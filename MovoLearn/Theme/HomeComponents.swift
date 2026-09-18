import SwiftUI

// MARK: - Kid-simple home header

struct HomeKidHeader: View {
    let name: String
    let subtitle: String
    let mascotTopic: Topic
    var streak: Int = 0
    var onSearch: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
            MascotView(topic: mascotTopic, size: 72, celebrate: false)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text("Hi, \(name)!")
                    .font(DesignSystem.Typography.headline(28))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .accessibilityAddTraits(.isHeader)

                Text(subtitle)
                    .font(DesignSystem.Typography.subtitle(15))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)

                if streak > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.white)
                            .symbolEffect(.bounce, value: streak)
                            .wiggle(degrees: 7)
                        Text("\(streak)-day streak")
                            .foregroundStyle(.white)
                    }
                    .font(DesignSystem.Typography.caption(13).weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        LinearGradient(
                            colors: [DesignSystem.Colors.warmOrange, DesignSystem.Colors.coralPink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .accessibilityLabel("\(streak) day streak")
                }
            }

            Spacer(minLength: 4)

            if let onSearch {
                Button(action: onSearch) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                        .background(
                            LinearGradient(
                                colors: [DesignSystem.Colors.skyBlue, DesignSystem.Colors.lavenderPurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: DesignSystem.Colors.skyBlue.opacity(0.35), radius: 8, y: 3)
                        .idlePulse(scale: 1.06, delay: 0.4)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Find adventures")
            }
        }
    }
}

struct HomeGreetingHeader: View {
    let title: String
    let subtitle: String
    var onSearch: (() -> Void)? = nil

    var body: some View {
        HomeKidHeader(
            name: title,
            subtitle: subtitle,
            mascotTopic: .space,
            onSearch: onSearch
        )
    }
}

struct AdventurePlayerHeader: View {
    let profile: ChildProfile
    let stats: PlayerHomeStats
    let mascotTopic: Topic
    var onSearch: (() -> Void)? = nil

    var body: some View {
        HomeKidHeader(
            name: profile.nickname.isEmpty ? "Explorer" : profile.nickname,
            subtitle: "\(stats.adventuresCompleted) adventure\(stats.adventuresCompleted == 1 ? "" : "s") done",
            mascotTopic: mascotTopic,
            streak: stats.streak,
            onSearch: onSearch
        )
    }
}

struct SkillOrbChip: View {
    let orb: SkillOrbModel

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(orb.tint.opacity(0.2), lineWidth: 5)
                    .frame(width: 44, height: 44)
                Circle()
                    .trim(from: 0, to: CGFloat(orb.masteryPercent) / 100)
                    .stroke(orb.tint, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                Text("\(orb.masteryPercent)")
                    .font(DesignSystem.Typography.label(11))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
            }
            Text(orb.title)
                .font(DesignSystem.Typography.caption(11))
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .lineLimit(1)
                .frame(width: 64)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(orb.title) skill \(orb.masteryPercent) percent")
    }
}

// MARK: - Progress indicator

struct HomeProgressBar: View {
    let progress: Double
    var tint: Color = DesignSystem.Colors.skyBlue
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(tint.opacity(0.15))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [tint, tint.opacity(0.75)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(height, geo.size.width * min(1, max(0, progress))))
            }
        }
        .frame(height: height)
        .accessibilityLabel("Progress \(Int(progress * 100)) percent")
    }
}

// MARK: - Continue Adventure hero

struct ContinueLearningCard: View {
    let model: ContinueLearningCardModel
    let onContinue: () -> Void

    @State private var ctaPulse = false

    private var accent: Color { TopicPalette.color(for: model.lesson.theme) }
    private var ctaTitle: String { model.isResume ? "Keep Going!" : "Let’s Go!" }

