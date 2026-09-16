import Foundation

enum QuestionType: String, Codable {
    case multipleChoice
    case openEnded
}

enum QuestionSubject: String, Codable {
    case reading
    case math
    case vocabulary
    case science
    case creative
    case reflection
}

struct LessonQuestion: Codable, Identifiable, Equatable {
    let id: UUID
    let subject: QuestionSubject
    let type: QuestionType
    /// Explicit UI modality. Bundled content must set this; inference is legacy-only.
    let responseType: QuestionResponseType
    /// `true` when `responseType` was inferred because it was missing from source data.
    let responseTypeWasInferred: Bool
    let prompt: String
    let choices: [String]
    let correctAnswer: String?
    let explanation: String?
    let difficultyLevel: ReadingLevel?
    /// Structured pairs for `responseType == .matching`.
    let pairs: [MatchingPair]
    /// Structured sortable items for `responseType == .sorting`.
    let items: [SortingItem]
    /// When set with 2+ `clues`, the question uses progressive mystery UI.
    let mysteryKind: MysteryKind?
    /// Scene / central problem shown before clues (does not name the answer).
    let mysterySetup: String?
    /// Progressive evidence strings, revealed one at a time.
    let clues: [String]

    /// True when this question should use the interactive clue-reveal flow.
    var isProgressiveMystery: Bool {
        clues.count >= 2 && (mysteryKind != nil || !(mysterySetup ?? "").isEmpty)
    }

    init(
        id: UUID = UUID(),
        subject: QuestionSubject = .reading,
        type: QuestionType = .multipleChoice,
        responseType: QuestionResponseType? = nil,
        prompt: String,
        choices: [String] = [],
        correctAnswer: String? = nil,
        explanation: String? = nil,
        difficultyLevel: ReadingLevel? = nil,
        pairs: [MatchingPair] = [],
        items: [SortingItem] = [],
        mysteryKind: MysteryKind? = nil,
        mysterySetup: String? = nil,
        clues: [String] = [],
        inferenceContext: QuestionResponseTypeResolver.InferenceContext = .init()
    ) {
        let normalizedPrompt = PromptWordingNormalizer.normalize(prompt)
        self.id = id
        self.subject = subject
        self.type = type
        self.prompt = normalizedPrompt
        self.choices = choices
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.difficultyLevel = difficultyLevel
        self.pairs = pairs
        self.items = items
        self.mysteryKind = mysteryKind
        self.mysterySetup = mysterySetup.map(PromptWordingNormalizer.normalize)
        self.clues = clues.map(PromptWordingNormalizer.normalize)

        var context = inferenceContext
        if context.questionID == nil {
            context.questionID = id
        }

        if let responseType {
            self.responseType = responseType
            self.responseTypeWasInferred = false
        } else {
            var inferred = false
            self.responseType = QuestionResponseTypeResolver.resolve(
                explicit: nil,
                questionType: type,
                subject: subject,
                prompt: normalizedPrompt,
                choices: choices,
                pairs: pairs,
                items: items,
                context: context,
                wasInferred: &inferred
            )
            self.responseTypeWasInferred = inferred
        }
    }

    /// Builder for progressive, evidence-based mysteries.
    static func mystery(
        id: UUID = UUID(),
        subject: QuestionSubject = .reading,
        kind: MysteryKind,
        setup: String,
        clues: [String],
        prompt: String,
        choices: [String],
        correctAnswer: String,
        explanation: String,
        difficultyLevel: ReadingLevel? = .earlyReader
    ) -> LessonQuestion {
        LessonQuestion(
            id: id,
            subject: subject,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: prompt,
            choices: choices,
            correctAnswer: correctAnswer,
            explanation: explanation,
            difficultyLevel: difficultyLevel,
            mysteryKind: kind,
            mysterySetup: setup,
            clues: clues
        )
    }

    /// Convenience builder for matching questions.
    static func matching(
        id: UUID = UUID(),
        subject: QuestionSubject = .reading,
        prompt: String,
        pairs: [MatchingPair],
        explanation: String? = nil,
        difficultyLevel: ReadingLevel? = nil
    ) -> LessonQuestion {
        LessonQuestion(
            id: id,
            subject: subject,
            type: .openEnded,
            responseType: .matching,
            prompt: prompt,
            explanation: explanation,
            difficultyLevel: difficultyLevel,
            pairs: pairs
        )
    }

    /// Convenience builder for sorting questions.
    static func sorting(
        id: UUID = UUID(),
        subject: QuestionSubject = .reading,
        prompt: String,
        items: [SortingItem],
        explanation: String? = nil,
        difficultyLevel: ReadingLevel? = nil
    ) -> LessonQuestion {
        LessonQuestion(
            id: id,
            subject: subject,
            type: .openEnded,
            responseType: .sorting,
            prompt: prompt,
            explanation: explanation,
            difficultyLevel: difficultyLevel,
            items: items
        )
    }

