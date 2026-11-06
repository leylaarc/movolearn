import Foundation
import SwiftUI

// MARK: - Home feed models

struct ContinueLearningCardModel: Identifiable {
    var id: UUID { lesson.id }
    let lesson: Lesson
    let progressPercent: Int
    let minutesRemaining: Int
    let isResume: Bool
    let subtitle: String
}

struct RecommendedLessonCardModel: Identifiable {
    var id: UUID { lesson.id }
    let lesson: Lesson
    let reason: String
    let score: Double

    /// Child-facing quest label derived from lesson content (honest — no fake Art Quests).
    var questLabel: String {
        lesson.activityLabel
    }
}

struct PlayerHomeStats {
    let level: Int
    let levelTitle: String
    let adventuresCompleted: Int
    let streak: Int
    let dailyGoal: Int
    let dailyProgress: Int
    let skillOrbs: [SkillOrbModel]
}

struct DiscoveryChallengeModel: Identifiable {
    let id: UUID
    let title: String
    let detail: String
    let systemImage: String
    let accentName: String
    let lesson: Lesson?

    var accent: Color {
        switch accentName {
        case "coral": return DesignSystem.Colors.coralPink
        case "orange": return DesignSystem.Colors.warmOrange
        case "green": return DesignSystem.Colors.freshGreen
        case "purple": return DesignSystem.Colors.lavenderPurple
        case "yellow": return DesignSystem.Colors.sunshineYellow
        default: return DesignSystem.Colors.skyBlue
        }
    }
}

struct HomeFeedModel {
    let greetingTitle: String
    let greetingSubtitle: String
    let continueLearning: ContinueLearningCardModel?
    let recommended: [RecommendedLessonCardModel]
    let interestTopics: [Topic]
    let featuredSubjects: [ExploreSubjectCategory]
    let isLoading: Bool
    let playerStats: PlayerHomeStats?
    let missions: [DailyMission]
    let worlds: [SubjectWorld]
    let discovery: DiscoveryChallengeModel?
    let recentRewards: [AdventureReward]
    let mascotTopic: Topic
    let playOffers: [PlayGameOffer]

    static func loadingPlaceholder(name: String = "there") -> HomeFeedModel {
        HomeFeedModel(
            greetingTitle: "Ready to explore, \(name)!",
            greetingSubtitle: "Getting your adventure ready…",
            continueLearning: nil,
            recommended: [],
            interestTopics: [],
            featuredSubjects: Array(ExploreSubjectCategory.allCases.prefix(6)),
            isLoading: true,
            playerStats: nil,
            missions: [],
            worlds: [],
            discovery: nil,
            recentRewards: [],
            mascotTopic: .space,
            playOffers: []
        )
    }
}

/// Local, replaceable recommendation scorer for the personalized home page.
/// Priority: interests → recent activity → lesson sequence → age fit → popular fallback.
enum HomeFeedBuilder {

    struct Context {
        let profile: ChildProfile
        let activity: HomeActivityState
        let completedLessonIDs: Set<UUID>
        let learningState: ChildLearningState
        let allLessons: [Lesson]
        let pathRecommendations: [LessonRecommendation]
        let game: GameProgressSnapshot
        let now: Date
        /// Subject of the lesson the child just finished. Next up should be a different activity.
        let lastCompletedSubject: PrimarySubject?

        init(
            profile: ChildProfile,
            activity: HomeActivityState,
            completedLessonIDs: Set<UUID>,
            learningState: ChildLearningState,
            allLessons: [Lesson],
            pathRecommendations: [LessonRecommendation],
            game: GameProgressSnapshot = .empty,
            now: Date = Date(),
            lastCompletedSubject: PrimarySubject? = nil
        ) {
            self.profile = profile
            self.activity = activity
            self.completedLessonIDs = completedLessonIDs
            self.learningState = learningState
            self.allLessons = allLessons
            self.pathRecommendations = pathRecommendations
            self.game = game
            self.now = now
            self.lastCompletedSubject = lastCompletedSubject
        }
    }

