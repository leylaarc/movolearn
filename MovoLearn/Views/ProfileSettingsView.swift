import SwiftUI

struct ProfileSettingsView: View {
    let profile: ChildProfile
    let learningState: ChildLearningState
    let onSave: (ChildProfile) -> Void
    let onResetConfirmed: () -> Void
    let onClose: (() -> Void)?
    var onEditInterests: (() -> Void)? = nil
    var onOpenParentSummary: (() -> Void)? = nil
    var familyAccountEmail: String? = nil
    var onOpenFamilyAccount: (() -> Void)? = nil
    var onSignOutFamilyAccount: (() -> Void)? = nil
    var onDeleteFamilyAccount: (() -> Void)? = nil

    @State private var draft: ChildProfile
    @State private var showResetConfirm = false
    @State private var showDeleteAccountConfirm = false
    @State private var showAcknowledgements = false
    @State private var showPrivacy = false

    init(
        profile: ChildProfile,
        learningState: ChildLearningState,
        onSave: @escaping (ChildProfile) -> Void,
        onResetConfirmed: @escaping () -> Void,
        onClose: (() -> Void)? = nil,
        onEditInterests: (() -> Void)? = nil,
        onOpenParentSummary: (() -> Void)? = nil,
        familyAccountEmail: String? = nil,
        onOpenFamilyAccount: (() -> Void)? = nil,
        onSignOutFamilyAccount: (() -> Void)? = nil,
        onDeleteFamilyAccount: (() -> Void)? = nil
    ) {
        self.profile = profile
        self.learningState = learningState
        self.onSave = onSave
        self.onResetConfirmed = onResetConfirmed
        self.onClose = onClose
        self.onEditInterests = onEditInterests
        self.onOpenParentSummary = onOpenParentSummary
        self.familyAccountEmail = familyAccountEmail
        self.onOpenFamilyAccount = onOpenFamilyAccount
        self.onSignOutFamilyAccount = onSignOutFamilyAccount
        self.onDeleteFamilyAccount = onDeleteFamilyAccount
        _draft = State(initialValue: profile)
    }

    private var mascotTopic: Topic { draft.favoriteTopics.first ?? .space }

