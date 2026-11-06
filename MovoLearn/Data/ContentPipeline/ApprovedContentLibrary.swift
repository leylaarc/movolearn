import Foundation

/// Pre-validated lessons available to the child-facing app.
/// Content is generated in advance (backend pipeline or offline factory), validated, then stored here.
/// Live sessions only select from approved lessons — never call AI for unvalidated drafts.
enum ApprovedContentLibrary {
    private static let cacheLock = NSLock()
    private static var cache: [Lesson]?
    private static var byID: [UUID: Lesson] = [:]
    private static var unavailableLog: [String] = []
    private static var isComplete = false
    private static var seededCells: Set<String> = []
    private static var jsonLessons: [Lesson]?
    private static var homePriority: HomePriority?
    /// Serializes the expensive seed so warmCache + first UI call never duplicate work.
    private static let buildQueue = DispatchQueue(label: "com.movolearn.approved-library.build")

    /// Bump when factory / curated packs change so the on-disk catalog is rebuilt.
    private static let contentRevision = "18"

    private struct HomePriority {
        let topics: [Topic]
        let readingLevel: ReadingLevel
        let mathLevel: MathLevel
    }

    private struct DiskEnvelope: Codable {
        let revision: String
        let lessons: [Lesson]
    }

    /// Remember which slice Home needs so a racing full-catalog build seeds that first.
    static func setHomePriority(
        topics: [Topic],
        readingLevel: ReadingLevel,
        mathLevel: MathLevel
    ) {
        cacheLock.lock()
        homePriority = HomePriority(
            topics: topics,
            readingLevel: readingLevel,
            mathLevel: mathLevel
        )
        cacheLock.unlock()
    }

    /// Loads standards + any on-disk catalog. Does **not** generate the full topic matrix.
    static func warmCache() {
        buildQueue.async {
            _ = MockCASEStandardsProvider.shared.loadIfNeeded()
            _ = loadDiskCacheIfNeeded()
        }
    }

    /// Non-blocking peek of the **complete** catalog — nil until the full matrix is built.
    static func cachedLessonsIfReady() -> [Lesson]? {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        guard isComplete else { return nil }
        return cache
    }

    static var isReady: Bool {
        cachedLessonsIfReady() != nil
    }

    static var isFullyBuilt: Bool {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return isComplete
    }

    /// Lesson lookup that never generates the remaining matrix.
    static func lesson(id: UUID) -> Lesson? {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return byID[id]
    }

    /// Seed only the child's current interests and levels so Home can appear immediately.
    @discardableResult
    static func ensureHomeSlice(
        topics: [Topic],
        readingLevel: ReadingLevel,
        mathLevel: MathLevel
    ) -> [Lesson] {
        if !topics.isEmpty {
            setHomePriority(topics: topics, readingLevel: readingLevel, mathLevel: mathLevel)
        }
        cacheLock.lock()
        let complete = isComplete
        let snapshot = cache
        let sliceReady = homeSliceIsPresentLocked(
            topics: topics,
            reading: readingLevel,
            math: mathLevel
        )
        cacheLock.unlock()
        if complete, let snapshot { return snapshot }
        if sliceReady, let snapshot { return snapshot }

        return buildQueue.sync {
            if loadDiskCacheIfNeeded() {
                return snapshotLocked()
            }
            seedHomeSliceIfNeeded()
            return snapshotLocked()
        }
    }

    /// Builds the library if needed. Prefer calling from a background queue;
    /// do not call from SwiftUI `body` — use `cachedLessonsIfReady()` instead.
    static func allApprovedLessons() -> [Lesson] {
        cacheLock.lock()
        if isComplete, let cache {
            cacheLock.unlock()
            return cache
        }
        cacheLock.unlock()
        return buildQueue.sync { buildIfNeeded() }
    }

    @discardableResult
    private static func buildIfNeeded() -> [Lesson] {
        if loadDiskCacheIfNeeded() {
            return snapshotLocked()
        }
        cacheLock.lock()
        if isComplete, let cache {
            cacheLock.unlock()
            return cache
        }
        cacheLock.unlock()

        seedHomeSliceIfNeeded()
        seedCells(
            topics: Array(Topic.allCases),
            readings: Array(ReadingLevel.allCases),
            maths: Array(MathLevel.allCases),
            categories: Array(LessonCategory.allCases)
        )
        publish(complete: true)
        persistDiskCacheInBackground()
        return snapshotLocked()
    }

