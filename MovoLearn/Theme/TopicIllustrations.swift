import SwiftUI

// MARK: - Topic Palette

enum TopicPalette {
    static func color(for topic: Topic) -> Color {
        TopicLibrary.definition(for: topic).primaryColor
    }

    static func gradientColors(for topic: Topic) -> [Color] {
        TopicLibrary.definition(for: topic).gradientColors
    }

    static func displayTitle(for topic: Topic) -> String {
        TopicLibrary.definition(for: topic).name
    }

    static func description(for topic: Topic) -> String {
        TopicLibrary.definition(for: topic).description
    }

    static func icon(for topic: Topic) -> String {
        switch topic {
        case .sharks, .oceanAnimals: return "water.waves"
        case .horses: return "figure.equestrian.sports"
        case .dinosaurs: return "leaf.fill"
        case .space, .planets, .rockets: return "moon.stars.fill"
        case .soccer: return "soccerball"
        case .basketball: return "basketball.fill"
        case .princesses, .castles, .fairies: return "building.columns.fill"
        case .dogs: return "dog.fill"
        case .cats: return "cat.fill"
        case .airplanes: return "airplane"
        case .trains: return "tram.fill"
        case .cars: return "car.fill"
        case .robots: return "cpu"
        case .superheroes: return "bolt.fill"
        case .art: return "paintpalette.fill"
        case .music: return "music.note"
        case .cooking: return "frying.pan.fill"
        case .nature, .farmAnimals, .zooAnimals, .jungleAnimals: return "leaf.fill"
        case .bugs: return "ant.fill"
        case .volcanoes: return "mountain.2.fill"
        case .weather: return "cloud.sun.fill"
        case .pirates: return "flag.fill"
        }
    }
}

// MARK: - Topic Illustration View

typealias TopicIllustrationView = AnimatedTopicIllustration

struct AnimatedTopicIllustration: View {
    let topic: Topic
    var size: CGFloat = 80
    var animate: Bool = true

    private var layoutSize: CGFloat { DesignSystem.Metrics.scaled(size) }

    var body: some View {
        Group {
            switch topic {
            case .sharks: SharksIllustration(size: layoutSize)
            case .oceanAnimals: OceanIllustration(size: layoutSize)
            case .horses: HorsesIllustration(size: layoutSize)
            case .dinosaurs: DinosaursIllustration(size: layoutSize)
            case .space, .planets, .rockets: SpaceIllustration(size: layoutSize)
            case .soccer: SoccerIllustration(size: layoutSize)
            case .basketball: BasketballIllustration(size: layoutSize)
            case .princesses, .castles, .fairies: PrincessIllustration(size: layoutSize)
            case .dogs: DogsIllustration(size: layoutSize)
            case .cats: CatsIllustration(size: layoutSize)
            case .airplanes: AirplanesIllustration(size: layoutSize)
            case .trains: TrainsIllustration(size: layoutSize)
            case .cars: VehiclesIllustration(size: layoutSize)
            case .robots: RobotsIllustration(size: layoutSize)
            case .nature, .bugs, .jungleAnimals: NatureBugsIllustration(size: layoutSize)
            default: GenericTopicIllustration(topic: topic, size: layoutSize)
            }
        }
        .environment(\.illustrationAnimates, animate)
        .frame(width: layoutSize, height: layoutSize * 0.85)
    }
}

// MARK: - Topic Card

struct TopicCard: View {
    let topic: Topic
    let isSelected: Bool
    let action: () -> Void

