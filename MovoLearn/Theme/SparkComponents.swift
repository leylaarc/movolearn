import SwiftUI

// MARK: - Backgrounds

struct AnimatedGradientBackground: View {
    var colors: [Color] = DesignSystem.Gradients.welcomeAnimated

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let phase = (sin(t * 0.35) + 1) / 2

            ZStack {
                LinearGradient(
                    colors: [
                        colors[0].opacity(0.95 + phase * 0.05),
                        colors[1],
                        colors[2].opacity(0.90 + (1 - phase) * 0.10),
                        colors[3 % colors.count]
                    ],
                    startPoint: UnitPoint(x: 0.0 + phase * 0.15, y: 0),
                    endPoint: UnitPoint(x: 1.0 - phase * 0.15, y: 1)
                )

                RadialGradient(
                    colors: [DesignSystem.Colors.sunshineYellow.opacity(0.28 + phase * 0.12), .clear],
                    center: UnitPoint(x: 0.8, y: 0.15),
                    startRadius: 20,
                    endRadius: 280
                )

                RadialGradient(
                    colors: [DesignSystem.Colors.brightLavender.opacity(0.26), .clear],
                    center: UnitPoint(x: 0.1, y: 0.85),
                    startRadius: 10,
                    endRadius: 220
                )

                RadialGradient(
                    colors: [DesignSystem.Colors.coralPink.opacity(0.18), .clear],
                    center: UnitPoint(x: 0.5, y: 0.45),
                    startRadius: 8,
                    endRadius: 200
                )
            }
            .ignoresSafeArea()
        }
    }
}

struct FloatingShapeBackground: View {
    var shapeCount: Int = 4

    private let shapes: [(color: Color, size: CGFloat, x: CGFloat, y: CGFloat, delay: Double)] = [
        (DesignSystem.Colors.skyBlue, 160, -0.35, -0.38, 0),
        (DesignSystem.Colors.sunshineYellow, 120, 0.38, -0.30, 0.4),
        (DesignSystem.Colors.brightLavender, 90, 0.28, 0.35, 0.9),
        (DesignSystem.Colors.freshGreen, 75, -0.30, 0.25, 1.3),
        (DesignSystem.Colors.coralPink, 55, 0.42, 0.10, 1.8),
        (DesignSystem.Colors.warmOrange, 45, -0.42, 0.05, 2.2)
    ]

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<min(shapeCount, shapes.count), id: \.self) { i in
                let shape = shapes[i]
                FloatingBlob(color: shape.color, size: shape.size, delay: shape.delay)
                    .position(
                        x: geo.size.width * (0.5 + shape.x),
                        y: geo.size.height * (0.5 + shape.y)
                    )
            }
        }
        .allowsHitTesting(false)
    }
}

private struct FloatingBlob: View {
    let color: Color
    let size: CGFloat
    let delay: Double
    @State private var floating = false

    var body: some View {
        Circle()
            .fill(color.opacity(0.38))
            .frame(width: size, height: size)
            .blur(radius: 1)
            .offset(y: floating ? -10 : 10)
            .onAppear {
                withAnimation(DesignSystem.Animation.float.delay(delay)) {
                    floating = true
                }
            }
    }
}

/// Soft blurred orbs used across kid-facing screens (Home, Adventures, Rewards).
struct SoftBubbleAtmosphere: View {
    var accent: Color = DesignSystem.Colors.skyBlue
    var secondary: Color = DesignSystem.Colors.sunshineYellow
    var tertiary: Color = DesignSystem.Colors.lavenderPurple
    var intensity: Double = 1.0

    init(
        accent: Color = DesignSystem.Colors.skyBlue,
        secondary: Color = DesignSystem.Colors.sunshineYellow,
        tertiary: Color = DesignSystem.Colors.lavenderPurple,
        intensity: Double = 1.0
    ) {
        self.accent = accent
        self.secondary = secondary
        self.tertiary = tertiary
        self.intensity = intensity
    }

    init(topic: Topic, intensity: Double = 1.0) {
        self.accent = TopicPalette.color(for: topic)
        self.secondary = DesignSystem.Colors.sunshineYellow
        self.tertiary = DesignSystem.Colors.skyBlue
        self.intensity = intensity
    }

