import SwiftUI

struct ProgressHubView: View {
    let profile: ChildProfile
    let progress: UserProgress
    let completions: [LessonCompletionRecord]
    let learningState: ChildLearningState
    let onStartLesson: (Lesson) -> Void

    @State private var appeared = false

    private var streak: Int { profile.currentLearningStreak }

    var body: some View {
        ZStack {
            DesignSystem.Gradients.homeGradient
                .ignoresSafeArea()

            SoftBubbleAtmosphere(
                accent: DesignSystem.Colors.freshGreen,
                secondary: DesignSystem.Colors.skyBlue,
                tertiary: DesignSystem.Colors.sunshineYellow,
                intensity: 0.9
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
                    KidScreenHeader(
                        title: "Progress",
                        subtitle: "See what you’ve learned and what’s growing stronger.",
                        mascotTopic: profile.favoriteTopics.first ?? .space
                    )
                    .entrance(appeared: appeared)

                    statsRow
                        .entrance(appeared: appeared, delay: 0.05)

                    if !completions.isEmpty {
                        recentSection
                            .entrance(appeared: appeared, delay: 0.1)
                    } else {
                        EmptyStateCard(
                            icon: "flag.checkered",
                            title: "No lessons yet",
                            message: "Finish a lesson and your progress will show up here.",
                            accent: DesignSystem.Colors.warmOrange
                        )
                        .entrance(appeared: appeared, delay: 0.1)
                    }

                    skillsSection
                        .entrance(appeared: appeared, delay: 0.14)
                }
                .padding(.horizontal, DesignSystem.Spacing.screenPadding)
                .padding(.top, DesignSystem.Spacing.md)
                .padding(.bottom, DesignSystem.Spacing.xxl)
            }
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.gentle) { appeared = true }
        }
    }

    private var statsRow: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            SoftStatBubble(
                title: "Lessons",
                value: "\(progress.completedLessonCount)",
                icon: "checkmark.circle.fill",
                tint: DesignSystem.Colors.freshGreen,
                floatDelay: 0
            )
            SoftStatBubble(
                title: "Streak",
                value: "\(streak)",
                icon: "flame.fill",
                tint: DesignSystem.Colors.warmOrange,
                floatDelay: 0.15
            )
            SoftStatBubble(
                title: "Worlds",
                value: "\(Set(completions.map(\.topic)).count)",
                icon: "sparkles",
                tint: DesignSystem.Colors.lavenderPurple,
                floatDelay: 0.3
            )
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HomeSectionTitle(title: "Recently Completed")
            ForEach(Array(completions.suffix(8).reversed())) { record in
                let lesson = LessonLoader.lesson(id: record.lessonId)
                Button {
                    if let lesson { onStartLesson(lesson) }
                } label: {
                    HStack(spacing: 12) {
                        if let lesson {
                            TopicIllustrationView(topic: lesson.theme, size: 36, animate: false)
                        } else {
                            Image(systemName: "book.fill")
                                .foregroundStyle(DesignSystem.Colors.skyBlue)
                                .frame(width: 36, height: 36)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(lesson?.title ?? record.topic.rawValue)
                                .font(DesignSystem.Typography.sectionHeader(15))
                                .foregroundStyle(DesignSystem.Colors.deepNavy)
                                .lineLimit(1)
                            Text("\(record.topic.rawValue) · \(Int(record.accuracy * 100))% correct")
                                .font(DesignSystem.Typography.caption(12))
                                .foregroundStyle(DesignSystem.Colors.mutedText)
                        }

                        Spacer()
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                    }
                    .padding(14)
                    .background(DesignSystem.Colors.cardWhite)
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous)
                            .stroke(DesignSystem.Colors.cardBorder, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                .disabled(lesson == nil)
            }
        }
    }

    private var skillsSection: some View {
        let developing = learningState.skillProgress.filter {
            $0.status == .practicing || $0.status == .developing || $0.status == .needsReview
        }.prefix(6)
        let mastered = learningState.skillProgress.filter { $0.status == .mastered }.prefix(4)

        return VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HomeSectionTitle(title: "Skills")
            if developing.isEmpty && mastered.isEmpty {
                Text("Skill badges appear as you practice.")
                    .font(DesignSystem.Typography.subtitle(14))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
            } else {
                if !developing.isEmpty {
                    Text("Growing now")
                        .font(DesignSystem.Typography.caption(12))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                    ForEach(Array(developing)) { skill in
                        skillRow(skill)
                    }
                }
                if !mastered.isEmpty {
                    Text("Feeling confident")
                        .font(DesignSystem.Typography.caption(12))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                        .padding(.top, 4)
                    ForEach(Array(mastered)) { skill in
                        skillRow(skill)
                    }
                }
            }
        }
    }

    private func skillRow(_ skill: ChildSkillProgress) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(skill.displayTitle)
                    .font(DesignSystem.Typography.sectionHeader(14))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                Text(skill.status.childFriendlyLabel)
                    .font(DesignSystem.Typography.caption(12))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
            }
            Spacer()
            Text("\(Int(skill.masteryScore))%")
                .font(DesignSystem.Typography.caption(12))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
        }
        .padding(12)
        .background(DesignSystem.Colors.cardWhite.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous))
    }
}

struct ProgressStatCard: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color
    var floatDelay: Double = 0

    var body: some View {
        SoftStatBubble(
            title: title,
            value: value,
            icon: icon,
            tint: tint,
            floatDelay: floatDelay
        )
    }
}

private extension ChildSkillProgress {
    var displayTitle: String {
        // Prefer humanized topic id when Marble title isn't loaded in this view.
        marbleTopicId
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
    }
}
