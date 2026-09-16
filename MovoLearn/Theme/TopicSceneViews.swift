import SwiftUI

// MARK: - Topic Scene Router

struct TopicSceneView: View {
    let topic: Topic
    var height: CGFloat = 140
    var clipsToRoundedRect: Bool = true

    var body: some View {
        Group {
            switch sceneKind {
            case .ocean: OceanSceneView()
            case .space: SpaceSceneView()
            case .dinosaur: DinosaurSceneView()
            case .horse: HorseSceneView()
            case .soccer: SoccerSceneView()
            case .basketball: BasketballSceneView()
            case .robot: RobotSceneView()
            case .castle: CastleSceneView()
            case .nature: NatureSceneView()
            case .vehicles: VehiclesSceneView()
            case .train: TrainSceneView()
            case .car: CarSceneView()
            case .city: CityHeroSceneView()
            case .studio: StudioSceneView()
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: clipsToRoundedRect ? DesignSystem.Radius.largeRadius : 0, style: .continuous))
    }

    private enum SceneKind {
        case ocean, space, dinosaur, horse, soccer, basketball, robot, castle, nature, vehicles, train, car, city, studio
    }

    private var sceneKind: SceneKind {
        switch topic {
        case .sharks, .oceanAnimals, .pirates: return .ocean
        case .space, .planets, .rockets: return .space
        case .dinosaurs, .volcanoes: return .dinosaur
        case .horses, .farmAnimals: return .horse
        case .soccer: return .soccer
        case .basketball: return .basketball
        case .robots: return .robot
        case .superheroes: return .city
        case .princesses, .castles, .fairies: return .castle
        case .nature, .bugs, .weather, .jungleAnimals, .zooAnimals, .dogs, .cats: return .nature
        case .airplanes: return .vehicles
        case .trains: return .train
        case .cars: return .car
        case .art, .music, .cooking: return .studio
        }
    }
}

// MARK: - Ocean

struct OceanSceneView: View {
    @State private var wavePhase = false
    @State private var bubbleRise = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    DesignSystem.Colors.skyBlue.opacity(0.55),
                    DesignSystem.Colors.oceanTurquoise.opacity(0.85),
                    Color(red: 0.05, green: 0.35, blue: 0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(.white.opacity(0.18))
                    .frame(width: CGFloat(4 + i % 4), height: CGFloat(4 + i % 4))
                    .offset(
                        x: CGFloat([-50, 30, -20, 55, -65, 10, 40, -35][i]),
                        y: bubbleRise ? CGFloat([-20, -55, -35, -70, -15, -45, -60, -25][i]) : 40
                    )
                    .animation(
                        .easeInOut(duration: 2.2 + Double(i) * 0.15).repeatForever(autoreverses: false).delay(Double(i) * 0.2),
                        value: bubbleRise
                    )
            }

            HStack(spacing: 18) {
                CoralShape()
                    .fill(DesignSystem.Colors.coralPink.opacity(0.75))
                    .frame(width: 28, height: 36)
                    .offset(y: 24)
                CoralShape()
                    .fill(DesignSystem.Colors.warmOrange.opacity(0.65))
                    .frame(width: 22, height: 30)
                    .offset(y: 30)
            }
            .offset(x: -70)

            FriendlySharkShape()
                .fill(DesignSystem.Colors.oceanTurquoise.opacity(0.9))
                .frame(width: 72, height: 44)
                .offset(x: 55, y: -8)
                .shadow(color: .black.opacity(0.12), radius: 6, y: 3)

            VStack {
                Spacer()
                WaveShape(phase: wavePhase ? 1 : 0)
                    .fill(.white.opacity(0.22))
                    .frame(height: 36)
                WaveShape(phase: wavePhase ? 0.6 : 0.3)
                    .fill(.white.opacity(0.14))
                    .frame(height: 28)
                    .offset(y: -8)
            }
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.float) { wavePhase = true }
            bubbleRise = true
        }
    }
}

// MARK: - Space

