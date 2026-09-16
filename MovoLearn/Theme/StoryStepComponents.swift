import SwiftUI

// MARK: - Journey Progress

struct StoryJourneyProgress: View {
    let currentStep: Int
    let totalSteps: Int
    let title: String
    var subtitle: String = ""
    var accent: Color = DesignSystem.Colors.oceanTurquoise

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(DesignSystem.Typography.caption(12).weight(.bold))
                    .foregroundStyle(accent)
                    .monospacedDigit()
                Spacer()
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption(12))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .lineLimit(1)
                }
            }

            Text(title)
                .font(DesignSystem.Typography.title(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(DesignSystem.Colors.surfaceMuted)
                        .frame(height: 6)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [accent, accent.opacity(0.65)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: progress <= 0 ? 0 : max(8, geometry.size.width * progress), height: 6)
                        .animation(DesignSystem.Animation.gentle, value: currentStep)
                }
            }
            .frame(height: 6)
        }
    }

    private var progress: Double {
        guard totalSteps > 0 else { return 0 }
        // currentStep is 1-based; fill bar for completed prior steps only.
        return Double(max(0, currentStep - 1)) / Double(totalSteps)
    }
}

// MARK: - Story Card

struct StoryStepCard<Content: View>: View {
    let moment: StoryMoment
    let topic: Topic
    let content: Content

    init(moment: StoryMoment, topic: Topic, @ViewBuilder content: () -> Content) {
        self.moment = moment
        self.topic = topic
        self.content = content()
    }

