import Foundation
import OSLog

private let responseTypeLog = Logger(subsystem: "com.movolearn.app", category: "QuestionResponseType")

/// Explicit UI response modality for every question / creative prompt.
enum QuestionResponseType: String, Codable, CaseIterable, Equatable {
    case drawing
    case shortText
    case longText
    case multipleChoice
    case number
    case matching
    case sorting

    /// Safe display type when data is missing or incompatible.
    static let fallback: QuestionResponseType = .longText
}

/// One left↔right pair for matching questions.
struct MatchingPair: Codable, Equatable, Identifiable, Hashable {
    var id: UUID
    let left: String
    let right: String
    /// Exact sentence or excerpt from the reading passage that proves this match.
    /// Required for newly generated matching questions; optional for legacy decode.
    let supportingEvidence: String?

    init(id: UUID = UUID(), left: String, right: String, supportingEvidence: String? = nil) {
        self.id = id
        self.left = left
        self.right = right
        self.supportingEvidence = supportingEvidence
    }

    enum CodingKeys: String, CodingKey {
        case id, left, right, supportingEvidence
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        left = try container.decode(String.self, forKey: .left)
        right = try container.decode(String.self, forKey: .right)
        supportingEvidence = try container.decodeIfPresent(String.self, forKey: .supportingEvidence)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(left, forKey: .left)
        try container.encode(right, forKey: .right)
        try container.encodeIfPresent(supportingEvidence, forKey: .supportingEvidence)
    }
}

/// One sortable row with its correct position (1-based).
struct SortingItem: Codable, Equatable, Identifiable, Hashable {
    let id: String
    let text: String
    let correctPosition: Int

    init(id: String = UUID().uuidString, text: String, correctPosition: Int) {
        self.id = id
        self.text = text
        self.correctPosition = correctPosition
    }
}

enum QuestionResponseTypeResolver {

    struct InferenceContext {
        var lessonID: UUID?
        var lessonTitle: String?
        var questionID: UUID?
    }

    /// Resolves the response type from structured fields first, then safe inference for legacy content.
    static func resolve(
        explicit: QuestionResponseType?,
        questionType: QuestionType,
        subject: QuestionSubject,
        prompt: String,
        choices: [String],
        pairs: [MatchingPair] = [],
        items: [SortingItem] = [],
        context: InferenceContext = InferenceContext(),
        wasInferred: inout Bool
    ) -> QuestionResponseType {
        wasInferred = false

        if let explicit {
            return sanitize(
                explicit,
                questionType: questionType,
                prompt: prompt,
                choices: choices,
                pairs: pairs,
                items: items
            )
        }

        // Prefer structured interaction data over prompt heuristics.
        if pairs.count >= 2 {
            wasInferred = true
            logInference(inferred: .matching, prompt: prompt, context: context)
            return .matching
        }
        if items.count >= 2 {
            wasInferred = true
            logInference(inferred: .sorting, prompt: prompt, context: context)
            return .sorting
        }

        if questionType == .multipleChoice || !choices.isEmpty {
            wasInferred = true
            logInference(inferred: .multipleChoice, prompt: prompt, context: context)
            return .multipleChoice
        }

        let inferred = inferFromPrompt(prompt, subject: subject)
        wasInferred = true
        logInference(inferred: inferred, prompt: prompt, context: context)
        return inferred
    }

    /// Convenience when the caller does not need the inferred flag.
    static func resolve(
        explicit: QuestionResponseType?,
        questionType: QuestionType,
        subject: QuestionSubject,
        prompt: String,
        choices: [String],
        pairs: [MatchingPair] = [],
        items: [SortingItem] = [],
        context: InferenceContext = InferenceContext()
    ) -> QuestionResponseType {
        var inferred = false
        return resolve(
            explicit: explicit,
            questionType: questionType,
            subject: subject,
            prompt: prompt,
            choices: choices,
            pairs: pairs,
            items: items,
            context: context,
            wasInferred: &inferred
        )
    }

