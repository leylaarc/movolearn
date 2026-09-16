import Foundation

/// Approval state for lessons in the content library.
/// Only `.approved` lessons may appear in the child-facing app.
enum ContentApprovalStatus: String, Codable, Equatable {
    case approved
    case pendingValidation
    case unavailable
    /// Pre-existing bundled content not yet run through the full pipeline.
    case legacyBundled
}

/// Anonymous context sent to backend / providers — never includes PII.
struct PrivacySafeLearnerContext: Codable, Equatable {
    /// Pseudonymous internal learner id (UUID string). Not a real-world identifier.
    let learnerId: String
    let ageRange: String
    let grade: String
    let readingLevel: ReadingLevel
    let mathLevel: MathLevel
    let interestTopics: [String]
    let preferredActivityTypes: [String]
    let recentlyMasteredSkillIds: [String]
    let skillsNeedingPracticeIds: [String]

    static func from(
        profile: ChildProfile,
        learningState: ChildLearningState? = nil
    ) -> PrivacySafeLearnerContext {
        let age = profile.currentAge
        let mastered = learningState?.skillProgress
            .filter { $0.status == .mastered }
            .map(\.marbleTopicId) ?? []
        let practice = learningState?.skillProgress
            .filter { $0.status == .needsReview || $0.incorrectAttempts > $0.correctAttempts }
            .map(\.marbleTopicId) ?? []
        return PrivacySafeLearnerContext(
            learnerId: profile.id.uuidString,
            ageRange: ageRangeLabel(for: age),
            grade: AgeGradeLearningStandards.curriculumKey(forAge: age),
            readingLevel: profile.readingLevel,
            mathLevel: profile.mathLevel,
            interestTopics: profile.favoriteTopics.map(\.rawValue),
            preferredActivityTypes: profile.preferredActivityTypes.map(\.rawValue),
            recentlyMasteredSkillIds: Array(mastered.prefix(8)),
            skillsNeedingPracticeIds: Array(practice.prefix(8))
        )
    }

    private static func ageRangeLabel(for age: Int) -> String {
        switch age {
        case ...5: return "4-5"
        case 6: return "6-6"
        case 7: return "7-7"
        case 8: return "8-8"
        default: return "9-10"
        }
    }
}

/// Structured request for backend AI lesson generation (never called from live child sessions).
struct LessonGenerationRequest: Codable, Equatable {
    let learnerContext: PrivacySafeLearnerContext
    let learningObjective: String
    let standardSkillId: String
    let prerequisiteSkillIds: [String]
    let activityType: String
    let requiredLearningOutcome: String
    let subject: PrimarySubject
}

/// Result of a reading-level measurement provider (Lexile or mock readability).
struct ReadingLevelMeasurement: Equatable {
    let providerName: String
    let isLicensedLexile: Bool
    let intendedBand: String
    let measuredEstimate: Int?
    let measuredBand: String
    let passesIntendedRange: Bool
    let notes: [String]
}

/// A standards-aligned skill (CASE-shaped when from CASE providers).
struct EducationalSkill: Identifiable, Codable, Equatable {
    let id: String
    let fullStatement: String
    let humanCodingScheme: String
    let subject: String
    let educationLevels: [String]
    let skillType: String
    let prerequisiteIds: [String]
    let relatedIds: [String]
}

// MARK: - Provider protocols

protocol EducationalStandardsProvider {
    var providerName: String { get }
    var isLiveCASEIntegration: Bool { get }
    func loadIfNeeded() -> Bool
    func skills(subject: String?, grade: String?) -> [EducationalSkill]
    func skill(id: String) -> EducationalSkill?
    func prerequisites(for skillId: String) -> [EducationalSkill]
    func relatedSkills(for skillId: String) -> [EducationalSkill]
    func recommendSkill(
        subject: String,
        grade: String,
        readingLevel: ReadingLevel?,
        mathLevel: MathLevel?,
        masteredIds: [String],
        practiceIds: [String]
    ) -> EducationalSkill?
}

protocol ReadingLevelMeasurementProvider {
    var providerName: String { get }
    var isLicensedLexile: Bool { get }
    func measure(
        passage: String,
        intendedReadingLevel: ReadingLevel
    ) -> ReadingLevelMeasurement
}

protocol MathProgressionProvider {
    var providerName: String { get }
    /// True only when a licensed MetaMetrics Quantile integration is configured.
    var isLicensedQuantile: Bool { get }
    func orderedSkills(for mathLevel: MathLevel, grade: String) -> [EducationalSkill]
    func nextSkill(
        after skillId: String?,
        mathLevel: MathLevel,
        grade: String,
        masteredIds: [String]
    ) -> EducationalSkill?
    func prerequisitesReady(skillId: String, masteredIds: [String]) -> Bool
}

/// Backend AI generation — iOS must never call live AI APIs for child-facing text.
protocol AILessonGenerationProvider {
    var providerName: String { get }
    var runsOnBackendOnly: Bool { get }
    /// Generates a structured lesson draft. Live implementations belong in `backend/content-pipeline`.
    func generateDraft(request: LessonGenerationRequest) throws -> Lesson
}

protocol ContentValidationProvider {
    func validateForChildDisplay(_ lesson: Lesson, profile: ChildProfile) -> AutomatedContentQualityGate.Result
}
