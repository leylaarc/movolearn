import SwiftUI

/// Parent-facing Launch privacy policy. Copy lives in `PrivacyPolicyCopy`.
struct PrivacyNoticeView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text(PrivacyPolicyCopy.headline)
                            .font(DesignSystem.Typography.headline(24))
                            .foregroundStyle(DesignSystem.Colors.deepNavy)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(PrivacyPolicyCopy.summary)
                            .font(DesignSystem.Typography.subtitle(16))
                            .foregroundStyle(DesignSystem.Colors.deepNavy)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Effective \(PrivacyPolicyCopy.effectiveDate) · Last updated \(PrivacyPolicyCopy.lastUpdated)")
                            .font(DesignSystem.Typography.caption(13))
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                    }

                    ForEach(Array(PrivacyPolicyCopy.snapshotCards.enumerated()), id: \.offset) { _, card in
                        noticeCard(title: card.title, body: card.body)
                    }

                    Text("Full policy")
                        .font(DesignSystem.Typography.sectionHeader(18))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .padding(.top, DesignSystem.Spacing.sm)

                    ForEach(PrivacyPolicyCopy.fullSections) { section in
                        noticeCard(title: section.title, body: section.body)
                    }

                    Text("Published at \(PrivacyPolicyCopy.publicURLString)")
                        .font(DesignSystem.Typography.caption(13))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                        .textSelection(.enabled)
                }
                .padding(.horizontal, DesignSystem.Spacing.screenPadding)
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.backgroundCream)
            .navigationTitle(PrivacyPolicyCopy.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func noticeCard(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(DesignSystem.Typography.sectionHeader(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
            Text(body)
                .font(DesignSystem.Typography.subtitle(14))
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)
        }
        .sparkCard(accent: DesignSystem.Colors.skyBlue)
    }
}

#Preview {
    PrivacyNoticeView()
}
