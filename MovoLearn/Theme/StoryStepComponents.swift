import SwiftUI

// MARK: - Journey Progress

struct StoryJourneyProgress: View {
    let currentStep: Int
    let totalSteps: Int
    let title: String
    var subtitle: String = ""
    var accent: Color = DesignSystem.Colors.oceanTurquoise
    var showsStars: Bool = false
    var earnedStars: Int = 0
    var isReadingAloud: Bool = false
    var onReadAloud: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack(alignment: .firstTextBaseline, spacing: DesignSystem.Spacing.sm) {
                Text(headline)
                    .font(DesignSystem.Typography.headline(26))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let onReadAloud {
                    ReadAloudButton(isSpeaking: isReadingAloud, accent: accent, action: onReadAloud)
                }
            }

            HStack(spacing: DesignSystem.Spacing.sm) {
                Text(stepLabel)
                    .font(DesignSystem.Typography.caption(13).weight(.semibold))
                    .foregroundStyle(DesignSystem.Colors.lessonMuted)
                    .lineLimit(1)
                Spacer(minLength: 8)
                SoundEffectsToggleButton(accent: DesignSystem.Colors.deepNavy)
                if showsStars {
                    HStack(spacing: 3) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(systemName: index < min(earnedStars, 3) ? "star.fill" : "star")
                                .font(.padScaled(size: 14, weight: .bold))
                                .foregroundStyle(
                                    index < min(earnedStars, 3)
                                        ? DesignSystem.Colors.sunshineYellow
                                        : DesignSystem.Colors.sunshineYellow.opacity(0.35)
                                )
                                .symbolEffect(.bounce, value: earnedStars)
                        }
                    }
                    .accessibilityLabel("\(min(earnedStars, 3)) of 3 stars")
                }
            }

            if totalSteps > 0 {
                HStack(spacing: 4) {
                    ForEach(0..<totalSteps, id: \.self) { index in
                        Capsule()
                            .fill(index < currentStep ? DesignSystem.Colors.deepNavy : DesignSystem.Colors.lessonLine)
                    }
                }
                .frame(height: 3)
                .accessibilityHidden(true)
                .animation(DesignSystem.Animation.gentle, value: currentStep)
            }
        }
    }

    private var headline: String {
        subtitle.isEmpty ? title : subtitle
    }

    private var stepLabel: String {
        let step = "\(max(currentStep, 1)) of \(max(totalSteps, 1))"
        if subtitle.isEmpty || title.isEmpty {
            return "Step \(step)"
        }
        return "\(title) · \(step)"
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
            TopicSceneView(topic: topic, height: DesignSystem.Metrics.scaled(138))
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

/// The lesson story, kept on screen while a child answers questions about it.
struct ReadingPassageCard: View {
    let text: String
    var pointSize: CGFloat = 20

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("The story")
                .font(DesignSystem.Typography.label(13))
                .foregroundStyle(DesignSystem.Colors.lessonMuted)

            passageText
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("The story. \(text)")
    }

    private var passageText: some View {
        Text(text)
            .font(DesignSystem.Typography.subtitle(pointSize))
            .foregroundStyle(DesignSystem.Colors.lessonMuted)
            .lineSpacing(DesignSystem.Metrics.scaled(6))
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
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
            .foregroundStyle(ink)
            .multilineTextAlignment(centered ? .center : .leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
    }

    private var font: Font {
        if let pointSize {
            return style == .narrative || style == .fact
                ? DesignSystem.Typography.subtitle(pointSize)
                : DesignSystem.Typography.title(pointSize)
        }
        switch style {
        case .narrative: return DesignSystem.Typography.subtitle(21)
        case .mission: return DesignSystem.Typography.headline(24)
        case .ending: return DesignSystem.Typography.headline(26)
        case .fact: return DesignSystem.Typography.subtitle(18)
        }
    }

    private var ink: Color {
        switch style {
        case .narrative, .fact: return DesignSystem.Colors.lessonMuted
        case .mission, .ending: return DesignSystem.Colors.deepNavy
        }
    }

    private var lineSpacing: CGFloat {
        let boost: CGFloat = pointSize != nil && (pointSize ?? 0) >= 22 ? 2 : 0
        switch style {
        case .narrative, .ending: return DesignSystem.Metrics.scaled(10 + boost)
        case .mission: return DesignSystem.Metrics.scaled(8 + boost)
        case .fact: return DesignSystem.Metrics.scaled(8)
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
                .font(DesignSystem.Typography.display(34))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .minimumScaleFactor(0.55)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(definition)
                .font(DesignSystem.Typography.subtitle(20))
                .foregroundStyle(DesignSystem.Colors.lessonMuted)
                .lineSpacing(DesignSystem.Metrics.scaled(7))
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
                .font(DesignSystem.Typography.headline(24))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .lineSpacing(DesignSystem.Metrics.scaled(6))
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)

            if !shownExplanation.isEmpty {
                Text(shownExplanation)
                    .font(DesignSystem.Typography.subtitle(18))
                    .foregroundStyle(DesignSystem.Colors.lessonMuted)
                    .lineSpacing(DesignSystem.Metrics.scaled(6))
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
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(maxHeight: expandsContent ? .infinity : nil)

            footer
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxHeight: expandsContent ? .infinity : nil)
    }
}

struct LessonContinueButton: View {
    let title: String
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignSystem.Typography.buttonText)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: DesignSystem.Metrics.scaled(52))
                .background(isEnabled ? DesignSystem.Colors.lessonCoral : DesignSystem.Colors.lessonCoral.opacity(0.35))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Story Background

struct StoryLessonBackground: View {
    let topic: Topic

    var body: some View {
        ZStack {
            DesignSystem.Colors.lessonCream.ignoresSafeArea()
            SoftBubbleAtmosphere(
                accent: DesignSystem.Colors.lessonSky,
                secondary: DesignSystem.Colors.lessonYellow,
                tertiary: DesignSystem.Colors.lavenderPurple,
                intensity: 0.55,
                showsSparkles: false
            )
        }
    }
}