    var body: some View {
        GeometryReader { geo in
            let i = max(0.35, min(1.35, intensity))
            ZStack {
                Circle()
                    .fill(accent.opacity(0.42 * i))
                    .frame(width: geo.size.width * 0.92)
                    .blur(radius: 28)
                    .position(x: geo.size.width * 0.08, y: geo.size.height * 0.08)
                    .floating(offset: 10, delay: 0)

                Circle()
                    .fill(secondary.opacity(0.38 * i))
                    .frame(width: geo.size.width * 0.78)
                    .blur(radius: 32)
                    .position(x: geo.size.width * 0.94, y: geo.size.height * 0.22)
                    .floating(offset: 8, delay: 0.55)

                Circle()
                    .fill(tertiary.opacity(0.34 * i))
                    .frame(width: geo.size.width * 0.68)
                    .blur(radius: 30)
                    .position(x: geo.size.width * 0.62, y: geo.size.height * 0.82)
                    .floating(offset: 12, delay: 1.05)

                Circle()
                    .fill(DesignSystem.Colors.coralPink.opacity(0.28 * i))
                    .frame(width: geo.size.width * 0.48)
                    .blur(radius: 24)
                    .position(x: geo.size.width * 0.18, y: geo.size.height * 0.58)
                    .floating(offset: 9, delay: 0.8)

                Circle()
                    .fill(DesignSystem.Colors.freshGreen.opacity(0.26 * i))
                    .frame(width: geo.size.width * 0.42)
                    .blur(radius: 22)
                    .position(x: geo.size.width * 0.88, y: geo.size.height * 0.68)
                    .floating(offset: 7, delay: 1.3)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

/// Shared title block for kid tabs — optional mascot and trailing control.
struct KidScreenHeader<Trailing: View>: View {
    let title: String
    let subtitle: String
    var mascotTopic: Topic? = nil
    @ViewBuilder var trailing: () -> Trailing

    init(
        title: String,
        subtitle: String,
        mascotTopic: Topic? = nil,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.mascotTopic = mascotTopic
        self.trailing = trailing
    }

    var body: some View {
        HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
            if let mascotTopic {
                MascotView(topic: mascotTopic, size: 64, celebrate: false)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(DesignSystem.Typography.headline(28))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .accessibilityAddTraits(.isHeader)

                Text(subtitle)
                    .font(DesignSystem.Typography.subtitle(15))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
            }

            Spacer(minLength: 4)

            trailing()
        }
    }
}

/// Soft circular stat for kid dashboards.
struct SoftStatBubble: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color
    var floatDelay: Double = 0

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [tint, tint.opacity(0.72)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: tint.opacity(0.38), radius: 8, y: 3)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .floating(offset: 4, delay: floatDelay)

            Text(value)
                .font(DesignSystem.Typography.title(18))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .fixedSize(horizontal: false, vertical: true)

            Text(title)
                .font(DesignSystem.Typography.caption(12))
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(DesignSystem.Gradients.kidCardFill(accent: tint))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                .stroke(tint.opacity(0.38), lineWidth: 1.5)
        )
        .shadow(color: tint.opacity(0.22), radius: 10, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

struct ThemedLessonBackground: View {
    let topic: Topic

    var body: some View {
        ZStack {
            DesignSystem.Colors.backgroundWarm.ignoresSafeArea()

            DesignSystem.Gradients.topicBackground(topic)
                .opacity(0.42)
                .ignoresSafeArea()

            FloatingShapeBackground(shapeCount: 6)
                .opacity(0.72)

            VStack {
                Spacer()
                WaveShape(phase: 0.5)
                    .fill(TopicPalette.color(for: topic).opacity(0.22))
                    .frame(height: 120)
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Buttons

struct PrimaryGradientButton: View {
    let title: String
    var icon: String? = nil
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.title3.weight(.semibold))
                }
                Text(title)
            }
        }
        .buttonStyle(PrimaryButtonStyle(isEnabled: isEnabled))
        .disabled(!isEnabled)
    }
}

struct PrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        PrimaryGradientButton(title: title, isEnabled: isEnabled, action: action)
    }
}

struct SecondaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                }
                Text(title)
            }
        }
        .buttonStyle(SecondaryButtonStyle())
    }
}

// MARK: - Skill Pill

struct SkillPill: View {
    let skill: String

    private var color: Color {
        switch skill.lowercased() {
        case "reading", "comprehension": return DesignSystem.Colors.skyBlue
        case "math", "word problems", "logic": return DesignSystem.Colors.coralPink
        case "vocabulary": return DesignSystem.Colors.lavenderPurple
        case "science": return DesignSystem.Colors.freshGreen
        case "writing": return DesignSystem.Colors.oceanTurquoise
        case "creativity", "creative thinking", "creative": return DesignSystem.Colors.sunshineYellow
        default: return DesignSystem.Colors.warmOrange
        }
    }

