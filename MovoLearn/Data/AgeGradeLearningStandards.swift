import Foundation

/// Age-based learning expectations for Movo Learn (ages 4–10).
///
/// Curriculum band follows the child's age (Common Core–style ELA/Math progressions,
/// NAEYC developmentally appropriate practice). School-grade names are never shown
/// to families — skills are looked up on the curriculum map with age keys (K / 1 / 2 / 3).
/// Marble curriculum JSON remains the topic graph; these standards drive vocabulary,
/// sentence length, independence, and difficulty at session time.
enum AgeGradeLearningStandards {

    /// Developmental / age band used for content shaping.
    /// Case names stay as curriculum-map codes; parent-facing copy uses `displayName`.
    enum Band: String, CaseIterable {
        case preK          // ~ages 4–5
        case kindergarten  // ~age 5–6
        case grade1        // ~age 6–7
        case grade2        // ~age 7–8
        case grade3        // ~age 8–10

        var displayName: String {
            switch self {
            case .preK: return "Ages 4–5"
            case .kindergarten: return "Ages 5–6"
            case .grade1: return "Ages 6–7"
            case .grade2: return "Ages 7–8"
            case .grade3: return "Ages 8–10"
            }
        }

        /// Key used to look up skills on the curriculum map (CASE / Marble education levels).
        var curriculumKey: String {
            switch self {
            case .preK, .kindergarten: return "K"
            case .grade1: return "1"
            case .grade2: return "2"
            case .grade3: return "3"
            }
        }

        var typicalAges: ClosedRange<Int> {
            switch self {
            case .preK: return 4...5
            case .kindergarten: return 5...6
            case .grade1: return 6...7
            case .grade2: return 7...8
            case .grade3: return 8...10
            }
        }
    }

    /// Concrete content shaping rules for one learner session.
    struct Expectations: Equatable {
        let band: Band
        let maxWordsPerSentence: Int
        let maxPassageSentences: Int
        let maxInstructionSentences: Int
        let preferConcreteLanguage: Bool
        let allowInference: Bool
        let allowMultiStepMath: Bool
        let allowAdvancedScienceTerms: Bool
        let teachVocabularyBeforeTesting: Bool
        let maxAnswerChoices: Int
        let readingFocus: [String]
        let mathFocus: [String]
        let independenceCue: String
        let feedbackTone: FeedbackTone
        let visualSupportLevel: VisualSupportLevel
        let instructionStyle: InstructionStyle
    }

    enum FeedbackTone: String {
        case warmScaffolded   // short tip + restate concept
        case guidedHint       // hint, then explanation on 2nd miss
        case independentReflect // prompt to re-check evidence
    }

    enum VisualSupportLevel: String {
        case high    // larger type, drawing preferred, fewer words
        case medium
        case low     // denser text OK, more independence
    }

    enum InstructionStyle: String {
        case shortImperative  // "Look. Count. Tap."
        case clearSteps       // 1–2 short sentences
        case reasonedPrompt   // invites compare / decide / explain
    }

    // MARK: - Band resolution

    /// Curriculum band follows **age** only. School-grade labels are not used.
    static func band(age: Int, grade: String = "") -> Band {
        _ = grade
        switch age {
        case ...5: return .preK
        case 6: return .kindergarten
        case 7: return .grade1
        case 8: return .grade2
        default: return .grade3
        }
    }

    /// Curriculum-map lookup key for this age (`K`, `1`, `2`, `3`).
    static func curriculumKey(forAge age: Int) -> String {
        band(age: age).curriculumKey
    }

    /// Age-band label plus curriculum key, used when a stored “grade” string is still required.
    static func suggestedGrade(forAge age: Int) -> String {
        curriculumKey(forAge: age)
    }

    /// Largest number allowed in math problems for this age (Common Core–style progressions).
    static func mathOperandUpperBound(forAge age: Int) -> Int {
        switch band(age: age) {
        case .preK: return 10
        case .kindergarten: return 10
        case .grade1: return 20
        case .grade2: return 100
        case .grade3: return 1000
        }
    }

    /// Equal-groups multiplication/division starts around 2nd grade (~age 8).
    static func allowsMultiplicativeMath(forAge age: Int) -> Bool {
        switch band(age: age) {
        case .preK, .kindergarten, .grade1: return false
        case .grade2, .grade3: return true
        }
    }

