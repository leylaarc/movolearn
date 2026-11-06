import SwiftUI

// MARK: - Home and catalog cards

struct PlayGameCard: View {
    let offer: PlayGameOffer
    var style: Style = .tile
    let onStart: () -> Void

    enum Style {
        case tile
        case row
    }

    private var accent: Color { TopicPalette.color(for: offer.lesson.theme) }

    var body: some View {
        Button(action: onStart) {
            switch style {
            case .tile:
                tile
            case .row:
                row
            }
        }
        .buttonStyle(BouncyCardButtonStyle())
        .accessibilityLabel("\(offer.practiceLabel), \(offer.lesson.title)")
        .accessibilityHint(offer.kind.howToPlay)
    }

    private var tile: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [accent.opacity(0.95), accent.opacity(0.55)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: DesignSystem.Metrics.scaled(72), height: DesignSystem.Metrics.scaled(72))
                TopicIllustrationView(topic: offer.lesson.theme, size: 46, animate: true)
            }
            .frame(maxWidth: .infinity)

            Text(offer.practiceLabel)
                .font(DesignSystem.Typography.caption(12).weight(.bold))
                .foregroundStyle(accent)

            Text(offer.lesson.title)
                .font(DesignSystem.Typography.sectionHeader(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(TopicPalette.displayTitle(for: offer.lesson.theme))
                .font(DesignSystem.Typography.caption(12))
                .foregroundStyle(DesignSystem.Colors.mutedText)
                .lineLimit(1)
        }
        .padding(DesignSystem.Spacing.md)
        .frame(width: DesignSystem.Metrics.scaled(176), alignment: .leading)
        .background(DesignSystem.Colors.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
        .shadow(color: accent.opacity(0.2), radius: 10, y: 5)
    }

    private var row: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [accent.opacity(0.95), accent.opacity(0.55)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: DesignSystem.Metrics.scaled(68), height: DesignSystem.Metrics.scaled(68))
                TopicIllustrationView(topic: offer.lesson.theme, size: 42, animate: true)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(offer.practiceLabel)
                    .font(DesignSystem.Typography.caption(12).weight(.bold))
                    .foregroundStyle(accent)
                Text(offer.lesson.title)
                    .font(DesignSystem.Typography.sectionHeader(16))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Text(TopicPalette.displayTitle(for: offer.lesson.theme))
                    .font(DesignSystem.Typography.caption(12))
                    .foregroundStyle(DesignSystem.Colors.mutedText)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            Image(systemName: "play.circle.fill")
                .font(.title2)
                .foregroundStyle(accent)
                .idlePulse(scale: 1.08)
        }
        .padding(DesignSystem.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignSystem.Colors.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg, style: .continuous))
        .shadow(color: accent.opacity(0.16), radius: 8, y: 3)
    }
}

struct PlayRoundIntro: View {
    let topic: Topic
    let kind: PlayGameKind
    let lessonTitle: String

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            MascotView(topic: topic, size: 120, animates: true)
                .idlePulse(scale: 1.04)

            Text(lessonTitle)
                .font(DesignSystem.Typography.title(22))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .multilineTextAlignment(.center)

            Text(kind.howToPlay)
                .font(DesignSystem.Typography.title(18))
                .foregroundStyle(DesignSystem.Colors.deepNavy.opacity(0.82))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Bubble pop

struct BubblePopGameView: View {
    let choices: [String]
    let correctAnswer: String?
    let accent: Color
    var showFeedback: Bool
    var isAnswerCorrect: Bool
    var selectedChoice: String?
    var onSelect: (String) -> Void

    private let palette: [Color] = [
        DesignSystem.Colors.coralPink,
        DesignSystem.Colors.oceanTurquoise,
        DesignSystem.Colors.sunshineYellow,
        DesignSystem.Colors.lavenderPurple
    ]

    private var compact: Bool {
        choices.allSatisfy { $0.count <= 4 }
    }

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Text("Tap the right answer.")
                .font(DesignSystem.Typography.caption(14).weight(.semibold))
                .foregroundStyle(accent)
                .frame(maxWidth: .infinity, alignment: .leading)

