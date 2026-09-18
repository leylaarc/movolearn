import SwiftUI

// MARK: - Design System

enum DesignSystem {

    // MARK: Colors

    enum Colors {
        // Named palette (bright, candy-like children’s product)
        static let appBackground = Color(red: 0.90, green: 0.96, blue: 1.0)
        static let creamBackground = Color(red: 1.0, green: 0.96, blue: 0.86)
        static let skyBlue = Color(red: 0.08, green: 0.58, blue: 1.0)
        static let oceanTurquoise = Color(red: 0.0, green: 0.78, blue: 0.86)
        static let coralPink = Color(red: 1.0, green: 0.28, blue: 0.48)
        static let sunshineYellow = Color(red: 1.0, green: 0.78, blue: 0.0)
        static let lavenderPurple = Color(red: 0.62, green: 0.28, blue: 1.0)
        static let freshGreen = Color(red: 0.05, green: 0.82, blue: 0.42)
        static let warmOrange = Color(red: 1.0, green: 0.46, blue: 0.06)
        static let deepNavy = Color(red: 0.08, green: 0.12, blue: 0.28)
        static let cardWhite = Color.white
        static let successGreen = Color(red: 0.08, green: 0.76, blue: 0.42)
        static let softRed = Color(red: 0.98, green: 0.32, blue: 0.38)
        static let mutedText = Color(red: 0.36, green: 0.38, blue: 0.52)

        // Supporting tones — saturated pastels, not washed-out
        static let skyBlueLight = Color(red: 0.52, green: 0.82, blue: 1.0)
        static let oceanTurquoiseLight = Color(red: 0.42, green: 0.92, blue: 0.94)
        static let sunshineYellowLight = Color(red: 1.0, green: 0.90, blue: 0.38)
        static let coralPinkDark = Color(red: 0.90, green: 0.16, blue: 0.36)
        static let brightLavender = lavenderPurple
        static let brightLavenderLight = Color(red: 0.80, green: 0.68, blue: 1.0)
        static let freshGreenLight = Color(red: 0.52, green: 0.96, blue: 0.72)
        static let warmOrangeLight = Color(red: 1.0, green: 0.76, blue: 0.42)
        static let coralPinkLight = Color(red: 1.0, green: 0.72, blue: 0.80)
        static let softCream = creamBackground
        static let cleanWhite = cardWhite

        static let backgroundCream = creamBackground
        static let backgroundWarm = Color(red: 1.0, green: 0.90, blue: 0.72)
        static let surfaceMuted = Color(red: 0.90, green: 0.94, blue: 1.0)
        static let textSecondary = mutedText
        static let textTertiary = Color(red: 0.48, green: 0.50, blue: 0.62)
        static let cardBorder = deepNavy.opacity(0.08)
        static let softCardShadow = deepNavy.opacity(0.12)
        static let shadow = softCardShadow

        // High-contrast answer inputs (always dark text on light fill)
        static let inputText = deepNavy
        static let inputPlaceholder = Color(red: 0.45, green: 0.48, blue: 0.58)
        static let inputBackground = Color(red: 0.99, green: 0.99, blue: 1.0)
        static let inputBorder = deepNavy.opacity(0.18)
        static let inputBorderStrong = deepNavy.opacity(0.28)
        static let inputCursor = skyBlue

        // Legacy aliases
        static let oceanBlue = skyBlue
        static let oceanBlueLight = skyBlueLight
        static let mintGreen = freshGreen
        static let mintGreenLight = freshGreenLight
        static let softPurple = brightLavender
        static let softPurpleLight = brightLavenderLight
    }

    // MARK: Gradients

