import SwiftUI

struct ParentSummaryView: View {
    let progress: UserProgress
    let latestSummary: ProgressSummary?
    let childName: String
    let onDone: () -> Void
    var onUpdateInterests: (() -> Void)? = nil

    private var safeName: String {
        let trimmed = childName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "your child" : trimmed
    }

    private var insights: ParentLearningInsights {
        ParentLearningInsights(
            childName: safeName,
            progress: progress,
            latestSummary: latestSummary
        )
    }

    var body: some View {
        ZStack {
            DesignSystem.Gradients.parentCalm
                .ignoresSafeArea()

            SoftBubbleAtmosphere(
                accent: DesignSystem.Colors.skyBlue,
                secondary: DesignSystem.Colors.freshGreen,
                tertiary: DesignSystem.Colors.lavenderPurple,
                intensity: 0.45,
                showsSparkles: false
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    headerSection

                    if progress.completedLessonCount == 0 {
                        emptyState
                    } else {
                        progressContent
                    }

                    if onUpdateInterests != nil {
                        updateInterestsCard
                    }

                    PrimaryGradientButton(title: "Done", icon: "checkmark.circle.fill", action: onDone)
                }
                .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
        }
    }

    private var updateInterestsCard: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("INTERESTS")
                .font(DesignSystem.Typography.label())
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .tracking(0.5)

            Text("You can update these anytime without resetting progress.")
                .font(DesignSystem.Typography.parentInsightText)
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .fixedSize(horizontal: false, vertical: true)

            SecondaryButton(title: "Update Interests", icon: "heart.text.square.fill") {
                onUpdateInterests?()
            }
        }
        .sparkCard(accent: DesignSystem.Colors.lavenderPurple)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text("Learning Report")
                        .font(DesignSystem.Typography.screenTitle)
                        .foregroundStyle(DesignSystem.Colors.deepNavy)

                    Text("A short record of \(safeName)’s practice")
                        .font(DesignSystem.Typography.parentInsightText)
                        .foregroundStyle(DesignSystem.Colors.mutedText)
                }
                Spacer()
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(DesignSystem.Colors.skyBlue.opacity(0.7))
            }
        }
    }

    private var emptyState: some View {
        EmptyStateCard(
            icon: "chart.line.uptrend.xyaxis",
            title: "No lessons yet",
            message: "Once \(safeName) completes a lesson, you’ll see scores and recent lessons here.",
            accent: DesignSystem.Colors.skyBlue
        )
    }

    private var progressContent: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            snapshotRow

            Text(insights.snapshotMessage)
                .font(DesignSystem.Typography.parentInsightText)
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let latestSummary {
                latestLessonCard(latestSummary)
            }

            recentLessonsCard
        }
    }

    private var snapshotRow: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            snapshotCard(
                icon: "checkmark.seal.fill",
                title: "Lessons",
                value: "\(progress.uniqueLessonCount)",
                subtitle: progress.completedLessonCount == progress.uniqueLessonCount
                    ? "completed"
                    : "\(progress.completedLessonCount) including repeats",
                accent: DesignSystem.Colors.skyBlue
            )
            snapshotCard(
                icon: "chart.bar.fill",
                title: "Accuracy",
                value: insights.accuracyDisplay,
                subtitle: insights.accuracySubtitle,
                accent: DesignSystem.Colors.brightLavender
            )
        }
    }

    private func snapshotCard(icon: String, title: String, value: String, subtitle: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(accent)

            Text(title.uppercased())
                .font(DesignSystem.Typography.label())
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .tracking(0.4)

            Text(value)
                .font(DesignSystem.Typography.headline(28))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .monospacedDigit()

            Text(subtitle)
                .font(DesignSystem.Typography.caption(11))
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sparkCard(padding: DesignSystem.Spacing.md, elevated: true, accent: accent)
    }

    private func latestLessonCard(_ summary: ProgressSummary) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(insights.latestLessonHeading.uppercased())
                .font(DesignSystem.Typography.label())
                .foregroundStyle(DesignSystem.Colors.skyBlue)
                .tracking(0.5)

            Text(summary.lessonTitle)
                .font(DesignSystem.Typography.title(18))
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            Text(formattedDate(summary.completedAt))
                .font(DesignSystem.Typography.caption(12))
                .foregroundStyle(DesignSystem.Colors.mutedText)

            if let topic = summary.topic {
                detailRow(icon: "heart.fill", label: "Topic", value: TopicPalette.displayTitle(for: topic))
            }

            detailRow(
                icon: summary.category.iconSystemName,
                label: "Type",
                value: summary.category.shortLabel
            )

            if summary.totalQuestions > 0 {
                detailRow(
                    icon: "checkmark.circle.fill",
                    label: "Score",
                    value: "\(summary.correctAnswers) of \(summary.totalQuestions) correct"
                )
            } else {
                detailRow(
                    icon: "paintbrush.fill",
                    label: "Score",
                    value: "Completed (no scored questions)"
                )
            }
        }
        .sparkCard(accent: DesignSystem.Colors.skyBlue)
    }

    private var recentLessonsCard: some View {
        let recent = Array(progress.completedLessons.suffix(5).reversed())
        return VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("RECENT LESSONS")
                .font(DesignSystem.Typography.label())
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .tracking(0.5)

            ForEach(recent) { record in
                HStack(alignment: .top, spacing: DesignSystem.Spacing.sm) {
                    TopicIllustrationView(topic: record.topic, size: 28, animate: false)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(record.lessonTitle)
                            .font(DesignSystem.Typography.body(15))
                            .foregroundStyle(DesignSystem.Colors.deepNavy)
                            .lineLimit(2)
                        Text(recentLessonSubtitle(record))
                            .font(DesignSystem.Typography.caption(12))
                            .foregroundStyle(DesignSystem.Colors.mutedText)
                    }
                    Spacer(minLength: 0)
                }
                if record.id != recent.last?.id {
                    Divider().overlay(DesignSystem.Colors.cardBorder)
                }
            }
        }
        .sparkCard()
    }

    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.skyBlue)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text(label.uppercased())
                    .font(DesignSystem.Typography.label(10))
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
                    .tracking(0.4)

                Text(value)
                    .font(DesignSystem.Typography.body(15))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func recentLessonSubtitle(_ record: LessonCompletionRecord) -> String {
        let topic = TopicPalette.displayTitle(for: record.topic)
        let score: String
        if record.totalQuestions > 0 {
            score = "\(record.correctAnswers) of \(record.totalQuestions) correct"
        } else {
            score = "Completed"
        }
        return "\(topic) · \(score) · \(formattedDate(record.completedAt))"
    }

    private func formattedDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today, \(date.formatted(date: .omitted, time: .shortened))"
        }
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday, \(date.formatted(date: .omitted, time: .shortened))"
        }
        return date.formatted(date: .abbreviated, time: .shortened)
    }
}

