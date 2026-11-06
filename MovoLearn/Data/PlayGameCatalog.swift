import Foundation

/// Short practice rounds built only from questions a child can already see.
/// A round is offered when it includes every scored question, so finishing practice
/// does not skip comprehension or math.
enum PlayGameKind: String, Identifiable {
    case bubblePop
    case memoryMatch

    var id: String { rawValue }

    var title: String {
        switch self {
        case .bubblePop: return "Answer Practice"
        case .memoryMatch: return "Word Practice"
        }
    }

    var howToPlay: String {
        switch self {
        case .bubblePop: return "Tap the answer that fits."
        case .memoryMatch: return "Tap a card on the left, then tap its match on the right."
        }
    }
}

struct PlayGameOffer: Identifiable {
    var id: String { "\(kind.rawValue)-\(lesson.id.uuidString)" }
    let kind: PlayGameKind
    let lesson: Lesson

    /// Subject-first label so a practice round reads as a lesson, not a separate game.
    var practiceLabel: String {
        switch lesson.primarySubject {
        case .math: return "Math practice"
        case .reading: return "Reading practice"
        case .science: return "Science practice"
        case .creative: return "Word practice"
        }
    }
}

enum PlayGameCatalog {

    private static let maxBubbleChoices = 32
    private static let maxCardSide = 64

    private static let passageDependentPhrases = [
        "in the story",
        "in the passage",
        "in this passage",
        "according to the",
        "the story says",
        "from the story",
        "the passage says",
        "what did you read",
        "after reading"
    ]

    static func offers(
        from lessons: [Lesson],
        favoriteTopics: [Topic],
        completedIDs: Set<UUID> = [],
        limit: Int = 4
    ) -> [PlayGameOffer] {
        guard limit > 0 else { return [] }

        let ordered = lessons.sorted { lhs, rhs in
            let leftFavorite = favoriteTopics.contains(lhs.theme)
            let rightFavorite = favoriteTopics.contains(rhs.theme)
            if leftFavorite != rightFavorite { return leftFavorite }
            let leftDone = completedIDs.contains(lhs.id)
            let rightDone = completedIDs.contains(rhs.id)
            if leftDone != rightDone { return !leftDone }
            return lhs.title < rhs.title
        }

        var bubble: [PlayGameOffer] = []
        var memory: [PlayGameOffer] = []

        for lesson in ordered.prefix(48) {
            guard lesson.isApprovedForChildDisplay || lesson.contentApprovalStatus == .legacyBundled else { continue }
            let practice = practiceQuestions(in: lesson)
            if canOfferBubble(practice, lesson: lesson) {
                bubble.append(PlayGameOffer(kind: .bubblePop, lesson: lesson))
            }
            if canOfferMemory(lesson, practice: practice) {
                memory.append(PlayGameOffer(kind: .memoryMatch, lesson: lesson))
            }
            if bubble.count >= limit && memory.count >= 2 { break }
        }

        return mix(bubble: bubble, memory: memory, limit: limit)
    }

    /// Questions for a play round. Empty when this lesson should stay a full adventure.
    static func playQuestions(in lesson: Lesson, kind: PlayGameKind) -> [LessonQuestion] {
        let practice = practiceQuestions(in: lesson)
        switch kind {
        case .bubblePop:
            guard canOfferBubble(practice, lesson: lesson) else { return [] }
            return practice.filter { fitsBubble($0) && isSelfContained($0) }
        case .memoryMatch:
            let memory = practice.filter { fitsMemory($0) }
            if canOfferAuthoredMemory(memory, practice: practice) {
                return memory
            }
            guard canOfferVocabularyMemory(lesson, practice: practice),
                  let built = vocabularyMemoryQuestion(from: lesson) else { return [] }
            return [built]
        }
    }

    /// Short multiple choice that can bounce as bubbles inside a normal lesson.
    static func fitsBubble(_ question: LessonQuestion) -> Bool {
        guard question.displayResponseType == .multipleChoice else { return false }
        guard !question.isProgressiveMystery else { return false }
        return fitsBubble(choices: question.choices, correctAnswer: question.correctAnswer)
    }

    static func fitsBubble(choices: [String], correctAnswer: String?) -> Bool {
        guard (2...4).contains(choices.count) else { return false }
        guard choices.allSatisfy({ side in
            let trimmed = side.trimmingCharacters(in: .whitespacesAndNewlines)
            return (1...maxBubbleChoices).contains(trimmed.count)
        }) else { return false }
        guard let correctAnswer else { return false }
        return choices.contains(correctAnswer)
    }

    /// A bubble round may hide the passage, so the prompt has to carry the facts.
    static func fitsPlayableBubble(_ question: LessonQuestion) -> Bool {
        fitsBubble(question) && isSelfContained(question)
    }

    static func fitsMemory(_ question: LessonQuestion) -> Bool {
        guard question.displayResponseType == .matching else { return false }
        return fitsMemory(pairs: question.pairs)
    }

    static func fitsMemory(pairs: [MatchingPair]) -> Bool {
        guard (2...4).contains(pairs.count) else { return false }
        return pairs.allSatisfy { pair in
            let left = pair.left.trimmingCharacters(in: .whitespacesAndNewlines)
            let right = pair.right.trimmingCharacters(in: .whitespacesAndNewlines)
            return (2...maxCardSide).contains(left.count) && (2...maxCardSide).contains(right.count)
        }
    }

