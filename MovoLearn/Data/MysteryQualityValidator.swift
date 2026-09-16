import Foundation

/// Validates progressive, evidence-based mystery questions.
/// Rejects “what am I” riddles solved by one giveaway word and unrelated clue lists.
enum MysteryQualityValidator {

    enum Issue: Equatable, CustomStringConvertible {
        case answerObviousFromFirstClue
        case clueNamesAnswer(String)
        case cluesUnrelated
        case tooFewClues(Int)
        case tooFewChoices(Int)
        case distractorsNotPlausible
        case answerContradictsClue
        case insufficientEvidence
        case absurdDistractor(String)
        case mysteryUnrelatedToLesson
        case solutionNeedsUntaughtKnowledge
        case confusingWording
        case fakeMysteryRecall
        case giveawayInSetup
        case missingMysteryStructure

        var description: String {
            switch self {
            case .answerObviousFromFirstClue:
                return "Mystery answer is obvious from the first clue alone."
            case .clueNamesAnswer(let clue):
                return "A clue directly names the answer: \"\(clue)\"."
            case .cluesUnrelated:
                return "Clues do not form a connected evidence chain for one question."
            case .tooFewClues(let count):
                return "Progressive mysteries need at least 2 clues (found \(count))."
            case .tooFewChoices(let count):
                return "Mystery needs at least 2 plausible choices (found \(count))."
            case .distractorsNotPlausible:
                return "Wrong answers must stay plausible until later clues narrow them."
            case .answerContradictsClue:
                return "Correct answer contradicts one or more clues."
            case .insufficientEvidence:
                return "Clues do not provide enough evidence to support the solution."
            case .absurdDistractor(let choice):
                return "Absurd or joke distractor: \"\(choice)\"."
            case .mysteryUnrelatedToLesson:
                return "Mystery does not connect to the lesson story or topic."
            case .solutionNeedsUntaughtKnowledge:
                return "Solution requires knowledge never taught in the lesson."
            case .confusingWording:
                return "Mystery wording is confusing or unnatural for children."
            case .fakeMysteryRecall:
                return "This is a recall question labeled as a mystery/clue, not real evidence work."
            case .giveawayInSetup:
                return "Mystery setup names or spoils the answer."
            case .missingMysteryStructure:
                return "Clue-style prompt is missing progressive clues and a clear setup."
            }
        }
    }

    struct Result {
        let issues: [Issue]
        var isValid: Bool { issues.isEmpty }
    }

    static func shouldValidateAsMystery(_ question: LessonQuestion) -> Bool {
        if question.isProgressiveMystery { return true }
        if question.mysteryKind != nil { return true }
        if !question.clues.isEmpty { return true }
        return looksLikeClueRiddle(question.prompt)
    }