    var body: some View {
        Button(action: onContinue) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.22))
                            .frame(width: 96, height: 96)
                        TopicIllustrationView(topic: model.lesson.theme, size: 72, animate: true)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(model.isResume ? "Keep exploring" : "Ready when you are")
                            .font(DesignSystem.Typography.caption(13))
                            .foregroundStyle(.white.opacity(0.88))

                        Text(model.lesson.title)
                            .font(DesignSystem.Typography.title(24))
                            .foregroundStyle(.white)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)

                        Text(TopicPalette.displayTitle(for: model.lesson.theme))
                            .font(DesignSystem.Typography.subtitle(14))
                            .foregroundStyle(.white.opacity(0.85))
                    }

                    Spacer(minLength: 0)
                }

                if model.progressPercent > 0 {
                    VStack(alignment: .leading, spacing: 8) {
                        HomeProgressBar(
                            progress: Double(model.progressPercent) / 100.0,
                            tint: .white,
                            height: 8
                        )
                        Text("You’re \(model.progressPercent)% through")
                            .font(DesignSystem.Typography.caption(12))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }

                HStack(spacing: 10) {
                    Text(ctaTitle)
                        .font(DesignSystem.Typography.button(18))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                        .offset(x: ctaPulse ? 4 : 0)
                }
                .foregroundStyle(accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous))
                .shadow(color: .black.opacity(0.10), radius: 10, y: 4)
                .scaleEffect(ctaPulse ? 1.02 : 1.0)
            }
            .padding(DesignSystem.Spacing.cardPadding)
            .background(
                ZStack {
                    LinearGradient(
                        colors: TopicPalette.gradientColors(for: model.lesson.theme) + [
                            accent,
                            DesignSystem.Colors.sunshineYellow.opacity(0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Circle()
                        .fill(DesignSystem.Colors.sunshineYellow.opacity(0.28))
                        .frame(width: 180, height: 180)
                        .offset(x: 110, y: -70)

                    Circle()
                        .fill(DesignSystem.Colors.coralPink.opacity(0.22))
                        .frame(width: 120, height: 120)
                        .offset(x: -90, y: 80)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous)
                    .stroke(.white.opacity(0.22), lineWidth: 1)
            )
            .shadow(color: accent.opacity(0.32), radius: 22, y: 10)
        }
        .buttonStyle(BouncyCardButtonStyle())
        .accessibilityLabel(model.isResume ? "Continue \(model.lesson.title)" : "Start \(model.lesson.title)")
        .onAppear {
            withAnimation(DesignSystem.Animation.idle) {
                ctaPulse = true
            }
        }
    }
}

// MARK: - Compact today strip (home launchpad)

struct HomeTodayStrip: View {
    let stats: PlayerHomeStats
    var onTap: (() -> Void)? = nil

    private var goalMet: Bool { stats.dailyProgress >= stats.dailyGoal }

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: DesignSystem.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: goalMet
                                    ? [DesignSystem.Colors.freshGreen, DesignSystem.Colors.oceanTurquoise]
                                    : [DesignSystem.Colors.sunshineYellow, DesignSystem.Colors.warmOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    Image(systemName: goalMet ? "star.fill" : "flag.checkered")
                        .font(.body.weight(.bold))
                        .foregroundStyle(.white)
                        .symbolEffect(.bounce, value: goalMet)
                        .symbolEffect(.bounce, value: stats.dailyProgress)
                }
                .idlePulse(scale: goalMet ? 1.08 : 1.04)

                VStack(alignment: .leading, spacing: 4) {
                    Text(goalMet ? "Daily goal done" : "Today’s goal")
                        .font(DesignSystem.Typography.sectionHeader(15))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                    HomeProgressBar(
                        progress: Double(stats.dailyProgress) / Double(max(1, stats.dailyGoal)),
                        tint: goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.warmOrange,
                        height: 8
                    )
                }

                Text("\(stats.dailyProgress)/\(stats.dailyGoal)")
                    .font(DesignSystem.Typography.sectionHeader(15))
                    .foregroundStyle(goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.warmOrange)

                if onTap != nil {
                    Image(systemName: "chevron.right")
                        .font(.body.weight(.bold))
                        .foregroundStyle(DesignSystem.Colors.mutedText)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(DesignSystem.Gradients.kidCardFill(accent: goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.sunshineYellow))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous)
                    .stroke((goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.warmOrange).opacity(0.36), lineWidth: 1.5)
            )
        }
        .buttonStyle(BouncyCardButtonStyle())
        .disabled(onTap == nil)
        .accessibilityLabel("Daily goal \(stats.dailyProgress) of \(stats.dailyGoal)")
        .accessibilityHint(onTap == nil ? "" : "Opens all adventures for your level")
    }
}

// MARK: - Daily goal

struct DailyGoalCard: View {
    let stats: PlayerHomeStats

    private var fraction: Double {
        Double(stats.dailyProgress) / Double(max(1, stats.dailyGoal))
    }

