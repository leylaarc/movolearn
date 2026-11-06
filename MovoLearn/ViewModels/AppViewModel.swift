import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case welcome
    case parentAccount
    case profileSetup
    case interestSelection
    case editInterests
    case home
    case lesson
    case lessonCompletion
    case profileSettings
}

/// Non-observable app state holder. ContentView owns `@State` copies so SwiftUI
/// navigation is not blocked by observation during screen transitions.
@MainActor
final class AppStore {
    let progressStore: ProgressStore
    let profileRepository: ProfileRepositoryProtocol
    let learningStore: LearningProgressStore
    private var lastSelectedLesson: Lesson?
    private(set) var lastRewardResult: LessonRewardResult?

    init(
        progressStore: ProgressStore = .shared,
        profileRepository: ProfileRepositoryProtocol = ProfileRepository.shared,
        learningStore: LearningProgressStore = .shared
    ) {
        self.progressStore = progressStore
        self.profileRepository = profileRepository
        self.learningStore = learningStore
    }

    /// Updates only favorite topics — does not reset progress or other profile fields.
    func updateFavoriteTopics(_ topics: [Topic], in profile: inout ChildProfile) {
        guard !topics.isEmpty else { return }
        profile.favoriteTopics = topics
        profile.touch()
    }

    @discardableResult
    func persistProfile(_ profile: ChildProfile) -> ChildProfile {
        let previous = profileRepository.load()
        var copy = profile
        copy.touch()
        _ = profileRepository.save(copy)
        PersonalizationService.shared.update(copy)
        let saved = profileRepository.load() ?? copy
        ProfileContentInvalidator.invalidateIfAcademicSettingsChanged(from: previous, to: saved)
        SyncCoordinator.shared.noteLocalChange()
        return saved
    }

    func loadPersistedProfile() -> ChildProfile? {
        let profile = profileRepository.load()
        PersonalizationService.shared.update(profile)
        return profile
    }

    func pickDailyOptions(for profile: ChildProfile, advance: Bool = false) -> [Lesson] {
        let completions = progressStore.loadCompletions()
        let completedIDs = Set(completions.map(\.lessonId))

        // Child-facing options come from the approved library only.
        let approved = ContentLibrarySelector.selectDailyOptions(
            for: profile,
            count: 4,
            completedIDs: completedIDs
        )
        if !approved.lessons.isEmpty {
            if advance, let first = approved.lessons.first {
                lastSelectedLesson = first
            }
            return approved.lessons
        }

        #if DEBUG
        if approved.contentUnavailable {
            print("Approved content unavailable: \(approved.unavailableReason ?? "unknown")")
        }
        #endif

        // Secondary path: standards-aware engine over approved pool only (no live generation).
        let learningState = learningStore.loadState(for: profile.id)
        let curriculum = MarbleCurriculumService.shared
        _ = curriculum.loadIfNeeded()
        let recentMistakes = learningState.skillProgress
            .filter { $0.status == .needsReview || $0.incorrectAttempts > $0.correctAttempts }
            .map(\.marbleTopicId)
        let pool = ContentLibrarySelector.pool(for: profile)

        let options = LearningPathEngine.pickDailyOptions(
            for: .init(
                profile: profile,
                learningState: learningState,
                completedLessonIDs: completedIDs,
                allLessons: pool,
                curriculum: curriculum,
                recentMistakeTopicIds: recentMistakes,
                lastCompletedSubject: HomeFeedBuilder.subjectOfLatestCompletion(completions, lessons: pool)
            ),
            count: 4
        )

        // Do not fall back to unvalidated LessonFactory generation for child display.
        if advance, let first = options.first {
            lastSelectedLesson = first
        }
        return options
    }

    func homeRecommendations(for profile: ChildProfile) -> [LessonRecommendation] {
        let completions = progressStore.loadCompletions()
        let learningState = learningStore.loadState(for: profile.id)
        let curriculum = MarbleCurriculumService.shared
        _ = curriculum.loadIfNeeded()
        let recentMistakes = learningState.skillProgress
            .filter { $0.status == .needsReview || $0.incorrectAttempts > $0.correctAttempts }
            .map(\.marbleTopicId)
        let pool = ContentLibrarySelector.pool(for: profile)
        return LearningPathEngine.recommendations(
            for: .init(
                profile: profile,
                learningState: learningState,
                completedLessonIDs: Set(completions.map(\.lessonId)),
                allLessons: pool,
                curriculum: curriculum,
                recentMistakeTopicIds: recentMistakes,
                lastCompletedSubject: HomeFeedBuilder.subjectOfLatestCompletion(completions, lessons: pool)
            )
        )
    }

    /// Personalized home feed (continue + recommended + interests + subjects).
    func buildHomeFeed(for profile: ChildProfile) -> HomeFeedModel {
        let completions = progressStore.loadCompletions()
        let completedIDs = Set(completions.map(\.lessonId))
        let learningState = learningStore.loadState(for: profile.id)
        let activity = HomeActivityStore.shared.load(for: profile.id)
        let pathRecs = homeRecommendations(for: profile)

        GameProgressStore.shared.hydrateIfNeeded(
            childId: profile.id,
            completedLessonCount: completions.count,
            streak: profile.currentLearningStreak,
            topics: Array(Set(completions.map(\.topic) + profile.favoriteTopics))
        )
        let game = GameProgressStore.shared.load(for: profile.id)

        var pool = ContentLibrarySelector.pool(for: profile)
        if pool.isEmpty {
            pool = ApprovedContentLibrary.lessons(
                readingLevel: profile.readingLevel,
                mathLevel: profile.mathLevel
            )
        }

        return HomeFeedBuilder.build(
            context: .init(
                profile: profile,
                activity: activity,
                completedLessonIDs: completedIDs,
                learningState: learningState,
                allLessons: pool,
                pathRecommendations: pathRecs,
                game: game,
                lastCompletedSubject: HomeFeedBuilder.subjectOfLatestCompletion(completions, lessons: pool)
            )
        )
    }