    private var icon: String {
        switch skill.lowercased() {
        case "reading", "comprehension": return "book.fill"
        case "math", "word problems", "logic": return "plus.forwardslash.minus"
        case "vocabulary": return "textformat.abc"
        case "science": return "leaf.fill"
        case "writing": return "pencil.line"
        case "creativity", "creative thinking", "creative": return "paintbrush.fill"
        default: return "star.fill"
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
            Text(skill)
                .font(DesignSystem.Typography.captionText.weight(.semibold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                colors: [color.opacity(0.32), color.opacity(0.16)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(Capsule())
        .overlay(Capsule().stroke(color.opacity(0.45), lineWidth: 1.25))
        .shadow(color: color.opacity(0.22), radius: 4, y: 2)
    }
}

typealias ProgressPill = SkillPill

// MARK: - Lesson Hero Card

struct LessonHeroCard: View {
    let lesson: Lesson
    let onStart: () -> Void

    private var accent: Color { lesson.category.accentColor }

    var body: some View {
        LessonOptionCard(lesson: lesson, onStart: onStart)
    }
}

/// Premium chooser card for one of today's lesson adventures.
struct LessonOptionCard: View {
    let lesson: Lesson
    let onStart: () -> Void

    private var accent: Color { lesson.category.accentColor }
    private var topicAccent: Color { TopicPalette.color(for: lesson.theme) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                DesignSystem.Gradients.categoryGradient(lesson.category)
                    .opacity(0.92)

                DesignSystem.Gradients.topicBackground(lesson.theme)
                    .opacity(0.55)
                    .blendMode(.overlay)

                Circle()
                    .fill(.white.opacity(0.14))
                    .frame(width: 90, height: 90)
                    .offset(x: -30, y: -20)

                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 50, height: 50)
                    .offset(x: 120, y: 10)

                HStack(alignment: .bottom) {
                    TopicIllustrationView(topic: lesson.theme, size: 78, animate: true)
                        .floating(offset: 5, delay: 0.2)

                    Spacer(minLength: 0)

                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 5) {
                            Image(systemName: lesson.category.iconSystemName)
                                .font(.system(size: 10, weight: .bold))
                            Text(lesson.category.shortLabel.uppercased())
                                .font(DesignSystem.Typography.label(10))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.22))
                        .clipShape(Capsule())

                        Text("\(lesson.estimatedMinutes) min")
                            .font(DesignSystem.Typography.caption(11).weight(.semibold))
                            .foregroundStyle(.white.opacity(0.95))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.black.opacity(0.18))
                            .clipShape(Capsule())
                    }
                }
                .padding(DesignSystem.Spacing.md)
            }
            .frame(height: 128)

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.elementSpacing) {
                Text(lesson.title)
                    .font(DesignSystem.Typography.cardTitle)
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(TopicPalette.displayTitle(for: lesson.theme))
                    .font(DesignSystem.Typography.caption(12).weight(.bold))
                    .foregroundStyle(topicAccent)

                Text(lesson.teaser)
                    .font(DesignSystem.Typography.body(14))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
                    .lineSpacing(3)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 8) {
                    metaChip(icon: "sparkles", text: lesson.difficultyLabel)
                    metaChip(icon: "clock.fill", text: "\(lesson.estimatedMinutes) min")
                }

                FlowLayout(spacing: 6) {
                    ForEach(Array(lesson.skillsPracticed.prefix(3)), id: \.self) { skill in
                        SkillPill(skill: skill)
                    }
                }

                Button(action: onStart) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start Adventure")
                            .font(DesignSystem.Typography.button(16))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 52)
                    .background(DesignSystem.Gradients.categoryGradient(lesson.category))
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous))
                    .shadow(color: accent.opacity(0.28), radius: 8, y: 4)
                }
                .buttonStyle(BouncyCardButtonStyle())
            }
            .padding(DesignSystem.Spacing.cardPadding)
            .background(DesignSystem.Colors.cardWhite)
        }
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                .stroke(accent.opacity(0.20), lineWidth: 1.5)
        )
        .shadow(color: accent.opacity(0.20), radius: 16, y: 9)
    }

    private func metaChip(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(text)
                .font(DesignSystem.Typography.caption(11).weight(.semibold))
        }
        .foregroundStyle(accent)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(lesson.category.lightAccent)
        .clipShape(Capsule())
    }
}

typealias LessonCard = LessonOptionCard

// MARK: - Mascot View

enum MascotKind {
    case willaWhale
    case novaStar
    case dottieDino
    case sunnyHorse
    case sparkBuddy