    private var goalMet: Bool { stats.dailyProgress >= stats.dailyGoal }

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: goalMet
                                ? [DesignSystem.Colors.freshGreen, DesignSystem.Colors.oceanTurquoise]
                                : [DesignSystem.Colors.sunshineYellow, DesignSystem.Colors.warmOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 58, height: 58)
                    .shadow(color: (goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.warmOrange).opacity(0.35), radius: 10, y: 4)

                Image(systemName: goalMet ? "star.fill" : "flag.checkered")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, value: goalMet)
                    .symbolEffect(.bounce, value: stats.dailyProgress)
            }
            .idlePulse(scale: goalMet ? 1.08 : 1.04)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(goalMet ? "Daily Goal Done!" : "Today’s Goal")
                        .font(DesignSystem.Typography.sectionHeader(16))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                    Spacer()
                    Text("\(stats.dailyProgress)/\(stats.dailyGoal)")
                        .font(DesignSystem.Typography.sectionHeader(15))
                        .foregroundStyle(goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.warmOrange)
                }

                HomeProgressBar(
                    progress: fraction,
                    tint: goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.warmOrange,
                    height: 12
                )

                Text(goalMet
                     ? "You smashed today’s quest goal — high five!"
                     : "Finish \(max(0, stats.dailyGoal - stats.dailyProgress)) more adventure\(stats.dailyGoal - stats.dailyProgress == 1 ? "" : "s") to fill the star meter.")
                    .font(DesignSystem.Typography.caption(13))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
            }
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Gradients.kidCardFill(accent: goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.sunshineYellow))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                .stroke((goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.warmOrange).opacity(0.42), lineWidth: 1.75)
        )
        .shadow(color: (goalMet ? DesignSystem.Colors.freshGreen : DesignSystem.Colors.warmOrange).opacity(0.22), radius: 10, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Daily goal \(stats.dailyProgress) of \(stats.dailyGoal)")
    }
}

// MARK: - Today's missions

struct TodayMissionCard: View {
    let mission: DailyMission
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: mission.isComplete
                                    ? [DesignSystem.Colors.freshGreen.opacity(0.9), DesignSystem.Colors.oceanTurquoise.opacity(0.75)]
                                    : [mission.accent.opacity(0.95), mission.accent.opacity(0.55)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: (mission.isComplete ? DesignSystem.Colors.freshGreen : mission.accent).opacity(0.28), radius: 8, y: 3)

                    Image(systemName: mission.isComplete ? "checkmark" : mission.systemImage)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .symbolEffect(.bounce, value: mission.isComplete)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(mission.title)
                        .font(DesignSystem.Typography.sectionHeader(15))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .multilineTextAlignment(.leading)
                    Text(mission.detail)
                        .font(DesignSystem.Typography.caption(12))
                        .foregroundStyle(DesignSystem.Colors.mutedText)
                        .multilineTextAlignment(.leading)
                    HomeProgressBar(
                        progress: mission.progressFraction,
                        tint: mission.isComplete ? DesignSystem.Colors.freshGreen : mission.accent,
                        height: 7
                    )
                    .padding(.top, 2)
                }

                Image(systemName: trailingIcon)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(mission.isComplete ? DesignSystem.Colors.sunshineYellow : mission.accent)
            }
            .padding(14)
            .background(DesignSystem.Gradients.kidCardFill(accent: mission.accent))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous)
                    .stroke(mission.accent.opacity(0.42), lineWidth: 1.75)
            )
            .shadow(color: mission.accent.opacity(0.22), radius: 8, y: 3)
        }
        .buttonStyle(BouncyCardButtonStyle())
        .disabled(mission.linkedLesson == nil && mission.linkedTopic == nil && !mission.isComplete)
        .accessibilityLabel("\(mission.title). \(mission.detail)")
    }

    private var trailingIcon: String {
        if mission.isComplete { return "star.fill" }
        if mission.kind == .exploreInterest { return "chevron.right" }
        return "play.circle.fill"
    }
}

// MARK: - Catch sparks (playful home moment)

private struct FloatingSpark: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var tintIndex: Int
    var size: CGFloat
}

struct CatchSparksPlay: View {
    let childId: UUID
    var accent: Color = DesignSystem.Colors.sunshineYellow

    @State private var collected = 0
    @State private var sparks: [FloatingSpark] = []
    @State private var doneToday = false
    @State private var popID: UUID?
    @State private var bob = false

    private let target = 5
    private var storageKey: String {
        "com.movolearn.sparkWarmup.\(childId.uuidString)"
    }

