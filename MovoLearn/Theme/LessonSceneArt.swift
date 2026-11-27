import SwiftUI

/// How a rocket lesson scene should behave. Matches the website demo:
/// countdown and liftoff on the opening, then a quiet hover while the child reads.
enum RocketLaunchCue: Equatable {
    case countdown
    case aloft
}

enum LessonHabitat {
    case sky, water, ground, space, volcano
}

// MARK: - Sky

struct LessonSkyBackdrop: View {
    var habitat: LessonHabitat
    /// Shift the volcano aside so counted objects can sit on the ground next to it.
    var anchoredToSide: Bool = false

    @State private var drift = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [
                    DesignSystem.Colors.lessonSky,
                    DesignSystem.Colors.lessonSky.opacity(0.55),
                    DesignSystem.Colors.lessonSky.opacity(0)
                ],
                center: .center,
                startRadius: 12,
                endRadius: 210
            )

            switch habitat {
            case .space:
                spaceStars
            case .water:
                Capsule()
                    .fill(Color(red: 0.08, green: 0.45, blue: 0.72).opacity(0.38))
                    .frame(height: DesignSystem.Metrics.scaled(34))
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .offset(y: drift ? 4 : -3)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, DesignSystem.Metrics.scaled(10))
            case .ground:
                Capsule()
                    .fill(Color(red: 0.22, green: 0.55, blue: 0.32).opacity(0.55))
                    .frame(height: DesignSystem.Metrics.scaled(12))
                    .padding(.horizontal, DesignSystem.Spacing.xl)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, DesignSystem.Metrics.scaled(18))
            case .sky:
                EmptyView()
            case .volcano:
                volcanoHill
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            guard !reduceMotion, habitat == .water || habitat == .volcano else { return }
            withAnimation(.easeInOut(duration: habitat == .volcano ? 1.8 : 2.4).repeatForever(autoreverses: true)) {
                drift = true
            }
        }
    }

    private var volcanoHill: some View {
        ZStack(alignment: .bottom) {
            Wedge()
                .fill(Color(red: 0.48, green: 0.30, blue: 0.24))
                .frame(width: DesignSystem.Metrics.scaled(200), height: DesignSystem.Metrics.scaled(108))
            Ellipse()
                .fill(DesignSystem.Colors.lessonOrange)
                .frame(width: DesignSystem.Metrics.scaled(28), height: DesignSystem.Metrics.scaled(12))
                .offset(y: -DesignSystem.Metrics.scaled(96))
            Circle()
                .fill(DesignSystem.Colors.lessonCream.opacity(0.92))
                .frame(width: DesignSystem.Metrics.scaled(16), height: DesignSystem.Metrics.scaled(16))
                .offset(y: drift ? -DesignSystem.Metrics.scaled(132) : -DesignSystem.Metrics.scaled(108))
            Circle()
                .fill(DesignSystem.Colors.cardWhite.opacity(0.75))
                .frame(width: DesignSystem.Metrics.scaled(12), height: DesignSystem.Metrics.scaled(12))
                .offset(x: DesignSystem.Metrics.scaled(14), y: drift ? -DesignSystem.Metrics.scaled(118) : -DesignSystem.Metrics.scaled(96))
        }
        .scaleEffect(anchoredToSide ? 0.82 : 1, anchor: .bottom)
        .offset(x: anchoredToSide ? -DesignSystem.Metrics.scaled(72) : 0)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    private var spaceStars: some View {
        ZStack {
            starDot(8, x: -70, y: -40)
            starDot(5, x: 80, y: -55)
            starDot(6, x: 40, y: 20)
            starDot(4, x: -90, y: 30)
            starDot(7, x: 10, y: -70)
        }
    }

    private func starDot(_ size: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(DesignSystem.Colors.lessonCream.opacity(0.9))
            .frame(width: size, height: size)
            .offset(x: x, y: y)
    }

    static func habitat(forName name: String) -> LessonHabitat {
        switch name {
        case "shark", "dolphin", "whale", "fish", "crab", "ship", "seashell", "pearl", "octopus", "lighthouse":
            return .water
        case "star", "planet", "moon", "moon rock", "star crystal", "earth", "venus", "spacecraft":
            return .space
        case "bird", "butterfly", "bee", "fairy", "airplane", "firefly", "leaf", "petal", "hero", "cloud", "sun", "hawk":
            return .sky
        case "volcano", "lava":
            return .volcano
        default:
            return .ground
        }
    }

    static func habitat(for picture: StoryPicture) -> LessonHabitat {
        switch picture.name {
        case "shark", "dolphin", "whale", "fish", "crab", "ship", "seashell", "pearl", "octopus", "lighthouse":
            return .water
        case "star", "planet", "moon", "moon rock", "star crystal", "earth", "venus", "spacecraft":
            return .space
        case "bird", "butterfly", "bee", "fairy", "airplane", "firefly", "leaf", "petal", "hero", "cloud", "sun", "hawk":
            return .sky
        case "volcano", "lava":
            return .volcano
        default:
            switch picture.motion {
            case .swim: return .water
            case .flutter, .float, .twinkle, .glide: return .sky
            default: return .ground
            }
        }
    }
}

// MARK: - Rocket launch

struct RocketLaunchScene: View {
    var cue: RocketLaunchCue

    @State private var started = false
    @State private var count: Int?
    @State private var pop = false
    @State private var flightLift: CGFloat = 0
    @State private var bobNudge: CGFloat = 0
    @State private var flaming = false
    @State private var puffA: CGFloat = 0
    @State private var puffB: CGFloat = 0
    @State private var pending: [DispatchWorkItem] = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .bottom) {
            LessonSkyBackdrop(habitat: .sky)

            if let count {
                Text("\(count)")
                    .font(DesignSystem.Typography.display(42))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .monospacedDigit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, DesignSystem.Spacing.md)
                    .padding(.top, DesignSystem.Spacing.sm)
                    .offset(y: pop ? 0 : 8)
                    .opacity(pop ? 1 : 0.2)
                    .animation(.easeOut(duration: 0.45), value: pop)
                    .accessibilityLabel("Countdown \(count)")
            }

            Capsule()
                .fill(DesignSystem.Colors.lessonPad)
                .frame(width: DesignSystem.Metrics.scaled(96), height: DesignSystem.Metrics.scaled(9))
                .padding(.bottom, DesignSystem.Metrics.scaled(12))

            puff(progress: puffA, direction: -1)
            puff(progress: puffB, direction: 1)

            WebsiteRocket(flickering: flaming)
                .frame(width: DesignSystem.Metrics.scaled(68))
                .offset(y: flightLift + bobNudge)
                .padding(.bottom, DesignSystem.Metrics.scaled(18))
        }
        .frame(height: DesignSystem.Metrics.scaled(230))
        .frame(maxWidth: .infinity)
        .clipped()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(flaming ? "Rocket lifting off" : "Rocket on the pad")
        .onAppear(perform: begin)
        .onDisappear {
            pending.forEach { $0.cancel() }
        }
    }

    private func puff(progress: CGFloat, direction: CGFloat) -> some View {
        Circle()
            .fill(DesignSystem.Colors.lessonCream.opacity(0.95))
            .frame(width: DesignSystem.Metrics.scaled(16), height: DesignSystem.Metrics.scaled(16))
            .scaleEffect(0.4 + progress * 2)
            .offset(x: progress * DesignSystem.Metrics.scaled(28) * direction, y: progress * DesignSystem.Metrics.scaled(10))
            .opacity(puffOpacity(progress))
            .padding(.bottom, DesignSystem.Metrics.scaled(20))
    }

    private func puffOpacity(_ progress: CGFloat) -> Double {
        if progress <= 0 { return 0 }
        if progress < 0.12 { return Double(progress / 0.12) }
        if progress < 0.35 { return 0.95 }
        return Double(max(0, (1 - progress) / 0.65))
    }

    private func begin() {
        guard !started else { return }
        started = true
        if reduceMotion || cue == .aloft {
            flightLift = -DesignSystem.Metrics.scaled(108)
            flaming = cue == .aloft || reduceMotion
            if cue == .aloft, !reduceMotion {
                withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                    bobNudge = DesignSystem.Metrics.scaled(8)
                }
            }
            return
        }
        tick(5)
    }

    private func tick(_ n: Int) {
        if n < 1 {
            count = nil
            flaming = true
            withAnimation(.easeOut(duration: 1.3)) { puffA = 1 }
            after(0.12) {
                withAnimation(.easeOut(duration: 1.3)) { puffB = 1 }
            }
            withAnimation(.timingCurve(0.2, 0.75, 0.2, 1, duration: 1.35)) {
                flightLift = -DesignSystem.Metrics.scaled(108)
            }
            after(1.4) {
                withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                    bobNudge = DesignSystem.Metrics.scaled(8)
                }
            }
            return
        }
        count = n
        pop = false
        DispatchQueue.main.async { pop = true }
        after(0.56) { tick(n - 1) }
    }

    private func after(_ seconds: Double, _ action: @escaping () -> Void) {
        let item = DispatchWorkItem(block: action)
        pending.append(item)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: item)
    }
}

struct WebsiteRocket: View {
    var flickering: Bool

    var body: some View {
        VStack(spacing: -2) {
            Color.clear
                .aspectRatio(80 / 120, contentMode: .fit)
                .overlay {
                    GeometryReader { geo in
                        let w = geo.size.width
                        let h = geo.size.height
                        ZStack {
                            RocketFins().fill(DesignSystem.Colors.lessonOrange)
                            RocketBody().fill(DesignSystem.Colors.lessonCoral)
                            RocketNose().fill(DesignSystem.Colors.deepNavy)
                            Circle()
                                .fill(DesignSystem.Colors.lessonWindow)
                                .overlay {
                                    Circle().stroke(DesignSystem.Colors.deepNavy, lineWidth: max(1.5, w * 0.03))
                                }
                                .frame(width: w * 16 / 80, height: w * 16 / 80)
                                .position(x: w * 0.5, y: h * 58 / 120)
                            RoundedRectangle(cornerRadius: 1, style: .continuous)
                                .fill(DesignSystem.Colors.lessonYellow)
                                .frame(width: w * 28 / 80, height: max(3, h * 6 / 120))
                                .position(x: w * 0.5, y: h * 77 / 120)
                        }
                    }
                }
            RocketFlame(on: flickering)
                .frame(height: flickering ? 18 : 0)
        }
    }
}

private struct RocketFins: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: rocketPoint(22, 78, in: rect))
        path.addLine(to: rocketPoint(8, 102, in: rect))
        path.addLine(to: rocketPoint(30, 90, in: rect))
        path.closeSubpath()
        path.move(to: rocketPoint(58, 78, in: rect))
        path.addLine(to: rocketPoint(72, 102, in: rect))
        path.addLine(to: rocketPoint(50, 90, in: rect))
        path.closeSubpath()
        return path
    }
}

private struct RocketBody: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: rocketPoint(26, 46, in: rect))
        path.addQuadCurve(to: rocketPoint(54, 46, in: rect), control: rocketPoint(40, 10, in: rect))
        path.addLine(to: rocketPoint(54, 86, in: rect))
        path.addQuadCurve(to: rocketPoint(26, 86, in: rect), control: rocketPoint(40, 96, in: rect))
        path.closeSubpath()
        return path
    }
}

private struct RocketNose: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: rocketPoint(26, 46, in: rect))
        path.addQuadCurve(to: rocketPoint(54, 46, in: rect), control: rocketPoint(40, 14, in: rect))
        path.closeSubpath()
        return path
    }
}

private func rocketPoint(_ x: CGFloat, _ y: CGFloat, in rect: CGRect) -> CGPoint {
    CGPoint(
        x: rect.minX + x / 80 * rect.width,
        y: rect.minY + y / 120 * rect.height
    )
}

private struct RocketFlame: View {
    var on: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 24, paused: !on || reduceMotion)) { context in
            let flicker = on
                ? 0.72 + 0.43 * abs(sin(context.date.timeIntervalSinceReferenceDate * 28))
                : 0.2
            ZStack {
                DownFlame().fill(DesignSystem.Colors.lessonOrange)
                DownFlame()
                    .fill(DesignSystem.Colors.lessonYellow)
                    .scaleEffect(0.5)
                    .offset(y: 2)
            }
            .scaleEffect(x: 0.85, y: flicker, anchor: .top)
            .opacity(on ? 1 : 0)
            .frame(width: 16)
            .frame(maxWidth: .infinity)
        }
    }
}

private struct Wedge: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct DownFlame: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// A dolphin or whale fluke. The narrow peduncle joins the body on the right. Two rounded lobes trail behind.
private struct FlukeTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let midY = rect.midY
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: maxX, y: midY))
        path.addCurve(
            to: CGPoint(x: minX + width * 0.06, y: minY + height * 0.14),
            control1: CGPoint(x: maxX - width * 0.45, y: midY),
            control2: CGPoint(x: minX + width * 0.35, y: minY)
        )
        path.addCurve(
            to: CGPoint(x: minX + width * 0.28, y: midY),
            control1: CGPoint(x: minX, y: minY + height * 0.32),
            control2: CGPoint(x: minX + width * 0.12, y: midY - height * 0.02)
        )
        path.addCurve(
            to: CGPoint(x: minX + width * 0.06, y: maxY - height * 0.14),
            control1: CGPoint(x: minX + width * 0.12, y: midY + height * 0.02),
            control2: CGPoint(x: minX, y: maxY - height * 0.32)
        )
        path.addCurve(
            to: CGPoint(x: maxX, y: midY),
            control1: CGPoint(x: minX + width * 0.35, y: maxY),
            control2: CGPoint(x: maxX - width * 0.45, y: midY)
        )
        path.closeSubpath()
        return path
    }
}

/// A fish or shark tail. The point joins the body on the right. The fork opens behind it.
private struct ForkedTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Superhero flight

struct HeroFlightScene: View {
    var showsCat: Bool = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30, paused: reduceMotion)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            let fly = reduceMotion ? 0 : CGFloat(sin(t * 0.85))
            let bob = reduceMotion ? 0 : CGFloat(sin(t * 1.7))
            ZStack(alignment: .bottom) {
                LessonSkyBackdrop(habitat: .sky)
                skyline
                if showsCat {
                    rescueTree
                        .offset(x: -DesignSystem.Metrics.scaled(110))
                }
                FlyingHero(flap: reduceMotion ? 0.2 : CGFloat(sin(t * 5)))
                    .frame(
                        width: DesignSystem.Metrics.scaled(150),
                        height: DesignSystem.Metrics.scaled(160)
                    )
                    .rotationEffect(.degrees(Double(fly) * 10))
                    .offset(
                        x: fly * DesignSystem.Metrics.scaled(78),
                        y: -DesignSystem.Metrics.scaled(78) + bob * DesignSystem.Metrics.scaled(12)
                    )
            }
        }
        .frame(height: DesignSystem.Metrics.scaled(250))
        .frame(maxWidth: .infinity)
        .clipped()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(showsCat ? "A hero flying toward a cat in a tree" : "A hero flying")
    }

    private var skyline: some View {
        HStack(alignment: .bottom, spacing: 8) {
            block(28, 46)
            block(22, 70)
            block(34, 40)
            block(18, 58)
            block(30, 36)
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.bottom, DesignSystem.Metrics.scaled(8))
    }

    private func block(_ width: CGFloat, _ height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(DesignSystem.Colors.deepNavy.opacity(0.18))
            .frame(
                width: DesignSystem.Metrics.scaled(width),
                height: DesignSystem.Metrics.scaled(height)
            )
    }

    private var rescueTree: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(Color(red: 0.45, green: 0.28, blue: 0.14))
                .frame(width: DesignSystem.Metrics.scaled(14), height: DesignSystem.Metrics.scaled(78))
            Circle()
                .fill(Color(red: 0.22, green: 0.62, blue: 0.36))
                .frame(width: DesignSystem.Metrics.scaled(70), height: DesignSystem.Metrics.scaled(70))
                .offset(y: -DesignSystem.Metrics.scaled(36))
            DrawnSubject(name: "cat", size: DesignSystem.Metrics.scaled(36))
                .offset(y: -DesignSystem.Metrics.scaled(48))
        }
        .padding(.bottom, DesignSystem.Metrics.scaled(18))
    }
}

private struct FlyingHero: View {
    var flap: CGFloat