    static func forTopic(_ topic: Topic) -> MascotKind {
        switch topic {
        case .sharks, .oceanAnimals, .pirates: return .willaWhale
        case .space, .planets, .rockets: return .novaStar
        case .dinosaurs, .volcanoes: return .dottieDino
        case .horses, .farmAnimals: return .sunnyHorse
        default: return .sparkBuddy
        }
    }

    var name: String {
        switch self {
        case .willaWhale: return "Willa"
        case .novaStar: return "Nova"
        case .dottieDino: return "Dottie"
        case .sunnyHorse: return "Sunny"
        case .sparkBuddy: return "Movo"
        }
    }
}

struct MascotView: View {
    let topic: Topic
    var size: CGFloat = 80
    var celebrate: Bool = false
    var animates: Bool = true

    @State private var bobbing = false
    @State private var pulse = false

    private var kind: MascotKind { MascotKind.forTopic(topic) }
    private var themeColor: Color { TopicPalette.color(for: topic) }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [themeColor.opacity(0.35), themeColor.opacity(0.1)],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )
                .frame(width: size * 1.1, height: size * 1.1)
                .scaleEffect(celebrate && pulse ? 1.08 : 1)

            mascotFace
                .scaleEffect(celebrate ? (pulse ? 1.06 : 1.0) : 1.0)
        }
        .offset(y: animates && bobbing ? -4 : 0)
        .onAppear {
            guard animates else { return }
            withAnimation(DesignSystem.Animation.bob) { bobbing = true }
            guard celebrate else { return }
            withAnimation(DesignSystem.Animation.twinkle) { pulse = true }
        }
    }

    @ViewBuilder
    private var mascotFace: some View {
        switch kind {
        case .willaWhale: whaleFace
        case .novaStar: starFace
        case .dottieDino: dinoFace
        case .sunnyHorse: horseFace
        case .sparkBuddy: buddyFace
        }
    }

    private var whaleFace: some View {
        ZStack {
            Ellipse()
                .fill(themeColor.opacity(0.85))
                .frame(width: size * 0.55, height: size * 0.38)
                .offset(y: size * 0.06)
            Circle()
                .fill(themeColor)
                .frame(width: size * 0.42, height: size * 0.42)
                .offset(x: -size * 0.08)
            mascotEyes(offsetY: -size * 0.04)
            smileArc.offset(x: -size * 0.08, y: size * 0.06)
            Circle()
                .fill(themeColor.opacity(0.5))
                .frame(width: size * 0.12)
                .offset(x: size * 0.22, y: -size * 0.02)
        }
    }

    private var starFace: some View {
        ZStack {
            StarShape(points: 5)
                .fill(
                    LinearGradient(
                        colors: [DesignSystem.Colors.sunshineYellow, DesignSystem.Colors.warmOrange],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            mascotEyes(offsetY: -size * 0.02)
            smileArc.offset(y: size * 0.1)
        }
    }

    private var dinoFace: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.15, style: .continuous)
                .fill(themeColor)
                .frame(width: size * 0.5, height: size * 0.42)
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(themeColor.opacity(0.7))
                    .frame(width: size * 0.1)
                    .offset(x: CGFloat(i - 1) * size * 0.12, y: -size * 0.28)
            }
            mascotEyes(offsetY: -size * 0.02)
            smileArc.offset(y: size * 0.08)
        }
    }

    private var horseFace: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.2, style: .continuous)
                .fill(themeColor)
                .frame(width: size * 0.48, height: size * 0.44)
            Ellipse()
                .fill(themeColor.opacity(0.6))
                .frame(width: size * 0.18, height: size * 0.28)
                .offset(x: -size * 0.2, y: -size * 0.12)
                .rotationEffect(.degrees(-20))
            mascotEyes(offsetY: -size * 0.02)
            smileArc.offset(y: size * 0.08)
        }
    }

    private var buddyFace: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [DesignSystem.Colors.coralPink, DesignSystem.Colors.brightLavender],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            mascotEyes(offsetY: -size * 0.02)
            smileArc.offset(y: size * 0.08)
        }
    }

    private func mascotEyes(offsetY: CGFloat) -> some View {
        HStack(spacing: size * 0.12) {
            eye
            eye
        }
        .offset(y: offsetY)
    }

    private var eye: some View {
        ZStack {
            Circle().fill(.white).frame(width: size * 0.12, height: size * 0.12)
            Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.06, height: size * 0.06)
        }
    }

    private var smileArc: some View {
        Path { path in
            path.addArc(center: .zero, radius: 8, startAngle: .degrees(20), endAngle: .degrees(160), clockwise: false)
        }
        .stroke(DesignSystem.Colors.deepNavy, lineWidth: 2)
        .frame(width: 16, height: 8)
    }
}