            if compact {
                HStack(spacing: 12) {
                    ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                        bubble(choice, index: index)
                    }
                }
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                        bubble(choice, index: index)
                    }
                }
            }
        }
    }

    private func bubble(_ choice: String, index: Int) -> some View {
        let fill = palette[index % palette.count]
        let ink: Color = index % palette.count == 2 ? DesignSystem.Colors.deepNavy : .white
        let isCorrect = showFeedback && choice == correctAnswer
        let isIncorrect = showFeedback && selectedChoice == choice && !isAnswerCorrect

        return Button {
            onSelect(choice)
        } label: {
            Text(choice)
                .font(compact ? DesignSystem.Typography.headline(32) : DesignSystem.Typography.title(18))
                .foregroundStyle(ink)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, compact ? 8 : 16)
                .frame(maxWidth: compact ? DesignSystem.Metrics.scaled(96) : .infinity)
                .frame(
                    minWidth: compact ? DesignSystem.Metrics.scaled(84) : nil,
                    minHeight: compact ? DesignSystem.Metrics.scaled(84) : DesignSystem.Metrics.scaled(72)
                )
                .background {
                    RoundedRectangle(cornerRadius: compact ? DesignSystem.Metrics.scaled(42) : DesignSystem.Metrics.scaled(28), style: .continuous)
                        .fill(fill)
                        .shadow(color: fill.opacity(0.35), radius: isCorrect ? 12 : 6, y: 4)
                }
                .overlay {
                    if isCorrect {
                        Image(systemName: "star.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(Circle().fill(DesignSystem.Colors.freshGreen))
                            .offset(x: 28, y: -28)
                            .symbolEffect(.bounce, value: isCorrect)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: compact ? DesignSystem.Metrics.scaled(42) : DesignSystem.Metrics.scaled(28), style: .continuous)
                        .stroke(isCorrect ? DesignSystem.Colors.freshGreen : Color.white.opacity(0.35), lineWidth: isCorrect ? 4 : 0)
                }
                .scaleEffect(isCorrect ? 1.06 : 1)
                .opacity(showFeedback && !isCorrect && !isIncorrect ? 0.45 : 1)
        }
        .buttonStyle(BouncyCardButtonStyle())
        .disabled(showFeedback)
        .floating(offset: showFeedback ? 0 : 6, delay: Double(index) * 0.18)
        .shake(trigger: isIncorrect)
        .sensoryFeedback(.selection, trigger: selectedChoice == choice)
        .accessibilityLabel(isCorrect ? "\(choice), correct" : choice)
    }
}

// MARK: - Side-by-side match

struct MemoryCardGameView: View {
    let pairs: [MatchingPair]
    let accent: Color
    var onStatusChange: ((Bool, Bool) -> Void)? = nil

    private struct SideCard: Identifiable {
        let pairID: UUID
        let text: String
        var id: UUID { pairID }
    }

    private let pairTints: [Color] = [
        DesignSystem.Colors.coralPink,
        DesignSystem.Colors.oceanTurquoise,
        DesignSystem.Colors.sunshineYellow,
        DesignSystem.Colors.lavenderPurple
    ]