    /// Parent math chips may go easier than age, never harder than the age curriculum.
    static func cappedMathLevel(_ level: MathLevel, age: Int) -> MathLevel {
        let ceiling = LessonDifficultyRules.suggestedMathLevel(forAge: age)
        return level.sortOrder <= ceiling.sortOrder ? level : ceiling
    }

    static func expectations(
        age: Int,
        grade: String,
        readingLevel: ReadingLevel,
        mathLevel: MathLevel
    ) -> Expectations {
        let band = band(age: age, grade: grade)
        let base = baseExpectations(for: band)

        // Reading/math chips can make content easier, never harder than the age curriculum.
        var maxWords = base.maxWordsPerSentence
        var maxSentences = base.maxPassageSentences
        var choices = base.maxAnswerChoices
        var concrete = base.preferConcreteLanguage
        var tone = base.feedbackTone
        var visuals = base.visualSupportLevel
        var style = base.instructionStyle

        switch readingLevel {
        case .beginner:
            maxWords = min(maxWords, 8)
            maxSentences = min(maxSentences, 3)
            choices = min(choices, 3)
            concrete = true
            tone = .warmScaffolded
            visuals = .high
            style = .shortImperative
        case .earlyReader:
            maxWords = min(maxWords, 10)
            maxSentences = min(maxSentences, 4)
            choices = min(choices, 3)
            tone = age <= 6 ? .warmScaffolded : .guidedHint
            if visuals == .low { visuals = .medium }
        case .growingReader:
            maxWords = min(maxWords, 14)
            maxSentences = min(maxSentences, 6)
            choices = min(choices, base.maxAnswerChoices)
            if age >= 7, base.allowInference { style = .reasonedPrompt }
        case .confidentReader:
            maxWords = min(maxWords, 18)
            maxSentences = min(maxSentences, 8)
            choices = min(choices, base.maxAnswerChoices)
            tone = base.feedbackTone
            visuals = base.visualSupportLevel
            style = base.instructionStyle
        }

        return Expectations(
            band: band,
            maxWordsPerSentence: maxWords,
            maxPassageSentences: maxSentences,
            maxInstructionSentences: base.maxInstructionSentences,
            preferConcreteLanguage: concrete,
            allowInference: base.allowInference && age >= 7,
            allowMultiStepMath: base.allowMultiStepMath,
            allowAdvancedScienceTerms: base.allowAdvancedScienceTerms && readingLevel != .beginner,
            teachVocabularyBeforeTesting: concrete || readingLevel == .beginner || readingLevel == .earlyReader || age <= 6,
            maxAnswerChoices: choices,
            readingFocus: base.readingFocus,
            mathFocus: mathFocus(for: mathLevel, band: band),
            independenceCue: base.independenceCue,
            feedbackTone: tone,
            visualSupportLevel: visuals,
            instructionStyle: style
        )
    }