    /// Infers response type from prompt + subject when structured data is absent.
    /// Bundled lessons must not rely on this — it exists only for legacy/external content.
    static func inferFromPrompt(_ prompt: String, subject: QuestionSubject) -> QuestionResponseType {
        let lower = prompt.lowercased()

        if looksLikeDrawingPrompt(lower) {
            return .drawing
        }
        if looksLikeNumberPrompt(lower, subject: subject) {
            return .number
        }
        if looksLikeMatchingPrompt(lower) {
            return .matching
        }
        if looksLikeSortingPrompt(lower) {
            return .sorting
        }
        if subject == .reflection || looksLikeShortText(lower) {
            return .shortText
        }
        return .longText
    }

    static func sanitize(
        _ type: QuestionResponseType,
        questionType: QuestionType,
        prompt: String,
        choices: [String],
        pairs: [MatchingPair],
        items: [SortingItem]
    ) -> QuestionResponseType {
        switch type {
        case .multipleChoice:
            if choices.count < 2 {
                responseTypeLog.error("multipleChoice without enough choices — falling back to longText")
                return .fallback
            }
            return .multipleChoice
        case .matching:
            if pairs.count < 2 {
                responseTypeLog.error("matching without pairs — falling back to longText")
                return .fallback
            }
            return .matching
        case .sorting:
            if items.count < 2 {
                responseTypeLog.error("sorting without items — falling back to longText")
                return .fallback
            }
            return .sorting
        case .drawing:
            if !choices.isEmpty && questionType == .multipleChoice && pairs.isEmpty {
                responseTypeLog.error("drawing typed as multipleChoice — using multipleChoice")
                return .multipleChoice
            }
            return .drawing
        case .number, .shortText, .longText:
            // Never ask a child to draw without a canvas.
            if looksLikeDrawingPrompt(prompt.lowercased()) {
                responseTypeLog.warning("Prompt asks to draw but type was \(type.rawValue) — upgrading to drawing")
                return .drawing
            }
            return type
        }
    }

    /// Aligns creative prompt wording with response type so we never say "draw" without a canvas.
    static func alignedCreative(
        prompt: String,
        responseType: QuestionResponseType
    ) -> (prompt: String, responseType: QuestionResponseType) {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return (trimmed, responseType) }

        // If the prompt asks the child to draw, always provide a drawing response type.
        if looksLikeDrawingPrompt(trimmed.lowercased()) {
            return (ChildFacingProseQualityValidator.polish(trimmed), .drawing)
        }

