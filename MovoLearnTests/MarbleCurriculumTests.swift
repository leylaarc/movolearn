import XCTest
@testable import MovoLearn

final class MarbleCurriculumTests: XCTestCase {
    func testTopicsDecodeAndLookup() throws {
        let curriculum = MarbleCurriculumService.shared
        XCTAssertTrue(curriculum.loadIfNeeded() || curriculum.topics.isEmpty == false || curriculum.loadError != nil)
        guard !curriculum.topics.isEmpty else {
            throw XCTSkip("Marble JSON not present in test host bundle")
        }
        let first = curriculum.topics[0]
        XCTAssertEqual(curriculum.topic(id: first.id)?.id, first.id)
    }

    func testPrerequisiteDirection() throws {
        let curriculum = MarbleCurriculumService.shared
        _ = curriculum.loadIfNeeded()
        guard let edge = curriculum.dependencies.first else {
            throw XCTSkip("Marble dependencies unavailable")
        }
        let prereqs = curriculum.prerequisites(for: edge.topicId)
        XCTAssertTrue(prereqs.contains(where: { $0.prerequisiteId == edge.prerequisiteId }))
        let unlocks = curriculum.unlocks(from: edge.prerequisiteId)
        XCTAssertTrue(unlocks.contains(where: { $0.topicId == edge.topicId }))
    }

    func testHardVersusSoftFiltering() throws {
        let curriculum = MarbleCurriculumService.shared
        _ = curriculum.loadIfNeeded()
        guard let topicId = curriculum.dependencies.first?.topicId else {
            throw XCTSkip("Marble dependencies unavailable")
        }
        let hard = curriculum.hardPrerequisites(for: topicId)
        let soft = curriculum.softPrerequisites(for: topicId)
        XCTAssertTrue(hard.allSatisfy { $0.strength == .hard })
        XCTAssertTrue(soft.allSatisfy { $0.strength == .soft })
    }

    func testAgeFiltering() throws {
        let curriculum = MarbleCurriculumService.shared
        _ = curriculum.loadIfNeeded()
        guard !curriculum.topics.isEmpty else {
            throw XCTSkip("Marble topics unavailable")
        }
        let age6 = curriculum.topics(forAge: 6)
        XCTAssertFalse(age6.isEmpty)
        XCTAssertTrue(age6.allSatisfy { $0.includesAge(6) })
    }

    func testLessonRecommendationRankingNotEmpty() throws {
        let profile = ChildProfile(
            nickname: "Mia",
            age: 6,
            favoriteTopics: [.sharks, .space],
            hasCompletedOnboarding: true
        )
        let lessons = LessonLoader.allLessons()
        guard !lessons.isEmpty else {
            throw XCTSkip("Lessons unavailable")
        }
        let curriculum = MarbleCurriculumService.shared
        _ = curriculum.loadIfNeeded()
        let options = LearningPathEngine.pickDailyOptions(
            for: .init(
                profile: profile,
                learningState: .empty(childId: profile.id),
                completedLessonIDs: [],
                allLessons: lessons,
                curriculum: curriculum,
                recentMistakeTopicIds: []
            ),
            count: 4
        )
        XCTAssertFalse(options.isEmpty)
    }

    func testCompletedCountingLessonIsNotFollowedByAnotherCountingLesson() throws {
        let topics: [Topic] = [.sharks, .space, .dinosaurs]
        var lessons: [Lesson] = []
        for topic in topics {
            for category in [LessonCategory.math, .story, .discovery, .creative] {
                guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                    topic: topic,
                    category: category,
                    readingLevel: .earlyReader,
                    mathLevel: .emerging
                ) else { continue }
                lessons.append(lesson)
            }
        }
        let counting = lessons.filter { $0.primarySubject == .math }
        XCTAssertGreaterThanOrEqual(counting.count, 2, "Need counting lessons in more than one world")
        let finished = counting[0]
        let otherCounting = counting[1]
        let profile = ChildProfile(
            nickname: "Mia",
            age: 6,
            readingLevel: .earlyReader,
            mathLevel: .emerging,
            favoriteTopics: topics,
            hasCompletedOnboarding: true
        )
        let context = HomeFeedBuilder.Context(
            profile: profile,
            activity: .empty,
            completedLessonIDs: [finished.id],
            learningState: .empty(childId: profile.id),
            allLessons: lessons,
            pathRecommendations: [
                LessonRecommendation(
                    kind: .continueLearning,
                    lesson: otherCounting,
                    reason: "Another counting quest",
                    score: 200
                )
            ],
            lastCompletedSubject: .math
        )

        let feed = HomeFeedBuilder.build(context: context)
        let next = try XCTUnwrap(feed.continueLearning?.lesson)
        XCTAssertNotEqual(next.id, finished.id)
        XCTAssertNotEqual(next.primarySubject, .math)
        XCTAssertTrue(
            next.primarySubject == .reading
                || next.primarySubject == .science
                || next.primarySubject == .creative
        )

        let recommended = HomeFeedBuilder.recommendedLessons(context: context, excluding: [], count: 2)
        XCTAssertEqual(recommended.count, 2)
        XCTAssertFalse(recommended.contains { $0.lesson.primarySubject == .math })
        XCTAssertNotEqual(recommended[0].lesson.primarySubject, recommended[1].lesson.primarySubject)
    }

    func testHomeStillOffersCountingWhenNothingElseIsLeft() throws {
        let counting = [Topic.sharks, .space].compactMap {
            LevelSpecificContentFactory.makeApprovedLesson(
                topic: $0,
                category: .math,
                readingLevel: .earlyReader,
                mathLevel: .emerging
            )
        }
        XCTAssertEqual(counting.count, 2)
        let profile = ChildProfile(
            nickname: "Mia",
            age: 6,
            readingLevel: .earlyReader,
            mathLevel: .emerging,
            favoriteTopics: [.sharks, .space],
            hasCompletedOnboarding: true
        )
        let feed = HomeFeedBuilder.build(
            context: .init(
                profile: profile,
                activity: .empty,
                completedLessonIDs: [counting[0].id],
                learningState: .empty(childId: profile.id),
                allLessons: counting,
                pathRecommendations: [],
                lastCompletedSubject: .math
            )
        )
        let next = try XCTUnwrap(feed.continueLearning?.lesson)
        XCTAssertEqual(next.primarySubject, .math)
        XCTAssertNotEqual(next.id, counting[0].id)
    }

    func testLegacyLessonsStillDecode() throws {
        for name in ["sharks", "horses", "space", "dinosaurs"] {
            let url = Bundle.main.url(forResource: name, withExtension: "json")
                ?? Bundle(for: MarbleCurriculumTests.self).url(forResource: name, withExtension: "json")
            guard let url else {
                throw XCTSkip("JSON lesson \(name) unavailable in test bundle")
            }
            let data = try Data(contentsOf: url)
            let lesson = try JSONDecoder().decode(Lesson.self, from: data)
            XCTAssertFalse(lesson.title.isEmpty)
            _ = lesson.primaryTopicId
        }
    }
}
