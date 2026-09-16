import Foundation

/// Explicit curriculum mapping for bundled lessons.
/// Do not invent mappings from vague keyword matches at runtime.
struct LessonCurriculumMapping: Codable, Equatable {
    let lessonId: UUID?
    let title: String?
    let theme: String?
    let primaryTopicId: String?
    let supportingTopicIds: [String]
    let prerequisiteTopicIds: [String]
    let subject: String?
    let domain: String?
    let difficulty: String?
    let recommendedAgeRange: String?
    let learningObjectives: [String]
    let evidenceTargets: [String]
}

enum LessonCurriculumMapper {
    private static var cached: [LessonCurriculumMapping]?
    private static var byLessonID: [UUID: LessonCurriculumMapping] = [:]
    private static var byTitleTheme: [String: LessonCurriculumMapping] = [:]
    private static let lock = NSLock()
    #if DEBUG
    private static var didLogUnmapped = false
    #endif

    static func loadMappings(bundle: Bundle = .main) -> [LessonCurriculumMapping] {
        lock.lock()
        defer { lock.unlock() }
        if let cached { return cached }
        guard let url = bundle.url(forResource: "lesson-curriculum-map", withExtension: "json")
            ?? bundle.url(forResource: "lesson-curriculum-map", withExtension: "json", subdirectory: "Data")
            ?? bundle.url(forResource: "lesson-curriculum-map", withExtension: "json", subdirectory: "Marble") else {
            #if DEBUG
            print("[MovoLearn] lesson-curriculum-map.json not found")
            #endif
            cached = []
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([LessonCurriculumMapping].self, from: data)
            cached = decoded
            index(decoded)
            return decoded
        } catch {
            #if DEBUG
            print("[MovoLearn] Failed to decode lesson-curriculum-map.json: \(error)")
            #endif
            cached = []
            return []
        }
    }

    private static func index(_ mappings: [LessonCurriculumMapping]) {
        byLessonID.removeAll(keepingCapacity: true)
        byTitleTheme.removeAll(keepingCapacity: true)
        for mapping in mappings {
            if let id = mapping.lessonId {
                byLessonID[id] = mapping
            }
            if let title = mapping.title {
                let theme = mapping.theme?.lowercased() ?? ""
                byTitleTheme[title.lowercased() + "|" + theme] = mapping
            }
        }
    }

    static func mapping(for lesson: Lesson) -> LessonCurriculumMapping? {
        _ = loadMappings()
        lock.lock()
        defer { lock.unlock() }
        if let hit = byLessonID[lesson.id] {
            return hit
        }
        let titled = lesson.title.lowercased()
        if let hit = byTitleTheme[titled + "|" + lesson.theme.rawValue.lowercased()] {
            return hit
        }
        return byTitleTheme[titled + "|"]
    }

    static func apply(to lesson: inout Lesson) {
        guard let map = mapping(for: lesson) else { return }
        lesson.primaryTopicId = map.primaryTopicId
        lesson.supportingTopicIds = map.supportingTopicIds
        lesson.prerequisiteTopicIds = map.prerequisiteTopicIds
        lesson.curriculumSubject = map.subject
        lesson.curriculumDomain = map.domain
        lesson.curriculumDifficulty = map.difficulty
        lesson.recommendedAgeRange = map.recommendedAgeRange ?? lesson.ageTarget
        lesson.learningObjectives = map.learningObjectives
        lesson.evidenceTargets = map.evidenceTargets
        if let mappedSubject = PrimarySubject.fromCurriculumSubject(map.subject) {
            lesson.primarySubject = mappedSubject
        }
    }

    static func applyAll(to lessons: [Lesson]) -> [Lesson] {
        let mapped = lessons.map { lesson -> Lesson in
            var copy = lesson
            apply(to: &copy)
            return copy
        }
        #if DEBUG
        if !didLogUnmapped {
            didLogUnmapped = true
            let n = unmappedLessons(in: lessons).count
            if n > 0 {
                print("[MovoLearn] \(n) lessons have no curriculum map (generated catalog is expected).")
            }
        }
        #endif
        return mapped
    }

    static func unmappedLessons(in lessons: [Lesson]) -> [Lesson] {
        lessons.filter { mapping(for: $0) == nil }
    }
}
