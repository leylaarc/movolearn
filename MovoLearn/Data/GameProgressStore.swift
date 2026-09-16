import Foundation

/// Persists daily progress and unlocked rewards per child (UserDefaults MVP).
final class GameProgressStore {
    static let shared = GameProgressStore()

    private let defaults: UserDefaults
    private let keyPrefix = "com.movolearn.gameProgress."

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load(for childId: UUID) -> GameProgressSnapshot {
        let key = storageKey(for: childId)
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode(GameProgressSnapshot.self, from: data) else {
            return .empty
        }
        var snapshot = decoded
        snapshot.rollDailyCountIfNeeded()
        return snapshot
    }

    func save(_ snapshot: GameProgressSnapshot, for childId: UUID) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: storageKey(for: childId))
    }

    func reset(for childId: UUID?) {
        guard let childId else { return }
        defaults.removeObject(forKey: storageKey(for: childId))
    }

    /// Records completion and evaluates unlocks. Returns what changed for UI.
    @discardableResult
    func recordLessonCompletion(
        childId: UUID,
        lesson: Lesson,
        summary: ProgressSummary,
        streak: Int
    ) -> LessonRewardResult {
        var snapshot = load(for: childId)
        let previousLevel = snapshot.level
        snapshot.rollDailyCountIfNeeded()

        snapshot.lessonsCompletedToday += 1
        snapshot.lastLessonDay = Date()
        snapshot.lastXPEarned = 0

        if summary.totalQuestions > 0, summary.correctAnswers == summary.totalQuestions {
            snapshot.perfectLessonCount += 1
        }

        let topicKey = lesson.theme.rawValue
        if !snapshot.topicsExplored.contains(topicKey) {
            snapshot.topicsExplored.append(topicKey)
        }

        let subjectKey = lesson.primarySubject.rawValue
        snapshot.subjectCompletions[subjectKey, default: 0] += 1

        let newly = Self.evaluateUnlocks(
            snapshot: snapshot,
            lesson: lesson,
            summary: summary,
            streak: streak
        )
        for reward in newly where !snapshot.unlockedRewardIDs.contains(reward.id) {
            snapshot.unlockedRewardIDs.append(reward.id)
        }
        snapshot.newlyUnlockedRewardIDs = newly.map(\.id)

        save(snapshot, for: childId)

        return LessonRewardResult(
            newlyUnlocked: newly,
            completedAdventureCount: snapshot.completedAdventureCount,
            newLevel: snapshot.level,
            previousLevel: previousLevel
        )
    }

    /// Seeds unlocks for learners who already have completions but no game snapshot yet.
    func hydrateIfNeeded(childId: UUID, completedLessonCount: Int, streak: Int, topics: [Topic]) {
        var snapshot = load(for: childId)
        let needsSeed = snapshot.unlockedRewardIDs.isEmpty && completedLessonCount > 0
        guard needsSeed else { return }

        snapshot.subjectCompletions["seed"] = completedLessonCount
        for topic in topics.prefix(8) {
            if !snapshot.topicsExplored.contains(topic.rawValue) {
                snapshot.topicsExplored.append(topic.rawValue)
            }
        }
        if completedLessonCount >= 1 {
            snapshot.unlockedRewardIDs.append("badge_first_spark")
        }
        if completedLessonCount >= 3 {
            snapshot.unlockedRewardIDs.append("collectible_star_map")
        }
        if completedLessonCount >= 5 {
            snapshot.unlockedRewardIDs.append("location_secret_cove")
        }
        if completedLessonCount >= 8 {
            snapshot.unlockedRewardIDs.append("ability_focus_boost")
        }
        if completedLessonCount >= 12 {
            snapshot.unlockedRewardIDs.append("character_nova_friend")
        }
        if streak >= 3 {
            snapshot.unlockedRewardIDs.append("badge_streak_3")
        }
        if streak >= 7 {
            snapshot.unlockedRewardIDs.append("badge_streak_7")
        }
        if topics.count >= 3 {
            snapshot.unlockedRewardIDs.append("location_world_gate")
        }
        snapshot.unlockedRewardIDs = Array(Set(snapshot.unlockedRewardIDs))
        save(snapshot, for: childId)
    }

    func clearNewlyUnlocked(for childId: UUID) {
        var snapshot = load(for: childId)
        snapshot.newlyUnlockedRewardIDs = []
        save(snapshot, for: childId)
    }

    private static func evaluateUnlocks(
        snapshot: GameProgressSnapshot,
        lesson: Lesson,
        summary: ProgressSummary,
        streak: Int
    ) -> [AdventureReward] {
        var unlocked: [AdventureReward] = []
        let already = Set(snapshot.unlockedRewardIDs)
        let lessonCount = max(1, snapshot.completedAdventureCount)

        for reward in AdventureRewardCatalog.all {
            guard !already.contains(reward.id) else { continue }
            let qualifies: Bool = {
                switch reward.unlockRule {
                case .firstLesson: return lessonCount >= 1
                case .threeLessons: return lessonCount >= 3
                case .fiveLessons: return lessonCount >= 5
                case .streak3: return streak >= 3
                case .streak7: return streak >= 7
                case .eightLessons: return lessonCount >= 8
                case .twelveLessons: return lessonCount >= 12
                case .perfectLesson:
                    return summary.totalQuestions > 0 && summary.correctAnswers == summary.totalQuestions
                case .mathFocus:
                    return lesson.primarySubject == .math || lesson.category == .math
                case .readingFocus:
                    return lesson.primarySubject == .reading || lesson.category == .story
                case .scienceFocus:
                    return lesson.primarySubject == .science || lesson.category == .discovery
                case .creativeFocus:
                    return lesson.primarySubject == .creative || lesson.category == .creative
                case .exploreThreeTopics:
                    return snapshot.topicsExplored.count >= 3
                }
            }()
            if qualifies {
                unlocked.append(reward)
            }
        }
        return unlocked
    }

    private func storageKey(for childId: UUID) -> String {
        keyPrefix + childId.uuidString
    }
}
