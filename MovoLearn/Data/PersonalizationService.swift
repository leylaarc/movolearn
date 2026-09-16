import Foundation

/// Central helper for warm, natural personalization copy.
/// Prefer this over scattering `profile.nickname` through views.
@MainActor
final class PersonalizationService {
    static let shared = PersonalizationService()

    private(set) var profile: ChildProfile?

    private init() {}

    func update(_ profile: ChildProfile?) {
        self.profile = profile
    }

    /// Saved display name, or empty when unset.
    var displayName: String {
        let trimmed = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed
    }

    var hasDisplayName: Bool {
        !displayName.isEmpty
    }

    /// Natural fallback when no name exists ("there", not blank / Optional).
    var greetingName: String {
        hasDisplayName ? displayName : "there"
    }

    /// For sentences like "…make ___ light up" — uses "your child" when unnamed.
    var childReference: String {
        hasDisplayName ? displayName : "your child"
    }

    /// Possessive form: "Mia's" / "their".
    var possessiveName: String {
        if hasDisplayName {
            if displayName.lowercased().hasSuffix("s") {
                return "\(displayName)’"
            }
            return "\(displayName)’s"
        }
        return "their"
    }

    func greeting(prefix: String = "Hello") -> String {
        "\(prefix), \(greetingName)!"
    }

    /// Formats Marble-style templates such as `{{name}}` safely for display.
    func formatTemplate(_ template: String) -> String {
        TemplateFormatter.format(template, name: displayName)
    }
}

enum TemplateFormatter {
    /// Replaces supported placeholders and cleans awkward punctuation.
    static func format(_ template: String, name: String) -> String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let resolvedName = trimmedName.isEmpty ? "your child" : trimmedName

        var result = template
        let replacements: [(String, String)] = [
            ("{{name}}", resolvedName),
            ("{{Name}}", resolvedName),
            ("{{NAME}}", resolvedName),
            ("{name}", resolvedName),
            ("{{childName}}", resolvedName),
        ]
        for (token, value) in replacements {
            result = result.replacingOccurrences(of: token, with: value)
        }

        // Never leave raw template syntax visible.
        if let regex = try? NSRegularExpression(pattern: #"\{\{[^}]+\}\}"#) {
            let range = NSRange(result.startIndex..., in: result)
            result = regex.stringByReplacingMatches(in: result, range: range, withTemplate: resolvedName)
        }

        result = result
            .replacingOccurrences(of: "  ", with: " ")
            .replacingOccurrences(of: " ,", with: ",")
            .replacingOccurrences(of: " .", with: ".")
            .replacingOccurrences(of: " ?", with: "?")
            .replacingOccurrences(of: " !", with: "!")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return result
    }
}