    enum Gradients {
        static let welcomeGradient = LinearGradient(
            colors: [
                Color(red: 0.38, green: 0.76, blue: 1.0),
                Color(red: 1.0, green: 0.72, blue: 0.42),
                Color(red: 0.98, green: 0.48, blue: 0.78),
                Color(red: 0.55, green: 0.90, blue: 0.62)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let homeGradient = LinearGradient(
            colors: [
                Color(red: 0.48, green: 0.82, blue: 1.0),
                Color(red: 1.0, green: 0.78, blue: 0.88),
                Color(red: 1.0, green: 0.90, blue: 0.42),
                Color(red: 0.78, green: 0.70, blue: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )

        static func kidCardFill(accent: Color) -> LinearGradient {
            LinearGradient(
                colors: [
                    Color.white,
                    accent.opacity(0.28),
                    Colors.sunshineYellow.opacity(0.16)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        static let storyGradient = LinearGradient(
            colors: [Colors.skyBlue, Colors.oceanTurquoise],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let mathGradient = LinearGradient(
            colors: [Colors.warmOrange, Colors.coralPink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let discoveryGradient = LinearGradient(
            colors: [Colors.freshGreen, Colors.oceanTurquoise],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let creativeGradient = LinearGradient(
            colors: [Colors.lavenderPurple, Colors.coralPink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let completionGradient = LinearGradient(
            colors: [
                Color(red: 0.78, green: 0.58, blue: 1.0),
                Color(red: 1.0, green: 0.82, blue: 0.22),
                Color(red: 0.42, green: 0.92, blue: 0.68),
                Color(red: 1.0, green: 0.58, blue: 0.48)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        // Topic gradients
        static let oceanTopicGradient = LinearGradient(
            colors: [Colors.skyBlue, Colors.oceanTurquoise, Color(red: 0.05, green: 0.40, blue: 0.70)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let spaceTopicGradient = LinearGradient(
            colors: [Color(red: 0.18, green: 0.12, blue: 0.42), Colors.lavenderPurple, Colors.skyBlue],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let dinosaursTopicGradient = LinearGradient(
            colors: [Colors.freshGreen, Color(red: 0.35, green: 0.62, blue: 0.28), Colors.warmOrange],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let horsesTopicGradient = LinearGradient(
            colors: [Colors.sunshineYellow, Colors.warmOrange, Color(red: 0.55, green: 0.78, blue: 0.40)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let soccerTopicGradient = LinearGradient(
            colors: [Colors.freshGreen, Color(red: 0.20, green: 0.58, blue: 0.32), Colors.skyBlue],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let robotsTopicGradient = LinearGradient(
            colors: [Color(red: 0.12, green: 0.22, blue: 0.45), Colors.skyBlue, Colors.lavenderPurple],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let castleTopicGradient = LinearGradient(
            colors: [Colors.lavenderPurple, Colors.coralPink, Colors.sunshineYellow],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let animalsTopicGradient = LinearGradient(
            colors: [Colors.warmOrange, Colors.coralPink, Colors.sunshineYellow],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let natureTopicGradient = LinearGradient(
            colors: [Colors.freshGreen, Color(red: 0.45, green: 0.82, blue: 0.45), Colors.sunshineYellow],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        static let vehiclesTopicGradient = LinearGradient(
            colors: [Colors.skyBlue, Colors.oceanTurquoise, Colors.deepNavy.opacity(0.55)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )

        // Legacy / screen aliases
        static let welcome = welcomeGradient
        static let welcomeAnimated = [
            Color(red: 0.32, green: 0.72, blue: 1.0),
            Color(red: 1.0, green: 0.62, blue: 0.28),
            Color(red: 0.86, green: 0.42, blue: 1.0),
            Color(red: 0.28, green: 0.90, blue: 0.58)
        ]

        static let homeHero = LinearGradient(
            colors: [
                Colors.skyBlue.opacity(0.55),
                Colors.sunshineYellow.opacity(0.50),
                Colors.coralPink.opacity(0.38),
                Colors.brightLavender.opacity(0.42)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let homeBackground = homeGradient

        static let lessonComplete = completionGradient

        static let primaryButton = LinearGradient(
            colors: [Colors.coralPink, Color(red: 1.0, green: 0.48, blue: 0.30)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let secondaryButton = LinearGradient(
            colors: [Colors.skyBlue, Colors.oceanTurquoise],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let progressBar = LinearGradient(
            colors: [Colors.freshGreen, Colors.skyBlue, Colors.brightLavender],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let parentCalm = LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.99, blue: 1.0),
                Colors.creamBackground,
                Color(red: 0.96, green: 0.98, blue: 0.97)
            ],
            startPoint: .top,
            endPoint: .bottom
        )

        static let cardHeader = LinearGradient(
            colors: [Colors.skyBlue.opacity(0.32), Colors.coralPink.opacity(0.18), Colors.brightLavender.opacity(0.28)],
            startPoint: .leading,
            endPoint: .trailing
        )

        static func topicBackground(_ topic: Topic) -> LinearGradient {
            let colors = TopicPalette.gradientColors(for: topic)
            return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        }

        static func categoryGradient(_ category: LessonCategory) -> LinearGradient {
            switch category {
            case .story: return storyGradient
            case .math: return mathGradient
            case .discovery: return discoveryGradient
            case .creative: return creativeGradient
            }
        }
    }

    // MARK: Typography

    enum Typography {
        // Named text styles
        static let heroTitle = Font.system(.largeTitle, design: .rounded).weight(.heavy)
        static let screenTitle = Font.system(.title, design: .rounded).weight(.bold)
        static let sectionTitle = Font.system(.title2, design: .rounded).weight(.bold)
        static let cardTitle = Font.system(.title3, design: .rounded).weight(.semibold)
        static let storyText = Font.system(.title3, design: .rounded).weight(.medium)
        static let questionText = Font.system(.title2, design: .rounded).weight(.bold)
        static let bodyText = Font.system(.body, design: .rounded)
        static let buttonText = Font.system(.headline, design: .rounded).weight(.bold)
        static let captionText = Font.system(.caption, design: .rounded).weight(.medium)
        static let parentInsightText = Font.system(.body, design: .rounded).weight(.regular)

        static func display(_ size: CGFloat = 40) -> Font {
            .system(size: size, weight: .heavy, design: .rounded)
        }

        static func headline(_ size: CGFloat = 32) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }

        static func title(_ size: CGFloat = 22) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }

        static func sectionHeader(_ size: CGFloat = 18) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }

        static func subtitle(_ size: CGFloat = 17) -> Font {
            .system(size: size, weight: .medium, design: .rounded)
        }

        static func body(_ size: CGFloat = 17) -> Font {
            .system(size: size, weight: .regular, design: .rounded)
        }

        static func question(_ size: CGFloat = 24) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }

        static func button(_ size: CGFloat = 18) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }

        static func label(_ size: CGFloat = 12) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }

        static func caption(_ size: CGFloat = 13) -> Font {
            .system(size: size, weight: .medium, design: .rounded)
        }
    }

    // MARK: Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48

        static let screenPadding: CGFloat = 22
        static let cardPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 28
        static let elementSpacing: CGFloat = 14
        static let compactSpacing: CGFloat = 8

        static let screenHorizontal: CGFloat = screenPadding
        static let screenBottom: CGFloat = 32
        static let cardInner: CGFloat = cardPadding
    }

    // MARK: Radius

    enum Radius {
        static let smallRadius: CGFloat = 14
        static let mediumRadius: CGFloat = 18
        static let largeRadius: CGFloat = 24
        static let pillRadius: CGFloat = 100

        static let sm: CGFloat = smallRadius
        static let md: CGFloat = mediumRadius
        static let lg: CGFloat = largeRadius
        static let xl: CGFloat = 28
        static let xxl: CGFloat = 36
        static let pill: CGFloat = pillRadius
    }

    // MARK: Shadow

    enum Shadow {
        static let softShadow = (color: Colors.softCardShadow.opacity(0.7), radius: CGFloat(10), y: CGFloat(4))
        static let cardShadow = (color: Colors.softCardShadow, radius: CGFloat(16), y: CGFloat(6))
        static let glowShadow = (color: Colors.sunshineYellow.opacity(0.45), radius: CGFloat(22), y: CGFloat(0))
        static let selectedShadow = (color: Colors.skyBlue.opacity(0.28), radius: CGFloat(18), y: CGFloat(5))

        static let card = cardShadow
        static let cardElevated = (color: Colors.softCardShadow.opacity(1.3), radius: CGFloat(26), y: CGFloat(12))
        static let button = (color: Colors.coralPink.opacity(0.38), radius: CGFloat(16), y: CGFloat(7))
        static let chip = softShadow
        static let glow = glowShadow
        static let selected = selectedShadow
    }

    // MARK: Animation

    enum Animation {
        static let buttonPressAnimation = SwiftUI.Animation.easeOut(duration: 0.16)
        static let cardSelectAnimation = SwiftUI.Animation.spring(response: 0.34, dampingFraction: 0.70)
        static let gentleFloatAnimation = SwiftUI.Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)
        static let progressAnimation = SwiftUI.Animation.spring(response: 0.58, dampingFraction: 0.82)
        static let celebrationAnimation = SwiftUI.Animation.spring(response: 0.50, dampingFraction: 0.62)

        static let quick = buttonPressAnimation
        static let bounce = SwiftUI.Animation.spring(response: 0.40, dampingFraction: 0.66)
        static let gentle = progressAnimation
        static let select = cardSelectAnimation
        static let float = gentleFloatAnimation
        static let bob = SwiftUI.Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
        static let twinkle = SwiftUI.Animation.easeInOut(duration: 1.6).repeatForever(autoreverses: true)
        static let celebrate = celebrationAnimation
        static let stagger = SwiftUI.Animation.spring(response: 0.52, dampingFraction: 0.80)
        static let idle = SwiftUI.Animation.easeInOut(duration: 2.4).repeatForever(autoreverses: true)
        static let wiggle = SwiftUI.Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)
        static let shake = SwiftUI.Animation.linear(duration: 0.42)
    }
}

// MARK: - View Modifiers

struct SparkCardModifier: ViewModifier {
    var padding: CGFloat = DesignSystem.Spacing.cardPadding
    var elevated: Bool = false
    var accent: Color? = nil

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: DesignSystem.Radius.largeRadius, style: .continuous)
                    .fill(
                        accent.map { DesignSystem.Gradients.kidCardFill(accent: $0) }
                        ?? LinearGradient(
                            colors: [DesignSystem.Colors.cardWhite, DesignSystem.Colors.skyBlueLight.opacity(0.22)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: elevated ? DesignSystem.Shadow.cardElevated.color : DesignSystem.Shadow.cardShadow.color,
                        radius: elevated ? DesignSystem.Shadow.cardElevated.radius : DesignSystem.Shadow.cardShadow.radius,
                        y: elevated ? DesignSystem.Shadow.cardElevated.y : DesignSystem.Shadow.cardShadow.y
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: DesignSystem.Radius.largeRadius, style: .continuous)
                    .stroke(
                        accent?.opacity(0.38) ?? DesignSystem.Colors.skyBlue.opacity(0.16),
                        lineWidth: accent == nil ? 1 : 1.5
                    )
            }
    }
}

struct ScreenBackgroundModifier: ViewModifier {
    var gradient: LinearGradient?

    func body(content: Content) -> some View {
        content
            .background {
                if let gradient {
                    gradient.ignoresSafeArea()
                } else {
                    DesignSystem.Gradients.homeGradient.ignoresSafeArea()
                }
            }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    var gradient: LinearGradient = DesignSystem.Gradients.primaryButton

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystem.Typography.buttonText)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 58)
            .background {
                Group {
                    if isEnabled {
                        gradient
                    } else {
                        DesignSystem.Colors.coralPink.opacity(0.28)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous))
            .overlay {
                if isEnabled {
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous)
                        .stroke(.white.opacity(configuration.isPressed ? 0 : 0.30), lineWidth: 1.5)
                        .padding(1)
                }
            }
            .shadow(
                color: isEnabled ? DesignSystem.Shadow.button.color : .clear,
                radius: DesignSystem.Shadow.button.radius,
                y: configuration.isPressed ? 2 : DesignSystem.Shadow.button.y
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .brightness(configuration.isPressed ? -0.04 : 0)
            .animation(DesignSystem.Animation.buttonPressAnimation, value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystem.Typography.button(16))
            .foregroundStyle(DesignSystem.Colors.deepNavy)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 54)
            .background(DesignSystem.Colors.cardWhite.opacity(0.88))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous)
                    .stroke(DesignSystem.Colors.deepNavy.opacity(0.12), lineWidth: 1.5)
            )
            .shadow(
                color: DesignSystem.Shadow.softShadow.color,
                radius: DesignSystem.Shadow.softShadow.radius,
                y: configuration.isPressed ? 1 : DesignSystem.Shadow.softShadow.y
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(DesignSystem.Animation.buttonPressAnimation, value: configuration.isPressed)
    }
}

struct BouncyCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(DesignSystem.Animation.bounce, value: configuration.isPressed)
    }
}

// MARK: - View Extensions

extension View {
    func sparkCard(padding: CGFloat = DesignSystem.Spacing.cardPadding, elevated: Bool = false, accent: Color? = nil) -> some View {
        modifier(SparkCardModifier(padding: padding, elevated: elevated, accent: accent))
    }

    func screenBackground() -> some View {
        modifier(ScreenBackgroundModifier())
    }

    func screenBackground(gradient: LinearGradient) -> some View {
        modifier(ScreenBackgroundModifier(gradient: gradient))
    }

    func floating(offset: CGFloat = 8, delay: Double = 0) -> some View {
        modifier(FloatingModifier(amplitude: offset, delay: delay))
    }

    func entrance(appeared: Bool, delay: Double = 0) -> some View {
        opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 14)
            .animation(DesignSystem.Animation.gentle.delay(delay), value: appeared)
    }

    func idlePulse(scale: CGFloat = 1.06, delay: Double = 0) -> some View {
        modifier(IdlePulseModifier(scale: scale, delay: delay))
    }

    func wiggle(degrees: Double = 4, delay: Double = 0) -> some View {
        modifier(WiggleModifier(degrees: degrees, delay: delay))
    }

    func shake(trigger: Bool) -> some View {
        modifier(ShakeModifier(trigger: trigger))
    }
}

struct FloatingModifier: ViewModifier {
    let amplitude: CGFloat
    let delay: Double
    @Environment(\.illustrationAnimates) private var illustrationAnimates
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var floating = false

    func body(content: Content) -> some View {
        content
            .offset(y: floating ? -amplitude : amplitude)
            .onAppear {
                guard illustrationAnimates, !reduceMotion else { return }
                withAnimation(DesignSystem.Animation.gentleFloatAnimation.delay(delay)) {
                    floating = true
                }
            }
    }
}

struct IdlePulseModifier: ViewModifier {
    let scale: CGFloat
    let delay: Double
    @Environment(\.illustrationAnimates) private var illustrationAnimates
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(shouldAnimate && pulsing ? scale : 1)
            .onAppear {
                guard shouldAnimate else { return }
                withAnimation(DesignSystem.Animation.idle.delay(delay)) {
                    pulsing = true
                }
            }
    }

    private var shouldAnimate: Bool { illustrationAnimates && !reduceMotion }
}

struct WiggleModifier: ViewModifier {
    let degrees: Double
    let delay: Double
    @Environment(\.illustrationAnimates) private var illustrationAnimates
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var wiggling = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(shouldAnimate && wiggling ? degrees : (shouldAnimate ? -degrees : 0)))
            .onAppear {
                guard shouldAnimate else { return }
                withAnimation(DesignSystem.Animation.wiggle.delay(delay)) {
                    wiggling = true
                }
            }
    }

    private var shouldAnimate: Bool { illustrationAnimates && !reduceMotion }
}

struct ShakeModifier: ViewModifier {
    var trigger: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shakes: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(ShakeGeometry(amount: reduceMotion ? 0 : 8, shakesPerUnit: 4, animatableData: shakes))
            .onChange(of: trigger) { _, isTriggered in
                guard isTriggered, !reduceMotion else { return }
                shakes = 0
                withAnimation(DesignSystem.Animation.shake) {
                    shakes = 1
                }
            }
    }
}

private struct ShakeGeometry: GeometryEffect {
    var amount: CGFloat
    var shakesPerUnit: CGFloat
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * shakesPerUnit),
                y: 0
            )
        )
    }
}

// MARK: - Illustration Animation Control

private struct IllustrationAnimatesKey: EnvironmentKey {
    static let defaultValue = true
}

extension EnvironmentValues {
    var illustrationAnimates: Bool {
        get { self[IllustrationAnimatesKey.self] }
        set { self[IllustrationAnimatesKey.self] = newValue }
    }
}

enum IllustrationAnimation {
    static func start(_ enabled: Bool, _ animation: Animation, _ body: @escaping () -> Void) {
        guard enabled else { return }
        withAnimation(animation, body)
    }
}

struct IllustrationOnAppearModifier: ViewModifier {
    @Environment(\.illustrationAnimates) private var animates
    let animation: Animation
    let action: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            IllustrationAnimation.start(animates, animation, action)
        }
    }
}

extension View {
    func illustrationOnAppear(animation: Animation, perform action: @escaping () -> Void) -> some View {
        modifier(IllustrationOnAppearModifier(animation: animation, action: action))
    }
}
