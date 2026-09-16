import Foundation

struct ProgressSummary: Codable {
    let totalQuestions: Int
    let correctAnswers: Int
    let accuracy: Double
    let topicsPracticed: [Topic]
    let skillsPracticed: [String]
    let lessonTitle: String
    let lessonType: LessonType
    let category: LessonCategory
    let readingSkill: String
    let mathSkill: String
    let vocabularyWord: String
    let vocabularyDefinition: String
    let scienceFact: String
    let creativePrompt: String
    let storyEnding: String
    let missionCompleteMessage: String
    let completedAt: Date

    var accuracyPercentage: Int {
        Int((accuracy * 100).rounded())
    }

    var topic: Topic? {
        topicsPracticed.first
    }

    init(
        totalQuestions: Int,
        correctAnswers: Int,
        topicsPracticed: [Topic],
        skillsPracticed: [String],
        lessonTitle: String,
        lessonType: LessonType = .explorer,
        category: LessonCategory? = nil,
        readingSkill: String = "",
        mathSkill: String = "",
        vocabularyWord: String = "",
        vocabularyDefinition: String = "",
        scienceFact: String = "",
        creativePrompt: String = "",
        storyEnding: String = "",
        missionCompleteMessage: String = "",
        completedAt: Date = Date()
    ) {
        self.totalQuestions = totalQuestions
        self.correctAnswers = correctAnswers
        self.accuracy = totalQuestions > 0 ? Double(correctAnswers) / Double(totalQuestions) : 0
        self.topicsPracticed = topicsPracticed
        self.skillsPracticed = skillsPracticed
        self.lessonTitle = lessonTitle
        self.lessonType = lessonType
        self.category = category ?? LessonCategory.inferred(from: lessonType, learningGoal: .allAround, title: lessonTitle, skills: skillsPracticed)
        self.readingSkill = readingSkill
        self.mathSkill = mathSkill
        self.vocabularyWord = vocabularyWord
        self.vocabularyDefinition = vocabularyDefinition
        self.scienceFact = scienceFact
        self.creativePrompt = creativePrompt
        self.storyEnding = storyEnding
        self.missionCompleteMessage = missionCompleteMessage.isEmpty
            ? Self.shortHeadline(from: storyEnding)
            : missionCompleteMessage
        self.completedAt = completedAt
    }

    init(from lesson: Lesson, totalQuestions: Int, correctAnswers: Int) {
        let recap = LessonRecap(lesson: lesson)
        self.init(
            totalQuestions: totalQuestions,
            correctAnswers: correctAnswers,
            topicsPracticed: [lesson.theme],
            skillsPracticed: recap.skillTags,
            lessonTitle: lesson.title,
            lessonType: lesson.lessonType,
            category: lesson.category,
            readingSkill: recap.readingSkill,
            mathSkill: recap.mathSkill,
            vocabularyWord: recap.vocabularyWord,
            vocabularyDefinition: recap.vocabularyDefinition,
            scienceFact: recap.scienceFact,
            creativePrompt: recap.creativeNote,
            storyEnding: lesson.storyEnding,
            missionCompleteMessage: recap.headline
        )
    }

    /// One line for what this lesson actually practiced — not a dump of every attached field.
    var practicedFocus: String {
        switch category {
        case .math:
            return mathSkill.isEmpty ? "Math" : mathSkill
        case .story:
            return readingSkill.isEmpty ? "Reading" : readingSkill
        case .discovery:
            return readingSkill.isEmpty ? "Science" : readingSkill
        case .creative:
            return "Creative expression"
        }
    }

    var completionHeadline: String {
        let trimmed = missionCompleteMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        return Self.shortHeadline(from: storyEnding)
    }

