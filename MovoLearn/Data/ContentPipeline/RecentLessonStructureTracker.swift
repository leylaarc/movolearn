import Foundation

/// Tracks recently served activity fingerprints so Home avoids repeating the same
/// story structure / activity shape back-to-back.
enum RecentLessonStructureTracker {
    private static let defaultsKey = "movo.recentLessonStructureFingerprints"
    private static let maxStored = 24
    private static let lock = NSLock()

    static func fingerprint(for lesson: Lesson) -> String {
        // Prefer curated fingerprint embedded in learning objectives / skills when present.
        if let tagged = lesson.learningObjectives.first(where: { $0.hasPrefix("fp:") }) {
            return String(tagged.dropFirst(3))
        }
        let title = lesson.title.lowercased()
        let skill = lesson.readingSkill.lowercased()
        let category = lesson.category.rawValue
        let theme = lesson.theme.rawValue.lowercased()
        let qShape = lesson.questions.prefix(2).map { promptShape($0.prompt) }.joined(separator: "|")
        return [theme, category, skill, title, qShape].joined(separator: "::")
    }

    static func recentlyUsedFingerprints() -> [String] {
        lock.lock()
        defer { lock.unlock() }
        return UserDefaults.standard.stringArray(forKey: defaultsKey) ?? []
    }

    static func record(lesson: Lesson) {
        let fp = fingerprint(for: lesson)
        lock.lock()
        defer { lock.unlock() }
        var list = UserDefaults.standard.stringArray(forKey: defaultsKey) ?? []
        list.removeAll { $0 == fp }
        list.insert(fp, at: 0)
        if list.count > maxStored {
            list = Array(list.prefix(maxStored))
        }
        UserDefaults.standard.set(list, forKey: defaultsKey)
    }

    /// Prefer lessons whose structure was not served recently.
    static func rankForNovelty(_ lessons: [Lesson]) -> [Lesson] {
        let recent = Set(recentlyUsedFingerprints())
        return lessons.sorted { a, b in
            let aRecent = recent.contains(fingerprint(for: a))
            let bRecent = recent.contains(fingerprint(for: b))
            if aRecent != bRecent { return !aRecent && bRecent }
            return a.title < b.title
        }
    }

    private static func promptShape(_ prompt: String) -> String {
        let lower = prompt.lowercased()
        if lower.contains("how many") { return "how-many" }
        if lower.contains("main") { return "main-idea" }
        if lower.contains("where") { return "where" }
        if lower.contains("why") { return "why" }
        if lower.contains("infer") || lower.contains("conclude") { return "infer" }
        if lower.contains("which") { return "which" }
        return "other"
    }
}