    @State private var leftCards: [SideCard]
    @State private var rightCards: [SideCard]
    @State private var selectedLeftID: UUID?
    @State private var matchedPairIDs: Set<UUID> = []
    @State private var wrongRightID: UUID?
    @State private var shakeRightID: UUID?
    @State private var nudgeStart = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(pairs: [MatchingPair], accent: Color, onStatusChange: ((Bool, Bool) -> Void)? = nil) {
        self.pairs = pairs
        self.accent = accent
        self.onStatusChange = onStatusChange
        let dealt = Self.deal(pairs)
        _leftCards = State(initialValue: dealt.left)
        _rightCards = State(initialValue: dealt.right)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(selectedLeftID == nil ? "Tap a card on the left, then tap its match on the right." : "Now tap its match on the right.")
                .font(DesignSystem.Typography.caption(14).weight(.semibold))
                .foregroundStyle(nudgeStart ? accent : DesignSystem.Colors.textSecondary)
                .shake(trigger: nudgeStart)

            HStack(alignment: .top, spacing: 12) {
                column(title: "Start here", cards: leftCards, side: .left)
                column(title: "Match", cards: rightCards, side: .right)
            }
        }
        .sensoryFeedback(.success, trigger: matchedPairIDs.count)
    }

    private enum Side {
        case left
        case right
    }

    private func column(title: String, cards: [SideCard], side: Side) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(DesignSystem.Typography.caption(12).weight(.bold))
                .foregroundStyle(side == .left && nudgeStart ? accent : DesignSystem.Colors.deepNavy)
                .frame(maxWidth: .infinity, alignment: .center)
                .shake(trigger: side == .left && nudgeStart)

            VStack(spacing: 10) {
                ForEach(cards) { card in
                    cardFace(card, side: side)
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(side == .left ? accent.opacity(0.12) : DesignSystem.Colors.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.Radius.md, style: .continuous)
                .stroke(side == .left ? accent.opacity(0.35) : DesignSystem.Colors.inputBorder, lineWidth: 1.5)
        }
    }

    private func cardFace(_ card: SideCard, side: Side) -> some View {
        let matched = matchedPairIDs.contains(card.pairID)
        let selected = side == .left && selectedLeftID == card.pairID
        let wrong = side == .right && wrongRightID == card.pairID

        return Button {
            switch side {
            case .left:
                chooseLeft(card)
            case .right:
                chooseRight(card)
            }
        } label: {
            VStack(spacing: 8) {
                Text(card.text)
                    .font(DesignSystem.Typography.title(16))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: .infinity)

                if matched {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body.weight(.bold))
                        .foregroundStyle(pairTint(card.pairID))
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: DesignSystem.Metrics.scaled(88), alignment: .center)
            .background(cardFill(matched: matched, selected: selected, wrong: wrong))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous)
                    .stroke(cardBorder(matched: matched, selected: selected, wrong: wrong, pairID: card.pairID), lineWidth: matched || selected || wrong ? 3 : 1.5)
            }
            .scaleEffect(selected && !reduceMotion ? 1.03 : 1)
            .animation(DesignSystem.Animation.bounce, value: matched)
            .animation(DesignSystem.Animation.select, value: selected)
        }
        .buttonStyle(.plain)
        .disabled(matched)
        .shake(trigger: side == .right && shakeRightID == card.pairID)
        .accessibilityLabel(card.text)
        .accessibilityHint(accessibilityHint(matched: matched, selected: selected, side: side))
    }

    private func chooseLeft(_ card: SideCard) {
        guard !matchedPairIDs.contains(card.pairID) else { return }
        wrongRightID = nil
        shakeRightID = nil
        nudgeStart = false
        selectedLeftID = selectedLeftID == card.pairID ? nil : card.pairID
    }

    private func chooseRight(_ card: SideCard) {
        guard !matchedPairIDs.contains(card.pairID) else { return }
        guard let leftID = selectedLeftID else {
            nudgeStart = false
            DispatchQueue.main.async {
                nudgeStart = true
            }
            return
        }

        if leftID == card.pairID {
            matchedPairIDs.insert(card.pairID)
            selectedLeftID = nil
            wrongRightID = nil
            shakeRightID = nil
            let done = matchedPairIDs.count == pairs.count && pairs.count >= 2
            onStatusChange?(done, done)
        } else {
            wrongRightID = card.pairID
            shakeRightID = nil
            DispatchQueue.main.async {
                shakeRightID = card.pairID
            }
        }
    }

    private func cardFill(matched: Bool, selected: Bool, wrong: Bool) -> Color {
        if matched { return DesignSystem.Colors.freshGreenLight }
        if wrong { return DesignSystem.Colors.softRed.opacity(0.18) }
        if selected { return accent.opacity(0.2) }
        return DesignSystem.Colors.inputBackground
    }

    private func cardBorder(matched: Bool, selected: Bool, wrong: Bool, pairID: UUID) -> Color {
        if matched { return pairTint(pairID) }
        if wrong { return DesignSystem.Colors.softRed }
        if selected { return accent }
        return DesignSystem.Colors.inputBorderStrong
    }

    private func pairTint(_ pairID: UUID) -> Color {
        let index = leftCards.firstIndex { $0.pairID == pairID } ?? 0
        let tint = pairTints[index % pairTints.count]
        return tint == DesignSystem.Colors.sunshineYellow ? DesignSystem.Colors.warmOrange : tint
    }

    private func accessibilityHint(matched: Bool, selected: Bool, side: Side) -> String {
        if matched { return "Matched" }
        switch side {
        case .left:
            return selected ? "Selected. Tap its match on the right." : "On the left. Tap to choose it."
        case .right:
            return "On the right. Tap if it matches the card you chose."
        }
    }

    private static func deal(_ pairs: [MatchingPair]) -> (left: [SideCard], right: [SideCard]) {
        let left = pairs.map { SideCard(pairID: $0.id, text: $0.left) }
        let right = deranged(pairs).map { SideCard(pairID: $0.id, text: $0.right) }
        return (left, right)
    }

    /// Right column is only the match side, and no answer sits straight across from its card.
    private static func deranged(_ pairs: [MatchingPair]) -> [MatchingPair] {
        guard pairs.count > 1 else { return pairs }
        var order = shuffled(pairs)
        var spins = 0
        while hasFixedPoint(order, original: pairs), spins < pairs.count + 2 {
            for index in order.indices where order[index].id == pairs[index].id {
                order.swapAt(index, (index + 1) % order.count)
            }
            spins += 1
        }
        if hasFixedPoint(order, original: pairs) {
            order = Array(pairs.dropFirst()) + [pairs[0]]
        }
        return order
    }

    private static func hasFixedPoint(_ order: [MatchingPair], original: [MatchingPair]) -> Bool {
        order.enumerated().contains { index, pair in
            index < original.count && pair.id == original[index].id
        }
    }

    private static func shuffled(_ pairs: [MatchingPair]) -> [MatchingPair] {
        var result = pairs
        var state: UInt64 = 0xA11CE
        for pair in pairs {
            for byte in pair.left.utf8 {
                state = state &* 16777619 &+ UInt64(byte)
            }
            for byte in pair.right.utf8 {
                state = state &* 16777619 &+ UInt64(byte)
            }
        }
        if state == 0 { state = 1 }
        for index in stride(from: result.count - 1, through: 1, by: -1) {
            state = state &* 6364136223846793005 &+ 1
            let swap = Int(state >> 33) % (index + 1)
            result.swapAt(index, swap)
        }
        return result
    }
}
