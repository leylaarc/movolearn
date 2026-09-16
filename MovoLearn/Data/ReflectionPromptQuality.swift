import Foundation

/// Keeps end-of-lesson ("Star Moment") prompts concrete and lesson-specific.
/// Bans vague meta-reflections and opinion questions that are not about the story.
enum ReflectionPromptQuality {

    /// True when the prompt is empty or matches a banned generic “what did you learn?” pattern.
    static func isGeneric(_ prompt: String) -> Bool {
        matchesClassicGeneric(prompt)
    }

    /// Classic “what did you learn today?” prompts that could apply to any lesson.
    static func matchesClassicGeneric(_ prompt: String) -> Bool {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 12 else { return true }

        let lower = trimmed.lowercased()

        let bannedSubstrings = [
            "what did you learn",
            "what is one new thing you learned",
            "one new thing you learned",
            "why was this important",
            "why was that important",
            "how did this help",
            "how did that help",
            "how did groups help",
            "equal groups help",
            "where did equal groups help",
            "what did you count today",
            "which step did you check",
            "think hardest",
            "made you think hardest",
            "was trickiest",
            "surprised you most",
            "detail from today you want to remember",
            "one detail from today",
            "one thing you remember from",
            "idea from today’s lesson",
            "idea from today's lesson",
            "idea from today’s",
            "idea from today's",
            "liked most",
            "what did you like",
            "would you like to",
            "how did you help",
            "how did reading the",
            "how did reading .* help you",
            "what is one detail from today's story that you used",
            "share one thing you learned"
        ]

        for banned in bannedSubstrings {
            if banned.contains(".*") {
                if lower.range(of: banned, options: .regularExpression) != nil {
                    return true
                }
            } else if lower.contains(banned) {
                return true
            }
        }

        if lower.range(of: #"which .+ would you like"#, options: .regularExpression) != nil {
            return true
        }

        // Vague meta questions about "today" / skill labels with no lesson object.
        let metaSkillPatterns = [
            #"^where did .+ help( you)?( today)?\??$"#,
            #"^how did (this|that|groups|reading) help\b.*$"#,
            #"^what did you (learn|count|practice)( today)?\??$"#,
            #"^which (step|problem|part) (did you check|made you think|was trickiest).*\??$"#
        ]
        for pattern in metaSkillPatterns {
            if lower.range(of: pattern, options: .regularExpression) != nil {
                return true
            }
        }

        return false
    }

    /// Returns the authored prompt when concrete; otherwise derives one from lesson content.
    static func ensureConcrete(prompt: String, lesson: Lesson, avoiding: String? = nil) -> String {
        ensureConcrete(
            prompt: prompt,
            questions: lesson.questions,
            mathChallenges: lesson.mathChallenges,
            knowledgeFacts: lesson.knowledgeFacts,
            vocabularyWords: lesson.vocabularyWords,
            title: lesson.title,
            category: lesson.category,
            isArtQuest: lesson.isArtQuest,
            avoiding: avoiding ?? lesson.creativePrompt
        )
    }

    /// Convenience for factory packs before a full `Lesson` exists.
    static func ensureConcrete(
        prompt: String,
        questions: [LessonQuestion],
        mathChallenges: [LessonQuestion] = [],
        knowledgeFacts: [KnowledgeFact] = [],
        vocabularyWords: [VocabularyWord] = [],
        title: String = "",
        category: LessonCategory? = nil,
        isArtQuest: Bool = false,
        avoiding: String? = nil
    ) -> String {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let skipOpinion = isArtQuest || category == .creative
        let needsRewrite = matchesClassicGeneric(trimmed)
            || (!skipOpinion && CreativePromptQuality.isOpinionOrHypothetical(trimmed))
        if !needsRewrite {
            return trimmed
        }
        return derive(
            questions: questions,
            mathChallenges: mathChallenges,
            knowledgeFacts: knowledgeFacts,
            vocabularyWords: vocabularyWords,
            title: title,
            avoiding: avoiding
        )
    }

    /// Derives a concrete end question from questions, math challenges, facts, or vocab.
    static func derive(from lesson: Lesson, avoiding: String? = nil) -> String {
        derive(
            questions: lesson.questions,
            mathChallenges: lesson.mathChallenges,
            knowledgeFacts: lesson.knowledgeFacts,
            vocabularyWords: lesson.vocabularyWords,
            title: lesson.title,
            avoiding: avoiding ?? lesson.creativePrompt
        )
    }

    static func derive(
        questions: [LessonQuestion],
        mathChallenges: [LessonQuestion] = [],
        knowledgeFacts: [KnowledgeFact] = [],
        vocabularyWords: [VocabularyWord] = [],
        title: String = "",
        preferLast: Bool = false,
        avoiding: String? = nil
    ) -> String {
        let avoided = avoiding.map { normalizeAsQuestion($0).lowercased() }
        let contentQuestions = (questions + mathChallenges)
            .filter { $0.subject != .reflection && $0.subject != .creative }
            .map { $0.prompt.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && $0.count >= 12 }
            .map(normalizeAsQuestion)
            .filter { candidate in
                guard let avoided else { return true }
                return candidate.lowercased() != avoided
            }

        if preferLast, let last = contentQuestions.last {
            return last
        }
        // Prefer a later content question so Star Moment is not an exact repeat of Q1.
        if contentQuestions.count >= 2 {
            return contentQuestions[1]
        }
        if let first = contentQuestions.first {
            return first
        }

        if let fact = knowledgeFacts.first?.fact
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !fact.isEmpty {
            let short = fact.count > 90 ? String(fact.prefix(87)) + "…" : fact
            return "Which is true from this lesson: \(short)"
        }

        if let word = vocabularyWords.first {
            let def = word.definition.trimmingCharacters(in: .whitespacesAndNewlines)
            if !def.isEmpty {
                return "What does \"\(word.word)\" mean in this lesson?"
            }
        }

        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanTitle.isEmpty {
            return "What was one important detail from \"\(cleanTitle)\"?"
        }

        return "What was one important detail from the story or problems you just finished?"
    }

    static func normalizeAsQuestion(_ prompt: String) -> String {
        var text = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        while text.hasSuffix(".") {
            text.removeLast()
        }
        if !text.hasSuffix("?") {
            text += "?"
        }
        return text
    }
}
