import Foundation

/// Enforces educational-quality multiple-choice distractors for reading and math.
/// Wrong answers must be plausible, topic-related, and non-joke — never absurd or random.
enum QuestionQualityValidator {

    /// Expected numeric relationship for a generated word problem.
    enum MathOperationHint: Equatable {
        case addition(Int, Int)
        case subtraction(Int, Int)
        case multiplication(Int, Int)
        case division(Int, Int)
        case identity(Int)

        var expectedAnswer: Int {
            switch self {
            case .addition(let a, let b): return a + b
            case .subtraction(let a, let b): return a - b
            case .multiplication(let a, let b): return a * b
            case .division(let a, let b): return b == 0 ? 0 : a / b
            case .identity(let n): return n
            }
        }
    }

    enum Issue: Equatable, CustomStringConvertible {
        case emptyChoices
        case tooFewChoices(Int)
        case duplicateChoices
        case missingCorrectAnswer
        case jokeOrAbsurdChoice(String)
        case unrelatedChoice(String)
        case mathNonNumericChoice(String)
        case mathDistractorTooFar(String)
        case styleMismatch(String)
        case openEndedHasChoices
        case responseTypeMismatch(String)
        case drawingHasChoices
        case unclearPrompt
        case mathPromptFragment(String)
        case mathPromptMissingQuestion
        case mathPromptInconsistentObject
        case mathPromptBadPlural
        case mathPromptAnswerMismatch
        case mathPromptUnclear
        case mathPromptAnswerInStem
        case unsupportedArrangingActivity
        case subjectMismatch(String)
        case unrelatedNoun(String)
        case answerNotVerifiable
        case scenarioIllogical
        case insufficientMathFocus(Double)
        case matchingNotPassageGrounded(String)
        case metaComprehensionPrompt(String)

        var description: String {
            switch self {
            case .emptyChoices:
                return "Multiple-choice question has no choices."
            case .tooFewChoices(let count):
                return "Expected at least 2 choices, found \(count)."
            case .duplicateChoices:
                return "Choices must be unique."
            case .missingCorrectAnswer:
                return "correctAnswer must be one of the choices."
            case .jokeOrAbsurdChoice(let choice):
                return "Joke or absurd choice: \"\(choice)\"."
            case .unrelatedChoice(let choice):
                return "Choice unrelated to topic/story: \"\(choice)\"."
            case .mathNonNumericChoice(let choice):
                return "Math choice must be numeric: \"\(choice)\"."
            case .mathDistractorTooFar(let choice):
                return "Math distractor too far from correct answer: \"\(choice)\"."
            case .styleMismatch(let choice):
                return "Choice style/length mismatches others: \"\(choice)\"."
            case .openEndedHasChoices:
                return "Open-ended questions should not include answer choices."
            case .responseTypeMismatch(let detail):
                return "Response type incompatible with question data: \(detail)"
            case .drawingHasChoices:
                return "Drawing prompts must not include multiple-choice answers."
            case .unclearPrompt:
                return "Prompt is unclear or incomplete for a child."
            case .mathPromptFragment(let detail):
                return "Math word problem has unnatural wording: \(detail)"
            case .mathPromptMissingQuestion:
                return "Math word problem must end with a clear question."
            case .mathPromptInconsistentObject:
                return "Math word problem changes the counted object mid-sentence."
            case .mathPromptBadPlural:
                return "Math word problem has incorrect singular/plural forms."
            case .mathPromptAnswerMismatch:
                return "Math word problem answer does not match the intended operation."
            case .mathPromptUnclear:
                return "Math word problem is unclear about what is being counted."
            case .mathPromptAnswerInStem:
                return "Math word problem restates the answer in the prompt (no real thinking required)."
            case .unsupportedArrangingActivity:
                return "Question uses an unsupported arranging or sequencing activity."
            case .subjectMismatch(let detail):
                return "Question does not match primary subject: \(detail)"
            case .unrelatedNoun(let noun):
                return "Unrelated noun detected: \"\(noun)\"."
            case .answerNotVerifiable:
                return "Answer cannot be verified from lesson content."
            case .scenarioIllogical:
                return "Scenario is grammatically correct but semantically illogical."
            case .insufficientMathFocus(let ratio):
                return "Math lesson math-assessment ratio \(Int(ratio * 100))% is below the 70% requirement."
            case .matchingNotPassageGrounded(let detail):
                return "Matching pair not grounded in passage: \(detail)"
            case .metaComprehensionPrompt(let detail):
                return "Reading question tests clue-writing instead of the story: \(detail)"
            }
        }
    }

    struct Result {
        let issues: [Issue]
        var isValid: Bool { issues.isEmpty }
    }

    // MARK: - Public API

