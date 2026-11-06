import SwiftUI

/// Combined Adventures catalog — every lesson available for the child’s level.
struct AdventuresView: View {
    let profile: ChildProfile
    let lessons: [Lesson]
    let onStartLesson: (Lesson) -> Void
    var onStartPlay: ((PlayGameOffer) -> Void)? = nil
    var onEditInterests: (() -> Void)? = nil
    var initialTopic: Topic? = nil
    var initialSubject: ExploreSubjectCategory? = nil
    var browseToken: Int = 0
    var discovery: DiscoveryChallengeModel? = nil

    @State private var searchText = ""
    @State private var selectedCategory: LessonCategory?
    @State private var selectedTopic: Topic?
    @State private var selectedSubject: ExploreSubjectCategory?
    @State private var gameOffers: [PlayGameOffer] = []
    @State private var appeared = false
    @State private var didApplyInitialFocus = false

    private var ability: LearnerAbilityProfile {
        LessonDifficultyRules.abilityProfile(for: profile)
    }

    private var levelMatched: [Lesson] {
        CatalogBrowseSelector.levelMatchedLessons(from: lessons, profile: profile)
    }

    private var isSearching: Bool {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }

    private var mascotTopic: Topic {
        selectedTopic
            ?? selectedSubject?.representativeTopic
            ?? profile.favoriteTopics.first
            ?? .space
    }

    private var visibleLessons: [Lesson] {
        var pool = levelMatched
        if let selectedSubject {
            pool = pool.filter { selectedSubject.topics.contains($0.theme) }
        }
        if let selectedTopic {
            pool = pool.filter { $0.theme == selectedTopic }
        }
        if let selectedCategory {
            pool = pool.filter { $0.category == selectedCategory }
        }
        return pool
    }

    private var groupedLessons: [CatalogTopicGroup] {
        CatalogBrowseSelector.groupedByTopic(visibleLessons, favoriteTopics: profile.favoriteTopics)
    }

    private var topicChips: [Topic] {
        let fromLessons = CatalogBrowseSelector.groupedByTopic(
            {
                var pool = levelMatched
                if let selectedSubject {
                    pool = pool.filter { selectedSubject.topics.contains($0.theme) }
                }
                return pool
            }(),
            favoriteTopics: profile.favoriteTopics
        ).map(\.topic)
        if let selectedTopic, !fromLessons.contains(selectedTopic) {
            return [selectedTopic] + fromLessons
        }
        return fromLessons
    }