    /// Subject of the most recently finished lesson, used so Home does not offer the same activity again.
    static func subjectOfLatestCompletion(
        _ records: [LessonCompletionRecord],
        lessons: [Lesson] = []
    ) -> PrimarySubject? {
        guard let latest = records.max(by: { $0.completedAt < $1.completedAt }) else { return nil }
        if let lesson = lessons.first(where: { $0.id == latest.lessonId }) {
            return lesson.primarySubject
        }
        return LessonLoader.lesson(id: latest.lessonId)?.primarySubject
    }

    static func build(context: Context, recommendedCount: Int = 2) -> HomeFeedModel {
        let name = context.profile.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let display = name.isEmpty ? "friend" : name
        let greeting = adventureGreeting(name: display, age: context.profile.currentAge, now: context.now)
        let subtitle = personalizedSubtitle(profile: context.profile, game: context.game)

        let continueCard = continueLearningCard(context: context)
        let recommended = recommendedLessons(
            context: context,
            excluding: continueCard.map { [$0.lesson.id] } ?? [],
            count: recommendedCount
        )

        let interests = Array(context.profile.favoriteTopics.prefix(6))
        let subjects = featuredSubjects(for: interests)
        let stats = playerStats(context: context)
        let missions = dailyMissions(context: context, continueCard: continueCard, recommended: recommended)
        let worlds = subjectWorlds(context: context, interests: interests, subjects: subjects)
        let discovery = discoveryChallenge(context: context, excluding: continueCard?.lesson.id)
        let rewards = recentRewards(from: context.game)
        let mascot = interests.first ?? .space
        let playOffers = PlayGameCatalog.offers(
            from: context.allLessons,
            favoriteTopics: interests,
            completedIDs: context.completedLessonIDs,
            limit: 4
        )

        return HomeFeedModel(
            greetingTitle: greeting,
            greetingSubtitle: subtitle,
            continueLearning: continueCard,
            recommended: recommended,
            interestTopics: interests,
            featuredSubjects: subjects,
            isLoading: false,
            playerStats: stats,
            missions: missions,
            worlds: worlds,
            discovery: discovery,
            recentRewards: rewards,
            mascotTopic: mascot,
            playOffers: playOffers
        )
    }

    // MARK: Continue

    private static func continueLearningCard(context: Context) -> ContinueLearningCardModel? {
        if let id = context.activity.inProgressLessonID,
           let lesson = context.allLessons.first(where: { $0.id == id })
            ?? LessonLoader.lesson(id: id),
           !context.completedLessonIDs.contains(id) {
            // Only show real progress — never invent a floor for an opened-but-not-advanced lesson.
            let percent = min(95, max(0, context.activity.inProgressPercent))
            let remaining = max(1, Int(ceil(Double(lesson.estimatedMinutes) * Double(100 - percent) / 100.0)))
            return ContinueLearningCardModel(
                lesson: lesson,
                progressPercent: percent,
                minutesRemaining: remaining,
                isResume: true,
                subtitle: "Your adventure is waiting"
            )
        }

        if let path = context.pathRecommendations.first(where: { $0.kind == .continueLearning }),
           !context.completedLessonIDs.contains(path.lesson.id),
           !context.activity.dismissedLessonIDs.contains(path.lesson.id),
           lessonFitsNextActivity(path.lesson, context: context) {
            return ContinueLearningCardModel(
                lesson: path.lesson,
                progressPercent: 0,
                minutesRemaining: max(1, path.lesson.estimatedMinutes),
                isResume: false,
                subtitle: path.reason
            )
        }

        if let top = recommendedLessons(context: context, excluding: [], count: 1).first {
            return ContinueLearningCardModel(
                lesson: top.lesson,
                progressPercent: 0,
                minutesRemaining: top.lesson.estimatedMinutes,
                isResume: false,
                subtitle: top.reason
            )
        }

        return nil
    }

    // MARK: Recommended