    var body: some View {
        ZStack {
            CapeShape(flap: flap)
                .fill(DesignSystem.Colors.lessonCoral)
                .frame(width: 92, height: 108)
                .offset(y: 18)
            Capsule()
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: 36, height: 52)
                .offset(y: 16)
            StarArt(color: DesignSystem.Colors.lessonYellow, size: 28, phase: flap)
                .offset(y: 14)
            Capsule()
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: 46, height: 12)
                .offset(y: 8)
            Circle()
                .fill(Color(red: 0.96, green: 0.8, blue: 0.66))
                .frame(width: 36, height: 36)
                .offset(y: -28)
            Capsule()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: 28, height: 10)
                .offset(y: -30)
            Circle()
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: 7, height: 7)
                .offset(x: -6, y: -31)
            Circle()
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: 7, height: 7)
                .offset(x: 6, y: -31)
        }
    }
}

private struct CapeShape: Shape {
    var flap: CGFloat

    func path(in rect: CGRect) -> Path {
        let sway = flap * rect.width * 0.42
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - 12, y: rect.minY + 6))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + sway, y: rect.maxY),
            control: CGPoint(x: rect.minX - 16 + sway, y: rect.midY)
        )
        path.addLine(to: CGPoint(x: rect.maxX + sway * 0.35, y: rect.maxY - 8))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX + 12, y: rect.minY + 6),
            control: CGPoint(x: rect.maxX + 10 + sway * 0.2, y: rect.midY)
        )
        path.closeSubpath()
        return path
    }
}

/// Lesson animation drawn inside a world bubble. The bubble chrome stays outside this view.
struct WorldBubbleMark: View {
    let topic: Topic
    var size: CGFloat

    var body: some View {
        ReviewListMark(itemID: TopicStageArt.name(for: topic))
            .frame(
                width: DesignSystem.Metrics.scaled(size),
                height: DesignSystem.Metrics.scaled(size)
            )
    }
}

/// The drawn subject each world uses, matching the lesson stage animation.
enum TopicStageArt {
    static func name(for topic: Topic) -> String {
        switch topic {
        case .sharks: return "shark"
        case .oceanAnimals: return "whale"
        case .horses: return "horse"
        case .dinosaurs: return "dinosaur"
        case .space, .planets: return "planet"
        case .rockets: return "rocket"
        case .soccer: return "soccer ball"
        case .basketball: return "basketball"
        case .dogs: return "dog"
        case .cats: return "cat"
        case .jungleAnimals, .zooAnimals: return "monkey"
        case .princesses: return "princess"
        case .castles: return "castle"
        case .fairies: return "fairy"
        case .airplanes: return "airplane"
        case .trains: return "train"
        case .cars: return "car"
        case .robots: return "robot"
        case .superheroes: return "hero"
        case .art: return "paintbrush"
        case .music: return "drum"
        case .cooking: return "cupcake"
        case .bugs: return "butterfly"
        case .farmAnimals: return "cow"
        case .pirates: return "pirate"
        case .volcanoes: return "volcano"
        case .weather: return "cloud"
        case .nature: return "leaf"
        }
    }
}

struct TopicStage: View {
    let name: String

    var body: some View {
        Group {
            if name == "volcano" || name == "lava" {
                VolcanoStudyScene(erupting: name == "lava")
            } else {
                ZStack {
                    LessonSkyBackdrop(habitat: LessonSkyBackdrop.habitat(forName: name))
                    DrawnSubject(name: name, size: DesignSystem.Metrics.scaled(148))
                }
            }
        }
        .frame(height: DesignSystem.Metrics.scaled(230))
        .frame(maxWidth: .infinity)
        .clipped()
        .accessibilityHidden(true)
    }
}

// MARK: - Drawn subjects (used wherever a story used to show an emoji)

struct DrawnSubject: View {
    let name: String
    let size: CGFloat

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            if reduceMotion {
                artwork(phase: 0, spin: 0)
            } else {
                TimelineView(.animation(minimumInterval: 1 / 20)) { context in
                    let t = context.date.timeIntervalSinceReferenceDate
                    artwork(phase: CGFloat(sin(t * 5)), spin: t)
                }
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private func artwork(phase: CGFloat, spin: TimeInterval) -> some View {
        switch name {
        case "rocket":
            WebsiteRocket(flickering: true)
                .padding(.bottom, size * 0.02)
        case "shark":
            FishArt(kind: .shark, phase: phase, size: size)
        case "dolphin":
            FishArt(kind: .dolphin, phase: phase, size: size)
        case "whale":
            FishArt(kind: .whale, phase: phase, size: size)
        case "fish":
            FishArt(kind: .fish, phase: phase, size: size)
        case "dinosaur":
            DinoArt(phase: phase, size: size)
        case "volcano", "lava":
            VolcanoArt(erupting: name == "lava", phase: phase, size: size)
        case "rock":
            RockArt(kind: .rock, size: size)
        case "hot rock":
            RockArt(kind: .hot, size: size)
        case "cloud":
            CloudArt(phase: phase, size: size)
        case "cape":
            CapeArt(phase: phase, size: size)
        case "sensor":
            SensorArt(phase: phase, size: size)
        case "gear":
            GearArt(spin: spin, size: size)
        case "pinecone":
            PineconeArt(size: size)
        case "chick":
            ChickArt(phase: phase, size: size)
        case "horse":
            BeastArt(preset: .horse, phase: phase, size: size)
        case "pony":
            BeastArt(preset: .pony, phase: phase, size: size)
        case "dog":
            BeastArt(preset: .dog, phase: phase, size: size)
        case "puppy":
            BeastArt(preset: .puppy, phase: phase, size: size)
        case "cat":
            BeastArt(preset: .cat, phase: phase, size: size)
        case "kitten":
            BeastArt(preset: .kitten, phase: phase, size: size)
        case "pig":
            BeastArt(preset: .pig, phase: phase, size: size)
        case "cow":
            BeastArt(preset: .cow, phase: phase, size: size)
        case "sheep":
            BeastArt(preset: .sheep, phase: phase, size: size)
        case "goat":
            BeastArt(preset: .goat, phase: phase, size: size)
        case "rabbit":
            BeastArt(preset: .rabbit, phase: phase, size: size)
        case "monkey":
            MonkeyArt(phase: phase, size: size)
        case "frog":
            BeastArt(preset: .frog, phase: phase, size: size)
        case "bird":
            BirdArt(preset: .bird, phase: phase, size: size)
        case "hen":
            BirdArt(preset: .hen, phase: phase, size: size)
        case "chicken":
            BirdArt(preset: .chicken, phase: phase, size: size)
        case "rooster":
            BirdArt(preset: .rooster, phase: phase, size: size)
        case "duck":
            BirdArt(preset: .duck, phase: phase, size: size)
        case "penguin":
            BirdArt(preset: .penguin, phase: phase, size: size)
        case "fairy":
            FairyArt(phase: phase, size: size)
        case "butterfly":
            WingedBug(kind: .butterfly, phase: phase, size: size)
        case "bee":
            WingedBug(kind: .bee, phase: phase, size: size)
        case "ladybug":
            WingedBug(kind: .ladybug, phase: phase, size: size)
        case "ant":
            WingedBug(kind: .ant, phase: phase, size: size)
        case "crab":
            CrabArt(phase: phase, size: size)
        case "seashell":
            ShellArt(size: size)
        case "egg", "dinosaur egg":
            EggArt(speckled: name == "dinosaur egg", size: size)
        case "fossil":
            BoneArt(kind: .fossil, size: size)
        case "bone":
            BoneArt(kind: .bone, size: size)
        case "dog treat":
            BoneArt(kind: .treat, size: size)
        case "planet":
            PlanetArt(size: size, spin: spin)
        case "moon":
            MoonArt(size: size)
        case "star":
            StarArt(color: DesignSystem.Colors.lessonYellow, size: size, phase: phase)
        case "star crystal", "jewel":
            CrystalArt(size: size, phase: phase)
        case "moon rock":
            RockArt(kind: .moon, size: size)
        case "stone":
            RockArt(kind: .stone, size: size)
        case "robot":
            RobotArt(phase: phase, size: size)
        case "flower", "rose":
            FlowerArt(rose: name == "rose", phase: phase, size: size)
        case "berry":
            RoundFruit(color: Color(red: 0.28, green: 0.28, blue: 0.72), leaf: true, size: size)
        case "apple":
            AppleArt(size: size)
        case "mushroom":
            MushroomArt(size: size)
        case "leaf", "seed":
            LeafArt(sprout: name == "seed", phase: phase, size: size)
        case "cupcake":
            CupcakeArt(size: size)
        case "coin":
            CoinArt(size: size, spin: spin)
        case "soccer ball":
            BallArt(mark: .soccer, size: size, spin: spin)
        case "basketball":
            BallArt(mark: .basketball, size: size, spin: spin)
        case "tennis ball":
            BallArt(mark: .tennis, size: size, spin: spin)
        case "yarn ball":
            BallArt(mark: .yarn, size: size, spin: spin)
        case "battery":
            BatteryArt(size: size)
        case "paintbrush":
            BrushArt(size: size, phase: phase)
        case "drum":
            DrumArt(size: size)
        case "spoon":
            SpoonArt(size: size)
        case "cup":
            CupArt(size: size)
        case "jar":
            JarArt(size: size)
        case "pouch", "bag":
            BagArt(size: size)
        case "box", "chest":
            CrateArt(openLid: name == "chest", size: size)
        case "basket":
            BasketArt(size: size)
        case "bowl":
            BowlArt(size: size)
        case "umbrella":
            UmbrellaArt(size: size)
        case "suitcase":
            SuitcaseArt(size: size)
        case "ticket":
            TicketArt(size: size)
        case "train":
            TrainArt(car: false, spin: spin, size: size)
        case "train car":
            TrainArt(car: true, spin: spin, size: size)
        case "car":
            CarArt(size: size, spin: spin)
        case "airplane":
            PlaneArt(phase: phase, size: size)
        case "tractor":
            TractorArt(spin: spin, size: size)
        case "castle":
            CastleArt(size: size)
        case "barn":
            BarnArt(size: size)
        case "sun":
            SunArt(phase: phase, spin: spin, size: size)
        case "octopus":
            OctopusArt(phase: phase, size: size)
        case "giraffe":
            GiraffeArt(size: size)
        case "elephant":
            ElephantArt(phase: phase, size: size)
        case "triceratops":
            TriceratopsArt(phase: phase, size: size)
        case "tyrannosaurus":
            TyrannosaurusArt(phase: phase, size: size)
        case "earth":
            EarthArt(spin: spin, size: size)
        case "venus":
            VenusArt(phase: phase, size: size)
        case "spacecraft":
            SpacecraftArt(phase: phase, size: size)
        case "magma":
            MagmaArt(size: size)
        case "wind vane":
            WindVaneArt(spin: spin, size: size)
        case "lighthouse":
            LighthouseArt(phase: phase, size: size)
        case "traffic light":
            TrafficLightArt(phase: phase, size: size)
        case "hubcap":
            HubcapArt(spin: spin, size: size)
        case "hawk":
            HawkArt(phase: phase, size: size)
        case "caterpillar":
            CaterpillarArt(phase: phase, size: size)
        case "ship":
            ShipArt(phase: phase, size: size)
        case "torch":
            TorchArt(phase: phase, size: size)
        case "hero":
            PersonArt(kind: .hero, phase: phase, size: size)
        case "princess":
            PersonArt(kind: .princess, phase: phase, size: size)
        case "pirate":
            PersonArt(kind: .pirate, phase: phase, size: size)
        case "space tool":
            WrenchArt(size: size)
        default:
            StarArt(color: DesignSystem.Colors.lessonSky, size: size, phase: phase)
        }
    }
}

// MARK: - Animals

private struct FishArt: View {
    enum Kind { case shark, dolphin, whale, fish }
    var kind: Kind
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        let color = bodyColor
        ZStack {
            if kind == .dolphin {
                ZStack(alignment: .trailing) {
                    Capsule()
                        .fill(color)
                        .frame(width: size * 0.32, height: size * 0.12)
                    FlukeTail()
                        .fill(color)
                        .frame(width: size * 0.22, height: size * 0.26)
                        .offset(x: -size * 0.16)
                }
                .frame(width: size * 0.42, height: size * 0.3, alignment: .trailing)
                .rotationEffect(.degrees(Double(phase) * 14), anchor: .trailing)
                .offset(x: -size * 0.1)
            } else if kind == .whale {
                FlukeTail()
                    .fill(color)
                    .frame(width: size * 0.4, height: size * 0.52)
                    .rotationEffect(.degrees(Double(phase) * 14), anchor: .trailing)
                    .offset(x: -size * 0.34)
            } else {
                ForkedTail()
                    .fill(color)
                    .frame(width: size * 0.3, height: size * 0.36)
                    .rotationEffect(.degrees(Double(phase) * 16))
                    .offset(x: -size * 0.34)
            }
            if kind == .whale {
                Capsule()
                    .fill(color)
                    .frame(width: size * 0.62, height: size * 0.4)
            } else {
                Capsule()
                    .fill(color)
                    .frame(width: size * (kind == .shark ? 0.62 : 0.56), height: size * (kind == .fish ? 0.3 : 0.34))
            }
            Capsule()
                .fill(DesignSystem.Colors.lessonWindow.opacity(kind == .fish ? 0.35 : 0.85))
                .frame(width: size * 0.34, height: size * 0.14)
                .offset(y: size * 0.08)
            if kind == .shark || kind == .fish {
                DownFlame()
                    .fill(color)
                    .frame(width: size * 0.16, height: size * 0.2)
                    .offset(x: size * 0.02, y: -size * 0.2)
            }
            if kind == .shark {
                sharkGill(x: 0)
                sharkGill(x: size * 0.045)
                sharkGill(x: size * 0.09)
            }
            if kind == .dolphin {
                Capsule()
                    .fill(color)
                    .frame(width: size * 0.36, height: size * 0.07)
                    .offset(x: size * 0.32, y: size * 0.04)
                Wedge()
                    .fill(color)
                    .frame(width: size * 0.12, height: size * 0.16)
                    .rotationEffect(.degrees(-16), anchor: .bottom)
                    .offset(x: -size * 0.02, y: -size * 0.2)
            }
            if kind == .whale {
                Circle()
                    .fill(DesignSystem.Colors.lessonWindow.opacity(0.8))
                    .frame(width: size * 0.08)
                    .offset(x: -size * 0.08, y: -size * (0.28 + abs(phase) * 0.08))
                Circle()
                    .fill(DesignSystem.Colors.lessonWindow.opacity(0.55))
                    .frame(width: size * 0.06)
                    .offset(x: size * 0.02, y: -size * (0.34 + abs(phase) * 0.1))
            }
            BeadEye(size: size * 0.1)
                .offset(x: size * 0.16, y: -size * 0.04)
        }
        .frame(width: size, height: size)
    }

    private func sharkGill(x: CGFloat) -> some View {
        Capsule()
            .fill(Color(red: 0.12, green: 0.24, blue: 0.32))
            .frame(width: max(1.5, size * 0.012), height: size * 0.11)
            .rotationEffect(.degrees(-12))
            .offset(x: x, y: size * 0.01)
    }

    private var bodyColor: Color {
        switch kind {
        case .shark: return Color(red: 0.27, green: 0.45, blue: 0.58)
        case .dolphin: return Color(red: 0.18, green: 0.62, blue: 0.78)
        case .whale: return Color(red: 0.18, green: 0.30, blue: 0.48)
        case .fish: return DesignSystem.Colors.lessonOrange
        }
    }
}

private struct BeastPreset {
    var body: Color
    var belly: Color
    var mane: Color? = nil
    var ear: Ear = .point
    var snout: CGFloat = 0.18
    var head: CGFloat = 0.28
    var bodyH: CGFloat = 0.34
    var wool: Bool = false
    var horn: Color? = nil
    var spots: Color? = nil
    var low: Bool = false
    var build: Build = .plain

    enum Ear { case point, flop, round, long, none }
    enum Build { case plain, dog, puppy }

