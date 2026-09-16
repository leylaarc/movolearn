import Foundation

/// Persists lesson progress locally via UserDefaults.
/// Replace with a real database by swapping this implementation.
final class ProgressStore {
    static let shared = ProgressStore()

    private let defaults: UserDefaults
    private let storageKey = "com.movolearn.lessonCompletions"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let isoEncoder: JSONEncoder
    private let isoDecoder: JSONDecoder

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        isoEncoder = JSONEncoder()
        isoEncoder.dateEncodingStrategy = .iso8601
        isoDecoder = JSONDecoder()
        isoDecoder.dateDecodingStrategy = .iso8601
    }

    func recordCompletion(summary: ProgressSummary, lesson: Lesson) {
        var records = loadCompletions()
        records.append(LessonCompletionRecord(summary: summary, lesson: lesson))
        saveCompletions(records)
    }

    func loadCompletions() -> [LessonCompletionRecord] {
        guard let data = defaults.data(forKey: storageKey) else { return [] }
        if let records = try? isoDecoder.decode([LessonCompletionRecord].self, from: data) {
            return records
        }
        return (try? decoder.decode([LessonCompletionRecord].self, from: data)) ?? []
    }

    func replaceCompletions(_ records: [LessonCompletionRecord]) {
        saveCompletions(records)
    }

    func userProgress() -> UserProgress {
        UserProgress(completedLessons: loadCompletions())
    }

    func reset() {
        defaults.removeObject(forKey: storageKey)
    }

    private func saveCompletions(_ records: [LessonCompletionRecord]) {
        guard let data = try? isoEncoder.encode(records) else { return }
        defaults.set(data, forKey: storageKey)
    }
}
