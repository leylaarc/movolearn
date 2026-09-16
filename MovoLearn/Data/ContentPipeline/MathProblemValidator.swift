import Foundation

/// Deterministic math validation — never rely solely on AI self-checks.
enum MathProblemValidator {

    struct Issue: Equatable {
        let code: String
        let message: String
    }

    struct Result: Equatable {
        let passed: Bool
        let issues: [Issue]

        static let ok = Result(passed: true, issues: [])
    }

    enum DetectedOperation: String {
        case addition, subtraction, multiplication, division, comparison, counting, unknown
    }

    static func validate(
        _ question: LessonQuestion,
        mathLevel: MathLevel,
        recentPrompts: [String] = []
    ) -> Result {
        var issues: [Issue] = []

        guard question.subject == .math else {
            return Result(passed: false, issues: [
                Issue(code: "wrong_subject", message: "Expected a math question")
            ])
        }

        let prompt = question.prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty else {
            issues.append(Issue(code: "empty_prompt", message: "Math prompt is empty"))
            return Result(passed: false, issues: issues)
        }

        if prompt.count < 12 {
            issues.append(Issue(code: "ambiguous_wording", message: "Prompt is too short to be unambiguous"))
        }

        let choices = question.choices.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        if question.responseType == .multipleChoice || !choices.isEmpty {
            if choices.count < 2 {
                issues.append(Issue(code: "missing_choices", message: "Multiple-choice math needs at least 2 choices"))
            }
            let lower = choices.map { $0.lowercased() }
            if Set(lower).count != lower.count {
                issues.append(Issue(code: "duplicate_choices", message: "Answer choices contain duplicates"))
            }
        }

        guard let correctRaw = question.correctAnswer?.trimmingCharacters(in: .whitespacesAndNewlines),
              !correctRaw.isEmpty else {
            issues.append(Issue(code: "missing_answer", message: "Correct answer is missing"))
            return Result(passed: false, issues: issues)
        }

        if !choices.isEmpty {
            let matchCount = choices.filter { $0.caseInsensitiveCompare(correctRaw) == .orderedSame }.count
            if matchCount == 0 {
                issues.append(Issue(code: "answer_not_in_choices", message: "Correct answer is not among choices"))
            } else if matchCount > 1 {
                issues.append(Issue(code: "multiple_correct", message: "More than one choice matches the correct answer"))
            }
        }

        let operation = detectOperation(in: prompt)
        if let numericAnswer = parseNumber(correctRaw) {
            if let computed = tryComputeAnswer(prompt: prompt, operation: operation) {
                if abs(computed - numericAnswer) > 0.0001 {
                    issues.append(Issue(
                        code: "incorrect_answer",
                        message: "Stated answer \(correctRaw) does not match computed \(formatNumber(computed))"
                    ))
                }
            }

            let range = LevelSkillProgressions.mathNumberRange(for: mathLevel)
            let intsInPrompt = extractIntegers(from: prompt)
            for value in intsInPrompt + [Int(numericAnswer.rounded())] {
                if value < range.lowerBound || value > range.upperBound {
                    // Allow slightly larger intermediate values for advancing multi-step.
                    if mathLevel != .advancing || value > range.upperBound * 2 {
                        issues.append(Issue(
                            code: "number_range",
                            message: "Number \(value) is outside level range \(range.lowerBound)–\(range.upperBound)"
                        ))
                        break
                    }
                }
            }

            if !LevelSkillProgressions.allowsMultiStepMath(for: mathLevel),
               looksMultiStep(prompt) {
                issues.append(Issue(
                    code: "multi_step_not_allowed",
                    message: "Multi-step problem is not appropriate for \(mathLevel.rawValue)"
                ))
            }
        } else if correctRaw.contains("/") {
            if !isValidFraction(correctRaw) {
                issues.append(Issue(code: "invalid_fraction", message: "Fraction answer is not valid"))
            }
        }

        if unitsInconsistent(prompt) {
            issues.append(Issue(code: "unit_mismatch", message: "Units appear inconsistent in the prompt"))
        }

        let normalized = normalizePrompt(prompt)
        if recentPrompts.map(normalizePrompt).contains(normalized) {
            issues.append(Issue(code: "duplicate_recent", message: "Problem is too similar to a recently shown question"))
        }

        if operation == .unknown,
           question.explanation?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            issues.append(Issue(code: "unclear_operation", message: "Could not determine the intended operation"))
        }