    private var accent: Color { TopicPalette.color(for: topic) }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    accent.opacity(isSelected ? 1 : 0.92),
                                    accent.opacity(isSelected ? 0.7 : 0.55)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: DesignSystem.Metrics.scaled(88), height: DesignSystem.Metrics.scaled(88))
                        .shadow(
                            color: accent.opacity(isSelected ? 0.38 : 0.22),
                            radius: isSelected ? 14 : 10,
                            y: 5
                        )

                    TopicIllustrationView(topic: topic, size: 56, animate: true)

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, DesignSystem.Colors.freshGreen)
                            .offset(x: 6, y: -6)
                            .transition(.scale.combined(with: .opacity))
                            .symbolEffect(.bounce, value: isSelected)
                    }
                }
                .floating(
                    offset: isSelected ? 6 : 4,
                    delay: Double((Topic.allCases.firstIndex(of: topic) ?? 0) % 6) * 0.12
                )

                Text(TopicPalette.displayTitle(for: topic))
                    .font(DesignSystem.Typography.sectionHeader(14))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: DesignSystem.Metrics.scaled(36), alignment: .top)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .background(DesignSystem.Gradients.kidCardFill(accent: accent))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous)
                    .stroke(
                        isSelected ? accent : accent.opacity(0.28),
                        lineWidth: isSelected ? 3 : 1.5
                    )
            )
            .scaleEffect(isSelected ? 1.03 : 1)
        }
        .buttonStyle(BouncyCardButtonStyle())
        .animation(DesignSystem.Animation.cardSelectAnimation, value: isSelected)
        .accessibilityLabel("\(TopicPalette.displayTitle(for: topic))\(isSelected ? ", selected" : "")")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Topic List Row (stable in List — no LazyVGrid)

struct TopicListRow: View {
    let topic: Topic
    let isSelected: Bool
    let action: () -> Void

    private var accent: Color { TopicPalette.color(for: topic) }

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.md) {
                AnimatedTopicIllustration(topic: topic, size: 44, animate: false)
                    .frame(width: 52, height: 52)
                    .background(accent.opacity(0.22))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Text(TopicPalette.displayTitle(for: topic))
                    .font(DesignSystem.Typography.title(16))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)

                Spacer(minLength: 0)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? accent : DesignSystem.Colors.textTertiary.opacity(0.45))
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? DesignSystem.Gradients.kidCardFill(accent: accent) : LinearGradient(colors: [DesignSystem.Colors.cardWhite, DesignSystem.Colors.skyBlueLight.opacity(0.35)], startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous)
                    .stroke(isSelected ? accent.opacity(0.4) : DesignSystem.Colors.cardBorder, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(BouncyCardButtonStyle())
        .animation(DesignSystem.Animation.select, value: isSelected)
    }
}

// MARK: - Compact Topic Badge (replaces emoji chips)

struct TopicBadge: View {
    let topic: Topic
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            AnimatedTopicIllustration(topic: topic, size: compact ? 20 : 24, animate: false)
            if !compact {
                Text(TopicPalette.displayTitle(for: topic))
                    .font(DesignSystem.Typography.caption(12))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
            }
        }
        .padding(.horizontal, compact ? 10 : 12)
        .padding(.vertical, compact ? 6 : 7)
        .background(TopicPalette.color(for: topic).opacity(0.22))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(TopicPalette.color(for: topic).opacity(0.45), lineWidth: 1.25))
    }
}

// MARK: - Generic Topic Illustration

struct GenericTopicIllustration: View {
    let topic: Topic
    let size: CGFloat
    @State private var pulse = false

    private var accent: Color { TopicPalette.color(for: topic) }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [accent.opacity(pulse ? 0.32 : 0.18), accent.opacity(0.08)],
                        center: .center,
                        startRadius: 2,
                        endRadius: size * 0.4
                    )
                )
                .frame(width: size * 0.78, height: size * 0.78)

            Circle()
                .stroke(accent.opacity(0.25), lineWidth: 2)
                .frame(width: size * 0.62, height: size * 0.62)

            Image(systemName: TopicPalette.icon(for: topic))
                .font(.system(size: size * 0.34, weight: .semibold))
                .foregroundStyle(accent)
                .shadow(color: accent.opacity(0.25), radius: 4, y: 2)
        }
        .illustrationOnAppear(animation: DesignSystem.Animation.twinkle) {
            pulse = true
        }
    }
}