    static func shortHeadline(from storyEnding: String) -> String {
        let trimmed = storyEnding.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "You finished today's adventure!" }
        var ending = trimmed
        if ending.lowercased().hasPrefix("mission complete") {
            if let bang = ending.firstIndex(of: "!") {
                ending = ending[ending.index(after: bang)...].trimmingCharacters(in: .whitespaces)
            }
        }
        if let cut = ending.firstIndex(where: { ".!?".contains($0) }) {
            let sentence = String(ending[...cut]).trimmingCharacters(in: .whitespaces)
            if (8...90).contains(sentence.count) {
                return ChildFacingProseQualityValidator.polish(sentence)
            }
        }
        if ending.count <= 90 { return ChildFacingProseQualityValidator.polish(ending) }
        return "You finished today's adventure!"
    }

    enum CodingKeys: String, CodingKey {
        case totalQuestions, correctAnswers, accuracy, topicsPracticed, skillsPracticed
        case lessonTitle, lessonType, category, readingSkill, mathSkill, vocabularyWord
        case vocabularyDefinition, scienceFact, creativePrompt, storyEnding, missionCompleteMessage, completedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalQuestions = try container.decode(Int.self, forKey: .totalQuestions)
        correctAnswers = try container.decode(Int.self, forKey: .correctAnswers)
        accuracy = try container.decodeIfPresent(Double.self, forKey: .accuracy)
            ?? (totalQuestions > 0 ? Double(correctAnswers) / Double(totalQuestions) : 0)
        topicsPracticed = try container.decode([Topic].self, forKey: .topicsPracticed)
        skillsPracticed = try container.decode([String].self, forKey: .skillsPracticed)
        lessonTitle = try container.decode(String.self, forKey: .lessonTitle)
        lessonType = try container.decodeIfPresent(LessonType.self, forKey: .lessonType) ?? .explorer
        category = try container.decodeIfPresent(LessonCategory.self, forKey: .category)
            ?? LessonCategory.inferred(from: lessonType, learningGoal: .allAround, title: lessonTitle, skills: skillsPracticed)
        readingSkill = try container.decodeIfPresent(String.self, forKey: .readingSkill) ?? ""
        mathSkill = try container.decodeIfPresent(String.self, forKey: .mathSkill) ?? ""
        vocabularyWord = try container.decodeIfPresent(String.self, forKey: .vocabularyWord) ?? ""
        vocabularyDefinition = try container.decodeIfPresent(String.self, forKey: .vocabularyDefinition) ?? ""
        scienceFact = try container.decodeIfPresent(String.self, forKey: .scienceFact) ?? ""
        creativePrompt = try container.decodeIfPresent(String.self, forKey: .creativePrompt) ?? ""
        storyEnding = try container.decodeIfPresent(String.self, forKey: .storyEnding) ?? ""
        let decodedMessage = try container.decodeIfPresent(String.self, forKey: .missionCompleteMessage) ?? ""
        if decodedMessage.isEmpty {
            missionCompleteMessage = Self.shortHeadline(from: storyEnding)
        } else if decodedMessage.lowercased().hasPrefix("mission complete") && decodedMessage.count > 90 {
            missionCompleteMessage = Self.shortHeadline(from: decodedMessage)
        } else {
            missionCompleteMessage = decodedMessage
        }
        completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt) ?? Date()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalQuestions, forKey: .totalQuestions)
        try container.encode(correctAnswers, forKey: .correctAnswers)
        try container.encode(accuracy, forKey: .accuracy)
        try container.encode(topicsPracticed, forKey: .topicsPracticed)
        try container.encode(skillsPracticed, forKey: .skillsPracticed)
        try container.encode(lessonTitle, forKey: .lessonTitle)
        try container.encode(lessonType, forKey: .lessonType)
        try container.encode(category, forKey: .category)
        try container.encode(readingSkill, forKey: .readingSkill)
        try container.encode(mathSkill, forKey: .mathSkill)
        try container.encode(vocabularyWord, forKey: .vocabularyWord)
        try container.encode(vocabularyDefinition, forKey: .vocabularyDefinition)
        try container.encode(scienceFact, forKey: .scienceFact)
        try container.encode(creativePrompt, forKey: .creativePrompt)
        try container.encode(storyEnding, forKey: .storyEnding)
        try container.encode(missionCompleteMessage, forKey: .missionCompleteMessage)
        try container.encode(completedAt, forKey: .completedAt)
    }
}

/// Category-accurate recap fields so summaries do not dump unused reading/math/vocab onto every lesson.
private struct LessonRecap {
    let readingSkill: String
    let mathSkill: String
    let vocabularyWord: String
    let vocabularyDefinition: String
    let scienceFact: String
    let creativeNote: String
    let skillTags: [String]
    let headline: String

    init(lesson: Lesson) {
        headline = ProgressSummary.shortHeadline(from: lesson.storyEnding)
        switch lesson.category {
        case .story:
            readingSkill = lesson.readingSkill
            mathSkill = ""
            vocabularyWord = lesson.vocabularyWord
            vocabularyDefinition = lesson.vocabularyDefinition
            scienceFact = ""
            creativeNote = ""
            skillTags = Self.tags(family: "Reading", specific: lesson.readingSkill, vocabulary: !lesson.vocabularyWord.isEmpty)
        case .math:
            readingSkill = ""
            mathSkill = lesson.mathSkill
            vocabularyWord = ""
            vocabularyDefinition = ""
            scienceFact = ""
            creativeNote = ""
            skillTags = Self.tags(family: "Math", specific: lesson.mathSkill, vocabulary: false)
        case .discovery:
            readingSkill = lesson.readingSkill
            mathSkill = ""
            vocabularyWord = lesson.vocabularyWord
            vocabularyDefinition = lesson.vocabularyDefinition
            scienceFact = lesson.knowledgeFact
            creativeNote = ""
            skillTags = Self.tags(family: "Science", specific: lesson.readingSkill, vocabulary: !lesson.vocabularyWord.isEmpty)
        case .creative:
            readingSkill = ""
            mathSkill = ""
            vocabularyWord = ""
            vocabularyDefinition = ""
            scienceFact = ""
            creativeNote = ""
            skillTags = ["Creative Thinking"]
        }
    }

    private static func tags(family: String, specific: String, vocabulary: Bool) -> [String] {
        var result = [family]
        let trimmed = specific.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty, trimmed.caseInsensitiveCompare(family) != .orderedSame {
            result.append(trimmed)
        }
        if vocabulary {
            result.append("Vocabulary")
        }
        return result
    }
}