struct StarShape: Shape {
    let points: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.4
        for i in 0..<(points * 2) {
            let angle = (Double(i) * .pi / Double(points)) - .pi / 2
            let radius = i.isMultiple(of: 2) ? outer : inner
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Character Bubble

struct CharacterBubble: View {
    let topic: Topic
    let message: String
    var animates: Bool = true

    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
            MascotView(topic: topic, size: 52, animates: animates)

            Text(message)
                .font(DesignSystem.Typography.body(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .lineSpacing(4)
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.md + 2)
                .background {
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous)
                        .fill(DesignSystem.Gradients.kidCardFill(accent: TopicPalette.color(for: topic)))
                        .shadow(color: TopicPalette.color(for: topic).opacity(0.22), radius: 8, y: 3)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous)
                        .stroke(TopicPalette.color(for: topic).opacity(0.38), lineWidth: 1.5)
                )
                .overlay(alignment: .leading) {
                    BubbleTail()
                        .fill(DesignSystem.Colors.cardWhite)
                        .frame(width: 10, height: 12)
                        .offset(x: -6, y: 18)
                }
        }
    }
}

struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 2))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 2))
        path.closeSubpath()
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Lesson UI

struct LessonProgressBar: View {
    let progress: Double
    let title: String

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text(title)
                    .font(DesignSystem.Typography.caption(12))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .lineLimit(1)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(DesignSystem.Typography.caption(12).weight(.bold))
                    .foregroundStyle(DesignSystem.Colors.freshGreen)
                    .monospacedDigit()
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(DesignSystem.Colors.surfaceMuted)
                        .frame(height: 8)
                    Capsule()
                        .fill(DesignSystem.Gradients.progressBar)
                        .frame(width: max(8, geometry.size.width * progress), height: 8)
                        .animation(DesignSystem.Animation.gentle, value: progress)
                }
            }
            .frame(height: 8)
        }
    }
}

struct QuestionCard: View {
    let prompt: String

    var body: some View {
        Text(prompt)
            .font(DesignSystem.Typography.question(26))
            .foregroundStyle(DesignSystem.Colors.deepNavy)
            .multilineTextAlignment(.leading)
            .lineSpacing(7)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isIncorrect: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.md) {
                Text(text)
                    .font(DesignSystem.Typography.title(20))
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(accessibilityLabel)
                Spacer()
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(DesignSystem.Colors.successGreen)
                        .accessibilityHidden(true)
                        .transition(.scale.combined(with: .opacity))
                } else if isIncorrect {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.title2)
                        .foregroundStyle(DesignSystem.Colors.softRed)
                        .accessibilityHidden(true)
                } else if isSelected {
                    Image(systemName: "circle.fill")
                        .font(.caption)
                        .foregroundStyle(DesignSystem.Colors.skyBlue)
                        .accessibilityHidden(true)
                }
            }
            .foregroundStyle(DesignSystem.Colors.deepNavy)
            .padding(DesignSystem.Spacing.lg)
            .frame(minHeight: 64)
            .background {
                RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous)
                    .fill(backgroundColor)
                    .shadow(color: shadowColor, radius: isSelected || isCorrect ? 10 : 5, y: isSelected || isCorrect ? 5 : 2)
            }
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: isSelected || isCorrect || isIncorrect ? 2.5 : 1)
            )
            .scaleEffect(isCorrect ? 1.02 : 1)
        }
        .buttonStyle(BouncyCardButtonStyle())
        .sensoryFeedback(.selection, trigger: isSelected)
        .sensoryFeedback(.success, trigger: isCorrect)
        .animation(DesignSystem.Animation.cardSelectAnimation, value: isCorrect)
        .animation(DesignSystem.Animation.cardSelectAnimation, value: isIncorrect)
        .animation(DesignSystem.Animation.cardSelectAnimation, value: isSelected)
    }

    private var accessibilityLabel: String {
        if isCorrect { return "\(text), correct" }
        if isIncorrect { return "\(text), try again" }
        if isSelected { return "\(text), selected" }
        return text
    }

    private var backgroundColor: Color {
        if isCorrect { return DesignSystem.Colors.freshGreenLight }
        if isIncorrect { return DesignSystem.Colors.softRed.opacity(0.16) }
        if isSelected { return DesignSystem.Colors.skyBlueLight }
        return DesignSystem.Colors.sunshineYellowLight.opacity(0.45)
    }

    private var borderColor: Color {
        if isCorrect { return DesignSystem.Colors.successGreen.opacity(0.75) }
        if isIncorrect { return DesignSystem.Colors.softRed.opacity(0.55) }
        if isSelected { return DesignSystem.Colors.skyBlue.opacity(0.50) }
        return DesignSystem.Colors.cardBorder
    }

    private var shadowColor: Color {
        if isCorrect { return DesignSystem.Colors.successGreen.opacity(0.20) }
        if isSelected { return DesignSystem.Colors.skyBlue.opacity(0.16) }
        return DesignSystem.Shadow.softShadow.color
    }
}

