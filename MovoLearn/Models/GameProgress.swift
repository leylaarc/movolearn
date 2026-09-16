import Foundation
import SwiftUI

// MARK: - Adventure progress titles (no XP)

enum AdventureLevel {
    /// Levels 1…20 derived from completed adventures (not XP).
    static func level(forAdventures count: Int) -> Int {
        max(1, min(20, count + 1))
    }

    static func adventuresToNextLevel(completed: Int) -> (current: Int, needed: Int, progress: Double) {
        let level = level(forAdventures: completed)
        let into = completed - (level - 1)
        let needed = 1
        return (into, needed, min(1, Double(into) / Double(needed)))
    }

    static func title(forLevel level: Int, age: Int) -> String {
        if age <= 7 {
            switch level {
            case 1...2: return "Movo Explorer"
            case 3...5: return "Adventure Buddy"
            case 6...10: return "Quest Hero"
            default: return "Super Learner"
            }
        } else {
            switch level {
            case 1...3: return "Explorer"
            case 4...7: return "Skill Builder"
            case 8...12: return "Challenge Seeker"
            default: return "Master Adventurer"
            }
        }
    }
}

// MARK: - Rewards

enum RewardKind: String, Codable, CaseIterable, Identifiable {
    case badge
    case collectible
    case location
    case character
    case ability

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .badge: return "Badge"
        case .collectible: return "Collectible"
        case .location: return "Location"
        case .character: return "Character"
        case .ability: return "Ability"
        }
    }
}

struct AdventureReward: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let kind: RewardKind
    let title: String
    let detail: String
    let systemImage: String
    let accentName: String
    let unlockRule: RewardUnlockRule

    var accent: Color {
        switch accentName {
        case "coral": return DesignSystem.Colors.coralPink
        case "orange": return DesignSystem.Colors.warmOrange
        case "green": return DesignSystem.Colors.freshGreen
        case "purple": return DesignSystem.Colors.lavenderPurple
        case "yellow": return DesignSystem.Colors.sunshineYellow
        case "turquoise": return DesignSystem.Colors.oceanTurquoise
        default: return DesignSystem.Colors.skyBlue
        }
    }
}

enum RewardUnlockRule: String, Codable, Equatable, Hashable {
    case firstLesson
    case threeLessons
    case fiveLessons
    case streak3
    case streak7
    case eightLessons
    case twelveLessons
    case perfectLesson
    case mathFocus
    case readingFocus
    case scienceFocus
    case creativeFocus
    case exploreThreeTopics

    /// Kid-facing progress toward unlocking a reward (not yet unlocked).
    func unlockProgress(game: GameProgressSnapshot, streak: Int) -> (current: Int, target: Int, caption: String) {
        let adventures = game.completedAdventureCount
        let topics = game.topicsExplored.count
        switch self {
        case .firstLesson:
            return (min(adventures, 1), 1, "\(min(adventures, 1))/1 adventure")
        case .threeLessons:
            return (min(adventures, 3), 3, "\(min(adventures, 3))/3 adventures")
        case .fiveLessons:
            return (min(adventures, 5), 5, "\(min(adventures, 5))/5 adventures")
        case .eightLessons:
            return (min(adventures, 8), 8, "\(min(adventures, 8))/8 adventures")
        case .twelveLessons:
            return (min(adventures, 12), 12, "\(min(adventures, 12))/12 adventures")
        case .streak3:
            return (min(streak, 3), 3, "\(min(streak, 3))/3 day streak")
        case .streak7:
            return (min(streak, 7), 7, "\(min(streak, 7))/7 day streak")
        case .perfectLesson:
            let done = game.perfectLessonCount > 0 ? 1 : 0
            return (done, 1, done == 1 ? "Perfect lesson done!" : "Get every answer right")
        case .mathFocus:
            let done = (game.subjectCompletions["math"] ?? 0) > 0 ? 1 : 0
            return (done, 1, done == 1 ? "Math quest done!" : "Finish a math quest")
        case .readingFocus:
            let done = (game.subjectCompletions["reading"] ?? 0) > 0 ? 1 : 0
            return (done, 1, done == 1 ? "Story quest done!" : "Finish a story quest")
        case .scienceFocus:
            let done = (game.subjectCompletions["science"] ?? 0) > 0 ? 1 : 0
            return (done, 1, done == 1 ? "Science quest done!" : "Finish a science quest")
        case .creativeFocus:
            let done = (game.subjectCompletions["creative"] ?? 0) > 0 ? 1 : 0
            return (done, 1, done == 1 ? "Art quest done!" : "Finish a creative quest")
        case .exploreThreeTopics:
            return (min(topics, 3), 3, "\(min(topics, 3))/3 topic worlds")
        }
    }
}

