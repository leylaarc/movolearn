import Foundation

/// Selects a daily lesson based on child interests, variety, and completion history.
struct DailyLessonSelector {

    struct SelectionContext {
        let profile: ChildProfile
        let completedLessonIDs: Set<UUID>
        let recentLessonTypes: [LessonType]
        let lastLessonID: UUID?
        let lastTopic: Topic?
    }

    /// Builds 3–4 personalized lesson options (one per category) for the Home chooser.
    /// Only returns approved, level-matched content — never live unvalidated generation.
    static func selectTodaysOptions(context: SelectionContext) -> [Lesson] {
        let result = ContentLibrarySelector.selectDailyOptions(
            for: context.profile,
            count: 4,
            completedIDs: context.completedLessonIDs
        )
        return result.lessons
    }

    /// Returns the best lesson for today from the approved library.
    static func selectLesson(context: SelectionContext) -> Lesson {
        if let lesson = selectTodaysOptions(context: context).first {
            return lesson
        }
        // Last resort: any approved lesson at the child's exact levels (may ignore interests).
        return ApprovedContentLibrary.exactMatches(
            readingLevel: context.profile.readingLevel,
            mathLevel: context.profile.mathLevel,
            topics: context.profile.favoriteTopics,
            category: .story
        ).first
            ?? ApprovedContentLibrary.exactMatches(
                readingLevel: context.profile.readingLevel,
                mathLevel: context.profile.mathLevel,
                topics: [],
                category: .story
            ).first
            ?? ApprovedContentLibrary.lessons(
                readingLevel: context.profile.readingLevel,
                mathLevel: context.profile.mathLevel,
                topics: context.profile.favoriteTopics
            ).first
            ?? ApprovedContentLibrary.lessons(
                readingLevel: context.profile.readingLevel,
                mathLevel: context.profile.mathLevel
            ).first
            ?? LessonLoader.fallbackLesson
            ?? LevelSpecificContentFactory.makeApprovedLesson(
                topic: context.profile.favoriteTopics.first ?? .space,
                category: .story,
                readingLevel: context.profile.readingLevel,
                mathLevel: context.profile.mathLevel
            )
            ?? BundledLessonsExtended.canopyClassroom
    }

    static func suggestedNextTopic(
        favorites: [Topic],
        currentLesson: Lesson?,
        completedLessonIDs: Set<UUID>
    ) -> Topic? {
        guard favorites.count > 1 else { return favorites.first }

        let bundled = LessonLoader.allLessons(for: favorites)
        let topicsWithLessons = Set(bundled.map(\.theme))
        let available = favorites.filter { topicsWithLessons.contains($0) }

        let pool = available.isEmpty ? favorites : available

        if let current = currentLesson {
            let others = pool.filter { $0 != current.theme }
            if let next = others.first { return next }
        }

        let practiced = Set(
            bundled.filter { completedLessonIDs.contains($0.id) }.map(\.theme)
        )
        if let unpracticed = pool.first(where: { !practiced.contains($0) }) {
            return unpracticed
        }

        return pool.first(where: { $0 != currentLesson?.theme }) ?? favorites.first
    }

    /// Suggests the next skill to practice based on the latest lesson and learning goal.
    static func suggestedNextSkill(
        latestSummary: ProgressSummary?,
        learningGoal: LearningGoal
    ) -> String? {
        guard let summary = latestSummary else { return nil }

        if summary.accuracy < 0.7 {
            if summary.correctAnswers < summary.totalQuestions / 2 + 1, !summary.mathSkill.isEmpty {
                return "Extra practice: \(summary.mathSkill)"
            }
            if !summary.readingSkill.isEmpty {
                return "Extra practice: \(summary.readingSkill)"
            }
        }

        switch learningGoal {
        case .reading:
            return nextReadingSkill(after: summary.readingSkill)
        case .math:
            return nextMathSkill(after: summary.mathSkill)
        case .vocabulary:
            return summary.vocabularyWord.isEmpty
                ? "Learn a new treasure word"
                : "Build vocabulary beyond \"\(summary.vocabularyWord)\""
        case .science:
            return "Explore another science fact"
        case .writing:
            return "Try a creative writing prompt next"
        case .allAround:
            switch summary.category {
            case .math:
                return nextMathSkill(after: summary.mathSkill)
            case .story:
                return nextReadingSkill(after: summary.readingSkill)
            case .discovery:
                return "Explore another science fact"
            case .creative:
                return "Try a creative writing prompt next"
            }
        }
    }

    // MARK: - Private

    private static func filterByProfile(_ lessons: [Lesson], profile: ChildProfile) -> [Lesson] {
        let ability = LessonDifficultyRules.abilityProfile(for: profile)
        let strict = lessons.filter {
            LessonDifficultyRules.readingLevelsCompatibleStrict(
                lesson: $0.readingLevel,
                profile: ability.readingLevel
            ) && LessonDifficultyRules.mathLevelsCompatible(
                lesson: $0.mathLevel,
                profile: ability.mathLevel
            )
        }
        let compatible = lessons.filter {
            LessonDifficultyRules.readingLevelsCompatible(
                lesson: $0.readingLevel,
                profile: ability.readingLevel
            ) && LessonDifficultyRules.mathLevelsCompatible(
                lesson: $0.mathLevel,
                profile: ability.mathLevel
            )
        }
        let pool = !strict.isEmpty ? strict : compatible
        let scored = pool.sorted {
            LessonDifficultyRules.matchScore(lesson: $0, profile: profile)
                > LessonDifficultyRules.matchScore(lesson: $1, profile: profile)
        }

        let topScore = scored.first.map { LessonDifficultyRules.matchScore(lesson: $0, profile: profile) } ?? 0
        let strongMatches = scored.filter {
            LessonDifficultyRules.matchScore(lesson: $0, profile: profile) >= topScore - 10
        }
        return strongMatches.isEmpty ? scored : strongMatches
    }