    private let sparkColors: [Color] = [
        DesignSystem.Colors.sunshineYellow,
        DesignSystem.Colors.coralPink,
        DesignSystem.Colors.skyBlue,
        DesignSystem.Colors.freshGreen,
        DesignSystem.Colors.lavenderPurple
    ]

    var body: some View {
        Group {
            if doneToday {
                HStack(spacing: 8) {
                    ForEach(0..<target, id: \.self) { i in
                        Image(systemName: "star.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(sparkColors[i % sparkColors.count])
                            .floating(offset: 3, delay: Double(i) * 0.1)
                    }
                    Text("You caught them all!")
                        .font(DesignSystem.Typography.caption(13).weight(.semibold))
                        .foregroundStyle(DesignSystem.Colors.deepNavy.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            } else {
                VStack(spacing: 10) {
                    Text("Catch the sparks!")
                        .font(DesignSystem.Typography.sectionHeader(17))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .frame(maxWidth: .infinity)

                    ZStack {
                        ForEach(sparks) { spark in
                            Button {
                                collectSpark(spark)
                            } label: {
                                Image(systemName: spark.tintIndex.isMultiple(of: 2) ? "star.fill" : "sparkle")
                                    .font(.system(size: spark.size, weight: .bold))
                                    .foregroundStyle(sparkColors[spark.tintIndex % sparkColors.count])
                                    .shadow(color: sparkColors[spark.tintIndex % sparkColors.count].opacity(0.45), radius: 8, y: 2)
                                    .scaleEffect(popID == spark.id ? 1.4 : 1)
                                    .opacity(popID == spark.id ? 0.2 : 1)
                            }
                            .buttonStyle(.plain)
                            .offset(x: spark.x, y: spark.y + (bob ? 5 : -5))
                            .accessibilityLabel("Catch a spark")
                        }
                    }
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)

                    HStack(spacing: 6) {
                        ForEach(0..<target, id: \.self) { i in
                            Image(systemName: i < collected ? "star.fill" : "star")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(
                                    i < collected
                                        ? sparkColors[i % sparkColors.count]
                                        : DesignSystem.Colors.deepNavy.opacity(0.22)
                                )
                        }
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 10)
        .background(
            LinearGradient(
                colors: [
                    DesignSystem.Colors.sunshineYellowLight,
                    DesignSystem.Colors.coralPinkLight,
                    DesignSystem.Colors.skyBlueLight,
                    DesignSystem.Colors.brightLavenderLight
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                .stroke(DesignSystem.Colors.sunshineYellow.opacity(0.55), lineWidth: 1.75)
        )
        .shadow(color: DesignSystem.Colors.sunshineYellow.opacity(0.28), radius: 12, y: 5)
        .sensoryFeedback(.success, trigger: collected)
        .onAppear {
            restoreOrSeed()
            withAnimation(DesignSystem.Animation.bob) { bob = true }
        }
    }

    private func restoreOrSeed() {
        let today = Self.dayStamp()
        if UserDefaults.standard.string(forKey: storageKey) == today {
            doneToday = true
            collected = target
            return
        }
        sparks = makeSparks(count: target)
    }

    private func makeSparks(count: Int) -> [FloatingSpark] {
        (0..<count).map { i in
            let angle = Double(i) / Double(max(count, 1)) * .pi * 2 + Double.random(in: -0.25...0.25)
            return FloatingSpark(
                id: UUID(),
                x: CGFloat(cos(angle)) * CGFloat.random(in: 55...95),
                y: CGFloat(sin(angle)) * CGFloat.random(in: 18...42),
                tintIndex: i,
                size: CGFloat.random(in: 26...34)
            )
        }
    }

    private func collectSpark(_ spark: FloatingSpark) {
        guard !doneToday else { return }
        withAnimation(DesignSystem.Animation.celebrate) {
            popID = spark.id
            sparks.removeAll { $0.id == spark.id }
            collected += 1
        }

        if collected >= target {
            withAnimation(DesignSystem.Animation.gentle) {
                doneToday = true
            }
            UserDefaults.standard.set(Self.dayStamp(), forKey: storageKey)
        } else if sparks.isEmpty {
            withAnimation(DesignSystem.Animation.gentle) {
                sparks = makeSparks(count: target - collected)
            }
        }
    }

    private static func dayStamp() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

typealias SparkCollectWarmupCard = CatchSparksPlay

// MARK: - World bubble (kid-simple)

struct WorldBubbleCard: View {
    let world: SubjectWorld
    var floatDelay: Double = 0
    let onTap: () -> Void

    private var shortTitle: String {
        if let topic = world.topic {
            return TopicPalette.displayTitle(for: topic)
        }
        return world.title
            .replacingOccurrences(of: " Adventures", with: "")
            .replacingOccurrences(of: " World", with: "")
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [world.accent.opacity(0.95), world.accent.opacity(0.65)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 92, height: 92)
                        .shadow(color: world.accent.opacity(0.28), radius: 12, y: 6)

                    TopicIllustrationView(topic: world.illustrationTopic, size: 58, animate: true)
                }
                .floating(offset: 5, delay: floatDelay)
                .idlePulse(scale: 1.04, delay: floatDelay)

                Text(shortTitle)
                    .font(DesignSystem.Typography.sectionHeader(14))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
                    .frame(minHeight: 36, alignment: .top)

                if world.masteryPercent > 0 {
                    HomeProgressBar(
                        progress: Double(world.masteryPercent) / 100,
                        tint: world.accent,
                        height: 5
                    )
                    .frame(width: 72)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 10)
            .background(DesignSystem.Gradients.kidCardFill(accent: world.accent))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                    .stroke(world.accent.opacity(0.42), lineWidth: 1.75)
            )
            .shadow(color: world.accent.opacity(0.22), radius: 10, y: 4)
        }
        .buttonStyle(BouncyCardButtonStyle())
        .accessibilityLabel(shortTitle)
    }
}

// MARK: - Compact next adventure

struct CompactAdventureChip: View {
    let model: RecommendedLessonCardModel
    let onTap: () -> Void

    private var accent: Color { TopicPalette.color(for: model.lesson.theme) }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [accent, accent.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    TopicIllustrationView(topic: model.lesson.theme, size: 34, animate: false)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(model.lesson.title)
                        .font(DesignSystem.Typography.sectionHeader(14))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Text(TopicPalette.displayTitle(for: model.lesson.theme))
                        .font(DesignSystem.Typography.caption(12))
                        .foregroundStyle(DesignSystem.Colors.mutedText)
                }

                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(width: 220, alignment: .leading)
            .background(DesignSystem.Gradients.kidCardFill(accent: accent))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous)
                    .stroke(accent.opacity(0.42), lineWidth: 1.5)
            )
            .shadow(color: accent.opacity(0.22), radius: 8, y: 3)
        }
        .buttonStyle(BouncyCardButtonStyle())
        .accessibilityLabel(model.lesson.title)
    }
}

// MARK: - Subject world card

struct SubjectWorldCard: View {
    let world: SubjectWorld
    let onTap: () -> Void

