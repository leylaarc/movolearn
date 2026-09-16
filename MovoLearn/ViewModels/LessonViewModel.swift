import Foundation
import SwiftUI
import OSLog

private let lessonLog = Logger(subsystem: "com.movolearn.app", category: "LessonViewModel")

enum LessonStep: Equatable {
    case moment(StoryMoment)
    case question(StoryMoment, LessonQuestion, index: Int, total: Int)
    case creative(StoryMoment)
    case reflection(StoryMoment)
    case completion
}

@MainActor
final class LessonViewModel: ObservableObject {
    @Published private(set) var currentStepIndex = 0
    @Published private(set) var responses: [ChildResponse] = []
    @Published var selectedAnswer: String?
    @Published var showFeedback = false
    @Published var isAnswerCorrect = false
    @Published var creativeResponse = ""
    @Published var reflectionResponse = ""
    @Published var openResponse = ""
    @Published var hasDrawingContent = false
    @Published var matchingComplete = false
    @Published var matchingCorrect = false
    @Published var sortingOrderIDs: [String] = []
    @Published var sortingCorrect = false
    @Published var revealedClueCount = 0
    @Published var earlyPrediction: String?
    @Published private(set) var predictionChanged = false

    let lesson: Lesson
    private let childId: UUID?
    private let ability: LearnerAbilityProfile?
    private let steps: [LessonStep]
    private let story: LessonStoryContent
    private var attemptCounts: [UUID: Int] = [:]

    var currentStep: LessonStep? {
        guard currentStepIndex < steps.count else { return nil }
        return steps[currentStepIndex]
    }

    var currentMoment: StoryMoment? {
        switch currentStep {
        case .moment(let moment), .question(let moment, _, _, _), .creative(let moment), .reflection(let moment):
            return moment
        case .completion, .none:
            return nil
        }
    }

    var totalSteps: Int { steps.count }

    var journeyStepNumber: Int { currentStepIndex + 1 }

    /// Larger story text and more visual scaffolding for younger / beginner learners.
    var prefersScaffoldedUI: Bool {
        ability?.needsScaffolding ?? false
    }

    var storyBodyFontSize: CGFloat {
        if ability?.prefersConcreteLanguage == true { return 24 }
        if ability?.age ?? 8 <= 7 { return 23 }
        return 22
    }

    var phaseTitle: String {
        switch currentStep {
        case .question(_, _, let index, let total):
            return "\(currentMoment?.title ?? "Question") (\(index) of \(total))"
        case .creative:
            return lesson.isArtQuest ? "Art Quest" : "Create Time"
        case .moment(let moment), .reflection(let moment):
            return moment.title
        case .completion:
            return "Complete!"
        case .none:
            return ""
        }
    }

    var progress: Double {
        guard !steps.isEmpty else { return 0 }
        // Steps not yet finished don't count — starting the first step is 0%.
        return Double(currentStepIndex) / Double(steps.count)
    }

    var isOnLastStep: Bool {
        currentStepIndex >= steps.count - 1
    }

    var estimatedMinutes: Int { lesson.estimatedMinutes }

    var creativeResponseType: QuestionResponseType {
        lesson.creativeResponseType
    }

    var reflectionResponseType: QuestionResponseType {
        lesson.reflectionResponseType
    }

    init(lesson: Lesson, childId: UUID? = nil, profile: ChildProfile? = nil, learningState: ChildLearningState? = nil) {
        self.lesson = lesson
        self.childId = childId
        if let profile {
            self.ability = LessonDifficultyRules.abilityProfile(for: profile, learningState: learningState)
        } else {
            self.ability = nil
        }
        self.story = lesson.story
        self.steps = Self.buildSteps(from: lesson, ability: self.ability)
    }

    func selectAnswer(_ answer: String) {
        guard !showFeedback else { return }
        guard case .question(_, let question, _, _) = currentStep else { return }
        let responseType = question.displayResponseType
        guard responseType == .multipleChoice || responseType == .matching else {
            lessonLog.error("selectAnswer called for incompatible type \(responseType.rawValue)")
            return
        }

        selectedAnswer = answer
        let correct: Bool
        if let expected = question.correctAnswer, !expected.isEmpty {
            correct = answer == expected
        } else {
            correct = true
        }
        isAnswerCorrect = correct
        showFeedback = true
        attemptCounts[question.id, default: 0] += 1

        responses.append(
            ChildResponse(
                questionId: question.id,
                selectedAnswer: answer,
                isCorrect: correct
            )
        )
        recordQuestionAttempt(question: question, correct: correct, usedHint: false)
    }