    private static func matchesReadingLevel(_ lessonLevel: ReadingLevel, profile: ChildProfile) -> Bool {
        LessonDifficultyRules.readingLevelsCompatible(lesson: lessonLevel, profile: profile.readingLevel)
    }

    private static func matchesAge(_ lesson: Lesson, profile: ChildProfile) -> Bool {
        LessonDifficultyRules.ageMatches(lesson.ageTarget, profile.age)
    }

    private static func pickTopic(
        favorites: [Topic],
        lastTopic: Topic?,
        bundled: [Lesson],
        completedIDs: Set<UUID>,
        preferredUnused: Set<Topic> = []
    ) -> Topic {
        let topicsWithContent = Set(bundled.map(\.theme))
        let pool = favorites.filter { topicsWithContent.contains($0) }
        let candidates = pool.isEmpty ? favorites : pool

        if candidates.count == 1 { return candidates[0] }

        let withoutLast = candidates.filter { $0 != lastTopic }
        var rotationPool = withoutLast.isEmpty ? candidates : withoutLast

        let unusedTopics = rotationPool.filter { !preferredUnused.contains($0) }
        if !unusedTopics.isEmpty {
            rotationPool = unusedTopics
        }

        let unpracticed = rotationPool.filter { topic in
            !bundled.contains { $0.theme == topic && completedIDs.contains($0.id) }
        }
        let finalPool = unpracticed.isEmpty ? rotationPool : unpracticed

        let index = dayIndex() % finalPool.count
        return finalPool[index]
    }

    private static func pickLessonType(
        recent: [LessonType],
        for topic: Topic,
        bundled: [Lesson],
        learningGoal: LearningGoal,
        preferred: [LessonType] = []
    ) -> LessonType {
        let topicTypes = Set(bundled.filter { $0.theme == topic }.map(\.lessonType))
        let allTypes = topicTypes.isEmpty ? Set(LessonType.allCases) : topicTypes

        if !preferred.isEmpty {
            let preferredFresh = preferred.filter { allTypes.contains($0) && !recent.suffix(3).contains($0) }
            if let type = preferredFresh.first { return type }
            if let type = preferred.first(where: { allTypes.contains($0) }) { return type }
            if let type = preferred.first { return type }
        }

        let recentSet = Set(recent.suffix(3))
        var fresh = LessonType.allCases.filter { allTypes.contains($0) && !recentSet.contains($0) }

        fresh = prioritize(fresh, for: learningGoal, available: allTypes)

        if let type = fresh.first { return type }

        let unused = LessonType.allCases.filter { allTypes.contains($0) && !recent.contains($0) }
        if let type = unused.first { return type }

        let ordered = LessonType.allCases.filter { allTypes.contains($0) }
        guard !ordered.isEmpty else { return .explorer }
        let index = (dayIndex() + topic.rawValue.hashValue) % ordered.count
        return ordered[index]
    }

    private static func prioritize(
        _ types: [LessonType],
        for goal: LearningGoal,
        available: Set<LessonType>
    ) -> [LessonType] {
        let preferred: [LessonType]
        switch goal {
        case .reading:
            preferred = [.detective, .mystery, .explorer, .animalExpert]
        case .math:
            preferred = [.builder, .rescue, .spaceMission]
        case .vocabulary:
            preferred = [.animalExpert, .explorer, .detective]
        case .science:
            preferred = [.explorer, .spaceMission, .animalExpert]
        case .writing:
            preferred = [.creativeLab, .detective, .explorer]
        case .allAround:
            return types
        }

        let boosted = preferred.filter { available.contains($0) && types.contains($0) }
        let rest = types.filter { !boosted.contains($0) }
        return boosted + rest
    }

    private static func pickFromCandidates(
        _ candidates: [Lesson],
        context: SelectionContext
    ) -> Lesson? {
        guard !candidates.isEmpty else { return nil }

        var pool = candidates.filter { $0.id != context.lastLessonID }
        if pool.isEmpty { pool = candidates }

        let uncompleted = pool.filter { !context.completedLessonIDs.contains($0.id) }
        if !uncompleted.isEmpty { pool = uncompleted }

        let ranked = pool.sorted {
            let scoreA = LessonDifficultyRules.matchScore(lesson: $0, profile: context.profile)
            let scoreB = LessonDifficultyRules.matchScore(lesson: $1, profile: context.profile)
            if scoreA != scoreB { return scoreA > scoreB }
            return $0.title < $1.title
        }

        let topTier = ranked.prefix(max(1, ranked.count / 3))
        let index = dayIndex() % topTier.count
        return Array(topTier)[index]
    }

    private static func nextReadingSkill(after current: String) -> String {
        let progression = [
            "Finding main ideas",
            "Using context clues",
            "Reading for details",
            "Close reading",
            "Following directions",
            "Learning from nonfiction",
            "Connecting ideas"
        ]
        if let idx = progression.firstIndex(of: current), idx + 1 < progression.count {
            return progression[idx + 1]
        }
        return "Close reading with a new topic"
    }

    private static func nextMathSkill(after current: String) -> String {
        let progression = [
            "Counting on",
            "Addition within 10",
            "Subtraction within 10",
            "Word problems",
            "Sequencing numbers"
        ]
        if let idx = progression.firstIndex(of: current), idx + 1 < progression.count {
            return progression[idx + 1]
        }
        return "Word problems with a new story"
    }

    private static func dayIndex() -> Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
    }
}
