import Foundation

/// The words a lesson page should speak. Built from the text already on screen,
/// so a read-aloud pass never announces a hidden answer.
enum LessonReadAloudScript {
    struct Page {
        var story: LessonStoryContent
        var step: LessonStep
        var lessonTitle: String
        var missionCompleteMessage: String
        var playKind: PlayGameKind?
        var showsPassageWithQuestion: Bool
        var includePassageOnReflection: Bool
        var revealedClueCount: Int
        var drawingGoals: [String]
        var leadIn: String
    }

    static func lines(for page: Page) -> [String] {
        let body = bodyLines(for: page)
        let intro = sentences(from: page.leadIn)
        let bodyKeys = Set(body.map { $0.lowercased() })
        let introIsNew = intro.allSatisfy { !bodyKeys.contains($0.lowercased()) }
        return deduped(introIsNew ? intro + body : body)
    }

    /// Spoken when a new mystery clue appears. Earlier clues stay on screen and are not repeated.
    static func newClueLines(question: LessonQuestion, clueNumber: Int) -> [String] {
        guard question.isProgressiveMystery else { return [] }
        guard clueNumber > 0, clueNumber <= question.clues.count else { return [] }
        var lines = ["Clue \(clueNumber).", spokenLabel(question.clues[clueNumber - 1])]
        if clueNumber >= question.clues.count {
            lines.append(contentsOf: sentences(from: question.prompt))
            lines.append("Use every clue to choose the best answer.")
            lines.append(contentsOf: choiceLines(question.choices))
        }
        return deduped(lines)
    }

    static func feedbackLines(message: String, explanation: String?) -> [String] {
        var lines = sentences(from: message)
        let extra = clean(explanation ?? "")
        guard !extra.isEmpty else { return lines }
        let spoken = lines.joined(separator: " ")
        if spoken.localizedCaseInsensitiveContains(extra) { return lines }
        lines.append(contentsOf: sentences(from: extra))
        return deduped(lines)
    }

    private static func bodyLines(for page: Page) -> [String] {
        switch page.step {
        case .moment(let moment):
            return momentLines(moment, page: page)
        case .question(_, let question, _, _):
            return questionLines(question, page: page)
        case .creative:
            return creativeLines(page: page)
        case .reflection:
            return reflectionLines(page: page)
        case .completion:
            return sentences(from: page.missionCompleteMessage)
        }
    }

    private static func momentLines(_ moment: StoryMoment, page: Page) -> [String] {
        switch moment {
        case .storyOpening:
            if page.playKind != nil {
                return sentences(from: page.lessonTitle) + sentences(from: page.playKind?.howToPlay ?? "")
            }
            return sentences(from: page.story.storyOpening)
        case .reading:
            return passageLines(opening: page.story.storyOpening, passage: page.story.readingPassage)
        case .vocabulary:
            return page.story.vocabularyWords.flatMap { word in
                sentences(from: word.word) + sentences(from: word.definition)
            }
        case .knowledge:
            return page.story.knowledgeFacts.flatMap { fact in
                sentences(from: fact.fact) + sentences(from: fact.childFacingExplanation)
            }
        case .ending:
            return sentences(from: page.story.storyEnding) + sentences(from: "You helped complete today's adventure!")
        default:
            return []
        }
    }

    private static func questionLines(_ question: LessonQuestion, page: Page) -> [String] {
        if question.isProgressiveMystery {
            return mysteryLines(question, revealedClueCount: page.revealedClueCount)
        }

        var lines: [String] = []
        if page.showsPassageWithQuestion {
            lines.append(contentsOf: sentences(from: page.story.readingPassage))
        }
        let prompt = StoryTextDedup.questionBesideStory(
            question.prompt,
            passage: page.showsPassageWithQuestion ? page.story.readingPassage : ""
        )
        lines.append(contentsOf: sentences(from: prompt))

        switch question.displayResponseType {
        case .multipleChoice:
            if page.playKind == .bubblePop {
                lines.append("Tap the right answer.")
            }
            lines.append(contentsOf: choiceLines(question.choices))
        case .matching:
            lines.append("Tap a word on the left, then tap its match on the right.")
            let lefts = question.pairs.map(\.left).map(spokenLabel).filter { !$0.isEmpty }
            let rights = question.pairs.map(\.right).sorted().map(spokenLabel).filter { !$0.isEmpty }
            if !lefts.isEmpty {
                lines.append("On the left.")
                lines.append(contentsOf: lefts)
            }
            if !rights.isEmpty {
                lines.append("On the right.")
                lines.append(contentsOf: rights)
            }
        case .sorting:
            lines.append("Put these in order.")
            let labels = question.items.map(\.text).sorted().map(spokenLabel).filter { !$0.isEmpty }
            lines.append(contentsOf: labels)
        case .drawing:
            lines.append(contentsOf: goalLines(page.drawingGoals))
        case .number, .shortText, .longText:
            break
        }
        return lines
    }