    static func validate(
        _ question: LessonQuestion,
        topic: Topic? = nil,
        passage: String = "",
        lessonTitle: String = ""
    ) -> Result {
        var issues: [Issue] = []

        guard shouldValidateAsMystery(question) else {
            return Result(issues: [])
        }

        let clues = question.clues
        let setup = question.mysterySetup ?? ""
        let prompt = question.prompt
        let correct = (question.correctAnswer ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let choices = question.choices

        if clues.count < 2 {
            if looksLikeClueRiddle(prompt) || question.mysteryKind != nil {
                issues.append(.missingMysteryStructure)
                issues.append(.tooFewClues(clues.count))
            }
            return Result(issues: issues)
        }

        if choices.count < 2 {
            issues.append(.tooFewChoices(choices.count))
        }

        if looksLikeFakeMysteryRecall(prompt) {
            issues.append(.fakeMysteryRecall)
        }

        if wordingIsConfusing(prompt) || clues.contains(where: wordingIsConfusing) {
            issues.append(.confusingWording)
        }

        if !correct.isEmpty {
            if clueDirectlyNamesAnswer(setup, answer: correct) {
                issues.append(.giveawayInSetup)
            }
            for clue in clues {
                if clueDirectlyNamesAnswer(clue, answer: correct) {
                    issues.append(.clueNamesAnswer(clue))
                }
            }
            if firstClueSolvesAlone(clues: clues, answer: correct, choices: choices) {
                issues.append(.answerObviousFromFirstClue)
            }
            if cluesContradictAnswer(clues: clues, answer: correct) {
                issues.append(.answerContradictsClue)
            }
            if !cluesProvideEnoughEvidence(clues: clues, answer: correct, choices: choices) {
                issues.append(.insufficientEvidence)
            }
        }

        if cluesSeemUnrelated(clues) {
            issues.append(.cluesUnrelated)
        }

        for choice in choices where choice != correct {
            if isAbsurdDistractor(choice, topic: topic) {
                issues.append(.absurdDistractor(choice))
            }
        }

        if choices.count >= 3, !hasCompetingPlausibleOptions(choices: choices, correct: correct, firstClues: Array(clues.prefix(2))) {
            issues.append(.distractorsNotPlausible)
        }

        if let topic, !mysteryRelatesToLesson(question, topic: topic, passage: passage, lessonTitle: lessonTitle) {
            issues.append(.mysteryUnrelatedToLesson)
        }

        if !passage.isEmpty, solutionNeedsUntaughtKnowledge(answer: correct, passage: passage, clues: clues, setup: setup) {
            // Soft: only flag when answer tokens are absent from both passage and clues entirely
            // and answer is a proper noun / specific label not supported by evidence words.
            if !evidenceMentionsAnswerSupport(answer: correct, passage: passage, clues: clues + [setup, prompt]) {
                issues.append(.solutionNeedsUntaughtKnowledge)
            }
        }

        return Result(issues: issues)
    }

    // MARK: - Heuristics

    private static func looksLikeClueRiddle(_ prompt: String) -> Bool {
        let lower = prompt.lowercased()
        let patterns = [
            "what am i",
            "who am i",
            "i have ",
            "i live in",
            "guess what",
            "which animal am i",
            "clue:",
            "clue a",
            "clue 1",
            "follow the clue"
        ]
        return patterns.contains { lower.contains($0) }
    }

    private static func looksLikeFakeMysteryRecall(_ prompt: String) -> Bool {
        let lower = prompt.lowercased()
        let fake = [
            "what does clue",
            "what is clue",
            "where does clue",
            "what did clue",
            "what helped solve the mystery"
        ]
        return fake.contains { lower.contains($0) }
    }

    private static func wordingIsConfusing(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < 8 { return true }
        if trimmed.contains("{{") { return true }
        if trimmed.filter(\.isLetter).count < 4 { return true }
        return false
    }

    private static func normalizedTokens(_ text: String) -> Set<String> {
        let separators = CharacterSet.alphanumerics.inverted
        return Set(
            text.lowercased()
                .components(separatedBy: separators)
                .filter { $0.count > 2 }
        )
    }

    private static func clueDirectlyNamesAnswer(_ text: String, answer: String) -> Bool {
        let lower = text.lowercased()
        let answerLower = answer.lowercased()
        // Whole-word-ish checks for key answer tokens longer than 3 chars.
        let answerTokens = normalizedTokens(answer).filter { $0.count > 3 }
        if answerTokens.isEmpty {
            return lower.contains(answerLower) && answerLower.count > 3
        }
        // "The animal is a reef shark" / "known as a reef shark"
        let giveawayPhrases = ["is a ", "is an ", "known as", "called a", "called an", "the answer is"]
        if giveawayPhrases.contains(where: { lower.contains($0) }) {
            return answerTokens.contains { lower.contains($0) }
        }
        // Clue that is basically just the answer label.
        if normalizedTokens(text).isSubset(of: answerTokens.union(["the", "a", "an", "animal"])) {
            return true
        }
        return false
    }

    private static func firstClueSolvesAlone(clues: [String], answer: String, choices: [String]) -> Bool {
        guard let first = clues.first else { return false }
        let firstTokens = normalizedTokens(first)
        let answerTokens = normalizedTokens(answer)
        // If the first clue already contains distinctive answer tokens that no distractor shares, it's a giveaway.
        let distinctive = answerTokens.subtracting(choices.filter { $0 != answer }.flatMap { normalizedTokens($0) })
        if !distinctive.isEmpty, distinctive.isSubset(of: firstTokens) {
            return true
        }
        // Classic "I have fins and live in the ocean" style: very short + contains identity keywords for ocean animals.
        if first.count < 55, looksLikeClueRiddle(first) {
            return true
        }
        return false
    }

    private static func cluesContradictAnswer(clues: [String], answer: String) -> Bool {
        let joined = clues.joined(separator: " ").lowercased()
        let answerLower = answer.lowercased()
        // Simple negation check: "not a shark" while answer is shark
        for token in normalizedTokens(answer) where token.count > 3 {
            if joined.contains("not a \(token)") || joined.contains("not an \(token)") || joined.contains("isn't a \(token)") {
                return true
            }
        }
        _ = answerLower
        return false
    }

    private static func cluesProvideEnoughEvidence(clues: [String], answer: String, choices: [String]) -> Bool {
        // Need either 3+ clues or 2 clues with substantial combined length and answer support words.
        let combined = clues.joined(separator: " ")
        if clues.count >= 3, combined.count >= 80 { return true }
        if clues.count >= 2, combined.count >= 100 { return true }
        // Number mysteries can be shorter.
        if normalizedTokens(answer).contains(where: { Int($0) != nil }) { return combined.count >= 40 }
        return combined.count >= 70
    }

    private static func cluesSeemUnrelated(_ clues: [String]) -> Bool {
        guard clues.count >= 3 else { return false }
        // If pairwise token overlap is near-zero across all pairs, treat as unrelated grab-bag.
        var overlaps = 0
        var pairs = 0
        for i in 0..<clues.count {
            for j in (i + 1)..<clues.count {
                pairs += 1
                let a = normalizedTokens(clues[i])
                let b = normalizedTokens(clues[j])
                if !a.intersection(b).isEmpty { overlaps += 1 }
            }
        }
        return pairs > 0 && overlaps == 0
    }

    private static func isAbsurdDistractor(_ choice: String, topic: Topic?) -> Bool {
        let lower = choice.lowercased()
        let absurd = ["toaster", "pizza", "banana", "spaceship", "castle", "phone", "sandwich", "grocery", "sock", "television"]
        if absurd.contains(where: { lower.contains($0) }) {
            // Allow castle/spaceship when topic matches.
            if let topic {
                let name = topic.rawValue.lowercased()
                if lower.contains("castle"), name.contains("castle") || name.contains("princess") { return false }
                if lower.contains("spaceship"), name.contains("space") || name.contains("rocket") { return false }
            }
            return true
        }
        return false
    }

    private static func hasCompetingPlausibleOptions(choices: [String], correct: String, firstClues: [String]) -> Bool {
        // At least one distractor should share a semantic neighborhood with early clues (same broad domain).
        let early = normalizedTokens(firstClues.joined(separator: " "))
        let distractors = choices.filter { $0 != correct }
        return distractors.contains { choice in
            !normalizedTokens(choice).intersection(early).isEmpty || choice.split(separator: " ").count <= 4
        }
    }

    private static func mysteryRelatesToLesson(
        _ question: LessonQuestion,
        topic: Topic,
        passage: String,
        lessonTitle: String
    ) -> Bool {
        let blob = ([question.mysterySetup, question.prompt] + question.clues + [passage, lessonTitle])
            .compactMap { $0 }
            .joined(separator: " ")
            .lowercased()
        let topicTokens = normalizedTokens(topic.rawValue)
        if topicTokens.contains(where: { blob.contains($0) }) { return true }
        // Theme-adjacent words
        let neighbors: [Topic: [String]] = [
            .sharks: ["reef", "ocean", "fin", "fish", "marine", "coral"],
            .space: ["moon", "astronaut", "gravity", "suit", "boot"],
            .dogs: ["leash", "fetch", "park", "puppy", "retriever"],
            .cats: ["whisker", "yarn", "purr", "curtain", "sofa"],
            .bugs: ["leaf", "caterpillar", "bee", "garden", "legs"],
            .weather: ["rain", "cloud", "storm", "radar", "pressure"],
            .fairies: ["glade", "firefly", "mushroom", "fern", "dew"],
            .pirates: ["map", "palm", "compass", "treasure", "steps"],
            .castles: ["passage", "library", "stone", "fortress", "map"]
        ]
        if let words = neighbors[topic], words.contains(where: { blob.contains($0) }) {
            return true
        }
        return blob.count > 40
    }

    private static func evidenceMentionsAnswerSupport(
        answer: String,
        passage: String,
        clues: [String]
    ) -> Bool {
        let blob = (clues + [passage]).joined(separator: " ").lowercased()
        let tokens = normalizedTokens(answer).filter { $0.count > 3 }
        if tokens.isEmpty { return true }
        // Support can be synonymous evidence rather than the answer word itself.
        return tokens.contains { blob.contains($0) } || blob.count > 120
    }

    private static func solutionNeedsUntaughtKnowledge(
        answer: String,
        passage: String,
        clues: [String],
        setup: String
    ) -> Bool {
        evidenceMentionsAnswerSupport(answer: answer, passage: passage, clues: clues + [setup]) == false
            && normalizedTokens(answer).contains { $0.count > 5 }
    }
}