    private static func baseExpectations(for band: Band) -> Expectations {
        switch band {
        case .preK:
            return Expectations(
                band: band,
                maxWordsPerSentence: 8,
                maxPassageSentences: 3,
                maxInstructionSentences: 1,
                preferConcreteLanguage: true,
                allowInference: false,
                allowMultiStepMath: false,
                allowAdvancedScienceTerms: false,
                teachVocabularyBeforeTesting: true,
                maxAnswerChoices: 3,
                readingFocus: ["Listen for key words", "Match picture to idea", "Recall one detail"],
                mathFocus: ["Count to 10", "Compare more/less", "Simple add within 5"],
                independenceCue: "An adult can sit nearby while you try.",
                feedbackTone: .warmScaffolded,
                visualSupportLevel: .high,
                instructionStyle: .shortImperative
            )
        case .kindergarten:
            return Expectations(
                band: band,
                maxWordsPerSentence: 10,
                maxPassageSentences: 4,
                maxInstructionSentences: 2,
                preferConcreteLanguage: true,
                allowInference: false,
                allowMultiStepMath: false,
                allowAdvancedScienceTerms: false,
                teachVocabularyBeforeTesting: true,
                maxAnswerChoices: 3,
                readingFocus: ["Find who/what/where", "Letter sounds in story words", "Retell in order"],
                mathFocus: ["Count to 20", "Add/subtract within 10", "Compare quantities"],
                independenceCue: "Try first, then ask for a hint if you need one.",
                feedbackTone: .warmScaffolded,
                visualSupportLevel: .high,
                instructionStyle: .clearSteps
            )
        case .grade1:
            return Expectations(
                band: band,
                maxWordsPerSentence: 14,
                maxPassageSentences: 6,
                maxInstructionSentences: 2,
                preferConcreteLanguage: false,
                allowInference: true,
                allowMultiStepMath: false,
                allowAdvancedScienceTerms: true,
                teachVocabularyBeforeTesting: true,
                maxAnswerChoices: 3,
                readingFocus: ["Main idea", "Key details", "Word meaning in context"],
                mathFocus: ["Add/subtract within 20", "Missing numbers", "Simple word problems"],
                independenceCue: "Read carefully and use the story as evidence.",
                feedbackTone: .guidedHint,
                visualSupportLevel: .medium,
                instructionStyle: .clearSteps
            )
        case .grade2:
            return Expectations(
                band: band,
                maxWordsPerSentence: 16,
                maxPassageSentences: 8,
                maxInstructionSentences: 2,
                preferConcreteLanguage: false,
                allowInference: true,
                allowMultiStepMath: true,
                allowAdvancedScienceTerms: true,
                teachVocabularyBeforeTesting: false,
                maxAnswerChoices: 4,
                readingFocus: ["Cause and effect", "Compare details", "Use evidence"],
                mathFocus: ["Add/subtract within 100", "Skip counting", "Story problems"],
                independenceCue: "Decide using clues from the passage.",
                feedbackTone: .guidedHint,
                visualSupportLevel: .medium,
                instructionStyle: .reasonedPrompt
            )
        case .grade3:
            return Expectations(
                band: band,
                maxWordsPerSentence: 20,
                maxPassageSentences: 12,
                maxInstructionSentences: 3,
                preferConcreteLanguage: false,
                allowInference: true,
                allowMultiStepMath: true,
                allowAdvancedScienceTerms: true,
                teachVocabularyBeforeTesting: false,
                maxAnswerChoices: 4,
                readingFocus: ["Inference", "Author’s purpose", "Explain with evidence"],
                mathFocus: ["Multiplication intro", "Fractions of a set", "Story problems"],
                independenceCue: "Work independently; explain your thinking.",
                feedbackTone: .independentReflect,
                visualSupportLevel: .low,
                instructionStyle: .reasonedPrompt
            )
        }
    }

    private static func mathFocus(for level: MathLevel, band: Band) -> [String] {
        // Age band is the curriculum. A lower math chip may ease skills; a higher chip may not skip ahead.
        let easier = level == .emerging
        switch band {
        case .preK:
            return ["Count to 10", "Compare more/less", "Add within 5"]
        case .kindergarten:
            return easier
                ? ["Count to 10", "Compare more/less", "Add within 5"]
                : ["Count to 20", "Add/subtract within 10", "Compare quantities"]
        case .grade1:
            return easier
                ? ["Count to 20", "Add/subtract within 10", "Compare quantities"]
                : ["Add/subtract within 20", "Missing numbers", "Simple word problems"]
        case .grade2:
            return easier
                ? ["Add/subtract within 20", "Missing numbers", "Compare quantities"]
                : ["Add/subtract within 100", "Skip counting", "Equal groups"]
        case .grade3:
            return easier || level == .developing
                ? ["Add/subtract within 100", "Skip counting", "Word problems"]
                : ["Multiplication intro", "Equal shares", "Story problems"]
        }
    }

    // MARK: - Language adaptation

