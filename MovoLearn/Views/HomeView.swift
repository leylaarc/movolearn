import SwiftUI

struct HomeView: View {
    let profile: ChildProfile
    let feed: HomeFeedModel
    let onStartLesson: (Lesson) -> Void
    var onEditInterests: (() -> Void)? = nil
    var onOpenSearch: (() -> Void)? = nil
    var onSelectInterest: ((Topic) -> Void)? = nil
    var onSelectSubject: ((ExploreSubjectCategory) -> Void)? = nil
    var onSeeAllSubjects: (() -> Void)? = nil
    var onOpenAdventures: (() -> Void)? = nil

    @State private var appeared = false

    private var displayName: String {
        let name = profile.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "Explorer" : name
    }

    var body: some View {
        ZStack {
            DesignSystem.Gradients.homeGradient
                .ignoresSafeArea()

            SoftBubbleAtmosphere(topic: feed.mascotTopic, intensity: 1.15)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
                    HomeKidHeader(
                        name: displayName,
                        subtitle: feed.greetingSubtitle,
                        mascotTopic: feed.mascotTopic,
                        streak: feed.playerStats?.streak ?? 0,
                        onSearch: onOpenSearch
                    )
                    .entrance(appeared: appeared)

                    continueSection
                        .entrance(appeared: appeared, delay: 0.06)

                    if let stats = feed.playerStats {
                        HomeTodayStrip(stats: stats, onTap: onOpenAdventures)
                            .entrance(appeared: appeared, delay: 0.1)
                    }

                    worldsSection
                        .entrance(appeared: appeared, delay: 0.14)
                }
                .padding(.horizontal, DesignSystem.Spacing.screenPadding)
                .padding(.top, DesignSystem.Spacing.md)
                .padding(.bottom, DesignSystem.Spacing.xxl)
            }
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.stagger.delay(0.04)) {
                appeared = true
            }
        }
    }

    @ViewBuilder
    private var continueSection: some View {
        if let model = feed.continueLearning {
            ContinueLearningCard(model: model) {
                onStartLesson(model.lesson)
            }
        } else if feed.isLoading {
            HomeLoadingCard()
        } else if profile.favoriteTopics.isEmpty {
            EmptyStateCard(
                icon: "heart.text.square.fill",
                title: "Pick what you love",
                message: "Choose a few favorites and we’ll make adventures for you.",
                accent: DesignSystem.Colors.lavenderPurple
            )
        } else if let first = feed.recommended.first {
            ContinueLearningCard(
                model: ContinueLearningCardModel(
                    lesson: first.lesson,
                    progressPercent: 0,
                    minutesRemaining: first.lesson.estimatedMinutes,
                    isResume: false,
                    subtitle: first.reason
                )
            ) {
                onStartLesson(first.lesson)
            }
        }
    }

    @ViewBuilder
    private var worldsSection: some View {
        let worlds = feed.worlds
        let topics = feed.interestTopics

        if !worlds.isEmpty || !topics.isEmpty {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                HomeSectionTitle(
                    title: "Your Worlds",
                    actionTitle: worldsActionTitle,
                    action: worldsAction
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        if !worlds.isEmpty {
                            ForEach(Array(worlds.enumerated()), id: \.element.id) { index, world in
                                WorldBubbleCard(world: world, floatDelay: Double(index) * 0.15) {
                                    openWorld(world)
                                }
                            }
                        } else {
                            ForEach(Array(topics.enumerated()), id: \.element.id) { index, topic in
                                WorldBubbleCard(
                                    world: SubjectWorld(
                                        id: topic.rawValue,
                                        topic: topic,
                                        subject: nil,
                                        title: TopicPalette.displayTitle(for: topic),
                                        subtitle: "",
                                        accent: TopicPalette.color(for: topic),
                                        masteryPercent: 0,
                                        sampleLesson: nil
                                    ),
                                    floatDelay: Double(index) * 0.15
                                ) {
                                    onSelectInterest?(topic)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.trailing, 4)
                }
            }
        }
    }

    private var worldsActionTitle: String? {
        if onSeeAllSubjects != nil { return "See all" }
        if onEditInterests != nil { return "Edit" }
        return nil
    }

    private var worldsAction: (() -> Void)? {
        onSeeAllSubjects ?? onEditInterests
    }

    private func openWorld(_ world: SubjectWorld) {
        if let topic = world.topic {
            onSelectInterest?(topic)
        } else if let subject = world.subject {
            onSelectSubject?(subject)
        } else {
            onSeeAllSubjects?()
        }
    }
}

#Preview {
    HomeView(
        profile: ChildProfile(nickname: "Leyla", favoriteTopics: [.dinosaurs, .space, .sharks]),
        feed: HomeFeedModel(
            greetingTitle: "Ready to explore, Leyla!",
            greetingSubtitle: "A new dinosaurs quest is ready.",
            continueLearning: ContinueLearningCardModel(
                lesson: BundledLessons.fossilDetective,
                progressPercent: 35,
                minutesRemaining: 7,
                isResume: true,
                subtitle: "Your adventure is waiting"
            ),
            recommended: [
                RecommendedLessonCardModel(lesson: BundledLessons.rocketMission, reason: "Matches Space", score: 50),
                RecommendedLessonCardModel(lesson: BundledLessons.sharkExplorer, reason: "Matches Sharks", score: 48)
            ],
            interestTopics: [.dinosaurs, .space, .sharks],
            featuredSubjects: [.science, .nature, .technology, .history],
            isLoading: false,
            playerStats: PlayerHomeStats(
                level: 3,
                levelTitle: "Quest Hero",
                adventuresCompleted: 4,
                streak: 2,
                dailyGoal: 1,
                dailyProgress: 0,
                skillOrbs: []
            ),
            missions: [],
            worlds: [
                SubjectWorld(
                    id: "d",
                    topic: .dinosaurs,
                    subject: nil,
                    title: "Dinosaurs",
                    subtitle: "Fun quests about dinosaurs",
                    accent: TopicPalette.color(for: .dinosaurs),
                    masteryPercent: 20,
                    sampleLesson: BundledLessons.fossilDetective
                ),
                SubjectWorld(
                    id: "s",
                    topic: .space,
                    subject: nil,
                    title: "Space",
                    subtitle: "Fun quests about space",
                    accent: TopicPalette.color(for: .space),
                    masteryPercent: 10,
                    sampleLesson: BundledLessons.rocketMission
                )
            ],
            discovery: nil,
            recentRewards: [],
            mascotTopic: .dinosaurs
        ),
        onStartLesson: { _ in },
        onEditInterests: {},
        onOpenSearch: {},
        onSelectInterest: { _ in },
        onSelectSubject: { _ in },
        onSeeAllSubjects: {},
        onOpenAdventures: {}
    )
}