    static let horse = BeastPreset(
        body: Color(red: 0.62, green: 0.34, blue: 0.14),
        belly: Color(red: 0.93, green: 0.78, blue: 0.58),
        mane: Color(red: 0.28, green: 0.14, blue: 0.08),
        ear: .point,
        snout: 0.12,
        head: 0.26
    )
    static let pony = BeastPreset(
        body: Color(red: 0.78, green: 0.52, blue: 0.28),
        belly: Color(red: 0.98, green: 0.88, blue: 0.72),
        mane: Color(red: 0.42, green: 0.24, blue: 0.12),
        ear: .point,
        snout: 0.12,
        head: 0.3,
        bodyH: 0.3
    )
    static let dog = BeastPreset(
        body: Color(red: 0.72, green: 0.48, blue: 0.24),
        belly: DesignSystem.Colors.lessonCream,
        ear: .flop,
        snout: 0.24,
        head: 0.3,
        build: .dog
    )
    static let puppy = BeastPreset(
        body: Color(red: 0.86, green: 0.62, blue: 0.34),
        belly: DesignSystem.Colors.lessonCream,
        ear: .flop,
        snout: 0.16,
        head: 0.36,
        bodyH: 0.3,
        build: .puppy
    )
    static let cat = BeastPreset(
        body: Color(red: 0.96, green: 0.62, blue: 0.28),
        belly: DesignSystem.Colors.lessonCream,
        ear: .point,
        snout: 0.1,
        head: 0.3
    )
    static let kitten = BeastPreset(
        body: Color(red: 0.98, green: 0.78, blue: 0.48),
        belly: DesignSystem.Colors.cardWhite,
        ear: .point,
        snout: 0.08,
        head: 0.36,
        bodyH: 0.28
    )
    static let pig = BeastPreset(
        body: Color(red: 0.96, green: 0.62, blue: 0.7),
        belly: Color(red: 1, green: 0.8, blue: 0.84),
        ear: .round,
        snout: 0.16,
        bodyH: 0.38
    )
    static let cow = BeastPreset(
        body: DesignSystem.Colors.lessonCream,
        belly: DesignSystem.Colors.lessonCream,
        ear: .round,
        snout: 0.16,
        bodyH: 0.4,
        spots: Color(red: 0.22, green: 0.18, blue: 0.16)
    )
    static let sheep = BeastPreset(
        body: DesignSystem.Colors.lessonWindow,
        belly: DesignSystem.Colors.cardWhite,
        ear: .none,
        snout: 0.12,
        wool: true
    )
    static let goat = BeastPreset(
        body: Color(red: 0.82, green: 0.78, blue: 0.7),
        belly: DesignSystem.Colors.lessonCream,
        ear: .point,
        snout: 0.16,
        horn: Color(red: 0.45, green: 0.34, blue: 0.22)
    )
    static let rabbit = BeastPreset(
        body: Color(red: 0.93, green: 0.9, blue: 0.86),
        belly: DesignSystem.Colors.cardWhite,
        ear: .long,
        snout: 0.08,
        head: 0.26
    )
    static let frog = BeastPreset(
        body: Color(red: 0.28, green: 0.7, blue: 0.38),
        belly: Color(red: 0.78, green: 0.92, blue: 0.55),
        ear: .none,
        snout: 0,
        head: 0.22,
        bodyH: 0.28,
        low: true
    )
}

private struct BeastArt: View {
    var preset: BeastPreset
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            if preset.build == .dog || preset.build == .puppy || (preset.ear == .point && preset.mane == nil && preset.horn == nil) {
                raisedTail
            } else if preset.mane != nil {
                Capsule()
                    .fill(preset.mane ?? preset.body)
                    .frame(width: size * 0.05, height: size * 0.42)
                    .rotationEffect(.degrees(28 + Double(phase) * 8), anchor: .top)
                    .offset(x: -size * 0.24, y: size * 0.13)
            } else {
                Capsule()
                    .fill(preset.body)
                    .frame(width: size * 0.22, height: size * 0.1)
                    .rotationEffect(.degrees(-35 + Double(phase) * 10), anchor: .trailing)
                    .offset(x: -size * 0.34, y: size * 0.02)
            }
            Ellipse()
                .fill(preset.body)
                .frame(width: size * 0.56, height: size * preset.bodyH)
                .offset(y: preset.low ? size * 0.08 : 0)
            if preset.wool {
                Circle().fill(preset.body).frame(width: size * 0.22).offset(x: -size * 0.12, y: -size * 0.08)
                Circle().fill(preset.body).frame(width: size * 0.2).offset(x: size * 0.08, y: -size * 0.1)
            }
            Ellipse()
                .fill(preset.belly)
                .frame(width: size * 0.32, height: size * preset.bodyH * 0.45)
                .offset(y: size * 0.08)
            if let spots = preset.spots {
                Circle().fill(spots).frame(width: size * 0.12).offset(x: -size * 0.08, y: -size * 0.04)
                Circle().fill(spots).frame(width: size * 0.09).offset(x: size * 0.1, y: size * 0.02)
            }
            if preset.mane != nil || preset.build == .dog || preset.build == .puppy || preset.wool {
                horseLegs
            } else {
                HStack(spacing: size * 0.14) {
                    leg(phase)
                    leg(-phase)
                }
                .offset(y: size * (preset.low ? 0.16 : 0.2))
            }
            head
                .offset(x: size * 0.26, y: -size * (preset.low ? 0.02 : 0.12))
        }
        .frame(width: size, height: size)
    }

    private var head: some View {
        ZStack {
            if let mane = preset.mane {
                Capsule()
                    .fill(mane)
                    .frame(width: size * 0.2, height: size * 0.045)
                    .rotationEffect(.degrees(-34))
                    .offset(x: -size * 0.07, y: -size * 0.02)
            }
            Circle()
                .fill(preset.body)
                .frame(width: size * preset.head)
            ears
            if let horn = preset.horn {
                Capsule()
                    .fill(horn)
                    .frame(width: size * 0.05, height: size * 0.14)
                    .rotationEffect(.degrees(-20))
                    .offset(x: size * 0.04, y: -size * 0.16)
            }
            if preset.snout > 0 {
                let smallMuzzle = preset.mane != nil && preset.snout < 0.16
                Capsule()
                    .fill(preset.mane != nil ? preset.body : preset.belly)
                    .frame(width: size * preset.snout, height: size * (smallMuzzle ? 0.055 : preset.build == .dog ? 0.12 : 0.1))
                    .offset(x: size * (smallMuzzle ? 0.1 : 0.12), y: size * (smallMuzzle ? 0.035 : 0.04))
                if preset.build == .dog || preset.build == .puppy {
                    Circle()
                        .fill(DesignSystem.Colors.deepNavy)
                        .frame(width: size * 0.05)
                        .offset(x: size * 0.16, y: size * 0.04)
                    Capsule()
                        .fill(Color(red: 1, green: 0.56, blue: 0.72))
                        .frame(width: size * 0.022, height: size * 0.04)
                        .offset(x: size * 0.17, y: size * 0.07)
                }
            }
            BeadEye(size: size * 0.08)
                .offset(x: size * 0.06, y: -size * 0.03)
        }
    }

    @ViewBuilder
    private var ears: some View {
        switch preset.ear {
        case .point:
            if preset.mane != nil {
                horseEar(x: -size * 0.03, tilt: -14)
                horseEar(x: size * 0.04, tilt: 10)
            } else {
                DownFlame()
                    .fill(preset.body)
                    .frame(width: size * 0.1, height: size * 0.12)
                    .offset(y: -size * 0.14)
            }
        case .flop:
            if preset.build == .dog || preset.build == .puppy {
                floppyEar(x: -size * 0.06, tilt: -18)
                floppyEar(x: size * 0.02, tilt: 10)
            } else {
                Capsule()
                    .fill(preset.body)
                    .frame(width: size * 0.08, height: size * 0.16)
                    .rotationEffect(.degrees(40))
                    .offset(x: -size * 0.08, y: -size * 0.02)
            }
        case .round:
            Circle()
                .fill(preset.body)
                .frame(width: size * 0.1)
                .offset(y: -size * 0.12)
        case .long:
            rabbitEar(x: -size * 0.05)
            rabbitEar(x: size * 0.05)
        case .none:
            EmptyView()
        }
    }

    private var horseLegs: some View {
        HStack(spacing: size * 0.07) {
            HStack(spacing: size * 0.03) {
                tinyLeg(phase)
                tinyLeg(-phase)
            }
            HStack(spacing: size * 0.03) {
                tinyLeg(-phase)
                tinyLeg(phase)
            }
        }
        .offset(y: size * 0.18)
    }

    private func tinyLeg(_ swing: CGFloat) -> some View {
        Capsule()
            .fill(preset.body)
            .frame(width: size * 0.045, height: size * 0.14)
            .rotationEffect(.degrees(Double(swing) * 10), anchor: .top)
    }

    private func leg(_ phase: CGFloat) -> some View {
        Capsule()
            .fill(preset.mane ?? preset.body.opacity(0.9))
            .frame(width: size * 0.07, height: size * (preset.low ? 0.12 : preset.build == .puppy ? 0.14 : 0.2))
            .rotationEffect(.degrees(Double(phase) * 22), anchor: .top)
    }

    private var raisedTail: some View {
        Capsule()
            .fill(preset.body)
            .frame(width: size * 0.38, height: size * 0.04)
            .rotationEffect(.degrees(48 + Double(phase) * 12), anchor: .trailing)
            .offset(x: -size * 0.3, y: -size * 0.02)
    }

    private func horseEar(x: CGFloat, tilt: Double) -> some View {
        Wedge()
            .fill(preset.body)
            .frame(width: size * 0.04, height: size * 0.065)
            .rotationEffect(.degrees(tilt), anchor: .bottom)
            .offset(x: x, y: -size * preset.head * 0.55)
    }

    private var dogEar: Color {
        preset.build == .puppy
            ? Color(red: 0.66, green: 0.42, blue: 0.2)
            : Color(red: 0.55, green: 0.33, blue: 0.15)
    }

    private func floppyEar(x: CGFloat, tilt: Double) -> some View {
        Capsule()
            .fill(dogEar)
            .frame(width: size * 0.07, height: size * (preset.build == .puppy ? 0.14 : 0.17))
            .rotationEffect(.degrees(tilt), anchor: .top)
            .offset(x: x, y: size * 0.01)
    }

    private func rabbitEar(x: CGFloat) -> some View {
        ZStack {
            Capsule()
                .fill(preset.body)
                .frame(width: size * 0.08, height: size * 0.24)
            Capsule()
                .fill(Color(red: 0.96, green: 0.62, blue: 0.7))
                .frame(width: size * 0.035, height: size * 0.14)
                .offset(y: size * 0.02)
        }
        .offset(x: x, y: -size * 0.12)
    }
}

private struct MonkeyArt: View {
    var phase: CGFloat
    var size: CGFloat

    private var fur: Color { Color(red: 0.55, green: 0.34, blue: 0.18) }
    private var face: Color { Color(red: 0.95, green: 0.8, blue: 0.62) }

    var body: some View {
        ZStack {
            Capsule()
                .fill(fur)
                .frame(width: size * 0.34, height: size * 0.08)
                .rotationEffect(.degrees(-55 + Double(phase) * 14), anchor: .trailing)
                .offset(x: -size * 0.12, y: size * 0.14)
            monkeyArm(sign: -1)
            monkeyArm(sign: 1)
            Ellipse()
                .fill(fur)
                .frame(width: size * 0.36, height: size * 0.4)
                .offset(y: size * 0.1)
            Ellipse()
                .fill(face)
                .frame(width: size * 0.16, height: size * 0.2)
                .offset(y: size * 0.14)
            Circle().fill(fur).frame(width: size * 0.12).offset(x: -size * 0.16, y: -size * 0.14)
            Circle().fill(face).frame(width: size * 0.07).offset(x: -size * 0.16, y: -size * 0.14)
            Circle().fill(fur).frame(width: size * 0.12).offset(x: size * 0.16, y: -size * 0.14)
            Circle().fill(face).frame(width: size * 0.07).offset(x: size * 0.16, y: -size * 0.14)
            Circle().fill(fur).frame(width: size * 0.32).offset(y: -size * 0.14)
            Ellipse().fill(face).frame(width: size * 0.2, height: size * 0.16).offset(y: -size * 0.1)
            BeadEye(size: size * 0.06).offset(x: -size * 0.05, y: -size * 0.12)
            BeadEye(size: size * 0.06).offset(x: size * 0.05, y: -size * 0.12)
            Capsule()
                .fill(fur)
                .frame(width: size * 0.08, height: size * 0.025)
                .offset(y: -size * 0.04)
        }
        .frame(width: size, height: size)
    }

    private func monkeyArm(sign: CGFloat) -> some View {
        Capsule()
            .fill(fur)
            .frame(width: size * 0.09, height: size * 0.28)
            .rotationEffect(.degrees(Double(sign) * (24 - Double(phase) * 8)), anchor: .top)
            .offset(x: sign * size * 0.15, y: size * 0.16)
    }
}

private struct DinoArt: View {
    var phase: CGFloat
    var size: CGFloat

    private var green: Color { Color(red: 0.2, green: 0.62, blue: 0.4) }

    var body: some View {
        ZStack {
            Capsule()
                .fill(green)
                .frame(width: size * 0.4, height: size * 0.11)
                .rotationEffect(.degrees(-24 + Double(phase) * 8), anchor: .trailing)
                .offset(x: -size * 0.28, y: size * 0.1)
            ForEach(0..<4, id: \.self) { leg in
                Capsule()
                    .fill(green)
                    .frame(width: size * 0.045, height: size * 0.2)
                    .offset(x: size * (CGFloat(leg) * 0.07 - 0.1), y: size * 0.1)
            }
            Ellipse()
                .fill(green)
                .frame(width: size * 0.42, height: size * 0.3)
            Capsule()
                .fill(green)
                .frame(width: size * 0.48, height: size * 0.09)
                .rotationEffect(.degrees(-50), anchor: .leading)
                .offset(x: size * 0.34, y: size * 0.02)
            Ellipse()
                .fill(green)
                .frame(width: size * 0.18, height: size * 0.13)
                .offset(x: size * 0.36, y: -size * 0.32)
            BeadEye(size: size * 0.07)
                .offset(x: size * 0.4, y: -size * 0.33)
        }
        .frame(width: size, height: size)
    }
}

private struct BirdPreset {
    var body: Color
    var beak: Color
    var belly: Color
    var comb: Bool = false
    var upright: Bool = false

    static let bird = BirdPreset(body: Color(red: 0.2, green: 0.55, blue: 0.86), beak: DesignSystem.Colors.lessonOrange, belly: DesignSystem.Colors.lessonWindow)
    static let hen = BirdPreset(body: DesignSystem.Colors.lessonCream, beak: DesignSystem.Colors.lessonOrange, belly: DesignSystem.Colors.cardWhite, comb: true)
    static let chicken = BirdPreset(body: DesignSystem.Colors.cardWhite, beak: DesignSystem.Colors.lessonOrange, belly: DesignSystem.Colors.lessonYellow, comb: true)
    static let rooster = BirdPreset(body: Color(red: 0.86, green: 0.28, blue: 0.22), beak: DesignSystem.Colors.lessonYellow, belly: DesignSystem.Colors.lessonOrange, comb: true)
    static let duck = BirdPreset(body: DesignSystem.Colors.lessonYellow, beak: DesignSystem.Colors.lessonOrange, belly: DesignSystem.Colors.lessonCream)
    static let penguin = BirdPreset(body: Color(red: 0.12, green: 0.16, blue: 0.28), beak: DesignSystem.Colors.lessonOrange, belly: DesignSystem.Colors.cardWhite, upright: true)
}