    /// Removes arranging/sequencing items and low-quality questions before child display.
    static func filterForChildDisplay(_ questions: [LessonQuestion], lesson: Lesson? = nil) -> [LessonQuestion] {
        questions.compactMap { question in
            if isUnsupportedArranging(question) {
                #if DEBUG
                print("⚠️ Skipping arranging activity: \(question.prompt)")
                #endif
                return nil
            }
            let context = lesson.map { LessonContextBank.from(lesson: $0) }
            let result = validate(
                question,
                topic: lesson?.theme,
                topicKeywords: lesson.map { topicKeywords(for: $0.theme) } ?? [],
                context: context,
                primarySubject: lesson?.primarySubject,
                passage: lesson?.readingPassage
            )
            if !result.isValid {
                #if DEBUG
                print("⚠️ Skipping low-quality question: \(question.prompt)\n  \(result.issues.map(\.description).joined(separator: "; "))")
                #endif
                // Keep structurally valid matching/MCQ that only fail soft checks when no lesson context.
                if lesson == nil {
                    return question
                }
                let fatal = result.issues.contains { issue in
                    switch issue {
                    case .unsupportedArrangingActivity, .jokeOrAbsurdChoice, .emptyChoices,
                         .missingCorrectAnswer, .responseTypeMismatch, .scenarioIllogical,
                         .matchingNotPassageGrounded, .answerNotVerifiable, .mathPromptAnswerInStem,
                         .metaComprehensionPrompt:
                        return true
                    default:
                        return false
                    }
                }
                return fatal ? nil : question
            }
            // Extra safeguard: never show matching without passage-grounded pairs.
            if (question.responseType == .matching || question.displayResponseType == .matching),
               let lesson,
               !PassageMatchingQuestionGenerator.pairsArePassageGrounded(question.pairs, passage: lesson.readingPassage) {
                #if DEBUG
                print("⚠️ Skipping matching without passage evidence: \(question.prompt)")
                #endif
                return nil
            }
            return question
        }
    }

    /// Keeps a passage-grounded matching activity when truncating a question list.
    static func prefixPreservingMatching(_ questions: [LessonQuestion], cap: Int) -> [LessonQuestion] {
        let matching = questions.filter { $0.responseType == .matching || $0.displayResponseType == .matching }
        let rest = questions.filter { $0.responseType != .matching && $0.displayResponseType != .matching }
        if cap <= 0 {
            return Array(matching.prefix(1))
        }
        var result = Array(matching.prefix(1))
        let remaining = max(0, cap - result.count)
        result.append(contentsOf: rest.prefix(remaining))
        return result
    }

    static func isUnsupportedArranging(_ question: LessonQuestion) -> Bool {
        if question.responseType == .sorting || question.displayResponseType == .sorting {
            return true
        }
        return looksLikeArrangingPrompt(question.prompt)
    }

    static func looksLikeArrangingPrompt(_ prompt: String) -> Bool {
        let lower = prompt.lowercased()
        let patterns = [
            "put these events in order", "put the events in order", "put .* in the correct order",
            "arrange each step", "arrange the", "what happened first",
            "drag the events", "from first to last", "correct order",
            "put .* steps in", "sequence these", "reorder"
        ]
        for pattern in patterns {
            if lower.range(of: pattern, options: .regularExpression) != nil {
                return true
            }
        }
        return lower.contains("put in order") || lower.contains("arrange ")
    }

    static func looksLikeMetaComprehensionPrompt(_ prompt: String) -> Bool {
        let lower = prompt.lowercased()
        let markers = [
            "which two clues",
            "which pair of clues",
            "which clues did",
            "what clues would you",
            "what clues you would",
            "what you would check",
            "what would you check",
            "what you would do",
            "felt most convincing",
            "would you trust most",
            "make it yours",
            "weighing more than one clue",
            "write two evidence notes",
            "why is careful reading important",
            "name both clues"
        ]
        return markers.contains { lower.contains($0) }
    }

    static func looksLikeLazyClueDistractor(_ choice: String) -> Bool {
        let lower = choice.lowercased()
        let markers = [
            "only the color of",
            "only the sound of",
            "only how old",
            "only the number of passengers",
            "only the size of",
            "only the smell of",
            "only the day of the week"
        ]
        return markers.contains { lower.contains($0) }
    }

