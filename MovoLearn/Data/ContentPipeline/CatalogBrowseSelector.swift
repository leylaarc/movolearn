import Foundation

/// One topic’s level-matched adventures, used to group the combined catalog.
struct CatalogTopicGroup: Identifiable {
    var id: String { topic.rawValue }
    let topic: Topic
    let lessons: [Lesson]
}

/// Builds a child-facing browse catalog that feels like a real content library:
/// approved, level-matched lessons for the child’s reading and math pack.
enum CatalogBrowseSelector {

    /// Every approved lesson at the child’s current reading and math level.
    static func levelMatchedLessons(from lessons: [Lesson], profile: ChildProfile) -> [Lesson] {
        let ability = LessonDifficultyRules.abilityProfile(for: profile)
        return lessons.filter { lesson in
            lesson.isApprovedForChildDisplay
                && lesson.readingLevel == ability.readingLevel
                && lesson.mathLevel == ability.mathLevel
        }
        .sorted { lhs, rhs in
            if lhs.theme != rhs.theme {
                return topicSortKey(lhs.theme, favorites: profile.favoriteTopics)
                    < topicSortKey(rhs.theme, favorites: profile.favoriteTopics)
            }
            if lhs.category != rhs.category {
                return categorySortKey(lhs.category) < categorySortKey(rhs.category)
            }
            return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        }
    }

    /// Groups level-matched lessons by topic, favorites first.
    static func groupedByTopic(_ lessons: [Lesson], favoriteTopics: [Topic]) -> [CatalogTopicGroup] {
        let grouped = Dictionary(grouping: lessons, by: \.theme)
        let favoriteOrder = favoriteTopics
        let remaining = Topic.allCases.filter { !favoriteOrder.contains($0) }
        return (favoriteOrder + remaining).compactMap { topic in
            guard var items = grouped[topic], !items.isEmpty else { return nil }
            items.sort {
                if $0.category != $1.category {
                    return categorySortKey($0.category) < categorySortKey($1.category)
                }
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
            return CatalogTopicGroup(topic: topic, lessons: items)
        }
    }

    /// Best story / math / discovery / creative for a single interest topic.
    static func lessons(for topic: Topic, profile: ChildProfile) -> [Lesson] {
        let ability = LessonDifficultyRules.abilityProfile(for: profile)
        var picked: [Lesson] = []
        var used = Set<UUID>()

        for category in LessonCategory.allCases {
            if let lesson = best(
                topic: topic,
                category: category,
                reading: ability.readingLevel,
                math: ability.mathLevel,
                excluding: used
            ) {
                picked.append(lesson)
                used.insert(lesson.id)
            }
        }
        return picked
    }

    /// Subject browse: featured adventures grouped by topic identity (never cross-mix pets into jungle).
    static func lessons(for subject: ExploreSubjectCategory, profile: ChildProfile) -> [Lesson] {
        var picked: [Lesson] = []
        var used = Set<UUID>()
        for topic in subject.topics {
            for lesson in lessons(for: topic, profile: profile) {
                guard used.insert(lesson.id).inserted else { continue }
                picked.append(lesson)
                if picked.count >= 16 { return picked }
            }
        }
        return picked
    }

    private static func best(
        topic: Topic,
        category: LessonCategory,
        reading: ReadingLevel,
        math: MathLevel,
        excluding: Set<UUID>
    ) -> Lesson? {
        let exact = ApprovedContentLibrary.exactMatches(
            readingLevel: reading,
            mathLevel: math,
            topics: [topic],
            category: category
        ).filter { !excluding.contains($0.id) }
        if let hit = exact.first { return hit }

        let near = ApprovedContentLibrary.lessons(
            readingLevel: reading,
            mathLevel: math,
            topics: [topic],
            category: category
        ).filter { !excluding.contains($0.id) }
        return near.first
    }

    private static func topicSortKey(_ topic: Topic, favorites: [Topic]) -> (Int, String) {
        if let index = favorites.firstIndex(of: topic) {
            return (index, topic.rawValue)
        }
        return (1000 + (Topic.allCases.firstIndex(of: topic) ?? 0), topic.rawValue)
    }

    private static func categorySortKey(_ category: LessonCategory) -> Int {
        LessonCategory.allCases.firstIndex(of: category) ?? 0
    }
}
