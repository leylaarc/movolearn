import SwiftUI

struct ContentView: View {
    @State private var route: AppRoute = .welcome
    @State private var childProfile = ChildProfile()
    @State private var todaysLesson: Lesson?
    @State private var dailyLessonOptions: [Lesson] = []
    @State private var homeRecommendations: [LessonRecommendation] = []
    @State private var homeFeed = HomeFeedModel.loadingPlaceholder()
    @State private var userProgress = UserProgress.empty
    @State private var latestProgress: ProgressSummary?
    @State private var latestRewardResult: LessonRewardResult?
    @State private var nextLessonAfterCompletion: Lesson?
    @State private var showParentSummary = false
    @State private var lessonViewModel: LessonViewModel?
    @State private var store = AppStore()
    @ObservedObject private var sessionStore = ParentSessionStore.shared
    @State private var didRestoreSession = false
    @State private var showFamilyAccountSheet = false
    @State private var selectedTab: MainTab = .home
    @State private var exploreFocusTopic: Topic?
    @State private var exploreFocusSubject: ExploreSubjectCategory?
    @State private var adventureBrowseToken = 0
    @State private var pendingPlayKind: PlayGameKind?
    /// Loaded off the main thread — never call `LessonLoader.allLessons()` from `body`.
    @State private var catalogLessons: [Lesson] = []
    @State private var isRefreshingHome = false

    var body: some View {
        Group {
            switch route {
            case .welcome:
                WelcomeView {
                    route = FamilyCloudSync.isEnabled ? .parentAccount : .profileSetup
                }

            case .parentAccount:
                ParentAccountView(
                    onSignedIn: handleParentSignedIn,
                    onContinueLocally: { route = .profileSetup }
                )

            case .profileSetup:
                ChildProfileSetupView(
                    initialProfile: childProfile,
                    onContinue: { profile in
                        var saved = profile
                        saved.hasCompletedOnboarding = false
                        childProfile = store.persistProfile(saved)
                        _ = store.learningStore.appendEvent(
                            LearningEvent(childId: childProfile.id, type: .profileUpdated, metadata: ["phase": "profileSetup"]),
                            to: childProfile.id
                        )
                        route = .interestSelection
                    }
                )

            case .interestSelection:
                InterestSelectionView(
                    childName: PersonalizationService.shared.childReference,
                    mode: .onboarding,
                    onContinue: finishInterestSelection
                )

            case .editInterests:
                InterestSelectionView(
                    childName: PersonalizationService.shared.childReference,
                    mode: .editing,
                    initialTopics: childProfile.favoriteTopics,
                    onCancel: { route = .home },
                    onContinue: saveEditedInterests
                )

            case .home, .profileSettings:
                mainTabs

            case .lesson:
                if let lessonViewModel {
                    LessonView(viewModel: lessonViewModel) { summary in
                        if let lesson = todaysLesson {
                            userProgress = store.recordCompletion(
                                summary: summary,
                                lesson: lesson,
                                profile: &childProfile
                            )
                            latestRewardResult = store.lastRewardResult
                            nextLessonAfterCompletion = store.suggestedNextLesson(
                                for: childProfile,
                                excluding: lesson.id
                            )
                        } else {
                            nextLessonAfterCompletion = nil
                        }
                        latestProgress = summary
                        route = .lessonCompletion
                    }
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(DesignSystem.Colors.backgroundCream)
                }

            case .lessonCompletion:
                if let summary = latestProgress {
                    LessonCompletionView(
                        summary: summary,
                        rewardResult: latestRewardResult,
                        nextLesson: nextLessonAfterCompletion,
                        onPlayAnother: playAnotherAfterCompletion,
                        onGoHome: goHomeAfterCompletion
                    )
                }
            }
        }
        .onAppear(perform: restoreSessionIfNeeded)
        .task(id: route) {
            guard route == .home || route == .profileSettings else { return }
            if let ready = LessonLoader.cachedAllLessonsIfReady(), !ready.isEmpty {
                catalogLessons = ready
            }
        }
    }