struct RobotsIllustration: View {
    let size: CGFloat
    @State private var blink = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.12, style: .continuous)
                .fill(DesignSystem.Colors.skyBlue.opacity(0.85))
                .frame(width: size * 0.48, height: size * 0.42)
                .offset(y: size * 0.02)

            Capsule()
                .fill(DesignSystem.Colors.lavenderPurple.opacity(0.7))
                .frame(width: size * 0.08, height: size * 0.14)
                .offset(y: -size * 0.22)

            HStack(spacing: size * 0.12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignSystem.Colors.deepNavy)
                    .frame(width: size * 0.1, height: blink ? 2 : size * 0.08)
                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignSystem.Colors.deepNavy)
                    .frame(width: size * 0.1, height: blink ? 2 : size * 0.08)
            }
            .offset(y: -size * 0.02)

            Capsule()
                .fill(DesignSystem.Colors.freshGreen)
                .frame(width: size * 0.18, height: size * 0.05)
                .offset(y: size * 0.12)

            Circle()
                .stroke(DesignSystem.Colors.sunshineYellow.opacity(0.6), lineWidth: 2)
                .frame(width: size * 0.14)
                .offset(x: size * 0.28, y: -size * 0.22)
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 0.12).repeatForever(autoreverses: true).delay(2.2)) {
            blink = true
        }
    }
}

struct NatureBugsIllustration: View {
    let size: CGFloat
    @State private var flutter = false

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                Ellipse()
                    .fill(DesignSystem.Colors.freshGreen.opacity(0.45))
                    .frame(width: size * 0.16, height: size * 0.1)
                    .rotationEffect(.degrees(Double(i - 1) * 25))
                    .offset(x: CGFloat(i - 1) * size * 0.2, y: size * 0.28)
            }

            Circle()
                .fill(DesignSystem.Colors.coralPink.opacity(0.7))
                .frame(width: size * 0.12)
                .offset(x: -size * 0.22, y: -size * 0.18)

            // Butterfly body
            Capsule()
                .fill(DesignSystem.Colors.deepNavy.opacity(0.7))
                .frame(width: size * 0.05, height: size * 0.28)
                .offset(y: -size * 0.02)

            // Wings
            Ellipse()
                .fill(DesignSystem.Colors.lavenderPurple.opacity(0.75))
                .frame(width: size * 0.22, height: size * 0.16)
                .offset(x: flutter ? -size * 0.16 : -size * 0.14, y: -size * 0.06)
                .rotationEffect(.degrees(flutter ? -18 : -8))

            Ellipse()
                .fill(DesignSystem.Colors.skyBlue.opacity(0.75))
                .frame(width: size * 0.22, height: size * 0.16)
                .offset(x: flutter ? size * 0.16 : size * 0.14, y: -size * 0.06)
                .rotationEffect(.degrees(flutter ? 18 : 8))
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
            flutter = true
        }
    }
}

struct VehiclesIllustration: View {
    let size: CGFloat
    @State private var roll = false

    var body: some View {
        ZStack {
            // Road
            Capsule()
                .fill(DesignSystem.Colors.deepNavy.opacity(0.2))
                .frame(width: size * 0.7, height: size * 0.08)
                .offset(y: size * 0.28)

            // Body
            RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                .fill(DesignSystem.Colors.coralPink)
                .frame(width: size * 0.48, height: size * 0.22)
                .offset(x: roll ? 4 : -4, y: size * 0.02)

            RoundedRectangle(cornerRadius: size * 0.06, style: .continuous)
                .fill(DesignSystem.Colors.skyBlue.opacity(0.85))
                .frame(width: size * 0.28, height: size * 0.14)
                .offset(x: roll ? 4 : -4, y: -size * 0.12)

            // Wheels
            Circle()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.12)
                .offset(x: -size * 0.14 + (roll ? 4 : -4), y: size * 0.16)
            Circle()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.12)
                .offset(x: size * 0.14 + (roll ? 4 : -4), y: size * 0.16)
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
            roll = true
        }
    }
}

// MARK: - Individual Illustrations

struct SharksIllustration: View {
    let size: CGFloat
    @State private var wavePhase = false
    @State private var bubbleOffset: CGFloat = 0

    var body: some View {
        ZStack {
            WaveShape(phase: wavePhase ? 1 : 0)
                .fill(DesignSystem.Colors.skyBlue.opacity(0.35))
                .frame(height: size * 0.25)
                .offset(y: size * 0.32)

            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(.white.opacity(0.5))
                    .frame(width: size * 0.06)
                    .offset(
                        x: CGFloat(i - 1) * size * 0.15,
                        y: size * 0.1 - bubbleOffset * CGFloat(i + 1) * 0.3
                    )
            }

            SharkFinShape()
                .fill(DesignSystem.Colors.oceanTurquoise)
                .frame(width: size * 0.35, height: size * 0.4)
                .offset(x: size * 0.08, y: -size * 0.05)
                .rotationEffect(.degrees(-8))
        }
        .illustrationOnAppear(animation: DesignSystem.Animation.float) {
            wavePhase = true
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            bubbleOffset = size * 0.12
        }
    }
}