    /// Submits a typed / number-pad answer for non-MCQ question steps.
    func submitTypedAnswer() {
        guard !showFeedback else { return }
        guard case .question(_, let question, _, _) = currentStep else { return }
        let responseType = question.displayResponseType
        guard responseType == .number || responseType == .shortText || responseType == .longText else {
            lessonLog.error("submitTypedAnswer for incompatible type \(responseType.rawValue)")
            return
        }

        let answer = openResponse.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !answer.isEmpty else { return }

        let correct: Bool
        if let expected = question.correctAnswer?.trimmingCharacters(in: .whitespacesAndNewlines),
           !expected.isEmpty {
            correct = answer.lowercased() == expected.lowercased()
                || normalizeNumber(answer) == normalizeNumber(expected)
        } else {
            correct = true
        }

        selectedAnswer = answer
        isAnswerCorrect = correct
        showFeedback = true
        attemptCounts[question.id, default: 0] += 1

        responses.append(
            ChildResponse(
                questionId: question.id,
                selectedAnswer: answer,
                isCorrect: correct
            )
        )
        recordQuestionAttempt(question: question, correct: correct, usedHint: false)
    }

    func submitMatchingAnswer() {
        guard !showFeedback else { return }
        guard case .question(_, let question, _, _) = currentStep else { return }
        guard question.displayResponseType == .matching, matchingComplete else { return }

        isAnswerCorrect = matchingCorrect
        showFeedback = true
        attemptCounts[question.id, default: 0] += 1
        responses.append(
            ChildResponse(
                questionId: question.id,
                selectedAnswer: matchingCorrect ? "Matched correctly" : "Matched incorrectly",
                isCorrect: matchingCorrect
            )
        )
        recordQuestionAttempt(question: question, correct: matchingCorrect, usedHint: false)
    }

    func submitSortingAnswer() {
        guard !showFeedback else { return }
        guard case .question(_, let question, _, _) = currentStep else { return }
        guard question.displayResponseType == .sorting else { return }

        let correctOrder = question.correctlyOrderedItemIDs
        let correct = sortingOrderIDs == correctOrder
        sortingCorrect = correct
        isAnswerCorrect = correct
        showFeedback = true
        responses.append(
            ChildResponse(
                questionId: question.id,
                selectedAnswer: correct ? "Sorted correctly" : "Sorted incorrectly",
                isCorrect: correct
            )
        )
    }

    func submitOpenResponse(kind: QuestionResponseType) {
        guard case .question(_, let question, _, _) = currentStep else { return }

        let label: String
        switch kind {
        case .drawing:
            label = hasDrawingContent ? "Shared a drawing" : "Skipped drawing"
        case .sorting:
            label = "Completed sorting"
        default:
            label = openResponse.isEmpty ? "Shared a response" : openResponse
        }

        responses.append(
            ChildResponse(
                questionId: question.id,
                selectedAnswer: label,
                isCorrect: true
            )
        )
        advance()
    }

    func resetForRetry() {
        selectedAnswer = nil
        showFeedback = false
        isAnswerCorrect = false
        openResponse = ""
        matchingComplete = false
        matchingCorrect = false
        // Keep the first scored attempt in `responses` so a later correct retry
        // does not turn the lesson recap into 100%.
        // Keep sortingOrderIDs so the child can adjust without a full reshuffle.
        // Keep revealed clues and early prediction for mystery scaffolding.
    }

    func revealNextClue() {
        guard case .question(_, let question, _, _) = currentStep else { return }
        guard question.isProgressiveMystery else { return }
        revealedClueCount = min(revealedClueCount + 1, question.clues.count)
    }

    func recordEarlyPrediction(_ choice: String) {
        if let prior = earlyPrediction, prior != choice {
            predictionChanged = true
        }
        earlyPrediction = choice
    }

