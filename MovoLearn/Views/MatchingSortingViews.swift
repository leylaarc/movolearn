import SwiftUI

/// Child taps a left item, then a right item, to form pairs. Supports reset and validation.
struct MatchingQuestionView: View {
    let pairs: [MatchingPair]
    let accent: Color
    var showFeedback: Bool = false
    var onStatusChange: ((Bool, Bool) -> Void)? = nil

    @State private var selectedLeftID: UUID?
    @State private var matches: [UUID: UUID] = [:] // leftID → rightID
    @State private var shuffledRights: [MatchingPair] = []

    private var leftItems: [MatchingPair] { pairs }
    private var allMatched: Bool { matches.count == pairs.count && pairs.count >= 2 }

    private var isCorrect: Bool {
        guard allMatched else { return false }
        for pair in pairs {
            guard let rightID = matches[pair.id] else { return false }
            if rightID != pair.id { return false }
        }
        return true
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Tap a word on the left, then tap its match on the right.")
                .font(DesignSystem.Typography.caption(13).weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.textSecondary)

            HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(leftItems) { pair in
                        matchChip(
                            text: pair.left,
                            selected: selectedLeftID == pair.id,
                            locked: matches[pair.id] != nil,
                            correct: showFeedback && matches[pair.id] == pair.id,
                            incorrect: showFeedback && matches[pair.id] != nil && matches[pair.id] != pair.id
                        ) {
                            guard !showFeedback else { return }
                            if matches[pair.id] != nil {
                                matches[pair.id] = nil
                            }
                            selectedLeftID = pair.id
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(shuffledRights) { pair in
                        let isUsed = matches.values.contains(pair.id)
                        matchChip(
                            text: pair.right,
                            selected: false,
                            locked: isUsed,
                            correct: showFeedback && pairs.contains(where: { matches[$0.id] == pair.id && $0.id == pair.id }),
                            incorrect: showFeedback && pairs.contains(where: { matches[$0.id] == pair.id && $0.id != pair.id })
                        ) {
                            guard !showFeedback, let leftID = selectedLeftID else { return }
                            // Remove prior use of this right
                            for key in matches.keys where matches[key] == pair.id {
                                matches[key] = nil
                            }
                            matches[leftID] = pair.id
                            selectedLeftID = nil
                            onStatusChange?(allMatched, isCorrect)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }

            if !matches.isEmpty && !showFeedback {
                Button {
                    matches = [:]
                    selectedLeftID = nil
                    onStatusChange?(false, false)
                } label: {
                    Label("Reset matches", systemImage: "arrow.counterclockwise")
                        .font(DesignSystem.Typography.caption(13).weight(.bold))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(DesignSystem.Colors.surfaceMuted)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }

            if showFeedback {
                Text(isCorrect ? "Great matching!" : "Some pairs need another try.")
                    .font(DesignSystem.Typography.body(15).weight(.semibold))
                    .foregroundStyle(isCorrect ? DesignSystem.Colors.successGreen : DesignSystem.Colors.softRed)
            }
        }
        .onAppear {
            if shuffledRights.isEmpty {
                shuffledRights = pairs.shuffled()
            }
        }
    }

    private func matchChip(
        text: String,
        selected: Bool,
        locked: Bool,
        correct: Bool,
        incorrect: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(text)
                .font(DesignSystem.Typography.title(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 10)
                .background(chipBackground(selected: selected, locked: locked, correct: correct, incorrect: incorrect))
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous)
                        .stroke(chipBorder(selected: selected, correct: correct, incorrect: incorrect), lineWidth: selected || correct || incorrect ? 2.5 : 1.5)
                )
        }
        .buttonStyle(.plain)
        .disabled(showFeedback)
        .opacity(locked && !showFeedback ? 0.55 : 1)
        .scaleEffect(correct ? 1.04 : (selected ? 1.02 : 1))
        .shake(trigger: incorrect)
        .animation(DesignSystem.Animation.select, value: selected)
        .animation(DesignSystem.Animation.celebrate, value: correct)
        .environment(\.colorScheme, .light)
    }

    private func chipBackground(selected: Bool, locked: Bool, correct: Bool, incorrect: Bool) -> Color {
        if correct { return DesignSystem.Colors.successGreen.opacity(0.18) }
        if incorrect { return DesignSystem.Colors.softRed.opacity(0.18) }
        if selected { return accent.opacity(0.18) }
        if locked { return DesignSystem.Colors.surfaceMuted }
        return DesignSystem.Colors.inputBackground
    }

    private func chipBorder(selected: Bool, correct: Bool, incorrect: Bool) -> Color {
        if correct { return DesignSystem.Colors.successGreen }
        if incorrect { return DesignSystem.Colors.softRed }
        if selected { return accent }
        return DesignSystem.Colors.inputBorderStrong
    }

    /// Expose correctness for parent Check Answer button.
    func evaluate() -> Bool { isCorrect }

    var currentMatchesComplete: Bool { allMatched }
}

/// Reorder items with move-up / move-down controls and drag-and-drop. Validates against correctPosition.
struct SortingQuestionView: View {
    let items: [SortingItem]
    let accent: Color
    var showFeedback: Bool = false
    var onOrderChanged: (([String]) -> Void)? = nil

    @State private var orderedIDs: [String] = []
    @State private var draggingID: String?

    private var orderedItems: [SortingItem] {
        orderedIDs.compactMap { id in items.first(where: { $0.id == id }) }
    }