    var body: some View {
        ZStack {
            DesignSystem.Gradients.homeGradient
                .ignoresSafeArea()

            SoftBubbleAtmosphere(topic: mascotTopic, intensity: 0.75)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    KidScreenHeader(
                        title: "Profile",
                        subtitle: "Your explorer’s world, levels, and settings.",
                        mascotTopic: mascotTopic
                    )

                    identityCard
                    growthCard
                    if onOpenParentSummary != nil {
                        parentReportCard
                    }
                    if onOpenFamilyAccount != nil || familyAccountEmail != nil {
                        familyAccountCard
                    }
                    editCard

                    SecondaryButton(title: "Privacy", icon: "lock.shield") {
                        showPrivacy = true
                    }

                    SecondaryButton(title: "Acknowledgements", icon: "heart.text.square") {
                        showAcknowledgements = true
                    }

                    Button(role: .destructive) {
                        showResetConfirm = true
                    } label: {
                        Label("Reset Profile & Progress", systemImage: "trash")
                            .font(DesignSystem.Typography.sectionHeader(15))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(DesignSystem.Colors.coralPink.opacity(0.12))
                            .foregroundStyle(DesignSystem.Colors.coralPink)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    PrimaryGradientButton(title: "Save Profile", icon: "checkmark.circle.fill") {
                        var saved = draft
                        saved.touch()
                        onSave(saved)
                    }

                    if let onClose {
                        SecondaryButton(title: "Close", icon: "xmark.circle") {
                            onClose()
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
        }
        .alert("Reset everything?", isPresented: $showResetConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Reset Profile & Progress", role: .destructive) {
                onResetConfirmed()
            }
        } message: {
            Text("This permanently erases the saved child profile, lesson history, and learning progress on this device. This cannot be undone.")
        }
        .alert("Delete family account?", isPresented: $showDeleteAccountConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete Account", role: .destructive) {
                onDeleteFamilyAccount?()
            }
        } message: {
            Text("This deletes the parent account and all saved child learning data on our servers and this device.")
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyNoticeView()
        }
        .sheet(isPresented: $showAcknowledgements) {
            AcknowledgementsView()
        }
    }

    private var identityCard: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(draft.nickname.isEmpty ? "Your explorer" : draft.nickname)
                .font(DesignSystem.Typography.title(26))
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            Text("Age \(draft.currentAge) · \(AgeGradeLearningStandards.band(age: draft.currentAge).displayName) skills")
                .font(DesignSystem.Typography.subtitle(15))
                .foregroundStyle(DesignSystem.Colors.mutedText)

            HStack(spacing: DesignSystem.Spacing.sm) {
                SoftStatBubble(
                    title: "Reading",
                    value: draft.readingLevel.rawValue,
                    icon: "book.fill",
                    tint: DesignSystem.Colors.skyBlue
                )
                SoftStatBubble(
                    title: "Math",
                    value: draft.mathLevel.rawValue,
                    icon: "function",
                    tint: DesignSystem.Colors.lavenderPurple
                )
                SoftStatBubble(
                    title: "Streak",
                    value: "\(draft.currentLearningStreak)",
                    icon: "flame.fill",
                    tint: DesignSystem.Colors.warmOrange
                )
            }
        }
        .padding(DesignSystem.Spacing.cardPadding)
        .background(DesignSystem.Colors.cardWhite.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous)
                .stroke(DesignSystem.Colors.skyBlue.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: DesignSystem.Shadow.softShadow.color, radius: 12, y: 5)
    }

    private var growthCard: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HomeSectionTitle(
                title: "Favorite Worlds",
                actionTitle: onEditInterests == nil ? nil : "Edit",
                action: onEditInterests
            )

            if draft.favoriteTopics.isEmpty {
                Text("No favorites yet.")
                    .font(DesignSystem.Typography.subtitle(14))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        ForEach(Array(draft.favoriteTopics.prefix(8).enumerated()), id: \.element.id) { index, topic in
                            InterestCategoryCard(topic: topic, floatDelay: Double(index) * 0.1)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(DesignSystem.Spacing.cardPadding)
        .background(DesignSystem.Colors.cardWhite.opacity(0.84))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.xxl, style: .continuous)
                .stroke(DesignSystem.Colors.cardBorder, lineWidth: 1)
        )
    }

    private var parentReportCard: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("FOR PARENTS")
                .font(DesignSystem.Typography.label())
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .tracking(0.5)

            Text("Learning report")
                .font(DesignSystem.Typography.sectionHeader(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            Text("See how your explorer is doing — latest scores and recent lessons.")
                .font(DesignSystem.Typography.subtitle(14))
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .fixedSize(horizontal: false, vertical: true)

            SecondaryButton(title: "Open Learning Report", icon: "chart.line.uptrend.xyaxis") {
                onOpenParentSummary?()
            }
        }
        .sparkCard(accent: DesignSystem.Colors.skyBlue)
    }

    private var familyAccountCard: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("FAMILY ACCOUNT")
                .font(DesignSystem.Typography.label())
                .foregroundStyle(DesignSystem.Colors.textTertiary)
                .tracking(0.5)

            Text("Save across devices")
                .font(DesignSystem.Typography.sectionHeader(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            if let familyAccountEmail {
                Text("Signed in as \(familyAccountEmail). Profiles and lesson history stay with this parent account.")
                    .font(DesignSystem.Typography.subtitle(14))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
                    .fixedSize(horizontal: false, vertical: true)

                if let onSignOutFamilyAccount {
                    SecondaryButton(title: "Sign Out", icon: "rectangle.portrait.and.arrow.right") {
                        onSignOutFamilyAccount()
                    }
                }
                if onDeleteFamilyAccount != nil {
                    Button(role: .destructive) {
                        showDeleteAccountConfirm = true
                    } label: {
                        Label("Delete Family Account", systemImage: "person.crop.circle.badge.minus")
                            .font(DesignSystem.Typography.sectionHeader(15))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(DesignSystem.Colors.coralPink.opacity(0.12))
                            .foregroundStyle(DesignSystem.Colors.coralPink)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.xl, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text("Create a parent account to keep this child’s profile if you get a new phone.")
                    .font(DesignSystem.Typography.subtitle(14))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
                    .fixedSize(horizontal: false, vertical: true)

                if let onOpenFamilyAccount {
                    SecondaryButton(title: "Set Up Parent Account", icon: "icloud.and.arrow.up") {
                        onOpenFamilyAccount()
                    }
                }
            }
        }
        .sparkCard(accent: DesignSystem.Colors.lavenderPurple)
    }

    private var editCard: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Edit profile")
                .font(DesignSystem.Typography.sectionHeader(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            SparkInputCard(icon: "person.fill", title: "Name", accent: DesignSystem.Colors.coralPink) {
                TextField("Child's name", text: $draft.nickname)
                    .textFieldStyle(SparkTextFieldStyle())
            }

            SparkInputCard(icon: "birthday.cake.fill", title: "Age", accent: DesignSystem.Colors.sunshineYellow) {
                HStack {
                    Button {
                        if draft.storedAge > 4 {
                            draft.storedAge -= 1
                            draft.birthday = nil
                            draft.applyAgeBasedCurriculumDefaults()
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill").font(.title2)
                            .foregroundStyle(DesignSystem.Colors.sunshineYellow)
                    }
                    .frame(minWidth: 48, minHeight: 48)

                    Text("\(draft.currentAge) years old")
                        .font(DesignSystem.Typography.title(20))
                        .frame(maxWidth: .infinity)

                    Button {
                        if draft.storedAge < 12 {
                            draft.storedAge += 1
                            draft.birthday = nil
                            draft.applyAgeBasedCurriculumDefaults()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.title2)
                            .foregroundStyle(DesignSystem.Colors.sunshineYellow)
                    }
                    .frame(minWidth: 48, minHeight: 48)
                }
            }

            SparkInputCard(icon: "book.fill", title: "Reading level", accent: DesignSystem.Colors.freshGreen) {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(ReadingLevel.allCases) { level in
                        SelectableChip(title: level.rawValue, isSelected: draft.readingLevel == level, accent: DesignSystem.Colors.freshGreen) {
                            draft.readingLevel = level
                        }
                    }
                }
            }

            SparkInputCard(icon: "function", title: "Math level", accent: DesignSystem.Colors.brightLavender) {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(MathLevel.allCases) { level in
                        SelectableChip(title: level.rawValue, isSelected: draft.mathLevel == level, accent: DesignSystem.Colors.brightLavender) {
                            draft.mathLevel = level
                        }
                    }
                }
            }
        }
    }
}

struct AcknowledgementsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("Marble Skill Taxonomy")
                        .font(DesignSystem.Typography.title(22))
                    Text("Movo Learn uses the open Marble Skill Taxonomy (withmarbleapp/os-taxonomy) as a curriculum map for skills and prerequisites. Lesson stories and activities are original Movo Learn content.")
                        .font(DesignSystem.Typography.subtitle(15))
                        .foregroundStyle(DesignSystem.Colors.mutedText)
                    Text("License: Open Data Commons Open Database License (ODbL). See ThirdParty/Marble/LICENSE in the project repository.")
                        .font(DesignSystem.Typography.caption(13))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                    Text("Upstream: https://github.com/withmarbleapp/os-taxonomy")
                        .font(DesignSystem.Typography.caption(13))
                        .foregroundStyle(DesignSystem.Colors.skyBlue)
                }
                .padding()
            }
            .navigationTitle("Acknowledgements")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ProfileSettingsView(
        profile: ChildProfile(nickname: "Mia", favoriteTopics: [.space]),
        learningState: .empty(childId: UUID()),
        onSave: { _ in },
        onResetConfirmed: {},
        onClose: {}
    )
}