    private func resetMysteryProgress() {
        revealedClueCount = 0
        earlyPrediction = nil
        predictionChanged = false
    }

    func submitCreativeResponse() {
        guard case .creative = currentStep else { return }

        let responseType = creativeResponseType
        let creativeQuestion = LessonQuestion(
            subject: .creative,
            type: .openEnded,
            responseType: responseType,
            prompt: story.creativePrompt,
            correctAnswer: nil,
            inferenceContext: .init(lessonID: lesson.id, lessonTitle: lesson.title)
        )

        let answer: String
        switch responseType {
        case .drawing:
            answer = hasDrawingContent ? "Shared a drawing" : "Shared an idea"
        default:
            answer = creativeResponse.isEmpty ? "Shared an idea" : creativeResponse
        }

        responses.append(
            ChildResponse(
                questionId: creativeQuestion.id,
                selectedAnswer: answer,
                isCorrect: true
            )
        )
        advance()
    }

    func submitReflection() {
        guard case .reflection = currentStep else { return }

        let responseType = reflectionResponseType
        let reflectionQuestion = LessonQuestion(
            subject: .reflection,
            type: .openEnded,
            responseType: responseType,
            prompt: story.reflectionPrompt,
            correctAnswer: nil,
            inferenceContext: .init(lessonID: lesson.id, lessonTitle: lesson.title)
        )

        let answer: String
        if responseType == .drawing {
            answer = hasDrawingContent ? "Shared a drawing" : "Thought about it"
        } else {
            answer = reflectionResponse.isEmpty ? "Thought about it" : reflectionResponse
        }

        responses.append(
            ChildResponse(
                questionId: reflectionQuestion.id,
                selectedAnswer: answer,
                isCorrect: true
            )
        )
        advance()
    }

    func advance() {
        selectedAnswer = nil
        showFeedback = false
        isAnswerCorrect = false
        creativeResponse = ""
        reflectionResponse = ""
        openResponse = ""
        hasDrawingContent = false
        matchingComplete = false
        matchingCorrect = false
        sortingOrderIDs = []
        sortingCorrect = false
        resetMysteryProgress()

        guard currentStepIndex + 1 < steps.count else { return }
        currentStepIndex += 1
        persistInProgressPercent()
    }

    private func persistInProgressPercent() {
        guard let childId else { return }
        let total = max(1, steps.count - 1) // exclude completion step
        let percent = min(95, Int((Double(currentStepIndex) / Double(total)) * 100))
        HomeActivityStore.shared.updateInProgressPercent(percent, childId: childId)
    }

    func makeProgressSummary() -> ProgressSummary {
        // First attempt per question is the score — retries are for learning, not a do-over.
        var seen = Set<UUID>()
        var total = 0
        var correct = 0
        for response in responses {
            guard seen.insert(response.questionId).inserted else { continue }
            guard let question = findQuestion(id: response.questionId) else { continue }
            let type = question.displayResponseType
            let scored = type == .multipleChoice
                || type == .number
                || type == .matching
                || type == .sorting
                || question.type == .multipleChoice
            guard scored else { continue }
            total += 1
            if response.isCorrect { correct += 1 }
        }

        return ProgressSummary(
            from: lesson,
            totalQuestions: total,
            correctAnswers: correct
        )
    }