struct OceanIllustration: View {
    let size: CGFloat
    @State private var animate = false

    var body: some View {
        ZStack {
            WaveShape(phase: animate ? 1 : 0)
                .fill(DesignSystem.Colors.oceanTurquoise.opacity(0.4))
                .frame(height: size * 0.3)
                .offset(y: size * 0.28)

            Ellipse()
                .fill(DesignSystem.Colors.coralPink.opacity(0.6))
                .frame(width: size * 0.18, height: size * 0.12)
                .offset(x: -size * 0.2, y: size * 0.15)

            Circle()
                .fill(DesignSystem.Colors.freshGreen.opacity(0.5))
                .frame(width: size * 0.1)
                .offset(x: size * 0.22, y: size * 0.2)

            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(.white.opacity(0.45))
                    .frame(width: size * 0.05)
                    .offset(
                        x: CGFloat([-0.15, 0.1, 0.25, -0.05][i]) * size,
                        y: -size * 0.05 - (animate ? size * 0.08 : 0) * CGFloat(i % 2 + 1) * 0.5
                    )
            }
        }
        .illustrationOnAppear(animation: DesignSystem.Animation.float) {
            animate = true
        }
    }
}

struct HorsesIllustration: View {
    let size: CGFloat
    @State private var sunGlow = false

    var body: some View {
        ZStack {
            Circle()
                .fill(DesignSystem.Colors.sunshineYellow.opacity(sunGlow ? 0.5 : 0.35))
                .frame(width: size * 0.28)
                .offset(x: size * 0.28, y: -size * 0.28)

            ForEach(0..<5, id: \.self) { i in
                Capsule()
                    .fill(DesignSystem.Colors.freshGreen.opacity(0.5))
                    .frame(width: 3, height: size * 0.1)
                    .offset(x: CGFloat(i - 2) * size * 0.1, y: size * 0.35)
            }

            HorseHeadShape()
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: size * 0.55, height: size * 0.5)
                .offset(y: -size * 0.02)
        }
        .illustrationOnAppear(animation: DesignSystem.Animation.twinkle) {
            sunGlow = true
        }
    }
}

struct DinosaursIllustration: View {
    let size: CGFloat
    @State private var sway = false

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                Ellipse()
                    .fill(DesignSystem.Colors.freshGreen.opacity(0.35))
                    .frame(width: size * 0.2, height: size * 0.12)
                    .offset(
                        x: CGFloat(i - 1) * size * 0.22 + (sway ? 3 : -3),
                        y: size * 0.3
                    )
                    .rotationEffect(.degrees(Double(i - 1) * 15))
            }

            DinoHeadShape()
                .fill(DesignSystem.Colors.freshGreen)
                .frame(width: size * 0.55, height: size * 0.45)
                .offset(y: -size * 0.05)

            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(DesignSystem.Colors.freshGreen.opacity(0.7))
                    .frame(width: size * 0.08)
                    .offset(x: CGFloat(i - 1) * size * 0.1, y: -size * 0.28)
            }
        }
        .illustrationOnAppear(animation: DesignSystem.Animation.bob) {
            sway = true
        }
    }
}

struct SpaceIllustration: View {
    let size: CGFloat
    @State private var twinkle = false
    @State private var rocketOffset: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: size * [0.06, 0.05, 0.07, 0.04, 0.06, 0.05][i]))
                    .foregroundStyle(DesignSystem.Colors.sunshineYellow.opacity(twinkle ? 1 : 0.4))
                    .offset(
                        x: CGFloat([-0.3, 0.25, -0.1, 0.32, -0.28, 0.05][i]) * size,
                        y: CGFloat([-0.25, -0.2, 0.15, -0.05, 0.25, -0.32][i]) * size
                    )
            }

            Circle()
                .fill(
                    LinearGradient(
                        colors: [DesignSystem.Colors.warmOrange, DesignSystem.Colors.coralPink],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.28)
                .offset(x: -size * 0.15, y: size * 0.08)

            Circle()
                .stroke(DesignSystem.Colors.brightLavenderLight.opacity(0.6), lineWidth: 3)
                .frame(width: size * 0.38)
                .offset(x: -size * 0.15, y: size * 0.08)

            RocketShape()
                .fill(.white)
                .frame(width: size * 0.22, height: size * 0.35)
                .offset(x: size * 0.18, y: -size * 0.05 + rocketOffset)
        }
        .illustrationOnAppear(animation: DesignSystem.Animation.twinkle) {
            twinkle = true
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
            rocketOffset = -size * 0.06
        }
    }
}

