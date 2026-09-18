import Foundation
import SwiftUI

/// Explicit primary academic subject used for section filtering and question quality.
/// A story format can still be Math, Reading, or Science depending on the learning objective.
enum PrimarySubject: String, Codable, CaseIterable, Identifiable, Equatable {
    case math
    case reading
    case science
    case creative

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .math: return "Math"
        case .reading: return "Reading"
        case .science: return "Science"
        case .creative: return "Creative"
        }
    }

    var defaultSkillLabel: String {
        switch self {
        case .math: return "Number sense"
        case .reading: return "Reading comprehension"
        case .science: return "Scientific reasoning"
        case .creative: return "Creative expression"
        }
    }

    /// Maps Marble / JSON curriculum subject strings onto primary subjects.
    static func fromCurriculumSubject(_ value: String?) -> PrimarySubject? {
        guard let value else { return nil }
        let lower = value.lowercased()
        if lower.contains("math") || lower.contains("numeracy") { return .math }
        if lower.contains("read") || lower.contains("literacy") || lower.contains("language")
            || lower.contains("english") { return .reading }
        if lower.contains("science") || lower.contains("stem") { return .science }
        if lower.contains("creat") || lower.contains("art") || lower.contains("writ")
            || lower.contains("computing") { return .creative }
        return nil
    }

    static func from(category: LessonCategory) -> PrimarySubject {
        switch category {
        case .math: return .math
        case .story: return .reading
        case .discovery: return .science
        case .creative: return .creative
        }
    }

    var matchingCategories: [LessonCategory] {
        switch self {
        case .math: return [.math]
        case .reading: return [.story]
        case .science: return [.discovery]
        case .creative: return [.creative]
        }
    }
}

/// High-level adventure category shown on the Home screen chooser.
enum LessonCategory: String, Codable, CaseIterable, Identifiable {
    case story
    case math
    case discovery
    case creative

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .story: return "Story Adventure"
        case .math: return "Math Mission"
        case .discovery: return "Discovery Lesson"
        case .creative: return "Creative Challenge"
        }
    }

    var shortLabel: String {
        switch self {
        case .story: return "Story"
        case .math: return "Math"
        case .discovery: return "Discovery"
        case .creative: return "Creative"
        }
    }

    var emoji: String {
        switch self {
        case .story: return "📖"
        case .math: return "🔢"
        case .discovery: return "🔬"
        case .creative: return "🎨"
        }
    }

    var iconSystemName: String {
        switch self {
        case .story: return "book.fill"
        case .math: return "function"
        case .discovery: return "sparkle.magnifyingglass"
        case .creative: return "paintbrush.fill"
        }
    }

    var accentColor: Color {
        switch self {
        case .story: return DesignSystem.Colors.skyBlue
        case .math: return DesignSystem.Colors.warmOrange
        case .discovery: return DesignSystem.Colors.freshGreen
        case .creative: return DesignSystem.Colors.brightLavender
        }
    }

    var lightAccent: Color {
        switch self {
        case .story: return DesignSystem.Colors.skyBlueLight
        case .math: return DesignSystem.Colors.warmOrangeLight
        case .discovery: return DesignSystem.Colors.freshGreenLight
        case .creative: return DesignSystem.Colors.brightLavenderLight
        }
    }

    var focusSkills: [String] {
        switch self {
        case .story: return ["Reading", "Vocabulary", "Comprehension"]
        case .math: return ["Math", "Word Problems", "Logic"]
        case .discovery: return ["Science", "Reading", "Vocabulary"]
        case .creative: return ["Creativity", "Writing", "Vocabulary"]
        }
    }

    /// Preferred lesson formats when generating or ranking for this category.
    var preferredLessonTypes: [LessonType] {
        switch self {
        case .story: return [.mystery, .detective, .rescue, .explorer]
        case .math: return [.builder, .rescue, .spaceMission]
        case .discovery: return [.animalExpert, .spaceMission, .explorer]
        case .creative: return [.creativeLab, .detective, .explorer]
        }
    }

    static func inferred(from lessonType: LessonType) -> LessonCategory {
        switch lessonType {
        case .mystery, .detective, .rescue: return .story
        case .builder: return .math
        case .animalExpert, .spaceMission: return .discovery
        case .creativeLab: return .creative
        case .explorer: return .story
        }
    }

    static func inferred(
        from lessonType: LessonType,
        learningGoal: LearningGoal = .allAround,
        title: String = "",
        mathSkill: String = "",
        skills: [String] = []
    ) -> LessonCategory {
        infer(
            lessonType: lessonType,
            learningGoal: learningGoal,
            title: title,
            mathSkill: mathSkill,
            skills: skills
        )
    }

    static func infer(
        lessonType: LessonType,
        learningGoal: LearningGoal = .allAround,
        title: String = "",
        mathSkill: String = "",
        skills: [String] = []
    ) -> LessonCategory {
        let haystack = (title + " " + mathSkill + " " + skills.joined(separator: " ")).lowercased()

        if haystack.contains("math") || haystack.contains("count") || haystack.contains("addition")
            || haystack.contains("subtract") || lessonType == .builder {
            return .math
        }
        if lessonType == .creativeLab || haystack.contains("creative") || haystack.contains("design")
            || haystack.contains("invent") || learningGoal == .writing {
            return .creative
        }
        if lessonType == .animalExpert || lessonType == .spaceMission
            || haystack.contains("discovery") || haystack.contains("science")
            || haystack.contains("rocket") || learningGoal == .science {
            return .discovery
        }
        if learningGoal == .math {
            return .math
        }
        return inferred(from: lessonType)
    }
}

enum LessonType: String, Codable, CaseIterable {
    case explorer
    case rescue
    case mystery
    case builder
    case animalExpert
    case spaceMission
    case detective
    case creativeLab

    var displayName: String {
        switch self {
        case .explorer: return "Explorer"
        case .rescue: return "Rescue"
        case .mystery: return "Mystery"
        case .builder: return "Builder"
        case .animalExpert: return "Animal Expert"
        case .spaceMission: return "Space Mission"
        case .detective: return "Detective"
        case .creativeLab: return "Create & Invent"
        }
    }

    var category: LessonCategory {
        LessonCategory.inferred(from: self)
    }

    var emoji: String {
        switch self {
        case .explorer: return "🔍"
        case .rescue: return "🛟"
        case .mystery: return "🕵️"
        case .builder: return "🔨"
        case .animalExpert: return "🐾"
        case .spaceMission: return "🚀"
        case .detective: return "🔎"
        case .creativeLab: return "🎨"
        }
    }

    var introPhrase: String {
        switch self {
        case .explorer: return "Today you get to discover something new!"
        case .rescue: return "Someone needs your help — let's solve this together!"
        case .mystery: return "Follow the clues and see what you can figure out!"
        case .builder: return "Time to build and create something awesome!"
        case .animalExpert: return "You're the animal expert today!"
        case .spaceMission: return "Mission control is counting on you!"
        case .detective: return "Read carefully — the answer is hiding in the details!"
        case .creativeLab: return "Welcome — read a short spark story, then make something of your own!"
        }
    }

