import SwiftUI

/// Progressive clue reveal for evidence-based mysteries.
struct MysteryInvestigationView: View {
    let question: LessonQuestion
    let topic: Topic
    let accent: Color
    let revealedClueCount: Int
    let earlyPrediction: String?
    let showFeedback: Bool
    let isAnswerCorrect: Bool
    @Binding var selectedChoice: String?
    let onRevealClue: () -> Void
    let onEarlyPrediction: (String) -> Void
    let onFinalAnswer: (String) -> Void

    private var setupText: String {
        let setup = question.mysterySetup?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return setup.isEmpty ? question.prompt : setup
    }

    private var allCluesRevealed: Bool {
        revealedClueCount >= question.clues.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(setupText)
                .font(DesignSystem.Typography.headline(24))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
                .lineSpacing(7)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(Array(question.clues.prefix(revealedClueCount).enumerated()), id: \.offset) { index, clue in
                VStack(alignment: .leading, spacing: 4) {
                    Text("Clue \(index + 1)")
                        .font(DesignSystem.Typography.label(12))
                        .foregroundStyle(accent)
                    Text(clue)
                        .font(DesignSystem.Typography.title(19))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if !allCluesRevealed {
                LessonContinueButton(
                    title: revealedClueCount == 0 ? "Reveal first clue" : "Reveal next clue",
                    action: onRevealClue
                )

                if revealedClueCount >= 1, !question.choices.isEmpty, !showFeedback {
                    earlyPredictionSection
                }
            } else {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text(question.prompt)
                        .font(DesignSystem.Typography.question(24))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .lineSpacing(6)

                    Text("Use every clue to choose the best answer.")
                        .font(DesignSystem.Typography.subtitle(16))
                        .foregroundStyle(DesignSystem.Colors.lessonMuted)

                    ForEach(question.choices, id: \.self) { choice in
                        AnswerButton(
                            text: choice,
                            isSelected: selectedChoice == choice,
                            isCorrect: showFeedback && choice == question.correctAnswer,
                            isIncorrect: showFeedback && selectedChoice == choice && !isAnswerCorrect
                        ) {
                            guard !showFeedback else { return }
                            selectedChoice = choice
                            onFinalAnswer(choice)
                        }
                        .disabled(showFeedback)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var earlyPredictionSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Optional early guess")
                .font(DesignSystem.Typography.sectionHeader(16))
                .foregroundStyle(DesignSystem.Colors.deepNavy)
            Text("You can change your mind when new clues appear.")
                .font(DesignSystem.Typography.title(15))
                .foregroundStyle(DesignSystem.Colors.deepNavy)

            ForEach(question.choices, id: \.self) { choice in
                Button {
                    onEarlyPrediction(choice)
                } label: {
                    Text(choice)
                        .font(DesignSystem.Typography.title(18))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .frame(minHeight: DesignSystem.Metrics.scaled(56))
                        .background(earlyPrediction == choice ? DesignSystem.Colors.lessonCorrectWash : Color.clear)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(earlyPrediction == choice ? DesignSystem.Colors.lessonCorrectLine : DesignSystem.Colors.lessonLine)
                                .frame(height: 1)
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, DesignSystem.Spacing.xs)
    }
}
