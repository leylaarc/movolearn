import SwiftUI

enum ChildProfileSetupStep: Int, CaseIterable {
    case name
    case age
    case levels

    var index: Int { rawValue }

    var title: String {
        switch self {
        case .name: return "What should we call them?"
        case .age: return "How old are they?"
        case .levels: return "Where should we start?"
        }
    }

    var subtitle: String {
        switch self {
        case .name:
            return "A first name or nickname is enough. Lessons will greet them by this name."
        case .age:
            return "Age sets a starting point for lessons. You can fine-tune reading and math next."
        case .levels:
            return "Pick the closest fit. These can be changed later in Profile."
        }
    }
}

struct ChildProfileSetupView: View {
    let initialProfile: ChildProfile
    var initialStep: ChildProfileSetupStep = .name
    var onBackToPreviousScreen: (() -> Void)? = nil
    let onContinue: (ChildProfile) -> Void

    @State private var profile: ChildProfile
    @State private var step: ChildProfileSetupStep
    @State private var levelsAdjusted: Bool
    @FocusState private var nameFocused: Bool

    private let ages = Array(4...10)

    init(
        initialProfile: ChildProfile,
        initialStep: ChildProfileSetupStep = .name,
        onBackToPreviousScreen: (() -> Void)? = nil,
        onContinue: @escaping (ChildProfile) -> Void
    ) {
        self.initialProfile = initialProfile
        self.initialStep = initialStep
        self.onBackToPreviousScreen = onBackToPreviousScreen
        self.onContinue = onContinue
        _profile = State(initialValue: initialProfile)
        _step = State(initialValue: initialStep)
        _levelsAdjusted = State(initialValue: initialStep == .levels)
    }

    private var canContinue: Bool {
        switch step {
        case .name:
            return !profile.nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .age, .levels:
            return true
        }
    }

