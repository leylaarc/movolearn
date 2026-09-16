import Foundation

@MainActor
final class SyncCoordinator {
    static let shared = SyncCoordinator()

    private let api: FamilyAPIClientProtocol
    private let sessionStore: ParentSessionStoreProtocol
    private let profileRepository: ProfileRepositoryProtocol
    private let progressStore: ProgressStore
    private let learningStore: LearningProgressStore
    private var pushTask: Task<Void, Never>?

    init(
        api: FamilyAPIClientProtocol = FamilyAPIClient.shared,
        sessionStore: ParentSessionStoreProtocol = ParentSessionStore.shared,
        profileRepository: ProfileRepositoryProtocol = ProfileRepository.shared,
        progressStore: ProgressStore = .shared,
        learningStore: LearningProgressStore = .shared
    ) {
        self.api = api
        self.sessionStore = sessionStore
        self.profileRepository = profileRepository
        self.progressStore = progressStore
        self.learningStore = learningStore
    }

    func applyAuth(_ response: FamilyAuthResponse) {
        guard FamilyCloudSync.isEnabled else { return }
        sessionStore.save(
            ParentSession(
                parent: response.parent,
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                accessTokenExpiresAt: Date().addingTimeInterval(TimeInterval(max(60, response.expiresIn - 30)))
            )
        )
    }

    func signOut() async {
        guard FamilyCloudSync.isEnabled else {
            sessionStore.clear()
            return
        }
        if let refresh = sessionStore.session?.refreshToken {
            await api.logout(refreshToken: refresh)
        }
        sessionStore.clear()
    }

    func deleteAccountAndLocalData() async throws {
        guard FamilyCloudSync.isEnabled else {
            sessionStore.clear()
            return
        }
        let token = try await validAccessToken()
        try await api.deleteAccount(accessToken: token)
        sessionStore.clear()
    }

    func deleteRemoteChild(_ childId: UUID) async {
        guard FamilyCloudSync.isEnabled, sessionStore.isSignedIn else { return }
        do {
            let token = try await validAccessToken()
            try await api.deleteChild(accessToken: token, childId: childId)
        } catch {
            #if DEBUG
            print("[MovoLearn] Remote child delete skipped — \(error.localizedDescription)")
            #endif
        }
    }

    func restoreFromCloudIfNeeded() async -> ChildProfile? {
        guard FamilyCloudSync.isEnabled else { return profileRepository.load() }
        guard sessionStore.isSignedIn else { return profileRepository.load() }
        do {
            let snapshot = try await fetchFamily()
            if let remote = snapshot.children.first {
                merge(remote)
                try? await pushNow()
                return profileRepository.load()
            }
            if let local = profileRepository.load() {
                try await pushNow()
                return local
            }
            return nil
        } catch {
            #if DEBUG
            print("[MovoLearn] Cloud restore skipped — \(error.localizedDescription)")
            #endif
            return profileRepository.load()
        }
    }

    func noteLocalChange() {
        guard FamilyCloudSync.isEnabled, sessionStore.isSignedIn else { return }
        pushTask?.cancel()
        pushTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            try? await self?.pushNow()
        }
    }

    func pushNow() async throws {
        guard FamilyCloudSync.isEnabled else { return }
        guard let profile = profileRepository.load() else { return }
        let token = try await validAccessToken()
        let payload = FamilySyncPayload(
            childId: profile.id,
            profile: profile,
            completions: progressStore.loadCompletions(),
            learningState: learningStore.loadState(for: profile.id),
            gameProgress: GameProgressStore.shared.load(for: profile.id),
            homeActivity: HomeActivityStore.shared.load(for: profile.id)
        )
        let remote = try await api.upsertChild(accessToken: token, payload: payload)
        merge(remote)
    }

    private func fetchFamily() async throws -> FamilySnapshot {
        let token = try await validAccessToken()
        return try await api.fetchFamily(accessToken: token)
    }

    private func merge(_ snapshot: FamilyChildSnapshot) {
        let localProfile = profileRepository.load()
        let keepLocalProfile = localProfile.map { $0.updatedAt >= snapshot.profile.updatedAt } ?? false
        let profile = keepLocalProfile ? (localProfile ?? snapshot.profile) : snapshot.profile
        _ = profileRepository.save(profile)

        var byID: [UUID: LessonCompletionRecord] = [:]
        for record in progressStore.loadCompletions() + snapshot.completions {
            byID[record.id] = record
        }
        progressStore.replaceCompletions(Array(byID.values).sorted { $0.completedAt < $1.completedAt })

        let localState = learningStore.loadState(for: profile.id)
        if let remoteState = snapshot.learningState {
            _ = learningStore.save(remoteState.updatedAt >= localState.updatedAt ? remoteState : localState)
        }

        if let game = snapshot.gameProgress {
            let localGame = GameProgressStore.shared.load(for: profile.id)
            let mergedIDs = Array(Set(localGame.unlockedRewardIDs + game.unlockedRewardIDs))
            var merged = localGame.unlockedRewardIDs.count >= game.unlockedRewardIDs.count ? localGame : game
            merged.unlockedRewardIDs = mergedIDs
            GameProgressStore.shared.save(merged, for: profile.id)
        }
        if let home = snapshot.homeActivity, HomeActivityStore.shared.load(for: profile.id) == .empty {
            _ = HomeActivityStore.shared.save(home, for: profile.id)
        }
    }

    private func validAccessToken() async throws -> String {
        guard let session = sessionStore.session else { throw FamilyAPIError.notSignedIn }
        if session.accessTokenExpiresAt > Date().addingTimeInterval(15) {
            return session.accessToken
        }
        let refreshed = try await api.refresh(refreshToken: session.refreshToken)
        sessionStore.updateTokens(
            accessToken: refreshed.accessToken,
            refreshToken: refreshed.refreshToken,
            expiresIn: refreshed.expiresIn
        )
        return refreshed.accessToken
    }
}