    static func recommendedLessons(
        context: Context,
        excluding: [UUID],
        count: Int
    ) -> [RecommendedLessonCardModel] {
        let excluded = Set(excluding + context.activity.dismissedLessonIDs + Array(context.completedLessonIDs))
        let scored = context.allLessons.compactMap { lesson -> RecommendedLessonCardModel? in
            guard !excluded.contains(lesson.id) else { return nil }
            let (score, reason) = score(lesson: lesson, context: context)
            guard score > 0 else { return nil }
            return RecommendedLessonCardModel(lesson: lesson, reason: reason, score: score)
        }
        .sorted { $0.score > $1.score }

        let fresh = scored.filter { lessonFitsNextActivity($0.lesson, context: context) }
        var results = pickVariedLessons(from: fresh, count: count)
        if results.count < count {
            let sameKind = scored.filter { !lessonFitsNextActivity($0.lesson, context: context) }
            for item in pickVariedLessons(from: sameKind, count: count - results.count)
            where !results.contains(where: { $0.id == item.id }) {
                results.append(item)
            }
        }
        return results
    }

    /// A finished counting lesson should be followed by reading, art, or science — not another count.
    private static func lessonFitsNextActivity(_ lesson: Lesson, context: Context) -> Bool {
        guard let last = context.lastCompletedSubject else { return true }
        return lesson.primarySubject != last
    }

    /// One card per activity, then a new world. Two suggestions should not both be counting lessons.
    private static func pickVariedLessons(
        from scored: [RecommendedLessonCardModel],
        count: Int
    ) -> [RecommendedLessonCardModel] {
        guard count > 0 else { return [] }
        var results: [RecommendedLessonCardModel] = []
        var seenSubjects = Set<PrimarySubject>()
        var seenTopics = Set<Topic>()

        func take(_ item: RecommendedLessonCardModel) {
            results.append(item)
            seenSubjects.insert(item.lesson.primarySubject)
            seenTopics.insert(item.lesson.theme)
        }

        for item in scored where !seenSubjects.contains(item.lesson.primarySubject) && !seenTopics.contains(item.lesson.theme) {
            take(item)
            if results.count >= count { return results }
        }
        for item in scored where !results.contains(where: { $0.id == item.id }) && !seenSubjects.contains(item.lesson.primarySubject) {
            take(item)
            if results.count >= count { return results }
        }
        for item in scored where !results.contains(where: { $0.id == item.id }) {
            take(item)
            if results.count >= count { break }
        }
        return results
    }

    static func score(lesson: Lesson, context: Context) -> (Double, String) {
        var score = 10.0
        var reasons: [String] = []
        let favorites = Set(context.profile.favoriteTopics)
        let recentTopics = Set(context.activity.recentTopicRawValues)

        if favorites.contains(lesson.theme) {
            score += 40
            reasons.append("Matches \(TopicPalette.displayTitle(for: lesson.theme))")
        }

        if recentTopics.contains(lesson.theme.rawValue) {
            score += 18
            if reasons.isEmpty { reasons.append("You explored \(lesson.theme.rawValue) recently") }
        }

        if let path = context.pathRecommendations.first(where: { $0.lesson.id == lesson.id }) {
            score += 16 + min(10, path.score / 5)
            if reasons.isEmpty { reasons.append(path.reason) }
        }
        if let topicId = lesson.primaryTopicId,
           let progress = context.learningState.progress(for: topicId) {
            switch progress.status {
            case .practicing, .developing:
                score += 14
                if reasons.isEmpty { reasons.append("Continues a skill you started") }
            case .needsReview:
                score += 12
                if reasons.isEmpty { reasons.append("Good practice to strengthen") }
            case .mastered:
                score -= 8
            case .notStarted, .introduced:
                score += 4
            }
        }

        if LessonDifficultyRules.ageMatches(lesson.ageTarget, context.profile.currentAge) {
            score += 12
        } else {
            score -= 20
        }
        if lesson.readingLevel == context.profile.readingLevel {
            score += 8
        }

        if favorites.isEmpty {
            score += 6
            if reasons.isEmpty { reasons.append("A great place to start") }
        }

        if context.activity.recentlyOpenedLessonIDs.suffix(3).contains(lesson.id) {
            score -= 25
        }

        if context.completedLessonIDs.contains(lesson.id) {
            score -= 50
        }

        if context.activity.dismissedLessonIDs.contains(lesson.id) {
            score -= 80
        }

        let reason = reasons.first ?? "Picked for \(context.profile.currentAge)-year-olds"
        return (score, reason)
    }

    // MARK: Player stats