struct SpaceSceneView: View {
    @State private var twinkle = false
    @State private var rocketFloat = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.08, blue: 0.32),
                    Color(red: 0.18, green: 0.14, blue: 0.48),
                    Color(red: 0.08, green: 0.12, blue: 0.28)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            ForEach(0..<10, id: \.self) { i in
                Circle()
                    .fill(.white.opacity(twinkle ? 0.9 : 0.35))
                    .frame(width: CGFloat([2, 3, 2, 4, 2, 3, 2, 2, 3, 2][i]))
                    .offset(
                        x: CGFloat([-80, 60, -30, 75, -55, 20, -70, 45, -10, 85][i]),
                        y: CGFloat([-45, -30, 10, -50, 35, -15, 5, -40, 25, -5][i])
                    )
            }

            Circle()
                .fill(
                    LinearGradient(
                        colors: [DesignSystem.Colors.warmOrange, DesignSystem.Colors.coralPink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
                .offset(x: -55, y: 12)

            Circle()
                .stroke(DesignSystem.Colors.brightLavenderLight.opacity(0.5), lineWidth: 2.5)
                .frame(width: 58, height: 58)
                .offset(x: -55, y: 12)

            MoonCrescentShape()
                .fill(DesignSystem.Colors.sunshineYellowLight.opacity(0.85))
                .frame(width: 28, height: 28)
                .offset(x: 70, y: -35)

            RocketShape()
                .fill(.white.opacity(0.95))
                .frame(width: 26, height: 42)
                .offset(x: 50, y: rocketFloat ? -18 : -8)
                .shadow(color: DesignSystem.Colors.warmOrange.opacity(0.4), radius: 8, y: 4)
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.twinkle) { twinkle = true }
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                rocketFloat = true
            }
        }
    }
}

// MARK: - Dinosaur

struct DinosaurSceneView: View {
    @State private var leafSway = false
    @State private var smokePuff = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.45, green: 0.72, blue: 0.38),
                    Color(red: 0.28, green: 0.55, blue: 0.30),
                    Color(red: 0.18, green: 0.38, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VolcanoShape()
                .fill(Color(red: 0.45, green: 0.28, blue: 0.22))
                .frame(width: 90, height: 55)
                .offset(x: 70, y: 35)

            Circle()
                .fill(DesignSystem.Colors.warmOrange.opacity(smokePuff ? 0.35 : 0.15))
                .frame(width: smokePuff ? 36 : 20, height: smokePuff ? 28 : 16)
                .offset(x: 70, y: -5)
                .blur(radius: 4)

            ForEach(0..<4, id: \.self) { i in
                LeafShape()
                    .fill(DesignSystem.Colors.freshGreen.opacity(0.55))
                    .frame(width: 22, height: 14)
                    .rotationEffect(.degrees(Double(i) * 18 + (leafSway ? 6 : -6)))
                    .offset(
                        x: CGFloat([-75, -55, 75, -85][i]),
                        y: CGFloat([20, 35, 30, 8][i])
                    )
            }

            CuteDinoFaceShape()
                .fill(DesignSystem.Colors.freshGreen)
                .frame(width: 68, height: 58)
                .offset(x: -20, y: -10)
                .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.bob) { leafSway = true }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                smokePuff = true
            }
        }
    }
}

// MARK: - Horse

struct HorseSceneView: View {
    @State private var sunGlow = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.55, green: 0.82, blue: 0.98),
                    Color(red: 0.78, green: 0.92, blue: 0.62),
                    Color(red: 0.55, green: 0.78, blue: 0.38)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Circle()
                .fill(DesignSystem.Colors.sunshineYellow.opacity(sunGlow ? 0.75 : 0.55))
                .frame(width: 48, height: 48)
                .offset(x: 75, y: -42)

            StableFenceShape()
                .stroke(Color(red: 0.55, green: 0.38, blue: 0.22).opacity(0.7), lineWidth: 3)
                .frame(width: 120, height: 36)
                .offset(y: 42)

            ForEach(0..<7, id: \.self) { i in
                Capsule()
                    .fill(DesignSystem.Colors.freshGreen.opacity(0.65))
                    .frame(width: 3, height: CGFloat(10 + i % 3 * 4))
                    .offset(x: CGFloat(i - 3) * 14, y: 52)
            }

            HorseHeadShape()
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: 64, height: 56)
                .offset(x: -15, y: -5)
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.twinkle) { sunGlow = true }
        }
    }
}