    private static func mysteryLines(_ question: LessonQuestion, revealedClueCount: Int) -> [String] {
        let setup = clean(question.mysterySetup ?? "")
        var lines = sentences(from: setup.isEmpty ? question.prompt : setup)
        let visibleClues = question.clues.prefix(max(0, revealedClueCount))
        for (index, clue) in visibleClues.enumerated() {
            lines.append("Clue \(index + 1).")
            lines.append(spokenLabel(clue))
        }
        if revealedClueCount >= question.clues.count {
            lines.append(contentsOf: sentences(from: question.prompt))
            lines.append("Use every clue to choose the best answer.")
            lines.append(contentsOf: choiceLines(question.choices))
        } else if revealedClueCount == 0 {
            lines.append("Reveal the first clue when you are ready.")
        } else {
            lines.append("You can make an early guess.")
            lines.append(contentsOf: choiceLines(question.choices))
        }
        return lines
    }

    private static func creativeLines(page: Page) -> [String] {
        var lines = sentences(from: PromptWordingNormalizer.normalize(page.story.creativePrompt))
        if page.story.creativeResponseType == .number {
            lines.append("Tap the numbers to enter your answer.")
        }
        lines.append(contentsOf: goalLines(page.drawingGoals))
        return lines
    }

    private static func reflectionLines(page: Page) -> [String] {
        var lines: [String] = []
        if page.includePassageOnReflection {
            lines.append(contentsOf: sentences(from: page.story.readingPassage))
        }
        lines.append(contentsOf: sentences(from: PromptWordingNormalizer.normalize(page.story.reflectionPrompt)))
        return lines
    }

    private static func passageLines(opening: String, passage: String) -> [String] {
        let openingText = clean(opening)
        let passageText = clean(passage)
        var lines: [String] = []
        if !StoryTextDedup.openingIsRetold(by: passageText, opening: openingText) {
            lines.append(contentsOf: sentences(from: openingText))
        }
        let passageOnce = StoryTextDedup.withoutRepeatedBlock(passageText)
        if !passageOnce.isEmpty, passageOnce.caseInsensitiveCompare(openingText) != .orderedSame {
            lines.append(contentsOf: sentences(from: passageOnce))
        }
        return lines
    }

    private static func goalLines(_ goals: [String]) -> [String] {
        let labels = goals.map(spokenLabel).filter { !$0.isEmpty }
        guard !labels.isEmpty else { return [] }
        return ["Try to add each part."] + labels
    }

    private static func choiceLines(_ choices: [String]) -> [String] {
        let labels = choices.map(spokenLabel).filter { !$0.isEmpty }
        guard !labels.isEmpty else { return [] }
        return ["The choices are."] + labels
    }

    private static func spokenLabel(_ text: String) -> String {
        let cleaned = clean(text)
        guard !cleaned.isEmpty else { return "" }
        guard let last = cleaned.last, !".!?".contains(last) else { return cleaned }
        return cleaned + "."
    }

    private static func sentences(from text: String) -> [String] {
        let trimmed = clean(text)
        guard !trimmed.isEmpty else { return [] }
        let characters = Array(trimmed)
        var results: [String] = []
        var current = ""
        for index in characters.indices {
            let character = characters[index]
            current.append(character)
            if ".!?".contains(character), !isDecimalPoint(characters, at: index) {
                pushSentence(current, into: &results)
                current = ""
            }
        }
        pushSentence(current, into: &results)
        return results.isEmpty ? [trimmed] : results
    }

    /// Keeps amounts like 3.5 in one spoken phrase.
    private static func isDecimalPoint(_ characters: [Character], at index: Int) -> Bool {
        guard characters[index] == "." else { return false }
        guard index > 0, index + 1 < characters.count else { return false }
        return characters[index - 1].isNumber && characters[index + 1].isNumber
    }

    private static func pushSentence(_ raw: String, into results: inout [String]) {
        let piece = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard piece.unicodeScalars.contains(where: { CharacterSet.alphanumerics.contains($0) }) else { return }
        results.append(piece)
    }