    var body: some View {
        WorldBubbleCard(world: world, onTap: onTap)
    }
}

// MARK: - Discovery challenge

struct DiscoveryChallengeCard: View {
    let model: DiscoveryChallengeModel
    let onStart: () -> Void

    var body: some View {
        Button(action: onStart) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [model.accent, model.accent.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                    Image(systemName: model.systemImage)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY’S CHALLENGE")
                        .font(DesignSystem.Typography.label(10))
                        .foregroundStyle(model.accent)
                    Text(model.title)
                        .font(DesignSystem.Typography.sectionHeader(16))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                    Text(model.detail)
                        .font(DesignSystem.Typography.caption(13))
                        .foregroundStyle(DesignSystem.Colors.mutedText)
                }

                Spacer(minLength: 0)

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(model.accent)
            }
            .padding(16)
            .background(DesignSystem.Gradients.kidCardFill(accent: model.accent))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous)
                    .stroke(model.accent.opacity(0.45), lineWidth: 1.75)
            )
            .shadow(color: model.accent.opacity(0.24), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(model.title). \(model.detail)")
    }
}

// MARK: - Reward chip

struct HomeRewardChip: View {
    let reward: AdventureReward
    var floatDelay: Double = 0

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [reward.accent.opacity(0.9), reward.accent.opacity(0.55)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: reward.accent.opacity(0.25), radius: 10, y: 4)
                Image(systemName: reward.systemImage)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, value: reward.id)
            }
            .floating(offset: 4, delay: floatDelay)
            .idlePulse(scale: 1.06, delay: floatDelay)
            .wiggle(degrees: 5, delay: floatDelay)

            Text(reward.title)
                .font(DesignSystem.Typography.caption(12))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 88)
                .frame(minHeight: 32, alignment: .top)
        }
        .accessibilityLabel("\(reward.title). \(reward.detail)")
    }
}