    private var isCorrect: Bool {
        let correct = items.sorted { $0.correctPosition < $1.correctPosition }.map(\.id)
        return orderedIDs == correct
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Drag the cards, or use the arrows, to put these in the correct order.")
                .font(DesignSystem.Typography.caption(13).weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.textSecondary)

            ForEach(Array(orderedItems.enumerated()), id: \.element.id) { index, item in
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "line.3.horizontal")
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                        .accessibilityHidden(true)

                    Text("\(index + 1)")
                        .font(DesignSystem.Typography.caption(12).weight(.bold))
                        .foregroundStyle(DesignSystem.Colors.cardWhite)
                        .frame(width: 28, height: 28)
                        .background(accent)
                        .clipShape(Circle())

                    Text(item.text)
                        .font(DesignSystem.Typography.title(16))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 4) {
                        Button {
                            move(index, by: -1)
                        } label: {
                            Image(systemName: "chevron.up")
                                .font(.padScaled(size: 14, weight: .bold))
                                .foregroundStyle(DesignSystem.Colors.deepNavy)
                                .frame(width: 36, height: 28)
                                .background(DesignSystem.Colors.surfaceMuted)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .disabled(showFeedback || index == 0)
                        .accessibilityLabel("Move up")

                        Button {
                            move(index, by: 1)
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.padScaled(size: 14, weight: .bold))
                                .foregroundStyle(DesignSystem.Colors.deepNavy)
                                .frame(width: 36, height: 28)
                                .background(DesignSystem.Colors.surfaceMuted)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .disabled(showFeedback || index == orderedItems.count - 1)
                        .accessibilityLabel("Move down")
                    }
                }
                .padding(DesignSystem.Spacing.md)
                .background(rowBackground(for: item, index: index))
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous)
                        .stroke(rowBorder(for: item, index: index), lineWidth: 1.5)
                )
                .scaleEffect(showFeedback && isCorrectRow(item, index: index) ? 1.02 : 1)
                .animation(DesignSystem.Animation.select, value: orderedIDs)
                .animation(DesignSystem.Animation.celebrate, value: showFeedback)
                .opacity(draggingID == item.id ? 0.55 : 1)
                .draggable(item.id) {
                    Text(item.text)
                        .font(DesignSystem.Typography.caption(13).weight(.semibold))
                        .padding(8)
                        .background(DesignSystem.Colors.cardWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onAppear { draggingID = item.id }
                }
                .dropDestination(for: String.self) { droppedIDs, _ in
                    guard !showFeedback, let fromID = droppedIDs.first,
                          let fromIndex = orderedIDs.firstIndex(of: fromID),
                          let toIndex = orderedIDs.firstIndex(of: item.id),
                          fromIndex != toIndex else {
                        draggingID = nil
                        return false
                    }
                    orderedIDs.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                    onOrderChanged?(orderedIDs)
                    draggingID = nil
                    return true
                } isTargeted: { _ in }
            }

            if !showFeedback {
                Button {
                    resetShuffled()
                } label: {
                    Label("Shuffle again", systemImage: "shuffle")
                        .font(DesignSystem.Typography.caption(13).weight(.bold))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(DesignSystem.Colors.surfaceMuted)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }

            if showFeedback {
                Text(isCorrect ? "Perfect order!" : "Not quite — try a different order.")
                    .font(DesignSystem.Typography.body(15).weight(.semibold))
                    .foregroundStyle(isCorrect ? DesignSystem.Colors.successGreen : DesignSystem.Colors.softRed)
            }
        }
        .onAppear {
            if orderedIDs.isEmpty {
                resetShuffled()
            }
        }
        .environment(\.colorScheme, .light)
    }

    private func move(_ index: Int, by delta: Int) {
        let newIndex = index + delta
        guard orderedIDs.indices.contains(newIndex) else { return }
        orderedIDs.swapAt(index, newIndex)
        onOrderChanged?(orderedIDs)
    }

    private func resetShuffled() {
        var ids = items.map(\.id)
        if ids.count > 1 {
            repeat {
                ids.shuffle()
            } while ids == items.sorted(by: { $0.correctPosition < $1.correctPosition }).map(\.id) && ids.count > 1
        }
        orderedIDs = ids
        onOrderChanged?(orderedIDs)
    }

    private func isCorrectRow(_ item: SortingItem, index: Int) -> Bool {
        guard showFeedback else { return false }
        let correctID = items.sorted { $0.correctPosition < $1.correctPosition }.map(\.id)
        return index < correctID.count && correctID[index] == item.id
    }

    private func rowBackground(for item: SortingItem, index: Int) -> Color {
        guard showFeedback else { return DesignSystem.Colors.inputBackground }
        let correctID = items.sorted { $0.correctPosition < $1.correctPosition }.map(\.id)
        if index < correctID.count && correctID[index] == item.id {
            return DesignSystem.Colors.successGreen.opacity(0.18)
        }
        return DesignSystem.Colors.softRed.opacity(0.18)
    }

    private func rowBorder(for item: SortingItem, index: Int) -> Color {
        guard showFeedback else { return DesignSystem.Colors.inputBorderStrong }
        let correctID = items.sorted { $0.correctPosition < $1.correctPosition }.map(\.id)
        if index < correctID.count && correctID[index] == item.id {
            return DesignSystem.Colors.successGreen
        }
        return DesignSystem.Colors.softRed
    }

    func evaluate() -> Bool { isCorrect }
}