    static func lessons(
        readingLevel: ReadingLevel,
        mathLevel: MathLevel,
        topics: [Topic] = [],
        category: LessonCategory? = nil,
        primarySubject: PrimarySubject? = nil
    ) -> [Lesson] {
        let pool = ensureHomeSlice(
            topics: topics,
            readingLevel: readingLevel,
            mathLevel: mathLevel
        )
        return pool.filter { lesson in
            let readingOK = abs(lesson.readingLevel.sortOrder - readingLevel.sortOrder) <= 0
                || (category == .math && abs(lesson.readingLevel.sortOrder - readingLevel.sortOrder) <= 1)
            let mathOK: Bool
            if lesson.primarySubject == .math || category == .math {
                mathOK = lesson.mathLevel == mathLevel
            } else if lesson.mathChallenges.isEmpty {
                mathOK = true
            } else {
                mathOK = abs(lesson.mathLevel.sortOrder - mathLevel.sortOrder) <= 1
            }
            let topicOK = topics.isEmpty || topics.contains(lesson.theme)
            let categoryOK = category.map { lesson.category == $0 } ?? true
            let subjectOK = primarySubject.map { lesson.primarySubject == $0 } ?? true
            return readingOK && mathOK && topicOK && categoryOK && subjectOK && lesson.isApprovedForChildDisplay
        }
    }

    /// Strict exact-level match preferred by the selector.
    static func exactMatches(
        readingLevel: ReadingLevel,
        mathLevel: MathLevel,
        topics: [Topic],
        category: LessonCategory
    ) -> [Lesson] {
        let pool = ensureHomeSlice(
            topics: topics,
            readingLevel: readingLevel,
            mathLevel: mathLevel
        )
        return pool.filter {
            $0.isApprovedForChildDisplay
                && $0.readingLevel == readingLevel
                && $0.mathLevel == mathLevel
                && $0.category == category
                && (topics.isEmpty || topics.contains($0.theme))
        }
    }

    static func invalidateCache() {
        cacheLock.lock()
        cache = nil
        byID = [:]
        isComplete = false
        seededCells = []
        jsonLessons = nil
        unavailableLog = []
        cacheLock.unlock()
        deleteDiskCache()
        LessonLoader.invalidateCache()
    }

    static func unavailableReasons() -> [String] {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return unavailableLog
    }

    // MARK: - Seeding

    private static func homeSliceIsPresentLocked(
        topics: [Topic],
        reading: ReadingLevel,
        math: MathLevel
    ) -> Bool {
        let sliceTopics = topics.isEmpty ? Array(Topic.allCases) : topics
        guard !sliceTopics.isEmpty else { return false }
        for topic in sliceTopics {
            for category in LessonCategory.allCases {
                let key = cellKey(topic: topic, category: category, reading: reading, math: math)
                if !seededCells.contains(key) { return false }
            }
        }
        return true
    }

    private static func seedHomeSliceIfNeeded() {
        let priority: HomePriority?
        cacheLock.lock()
        priority = homePriority
        cacheLock.unlock()

        let topics = priority?.topics ?? []
        let reading = priority?.readingLevel ?? .earlyReader
        let math = priority?.mathLevel ?? .developing
        let sliceTopics = topics.isEmpty ? Array(Topic.allCases) : topics

        seedCells(
            topics: sliceTopics,
            readings: [reading],
            maths: [math],
            categories: Array(LessonCategory.allCases)
        )
    }

    private static func seedCells(
        topics: [Topic],
        readings: [ReadingLevel],
        maths: [MathLevel],
        categories: [LessonCategory]
    ) {
        mergeJSONLessonsIfNeeded()

        var newly: [Lesson] = []
        var failures: [String] = []
        for topic in topics {
            for reading in readings {
                for math in maths {
                    for category in categories {
                        let key = cellKey(topic: topic, category: category, reading: reading, math: math)
                        cacheLock.lock()
                        let already = seededCells.contains(key)
                        if !already { seededCells.insert(key) }
                        cacheLock.unlock()
                        guard !already else { continue }

                        if let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                            topic: topic,
                            category: category,
                            readingLevel: reading,
                            mathLevel: math
                        ) {
                            newly.append(lesson)
                        } else if category == .story || category == .math {
                            failures.append(
                                "unavailable topic=\(topic.rawValue) category=\(category.rawValue) reading=\(reading.rawValue) math=\(math.rawValue)"
                            )
                        }
                    }
                }
            }
        }