    static func validate(
        _ question: LessonQuestion,
        topic: Topic? = nil,
        topicKeywords: [String] = [],
        context: LessonContextBank? = nil,
        primarySubject: PrimarySubject? = nil,
        passage: String? = nil
    ) -> Result {
        var issues: [Issue] = []

        if isUnsupportedArranging(question) {
            issues.append(.unsupportedArrangingActivity)
        }

        issues.append(contentsOf: validateResponseType(question))
        issues.append(contentsOf: validatePromptClarity(question.prompt))
        if question.subject == .reading,
           question.responseType == .multipleChoice,
           !question.isProgressiveMystery,
           looksLikeMetaComprehensionPrompt(question.prompt) {
            issues.append(.metaComprehensionPrompt(question.prompt))
        }
        if question.subject == .reading {
            for choice in question.choices where looksLikeLazyClueDistractor(choice) {
                issues.append(.jokeOrAbsurdChoice(choice))
            }
        }

        if let primarySubject {
            issues.append(contentsOf: validateSubjectAlignment(question, primarySubject: primarySubject))
        }

        if question.subject == .math {
            issues.append(contentsOf: validateMathWordProblemPrompt(
                question.prompt,
                expectedAnswer: question.correctAnswer.flatMap(parseNumber)
            ))
        }

        if let context {
            issues.append(contentsOf: validateAgainstContext(question, context: context))
        }

        if let passage,
           question.subject != .math,
           question.responseType == .multipleChoice,
           let answer = question.correctAnswer?.trimmingCharacters(in: .whitespacesAndNewlines),
           !answer.isEmpty {
            let haystack = passage.lowercased()
            let needle = answer.lowercased()
            let shortOK = ["yes", "no", "left", "right", "same"].contains(needle)
            let grounded = shortOK
                || haystack.contains(needle)
                || needle.split(separator: " ").map(String.init).filter { $0.count > 3 }.contains { haystack.contains($0) }
            if !grounded {
                issues.append(.answerNotVerifiable)
            }
        }

        switch question.responseType {
        case .multipleChoice:
            let mc = validateMultipleChoice(question, topic: topic, topicKeywords: topicKeywords, context: context)
            issues.append(contentsOf: mc.issues)
        case .drawing:
            if !question.choices.isEmpty {
                issues.append(.drawingHasChoices)
            }
        case .matching:
            if question.pairs.count < 2 {
                issues.append(.responseTypeMismatch("matching requires at least 2 pairs"))
            }
            if let passage, !passage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                for detail in PassageMatchingQuestionGenerator.validationIssues(for: question.pairs, passage: passage) {
                    issues.append(.matchingNotPassageGrounded(detail))
                }
            } else {
                for pair in question.pairs where PassageMatchingQuestionGenerator.isLooseAssociation(left: pair.left, right: pair.right) {
                    issues.append(.matchingNotPassageGrounded("Loose association: \"\(pair.left)\" → \"\(pair.right)\""))
                }
            }
        case .sorting:
            // Structural decode may still succeed; child display rejects arranging.
            if question.items.count < 2 {
                issues.append(.responseTypeMismatch("sorting requires at least 2 items"))
            }
            issues.append(.unsupportedArrangingActivity)
        case .number, .shortText, .longText:
            if question.type == .openEnded && !question.choices.isEmpty {
                issues.append(.openEndedHasChoices)
            }
        }

