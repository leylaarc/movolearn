import Foundation

/// Lightweight local activity used by the personalized home feed.
/// Easy to replace with a backend later — keep scoring inputs here.
struct HomeActivityState: Codable, Equatable {
    var inProgressLessonID: UUID?
    /// 0…99 while a lesson is open / unfinished.
    var inProgressPercent: Int
    var inProgressOpenedAt: Date?
    /// Lessons the learner dismissed or skipped from recommendations.
    var dismissedLessonIDs: [UUID]
    /// Recently opened topic raw values (most recent last).
    var recentTopicRawValues: [String]
    /// Lessons opened recently (most recent last).
    var recentlyOpenedLessonIDs: [UUID]

    static let empty = HomeActivityState(
        inProgressLessonID: nil,
        inProgressPercent: 0,
        inProgressOpenedAt: nil,
        dismissedLessonIDs: [],
        recentTopicRawValues: [],
        recentlyOpenedLessonIDs: []
    )
}

/// Persists home personalization signals in UserDefaults (MVP local store).
final class HomeActivityStore {
    static let shared = HomeActivityStore()

    private let defaults: UserDefaults
    private let keyPrefix = "com.movolearn.homeActivity."

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load(for childId: UUID) -> HomeActivityState {
        let key = keyPrefix + childId.uuidString
        guard let data = defaults.data(forKey: key),
              let state = try? JSONDecoder().decode(HomeActivityState.self, from: data) else {
            return .empty
        }
        return state
    }

    @discardableResult
    func save(_ state: HomeActivityState, for childId: UUID) -> HomeActivityState {
        let key = keyPrefix + childId.uuidString
        if let data = try? JSONEncoder().encode(state) {
            defaults.set(data, forKey: key)
        }
        return state
    }

    func markLessonStarted(_ lesson: Lesson, childId: UUID) {
        var state = load(for: childId)
        let isSameLesson = state.inProgressLessonID == lesson.id
        state.inProgressLessonID = lesson.id
        // Opening a lesson is not progress — keep existing % only when resuming the same one.
        if !isSameLesson {
            state.inProgressPercent = 0
        }
        state.inProgressOpenedAt = Date()
        appendUnique(&state.recentlyOpenedLessonIDs, lesson.id, limit: 20)
        appendUnique(&state.recentTopicRawValues, lesson.theme.rawValue, limit: 12)
        // Re-opening a lesson should allow it to be recommended again.
        state.dismissedLessonIDs.removeAll { $0 == lesson.id }
        _ = save(state, for: childId)
    }

    func updateInProgressPercent(_ percent: Int, childId: UUID) {
        var state = load(for: childId)
        guard state.inProgressLessonID != nil else { return }
        state.inProgressPercent = min(99, max(0, percent))
        _ = save(state, for: childId)
    }

    func markLessonCompleted(_ lesson: Lesson, childId: UUID) {
        var state = load(for: childId)
        if state.inProgressLessonID == lesson.id {
            state.inProgressLessonID = nil
            state.inProgressPercent = 0
            state.inProgressOpenedAt = nil
        }
        state.dismissedLessonIDs.removeAll { $0 == lesson.id }
        appendUnique(&state.recentTopicRawValues, lesson.theme.rawValue, limit: 12)
        _ = save(state, for: childId)
    }

    func dismissRecommendation(_ lessonID: UUID, childId: UUID) {
        var state = load(for: childId)
        appendUnique(&state.dismissedLessonIDs, lessonID, limit: 40)
        if state.inProgressLessonID == lessonID {
            state.inProgressLessonID = nil
            state.inProgressPercent = 0
            state.inProgressOpenedAt = nil
        }
        _ = save(state, for: childId)
    }

    func reset(for childId: UUID?) {
        if let childId {
            defaults.removeObject(forKey: keyPrefix + childId.uuidString)
        } else if let bundleId = Bundle.main.bundleIdentifier {
            // Clear all known keys for a full learner reset.
            let prefix = keyPrefix
            for key in defaults.dictionaryRepresentation().keys where key.hasPrefix(prefix) {
                defaults.removeObject(forKey: key)
            }
            _ = bundleId
        }
    }

    private func appendUnique<T: Equatable>(_ array: inout [T], _ value: T, limit: Int) {
        array.removeAll { $0 == value }
        array.append(value)
        if array.count > limit {
            array.removeFirst(array.count - limit)
        }
    }
}