    private static func deduped(_ lines: [String]) -> [String] {
        var seen = Set<String>()
        var result: [String] = []
        for line in lines {
            let cleaned = clean(line)
            guard !cleaned.isEmpty else { continue }
            guard seen.insert(cleaned.lowercased()).inserted else { continue }
            result.append(cleaned)
        }
        return result
    }

    private static func clean(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/// Stops a lesson from telling the same story, then asking that same question again.
enum StoryTextDedup {
    /// True when the opening mostly retells the start of the passage.
    static func openingIsRetold(by passage: String, opening: String) -> Bool {
        let openingWords = meaningfulWords(opening)
        guard openingWords.count >= 5 else { return false }
        let sample = String(passage.prefix(max(opening.count * 3, 240)))
        let passageWords = Set(meaningfulWords(sample))
        guard !passageWords.isEmpty else { return false }
        let hits = openingWords.filter { passageWords.contains($0) }
        return Double(hits.count) / Double(openingWords.count) >= 0.68
    }

    /// The story is already on screen. Keep the question, and drop a retold story
    /// or a second copy of the same story-and-question block.
    static func questionBesideStory(_ prompt: String, passage: String) -> String {
        let collapsed = withoutRepeatedBlock(prompt)
        let sentences = splitSentences(collapsed)
        guard !passage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return collapsed }
        var kept: [String] = []
        for sentence in sentences {
            if !sentence.contains("?"), sentenceIsRetold(sentence, in: passage) {
                continue
            }
            kept.append(sentence)
        }
        let result = kept.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        return result.isEmpty ? collapsed : result
    }

    /// "Story. Question? Story. Question?" becomes "Story. Question?"
    static func withoutRepeatedBlock(_ text: String) -> String {
        let sentences = splitSentences(text)
        guard sentences.count >= 2 else {
            return text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if sentences.count.isMultiple(of: 2) {
            let half = sentences.count / 2
            let first = sentences.prefix(half).map { normalized($0) }
            let second = sentences.suffix(half).map { normalized($0) }
            if first.elementsEqual(second) {
                return sentences.prefix(half).joined(separator: " ")
            }
        }
        var kept: [String] = []
        for sentence in sentences where kept.last.map({ normalized($0) != normalized(sentence) }) ?? true {
            kept.append(sentence)
        }
        return kept.joined(separator: " ")
    }

    private static func sentenceIsRetold(_ sentence: String, in passage: String) -> Bool {
        let words = meaningfulWords(sentence)
        guard words.count >= 6 else { return false }
        for passageSentence in splitSentences(passage) {
            let passageWords = Set(meaningfulWords(passageSentence))
            let hits = words.filter { passageWords.contains($0) }
            if Double(hits.count) / Double(words.count) >= 0.72 {
                return true
            }
        }
        return false
    }

    private static func meaningfulWords(_ text: String) -> [String] {
        let stop: Set<String> = [
            "a", "an", "the", "and", "or", "but", "to", "of", "in", "on", "for", "with",
            "her", "his", "their", "she", "he", "they", "it", "is", "are", "was", "were",
            "why", "how", "what", "when", "before", "after", "that", "this", "from", "not"
        ]
        return text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 2 && !stop.contains($0) }
    }

    private static func splitSentences(_ text: String) -> [String] {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        let characters = Array(trimmed)
        var results: [String] = []
        var current = ""
        for index in characters.indices {
            let character = characters[index]
            current.append(character)
            if ".!?".contains(character), !isDecimalPoint(characters, at: index) {
                let piece = current.trimmingCharacters(in: .whitespacesAndNewlines)
                if piece.contains(where: { $0.isLetter || $0.isNumber }) {
                    results.append(piece)
                }
                current = ""
            }
        }
        let tail = current.trimmingCharacters(in: .whitespacesAndNewlines)
        if tail.contains(where: { $0.isLetter || $0.isNumber }) {
            results.append(tail.hasSuffix(".") || tail.hasSuffix("!") || tail.hasSuffix("?") ? tail : tail + ".")
        }
        return results
    }

    private static func isDecimalPoint(_ characters: [Character], at index: Int) -> Bool {
        guard characters[index] == "." else { return false }
        guard index > 0, index + 1 < characters.count else { return false }
        return characters[index - 1].isNumber && characters[index + 1].isNumber
    }

    private static func normalized(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