    /// Expands child-friendly wording for younger / beginner learners.
    /// Uses word-boundary-safe replacements. Prefer single-word (or hyphenated)
    /// synonyms so sentence word-counts do not inflate and trigger broken splits.
    /// `protectedTerms` are left unchanged (e.g. words on the lesson vocabulary card).
    static func simplifyWording(_ text: String, protectedTerms: Set<String> = []) -> String {
        var result = text
        let protected = Set(protectedTerms.map { $0.lowercased() })
        // Longer phrases first. Never expand one word into multiple space-separated
        // words when a single natural synonym exists — that caused "horse. yard.".
        let replacements: [(String, String)] = [
            ("flexible cartilage", "soft tissue"),
            ("mission control", "helpers"),
            ("investigate", "look at"),
            ("Investigate", "Look at"),
            ("discover", "find"),
            ("Discover", "Find"),
            ("observe", "watch"),
            ("Observe", "Watch"),
            ("conclude", "decide"),
            ("Conclude", "Decide"),
            ("evidence", "clues"),
            ("Evidence", "Clues"),
            ("approximately", "about"),
            ("utilize", "use"),
            ("Utilize", "Use"),
            ("shimmered", "shined"),
            ("Shimmered", "Shined"),
            ("noticed", "saw"),
            ("Noticed", "Saw"),
            ("darted", "dashed"),
            ("Darted", "Dashed"),
            ("cartilage", "tissue"),
            ("oxygen", "air"),
            ("Oxygen", "Air"),
            ("predator", "hunter"),
            ("Predator", "Hunter"),
            ("herbivores", "grazers"),
            ("Herbivores", "Grazers"),
            ("herbivore", "grazer"),
            ("Herbivore", "Grazer"),
            ("whinnied", "nickered"),
            ("Whinnied", "Nickered"),
            ("paddock", "yard"),
            ("Paddock", "Yard"),
            ("orbits", "circles"),
            ("astronauts", "explorers"),
            ("Astronauts", "Explorers"),
            ("craters", "pits"),
            ("Craters", "Pits")
        ]
        for (from, to) in replacements {
            if protected.contains(from.lowercased()) { continue }
            result = replaceWholeWord(in: result, from: from, to: to)
        }
        return result
    }

    private static func replaceWholeWord(in text: String, from: String, to: String) -> String {
        guard !from.isEmpty else { return text }
        if from.contains(" ") {
            return text.replacingOccurrences(of: from, with: to)
        }
        var output = ""
        var search = text[...]
        while let range = search.range(of: from, options: .caseInsensitive) {
            let beforeOK: Bool = {
                if range.lowerBound == search.startIndex { return true }
                let prev = search[search.index(before: range.lowerBound)]
                return !prev.isLetter
            }()
            let afterOK: Bool = {
                if range.upperBound == search.endIndex { return true }
                let next = search[range.upperBound]
                return !next.isLetter
            }()
            output += search[..<range.lowerBound]
            if beforeOK && afterOK {
                let matched = String(search[range])
                if matched.first?.isUppercase == true, let toFirst = to.first {
                    output += String(toFirst).uppercased() + to.dropFirst()
                } else {
                    output += to
                }
            } else {
                output += String(search[range])
            }
            search = search[range.upperBound...]
        }
        output += search
        return output
    }

