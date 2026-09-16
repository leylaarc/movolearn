import Foundation

/// Combined academic ability used to adapt tone/scaffolding at launch.
/// Age sets the curriculum ceiling (sentence length, math range, inference).
/// Parent-selected reading and math chips pick the catalog pack and may go easier,
/// but cannot make a younger child work above their age curriculum.
struct LearnerAbilityProfile {
    let age: Int
    let grade: String
    let readingLevel: ReadingLevel
    let mathLevel: MathLevel
    let learningGoal: LearningGoal
    /// Difficulty rules for the child's reading level.
    let rules: LessonDifficultyRules.Profile
    /// True when instructions and feedback should use more scaffolding.
    let needsScaffolding: Bool
    /// True when passages/questions should favor shorter, concrete language.
    let prefersConcreteLanguage: Bool
    /// True when inference / multi-step items are allowed.
    let allowsAdvancedReasoning: Bool
    /// How much to bump or drop difficulty from demonstrated mastery (−1…+1).
    let skillDelta: Int
}

extension LessonDifficultyRules {

    /// Suggests a starting reading level from age alone (parent may override).
    static func suggestedReadingLevel(forAge age: Int) -> ReadingLevel {
        switch age {
        case ...5: return .beginner
        case 6: return .earlyReader
        case 7: return .growingReader
        default: return .confidentReader
        }
    }

    static func suggestedMathLevel(forAge age: Int) -> MathLevel {
        switch age {
        case ...5: return .emerging
        case 6: return .developing
        case 7: return .secure
        default: return .advancing
        }
    }

    /// Age used when authoring/approving a pack so the quality gate matches that band's curriculum.
    /// Beginner/Early packs are gated at the ages 5–6 band so existing stories can seed; session
    /// adaptation still tightens them for a 4–5 year old.
    static func typicalAge(
        for reading: ReadingLevel,
        math: MathLevel,
        category: LessonCategory
    ) -> Int {
        if category == .math {
            switch math {
            case .emerging, .developing: return 6
            case .secure: return 7
            case .advancing: return 8
            }
        }
        switch reading {
        case .beginner, .earlyReader: return 6
        case .growingReader: return 7
        case .confidentReader: return 8
        }
    }

    /// Maps math level onto reading-level packaging used by some generators for wording only.
    static func readingLevel(forMath mathLevel: MathLevel) -> ReadingLevel {
        switch mathLevel {
        case .emerging: return .beginner
        case .developing: return .earlyReader
        case .secure: return .growingReader
        case .advancing: return .confidentReader
        }
    }

    /// Builds an ability profile from the child + optional mastery state.
    /// Age owns the curriculum band. Parent reading/math chips are kept for catalog
    /// matching and may go easier; session shaping still uses the age ceiling.
    static func abilityProfile(
        for child: ChildProfile,
        learningState: ChildLearningState? = nil
    ) -> LearnerAbilityProfile {
        let age = child.currentAge
        var effectiveReading = child.readingLevel
        var effectiveMath = child.mathLevel

        let skillDelta = masterySkillDelta(learningState: learningState)
    /// Mastery may nudge within the selected band; session shaping still uses the age curriculum ceiling.
        effectiveReading = effectiveReading.adjusting(by: skillDelta)
        effectiveMath = effectiveMath.adjusting(by: skillDelta)

        let rules = profile(for: effectiveReading)
        let standards = AgeGradeLearningStandards.expectations(
            age: age,
            grade: AgeGradeLearningStandards.curriculumKey(forAge: age),
            readingLevel: effectiveReading,
            mathLevel: effectiveMath
        )
        let scaffolding = age <= 6
            || effectiveReading == .beginner
            || effectiveReading == .earlyReader
            || skillDelta < 0
            || standards.visualSupportLevel == .high

        return LearnerAbilityProfile(
            age: age,
            grade: AgeGradeLearningStandards.curriculumKey(forAge: age),
            readingLevel: effectiveReading,
            mathLevel: effectiveMath,
            learningGoal: child.learningGoal,
            rules: rules,
            needsScaffolding: scaffolding,
            prefersConcreteLanguage: standards.preferConcreteLanguage || age <= 6 || effectiveReading == .beginner,
            allowsAdvancedReasoning: standards.allowInference
                && rules.supportsInference
                && effectiveReading.sortOrder >= ReadingLevel.growingReader.sortOrder
                && skillDelta >= 0,
            skillDelta: skillDelta
        )
    }

    /// −1 if struggling, +1 if advancing quickly, otherwise 0.
    private static func masterySkillDelta(learningState: ChildLearningState?) -> Int {
        guard let learningState else { return 0 }
        let active = learningState.skillProgress.filter { $0.status != .notStarted }
        guard !active.isEmpty else { return 0 }

        let reviewCount = active.filter { $0.status == .needsReview }.count
        let masteredCount = active.filter { $0.status == .mastered }.count
        let lowMastery = active.filter { $0.masteryScore < 0.4 }.count

        if reviewCount >= 2 || lowMastery >= 2 { return -1 }
        if masteredCount >= 3, active.allSatisfy({ $0.masteryScore >= 0.7 || $0.status == .mastered }) {
            return 1
        }
        return 0
    }

    /// Stricter compatibility when the catalog has on-level alternatives.
    static func readingLevelsCompatibleStrict(lesson: ReadingLevel, profile: ReadingLevel) -> Bool {
        abs(lesson.sortOrder - profile.sortOrder) <= 1
    }

    static func mathLevelsCompatible(lesson: MathLevel, profile: MathLevel) -> Bool {
        abs(lesson.sortOrder - profile.sortOrder) <= 1
    }

    static func mathLevelsCompatibleStrict(lesson: MathLevel, profile: MathLevel) -> Bool {
        lesson == profile
    }
}

extension ReadingLevel {
    func adjusting(by delta: Int) -> ReadingLevel {
        let ordered = ReadingLevel.allCases.sorted { $0.sortOrder < $1.sortOrder }
        let index = min(max(0, sortOrder + delta), ordered.count - 1)
        return ordered[index]
    }
}

extension MathLevel {
    func adjusting(by delta: Int) -> MathLevel {
        let ordered = MathLevel.allCases.sorted { $0.sortOrder < $1.sortOrder }
        let index = min(max(0, sortOrder + delta), ordered.count - 1)
        return ordered[index]
    }
}
