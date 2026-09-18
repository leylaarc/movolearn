import SwiftUI

struct ChildProfileSetupView: View {
    let initialProfile: ChildProfile
    let onContinue: (ChildProfile) -> Void

    @State private var profile: ChildProfile
    @State private var appeared = false

    init(initialProfile: ChildProfile, onContinue: @escaping (ChildProfile) -> Void) {
        self.initialProfile = initialProfile
        self.onContinue = onContinue
        _profile = State(initialValue: initialProfile)
    }

    var isValid: Bool {
        !profile.nickname.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            DesignSystem.Gradients.homeGradient
                .ignoresSafeArea()

            SoftBubbleAtmosphere(
                accent: DesignSystem.Colors.skyBlue,
                secondary: DesignSystem.Colors.coralPink,
                tertiary: DesignSystem.Colors.sunshineYellow,
                intensity: 1.12
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    KidScreenHeader(
                        title: "Meet your explorer",
                        subtitle: "Tell us a little about them — we’ll build adventures just for them.",
                        mascotTopic: .space
                    )
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)

                    CharacterBubble(
                        topic: .space,
                        message: "Hi! Tell us a little about your learner so we can pick the perfect adventures.",
                        animates: true
                    )
                    .opacity(appeared ? 1 : 0)

                    VStack(spacing: DesignSystem.Spacing.md) {
                        SparkInputCard(icon: "person.fill", title: "Child's name", accent: DesignSystem.Colors.coralPink) {
                            TextField("e.g. Mia", text: $profile.nickname)
                                .textFieldStyle(SparkTextFieldStyle())
                        }

                        SparkInputCard(icon: "birthday.cake.fill", title: "Age", accent: DesignSystem.Colors.sunshineYellow) {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                HStack {
                                    Button {
                                        if profile.storedAge > 4 {
                                            profile.storedAge -= 1
                                            profile.birthday = nil
                                            applyAgeBasedDefaults(to: &profile)
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundStyle(DesignSystem.Colors.sunshineYellow)
                                            .symbolEffect(.bounce, value: profile.currentAge)
                                    }
                                    .frame(minWidth: 48, minHeight: 48)

                                    Text("\(profile.currentAge) years old")
                                        .font(DesignSystem.Typography.title(22))
                                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                                        .frame(maxWidth: .infinity)
                                        .contentTransition(.numericText())
                                        .animation(DesignSystem.Animation.bounce, value: profile.currentAge)

                                    Button {
                                        if profile.storedAge < 10 {
                                            profile.storedAge += 1
                                            profile.birthday = nil
                                            applyAgeBasedDefaults(to: &profile)
                                        }
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundStyle(DesignSystem.Colors.sunshineYellow)
                                            .symbolEffect(.bounce, value: profile.currentAge)
                                    }
                                    .frame(minWidth: 48, minHeight: 48)
                                }
                                .padding(.horizontal, DesignSystem.Spacing.md)
                                .padding(.vertical, 12)
                                .background(DesignSystem.Colors.backgroundCream)
                                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous))

                                Text("Used only on this device to match lesson difficulty.")
                                    .font(DesignSystem.Typography.caption(13))
                                    .foregroundStyle(DesignSystem.Colors.mutedText)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        SparkInputCard(icon: "book.fill", title: "Reading level", accent: DesignSystem.Colors.freshGreen) {
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ForEach(ReadingLevel.allCases) { level in
                                    SelectableChip(
                                        title: level.rawValue,
                                        isSelected: profile.readingLevel == level,
                                        accent: DesignSystem.Colors.freshGreen
                                    ) {
                                        profile.readingLevel = level
                                    }
                                }
                            }
                        }

                        SparkInputCard(icon: "function", title: "Math level", accent: DesignSystem.Colors.skyBlue) {
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ForEach(MathLevel.allCases) { level in
                                    SelectableChip(
                                        title: level.rawValue,
                                        isSelected: profile.mathLevel == level,
                                        accent: DesignSystem.Colors.skyBlue
                                    ) {
                                        profile.mathLevel = level
                                    }
                                }
                            }
                        }

                        SparkInputCard(icon: "target", title: "Main learning goal", accent: DesignSystem.Colors.brightLavender) {
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ForEach(LearningGoal.allCases) { goal in
                                    SelectableChip(
                                        title: goal.rawValue,
                                        isSelected: profile.learningGoal == goal,
                                        accent: DesignSystem.Colors.brightLavender
                                    ) {
                                        profile.learningGoal = goal
                                    }
                                }
                            }
                        }
                    }

                    PrimaryGradientButton(
                        title: "Continue",
                        icon: "arrow.right.circle.fill",
                        isEnabled: isValid,
                        action: { onContinue(profile) }
                    )
                    .padding(.top, DesignSystem.Spacing.sm)
                }
                .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.gentle.delay(0.1)) {
                appeared = true
            }
        }
    }

    /// Keeps reading and math starting points on the age curriculum.
    /// Parents can still lower a chip; raising one will not exceed the age ceiling in lessons.
    private func applyAgeBasedDefaults(to profile: inout ChildProfile) {
        profile.applyAgeBasedCurriculumDefaults()
    }
}

#Preview {
    ChildProfileSetupView(
        initialProfile: ChildProfile(),
        onContinue: { _ in }
    )
}