// MARK: - Soccer

struct SoccerSceneView: View {
    @State private var ballRoll = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.32, green: 0.68, blue: 0.38),
                    Color(red: 0.22, green: 0.58, blue: 0.30)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            GoalShape()
                .stroke(.white.opacity(0.75), lineWidth: 3)
                .frame(width: 56, height: 38)
                .offset(x: -65, y: -15)

            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(.white.opacity(0.35))
                    .frame(width: 18, height: 2)
                    .rotationEffect(.degrees(-25))
                    .offset(x: 40 + CGFloat(i) * 8, y: -20 - CGFloat(i) * 6)
            }

            SoccerBallShape()
                .fill(.white)
                .frame(width: 36, height: 36)
                .offset(x: ballRoll ? 25 : -5, y: 18)
                .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                ballRoll = true
            }
        }
    }
}

// MARK: - Robot

struct RobotSceneView: View {
    @State private var gearSpin = false
    @State private var eyeBlink = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.22, blue: 0.42),
                    Color(red: 0.18, green: 0.35, blue: 0.58),
                    Color(red: 0.10, green: 0.28, blue: 0.48)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            ForEach(0..<3, id: \.self) { i in
                CircuitLineShape()
                    .stroke(DesignSystem.Colors.skyBlue.opacity(0.45), lineWidth: 2)
                    .frame(width: 40, height: 24)
                    .offset(
                        x: CGFloat([-70, 65, -40][i]),
                        y: CGFloat([-25, 20, 35][i])
                    )
            }

            GearShape(teeth: 8)
                .fill(DesignSystem.Colors.brightLavenderLight.opacity(0.55))
                .frame(width: 32, height: 32)
                .offset(x: 72, y: -30)
                .rotationEffect(.degrees(gearSpin ? 360 : 0))
                .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: gearSpin)

            RobotFaceShape(eyesOpen: !eyeBlink)
                .fill(DesignSystem.Colors.cardWhite.opacity(0.92))
                .frame(width: 76, height: 68)
                .offset(y: -5)
                .shadow(color: DesignSystem.Colors.skyBlue.opacity(0.35), radius: 10, y: 4)
        }
        .onAppear {
            gearSpin = true
            withAnimation(.easeInOut(duration: 0.12).repeatForever(autoreverses: true).delay(2.5)) {
                eyeBlink = true
            }
        }
    }
}

// MARK: - Castle

struct CastleSceneView: View {
    @State private var sparkle = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.72, green: 0.82, blue: 1.0),
                    DesignSystem.Colors.lavenderPurple.opacity(0.55),
                    DesignSystem.Colors.coralPink.opacity(0.35)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            CloudShape()
                .fill(.white.opacity(0.55))
                .frame(width: 50, height: 24)
                .offset(x: -70, y: -40)

            CloudShape()
                .fill(.white.opacity(0.4))
                .frame(width: 40, height: 20)
                .offset(x: 75, y: -30)

            ForEach(0..<4, id: \.self) { i in
                Image(systemName: "sparkle")
                    .font(.system(size: 10 + CGFloat(i % 2) * 3))
                    .foregroundStyle(DesignSystem.Colors.sunshineYellow.opacity(sparkle ? 1 : 0.35))
                    .offset(
                        x: CGFloat([-55, 40, -20, 65][i]),
                        y: CGFloat([-25, -45, 10, -15][i])
                    )
            }

            CastleShape()
                .fill(DesignSystem.Colors.lavenderPurple)
                .frame(width: 100, height: 70)
                .offset(y: 18)
                .shadow(color: DesignSystem.Colors.lavenderPurple.opacity(0.35), radius: 8, y: 4)

            // Flag
            Capsule()
                .fill(DesignSystem.Colors.coralPink)
                .frame(width: 3, height: 22)
                .offset(y: -28)
            Triangle()
                .fill(DesignSystem.Colors.sunshineYellow)
                .frame(width: 14, height: 10)
                .offset(x: 8, y: -32)
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.twinkle) { sparkle = true }
        }
    }
}