    private var mainTabs: some View {
        MainTabShell(selectedTab: $selectedTab) {
            HomeView(
                profile: childProfile,
                feed: homeFeed,
                onStartLesson: startLesson,
                onEditInterests: { route = .editInterests },
                onOpenSearch: { openAdventures() },
                onSelectInterest: openAdventures(topic:),
                onSelectSubject: openAdventures(subject:),
                onSeeAllSubjects: { openAdventures() },
                onOpenAdventures: { openAdventures() },
                onStartPlay: startPlay
            )
        } adventures: {
            AdventuresView(
                profile: childProfile,
                lessons: catalogLessons.isEmpty ? dailyLessonOptions : catalogLessons,
                onStartLesson: startLesson,
                onStartPlay: startPlay,
                onEditInterests: { route = .editInterests },
                initialTopic: exploreFocusTopic,
                initialSubject: exploreFocusSubject,
                browseToken: adventureBrowseToken,
                discovery: homeFeed.discovery
            )
        } rewards: {
            RewardsView(
                profile: childProfile,
                game: store.gameSnapshot(for: childProfile.id)
            )
        } profile: {
            ProfileSettingsView(
                profile: childProfile,
                learningState: store.learningStore.loadState(for: childProfile.id),
                onSave: { updated in
                    let previous = childProfile
                    childProfile = store.persistProfile(updated)
                    _ = store.learningStore.appendEvent(
                        LearningEvent(childId: childProfile.id, type: .profileUpdated, metadata: ["phase": "settings"]),
                        to: childProfile.id
                    )
                    if ProfileContentInvalidator.snapshot(from: previous)
                        != ProfileContentInvalidator.snapshot(from: childProfile) {
                        todaysLesson = nil
                        dailyLessonOptions = []
                        homeRecommendations = []
                        homeFeed = HomeFeedModel.loadingPlaceholder(name: PersonalizationService.shared.greetingName)
                    }
                    Task { await refreshHomeAsync(advance: false) }
                    selectedTab = .home
                },
                onResetConfirmed: {
                    store.resetAllLearnerData()
                    childProfile = ChildProfile()
                    userProgress = .empty
                    dailyLessonOptions = []
                    homeRecommendations = []
                    homeFeed = HomeFeedModel.loadingPlaceholder()
                    todaysLesson = nil
                    latestProgress = nil
                    latestRewardResult = nil
                    lessonViewModel = nil
                    nextLessonAfterCompletion = nil
                    showParentSummary = false
                    selectedTab = .home
                    route = .welcome
                },
                onClose: nil,
                onEditInterests: { route = .editInterests },
                onOpenParentSummary: {
                    userProgress = store.progressStore.userProgress()
                    if latestProgress == nil, let record = userProgress.latestRecord,
                       let lesson = LessonLoader.lesson(id: record.lessonId) {
                        latestProgress = ProgressSummary(
                            from: lesson,
                            totalQuestions: record.totalQuestions,
                            correctAnswers: record.correctAnswers
                        )
                    }
                    showParentSummary = true
                },
                familyAccountEmail: FamilyCloudSync.isEnabled ? sessionStore.session?.parent.email : nil,
                onOpenFamilyAccount: FamilyCloudSync.isEnabled ? { showFamilyAccountSheet = true } : nil,
                onSignOutFamilyAccount: FamilyCloudSync.isEnabled ? {
                    Task { await SyncCoordinator.shared.signOut() }
                } : nil,
                onDeleteFamilyAccount: FamilyCloudSync.isEnabled ? {
                    Task {
                        try? await SyncCoordinator.shared.deleteAccountAndLocalData()
                        store.resetAllLearnerData()
                        childProfile = ChildProfile()
                        userProgress = .empty
                        dailyLessonOptions = []
                        homeRecommendations = []
                        homeFeed = HomeFeedModel.loadingPlaceholder()
                        selectedTab = .home
                        route = .welcome
                    }
                } : nil
            )
        }
        .fullScreenCover(isPresented: $showParentSummary) {
            ParentSummaryView(
                progress: userProgress,
                latestSummary: latestProgress,
                childName: PersonalizationService.shared.displayName,
                onDone: { showParentSummary = false },
                onUpdateInterests: {
                    showParentSummary = false
                    route = .editInterests
                }
            )
        }
        .sheet(isPresented: $showFamilyAccountSheet) {
            ParentAccountView(
                onSignedIn: { response in
                    handleParentSignedIn(response)
                    showFamilyAccountSheet = false
                },
                onContinueLocally: { showFamilyAccountSheet = false }
            )
        }
    }

