import Foundation

/// Strict quality checks for any text shown to a child.
/// Rejects malformed, truncated, or unnatural prose before display.
enum ChildFacingProseQualityValidator {

    enum Issue: Equatable, CustomStringConvertible {
        case midPhrasePeriod(String)
        case lowercaseAfterPeriod(String)
        case danglingFragment(String)
        case sentenceFragment(String)
        case awkwardObservationVerb(String)
        case awkwardNumbersToCheck(String)
        case awkwardCurriculumJargon(String)
        case repeatedPunctuation(String)
        case brokenContraction(String)
        case missingSpaceAfterPunctuation(String)
        case placeholderOrFallback(String)
        case truncatedOrUnfinished(String)
        case emptyOrWhitespace
        case duplicateSentence(String)
        case brokenMissionPrompt(String)
        case nounListFragment(String)
        case missingIntroComma(String)
        case subjectVerbAgreement(String)
        case commaSplice(String)

        var description: String {
            switch self {
            case .midPhrasePeriod(let s): return "Mid-phrase period: \(s)"
            case .lowercaseAfterPeriod(let s): return "Lowercase after period: \(s)"
            case .danglingFragment(let s): return "Dangling fragment: \(s)"
            case .sentenceFragment(let s): return "Sentence fragment: \(s)"
            case .awkwardObservationVerb(let s): return "Awkward clause construction: \(s)"
            case .awkwardNumbersToCheck(let s): return "Awkward 'numbers to check' phrasing: \(s)"
            case .awkwardCurriculumJargon(let s): return "Curriculum jargon in child-facing prose: \(s)"
            case .repeatedPunctuation(let s): return "Repeated punctuation: \(s)"
            case .brokenContraction(let s): return "Broken contraction: \(s)"
            case .missingSpaceAfterPunctuation(let s): return "Missing space after punctuation: \(s)"
            case .placeholderOrFallback(let s): return "Placeholder/fallback text: \(s)"
            case .truncatedOrUnfinished(let s): return "Truncated/unfinished text: \(s)"
            case .emptyOrWhitespace: return "Empty text"
            case .duplicateSentence(let s): return "Duplicate sentence: \(s)"
            case .brokenMissionPrompt(let s): return "Broken mission prompt: \(s)"
            case .nounListFragment(let s): return "Noun-list fragment used as a sentence: \(s)"
            case .missingIntroComma(let s): return "Missing comma after introductory word: \(s)"
            case .subjectVerbAgreement(let s): return "Subject-verb agreement error: \(s)"
            case .commaSplice(let s): return "Comma splice / comma fragment: \(s)"
            }
        }

        var isFatal: Bool { true }
    }

    struct Result: Equatable {
        let issues: [Issue]
        var passed: Bool { issues.isEmpty }
    }

    /// Validates a single child-facing prose field (passage, opening, mission, etc.).
    /// - Parameters:
    ///   - allowShortImperative: Skip finite-verb checks for imperative instructions ("Draw…", "Count…").
    ///   - allowDefinitionPhrase: Skip finite-verb checks for dictionary-style vocab definitions
    ///     ("A small room in a barn for a horse.") which are noun/infinitive phrases by design.
    static func validate(
        _ text: String,
        allowShortImperative: Bool = false,
        allowDefinitionPhrase: Bool = false
    ) -> Result {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return Result(issues: [.emptyOrWhitespace])
        }

        var issues: [Issue] = []
        let lower = trimmed.lowercased()

        // Broken list split: "rocks. Sand, or coral"
        if let match = firstMatch(
            in: trimmed,
            pattern: #"\b([A-Za-z]{3,})\.\s+([A-Z][a-z]{2,}),\s+(?:and|or)\b"#
        ) {
            issues.append(.midPhrasePeriod("\(match.1). \(match.2)"))
        }

        // Mid-phrase period: "horse. yard" / "plant. eater"
        if let match = firstMatch(in: trimmed, pattern: #"\b([A-Za-z]{2,})\.\s+([a-z]{2,})\b"#) {
            let left = match.1.lowercased()
            let right = match.2.lowercased()
            // Allow legitimate abbreviations only (Mr. Smith style is rare in our content).
            let knownAbbreviations: Set<String> = ["mr", "mrs", "ms", "dr", "st", "ave"]
            if !knownAbbreviations.contains(left) {
                // Flag when the right side looks like a continuation noun/adjective fragment.
                if right.count <= 12 {
                    issues.append(.midPhrasePeriod("\(match.1). \(match.2)"))
                }
            }
        }

        // Sentence starting with lowercase after . ! ?
        if let match = firstMatch(in: trimmed, pattern: #"[.!?]\s+([a-z])"#) {
            issues.append(.lowercaseAfterPeriod(String(match.1)))
        }

        // "Mia walked to the barn, she filled the bucket."
        if let splice = firstCommaSplice(in: trimmed) {
            issues.append(.commaSplice(splice))
        }

        // Repeated / mixed punctuation: "!!", "..", "??", ".!", and split leftovers like "calm,."
        if trimmed.range(of: #"[.!?]{2,}|,[.!?]|[.!?],"#, options: .regularExpression) != nil {
            issues.append(.repeatedPunctuation(trimmed))
        }

        // Broken contractions: "don t", "can t" (missing apostrophe)
        if let broken = firstMatch(
            in: trimmed,
            pattern: #"\b((?:don|can|won|isn|aren|wasn|weren|hasn|haven|hadn|didn|wouldn|couldn|shouldn)\s+t)\b"#,
            options: .caseInsensitive
        ) {
            issues.append(.brokenContraction(broken.0))
        }

        // Awkward observation clauses: "She saw the path looked smooth."
        if let awkward = firstMatch(
            in: trimmed,
            pattern: #"\b((?:saw|noticed|realized|found)\s+the\s+[A-Za-z][^.?!]{0,60}\s+looked\b[^.?!]*)"#,
            options: .caseInsensitive
        ) {
            issues.append(.awkwardObservationVerb(awkward.1.isEmpty ? awkward.0 : awkward.1))
        }

        // Template junk: "Capsule racks and clip bags give Tess numbers to check."
        if let awkward = firstMatch(
            in: trimmed,
            pattern: #"\b([^.?!]{0,80}\bgive[s]?\s+[A-Za-z]+\s+numbers?\s+to\s+check[^.?!]*)"#,
            options: .caseInsensitive
        ) {
            issues.append(.awkwardNumbersToCheck(awkward.1.isEmpty ? awkward.0 : awkward.1))
        }

