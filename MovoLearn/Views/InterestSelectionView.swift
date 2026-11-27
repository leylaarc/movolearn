import SwiftUI

enum InterestSelectionMode {
    case onboarding
    case editing

    var primaryButtonTitle: String {
        switch self {
        case .onboarding: return "Start learning"
        case .editing: return "Save Interests"
        }
    }

    var primaryButtonIcon: String {
        switch self {
        case .onboarding: return "arrow.right.circle.fill"
        case .editing: return "checkmark.circle.fill"
        }
    }
}

struct InterestSelectionView: View {
    let childName: String
    var mode: InterestSelectionMode = .onboarding
    var initialTopics: [Topic] = []
    var onCancel: (() -> Void)? = nil
    let onContinue: ([Topic]) -> Void

    @State private var selectedTopics: Set<Topic> = []
    /// Preserves tap order so the first favorite is what the child chose first (not enum order).
    @State private var selectionOrder: [Topic] = []
    @State private var appeared = false

    private let topics = Topic.allCases

    var body: some View {
        ZStack {
            ZStack {
                if mode == .onboarding {
                    OnboardingBackdrop()
                } else {
                    ZStack {
                        DesignSystem.Gradients.homeGradient
                            .ignoresSafeArea()
                        SoftBubbleAtmosphere(
                            accent: DesignSystem.Colors.coralPink,
                            secondary: DesignSystem.Colors.sunshineYellow,
                            tertiary: DesignSystem.Colors.skyBlue,
                            intensity: 1.15
                        )
                    }
                }
            }

            VStack(spacing: 0) {
                if mode == .editing {
                    editToolbar
                } else {
                    onboardingToolbar
                }

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        headerCopy
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 12)

                        if mode == .editing {
                            CharacterBubble(
                                topic: .dinosaurs,
                                message: "Update \(childName)'s favorites anytime — new interests mean new adventures!",
                                animates: true
                            )
                        }

                        if !selectedTopics.isEmpty {
                            selectionCounter
                        }

                        topicGrid
                    }
                    .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
                    .padding(.top, DesignSystem.Spacing.sm)
                    .padding(.bottom, DesignSystem.Spacing.lg)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                continueBar
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if selectedTopics.isEmpty, !initialTopics.isEmpty {
                selectedTopics = Set(initialTopics)
                selectionOrder = initialTopics
            }
            withAnimation(DesignSystem.Animation.gentle.delay(0.1)) {
                appeared = true
            }
        }
    }

    private var headerCopy: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(mode == .editing ? "Update \(childName)'s interests" : "What does \(childName) love?")
                .font(DesignSystem.Typography.screenTitle)
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            Text(
                mode == .editing
                    ? "Children’s interests change. You can update these anytime."
                    : "Choose at least 3. Home and lessons follow these topics."
            )
            .font(DesignSystem.Typography.subtitle(16))
            .foregroundStyle(DesignSystem.Colors.mutedText)
            .lineSpacing(4)

            if mode == .editing {
                Text("Tap topics to add or remove them. Progress stays saved.")
                    .font(DesignSystem.Typography.captionText)
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
            }

            Button {
                surpriseMe()
            } label: {
                if mode == .onboarding {
                    Text("Surprise me")
                        .font(DesignSystem.Typography.sectionHeader(15))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .underline()
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.body.weight(.semibold))
                            .symbolEffect(.bounce, value: selectedTopics.count)
                        Text("Surprise me")
                            .font(DesignSystem.Typography.sectionHeader(15))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [DesignSystem.Colors.lavenderPurple, DesignSystem.Colors.coralPink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: DesignSystem.Colors.lavenderPurple.opacity(0.32), radius: 8, y: 3)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Surprise me with interest suggestions")
        }
    }

    private var onboardingToolbar: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Button {
                    onCancel?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                        Text("Back")
                            .font(DesignSystem.Typography.sectionHeader(15))
                    }
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back to learning levels")

                Spacer()

                Text("Step 4 of 4")
                    .font(DesignSystem.Typography.captionText)
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
            }

            HStack(spacing: 6) {
                ForEach(0..<4, id: \.self) { _ in
                    Capsule()
                        .fill(DesignSystem.Colors.deepNavy)
                        .frame(height: 4)
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
        .padding(.top, DesignSystem.Spacing.md)
        .padding(.bottom, DesignSystem.Spacing.xs)
    }

    private var editToolbar: some View {
        HStack {
            Button {
                onCancel?()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "xmark")
                        .font(.body.weight(.semibold))
                    Text("Cancel")
                        .font(DesignSystem.Typography.sectionHeader(15))
                }
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, 10)
                .background(DesignSystem.Colors.cardWhite.opacity(0.85))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(DesignSystem.Colors.cardBorder, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Cancel without saving interests")

            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
        .padding(.top, DesignSystem.Spacing.md)
    }

    /// Eager rows so every world stays in the scroll content and can be tapped.
    private var topicGrid: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            ForEach(Array(stride(from: 0, to: topics.count, by: 2)), id: \.self) { index in
                HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                    topicChoice(topics[index])
                    if index + 1 < topics.count {
                        topicChoice(topics[index + 1])
                    } else {
                        Color.clear
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func topicChoice(_ topic: Topic) -> some View {
        if mode == .onboarding {
            worldBubble(topic)
        } else {
            topicCard(topic)
        }
    }

    private func worldBubble(_ topic: Topic) -> some View {
        let selected = selectedTopics.contains(topic)
        let accent = TopicPalette.color(for: topic)
        return Button {
            toggle(topic)
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    accent.opacity(selected ? 1 : 0.88),
                                    accent.opacity(selected ? 0.72 : 0.5)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: DesignSystem.Metrics.scaled(92), height: DesignSystem.Metrics.scaled(92))

                    WorldBubbleMark(topic: topic, size: 56)
                }
                .overlay(alignment: .topTrailing) {
                    if selected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, DesignSystem.Colors.deepNavy)
                            .offset(x: 4, y: -4)
                    }
                }

                Text(TopicPalette.displayTitle(for: topic))
                    .font(DesignSystem.Typography.sectionHeader(14))
                    .foregroundStyle(selected ? DesignSystem.Colors.deepNavy : DesignSystem.Colors.deepNavy.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(minHeight: DesignSystem.Metrics.scaled(36), alignment: .top)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(TopicPalette.displayTitle(for: topic))\(selected ? ", selected" : "")")
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private func topicCard(_ topic: Topic) -> some View {
        TopicCard(
            topic: topic,
            isSelected: selectedTopics.contains(topic)
        ) {
            toggle(topic)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }

    private var selectionCounter: some View {
        Group {
            if mode == .onboarding {
                Text("\(selectedTopics.count) selected\(selectedTopics.count < 3 ? " · pick \(3 - selectedTopics.count) more" : "")")
                    .font(DesignSystem.Typography.subtitle(15))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
            } else {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "heart.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(DesignSystem.Colors.coralPink)
                        .symbolEffect(.bounce, value: selectedTopics.count)
                        .idlePulse(scale: 1.16)
                    Text("\(selectedTopics.count) topic\(selectedTopics.count == 1 ? "" : "s") selected\(selectedTopics.count < 3 ? " · pick \(3 - selectedTopics.count) more" : "")")
                        .font(DesignSystem.Typography.sectionHeader(14))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, 10)
                .background(DesignSystem.Colors.coralPink.opacity(0.10))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(DesignSystem.Colors.coralPink.opacity(0.25), lineWidth: 1.5))
                .shadow(color: DesignSystem.Colors.coralPink.opacity(0.12), radius: 6, y: 2)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .animation(DesignSystem.Animation.select, value: selectedTopics.count)
    }

    private var continueBar: some View {
        Group {
            if mode == .onboarding {
                OnboardingActionButton(
                    title: mode.primaryButtonTitle,
                    isEnabled: selectedTopics.count >= 3,
                    action: submitSelection
                )
                .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
                .padding(.bottom, DesignSystem.Spacing.sm)
            } else {
                VStack(spacing: 0) {
                    Divider()
                        .overlay(DesignSystem.Colors.cardBorder)

                    PrimaryGradientButton(
                        title: mode.primaryButtonTitle,
                        icon: mode.primaryButtonIcon,
                        isEnabled: selectedTopics.count >= 3,
                        action: submitSelection
                    )
                    .padding(DesignSystem.Spacing.screenHorizontal)
                    .padding(.top, DesignSystem.Spacing.md)
                    .padding(.bottom, DesignSystem.Spacing.sm)
                }
                .background(.ultraThinMaterial)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private func submitSelection() {
        var ordered = selectionOrder.filter { selectedTopics.contains($0) }
        for topic in initialTopics where selectedTopics.contains(topic) && !ordered.contains(topic) {
            ordered.append(topic)
        }
        for topic in topics where selectedTopics.contains(topic) && !ordered.contains(topic) {
            ordered.append(topic)
        }
        onContinue(ordered)
    }

    private func toggle(_ topic: Topic) {
        withAnimation(DesignSystem.Animation.select) {
            if selectedTopics.contains(topic) {
                selectedTopics.remove(topic)
                selectionOrder.removeAll { $0 == topic }
            } else {
                selectedTopics.insert(topic)
                if !selectionOrder.contains(topic) {
                    selectionOrder.append(topic)
                }
            }
        }
    }

    private func surpriseMe() {
        let popular: [Topic] = [
            .dinosaurs, .space, .sharks, .horses, .robots, .dogs, .art, .nature, .pirates, .volcanoes
        ]
        let picks = Array(popular.shuffled().prefix(4))
        withAnimation(DesignSystem.Animation.select) {
            selectedTopics = Set(picks)
            selectionOrder = picks
        }
    }
}

#Preview("Onboarding") {
    InterestSelectionView(
        childName: "Mia",
        onContinue: { _ in }
    )
}

#Preview("Editing") {
    InterestSelectionView(
        childName: "Mia",
        mode: .editing,
        initialTopics: [.horses, .sharks, .space],
        onCancel: {},
        onContinue: { _ in }
    )
}