    /// How this lesson type should feel emotionally from opening to ending.
    var emotionalStructure: String {
        switch self {
        case .explorer:
            return "Wander, notice details, and uncover something wonderful you did not expect."
        case .rescue:
            return "Someone is counting on you — read the plan, act carefully, and save the day."
        case .mystery:
            return "Collect clues one by one until the hidden answer finally clicks."
        case .builder:
            return "Gather materials, follow steps, and create something that was not there before."
        case .animalExpert:
            return "Share what you know and help others understand amazing living creatures."
        case .spaceMission:
            return "Check every system, complete each step, and launch a bold mission."
        case .detective:
            return "Study the evidence closely — the truth is hiding in plain sight."
        case .creativeLab:
            return "Mix real facts with wild imagination and make something only you could create."
        }
    }

    var missionButtonLabel: String {
        switch self {
        case .rescue: return "I'm on my way!"
        case .mystery, .detective: return "Investigate!"
        case .builder: return "Start building!"
        case .spaceMission: return "Launch mission!"
        case .creativeLab: return "Let's create!"
        case .animalExpert: return "Teach the group!"
        case .explorer: return "Let's explore!"
        }
    }
}

// MARK: - Supporting Types

struct VocabularyWord: Codable, Identifiable, Hashable {
    let id: UUID
    let word: String
    let definition: String
    let exampleSentence: String
    let storyConnection: String

    init(
        id: UUID = UUID(),
        word: String,
        definition: String,
        exampleSentence: String = "",
        storyConnection: String = ""
    ) {
        self.id = id
        self.word = word
        self.definition = definition
        self.exampleSentence = exampleSentence
        self.storyConnection = storyConnection
    }

    enum CodingKeys: String, CodingKey {
        case id, word, definition, exampleSentence, storyConnection
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = Self.decodeFlexibleUUID(from: container, forKey: .id)
        word = try container.decode(String.self, forKey: .word)
        definition = try container.decode(String.self, forKey: .definition)
        exampleSentence = try container.decodeIfPresent(String.self, forKey: .exampleSentence) ?? ""
        storyConnection = try container.decodeIfPresent(String.self, forKey: .storyConnection) ?? ""
    }

    private static func decodeFlexibleUUID(from container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) -> UUID {
        if let raw = try? container.decode(String.self, forKey: key), let uuid = UUID(uuidString: raw) {
            return uuid
        }
        if let uuid = try? container.decode(UUID.self, forKey: key) {
            return uuid
        }
        return UUID()
    }
}

struct KnowledgeFact: Codable, Identifiable, Hashable {
    let id: UUID
    let fact: String
    let explanation: String

    init(id: UUID = UUID(), fact: String, explanation: String = "") {
        self.id = id
        self.fact = fact
        let cleaned = Self.childFacingExplanation(fact: fact, explanation: explanation)
        self.explanation = cleaned.isEmpty ? fact : cleaned
    }

    /// Extra sentence shown under a fact. Empty when it would just repeat the fact or
    /// dump adult “use this in your art” glue on a child.
    var childFacingExplanation: String {
        Self.childFacingExplanation(fact: fact, explanation: explanation)
    }

    static func childFacingExplanation(fact: String, explanation: String) -> String {
        let factText = fact.trimmingCharacters(in: .whitespacesAndNewlines)
        let extra = explanation.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !extra.isEmpty else { return "" }
        if extra.compare(factText, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame {
            return ""
        }
        let lower = extra.lowercased()
        let metaGlue = [
            "builders and artists",
            "true details like this",
            "use this fact so your creation",
            "let this fact shape",
            "science can guide what you draw",
            "shape one choice in your design",
            "stays true:",
            "a good badge teaches"
        ]
        if metaGlue.contains(where: { lower.contains($0) }) {
            return ""
        }
        if !factText.isEmpty, factText.count >= 12, extra.localizedCaseInsensitiveContains(factText) {
            return ""
        }
        return extra
    }

    enum CodingKeys: String, CodingKey {
        case id, fact, explanation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let raw = try? container.decode(String.self, forKey: .id), let uuid = UUID(uuidString: raw) {
            id = uuid
        } else if let uuid = try? container.decode(UUID.self, forKey: .id) {
            id = uuid
        } else {
            id = UUID()
        }
        fact = try container.decode(String.self, forKey: .fact)
        let decodedExplanation = try container.decodeIfPresent(String.self, forKey: .explanation) ?? ""
        let cleaned = Self.childFacingExplanation(fact: fact, explanation: decodedExplanation)
        explanation = cleaned.isEmpty ? fact : cleaned
    }
}

enum DifficultyLevel: String, Codable {
    case beginner = "Beginner"
    case earlyReader = "Early Reader"
    case growingReader = "Growing Reader"
    case confidentReader = "Confident Reader"

    init(readingLevel: ReadingLevel) {
        switch readingLevel {
        case .beginner: self = .beginner
        case .earlyReader: self = .earlyReader
        case .growingReader: self = .growingReader
        case .confidentReader: self = .confidentReader
        }
    }
}

// MARK: - Story Moments

enum StoryMoment: String, CaseIterable, Identifiable {
    case storyOpening
    case mission
    case reading
    case question
    case math
    case vocabulary
    case knowledge
    case creative
    case reflection
    case ending

    var id: String { rawValue }

    var stepNumber: Int {
        switch self {
        case .storyOpening: return 1
        case .mission: return 2
        case .reading: return 3
        case .question: return 4
        case .math: return 5
        case .vocabulary: return 6
        case .knowledge: return 7
        case .creative: return 8
        case .reflection: return 9
        case .ending: return 10
        }
    }

    static let journeyCount = 10

    var title: String {
        switch self {
        case .storyOpening: return "The Story Begins"
        case .mission: return "Your Mission"
        case .reading: return "Read Along"
        case .question: return "Story Clues"
        case .math: return "Math Challenges"
        case .vocabulary: return "Treasure Words"
        case .knowledge: return "Did You Know?"
        case .creative: return "Create Time"
        case .reflection: return "Star Moment"
        case .ending: return "Victory!"
        }
    }

    var badge: String {
        switch self {
        case .storyOpening, .mission, .ending: return "Adventure"
        case .reading, .question: return "Reading"
        case .math: return "Math"
        case .vocabulary: return "Vocabulary"
        case .knowledge: return "Science"
        case .creative: return "Create"
        case .reflection: return "Star"
        }
    }

    var continueLabel: String {
        switch self {
        case .storyOpening: return "Begin Adventure"
        case .mission: return "Accept Mission"
        case .reading: return "I read it!"
        case .question, .math: return "Continue"
        case .vocabulary, .knowledge: return "Got it!"
        case .creative: return "Share My Creation"
        case .reflection: return "Collect My Star!"
        case .ending: return "See My Results"
        }
    }

