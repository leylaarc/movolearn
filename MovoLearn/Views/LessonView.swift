import SwiftUI
import UIKit

struct LessonView: View {
    @ObservedObject var viewModel: LessonViewModel
    let onComplete: (ProgressSummary) -> Void

    @ObservedObject private var speech = LessonSpeechReader.shared
    @State private var showCelebration = false
    @State private var cardVisible = true
    @State private var celebrationTick = 0
    @State private var readGeneration = 0

    private var story: LessonStoryContent { viewModel.lesson.story }
    private var topicAccent: Color { TopicPalette.color(for: viewModel.lesson.theme) }

    var body: some View {
        ZStack {
            StoryLessonBackground(topic: viewModel.lesson.theme)

            VStack(spacing: 0) {
                StoryJourneyProgress(
                    currentStep: viewModel.journeyStepNumber,
                    totalSteps: viewModel.totalSteps,
                    title: viewModel.phaseTitle,
                    subtitle: viewModel.lesson.title,
                    accent: topicAccent,
                    showsStars: viewModel.playKind != nil,
                    earnedStars: viewModel.earnedStars,
                    isReadingAloud: speech.isSpeaking,
                    onReadAloud: toggleReading
                )
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.top, DesignSystem.Spacing.md)

                GeometryReader { geo in
                    ScrollView {
                        VStack(alignment: .center, spacing: DesignSystem.Spacing.lg) {
                            if showsLessonStage {
                                lessonStage
                            }
                            if let step = viewModel.currentStep, cardVisible {
                                stepContent(for: step)
                                    .frame(maxWidth: .infinity)
                                    .frame(
                                        minHeight: max(0, geo.size.height - DesignSystem.Spacing.lg * 2),
                                        alignment: .top
                                    )
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            }
                        }
                        .padding(DesignSystem.Spacing.lg)
                        .frame(maxWidth: .infinity)
                        .animation(DesignSystem.Animation.gentle, value: viewModel.currentStepIndex)
                    }
                }
            }

            if showCelebration {
                CelebrationView()
                ConfettiView()
                    .frame(height: 220)
                    .offset(y: -40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sensoryFeedback(.success, trigger: celebrationTick)
        .onAppear {
            scheduleAutomaticReading()
        }
        .onDisappear {
            cancelScheduledReading()
            speech.stop()
        }
        .onChange(of: viewModel.currentStepIndex) { _, _ in
            cardVisible = false
            speech.stop()
            scheduleAutomaticReading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                cardVisible = true
            }
        }
        .onChange(of: viewModel.showFeedback) { _, showing in
            guard showing else { return }
            scheduleFeedbackReading()
        }
        .onChange(of: viewModel.revealedClueCount) { previous, count in
            guard count > previous else { return }
            scheduleClueReading(clueNumber: count)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            cancelScheduledReading()
            speech.stop()
        }
    }

    private func triggerCelebration() {
        celebrationTick += 1
        showCelebration = true
        CorrectAnswerChime.shared.playIfVolumeOn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            showCelebration = false
        }
    }

    @ViewBuilder
    private func stepContent(for step: LessonStep) -> some View {
        switch step {
        case .moment(let moment):
            storyMomentView(moment)
        case .question(let moment, let question, _, _):
            questionView(moment: moment, question: question)
        case .creative(let moment):
            creativeView(moment: moment)
        case .reflection(let moment):
            reflectionView(moment: moment)
        case .completion:
            completionView
        }
    }

    private func storyMomentView(_ moment: StoryMoment) -> some View {
        LessonPageStage(
            topic: viewModel.lesson.theme,
            title: viewModel.playKind == nil ? moment.title : viewModel.phaseTitle,
            kicker: (moment == .vocabulary || moment == .knowledge) ? "" : viewModel.encouragement(for: moment),
            accent: moment.pageAccent(topic: viewModel.lesson.theme),
            cardOpacity: (moment == .vocabulary || moment == .knowledge) ? 0.46 : 0.82
        ) {
            momentContent(moment)
        } footer: {
            continueButton(for: moment)
        }
    }

    private func continueButton(for moment: StoryMoment) -> some View {
        let playOpening = viewModel.playKind != nil && moment == .storyOpening
        return LessonContinueButton(
            title: playOpening ? "Start Practice" : (moment == .ending ? "See My Results" : moment.continueLabel)
        ) {
            if moment == .ending {
                onComplete(viewModel.makeProgressSummary())
            } else {
                withAnimation(DesignSystem.Animation.gentle) {
                    viewModel.advance()
                }
            }
        }
    }