struct SoccerIllustration: View {
    let size: CGFloat
    @State private var roll = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(DesignSystem.Colors.freshGreen.opacity(0.3))
                .frame(height: size * 0.35)
                .offset(y: size * 0.25)

            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(.white.opacity(0.3))
                    .frame(width: size * 0.15, height: 2)
                    .offset(x: -size * 0.25 + CGFloat(i) * size * 0.08, y: -size * 0.05)
                    .rotationEffect(.degrees(-20))
            }

            SoccerBallShape()
                .fill(.white)
                .frame(width: size * 0.38, height: size * 0.38)
                .offset(x: roll ? size * 0.05 : -size * 0.05, y: -size * 0.08)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            roll = true
        }
    }
}

struct BasketballIllustration: View {
    let size: CGFloat
    @State private var bounce = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(DesignSystem.Colors.warmOrange.opacity(0.28))
                .frame(height: size * 0.35)
                .offset(y: size * 0.25)

            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(.white.opacity(0.85))
                .frame(width: size * 0.22, height: size * 0.16)
                .offset(x: -size * 0.22, y: -size * 0.12)

            Capsule()
                .stroke(DesignSystem.Colors.coralPink, lineWidth: 2.5)
                .frame(width: size * 0.16, height: size * 0.06)
                .offset(x: -size * 0.22, y: -size * 0.02)

            Circle()
                .fill(DesignSystem.Colors.warmOrange)
                .overlay(Circle().stroke(DesignSystem.Colors.deepNavy.opacity(0.2), lineWidth: 1.5))
                .frame(width: size * 0.32, height: size * 0.32)
                .offset(x: bounce ? size * 0.08 : size * 0.02, y: bounce ? size * 0.08 : -size * 0.02)
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
            bounce = true
        }
    }
}

struct TrainsIllustration: View {
    let size: CGFloat
    @State private var chug = false

    var body: some View {
        ZStack {
            Capsule()
                .fill(DesignSystem.Colors.deepNavy.opacity(0.2))
                .frame(width: size * 0.7, height: size * 0.06)
                .offset(y: size * 0.28)

            RoundedRectangle(cornerRadius: size * 0.06, style: .continuous)
                .fill(DesignSystem.Colors.coralPink)
                .frame(width: size * 0.36, height: size * 0.2)
                .offset(x: chug ? 4 : -4, y: size * 0.02)

            RoundedRectangle(cornerRadius: size * 0.04, style: .continuous)
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: size * 0.16, height: size * 0.18)
                .offset(x: (chug ? 4 : -4) - size * 0.22, y: 0)

            Circle()
                .fill(.white.opacity(0.7))
                .frame(width: size * 0.1)
                .offset(x: (chug ? 4 : -4) - size * 0.28, y: -size * 0.18)

            Circle()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.1)
                .offset(x: (chug ? 4 : -4) - size * 0.08, y: size * 0.16)
            Circle()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.1)
                .offset(x: (chug ? 4 : -4) + size * 0.1, y: size * 0.16)
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            chug = true
        }
    }
}

struct PrincessIllustration: View {
    let size: CGFloat
    @State private var sparkle = false

    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { i in
                Image(systemName: "sparkle")
                    .font(.system(size: size * 0.08))
                    .foregroundStyle(DesignSystem.Colors.sunshineYellow.opacity(sparkle ? 1 : 0.3))
                    .offset(
                        x: CGFloat([-0.28, 0.3, -0.15, 0.2][i]) * size,
                        y: CGFloat([-0.28, -0.15, 0.2, -0.32][i]) * size
                    )
            }

            CastleShape()
                .fill(DesignSystem.Colors.brightLavender)
                .frame(width: size * 0.55, height: size * 0.45)
                .offset(y: size * 0.05)