        // Adult curriculum glue: "Use groups of ten and equal rows with reef numbers."
        if lower.contains("groups of ten and equal rows") || lower.contains("equal rows with") {
            issues.append(.awkwardCurriculumJargon(trimmed))
        }
        // Literary leftovers that do not make sense on Mission Complete.
        if lower.contains("true reef sighting") || lower.contains("listens wide-eyed") {
            issues.append(.awkwardCurriculumJargon(trimmed))
        }
        // Adult lab-speak and meta glue kids should never see.
        if lower.contains("true detail") || lower.contains("demo plan") || lower.contains("dissolving demo") {
            issues.append(.awkwardCurriculumJargon(trimmed))
        }

        // Missing space after punctuation: "yard.The"
        if trimmed.range(of: #"[.!?,:;][A-Za-z]"#, options: .regularExpression) != nil {
            issues.append(.missingSpaceAfterPunctuation(trimmed))
        }

        // "First she checked" / "Next the wheels" / "Gently she squeezes" — kids need the pause comma.
        // Only flag sentence-initial intro words that are missing the comma. Leave "Then she" alone.
        if let intro = firstMatch(
            in: trimmed,
            pattern: #"(?:^|[.!?]\s+)((?:First|Next|Last|Finally|Gently|Suddenly|Slowly|Quickly|Carefully) (?:she|he|they|you|we|the|a|an|it)\b)"#
        ) {
            issues.append(.missingIntroComma(intro.1.isEmpty ? intro.0 : intro.1))
        }

        // "Check what she add" / "Check what Kai find" / "each animal make".
        // Do not flag real questions such as "What does she find?"
        if let bad = firstMatch(
            in: trimmed,
            pattern: #"\b(what (?:she|he|it|Kai|Dottie|Venus|Wren) (?:add|find|make|look|conclude))\b"#,
            options: .caseInsensitive
        ) {
            issues.append(.subjectVerbAgreement(bad.1.isEmpty ? bad.0 : bad.1))
        }
        if let bad = firstMatch(
            in: trimmed,
            pattern: #"\b(each [A-Za-z]+ make)\b"#,
            options: .caseInsensitive
        ) {
            issues.append(.subjectVerbAgreement(bad.1.isEmpty ? bad.0 : bad.1))
        }
        if let bad = firstMatch(
            in: trimmed,
            pattern: #"\b(What help [a-z])"#
        ) {
            issues.append(.subjectVerbAgreement(bad.1.isEmpty ? bad.0 : bad.1))
        }
        if let bad = subjectVerbAgreementSnippet(in: trimmed) {
            issues.append(.subjectVerbAgreement(bad))
        }

        // Placeholder / fallback markers
        let placeholders = ["lorem ipsum", "todo:", "placeholder", "tbd", "coming soon", "[insert", "xxx", "FIXME", "FIXME:"]
        if placeholders.contains(where: { lower.contains($0.lowercased()) }) {
            issues.append(.placeholderOrFallback(trimmed))
        }

        // Truncated / unfinished: ends with ellipsis mid-thought, or trailing incomplete joiners
        if trimmed.hasSuffix("...") || trimmed.hasSuffix("…") {
            issues.append(.truncatedOrUnfinished(trimmed))
        }
        let unfinishedEndings = [" and", " or", " but"]
        if unfinishedEndings.contains(where: { lower.hasSuffix($0) }) {
            issues.append(.truncatedOrUnfinished(trimmed))
        }

        // Dangling one-word "sentences" after a period (classic hard-split artifact)
        let sentences = splitSentences(trimmed)
        for sentence in sentences {
            let allowedSounds: Set<String> = ["splash", "yum", "crunch", "whoosh", "twinkle", "boom", "pop"]
            let soundTokens = sentence
                .lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { !$0.isEmpty }
            // Allow repeated sound-effect lines like "Boom, boom, boom".
            if !soundTokens.isEmpty && soundTokens.allSatisfy({ allowedSounds.contains($0) }) {
                continue
            }

            let words = sentence.split(separator: " ").map(String.init)
            if words.count == 1 {
                let word = words[0].trimmingCharacters(in: CharacterSet(charactersIn: ".!?\""))
                let lowerWord = word.lowercased()
                let allowedImperatives: Set<String> = [
                    "look", "count", "tap", "listen", "point", "draw", "read", "try", "stop", "go", "see", "find",
                    "open", "use", "add", "write", "check", "share", "create", "design", "mark", "choose", "name"
                ]
                if !allowShortImperative
                    && !allowedSounds.contains(lowerWord)
                    && !allowedImperatives.contains(lowerWord)
                    && word.count <= 12 {
                    // Single lowercase or continuation-looking noun fragments fail.
                    if word.first?.isLowercase == true || isLikelyDanglingNoun(lowerWord) {
                        issues.append(.danglingFragment(sentence))
                    }
                }
            }

            let normalizedSentence = normalizeSentence(sentence)
            guard !normalizedSentence.isEmpty else { continue }
            if startsWithLowercaseLetter(normalizedSentence) {
                issues.append(.lowercaseAfterPeriod(sentence))
            }
            if looksLikeDanglingDependentOpener(normalizedSentence) {
                issues.append(.sentenceFragment(sentence))
                continue
            }
            if looksLikeRelativeClauseFragment(normalizedSentence) {
                issues.append(.sentenceFragment(sentence))
                continue
            }
            if looksLikeModalVerbFragment(normalizedSentence) {
                issues.append(.sentenceFragment(sentence))
                continue
            }
            if looksLikeQuestion(normalizedSentence)
                || looksLikeImperative(normalizedSentence, allowShortImperative: allowShortImperative)
                || looksLikeShortPraise(normalizedSentence) {
                continue
            }
            // Dictionary glosses ("Used to find out…") and short equation justifications
            // are valid without a finite verb or a grammatical subject.
            if allowDefinitionPhrase || looksLikeMathEquationExplanation(normalizedSentence) {
                continue
            }
            if looksLikeSubjectlessVerbFragment(normalizedSentence) {
                issues.append(.sentenceFragment(sentence))
                continue
            }
            if looksLikeNounListFragment(normalizedSentence) {
                issues.append(.nounListFragment(sentence))
                continue
            }
            if looksLikePrepositionalFragment(normalizedSentence)
                && !containsExplicitFiniteVerb(normalizedSentence) {
                issues.append(.sentenceFragment(sentence))
                continue
            }
            if !containsFiniteVerb(normalizedSentence) {
                issues.append(.sentenceFragment(sentence))
            }
        }

        // Duplicate consecutive sentences
        if sentences.count >= 2 {
            for i in 1..<sentences.count {
                if sentences[i].lowercased() == sentences[i - 1].lowercased() {
                    issues.append(.duplicateSentence(sentences[i]))
                }
            }
        }