    private func restoreSessionIfNeeded() {
        guard !didRestoreSession else { return }
        didRestoreSession = true

        if let saved = store.loadPersistedProfile() {
            applyRestoredProfile(saved)
        }

        guard FamilyCloudSync.isEnabled, sessionStore.isSignedIn else { return }
        Task {
            if let cloud = await SyncCoordinator.shared.restoreFromCloudIfNeeded() {
                applyRestoredProfile(cloud)
                if route == .home {
                    await refreshHomeAsync(advance: false)
                }
            }
        }
    }

    private func handleParentSignedIn(_ response: FamilyAuthResponse) {
        SyncCoordinator.shared.applyAuth(response)
        Task {
            if let restored = await SyncCoordinator.shared.restoreFromCloudIfNeeded() {
                applyRestoredProfile(restored)
                if restored.isReadyForHome || restored.hasValidName {
                    return
                }
            }
            if route == .welcome || route == .parentAccount {
                route = .profileSetup
            }
        }
    }

    private func applyRestoredProfile(_ saved: ChildProfile) {
        childProfile = saved
        userProgress = store.progressStore.userProgress()

        if saved.isReadyForHome {
            childProfile.lastActiveAt = Date()
            childProfile = store.persistProfile(childProfile)
            ApprovedContentLibrary.setHomePriority(
                topics: childProfile.favoriteTopics,
                readingLevel: childProfile.readingLevel,
                mathLevel: childProfile.mathLevel
            )
            route = .home
            Task { await refreshHomeAsync(advance: false) }
        } else if saved.hasValidName {
            route = saved.favoriteTopics.isEmpty ? .interestSelection : .home
            if route == .home {
                ApprovedContentLibrary.setHomePriority(
                    topics: childProfile.favoriteTopics,
                    readingLevel: childProfile.readingLevel,
                    mathLevel: childProfile.mathLevel
                )
                Task { await refreshHomeAsync(advance: false) }
            }
        }
    }

    @MainActor
    private func refreshHomeAsync(advance: Bool) async {
        guard !isRefreshingHome else { return }
        isRefreshingHome = true
        defer { isRefreshingHome = false }

        let profile = childProfile
        ApprovedContentLibrary.setHomePriority(
            topics: profile.favoriteTopics,
            readingLevel: profile.readingLevel,
            mathLevel: profile.mathLevel
        )
        // Seed only this child's slice first — the full topic matrix can take seconds.
        await Task.detached(priority: .userInitiated) {
            _ = LessonLoader.prepareHomeCatalog(
                topics: profile.favoriteTopics,
                readingLevel: profile.readingLevel,
                mathLevel: profile.mathLevel
            )
        }.value

        refreshHome(advance: advance)
        if catalogLessons.isEmpty, let ready = LessonLoader.cachedAllLessonsIfReady() {
            catalogLessons = ready
        }

        Task {
            let lessons = await Task.detached(priority: .utility) {
                LessonLoader.allLessons()
            }.value
            catalogLessons = lessons
            refreshHome(advance: false)
        }
    }

    private func finishInterestSelection(_ topics: [Topic]) {
        applyFavoriteTopics(topics, advance: false, completingOnboarding: true)
    }

    private func saveEditedInterests(_ topics: [Topic]) {
        applyFavoriteTopics(topics, advance: false, completingOnboarding: false)
    }

    /// Updates only `favoriteTopics`, preserves progress, refreshes home lesson options.
    private func applyFavoriteTopics(_ topics: [Topic], advance: Bool, completingOnboarding: Bool) {
        guard topics.count >= 3 else { return }
        let topicsCopy = topics

        store.updateFavoriteTopics(topicsCopy, in: &childProfile)
        if completingOnboarding {
            childProfile.hasCompletedOnboarding = true
        }
        childProfile = store.persistProfile(childProfile)
        _ = store.learningStore.appendEvent(
            LearningEvent(
                childId: childProfile.id,
                type: .interestSelected,
                metadata: ["count": String(topicsCopy.count)]
            ),
            to: childProfile.id
        )

        todaysLesson = nil
        dailyLessonOptions = []
        homeRecommendations = []
        homeFeed = HomeFeedModel.loadingPlaceholder(name: PersonalizationService.shared.greetingName)
        selectedTab = .home
        route = .home

        Task { await refreshHomeAsync(advance: advance) }
    }

