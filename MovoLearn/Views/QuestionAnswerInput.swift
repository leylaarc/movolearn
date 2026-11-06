import SwiftUI
import UIKit
import OSLog

private let answerInputLog = Logger(subsystem: "com.movolearn.app", category: "AnswerInput")

/// Renders the correct child response UI for a `QuestionResponseType`.
struct QuestionAnswerInput: View {
    let responseType: QuestionResponseType
    let choices: [String]
    let correctAnswer: String?
    let pairs: [MatchingPair]
    let items: [SortingItem]
    let accent: Color
    var interactionID: String = ""

    @Binding var textAnswer: String
    @Binding var selectedChoice: String?
    @Binding var hasDrawing: Bool
    @Binding var matchingComplete: Bool
    @Binding var matchingCorrect: Bool
    @Binding var sortingOrderIDs: [String]
    @Binding var sortingCorrect: Bool

    var showFeedback: Bool = false
    var isAnswerCorrect: Bool = false
    var onSelectChoice: ((String) -> Void)? = nil
    var drawingQuestGoals: [String] = []

    var body: some View {
        Group {
            switch resolvedType {
            case .multipleChoice:
                if PlayGameCatalog.fitsBubble(choices: choices, correctAnswer: correctAnswer) {
                    BubblePopGameView(
                        choices: choices,
                        correctAnswer: correctAnswer,
                        accent: accent,
                        showFeedback: showFeedback,
                        isAnswerCorrect: isAnswerCorrect,
                        selectedChoice: selectedChoice,
                        onSelect: { onSelectChoice?($0) }
                    )
                    .id(interactionID)
                } else {
                    multipleChoiceInput
                }
            case .drawing:
                DrawingCanvasView(
                    hasContent: $hasDrawing,
                    accent: accent,
                    questGoals: drawingQuestGoals
                )
                .frame(maxHeight: .infinity)
            case .shortText:
                SparkAnswerTextField(
                    placeholder: "Type a short answer…",
                    text: $textAnswer,
                    lineLimit: 1...2,
                    accent: accent
                )
            case .longText:
                SparkAnswerTextField(
                    placeholder: "Type a short answer…",
                    text: $textAnswer,
                    lineLimit: 3...8,
                    accent: accent
                )
            case .number:
                NumberPadInput(text: $textAnswer, accent: accent)
            case .matching:
                if pairs.count >= 2, PlayGameCatalog.fitsMemory(pairs: pairs) {
                    MemoryCardGameView(
                        pairs: pairs,
                        accent: accent
                    ) { complete, correct in
                        matchingComplete = complete
                        matchingCorrect = correct
                    }
                    .id(interactionID)
                } else if pairs.count >= 2 {
                    MatchingQuestionView(
                        pairs: pairs,
                        accent: accent,
                        showFeedback: showFeedback
                    ) { complete, correct in
                        matchingComplete = complete
                        matchingCorrect = correct
                    }
                    .onAppear {
                        matchingComplete = false
                        matchingCorrect = false
                    }
                } else {
                    invalidDataBanner(
                        message: "This matching question is missing pair data.",
                        fallback: .longText
                    )
                }
            case .sorting:
                if items.count >= 2 {
                    SortingQuestionView(
                        items: items,
                        accent: accent,
                        showFeedback: showFeedback
                    ) { order in
                        sortingOrderIDs = order
                        let correct = items.sorted { $0.correctPosition < $1.correctPosition }.map(\.id)
                        sortingCorrect = order == correct
                    }
                } else {
                    invalidDataBanner(
                        message: "This sorting question is missing ordered items.",
                        fallback: .longText
                    )
                }
            }
        }
    }

    private var resolvedType: QuestionResponseType {
        guard QuestionResponseType.allCases.contains(responseType) else {
            answerInputLog.error("Unknown response type — falling back to longText")
            return .fallback
        }
        switch responseType {
        case .multipleChoice where choices.count < 2:
            answerInputLog.error("multipleChoice with insufficient choices — falling back to longText")
            return .fallback
        case .matching where pairs.count < 2:
            answerInputLog.error("matching without pairs — falling back to longText")
            return .fallback
        case .sorting where items.count < 2:
            answerInputLog.error("sorting without items — falling back to longText")
            return .fallback
        default:
            return responseType
        }
    }

    private var multipleChoiceInput: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            ForEach(choices, id: \.self) { choice in
                AnswerButton(
                    text: choice,
                    isSelected: selectedChoice == choice,
                    isCorrect: showFeedback && choice == correctAnswer,
                    isIncorrect: showFeedback && selectedChoice == choice && !isAnswerCorrect
                ) {
                    onSelectChoice?(choice)
                }
                .disabled(showFeedback)
            }
        }
    }

    @ViewBuilder
    private func invalidDataBanner(message: String, fallback: QuestionResponseType) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(message)
                .font(DesignSystem.Typography.caption(13).weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.softRed)
            #if DEBUG
            Text("DEBUG: showing fallback \(fallback.rawValue) input")
                .font(DesignSystem.Typography.caption(11))
                .foregroundStyle(DesignSystem.Colors.textTertiary)
            #endif
            SparkAnswerTextField(
                placeholder: "Type your answer…",
                text: $textAnswer,
                lineLimit: 2...4,
                accent: accent
            )
        }
    }
}

// MARK: - High-contrast text answer field

struct SparkAnswerTextField: View {
    let placeholder: String
    @Binding var text: String
    var lineLimit: ClosedRange<Int> = 2...6
    var accent: Color = DesignSystem.Colors.warmOrange
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .lineLimit(lineLimit)
            .font(DesignSystem.Typography.title(20))
            .foregroundStyle(DesignSystem.Colors.inputText)
            .tint(DesignSystem.Colors.inputCursor)
            .keyboardType(keyboardType)
            .padding(DesignSystem.Spacing.cardPadding)
            .background(DesignSystem.Colors.inputBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous)
                    .stroke(DesignSystem.Colors.inputBorderStrong, lineWidth: 2)
            )
            .shadow(color: accent.opacity(0.12), radius: 6, y: 2)
            .environment(\.colorScheme, .light)
    }
}

// MARK: - Number pad

struct NumberPadInput: View {
    @Binding var text: String
    var accent: Color = DesignSystem.Colors.warmOrange
    var maxDigits: Int = 4

    private let keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "Clear", "0", "⌫"]

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Text(text.isEmpty ? "?" : text)
                .font(DesignSystem.Typography.headline(36))
                .foregroundStyle(DesignSystem.Colors.inputText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.md)
                .background(DesignSystem.Colors.inputBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous)
                        .stroke(DesignSystem.Colors.inputBorderStrong, lineWidth: 2)
                )
                .environment(\.colorScheme, .light)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: DesignSystem.Metrics.scaled(10)), count: 3),
                spacing: DesignSystem.Metrics.scaled(10)
            ) {
                ForEach(keys, id: \.self) { key in
                    Button {
                        handle(key)
                    } label: {
                        Text(key)
                            .font(DesignSystem.Typography.title(key.count > 1 ? 16 : 22))
                            .foregroundStyle(DesignSystem.Colors.deepNavy)
                            .frame(maxWidth: .infinity)
                            .frame(height: DesignSystem.Metrics.scaled(56))
                            .background(DesignSystem.Colors.surfaceMuted)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.Radius.sm, style: .continuous)
                                    .stroke(DesignSystem.Colors.inputBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func handle(_ key: String) {
        switch key {
        case "Clear":
            text = ""
        case "⌫":
            if !text.isEmpty { text.removeLast() }
        default:
            guard text.count < maxDigits else { return }
            text += key
        }
    }
}
