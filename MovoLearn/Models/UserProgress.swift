import Foundation

struct LessonCompletionRecord: Codable, Identifiable {
    let id: UUID
    let lessonId: UUID
    let lessonTitle: String
    let topic: Topic
    let correctAnswers: Int
    let incorrectAnswers: Int
    let totalQuestions: Int
    let accuracy: Double
    let skillsPracticed: [String]
    let completedAt: Date

    init(summary: ProgressSummary, lesson: Lesson) {
        self.id = UUID()
        self.lessonId = lesson.id
        self.lessonTitle = lesson.title
        self.topic = lesson.theme
        self.correctAnswers = summary.correctAnswers
        self.incorrectAnswers = summary.totalQuestions - summary.correctAnswers
        self.totalQuestions = summary.totalQuestions
        self.accuracy = summary.accuracy
        self.skillsPracticed = summary.skillsPracticed
        self.completedAt = summary.completedAt
    }
}

struct UserProgress: Codable {
    let completedLessons: [LessonCompletionRecord]

    var completedLessonCount: Int {
        completedLessons.count
    }

    var completedLessonTitles: [String] {
        completedLessons.map(\.lessonTitle)
    }

    var correctAnswers: Int {
        completedLessons.reduce(0) { $0 + $1.correctAnswers }
    }

    var incorrectAnswers: Int {
        completedLessons.reduce(0) { $0 + $1.incorrectAnswers }
    }

    var totalQuestions: Int {
        completedLessons.reduce(0) { $0 + $1.totalQuestions }
    }

    var accuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions)
    }

    var accuracyPercentage: Int {
        Int((accuracy * 100).rounded())
    }

    var topicsPracticed: [Topic] {
        var seen = Set<Topic>()
        return completedLessons.compactMap { record in
            guard seen.insert(record.topic).inserted else { return nil }
            return record.topic
        }
    }

    var skillsPracticed: [String] {
        var seen = Set<String>()
        return completedLessons.flatMap(\.skillsPracticed).filter { skill in
            seen.insert(skill).inserted
        }
    }

    var lastCompletedAt: Date? {
        completedLessons.map(\.completedAt).max()
    }

    var uniqueLessonCount: Int {
        Set(completedLessons.map(\.lessonId)).count
    }

    var latestRecord: LessonCompletionRecord? {
        completedLessons.max(by: { $0.completedAt < $1.completedAt })
    }

    var scoredQuestionCount: Int { totalQuestions }

    /// Completions in the last `days` calendar days, including today.
    func completions(inLastDays days: Int, now: Date = Date()) -> [LessonCompletionRecord] {
        guard let start = Calendar.current.date(byAdding: .day, value: -(days - 1), to: Calendar.current.startOfDay(for: now)) else {
            return []
        }
        return completedLessons.filter { $0.completedAt >= start }
    }

    static let empty = UserProgress(completedLessons: [])
}