typealias AnswerChoiceButton = AnswerButton

struct FeedbackCard: View {
    let isCorrect: Bool
    let message: String
    let explanation: String?

    @State private var bounce = false

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: isCorrect ? "star.circle.fill" : "lightbulb.fill")
                    .font(.title2)
                    .foregroundStyle(isCorrect ? DesignSystem.Colors.sunshineYellow : DesignSystem.Colors.warmOrange)
                    .scaleEffect(bounce ? 1.15 : 1)
                    .accessibilityHidden(true)

                Text(message)
                    .font(DesignSystem.Typography.title(18))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
            }

            if let explanation {
                Text(explanation)
                    .font(DesignSystem.Typography.title(17))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineSpacing(5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .transition(.opacity.combined(with: .move(edge: .bottom)).combined(with: .scale(scale: 0.97)))
        .onAppear {
            guard isCorrect else { return }
            withAnimation(DesignSystem.Animation.celebrate) { bounce = true }
        }
    }
}

// MARK: - Celebration

struct CelebrationView: View {
    @State private var animate = false

    private let particles: [(size: CGFloat, x: CGFloat, y: CGFloat, color: Color, symbol: String)] = [
        (16, -60, -80, DesignSystem.Colors.sunshineYellow, "star.fill"),
        (14, 50, -90, DesignSystem.Colors.coralPink, "sparkle"),
        (12, -40, -40, DesignSystem.Colors.freshGreen, "star.fill"),
        (15, 65, -50, DesignSystem.Colors.brightLavender, "sparkle"),
        (13, -70, 0, DesignSystem.Colors.skyBlue, "star.fill"),
        (11, 35, 10, DesignSystem.Colors.warmOrange, "sparkle"),
        (14, -15, -95, DesignSystem.Colors.coralPink, "star.fill"),
        (12, 70, -15, DesignSystem.Colors.freshGreen, "sparkle"),
        (10, -55, 30, DesignSystem.Colors.sunshineYellow, "star.fill"),
        (13, 20, -60, DesignSystem.Colors.brightLavender, "sparkle")
    ]

    var body: some View {
        ZStack {
            ForEach(particles.indices, id: \.self) { i in
                let p = particles[i]
                Image(systemName: p.symbol)
                    .font(.system(size: p.size))
                    .foregroundStyle(p.color)
                    .offset(x: animate ? p.x : 0, y: animate ? p.y : 0)
                    .opacity(animate ? 0 : 1)
                    .scaleEffect(animate ? 0.3 : 1)
                    .rotationEffect(.degrees(animate ? Double(i) * 40 : 0))
                    .animation(
                        .easeOut(duration: 0.8).delay(Double(i) * 0.03),
                        value: animate
                    )
            }
        }
        .allowsHitTesting(false)
        .onAppear { animate = true }
    }
}

struct SparkleOverlay: View {
    var body: some View {
        CelebrationView()
    }
}

struct ConfettiView: View {
    @State private var falling = false

    private let colors: [Color] = [
        DesignSystem.Colors.coralPink,
        DesignSystem.Colors.sunshineYellow,
        DesignSystem.Colors.freshGreen,
        DesignSystem.Colors.skyBlue
    ]

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<12, id: \.self) { i in
                confettiPiece(index: i, geo: geo)
            }
        }
        .allowsHitTesting(false)
        .onAppear { falling = true }
    }

    private func confettiPiece(index i: Int, geo: GeometryProxy) -> some View {
        let xPos = CGFloat(i % 6) / 6 * geo.size.width - geo.size.width * 0.42
        let yEnd = geo.size.height * 0.5
        let yStart = -geo.size.height * 0.08
        let w: CGFloat = i.isMultiple(of: 2) ? 6 : 5
        let h: CGFloat = i.isMultiple(of: 2) ? 9 : 7

        return RoundedRectangle(cornerRadius: 1.5)
            .fill(colors[i % colors.count].opacity(0.85))
            .frame(width: w, height: h)
            .rotationEffect(.degrees(falling ? Double(i * 31) : 0))
            .offset(x: xPos, y: falling ? yEnd : yStart)
            .opacity(falling ? 0 : 0.75)
            .animation(.easeIn(duration: 1.4 + Double(i % 3) * 0.2).delay(Double(i) * 0.06), value: falling)
    }
}