    var body: some View {
        ZStack {
            OnboardingBackdrop()

            VStack(spacing: 0) {
                progressHeader

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            Text(step.title)
                                .font(DesignSystem.Typography.screenTitle)
                                .foregroundStyle(DesignSystem.Colors.deepNavy)
                                .fixedSize(horizontal: false, vertical: true)

                            Text(step.subtitle)
                                .font(DesignSystem.Typography.subtitle(16))
                                .foregroundStyle(DesignSystem.Colors.mutedText)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        stepContent
                    }
                    .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
                    .padding(.top, DesignSystem.Spacing.md)
                    .padding(.bottom, DesignSystem.Spacing.xl)
                    .id(step)
                }

                footer
            }
        }
        .onAppear {
            if step == .name {
                nameFocused = true
            }
        }
    }

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Button(action: goBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                        Text("Back")
                            .font(DesignSystem.Typography.sectionHeader(15))
                    }
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(step == .name ? "Back to welcome" : "Back")

                Spacer()

                Text("Step \(step.index + 1) of \(ChildProfileSetupStep.allCases.count + 1)")
                    .font(DesignSystem.Typography.captionText)
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
            }

            HStack(spacing: 6) {
                ForEach(0..<(ChildProfileSetupStep.allCases.count + 1), id: \.self) { index in
                    Capsule()
                        .fill(index <= step.index ? DesignSystem.Colors.deepNavy : DesignSystem.Colors.deepNavy.opacity(0.12))
                        .frame(height: 4)
                }
            }
            .accessibilityLabel("Step \(step.index + 1) of \(ChildProfileSetupStep.allCases.count + 1)")
        }
        .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
        .padding(.top, DesignSystem.Spacing.md)
        .padding(.bottom, DesignSystem.Spacing.sm)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case .name:
            nameStep
        case .age:
            ageStep
        case .levels:
            levelsStep
        }
    }

    private var nameStep: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            TextField("e.g. Mia", text: $profile.nickname)
                .font(DesignSystem.Typography.title(22))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .tint(DesignSystem.Colors.deepNavy)
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.next)
                .focused($nameFocused)
                .onSubmit(advance)
                .padding(.vertical, 12)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(DesignSystem.Colors.deepNavy.opacity(0.16))
                        .frame(height: 1)
                }

            Text("Only stored on this device.")
                .font(DesignSystem.Typography.caption(13))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
        }
    }

    private var ageStep: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                ForEach(ages, id: \.self) { age in
                    let selected = profile.currentAge == age
                    Button {
                        selectAge(age)
                    } label: {
                        Text("\(age)")
                            .font(DesignSystem.Typography.title(22))
                            .foregroundStyle(selected ? DesignSystem.Colors.deepNavy : DesignSystem.Colors.deepNavy.opacity(0.38))
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 56)
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .fill(selected ? DesignSystem.Colors.deepNavy : DesignSystem.Colors.deepNavy.opacity(0.12))
                                    .frame(height: selected ? 2 : 1)
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(age) years old")
                    .accessibilityAddTraits(selected ? .isSelected : [])
                }
            }

            Text("\(profile.currentAge) years old. Lessons are written for ages 5–8.")
                .font(DesignSystem.Typography.subtitle(15))
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var levelsStep: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            levelGroup(
                title: "Reading",
                footnote: "How they handle words and short passages."
            ) {
                ForEach(ReadingLevel.allCases) { level in
                    OnboardingChoiceRow(
                        title: level.rawValue,
                        detail: level.parentDetail,
                        isSelected: profile.readingLevel == level
                    ) {
                        levelsAdjusted = true
                        profile.readingLevel = level
                    }
                }
            }

            levelGroup(
                title: "Math",
                footnote: "How comfortable they are with numbers."
            ) {
                ForEach(MathLevel.allCases) { level in
                    OnboardingChoiceRow(
                        title: level.rawValue,
                        detail: level.parentDetail,
                        isSelected: profile.mathLevel == level
                    ) {
                        levelsAdjusted = true
                        profile.mathLevel = level
                    }
                }
            }

            levelGroup(
                title: "Practice",
                footnote: "What to give a little more room to."
            ) {
                ForEach(LearningGoal.allCases) { goal in
                    OnboardingChoiceRow(
                        title: goal.rawValue,
                        detail: goal.parentDetail,
                        isSelected: profile.learningGoal == goal
                    ) {
                        levelsAdjusted = true
                        profile.learningGoal = goal
                    }
                }
            }
        }
    }

    private func levelGroup<Content: View>(
        title: String,
        footnote: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(DesignSystem.Typography.sectionHeader(26))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
            Text(footnote)
                .font(DesignSystem.Typography.caption(13))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
            VStack(spacing: 8) {
                content()
            }
        }
    }

    private var footer: some View {
        OnboardingActionButton(
            title: step == .levels ? "Choose interests" : "Continue",
            isEnabled: canContinue,
            action: advance
        )
        .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
        .padding(.top, DesignSystem.Spacing.sm)
        .padding(.bottom, DesignSystem.Spacing.sm)
    }

    private func selectAge(_ age: Int) {
        guard profile.storedAge != age || profile.birthday != nil else { return }
        profile.storedAge = age
        profile.birthday = nil
        profile.applyAgeBasedCurriculumDefaults()
        levelsAdjusted = false
    }

    private func goBack() {
        nameFocused = false
        guard let previous = ChildProfileSetupStep(rawValue: step.rawValue - 1) else {
            onBackToPreviousScreen?()
            return
        }
        withAnimation(DesignSystem.Animation.gentle) {
            step = previous
        }
    }

    private func advance() {
        guard canContinue else { return }
        nameFocused = false
        profile.nickname = profile.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        if step == .age, !levelsAdjusted {
            profile.applyAgeBasedCurriculumDefaults()
        }
        if let next = ChildProfileSetupStep(rawValue: step.rawValue + 1) {
            withAnimation(DesignSystem.Animation.gentle) {
                step = next
            }
            return
        }
        onContinue(profile)
    }
}

private struct OnboardingChoiceRow: View {
    let title: String
    let detail: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(DesignSystem.Typography.title(16))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                    Text(detail)
                        .font(DesignSystem.Typography.caption(13))
                        .foregroundStyle(DesignSystem.Colors.mutedText)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.body.weight(.bold))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                }
            }
            .padding(.vertical, 12)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(isSelected ? DesignSystem.Colors.deepNavy : DesignSystem.Colors.deepNavy.opacity(0.12))
                    .frame(height: isSelected ? 2 : 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct OnboardingBackdrop: View {
    var body: some View {
        ZStack {
            DesignSystem.Colors.lessonCream
                .ignoresSafeArea()
            DesignSystem.Gradients.homeGradient
                .opacity(0.42)
                .ignoresSafeArea()
            SoftBubbleAtmosphere(
                accent: DesignSystem.Colors.skyBlue,
                secondary: DesignSystem.Colors.sunshineYellow,
                tertiary: DesignSystem.Colors.lavenderPurple,
                intensity: 0.55,
                showsSparkles: false
            )
        }
        .allowsHitTesting(false)
    }
}

struct OnboardingActionButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                Image(systemName: "chevron.right")
                    .font(.body.weight(.bold))
            }
            .font(DesignSystem.Typography.sectionHeader(18))
            .foregroundStyle(DesignSystem.Colors.deepNavy.opacity(isEnabled ? 1 : 0.32))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityLabel(title)
    }
}

#Preview {
    ChildProfileSetupView(
        initialProfile: ChildProfile(),
        onContinue: { _ in }
    )
}
