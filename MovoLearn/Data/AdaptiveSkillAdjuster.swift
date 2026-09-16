import Foundation

/// Gently adjusts reading/math levels from demonstrated performance so difficulty
/// tracks the child — age sets the starting range; mastery moves within it.
enum AdaptiveSkillAdjuster {

    /// After a scored lesson, nudge profile levels when the child is clearly
    /// struggling or advancing. Stays within one step of the age-suggested band.
    @MainActor
    @discardableResult
    static func applyLessonOutcome(
        summary: ProgressSummary,
        to profile: inout ChildProfile
    ) -> [String] {
        guard summary.totalQuestions >= 3 else { return [] }

        var notes: [String] = []
        let ageSuggestedReading = LessonDifficultyRules.suggestedReadingLevel(forAge: profile.currentAge)
        let ageSuggestedMath = LessonDifficultyRules.suggestedMathLevel(forAge: profile.currentAge)

        if summary.accuracy < 0.45 {
            let lowered = profile.readingLevel.adjusting(by: -1)
            if lowered.sortOrder >= ageSuggestedReading.adjusting(by: -1).sortOrder,
               lowered != profile.readingLevel {
                profile.readingLevel = lowered
                notes.append("Reading eased to \(lowered.rawValue) after struggle")
            }
            let mathLowered = profile.mathLevel.adjusting(by: -1)
            if mathLowered.sortOrder >= ageSuggestedMath.adjusting(by: -1).sortOrder,
               mathLowered != profile.mathLevel {
                profile.mathLevel = mathLowered
                notes.append("Math eased to \(mathLowered.rawValue) after struggle")
            }
        } else if summary.accuracy >= 0.9, summary.totalQuestions >= 4 {
            let raised = profile.readingLevel.adjusting(by: 1)
            if raised.sortOrder <= ageSuggestedReading.adjusting(by: 1).sortOrder,
               raised != profile.readingLevel {
                profile.readingLevel = raised
                notes.append("Reading raised to \(raised.rawValue) after strong progress")
            }
            let mathRaised = profile.mathLevel.adjusting(by: 1)
            if mathRaised.sortOrder <= ageSuggestedMath.adjusting(by: 1).sortOrder,
               mathRaised != profile.mathLevel {
                profile.mathLevel = mathRaised
                notes.append("Math raised to \(mathRaised.rawValue) after strong progress")
            }
        }

        return notes
    }
}