    /// Softens babyish tone for older learners without inventing new facts.
    static func elevateTone(_ text: String, kind: ProseKind) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return trimmed }
        switch kind {
        case .mission:
            if trimmed.lowercased().hasPrefix("help ") {
                let rest = String(trimmed.dropFirst(5)).trimmingCharacters(in: .whitespacesAndNewlines)
                guard !rest.isEmpty else { return trimmed }
                let firstWord = rest.split(separator: " ").first.map(String.init)?.lowercased() ?? ""
                let verbFollows: Set<String> = [
                    "count", "read", "find", "check", "draw", "match", "look", "pack",
                    "sort", "use", "write", "listen", "watch", "open", "follow"
                ]
                let job = verbFollows.contains(firstWord) ? rest : trimmed
                return ChildFacingProseQualityValidator.polish("Your job: \(job)")
            }
            if !trimmed.contains("Decide") && !trimmed.contains("carefully") {
                return trimmed
            }
            return trimmed
        case .reflection:
            let lower = trimmed.lowercased()
            if ReflectionPromptQuality.isGeneric(trimmed)
                || lower.contains("like most")
                || lower == "what did you like?" {
                // Keep elevateTone from introducing meta prompts; callers re-run ensureConcrete.
                return trimmed
            }
            return trimmed
        case .opening, .ending, .passage, .creative:
            return trimmed
        }
    }

    enum ProseKind {
        case opening, mission, passage, ending, creative, reflection
    }

    /// Concepts that must be taught (vocab card / passage) before asking about them for younger bands.
    static let conceptsRequiringTeaching: Set<String> = [
        "gills", "oxygen", "cartilage", "predator", "herbivore", "fossil",
        "orbit", "astronaut", "crater", "paddock", "foal", "stable",
        "reef", "launch", "antenna"
    ]

    static func requiresPreTeaching(_ term: String, expectations: Expectations) -> Bool {
        guard expectations.teachVocabularyBeforeTesting else { return false }
        return conceptsRequiringTeaching.contains(term.lowercased())
    }

    /// Average words per sentence — used by the quality gate.
    static func averageWordsPerSentence(in text: String) -> Double {
        let sentences = text
            .components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        guard !sentences.isEmpty else { return 0 }
        let words = sentences.map { $0.split(separator: " ").count }
        return Double(words.reduce(0, +)) / Double(words.count)
    }

    static func sentenceCount(of text: String) -> Int {
        text
            .components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .count
    }

    /// Truncate passage to sentence cap, preferring complete sentences.
    /// Preserves each sentence's original `.` / `!` / `?` terminal (never turns questions into periods).
    static func limitSentences(_ text: String, max: Int) -> String {
        let pieces = extractSentencesPreservingTerminal(text)
        return Array(pieces.prefix(Swift.max(1, max))).map { piece in
            let body = piece.body.trimmingCharacters(in: .whitespacesAndNewlines)
            let terminal = piece.terminal.isEmpty ? "." : piece.terminal
            return ChildFacingProseQualityValidator.polish(body + terminal)
        }.joined(separator: " ")
    }

    /// Shorten long sentences for younger readers by splitting only at natural
    /// clause boundaries. Never hard-splits mid-phrase (that produced "horse. yard.").
    /// If no safe split exists, the original sentence is kept intact — slightly
    /// longer correct English beats broken fragments.
    static func enforceWordBudget(_ text: String, maxWordsPerSentence: Int) -> String {
        let sentences = extractSentencesPreservingTerminal(text)
        var rebuilt: [String] = []
        for item in sentences {
            let body = item.body
            let words = body.split(separator: " ").map(String.init)
            if words.count <= maxWordsPerSentence {
                rebuilt.append(finishedSentence(body, terminal: item.terminal))
                continue
            }
            if let parts = splitAtNaturalBoundary(body, maxWordsPerSentence: maxWordsPerSentence) {
                for (index, part) in parts.enumerated() {
                    let terminal = index == parts.count - 1 ? item.terminal : "."
                    rebuilt.append(finishedSentence(part, terminal: terminal))
                }
            } else {
                // Keep intact — do not invent mid-phrase periods.
                rebuilt.append(finishedSentence(body, terminal: item.terminal))
            }
        }
        return rebuilt.joined(separator: " ")
    }

    /// Adapts prose for younger readers without corrupting grammar.
    /// Returns the best safe candidate that passes prose quality checks.
    static func adaptProseSafely(
        _ text: String,
        maxWordsPerSentence: Int,
        maxSentences: Int,
        protectedTerms: Set<String> = []
    ) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return trimmed }

        let limited = limitSentences(trimmed, max: max(1, maxSentences))
        let simplified = simplifyWording(limited, protectedTerms: protectedTerms)
        let budgeted = enforceWordBudget(simplified, maxWordsPerSentence: maxWordsPerSentence)

        let candidates = [budgeted, simplified, limited, trimmed]
        for candidate in candidates {
            let polished = ChildFacingProseQualityValidator.polish(candidate)
            if ChildFacingProseQualityValidator.passes(polished) {
                return polished
            }
        }
        // Last resort: original limited sentences — never return known-corrupt text.
        return ChildFacingProseQualityValidator.polish(limited)
    }

    // MARK: - Sentence helpers

    private struct SentencePiece {
        let body: String
        let terminal: String
    }

    private static func extractSentencesPreservingTerminal(_ text: String) -> [SentencePiece] {
        var protected = text
        let abbreviations = ["Mr.", "Mrs.", "Ms.", "Dr.", "St."]
        for (index, abbr) in abbreviations.enumerated() {
            protected = protected.replacingOccurrences(of: abbr, with: "⟦ABBR\(index)⟧")
        }

        func restore(_ s: String) -> String {
            var out = s
            for (index, abbr) in abbreviations.enumerated() {
                out = out.replacingOccurrences(of: "⟦ABBR\(index)⟧", with: abbr)
            }
            return out
        }

        var pieces: [SentencePiece] = []
        var current = ""
        for ch in protected {
            if ch == "." || ch == "!" || ch == "?" {
                let body = current.trimmingCharacters(in: .whitespacesAndNewlines)
                if !body.isEmpty {
                    pieces.append(SentencePiece(body: restore(body), terminal: String(ch)))
                }
                current = ""
            } else {
                current.append(ch)
            }
        }
        let trailing = current.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trailing.isEmpty {
            pieces.append(SentencePiece(body: restore(trailing), terminal: "."))
        }
        return pieces
    }

    private static func capitalizeSentenceStart(_ sentence: String) -> String {
        let trimmed = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.first else { return trimmed }
        if first.isUppercase { return trimmed }
        return String(first).uppercased() + trimmed.dropFirst()
    }

    /// Clause splits on ", but" / ", so" used to keep the comma, then a period was
    /// appended ("calm,."). Strip leftover clause punctuation before ending a sentence.
    private static func strippingTrailingClausePunctuation(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: ",;:—–-"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func finishedSentence(_ body: String, terminal: String) -> String {
        let cleaned = strippingTrailingClausePunctuation(body)
        let mark = terminal.isEmpty ? "." : terminal
        return capitalizeSentenceStart(cleaned) + mark
    }

    /// Splits only when both sides can stand as complete-enough sentences.
    private static func splitAtNaturalBoundary(
        _ sentence: String,
        maxWordsPerSentence: Int
    ) -> [String]? {
        // Prefer comma / em-dash when both sides have enough words.
        // Skip introductory phrases ("Inside the training dome, …") — turning those
        // into their own sentences produced "Inside the training dome." fragments.
        var searchStart = sentence.startIndex
        while searchStart < sentence.endIndex {
            let remainder = sentence[searchStart...]
            guard let comma = remainder.firstIndex(of: ",") else { break }
            let first = strippingTrailingClausePunctuation(String(sentence[..<comma]))
            var second = strippingTrailingClausePunctuation(
                String(sentence[sentence.index(after: comma)...])
            )
            // Only drop a leading conjunction when the remainder can stand as its own
            // clause (has a subject). Otherwise this is a compound predicate
            // ("picks it up, then finds a pinecone") and splitting creates a fragment.
            var skipCompoundPredicate = false
            for prefix in ["and ", "but ", "or ", "so ", "then "] {
                if second.lowercased().hasPrefix(prefix) {
                    let remainderClause = String(second.dropFirst(prefix.count))
                    if hasClauseSubject(remainderClause) {
                        if prefix == "then " {
                            second = "Then " + remainderClause
                        } else {
                            second = remainderClause
                        }
                    } else {
                        skipCompoundPredicate = true
                    }
                    break
                }
            }
            if skipCompoundPredicate {
                searchStart = sentence.index(after: comma)
                continue
            }
            if looksLikeRelativeClauseRemainder(second) || looksLikeContinuationFragment(second) {
                searchStart = sentence.index(after: comma)
                continue
            }
            if wordCount(first) >= 3, wordCount(second) >= 3,
               wordCount(first) <= maxWordsPerSentence,
               !isIntroductoryPhrase(first),
               !looksLikeNounList(first),
               !isCommaInsideCoordinatedList(sentence, comma: comma),
               ChildFacingProseQualityValidator.containsExplicitFiniteVerb(first),
               ChildFacingProseQualityValidator.containsExplicitFiniteVerb(second) {
                var parts = [first]
                if wordCount(second) <= maxWordsPerSentence {
                    parts.append(second)
                } else if let nested = splitAtNaturalBoundary(second, maxWordsPerSentence: maxWordsPerSentence) {
                    parts.append(contentsOf: nested)
                } else {
                    parts.append(second)
                }
                return parts
            }
            searchStart = sentence.index(after: comma)
        }

        // Clause connectors that often yield two full sentences.
        let connectors = [" while ", " because ", " when ", " so ", " but ", " and then "]
        for connector in connectors {
            guard let range = sentence.range(of: connector, options: .caseInsensitive) else { continue }
            let first = strippingTrailingClausePunctuation(String(sentence[..<range.lowerBound]))
            let second = strippingTrailingClausePunctuation(String(sentence[range.upperBound...]))
            if wordCount(first) >= 3, wordCount(second) >= 3,
               wordCount(first) <= maxWordsPerSentence,
               !isIntroductoryPhrase(first),
               ChildFacingProseQualityValidator.containsExplicitFiniteVerb(first),
               ChildFacingProseQualityValidator.containsExplicitFiniteVerb(second) {
                var parts = [first]
                if wordCount(second) <= maxWordsPerSentence {
                    parts.append(second)
                } else if let nested = splitAtNaturalBoundary(second, maxWordsPerSentence: maxWordsPerSentence) {
                    parts.append(contentsOf: nested)
                } else {
                    parts.append(second)
                }
                return parts
            }
        }
        return nil
    }

    /// ", which helps…" / ", who carried…" cannot become their own sentences.
    private static func looksLikeRelativeClauseRemainder(_ text: String) -> Bool {
        let lower = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let starters = ["which ", "who ", "whom ", "whose "]
        return starters.contains { lower.hasPrefix($0) }
    }

    /// "the new road, not the weaver's work, might explain…" — appositives and
    /// subjectless modals cannot stand as sentences.
    private static func looksLikeContinuationFragment(_ text: String) -> Bool {
        let lower = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if lower.hasPrefix("not ") { return true }
        let modals = ["might ", "may ", "could ", "would ", "should "]
        return modals.contains { lower.hasPrefix($0) } && !hasClauseSubject(lower)
    }

    /// "Spice jars, cups" is a list, not a sentence — never split there.
    private static func looksLikeNounList(_ text: String) -> Bool {
        ChildFacingProseQualityValidator.looksLikeNounListFragment(text)
            || (text.contains(",") && !ChildFacingProseQualityValidator.containsExplicitFiniteVerb(text))
    }

    /// "rocks, sand, or coral" is one list. Splitting at those commas made "rocks. Sand, or coral".
    private static func isCommaInsideCoordinatedList(_ sentence: String, comma: String.Index) -> Bool {
        let pattern = #"(?i)\b[A-Za-z][A-Za-z']*,\s+[A-Za-z][A-Za-z']*,\s+(?:and|or)\s+[A-Za-z][A-Za-z']*"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let nsRange = NSRange(sentence.startIndex..., in: sentence)
        let commaUTF16 = comma.utf16Offset(in: sentence)
        for match in regex.matches(in: sentence, options: [], range: nsRange) {
            if commaUTF16 >= match.range.location && commaUTF16 < match.range.location + match.range.length {
                return true
            }
        }
        return false
    }

    /// True when the clause has its own subject, so it can become a new sentence.
    private static func hasClauseSubject(_ text: String) -> Bool {
        let words = text
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters) }
            .filter { !$0.isEmpty }
        guard let first = words.first else { return false }
        let lower = first.lowercased()
        let pronouns: Set<String> = ["i", "he", "she", "they", "we", "it", "you"]
        if pronouns.contains(lower) { return true }
        let determiners: Set<String> = [
            "the", "a", "an", "this", "that", "these", "those", "my", "his", "her", "their", "our"
        ]
        if determiners.contains(lower) { return true }
        if first.first?.isNumber == true { return true }
        if let ch = first.first, ch.isUppercase, first.count >= 2,
           !ChildFacingProseQualityValidator.containsExplicitFiniteVerb(first) {
            return true
        }
        return false
    }

    /// True for place/time openers that cannot stand as a sentence on their own.
    private static func isIntroductoryPhrase(_ text: String) -> Bool {
        let lower = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let starters = [
            "inside ", "outside ", "near ", "nearby ", "after ", "before ", "during ",
            "beside ", "along ", "under ", "over ", "on ", "in ", "at ", "from ",
            "with ", "without ", "for ", "as ", "around ", "across ", "behind ",
            "beyond ", "among ", "between ", "into ", "onto ", "through ", "toward ",
            "towards ", "against ", "above ", "below ", "beneath ", "within ", "upon ",
            "until ", "since ", "while ", "when ", "whenever ", "although ", "though ",
            "because ", "if ", "unless ", "once ", "whether ",
            "rather ", "rather than ", "instead ", "instead of ",
            "comparing ", "using ", "trusting ", "following ", "leaving ", "based "
        ]
        return starters.contains { lower.hasPrefix($0) }
    }

    private static func wordCount(_ text: String) -> Int {
        text.split(separator: " ").filter { !$0.isEmpty }.count
    }
}