// MARK: - Nature

struct NatureSceneView: View {
    @State private var sway = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.70, green: 0.90, blue: 0.98),
                    Color(red: 0.55, green: 0.85, blue: 0.55),
                    Color(red: 0.35, green: 0.68, blue: 0.38)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Circle()
                .fill(DesignSystem.Colors.sunshineYellow.opacity(0.7))
                .frame(width: 36, height: 36)
                .offset(x: 70, y: -40)

            ForEach(0..<5, id: \.self) { i in
                LeafShape()
                    .fill(DesignSystem.Colors.freshGreen.opacity(0.65))
                    .frame(width: 20, height: 12)
                    .rotationEffect(.degrees(Double(i) * 20 + (sway ? 8 : -8)))
                    .offset(
                        x: CGFloat([-70, -40, 50, 75, -20][i]),
                        y: CGFloat([25, 40, 30, 15, 45][i])
                    )
            }

            // Flower
            ZStack {
                ForEach(0..<5, id: \.self) { i in
                    Circle()
                        .fill(DesignSystem.Colors.coralPink.opacity(0.8))
                        .frame(width: 14, height: 14)
                        .offset(y: -10)
                        .rotationEffect(.degrees(Double(i) * 72))
                }
                Circle()
                    .fill(DesignSystem.Colors.sunshineYellow)
                    .frame(width: 12, height: 12)
            }
            .offset(x: -15, y: -5)
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.bob) { sway = true }
        }
    }
}

// MARK: - Vehicles (airplane sky)

struct VehiclesSceneView: View {
    @State private var fly = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.55, green: 0.78, blue: 0.98),
                    Color(red: 0.72, green: 0.88, blue: 1.0),
                    DesignSystem.Colors.skyBlueLight
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            CloudShape()
                .fill(.white.opacity(0.65))
                .frame(width: 55, height: 26)
                .offset(x: -60, y: -20)

            CloudShape()
                .fill(.white.opacity(0.5))
                .frame(width: 42, height: 20)
                .offset(x: 70, y: 25)

            AirplaneShape()
                .fill(.white)
                .frame(width: 70, height: 28)
                .offset(x: fly ? 20 : -20, y: fly ? -12 : 0)
                .shadow(color: DesignSystem.Colors.skyBlue.opacity(0.35), radius: 6, y: 3)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                fly = true
            }
        }
    }
}

// MARK: - Train

struct TrainSceneView: View {
    @State private var chug = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.62, green: 0.82, blue: 0.95),
                    Color(red: 0.45, green: 0.68, blue: 0.42),
                    Color(red: 0.35, green: 0.55, blue: 0.32)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Tracks
            Capsule()
                .fill(DesignSystem.Colors.deepNavy.opacity(0.35))
                .frame(width: 200, height: 6)
                .offset(y: 38)
            HStack(spacing: 14) {
                ForEach(0..<6, id: \.self) { _ in
                    Capsule()
                        .fill(DesignSystem.Colors.deepNavy.opacity(0.28))
                        .frame(width: 4, height: 14)
                }
            }
            .offset(y: 38)

            // Engine
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(DesignSystem.Colors.coralPink)
                .frame(width: 70, height: 34)
                .offset(x: chug ? 12 : -12, y: 8)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: 28, height: 28)
                .offset(x: chug ? -28 : -52, y: 4)
            // Smoke
            Circle()
                .fill(.white.opacity(0.55))
                .frame(width: 14, height: 14)
                .offset(x: chug ? -48 : -72, y: chug ? -28 : -18)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                chug = true
            }
        }
    }
}

// MARK: - Car