enum AdventureRewardCatalog {
    static let all: [AdventureReward] = [
        AdventureReward(
            id: "badge_first_spark",
            kind: .badge,
            title: "First Adventure",
            detail: "Finished your first adventure",
            systemImage: "sparkles",
            accentName: "yellow",
            unlockRule: .firstLesson
        ),
        AdventureReward(
            id: "badge_streak_3",
            kind: .badge,
            title: "3-Day Flame",
            detail: "Learned 3 days in a row",
            systemImage: "flame.fill",
            accentName: "orange",
            unlockRule: .streak3
        ),
        AdventureReward(
            id: "badge_streak_7",
            kind: .badge,
            title: "Week Warrior",
            detail: "Kept a 7-day streak",
            systemImage: "bolt.fill",
            accentName: "coral",
            unlockRule: .streak7
        ),
        AdventureReward(
            id: "collectible_star_map",
            kind: .collectible,
            title: "Star Map",
            detail: "Completed 3 adventures",
            systemImage: "map.fill",
            accentName: "purple",
            unlockRule: .threeLessons
        ),
        AdventureReward(
            id: "location_secret_cove",
            kind: .location,
            title: "Secret Cove",
            detail: "Completed 5 adventures",
            systemImage: "water.waves",
            accentName: "turquoise",
            unlockRule: .fiveLessons
        ),
        AdventureReward(
            id: "ability_focus_boost",
            kind: .ability,
            title: "Focus Boost",
            detail: "Completed 8 adventures",
            systemImage: "brain.head.profile",
            accentName: "blue",
            unlockRule: .eightLessons
        ),
        AdventureReward(
            id: "character_nova_friend",
            kind: .character,
            title: "Nova’s Friend",
            detail: "Completed 12 adventures",
            systemImage: "star.circle.fill",
            accentName: "purple",
            unlockRule: .twelveLessons
        ),
        AdventureReward(
            id: "badge_perfect",
            kind: .badge,
            title: "Sharp Thinker",
            detail: "Nailed every scored question in a lesson",
            systemImage: "checkmark.seal.fill",
            accentName: "green",
            unlockRule: .perfectLesson
        ),
        AdventureReward(
            id: "badge_math",
            kind: .badge,
            title: "Number Ninja",
            detail: "Finished a math-focused adventure",
            systemImage: "function",
            accentName: "orange",
            unlockRule: .mathFocus
        ),
        AdventureReward(
            id: "badge_reading",
            kind: .badge,
            title: "Story Sleuth",
            detail: "Finished a reading adventure",
            systemImage: "book.fill",
            accentName: "blue",
            unlockRule: .readingFocus
        ),
        AdventureReward(
            id: "badge_science",
            kind: .badge,
            title: "Curious Explorer",
            detail: "Finished a science discovery",
            systemImage: "leaf.fill",
            accentName: "green",
            unlockRule: .scienceFocus
        ),
        AdventureReward(
            id: "collectible_paintbrush",
            kind: .collectible,
            title: "Magic Brush",
            detail: "Finished a creative activity",
            systemImage: "paintbrush.pointed.fill",
            accentName: "coral",
            unlockRule: .creativeFocus
        ),
        AdventureReward(
            id: "location_world_gate",
            kind: .location,
            title: "World Gate",
            detail: "Explored 3 different topic worlds",
            systemImage: "globe.americas.fill",
            accentName: "turquoise",
            unlockRule: .exploreThreeTopics
        )
    ]

    static func reward(id: String) -> AdventureReward? {
        all.first { $0.id == id }
    }
}

// MARK: - Daily missions

enum DailyMissionKind: String, Codable, Equatable {
    case completeLesson
    case practiceSkill
    case exploreInterest
    case keepStreak
}

struct DailyMission: Identifiable {
    let id: String
    let kind: DailyMissionKind
    let title: String
    let detail: String
    let systemImage: String
    let accent: Color
    let target: Int
    let progress: Int
    let linkedLesson: Lesson?
    var linkedTopic: Topic? = nil

    var isComplete: Bool { progress >= target }
    var progressFraction: Double { min(1, Double(progress) / Double(max(1, target))) }
}

// MARK: - Subject worlds

struct SubjectWorld: Identifiable {
    let id: String
    let topic: Topic?
    let subject: ExploreSubjectCategory?
    let title: String
    let subtitle: String
    let accent: Color
    let masteryPercent: Int
    let sampleLesson: Lesson?

    /// Prefer the sample lesson’s theme so the card image matches what opens.
    var illustrationTopic: Topic {
        if let topic { return topic }
        if let sampleLesson { return sampleLesson.theme }
        return subject?.representativeTopic ?? .nature
    }
}

// MARK: - Skill orb (home)

struct SkillOrbModel: Identifiable {
    let id: String
    let title: String
    let masteryPercent: Int
    let status: SkillStatus
    let tint: Color
}

// MARK: - Game snapshot

struct GameProgressSnapshot: Codable, Equatable {
    /// Legacy field kept for decoding older saves; XP is no longer awarded or shown.
    var totalXP: Int
    var unlockedRewardIDs: [String]
    var newlyUnlockedRewardIDs: [String]
    var lessonsCompletedToday: Int
    var lastLessonDay: Date?
    var perfectLessonCount: Int
    var topicsExplored: [String]
    var subjectCompletions: [String: Int]
    /// Legacy field kept for decoding older saves.
    var lastXPEarned: Int

    static let empty = GameProgressSnapshot(
        totalXP: 0,
        unlockedRewardIDs: [],
        newlyUnlockedRewardIDs: [],
        lessonsCompletedToday: 0,
        lastLessonDay: nil,
        perfectLessonCount: 0,
        topicsExplored: [],
        subjectCompletions: [:],
        lastXPEarned: 0
    )

    var completedAdventureCount: Int {
        max(0, subjectCompletions.values.reduce(0, +))
    }

    var level: Int { AdventureLevel.level(forAdventures: completedAdventureCount) }

    mutating func rollDailyCountIfNeeded(now: Date = Date()) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        if let last = lastLessonDay, calendar.isDate(last, inSameDayAs: today) {
            return
        }
        if lastLessonDay == nil || !(lastLessonDay.map { calendar.isDate($0, inSameDayAs: today) } ?? false) {
            if let last = lastLessonDay, !calendar.isDate(last, inSameDayAs: today) {
                lessonsCompletedToday = 0
            }
        }
    }
}

/// Result of recording a lesson completion for celebration UI (no XP).
struct LessonRewardResult: Equatable {
    let newlyUnlocked: [AdventureReward]
    let completedAdventureCount: Int
    let newLevel: Int
    let previousLevel: Int
}