    func pageAccent(topic: Topic) -> Color {
        switch self {
        case .storyOpening, .mission, .ending:
            return TopicPalette.color(for: topic)
        case .reading, .question:
            return DesignSystem.Colors.skyBlue
        case .math:
            return DesignSystem.Colors.coralPink
        case .vocabulary:
            return DesignSystem.Colors.lavenderPurple
        case .knowledge:
            return DesignSystem.Colors.freshGreen
        case .creative:
            return DesignSystem.Colors.sunshineYellow
        case .reflection:
            return DesignSystem.Colors.warmOrange
        }
    }
}

// MARK: - Legacy Section Types (backward compatibility)

enum LessonSectionType: String, Codable {
    case storySetup
    case readingPassage
    case readingComprehension
    case math
    case vocabulary
    case scienceFact
    case creativePrompt
    case reflection
}

struct LessonSection: Codable, Identifiable {
    let id: UUID
    let type: LessonSectionType
    let title: String
    let content: String
    let questions: [LessonQuestion]

    init(
        id: UUID = UUID(),
        type: LessonSectionType,
        title: String,
        content: String = "",
        questions: [LessonQuestion] = []
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.content = content
        self.questions = questions
    }
}

// MARK: - Resolved Story Content

struct LessonStoryContent {
    let storyOpening: String
    let missionPrompt: String
    let readingPassage: String
    let readingQuestions: [LessonQuestion]
    let mathQuestions: [LessonQuestion]
    let vocabularyWords: [VocabularyWord]
    let knowledgeFacts: [KnowledgeFact]
    let creativePrompt: String
    let creativeResponseType: QuestionResponseType
    let reflectionPrompt: String
    let reflectionResponseType: QuestionResponseType
    let storyEnding: String

    var comprehensionQuestion: LessonQuestion {
        readingQuestions.first ?? Lesson.placeholderQuestion
    }

    var mathChallenge: LessonQuestion {
        mathQuestions.first ?? Lesson.placeholderMath
    }

    var vocabularyWord: String { vocabularyWords.first?.word ?? "" }
    var vocabularyDefinition: String { vocabularyWords.first?.definition ?? "" }
    var knowledgeFact: String { knowledgeFacts.first?.fact ?? "" }
}

// MARK: - Lesson

struct Lesson: Codable, Identifiable {
    let id: UUID
    let title: String
    let theme: Topic
    let lessonType: LessonType
    let storyOpening: String
    let missionPrompt: String
    let readingPassage: String
    let questions: [LessonQuestion]
    let mathChallenges: [LessonQuestion]
    let vocabularyWords: [VocabularyWord]
    let knowledgeFacts: [KnowledgeFact]
    var creativePrompt: String
    let creativeResponseType: QuestionResponseType
    let storyEnding: String
    let ageTarget: String
    let gradeTarget: String
    let readingLevel: ReadingLevel
    /// Independent of reading level — used to select and validate math content.
    let mathLevel: MathLevel
    let learningGoal: LearningGoal
    let difficultyLevel: DifficultyLevel
    let estimatedMinutes: Int
    let readingSkill: String
    let mathSkill: String
    var reflectionPrompt: String
    let reflectionResponseType: QuestionResponseType
    let sections: [LessonSection]
    let skillsPracticed: [String]
    let category: LessonCategory
    /// Explicit subject for Home section filtering (Math / Reading / Science / Creative).
    var primarySubject: PrimarySubject
    let teaser: String
    let difficultyLabel: String

    // MARK: Content pipeline metadata
    /// CASE / standards skill identifier (mock or live).
    var standardSkillId: String?
    var contentApprovalStatus: ContentApprovalStatus
    var hints: [String]
    var commonMistakes: [String]
    var successCriteria: [String]
    /// Intended reading band label (Lexile band when licensed; mock band otherwise).
    var intendedReadingBand: String?
    /// Measured estimate from reading provider (nil if not measured). Not a Quantile/Lexile claim unless provider says so.
    var measuredReadingEstimate: Int?
    var readingMeasurementProvider: String?

    // MARK: Marble curriculum mapping (optional; legacy lessons may be unmapped)
    var primaryTopicId: String?
    var supportingTopicIds: [String]
    var prerequisiteTopicIds: [String]
    var curriculumSubject: String?
    var curriculumDomain: String?
    var curriculumDifficulty: String?
    var recommendedAgeRange: String?
    var learningObjectives: [String]
    var evidenceTargets: [String]
    /// Scene checklist shown on Art Quest drawing boards (tap-what-you-added).
    var drawingQuestGoals: [String]

    /// True when the lesson may be shown to children.
    var isApprovedForChildDisplay: Bool {
        contentApprovalStatus == .approved
    }

    /// Topic label (same as theme display name).
    var topic: String { theme.rawValue }

    var isCurriculumMapped: Bool {
        primaryTopicId != nil || !supportingTopicIds.isEmpty
    }

    /// Scored practice items shown to the child (arranging/sorting excluded).
    var childFacingQuestions: [LessonQuestion] {
        var filtered = QuestionQualityValidator.filterForChildDisplay(questions, lesson: self)
        if primarySubject == .math {
            var kept: [LessonQuestion] = []
            var nonMathKept = 0
            for question in filtered {
                if question.subject == .math {
                    kept.append(question)
                } else if nonMathKept < 1 {
                    kept.append(question)
                    nonMathKept += 1
                }
            }
            filtered = kept
        }
        return filtered
    }

    var childFacingMathChallenges: [LessonQuestion] {
        QuestionQualityValidator.filterForChildDisplay(mathChallenges, lesson: self)
    }

    /// Math practice belongs in Math Missions, not themed story/discovery/creative sessions.
    var focusesOnMath: Bool {
        category == .math || primarySubject == .math
    }

    /// True only for pure creative sessions — story inspiration + create, no reading/math quiz.
    /// Do not brand mixed quiz lessons as "Art Quest."
    var isArtQuest: Bool {
        lessonType == .creativeLab
            && primarySubject == .creative
            && childFacingQuestions.isEmpty
            && childFacingMathChallenges.isEmpty
    }

    /// Kid-facing activity label for cards and CTAs.
    var activityLabel: String {
        if isArtQuest { return "Art Quest" }
        switch category {
        case .story: return "Story"
        case .math: return "Math"
        case .discovery: return "Discovery"
        case .creative: return "Create"
        }
    }

    var startButtonLabel: String {
        if isArtQuest { return "Start Drawing!" }
        return lessonType.missionButtonLabel
    }

    /// Fraction of scored activities that assess math (0...1).
    var mathAssessmentRatio: Double {
        let scored = childFacingQuestions + childFacingMathChallenges
        guard !scored.isEmpty else { return 0 }
        let mathCount = scored.filter { $0.subject == .math }.count
        return Double(mathCount) / Double(scored.count)
    }

    /// Legacy alias for grade target.
    var gradeLevel: String { gradeTarget }