    private static func playerStats(context: Context) -> PlayerHomeStats {
        let game = context.game
        let dailyGoal = max(1, context.profile.parentSettings?.dailyLessonGoal ?? 1)
        let orbs = skillOrbs(from: context.learningState, age: context.profile.currentAge)

        return PlayerHomeStats(
            level: game.level,
            levelTitle: AdventureLevel.title(forLevel: game.level, age: context.profile.currentAge),
            adventuresCompleted: game.completedAdventureCount,
            streak: context.profile.currentLearningStreak,
            dailyGoal: dailyGoal,
            dailyProgress: min(dailyGoal, game.lessonsCompletedToday),
            skillOrbs: orbs
        )
    }

    private static func skillOrbs(from state: ChildLearningState, age: Int) -> [SkillOrbModel] {
        let tints: [Color] = [
            DesignSystem.Colors.skyBlue,
            DesignSystem.Colors.warmOrange,
            DesignSystem.Colors.freshGreen,
            DesignSystem.Colors.lavenderPurple
        ]
        let ranked = state.skillProgress
            .filter { $0.status != .notStarted }
            .sorted { $0.masteryScore > $1.masteryScore }
        let source = ranked.isEmpty
            ? Array(state.skillProgress.prefix(4))
            : Array(ranked.prefix(4))

        if source.isEmpty {
            let defaults = age <= 7
                ? ["Reading", "Numbers", "Curiosity", "Creativity"]
                : ["Reading", "Math", "Science", "Writing"]
            return defaults.enumerated().map { index, title in
                SkillOrbModel(
                    id: "default-\(title)",
                    title: title,
                    masteryPercent: 0,
                    status: .notStarted,
                    tint: tints[index % tints.count]
                )
            }
        }

        return source.enumerated().map { index, skill in
            SkillOrbModel(
                id: skill.marbleTopicId,
                title: shortSkillTitle(skill.marbleTopicId),
                masteryPercent: Int(min(100, max(0, skill.masteryScore * 100))),
                status: skill.status,
                tint: tints[index % tints.count]
            )
        }
    }

    private static func shortSkillTitle(_ topicId: String) -> String {
        let cleaned = topicId
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
        let words = cleaned.split(separator: " ").prefix(2).map(String.init)
        let joined = words.joined(separator: " ")
        if joined.isEmpty { return "Skill" }
        return joined.prefix(1).uppercased() + joined.dropFirst()
    }

    // MARK: Missions

    private static func dailyMissions(
        context: Context,
        continueCard: ContinueLearningCardModel?,
        recommended: [RecommendedLessonCardModel]
    ) -> [DailyMission] {
        let game = context.game
        let dailyGoal = max(1, context.profile.parentSettings?.dailyLessonGoal ?? 1)
        let age = context.profile.currentAge
        var missions: [DailyMission] = []

        let lessonProgress = min(dailyGoal, game.lessonsCompletedToday)
        missions.append(
            DailyMission(
                id: "mission-lesson",
                kind: .completeLesson,
                title: age <= 7 ? "Finish today’s adventure" : "Complete a lesson",
                detail: lessonProgress >= dailyGoal
                    ? "Done — great focus!"
                    : "\(lessonProgress)/\(dailyGoal) complete",
                systemImage: "flag.fill",
                accent: DesignSystem.Colors.coralPink,
                target: dailyGoal,
                progress: lessonProgress,
                linkedLesson: continueCard?.lesson ?? recommended.first?.lesson
            )
        )

        if let topic = context.profile.favoriteTopics.first {
            let explored = context.activity.recentTopicRawValues.contains(topic.rawValue)
                || game.topicsExplored.contains(topic.rawValue)
            missions.append(
                DailyMission(
                    id: "mission-interest",
                    kind: .exploreInterest,
                    title: age <= 7 ? "Visit \(topic.rawValue)" : "Explore \(topic.rawValue)",
                    detail: explored ? "You’ve been there today!" : "Open the \(topic.rawValue.lowercased()) world",
                    systemImage: "sparkles",
                    accent: TopicPalette.color(for: topic),
                    target: 1,
                    progress: explored && game.lessonsCompletedToday > 0 ? 1 : 0,
                    linkedLesson: nil,
                    linkedTopic: topic
                )
            )
        }

        let streakTarget = 1
        let streakDone = game.lessonsCompletedToday > 0 || context.profile.currentLearningStreak > 0
            && Calendar.current.isDateInToday(game.lastLessonDay ?? .distantPast)
        missions.append(
            DailyMission(
                id: "mission-streak",
                kind: .keepStreak,
                title: age <= 7 ? "Keep your flame" : "Protect your streak",
                detail: context.profile.currentLearningStreak > 0
                    ? "\(context.profile.currentLearningStreak)-day streak"
                    : "Learn once today to start a streak",
                systemImage: "flame.fill",
                accent: DesignSystem.Colors.warmOrange,
                target: streakTarget,
                progress: (game.lessonsCompletedToday > 0) ? 1 : 0,
                linkedLesson: continueCard?.lesson
            )
        )

        _ = streakDone
        return Array(missions.prefix(3))
    }