    private var searchMatches: [Lesson] {
        let needle = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard needle.count >= 2 else { return [] }
        return levelMatched.filter {
            $0.title.lowercased().contains(needle)
                || $0.theme.rawValue.lowercased().contains(needle)
                || $0.teaser.lowercased().contains(needle)
                || $0.category.displayName.lowercased().contains(needle)
                || $0.category.shortLabel.lowercased().contains(needle)
                || $0.primarySubject.displayName.lowercased().contains(needle)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.Gradients.homeGradient
                    .ignoresSafeArea()

                SoftBubbleAtmosphere(topic: mascotTopic, intensity: 1.15)

                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
                        header
                            .entrance(appeared: appeared)

                        if isSearching {
                            searchResultsSection
                        } else {
                            browseContent
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.screenPadding)
                    .padding(.top, DesignSystem.Spacing.md)
                    .padding(.bottom, DesignSystem.Spacing.xxl)
                }
            }
            .navigationBarHidden(true)
            .searchable(text: $searchText, prompt: "Find a quest")
        }
        .onAppear {
            applyInitialFocusIfNeeded()
            refreshGameOffers()
            withAnimation(DesignSystem.Animation.stagger.delay(0.04)) { appeared = true }
        }
        .onChange(of: initialTopic) { _, newValue in
            if let newValue {
                selectedTopic = newValue
                selectedSubject = nil
            }
        }
        .onChange(of: initialSubject) { _, newValue in
            if let newValue {
                selectedSubject = newValue
                selectedTopic = nil
            }
        }
        .onChange(of: browseToken) { _, newValue in
            guard newValue > 0 else { return }
            searchText = ""
            selectedCategory = nil
            selectedTopic = nil
            selectedSubject = nil
        }
        .onChange(of: lessons.map(\.id)) { _, _ in
            refreshGameOffers()
        }
    }

    private func refreshGameOffers() {
        let pool = CatalogBrowseSelector.levelMatchedLessons(from: lessons, profile: profile)
        gameOffers = PlayGameCatalog.offers(
            from: pool,
            favoriteTopics: profile.favoriteTopics,
            limit: 8
        )
    }

    private func applyInitialFocusIfNeeded() {
        guard !didApplyInitialFocus else { return }
        didApplyInitialFocus = true
        selectedTopic = initialTopic
        selectedSubject = initialSubject
    }

    private var header: some View {
        KidScreenHeader(
            title: headerTitle,
            subtitle: headerSubtitle,
            mascotTopic: mascotTopic
        ) {
            if selectedSubject != nil || selectedTopic != nil {
                Button {
                    withAnimation(DesignSystem.Animation.gentle) {
                        selectedSubject = nil
                        selectedTopic = nil
                    }
                } label: {
                    Text("See all")
                        .font(DesignSystem.Typography.sectionHeader(14))
                        .foregroundStyle(DesignSystem.Colors.skyBlue)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .frame(minHeight: 44)
                        .background(DesignSystem.Colors.cardWhite.opacity(0.9))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("See all adventures")
            }
        }
    }

    private var headerTitle: String {
        if let selectedTopic { return TopicPalette.displayTitle(for: selectedTopic) }
        if let selectedSubject { return selectedSubject.worldTitle }
        return "Adventures"
    }

    private var headerSubtitle: String {
        if let selectedTopic {
            return TopicLibrary.definition(for: selectedTopic).description
        }
        if let selectedSubject {
            return selectedSubject.subtitle
        }
        let count = levelMatched.count
        if profile.currentAge <= 7 {
            return count == 0
                ? "Getting your quests ready…"
                : "All \(count) quests for your level."
        }
        return count == 0
            ? "Loading lessons for \(ability.readingLevel.rawValue) · \(ability.mathLevel.rawValue)…"
            : "\(count) lessons for \(ability.readingLevel.rawValue) · \(ability.mathLevel.rawValue)."
    }

    @ViewBuilder
    private var browseContent: some View {
        if let discovery, let lesson = discovery.lesson,
           selectedTopic == nil, selectedSubject == nil, selectedCategory == nil {
            DiscoveryChallengeCard(model: discovery) {
                onStartLesson(lesson)
            }
        }

        if !visiblePractice.isEmpty {
            practiceSection
        }

        filterChips

        if lessons.isEmpty {
            HomeLoadingCard(message: "Finding every quest for your level…")
        } else if groupedLessons.isEmpty {
            EmptyStateCard(
                icon: "map.fill",
                title: "No quests here yet",
                message: "Try another world — or check back soon.",
                accent: DesignSystem.Colors.skyBlue
            )
        } else {
            ForEach(groupedLessons) { group in
                topicSection(group)
            }
        }
    }

    private var filterChips: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CatalogFilterChip(
                        title: "All kinds",
                        tint: DesignSystem.Colors.lavenderPurple,
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                    }
                    ForEach(LessonCategory.allCases) { category in
                        CatalogFilterChip(
                            title: category.shortLabel,
                            tint: category.accentColor,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
                .padding(.vertical, 2)
            }

            if !topicChips.isEmpty {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    HomeSectionTitle(
                        title: selectedSubject == nil ? "Worlds" : "Topics",
                        actionTitle: onEditInterests == nil ? nil : "Edit",
                        action: onEditInterests
                    )
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CatalogFilterChip(
                                title: "All worlds",
                                tint: DesignSystem.Colors.skyBlue,
                                isSelected: selectedTopic == nil
                            ) {
                                selectedTopic = nil
                            }
                            ForEach(topicChips) { topic in
                                CatalogFilterChip(
                                    title: TopicPalette.displayTitle(for: topic),
                                    tint: TopicPalette.color(for: topic),
                                    isSelected: selectedTopic == topic
                                ) {
                                    selectedTopic = selectedTopic == topic ? nil : topic
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
    }

    private var visiblePractice: [PlayGameOffer] {
        gameOffers.filter { offer in
            if let selectedTopic, offer.lesson.theme != selectedTopic { return false }
            if let selectedSubject, !(selectedSubject.topics.contains(offer.lesson.theme)) { return false }
            if let selectedCategory, offer.lesson.category != selectedCategory { return false }
            return true
        }
    }

    private var practiceSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HomeSectionTitle(title: "Practice")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                    ForEach(visiblePractice) { offer in
                        PlayGameCard(offer: offer) {
                            if let onStartPlay {
                                onStartPlay(offer)
                            } else {
                                onStartLesson(offer.lesson)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.trailing, 4)
            }
        }
    }

    private func topicSection(_ group: CatalogTopicGroup) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            if selectedTopic == nil {
                HomeSectionTitle(title: TopicPalette.displayTitle(for: group.topic))
            }
            ForEach(group.lessons) { lesson in
                RecommendedLessonCard(
                    model: RecommendedLessonCardModel(
                        lesson: lesson,
                        reason: lesson.category.displayName,
                        score: 0
                    )
                ) {
                    onStartLesson(lesson)
                }
            }
        }
    }

    @ViewBuilder
    private var searchResultsSection: some View {
        if searchMatches.isEmpty {
            EmptyStateCard(
                icon: "magnifyingglass",
                title: "No matches",
                message: "Try a word like “space” or “dinosaurs”.",
                accent: DesignSystem.Colors.skyBlue
            )
        } else {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                HomeSectionTitle(title: "Adventures")
                ForEach(searchMatches) { lesson in
                    RecommendedLessonCard(
                        model: RecommendedLessonCardModel(
                            lesson: lesson,
                            reason: "\(lesson.category.shortLabel) · \(TopicPalette.displayTitle(for: lesson.theme))",
                            score: 0
                        )
                    ) {
                        onStartLesson(lesson)
                    }
                }
            }
        }
    }
}

private struct CatalogFilterChip: View {
    let title: String
    let tint: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignSystem.Typography.sectionHeader(14))
                .foregroundStyle(isSelected ? .white : DesignSystem.Colors.deepNavy)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(minHeight: 44)
                .background(
                    Capsule()
                        .fill(isSelected ? tint : DesignSystem.Colors.cardWhite.opacity(0.92))
                )
                .overlay(
                    Capsule()
                        .stroke(tint.opacity(isSelected ? 0 : 0.35), lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel(title)
    }
}