    enum CodingKeys: String, CodingKey {
        case id, subject, type, responseType, prompt, choices, correctAnswer, explanation, difficultyLevel
        case pairs, items
        case mysteryKind, mysterySetup, clues
        // Legacy / alternate keys from the user schema examples
        case question
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let raw = try container.decodeIfPresent(String.self, forKey: .id) {
            id = UUID(uuidString: raw) ?? UUID()
        } else {
            id = UUID()
        }
        subject = try container.decodeIfPresent(QuestionSubject.self, forKey: .subject) ?? .reading
        type = try container.decodeIfPresent(QuestionType.self, forKey: .type) ?? .multipleChoice

        if let promptValue = try container.decodeIfPresent(String.self, forKey: .prompt) {
            prompt = PromptWordingNormalizer.normalize(promptValue)
        } else if let questionValue = try container.decodeIfPresent(String.self, forKey: .question) {
            prompt = PromptWordingNormalizer.normalize(questionValue)
        } else {
            throw DecodingError.keyNotFound(
                CodingKeys.prompt,
                .init(codingPath: container.codingPath, debugDescription: "Missing prompt/question")
            )
        }

        choices = try container.decodeIfPresent([String].self, forKey: .choices) ?? []
        correctAnswer = try container.decodeIfPresent(String.self, forKey: .correctAnswer)
        explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
        difficultyLevel = try container.decodeIfPresent(ReadingLevel.self, forKey: .difficultyLevel)
        pairs = try container.decodeIfPresent([MatchingPair].self, forKey: .pairs) ?? []
        items = try container.decodeIfPresent([SortingItem].self, forKey: .items) ?? []
        mysteryKind = try container.decodeIfPresent(MysteryKind.self, forKey: .mysteryKind)
        mysterySetup = try container.decodeIfPresent(String.self, forKey: .mysterySetup).map(PromptWordingNormalizer.normalize)
        clues = (try container.decodeIfPresent([String].self, forKey: .clues) ?? []).map(PromptWordingNormalizer.normalize)

        let decodedRaw = try container.decodeIfPresent(String.self, forKey: .responseType)
        let decodedResponseType = decodedRaw.flatMap(QuestionResponseType.init(rawValue:))

        if let decodedResponseType {
            responseType = decodedResponseType
            responseTypeWasInferred = false
        } else if let decodedRaw, QuestionResponseType(rawValue: decodedRaw) == nil {
            // Unknown response type string — fall back with warning.
            #if DEBUG
            print("⚠️ Unknown responseType \"\(decodedRaw)\" for question \(id) — falling back")
            #endif
            var inferred = false
            responseType = QuestionResponseTypeResolver.resolve(
                explicit: nil,
                questionType: type,
                subject: subject,
                prompt: prompt,
                choices: choices,
                pairs: pairs,
                items: items,
                context: .init(questionID: id),
                wasInferred: &inferred
            )
            responseTypeWasInferred = true
        } else {
            var inferred = false
            responseType = QuestionResponseTypeResolver.resolve(
                explicit: nil,
                questionType: type,
                subject: subject,
                prompt: prompt,
                choices: choices,
                pairs: pairs,
                items: items,
                context: .init(questionID: id),
                wasInferred: &inferred
            )
            responseTypeWasInferred = inferred
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(subject, forKey: .subject)
        try container.encode(type, forKey: .type)
        try container.encode(responseType, forKey: .responseType)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(choices, forKey: .choices)
        try container.encodeIfPresent(correctAnswer, forKey: .correctAnswer)
        try container.encodeIfPresent(explanation, forKey: .explanation)
        try container.encodeIfPresent(difficultyLevel, forKey: .difficultyLevel)
        if !pairs.isEmpty {
            try container.encode(pairs, forKey: .pairs)
        }
        if !items.isEmpty {
            try container.encode(items, forKey: .items)
        }
        try container.encodeIfPresent(mysteryKind, forKey: .mysteryKind)
        try container.encodeIfPresent(mysterySetup, forKey: .mysterySetup)
        if !clues.isEmpty {
            try container.encode(clues, forKey: .clues)
        }
    }

    /// Effective response type for UI rendering.
    var displayResponseType: QuestionResponseType {
        QuestionResponseTypeResolver.sanitize(
            responseType,
            questionType: type,
            prompt: prompt,
            choices: choices,
            pairs: pairs,
            items: items
        )
    }

    var hasValidMatchingData: Bool { pairs.count >= 2 }
    var hasValidSortingData: Bool { items.count >= 2 }

    var correctlyOrderedItemIDs: [String] {
        items.sorted { $0.correctPosition < $1.correctPosition }.map(\.id)
    }
}