    private var accent: Color {
        accentFor(moment)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            TopicSceneView(topic: topic, height: 138)
                .overlay(alignment: .bottomLeading) {
                    Text(moment.title.uppercased())
                        .font(DesignSystem.Typography.label(11))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(12)
                }

            HStack(spacing: DesignSystem.Spacing.sm) {
                SkillPill(skill: moment.badge)
                Spacer()
                Text("Step \(moment.stepNumber)")
                    .font(DesignSystem.Typography.caption(11).weight(.bold))
                    .foregroundStyle(accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(accent.opacity(0.12))
                    .clipShape(Capsule())
            }

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                content
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                .fill(DesignSystem.Gradients.kidCardFill(accent: accent))
                .shadow(
                    color: accent.opacity(0.28),
                    radius: DesignSystem.Shadow.cardElevated.radius,
                    y: DesignSystem.Shadow.cardElevated.y
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [accent.opacity(0.55), accent.opacity(0.22)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        }
    }

    private func accentFor(_ moment: StoryMoment) -> Color {
        switch moment {
        case .storyOpening, .mission, .ending:
            return TopicPalette.color(for: topic)
        case .reading, .question:
            return DesignSystem.Colors.skyBlue
        case .math:
            return DesignSystem.Colors.coralPink
        case .vocabulary:
            return DesignSystem.Colors.lavenderPurple
        case .knowledge:
            return DesignSystem.Colors.freshGreen
        case .creative:
            return DesignSystem.Colors.sunshineYellow
        case .reflection:
            return DesignSystem.Colors.warmOrange
        }
    }
}

struct StoryTextBlock: View {
    let text: String
    var style: Style = .narrative
    /// Optional override for age-adaptive reading size.
    var pointSize: CGFloat? = nil
    var centered: Bool = false

    enum Style {
        case narrative, mission, ending, fact
    }

    var body: some View {
        Text(text)
            .font(font)
            .lineSpacing(lineSpacing)
            .foregroundStyle(DesignSystem.Colors.deepNavy)
            .multilineTextAlignment(centered ? .center : .leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
    }

    private var font: Font {
        if let pointSize {
            return DesignSystem.Typography.title(pointSize)
        }
        switch style {
        case .narrative: return DesignSystem.Typography.title(21)
        case .mission: return DesignSystem.Typography.headline(24)
        case .ending: return DesignSystem.Typography.headline(26)
        case .fact: return DesignSystem.Typography.title(20)
        }
    }

    private var lineSpacing: CGFloat {
        let boost: CGFloat = pointSize != nil && (pointSize ?? 0) >= 22 ? 2 : 0
        switch style {
        case .narrative, .ending: return 10 + boost
        case .mission: return 8 + boost
        case .fact: return 8
        }
    }
}

struct VocabularyTreasureCard: View {
    let word: String
    let definition: String
    var accent: Color = DesignSystem.Colors.lavenderPurple

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(word)
                .font(DesignSystem.Typography.display(36))
                .foregroundStyle(accent)
                .minimumScaleFactor(0.55)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(definition)
                .font(DesignSystem.Typography.title(21))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .lineSpacing(7)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

typealias VocabularyCard = VocabularyTreasureCard

struct VocabularyWordsList: View {
    let words: [VocabularyWord]

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl) {
            ForEach(words) { entry in
                VocabularyTreasureCard(
                    word: entry.word,
                    definition: entry.definition
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct KnowledgeSparkCard: View {
    let fact: String
    var explanation: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(fact)
                .font(DesignSystem.Typography.headline(26))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .lineSpacing(7)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)

            if !shownExplanation.isEmpty {
                Text(shownExplanation)
                    .font(DesignSystem.Typography.title(20))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private var shownExplanation: String {
        KnowledgeFact.childFacingExplanation(fact: fact, explanation: explanation)
    }
}

typealias KnowledgeFactCard = KnowledgeSparkCard

struct KnowledgeFactsList: View {
    let facts: [KnowledgeFact]

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl) {
            ForEach(facts) { entry in
                KnowledgeSparkCard(fact: entry.fact, explanation: entry.childFacingExplanation)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct LessonPageStage<Content: View, Footer: View>: View {
    let topic: Topic
    let title: String
    let kicker: String
    var accent: Color
    var compactHeader: Bool = false
    var expandsContent: Bool = false
    var cardOpacity: Double = 0.82
    let content: Content
    let footer: Footer

    init(
        topic: Topic,
        title: String,
        kicker: String,
        accent: Color,
        compactHeader: Bool = false,
        expandsContent: Bool = false,
        cardOpacity: Double = 0.82,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.topic = topic
        self.title = title
        self.kicker = kicker
        self.accent = accent
        self.compactHeader = compactHeader
        self.expandsContent = expandsContent
        self.cardOpacity = cardOpacity
        self.content = content()
        self.footer = footer()
    }

    var body: some View {
        VStack(spacing: compactHeader ? DesignSystem.Spacing.md : DesignSystem.Spacing.lg) {
            if !expandsContent {
                Spacer(minLength: 0)
            }

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
                    MascotView(topic: topic, size: compactHeader ? 56 : 68, animates: true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(DesignSystem.Typography.sectionHeader(18))
                            .foregroundStyle(accent)

                        if !kicker.isEmpty {
                            Text(kicker)
                                .font(DesignSystem.Typography.title(compactHeader ? 16 : 18))
                                .foregroundStyle(DesignSystem.Colors.deepNavy)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxHeight: expandsContent ? .infinity : nil)
            }
            .padding(DesignSystem.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxHeight: expandsContent ? .infinity : nil)
            .background(DesignSystem.Colors.cardWhite.opacity(cardOpacity))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
            .layoutPriority(1)

            if !expandsContent {
                Spacer(minLength: DesignSystem.Spacing.sm)
            }

            footer
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: expandsContent ? .infinity : nil)
    }
}

// MARK: - Story Background

struct StoryLessonBackground: View {
    let topic: Topic

    var body: some View {
        ZStack {
            DesignSystem.Colors.backgroundWarm.ignoresSafeArea()

            DesignSystem.Gradients.topicBackground(topic)
                .opacity(0.48)
                .ignoresSafeArea()

            SoftBubbleAtmosphere(topic: topic, intensity: 1.15)

            FloatingShapeBackground(shapeCount: 6)
                .opacity(0.75)

            VStack {
                Spacer()
                WaveShape(phase: 0.6)
                    .fill(TopicPalette.color(for: topic).opacity(0.22))
                    .frame(height: 100)
            }
            .ignoresSafeArea()
        }
    }
}