    // MARK: - Eligibility

    /// Math missions can become a bubble round when every math question fits.
    /// One extra story question does not block the game.
    private static func canOfferBubble(_ practice: [LessonQuestion], lesson: Lesson) -> Bool {
        let bubbles = practice.filter { fitsBubble($0) && isSelfContained($0) }
        guard (2...5).contains(bubbles.count) else { return false }
        let covered = Set(bubbles.map(\.id))
        return requiredQuestions(practice, lesson: lesson).allSatisfy { covered.contains($0.id) }
    }

    private static func requiredQuestions(_ practice: [LessonQuestion], lesson: Lesson) -> [LessonQuestion] {
        let scoredItems = scored(practice)
        if lesson.primarySubject == .math || lesson.category == .math {
            let mathItems = scoredItems.filter { $0.subject == .math }
            if !mathItems.isEmpty { return mathItems }
        }
        return scoredItems
    }

    private static func canOfferMemory(_ lesson: Lesson, practice: [LessonQuestion]) -> Bool {
        let memory = practice.filter { fitsMemory($0) }
        if canOfferAuthoredMemory(memory, practice: practice) { return true }
        return canOfferVocabularyMemory(lesson, practice: practice)
    }

    private static func canOfferAuthoredMemory(_ memory: [LessonQuestion], practice: [LessonQuestion]) -> Bool {
        guard (1...2).contains(memory.count) else { return false }
        return uncoveredScored(practice, coveredIDs: Set(memory.map(\.id))).isEmpty
    }

    /// Word cards are a full round only when the adventure has no quiz to skip, and it is not an art quest.
    private static func canOfferVocabularyMemory(_ lesson: Lesson, practice: [LessonQuestion]) -> Bool {
        guard lesson.category != .creative else { return false }
        guard !lesson.isArtQuest else { return false }
        guard scored(practice).isEmpty else { return false }
        return vocabularyPairs(from: lesson).count >= 3
    }

    private static func uncoveredScored(_ practice: [LessonQuestion], coveredIDs: Set<UUID>) -> [LessonQuestion] {
        scored(practice).filter { !coveredIDs.contains($0.id) }
    }

    private static func scored(_ practice: [LessonQuestion]) -> [LessonQuestion] {
        practice.filter { question in
            switch question.displayResponseType {
            case .multipleChoice, .number, .matching, .sorting:
                return true
            case .drawing, .shortText, .longText:
                return false
            }
        }
    }

    private static func isSelfContained(_ question: LessonQuestion) -> Bool {
        let lower = question.prompt.lowercased()
        return !passageDependentPhrases.contains(where: { lower.contains($0) })
    }

    private static func practiceQuestions(in lesson: Lesson) -> [LessonQuestion] {
        var seen = Set<UUID>()
        return (lesson.childFacingQuestions + lesson.childFacingMathChallenges).filter { seen.insert($0.id).inserted }
    }

    private static func vocabularyPairs(from lesson: Lesson) -> [MatchingPair] {
        var seen = Set<String>()
        var pairs: [MatchingPair] = []
        for word in lesson.vocabularyWords {
            let left = word.word.trimmingCharacters(in: .whitespacesAndNewlines)
            let right = word.definition.trimmingCharacters(in: .whitespacesAndNewlines)
            let key = left.lowercased()
            guard (2...24).contains(left.count), (2...maxCardSide).contains(right.count) else { continue }
            guard seen.insert(key).inserted else { continue }
            let evidence = word.exampleSentence.trimmingCharacters(in: .whitespacesAndNewlines)
            pairs.append(MatchingPair(
                left: left,
                right: right,
                supportingEvidence: evidence.isEmpty ? nil : evidence
            ))
            if pairs.count == 4 { break }
        }
        return pairs.count >= 3 ? pairs : []
    }

    private static func vocabularyMemoryQuestion(from lesson: Lesson) -> LessonQuestion? {
        let pairs = vocabularyPairs(from: lesson)
        guard pairs.count >= 3 else { return nil }
        return LessonQuestion.matching(
            subject: .vocabulary,
            prompt: "Match each word to what it means.",
            pairs: pairs,
            explanation: "These words come from this adventure."
        )
    }

    private static func mix(bubble: [PlayGameOffer], memory: [PlayGameOffer], limit: Int) -> [PlayGameOffer] {
        var result: [PlayGameOffer] = []
        var used = Set<UUID>()
        var bubbleIndex = 0
        var memoryIndex = 0
        var preferBubble = true

        func take(_ offer: PlayGameOffer) {
            guard result.count < limit, used.insert(offer.lesson.id).inserted else { return }
            result.append(offer)
        }

        while result.count < limit && (bubbleIndex < bubble.count || memoryIndex < memory.count) {
            let before = result.count
            if preferBubble, bubbleIndex < bubble.count {
                take(bubble[bubbleIndex])
                bubbleIndex += 1
            } else if memoryIndex < memory.count {
                take(memory[memoryIndex])
                memoryIndex += 1
            } else if bubbleIndex < bubble.count {
                take(bubble[bubbleIndex])
                bubbleIndex += 1
            } else {
                break
            }
            if result.count == before, bubbleIndex >= bubble.count, memoryIndex >= memory.count {
                break
            }
            preferBubble.toggle()
        }
        return result
    }
}