            RoundedRectangle(cornerRadius: 2)
                .fill(DesignSystem.Colors.coralPink)
                .frame(width: size * 0.12, height: size * 0.18)
                .offset(y: -size * 0.12)
        }
        .illustrationOnAppear(animation: DesignSystem.Animation.twinkle) {
            sparkle = true
        }
    }
}

struct DogsIllustration: View {
    let size: CGFloat
    @State private var wag = false

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                PawPrintShape()
                    .fill(DesignSystem.Colors.warmOrange.opacity(0.2))
                    .frame(width: size * 0.12)
                    .offset(
                        x: CGFloat([-0.25, 0.28, -0.05][i]) * size,
                        y: CGFloat([0.25, 0.2, -0.28][i]) * size
                    )
                    .rotationEffect(.degrees(Double(i) * 20))
            }

            DogFaceShape()
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: size * 0.5, height: size * 0.48)
                .offset(y: -size * 0.02)

            Ellipse()
                .fill(DesignSystem.Colors.warmOrange.opacity(0.7))
                .frame(width: size * 0.14, height: size * 0.28)
                .offset(x: -size * 0.28, y: -size * 0.02)
                .rotationEffect(.degrees(wag ? -15 : -25))

            Ellipse()
                .fill(DesignSystem.Colors.warmOrange.opacity(0.7))
                .frame(width: size * 0.14, height: size * 0.28)
                .offset(x: size * 0.28, y: -size * 0.02)
                .rotationEffect(.degrees(wag ? 15 : 25))
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
            wag = true
        }
    }
}

struct CatsIllustration: View {
    let size: CGFloat
    @State private var blink = false

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                PawPrintShape()
                    .fill(DesignSystem.Colors.brightLavender.opacity(0.2))
                    .frame(width: size * 0.1)
                    .offset(
                        x: CGFloat([0.25, -0.22, 0.05][i]) * size,
                        y: CGFloat([-0.22, 0.22, 0.28][i]) * size
                    )
            }

            CatFaceShape()
                .fill(DesignSystem.Colors.brightLavender.opacity(0.85))
                .frame(width: size * 0.52, height: size * 0.46)
                .offset(y: -size * 0.02)

            HStack(spacing: size * 0.14) {
                Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.06, height: blink ? 1 : size * 0.07)
                Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.06, height: blink ? 1 : size * 0.07)
            }
            .offset(y: -size * 0.04)
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 0.15).repeatForever(autoreverses: true).delay(3)) {
            blink = true
        }
    }
}

struct AirplanesIllustration: View {
    let size: CGFloat
    @State private var fly = false

    var body: some View {
        ZStack {
            CloudShape()
                .fill(.white.opacity(0.6))
                .frame(width: size * 0.3, height: size * 0.15)
                .offset(x: -size * 0.2, y: size * 0.2)

            CloudShape()
                .fill(.white.opacity(0.45))
                .frame(width: size * 0.22, height: size * 0.12)
                .offset(x: size * 0.22, y: -size * 0.22)

            AirplaneShape()
                .fill(.white)
                .frame(width: size * 0.5, height: size * 0.2)
                .offset(x: fly ? size * 0.06 : -size * 0.06, y: -size * 0.02)
                .shadow(color: DesignSystem.Colors.skyBlue.opacity(0.3), radius: 4, y: 2)
        }
        .illustrationOnAppear(animation: .easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            fly = true
        }
    }
}

// MARK: - Custom Shapes

struct WaveShape: Shape {
    var phase: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: 0, y: h * 0.5))
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.5),
            control1: CGPoint(x: w * 0.25, y: h * (0.2 + phase * 0.15)),
            control2: CGPoint(x: w * 0.75, y: h * (0.8 - phase * 0.15))
        )
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.closeSubpath()
        return path
    }
}

struct SharkFinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.maxX * 0.7, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.maxY * 0.85)
        )
        path.closeSubpath()
        return path
    }
}

