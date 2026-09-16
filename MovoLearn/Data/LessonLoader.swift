import Foundation

enum LessonLoaderError: Error, LocalizedError {
    case fileNotFound(String)
    case decodingFailed(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "Lesson file not found: \(name)"
        case .decodingFailed(let underlying):
            return "Failed to decode lesson: \(underlying.localizedDescription)"
        }
    }
}

struct LessonLoader {
    private static let decoder = JSONDecoder()
    private static var cache: [UUID: Lesson] = [:]
    private static var allCache: [Lesson]?
    private static let cacheLock = NSLock()

    /// Clears in-memory lesson caches (e.g. after academic profile changes).
    static func invalidateCache() {
        cacheLock.lock()
        cache.removeAll()
        allCache = nil
        cacheLock.unlock()
    }

    /// Pre-load standards and any on-disk catalog. Does not generate the full lesson matrix.
    static func warmCache() {
        DispatchQueue.global(qos: .userInitiated).async {
            _ = MarbleCurriculumService.shared.loadIfNeeded()
            _ = MockCASEStandardsProvider.shared.loadIfNeeded()
            ApprovedContentLibrary.warmCache()
            if ApprovedContentLibrary.isFullyBuilt {
                _ = allLessons()
            }
        }
    }

    /// Seed only the child's current interests/levels so Home can render without the full catalog.
    @discardableResult
    static func prepareHomeCatalog(
        topics: [Topic],
        readingLevel: ReadingLevel,
        mathLevel: MathLevel
    ) -> [Lesson] {
        let approved = ApprovedContentLibrary.ensureHomeSlice(
            topics: topics,
            readingLevel: readingLevel,
            mathLevel: mathLevel
        )
        return install(approved, markComplete: false)
    }

    /// Non-blocking peek of the **complete** catalog — nil until the full matrix is built.
    static func cachedAllLessonsIfReady() -> [Lesson]? {
        guard ApprovedContentLibrary.isFullyBuilt else { return nil }
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return allCache
    }

    /// Child-facing catalog: approved pipeline JSON + Swift-seeded `ApprovedContentLibrary`.
    ///
    /// Legacy `BundledLessons` / `Data/Lessons/*.json` are **not** in this browse list
    /// (Swift curated bank is source of truth). Use `lesson(id:)` to resolve retired
    /// IDs for resume; `ContentView` / `ContentLibrarySelector` swap to an approved replacement.
    /// Prefer calling off the main thread on first launch — seeding is expensive.
    static func allLessons() -> [Lesson] {
        if ApprovedContentLibrary.isFullyBuilt {
            cacheLock.lock()
            if let cached = allCache {
                cacheLock.unlock()
                return cached
            }
            cacheLock.unlock()
        }

        var lessons: [Lesson] = []
        var seenIDs = Set<UUID>()
        for lesson in ApprovedContentLibrary.allApprovedLessons() {
            guard seenIDs.insert(lesson.id).inserted else { continue }
            lessons.append(lesson)
        }

        return install(lessons, markComplete: true)
    }