    // MARK: Worlds

    private static func subjectWorlds(
        context: Context,
        interests: [Topic],
        subjects: [ExploreSubjectCategory]
    ) -> [SubjectWorld] {
        var worlds: [SubjectWorld] = []

        for topic in interests.prefix(4) {
            let sample = preferredTopicSample(for: topic, context: context)
            let mastery = worldMastery(for: topic, context: context)
            worlds.append(
                SubjectWorld(
                    id: "topic-\(topic.rawValue)",
                    topic: topic,
                    subject: nil,
                    title: TopicPalette.displayTitle(for: topic),
                    subtitle: worldSubtitle(for: topic, age: context.profile.currentAge),
                    accent: TopicPalette.color(for: topic),
                    masteryPercent: mastery,
                    sampleLesson: sample
                )
            )
        }

        if worlds.count < 4 {
            for subject in subjects where worlds.count < 5 {
                let sample = preferredSampleLesson(for: subject, context: context)
                worlds.append(
                    SubjectWorld(
                        id: "subject-\(subject.rawValue)",
                        topic: nil,
                        subject: subject,
                        title: subject.worldTitle,
                        subtitle: subject.subtitle,
                        accent: subject.accent,
                        masteryPercent: 0,
                        sampleLesson: sample
                    )
                )
            }
        }

        return worlds
    }

    /// Level-matched approved lesson for a topic world (never cross-theme).
    private static func preferredTopicSample(for topic: Topic, context: Context) -> Lesson? {
        if let approved = ContentLibrarySelector.preferredLesson(for: topic, profile: context.profile),
           !context.completedLessonIDs.contains(approved.id) {
            return approved
        }
        if let approved = ContentLibrarySelector.preferredLesson(for: topic, profile: context.profile) {
            return approved
        }

        let ability = LessonDifficultyRules.abilityProfile(for: context.profile)
        let themed = context.allLessons.filter { $0.theme == topic }
        let incomplete = themed.filter { !context.completedLessonIDs.contains($0.id) }
        let pool = incomplete.isEmpty ? themed : incomplete

        let levelMatched = pool.filter {
            $0.readingLevel == ability.readingLevel
                && ($0.primarySubject != .math || $0.mathLevel == ability.mathLevel)
        }
        let preferred = levelMatched.isEmpty ? pool : levelMatched
        let approvedFirst = preferred.filter(\.isApprovedForChildDisplay)
        return (approvedFirst.isEmpty ? preferred : approvedFirst).first
    }

    /// Picks a sample adventure that matches the world identity (e.g. forest for Wild Nature Trails).
    private static func preferredSampleLesson(
        for subject: ExploreSubjectCategory,
        context: Context
    ) -> Lesson? {
        for topic in subject.preferredSampleTopics {
            if let match = preferredTopicSample(for: topic, context: context) {
                return match
            }
        }

        if subject == .math {
            let incomplete = context.allLessons.filter { !context.completedLessonIDs.contains($0.id) }
            let pool = incomplete.isEmpty ? context.allLessons : incomplete
            if let mathLesson = pool.first(where: {
                subject.topics.contains($0.theme) && ($0.primarySubject == .math || $0.category == .math)
            }) {
                return mathLesson
            }
        }

        for topic in subject.topics {
            if let match = preferredTopicSample(for: topic, context: context) {
                return match
            }
        }
        return nil
    }