        cacheLock.lock()
        for lesson in newly where lesson.contentApprovalStatus == .approved {
            byID[lesson.id] = lesson
        }
        if !failures.isEmpty {
            unavailableLog.append(contentsOf: failures)
        }
        cache = Array(byID.values).sorted { $0.title < $1.title }
        cacheLock.unlock()
    }

    private static func mergeJSONLessonsIfNeeded() {
        cacheLock.lock()
        if jsonLessons != nil {
            cacheLock.unlock()
            return
        }
        cacheLock.unlock()

        let loaded = loadApprovedJSONLessons()
        var blocked: [String] = []
        var accepted: [Lesson] = []
        for lesson in loaded where lesson.contentApprovalStatus == .approved {
            let coherence = LessonContentCoherenceValidator.validate(lesson)
            if coherence.passed {
                accepted.append(lesson)
            } else {
                blocked.append("blocked \"\(lesson.title)\": \(coherence.summary)")
            }
        }
        #if DEBUG
        blocked.prefix(8).forEach { print("🚫 Approved library \($0)") }
        #endif

        cacheLock.lock()
        jsonLessons = accepted
        for lesson in accepted {
            byID[lesson.id] = lesson
        }
        unavailableLog.append(contentsOf: blocked)
        cache = Array(byID.values).sorted { $0.title < $1.title }
        cacheLock.unlock()
    }

    private static func publish(complete: Bool) {
        cacheLock.lock()
        cache = Array(byID.values).sorted { $0.title < $1.title }
        isComplete = complete
        cacheLock.unlock()
    }

    private static func snapshotLocked() -> [Lesson] {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return cache ?? Array(byID.values).sorted { $0.title < $1.title }
    }

    private static func cellKey(
        topic: Topic,
        category: LessonCategory,
        reading: ReadingLevel,
        math: MathLevel
    ) -> String {
        "\(topic.rawValue)|\(category.rawValue)|\(reading.rawValue)|\(math.rawValue)"
    }

    // MARK: - Disk cache

    private static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    @discardableResult
    private static func loadDiskCacheIfNeeded() -> Bool {
        cacheLock.lock()
        if isComplete, cache != nil {
            cacheLock.unlock()
            return true
        }
        cacheLock.unlock()
        guard !isRunningTests, let url = diskURL(),
              let data = try? Data(contentsOf: url),
              let envelope = try? JSONDecoder().decode(DiskEnvelope.self, from: data),
              !envelope.lessons.isEmpty else {
            return false
        }
        if envelope.revision != contentRevision {
            deleteDiskCache()
            return false
        }

        cacheLock.lock()
        byID = Dictionary(uniqueKeysWithValues: envelope.lessons.map { ($0.id, $0) })
        cache = envelope.lessons.sorted { $0.title < $1.title }
        isComplete = true
        seededCells = Set(
            Topic.allCases.flatMap { topic in
                LessonCategory.allCases.flatMap { category in
                    ReadingLevel.allCases.flatMap { reading in
                        MathLevel.allCases.map { math in
                            cellKey(topic: topic, category: category, reading: reading, math: math)
                        }
                    }
                }
            }
        )
        cacheLock.unlock()
        return true
    }

    private static func persistDiskCacheInBackground() {
        guard !isRunningTests else { return }
        let lessons = snapshotLocked()
        let revision = contentRevision
        DispatchQueue.global(qos: .utility).async {
            guard let url = diskURL() else { return }
            let folder = url.deletingLastPathComponent()
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            let envelope = DiskEnvelope(revision: revision, lessons: lessons)
            guard let data = try? JSONEncoder().encode(envelope) else { return }
            try? data.write(to: url, options: .atomic)
        }
    }

    private static func deleteDiskCache() {
        guard let url = diskURL() else { return }
        try? FileManager.default.removeItem(at: url)
    }

    private static func diskURL() -> URL? {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
            .appendingPathComponent("MovoLearn", isDirectory: true)
            .appendingPathComponent("approved-library-cache.json")
    }

    private static func loadApprovedJSONLessons() -> [Lesson] {
        let names = ["approved-lessons", "approved_lessons"]
        var loaded: [Lesson] = []
        for name in names {
            let urls = [
                Bundle.main.url(forResource: name, withExtension: "json"),
                Bundle.main.url(forResource: name, withExtension: "json", subdirectory: "ApprovedLessons")
            ].compactMap { $0 }
            for url in urls {
                guard let data = try? Data(contentsOf: url) else { continue }
                if let batch = try? JSONDecoder().decode([Lesson].self, from: data) {
                    loaded.append(contentsOf: batch.filter { $0.contentApprovalStatus == .approved })
                } else if let adapted = PipelineLessonAdapter.lesson(from: data) {
                    loaded.append(adapted)
                } else if let one = try? LessonLoader.decodeLesson(from: data),
                          one.contentApprovalStatus == .approved {
                    loaded.append(one)
                }
            }
        }

        // Individual files in ApprovedLessons folder via manifest.
        if let manifestURL = Bundle.main.url(forResource: "approved-manifest", withExtension: "json", subdirectory: "ApprovedLessons")
            ?? Bundle.main.url(forResource: "approved-manifest", withExtension: "json"),
           let data = try? Data(contentsOf: manifestURL),
           let manifest = try? JSONDecoder().decode(ApprovedManifest.self, from: data) {
            for file in manifest.approvedFiles {
                let base = (file as NSString).deletingPathExtension
                let ext = (file as NSString).pathExtension.isEmpty ? "json" : (file as NSString).pathExtension
                let url = Bundle.main.url(forResource: base, withExtension: ext, subdirectory: "ApprovedLessons")
                    ?? Bundle.main.url(forResource: base, withExtension: ext)
                guard let url, let fileData = try? Data(contentsOf: url) else { continue }
                if let adapted = PipelineLessonAdapter.lesson(from: fileData) {
                    loaded.append(adapted)
                } else if let lesson = try? LessonLoader.decodeLesson(from: fileData),
                          lesson.contentApprovalStatus == .approved {
                    loaded.append(lesson)
                }
            }
        }
        return loaded
    }
}

private struct ApprovedManifest: Codable {
    let approvedFiles: [String]
    let providerNote: String?
}