struct CarSceneView: View {
    @State private var roll = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.70, green: 0.88, blue: 0.98),
                    Color(red: 0.55, green: 0.72, blue: 0.55),
                    Color(red: 0.40, green: 0.58, blue: 0.40)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Capsule()
                .fill(DesignSystem.Colors.deepNavy.opacity(0.25))
                .frame(width: 180, height: 10)
                .offset(y: 40)

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(DesignSystem.Colors.coralPink)
                .frame(width: 78, height: 28)
                .offset(x: roll ? 10 : -10, y: 8)
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(DesignSystem.Colors.skyBlue.opacity(0.9))
                .frame(width: 40, height: 18)
                .offset(x: roll ? 10 : -10, y: -8)
            Circle()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: 16, height: 16)
                .offset(x: (roll ? 10 : -10) - 22, y: 24)
            Circle()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: 16, height: 16)
                .offset(x: (roll ? 10 : -10) + 22, y: 24)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                roll = true
            }
        }
    }
}

// MARK: - Basketball

struct BasketballSceneView: View {
    @State private var bounce = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.72, blue: 0.35),
                    Color(red: 0.88, green: 0.55, blue: 0.25)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Backboard
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(.white.opacity(0.85))
                .frame(width: 42, height: 28)
                .offset(x: -55, y: -22)
            // Rim
            Capsule()
                .stroke(DesignSystem.Colors.coralPink, lineWidth: 3)
                .frame(width: 28, height: 10)
                .offset(x: -55, y: -6)

            Circle()
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: 34, height: 34)
                .overlay(
                    Circle().stroke(DesignSystem.Colors.deepNavy.opacity(0.25), lineWidth: 2)
                )
                .offset(x: bounce ? 18 : 5, y: bounce ? 22 : 8)
                .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                bounce = true
            }
        }
    }
}

// MARK: - City hero

struct CityHeroSceneView: View {
    @State private var capeFlutter = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.35, green: 0.55, blue: 0.95),
                    Color(red: 0.55, green: 0.70, blue: 0.98),
                    Color(red: 0.45, green: 0.48, blue: 0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Skyline
            HStack(alignment: .bottom, spacing: 8) {
                RoundedRectangle(cornerRadius: 4).fill(DesignSystem.Colors.deepNavy.opacity(0.55)).frame(width: 28, height: 48)
                RoundedRectangle(cornerRadius: 4).fill(DesignSystem.Colors.deepNavy.opacity(0.7)).frame(width: 36, height: 68)
                RoundedRectangle(cornerRadius: 4).fill(DesignSystem.Colors.deepNavy.opacity(0.5)).frame(width: 24, height: 40)
                RoundedRectangle(cornerRadius: 4).fill(DesignSystem.Colors.deepNavy.opacity(0.65)).frame(width: 32, height: 56)
            }
            .offset(y: 28)

            // Cape helper
            Capsule()
                .fill(DesignSystem.Colors.coralPink)
                .frame(width: capeFlutter ? 22 : 16, height: 28)
                .rotationEffect(.degrees(capeFlutter ? 18 : 8))
                .offset(x: 8, y: -8)
            Circle()
                .fill(DesignSystem.Colors.sunshineYellow)
                .frame(width: 22, height: 22)
                .offset(y: -18)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                capeFlutter = true
            }
        }
    }
}

// MARK: - Studio (art / music / cooking)

struct StudioSceneView: View {
    @State private var twinkle = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.92, blue: 0.78),
                    DesignSystem.Colors.coralPink.opacity(0.35),
                    DesignSystem.Colors.lavenderPurple.opacity(0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Palette blobs
            Circle().fill(DesignSystem.Colors.coralPink).frame(width: 18, height: 18).offset(x: -50, y: twinkle ? -10 : 0)
            Circle().fill(DesignSystem.Colors.skyBlue).frame(width: 16, height: 16).offset(x: -30, y: 12)
            Circle().fill(DesignSystem.Colors.sunshineYellow).frame(width: 14, height: 14).offset(x: -42, y: 22)
            Circle().fill(DesignSystem.Colors.freshGreen).frame(width: 15, height: 15).offset(x: -20, y: -8)

            // Music notes / easel hint
            Image(systemName: "music.note")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(DesignSystem.Colors.lavenderPurple.opacity(twinkle ? 1 : 0.55))
                .offset(x: 45, y: -18)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(.white.opacity(0.85))
                .frame(width: 48, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(DesignSystem.Colors.warmOrange, lineWidth: 3)
                        .padding(6)
                )
                .offset(x: 40, y: 16)
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.twinkle) { twinkle = true }
        }
    }
}

