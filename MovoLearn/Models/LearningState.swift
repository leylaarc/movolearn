import Foundation

enum SkillStatus: String, Codable, CaseIterable, Identifiable {
    case notStarted
    case introduced
    case practicing
    case developing
    case mastered
    case needsReview

    var id: String { rawValue }

    var childFriendlyLabel: String {
        switch self {
        case .notStarted: return "Not started yet"
        case .introduced: return "Just getting started"
        case .practicing: return "Practicing"
        case .developing: return "Growing stronger"
        case .mastered: return "Feeling confident"
        case .needsReview: return "Ready for a refresh"
        }
    }

    /// Direct labels for parents — not softened kid copy.
    var parentFriendlyLabel: String {
        switch self {
        case .notStarted: return "Not started"
        case .introduced: return "Introduced"
        case .practicing: return "Practicing"
        case .developing: return "Developing"
        case .mastered: return "Secure"
        case .needsReview: return "Needs review"
        }
    }
}

struct SkillEvidenceRecord: Codable, Identifiable, Equatable {
    let id: UUID
    let timestamp: Date
    let activityType: String
    let wasCorrect: Bool
    let usedHint: Bool
    let wasIndependent: Bool
    let responseTimeMs: Int?
    let lessonId: UUID?
    let questionFormat: String?

    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        activityType: String,
        wasCorrect: Bool,
        usedHint: Bool,
        wasIndependent: Bool,
        responseTimeMs: Int? = nil,
        lessonId: UUID? = nil,
        questionFormat: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.activityType = activityType
        self.wasCorrect = wasCorrect
        self.usedHint = usedHint
        self.wasIndependent = wasIndependent
        self.responseTimeMs = responseTimeMs
        self.lessonId = lessonId
        self.questionFormat = questionFormat
    }
}

struct ChildSkillProgress: Codable, Identifiable, Equatable {
    var id: UUID
    var childProfileId: UUID
    var marbleTopicId: String
    var status: SkillStatus
    var masteryScore: Double
    var confidenceScore: Double
    var attemptCount: Int
    var correctAttempts: Int
    var independentCorrectAttempts: Int
    var incorrectAttempts: Int
    var hintCount: Int
    var lastAttemptedAt: Date?
    var lastMasteredAt: Date?
    var nextReviewAt: Date?
    var recentResponseTimeMs: Int?
    var evidenceRecords: [SkillEvidenceRecord]
    var sourceLessonIds: [UUID]

    init(
        id: UUID = UUID(),
        childProfileId: UUID,
        marbleTopicId: String,
        status: SkillStatus = .notStarted,
        masteryScore: Double = 0,
        confidenceScore: Double = 0,
        attemptCount: Int = 0,
        correctAttempts: Int = 0,
        independentCorrectAttempts: Int = 0,
        incorrectAttempts: Int = 0,
        hintCount: Int = 0,
        lastAttemptedAt: Date? = nil,
        lastMasteredAt: Date? = nil,
        nextReviewAt: Date? = nil,
        recentResponseTimeMs: Int? = nil,
        evidenceRecords: [SkillEvidenceRecord] = [],
        sourceLessonIds: [UUID] = []
    ) {
        self.id = id
        self.childProfileId = childProfileId
        self.marbleTopicId = marbleTopicId
        self.status = status
        self.masteryScore = masteryScore
        self.confidenceScore = confidenceScore
        self.attemptCount = attemptCount
        self.correctAttempts = correctAttempts
        self.independentCorrectAttempts = independentCorrectAttempts
        self.incorrectAttempts = incorrectAttempts
        self.hintCount = hintCount
        self.lastAttemptedAt = lastAttemptedAt
        self.lastMasteredAt = lastMasteredAt
        self.nextReviewAt = nextReviewAt
        self.recentResponseTimeMs = recentResponseTimeMs
        self.evidenceRecords = evidenceRecords
        self.sourceLessonIds = sourceLessonIds
    }

    var accuracy: Double {
        guard attemptCount > 0 else { return 0 }
        return Double(correctAttempts) / Double(attemptCount)
    }
}

enum LearningEventType: String, Codable, CaseIterable {
    case lessonStarted
    case lessonCompleted
    case questionAnswered
    case hintRequested
    case skillDemonstrated
    case skillReviewed
    case skillMastered
    case skillRegressed
    case interestSelected
    case profileUpdated
}

struct LearningEvent: Codable, Identifiable, Equatable {
    let id: UUID
    let childId: UUID
    let timestamp: Date
    let type: LearningEventType
    let lessonId: UUID?
    let marbleTopicId: String?
    let activityType: String?
    let result: String?
    let hintUsed: Bool?
    let responseTimeMs: Int?
    /// Non-PII metadata only (no child names).
    let metadata: [String: String]

    init(
        id: UUID = UUID(),
        childId: UUID,
        timestamp: Date = Date(),
        type: LearningEventType,
        lessonId: UUID? = nil,
        marbleTopicId: String? = nil,
        activityType: String? = nil,
        result: String? = nil,
        hintUsed: Bool? = nil,
        responseTimeMs: Int? = nil,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.childId = childId
        self.timestamp = timestamp
        self.type = type
        self.lessonId = lessonId
        self.marbleTopicId = marbleTopicId
        self.activityType = activityType
        self.result = result
        self.hintUsed = hintUsed
        self.responseTimeMs = responseTimeMs
        self.metadata = metadata
    }
}

/// Snapshot of learning state for one child. UI should read from this, not raw events.
struct ChildLearningState: Codable, Equatable {
    var childProfileId: UUID
    var skillProgress: [ChildSkillProgress]
    var events: [LearningEvent]
    var updatedAt: Date

    static func empty(childId: UUID) -> ChildLearningState {
        ChildLearningState(
            childProfileId: childId,
            skillProgress: [],
            events: [],
            updatedAt: Date()
        )
    }

    func progress(for topicId: String) -> ChildSkillProgress? {
        skillProgress.first { $0.marbleTopicId == topicId }
    }
}