    func feedbackMessage(for moment: StoryMoment) -> String {
        let scaffolding = ability?.needsScaffolding ?? true
        let young = (ability?.age ?? 7) <= 7
        let expectations: AgeGradeLearningStandards.Expectations? = {
            guard let ability else { return nil }
            return AgeGradeLearningStandards.expectations(
                age: ability.age,
                grade: ability.grade,
                readingLevel: ability.readingLevel,
                mathLevel: ability.mathLevel
            )
        }()
        let tone = expectations?.feedbackTone ?? (young ? .warmScaffolded : .guidedHint)

        if isAnswerCorrect {
            if young || tone == .warmScaffolded {
                switch moment {
                case .math: return "Yes! Great counting."
                case .question: return "Yes! That matches the story."
                default: return "Great work!"
                }
            }
            switch moment {
            case .question:
                if case .question(_, let question, _, _) = currentStep, question.isProgressiveMystery {
                    return "Sharp detective work — the clues support that answer!"
                }
                return [
                    "Great reading — you spotted the clue!",
                    "Yes! That matches the story.",
                    "Amazing thinking. The mission continues."
                ].randomElement()!
            case .math:
                return [
                    "Yes! You solved part of the mission.",
                    "Perfect counting — the adventure moves on!",
                    "Wonderful math thinking!"
                ].randomElement()!
            default:
                return "Great work!"
            }
        }

        // Incorrect — teach, don't just say "try again". Tone follows age/skill band.
        if case .question(_, let question, _, _) = currentStep {
            let attempts = attemptCounts[question.id, default: 1]
            let explanation = question.explanation?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let showExplanation: Bool = {
                guard !explanation.isEmpty else { return false }
                switch tone {
                case .warmScaffolded: return true
                case .guidedHint: return scaffolding || attempts >= 2
                case .independentReflect: return attempts >= 2
                }
            }()
            if showExplanation {
                switch tone {
                case .warmScaffolded:
                    return "Almost! Here's a tip: \(explanation)"
                case .guidedHint:
                    return "Not quite. Think about this: \(explanation)"
                case .independentReflect:
                    return "Check the evidence again. Hint: \(explanation)"
                }
            }
            if question.isProgressiveMystery {
                switch tone {
                case .warmScaffolded:
                    return "Almost. Look at each clue again. Which choice fits all of them?"
                case .guidedHint:
                    return "Re-read the clues and choose the conclusion they all support."
                case .independentReflect:
                    return "Which answer is supported by every clue? Re-check the chain of evidence."
                }
            }
        }

        switch moment {
        case .question:
            switch tone {
            case .warmScaffolded:
                return "Almost. Look back at the story words and try again."
            case .guidedHint:
                return "Check the passage for evidence, then choose again."
            case .independentReflect:
                return "Find the sentence that proves your answer, then choose again."
            }
        case .math:
            switch tone {
            case .warmScaffolded:
                return "Good try. Count the groups carefully, one by one."
            case .guidedHint:
                return "Re-check the numbers in the problem, then solve again."
            case .independentReflect:
                return "What operation fits the story? Solve again with that plan."
            }
        default:
            return "You're close — check the story one more time."
        }
    }

    func encouragement(for moment: StoryMoment) -> String {
        let mascot = MascotKind.forTopic(lesson.theme).name
        let young = (ability?.age ?? 7) <= 7
        switch moment {
        case .storyOpening:
            return young ? "Let's begin!" : lesson.lessonType.introPhrase
        case .mission:
            return young ? "\(mascot) needs your help!" : "\(mascot) needs your help — are you ready?"
        case .reading:
            return young
                ? "Read each sentence. Picture what you see."
                : "Read carefully and notice details you can use later."
        case .question:
            return young ? "Think about what you just read." : "Use evidence from the story to decide."
        case .math:
            return young ? "Use your fingers or count out loud if you need to." : "Use the story numbers to figure it out."
        case .vocabulary:
            return young ? "This new word helps you understand the story." : "Every new word strengthens your reading power."
        case .knowledge:
            return young ? "Here's a true fact from your adventure." : "Here's a science fact to remember."
        case .creative:
            if lesson.isArtQuest {
                return young
                    ? "Art Quest! Draw your scene and chase those stars!"
                    : "Art Quest unlocked — draw the story scene and earn your stars!"
            }
            if lesson.creativeResponseType == .drawing {
                return young
                    ? "Time to create — draw a moment from the story!"
                    : "Draw one moment from the story you just read."
            }
            return young
                ? "Answer using what happened in the story."
                : "Use details from the story in your answer."
        case .reflection:
            return young
                ? "One last star — answer this about the lesson!"
                : "Star Moment: one more question from today’s adventure."
        case .ending:
            return young ? "You did it!" : "You did it! Let's celebrate your adventure."
        }
    }

    private func recordQuestionAttempt(question: LessonQuestion, correct: Bool, usedHint: Bool) {
        guard let childId else { return }
        LearningSessionRecorder.recordQuestionAnswered(
            childId: childId,
            lesson: lesson,
            question: question,
            wasCorrect: correct,
            usedHint: usedHint
        )
    }

