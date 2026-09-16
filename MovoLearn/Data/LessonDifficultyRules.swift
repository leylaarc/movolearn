import Foundation

/// Flexible difficulty rules that adapt lesson content and selection to a child's profile.
enum LessonDifficultyRules {

    struct Profile {
        let readingQuestionRange: ClosedRange<Int>
        let mathQuestionRange: ClosedRange<Int>
        let vocabularyWordRange: ClosedRange<Int>
        let knowledgeFactRange: ClosedRange<Int>
        let passageSentenceRange: ClosedRange<Int>
        let estimatedMinutes: ClosedRange<Int>
        let maxAnswerChoices: Int
        let allowsRepetition: Bool
        let supportsInference: Bool
        let supportsMultiStepMath: Bool
    }

    static func profile(for level: ReadingLevel) -> Profile {
        switch level {
        case .beginner:
            return Profile(
                readingQuestionRange: 3...3,
                mathQuestionRange: 3...3,
                vocabularyWordRange: 2...2,
                knowledgeFactRange: 1...1,
                passageSentenceRange: 2...4,
                estimatedMinutes: 5...8,
                maxAnswerChoices: 3,
                allowsRepetition: true,
                supportsInference: false,
                supportsMultiStepMath: false
            )
        case .earlyReader:
            return Profile(
                readingQuestionRange: 3...4,
                mathQuestionRange: 3...4,
                vocabularyWordRange: 2...3,
                knowledgeFactRange: 1...2,
                passageSentenceRange: 4...6,
                estimatedMinutes: 8...12,
                maxAnswerChoices: 3,
                allowsRepetition: false,
                supportsInference: false,
                supportsMultiStepMath: false
            )
        case .growingReader:
            return Profile(
                readingQuestionRange: 4...5,
                mathQuestionRange: 4...5,
                vocabularyWordRange: 2...3,
                knowledgeFactRange: 1...2,
                passageSentenceRange: 6...10,
                estimatedMinutes: 10...15,
                maxAnswerChoices: 4,
                allowsRepetition: false,
                supportsInference: true,
                supportsMultiStepMath: true
            )
        case .confidentReader:
            return Profile(
                readingQuestionRange: 4...5,
                mathQuestionRange: 4...5,
                vocabularyWordRange: 3...3,
                knowledgeFactRange: 2...2,
                passageSentenceRange: 8...14,
                estimatedMinutes: 12...18,
                maxAnswerChoices: 4,
                allowsRepetition: false,
                supportsInference: true,
                supportsMultiStepMath: true
            )
        }
    }

    static func estimatedMinutes(for level: ReadingLevel) -> Int {
        let range = profile(for: level).estimatedMinutes
        return (range.lowerBound + range.upperBound) / 2
    }

    /// Score how well a lesson fits a child profile (higher is better).
    static func matchScore(lesson: Lesson, profile: ChildProfile) -> Int {
        var score = 0
        let ability = abilityProfile(for: profile)

        let readingDelta = abs(lesson.readingLevel.sortOrder - ability.readingLevel.sortOrder)
        score += max(0, 40 - readingDelta * 20)

        let mathDelta = abs(lesson.mathLevel.sortOrder - ability.mathLevel.sortOrder)
        if lesson.primarySubject == .math || lesson.category == .math || !lesson.mathChallenges.isEmpty {
            score += max(0, 40 - mathDelta * 20)
        } else {
            score += max(0, 10 - mathDelta * 5)
        }

        if ageMatches(lesson.ageTarget, ability.age) { score += 18 }
        if learningGoalMatches(lesson.learningGoal, ability.learningGoal) { score += 12 }
        if gradeMatches(lesson.gradeTarget, ability.grade) { score += 4 }
        if profile.favoriteTopics.contains(lesson.theme) { score += 15 }

        if lesson.isApprovedForChildDisplay { score += 25 }

        return score
    }

    static func gradeMatches(_ lessonGrade: String, _ childGrade: String) -> Bool {
        if lessonGrade == childGrade { return true }
        // Normalize catalog labels like "K-2" / "1-3" onto child grade names.
        let childTokens = gradeTokens(childGrade)
        let lessonTokens = gradeTokens(lessonGrade)
        return !childTokens.isDisjoint(with: lessonTokens)
    }

    /// Maps free-form grade strings onto comparable tokens.
    private static func gradeTokens(_ raw: String) -> Set<String> {
        let g = raw.lowercased()
        var tokens = Set<String>()
        if g.contains("pre") { tokens.insert("preK") }
        if g.contains("kind") || g == "k" || g.hasPrefix("k-") || g.contains("k-2") {
            tokens.formUnion(["preK", "K", "1"])
        }
        if g.contains("1st") || g.contains("first") || g.contains("1-") || g == "1" {
            tokens.formUnion(["K", "1", "2"])
        }
        if g.contains("2nd") || g.contains("second") || g.contains("2-3") || g == "2" {
            tokens.formUnion(["1", "2", "3"])
        }
        if g.contains("3rd") || g.contains("third") || g.contains("3-4") || g == "3" {
            tokens.formUnion(["2", "3"])
        }
        if g.contains("1-3") { tokens.formUnion(["1", "2", "3"]) }
        if g.contains("k-2") { tokens.formUnion(["preK", "K", "1", "2"]) }
        if tokens.isEmpty { tokens.insert(raw) }
        return tokens
    }

    static func ageMatches(_ ageTarget: String, _ age: Int) -> Bool {
        let parts = ageTarget.split(separator: "-").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard parts.count == 2, let low = parts.first, let high = parts.last else { return true }
        return (low...high).contains(age)
    }

    static func learningGoalMatches(_ lessonGoal: LearningGoal, _ childGoal: LearningGoal) -> Bool {
        if lessonGoal == childGoal || childGoal == .allAround { return true }
        if childGoal == .science && lessonGoal == .science { return true }
        if childGoal == .writing && (lessonGoal == .reading || lessonGoal == .vocabulary) { return true }
        return false
    }

    static func readingLevelsCompatible(lesson: ReadingLevel, profile: ReadingLevel) -> Bool {
        let delta = abs(lesson.sortOrder - profile.sortOrder)
        switch profile {
        case .beginner:
            return lesson == .beginner || lesson == .earlyReader
        case .earlyReader:
            return delta <= 1
        case .growingReader:
            return lesson != .beginner
        case .confidentReader:
            return lesson != .beginner
        }
    }
}