        return Result(passed: issues.isEmpty, issues: issues)
    }

    static func validateAll(
        _ questions: [LessonQuestion],
        mathLevel: MathLevel
    ) -> Result {
        var allIssues: [Issue] = []
        var prompts: [String] = []
        for question in questions {
            let result = validate(question, mathLevel: mathLevel, recentPrompts: prompts)
            allIssues.append(contentsOf: result.issues)
            prompts.append(question.prompt)
        }
        return Result(passed: allIssues.isEmpty, issues: allIssues)
    }

    // MARK: - Helpers

    static func detectOperation(in prompt: String) -> DetectedOperation {
        let p = prompt.lowercased()
        if p.contains("how many more") || p.contains("how much longer") || p.contains("minus")
            || p.contains("subtract") || p.contains("gives away") || p.contains("have left")
            || p.contains("are left") || p.contains("gives ") && p.contains("then") {
            return .subtraction
        }
        if p.contains("rows of") || p.contains("packs of") || p.contains("groups of")
            || p.contains("each pack") || p.contains("in each") || p.contains("times")
            || p.contains("equal groups")
            || p.contains("baskets of") || p.contains("crates of") || p.contains("chests of")
            || p.contains("trays of") || p.contains("boxes of") {
            // Division phrasing often includes "groups of" too — prefer division when sharing/splitting.
            if p.contains("share") || p.contains("equally") || p.contains("each friend")
                || p.contains("how many full") || p.contains("divided") {
                return .division
            }
            return .multiplication
        }
        if p.contains("share") || p.contains("split") || p.contains("divided") || p.contains("each gets")
            || p.contains("how many full groups") || p.contains("how many full boxes") {
            return .division
        }
        if p.contains("in all") || p.contains("altogether") || p.contains("plus") || p.contains("add")
            || p.contains("joined") || p.contains("more arrived")
            || (p.contains("finds") && p.contains("more") && p.contains("how many")) {
            return .addition
        }
        if p.contains("more than") || p.contains("less than") || p.contains("greater") || p.contains("fewer")
            || p.contains("which side has more") || p.contains("has more") {
            return .comparison
        }
        if p.contains("count") || p.contains("how many") {
            return .counting
        }
        return .unknown
    }

    private static func tryComputeAnswer(prompt: String, operation: DetectedOperation) -> Double? {
        let nums = extractIntegers(from: prompt).map(Double.init)
        let p = prompt.lowercased()

        // Multi-step: a×b then −c
        if p.contains("then"), nums.count >= 3,
           (p.contains("packs") || p.contains("each pack") || p.contains("in each")
            || p.contains("rows") || p.contains("baskets") || p.contains("crates")
            || p.contains("chests") || p.contains("trays") || p.contains("boxes")) {
            return nums[0] * nums[1] - nums[2]
        }

        guard nums.count >= 2 else {
            if operation == .counting, let only = nums.first { return only }
            return nil
        }
        let a = nums[0]
        let b = nums[1]
        switch operation {
        case .addition: return a + b
        case .subtraction: return abs(a - b)
        case .multiplication: return a * b
        case .division:
            guard b != 0, a.truncatingRemainder(dividingBy: b) == 0 else { return nil }
            return a / b
        case .comparison: return a > b ? a : b
        case .counting: return nums.last
        case .unknown:
            if p.contains("in all") || p.contains("altogether") {
                return a + b
            }
            return nil
        }
    }

    static func extractIntegers(from text: String) -> [Int] {
        let pattern = #"-?\d+"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            guard let r = Range(match.range, in: text) else { return nil }
            return Int(text[r])
        }
    }

    static func parseNumber(_ raw: String) -> Double? {
        let cleaned = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: "")
        if let value = Double(cleaned) { return value }
        if cleaned.contains("/") {
            let parts = cleaned.split(separator: "/").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
            guard parts.count == 2, parts[1] != 0 else { return nil }
            return parts[0] / parts[1]
        }
        return nil
    }

    private static func isValidFraction(_ raw: String) -> Bool {
        let parts = raw.split(separator: "/").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard parts.count == 2 else { return false }
        return parts[1] != 0
    }

    private static func looksMultiStep(_ prompt: String) -> Bool {
        let p = prompt.lowercased()
        let cues = ["then", "after that", "next,", "first,", "second,", "finally"]
        return cues.filter { p.contains($0) }.count >= 2 || (p.contains("then") && extractIntegers(from: prompt).count >= 3)
    }

    private static func unitsInconsistent(_ prompt: String) -> Bool {
        let p = prompt.lowercased()
        let hasInches = p.contains("inch")
        let hasCm = p.contains("centimeter") || p.contains("cm")
        if hasInches && hasCm { return true }
        return false
    }

    private static func normalizePrompt(_ prompt: String) -> String {
        prompt.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private static func formatNumber(_ value: Double) -> String {
        if value.rounded() == value { return String(Int(value)) }
        return String(format: "%.2f", value)
    }
}
