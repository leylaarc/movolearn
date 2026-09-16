import Foundation

/// Passage-grounded matching + comprehension questions for lessons.
/// Matching pairs are generated only from explicit passage evidence — never from loose word associations.
enum ThemeInteractionQuestions {

    /// Builds interaction questions from the reading passage.
    /// Returns a matching question when ≥3 strong passage-grounded pairs exist; otherwise a comprehension MCQ.
    static func forPassage(
        _ passage: String,
        topic: Topic,
        vocabulary: [VocabularyWord] = [],
        knowledgeFacts: [KnowledgeFact] = []
    ) -> [LessonQuestion] {
        let result = PassageMatchingQuestionGenerator.generate(
            passage: passage,
            topic: topic,
            vocabulary: vocabulary,
            knowledgeFacts: knowledgeFacts
        )
        return [result.question]
    }

    /// Builds a "put each item in its group" matching question from authored
    /// "puts the X in/on Y" sentences. Used so grouping lessons actually sort.
    static func groupingMatch(from passage: String) -> LessonQuestion? {
        GroupingSortQuestionBuilder.question(from: passage)
    }

    /// Legacy entry point without a passage — cannot safely create matching pairs.
    /// Prefer `forPassage`. Returns a generic comprehension question instead of loose associations.
    static func forTopic(_ topic: Topic) -> [LessonQuestion] {
        let result = PassageMatchingQuestionGenerator.generate(
            passage: "",
            topic: topic,
            vocabulary: [],
            knowledgeFacts: []
        )
        return [result.question]
    }
}

/// Extracts item → group pairs from sentences like "She puts the spoons in the utensil tray."
enum GroupingSortQuestionBuilder {
    static func question(from passage: String) -> LessonQuestion? {
        let pairs = pairs(from: passage)
        guard pairs.count >= 3 else { return nil }
        let selected = Array(pairs.prefix(4))
        return LessonQuestion.matching(
            prompt: "Match each item to its group.",
            pairs: selected,
            explanation: "Each item goes in the group named in the story."
        )
    }

    static func pairs(from passage: String) -> [MatchingPair] {
        guard let regex = try? NSRegularExpression(
            pattern: #"(?i)\b(?:puts|put|places|place)\s+the\s+([A-Za-z][A-Za-z\- ]{1,28}?)\s+(in|on|into|onto)\s+(?:the\s+)?([^.?!]+)"#,
            options: []
        ) else { return [] }

        let ns = passage as NSString
        let matches = regex.matches(in: passage, range: NSRange(location: 0, length: ns.length))
        var seenLeft = Set<String>()
        var seenRight = Set<String>()
        var result: [MatchingPair] = []

        for match in matches {
            guard match.numberOfRanges >= 4,
                  let itemRange = Range(match.range(at: 1), in: passage),
                  Range(match.range(at: 2), in: passage) != nil,
                  let groupRange = Range(match.range(at: 3), in: passage),
                  let fullRange = Range(match.range(at: 0), in: passage) else {
                continue
            }
            let item = titleCase(passage[itemRange].trimmingCharacters(in: .whitespaces))
            var group = passage[groupRange]
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: "."))
            if group.lowercased().hasPrefix("the ") {
                group = String(group.dropFirst(4))
            }
            group = titleCase(group)
            let leftKey = item.lowercased()
            let rightKey = group.lowercased()
            guard item.count >= 2, group.count >= 3 else { continue }
            guard !seenLeft.contains(leftKey), !seenRight.contains(rightKey) else { continue }
            seenLeft.insert(leftKey)
            seenRight.insert(rightKey)
            let evidence = String(passage[fullRange])
                .trimmingCharacters(in: .whitespacesAndNewlines)
            result.append(
                MatchingPair(
                    left: item,
                    right: group,
                    supportingEvidence: evidence.hasSuffix(".") ? evidence : evidence + "."
                )
            )
        }
        return result
    }

    private static func titleCase(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.first else { return trimmed }
        return String(first).uppercased() + trimmed.dropFirst().lowercased()
    }
}