// MARK: - Streak & Headers

struct StreakBadge: View {
    let completedLessons: Int

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(completedLessons > 0 ? DesignSystem.Colors.warmOrange.opacity(0.15) : DesignSystem.Colors.surfaceMuted)
                    .frame(width: 36, height: 36)
                Image(systemName: completedLessons > 0 ? "flame.fill" : "sparkles")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(completedLessons > 0 ? DesignSystem.Colors.warmOrange : DesignSystem.Colors.skyBlue)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(completedLessons == 0 ? "Start your streak!" : "\(completedLessons) lesson\(completedLessons == 1 ? "" : "s") done")
                    .font(DesignSystem.Typography.sectionHeader(14))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                Text(completedLessons == 0 ? "Complete today's lesson to begin" : "Keep the learning going!")
                    .font(DesignSystem.Typography.caption(11))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, 12)
        .background(DesignSystem.Colors.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous)
                .stroke(DesignSystem.Colors.cardBorder, lineWidth: 1)
        )
        .shadow(color: DesignSystem.Shadow.chip.color, radius: 6, y: 2)
    }
}

struct SectionHeader: View {
    let badge: String
    let title: String
    var accent: Color = DesignSystem.Colors.coralPink

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(badge.uppercased())
                .font(DesignSystem.Typography.label())
                .foregroundStyle(accent)
                .tracking(0.5)
            Text(title)
                .font(DesignSystem.Typography.headline(24))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
        }
    }
}

// MARK: - Form Components

struct SparkInputCard<Content: View>: View {
    let icon: String
    let title: String
    let accent: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.body.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        LinearGradient(
                            colors: [accent, accent.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(color: accent.opacity(0.25), radius: 4, y: 2)

                Text(title)
                    .font(DesignSystem.Typography.sectionHeader(15))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
            }

            content
        }
        .padding(DesignSystem.Spacing.cardInner)
        .background(DesignSystem.Gradients.kidCardFill(accent: accent))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous)
                .stroke(accent.opacity(0.38), lineWidth: 1.5)
        )
        .shadow(color: accent.opacity(0.18), radius: DesignSystem.Shadow.card.radius, y: DesignSystem.Shadow.card.y)
    }
}

struct SelectableChip: View {
    let title: String
    let isSelected: Bool
    var accent: Color = DesignSystem.Colors.freshGreen
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(DesignSystem.Typography.body(16).weight(isSelected ? .semibold : .regular))
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.body.weight(.bold))
                        .foregroundStyle(accent)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .foregroundStyle(DesignSystem.Colors.deepNavy)
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, 14)
            .background {
                RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous)
                    .fill(isSelected ? DesignSystem.Gradients.kidCardFill(accent: accent) : LinearGradient(colors: [DesignSystem.Colors.skyBlueLight.opacity(0.45), DesignSystem.Colors.cardWhite], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous)
                    .stroke(isSelected ? accent : accent.opacity(0.22), lineWidth: isSelected ? 2 : 1.25)
            )
        }
        .buttonStyle(BouncyCardButtonStyle())
        .animation(DesignSystem.Animation.select, value: isSelected)
    }
}

struct SparkTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .font(DesignSystem.Typography.title(18))
            .foregroundStyle(DesignSystem.Colors.inputText)
            .tint(DesignSystem.Colors.inputCursor)
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, 14)
            .background(DesignSystem.Colors.inputBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous)
                    .stroke(DesignSystem.Colors.inputBorderStrong, lineWidth: 1.5)
            )
            .environment(\.colorScheme, .light)
    }
}

// MARK: - Parent Components

struct ParentInsightCard: View {
    let title: String
    let message: String
    var icon: String = "lightbulb.fill"
    var accent: Color = DesignSystem.Colors.skyBlue

    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(accent)
                .frame(width: 44, height: 44)
                .background(accent.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.smallRadius, style: .continuous))

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title.uppercased())
                    .font(DesignSystem.Typography.label())
                    .foregroundStyle(accent)
                    .tracking(0.5)
                Text(message)
                    .font(DesignSystem.Typography.parentInsightText)
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .sparkCard(accent: accent)
    }
}

struct ParentStatCard: View {
    let icon: String
    let title: String
    let value: String
    var subtitle: String? = nil
    let accent: Color

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(accent)
                .frame(width: 44, height: 44)
                .background(accent.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title.uppercased())
                    .font(DesignSystem.Typography.label())
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
                    .tracking(0.4)
                Text(value)
                    .font(DesignSystem.Typography.title(17))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                if let subtitle {
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption(12))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }
            Spacer()
        }
        .sparkCard()
    }
}