    private static func worldMastery(for topic: Topic, context: Context) -> Int {
        let related = context.learningState.skillProgress.filter {
            $0.marbleTopicId.lowercased().contains(topic.rawValue.lowercased().prefix(4))
        }
        if let best = related.max(by: { $0.masteryScore < $1.masteryScore }) {
            return Int(min(100, best.masteryScore * 100))
        }
        if context.game.topicsExplored.contains(topic.rawValue) {
            return 25
        }
        return 0
    }

    private static func worldSubtitle(for topic: Topic, age: Int) -> String {
        let name = TopicPalette.displayTitle(for: topic).lowercased()
        if age <= 7 {
            return "Fun quests about \(name)"
        }
        return "Missions, challenges & discoveries in \(name)"
    }

    // MARK: Discovery

    private static func discoveryChallenge(
        context: Context,
        excluding: UUID?
    ) -> DiscoveryChallengeModel? {
        let favorites = Set(context.profile.favoriteTopics)
        let ability = LessonDifficultyRules.abilityProfile(for: context.profile)
        let baseFilter: (Lesson) -> Bool = {
            $0.id != excluding
                && !context.completedLessonIDs.contains($0.id)
                && !context.activity.dismissedLessonIDs.contains($0.id)
                && $0.isApprovedForChildDisplay
                && $0.readingLevel == ability.readingLevel
        }
        let favoritePool = context.allLessons.filter {
            baseFilter($0) && (favorites.isEmpty || favorites.contains($0.theme))
        }
        let unrotated = favoritePool.isEmpty
            ? context.allLessons.filter(baseFilter)
            : favoritePool
        let pool: [Lesson]
        if let avoid = context.lastCompletedSubject {
            let fresh = unrotated.filter { $0.primarySubject != avoid }
            pool = fresh.isEmpty ? unrotated : fresh
        } else {
            pool = unrotated
        }
        let daySeed = Calendar.current.ordinality(of: .day, in: .year, for: context.now) ?? 1
        let lesson: Lesson?
        if pool.isEmpty {
            lesson = ContentLibrarySelector.preferredLesson(
                for: context.profile.favoriteTopics.first ?? .space,
                profile: context.profile
            )
        } else {
            lesson = pool[daySeed % pool.count]
        }
        guard let lesson else { return nil }

        let (title, detail, image, accent): (String, String, String, String) = {
            switch lesson.lessonType {
            case .mystery, .detective:
                return ("Mystery Challenge", "Follow clues in \(lesson.theme.rawValue.lowercased())", "magnifyingglass", "purple")
            case .rescue:
                return ("Rescue Mission", "Help solve a problem in \(lesson.theme.rawValue.lowercased())", "cross.case.fill", "coral")
            case .builder:
                return ("Builder Challenge", "Plan and build with careful counting", "hammer.fill", "orange")
            case .spaceMission:
                return ("Space Mission", "Countdown, gear check, launch!", "airplane", "blue")
            case .animalExpert:
                return ("Animal Expert", "Teach and learn real animal facts", "pawprint.fill", "green")
            case .creativeLab:
                return ("Creative Moment", "Draw or invent something new", "paintbrush.pointed.fill", "coral")
            case .explorer:
                switch lesson.category {
                case .math:
                    return ("Quick Number Puzzle", "A short \(lesson.theme.rawValue.lowercased()) math challenge", "puzzlepiece.fill", "orange")
                case .discovery:
                    return ("Discovery Lab", "Explore \(lesson.theme.rawValue.lowercased()) science", "flask.fill", "green")
                case .creative:
                    return ("Creative Moment", "Draw or invent something new", "paintbrush.pointed.fill", "coral")
                case .story:
                    return (lesson.title, lesson.teaser.isEmpty ? "A \(lesson.theme.rawValue.lowercased()) story quest" : lesson.teaser, "book.fill", "purple")
                }
            }
        }()

        return DiscoveryChallengeModel(
            id: lesson.id,
            title: title,
            detail: detail,
            systemImage: image,
            accentName: accent,
            lesson: lesson
        )
    }

    // MARK: Rewards