    /// Legacy single vocabulary word.
    var vocabularyWord: String { vocabularyWords.first?.word ?? "" }

    /// Legacy single vocabulary definition.
    var vocabularyDefinition: String { vocabularyWords.first?.definition ?? "" }

    /// Legacy alias for reflection.
    var reflectionQuestion: String { reflectionPrompt }

    /// Legacy alias for story opening.
    var storySetup: String { storyOpening }

    /// Legacy alias for science fact.
    var scienceFact: String { knowledgeFacts.first?.fact ?? "" }

    /// Legacy alias for knowledge fact string.
    var knowledgeFact: String { scienceFact }

    var story: LessonStoryContent {
        LessonStoryContent(
            storyOpening: storyOpening,
            missionPrompt: missionPrompt,
            readingPassage: readingPassage,
            readingQuestions: questions,
            mathQuestions: mathChallenges,
            vocabularyWords: vocabularyWords,
            knowledgeFacts: knowledgeFacts,
            creativePrompt: creativePrompt,
            creativeResponseType: creativeResponseType,
            reflectionPrompt: reflectionPrompt,
            reflectionResponseType: reflectionResponseType,
            storyEnding: storyEnding
        )
    }

    var missionCompleteMessage: String {
        ProgressSummary.shortHeadline(from: storyEnding)
    }

    init(
        id: UUID = UUID(),
        title: String,
        theme: Topic,
        lessonType: LessonType,
        category: LessonCategory? = nil,
        primarySubject: PrimarySubject? = nil,
        storyOpening: String,
        missionPrompt: String,
        readingPassage: String,
        questions: [LessonQuestion],
        mathChallenges: [LessonQuestion],
        vocabularyWords: [VocabularyWord],
        knowledgeFacts: [KnowledgeFact],
        creativePrompt: String,
        creativeResponseType: QuestionResponseType,
        storyEnding: String,
        ageTarget: String = "5-8",
        gradeTarget: String = "K-2",
        readingLevel: ReadingLevel = .earlyReader,
        mathLevel: MathLevel = .developing,
        learningGoal: LearningGoal = .allAround,
        estimatedMinutes: Int? = nil,
        teaser: String? = nil,
        difficultyLabel: String? = nil,
        readingSkill: String,
        mathSkill: String,
        reflectionPrompt: String = "What was one important detail from the story or problems you just finished?",
        reflectionResponseType: QuestionResponseType = .shortText,
        sections: [LessonSection] = [],
        skillsPracticed: [String],
        standardSkillId: String? = nil,
        contentApprovalStatus: ContentApprovalStatus = .legacyBundled,
        hints: [String] = [],
        commonMistakes: [String] = [],
        successCriteria: [String] = [],
        intendedReadingBand: String? = nil,
        measuredReadingEstimate: Int? = nil,
        readingMeasurementProvider: String? = nil,
        primaryTopicId: String? = nil,
        supportingTopicIds: [String] = [],
        prerequisiteTopicIds: [String] = [],
        curriculumSubject: String? = nil,
        curriculumDomain: String? = nil,
        curriculumDifficulty: String? = nil,
        recommendedAgeRange: String? = nil,
        learningObjectives: [String] = [],
        evidenceTargets: [String] = [],
        drawingQuestGoals: [String] = []
    ) {
        self.id = id
        self.title = title
        self.theme = theme
        self.lessonType = lessonType
        self.storyOpening = storyOpening
        self.missionPrompt = missionPrompt
        self.readingPassage = readingPassage
        self.questions = questions
        self.mathChallenges = mathChallenges
        self.vocabularyWords = vocabularyWords
        self.knowledgeFacts = knowledgeFacts
        let alignedCreative = QuestionResponseTypeResolver.alignedCreative(
            prompt: creativePrompt,
            responseType: creativeResponseType
        )
        self.creativePrompt = alignedCreative.prompt
        self.creativeResponseType = alignedCreative.responseType
        self.storyEnding = storyEnding
        self.ageTarget = ageTarget
        self.gradeTarget = gradeTarget
        self.readingLevel = readingLevel
        self.mathLevel = mathLevel
        self.learningGoal = learningGoal
        self.difficultyLevel = DifficultyLevel(readingLevel: readingLevel)
        self.estimatedMinutes = estimatedMinutes ?? LessonDifficultyRules.estimatedMinutes(for: readingLevel)
        self.readingSkill = readingSkill
        self.mathSkill = mathSkill
        self.reflectionPrompt = reflectionPrompt
        self.reflectionResponseType = reflectionResponseType
        self.sections = sections.isEmpty
            ? Self.legacySections(
                storyOpening: storyOpening,
                missionPrompt: missionPrompt,
                readingPassage: readingPassage,
                questions: questions,
                mathChallenges: mathChallenges,
                vocabularyWords: vocabularyWords,
                knowledgeFacts: knowledgeFacts,
                creativePrompt: alignedCreative.prompt,
                creativeResponseType: alignedCreative.responseType,
                reflectionPrompt: reflectionPrompt,
                reflectionResponseType: reflectionResponseType
            )
            : sections
        self.skillsPracticed = skillsPracticed.isEmpty
            ? (category ?? LessonCategory.infer(lessonType: lessonType, learningGoal: learningGoal, title: title, mathSkill: mathSkill)).focusSkills
            : skillsPracticed
        let resolvedCategory = category ?? LessonCategory.infer(
            lessonType: lessonType,
            learningGoal: learningGoal,
            title: title,
            mathSkill: mathSkill
        )
        self.category = resolvedCategory
        self.primarySubject = primarySubject
            ?? PrimarySubject.fromCurriculumSubject(curriculumSubject)
            ?? PrimarySubject.from(category: resolvedCategory)
        self.teaser = {
            if let teaser, !teaser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return teaser
            }
            return Self.makeTeaser(from: missionPrompt, fallback: storyOpening)
        }()
        self.difficultyLabel = difficultyLabel ?? DifficultyLevel(readingLevel: readingLevel).rawValue
        self.standardSkillId = standardSkillId
        self.contentApprovalStatus = contentApprovalStatus
        self.hints = hints
        self.commonMistakes = commonMistakes
        self.successCriteria = successCriteria
        self.intendedReadingBand = intendedReadingBand
        self.measuredReadingEstimate = measuredReadingEstimate
        self.readingMeasurementProvider = readingMeasurementProvider
        self.primaryTopicId = primaryTopicId
        self.supportingTopicIds = supportingTopicIds
        self.prerequisiteTopicIds = prerequisiteTopicIds
        self.curriculumSubject = curriculumSubject
        self.curriculumDomain = curriculumDomain
        self.curriculumDifficulty = curriculumDifficulty
        self.recommendedAgeRange = recommendedAgeRange
        self.learningObjectives = learningObjectives
        self.evidenceTargets = evidenceTargets
        self.drawingQuestGoals = drawingQuestGoals
    }

