import Foundation

/// Keeps Create Time writing prompts as story comprehension, not invention or opinion.
enum CreativePromptQuality {

    /// True when the prompt asks the child to invent, opine, or role-play instead of recalling the story.
    static func isOpinionOrHypothetical(_ prompt: String) -> Bool {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 8 else { return true }

        let lower = trimmed.lowercased()
        let markers = [
            "what you would",
            "what would you",
            "would you",
            "which clue felt",
            "felt most convincing",
            "would you trust",
            "would you check",
            "would you use",
            "would you rather",
            "would you want",
            "would you do",
            "would you pack",
            "would you visit",
            "would you ask",
            "before assuming",
            "make it yours",
            "only you would",
            "in your idea",
            "invent a",
            "could happen next",
            "new scene that",
            "your favorite",
            "when have you",
            "if you were",
            "if a pony",
            "if your favorite"
        ]
        return markers.contains { lower.contains($0) }
    }

    /// True when the prompt is a writing instruction rather than a question about the story.
    static func isWriteInstruction(_ prompt: String) -> Bool {
        let lower = prompt.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return lower.hasPrefix("write two sentences")
            || lower.hasPrefix("write four sentences")
            || lower.hasPrefix("write one idea")
            || lower.hasPrefix("write a short sequel")
            || lower.hasPrefix("invent a short sequel")
            || lower.contains("in your own words")
    }

    /// Drawing and Art Quest stay creative; story/discovery writing becomes a comprehension question.
    static func ensureStoryComprehension(prompt: String, responseType: QuestionResponseType, lesson: Lesson) -> String {
        ensureStoryComprehension(
            prompt: prompt,
            responseType: responseType,
            questions: lesson.questions,
            mathChallenges: lesson.mathChallenges,
            knowledgeFacts: lesson.knowledgeFacts,
            vocabularyWords: lesson.vocabularyWords,
            title: lesson.title,
            category: lesson.category,
            isArtQuest: lesson.isArtQuest
        )
    }

    static func ensureStoryComprehension(
        prompt: String,
        responseType: QuestionResponseType,
        questions: [LessonQuestion],
        mathChallenges: [LessonQuestion] = [],
        knowledgeFacts: [KnowledgeFact] = [],
        vocabularyWords: [VocabularyWord] = [],
        title: String = "",
        category: LessonCategory? = nil,
        isArtQuest: Bool = false
    ) -> String {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        if isArtQuest || category == .creative || responseType == .drawing {
            return trimmed
        }

        if isOpinionOrHypothetical(trimmed) {
            return derive(
                questions: questions,
                mathChallenges: mathChallenges,
                knowledgeFacts: knowledgeFacts,
                vocabularyWords: vocabularyWords,
                title: title,
                preferLast: true
            )
        }

        if isWriteInstruction(trimmed), let converted = convertWriteInstruction(trimmed) {
            if isOpinionOrHypothetical(converted)
                || !ChildFacingProseQualityValidator.passes(converted, allowShortImperative: true) {
                return derive(
                    questions: questions,
                    mathChallenges: mathChallenges,
                    knowledgeFacts: knowledgeFacts,
                    vocabularyWords: vocabularyWords,
                    title: title,
                    preferLast: true
                )
            }
            return converted
        }

        return trimmed
    }

    /// Prefer a later story question so Create Time is not an exact repeat of Q1.
    static func derive(
        questions: [LessonQuestion],
        mathChallenges: [LessonQuestion] = [],
        knowledgeFacts: [KnowledgeFact] = [],
        vocabularyWords: [VocabularyWord] = [],
        title: String = "",
        preferLast: Bool = true,
        avoiding: String? = nil
    ) -> String {
        ReflectionPromptQuality.derive(
            questions: questions,
            mathChallenges: mathChallenges,
            knowledgeFacts: knowledgeFacts,
            vocabularyWords: vocabularyWords,
            title: title,
            preferLast: preferLast,
            avoiding: avoiding
        )
    }

    private static func convertWriteInstruction(_ prompt: String) -> String? {
        var text = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let prefixes = [
            "Write two sentences retelling ",
            "Write two sentences explaining ",
            "Write two sentences about ",
            "Write two sentences ",
            "Write four sentences describing ",
            "Write four sentences ",
            "Write one idea from ",
            "Invent a short sequel scene that uses one detail from ",
            "Describe one scene from "
        ]
        for prefix in prefixes {
            if let range = text.range(of: prefix, options: .caseInsensitive), range.lowerBound == text.startIndex {
                text = String(text[range.upperBound...])
                break
            }
        }
        text = text.replacingOccurrences(
            of: #"\s+in your own words\.?$"#,
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count >= 12 else { return nil }

        if let first = text.first, first.isLowercase {
            text = first.uppercased() + text.dropFirst()
        }
        while text.hasSuffix(".") {
            text.removeLast()
        }
        if !text.hasSuffix("?") {
            text += "?"
        }
        return text
    }
}