// MARK: - Recommended lesson card

struct RecommendedLessonCard: View {
    let model: RecommendedLessonCardModel
    let onStart: () -> Void

    private var accent: Color { TopicPalette.color(for: model.lesson.theme) }

    var body: some View {
        Button(action: onStart) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [accent.opacity(0.95), accent.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 68, height: 68)
                        .shadow(color: accent.opacity(0.22), radius: 8, y: 3)
                    TopicIllustrationView(topic: model.lesson.theme, size: 42, animate: true)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(model.questLabel)
                        .font(DesignSystem.Typography.caption(12))
                        .foregroundStyle(accent)

                    Text(model.lesson.title)
                        .font(DesignSystem.Typography.sectionHeader(16))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text("\(TopicPalette.displayTitle(for: model.lesson.theme)) · \(model.lesson.readingLevel.rawValue)")
                        .font(DesignSystem.Typography.caption(12))
                        .foregroundStyle(DesignSystem.Colors.mutedText)
                        .lineLimit(1)

                    if !model.reason.isEmpty, model.reason != model.questLabel {
                        Text(model.reason)
                            .font(DesignSystem.Typography.caption(11))
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(accent)
            }
            .padding(14)
            .background(DesignSystem.Gradients.kidCardFill(accent: accent))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                    .stroke(accent.opacity(0.42), lineWidth: 1.5)
            )
            .shadow(color: accent.opacity(0.22), radius: 10, y: 4)
        }
        .buttonStyle(BouncyCardButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(model.lesson.title), \(model.questLabel)")
    }
}

// MARK: - Interest category card

struct InterestCategoryCard: View {
    let topic: Topic
    var floatDelay: Double = 0
    var onTap: (() -> Void)? = nil

    private var accent: Color { TopicPalette.color(for: topic) }

    var body: some View {
        Button {
            onTap?()
        } label: {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [accent.opacity(0.95), accent.opacity(0.65)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 84, height: 84)
                        .shadow(color: accent.opacity(0.28), radius: 12, y: 6)

                    TopicIllustrationView(topic: topic, size: 52, animate: true)
                }
                .floating(offset: 5, delay: floatDelay)

                Text(TopicPalette.displayTitle(for: topic))
                    .font(DesignSystem.Typography.sectionHeader(14))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 96)
                    .frame(minHeight: 34, alignment: .top)
            }
        }
        .buttonStyle(BouncyCardButtonStyle())
        .disabled(onTap == nil)
        .accessibilityLabel(TopicPalette.displayTitle(for: topic))
    }
}

// MARK: - Subject bubble card

struct ExploreSubjectCard: View {
    let category: ExploreSubjectCategory
    var floatDelay: Double = 0
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [category.accent.opacity(0.92), category.accent.opacity(0.58)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 86, height: 86)
                        .shadow(color: category.accent.opacity(0.26), radius: 12, y: 6)

                    Image(systemName: category.systemImage)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .floating(offset: 5, delay: floatDelay)

                Text(category.worldTitle)
                    .font(DesignSystem.Typography.sectionHeader(13))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 104)
                    .frame(minHeight: 34, alignment: .top)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .background(DesignSystem.Gradients.kidCardFill(accent: category.accent))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous)
                    .stroke(category.accent.opacity(0.42), lineWidth: 1.5)
            )
        }
        .buttonStyle(BouncyCardButtonStyle())
        .accessibilityLabel("\(category.worldTitle). \(category.subtitle)")
    }
}

struct CompactSubjectChip: View {
    let category: ExploreSubjectCategory
    let onTap: () -> Void

    var body: some View {
        ExploreSubjectCard(category: category, onTap: onTap)
    }
}

// MARK: - Home empty / loading

struct HomeLoadingCard: View {
    var message: String = "Finding your next adventure…"

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            ProgressView()
                .controlSize(.large)
                .tint(DesignSystem.Colors.skyBlue)
            Text(message)
                .font(DesignSystem.Typography.subtitle(15))
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xxl)
        .sparkCard(elevated: true)
    }
}

struct HomeSectionTitle: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(DesignSystem.Typography.sectionHeader(20))
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            Spacer()

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(DesignSystem.Typography.subtitle(14).weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            LinearGradient(
                                colors: [DesignSystem.Colors.skyBlue, DesignSystem.Colors.lavenderPurple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(actionTitle)
            }
        }
    }
}