    /// Convenience initializer with legacy single vocabulary and fact fields.
    init(
        id: UUID = UUID(),
        title: String,
        theme: Topic,
        lessonType: LessonType,
        storyOpening: String,
        missionPrompt: String,
        readingPassage: String,
        questions: [LessonQuestion],
        mathChallenges: [LessonQuestion],
        vocabularyWord: String,
        vocabularyDefinition: String,
        knowledgeFact: String,
        creativePrompt: String,
        creativeResponseType: QuestionResponseType,
        storyEnding: String,
        ageTarget: String = "5-8",
        gradeLevel: String = "K-2",
        readingLevel: ReadingLevel = .earlyReader,
        learningGoal: LearningGoal = .allAround,
        estimatedMinutes: Int? = nil,
        readingSkill: String,
        mathSkill: String,
        reflectionQuestion: String = "What was one important detail from the story or problems you just finished?",
        reflectionResponseType: QuestionResponseType = .shortText,
        sections: [LessonSection] = [],
        skillsPracticed: [String]
    ) {
        self.init(
            id: id,
            title: title,
            theme: theme,
            lessonType: lessonType,
            storyOpening: storyOpening,
            missionPrompt: missionPrompt,
            readingPassage: readingPassage,
            questions: questions,
            mathChallenges: mathChallenges,
            vocabularyWords: Self.enrichVocabulary(
                primary: VocabularyWord(word: vocabularyWord, definition: vocabularyDefinition),
                theme: theme,
                passage: readingPassage,
                level: readingLevel
            ),
            knowledgeFacts: [KnowledgeFact(fact: knowledgeFact)],
            creativePrompt: creativePrompt,
            creativeResponseType: creativeResponseType,
            storyEnding: storyEnding,
            ageTarget: ageTarget,
            gradeTarget: gradeLevel,
            readingLevel: readingLevel,
            learningGoal: learningGoal,
            estimatedMinutes: estimatedMinutes,
            readingSkill: readingSkill,
            mathSkill: mathSkill,
            reflectionPrompt: reflectionQuestion,
            reflectionResponseType: reflectionResponseType,
            sections: sections,
            skillsPracticed: skillsPracticed
        )
    }

    /// Convenience initializer preserving legacy `storySetup` parameter name.
    init(
        id: UUID = UUID(),
        title: String,
        theme: Topic,
        lessonType: LessonType,
        storySetup: String,
        missionPrompt: String = "",
        readingPassage: String = "",
        questions: [LessonQuestion] = [],
        mathChallenges: [LessonQuestion] = [],
        vocabularyWord: String,
        vocabularyDefinition: String,
        scienceFact: String,
        creativePrompt: String,
        creativeResponseType: QuestionResponseType,
        storyEnding: String = "",
        ageTarget: String = "5-8",
        gradeLevel: String = "K-2",
        readingLevel: ReadingLevel = .earlyReader,
        learningGoal: LearningGoal = .allAround,
        readingSkill: String,
        mathSkill: String,
        reflectionQuestion: String = "What was one important detail from the story or problems you just finished?",
        reflectionResponseType: QuestionResponseType = .shortText,
        sections: [LessonSection] = [],
        skillsPracticed: [String]
    ) {
        self.init(
            id: id,
            title: title,
            theme: theme,
            lessonType: lessonType,
            storyOpening: storySetup,
            missionPrompt: missionPrompt,
            readingPassage: readingPassage,
            questions: questions,
            mathChallenges: mathChallenges,
            vocabularyWord: vocabularyWord,
            vocabularyDefinition: vocabularyDefinition,
            knowledgeFact: scienceFact,
            creativePrompt: creativePrompt,
            creativeResponseType: creativeResponseType,
            storyEnding: storyEnding,
            ageTarget: ageTarget,
            gradeLevel: gradeLevel,
            readingLevel: readingLevel,
            learningGoal: learningGoal,
            readingSkill: readingSkill,
            mathSkill: mathSkill,
            reflectionQuestion: reflectionQuestion,
            reflectionResponseType: reflectionResponseType,
            sections: sections,
            skillsPracticed: skillsPracticed
        )
    }

    enum CodingKeys: String, CodingKey {
        case id, title, theme, lessonType
        case storyOpening, storySetup, missionPrompt, readingPassage
        case questions, mathChallenges
        case vocabularyWords, vocabularyWord, vocabularyDefinition
        case knowledgeFacts, knowledgeFact, scienceFact
        case creativePrompt, creativeResponseType, storyEnding
        case ageTarget, gradeTarget, gradeLevel
        case readingLevel, mathLevel, learningGoal, difficultyLevel, estimatedMinutes
        case readingSkill, mathSkill
        case reflectionPrompt, reflectionQuestion, reflectionResponseType
        case sections, skillsPracticed
        case category, primarySubject, teaser, difficultyLabel
        case standardSkillId, contentApprovalStatus, hints, commonMistakes, successCriteria
        case intendedReadingBand, measuredReadingEstimate, readingMeasurementProvider
        case primaryTopicId, supportingTopicIds, prerequisiteTopicIds
        case curriculumSubject, subject
        case curriculumDomain, domain
        case curriculumDifficulty, difficulty
        case recommendedAgeRange, learningObjectives, evidenceTargets
        case drawingQuestGoals
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        theme = try container.decode(Topic.self, forKey: .theme)
        lessonType = try container.decodeIfPresent(LessonType.self, forKey: .lessonType) ?? .explorer
        gradeTarget = try container.decodeIfPresent(String.self, forKey: .gradeTarget)
            ?? container.decodeIfPresent(String.self, forKey: .gradeLevel) ?? "K-2"
        readingLevel = try container.decodeIfPresent(ReadingLevel.self, forKey: .readingLevel) ?? .earlyReader
        mathLevel = try container.decodeIfPresent(MathLevel.self, forKey: .mathLevel) ?? .developing
        learningGoal = try container.decodeIfPresent(LearningGoal.self, forKey: .learningGoal) ?? .allAround
        ageTarget = try container.decodeIfPresent(String.self, forKey: .ageTarget) ?? "5-8"
        readingSkill = try container.decodeIfPresent(String.self, forKey: .readingSkill) ?? "Reading comprehension"
        mathSkill = try container.decodeIfPresent(String.self, forKey: .mathSkill) ?? "Number sense"
        reflectionPrompt = try container.decodeIfPresent(String.self, forKey: .reflectionPrompt)
            ?? container.decodeIfPresent(String.self, forKey: .reflectionQuestion)
            ?? "What was one important detail from the story or problems you just finished?"
        skillsPracticed = try container.decode([String].self, forKey: .skillsPracticed)
        difficultyLevel = try container.decodeIfPresent(DifficultyLevel.self, forKey: .difficultyLevel)
            ?? DifficultyLevel(readingLevel: readingLevel)
        estimatedMinutes = try container.decodeIfPresent(Int.self, forKey: .estimatedMinutes)
            ?? LessonDifficultyRules.estimatedMinutes(for: readingLevel)
        let decodedCategory = try container.decodeIfPresent(LessonCategory.self, forKey: .category)
        let decodedTeaser = try container.decodeIfPresent(String.self, forKey: .teaser)
        let decodedDifficultyLabel = try container.decodeIfPresent(String.self, forKey: .difficultyLabel)