private struct BirdArt: View {
    var preset: BirdPreset
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            if preset.upright {
                flipper(sign: -1)
                flipper(sign: 1)
                Capsule().fill(preset.body).frame(width: size * 0.4, height: size * 0.52)
                Capsule().fill(preset.belly).frame(width: size * 0.22, height: size * 0.36)
                Circle().fill(preset.body).frame(width: size * 0.28).offset(y: -size * 0.28)
                BeadEye(size: size * 0.08).offset(x: size * 0.06, y: -size * 0.3)
                Capsule().fill(preset.beak).frame(width: size * 0.12, height: size * 0.06)
                    .rotationEffect(.degrees(18))
                    .offset(x: size * 0.14, y: -size * 0.2)
                HStack(spacing: size * 0.08) {
                    Capsule().fill(preset.beak).frame(width: size * 0.1, height: size * 0.06)
                    Capsule().fill(preset.beak).frame(width: size * 0.1, height: size * 0.06)
                }
                .offset(y: size * 0.28)
            } else {
                wing(phase).offset(y: -size * 0.02)
                Ellipse().fill(preset.body).frame(width: size * 0.46, height: size * 0.32)
                Ellipse().fill(preset.belly).frame(width: size * 0.24, height: size * 0.16).offset(y: size * 0.04)
                Circle().fill(preset.body).frame(width: size * 0.24).offset(x: size * 0.24, y: -size * 0.08)
                if preset.comb {
                    DownFlame()
                        .fill(DesignSystem.Colors.lessonCoral)
                        .frame(width: size * 0.1, height: size * 0.1)
                        .offset(x: size * 0.24, y: -size * 0.22)
                }
                BeadEye(size: size * 0.08).offset(x: size * 0.28, y: -size * 0.1)
                Capsule().fill(preset.beak).frame(width: size * (preset.comb ? 0.1 : 0.14), height: size * 0.07)
                    .offset(x: size * 0.38, y: -size * 0.04)
                Capsule().fill(preset.beak).frame(width: size * 0.08, height: size * 0.05)
                    .offset(x: size * 0.04, y: size * 0.18)
                    .rotationEffect(.degrees(Double(phase) * 12))
            }
        }
        .frame(width: size, height: size)
    }

    private func flipper(sign: CGFloat) -> some View {
        Capsule()
            .fill(preset.body)
            .frame(width: size * 0.1, height: size * 0.28)
            .rotationEffect(.degrees(Double(sign) * (16 + Double(phase) * 6)), anchor: .top)
            .offset(x: sign * size * 0.18, y: size * 0.06)
    }

    private func wing(_ phase: CGFloat) -> some View {
        Ellipse()
            .fill(preset.body.opacity(0.85))
            .frame(width: size * 0.34, height: size * 0.16)
            .rotationEffect(.degrees(Double(phase) * 28))
            .offset(x: -size * 0.08)
    }
}

private struct FairyArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(DesignSystem.Colors.lessonWindow.opacity(0.92))
                .frame(width: size * 0.34, height: size * 0.11)
                .rotationEffect(.degrees(20 + Double(phase) * 18), anchor: .trailing)
                .offset(x: -size * 0.15, y: -size * 0.02)
            Ellipse()
                .fill(DesignSystem.Colors.lavenderPurple.opacity(0.78))
                .frame(width: size * 0.34, height: size * 0.11)
                .rotationEffect(.degrees(-20 - Double(phase) * 18), anchor: .leading)
                .offset(x: size * 0.15, y: -size * 0.02)
            Capsule()
                .fill(DesignSystem.Colors.lessonCoral)
                .frame(width: size * 0.16, height: size * 0.28)
                .offset(y: size * 0.06)
            Circle()
                .fill(Color(red: 0.98, green: 0.82, blue: 0.7))
                .frame(width: size * 0.2)
                .offset(y: -size * 0.16)
            BeadEye(size: size * 0.038).offset(x: -size * 0.035, y: -size * 0.165)
            BeadEye(size: size * 0.038).offset(x: size * 0.035, y: -size * 0.165)
        }
        .frame(width: size, height: size)
    }
}

private struct WingedBug: View {
    enum Kind { case butterfly, bee, ladybug, ant }
    var kind: Kind
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            switch kind {
            case .butterfly:
                wing(DesignSystem.Colors.lavenderPurple, sign: -1)
                wing(DesignSystem.Colors.lessonCoral, sign: 1)
                Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.08, height: size * 0.4)
            case .bee:
                wing(DesignSystem.Colors.lessonWindow, sign: -1).offset(y: -size * 0.08)
                wing(DesignSystem.Colors.lessonWindow, sign: 1).offset(y: -size * 0.08)
                Capsule().fill(DesignSystem.Colors.lessonYellow).frame(width: size * 0.28, height: size * 0.2)
                Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.06, height: size * 0.2)
                Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.06, height: size * 0.2).offset(x: size * 0.08)
            case .ladybug:
                Circle().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.5)
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.1).offset(x: -size * 0.1, y: -size * 0.06)
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.1).offset(x: size * 0.1, y: size * 0.06)
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.16).offset(y: -size * 0.22)
            case .ant:
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.22).offset(x: -size * 0.12)
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.16)
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.14).offset(x: size * 0.12, y: -size * 0.02)
                Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.03, height: size * 0.14)
                    .rotationEffect(.degrees(-24)).offset(x: size * 0.08, y: -size * 0.16)
                Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.03, height: size * 0.14)
                    .rotationEffect(.degrees(24)).offset(x: size * 0.16, y: -size * 0.16)
                BeadEye(size: size * 0.05).offset(x: size * 0.14, y: -size * 0.04)
            }
            if kind != .ant {
                BeadEye(size: size * 0.07).offset(x: size * 0.08, y: -size * 0.02)
            }
        }
        .frame(width: size, height: size)
    }

    private func wing(_ color: Color, sign: CGFloat) -> some View {
        Ellipse()
            .fill(color.opacity(0.85))
            .frame(width: size * 0.28, height: size * 0.2)
            .rotationEffect(.degrees(Double(sign) * (18 + Double(phase) * 24)))
            .offset(x: sign * size * 0.16, y: -size * 0.06)
    }
}

private struct CrabArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        let red = DesignSystem.Colors.lessonCoral
        ZStack {
            crabClaw(side: -1, phase: phase)
            crabClaw(side: 1, phase: -phase)
            Ellipse().fill(red).frame(width: size * 0.46, height: size * 0.32)
            HStack(spacing: size * 0.06) {
                BeadEye(size: size * 0.1)
                BeadEye(size: size * 0.1)
            }
            .offset(y: -size * 0.06)
        }
        .frame(width: size, height: size)
    }

    private func crabClaw(side: CGFloat, phase: CGFloat) -> some View {
        let red = DesignSystem.Colors.lessonCoral
        return ZStack {
            Capsule()
                .fill(red)
                .frame(width: size * 0.3, height: size * 0.07)
                .offset(x: side * size * 0.1)
            Circle()
                .fill(red)
                .frame(width: size * 0.09)
                .offset(x: side * size * 0.2)
            Capsule()
                .fill(red)
                .frame(width: size * 0.18, height: size * 0.05)
                .rotationEffect(.degrees(Double(side) * (-22 + Double(phase) * 8)))
                .offset(x: side * size * 0.24, y: -size * 0.03)
            Capsule()
                .fill(red)
                .frame(width: size * 0.18, height: size * 0.05)
                .rotationEffect(.degrees(Double(side) * (16 + Double(phase) * 8)))
                .offset(x: side * size * 0.24, y: size * 0.028)
        }
    }
}

private struct BeadEye: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            Circle().fill(DesignSystem.Colors.lessonWindow)
            Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.48)
                .offset(x: size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Props

private struct VolcanoArt: View {
    var erupting: Bool
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack(alignment: .bottom) {
            Wedge()
                .fill(Color(red: 0.45, green: 0.28, blue: 0.22))
                .frame(width: size * 0.72, height: size * 0.5)
            Ellipse()
                .fill(erupting ? DesignSystem.Colors.lessonCoral : DesignSystem.Colors.lessonOrange)
                .frame(width: size * 0.18, height: size * 0.08)
                .offset(y: -size * 0.46)
            Circle()
                .fill(DesignSystem.Colors.lessonCream.opacity(0.95))
                .frame(width: size * 0.14)
                .offset(y: -size * (0.56 + abs(phase) * 0.14))
            Circle()
                .fill(DesignSystem.Colors.cardWhite.opacity(0.8))
                .frame(width: size * 0.1)
                .offset(x: size * 0.08, y: -size * (0.66 + abs(phase) * 0.1))
        }
        .frame(width: size, height: size)
    }
}

/// One volcano. Hot rock sits on the upper slope. Counted rocks sit on the ground beside it.
struct VolcanoStudyScene: View {
    var erupting: Bool = false
    var hotRockCount: Int = 0
    var groundRockCount: Int = 0

    @State private var drift = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let coneWidth = DesignSystem.Metrics.scaled(168)
        let coneHeight = DesignSystem.Metrics.scaled(118)
        let hasGroundRocks = groundRockCount > 0
        let coneShift: CGFloat = hasGroundRocks ? -DesignSystem.Metrics.scaled(46) : 0

        ZStack(alignment: .bottom) {
            LessonSkyBackdrop(habitat: .sky)

            Capsule()
                .fill(Color(red: 0.55, green: 0.36, blue: 0.24).opacity(0.55))
                .frame(height: DesignSystem.Metrics.scaled(12))
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.bottom, DesignSystem.Metrics.scaled(16))

            ZStack(alignment: .bottom) {
                cone(width: coneWidth, height: coneHeight)
                    .offset(x: coneShift)
                if hotRockCount > 0 {
                    hotRocks(min(hotRockCount, 5))
                        .offset(x: coneShift, y: -coneHeight * 0.72)
                }
                if hasGroundRocks {
                    groundRocks(min(groundRockCount, 12))
                        .offset(x: DesignSystem.Metrics.scaled(78))
                }
            }
            .padding(.bottom, DesignSystem.Metrics.scaled(18))
        }
        .frame(height: DesignSystem.Metrics.scaled(220))
        .frame(maxWidth: .infinity)
        .clipped()
        .accessibilityHidden(true)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                drift = true
            }
        }
    }

    private func cone(width: CGFloat, height: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            Wedge()
                .fill(Color(red: 0.45, green: 0.28, blue: 0.22))
                .frame(width: width, height: height)
            Ellipse()
                .fill(erupting ? DesignSystem.Colors.lessonCoral : DesignSystem.Colors.lessonOrange)
                .frame(width: width * 0.16, height: height * 0.08)
                .offset(y: -height * 0.9)
            Circle()
                .fill(Color(red: 0.75, green: 0.78, blue: 0.82).opacity(0.92))
                .frame(width: width * 0.1, height: width * 0.1)
                .offset(y: drift ? -height * 1.08 : -height * 0.96)
            Circle()
                .fill(DesignSystem.Colors.cardWhite.opacity(0.8))
                .frame(width: width * 0.07, height: width * 0.07)
                .offset(x: width * 0.06, y: drift ? -height * 0.98 : -height * 0.86)
        }
        .frame(width: width, height: height + DesignSystem.Metrics.scaled(28), alignment: .bottom)
    }

    private func hotRocks(_ count: Int) -> some View {
        let size = DesignSystem.Metrics.scaled(count == 1 ? 42 : 34)
        return HStack(spacing: DesignSystem.Metrics.scaled(-6)) {
            ForEach(0..<count, id: \.self) { index in
                let middle = CGFloat(count - 1) / 2
                let edge = abs(CGFloat(index) - middle)
                RockArt(kind: .hot, size: size)
                    .offset(y: edge * DesignSystem.Metrics.scaled(8))
            }
        }
    }

    private func groundRocks(_ count: Int) -> some View {
        let size = DesignSystem.Metrics.scaled(count > 6 ? 28 : 34)
        let columns = count > 6 ? 6 : count
        let rows = stride(from: 0, to: count, by: columns).map { start in
            Array(start..<min(start + columns, count))
        }
        return VStack(spacing: 2) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 4) {
                    ForEach(row, id: \.self) { _ in
                        RockArt(kind: .rock, size: size)
                    }
                }
            }
        }
    }
}

private struct CloudArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            puffs(Color(red: 0.35, green: 0.48, blue: 0.62), grow: size * 0.045)
            puffs(DesignSystem.Colors.cardWhite, grow: 0)
        }
        .offset(x: phase * size * 0.06)
        .frame(width: size, height: size)
    }

    private func puffs(_ color: Color, grow: CGFloat) -> some View {
        ZStack {
            Ellipse().fill(color).frame(width: size * 0.36 + grow, height: size * 0.24 + grow)
            Ellipse().fill(color).frame(width: size * 0.28 + grow, height: size * 0.2 + grow).offset(x: -size * 0.16, y: size * 0.05)
            Ellipse().fill(color).frame(width: size * 0.3 + grow, height: size * 0.2 + grow).offset(x: size * 0.15, y: size * 0.04)
            Ellipse().fill(color).frame(width: size * 0.2 + grow, height: size * 0.16 + grow).offset(y: -size * 0.08)
        }
    }
}

private struct CapeArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        CapeShape(flap: phase)
            .fill(DesignSystem.Colors.lessonCoral)
            .frame(width: size * 0.55, height: size * 0.62)
            .frame(width: size, height: size)
    }
}

private struct SensorArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            Capsule()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.06, height: size * 0.42)
                .offset(y: size * 0.1)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: size * 0.28, height: size * 0.2)
                .offset(y: -size * 0.08)
            Circle()
                .fill(abs(phase) > 0.45 ? DesignSystem.Colors.lessonCoral : DesignSystem.Colors.lessonYellow)
                .frame(width: size * 0.08)
                .offset(y: -size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

private struct GearArt: View {
    var spin: TimeInterval
    var size: CGFloat

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { tooth in
                RoundedRectangle(cornerRadius: 1, style: .continuous)
                    .fill(DesignSystem.Colors.lessonWindow)
                    .frame(width: size * 0.1, height: size * 0.16)
                    .offset(y: -size * 0.2)
                    .rotationEffect(.degrees(Double(tooth) * 45))
            }
            Circle().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.28)
            Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.1)
        }
        .rotationEffect(.degrees(spin * 80))
        .frame(width: size, height: size)
    }
}

private struct PineconeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        path.move(to: CGPoint(x: midX, y: rect.minY))
        path.addCurve(
            to: CGPoint(x: midX, y: rect.maxY),
            control1: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.28),
            control2: CGPoint(x: rect.minX + rect.width * 0.16, y: rect.maxY)
        )
        path.addCurve(
            to: CGPoint(x: midX, y: rect.minY),
            control1: CGPoint(x: rect.maxX - rect.width * 0.16, y: rect.maxY),
            control2: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.28)
        )
        path.closeSubpath()
        return path
    }
}

private struct PineconeArt: View {
    var size: CGFloat

    var body: some View {
        let scale = Color(red: 0.62, green: 0.4, blue: 0.2)
        let pale = Color(red: 0.72, green: 0.5, blue: 0.28)
        return ZStack {
            PineconeShape().fill(Color(red: 0.48, green: 0.3, blue: 0.16))
            ForEach(0..<6, id: \.self) { row in
                let count = [1, 2, 3, 3, 2, 1][row]
                ForEach(0..<count, id: \.self) { column in
                    Ellipse()
                        .fill(row.isMultiple(of: 2) ? scale : pale)
                        .frame(width: size * 0.09, height: size * 0.07)
                        .offset(
                            x: (CGFloat(column) - CGFloat(count - 1) / 2) * size * 0.07,
                            y: size * (CGFloat(row) * 0.075 - 0.18)
                        )
                }
            }
        }
        .frame(width: size * 0.34, height: size * 0.56)
        .clipShape(PineconeShape())
        .frame(width: size, height: size)
    }
}

private struct ChickArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            Ellipse().fill(DesignSystem.Colors.lessonYellow).frame(width: size * 0.4, height: size * 0.32)
            Circle().fill(DesignSystem.Colors.lessonYellow).frame(width: size * 0.24).offset(x: size * 0.12, y: -size * 0.1)
            Capsule().fill(DesignSystem.Colors.lessonOrange).frame(width: size * 0.1, height: size * 0.06).offset(x: size * 0.24, y: -size * 0.08)
            BeadEye(size: size * 0.07).offset(x: size * 0.16, y: -size * 0.12)
            HStack(spacing: size * 0.08) {
                Capsule().fill(DesignSystem.Colors.lessonOrange).frame(width: size * 0.08, height: size * 0.05)
                    .rotationEffect(.degrees(Double(phase) * 16))
                Capsule().fill(DesignSystem.Colors.lessonOrange).frame(width: size * 0.08, height: size * 0.05)
                    .rotationEffect(.degrees(Double(-phase) * 16))
            }
            .offset(y: size * 0.16)
        }
        .frame(width: size, height: size)
    }
}

private struct ShellArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            ScallopShell().fill(DesignSystem.Colors.lessonCream)
            ribFan
                .mask(ScallopShell())
            ScallopShell().stroke(DesignSystem.Colors.lessonOrange, lineWidth: max(2, size * 0.02))
            Circle()
                .fill(DesignSystem.Colors.lessonOrange)
                .frame(width: size * 0.1)
                .offset(y: size * 0.22)
        }
        .frame(width: size, height: size)
    }

    private var ribFan: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { rib in
                Capsule()
                    .fill(Color(red: 0.96, green: 0.7, blue: 0.38).opacity(0.85))
                    .frame(width: max(2, size * 0.02), height: size * 0.46)
                    .offset(y: -size * 0.08)
                    .rotationEffect(.degrees(Double(rib - 2) * 18))
            }
        }
    }
}

