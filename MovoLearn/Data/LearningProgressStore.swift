import Foundation

/// Persists skill progress and learning events separately from public curriculum data.
final class LearningProgressStore {
    static let shared = LearningProgressStore()

    private let defaults: UserDefaults
    private let stateKey = "com.movolearn.learningState"
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    func loadState(for childId: UUID) -> ChildLearningState {
        guard let data = defaults.data(forKey: stateKey) else {
            return .empty(childId: childId)
        }
        do {
            let state = try decoder.decode(ChildLearningState.self, from: data)
            if state.childProfileId != childId {
                return .empty(childId: childId)
            }
            return state
        } catch {
            #if DEBUG
            print("[MovoLearn] Learning state decode failure — \(error)")
            #endif
            return .empty(childId: childId)
        }
    }

    @discardableResult
    func save(_ state: ChildLearningState) -> Bool {
        var copy = state
        copy.updatedAt = Date()
        do {
            let data = try encoder.encode(copy)
            defaults.set(data, forKey: stateKey)
            return true
        } catch {
            #if DEBUG
            print("[MovoLearn] Learning state encode failure — \(error)")
            #endif
            return false
        }
    }

    func appendEvent(_ event: LearningEvent, to childId: UUID) -> ChildLearningState {
        var state = loadState(for: childId)
        state.events.append(event)
        // Keep a bounded event log for local MVP storage.
        if state.events.count > 500 {
            state.events = Array(state.events.suffix(500))
        }
        save(state)
        return state
    }

    func upsertSkillProgress(_ progress: ChildSkillProgress) -> ChildLearningState {
        var state = loadState(for: progress.childProfileId)
        if let index = state.skillProgress.firstIndex(where: { $0.marbleTopicId == progress.marbleTopicId }) {
            state.skillProgress[index] = progress
        } else {
            state.skillProgress.append(progress)
        }
        save(state)
        return state
    }

    func reset(for childId: UUID? = nil) {
        if let childId {
            save(.empty(childId: childId))
        } else {
            defaults.removeObject(forKey: stateKey)
        }
    }
}
