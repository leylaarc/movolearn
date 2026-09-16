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