private struct ScallopShell: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let hinge = CGPoint(x: rect.midX, y: rect.maxY * 0.78)
        path.move(to: hinge)
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + rect.width * 0.16, y: rect.midY),
            control: CGPoint(x: rect.minX, y: rect.maxY * 0.72)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.16),
            control: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.08)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.16, y: rect.midY),
            control: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.minY + rect.height * 0.08)
        )
        path.addQuadCurve(
            to: hinge,
            control: CGPoint(x: rect.maxX, y: rect.maxY * 0.72)
        )
        path.closeSubpath()
        return path
    }
}

private struct EggArt: View {
    var speckled: Bool
    var size: CGFloat
    var body: some View {
        Ellipse()
            .fill(DesignSystem.Colors.lessonCream)
            .overlay {
                Ellipse().stroke(DesignSystem.Colors.lessonOrange.opacity(0.7), lineWidth: 2)
            }
            .frame(width: size * 0.4, height: size * 0.52)
            .overlay {
                if speckled {
                    Circle().fill(Color(red: 0.45, green: 0.32, blue: 0.2)).frame(width: size * 0.06).offset(x: -size * 0.06, y: -size * 0.04)
                    Circle().fill(Color(red: 0.45, green: 0.32, blue: 0.2)).frame(width: size * 0.05).offset(x: size * 0.07, y: size * 0.06)
                }
            }
            .frame(width: size, height: size)
    }
}

private struct BoneArt: View {
    enum Kind { case bone, fossil, treat }
    var kind: Kind
    var size: CGFloat
    var body: some View {
        let color: Color = kind == .treat
            ? Color(red: 0.72, green: 0.48, blue: 0.24)
            : DesignSystem.Colors.lessonCream
        ZStack {
            if kind == .fossil {
                Ellipse()
                    .fill(Color(red: 0.55, green: 0.52, blue: 0.48))
                    .frame(width: size * 0.62, height: size * 0.4)
            }
            Capsule().fill(color).frame(width: size * 0.46, height: size * 0.12)
            Circle().fill(color).frame(width: size * 0.16).offset(x: -size * 0.2, y: -size * 0.06)
            Circle().fill(color).frame(width: size * 0.16).offset(x: -size * 0.2, y: size * 0.06)
            Circle().fill(color).frame(width: size * 0.16).offset(x: size * 0.2, y: -size * 0.06)
            Circle().fill(color).frame(width: size * 0.16).offset(x: size * 0.2, y: size * 0.06)
        }
        .frame(width: size, height: size)
    }
}

private struct PlanetArt: View {
    var size: CGFloat
    var spin: TimeInterval
    var body: some View {
        ZStack {
            Ellipse()
                .stroke(DesignSystem.Colors.lessonYellow, lineWidth: max(2, size * 0.04))
                .frame(width: size * 0.78, height: size * 0.28)
                .rotationEffect(.degrees(-18))
            Circle()
                .fill(Color(red: 0.45, green: 0.36, blue: 0.86))
                .frame(width: size * 0.42)
            Circle()
                .fill(DesignSystem.Colors.lessonCoral.opacity(0.8))
                .frame(width: size * 0.12)
                .offset(x: size * 0.08)
                .rotationEffect(.degrees(spin * 40))
        }
        .frame(width: size, height: size)
    }
}

private struct MoonArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            Circle().fill(DesignSystem.Colors.lessonCream).frame(width: size * 0.5)
            Circle().fill(DesignSystem.Colors.lessonYellow.opacity(0.45)).frame(width: size * 0.1).offset(x: -size * 0.08, y: -size * 0.06)
            Circle().fill(DesignSystem.Colors.lessonYellow.opacity(0.35)).frame(width: size * 0.07).offset(x: size * 0.1, y: size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

private struct FivePointStar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.41
        for index in 0..<10 {
            let angle = (Double(index) * 36 - 90) * Double.pi / 180
            let radius = index.isMultiple(of: 2) ? outer : inner
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

private struct StarArt: View {
    var color: Color
    var size: CGFloat
    var phase: CGFloat
    var body: some View {
        FivePointStar()
            .fill(color)
            .frame(width: size * 0.72, height: size * 0.72)
            .scaleEffect(1 + abs(phase) * 0.06)
            .frame(width: size, height: size)
    }
}

private struct CrystalArt: View {
    var size: CGFloat
    var phase: CGFloat
    var body: some View {
        DownFlame()
            .fill(DesignSystem.Colors.skyBlue)
            .frame(width: size * 0.36, height: size * 0.48)
            .overlay {
                DownFlame()
                    .fill(DesignSystem.Colors.lessonWindow.opacity(0.8))
                    .frame(width: size * 0.12, height: size * 0.28)
                    .offset(y: -size * 0.04)
            }
            .opacity(0.75 + Double(abs(phase)) * 0.25)
            .frame(width: size, height: size)
    }
}

private struct RockArt: View {
    enum Kind { case rock, moon, stone, hot }
    var kind: Kind
    var size: CGFloat

    var body: some View {
        let body: Color
        let highlight: Color
        switch kind {
        case .rock:
            body = Color(red: 0.42, green: 0.40, blue: 0.38)
            highlight = Color(red: 0.62, green: 0.48, blue: 0.40)
        case .moon:
            body = Color(red: 0.72, green: 0.74, blue: 0.78)
            highlight = Color(red: 0.55, green: 0.58, blue: 0.64)
        case .stone:
            body = Color(red: 0.32, green: 0.34, blue: 0.38)
            highlight = Color(red: 0.48, green: 0.50, blue: 0.54)
        case .hot:
            body = Color(red: 0.86, green: 0.16, blue: 0.06)
            highlight = Color(red: 1.0, green: 0.82, blue: 0.28)
        }
        return ZStack {
            if kind == .hot {
                Ellipse()
                    .fill(Color(red: 1, green: 0.42, blue: 0.08).opacity(0.55))
                    .frame(width: size * 0.72, height: size * 0.46)
            }
            Ellipse()
                .fill(body)
                .frame(width: size * (kind == .stone ? 0.4 : 0.5), height: size * (kind == .stone ? 0.28 : 0.34))
            if kind == .moon {
                Circle().fill(highlight).frame(width: size * 0.1).offset(x: -size * 0.08, y: -size * 0.02)
                Circle().fill(highlight).frame(width: size * 0.06).offset(x: size * 0.08, y: size * 0.04)
            } else {
                Ellipse()
                    .fill(highlight)
                    .frame(width: size * 0.16, height: size * 0.1)
                    .offset(x: -size * 0.08, y: -size * 0.04)
            }
        }
        .frame(width: size, height: size)
    }
}

private struct RobotArt: View {
    var phase: CGFloat
    var size: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: size * 0.4, height: size * 0.32)
                .offset(y: size * 0.08)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: size * 0.36, height: size * 0.24)
                .offset(y: -size * 0.16)
            Circle().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.08).offset(x: -size * 0.08, y: -size * 0.16)
            Circle().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.08).offset(x: size * 0.08, y: -size * 0.16)
            Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.04, height: size * 0.12).offset(y: -size * 0.32)
            Circle().fill(DesignSystem.Colors.lessonYellow).frame(width: size * 0.08).offset(y: -size * 0.36 + phase * size * 0.02)
            HStack(spacing: size * 0.16) {
                Circle().stroke(DesignSystem.Colors.deepNavy, lineWidth: 2).frame(width: size * 0.12)
                Circle().stroke(DesignSystem.Colors.deepNavy, lineWidth: 2).frame(width: size * 0.12)
            }
            .offset(y: size * 0.26)
        }
        .frame(width: size, height: size)
    }
}

private struct RoseCurl: Shape {
    var tight = false

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let scale = tight ? 0.72 : 1
        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + rect.width * x, y: rect.minY + rect.height * y)
        }
        path.move(to: point(0.5, 0.92 * scale))
        path.addCurve(to: point(0.22, 0.28), control1: point(0.08, 0.9), control2: point(0.02, 0.36))
        path.addCurve(to: point(0.78, 0.62), control1: point(0.48, 0.08), control2: point(0.96, 0.4))
        path.addCurve(to: point(0.34, 0.55), control1: point(0.62, 0.9), control2: point(0.28, 0.78))
        if !tight {
            path.addCurve(to: point(0.58, 0.42), control1: point(0.4, 0.36), control2: point(0.66, 0.34))
        }
        return path
    }
}

private struct FlowerArt: View {
    var rose: Bool
    var phase: CGFloat
    var size: CGFloat
    var body: some View {
        ZStack {
            if rose {
                roseBloom
            } else {
                let petal = Color(red: 0.98, green: 0.55, blue: 0.72)
                Capsule().fill(Color(red: 0.2, green: 0.62, blue: 0.36)).frame(width: size * 0.06, height: size * 0.36).offset(y: size * 0.16)
                ForEach(0..<5, id: \.self) { index in
                    Ellipse()
                        .fill(petal)
                        .frame(width: size * 0.16, height: size * 0.26)
                        .offset(y: -size * 0.12)
                        .rotationEffect(.degrees(Double(index) * 72 + Double(phase) * 4))
                }
                Circle().fill(DesignSystem.Colors.lessonYellow).frame(width: size * 0.14)
            }
        }
        .frame(width: size, height: size)
    }

    private var roseBloom: some View {
        let coral = DesignSystem.Colors.lessonCoral
        let deep = Color(red: 0.72, green: 0.16, blue: 0.32)
        let blush = Color(red: 0.95, green: 0.48, blue: 0.59)
        return ZStack {
            Capsule().fill(Color(red: 0.2, green: 0.62, blue: 0.36)).frame(width: size * 0.06, height: size * 0.28).offset(y: size * 0.18)
            Ellipse().fill(Color(red: 0.18, green: 0.6, blue: 0.32))
                .frame(width: size * 0.16, height: size * 0.07)
                .rotationEffect(.degrees(36))
                .offset(x: size * 0.06, y: size * 0.2)
            Ellipse().fill(coral).frame(width: size * 0.2, height: size * 0.3)
                .rotationEffect(.degrees(-24)).offset(x: -size * 0.12, y: -size * 0.02)
            Ellipse().fill(coral).frame(width: size * 0.2, height: size * 0.3)
                .rotationEffect(.degrees(24)).offset(x: size * 0.12, y: -size * 0.02)
            Ellipse().fill(blush).frame(width: size * 0.24, height: size * 0.28).offset(y: -size * 0.1)
            Ellipse().fill(deep).frame(width: size * 0.16, height: size * 0.22).offset(y: -size * 0.02)
            RoseCurl()
                .stroke(blush, style: StrokeStyle(lineWidth: size * 0.045, lineCap: .round))
                .frame(width: size * 0.2, height: size * 0.22)
                .offset(y: -size * 0.04)
            RoseCurl(tight: true)
                .stroke(Color(red: 1, green: 0.82, blue: 0.86), style: StrokeStyle(lineWidth: size * 0.028, lineCap: .round))
                .frame(width: size * 0.12, height: size * 0.13)
                .offset(y: -size * 0.05)
        }
    }
}

private struct AppleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midX = rect.midX
        let dip = CGPoint(x: midX, y: rect.minY + height * 0.18)
        path.move(to: dip)
        path.addCurve(
            to: CGPoint(x: rect.minX + width * 0.06, y: rect.minY + height * 0.5),
            control1: CGPoint(x: rect.minX + width * 0.22, y: rect.minY),
            control2: CGPoint(x: rect.minX, y: rect.minY + height * 0.2)
        )
        path.addCurve(
            to: CGPoint(x: midX, y: rect.maxY),
            control1: CGPoint(x: rect.minX + width * 0.08, y: rect.minY + height * 0.86),
            control2: CGPoint(x: rect.minX + width * 0.3, y: rect.maxY)
        )
        path.addCurve(
            to: CGPoint(x: rect.maxX - width * 0.06, y: rect.minY + height * 0.5),
            control1: CGPoint(x: rect.maxX - width * 0.3, y: rect.maxY),
            control2: CGPoint(x: rect.maxX - width * 0.08, y: rect.minY + height * 0.86)
        )
        path.addCurve(
            to: dip,
            control1: CGPoint(x: rect.maxX, y: rect.minY + height * 0.2),
            control2: CGPoint(x: rect.maxX - width * 0.22, y: rect.minY)
        )
        path.closeSubpath()
        return path
    }
}

private struct AppleArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            AppleShape()
                .fill(DesignSystem.Colors.lessonCoral)
                .frame(width: size * 0.48, height: size * 0.4)
            Capsule()
                .fill(Color(red: 0.36, green: 0.22, blue: 0.12))
                .frame(width: size * 0.025, height: size * 0.1)
                .rotationEffect(.degrees(-16))
                .offset(y: -size * 0.24)
            Ellipse()
                .fill(Color(red: 0.2, green: 0.62, blue: 0.36))
                .frame(width: size * 0.13, height: size * 0.06)
                .rotationEffect(.degrees(-28))
                .offset(x: size * 0.07, y: -size * 0.22)
        }
        .frame(width: size, height: size)
    }
}

private struct RoundFruit: View {
    var color: Color
    var leaf: Bool
    var size: CGFloat
    var body: some View {
        ZStack {
            Circle().fill(color).frame(width: size * 0.42)
            if leaf {
                Ellipse().fill(Color(red: 0.2, green: 0.62, blue: 0.36))
                    .frame(width: size * 0.14, height: size * 0.08)
                    .rotationEffect(.degrees(-30))
                    .offset(x: size * 0.06, y: -size * 0.22)
            }
            Circle().fill(DesignSystem.Colors.cardWhite.opacity(0.35)).frame(width: size * 0.08).offset(x: -size * 0.08, y: -size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

private struct MushroomArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            Capsule().fill(Color(red: 0.89, green: 0.87, blue: 0.85)).frame(width: size * 0.16, height: size * 0.28).offset(y: size * 0.1)
            Capsule().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.46, height: size * 0.28).offset(y: -size * 0.06)
            Circle().fill(DesignSystem.Colors.lessonCream).frame(width: size * 0.08).offset(x: -size * 0.08, y: -size * 0.08)
            Circle().fill(DesignSystem.Colors.lessonCream).frame(width: size * 0.06).offset(x: size * 0.1, y: -size * 0.02)
        }
        .frame(width: size, height: size)
    }
}

private struct LeafArt: View {
    var sprout: Bool
    var phase: CGFloat
    var size: CGFloat
    var body: some View {
        ZStack {
            if sprout {
                Ellipse().fill(Color(red: 0.35, green: 0.75, blue: 0.4))
                    .frame(width: size * 0.18, height: size * 0.09)
                    .rotationEffect(.degrees(-34 + Double(phase) * 6), anchor: .trailing)
                    .offset(x: -size * 0.09, y: -size * 0.08)
                Ellipse().fill(Color(red: 0.35, green: 0.75, blue: 0.4))
                    .frame(width: size * 0.18, height: size * 0.09)
                    .rotationEffect(.degrees(34 - Double(phase) * 6), anchor: .leading)
                    .offset(x: size * 0.09, y: -size * 0.08)
                Capsule().fill(Color(red: 0.2, green: 0.62, blue: 0.36)).frame(width: size * 0.06, height: size * 0.32)
            } else {
                Ellipse().fill(Color(red: 0.22, green: 0.66, blue: 0.38))
                    .frame(width: size * 0.28, height: size * 0.46)
                    .rotationEffect(.degrees(-20 + Double(phase) * 10))
                Capsule()
                    .fill(Color(red: 0.12, green: 0.42, blue: 0.24))
                    .frame(width: size * 0.025, height: size * 0.36)
                    .rotationEffect(.degrees(-20 + Double(phase) * 10))
                Capsule()
                    .fill(Color(red: 0.12, green: 0.42, blue: 0.24))
                    .frame(width: size * 0.02, height: size * 0.12)
                    .rotationEffect(.degrees(-55 + Double(phase) * 10))
                    .offset(x: -size * 0.04, y: -size * 0.04)
                Capsule()
                    .fill(Color(red: 0.12, green: 0.42, blue: 0.24))
                    .frame(width: size * 0.02, height: size * 0.12)
                    .rotationEffect(.degrees(15 + Double(phase) * 10))
                    .offset(x: size * 0.04, y: size * 0.02)
            }
        }
        .frame(width: size, height: size)
    }
}