    func markLessonStarted(_ lesson: Lesson, childId: UUID) {
        HomeActivityStore.shared.markLessonStarted(lesson, childId: childId)
        rememberSelectedLesson(lesson)
    }

    func dismissRecommendation(_ lessonID: UUID, childId: UUID) {
        HomeActivityStore.shared.dismissRecommendation(lessonID, childId: childId)
    }

    func rememberSelectedLesson(_ lesson: Lesson) {
        lastSelectedLesson = lesson
    }

    func pickLesson(for profile: ChildProfile, advance: Bool) -> Lesson? {
        pickDailyOptions(for: profile, advance: advance).first
    }

    /// Next child-facing lesson after a completion — a different activity than the one just finished.
    func suggestedNextLesson(for profile: ChildProfile, excluding lessonID: UUID?) -> Lesson? {
        let options = pickDailyOptions(for: profile, advance: true)
        let finishedSubject = lessonID.flatMap { LessonLoader.lesson(id: $0)?.primarySubject }
        if let next = options.first(where: {
            $0.id != lessonID && (finishedSubject == nil || $0.primarySubject != finishedSubject)
        }) {
            return next
        }
        if let next = options.first(where: { $0.id != lessonID }) {
            return next
        }
        let recommendations = homeRecommendations(for: profile)
        if let next = recommendations.first(where: {
            $0.lesson.id != lessonID && (finishedSubject == nil || $0.lesson.primarySubject != finishedSubject)
        }) {
            return next.lesson
        }
        return recommendations.first(where: { $0.lesson.id != lessonID })?.lesson
    }

    func recordCompletion(summary: ProgressSummary, lesson: Lesson, profile: inout ChildProfile) -> UserProgress {
        lastSelectedLesson = lesson
        progressStore.recordCompletion(summary: summary, lesson: lesson)
        HomeActivityStore.shared.markLessonCompleted(lesson, childId: profile.id)
        LearningSessionRecorder.recordLessonCompleted(
            childId: profile.id,
            lesson: lesson,
            summary: summary
        )
        let skillNotes = AdaptiveSkillAdjuster.applyLessonOutcome(summary: summary, to: &profile)
        #if DEBUG
        if !skillNotes.isEmpty {
            print("Adaptive skill adjust: \(skillNotes.joined(separator: "; "))")
        }
        #endif
        profile.completedLessonCount = progressStore.userProgress().completedLessonCount
        profile.currentLearningStreak = Self.computeStreak(from: progressStore.loadCompletions())
        profile.touch()
        _ = persistProfile(profile)

        lastRewardResult = GameProgressStore.shared.recordLessonCompletion(
            childId: profile.id,
            lesson: lesson,
            summary: summary,
            streak: profile.currentLearningStreak
        )
        SyncCoordinator.shared.noteLocalChange()

        return progressStore.userProgress()
    }

    func gameSnapshot(for childId: UUID) -> GameProgressSnapshot {
        GameProgressStore.shared.load(for: childId)
    }

    func clearNewRewards(for childId: UUID) {
        GameProgressStore.shared.clearNewlyUnlocked(for: childId)
    }

    func suggestedNextTopic(
        favorites: [Topic],
        currentLesson: Lesson?
    ) -> Topic? {
        let completedIDs = Set(progressStore.loadCompletions().map(\.lessonId))
        return DailyLessonSelector.suggestedNextTopic(
            favorites: favorites,
            currentLesson: currentLesson,
            completedLessonIDs: completedIDs
        )
    }

    func suggestedNextSkill(
        latestSummary: ProgressSummary?,
        learningGoal: LearningGoal
    ) -> String? {
        DailyLessonSelector.suggestedNextSkill(
            latestSummary: latestSummary,
            learningGoal: learningGoal
        )
    }

    /// Deliberate full reset — never called silently.
    func resetAllLearnerData() {
        let childId = profileRepository.load()?.id
        if let childId {
            Task { await SyncCoordinator.shared.deleteRemoteChild(childId) }
        }
        profileRepository.delete()
        progressStore.reset()
        learningStore.reset()
        HomeActivityStore.shared.reset(for: childId)
        GameProgressStore.shared.reset(for: childId)
        PersonalizationService.shared.update(nil)
        lastSelectedLesson = nil
        lastRewardResult = nil
    }

    private static func computeStreak(from completions: [LessonCompletionRecord]) -> Int {
        guard !completions.isEmpty else { return 0 }
        let calendar = Calendar.current
        let days = Set(completions.map { calendar.startOfDay(for: $0.completedAt) })
        var streak = 0
        var day = calendar.startOfDay(for: Date())
        while days.contains(day) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        // Allow yesterday-start streaks if no lesson yet today.
        if streak == 0, let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date())),
           days.contains(yesterday) {
            day = yesterday
            while days.contains(day) {
                streak += 1
                guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
                day = previous
            }
        }
        return streak
    }
}