    private func openAdventures() {
        exploreFocusTopic = nil
        exploreFocusSubject = nil
        adventureBrowseToken += 1
        selectedTab = .adventures
    }

    private func openAdventures(topic: Topic) {
        exploreFocusTopic = topic
        exploreFocusSubject = nil
        selectedTab = .adventures
        clearAdventureFocusSoon()
    }

    private func openAdventures(subject: ExploreSubjectCategory) {
        exploreFocusTopic = nil
        exploreFocusSubject = subject
        selectedTab = .adventures
        clearAdventureFocusSoon()
    }

    private func clearAdventureFocusSoon() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            exploreFocusTopic = nil
            exploreFocusSubject = nil
        }
    }

    private func goHomeAfterCompletion() {
        store.clearNewRewards(for: childProfile.id)
        nextLessonAfterCompletion = nil
        Task { await refreshHomeAsync(advance: true) }
        selectedTab = .home
        route = .home
    }

    private func playAnotherAfterCompletion() {
        store.clearNewRewards(for: childProfile.id)
        guard let next = nextLessonAfterCompletion else {
            goHomeAfterCompletion()
            return
        }
        nextLessonAfterCompletion = nil
        startLesson(next)
    }

    private func startLesson(_ lesson: Lesson) {
        guard lesson.isApprovedForChildDisplay || lesson.contentApprovalStatus == .legacyBundled else {
            #if DEBUG
            print("Blocked unapproved lesson: \(lesson.title) status=\(lesson.contentApprovalStatus.rawValue)")
            #endif
            pendingPlayKind = nil
            return
        }
        // Prefer exact-level approved content when the opened lesson is off-level legacy.
        // Always preserve topic — never swap jungle into horses (or any other theme).
        let ability = LessonDifficultyRules.abilityProfile(for: childProfile)
        var lessonToStart = lesson
        if lesson.contentApprovalStatus == .legacyBundled,
           (lesson.readingLevel != ability.readingLevel || lesson.mathLevel != ability.mathLevel),
           let replacement = ContentLibrarySelector.replacement(for: lesson, profile: childProfile) {
            lessonToStart = replacement
        }

        let learningState = store.learningStore.loadState(for: childProfile.id)
        let prepared = ContentAdaptationService.prepare(
            lesson: lessonToStart,
            profile: childProfile,
            learningState: learningState
        )
        #if DEBUG
        if !prepared.gate.passed {
            print("Lesson gate warnings for \(prepared.lesson.title):\n\(prepared.gate.failedSummaries.joined(separator: "\n"))")
        }
        if !prepared.adaptationsApplied.isEmpty {
            print("Adaptations: \(prepared.adaptationsApplied.joined(separator: "; "))")
        }
        #endif
        todaysLesson = prepared.lesson
        RecentLessonStructureTracker.record(lesson: prepared.lesson)
        store.markLessonStarted(prepared.lesson, childId: childProfile.id)
        LearningSessionRecorder.recordLessonStarted(childId: childProfile.id, lesson: prepared.lesson)
        lessonViewModel = LessonViewModel(
            lesson: prepared.lesson,
            childId: childProfile.id,
            profile: childProfile,
            learningState: learningState,
            playKind: pendingPlayKind
        )
        pendingPlayKind = nil
        route = .lesson
    }

    private func startPlay(_ offer: PlayGameOffer) {
        pendingPlayKind = offer.kind
        startLesson(offer.lesson)
    }

    private func refreshHome(advance: Bool) {
        dailyLessonOptions = store.pickDailyOptions(for: childProfile, advance: advance)
        homeRecommendations = store.homeRecommendations(for: childProfile)
        homeFeed = store.buildHomeFeed(for: childProfile)
        todaysLesson = homeFeed.continueLearning?.lesson ?? dailyLessonOptions.first
    }
}

#Preview {
    ContentView()
}