    @ViewBuilder
    private func momentContent(_ moment: StoryMoment) -> some View {
        switch moment {
        case .storyOpening:
            if let playKind = viewModel.playKind {
                PlayRoundIntro(
                    topic: viewModel.lesson.theme,
                    kind: playKind,
                    lessonTitle: viewModel.lesson.title
                )
            } else {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    StoryTextBlock(
                        text: story.storyOpening,
                        style: .narrative,
                        pointSize: viewModel.storyBodyFontSize,
                        centered: false
                    )
                }
            }
        case .reading:
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                let opening = story.storyOpening.trimmingCharacters(in: .whitespacesAndNewlines)
                let passage = StoryTextDedup.withoutRepeatedBlock(story.readingPassage)
                if !opening.isEmpty, !StoryTextDedup.openingIsRetold(by: passage, opening: opening) {
                    StoryTextBlock(
                        text: opening,
                        style: .narrative,
                        pointSize: viewModel.storyBodyFontSize,
                        centered: false
                    )
                }
                if !passage.isEmpty, passage != opening {
                    StoryTextBlock(
                        text: passage,
                        style: .narrative,
                        pointSize: viewModel.storyBodyFontSize,
                        centered: false
                    )
                }
            }
        case .vocabulary:
            VocabularyWordsList(words: story.vocabularyWords)
        case .knowledge:
            KnowledgeFactsList(facts: story.knowledgeFacts)
        case .ending:
            VStack(spacing: DesignSystem.Spacing.md) {
                StoryTextBlock(text: story.storyEnding, style: .ending)
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "star.circle.fill")
                        .foregroundStyle(DesignSystem.Colors.sunshineYellow)
                        .symbolEffect(.bounce, value: moment.title)
                        .idlePulse(scale: 1.12)
                    Text("You helped complete today's adventure!")
                        .font(DesignSystem.Typography.title(17))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
        default:
            EmptyView()
        }
    }

    private var showsLessonStage: Bool {
        switch viewModel.currentStep {
        case .creative where viewModel.creativeResponseType == .drawing:
            return false
        case .question(_, let question, _, _) where question.displayResponseType == .drawing:
            return false
        default:
            return true
        }
    }

    private var lessonMentionsCat: Bool {
        let blob = "\(viewModel.lesson.title) \(story.storyOpening) \(story.readingPassage)"
        return blob.range(of: #"\bcats?\b"#, options: [.regularExpression, .caseInsensitive]) != nil
    }

    private var stageScene: StoryCountScene? {
        if case .question(_, let question, _, _) = viewModel.currentStep,
           let math = StoryCountScene.math(
               prompt: question.prompt,
               explanation: question.explanation,
               title: viewModel.lesson.title,
               opening: story.storyOpening,
               passage: story.readingPassage
           ) {
            return math
        }
        return StoryCountScene.story(
            title: viewModel.lesson.title,
            opening: story.storyOpening,
            passage: story.readingPassage,
            goals: viewModel.lesson.drawingQuestGoals
        )
    }

    /// The place in the lesson, shown behind the thing being counted.
    private var stageHabitat: LessonHabitat? {
        let blob = "\(viewModel.lesson.theme.rawValue) \(viewModel.lesson.title) \(story.storyOpening) \(story.readingPassage)"
        let mentionsVolcano = blob.range(of: #"\bvolcano(es)?\b"#, options: [.regularExpression, .caseInsensitive]) != nil
        guard mentionsVolcano, stageScene?.picture.name != "volcano" else { return nil }
        return .volcano
    }

    /// The passage or question is about rock that glows, so the picture uses red rock.
    private var stageShowsHotRock: Bool {
        var blob = "\(story.storyOpening) \(story.readingPassage)"
        if case .question(_, let question, _, _) = viewModel.currentStep {
            blob += " \(question.prompt) \(question.explanation)"
        }
        let lower = blob.lowercased()
        if lower.range(of: #"\b(hot|glowing) rocks?\b"#, options: .regularExpression) != nil {
            return true
        }
        return lower.contains("glows red")
    }

    @ViewBuilder
    private var lessonStage: some View {
        if let scene = stageScene {
            if scene.picture.name == "hero", isVisit(scene) {
                HeroFlightScene(showsCat: lessonMentionsCat)
            } else {
                StoryPictureStrip(
                    scene: scene,
                    accent: topicAccent,
                    rocketLaunch: isVisit(scene) && scene.picture.name == "rocket" ? .countdown : nil,
                    habitatOverride: stageHabitat,
                    showsHotRock: stageShowsHotRock
                )
                .id("\(viewModel.currentStepIndex)-\(scene.picture.name)")
            }
        } else {
            TopicStage(name: topicStageName(viewModel.lesson.theme))
        }
    }

    private func isVisit(_ scene: StoryCountScene) -> Bool {
        if case .visit = scene.arrangement { return true }
        return false
    }

    private func topicStageName(_ topic: Topic) -> String {
        TopicStageArt.name(for: topic)
    }

    private var readingPassageText: String {
        StoryTextDedup.withoutRepeatedBlock(story.readingPassage)
    }

    private func showsStoryWithQuestion(_ question: LessonQuestion, moment: StoryMoment) -> Bool {
        guard moment == .question else { return false }
        guard !readingPassageText.isEmpty else { return false }
        guard !question.isProgressiveMystery else { return false }
        guard question.displayResponseType != .drawing else { return false }
        return true
    }

    private func questionView(
        moment: StoryMoment,
        question: LessonQuestion
    ) -> some View {
        let isDrawing = question.displayResponseType == .drawing
        let showsStory = showsStoryWithQuestion(question, moment: moment)

        return LessonPageStage(
            topic: viewModel.lesson.theme,
            title: viewModel.playKind == nil ? moment.title : viewModel.phaseTitle,
            kicker: viewModel.encouragement(for: moment),
            accent: moment.pageAccent(topic: viewModel.lesson.theme),
            compactHeader: isDrawing || showsStory,
            expandsContent: isDrawing
        ) {
            questionBody(moment: moment, question: question)
        } footer: {
            questionFooter(question: question)
        }
    }

    @ViewBuilder
    private func questionBody(
        moment: StoryMoment,
        question: LessonQuestion
    ) -> some View {
        let responseType = question.displayResponseType
        let isDrawing = responseType == .drawing

        VStack(spacing: isDrawing ? DesignSystem.Spacing.md : DesignSystem.Spacing.xl) {
            if showsStoryWithQuestion(question, moment: moment) {
                ReadingPassageCard(
                    text: readingPassageText,
                    pointSize: min(viewModel.storyBodyFontSize, 22)
                )
            }

            if question.isProgressiveMystery {
                MysteryInvestigationView(
                    question: question,
                    topic: viewModel.lesson.theme,
                    accent: topicAccent,
                    revealedClueCount: viewModel.revealedClueCount,
                    earlyPrediction: viewModel.earlyPrediction,
                    showFeedback: viewModel.showFeedback,
                    isAnswerCorrect: viewModel.isAnswerCorrect,
                    selectedChoice: $viewModel.selectedAnswer,
                    onRevealClue: { viewModel.revealNextClue() },
                    onEarlyPrediction: { viewModel.recordEarlyPrediction($0) },
                    onFinalAnswer: { choice in
                        viewModel.selectAnswer(choice)
                        if viewModel.isAnswerCorrect {
                            triggerCelebration()
                        }
                    }
                )
            } else {
                QuestionCard(
                    prompt: StoryTextDedup.questionBesideStory(
                        question.prompt,
                        passage: showsStoryWithQuestion(question, moment: moment) ? readingPassageText : ""
                    )
                )

                QuestionAnswerInput(
                    responseType: responseType,
                    choices: question.choices,
                    correctAnswer: question.correctAnswer,
                    pairs: question.pairs,
                    items: question.items,
                    accent: topicAccent,
                    interactionID: question.id.uuidString,
                    textAnswer: $viewModel.openResponse,
                    selectedChoice: $viewModel.selectedAnswer,
                    hasDrawing: $viewModel.hasDrawingContent,
                    matchingComplete: $viewModel.matchingComplete,
                    matchingCorrect: $viewModel.matchingCorrect,
                    sortingOrderIDs: $viewModel.sortingOrderIDs,
                    sortingCorrect: $viewModel.sortingCorrect,
                    showFeedback: viewModel.showFeedback,
                    isAnswerCorrect: viewModel.isAnswerCorrect,
                    onSelectChoice: { choice in
                        viewModel.selectAnswer(choice)
                        if viewModel.isAnswerCorrect {
                            triggerCelebration()
                        }
                    },
                    drawingQuestGoals: responseType == .drawing
                        ? DrawingQuestGoals.goals(for: viewModel.lesson.theme)
                        : []
                )
                .frame(maxHeight: isDrawing ? .infinity : nil)
            }

            if shouldShowQuestionFeedback(for: question) {
                FeedbackCard(
                    isCorrect: viewModel.isAnswerCorrect,
                    message: viewModel.feedbackText,
                    explanation: question.explanation
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: isDrawing ? .infinity : nil)
        .onChange(of: viewModel.matchingComplete) { _, done in
            guard done, viewModel.matchingCorrect, !viewModel.showFeedback else { return }
            guard PlayGameCatalog.fitsMemory(question) else { return }
            viewModel.submitMatchingAnswer()
            if viewModel.isAnswerCorrect {
                triggerCelebration()
            }
        }
    }

    private func shouldShowQuestionFeedback(for question: LessonQuestion) -> Bool {
        guard viewModel.showFeedback else { return false }
        if question.isProgressiveMystery { return true }
        switch question.displayResponseType {
        case .number, .shortText, .longText, .matching, .sorting, .multipleChoice:
            return true
        default:
            return false
        }
    }

    @ViewBuilder
    private func questionFooter(question: LessonQuestion) -> some View {
        let responseType = question.displayResponseType

        if question.isProgressiveMystery {
            if viewModel.showFeedback {
                questionAdvanceButton
            }
        } else if responseType == .number || responseType == .shortText || responseType == .longText {
            LessonContinueButton(
                title: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "Continue" : "Try Again")
                    : "Check Answer"
            ) {
                if viewModel.showFeedback {
                    handleQuestionAdvance()
                } else {
                    viewModel.submitTypedAnswer()
                    if viewModel.isAnswerCorrect {
                        triggerCelebration()
                    }
                }
            }
            .disabled(!viewModel.showFeedback && viewModel.openResponse.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        } else if responseType == .matching {
            LessonContinueButton(
                title: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "Continue" : "Try Again")
                    : "Check Matches"
            ) {
                if viewModel.showFeedback {
                    handleQuestionAdvance()
                } else {
                    viewModel.submitMatchingAnswer()
                    if viewModel.isAnswerCorrect {
                        triggerCelebration()
                    }
                }
            }
            .disabled(!viewModel.showFeedback && !viewModel.matchingComplete)
        } else if responseType == .sorting {
            LessonContinueButton(
                title: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "Continue" : "Try Again")
                    : "Check Order"
            ) {
                if viewModel.showFeedback {
                    handleQuestionAdvance()
                } else {
                    viewModel.submitSortingAnswer()
                    if viewModel.isAnswerCorrect {
                        triggerCelebration()
                    }
                }
            }
            .disabled(!viewModel.showFeedback && viewModel.sortingOrderIDs.count < 2)
        } else if responseType == .multipleChoice {
            if viewModel.showFeedback {
                questionAdvanceButton
            }
        } else if responseType == .drawing {
            LessonContinueButton(title: "Finish Drawing!") {
                withAnimation(DesignSystem.Animation.gentle) {
                    viewModel.submitOpenResponse(kind: .drawing)
                }
            }
            .disabled(!viewModel.hasDrawingContent)
        }
    }

    private var questionAdvanceButton: some View {
        LessonContinueButton(
            title: viewModel.isAnswerCorrect ? "Continue" : "Try Again"
        ) {
            handleQuestionAdvance()
        }
    }

    private func handleQuestionAdvance() {
        if viewModel.isAnswerCorrect {
            withAnimation(DesignSystem.Animation.gentle) {
                viewModel.advance()
            }
        } else {
            viewModel.resetForRetry()
        }
    }

    private func creativeView(moment: StoryMoment) -> some View {
        let responseType = viewModel.creativeResponseType
        let displayPrompt = PromptWordingNormalizer.normalize(story.creativePrompt)
        let isArtQuest = viewModel.lesson.isArtQuest
        let questGoals = isArtQuest && responseType == .drawing
            ? DrawingQuestGoals.goals(
                for: viewModel.lesson.theme,
                authored: viewModel.lesson.drawingQuestGoals
            )
            : []

        return LessonPageStage(
            topic: viewModel.lesson.theme,
            title: isArtQuest ? viewModel.phaseTitle : moment.title,
            kicker: viewModel.encouragement(for: moment),
            accent: moment.pageAccent(topic: viewModel.lesson.theme),
            compactHeader: responseType == .drawing,
            expandsContent: responseType == .drawing
        ) {
            VStack(spacing: DesignSystem.Spacing.sm) {
                if isArtQuest && responseType != .drawing {
                    HStack(spacing: 8) {
                        Image(systemName: "star.circle.fill")
                            .foregroundStyle(DesignSystem.Colors.sunshineYellow)
                        Text("Earn up to 3 stars!")
                            .font(DesignSystem.Typography.title(16))
                            .foregroundStyle(DesignSystem.Colors.warmOrange)
                    }
                }

                StoryTextBlock(text: displayPrompt, style: responseType == .drawing ? .narrative : .mission)

                if let hint = creativeHint(for: responseType) {
                    Text(hint)
                        .font(DesignSystem.Typography.title(17))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }

                QuestionAnswerInput(
                    responseType: responseType,
                    choices: [],
                    correctAnswer: nil,
                    pairs: [],
                    items: [],
                    accent: topicAccent,
                    textAnswer: $viewModel.creativeResponse,
                    selectedChoice: $viewModel.selectedAnswer,
                    hasDrawing: $viewModel.hasDrawingContent,
                    matchingComplete: $viewModel.matchingComplete,
                    matchingCorrect: $viewModel.matchingCorrect,
                    sortingOrderIDs: $viewModel.sortingOrderIDs,
                    sortingCorrect: $viewModel.sortingCorrect,
                    drawingQuestGoals: questGoals
                )
                .frame(maxHeight: responseType == .drawing ? .infinity : nil)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: responseType == .drawing ? .infinity : nil)
        } footer: {
            LessonContinueButton(
                title: creativeButtonTitle(responseType: responseType, isArtQuest: isArtQuest)
            ) {
                withAnimation(DesignSystem.Animation.gentle) {
                    viewModel.submitCreativeResponse()
                }
            }
            .disabled(responseType == .drawing ? !viewModel.hasDrawingContent : false)
        }
    }

    private func creativeHint(for type: QuestionResponseType) -> String? {
        switch type {
        case .number:
            return "Tap the numbers to enter your answer."
        default:
            return nil
        }
    }

    private func creativeButtonTitle(responseType: QuestionResponseType, isArtQuest: Bool) -> String {
        if isArtQuest { return "I'm Done Drawing!" }
        return responseType == .drawing ? "Share My Drawing" : "Submit My Answer"
    }

    private func reflectionView(moment: StoryMoment) -> some View {
        let responseType = viewModel.reflectionResponseType
        let displayPrompt = PromptWordingNormalizer.normalize(story.reflectionPrompt)

        return LessonPageStage(
            topic: viewModel.lesson.theme,
            title: moment.title,
            kicker: viewModel.encouragement(for: moment),
            accent: moment.pageAccent(topic: viewModel.lesson.theme)
        ) {
            VStack(spacing: DesignSystem.Spacing.xl) {
                if viewModel.lesson.primarySubject != .math, !readingPassageText.isEmpty {
                    ReadingPassageCard(
                        text: readingPassageText,
                        pointSize: min(viewModel.storyBodyFontSize, 22)
                    )
                }

                StoryTextBlock(text: displayPrompt, style: .mission)

                QuestionAnswerInput(
                    responseType: responseType,
                    choices: [],
                    correctAnswer: nil,
                    pairs: [],
                    items: [],
                    accent: topicAccent,
                    textAnswer: $viewModel.reflectionResponse,
                    selectedChoice: $viewModel.selectedAnswer,
                    hasDrawing: $viewModel.hasDrawingContent,
                    matchingComplete: $viewModel.matchingComplete,
                    matchingCorrect: $viewModel.matchingCorrect,
                    sortingOrderIDs: $viewModel.sortingOrderIDs,
                    sortingCorrect: $viewModel.sortingCorrect
                )
            }
            .frame(maxWidth: .infinity)
        } footer: {
            LessonContinueButton(title: moment.continueLabel) {
                withAnimation(DesignSystem.Animation.gentle) {
                    viewModel.submitReflection()
                }
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Spacer(minLength: 0)

            VStack(spacing: DesignSystem.Spacing.lg) {
                ZStack {
                    CelebrationView()
                    MascotView(topic: viewModel.lesson.theme, size: 110, celebrate: true)
                }

                Text(viewModel.lesson.missionCompleteMessage)
                    .font(DesignSystem.Typography.headline(26))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
            }
            .frame(maxWidth: .infinity)

            LessonContinueButton(title: "See My Results") {
                onComplete(viewModel.makeProgressSummary())
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var allowsAutomaticReading: Bool {
        LessonSpeechReader.isEnabled
            && !UIAccessibility.isVoiceOverRunning
            && ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1"
    }

    private func toggleReading() {
        if speech.isSpeaking {
            cancelScheduledReading()
            speech.stop()
            return
        }
        cancelScheduledReading()
        speech.speak(currentSpokenLines())
    }

    private func scheduleAutomaticReading() {
        guard allowsAutomaticReading else { return }
        let generation = nextReadGeneration()
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 450_000_000)
            guard generation == readGeneration else { return }
            speech.speak(currentSpokenLines())
        }
    }

    private func scheduleFeedbackReading() {
        guard allowsAutomaticReading else { return }
        speech.stop()
        let generation = nextReadGeneration()
        let delay: UInt64 = viewModel.isAnswerCorrect ? 700_000_000 : 250_000_000
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: delay)
            guard generation == readGeneration else { return }
            speech.speak(currentSpokenLines())
        }
    }

    private func scheduleClueReading(clueNumber: Int) {
        guard allowsAutomaticReading else { return }
        guard case .question(_, let question, _, _) = viewModel.currentStep else { return }
        let lines = LessonReadAloudScript.newClueLines(question: question, clueNumber: clueNumber)
        guard !lines.isEmpty else { return }
        speech.stop()
        let generation = nextReadGeneration()
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 200_000_000)
            guard generation == readGeneration else { return }
            speech.speak(lines)
        }
    }

    private func cancelScheduledReading() {
        readGeneration += 1
    }

    private func nextReadGeneration() -> Int {
        readGeneration += 1
        return readGeneration
    }

    private func currentSpokenLines() -> [String] {
        if viewModel.showFeedback {
            let explanation: String?
            if case .question(_, let question, _, _) = viewModel.currentStep {
                explanation = question.explanation
            } else {
                explanation = nil
            }
            return LessonReadAloudScript.feedbackLines(
                message: viewModel.feedbackText,
                explanation: explanation
            )
        }
        return LessonReadAloudScript.lines(for: spokenPage())
    }

    private func spokenPage() -> LessonReadAloudScript.Page {
        let step = viewModel.currentStep ?? .completion
        let leadIn: String = {
            guard let moment = viewModel.currentMoment else { return "" }
            if moment == .vocabulary || moment == .knowledge { return "" }
            return viewModel.encouragement(for: moment)
        }()
        let drawingGoals: [String] = {
            switch step {
            case .question(_, let question, _, _) where question.displayResponseType == .drawing:
                return DrawingQuestGoals.goals(for: viewModel.lesson.theme)
            case .creative where viewModel.lesson.isArtQuest && viewModel.creativeResponseType == .drawing:
                return DrawingQuestGoals.goals(
                    for: viewModel.lesson.theme,
                    authored: viewModel.lesson.drawingQuestGoals
                )
            default:
                return []
            }
        }()
        let showsPassage: Bool = {
            guard case .question(_, let question, _, _) = step else { return false }
            return showsStoryWithQuestion(question, moment: viewModel.currentMoment ?? .question)
        }()
        return LessonReadAloudScript.Page(
            story: story,
            step: step,
            lessonTitle: viewModel.lesson.title,
            missionCompleteMessage: viewModel.lesson.missionCompleteMessage,
            playKind: viewModel.playKind,
            showsPassageWithQuestion: showsPassage,
            includePassageOnReflection: viewModel.lesson.primarySubject != .math && !readingPassageText.isEmpty,
            revealedClueCount: viewModel.revealedClueCount,
            drawingGoals: drawingGoals,
            leadIn: leadIn
        )
    }
}

#Preview {
    LessonView(
        viewModel: LessonViewModel(lesson: BundledLessons.sharkExplorer),
        onComplete: { _ in }
    )
}