private struct CupcakeArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            CupWrapper()
                .fill(DesignSystem.Colors.lessonCream)
                .frame(width: size * 0.46, height: size * 0.32)
                .offset(y: size * 0.12)
            CupWrapper()
                .stroke(Color(red: 0.86, green: 0.62, blue: 0.34), lineWidth: max(1.5, size * 0.015))
                .frame(width: size * 0.46, height: size * 0.32)
                .offset(y: size * 0.12)
            ForEach(0..<3, id: \.self) { pleat in
                Capsule()
                    .fill(Color(red: 0.93, green: 0.78, blue: 0.5).opacity(0.9))
                    .frame(width: max(1.5, size * 0.015), height: size * 0.22)
                    .offset(x: CGFloat(pleat - 1) * size * 0.08, y: size * 0.14)
            }
            Ellipse()
                .fill(DesignSystem.Colors.lessonCoral)
                .frame(width: size * 0.5, height: size * 0.28)
                .offset(y: -size * 0.02)
            Ellipse()
                .fill(Color(red: 0.96, green: 0.45, blue: 0.58))
                .frame(width: size * 0.28, height: size * 0.16)
                .offset(x: -size * 0.06, y: -size * 0.06)
            Circle()
                .fill(DesignSystem.Colors.lessonCoral)
                .frame(width: size * 0.16)
                .offset(y: -size * 0.14)
            Circle()
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: size * 0.08)
                .offset(y: -size * 0.2)
        }
        .frame(width: size, height: size)
    }
}

private struct CoinArt: View {
    var size: CGFloat
    var spin: TimeInterval
    var body: some View {
        Circle()
            .fill(DesignSystem.Colors.lessonYellow)
            .overlay { Circle().stroke(DesignSystem.Colors.lessonPad, lineWidth: 2) }
            .overlay {
                Text("¢")
                    .font(DesignSystem.Typography.headline(size * 0.28))
                    .foregroundStyle(DesignSystem.Colors.lessonPad)
            }
            .frame(width: size * 0.46, height: size * 0.46)
            .scaleEffect(x: 0.35 + 0.65 * abs(cos(spin * 2)), y: 1)
            .frame(width: size, height: size)
    }
}

private struct BallArt: View {
    enum Mark { case soccer, basketball, tennis, yarn }
    var mark: Mark
    var size: CGFloat
    var spin: TimeInterval

    var body: some View {
        ZStack {
            switch mark {
            case .soccer:
                soccerBall
            case .basketball:
                basketball
            case .tennis:
                Circle().fill(Color(red: 0.78, green: 0.9, blue: 0.22)).frame(width: size * 0.52)
                Capsule().stroke(DesignSystem.Colors.cardWhite, lineWidth: max(2, size * 0.03))
                    .frame(width: size * 0.16, height: size * 0.4)
                    .rotationEffect(.degrees(24))
                    .offset(x: -size * 0.05)
                Capsule().stroke(DesignSystem.Colors.cardWhite, lineWidth: max(2, size * 0.03))
                    .frame(width: size * 0.16, height: size * 0.4)
                    .rotationEffect(.degrees(-24))
                    .offset(x: size * 0.05)
            case .yarn:
                yarnBall
            }
        }
        .rotationEffect(.degrees(spin * 40))
        .frame(width: size, height: size)
    }

    private var yarnBall: some View {
        ZStack {
            Circle().fill(DesignSystem.Colors.lavenderPurple)
            ForEach(0..<16, id: \.self) { ring in
                Circle()
                    .stroke(Color(red: 0.94, green: 0.91, blue: 1), lineWidth: max(1.4, size * 0.015))
                    .frame(width: size * (0.1 + CGFloat(ring % 6) * 0.065))
                    .offset(
                        x: CGFloat((ring % 5) - 2) * size * 0.032,
                        y: CGFloat((ring % 4) - 1) * size * 0.038
                    )
            }
        }
        .frame(width: size * 0.52, height: size * 0.52)
        .clipShape(Circle())
    }

    private var basketball: some View {
        let line = max(1.5, size * 0.02)
        return ZStack {
            Circle().fill(DesignSystem.Colors.lessonOrange)
            Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: line, height: size * 0.46)
            Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.44, height: line)
            Ellipse()
                .stroke(DesignSystem.Colors.deepNavy, lineWidth: line)
                .frame(width: size * 0.14, height: size * 0.4)
                .offset(x: -size * 0.05)
            Ellipse()
                .stroke(DesignSystem.Colors.deepNavy, lineWidth: line)
                .frame(width: size * 0.14, height: size * 0.4)
                .offset(x: size * 0.05)
        }
        .frame(width: size * 0.52, height: size * 0.52)
        .clipShape(Circle())
        .overlay {
            Circle().stroke(DesignSystem.Colors.deepNavy, lineWidth: line)
        }
    }

    private var soccerBall: some View {
        ZStack {
            Circle().fill(DesignSystem.Colors.cardWhite)
            Pentagon().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.13, height: size * 0.13)
            ForEach(0..<5, id: \.self) { patch in
                Pentagon()
                    .fill(DesignSystem.Colors.deepNavy)
                    .frame(width: size * 0.1, height: size * 0.1)
                    .rotationEffect(.degrees(Double(patch) * 72))
                    .offset(y: -size * 0.2)
                    .rotationEffect(.degrees(Double(patch) * 72 + 36))
            }
        }
        .frame(width: size * 0.52, height: size * 0.52)
        .clipShape(Circle())
        .overlay {
            Circle().stroke(DesignSystem.Colors.deepNavy, lineWidth: max(1.5, size * 0.02))
        }
    }
}

private struct CupWrapper: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct Pentagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        for index in 0..<5 {
            let angle = (Double(index) * 72 - 90) * Double.pi / 180
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}

private struct BatteryArt: View {
    var size: CGFloat
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(DesignSystem.Colors.freshGreen)
                .frame(width: size * 0.28, height: size * 0.46)
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.12, height: size * 0.06)
                .offset(y: -size * 0.02)
        }
        .frame(width: size, height: size)
    }
}

private struct BrushArt: View {
    var size: CGFloat
    var phase: CGFloat
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color(red: 0.55, green: 0.32, blue: 0.16))
                .frame(width: size * 0.08, height: size * 0.36)
                .offset(y: size * 0.16)
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color(red: 0.77, green: 0.65, blue: 0.45))
                .frame(width: size * 0.18, height: size * 0.08)
                .offset(y: -size * 0.02)
            HStack(spacing: size * 0.004) {
                ForEach(0..<8, id: \.self) { bristle in
                    Capsule()
                        .fill(Color(red: 0.9, green: 0.83, blue: 0.69))
                        .frame(width: size * 0.012, height: size * (bristle % 2 == 0 ? 0.15 : 0.12))
                        .offset(y: phase * size * 0.004 * CGFloat(bristle - 4))
                }
            }
            .offset(y: -size * 0.12)
        }
        .frame(width: size, height: size)
    }
}

private struct DrumArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            Capsule().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.46, height: size * 0.36)
            Ellipse().fill(DesignSystem.Colors.lessonCream).frame(width: size * 0.46, height: size * 0.16).offset(y: -size * 0.08)
            Capsule().fill(Color(red: 0.55, green: 0.32, blue: 0.16)).frame(width: size * 0.28, height: size * 0.04).rotationEffect(.degrees(-40)).offset(x: size * 0.12, y: -size * 0.16)
        }
        .frame(width: size, height: size)
    }
}

private struct SpoonArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            Capsule().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.08, height: size * 0.4).offset(y: size * 0.08)
            Ellipse().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.2, height: size * 0.26).offset(y: -size * 0.16)
        }
        .frame(width: size, height: size)
    }
}

private struct CupArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: size * 0.32, height: size * 0.36)
            Capsule().stroke(DesignSystem.Colors.lessonWindow, lineWidth: 3).frame(width: size * 0.12, height: size * 0.16).offset(x: size * 0.2)
            Rectangle().fill(DesignSystem.Colors.lessonCream).frame(width: size * 0.24, height: size * 0.12).offset(y: size * 0.04)
        }
        .frame(width: size, height: size)
    }
}

private struct JarArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(DesignSystem.Colors.skyBlue, lineWidth: 3)
                .frame(width: size * 0.36, height: size * 0.42)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(DesignSystem.Colors.lessonOrange.opacity(0.75))
                .frame(width: size * 0.28, height: size * 0.16)
                .offset(y: size * 0.08)
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.22, height: size * 0.06)
                .offset(y: -size * 0.22)
        }
        .frame(width: size, height: size)
    }
}

private struct BagArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(DesignSystem.Colors.lessonOrange)
                .frame(width: size * 0.42, height: size * 0.36)
                .offset(y: size * 0.06)
            Capsule().stroke(DesignSystem.Colors.lessonPad, lineWidth: 3).frame(width: size * 0.2, height: size * 0.14).offset(y: -size * 0.14)
        }
        .frame(width: size, height: size)
    }
}

private struct CrateArt: View {
    var openLid: Bool
    var size: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(red: 0.72, green: 0.48, blue: 0.24))
                .frame(width: size * 0.46, height: size * 0.36)
            if openLid {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(Color(red: 0.55, green: 0.34, blue: 0.16))
                    .frame(width: size * 0.46, height: size * 0.08)
                    .rotationEffect(.degrees(-28))
                    .offset(y: -size * 0.22)
            }
        }
        .frame(width: size, height: size)
    }
}

private struct BasketArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            DownFlame()
                .fill(Color(red: 0.72, green: 0.48, blue: 0.24))
                .frame(width: size * 0.5, height: size * 0.32)
                .rotationEffect(.degrees(180))
                .offset(y: size * 0.06)
            Capsule().stroke(Color(red: 0.55, green: 0.34, blue: 0.16), lineWidth: 3)
                .frame(width: size * 0.28, height: size * 0.16)
                .offset(y: -size * 0.12)
        }
        .frame(width: size, height: size)
    }
}

private struct BowlArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            Ellipse().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.5, height: size * 0.28).offset(y: size * 0.04)
            Ellipse().fill(DesignSystem.Colors.lessonCream).frame(width: size * 0.36, height: size * 0.12).offset(y: -size * 0.02)
        }
        .frame(width: size, height: size)
    }
}

private struct UmbrellaArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            DownFlame().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.56, height: size * 0.32).offset(y: -size * 0.06)
            Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.04, height: size * 0.4).offset(y: size * 0.1)
        }
        .frame(width: size, height: size)
    }
}

private struct SuitcaseArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous).fill(DesignSystem.Colors.skyBlue).frame(width: size * 0.46, height: size * 0.36)
            Capsule().stroke(DesignSystem.Colors.deepNavy, lineWidth: 3).frame(width: size * 0.16, height: size * 0.1).offset(y: -size * 0.2)
            HStack(spacing: size * 0.18) {
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.1)
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.1)
            }
            .offset(y: size * 0.22)
        }
        .frame(width: size, height: size)
    }
}

private struct TicketArt: View {
    var size: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(DesignSystem.Colors.lessonYellow)
            .frame(width: size * 0.52, height: size * 0.28)
            .overlay {
                Rectangle().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.06)
            }
            .frame(width: size, height: size)
    }
}

private struct TrainArt: View {
    var car: Bool
    var spin: TimeInterval
    var size: CGFloat
    var body: some View {
        ZStack {
            if !car {
                Circle().fill(DesignSystem.Colors.lessonWindow.opacity(0.7)).frame(width: size * 0.1)
                    .offset(x: size * 0.02, y: -size * (0.28 + CGFloat(abs(sin(spin * 3))) * 0.08))
            }
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(car ? DesignSystem.Colors.lessonOrange : DesignSystem.Colors.lessonCoral)
                .frame(width: size * 0.56, height: size * 0.28)
            if !car {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(DesignSystem.Colors.deepNavy)
                    .frame(width: size * 0.16, height: size * 0.16)
                    .offset(x: size * 0.16, y: -size * 0.12)
            }
            HStack(spacing: size * 0.18) {
                wheel(spin)
                wheel(spin)
            }
            .offset(y: size * 0.16)
        }
        .frame(width: size, height: size)
    }

    private func wheel(_ spin: TimeInterval) -> some View {
        Circle()
            .stroke(DesignSystem.Colors.deepNavy, lineWidth: max(2, size * 0.03))
            .frame(width: size * 0.14, height: size * 0.14)
            .overlay {
                Capsule().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.08, height: 2)
                    .rotationEffect(.degrees(spin * 200))
            }
    }
}

private struct CarArt: View {
    var size: CGFloat
    var spin: TimeInterval
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: size * 0.62, height: size * 0.22)
                .offset(y: size * 0.04)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: size * 0.32, height: size * 0.16)
                .offset(y: -size * 0.1)
            HStack(spacing: size * 0.24) {
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.14)
                    .rotationEffect(.degrees(spin * 200))
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.14)
            }
            .offset(y: size * 0.16)
        }
        .frame(width: size, height: size)
    }
}

private struct Airfoil: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.55))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.28))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.32, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct PlaneArt: View {
    var phase: CGFloat
    var size: CGFloat
    var body: some View {
        ZStack {
            Wedge()
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: size * 0.12, height: size * 0.16)
                .offset(x: -size * 0.26, y: -size * 0.1)
            Capsule()
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: size * 0.18, height: size * 0.045)
                .offset(x: -size * 0.28)
            Capsule().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.62, height: size * 0.14)
            Airfoil()
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: size * 0.32, height: size * 0.18)
                .rotationEffect(.degrees(Double(phase) * 8), anchor: .bottomTrailing)
                .offset(x: size * 0.02, y: -size * 0.05)
            HStack(spacing: size * 0.04) {
                ForEach(0..<4, id: \.self) { _ in
                    Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.028)
                }
            }
            .offset(x: size * 0.04)
        }
        .rotationEffect(.degrees(Double(phase) * 6))
        .frame(width: size, height: size)
    }
}

private struct TractorArt: View {
    var spin: TimeInterval
    var size: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(DesignSystem.Colors.freshGreen)
                .frame(width: size * 0.4, height: size * 0.24)
                .offset(x: -size * 0.04, y: size * 0.02)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: size * 0.16, height: size * 0.16)
                .offset(x: size * 0.12, y: -size * 0.12)
            Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.22).offset(x: -size * 0.14, y: size * 0.14)
                .rotationEffect(.degrees(spin * 160))
            Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.14).offset(x: size * 0.16, y: size * 0.16)
        }
        .frame(width: size, height: size)
    }
}

private struct BarnArt: View {
    var size: CGFloat
    private var red: Color { Color(red: 0.77, green: 0.18, blue: 0.16) }
    private var roof: Color { Color(red: 0.56, green: 0.12, blue: 0.11) }

    var body: some View {
        ZStack {
            BarnRoof()
                .fill(roof)
                .frame(width: size * 0.78, height: size * 0.28)
                .offset(y: -size * 0.22)
            Rectangle()
                .fill(red)
                .frame(width: size * 0.62, height: size * 0.4)
                .offset(y: size * 0.08)
            Rectangle()
                .fill(DesignSystem.Colors.lessonCream)
                .frame(width: size * 0.62, height: size * 0.035)
                .offset(y: -size * 0.11)
            Circle()
                .fill(DesignSystem.Colors.lessonCream)
                .frame(width: size * 0.12)
                .offset(y: -size * 0.01)
            HStack(spacing: size * 0.025) {
                barnDoor
                barnDoor
            }
            .offset(y: size * 0.16)
        }
        .frame(width: size, height: size)
    }

    private var barnDoor: some View {
        RoundedRectangle(cornerRadius: 1, style: .continuous)
            .fill(DesignSystem.Colors.cardWhite)
            .frame(width: size * 0.13, height: size * 0.2)
            .overlay {
                BarnDoorCross()
                    .stroke(red, lineWidth: max(1.5, size * 0.012))
                    .padding(size * 0.012)
            }
    }
}

private struct BarnRoof: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.16, y: rect.minY + rect.height * 0.38))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.34, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.34, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.16, y: rect.minY + rect.height * 0.38))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct BarnDoorCross: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }
}

