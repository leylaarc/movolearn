import Foundation

/// Turns mission prompts into clear child-facing instructions for the "Your Mission" step.
///
/// Curated packs sometimes store bare reading questions as `missionPrompt`. Under the
/// step badge "Your Mission", that reads like quoting a question as a job. Prefer
/// short imperatives that match bundled lessons ("Count…", "Help…", "Find out…").
enum MissionPromptNormalizer {

    enum Issue: Equatable, CustomStringConvertible {
        case empty
        case tooShort
        case brokenPhrase(String)
        case bareQuestionAsStatement(String)
        case ungrammaticalFragment(String)

        var description: String {
            switch self {
            case .empty: return "Mission prompt is empty"
            case .tooShort: return "Mission prompt is too short"
            case .brokenPhrase(let s): return "Broken mission phrasing: \(s)"
            case .bareQuestionAsStatement(let s): return "Question shaped as a statement: \(s)"
            case .ungrammaticalFragment(let s): return "Ungrammatical mission fragment: \(s)"
            }
        }
    }

    /// Display / ship form under the "Your Mission" badge (no "Your mission:" prefix —
    /// the step title already says that).
    static func childFacing(_ prompt: String) -> String {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return trimmed }

        // Already framed as a mission / job line.
        let lower = trimmed.lowercased()
        if lower.hasPrefix("your mission:") || lower.hasPrefix("your job:") {
            return ChildFacingProseQualityValidator.polish(stripLeadingLabel(trimmed))
        }

        let sentences = splitKeepingTerminals(trimmed)
        guard !sentences.isEmpty else { return trimmed }

