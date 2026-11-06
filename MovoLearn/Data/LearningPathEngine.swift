import Foundation

enum HomeRecommendationKind: String, CaseIterable, Identifiable {
    case continueLearning
    case storyAdventure
    case mathChallenge
    case readingLanguage
    case scienceDiscovery
    case creativeActivity
    case reviewStrengthen

    var id: String { rawValue }

    var title: String {
        switch self {
        case .continueLearning: return "Continue Learning"
        case .storyAdventure: return "Story Adventure"
        case .mathChallenge: return "Math Challenge"
        case .readingLanguage: return "Reading and Language"
        case .scienceDiscovery: return "Science Discovery"
        case .creativeActivity: return "Creative Activity"
        case .reviewStrengthen: return "Review and Strengthen"
        }
    }

    var subtitle: String {
        switch self {
        case .continueLearning: return "Pick up where you left off"
        case .storyAdventure: return "A story-powered mission"
        case .mathChallenge: return "Numbers and problem solving"
        case .readingLanguage: return "Words, clues, and meaning"
        case .scienceDiscovery: return "Explore how the world works"
        case .creativeActivity: return "Draw, invent, and create"
        case .reviewStrengthen: return "Practice skills that need a boost"
        }
    }

    var systemImage: String {
        switch self {
        case .continueLearning: return "arrow.forward.circle.fill"
        case .storyAdventure: return "book.fill"
        case .mathChallenge: return "plus.forwardslash.minus"
        case .readingLanguage: return "text.book.closed.fill"
        case .scienceDiscovery: return "sparkles"
        case .creativeActivity: return "paintbrush.fill"
        case .reviewStrengthen: return "arrow.clockwise.circle.fill"
        }
    }
}

struct LessonRecommendation: Identifiable {
    let id: UUID
    let kind: HomeRecommendationKind
    let lesson: Lesson
    let reason: String
    let score: Double

    init(kind: HomeRecommendationKind, lesson: Lesson, reason: String, score: Double) {
        self.id = UUID()
        self.kind = kind
        self.lesson = lesson
        self.reason = reason
        self.score = score
    }
}

/// Adaptive lesson selection using profile, mastery, and Marble prerequisites.
struct LearningPathEngine {
    struct Context {
        let profile: ChildProfile
        let learningState: ChildLearningState
        let completedLessonIDs: Set<UUID>
        let allLessons: [Lesson]
        let curriculum: MarbleCurriculumService
        let recentMistakeTopicIds: [String]
        /// Subject just finished. The next open lesson should be a different kind of activity.
        var lastCompletedSubject: PrimarySubject? = nil
    }

    static func recommendations(for context: Context, limitPerKind: Int = 1) -> [LessonRecommendation] {
        let mapped = LessonCurriculumMapper.applyAll(to: context.allLessons)
        var results: [LessonRecommendation] = []
        var usedLessonIDs = Set<UUID>()

        func take(kind: HomeRecommendationKind, from candidates: [(Lesson, Double, String)]) {
            let filtered = candidates
                .filter { !usedLessonIDs.contains($0.0.id) }
                .sorted { $0.1 > $1.1 }
            for item in filtered.prefix(limitPerKind) {
                usedLessonIDs.insert(item.0.id)
                results.append(LessonRecommendation(kind: kind, lesson: item.0, reason: item.2, score: item.1))
            }
        }

        take(kind: .reviewStrengthen, from: scoreLessons(
            mapped,
            context: context,
            preferReview: true,
            categoryHint: nil
        ))

        take(kind: .continueLearning, from: preferringDifferentSubject(
            scoreLessons(
                mapped,
                context: context,
                preferInProgress: true,
                categoryHint: nil
            ),
            avoiding: context.lastCompletedSubject
        ))

        take(kind: .storyAdventure, from: scoreLessons(
            mapped, context: context, categoryHint: .story, primarySubject: .reading
        ))
        take(kind: .mathChallenge, from: scoreLessons(
            mapped, context: context, categoryHint: .math, primarySubject: .math
        ))
        take(kind: .readingLanguage, from: scoreLessons(
            mapped, context: context, learningGoal: .reading, primarySubject: .reading
        ))
        take(kind: .scienceDiscovery, from: scoreLessons(
            mapped, context: context, categoryHint: .discovery, learningGoal: .science, primarySubject: .science
        ))
        take(kind: .creativeActivity, from: scoreLessons(
            mapped, context: context, categoryHint: .creative, primarySubject: .creative
        ))

        // Fill any empty slots with best remaining age/interest matches.
        if results.count < HomeRecommendationKind.allCases.count {
            let remaining = scoreLessons(mapped, context: context)
                .filter { !usedLessonIDs.contains($0.0.id) }
                .sorted { $0.1 > $1.1 }
            for kind in HomeRecommendationKind.allCases where !results.contains(where: { $0.kind == kind }) {
                guard let next = remaining.first(where: { !usedLessonIDs.contains($0.0.id) }) else { break }
                usedLessonIDs.insert(next.0.id)
                results.append(LessonRecommendation(kind: kind, lesson: next.0, reason: next.2, score: next.1))
            }
        }

        return results.sorted { lhs, rhs in
            let order = HomeRecommendationKind.allCases
            let li = order.firstIndex(of: lhs.kind) ?? 0
            let ri = order.firstIndex(of: rhs.kind) ?? 0
            return li < ri
        }
    }