private struct SunArt: View {
    var phase: CGFloat
    var spin: TimeInterval
    var size: CGFloat

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { ray in
                Capsule()
                    .fill(DesignSystem.Colors.lessonYellow)
                    .frame(width: size * 0.07, height: size * (0.16 + abs(phase) * 0.04))
                    .offset(y: -size * 0.32)
                    .rotationEffect(.degrees(Double(ray) * 45))
            }
            .rotationEffect(.degrees(spin * 18))
            Circle()
                .fill(DesignSystem.Colors.lessonYellow)
                .frame(width: size * 0.42)
                .scaleEffect(1 + abs(phase) * 0.06)
        }
        .frame(width: size, height: size)
    }
}

private struct OctopusArt: View {
    var phase: CGFloat
    var size: CGFloat
    private var sand: Color { Color(red: 0.76, green: 0.62, blue: 0.42) }
    private var bump: Color { Color(red: 0.45, green: 0.32, blue: 0.2) }

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { arm in
                tentacle(arm)
            }
            Ellipse()
                .fill(sand)
                .frame(width: size * 0.42, height: size * 0.34)
                .offset(y: -size * 0.08)
            HStack(spacing: size * 0.09) {
                BeadEye(size: size * 0.07)
                BeadEye(size: size * 0.07)
            }
            .offset(y: -size * 0.1)
        }
        .frame(width: size, height: size)
    }

    private func tentacle(_ arm: Int) -> some View {
        let spread = Double(arm - 3) * 18 - 9
        let sway = Double(phase) * (arm % 2 == 0 ? 7 : -5)
        return ZStack {
            Capsule()
                .fill(arm == 6 ? bump : sand)
                .frame(width: size * 0.055, height: size * 0.34)
            if arm == 6 {
                VStack(spacing: size * 0.045) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle().fill(Color(red: 0.32, green: 0.22, blue: 0.14)).frame(width: size * 0.028)
                    }
                }
                .offset(y: size * 0.06)
            }
        }
        .offset(y: size * 0.17)
        .rotationEffect(.degrees(spread + sway))
        .offset(y: size * 0.08)
    }
}

private struct GiraffeArt: View {
    var size: CGFloat
    private var tan: Color { Color(red: 0.86, green: 0.7, blue: 0.42) }
    private var patch: Color { Color(red: 0.45, green: 0.28, blue: 0.14) }

    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { leg in
                Capsule()
                    .fill(tan)
                    .frame(width: size * 0.04, height: size * 0.26)
                    .offset(x: size * (CGFloat(leg) * 0.07 - 0.12), y: size * 0.22)
            }
            Ellipse().fill(tan).frame(width: size * 0.4, height: size * 0.2).offset(x: -size * 0.04, y: size * 0.14)
            Capsule()
                .fill(tan)
                .frame(width: size * 0.02, height: size * 0.22)
                .rotationEffect(.degrees(28), anchor: .top)
                .offset(x: -size * 0.22, y: size * 0.22)
            Circle().fill(patch).frame(width: size * 0.05).offset(x: -size * 0.28, y: size * 0.32)
            Capsule().fill(tan).frame(width: size * 0.09, height: size * 0.34).offset(x: size * 0.1, y: -size * 0.04)
            Circle().fill(tan).frame(width: size * 0.2).offset(x: size * 0.14, y: -size * 0.24)
            ossicone.offset(x: size * 0.09, y: -size * 0.32)
            ossicone.offset(x: size * 0.17, y: -size * 0.33)
            spot(0.055).offset(x: -size * 0.12, y: size * 0.12)
            spot(0.04).offset(x: -size * 0.02, y: size * 0.18)
            spot(0.045).offset(x: size * 0.06, y: size * 0.1)
            spot(0.035).offset(x: size * 0.08, y: size * 0.04)
            spot(0.04).offset(x: size * 0.1, y: -size * 0.08)
            spot(0.03).offset(x: size * 0.12, y: -size * 0.18)
            BeadEye(size: size * 0.045).offset(x: size * 0.18, y: -size * 0.24)
            Capsule()
                .fill(Color(red: 0.22, green: 0.62, blue: 0.32))
                .frame(width: size * 0.14, height: size * 0.06)
                .rotationEffect(.degrees(-28))
                .offset(x: size * 0.26, y: -size * 0.3)
        }
        .frame(width: size, height: size)
    }

    private func spot(_ scale: CGFloat) -> some View {
        Circle().fill(patch).frame(width: size * scale)
    }

    private var ossicone: some View {
        VStack(spacing: 0) {
            Circle().fill(patch).frame(width: size * 0.035)
            Capsule().fill(tan).frame(width: size * 0.02, height: size * 0.05)
        }
    }
}

private struct ElephantArt: View {
    var phase: CGFloat
    var size: CGFloat
    private var gray: Color { Color(red: 0.55, green: 0.58, blue: 0.62) }

    var body: some View {
        ZStack {
            pillarFoot(at: -0.14)
            pillarFoot(at: -0.05)
            pillarFoot(at: 0.04)
            pillarFoot(at: 0.12)
            Ellipse().fill(gray).frame(width: size * 0.42, height: size * 0.24).offset(x: -size * 0.02, y: size * 0.06)
            Capsule()
                .fill(gray)
                .frame(width: size * 0.025, height: size * 0.2)
                .rotationEffect(.degrees(-16 + Double(phase) * 8), anchor: .top)
                .offset(x: -size * 0.2, y: size * 0.14)
            Circle().fill(gray).frame(width: size * 0.24).offset(x: size * 0.2, y: -size * 0.08)
            CurvedTrunk()
                .fill(gray)
                .frame(width: size * 0.16, height: size * 0.2)
                .offset(x: size * 0.3, y: size * 0.04 + phase)
            Ellipse().fill(gray).frame(width: size * 0.14, height: size * 0.18).offset(x: size * 0.1, y: -size * 0.16)
            BeadEye(size: size * 0.045).offset(x: size * 0.26, y: -size * 0.1)
        }
        .frame(width: size, height: size)
    }

    private func pillarFoot(at x: CGFloat) -> some View {
        ZStack {
            Capsule().fill(gray).frame(width: size * 0.045, height: size * 0.24)
            Ellipse().fill(gray).frame(width: size * 0.062, height: size * 0.03).offset(y: size * 0.11)
        }
        .offset(x: size * x, y: size * 0.16)
    }
}

/// Trunk that leaves the face and curls forward, stopping short of the feet.
private struct CurvedTrunk: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: rect.minX + width * 0.2, y: rect.minY))
        path.addCurve(
            to: CGPoint(x: rect.minX + width * 0.42, y: rect.maxY),
            control1: CGPoint(x: rect.maxX, y: rect.minY + height * 0.25),
            control2: CGPoint(x: rect.maxX * 0.92, y: rect.minY + height * 0.72)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX + width * 0.62, y: rect.minY),
            control1: CGPoint(x: rect.midX, y: rect.maxY - height * 0.02),
            control2: CGPoint(x: rect.midX + width * 0.1, y: rect.minY + height * 0.2)
        )
        path.closeSubpath()
        return path
    }
}

private struct TriceratopsArt: View {
    var phase: CGFloat
    var size: CGFloat
    private var olive: Color { Color(red: 0.42, green: 0.52, blue: 0.26) }
    private var horn: Color { DesignSystem.Colors.lessonCream }

    var body: some View {
        ZStack {
            Capsule()
                .fill(olive)
                .frame(width: size * 0.26, height: size * 0.07)
                .rotationEffect(.degrees(-16 + Double(phase) * 5), anchor: .trailing)
                .offset(x: -size * 0.22, y: size * 0.08)
            ForEach(0..<4, id: \.self) { leg in
                Capsule()
                    .fill(olive)
                    .frame(width: size * 0.04, height: size * 0.18)
                    .offset(x: size * (CGFloat(leg) * 0.07 - 0.12), y: size * 0.16)
            }
            Ellipse().fill(olive).frame(width: size * 0.42, height: size * 0.22).offset(x: -size * 0.02, y: size * 0.1)
            Ellipse().fill(olive).frame(width: size * 0.22, height: size * 0.26).offset(x: size * 0.2, y: size * 0.02)
            Ellipse().fill(olive).frame(width: size * 0.16, height: size * 0.14).offset(x: size * 0.28, y: size * 0.06)
            hornTip(width: 0.028, height: 0.09).offset(x: size * 0.34, y: -size * 0.02)
            hornTip(width: 0.03, height: 0.11).offset(x: size * 0.16, y: -size * 0.1)
            hornTip(width: 0.03, height: 0.11).offset(x: size * 0.24, y: -size * 0.12)
            BeadEye(size: size * 0.04).offset(x: size * 0.26, y: size * 0.02)
        }
        .frame(width: size, height: size)
    }

    private func hornTip(width: CGFloat, height: CGFloat) -> some View {
        Capsule()
            .fill(horn)
            .frame(width: size * width, height: size * height)
    }
}

private struct TyrannosaurusArt: View {
    var phase: CGFloat
    var size: CGFloat
    private var brown: Color { Color(red: 0.55, green: 0.32, blue: 0.18) }
    private var tooth: Color { DesignSystem.Colors.lessonCream }

    var body: some View {
        ZStack {
            BalanceTail()
                .fill(brown)
                .frame(width: size * 0.46, height: size * 0.16)
                .rotationEffect(.degrees(4 + Double(phase) * 6), anchor: .trailing)
                .offset(x: -size * 0.22, y: size * 0.04)
            hindLeg(x: -0.04, y: 0.2)
            hindLeg(x: 0.08, y: 0.18)
            Ellipse()
                .fill(brown)
                .frame(width: size * 0.24, height: size * 0.34)
                .rotationEffect(.degrees(-16))
                .offset(x: size * 0.02, y: -size * 0.02)
            Capsule()
                .fill(brown)
                .frame(width: size * 0.12, height: size * 0.16)
                .rotationEffect(.degrees(-42))
                .offset(x: size * 0.1, y: -size * 0.12)
            Ellipse()
                .fill(brown)
                .frame(width: size * 0.26, height: size * 0.12)
                .rotationEffect(.degrees(-12))
                .offset(x: size * 0.18, y: -size * 0.24)
            Ellipse()
                .fill(Color(red: 0.24, green: 0.14, blue: 0.09))
                .frame(width: size * 0.12, height: size * 0.045)
                .rotationEffect(.degrees(4))
                .offset(x: size * 0.22, y: -size * 0.18)
            Ellipse()
                .fill(brown)
                .frame(width: size * 0.1, height: size * 0.036)
                .rotationEffect(.degrees(20))
                .offset(x: size * 0.22, y: -size * 0.12)
            JawTeeth()
                .fill(tooth)
                .frame(width: size * 0.14, height: size * 0.028)
                .rotationEffect(.degrees(-8))
                .offset(x: size * 0.26, y: -size * 0.22)
            BeadEye(size: size * 0.04).offset(x: size * 0.14, y: -size * 0.26)
            rexArm(x: 0.02, y: -0.08, reach: 0.16)
            rexArm(x: 0.05, y: -0.02, reach: 0.13)
        }
        .frame(width: size, height: size)
    }

    private func hindLeg(x: CGFloat, y: CGFloat) -> some View {
        ZStack {
            Capsule().fill(brown).frame(width: size * 0.07, height: size * 0.26)
            Ellipse().fill(brown).frame(width: size * 0.11, height: size * 0.04).offset(y: size * 0.12)
        }
        .offset(x: size * x, y: size * y)
    }

    private func rexArm(x: CGFloat, y: CGFloat, reach: CGFloat) -> some View {
        ZStack {
            Capsule()
                .fill(brown)
                .frame(width: size * 0.08, height: size * 0.045)
            Capsule()
                .fill(brown)
                .frame(width: size * reach, height: size * 0.034)
                .rotationEffect(.degrees(32), anchor: .leading)
                .offset(x: size * 0.05)
            Capsule()
                .fill(tooth)
                .frame(width: size * 0.045, height: size * 0.014)
                .rotationEffect(.degrees(48))
                .offset(x: size * (reach * 0.72), y: size * 0.045)
            Capsule()
                .fill(tooth)
                .frame(width: size * 0.04, height: size * 0.014)
                .rotationEffect(.degrees(68))
                .offset(x: size * (reach * 0.66), y: size * 0.062)
        }
        .offset(x: size * x, y: size * y)
    }
}

/// Long balance tail: thick where it meets the hip, narrow at the tip.
private struct BalanceTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height = rect.height
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY + height * 0.12))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control: CGPoint(x: rect.midX, y: rect.minY + height * 0.02)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY - height * 0.08),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        path.closeSubpath()
        return path
    }
}

private struct JawTeeth: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let count = 6
        let tooth = rect.width / CGFloat(count)
        for index in 0..<count {
            let x = rect.minX + CGFloat(index) * tooth
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x + tooth * 0.5, y: rect.maxY))
            path.addLine(to: CGPoint(x: x + tooth, y: rect.minY))
            path.closeSubpath()
        }
        return path
    }
}

private struct EarthArt: View {
    var spin: TimeInterval
    var size: CGFloat
    private var ocean: Color { Color(red: 0.16, green: 0.45, blue: 0.78) }
    private var land: Color { Color(red: 0.22, green: 0.58, blue: 0.32) }

    var body: some View {
        ZStack {
            Circle().fill(ocean)
            Ellipse().fill(land).frame(width: size * 0.1, height: size * 0.28).offset(x: -size * 0.08, y: size * 0.02)
            Ellipse().fill(land).frame(width: size * 0.05, height: size * 0.16).offset(x: -size * 0.02, y: size * 0.08)
            Ellipse().fill(land).frame(width: size * 0.09, height: size * 0.2).offset(x: size * 0.08, y: -size * 0.02)
            Ellipse().fill(land).frame(width: size * 0.06, height: size * 0.05).offset(x: -size * 0.01, y: -size * 0.16)
            Capsule()
                .fill(DesignSystem.Colors.cardWhite.opacity(0.88))
                .frame(width: size * 0.16, height: size * 0.05)
                .offset(x: size * 0.04, y: -size * 0.08)
            Capsule()
                .fill(DesignSystem.Colors.cardWhite.opacity(0.75))
                .frame(width: size * 0.1, height: size * 0.035)
                .offset(x: -size * 0.06, y: size * 0.1)
        }
        .frame(width: size * 0.62, height: size * 0.62)
        .clipShape(Circle())
        .rotationEffect(.degrees(spin * 12))
        .frame(width: size, height: size)
    }
}

private struct VenusArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.96, green: 0.86, blue: 0.55).opacity(0.45))
                .frame(width: size * (0.7 + abs(phase) * 0.04))
            ZStack {
                Circle().fill(Color(red: 0.94, green: 0.83, blue: 0.54))
                cloudBand(width: 0.42, height: 0.16, cream: true, angle: -24)
                    .offset(x: -size * 0.08, y: -size * 0.06)
                cloudBand(width: 0.34, height: 0.13, cream: false, angle: 18)
                    .offset(x: size * 0.08, y: -size * 0.04)
                cloudBand(width: 0.48, height: 0.1, cream: true, angle: -8)
                    .offset(y: size * 0.04)
                cloudBand(width: 0.3, height: 0.1, cream: false, angle: 14)
                    .offset(x: size * 0.06, y: size * 0.09)
            }
            .frame(width: size * 0.5, height: size * 0.5)
            .clipShape(Circle())
        }
        .frame(width: size, height: size)
    }

    private func cloudBand(width: CGFloat, height: CGFloat, cream: Bool, angle: Double) -> some View {
        Capsule()
            .fill(cream ? Color(red: 1, green: 0.97, blue: 0.9) : Color(red: 0.89, green: 0.72, blue: 0.38))
            .frame(width: size * width, height: size * height)
            .rotationEffect(.degrees(angle))
    }
}

private struct SpacecraftArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        let wing = Color(red: 0.84, green: 0.89, blue: 0.95)
        let metal = Color(red: 0.55, green: 0.58, blue: 0.63)
        let _ = phase
        ZStack {
            SideWing().fill(wing).frame(width: size * 0.34, height: size * 0.22).offset(x: -size * 0.02, y: -size * 0.16)
            SideWing().fill(wing).frame(width: size * 0.34, height: size * 0.22)
                .rotationEffect(.degrees(180))
                .offset(x: -size * 0.02, y: size * 0.16)
            TailFin().fill(metal).frame(width: size * 0.22, height: size * 0.16).offset(x: size * 0.16, y: -size * 0.1)
            TailFin().fill(metal).frame(width: size * 0.22, height: size * 0.16)
                .scaleEffect(x: 1, y: -1)
                .offset(x: size * 0.16, y: size * 0.1)
            TailSpine().fill(Color(red: 0.44, green: 0.47, blue: 0.51))
                .frame(width: size * 0.22, height: size * 0.08)
                .offset(x: size * 0.2)
            Capsule().fill(DesignSystem.Colors.cardWhite).frame(width: size * 0.46, height: size * 0.16)
            NoseCone()
                .fill(metal)
                .frame(width: size * 0.24, height: size * 0.16)
                .offset(x: -size * 0.26)
            Circle().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.1).offset(x: -size * 0.06)
        }
        .frame(width: size, height: size)
    }
}