struct HorseHeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let head = CGRect(
            x: rect.width * 0.2,
            y: rect.height * 0.15,
            width: rect.width * 0.55,
            height: rect.height * 0.65
        )
        path.addRoundedRect(in: head, cornerSize: CGSize(width: 12, height: 12))

        var ears = Path()
        ears.move(to: CGPoint(x: rect.width * 0.35, y: rect.height * 0.15))
        ears.addQuadCurve(
            to: CGPoint(x: rect.width * 0.55, y: rect.minY),
            control: CGPoint(x: rect.width * 0.4, y: rect.minY)
        )
        ears.addQuadCurve(
            to: CGPoint(x: rect.width * 0.7, y: rect.height * 0.2),
            control: CGPoint(x: rect.width * 0.65, y: rect.minY)
        )
        ears.closeSubpath()
        path.addPath(ears)
        return path
    }
}

struct DinoHeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
            in: CGRect(x: rect.width * 0.15, y: rect.height * 0.2, width: rect.width * 0.65, height: rect.height * 0.6),
            cornerSize: CGSize(width: 16, height: 16)
        )
        path.move(to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.45))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.55))
        return path
    }
}

struct RocketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.height * 0.7))
        path.closeSubpath()
        return path
    }
}

struct SoccerBallShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect)
        let cx = rect.midX
        let cy = rect.midY
        let r = rect.width * 0.15
        for i in 0..<5 {
            let angle = Double(i) * 72 - 90
            let rad = angle * .pi / 180
            let x = cx + CGFloat(cos(rad)) * r * 2
            let y = cy + CGFloat(sin(rad)) * r * 2
            path.addEllipse(in: CGRect(x: x - r * 0.5, y: y - r * 0.5, width: r, height: r))
        }
        return path
    }
}

struct CastleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let towerW = rect.width * 0.22
        for i in 0..<3 {
            let x = CGFloat(i) * (rect.width - towerW) / 2
            let towerH = i == 1 ? rect.height * 0.85 : rect.height * 0.65
            path.addRoundedRect(
                in: CGRect(x: x, y: rect.height - towerH, width: towerW, height: towerH),
                cornerSize: CGSize(width: 4, height: 4)
            )
            path.addEllipse(in: CGRect(x: x + towerW * 0.25, y: rect.height - towerH - towerW * 0.3, width: towerW * 0.5, height: towerW * 0.35))
        }
        return path
    }
}

struct PawPrintShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let pad = rect.width * 0.35
        path.addEllipse(in: CGRect(x: rect.midX - pad / 2, y: rect.height * 0.45, width: pad, height: pad * 1.1))
        for i in 0..<4 {
            let x = rect.width * [0.15, 0.4, 0.6, 0.85][i]
            path.addEllipse(in: CGRect(x: x - pad * 0.2, y: rect.minY, width: pad * 0.4, height: pad * 0.45))
        }
        return path
    }
}

struct DogFaceShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.width * 0.15, y: rect.height * 0.1, width: rect.width * 0.7, height: rect.height * 0.75))
        path.addEllipse(in: CGRect(x: rect.width * 0.3, y: rect.height * 0.55, width: rect.width * 0.4, height: rect.height * 0.3))
        return path
    }
}

struct CatFaceShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.width * 0.12, y: rect.height * 0.18, width: rect.width * 0.76, height: rect.height * 0.7))
        path.move(to: CGPoint(x: rect.width * 0.15, y: rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.width * 0.05, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: rect.height * 0.2))
        path.move(to: CGPoint(x: rect.width * 0.85, y: rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.width * 0.95, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width * 0.7, y: rect.height * 0.2))
        return path
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: 0, y: rect.height * 0.3, width: rect.width * 0.45, height: rect.height * 0.6))
        path.addEllipse(in: CGRect(x: rect.width * 0.25, y: 0, width: rect.width * 0.5, height: rect.height * 0.75))
        path.addEllipse(in: CGRect(x: rect.width * 0.5, y: rect.height * 0.25, width: rect.width * 0.5, height: rect.height * 0.6))
        return path
    }
}

struct AirplaneShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

// Legacy compatibility
typealias TopicSelectionCard = TopicCard

struct TopicChip: View {
    let topic: Topic
    var isSelected: Bool = false
    var compact: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            if let action {
                Button(action: action) { TopicBadge(topic: topic, compact: compact) }
                    .buttonStyle(.plain)
            } else {
                TopicBadge(topic: topic, compact: compact)
            }
        }
    }
}