    /// Load a lesson by UUID (approved catalog, then retired legacy for resume continuity).
    static func lesson(id: UUID) -> Lesson? {
        cacheLock.lock()
        if let cached = cache[id] {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()
        if let approved = ApprovedContentLibrary.lesson(id: id) {
            cacheLock.lock()
            cache[id] = approved
            cacheLock.unlock()
            return approved
        }
        if ApprovedContentLibrary.isFullyBuilt,
           let approved = allLessons().first(where: { $0.id == id }) {
            return approved
        }
        if let legacy = retiredLegacyLesson(id: id) {
            cacheLock.lock()
            cache[id] = legacy
            cacheLock.unlock()
            return legacy
        }
        return nil
    }

    @discardableResult
    private static func install(_ lessons: [Lesson], markComplete: Bool) -> [Lesson] {
        let mapped = LessonCurriculumMapper.applyAll(to: lessons)
        cacheLock.lock()
        for lesson in mapped {
            cache[lesson.id] = lesson
        }
        if markComplete {
            allCache = mapped
        } else {
            var merged = Dictionary(uniqueKeysWithValues: (allCache ?? []).map { ($0.id, $0) })
            for lesson in mapped {
                merged[lesson.id] = lesson
            }
            allCache = Array(merged.values)
        }
        cacheLock.unlock()
        return mapped
    }

    /// Retired catalog kept only for progress resume / tests — not for Home browse.
    private static func retiredLegacyLesson(id: UUID) -> Lesson? {
        if let bundled = BundledLessons.all.first(where: { $0.id == id }) {
            return bundled
        }
        return loadJSONLessons().first { $0.id == id }
    }

    /// All lessons matching favorite topics, preserving topic order.
    static func allLessons(for topics: [Topic]) -> [Lesson] {
        let all = allLessons()
        var seen = Set<UUID>()
        var result: [Lesson] = []
        for topic in topics {
            for lesson in all where lesson.theme == topic && seen.insert(lesson.id).inserted {
                result.append(lesson)
            }
        }
        return result
    }

    /// First lesson for topics (legacy helper).
    static func firstLesson(for topics: [Topic]) -> Lesson? {
        DailyLessonSelector.selectLesson(
            context: .init(
                profile: ChildProfile(favoriteTopics: topics),
                completedLessonIDs: [],
                recentLessonTypes: [],
                lastLessonID: nil,
                lastTopic: nil
            )
        )
    }

    /// Decode a single lesson from JSON data (for backend or AI-generated content).
    /// Runs `QuestionQualityValidator` in DEBUG to catch low-quality distractors early.
    static func decodeLesson(from data: Data) throws -> Lesson {
        do {
            let lesson = try decoder.decode(Lesson.self, from: data)
            // Re-log any inferred response types with full lesson context (legacy/external only).
            for question in lesson.questions + lesson.mathChallenges where question.responseTypeWasInferred {
                #if DEBUG
                print("""
                ⚠️ responseType inference used
                  lessonID: \(lesson.id)
                  lessonTitle: \(lesson.title)
                  questionID: \(question.id)
                  prompt: \(question.prompt)
                  inferred: \(question.responseType.rawValue)
                """)
                #endif
            }
            let schemaIssues = QuestionQualityValidator.validateLessonSchema(lesson)
            #if DEBUG
            if !schemaIssues.isEmpty {
                print("Lesson schema/quality warnings for \(lesson.title):\n\(schemaIssues.joined(separator: "\n"))")
            }
            #endif
            // Surface hard schema failures for missing required interaction data.
            let hardFailures = schemaIssues.filter {
                $0.contains("without pairs")
                    || $0.contains("without items")
                    || $0.contains("without choices")
                    || $0.contains("Unknown")
            }
            let proseIssues = ChildFacingProseQualityValidator.validateLessonProse(lesson)
            let proseFailures = proseIssues.issues.map(\.description)
            if !hardFailures.isEmpty {
                throw LessonLoaderError.decodingFailed(
                    underlying: NSError(
                        domain: "MovoLearn.LessonSchema",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: hardFailures.joined(separator: "; ")]
                    )
                )
            }
            if !proseFailures.isEmpty {
                throw LessonLoaderError.decodingFailed(
                    underlying: NSError(
                        domain: "MovoLearn.LessonProse",
                        code: 2,
                        userInfo: [NSLocalizedDescriptionKey: proseFailures.joined(separator: "; ")]
                    )
                )
            }
            return lesson
        } catch let error as LessonLoaderError {
            throw error
        } catch {
            throw LessonLoaderError.decodingFailed(underlying: error)
        }
    }

    /// Decode an array of lessons from JSON data.
    static func decodeLessons(from data: Data) throws -> [Lesson] {
        do {
            return try decoder.decode([Lesson].self, from: data)
        } catch {
            throw LessonLoaderError.decodingFailed(underlying: error)
        }
    }

    static var fallbackLesson: Lesson? {
        ApprovedContentLibrary.allApprovedLessons().first
            ?? BundledLessons.all.first
    }

    // MARK: - Legacy JSON (retired from browse catalog)

    private static let jsonResourceNames = ["sharks", "horses", "space", "dinosaurs"]

    /// Theme sample JSON under `Data/Lessons/` — retired; used only via `lesson(id:)`.
    private static func loadJSONLessons() -> [Lesson] {
        var lessons: [Lesson] = []

        for name in jsonResourceNames {
            guard let url = bundleURL(for: name),
                  let data = try? Data(contentsOf: url) else { continue }
            if let lesson = try? decodeLesson(from: data) {
                lessons.append(lesson)
            } else if let batch = try? decodeLessons(from: data) {
                lessons.append(contentsOf: batch)
            }
        }

        if let url = bundleURL(for: "lessons"),
           let data = try? Data(contentsOf: url),
           let batch = try? decodeLessons(from: data) {
            lessons.append(contentsOf: batch)
        }

        return lessons
    }

    private static func bundleURL(for resourceName: String) -> URL? {
        Bundle.main.url(forResource: resourceName, withExtension: "json", subdirectory: "Lessons")
            ?? Bundle.main.url(forResource: resourceName, withExtension: "json")
    }
}