    private static func recentRewards(from game: GameProgressSnapshot) -> [AdventureReward] {
        let ids = game.newlyUnlockedRewardIDs.isEmpty
            ? Array(game.unlockedRewardIDs.suffix(3))
            : game.newlyUnlockedRewardIDs
        return ids.compactMap { AdventureRewardCatalog.reward(id: $0) }
    }

    // MARK: Subjects on home

    private static func featuredSubjects(for interests: [Topic]) -> [ExploreSubjectCategory] {
        var ranked: [(ExploreSubjectCategory, Int)] = ExploreSubjectCategory.allCases.map { category in
            let hits = interests.filter { category.topics.contains($0) }.count
            return (category, hits)
        }
        ranked.sort { lhs, rhs in
            if lhs.1 != rhs.1 { return lhs.1 > rhs.1 }
            return lhs.0.rawValue < rhs.0.rawValue
        }
        let top = ranked.filter { $0.1 > 0 }.map(\.0)
        if top.count >= 4 {
            return Array(top.prefix(6))
        }
        var combined = top
        for category in ExploreSubjectCategory.allCases where !combined.contains(category) {
            combined.append(category)
            if combined.count >= 6 { break }
        }
        return combined
    }

    // MARK: Copy

    static func timeAwareGreeting(name: String, now: Date = Date()) -> String {
        adventureGreeting(name: name, age: 7, now: now)
    }

    static func adventureGreeting(name: String, age: Int, now: Date = Date()) -> String {
        let hour = Calendar.current.component(.hour, from: now)
        if age <= 7 {
            let options: [String]
            switch hour {
            case 5..<12:
                options = ["Ready for your next adventure, \(name)?", "Let’s play and learn, \(name)!"]
            case 12..<17:
                options = ["Time for a new quest, \(name)!", "Your adventure is waiting, \(name)!"]
            default:
                options = ["One more adventure, \(name)?", "Ready to shine, \(name)?"]
            }
            return options[abs(name.hashValue) % options.count]
        } else {
            let options: [String]
            switch hour {
            case 5..<12:
                options = ["Ready for your next challenge, \(name)?", "Let’s build your skills, \(name)!"]
            case 12..<17:
                options = ["Your next mission is ready, \(name)!", "Time to explore, \(name)!"]
            default:
                options = ["Keep your streak going, \(name)!", "Ready for today’s quest, \(name)?"]
            }
            return options[abs(name.hashValue) % options.count]
        }
    }

    private static func personalizedSubtitle(profile: ChildProfile, game: GameProgressSnapshot) -> String {
        if game.lessonsCompletedToday > 0 {
            return "You’re on a roll — keep going!"
        }
        if let topic = profile.favoriteTopics.first {
            return "A new \(topic.rawValue.lowercased()) quest is ready."
        }
        return "Pick a world and start exploring."
    }
}

// MARK: - Catalog search

struct CatalogSearchResults {
    var lessons: [Lesson]
    var topics: [Topic]
    var subjects: [ExploreSubjectCategory]

    static let empty = CatalogSearchResults(lessons: [], topics: [], subjects: [])

    var isEmpty: Bool { lessons.isEmpty && topics.isEmpty && subjects.isEmpty }
}

enum CatalogSearch {
    static func search(query: String, lessons: [Lesson]) -> CatalogSearchResults {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return .empty }
        let needle = trimmed.lowercased()

        let matchedLessons = lessons.filter {
            $0.title.lowercased().contains(needle)
                || $0.theme.rawValue.lowercased().contains(needle)
                || $0.teaser.lowercased().contains(needle)
                || $0.category.displayName.lowercased().contains(needle)
                || $0.primarySubject.displayName.lowercased().contains(needle)
        }

        let matchedTopics = Topic.allCases.filter {
            $0.rawValue.lowercased().contains(needle)
                || TopicLibrary.definition(for: $0).description.lowercased().contains(needle)
        }

        let matchedSubjects = ExploreSubjectCategory.allCases.filter {
            $0.rawValue.lowercased().contains(needle)
                || $0.subtitle.lowercased().contains(needle)
                || $0.topics.contains(where: { matchedTopics.contains($0) })
        }

        return CatalogSearchResults(
            lessons: Array(matchedLessons.prefix(20)),
            topics: Array(matchedTopics.prefix(12)),
            subjects: Array(matchedSubjects.prefix(8))
        )
    }
}