// MARK: - Scene Shapes

struct CoralShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.minX, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.maxY * 0.85)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.maxX, y: rect.midY)
        )
        return path
    }
}

struct FriendlySharkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.width * 0.05, y: rect.height * 0.25, width: rect.width * 0.75, height: rect.height * 0.55))
        path.move(to: CGPoint(x: rect.width * 0.55, y: rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.width * 0.72, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width * 0.78, y: rect.height * 0.35))
        path.closeSubpath()
        path.addEllipse(in: CGRect(x: rect.width * 0.62, y: rect.height * 0.38, width: rect.width * 0.08, height: rect.height * 0.1))
        return path
    }
}

struct MoonCrescentShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect)
        path.addEllipse(in: rect.offsetBy(dx: rect.width * 0.28, dy: -rect.height * 0.08).insetBy(dx: rect.width * 0.15, dy: rect.height * 0.15))
        return path
    }
}

struct VolcanoShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        return path
    }
}

struct CuteDinoFaceShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
            in: CGRect(x: rect.width * 0.12, y: rect.height * 0.22, width: rect.width * 0.7, height: rect.height * 0.58),
            cornerSize: CGSize(width: 14, height: 14)
        )
        for i in 0..<3 {
            path.addEllipse(in: CGRect(
                x: rect.width * (0.28 + CGFloat(i) * 0.14),
                y: rect.height * 0.05,
                width: rect.width * 0.1,
                height: rect.height * 0.12
            ))
        }
        path.addEllipse(in: CGRect(x: rect.width * 0.38, y: rect.height * 0.42, width: rect.width * 0.1, height: rect.height * 0.08))
        return path
    }
}

struct StableFenceShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let posts = 5
        let spacing = rect.width / CGFloat(posts - 1)
        for i in 0..<posts {
            let x = CGFloat(i) * spacing
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        path.move(to: CGPoint(x: 0, y: rect.midY - 6))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY - 6))
        path.move(to: CGPoint(x: 0, y: rect.midY + 6))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + 6))
        return path
    }
}

struct GoalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

struct CircuitLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.move(to: CGPoint(x: rect.width * 0.6, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

struct GearShape: Shape {
    var teeth: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.72
        for i in 0..<(teeth * 2) {
            let angle = (Double(i) / Double(teeth * 2)) * 2 * .pi - .pi / 2
            let radius = i.isMultiple(of: 2) ? outer : inner
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        path.addEllipse(in: CGRect(
            x: center.x - inner * 0.35,
            y: center.y - inner * 0.35,
            width: inner * 0.7,
            height: inner * 0.7
        ))
        return path
    }
}

struct RobotFaceShape: Shape {
    var eyesOpen: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect.insetBy(dx: rect.width * 0.05, dy: rect.height * 0.08), cornerSize: CGSize(width: 12, height: 12))
        let eyeH = eyesOpen ? rect.height * 0.12 : 2
        path.addRoundedRect(
            in: CGRect(x: rect.width * 0.22, y: rect.height * 0.28, width: rect.width * 0.18, height: eyeH),
            cornerSize: CGSize(width: 4, height: 4)
        )
        path.addRoundedRect(
            in: CGRect(x: rect.width * 0.58, y: rect.height * 0.28, width: rect.width * 0.18, height: eyeH),
            cornerSize: CGSize(width: 4, height: 4)
        )
        path.addRoundedRect(
            in: CGRect(x: rect.width * 0.32, y: rect.height * 0.58, width: rect.width * 0.36, height: rect.height * 0.08),
            cornerSize: CGSize(width: 4, height: 4)
        )
        return path
    }
}
