import SwiftUI

struct LessonView: View {
    @ObservedObject var viewModel: LessonViewModel
    let onComplete: (ProgressSummary) -> Void

    @State private var showCelebration = false
    @State private var cardVisible = true
    @State private var celebrationTick = 0

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
                    earnedStars: viewModel.earnedStars
                )
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.top, DesignSystem.Spacing.md)

                GeometryReader { geo in
                    ScrollView {
                        VStack(alignment: .center, spacing: DesignSystem.Spacing.lg) {
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
        .onChange(of: viewModel.currentStepIndex) { _, _ in
            cardVisible = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                cardVisible = true
            }
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
        case .question(let moment, let question, let index, let total):
            questionView(moment: moment, question: question, index: index, total: total)
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
        return PrimaryGradientButton(
            title: playOpening ? "Start Practice" : (moment == .ending ? "See My Results" : moment.continueLabel),
            icon: playOpening ? "play.fill" : (moment == .ending ? "star.fill" : "arrow.right")
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
                StoryTextBlock(
                    text: story.storyOpening,
                    style: .narrative,
                    pointSize: viewModel.storyBodyFontSize,
                    centered: false
                )
            }
        case .reading:
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                let opening = story.storyOpening.trimmingCharacters(in: .whitespacesAndNewlines)
                let passage = story.readingPassage.trimmingCharacters(in: .whitespacesAndNewlines)
                if !opening.isEmpty {
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

    private var readingPassageText: String {
        story.readingPassage.trimmingCharacters(in: .whitespacesAndNewlines)
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
        question: LessonQuestion,
        index: Int,
        total: Int
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
            questionBody(moment: moment, question: question, index: index, total: total)
        } footer: {
            questionFooter(question: question)
        }
    }

    @ViewBuilder
    private func questionBody(
        moment: StoryMoment,
        question: LessonQuestion,
        index: Int,
        total: Int
    ) -> some View {
        let responseType = question.displayResponseType
        let isDrawing = responseType == .drawing

        VStack(spacing: isDrawing ? DesignSystem.Spacing.md : DesignSystem.Spacing.xl) {
            if total > 1 {
                Text("\(index) of \(total)")
                    .font(DesignSystem.Typography.title(14))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
            }

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
                QuestionCard(prompt: question.prompt)

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
                    message: viewModel.feedbackMessage(for: moment),
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
            PrimaryGradientButton(
                title: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "Continue" : "Try Again")
                    : "Check Answer",
                icon: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "arrow.right" : "arrow.counterclockwise")
                    : "checkmark"
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
            PrimaryGradientButton(
                title: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "Continue" : "Try Again")
                    : "Check Matches",
                icon: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "arrow.right" : "arrow.counterclockwise")
                    : "checkmark"
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
            PrimaryGradientButton(
                title: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "Continue" : "Try Again")
                    : "Check Order",
                icon: viewModel.showFeedback
                    ? (viewModel.isAnswerCorrect ? "arrow.right" : "arrow.counterclockwise")
                    : "checkmark"
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
            PrimaryGradientButton(title: "Finish Drawing!", icon: "star.fill") {
                withAnimation(DesignSystem.Animation.gentle) {
                    viewModel.submitOpenResponse(kind: .drawing)
                }
            }
            .disabled(!viewModel.hasDrawingContent)
        }
    }

    private var questionAdvanceButton: some View {
        PrimaryGradientButton(
            title: viewModel.isAnswerCorrect ? "Continue" : "Try Again",
            icon: viewModel.isAnswerCorrect ? "arrow.right" : "arrow.counterclockwise"
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
            PrimaryGradientButton(
                title: creativeButtonTitle(responseType: responseType, isArtQuest: isArtQuest),
                icon: responseType == .drawing ? "star.fill" : "paperplane.fill"
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
            PrimaryGradientButton(title: moment.continueLabel, icon: "heart.fill") {
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
            .padding(DesignSystem.Spacing.lg)
            .frame(maxWidth: .infinity)
            .background(DesignSystem.Colors.cardWhite.opacity(0.82))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))

            Spacer(minLength: DesignSystem.Spacing.sm)

            PrimaryGradientButton(title: "See My Results", icon: "star.fill") {
                onComplete(viewModel.makeProgressSummary())
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LessonView(
        viewModel: LessonViewModel(lesson: BundledLessons.sharkExplorer),
        onComplete: { _ in }
    )
}
