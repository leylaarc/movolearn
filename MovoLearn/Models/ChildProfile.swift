import Foundation

enum ReadingLevel: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case earlyReader = "Early Reader"
    case growingReader = "Growing Reader"
    case confidentReader = "Confident Reader"

    var id: String { rawValue }

    var sortOrder: Int {
        switch self {
        case .beginner: return 0
        case .earlyReader: return 1
        case .growingReader: return 2
        case .confidentReader: return 3
        }
    }
}

enum MathLevel: String, Codable, CaseIterable, Identifiable {
    case emerging = "Emerging"
    case developing = "Developing"
    case secure = "Secure"
    case advancing = "Advancing"

    var id: String { rawValue }

    var sortOrder: Int {
        switch self {
        case .emerging: return 0
        case .developing: return 1
        case .secure: return 2
        case .advancing: return 3
        }
    }
}

enum LearningGoal: String, Codable, CaseIterable, Identifiable {
    case reading = "Reading"
    case math = "Math"
    case vocabulary = "Vocabulary"
    case science = "Science"
    case writing = "Writing"
    case allAround = "All-around practice"

    var id: String { rawValue }
}

enum PreferredActivityType: String, Codable, CaseIterable, Identifiable {
    case story
    case math
    case reading
    case science
    case creative
    case matching
    case sorting
    case drawing
    case review

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .story: return "Story Adventures"
        case .math: return "Math Challenges"
        case .reading: return "Reading & Language"
        case .science: return "Science Discovery"
        case .creative: return "Creative Activities"
        case .matching: return "Matching Games"
        case .sorting: return "Sorting Games"
        case .drawing: return "Drawing"
        case .review: return "Review & Strengthen"
        }
    }
}

struct ParentSettings: Codable, Equatable {
    var showParentSummaryAfterLesson: Bool
    var allowInterestEditing: Bool
    var dailyLessonGoal: Int

    init(
        showParentSummaryAfterLesson: Bool = false,
        allowInterestEditing: Bool = true,
        dailyLessonGoal: Int = 1
    ) {
        self.showParentSummaryAfterLesson = showParentSummaryAfterLesson
        self.allowInterestEditing = allowInterestEditing
        self.dailyLessonGoal = max(1, dailyLessonGoal)
    }
}

/// Persistent learner profile. Age is derived from birthday when available.
struct ChildProfile: Codable, Identifiable, Equatable {
    static let currentSchemaVersion = 2

    let id: UUID
    var schemaVersion: Int
    /// Display name entered during onboarding (historically `nickname`).
    var nickname: String
    var birthday: Date?
    /// Fallback age when birthday is unavailable. Prefer `currentAge`.
    var storedAge: Int
    /// Curriculum-map key derived from age (`K`, `1`, `2`, `3`). Not a school-grade label.
    var grade: String {
        get { AgeGradeLearningStandards.curriculumKey(forAge: currentAge) }
        set { /* Grade follows age so families never pick country-specific school years. */ }
    }
    var readingLevel: ReadingLevel
    var mathLevel: MathLevel
    var learningGoal: LearningGoal
    var favoriteTopics: [Topic]
    var preferredActivityTypes: [PreferredActivityType]
    var avatarIdentifier: String?
    var createdAt: Date
    var updatedAt: Date
    var lastActiveAt: Date
    var completedLessonCount: Int
    var currentLearningStreak: Int
    var hasCompletedOnboarding: Bool
    var parentSettings: ParentSettings?

    /// Compatibility alias used throughout the existing UI.
    var age: Int {
        get { currentAge }
        set { storedAge = newValue }
    }

    /// Age calculated from birthday when present; otherwise stored age.
    var currentAge: Int {
        if let birthday {
            return Self.age(from: birthday, on: Date())
        }
        return storedAge
    }

    var hasValidName: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isReadyForHome: Bool {
        hasCompletedOnboarding && hasValidName && !favoriteTopics.isEmpty
    }

    init(
        id: UUID = UUID(),
        schemaVersion: Int = ChildProfile.currentSchemaVersion,
        nickname: String = "",
        birthday: Date? = nil,
        age: Int = 6,
        grade _: String = "",
        readingLevel: ReadingLevel = .earlyReader,
        mathLevel: MathLevel = .developing,
        learningGoal: LearningGoal = .allAround,
        favoriteTopics: [Topic] = [],
        preferredActivityTypes: [PreferredActivityType] = [.story, .math, .reading, .science, .creative],
        avatarIdentifier: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastActiveAt: Date = Date(),
        completedLessonCount: Int = 0,
        currentLearningStreak: Int = 0,
        hasCompletedOnboarding: Bool = false,
        parentSettings: ParentSettings? = ParentSettings()
    ) {
        self.id = id
        self.schemaVersion = schemaVersion
        self.nickname = nickname
        self.birthday = birthday
        self.storedAge = age
        self.readingLevel = readingLevel
        self.mathLevel = mathLevel
        self.learningGoal = learningGoal
        self.favoriteTopics = favoriteTopics
        self.preferredActivityTypes = preferredActivityTypes
        self.avatarIdentifier = avatarIdentifier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastActiveAt = lastActiveAt
        self.completedLessonCount = completedLessonCount
        self.currentLearningStreak = currentLearningStreak
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.parentSettings = parentSettings
    }