        return (ChildFacingProseQualityValidator.polish(trimmed), responseType)
    }

    /// Creative / Art Quest sessions should not ask 5–8 year olds to "write four sentences".
    static func preferDrawingForCreativeSession(
        title: String,
        mission: String,
        prompt: String,
        responseType: QuestionResponseType,
        category: LessonCategory
    ) -> (mission: String, prompt: String, responseType: QuestionResponseType) {
        let lowerTitle = title.lowercased()
        let lowerPrompt = prompt.lowercased()
        let lowerMission = mission.lowercased()
        let writeFour = lowerPrompt.contains("write four")
            || lowerMission.contains("write four")
        let writingPrompt = lowerPrompt.hasPrefix("write ")
            || lowerMission.contains("write and ")
            || writeFour
        let visualTitle = ["art", "camouflage", "design", "invent", "draw", "creature", "poster", "comic", "portrait", "badge"]
            .contains { lowerTitle.contains($0) }
        let shouldDraw = category == .creative && writingPrompt && (writeFour || visualTitle)
        guard shouldDraw else {
            return (
                ChildFacingProseQualityValidator.polish(mission),
                ChildFacingProseQualityValidator.polish(prompt),
                responseType
            )
        }
        if looksLikeDrawingPrompt(prompt.lowercased()) {
            return (
                ChildFacingProseQualityValidator.polish(rewriteWritingActionToDraw(mission, title: title)),
                ChildFacingProseQualityValidator.polish(prompt),
                .drawing
            )
        }
        return (
            ChildFacingProseQualityValidator.polish(rewriteWritingActionToDraw(mission, title: title)),
            drawingPrompt(fromWriting: prompt, title: title),
            .drawing
        )
    }

    private static func drawingPrompt(fromWriting prompt: String, title: String) -> String {
        var details = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let prefixes = [
            "Write four sentences describing ",
            "Write four sentences naming ",
            "Write four sentences explaining ",
            "Write four sentences for ",
            "Write four sentences ",
            "Write four short panel descriptions in order: ",
            "Write a postcard of four sentences ",
            "Write a short ",
            "Write "
        ]
        for prefix in prefixes {
            if let range = details.range(of: prefix, options: .caseInsensitive) {
                details = String(details[range.upperBound...])
                break
            }
        }
        details = details.trimmingCharacters(in: .whitespacesAndNewlines)
        if details.lowercased().hasPrefix("your ") {
            details = String(details.dropFirst(5))
        }
        if let colon = details.firstIndex(of: ":") {
            details = String(details[details.index(after: colon)...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if details.hasSuffix(".") {
            details.removeLast()
        }
        let subject = visualSubject(from: title).lowercased()
        if details.isEmpty || looksUndrawable(details) {
            if subject.contains("whisker") {
                return ChildFacingProseQualityValidator.polish("Draw a cat with long whiskers walking through a tight space.")
            }
            return ChildFacingProseQualityValidator.polish("Draw \(subject).")
        }
        return ChildFacingProseQualityValidator.polish("Draw \(subject). Show \(details).")
    }

    private static func looksUndrawable(_ details: String) -> Bool {
        let lower = details.lowercased()
        return lower.contains("why ")
            || lower.contains("should not")
            || lower.contains("design plan")
            || lower.contains("demo plan")
    }

    private static func visualSubject(from title: String) -> String {
        var text = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let prefixes = ["Invent a ", "Invent an ", "Design a ", "Design an ", "Design ", "Draw a ", "Draw an ", "Draw "]
        for prefix in prefixes {
            if text.lowercased().hasPrefix(prefix.lowercased()) {
                text = String(text.dropFirst(prefix.count))
                break
            }
        }
        return text.prefix(1).lowercased() + text.dropFirst()
    }

    private static func rewriteWritingActionToDraw(_ text: String, title: String) -> String {
        let patterns: [(String, String)] = [
            (#"(?i)write and describe"#, "draw"),
            (#"(?i)write and design"#, "draw"),
            (#"(?i)write four sentences"#, "draw"),
            (#"(?i)write a "#, "draw a "),
            (#"(?i)write your "#, "draw your "),
            (#"(?i)write the "#, "draw the "),
            (#"(?i)write "#, "draw ")
        ]
        var result = text
        for (pattern, replacement) in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern),
                  let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)),
                  let range = Range(match.range, in: result) else {
                continue
            }
            let original = String(result[range])
            let swap = original.first?.isUppercase == true
                ? replacement.prefix(1).uppercased() + replacement.dropFirst()
                : replacement
            result.replaceSubrange(range, with: String(swap))
            break
        }
        let lower = result.lowercased()
        if lower.contains("design plan") || lower.contains("whisker design") || lower.contains("demo plan") {
            if lower.contains("whisker") || title.lowercased().contains("whisker") {
                return ChildFacingProseQualityValidator.polish("Draw a cat using its long whiskers.")
            }
            return ChildFacingProseQualityValidator.polish("Draw \(visualSubject(from: title).lowercased()).")
        }
        return ChildFacingProseQualityValidator.polish(result)
    }

    static func looksLikeDrawingPrompt(_ lower: String) -> Bool {
        // Avoid false positives like "drawbridge".
        if lower.contains("drawbridge") { return false }

        let drawingPhrases = [
            "draw ", "draw a ", "draw an ", "draw the ", "draw your ", "draw what",
            "draw one ", "draw two ", "draw three ",
            "illustrate ", "sketch ", "paint ", "color a picture", "color the"
        ]
        if drawingPhrases.contains(where: {
            lower.hasPrefix($0)
                || lower.contains(". \($0)")
                || lower.contains(": \($0)")
                || lower.contains(", \($0)")
                || lower.contains(" then \($0)")
                || lower.contains(" and \($0)")
        }) {
            return true
        }
        if lower.hasPrefix("design ") || lower.contains(" design a ") || lower.contains(" design your ") {
            if lower.contains("describe") || lower.contains("write ") || lower.contains("list ") {
                return false
            }
            return true
        }
        return false
    }

    private static func looksLikeNumberPrompt(_ lower: String, subject: QuestionSubject) -> Bool {
        if subject == .math && !lower.contains("?") {
            return true
        }
        let cues = ["how many", "what number", "write the number", "enter the number", "type the number"]
        return cues.contains(where: { lower.contains($0) }) && subject == .math
    }

    private static func looksLikeMatchingPrompt(_ lower: String) -> Bool {
        lower.contains("match ") || lower.contains("match each") || lower.hasPrefix("match")
    }

    private static func looksLikeSortingPrompt(_ lower: String) -> Bool {
        lower.contains("sort ") || lower.contains("put in order") || lower.contains("arrange ")
            || lower.contains("correct order")
    }

    private static func looksLikeShortText(_ lower: String) -> Bool {
        lower.count < 80
            || lower.hasPrefix("what ")
            || lower.hasPrefix("who ")
            || lower.hasPrefix("why ")
            || lower.hasPrefix("how did")
            || lower.hasPrefix("how do you feel")
            || lower.hasPrefix("name ")
    }

    private static func logInference(
        inferred: QuestionResponseType,
        prompt: String,
        context: InferenceContext
    ) {
        let lessonID = context.lessonID?.uuidString ?? "unknown-lesson"
        let questionID = context.questionID?.uuidString ?? "unknown-question"
        let title = context.lessonTitle ?? "(untitled)"
        let truncated = prompt.count > 120 ? String(prompt.prefix(117)) + "…" : prompt
        #if DEBUG
        responseTypeLog.warning("""
        [responseType inference] Bundled/legacy content is missing an explicit responseType.
        lessonID=\(lessonID) lessonTitle=\(title) questionID=\(questionID)
        prompt="\(truncated)"
        inferredResponseType=\(inferred.rawValue)
        """)
        print("""
        ⚠️ responseType inference used
          lessonID: \(lessonID)
          lessonTitle: \(title)
          questionID: \(questionID)
          prompt: \(truncated)
          inferred: \(inferred.rawValue)
        """)
        #endif
    }
}

/// Makes child-facing prompts clearer before display / storage.
enum PromptWordingNormalizer {

    static func normalize(_ prompt: String) -> String {
        var text = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return text }

        let drawPatterns: [(String, String)] = [
            (#"(?i)^Draw your (.+)$"#, "Draw a picture of your $1"),
            (#"(?i)^Draw a (.+)$"#, "Draw a picture of a $1"),
            (#"(?i)^Draw an (.+)$"#, "Draw a picture of an $1"),
            (#"(?i)^Draw the (.+)$"#, "Draw a picture of the $1"),
            (#"(?i)^Draw what (.+)$"#, "Draw a picture of what $1"),
            (#"(?i)^Illustrate (.+)$"#, "Draw a picture that shows $1"),
            (#"(?i)^Sketch (.+)$"#, "Draw a picture of $1")
        ]

        for (pattern, template) in drawPatterns {
            if text.lowercased().contains("picture of") || text.lowercased().contains("draw a picture") {
                break
            }
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
               match.range.length == (text as NSString).length {
                text = regex.stringByReplacingMatches(
                    in: text,
                    range: NSRange(text.startIndex..., in: text),
                    withTemplate: template
                )
                break
            }
        }

        if !text.hasSuffix(".") && !text.hasSuffix("?") && !text.hasSuffix("!") {
            text += "."
        }

        if let first = text.first, first.isLowercase {
            text = first.uppercased() + text.dropFirst()
        }

        return ChildFacingProseQualityValidator.polish(text)
    }
}