    private func findQuestion(id: UUID) -> LessonQuestion? {
        for question in story.readingQuestions + story.mathQuestions {
            if question.id == id { return question }
        }
        for section in lesson.sections {
            if let question = section.questions.first(where: { $0.id == id }) {
                return question
            }
        }
        return nil
    }

    private func normalizeNumber(_ text: String) -> Int? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let value = Int(trimmed) { return value }
        let words: [String: Int] = [
            "zero": 0, "one": 1, "two": 2, "three": 3, "four": 4, "five": 5,
            "six": 6, "seven": 7, "eight": 8, "nine": 9, "ten": 10
        ]
        return words[trimmed.lowercased()]
    }

    private static func buildSteps(from lesson: Lesson, ability: LearnerAbilityProfile? = nil) -> [LessonStep] {
        let story = lesson.story

        // Pure Art Quests: short inspiration story → create → reflect. No quiz.
        if lesson.isArtQuest {
            var artSteps: [LessonStep] = [
                .moment(.storyOpening),
                .moment(.mission),
                .moment(.reading)
            ]
            if !story.creativePrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                artSteps.append(.creative(.creative))
            }
            if !story.reflectionPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                artSteps.append(.reflection(.reflection))
            }
            artSteps.append(.moment(.ending))
            artSteps.append(.completion)
            return artSteps
        }

        var steps: [LessonStep] = [
            .moment(.storyOpening),
            .moment(.mission),
            .moment(.reading)
        ]

        // Teach vocabulary and facts before testing when scaffolding is needed.
        let scaffold = ability?.needsScaffolding == true
        if scaffold, !story.vocabularyWords.isEmpty {
            steps.append(.moment(.vocabulary))
        }
        if scaffold, !story.knowledgeFacts.isEmpty {
            steps.append(.moment(.knowledge))
        }

        var readingQs = QuestionQualityValidator.filterForChildDisplay(story.readingQuestions, lesson: lesson)
        if lesson.primarySubject == .math {
            // Keep at most one non-math story question so math remains ≥70% of scored work.
            var kept: [LessonQuestion] = []
            var nonMathKept = 0
            for question in readingQs {
                if question.subject == .math {
                    kept.append(question)
                } else if nonMathKept < 1 {
                    kept.append(question)
                    nonMathKept += 1
                }
            }
            readingQs = kept
        }
        if let cap = ability?.rules.readingQuestionRange.upperBound {
            readingQs = QuestionQualityValidator.prefixPreservingMatching(readingQs, cap: cap)
        }
        for (index, question) in readingQs.enumerated() {
            steps.append(.question(.question, question, index: index + 1, total: readingQs.count))
        }

        var mathQs = QuestionQualityValidator.filterForChildDisplay(story.mathQuestions, lesson: lesson)
        if let cap = ability?.rules.mathQuestionRange.upperBound {
            mathQs = Array(mathQs.prefix(cap))
        }
        for (index, question) in mathQs.enumerated() {
            steps.append(.question(.math, question, index: index + 1, total: mathQs.count))
        }

        if !scaffold {
            if !story.vocabularyWords.isEmpty { steps.append(.moment(.vocabulary)) }
            if !story.knowledgeFacts.isEmpty { steps.append(.moment(.knowledge)) }
        }

        if !story.creativePrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            steps.append(.creative(.creative))
        }
        if !story.reflectionPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            steps.append(.reflection(.reflection))
        }
        steps.append(.moment(.ending))
        steps.append(.completion)
        return steps
    }
}

extension LessonStep {
    static func == (lhs: LessonStep, rhs: LessonStep) -> Bool {
        switch (lhs, rhs) {
        case (.moment(let a), .moment(let b)):
            return a == b
        case (.question(let aMoment, let aQ, let aI, let aT), .question(let bMoment, let bQ, let bI, let bT)):
            return aMoment == bMoment && aQ.id == bQ.id && aI == bI && aT == bT
        case (.creative(let a), .creative(let b)):
            return a == b
        case (.reflection(let a), .reflection(let b)):
            return a == b
        case (.completion, .completion):
            return true
        default:
            return false
        }
    }
}