struct SkillMiniCard: View {
    let title: String
    let practiced: Bool

    private var color: Color {
        switch title {
        case "Reading": return DesignSystem.Colors.skyBlue
        case "Math": return DesignSystem.Colors.coralPink
        case "Vocabulary": return DesignSystem.Colors.brightLavender
        case "Science": return DesignSystem.Colors.freshGreen
        default: return DesignSystem.Colors.warmOrange
        }
    }

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: practiced ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundStyle(practiced ? color : DesignSystem.Colors.textTertiary.opacity(0.5))
            Text(title)
                .font(DesignSystem.Typography.caption(12))
                .foregroundStyle(practiced ? DesignSystem.Colors.deepNavy : DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.md)
        .background(practiced ? color.opacity(0.06) : DesignSystem.Colors.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous)
                .stroke(practiced ? color.opacity(0.25) : DesignSystem.Colors.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Empty State

struct EmptyStateCard: View {
    let icon: String
    let title: String
    let message: String
    var accent: Color = DesignSystem.Colors.skyBlue

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                    RadialGradient(
                        colors: [accent.opacity(0.55), accent.opacity(0.18)],
                        center: .center,
                        startRadius: 4,
                        endRadius: 48
                    )
                    )
                    .frame(width: 88, height: 88)
                    .floating(offset: 5, delay: 0.2)

                Image(systemName: icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(accent)
            }

            VStack(spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.title(20))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                Text(message)
                    .font(DesignSystem.Typography.subtitle(15))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xl)
        .padding(.horizontal, DesignSystem.Spacing.md)
        .background(DesignSystem.Gradients.kidCardFill(accent: accent))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous)
                .stroke(accent.opacity(0.38), lineWidth: 1.5)
        )
        .shadow(color: accent.opacity(0.22), radius: 14, y: 6)
    }
}

// MARK: - Welcome Hero

struct WelcomeHeroIllustration: View {
    private let orbitTopics: [Topic] = [.space, .sharks, .dinosaurs, .horses, .soccer, .princesses]
    private let orbitRadius: CGFloat = 100
    @State private var orbitAngle: Double = 0
    @State private var glowPulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            DesignSystem.Colors.sunshineYellow.opacity(glowPulse ? 0.42 : 0.22),
                            DesignSystem.Colors.coralPink.opacity(0.18),
                            DesignSystem.Colors.brightLavender.opacity(0.20),
                            .clear
                        ],
                        center: .center,
                        startRadius: 30,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)

            ForEach(0..<6, id: \.self) { i in
                ZStack {
                    Circle()
                        .fill(TopicPalette.color(for: orbitTopics[i]).opacity(0.15))
                        .frame(width: 52, height: 52)
                    TopicIllustrationView(topic: orbitTopics[i], size: 36, animate: false)
                }
                .offset(orbitOffset(for: i))
                .floating(offset: 4, delay: Double(i) * 0.3)
            }

            MascotView(topic: .space, size: 130, animates: true)
                .floating(offset: 6, delay: 0.5)
        }
        .frame(height: 270)
        .onAppear {
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                orbitAngle = 360
            }
            withAnimation(DesignSystem.Animation.twinkle) {
                glowPulse = true
            }
        }
    }

    private func orbitOffset(for index: Int) -> CGSize {
        let baseAngle = Double(index) * .pi / 3
        let angle = baseAngle + orbitAngle * .pi / 180
        return CGSize(
            width: CGFloat(Darwin.cos(angle)) * orbitRadius,
            height: CGFloat(Darwin.sin(angle)) * orbitRadius
        )
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        guard !subviews.isEmpty else { return (.zero, []) }

        let proposedWidth = proposal.width
        let maxWidth: CGFloat
        if let width = proposedWidth, width.isFinite, width > 0, width < 10_000 {
            maxWidth = width
        } else {
            maxWidth = 320
        }

        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var contentWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(ProposedViewSize(width: maxWidth, height: nil))
            let itemWidth = min(size.width, maxWidth)
            let itemHeight = size.height.isFinite ? size.height : 32
            if x + itemWidth > maxWidth, x > 0 {
                contentWidth = max(contentWidth, x - spacing)
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, itemHeight)
            x += itemWidth + spacing
            contentWidth = max(contentWidth, x - spacing)
        }

        let finalWidth = min(maxWidth, max(contentWidth, 1))
        let finalHeight = y + rowHeight
        return (CGSize(width: finalWidth, height: finalHeight.isFinite ? finalHeight : 32), positions)
    }
}
