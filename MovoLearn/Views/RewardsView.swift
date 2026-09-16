import SwiftUI

struct RewardsView: View {
    let profile: ChildProfile
    let game: GameProgressSnapshot

    @State private var appeared = false

    private var unlocked: [AdventureReward] {
        game.unlockedRewardIDs.compactMap { AdventureRewardCatalog.reward(id: $0) }
    }

    private var locked: [AdventureReward] {
        AdventureRewardCatalog.all.filter { !game.unlockedRewardIDs.contains($0.id) }
    }

    private var mascotTopic: Topic { profile.favoriteTopics.first ?? .space }

    var body: some View {
        ZStack {
            DesignSystem.Gradients.homeGradient
                .ignoresSafeArea()

            SoftBubbleAtmosphere(
                accent: DesignSystem.Colors.sunshineYellow,
                secondary: DesignSystem.Colors.coralPink,
                tertiary: DesignSystem.Colors.lavenderPurple,
                intensity: 1.18
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
                    KidScreenHeader(
                        title: "Treasures",
                        subtitle: profile.currentAge <= 7
                            ? "Badges and prizes you earn by learning."
                            : "Collectibles unlocked through practice and streaks.",
                        mascotTopic: mascotTopic
                    )
                    .entrance(appeared: appeared)

                    summaryStrip
                        .entrance(appeared: appeared, delay: 0.06)

                    if !unlocked.isEmpty {
                        section(title: "Your Collection", rewards: unlocked, locked: false)
                            .entrance(appeared: appeared, delay: 0.1)
                    } else {
                        EmptyStateCard(
                            icon: "trophy.fill",
                            title: "Treasures await",
                            message: "Finish adventures to unlock badges, places, and collectibles.",
                            accent: DesignSystem.Colors.sunshineYellow
                        )
                        .entrance(appeared: appeared, delay: 0.1)
                    }

                    if !locked.isEmpty {
                        section(title: "Still to Find", rewards: Array(locked.prefix(8)), locked: true)
                            .entrance(appeared: appeared, delay: 0.14)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.screenPadding)
                .padding(.top, DesignSystem.Spacing.md)
                .padding(.bottom, DesignSystem.Spacing.xxl)
            }
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.stagger.delay(0.04)) { appeared = true }
        }
    }

    private var summaryStrip: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            SoftStatBubble(
                title: "Unlocked",
                value: "\(unlocked.count)",
                icon: "checkmark.seal.fill",
                tint: DesignSystem.Colors.freshGreen,
                floatDelay: 0
            )
            SoftStatBubble(
                title: "Quests",
                value: "\(game.completedAdventureCount)",
                icon: "flag.checkered",
                tint: DesignSystem.Colors.oceanTurquoise,
                floatDelay: 0.15
            )
            SoftStatBubble(
                title: "Rank",
                value: "\(game.level)",
                icon: "star.fill",
                tint: DesignSystem.Colors.lavenderPurple,
                floatDelay: 0.3
            )
        }
    }

    private func section(title: String, rewards: [AdventureReward], locked: Bool) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HomeSectionTitle(title: title)
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: DesignSystem.Spacing.md
            ) {
                ForEach(Array(rewards.enumerated()), id: \.element.id) { index, reward in
                    let progress = reward.unlockRule.unlockProgress(
                        game: game,
                        streak: profile.currentLearningStreak
                    )
                    RewardDetailCard(
                        reward: reward,
                        isLocked: locked,
                        progressCurrent: progress.current,
                        progressTarget: progress.target,
                        progressCaption: progress.caption,
                        floatDelay: Double(index % 4) * 0.12
                    )
                }
            }
        }
    }
}

struct RewardDetailCard: View {
    let reward: AdventureReward
    var isLocked: Bool = false
    var progressCurrent: Int = 0
    var progressTarget: Int = 1
    var progressCaption: String = ""
    var floatDelay: Double = 0

    private var progressFraction: Double {
        Double(progressCurrent) / Double(max(1, progressTarget))
    }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isLocked
                                ? [DesignSystem.Colors.textTertiary.opacity(0.22), DesignSystem.Colors.textTertiary.opacity(0.1)]
                                : [reward.accent.opacity(0.95), reward.accent.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 78, height: 78)
                    .shadow(
                        color: (isLocked ? DesignSystem.Colors.textTertiary : reward.accent).opacity(0.22),
                        radius: 12,
                        y: 5
                    )

                if isLocked {
                    Circle()
                        .trim(from: 0, to: progressFraction)
                        .stroke(reward.accent.opacity(0.85), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .frame(width: 86, height: 86)
                        .rotationEffect(.degrees(-90))
                }

                Image(systemName: isLocked ? "lock.fill" : reward.systemImage)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(isLocked ? DesignSystem.Colors.textTertiary : .white)
            }
            .floating(offset: isLocked ? 0 : 5, delay: floatDelay)

            Text(reward.title)
                .font(DesignSystem.Typography.sectionHeader(15))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(minHeight: 36, alignment: .top)

            if isLocked {
                Text(progressCaption.isEmpty ? reward.detail : progressCaption)
                    .font(DesignSystem.Typography.caption(12))
                    .foregroundStyle(reward.accent)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(minHeight: 32, alignment: .top)
            } else {
                Text(reward.kind.displayName)
                    .font(DesignSystem.Typography.caption(12))
                    .foregroundStyle(reward.accent)
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(DesignSystem.Gradients.kidCardFill(accent: isLocked ? DesignSystem.Colors.textTertiary : reward.accent))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous)
                .stroke(reward.accent.opacity(isLocked ? 0.28 : 0.48), lineWidth: 1.75)
        )
        .shadow(color: (isLocked ? DesignSystem.Colors.textTertiary : reward.accent).opacity(0.22), radius: isLocked ? 6 : 12, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(reward.title). \(isLocked ? progressCaption : reward.detail)\(isLocked ? ". Locked" : "")")
    }
}
