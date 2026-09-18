import SwiftUI

enum InterestSelectionMode {
    case onboarding
    case editing

    var primaryButtonTitle: String {
        switch self {
        case .onboarding: return "Continue"
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
    private let columns = [
        GridItem(.flexible(), spacing: DesignSystem.Spacing.md),
        GridItem(.flexible(), spacing: DesignSystem.Spacing.md)
    ]

    var body: some View {
        ZStack {
            DesignSystem.Gradients.homeGradient
                .ignoresSafeArea()

            SoftBubbleAtmosphere(
                accent: DesignSystem.Colors.coralPink,
                secondary: DesignSystem.Colors.sunshineYellow,
                tertiary: DesignSystem.Colors.skyBlue,
                intensity: 1.15
            )

            VStack(spacing: 0) {
                if mode == .editing {
                    editToolbar
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        headerCopy
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 12)

                        CharacterBubble(
                            topic: .dinosaurs,
                            message: mode == .editing
                                ? "Update \(childName)'s favorites anytime — new interests mean new adventures!"
                                : "Pick the topics that make \(childName) light up — we'll build adventures around them!",
                            animates: true
                        )

                        if !selectedTopics.isEmpty {
                            selectionCounter
                        }

                        LazyVGrid(columns: columns, spacing: DesignSystem.Spacing.md) {
                            ForEach(topics) { topic in
                                TopicCard(
                                    topic: topic,
                                    isSelected: selectedTopics.contains(topic)
                                ) {
                                    toggle(topic)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.screenHorizontal)
                    .padding(.top, mode == .editing ? DesignSystem.Spacing.sm : DesignSystem.Spacing.lg)
                    .padding(.bottom, DesignSystem.Spacing.md)
                }

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
            Text(mode == .editing ? "Update \(childName)'s interests" : "What would you like to learn about?")
                .font(DesignSystem.Typography.screenTitle)
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            Text(
                mode == .editing
                    ? "Children’s interests change. You can update these anytime."
                    : "Pick at least 3 favorites. We’ll personalize the home page around them."
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
            .buttonStyle(.plain)
            .accessibilityLabel("Surprise me with interest suggestions")
        }
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

    private var selectionCounter: some View {
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
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .animation(DesignSystem.Animation.select, value: selectedTopics.count)
    }

    private var continueBar: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(DesignSystem.Colors.cardBorder)

            PrimaryGradientButton(
                title: mode.primaryButtonTitle,
                icon: mode.primaryButtonIcon,
                isEnabled: selectedTopics.count >= 3,
                action: {
                    // Prefer tap order; fall back to initial/edit order, then enum order.
                    var ordered = selectionOrder.filter { selectedTopics.contains($0) }
                    for topic in initialTopics where selectedTopics.contains(topic) && !ordered.contains(topic) {
                        ordered.append(topic)
                    }
                    for topic in topics where selectedTopics.contains(topic) && !ordered.contains(topic) {
                        ordered.append(topic)
                    }
                    onContinue(ordered)
                }
            )
            .padding(DesignSystem.Spacing.screenHorizontal)
            .padding(.vertical, DesignSystem.Spacing.md)
        }
        .background(.ultraThinMaterial)
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