        var rebuilt: [String] = []
        for (index, piece) in sentences.enumerated() {
            if index == 0, looksLikeInterrogative(piece.body) {
                rebuilt.append(imperativeFromQuestion(piece.body))
            } else if looksLikeInterrogative(piece.body) {
                rebuilt.append(imperativeFromQuestion(piece.body))
            } else {
                rebuilt.append(ensureTerminal(piece.body, preferred: piece.terminal.isEmpty ? "." : piece.terminal))
            }
        }
        return ChildFacingProseQualityValidator.polish(rebuilt.joined(separator: " "))
    }

    /// Quality issues for mission prompts (canonical or adapted).
    static func validate(_ prompt: String) -> [Issue] {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [.empty] }

        var issues: [Issue] = []
        if trimmed.count < 12 {
            issues.append(.tooShort)
        }

        let lower = trimmed.lowercased()
        let broken: [String] = [
            "launch off",
            "the launch off",
            "before the launch off",
            "before launch off",
            "groups of ten and equal rows",
            "equal rows with"
        ]
        for phrase in broken where lower.contains(phrase) {
            issues.append(.brokenPhrase(phrase))
        }
        // "the launch off" / "a launch off" style
        if lower.range(of: #"\b(the|a|an)\s+launch\s+off\b"#, options: .regularExpression) != nil {
            issues.append(.brokenPhrase("article + launch off"))
        }

        // Wh-question stem ending in a period (adaptation stripped the ?).
        // Do not flag imperatives like "Do the math carefully."
        if looksLikeWhQuestionStem(trimmed), trimmed.hasSuffix(".") {
            issues.append(.bareQuestionAsStatement(trimmed))
        }

        return issues
    }

    static func passes(_ prompt: String) -> Bool {
        validate(prompt).isEmpty
    }

    /// Rewrites a mission so it only promises activities the child will actually do.
    static func alignedToActivities(
        existing: String,
        questions: [LessonQuestion],
        mathChallenges: [LessonQuestion],
        maxSentences: Int = 2
    ) -> String {
        let all = questions + mathChallenges
        let hasMatching = all.contains { $0.responseType == .matching }
        let mathBlob = all
            .filter { $0.subject == .math || $0.responseType != .matching }
            .map(\.prompt)
            .joined(separator: " ")
            .lowercased()
        let mathGroupSize = groupSize(in: mathBlob)

        var kept: [String] = []
        for piece in splitKeepingTerminals(existing) {
            let lower = piece.body.lowercased()
            let claimsSort = (lower.contains("sort") || lower.contains("match"))
                && (lower.contains("group") || lower.contains("place"))
            let claimedSize = groupSize(in: lower)
            let claimsPackTens = lower.contains("pack") && claimedSize != nil
            let claimsCount = lower.hasPrefix("count ")

            if claimsSort && !hasMatching { continue }
            if claimedSize != nil && claimedSize != mathGroupSize { continue }
            if claimsCount {
                // Keep count/compare missions when the math is actually counting or comparing.
                // Drop leftover "Count the measuring cups" promises on equal-groups stories.
                let countingMath = mathBlob.contains("in all")
                    || mathBlob.contains("comes next")
                    || mathBlob.contains("which side has more")
                    || mathBlob.contains("count the")
                    || (mathBlob.contains("how many") && mathBlob.contains("are there"))
                if !countingMath {
                    let counted = String(lower.dropFirst(6))
                        .trimmingCharacters(in: CharacterSet(charactersIn: "."))
                    let countingPrompt = mathBlob.contains("count the \(counted)")
                        || (mathBlob.contains("how many \(counted)") && mathBlob.contains("are there"))
                    if !countingPrompt { continue }
                }
            }

            var body = piece.body
            if claimsSort && hasMatching && lower.contains("sort") && !lower.contains("match") {
                body = rewriteSortClaimToMatch(body)
            } else if claimsPackTens, let size = mathGroupSize {
                body = rewritePackClaimToFind(body, groupSize: size)
            }
            kept.append(ensureTerminal(body, preferred: piece.terminal.isEmpty ? "." : piece.terminal))
        }

        if kept.isEmpty {
            if hasMatching {
                kept.append("Match each item to its group.")
            }
            if let size = mathGroupSize {
                kept.append(hasMatching
                    ? "Then find how many groups of \(size) you can make."
                    : "Find how many groups of \(size) you can make.")
            }
            if kept.isEmpty {
                kept.append("Read carefully. Answer each question.")
            }
        }

        let limited = Array(kept.prefix(max(1, maxSentences)))
        return childFacing(limited.joined(separator: " "))
    }

    static func groupSize(in text: String) -> Int? {
        let lower = text.lowercased()
        if lower.contains("groups of ten") { return 10 }
        guard let regex = try? NSRegularExpression(pattern: #"groups of (\d+)"#) else { return nil }
        let range = NSRange(lower.startIndex..., in: lower)
        guard let match = regex.firstMatch(in: lower, range: range),
              let sizeRange = Range(match.range(at: 1), in: lower) else {
            return nil
        }
        return Int(lower[sizeRange])
    }

    private static func rewriteSortClaimToMatch(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(
            of: #"Sort the (.+?) into groups\.?"#,
            with: "Match the $1 to their groups.",
            options: [.regularExpression, .caseInsensitive]
        )
        if result == text {
            result = "Match each item to its group."
        }
        return result
    }

    private static func rewritePackClaimToFind(_ text: String, groupSize: Int) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let regex = try? NSRegularExpression(
            pattern: #"(?i)^(?:help\s+)?(.+?)\s+pack(?:s)?\s+(?:the\s+)?.+?\s+into groups of (?:\d+|ten)\.?$"#,
            options: []
        ) {
            let range = NSRange(trimmed.startIndex..., in: trimmed)
            if let match = regex.firstMatch(in: trimmed, range: range),
               match.numberOfRanges >= 2,
               let nameRange = Range(match.range(at: 1), in: trimmed) {
                let name = String(trimmed[nameRange]).trimmingCharacters(in: .whitespaces)
                if !name.isEmpty, name.lowercased() != "then", name.lowercased() != "you" {
                    let helpPrefix = trimmed.lowercased().hasPrefix("help ") ? "Help " : ""
                    return "\(helpPrefix)\(name) find how many groups of \(groupSize) to make."
                }
            }
        }
        if trimmed.lowercased().hasPrefix("then ") {
            return "Then find how many groups of \(groupSize) you can make."
        }
        return "Find how many groups of \(groupSize) you can make."
    }

    // MARK: - Conversion

    private static func stripLeadingLabel(_ text: String) -> String {
        var result = text
        for prefix in ["Your mission:", "Your Mission:", "your mission:", "Your job:", "Your Job:", "your job:"] {
            if result.hasPrefix(prefix) {
                result = String(result.dropFirst(prefix.count)).trimmingCharacters(in: .whitespacesAndNewlines)
                break
            }
        }
        return ensureTerminal(result, preferred: result.hasSuffix("?") ? "?" : ".")
    }

    private static func imperativeFromQuestion(_ body: String) -> String {
        var text = body.trimmingCharacters(in: .whitespacesAndNewlines)
        while text.hasSuffix("?") || text.hasSuffix(".") || text.hasSuffix("!") {
            text = String(text.dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        // Drop leading "Can you " → keep the rest as a soft ask turned into a job.
        if let range = text.range(of: #"^can you\s+"#, options: [.regularExpression, .caseInsensitive]) {
            text = String(text[range.upperBound...])
            return ensureTerminal(capitalize(text), preferred: ".")
        }

        let lower = text.lowercased()
        let mappings: [(String, String)] = [
            ("what is the main idea about ", "Find the main idea about "),
            ("what is the main idea ", "Find the main idea "),
            ("what does ", "Check what "),
            ("what do ", "Check what "),
            ("what did ", "Check what "),
            ("what is ", "Find out what "),
            ("what are ", "Find out what "),
            ("what can ", "Find out what "),
            ("what happens ", "Find out what happens "),
            ("what happens when ", "Find out what happens when "),
            ("what kind ", "Find out what kind "),
            ("what bright ", "Notice what bright "),
            ("what safety ", "Find the safety "),
            ("what conclusion ", "Explain what conclusion "),
            ("what treasures ", "Find what treasures "),
            ("why does ", "Figure out why "),
            ("why do ", "Figure out why "),
            ("why did ", "Figure out why "),
            ("why were ", "Figure out why "),
            ("why was ", "Figure out why "),
            ("how does ", "Discover how "),
            ("how do ", "Discover how "),
            ("how did ", "Discover how "),
            ("how can ", "Discover how "),
            ("which ", "Decide which "),
            ("where does ", "Find where "),
            ("where do ", "Find where "),
            ("where did ", "Find where "),
            ("when does ", "Find when "),
            ("when do ", "Find when "),
            ("who ", "Find who ")
        ]

        // "Watch … — what really happens" / "Follow …. What does …"
        if let dashSplit = splitTrailingQuestionClause(text) {
            let lead = dashSplit.lead.trimmingCharacters(in: .whitespacesAndNewlines)
            let question = dashSplit.question.trimmingCharacters(in: .whitespacesAndNewlines)
            let convertedQ = imperativeFromQuestion(question)
            if lead.isEmpty {
                return convertedQ
            }
            return ensureTerminal(lead, preferred: ".") + " " + convertedQ
        }

        for (prefix, replacement) in mappings {
            if lower.hasPrefix(prefix) {
                let rest = String(text.dropFirst(prefix.count))
                var converted = replacement + rest
                if prefix == "what does " {
                    converted = fixDoesDoAgreement(converted)
                }
                return ensureTerminal(converted, preferred: ".")
            }
        }

        // Fallback: frame any remaining question as a find-out mission.
        return ensureTerminal("Find out: \(capitalize(text))", preferred: ".")
    }

    /// Splits "Lead — what …" / "Lead. What …" style compounds.
    private static func splitTrailingQuestionClause(_ text: String) -> (lead: String, question: String)? {
        let separators = [" — ", " – ", " - ", ". "]
        for sep in separators {
            guard let range = text.range(of: sep) else { continue }
            let lead = String(text[..<range.lowerBound])
            let question = String(text[range.upperBound...])
            if looksLikeInterrogativeStem(question) || question.trimmingCharacters(in: .whitespaces).hasSuffix("?") {
                return (lead, question)
            }
        }
        return nil
    }

    /// "What does Tess do …" → "Check what Tess do …" → "Check what Tess does …".
    private static func fixDoesDoAgreement(_ text: String) -> String {
        guard let regex = try? NSRegularExpression(
            pattern: #"(Check what )((?:(?:Mr|Mrs|Ms|Dr|St)\.\s+)?[A-Za-z][A-Za-z'’\-]*) do\b"#,
            options: []
        ) else { return text }
        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(
            in: text,
            range: range,
            withTemplate: "$1$2 does"
        )
    }

    private static func looksLikeInterrogative(_ body: String) -> Bool {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasSuffix("?") { return true }
        return looksLikeInterrogativeStem(trimmed)
    }

    private static func looksLikeInterrogativeStem(_ text: String) -> Bool {
        looksLikeWhQuestionStem(text) || looksLikeAuxQuestionStem(text)
    }

    private static func looksLikeWhQuestionStem(_ text: String) -> Bool {
        let lower = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: ".!?"))
            .lowercased()
        let starters = ["what ", "why ", "how ", "which ", "when ", "where ", "who "]
        return starters.contains { lower.hasPrefix($0) }
    }

    private static func looksLikeAuxQuestionStem(_ text: String) -> Bool {
        let lower = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: ".!?"))
            .lowercased()
        let starters = [
            "is ", "are ", "do ", "does ", "did ", "can ", "could ", "would ", "should ", "will "
        ]
        return starters.contains { lower.hasPrefix($0) }
    }

    private static func capitalize(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.first else { return trimmed }
        return String(first).uppercased() + trimmed.dropFirst()
    }

    private static func ensureTerminal(_ text: String, preferred: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return trimmed }
        if trimmed.hasSuffix(".") || trimmed.hasSuffix("!") || trimmed.hasSuffix("?") {
            return trimmed
        }
        return trimmed + preferred
    }

    private struct Piece {
        let body: String
        let terminal: String
    }

    private static func splitKeepingTerminals(_ text: String) -> [Piece] {
        // Protect honorifics so "Mr. Bram" is not split into two sentences.
        var protected = text
        let abbreviations = ["Mr.", "Mrs.", "Ms.", "Dr.", "St."]
        for (index, abbr) in abbreviations.enumerated() {
            protected = protected.replacingOccurrences(of: abbr, with: "⟦ABBR\(index)⟧")
        }

        var pieces: [Piece] = []
        var current = ""
        for ch in protected {
            if ch == "." || ch == "!" || ch == "?" {
                let body = current.trimmingCharacters(in: .whitespacesAndNewlines)
                if !body.isEmpty {
                    pieces.append(Piece(body: restoreAbbreviations(body), terminal: String(ch)))
                }
                current = ""
            } else {
                current.append(ch)
            }
        }
        let trailing = current.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trailing.isEmpty {
            pieces.append(Piece(body: restoreAbbreviations(trailing), terminal: ""))
        }
        return pieces
    }

    private static func restoreAbbreviations(_ text: String) -> String {
        var restored = text
        let abbreviations = ["Mr.", "Mrs.", "Ms.", "Dr.", "St."]
        for (index, abbr) in abbreviations.enumerated() {
            restored = restored.replacingOccurrences(of: "⟦ABBR\(index)⟧", with: abbr)
        }
        return restored
    }
}