/// Launch-safe parent copy: recorded counts only, no inferred skills or advice.
struct ParentLearningInsights {
    let childName: String
    let progress: UserProgress
    let latestSummary: ProgressSummary?

    private var thisWeekCount: Int {
        progress.completions(inLastDays: 7).count
    }

    var latestLessonHeading: String {
        guard let date = latestSummary?.completedAt else { return "Latest lesson" }
        return Calendar.current.isDateInToday(date) ? "Today’s lesson" : "Latest lesson"
    }

    var accuracyDisplay: String {
        guard progress.totalQuestions > 0 else { return "—" }
        return "\(progress.accuracyPercentage)%"
    }

    var accuracySubtitle: String {
        if progress.totalQuestions == 0 {
            return "No scored questions yet"
        }
        return "\(progress.correctAnswers) of \(progress.totalQuestions) scored items"
    }

    var snapshotMessage: String {
        var parts: [String] = []

        if thisWeekCount > 0 {
            let lessonWord = thisWeekCount == 1 ? "lesson" : "lessons"
            parts.append("\(childName) finished \(thisWeekCount) \(lessonWord) in the last 7 days.")
        }

        if let latest = latestSummary, latest.totalQuestions > 0 {
            parts.append("Latest score: \(latest.correctAnswers) of \(latest.totalQuestions) correct.")
        } else if let latest = latestSummary, latest.totalQuestions == 0 {
            parts.append("The latest activity had no scored questions.")
        }

        if parts.isEmpty {
            return "Completed lessons will appear here."
        }
        return parts.joined(separator: " ")
    }
}

#Preview {
    let lesson = BundledLessons.sharkExplorer
    let summary = ProgressSummary(from: lesson, totalQuestions: 6, correctAnswers: 5)
    return ParentSummaryView(
        progress: UserProgress(completedLessons: [
            LessonCompletionRecord(summary: summary, lesson: lesson)
        ]),
        latestSummary: summary,
        childName: "Mia",
        onDone: {},
        onUpdateInterests: {}
    )
}
