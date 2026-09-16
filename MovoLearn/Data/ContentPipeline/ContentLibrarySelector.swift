import Foundation

/// Selects child-facing lessons only from the approved library, matching reading and math independently.
enum ContentLibrarySelector {

    struct SelectionResult {
        let lessons: [Lesson]
        /// True when no approved content matched; UI should not invent fallback of the wrong level.
        let contentUnavailable: Bool
        let unavailableReason: String?
    }

    static func selectDailyOptions(
        for profile: ChildProfile,
        count: Int = 4,
        completedIDs: Set<UUID> = []
    ) -> SelectionResult {
        let topics = profile.favoriteTopics
        var selected: [Lesson] = []
        var used = Set<UUID>()

        for category in LessonCategory.allCases {
            if let lesson = pick(
                profile: profile,
                category: category,
                topics: topics,
                excluding: used,
                completedIDs: completedIDs
            ) {
                selected.append(lesson)
                used.insert(lesson.id)
            }
            if selected.count >= count { break }
        }

        if selected.count < count {
            let extras = ApprovedContentLibrary.lessons(
                readingLevel: profile.readingLevel,
                mathLevel: profile.mathLevel,
                topics: topics
            ).filter { !used.contains($0.id) }
            for lesson in extras {
                selected.append(lesson)
                used.insert(lesson.id)
                if selected.count >= count { break }
            }
        }

        if selected.isEmpty {
            return SelectionResult(
                lessons: [],
                contentUnavailable: true,
                unavailableReason: "No approved lessons match reading \(profile.readingLevel.rawValue) and math \(profile.mathLevel.rawValue)."
            )
        }

        return SelectionResult(lessons: Array(selected.prefix(count)), contentUnavailable: false, unavailableReason: nil)
    }

    static func pool(for profile: ChildProfile) -> [Lesson] {
        let favorites = ApprovedContentLibrary.lessons(
            readingLevel: profile.readingLevel,
            mathLevel: profile.mathLevel,
            topics: profile.favoriteTopics
        )
        // Stay on favorite topics whenever possible — never dilute with unrelated themes.
        if !favorites.isEmpty { return favorites }
        return ApprovedContentLibrary.lessons(
            readingLevel: profile.readingLevel,
            mathLevel: profile.mathLevel
        )
    }

    /// Same-topic approved replacement when a legacy/off-level lesson is opened.
    /// Never substitutes a different theme (e.g. jungle → horses).
    static func replacement(for lesson: Lesson, profile: ChildProfile) -> Lesson? {
        let ability = LessonDifficultyRules.abilityProfile(for: profile)
        let themePool = ApprovedContentLibrary.lessons(
            readingLevel: ability.readingLevel,
            mathLevel: ability.mathLevel,
            topics: [lesson.theme]
        )
        guard !themePool.isEmpty else { return nil }

        let sameCategory = themePool.filter {
            $0.category == lesson.category || $0.primarySubject == lesson.primarySubject
        }
        let candidates = sameCategory.isEmpty ? themePool : sameCategory

        let exact = candidates.filter {
            $0.readingLevel == ability.readingLevel
                && ($0.primarySubject != .math || $0.mathLevel == ability.mathLevel)
        }
        let ranked = exact.isEmpty ? candidates : exact
        return RecentLessonStructureTracker.rankForNovelty(ranked).first
    }

    /// Best approved lesson for a topic at the child's current levels.
    static func preferredLesson(for topic: Topic, profile: ChildProfile) -> Lesson? {
        let ability = LessonDifficultyRules.abilityProfile(for: profile)
        let pool = ApprovedContentLibrary.lessons(
            readingLevel: ability.readingLevel,
            mathLevel: ability.mathLevel,
            topics: [topic]
        )
        guard !pool.isEmpty else { return nil }
        let stories = pool.filter { $0.category == .story }
        let preferred = stories.isEmpty ? pool : stories
        return RecentLessonStructureTracker.rankForNovelty(preferred).first
    }

    private static func pick(
        profile: ChildProfile,
        category: LessonCategory,
        topics: [Topic],
        excluding: Set<UUID>,
        completedIDs: Set<UUID>
    ) -> Lesson? {
        let exact = ApprovedContentLibrary.exactMatches(
            readingLevel: profile.readingLevel,
            mathLevel: profile.mathLevel,
            topics: topics,
            category: category
        ).filter { !excluding.contains($0.id) }

        let near = ApprovedContentLibrary.lessons(
            readingLevel: profile.readingLevel,
            mathLevel: profile.mathLevel,
            topics: topics,
            category: category
        ).filter { !excluding.contains($0.id) }

        let pool = !exact.isEmpty ? exact : near
        guard !pool.isEmpty else {
            // Do not substitute a different academic level.
            return nil
        }

        let uncompleted = pool.filter { !completedIDs.contains($0.id) }
        let finalPool = uncompleted.isEmpty ? pool : uncompleted
        let bestScore = finalPool.map { LessonDifficultyRules.matchScore(lesson: $0, profile: profile) }.max() ?? 0
        let top = finalPool.filter { LessonDifficultyRules.matchScore(lesson: $0, profile: profile) == bestScore }
        return RecentLessonStructureTracker.rankForNovelty(top).first
    }
}