    enum CodingKeys: String, CodingKey {
        case id, schemaVersion, nickname, birthday, storedAge, age
        case grade, readingLevel, mathLevel, learningGoal
        case favoriteTopics, preferredActivityTypes, avatarIdentifier
        case createdAt, updatedAt, lastActiveAt
        case completedLessonCount, currentLearningStreak
        case hasCompletedOnboarding, parentSettings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        schemaVersion = try container.decodeIfPresent(Int.self, forKey: .schemaVersion) ?? 1
        nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
        birthday = try container.decodeIfPresent(Date.self, forKey: .birthday)
        if let stored = try container.decodeIfPresent(Int.self, forKey: .storedAge) {
            storedAge = stored
        } else {
            storedAge = try container.decodeIfPresent(Int.self, forKey: .age) ?? 6
        }
        _ = try container.decodeIfPresent(String.self, forKey: .grade)
        readingLevel = try container.decodeIfPresent(ReadingLevel.self, forKey: .readingLevel) ?? .earlyReader
        mathLevel = try container.decodeIfPresent(MathLevel.self, forKey: .mathLevel) ?? .developing
        learningGoal = try container.decodeIfPresent(LearningGoal.self, forKey: .learningGoal) ?? .allAround
        favoriteTopics = try container.decodeIfPresent([Topic].self, forKey: .favoriteTopics) ?? []
        preferredActivityTypes = try container.decodeIfPresent(
            [PreferredActivityType].self,
            forKey: .preferredActivityTypes
        ) ?? [.story, .math, .reading, .science, .creative]
        avatarIdentifier = try container.decodeIfPresent(String.self, forKey: .avatarIdentifier)
        let now = Date()
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? now
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? now
        lastActiveAt = try container.decodeIfPresent(Date.self, forKey: .lastActiveAt) ?? now
        completedLessonCount = try container.decodeIfPresent(Int.self, forKey: .completedLessonCount) ?? 0
        currentLearningStreak = try container.decodeIfPresent(Int.self, forKey: .currentLearningStreak) ?? 0
        // Legacy profiles with a name + interests are treated as onboarded.
        let decodedOnboarding = try container.decodeIfPresent(Bool.self, forKey: .hasCompletedOnboarding)
        if let decodedOnboarding {
            hasCompletedOnboarding = decodedOnboarding
        } else {
            hasCompletedOnboarding = !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !favoriteTopics.isEmpty
        }
        parentSettings = try container.decodeIfPresent(ParentSettings.self, forKey: .parentSettings)
            ?? ParentSettings()
        schemaVersion = ChildProfile.currentSchemaVersion
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ChildProfile.currentSchemaVersion, forKey: .schemaVersion)
        try container.encode(nickname, forKey: .nickname)
        try container.encodeIfPresent(birthday, forKey: .birthday)
        try container.encode(storedAge, forKey: .storedAge)
        // Keep legacy `age` key in sync for older readers.
        try container.encode(currentAge, forKey: .age)
        try container.encode(grade, forKey: .grade)
        try container.encode(readingLevel, forKey: .readingLevel)
        try container.encode(mathLevel, forKey: .mathLevel)
        try container.encode(learningGoal, forKey: .learningGoal)
        try container.encode(favoriteTopics, forKey: .favoriteTopics)
        try container.encode(preferredActivityTypes, forKey: .preferredActivityTypes)
        try container.encodeIfPresent(avatarIdentifier, forKey: .avatarIdentifier)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(lastActiveAt, forKey: .lastActiveAt)
        try container.encode(completedLessonCount, forKey: .completedLessonCount)
        try container.encode(currentLearningStreak, forKey: .currentLearningStreak)
        try container.encode(hasCompletedOnboarding, forKey: .hasCompletedOnboarding)
        try container.encodeIfPresent(parentSettings, forKey: .parentSettings)
    }

    mutating func applyAgeBasedCurriculumDefaults() {
        readingLevel = LessonDifficultyRules.suggestedReadingLevel(forAge: currentAge)
        mathLevel = LessonDifficultyRules.suggestedMathLevel(forAge: currentAge)
    }

    mutating func touch(updated: Bool = true, active: Bool = true) {
        let now = Date()
        if updated { updatedAt = now }
        if active { lastActiveAt = now }
    }

    static func age(from birthday: Date, on date: Date = Date()) -> Int {
        let calendar = Calendar.current
        let years = calendar.dateComponents([.year], from: birthday, to: date).year ?? 0
        return max(0, years)
    }
}

struct ChildResponse: Codable, Identifiable {
    let id: UUID
    let questionId: UUID
    let selectedAnswer: String
    let isCorrect: Bool
    let timestamp: Date

    init(
        id: UUID = UUID(),
        questionId: UUID,
        selectedAnswer: String,
        isCorrect: Bool,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.questionId = questionId
        self.selectedAnswer = selectedAnswer
        self.isCorrect = isCorrect
        self.timestamp = timestamp
    }
}
