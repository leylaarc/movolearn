import SwiftUI
import UIKit

struct LessonCompletionView: View {
    let summary: ProgressSummary
    var rewardResult: LessonRewardResult? = nil
    var nextLesson: Lesson? = nil
    let onPlayAnother: () -> Void
    let onGoHome: () -> Void

    @State private var badgeScale: CGFloat = 0.3
    @State private var badgeRotation: Double = -15
    @State private var contentOpacity: Double = 0
    @State private var showSparkles = false
    @State private var sparkleSpin: Double = 0
    @State private var badgePulse = false
    @ObservedObject private var speech = LessonSpeechReader.shared
    @State private var readGeneration = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var topic: Topic {
        summary.topicsPracticed.first ?? .sharks
    }

    var body: some View {
        ZStack {
            DesignSystem.Gradients.completionGradient
                .ignoresSafeArea()

            SoftBubbleAtmosphere(topic: topic, intensity: 1.05)

            ConfettiView()
                .opacity(0.55)

            if showSparkles {
                CelebrationView()
            }

            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    heroSection

                    MascotView(topic: topic, size: 110, celebrate: true)
                        .opacity(contentOpacity)

                    if let rewardResult, rewardResult.newLevel > rewardResult.previousLevel {
                        levelUpBanner(rewardResult)
                            .opacity(contentOpacity)
                    }

                    if let rewardResult, !rewardResult.newlyUnlocked.isEmpty {
                        unlocksRow(rewardResult.newlyUnlocked)
                            .opacity(contentOpacity)
                    }

                    nextAdventureSection
                        .opacity(contentOpacity)

                    statsCard
                        .opacity(contentOpacity)
                }
                .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.celebrate) {
                badgeScale = 1
                badgeRotation = 0
            }
            withAnimation(DesignSystem.Animation.gentle.delay(0.3)) {
                contentOpacity = 1
            }
            if !reduceMotion {
                withAnimation(.linear(duration: 22).repeatForever(autoreverses: false).delay(0.4)) {
                    sparkleSpin = 360
                }
                withAnimation(DesignSystem.Animation.twinkle.delay(0.5)) {
                    badgePulse = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showSparkles = true
            }
            scheduleCelebrationReading()
        }
        .onDisappear {
            readGeneration += 1
            speech.stop()
        }
        .overlay(alignment: .topTrailing) {
            ReadAloudButton(isSpeaking: speech.isSpeaking, accent: DesignSystem.Colors.warmOrange) {
                if speech.isSpeaking {
                    readGeneration += 1
                    speech.stop()
                } else {
                    readGeneration += 1
                    speech.speak(celebrationLines)
                }
            }
            .padding(.top, DesignSystem.Spacing.md)
            .padding(.trailing, DesignSystem.Spacing.lg)
        }
    }

    private var celebrationLines: [String] {
        var lines = ["Mission complete!", summary.completionHeadline]
        if summary.totalQuestions > 0 {
            lines.append("\(summary.correctAnswers) of \(summary.totalQuestions) correct.")
        }
        lines.append(nextLesson == nil
                     ? "Amazing work. Head home for more adventures!"
                     : "Want to keep exploring? Another adventure is ready!")
        return lines
    }

    private func scheduleCelebrationReading() {
        guard LessonSpeechReader.isEnabled else { return }
        guard !UIAccessibility.isVoiceOverRunning else { return }
        guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { return }
        readGeneration += 1
        let generation = readGeneration
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000)
            guard generation == readGeneration else { return }
            speech.speak(celebrationLines)
        }
    }

    @ViewBuilder
    private var nextAdventureSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            if let nextLesson {
                Button(action: onPlayAnother) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.22))
                                .frame(width: 72, height: 72)
                            TopicIllustrationView(topic: nextLesson.theme, size: 56, animate: true)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("PLAY ANOTHER!")
                                .font(DesignSystem.Typography.label(11))
                                .foregroundStyle(.white.opacity(0.88))
                                .tracking(0.6)
                            Text(nextLesson.title)
                                .font(DesignSystem.Typography.title(18))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            Text(TopicPalette.displayTitle(for: nextLesson.theme))
                                .font(DesignSystem.Typography.caption(13))
                                .foregroundStyle(.white.opacity(0.85))
                        }

                        Spacer(minLength: 0)

                        Image(systemName: "play.fill")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .idlePulse(scale: 1.12, delay: 0.2)
                    }
                    .padding(DesignSystem.Spacing.md)
                    .frame(minHeight: DesignSystem.Metrics.scaled(72))
                    .background(
                        LinearGradient(
                            colors: TopicPalette.gradientColors(for: nextLesson.theme),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
                    .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
                }
                .buttonStyle(.plain)

                SecondaryButton(title: "Home", icon: "house.fill", action: onGoHome)
            } else {
                PrimaryGradientButton(
                    title: "Back home",
                    icon: "house.fill",
                    action: onGoHome
                )
            }
        }
    }

    private func levelUpBanner(_ result: LessonRewardResult) -> some View {
        VStack(spacing: 8) {
            Text("New adventure rank!")
                .font(DesignSystem.Typography.title(24))
                .foregroundStyle(DesignSystem.Colors.sunshineYellow)
            Text("You’re now level \(result.newLevel)")
                .font(DesignSystem.Typography.sectionHeader(16))
                .foregroundStyle(DesignSystem.Colors.lavenderPurple)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(DesignSystem.Colors.deepNavy.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
    }

    private func unlocksRow(_ rewards: [AdventureReward]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("New unlocks")
                .font(DesignSystem.Typography.sectionHeader(15))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(rewards) { reward in
                        HomeRewardChip(reward: reward)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var heroSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    StarShape(points: 5)
                        .stroke(DesignSystem.Colors.sunshineYellow.opacity(0.3), lineWidth: 2)
                        .frame(width: 100 + CGFloat(i) * 20, height: 100 + CGFloat(i) * 20)
                        .rotationEffect(.degrees(Double(i) * 15 + badgeRotation + sparkleSpin * (i.isMultiple(of: 2) ? 1 : -0.7)))
                }

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [DesignSystem.Colors.sunshineYellow, DesignSystem.Colors.warmOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 96, height: 96)
                    .shadow(color: DesignSystem.Shadow.glow.color, radius: DesignSystem.Shadow.glow.radius)
                    .scaleEffect(badgePulse ? 1.06 : 1)

                Image(systemName: "star.fill")
                    .font(.padScaled(size: 44, weight: .bold))
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, value: showSparkles)
                    .scaleEffect(badgePulse ? 1.08 : 1)
            }
            .scaleEffect(badgeScale)
            .rotationEffect(.degrees(badgeRotation))

            VStack(spacing: DesignSystem.Spacing.sm) {
                Text("Mission Complete!")
                    .font(DesignSystem.Typography.label(12))
                    .foregroundStyle(DesignSystem.Colors.warmOrange)
                    .tracking(1.2)

                Text(summary.completionHeadline)
                    .font(DesignSystem.Typography.heroTitle)
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                Text(nextLesson == nil
                     ? "Amazing work — head home for more adventures!"
                     : "Want to keep exploring? Another adventure is ready!")
                    .font(DesignSystem.Typography.subtitle(16))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.top, DesignSystem.Spacing.md)
        .opacity(contentOpacity)
    }

    private var statsCard: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            if summary.totalQuestions > 0 {
                CompletionStatRow(
                    icon: "checkmark.seal.fill",
                    label: "Score",
                    value: "\(summary.correctAnswers) of \(summary.totalQuestions) correct",
                    accent: DesignSystem.Colors.freshGreen
                )

                Divider().overlay(DesignSystem.Colors.cardBorder)
            }

            CompletionStatRow(
                icon: "heart.fill",
                label: "Topic",
                value: summary.topicsPracticed.map { TopicPalette.displayTitle(for: $0) }.joined(separator: ", "),
                accent: DesignSystem.Colors.coralPink
            )
        }
        .sparkCard(elevated: true)
    }
}

private struct CompletionStatRow: View {
    let icon: String
    let label: String
    let value: String
    let accent: Color

    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(accent)
                .frame(width: 32)
                .symbolEffect(.bounce, value: value)
                .idlePulse(scale: 1.08, delay: 0.2)

            VStack(alignment: .leading, spacing: 4) {
                Text(label.uppercased())
                    .font(DesignSystem.Typography.label())
                    .foregroundStyle(accent)
                    .tracking(0.4)
                Text(value)
                    .font(DesignSystem.Typography.title(17))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}

#Preview {
    LessonCompletionView(
        summary: ProgressSummary(
            totalQuestions: 6,
            correctAnswers: 5,
            topicsPracticed: [.sharks],
            skillsPracticed: ["Reading", "Math"],
            lessonTitle: "Shark Explorer Practice"
        ),
        nextLesson: BundledLessons.sharkExplorer,
        onPlayAnother: {},
        onGoHome: {}
    )
}