        let decodedSections = try container.decodeIfPresent([LessonSection].self, forKey: .sections) ?? []

        let legacyVocab = try container.decodeIfPresent(String.self, forKey: .vocabularyWord) ?? ""
        let legacyVocabDef = try container.decodeIfPresent(String.self, forKey: .vocabularyDefinition) ?? ""
        let legacyFact = try container.decodeIfPresent(String.self, forKey: .knowledgeFact)
            ?? container.decodeIfPresent(String.self, forKey: .scienceFact) ?? ""
        var resolvedCreative = try container.decodeIfPresent(String.self, forKey: .creativePrompt) ?? ""

        // Resolve creative/reflection response types early (needed by legacySections).
        let decodedCreativeType = try container.decodeIfPresent(String.self, forKey: .creativeResponseType)
            .flatMap(QuestionResponseType.init(rawValue:))
        let decodedReflectionType = try container.decodeIfPresent(String.self, forKey: .reflectionResponseType)
            .flatMap(QuestionResponseType.init(rawValue:))

        let explicitOpening = try container.decodeIfPresent(String.self, forKey: .storyOpening)
            ?? container.decodeIfPresent(String.self, forKey: .storySetup)
        let explicitMission = try container.decodeIfPresent(String.self, forKey: .missionPrompt)
        let explicitPassage = try container.decodeIfPresent(String.self, forKey: .readingPassage)
        let explicitQuestions = try container.decodeIfPresent([LessonQuestion].self, forKey: .questions)
        let explicitMath = try container.decodeIfPresent([LessonQuestion].self, forKey: .mathChallenges)
        let explicitEnding = try container.decodeIfPresent(String.self, forKey: .storyEnding)

        let decodedVocabWords = try container.decodeIfPresent([VocabularyWord].self, forKey: .vocabularyWords) ?? []
        let decodedFacts = try container.decodeIfPresent([KnowledgeFact].self, forKey: .knowledgeFacts) ?? []

        // Peek creative from sections if needed before type resolution.
        if resolvedCreative.isEmpty,
           let creative = Self.sectionQuestions(decodedSections, type: .creativePrompt).first {
            resolvedCreative = creative.prompt
        }

        let resolvedCreativeType = QuestionResponseTypeResolver.resolve(
            explicit: decodedCreativeType,
            questionType: .openEnded,
            subject: .creative,
            prompt: resolvedCreative,
            choices: [],
            context: .init(lessonID: id, lessonTitle: title)
        )
        let alignedCreative = QuestionResponseTypeResolver.alignedCreative(
            prompt: resolvedCreative,
            responseType: resolvedCreativeType
        )
        resolvedCreative = alignedCreative.prompt
        let resolvedReflectionType = QuestionResponseTypeResolver.resolve(
            explicit: decodedReflectionType,
            questionType: .openEnded,
            subject: .reflection,
            prompt: reflectionPrompt,
            choices: [],
            context: .init(lessonID: id, lessonTitle: title)
        )
        creativeResponseType = alignedCreative.responseType
        reflectionResponseType = resolvedReflectionType
        let resolvedOpening: String
        let resolvedMission: String
        let resolvedPassage: String
        let resolvedQuestions: [LessonQuestion]
        let resolvedMath: [LessonQuestion]
        let resolvedEnding: String
        let resolvedSections: [LessonSection]
        var resolvedVocabWords: [VocabularyWord]
        var resolvedFacts: [KnowledgeFact]

        if let opening = explicitOpening, !opening.isEmpty,
           explicitMission != nil || explicitPassage != nil || !decodedSections.isEmpty {
            resolvedOpening = opening
            resolvedMission = explicitMission ?? Self.inferMission(from: opening, lessonType: lessonType)
            resolvedPassage = explicitPassage ?? Self.sectionContent(decodedSections, type: .readingPassage) ?? ""
            resolvedQuestions = explicitQuestions ?? Self.sectionQuestions(decodedSections, type: .readingComprehension)
            resolvedMath = explicitMath ?? Self.sectionQuestions(decodedSections, type: .math)
            resolvedEnding = explicitEnding ?? Self.defaultEnding(for: theme, lessonType: lessonType)
            resolvedSections = decodedSections.isEmpty
                ? Self.legacySections(
                    storyOpening: resolvedOpening,
                    missionPrompt: resolvedMission,
                    readingPassage: resolvedPassage,
                    questions: resolvedQuestions,
                    mathChallenges: resolvedMath,
                    vocabularyWords: decodedVocabWords,
                    knowledgeFacts: decodedFacts,
                    creativePrompt: resolvedCreative,
                    creativeResponseType: resolvedCreativeType,
                    reflectionPrompt: reflectionPrompt,
                    reflectionResponseType: resolvedReflectionType
                )
                : decodedSections
        } else if !decodedSections.isEmpty {
            resolvedOpening = Self.sectionContent(decodedSections, type: .storySetup) ?? ""
            resolvedMission = Self.inferMission(from: resolvedOpening, lessonType: lessonType)
            resolvedPassage = Self.sectionContent(decodedSections, type: .readingPassage) ?? ""
            resolvedQuestions = Self.sectionQuestions(decodedSections, type: .readingComprehension)
            resolvedMath = Self.sectionQuestions(decodedSections, type: .math)
            resolvedEnding = explicitEnding ?? Self.defaultEnding(for: theme, lessonType: lessonType)
            resolvedSections = decodedSections
        } else {
            resolvedOpening = explicitOpening ?? ""
            resolvedMission = explicitMission ?? Self.inferMission(from: resolvedOpening, lessonType: lessonType)
            resolvedPassage = explicitPassage ?? ""
            resolvedQuestions = explicitQuestions ?? []
            resolvedMath = explicitMath ?? []
            resolvedEnding = explicitEnding ?? Self.defaultEnding(for: theme, lessonType: lessonType)
            resolvedSections = Self.legacySections(
                storyOpening: resolvedOpening,
                missionPrompt: resolvedMission,
                readingPassage: resolvedPassage,
                questions: resolvedQuestions,
                mathChallenges: resolvedMath,
                vocabularyWords: decodedVocabWords,
                knowledgeFacts: decodedFacts,
                creativePrompt: resolvedCreative,
                creativeResponseType: resolvedCreativeType,
                reflectionPrompt: reflectionPrompt,
                reflectionResponseType: resolvedReflectionType
            )
        }