        return Result(issues: issues)
    }

    private static func validateResponseType(_ question: LessonQuestion) -> [Issue] {
        var issues: [Issue] = []
        // Validate against the declared type (not the sanitized display fallback).
        let type = question.responseType

        switch type {
        case .multipleChoice:
            if question.choices.count < 2 {
                issues.append(.responseTypeMismatch("multipleChoice needs at least 2 choices"))
            }
        case .matching:
            if !question.hasValidMatchingData {
                issues.append(.responseTypeMismatch("matching needs structured pairs"))
            }
        case .sorting:
            if !question.hasValidSortingData {
                issues.append(.responseTypeMismatch("sorting needs structured items"))
            }
        case .number:
            if question.subject == .math,
               let answer = question.correctAnswer,
               Int(answer) == nil,
               question.choices.isEmpty {
                issues.append(.responseTypeMismatch("number response without numeric answer"))
            }
        case .drawing, .shortText, .longText:
            break
        }
        return issues
    }

    private static func validatePromptClarity(_ prompt: String) -> [Issue] {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed.count < 8 {
            return [.unclearPrompt]
        }
        let lower = trimmed.lowercased()
        let bad = [" while ", " treasures", "animals treasures", "princess treasures"]
        if bad.contains(where: { lower.contains($0) }) {
            return [.unclearPrompt]
        }
        return []
    }

    /// Schema validation for a whole lesson, including creative/reflection response types.
    static func validateLessonSchema(_ lesson: Lesson) -> [String] {
        var messages = validateLesson(lesson)

        let creativeAllowed: Set<QuestionResponseType> = [.drawing, .shortText, .longText]
        if !creativeAllowed.contains(lesson.creativeResponseType) {
            messages.append("creativeResponseType must be drawing, shortText, or longText (found \(lesson.creativeResponseType.rawValue))")
        }
        if lesson.creativeResponseType == .drawing,
           !QuestionResponseTypeResolver.looksLikeDrawingPrompt(lesson.creativePrompt.lowercased()),
           lesson.creativePrompt.lowercased().hasPrefix("write ") {
            messages.append("creativeResponseType is drawing but prompt looks like a writing task")
        }
        if lesson.creativeResponseType != .drawing,
           QuestionResponseTypeResolver.looksLikeDrawingPrompt(lesson.creativePrompt.lowercased()) {
            messages.append("creative prompt asks to draw but creativeResponseType is \(lesson.creativeResponseType.rawValue)")
        }
        if looksLikeMetaComprehensionPrompt(lesson.creativePrompt) {
            messages.append("creativePrompt asks the child to invent clues instead of retelling the story: \(lesson.creativePrompt)")
        }

        for (index, question) in (lesson.questions + lesson.mathChallenges).enumerated() {
            if question.responseTypeWasInferred {
                messages.append("Q\(index + 1) is missing explicit responseType (inferred \(question.responseType.rawValue)): \(question.prompt)")
            }
            switch question.responseType {
            case .matching where !question.hasValidMatchingData:
                messages.append("Q\(index + 1) matching without pairs: \(question.prompt)")
            case .sorting where !question.hasValidSortingData:
                messages.append("Q\(index + 1) sorting without items: \(question.prompt)")
            case .sorting:
                messages.append("Q\(index + 1) uses unsupported arranging activity: \(question.prompt)")
            case .multipleChoice where question.choices.count < 2:
                messages.append("Q\(index + 1) multipleChoice without choices: \(question.prompt)")
            case .drawing where !question.choices.isEmpty:
                messages.append("Q\(index + 1) drawing should not include choices: \(question.prompt)")
            default:
                break
            }
        }
        return messages
    }

    static func validateLesson(_ lesson: Lesson) -> [String] {
        let keywords = topicKeywords(for: lesson.theme)
        let context = LessonContextBank.from(lesson: lesson)
        var messages: [String] = []

        for (index, question) in lesson.questions.enumerated() {
            let result = validate(
                question,
                topic: lesson.theme,
                topicKeywords: keywords,
                context: context,
                primarySubject: lesson.primarySubject,
                passage: lesson.readingPassage
            )
            for issue in result.issues {
                messages.append("Reading Q\(index + 1): \(issue.description)")
            }
            let mystery = MysteryQualityValidator.validate(
                question,
                topic: lesson.theme,
                passage: lesson.readingPassage,
                lessonTitle: lesson.title
            )
            for issue in mystery.issues {
                messages.append("Reading Q\(index + 1) mystery: \(issue.description)")
            }
        }
        for (index, question) in lesson.mathChallenges.enumerated() {
            let result = validate(
                question,
                topic: lesson.theme,
                topicKeywords: keywords,
                context: context,
                primarySubject: lesson.primarySubject
            )
            for issue in result.issues {
                messages.append("Math Q\(index + 1): \(issue.description)")
            }
            let mystery = MysteryQualityValidator.validate(
                question,
                topic: lesson.theme,
                passage: lesson.readingPassage,
                lessonTitle: lesson.title
            )
            for issue in mystery.issues {
                messages.append("Math Q\(index + 1) mystery: \(issue.description)")
            }
        }

        if lesson.primarySubject == .math {
            let ratio = lesson.mathAssessmentRatio
            if ratio < 0.70 {
                messages.append(Issue.insufficientMathFocus(ratio).description)
            }
        }

        return messages
    }

    private static func validateSubjectAlignment(
        _ question: LessonQuestion,
        primarySubject: PrimarySubject
    ) -> [Issue] {
        // Creative/reflection prompts are always allowed.
        if question.subject == .creative || question.subject == .reflection {
            return []
        }
        // Math-primary lessons should not present reading-only filler as the majority,
        // but individual reading/matching items can still appear for story context.
        if primarySubject == .math && question.subject == .reading {
            // Soft: only flag if the prompt is clearly unrelated to any math skill cue
            // and looks like a generic comprehension template about "notes" / homework.
            let lower = question.prompt.lowercased()
            let offTopic = ["notes", "homework", "classroom desk", "sandwich"]
            if offTopic.contains(where: { lower.contains($0) }) {
                return [.subjectMismatch("reading prompt uses content unrelated to the math lesson")]
            }
        }
        if primarySubject == .reading && question.subject == .math {
            // Math challenges live in mathChallenges; stray math in reading bucket is OK if thematic.
            return []
        }
        return []
    }

    private static func validateAgainstContext(
        _ question: LessonQuestion,
        context: LessonContextBank
    ) -> [Issue] {
        var issues: [Issue] = []
        let promptLower = question.prompt.lowercased()

        for excluded in context.excludedConcepts {
            if promptLower.contains(excluded.lowercased()) {
                issues.append(.unrelatedNoun(excluded))
            }
            for choice in question.choices where choice.lowercased().contains(excluded.lowercased()) {
                issues.append(.unrelatedNoun(excluded))
            }
        }

        // Fantasy transformation / impossible science distractors.
        let illogical = [
            "turned into", "left the ocean forever", "turns the fish invisible",
            "teleport", "became a rock", "magic only"
        ]
        for choice in question.choices {
            let lower = choice.lowercased()
            if illogical.contains(where: { lower.contains($0) }) {
                issues.append(.jokeOrAbsurdChoice(choice))
            }
        }

        return issues
    }

    /// Validates word-problem wording before a generated question is shown to a child.
    static func validateMathWordProblemPrompt(
        _ prompt: String,
        expectedAnswer: Int? = nil,
        operation: MathOperationHint? = nil
    ) -> [Issue] {
        var issues: [Issue] = []
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = trimmed.lowercased()

        if trimmed.isEmpty {
            issues.append(.mathPromptUnclear)
            return issues
        }

        // Must ask a clear question.
        let asksQuestion = trimmed.contains("?")
            || lower.contains("how many")
            || lower.contains("what is")
            || lower.contains("what time")
            || lower.contains("how many more")
            || lower.hasPrefix("a ") && lower.contains("how many")
        if !asksQuestion {
            issues.append(.mathPromptMissingQuestion)
        }

        // Legacy broken template fingerprints.
        let brokenFragments = [
            " treasures",
            " while ",
            " items.",
            " items?",
            " animals treasures",
            " space animals",
            " princess treasures",
            "jungle rocks",
            "while volcano"
        ]
        for fragment in brokenFragments {
            if lower.contains(fragment) {
                issues.append(.mathPromptFragment("\"\(fragment.trimmingCharacters(in: .whitespaces))\""))
                break
            }
        }

        // Tautological counting: answer is already stated in the stem.
        // e.g. "Lina sees 4 toucans. How many toucans does she see?"
        if lower.range(
            of: #"sees \d+ .+\. how many .+ (does|do) .+ see\?"#,
            options: .regularExpression
        ) != nil {
            issues.append(.mathPromptAnswerInStem)
        }
        // e.g. "Mia points to the number 7. Which number is 7?"
        if lower.range(
            of: #"points to the number (\d+).+which number is \1\?"#,
            options: .regularExpression
        ) != nil {
            issues.append(.mathPromptAnswerInStem)
        }

        // Specific legacy pattern: "shared N while …" or topic stuffing with helpers/items.
        if lower.range(of: #"shared \d+ while"#, options: .regularExpression) != nil {
            issues.append(.mathPromptFragment("shared … while"))
        }
        if lower.range(of: #"(animals|princesses|dinosaurs|horses) (items|helpers|treasures)"#, options: .regularExpression) != nil {
            issues.append(.mathPromptFragment("topic noun stuffed into filler object"))
        }
        if lower.range(of: #"\b\d+ [a-z ]+ helpers\b"#, options: .regularExpression) != nil
            && lower.contains("arrive") {
            issues.append(.mathPromptFragment("theme helpers stuffing"))
        }

        // Duplicate adjacent content words (e.g. "sea stars stars").
        let tokens = tokenize(lower)
        for index in 1..<tokens.count {
            if tokens[index] == tokens[index - 1] && tokens[index].count > 3 {
                issues.append(.mathPromptFragment("duplicated word \"\(tokens[index])\""))
                break
            }
        }

        // Singular/plural with number words / digits.
        if hasPluralMismatch(lower) {
            issues.append(.mathPromptBadPlural)
        }

        // Unclear counting: prompt never names a countable noun for numeric word problems.
        let looksLikeShapeOrTime = lower.contains("sides") || lower.contains("o'clock") || lower.contains("cents")
        if !looksLikeShapeOrTime {
            let hasCountableCue = lower.contains("how many")
                || lower.contains("difference")
                || lower.contains("altogether")
                || lower.contains("in all")
                || lower.contains("are left")
                || lower.contains("remain")
                || lower.contains("still have")
                || lower.contains("still there")
                || lower.contains("did you count")
                || lower.contains("can you count")
                || lower.contains("were there at the start")
                || lower.contains("joined")
                || lower.contains("each")
                || lower.contains("comes next")
                || lower.contains("which number")
                || lower.contains("which side")
                || lower.contains("how much")
                || lower.contains("more animals")
                || lower.contains("has more")
            if !hasCountableCue {
                issues.append(.mathPromptUnclear)
            }
        }

        if let operation, let expectedAnswer, operation.expectedAnswer != expectedAnswer {
            issues.append(.mathPromptAnswerMismatch)
        }

        return issues
    }

    /// Returns true when patterns like "1 sea stars" or "one dolphins" appear.
    private static func hasPluralMismatch(_ lower: String) -> Bool {
        // "1/one <plural-word>" — e.g. "one seashells", "1 dolphins"
        guard let match = lower.range(of: #"\b(1|one) ([a-z]+s)\b"#, options: .regularExpression) else {
            return false
        }
        if lower.range(of: #"\b(1|one) of\b"#, options: .regularExpression) != nil {
            return false
        }
        let snippet = String(lower[match])
        let noun = snippet.split(separator: " ").last.map(String.init) ?? ""
        let allowedPluralsAfterOne: Set<String> = [
            "hours", "cents", "sides", "inches", "meters", "steps", "feet", "is"
        ]
        return !allowedPluralsAfterOne.contains(noun)
    }

    /// Keywords used for topic-consistency checks (story world vocabulary).
    static func topicKeywords(for topic: Topic) -> [String] {
        let def = TopicLibrary.definition(for: topic)
        var words = Set(def.vocabularyWords.map { $0.lowercased() })
        words.formUnion(def.storySettings.flatMap { tokenize($0) })
        words.formUnion(def.mathContexts.flatMap { tokenize($0) })
        words.formUnion(tokenize(def.name))
        words.formUnion(categoryKeywords(for: def.category))
        words.formUnion(topicSpecificKeywords(topic))
        return Array(words)
    }

    // MARK: - Multiple Choice

    private static func validateMultipleChoice(
        _ question: LessonQuestion,
        topic: Topic?,
        topicKeywords: [String],
        context: LessonContextBank? = nil
    ) -> Result {
        var issues: [Issue] = []
        let choices = question.choices.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if choices.isEmpty {
            return Result(issues: [.emptyChoices])
        }
        if choices.count < 2 {
            issues.append(.tooFewChoices(choices.count))
        }

        let normalized = choices.map { $0.lowercased() }
        if Set(normalized).count != normalized.count {
            issues.append(.duplicateChoices)
        }

        if let correct = question.correctAnswer?.trimmingCharacters(in: .whitespacesAndNewlines),
           !correct.isEmpty {
            let correctNorm = correct.lowercased()
            if !normalized.contains(correctNorm) {
                issues.append(.missingCorrectAnswer)
            }
        } else if question.subject != .creative && question.subject != .reflection {
            issues.append(.missingCorrectAnswer)
        }

        switch question.subject {
        case .math:
            issues.append(contentsOf: validateMathChoices(choices, correctAnswer: question.correctAnswer))
            if let context {
                issues.append(contentsOf: validateMathSceneUsesContext(question.prompt, context: context))
            }
        case .reading, .vocabulary, .science:
            issues.append(contentsOf: validateReadingChoices(
                choices,
                topic: topic,
                topicKeywords: topicKeywords
            ))
            issues.append(contentsOf: validateStyleSimilarity(choices))
        case .creative, .reflection:
            break
        }

        return Result(issues: issues)
    }

    private static func validateMathSceneUsesContext(_ prompt: String, context: LessonContextBank) -> [Issue] {
        let lower = prompt.lowercased()
        // Flag classic off-theme fillers that appear in themed math lessons.
        let banned = ["notes and you read", "homework", "classroom desk", "sandwich", "there are 5 notes"]
        if banned.contains(where: { lower.contains($0) }) {
            return [.unrelatedNoun("off-theme math object")]
        }
        _ = context
        return []
    }

    private static func validateMathChoices(_ choices: [String], correctAnswer: String?) -> [Issue] {
        var issues: [Issue] = []
        var numbers: [Int] = []

        for choice in choices {
            if let value = parseNumber(choice) {
                numbers.append(value)
            } else {
                issues.append(.mathNonNumericChoice(choice))
            }
        }

        guard let correct = correctAnswer.flatMap(parseNumber), !numbers.isEmpty else {
            return issues
        }

        let maxDistance = max(5, abs(correct) / 2 + 3)
        for choice in choices {
            guard let value = parseNumber(choice), value != correct else { continue }
            if abs(value - correct) > maxDistance {
                issues.append(.mathDistractorTooFar(choice))
            }
        }
        return issues
    }

    private static func validateReadingChoices(
        _ choices: [String],
        topic: Topic?,
        topicKeywords: [String]
    ) -> [Issue] {
        var issues: [Issue] = []
        let keywords = Set(topicKeywords.map { $0.lowercased() })

        for choice in choices {
            let lower = choice.lowercased()
            if matchesJokePattern(lower, topic: topic) {
                issues.append(.jokeOrAbsurdChoice(choice))
                continue
            }
            if !keywords.isEmpty && looksUnrelated(lower, keywords: keywords, topic: topic) {
                issues.append(.unrelatedChoice(choice))
            }
        }
        return issues
    }

    private static func validateStyleSimilarity(_ choices: [String]) -> [Issue] {
        guard choices.count >= 2 else { return [] }
        let lengths = choices.map(\.count)
        guard let median = lengths.sorted().dropFirst((lengths.count - 1) / 2).first else { return [] }
        var issues: [Issue] = []
        for choice in choices {
            // Flag extreme outliers (e.g. one-word joke vs long correct sentence).
            if choice.count < max(3, median / 4) || choice.count > median * 4 + 20 {
                issues.append(.styleMismatch(choice))
            }
        }
        return issues
    }

    // MARK: - Heuristics

    /// Phrase-level absurd distractors. Prefer multi-word phrases; short nouns use word-boundary match
    /// so `"a hat"` does not flag `"a hatch sensor"` and `"a car"` does not flag wind-tunnel answers.
    private static let globalJokePatterns: [String] = [
        "a sandwich", "kind of sandwich", "sandwich flavor", "sandwiches for seagulls",
        "a pizza", "pizza slice", "candy shop", "chocolate frosting", "chocolate milk",
        "only ice cream", "frozen ice cream",
        "hidden socks", "color of their socks", "type of shoe", "inside a shoe", "through your shoes",
        "in a shoe", "inside a backpack", "eat homework", "sending emails", "by sending emails",
        "a bicycle", "bicycle wheel", "parking meter", "grocery moon", "grocery list", "grocery store",
        "a snowman", "roller skates", "made of rubber", "bounce like rubber", "made of pudding",
        "add soup", "a kind of soup", "pillow fluff", "bubble gum",
        "magic mail", "magic only", "magic capes", "magic clouds", "invisible paint", "stays invisible",
        "sleeping cats", "sleeping all day", "sleep, sleep, nap", "sleeps all day", "sleep for years",
        "a sleepy cat", "in a fishbowl", "under a rug", "inside pencils",
        "wants to fly", "paint the boat", "paint the ceiling", "paint the moon",
        "eat flashlights", "drives a bus", "fly to school", "flies away",
        "a math book", "a math problem", "paper plates",
        "by magic mail", "pink polka dot", "only pillows",
        "rabbits erase", "to look shiny", "only on tuesdays",
        "purple balloons", "snow piles", "eating only pencils", "hide the playbook",
        "in the parking lot", "grow hair", "sells ice cream", "on mars only always",
        "to the grocery moon", "float away",
        "tomorrow's lunch", "under the school",
        "fish live in trees", "cars swim", "bake a cake", "on the moon only",
        "a ringing phone", "a barking dog", "a goldfish",
        "a vegetable", "under a car",
        "into juice", "into a bird", "into candy", "becomes a bird",
        "grow feathers", "paint the sky", "magic tricks", "gravity stops",
        "sing a song", "sing louder", "floating cloud", "melt into soft wax",
        "hear colors", "taste shadows", "endless fuel",
        // Whole-choice only (matched exactly — not inside longer educational distractors)
        "never", "zero", "square", "banana", "thunder",
        "a shoe", "a chair", "a book", "a phone", "a hat", "a ball", "a kite", "a hose",
        "into a lake"
    ]

    private static let wholeChoiceOnlyJokePatterns: Set<String> = [
        "never", "zero", "square", "banana", "thunder",
        "a shoe", "a chair", "a book", "a phone", "a hat", "a ball", "a kite", "a hose"
    ]

    private static func matchesJokePattern(_ lower: String, topic: Topic?) -> Bool {
        let spaceTopics: Set<Topic> = [.space, .planets, .rockets]
        let isSpace = topic.map { spaceTopics.contains($0) } ?? false
        let vehicleTopics: Set<Topic> = [.cars, .airplanes, .trains]
        let isVehicle = topic.map { vehicleTopics.contains($0) } ?? false

        for pattern in globalJokePatterns {
            guard jokePatternAppears(pattern, in: lower) else { continue }

            // Allow legitimate topic answers that overlap joke phrases.
            if isSpace && (pattern.contains("moon") || pattern.contains("space") || pattern == "the moon" || pattern == "outer space") {
                continue
            }
            if topic == .volcanoes && (pattern.contains("volcano") || pattern == "a volcano") {
                continue
            }
            if topic == .sharks && (pattern == "a shark" || pattern == "a fish") {
                continue
            }
            if topic == .dinosaurs && (pattern == "a dinosaur" || pattern == "a fish") {
                continue
            }
            if topic == .oceanAnimals && (pattern == "a fish" || pattern == "a rock") {
                continue
            }
            if (topic == .castles || topic == .princesses) && pattern == "a castle wall" {
                continue
            }
            if topic == .robots && pattern == "a robot" {
                continue
            }
            if isSpace && (pattern == "a robot" || pattern == "a rock") {
                continue
            }
            // Vehicle science answers often contain "a car" / wind / wing wording — only flag
            // clear off-theme jokes like "under a car" for non-vehicle topics.
            if isVehicle && (pattern == "under a car" || pattern.contains("bicycle")) {
                // still flag bicycle jokes on car lessons
                if pattern.contains("bicycle") { return true }
                continue
            }
            return true
        }
        return false
    }

    /// Multi-word phrases may use substring match; short tokens require word boundaries.
    /// Ultra-short fillers like `"never"` only match the entire choice (not "sharks never rest").
    private static func jokePatternAppears(_ pattern: String, in lower: String) -> Bool {
        if lower == pattern { return true }
        if wholeChoiceOnlyJokePatterns.contains(pattern) {
            return false
        }
        let tokenCount = pattern.split(whereSeparator: { $0.isWhitespace || $0 == "," }).count
        if tokenCount >= 2 || pattern.count >= 12 {
            return lower.contains(pattern)
        }
        let escaped = NSRegularExpression.escapedPattern(for: pattern)
        let regex = #"\b"# + escaped + #"\b"#
        return lower.range(of: regex, options: .regularExpression) != nil
    }

    private static func looksUnrelated(_ lower: String, keywords: Set<String>, topic: Topic?) -> Bool {
        // Short abstract answers (curious, plants, etc.) often lack topic tokens — skip soft check.
        let tokens = Set(tokenize(lower))
        if tokens.count <= 2 { return false }

        let overlap = tokens.intersection(keywords)
        if !overlap.isEmpty { return false }

        // Common educational answer stems that are fine without topic nouns.
        let allowedStems = [
            "careful", "reading", "plan", "detail", "clue", "learn", "help",
            "friend", "team", "safe", "kind", "count", "number", "step"
        ]
        if tokens.contains(where: { allowedStems.contains($0) }) { return false }

        // Flag only when choice clearly belongs to a different domain.
        let foreignMarkers = ["bicycle", "parking meter", "grocery store", "sending emails", "eat homework"]
        if foreignMarkers.contains(where: { lower.contains($0) }) {
            return true
        }
        return false
    }

    private static func categoryKeywords(for category: TopicCategory) -> Set<String> {
        switch category {
        case .animals:
            return ["animal", "animals", "habitat", "herd", "baby", "nest", "trail", "forest", "ocean", "cave"]
        case .science:
            return [
                "space", "star", "planet", "rocket", "orbit", "moon", "astronaut", "crew", "launch", "galaxy",
                "science", "fact", "experiment", "earth", "weather", "volcano", "rock", "cloud"
            ]
        case .sports:
            return ["team", "ball", "goal", "court", "field", "player", "coach", "pass", "score", "practice"]
        case .fantasy:
            return [
                "castle", "kingdom", "princess", "fairy", "dragon", "tower", "garden", "ballroom", "moat",
                "map", "treasure", "compass", "clue", "adventure", "explore", "island", "path"
            ]
        case .vehicles:
            return ["engine", "wheel", "pilot", "track", "road", "flight", "train", "plane", "car", "station", "robot"]
        case .arts:
            return ["art", "music", "color", "draw", "song", "beat", "paint", "create", "story", "recipe"]
        case .nature:
            return ["nature", "forest", "bug", "leaf", "trail", "tree", "garden", "bird", "plant", "ecosystem"]
        }
    }

    private static func topicSpecificKeywords(_ topic: Topic) -> Set<String> {
        switch topic {
        case .sharks, .oceanAnimals:
            return ["reef", "shark", "coral", "fin", "gill", "ocean", "fish", "wave", "bubble", "lagoon", "kelp", "tide", "shell", "whale"]
        case .horses:
            return ["stable", "stall", "paddock", "foal", "mane", "hay", "barn", "pasture", "pony", "ponies", "gallop"]
        case .jungleAnimals:
            return ["canopy", "rainforest", "toucan", "jaguar", "frog", "vine", "leaf", "jungle", "habitat", "camouflage"]
        case .dinosaurs:
            return ["fossil", "herd", "species", "triceratops", "stegosaurus", "tyrannosaurus", "brachiosaurus", "ankylosaurus", "valley", "footprint", "egg", "horn", "plant", "bone", "museum"]
        case .space, .planets, .rockets:
            return ["moon", "orbit", "suit", "rocket", "crew", "planet", "asteroid", "gravity", "launch"]
        case .princesses, .castles, .fairies:
            return ["ballroom", "garden", "tower", "castle", "kingdom", "drawbridge", "moat", "library"]
        case .cars:
            return ["car", "cars", "brake", "wheel", "tire", "road", "engine", "garage", "fuel"]
        case .weather:
            return ["cloud", "clouds", "rain", "wind", "storm", "sky", "weather", "umbrella", "forecast"]
        case .airplanes:
            return ["plane", "wing", "flight", "pilot", "fuel", "runway", "cockpit"]
        case .trains:
            return ["train", "rail", "track", "engine", "station", "car"]
        default:
            return []
        }
    }

    private static func tokenize(_ text: String) -> [String] {
        text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 2 }
    }

    private static func parseNumber(_ text: String) -> Int? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let value = Int(trimmed) { return value }

        let words: [String: Int] = [
            "zero": 0, "one": 1, "two": 2, "three": 3, "four": 4, "five": 5,
            "six": 6, "seven": 7, "eight": 8, "nine": 9, "ten": 10,
            "eleven": 11, "twelve": 12, "thirteen": 13, "twenty": 20,
            "hundred": 100
        ]
        return words[trimmed.lowercased()]
    }
}