/// Horizontal tail fin. The root is the bottom edge and the tip sweeps up toward the rear.
private struct TailFin: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.55, y: rect.maxY * 0.72))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.62, y: rect.minY + rect.height * 0.22))
        path.closeSubpath()
        return path
    }
}

/// Vertical fin seen from above. The root is on the left, under the body.
private struct TailSpine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.28))
        path.addLine(to: CGPoint(x: rect.maxX * 0.78, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX * 0.78, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.midY)
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height * 0.28))
        path.closeSubpath()
        return path
    }
}

/// Rounded nose. The tip is on the left and the base meets the body on the right.
private struct NoseCone: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.maxY)
        )
        path.closeSubpath()
        return path
    }
}

/// Swept wing. The straight root is the bottom edge, so a half turn makes the matching wing.
private struct SideWing: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX * 0.78, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.32, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.48, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

private struct MagmaArt: View {
    var size: CGFloat

    var body: some View {
        let rock = Color(red: 0.36, green: 0.25, blue: 0.19)
        let orange = Color(red: 1, green: 0.46, blue: 0.06)
        let hot = Color(red: 1, green: 0.76, blue: 0.29)
        ZStack {
            Ellipse().fill(rock).frame(width: size * 0.62, height: size * 0.3).offset(y: size * 0.06)
            Ellipse().fill(orange).frame(width: size * 0.4, height: size * 0.2).offset(y: size * 0.1)
            Ellipse().fill(hot).frame(width: size * 0.16, height: size * 0.08).offset(x: -size * 0.06, y: size * 0.08)
            Ellipse().fill(Color(red: 0.89, green: 0.27, blue: 0.07)).frame(width: size * 0.12, height: size * 0.06)
                .offset(x: size * 0.07, y: size * 0.12)
            Capsule().fill(Color(red: 0.42, green: 0.18, blue: 0.07))
                .frame(width: size * 0.28, height: size * 0.02)
                .rotationEffect(.degrees(-12))
                .offset(y: size * 0.08)
            Capsule().fill(hot)
                .frame(width: size * 0.18, height: size * 0.018)
                .rotationEffect(.degrees(16))
                .offset(y: size * 0.13)
            Capsule().fill(rock).frame(width: size * 0.5, height: size * 0.06).offset(y: -size * 0.04)
        }
        .frame(width: size, height: size)
    }
}

private struct WindVaneArt: View {
    var spin: TimeInterval
    var size: CGFloat

    var body: some View {
        ZStack {
            Capsule().fill(Color(red: 0.35, green: 0.38, blue: 0.44)).frame(width: size * 0.05, height: size * 0.46)
                .offset(y: size * 0.08)
            ZStack {
                Capsule().fill(Color(red: 0.82, green: 0.14, blue: 0.16)).frame(width: size * 0.42, height: size * 0.07)
                Wedge().fill(Color(red: 0.82, green: 0.14, blue: 0.16)).frame(width: size * 0.14, height: size * 0.12)
                    .rotationEffect(.degrees(90)).offset(x: size * 0.22)
            }
            .rotationEffect(.degrees(sin(spin) * 18))
            .offset(y: -size * 0.16)
        }
        .frame(width: size, height: size)
    }
}

private struct LighthouseArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        let glow = 0.28 + Double(phase + 1) * 0.34
        let red = Color(red: 0.82, green: 0.14, blue: 0.16)
        ZStack {
            Wedge()
                .fill(DesignSystem.Colors.lessonYellow.opacity(glow))
                .frame(width: size * 0.28, height: size * 0.46)
                .rotationEffect(.degrees(-90))
                .offset(x: -size * 0.2, y: -size * 0.22)
            Capsule().fill(DesignSystem.Colors.cardWhite).frame(width: size * 0.16, height: size * 0.48).offset(y: size * 0.08)
            Capsule().fill(red).frame(width: size * 0.16, height: size * 0.07).offset(y: size * 0.02)
            Capsule().fill(red).frame(width: size * 0.16, height: size * 0.07).offset(y: size * 0.16)
            Capsule().fill(red).frame(width: size * 0.2, height: size * 0.045).offset(y: -size * 0.16)
            RoundedRectangle(cornerRadius: 2).fill(DesignSystem.Colors.lessonCream)
                .frame(width: size * 0.1, height: size * 0.1)
                .offset(y: -size * 0.24)
            Wedge().fill(red).frame(width: size * 0.14, height: size * 0.08).offset(y: -size * 0.32)
            Circle()
                .fill(DesignSystem.Colors.lessonYellow.opacity(0.45 + Double(phase + 1) * 0.25))
                .frame(width: size * 0.08)
                .offset(y: -size * 0.22)
        }
        .frame(width: size, height: size)
    }
}

private struct TrafficLightArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.06, style: .continuous)
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.28, height: size * 0.62)
            Circle().fill(Color(red: 0.86, green: 0.12, blue: 0.16).opacity(0.55 + Double(abs(phase)) * 0.45))
                .frame(width: size * 0.14).offset(y: -size * 0.18)
            Circle().fill(DesignSystem.Colors.lessonYellow.opacity(0.25)).frame(width: size * 0.14)
            Circle().fill(Color(red: 0.2, green: 0.62, blue: 0.32).opacity(0.25)).frame(width: size * 0.14).offset(y: size * 0.18)
        }
        .frame(width: size, height: size)
    }
}

private struct HubcapArt: View {
    var spin: TimeInterval
    var size: CGFloat

    var body: some View {
        ZStack {
            Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.72)
            Circle().fill(Color(red: 0.75, green: 0.78, blue: 0.82)).frame(width: size * 0.42)
                .rotationEffect(.degrees(spin * 80))
            Circle().fill(DesignSystem.Colors.cardWhite.opacity(0.8)).frame(width: size * 0.12).offset(x: -size * 0.08, y: -size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

private struct HawkArt: View {
    var phase: CGFloat
    var size: CGFloat
    private var brown: Color { Color(red: 0.48, green: 0.3, blue: 0.16) }

    var body: some View {
        ZStack {
            Capsule()
                .fill(brown)
                .frame(width: size * 0.4, height: size * 0.07)
                .offset(x: -size * 0.2)
                .rotationEffect(.degrees(-24 - Double(phase) * 12))
            Capsule()
                .fill(brown)
                .frame(width: size * 0.4, height: size * 0.07)
                .offset(x: size * 0.2)
                .rotationEffect(.degrees(24 + Double(phase) * 12))
            Ellipse().fill(brown).frame(width: size * 0.3, height: size * 0.16)
            Ellipse().fill(DesignSystem.Colors.lessonCream).frame(width: size * 0.12, height: size * 0.07).offset(y: size * 0.02)
            Circle().fill(brown).frame(width: size * 0.12).offset(x: size * 0.14, y: -size * 0.02)
            Wedge()
                .fill(DesignSystem.Colors.lessonYellow)
                .frame(width: size * 0.045, height: size * 0.035)
                .rotationEffect(.degrees(90))
                .offset(x: size * 0.21, y: -size * 0.01)
            BeadEye(size: size * 0.04).offset(x: size * 0.15, y: -size * 0.04)
        }
        .frame(width: size, height: size)
    }
}

private struct CaterpillarArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        HStack(spacing: -size * 0.02) {
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(index % 2 == 0 ? DesignSystem.Colors.lessonYellow : DesignSystem.Colors.deepNavy)
                    .frame(width: size * 0.16, height: size * 0.16)
                    .offset(y: (index % 2 == 0 ? -1 : 1) * phase * 3)
            }
        }
        .frame(width: size, height: size)
    }
}

private struct CastleArt: View {
    var size: CGFloat
    private var stone: Color { Color(red: 0.55, green: 0.58, blue: 0.66) }

    var body: some View {
        ZStack {
            Rectangle().fill(stone).frame(width: size * 0.56, height: size * 0.3).offset(y: size * 0.1)
            HStack(spacing: size * 0.07) {
                ForEach(0..<4, id: \.self) { _ in
                    Rectangle().fill(stone).frame(width: size * 0.06, height: size * 0.07)
                }
            }
            .offset(y: -size * 0.08)
            HStack(spacing: size * 0.32) {
                tower
                tower
            }
            .offset(y: -size * 0.08)
            Capsule()
                .fill(Color(red: 0.36, green: 0.25, blue: 0.19))
                .frame(width: size * 0.09, height: size * 0.14)
                .offset(y: size * 0.16)
            HStack(spacing: size * 0.26) {
                Rectangle().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.045, height: size * 0.055)
                Rectangle().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.045, height: size * 0.055)
            }
            .offset(y: size * 0.06)
        }
        .frame(width: size, height: size)
    }

    private var tower: some View {
        ZStack {
            Rectangle().fill(stone).frame(width: size * 0.15, height: size * 0.2)
            HStack(spacing: size * 0.01) {
                ForEach(0..<3, id: \.self) { _ in
                    Rectangle().fill(stone).frame(width: size * 0.038, height: size * 0.05)
                }
            }
            .offset(y: -size * 0.12)
            Wedge()
                .fill(DesignSystem.Colors.lessonCoral)
                .frame(width: size * 0.09, height: size * 0.08)
                .offset(y: -size * 0.18)
        }
    }
}

private struct ShipArt: View {
    var phase: CGFloat
    var size: CGFloat
    var body: some View {
        ZStack {
            DownFlame()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.62, height: size * 0.24)
                .rotationEffect(.degrees(180))
                .offset(y: size * 0.12)
            Capsule().fill(DesignSystem.Colors.lessonCream).frame(width: size * 0.08, height: size * 0.36).offset(y: -size * 0.08)
            DownFlame().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.22, height: size * 0.2)
                .rotationEffect(.degrees(90))
                .offset(x: size * 0.1, y: -size * 0.12 + phase * 2)
        }
        .offset(y: phase * 3)
        .frame(width: size, height: size)
    }
}

private struct TorchArt: View {
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        let flicker = 1 + abs(phase) * 0.08
        ZStack {
            Capsule()
                .fill(Color(red: 0.45, green: 0.28, blue: 0.14))
                .frame(width: size * 0.1, height: size * 0.36)
                .offset(y: size * 0.16)
            Wedge()
                .fill(DesignSystem.Colors.lessonOrange)
                .frame(width: size * 0.28, height: size * 0.32)
                .scaleEffect(y: flicker, anchor: .bottom)
                .offset(y: -size * 0.16)
            Wedge()
                .fill(DesignSystem.Colors.lessonYellow)
                .frame(width: size * 0.14, height: size * 0.2)
                .scaleEffect(y: flicker, anchor: .bottom)
                .offset(y: -size * 0.12)
        }
        .frame(width: size, height: size)
    }
}

private struct PrincessHair: Shape {
    func path(in rect: CGRect) -> Path {
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(
                x: rect.minX + (x - 24) / 31 * rect.width,
                y: rect.minY + (y - 14) / 59 * rect.height
            )
        }
        var path = Path()
        path.move(to: p(27, 32))
        path.addCurve(to: p(39, 15), control1: p(25, 22), control2: p(30, 15))
        path.addCurve(to: p(51, 32), control1: p(48, 15), control2: p(53, 22))
        path.addLine(to: p(52, 62))
        path.addCurve(to: p(44, 67), control1: p(52, 70), control2: p(46, 73))
        path.addLine(to: p(43, 40))
        path.addCurve(to: p(39, 33), control1: p(42, 33), control2: p(40, 31))
        path.addCurve(to: p(35, 40), control1: p(38, 31), control2: p(36, 33))
        path.addLine(to: p(34, 67))
        path.addCurve(to: p(26, 62), control1: p(32, 73), control2: p(26, 70))
        path.closeSubpath()
        return path
    }
}

private struct PersonArt: View {
    enum Kind { case hero, princess, pirate }
    var kind: Kind
    var phase: CGFloat
    var size: CGFloat

    var body: some View {
        let cloth: Color = {
            switch kind {
            case .hero: return DesignSystem.Colors.skyBlue
            case .princess: return DesignSystem.Colors.lavenderPurple
            case .pirate: return DesignSystem.Colors.deepNavy
            }
        }()
        ZStack {
            if kind == .hero {
                Capsule().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.34, height: size * 0.16)
                    .rotationEffect(.degrees(-20 + Double(phase) * 12))
                    .offset(x: -size * 0.1, y: size * 0.02)
            }
            if kind == .princess {
                PrincessHair()
                    .fill(Color(red: 1, green: 0.90, blue: 0.42))
                    .frame(width: size * 31 / 80, height: size * 59 / 80)
                    .offset(x: -size * 0.5 / 80, y: size * 3.5 / 80)
            }
            Capsule().fill(cloth).frame(width: size * 0.22, height: size * 0.32).offset(y: size * 0.08)
            Circle().fill(Color(red: 0.96, green: 0.78, blue: 0.64)).frame(width: size * 0.22).offset(y: -size * 0.18)
            if kind == .princess {
                crown
            }
            if kind == .pirate {
                pirateHat
            }
            BeadEye(size: size * 0.06).offset(x: size * 0.04, y: -size * 0.18)
        }
        .frame(width: size, height: size)
    }

    private var crown: some View {
        ZStack {
            Capsule()
                .fill(DesignSystem.Colors.lessonYellow)
                .frame(width: size * 0.24, height: size * 0.045)
                .offset(y: -size * 0.28)
            HStack(spacing: size * 0.02) {
                DownFlame().fill(DesignSystem.Colors.lessonYellow).frame(width: size * 0.07, height: size * 0.1)
                DownFlame().fill(DesignSystem.Colors.lessonYellow).frame(width: size * 0.08, height: size * 0.14)
                DownFlame().fill(DesignSystem.Colors.lessonYellow).frame(width: size * 0.07, height: size * 0.1)
            }
            .offset(y: -size * 0.34)
            Circle().fill(DesignSystem.Colors.lessonCoral).frame(width: size * 0.035).offset(y: -size * 0.38)
        }
    }

    private var pirateHat: some View {
        ZStack {
            Tricorn()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.52, height: size * 0.22)
                .offset(y: -size * 0.34)
            Tricorn()
                .stroke(DesignSystem.Colors.cardWhite, lineWidth: max(1, size * 0.012))
                .frame(width: size * 0.52, height: size * 0.22)
                .offset(y: -size * 0.34)
            Circle()
                .fill(DesignSystem.Colors.cardWhite)
                .frame(width: size * 0.07)
                .offset(y: -size * 0.36)
            HStack(spacing: size * 0.014) {
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.012)
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.012)
            }
            .offset(y: -size * 0.365)
            Capsule()
                .stroke(DesignSystem.Colors.cardWhite, lineWidth: max(1, size * 0.012))
                .frame(width: size * 0.04, height: size * 0.012)
                .offset(y: -size * 0.34)
        }
    }
}

private struct Tricorn: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: 0, y: height * 0.85))
        path.addLine(to: CGPoint(x: width * 0.28, y: height * 0.12))
        path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.42))
        path.addLine(to: CGPoint(x: width * 0.72, y: height * 0.12))
        path.addLine(to: CGPoint(x: width, y: height * 0.85))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control: CGPoint(x: width * 0.75, y: height * 0.62)
        )
        path.addQuadCurve(
            to: CGPoint(x: 0, y: height * 0.85),
            control: CGPoint(x: width * 0.25, y: height * 0.62)
        )
        path.closeSubpath()
        return path
    }
}

private struct WrenchArt: View {
    var size: CGFloat
    var body: some View {
        ZStack {
            Capsule().fill(DesignSystem.Colors.lessonWindow).frame(width: size * 0.1, height: size * 0.42).rotationEffect(.degrees(40))
            Circle().stroke(DesignSystem.Colors.lessonWindow, lineWidth: 3).frame(width: size * 0.16).offset(x: size * 0.14, y: -size * 0.16)
        }
        .frame(width: size, height: size)
    }
}