        if !decodedVocabWords.isEmpty {
            resolvedVocabWords = decodedVocabWords
        } else if !legacyVocab.isEmpty {
            resolvedVocabWords = Self.enrichVocabulary(
                primary: VocabularyWord(word: legacyVocab, definition: legacyVocabDef),
                theme: theme,
                passage: resolvedPassage,
                level: readingLevel
            )
        } else if let vocab = Self.sectionContent(resolvedSections, type: .vocabulary) {
            let parts = vocab.split(separator: ":", maxSplits: 1).map(String.init)
            let word = parts.first?.trimmingCharacters(in: .whitespaces) ?? ""
            let def = parts.count > 1 ? parts[1].trimmingCharacters(in: .whitespaces) : ""
            resolvedVocabWords = Self.enrichVocabulary(
                primary: VocabularyWord(word: word, definition: def),
                theme: theme,
                passage: resolvedPassage,
                level: readingLevel
            )
        } else {
            resolvedVocabWords = []
        }

        if !decodedFacts.isEmpty {
            resolvedFacts = decodedFacts
        } else if !legacyFact.isEmpty {
            resolvedFacts = [KnowledgeFact(fact: legacyFact)]
        } else if let fact = Self.sectionContent(resolvedSections, type: .scienceFact) {
            resolvedFacts = [KnowledgeFact(fact: fact)]
        } else {
            resolvedFacts = []
        }

        storyOpening = resolvedOpening
        missionPrompt = resolvedMission
        readingPassage = resolvedPassage
        questions = resolvedQuestions
        mathChallenges = resolvedMath
        vocabularyWords = resolvedVocabWords
        knowledgeFacts = resolvedFacts
        creativePrompt = resolvedCreative
        storyEnding = resolvedEnding
        sections = resolvedSections

        category = decodedCategory ?? LessonCategory.infer(
            lessonType: lessonType,
            learningGoal: learningGoal,
            title: title,
            mathSkill: mathSkill
        )
        if let decodedTeaser, !decodedTeaser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            teaser = decodedTeaser
        } else {
            teaser = Self.makeTeaser(from: resolvedMission, fallback: resolvedOpening)
        }
        difficultyLabel = decodedDifficultyLabel ?? difficultyLevel.rawValue

        primaryTopicId = try container.decodeIfPresent(String.self, forKey: .primaryTopicId)
        supportingTopicIds = try container.decodeIfPresent([String].self, forKey: .supportingTopicIds) ?? []
        prerequisiteTopicIds = try container.decodeIfPresent([String].self, forKey: .prerequisiteTopicIds) ?? []
        curriculumSubject = try container.decodeIfPresent(String.self, forKey: .curriculumSubject)
            ?? container.decodeIfPresent(String.self, forKey: .subject)
        curriculumDomain = try container.decodeIfPresent(String.self, forKey: .curriculumDomain)
            ?? container.decodeIfPresent(String.self, forKey: .domain)
        curriculumDifficulty = try container.decodeIfPresent(String.self, forKey: .curriculumDifficulty)
            ?? container.decodeIfPresent(String.self, forKey: .difficulty)
        recommendedAgeRange = try container.decodeIfPresent(String.self, forKey: .recommendedAgeRange)
        learningObjectives = try container.decodeIfPresent([String].self, forKey: .learningObjectives) ?? []
        evidenceTargets = try container.decodeIfPresent([String].self, forKey: .evidenceTargets) ?? []
        drawingQuestGoals = try container.decodeIfPresent([String].self, forKey: .drawingQuestGoals) ?? []
        standardSkillId = try container.decodeIfPresent(String.self, forKey: .standardSkillId)
        contentApprovalStatus = try container.decodeIfPresent(ContentApprovalStatus.self, forKey: .contentApprovalStatus) ?? .legacyBundled
        hints = try container.decodeIfPresent([String].self, forKey: .hints) ?? []
        commonMistakes = try container.decodeIfPresent([String].self, forKey: .commonMistakes) ?? []
        successCriteria = try container.decodeIfPresent([String].self, forKey: .successCriteria) ?? []
        intendedReadingBand = try container.decodeIfPresent(String.self, forKey: .intendedReadingBand)
        measuredReadingEstimate = try container.decodeIfPresent(Int.self, forKey: .measuredReadingEstimate)
        readingMeasurementProvider = try container.decodeIfPresent(String.self, forKey: .readingMeasurementProvider)

        let decodedPrimarySubject = try container.decodeIfPresent(PrimarySubject.self, forKey: .primarySubject)
        primarySubject = decodedPrimarySubject
            ?? PrimarySubject.fromCurriculumSubject(curriculumSubject)
            ?? PrimarySubject.from(category: category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(theme, forKey: .theme)
        try container.encode(lessonType, forKey: .lessonType)
        try container.encode(storyOpening, forKey: .storyOpening)
        try container.encode(missionPrompt, forKey: .missionPrompt)
        try container.encode(readingPassage, forKey: .readingPassage)
        try container.encode(questions, forKey: .questions)
        try container.encode(mathChallenges, forKey: .mathChallenges)
        try container.encode(vocabularyWords, forKey: .vocabularyWords)
        try container.encode(knowledgeFacts, forKey: .knowledgeFacts)
        try container.encode(creativePrompt, forKey: .creativePrompt)
        try container.encode(creativeResponseType, forKey: .creativeResponseType)
        try container.encode(storyEnding, forKey: .storyEnding)
        try container.encode(ageTarget, forKey: .ageTarget)
        try container.encode(gradeTarget, forKey: .gradeTarget)
        try container.encode(readingLevel, forKey: .readingLevel)
        try container.encode(mathLevel, forKey: .mathLevel)
        try container.encode(learningGoal, forKey: .learningGoal)
        try container.encode(difficultyLevel, forKey: .difficultyLevel)
        try container.encode(estimatedMinutes, forKey: .estimatedMinutes)
        try container.encode(readingSkill, forKey: .readingSkill)
        try container.encode(mathSkill, forKey: .mathSkill)
        try container.encode(reflectionPrompt, forKey: .reflectionPrompt)
        try container.encode(reflectionResponseType, forKey: .reflectionResponseType)
        try container.encode(sections, forKey: .sections)
        try container.encode(skillsPracticed, forKey: .skillsPracticed)
        try container.encode(category, forKey: .category)
        try container.encode(primarySubject, forKey: .primarySubject)
        try container.encode(teaser, forKey: .teaser)
        try container.encode(difficultyLabel, forKey: .difficultyLabel)
        try container.encodeIfPresent(standardSkillId, forKey: .standardSkillId)
        try container.encode(contentApprovalStatus, forKey: .contentApprovalStatus)
        try container.encode(hints, forKey: .hints)
        try container.encode(commonMistakes, forKey: .commonMistakes)
        try container.encode(successCriteria, forKey: .successCriteria)
        try container.encodeIfPresent(intendedReadingBand, forKey: .intendedReadingBand)
        try container.encodeIfPresent(measuredReadingEstimate, forKey: .measuredReadingEstimate)
        try container.encodeIfPresent(readingMeasurementProvider, forKey: .readingMeasurementProvider)
        try container.encodeIfPresent(primaryTopicId, forKey: .primaryTopicId)
        try container.encode(supportingTopicIds, forKey: .supportingTopicIds)
        try container.encode(prerequisiteTopicIds, forKey: .prerequisiteTopicIds)
        try container.encodeIfPresent(curriculumSubject, forKey: .curriculumSubject)
        try container.encodeIfPresent(curriculumDomain, forKey: .curriculumDomain)
        try container.encodeIfPresent(curriculumDifficulty, forKey: .curriculumDifficulty)
        try container.encodeIfPresent(recommendedAgeRange, forKey: .recommendedAgeRange)
        try container.encode(learningObjectives, forKey: .learningObjectives)
        try container.encode(evidenceTargets, forKey: .evidenceTargets)
        try container.encode(drawingQuestGoals, forKey: .drawingQuestGoals)
    }