        return Result(issues: issues)
    }

    /// Validates the main child-facing prose fields on a lesson.
    static func validateLessonProse(_ lesson: Lesson) -> Result {
        var issues: [Issue] = []
        let fields: [(String, Bool)] = [
            (lesson.storyOpening, true),
            (lesson.missionPrompt, true),
            (lesson.readingPassage, false),
            (lesson.storyEnding, false),
            (lesson.creativePrompt, true),
            (lesson.reflectionPrompt, true),
            (lesson.teaser, true)
        ]
        for (field, allowImperative) in fields where !field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            issues.append(contentsOf: validate(field, allowShortImperative: allowImperative).issues)
        }
        let mission = lesson.missionPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        if !mission.isEmpty {
            // Mission-specific: reject "launch off", question-as-period, and similar junk.
            for missionIssue in MissionPromptNormalizer.validate(mission) {
                issues.append(.brokenMissionPrompt(missionIssue.description))
            }
            let displayMission = MissionPromptNormalizer.childFacing(mission)
            for missionIssue in MissionPromptNormalizer.validate(displayMission) {
                issues.append(.brokenMissionPrompt(missionIssue.description))
            }
            if displayMission != mission {
                issues.append(contentsOf: validate(displayMission, allowShortImperative: true).issues)
            }
        }
        for word in lesson.vocabularyWords {
            issues.append(contentsOf: validate(
                word.definition,
                allowShortImperative: true,
                allowDefinitionPhrase: true
            ).issues)
            if !word.exampleSentence.isEmpty {
                issues.append(contentsOf: validate(word.exampleSentence).issues)
            }
        }
        for fact in lesson.knowledgeFacts {
            issues.append(contentsOf: validate(fact.fact).issues)
            if !fact.explanation.isEmpty {
                issues.append(contentsOf: validate(fact.explanation).issues)
            }
        }
        for question in lesson.childFacingQuestions + lesson.childFacingMathChallenges {
            issues.append(contentsOf: validate(question.prompt, allowShortImperative: true).issues)
            if let explanation = question.explanation, !explanation.isEmpty {
                issues.append(contentsOf: validate(explanation, allowShortImperative: true).issues)
            }
            for choice in question.choices {
                // Choices may be short phrases; only check for mid-phrase period corruption.
                if choice.range(of: #"\b[A-Za-z]{2,}\.\s+[a-z]{2,}\b"#, options: .regularExpression) != nil {
                    issues.append(.midPhrasePeriod(choice))
                }
            }
        }
        for hint in lesson.hints where !hint.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            issues.append(contentsOf: validate(hint, allowShortImperative: true).issues)
        }
        return Result(issues: issues)
    }

    static func passes(_ text: String, allowShortImperative: Bool = false) -> Bool {
        validate(text, allowShortImperative: allowShortImperative).passed
    }

    /// Fixes capitalization and comma-fragment errors in child-facing prose.
    static func polish(_ text: String) -> String {
        var result = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !result.isEmpty else { return result }
        result = stripCircleWhileCountingInstructions(result)
        result = polishPunctuation(result)
        result = insertMissingIntroCommas(result)
        result = splitCommaSplices(result)
        result = joinCommandCommaThen(result)
        result = capitalizeAfterInstructionLabels(result)
        result = capitalizeAllSentenceStarts(result)
        result = polishPunctuation(result)
        return result
    }

    /// Drawing the amount is the count — never ask kids to circle objects as they count.
    static func stripCircleWhileCountingInstructions(_ text: String) -> String {
        let patterns = [
            #"\s+and circle them as you count[.!]?"#,
            #"\s+and circle them when you count[.!]?"#,
            #"\s+and circle both groups as you add[.!]?"#,
            #"\s+and circle each(?: one)? as you count[.!]?"#,
            #"\.\s*Circle them as you count[.!]?"#,
            #"\.\s*Circle them when you count[.!]?"#,
            #"\.\s*Circle both groups as you add[.!]?"#,
            #"\.\s*Circle each(?: one)? as you count[.!]?"#,
            #"\s+circle them as you count[.!]?"#,
            #"\s+circle them when you count[.!]?"#,
            #"\s+circle both groups as you add[.!]?"#,
            #"\s+circle each(?: one)? as you count[.!]?"#
        ]
        var result = text
        for pattern in patterns {
            result = result.replacingOccurrences(of: pattern, with: "", options: [.regularExpression, .caseInsensitive])
        }
        result = result.replacingOccurrences(of: #"\s{2,}"#, with: " ", options: .regularExpression)
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        guard result != text.trimmingCharacters(in: .whitespacesAndNewlines) else { return result }
        if result.isEmpty { return result }
        if let last = result.last, !".?!".contains(last) {
            result += "."
        }
        return result
    }

    /// Polishes every child-facing field so kids never see lowercase sentence starts or comma splices.
    static func polishLesson(_ lesson: Lesson) -> Lesson {
        Lesson(
            id: lesson.id,
            title: lesson.title,
            theme: lesson.theme,
            lessonType: lesson.lessonType,
            category: lesson.category,
            primarySubject: lesson.primarySubject,
            storyOpening: polish(lesson.storyOpening),
            missionPrompt: polish(MissionPromptNormalizer.childFacing(lesson.missionPrompt)),
            readingPassage: polish(lesson.readingPassage),
            questions: lesson.questions.map(polishQuestion),
            mathChallenges: lesson.mathChallenges.map(polishQuestion),
            vocabularyWords: lesson.vocabularyWords.map { word in
                VocabularyWord(
                    id: word.id,
                    word: word.word,
                    definition: polish(word.definition),
                    exampleSentence: polish(word.exampleSentence),
                    storyConnection: polish(word.storyConnection)
                )
            },
            knowledgeFacts: LessonContentCoherenceValidator.nonRepeatingFacts(
                lesson.knowledgeFacts.map { fact in
                    KnowledgeFact(
                        id: fact.id,
                        fact: polish(fact.fact),
                        explanation: polish(fact.explanation)
                    )
                },
                passage: [
                    polish(lesson.storyOpening),
                    polish(lesson.readingPassage),
                    polish(lesson.creativePrompt)
                ].filter { !$0.isEmpty }.joined(separator: "\n"),
                vocabulary: lesson.vocabularyWords
            ),
            creativePrompt: polish(lesson.creativePrompt),
            creativeResponseType: lesson.creativeResponseType,
            storyEnding: polish(lesson.storyEnding),
            ageTarget: lesson.ageTarget,
            gradeTarget: lesson.gradeTarget,
            readingLevel: lesson.readingLevel,
            mathLevel: lesson.mathLevel,
            learningGoal: lesson.learningGoal,
            estimatedMinutes: lesson.estimatedMinutes,
            teaser: polish(lesson.teaser),
            difficultyLabel: lesson.difficultyLabel,
            readingSkill: lesson.readingSkill,
            mathSkill: lesson.mathSkill,
            reflectionPrompt: polish(lesson.reflectionPrompt),
            reflectionResponseType: lesson.reflectionResponseType,
            skillsPracticed: lesson.skillsPracticed,
            standardSkillId: lesson.standardSkillId,
            contentApprovalStatus: lesson.contentApprovalStatus,
            hints: lesson.hints.map(polish),
            commonMistakes: lesson.commonMistakes.map(polish),
            successCriteria: lesson.successCriteria.map(polish),
            intendedReadingBand: lesson.intendedReadingBand,
            measuredReadingEstimate: lesson.measuredReadingEstimate,
            readingMeasurementProvider: lesson.readingMeasurementProvider,
            primaryTopicId: lesson.primaryTopicId,
            supportingTopicIds: lesson.supportingTopicIds,
            prerequisiteTopicIds: lesson.prerequisiteTopicIds,
            curriculumSubject: lesson.curriculumSubject,
            curriculumDomain: lesson.curriculumDomain,
            curriculumDifficulty: lesson.curriculumDifficulty,
            recommendedAgeRange: lesson.recommendedAgeRange,
            learningObjectives: lesson.learningObjectives,
            evidenceTargets: lesson.evidenceTargets,
            drawingQuestGoals: lesson.drawingQuestGoals
        )
    }

    private static func polishQuestion(_ question: LessonQuestion) -> LessonQuestion {
        LessonQuestion(
            id: question.id,
            subject: question.subject,
            type: question.type,
            responseType: question.responseType,
            prompt: polish(question.prompt),
            choices: question.choices,
            correctAnswer: question.correctAnswer,
            explanation: question.explanation.map(polish),
            difficultyLevel: question.difficultyLevel,
            pairs: question.pairs,
            items: question.items,
            mysteryKind: question.mysteryKind,
            mysterySetup: question.mysterySetup.map(polish),
            clues: question.clues.map(polish),
            inferenceContext: .init(questionID: question.id)
        )
    }

    // MARK: - Helpers

    private static func splitSentences(_ text: String) -> [String] {
        // Protect common honorific abbreviations so "Mr. Bram" / "Dr. Nolan" stay one clause.
        var protected = text
        let abbreviations = ["Mr.", "Mrs.", "Ms.", "Dr.", "St."]
        for (index, abbr) in abbreviations.enumerated() {
            protected = protected.replacingOccurrences(of: abbr, with: "⟦ABBR\(index)⟧")
        }
        let parts = protected
            .components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return parts.map { part in
            var restored = part
            for (index, abbr) in abbreviations.enumerated() {
                let bare = String(abbr.dropLast()) // "Mr" etc. — period already consumed as splitter proxy
                restored = restored.replacingOccurrences(of: "⟦ABBR\(index)⟧", with: bare)
            }
            return restored
        }
    }

    private static func normalizeSentence(_ sentence: String) -> String {
        sentence
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "\"'()[]{}"))
    }

    /// "Rather than assuming the weaver had simply lost skill." is only half a sentence.
    static func looksLikeDanglingDependentOpener(_ sentence: String) -> Bool {
        let lower = sentence.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let openers = ["rather than ", "instead of "]
        guard openers.contains(where: { lower.hasPrefix($0) }) else { return false }
        guard let comma = sentence.firstIndex(of: ",") else { return true }
        let after = sentence[sentence.index(after: comma)...]
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let head = after.split(separator: " ").first
            .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters) } ?? ""
        if head.isEmpty { return true }
        if clauseSubjects.contains(head.lowercased()) || clauseDeterminers.contains(head.lowercased()) {
            return false
        }
        if let first = head.first, first.isUppercase, head.count >= 2 {
            return false
        }
        return true
    }

    /// "Might explain the empty stall." has a modal and a verb but no subject.
    static func looksLikeModalVerbFragment(_ sentence: String) -> Bool {
        let words = sentence
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters).lowercased() }
            .filter { !$0.isEmpty }
        guard let first = words.first, words.count >= 2 else { return false }
        let modals: Set<String> = ["might", "may", "could", "would", "should"]
        let subjects: Set<String> = ["i", "you", "he", "she", "they", "we", "it", "the", "a", "an"]
        if subjects.contains(words[1]) { return false }
        return modals.contains(first)
    }

    /// "Which helps keep the reef from being smothered." is a broken relative clause,
    /// not a question like "Which side has more?"
    static func looksLikeRelativeClauseFragment(_ sentence: String) -> Bool {
        let words = sentence
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters).lowercased() }
            .filter { !$0.isEmpty }
        guard let first = words.first, let second = words.dropFirst().first else { return false }
        guard first == "which" else { return false }
        if clauseDeterminers.contains(second) { return false }
        if explicitFiniteVerbs.contains(second) { return true }
        let relativeContinuations: Set<String> = [
            "helps", "help", "means", "mean", "makes", "make", "keeps", "keep",
            "lets", "let", "gives", "give", "creates", "create", "supports", "support",
            "often", "can", "could", "would", "should", "will", "is", "was", "are", "were"
        ]
        return relativeContinuations.contains(second)
    }

    private static func looksLikeQuestion(_ sentence: String) -> Bool {
        let lower = sentence.lowercased()
        let starters = [
            "what", "why", "how", "when", "where", "who", "which",
            "is", "are", "do", "does", "did", "can", "could", "would", "should", "will"
        ]
        return starters.contains { lower.hasPrefix($0 + " ") || lower == $0 }
    }

    private static func looksLikeImperative(_ sentence: String, allowShortImperative: Bool) -> Bool {
        guard allowShortImperative else { return false }
        let words = sentence
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters).lowercased() }
            .filter { !$0.isEmpty }
        let first = words.first ?? ""
        let imperativeStarters: Set<String> = [
            "read", "look", "listen", "tap", "count", "draw", "write", "show", "find",
            "circle", "match", "sort", "choose", "use", "think", "compare", "point",
            "tell", "design", "create", "mark", "answer", "pick", "name", "trace",
            "check", "share", "say", "explain", "remember", "notice",
            "open", "add", "label", "reread", "connect", "place", "make", "build",
            "answer", "figure", "give", "sniff",
            "invent", "plan", "follow", "gather", "study", "watch", "help",
            "imagine", "picture", "shade", "color", "paint", "fold", "cut", "glue",
            "pretend", "describe", "list", "map", "measure", "press", "hold", "lift",
            "sniff", "hunt", "spot", "catch", "discover", "borrow", "keep", "start"
        ]
        if imperativeStarters.contains(first) { return true }
        // "Then answer each question." / "Now find the clue."
        let leadIns: Set<String> = ["then", "now", "please"]
        if words.count >= 2, leadIns.contains(first) {
            return imperativeStarters.contains(words[1])
        }
        return false
    }

    private static func looksLikeShortPraise(_ sentence: String) -> Bool {
        let lower = sentence.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let prefixes = ["great ", "beautiful ", "wonderful ", "awesome ", "nice ", "good "]
        if prefixes.contains(where: { lower.hasPrefix($0) }) && lower.split(separator: " ").count <= 5 {
            return true
        }
        let exact: Set<String> = [
            "great work", "great job", "well done", "nice work", "beautiful work", "wonderful work"
        ]
        return exact.contains(lower)
    }

    /// "Spice jars, cups." / "spoons, cups." — a comma list with no real verb.
    /// The -s heuristic otherwise treats plural nouns as finite verbs.
    static func looksLikeNounListFragment(_ sentence: String) -> Bool {
        let trimmed = normalizeSentence(sentence)
        guard trimmed.contains(",") else { return false }
        let words = trimmed
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters) }
            .filter { !$0.isEmpty }
        guard (2...8).contains(words.count) else { return false }
        let first = words[0].lowercased()
        // "First, sensors gather…" / "If force is too strong, parts break."
        let clauseStarters: Set<String> = [
            "first", "next", "last", "then", "now",
            "if", "when", "because", "although", "while", "after", "before", "without"
        ]
        if clauseStarters.contains(first) {
            return false
        }
        // Real clauses often continue after a comma: "Mia sees 2 ponies, then 2 more join."
        if trimmed.range(of: #",\s+(then|so|but|not)\b"#, options: .regularExpression) != nil {
            return false
        }

        let allowedListGlue: Set<String> = ["and", "or", "the", "a", "an"]
        let contentWords = words.filter { !allowedListGlue.contains($0.lowercased()) }
        guard contentWords.count >= 2 else { return false }

        // A real clause has a verb from the explicit list — not merely a plural -s noun.
        if containsExplicitFiniteVerb(trimmed) {
            return false
        }
        // Entire sentence is nouns / articles / and-or joined by commas.
        return words.allSatisfy { word in
            let lower = word.lowercased()
            if allowedListGlue.contains(lower) { return true }
            return lower.range(of: #"^[A-Za-z][A-Za-z\-]*$"#, options: .regularExpression) != nil
        }
    }

    /// "Inside the training dome." / "Near the crater rim." — place phrases used as sentences.
    private static func looksLikePrepositionalFragment(_ sentence: String) -> Bool {
        let words = sentence
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters) }
            .filter { !$0.isEmpty }
        guard (3...8).contains(words.count) else { return false }
        if sentence.contains(",") { return false }
        let introductory: Set<String> = [
            "inside", "outside", "near", "nearby", "after", "before", "during",
            "beside", "along", "under", "over", "on", "in", "at", "from",
            "with", "without", "for", "as", "around", "across", "behind",
            "beyond", "among", "between", "into", "onto", "through", "toward",
            "towards", "against", "above", "below", "beneath", "within", "upon",
            "until", "since", "while", "when", "whenever", "although", "though",
            "because", "if", "unless", "once", "whether",
            "rather", "instead"
        ]
        guard introductory.contains(words[0].lowercased()) else { return false }
        let pronouns: Set<String> = ["i", "he", "she", "they", "we", "it", "you"]
        let rest = words.dropFirst()
        if rest.contains(where: { pronouns.contains($0.lowercased()) }) {
            return false
        }
        // "Inside the dome Nova waited" — a later capitalized name is a subject.
        if rest.contains(where: { word in
            guard let first = word.first else { return false }
            return first.isUppercase && word.count >= 3
        }) {
            return false
        }
        return true
    }

    private static func looksLikeMathEquationExplanation(_ sentence: String) -> Bool {
        let t = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
        guard t.contains("=") else { return false }
        // Typical authored math justifications: "6 + 3 = 9." or "3 × 4 = 12."
        if t.range(of: #"^\d"#, options: .regularExpression) != nil {
            return true
        }
        return t.range(of: #"[\+\-−×\*÷/]"#, options: .regularExpression) != nil
    }

    /// Verbs from an explicit list only — does not treat plural nouns ("cups", "spoons") as verbs.
    static func containsExplicitFiniteVerb(_ sentence: String) -> Bool {
        let lower = sentence.lowercased()
        let finiteVerbPattern =
            #"\b(am|is|are|was|were|be|being|been|has|have|had|do|does|did|can|cannot|can't|could|will|would|shall|should|may|might|must)\b"#
        if lower.range(of: finiteVerbPattern, options: .regularExpression) != nil {
            return true
        }
        let tokens = lower
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        return tokens.contains(where: { explicitFiniteVerbs.contains($0) })
    }

    private static let explicitFiniteVerbs: Set<String> = [
        "stand", "stands", "stood", "swish", "swishes", "swished",
        "speak", "speaks", "spoke", "say", "says", "said",
        "walk", "walks", "walked", "lead", "leads", "led",
        "guide", "guides", "guided", "watch", "watches", "watched",
        "look", "looks", "looked", "notice", "notices", "noticed",
        "explain", "explains", "explained", "compare", "compares", "compared",
        "choose", "chooses", "chose", "help", "helps", "helped",
        "rest", "rests", "rested", "move", "moves", "moved",
        "glide", "glides", "glided", "point", "points", "pointed",
        "mark", "marks", "marked", "practice", "practices", "practiced",
        "read", "reads", "share", "shares", "shared", "keep", "keeps", "kept",
        "learn", "learns", "learned", "solve", "solves", "solved",
        "swim", "swims", "swam", "find", "finds", "found",
        "munch", "munches", "munched", "wave", "waves", "waved",
        "record", "records", "recorded", "glow", "glows", "glowed",
        "begin", "begins", "began", "matter", "matters", "tap", "taps",
        "open", "opens", "fill", "fills", "sit", "sits", "stamp", "stamps",
        "wait", "waits", "drip", "drips", "smell", "smells", "step", "steps",
        "tell", "tells", "hold", "holds", "pack", "packs", "add", "adds",
        "count", "counts", "sort", "sorts", "plan", "plans", "know", "knows",
        "feel", "feels", "show", "shows", "teach", "teaches", "dart", "darts",
        "rise", "rises", "call", "calls", "brush", "brushes", "flick", "flicks",
        "see", "sees", "saw", "come", "comes", "came", "go", "goes", "went",
        "make", "makes", "made", "take", "takes", "took", "give", "gives", "gave",
        "live", "lives", "lived", "need", "needs", "needed", "leave", "leaves", "left",
        "catch", "catches", "caught", "hide", "hides", "hid", "stay", "stays", "stayed",
        "grow", "grows", "grew", "build", "builds", "built", "work", "works", "worked",
        "study", "studies", "studied", "use", "uses", "used", "change", "changes", "changed",
        "push", "pushes", "pulled", "pull", "pulls", "turn", "turns", "turned",
        "write", "writes", "wrote", "draw", "draws", "drew", "run", "runs", "ran",
        "hop", "hops", "hopped", "pad", "pads", "padded", "snap", "snaps", "snapped",
        "cling", "clings", "clung", "float", "floats", "floated", "hum", "hums", "hummed",
        "appear", "appears", "appeared", "become", "becomes", "became",
        "let", "lets", "put", "puts", "get", "gets", "got", "set", "sets",
        "finish", "finishes", "finished", "carry", "carries", "carried",
        "scrape", "scrapes", "scraped", "lit", "investigate", "investigates", "investigated",
        "connect", "connects", "connected", "celebrate", "celebrates", "celebrated",
        "breathe", "breathes", "breathed", "dive", "dives", "dived", "dove",
        "enjoy", "enjoys", "enjoyed", "mean", "means", "meant",
        "fall", "falls", "fell", "fly", "flies", "flew", "land", "lands", "landed",
        "join", "joins", "joined", "arrive", "arrives", "arrived", "trot", "trots", "trotted",
        "crawl", "crawls", "crawled", "scuttle", "scuttles", "scuttled", "roll", "rolls", "rolled",
        "sprout", "sprouts", "sprouted", "bloom", "blooms", "bloomed", "wash", "washes", "washed",
        "line", "lines", "lined", "organize", "organizes", "organized",
        "check", "checks", "checked", "place", "places", "placed",
        "stack", "stacks", "stacked", "label", "labels", "labeled",
        "press", "presses", "pressed", "dart", "darts", "darted",
        "conclude", "concludes", "concluded", "infer", "infers", "inferred",
        "sort", "sorts", "sorted", "spin", "spins", "spun",
        "reflect", "reflects", "reflected", "bury", "buries", "buried",
        "harden", "hardens", "hardened", "shine", "shines", "shone",
        "nicker", "nickers", "nickered", "tip", "tips", "tipped",
        "offer", "offers", "offered", "opened",
        "sit", "sits", "sat", "freeze", "freezes", "froze", "frozen",
        "form", "forms", "formed", "protect", "protects", "protected",
        "follow", "follows", "followed", "answer", "answers", "answered",
        "include", "includes", "included", "support", "supports", "supported",
        "link", "links", "linked", "gather", "gathers", "gathered",
        "decide", "decides", "decided", "fail", "fails", "failed",
        "exceed", "exceeds", "exceeded", "planned",
        "slow", "slows", "slowed"
    ]

    private static func containsFiniteVerb(_ sentence: String) -> Bool {
        if containsExplicitFiniteVerb(sentence) {
            return true
        }
        // Suffix heuristic is a last resort for uncommon verbs. Skip it for short
        // comma lists so "spoons, cups" is not treated as a sentence — those are
        // already caught by looksLikeNounListFragment before this is called.
        if looksLikeNounListFragment(sentence) { return false }
        let lower = sentence.lowercased()
        return lower.range(of: #"\b[A-Za-z]{3,}(ied|ed|ies|es|ing|s)\b"#, options: .regularExpression) != nil
    }

    private static func isLikelyDanglingNoun(_ word: String) -> Bool {
        let dangling: Set<String> = [
            "yard", "eater", "eaters", "explorers", "holes", "helpers",
            "material", "sound", "brakes", "trail", "gate", "path"
        ]
        return dangling.contains(word)
    }

    /// Catches agreement errors such as "One chicken were" and "There were 1 chicken".
    /// Subjunctive "if a train were" is left alone.
    private static func subjectVerbAgreementSnippet(in text: String) -> String? {
        if let match = firstRegexHit(
            in: text,
            pattern: #"\bthere (?:were|are) (?:1|one)\b"#
        ) {
            return match.snippet
        }
        if let match = firstRegexHit(
            in: text,
            pattern: #"\bthere (?:was|is) (?:two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|[2-9]\d*)\b"#
        ) {
            return match.snippet
        }
        if let match = firstRegexHit(
            in: text,
            pattern: #"\b(?:1|one) (?:inches|cents|feet|meters|hours|minutes)\b|\b1 (?:more )?steps\b|\b(?:1|one) (?:friends|groups|boxes|bags|baskets|rows|piles)\b"#
        ) {
            return match.snippet
        }
        if let match = firstRegexHit(
            in: text,
            pattern: #"\ba group of\b[^.!?]{0,60}\bwere\b"#
        ) {
            return match.snippet
        }
        if let match = firstRegexHit(
            in: text,
            pattern: #"\b((?:one|a|an|1)\s+([a-z]+(?:\s+[a-z]+){0,2})\s+(?:were|are))\b"#
        ) {
            let phrase = match.groups.count > 1 ? match.groups[1] : ""
            let words = phrase.split(separator: " ").map(String.init)
            let head = words.first?.lowercased() ?? ""
            let last = words.last ?? ""
            // "a few were" and "a lot are" are plural. "a group of chickens were" is handled separately.
            let pluralQuantifiers: Set<String> = ["few", "lot", "pair", "number", "couple", "dozen"]
            if !pluralQuantifiers.contains(head),
               !looksLikePluralNoun(last),
               !precededBySubjunctive(match.range, in: text) {
                return match.snippet
            }
        }
        if let match = firstRegexHit(
            in: text,
            pattern: #"\b(?:two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|[2-9]|[1-9]\d+)\s+([a-z]+)\s+(?:was|is)\b"#
        ) {
            let noun = match.groups.first ?? ""
            let measures: Set<String> = [
                "inches", "cents", "feet", "meters", "steps", "hours", "minutes", "seconds", "dollars"
            ]
            if looksLikePluralNoun(noun), !measures.contains(noun.lowercased()) {
                return match.snippet
            }
        }
        if let match = firstRegexHit(
            in: text,
            pattern: #"\b(?:she|he|it) (?:were|are)\b"#
        ), !precededBySubjunctive(match.range, in: text) {
            return match.snippet
        }
        if let match = firstRegexHit(
            in: text,
            pattern: #"\b(?:they|we) (?:was|is)\b"#
        ) {
            return match.snippet
        }
        if let singular = firstRegexHit(
            in: text,
            pattern: #"\b(?:there was (?:1|one)\b|(?:^|[.!?]\s+)(?:one|a|an) [a-z]+ was\b)"#
        ),
           let joined = firstRegexHit(in: text, pattern: #"\bjoined them\b"#),
           joined.range.lowerBound >= singular.range.lowerBound,
           text.distance(from: singular.range.lowerBound, to: joined.range.lowerBound) < 180 {
            return joined.snippet
        }
        return nil
    }

    private static func looksLikePluralNoun(_ word: String) -> Bool {
        let lower = word.lowercased()
        let singularEndingInS: Set<String> = [
            "bus", "octopus", "cactus", "glass", "lens", "series", "species",
            "this", "his", "its", "was", "is", "as", "plus", "gas"
        ]
        if singularEndingInS.contains(lower) || lower.hasSuffix("ss") {
            return false
        }
        return lower.hasSuffix("s")
    }

    private static func precededBySubjunctive(_ range: Range<String.Index>, in text: String) -> Bool {
        let start = text.index(range.lowerBound, offsetBy: -48, limitedBy: text.startIndex) ?? text.startIndex
        let prefix = text[start..<range.lowerBound].lowercased()
        if prefix.contains("as though") || prefix.contains("as if") {
            return true
        }
        return prefix.range(of: #"\b(if|wish)\b"#, options: .regularExpression) != nil
    }

    private struct RegexHit {
        let snippet: String
        let range: Range<String.Index>
        let groups: [String]
    }

    private static func firstRegexHit(in text: String, pattern: String) -> RegexHit? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }
        let nsRange = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, options: [], range: nsRange),
              let range = Range(match.range, in: text) else {
            return nil
        }
        var groups: [String] = []
        if match.numberOfRanges > 1 {
            for index in 1..<match.numberOfRanges {
                if let groupRange = Range(match.range(at: index), in: text) {
                    groups.append(String(text[groupRange]))
                } else {
                    groups.append("")
                }
            }
        }
        return RegexHit(snippet: String(text[range]), range: range, groups: groups)
    }

    private static func firstMatch(
        in text: String,
        pattern: String,
        options: NSRegularExpression.Options = []
    ) -> (String, String, String)? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return nil
        }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, options: [], range: range) else {
            return nil
        }
        let full = Range(match.range, in: text).map { String(text[$0]) } ?? ""
        let g1 = match.numberOfRanges > 1
            ? (Range(match.range(at: 1), in: text).map { String(text[$0]) } ?? "")
            : ""
        let g2 = match.numberOfRanges > 2
            ? (Range(match.range(at: 2), in: text).map { String(text[$0]) } ?? "")
            : ""
        return (full, g1, g2)
    }

    // MARK: - Grammar polish

    private static let introAdverbs = [
        "First", "Next", "Last", "Finally", "Gently", "Suddenly", "Slowly", "Quickly", "Carefully"
    ]

    private static let clauseSubjects: Set<String> = [
        "i", "he", "she", "they", "we", "it", "you"
    ]

    private static let clauseDeterminers: Set<String> = [
        "the", "a", "an", "this", "that", "these", "those", "my", "his", "her", "their", "our"
    ]

    private static func startsWithLowercaseLetter(_ sentence: String) -> Bool {
        let stripped = sentence.drop(while: { "\"'“”([".contains($0) })
        guard let first = stripped.first, first.isLetter else { return false }
        return first.isLowercase
    }

    /// "Finds a pinecone." / "Then finds a pinecone." — a finite verb with no subject.
    static func looksLikeSubjectlessVerbFragment(_ sentence: String) -> Bool {
        let words = sentence
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters) }
            .filter { !$0.isEmpty }
        guard !words.isEmpty else { return false }

        // "Buried a few feet down, the crew uncovered…" is a participial opener plus a full clause.
        if let commaRange = sentence.range(of: ",") {
            let after = sentence[commaRange.upperBound...]
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let afterHead = after.split(separator: " ").first
                .map { $0.trimmingCharacters(in: CharacterSet.punctuationCharacters).lowercased() } ?? ""
            if clauseDeterminers.contains(afterHead) || clauseSubjects.contains(afterHead) {
                return false
            }
        }

        var index = 0
        var hasLeadIn = false
        let leadIns: Set<String> = ["then", "and", "but", "so"]
        if leadIns.contains(words[0].lowercased()) {
            index = 1
            hasLeadIn = true
        }
        guard index < words.count else { return false }

        let candidate = words[index]
        let lower = candidate.lowercased()
        if clauseSubjects.contains(lower) || clauseDeterminers.contains(lower) || lower == "there" || lower == "here" {
            return false
        }
        if candidate.first?.isNumber == true {
            return false
        }
        if !hasLeadIn, let first = candidate.first, first.isUppercase, candidate.count >= 2,
           !explicitFiniteVerbs.contains(lower) {
            return false
        }
        let looksFinite = explicitFiniteVerbs.contains(lower)
            && (lower.hasSuffix("s") || lower.hasSuffix("ed") || ["is", "was", "are", "were", "has", "had", "does", "did"].contains(lower))
        guard looksFinite else { return false }
        if hasLeadIn { return true }
        // "Finds a pinecone" / "Sits on a stool" — verb plus object/prepositional phrase.
        // Do not flag noun-as-subject sentences like "Leaves fall from the tree."
        guard index + 1 < words.count else { return false }
        let second = words[index + 1].lowercased()
        let objectStarters: Set<String> = [
            "a", "an", "the", "his", "her", "their", "its", "my", "our",
            "to", "on", "in", "at", "for", "from", "with", "into", "onto"
        ]
        return objectStarters.contains(second)
    }

    private static func firstCommaSplice(in text: String) -> String? {
        guard let regex = try? NSRegularExpression(
            pattern: #",\s+(?:then\s+)?(she|he|they|we|I)\s+[A-Za-z]+"#,
            options: []
        ) else {
            return nil
        }
        let nsRange = NSRange(text.startIndex..., in: text)
        for match in regex.matches(in: text, options: [], range: nsRange) {
            guard let commaRange = Range(match.range, in: text) else { continue }
            let left = String(text[text.startIndex..<commaRange.lowerBound])
            let lastSentence = left.split(whereSeparator: { ".!?".contains($0) }).last.map(String.init) ?? left
            let trimmedLeft = lastSentence.trimmingCharacters(in: .whitespacesAndNewlines)
            if wordCount(trimmedLeft) < 4 { continue }
            if isDependentOpener(trimmedLeft) { continue }
            if containsEmbeddedDependentClause(trimmedLeft) { continue }
            if containsExplicitFiniteVerb(trimmedLeft) {
                return String(text[commaRange]).trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }

    private static func isDependentOpener(_ text: String) -> Bool {
        let lower = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let starters = [
            "if ", "when ", "whenever ", "because ", "although ", "though ",
            "while ", "after ", "before ", "unless ", "until ", "since ",
            "as ", "once ", "whether ", "rather ", "instead ", "based ",
            "comparing ", "using ", "inside ", "outside ", "near ", "after ",
            "during ", "with ", "without ", "for ", "from ", "by ", "on ",
            "in ", "at ", "to ", "so that "
        ]
        return starters.contains { lower.hasPrefix($0) }
    }

    private static func containsEmbeddedDependentClause(_ text: String) -> Bool {
        let lower = " \(text.lowercased()) "
        let markers = [
            " if ", " when ", " whenever ", " because ", " although ", " though ",
            " while ", " after ", " before ", " unless ", " until ", " since ",
            " once ", " whether ", " that if ", " that when "
        ]
        return markers.contains { lower.contains($0) }
    }

    /// Repairs doubled and leftover punctuation from clause splits ("calm,.") plus
    /// missing spaces after sentence endings ("calm.Ripples").
    private static func polishPunctuation(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: #",\s*([.!?])"#, with: "$1", options: .regularExpression)
        result = result.replacingOccurrences(of: #"([.!?])\s*,"#, with: "$1", options: .regularExpression)
        result = result.replacingOccurrences(of: #"\s+([,.;:!?])"#, with: "$1", options: .regularExpression)
        result = result.replacingOccurrences(of: #"(?<=[A-Za-z])([.!?])([A-Za-z])"#, with: "$1 $2", options: .regularExpression)
        result = result.replacingOccurrences(of: #"\.{2,}"#, with: ".", options: .regularExpression)
        result = result.replacingOccurrences(of: #"!{2,}"#, with: "!", options: .regularExpression)
        result = result.replacingOccurrences(of: #"\?{2,}"#, with: "?", options: .regularExpression)
        result = result.replacingOccurrences(of: #"\s{2,}"#, with: " ", options: .regularExpression)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func insertMissingIntroCommas(_ text: String) -> String {
        let pattern = #"(^|[.!?]\s+)(First|Next|Last|Finally|Gently|Suddenly|Slowly|Quickly|Carefully) (she|he|they|you|we|the|a|an|it)\b"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return text }
        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text, range: range, withTemplate: "$1$2, $3")
    }

    private static func splitCommaSplices(_ text: String) -> String {
        guard firstCommaSplice(in: text) != nil else { return text }
        guard let regex = try? NSRegularExpression(
            pattern: #",\s+(?:then\s+)?(she|he|they|we|I)\b"#,
            options: []
        ) else {
            return text
        }
        var result = text
        let nsRange = NSRange(result.startIndex..., in: result)
        let matches = regex.matches(in: result, options: [], range: nsRange).reversed()
        for match in matches {
            guard let fullRange = Range(match.range, in: result),
                  match.numberOfRanges > 1,
                  let pronounRange = Range(match.range(at: 1), in: result) else {
                continue
            }
            let left = String(result[result.startIndex..<fullRange.lowerBound])
            let lastSentence = left.split(whereSeparator: { ".!?".contains($0) }).last.map(String.init) ?? left
            let trimmedLeft = lastSentence.trimmingCharacters(in: .whitespacesAndNewlines)
            if wordCount(trimmedLeft) < 4 || isDependentOpener(trimmedLeft) { continue }
            if containsEmbeddedDependentClause(trimmedLeft) { continue }
            if !containsExplicitFiniteVerb(trimmedLeft) { continue }
            let pronoun = String(result[pronounRange])
            let capitalized = pronoun.prefix(1).uppercased() + pronoun.dropFirst()
            result.replaceSubrange(fullRange, with: ". \(capitalized)")
        }
        return result
    }

    private static func joinCommandCommaThen(_ text: String) -> String {
        // "Look at the note, then draw a scene." is a comma splice of two commands.
        // Keep one sentence with "and then" so young-reader sentence caps are not dropped.
        guard let regex = try? NSRegularExpression(
            pattern: #"(?i)(^|[.!?]\s+)((?:look|read|help|draw|use|find|count|write|check|match|listen|watch|open|follow|notice|start|keep|borrow) [^,]{8,80}), then "#
        ) else {
            return text
        }
        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text, range: range, withTemplate: "$1$2 and then ")
    }

    private static func capitalizeAfterInstructionLabels(_ text: String) -> String {
        guard let regex = try? NSRegularExpression(
            pattern: #"(?i)((?:Your job|Your mission|Science note|Inspiration):)\s+([a-z])"#
        ) else {
            return text
        }
        var result = text
        let nsRange = NSRange(result.startIndex..., in: result)
        for match in regex.matches(in: result, options: [], range: nsRange).reversed() {
            guard match.numberOfRanges > 2,
                  let letterRange = Range(match.range(at: 2), in: result) else {
                continue
            }
            result.replaceSubrange(letterRange, with: result[letterRange].uppercased())
        }
        return result
    }

    static func capitalizeAllSentenceStarts(_ text: String) -> String {
        let abbreviations = ["Mr.", "Mrs.", "Ms.", "Dr.", "St."]
        var protected = text
        for (index, abbr) in abbreviations.enumerated() {
            protected = protected.replacingOccurrences(of: abbr, with: "⟦ABBR\(index)⟧")
        }

        var output = ""
        var capitalizeNext = true
        for ch in protected {
            if capitalizeNext, ch.isLetter {
                output.append(contentsOf: String(ch).uppercased())
                capitalizeNext = false
            } else {
                output.append(ch)
                if ch == "." || ch == "!" || ch == "?" {
                    capitalizeNext = true
                } else if !ch.isWhitespace && ch != "\"" && ch != "'" && ch != "“" && ch != "”" {
                    capitalizeNext = false
                }
            }
        }

        var restored = output
        for (index, abbr) in abbreviations.enumerated() {
            restored = restored.replacingOccurrences(of: "⟦ABBR\(index)⟧", with: abbr)
        }
        return restored
    }

    private static func wordCount(_ text: String) -> Int {
        text.split(separator: " ").filter { !$0.isEmpty }.count
    }
}