    /// Flat list used by Home when a simpler chooser is preferred.
    static func pickDailyOptions(for context: Context, count: Int = 4) -> [Lesson] {
        let recs = recommendations(for: context)
        var lessons: [Lesson] = []
        var seen = Set<UUID>()
        for rec in recs {
            if seen.insert(rec.lesson.id).inserted {
                lessons.append(rec.lesson)
            }
            if lessons.count >= count { break }
        }
        if lessons.count < count {
            let extras = scoreLessons(LessonCurriculumMapper.applyAll(to: context.allLessons), context: context)
                .map(\.0)
            for lesson in extras where seen.insert(lesson.id).inserted {
                lessons.append(lesson)
                if lessons.count >= count { break }
            }
        }
        return lessons
    }

    /// Keep a just-finished subject (counting, reading, art) from being the next open lesson
    /// when another kind of lesson is available.
    private static func preferringDifferentSubject(
        _ candidates: [(Lesson, Double, String)],
        avoiding subject: PrimarySubject?
    ) -> [(Lesson, Double, String)] {
        guard let subject else { return candidates }
        let fresh = candidates.filter { $0.0.primarySubject != subject }
        return fresh.isEmpty ? candidates : fresh
    }

    private static func scoreLessons(
        _ lessons: [Lesson],
        context: Context,
        preferReview: Bool = false,
        preferInProgress: Bool = false,
        categoryHint: LessonCategory? = nil,
        learningGoal: LearningGoal? = nil,
        primarySubject: PrimarySubject? = nil
    ) -> [(Lesson, Double, String)] {
        let age = context.profile.currentAge
        let favorites = Set(context.profile.favoriteTopics)

        return lessons.compactMap { lesson in
            var score = 0.0
            var reasons: [String] = []

            // Hard filter: section taps must match explicit primarySubject / topic mapping.
            if let primarySubject, lesson.primarySubject != primarySubject {
                return nil
            }

            let ageRange = lesson.recommendedAgeRange ?? lesson.ageTarget
            if LessonDifficultyRules.ageMatches(ageRange, age) {
                score += 12
            } else {
                score -= 18
            }

            if favorites.contains(lesson.theme) {
                score += 25
                reasons.append("matches interests")
            }

            if lesson.readingLevel == context.profile.readingLevel {
                score += 18
                reasons.append("matches reading level")
            } else if abs(lesson.readingLevel.sortOrder - context.profile.readingLevel.sortOrder) > 1 {
                // Hard preference: do not surface far-off reading content.
                score -= 35
            }

            if lesson.primarySubject == .math || lesson.category == .math {
                if lesson.mathLevel == context.profile.mathLevel {
                    score += 22
                    reasons.append("matches math level")
                } else if abs(lesson.mathLevel.sortOrder - context.profile.mathLevel.sortOrder) > 0 {
                    score -= 40
                }
            } else if abs(lesson.mathLevel.sortOrder - context.profile.mathLevel.sortOrder) <= 1 {
                score += 4
            }

            if !lesson.isApprovedForChildDisplay && lesson.contentApprovalStatus != .legacyBundled {
                return nil
            }
            if lesson.isApprovedForChildDisplay {
                score += 12
            }

            // Avoid unnecessary repetition, but allow review.
            if context.completedLessonIDs.contains(lesson.id) {
                if preferReview {
                    score += 5
                } else {
                    score -= 20
                }
            }

            if let categoryHint, lesson.category == categoryHint {
                score += 18
                reasons.append(categoryHint.rawValue.lowercased())
            }

            if let primarySubject {
                score += 22
                reasons.append(primarySubject.displayName.lowercased())
            }

            if let learningGoal {
                if lesson.learningGoal == learningGoal || lesson.skillsPracticed.contains(where: { $0.localizedCaseInsensitiveContains(learningGoal.rawValue) }) {
                    score += 16
                } else {
                    score -= 8
                }
            }

            if let primary = lesson.primaryTopicId {
                let progress = context.learningState.progress(for: primary)
                let hardReady = hardPrerequisitesReady(topicId: primary, context: context)
                if !hardReady {
                    score -= 40
                    reasons.append("building earlier skills first")
                } else {
                    score += 10
                }

                let softEdges = context.curriculum.softPrerequisites(for: primary)
                let softReadyCount = softEdges.filter {
                    MasteryEngine.isPrerequisiteReady(context.learningState.progress(for: $0.prerequisiteId))
                }.count
                score += Double(softReadyCount) * 2

                if let progress {
                    switch progress.status {
                    case .needsReview:
                        score += preferReview ? 40 : 20
                        reasons.append("ready for a refresh")
                    case .practicing, .introduced:
                        score += preferInProgress ? 30 : 12
                        reasons.append("already practicing")
                    case .developing:
                        score += preferInProgress ? 22 : 10
                    case .mastered:
                        score -= preferReview ? 0 : 15
                    case .notStarted:
                        score += 6
                    }
                } else if hardReady {
                    score += 14
                    reasons.append("ready to unlock")
                }

                if context.recentMistakeTopicIds.contains(primary) {
                    score += 18
                    reasons.append("supports a recent tricky skill")
                }

                // Interest-connected new topics
                if favorites.contains(lesson.theme), progress == nil || progress?.status == .notStarted {
                    score += 10
                }

                // Enrichment when performing above expected level
                if context.profile.mathLevel == .advancing || context.profile.readingLevel == .confidentReader {
                    if lesson.difficultyLevel.sortOrder >= DifficultyLevel.growingReader.sortOrder {
                        score += 6
                    }
                }
            } else {
                // Unmapped lessons remain eligible via interests/age only.
                score += 4
                reasons.append("theme adventure")
            }

            // Preferred activity types
            if context.profile.preferredActivityTypes.contains(.math), lesson.primarySubject == .math {
                score += 6
            }
            if context.profile.preferredActivityTypes.contains(.story), lesson.primarySubject == .reading {
                score += 6
            }
            if context.profile.preferredActivityTypes.contains(.creative), lesson.primarySubject == .creative {
                score += 6
            }

            // Controlled variety: slight preference for unread lesson types
            score += Double(abs(lesson.title.hashValue % 7)) * 0.1

            let reason = reasons.first.map { "Chosen because it \($0)." } ?? "A good next step for you."
            return (lesson, score, reason)
        }
    }

    private static func hardPrerequisitesReady(topicId: String, context: Context) -> Bool {
        let hard = context.curriculum.hardPrerequisites(for: topicId)
        guard !hard.isEmpty else { return true }
        return hard.allSatisfy { edge in
            MasteryEngine.isPrerequisiteReady(context.learningState.progress(for: edge.prerequisiteId))
        }
    }
}

private extension DifficultyLevel {
    var sortOrder: Int {
        switch self {
        case .beginner: return 0
        case .earlyReader: return 1
        case .growingReader: return 2
        case .confidentReader: return 3
        }
    }
}