    // MARK: - Helpers

    static let placeholderQuestion = LessonQuestion(
        subject: .reading,
        type: .multipleChoice,
        responseType: .multipleChoice,
        prompt: "What happened in the story?",
        choices: ["The hero solved a problem", "The hero ignored every clue", "The hero left before the mission began"],
        correctAnswer: "The hero solved a problem",
        explanation: "Every adventure has a story!"
    )

    static let placeholderMath = LessonQuestion(
        subject: .math,
        type: .multipleChoice,
        responseType: .multipleChoice,
        prompt: "Mia collected 3 seashells on the beach. Then she found 2 more. How many seashells does Mia have now?",
        choices: ["4", "5", "6"],
        correctAnswer: "5",
        explanation: "3 + 2 = 5."
    )

    static func makeTeaser(from mission: String, fallback: String) -> String {
        let source = mission.trimmingCharacters(in: .whitespacesAndNewlines)
        let text = source.isEmpty ? fallback.trimmingCharacters(in: .whitespacesAndNewlines) : source
        guard !text.isEmpty else {
            return "A fun learning adventure awaits!"
        }
        if text.count <= 120 { return ChildFacingProseQualityValidator.polish(text) }
        if let period = text.firstIndex(of: ".") {
            let sentence = String(text[...period]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !sentence.isEmpty { return ChildFacingProseQualityValidator.polish(sentence) }
        }
        return "A fun learning adventure awaits!"
    }

    static func enrichVocabulary(
        primary: VocabularyWord,
        theme: Topic,
        passage: String,
        level: ReadingLevel
    ) -> [VocabularyWord] {
        guard !primary.word.isEmpty else { return [] }
        let targetCount = LessonDifficultyRules.profile(for: level).vocabularyWordRange.lowerBound
        var words = [
            VocabularyWord(
                word: primary.word,
                definition: primary.definition,
                exampleSentence: primary.exampleSentence.isEmpty
                    ? "In the story, we learned about \(primary.word.lowercased())."
                    : primary.exampleSentence,
                storyConnection: primary.storyConnection.isEmpty
                    ? "This word connects to today's \(theme.rawValue.lowercased()) adventure."
                    : primary.storyConnection
            )
        ]

        let def = TopicLibrary.definition(for: theme)
        let extras = def.vocabularyWords
            .filter { $0.lowercased() != primary.word.lowercased() }
            .prefix(max(0, targetCount - 1))

        for extra in extras {
            words.append(
                VocabularyWord(
                    word: extra,
                    definition: TopicLibrary.vocabularyDefinition(for: extra, topic: theme),
                    exampleSentence: "You might spot \(extra.lowercased()) in this story.",
                    storyConnection: passage.contains(extra)
                        ? "\(extra) appears in today's reading passage."
                        : "This word helps you talk about \(theme.rawValue.lowercased())."
                )
            )
        }
        return Array(words.prefix(LessonDifficultyRules.profile(for: level).vocabularyWordRange.upperBound))
    }

    private static func sectionContent(_ sections: [LessonSection], type: LessonSectionType) -> String? {
        sections.first { $0.type == type }?.content.nilIfEmpty
    }

    private static func sectionQuestions(_ sections: [LessonSection], type: LessonSectionType) -> [LessonQuestion] {
        sections.first { $0.type == type }?.questions ?? []
    }

    private static func inferMission(from opening: String, lessonType: LessonType) -> String {
        let trimmed = opening.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return lessonType.introPhrase }
        if let sentence = trimmed.split(separator: ".").map(String.init).dropFirst().first {
            let cleaned = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            let withPeriod = cleaned.hasSuffix(".") ? cleaned : cleaned + "."
            return ChildFacingProseQualityValidator.polish(withPeriod)
        }
        return "Your mission: read carefully, solve the puzzles, and help save the day!"
    }

    private static func defaultEnding(for theme: Topic, lessonType: LessonType) -> String {
        let topic = TopicLibrary.definition(for: theme).name
        switch lessonType {
        case .rescue: return "You helped save the day in the \(topic.lowercased()) world. Heroes like you make a difference!"
        case .mystery, .detective: return "Mystery solved! Your sharp thinking cracked the \(topic.lowercased()) case."
        case .spaceMission: return "Mission accomplished! The \(topic.lowercased()) crew is proud of you."
        default: return "You explored the \(topic.lowercased()) world and learned something wonderful today."
        }
    }

    private static func legacySections(
        storyOpening: String,
        missionPrompt: String,
        readingPassage: String,
        questions: [LessonQuestion],
        mathChallenges: [LessonQuestion],
        vocabularyWords: [VocabularyWord],
        knowledgeFacts: [KnowledgeFact],
        creativePrompt: String,
        creativeResponseType: QuestionResponseType,
        reflectionPrompt: String,
        reflectionResponseType: QuestionResponseType
    ) -> [LessonSection] {
        let vocabContent = vocabularyWords.map { "\($0.word): \($0.definition)" }.joined(separator: "\n")
        let factContent = knowledgeFacts.map(\.fact).joined(separator: "\n")
        return [
            LessonSection(type: .storySetup, title: "The Story Begins", content: storyOpening),
            LessonSection(type: .readingPassage, title: "Read Along", content: readingPassage),
            LessonSection(type: .readingComprehension, title: "Story Clues", questions: questions),
            LessonSection(type: .math, title: "Math Challenges", questions: mathChallenges),
            LessonSection(type: .vocabulary, title: "Treasure Words", content: vocabContent),
            LessonSection(type: .scienceFact, title: "Did You Know?", content: factContent),
            LessonSection(
                type: .creativePrompt,
                title: "Imagine & Create",
                content: "Use your imagination — every idea counts!",
                questions: [LessonQuestion(
                    subject: .creative,
                    type: .openEnded,
                    responseType: creativeResponseType,
                    prompt: creativePrompt
                )]
            ),
            LessonSection(
                type: .reflection,
                title: "Think About It",
                content: reflectionPrompt,
                questions: [LessonQuestion(
                    subject: .reflection,
                    type: .openEnded,
                    responseType: reflectionResponseType,
                    prompt: reflectionPrompt
                )]
            )
        ]
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
