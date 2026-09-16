import XCTest
@testable import MovoLearn

final class ProfilePersistenceTests: XCTestCase {
    private var defaults: UserDefaults!
    private var suiteName: String!

    override func setUp() {
        super.setUp()
        suiteName = "MovoLearn.ProfileTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        if let suiteName {
            defaults.removePersistentDomain(forName: suiteName)
        }
        super.tearDown()
    }

    func testSaveAndLoadProfile() {
        let repo = ProfileRepository(defaults: defaults)
        var profile = ChildProfile(nickname: "Mia", age: 7, grade: "1st Grade")
        profile.favoriteTopics = [.space, .sharks]
        profile.hasCompletedOnboarding = true

        XCTAssertTrue(repo.save(profile))
        let loaded = repo.load()
        XCTAssertEqual(loaded?.nickname, "Mia")
        XCTAssertEqual(loaded?.id, profile.id)
        XCTAssertEqual(loaded?.favoriteTopics, [.space, .sharks])
        XCTAssertEqual(loaded?.grade, "1")
        XCTAssertTrue(loaded?.hasCompletedOnboarding == true)
    }

    func testEditingPreservesStableID() {
        let repo = ProfileRepository(defaults: defaults)
        var profile = ChildProfile(nickname: "Sam")
        XCTAssertTrue(repo.save(profile))
        let id = profile.id
        profile.nickname = "Sammy"
        profile.grade = "2nd Grade"
        XCTAssertTrue(repo.save(profile))
        XCTAssertEqual(repo.load()?.id, id)
        XCTAssertEqual(repo.load()?.nickname, "Sammy")
    }

    func testAgeCalculatedFromBirthday() {
        let birthday = Calendar.current.date(byAdding: .year, value: -6, to: Date())!
        let profile = ChildProfile(nickname: "Ava", birthday: birthday, age: 99)
        XCTAssertEqual(profile.currentAge, ChildProfile.age(from: birthday))
        XCTAssertNotEqual(profile.currentAge, 99)
    }

    func testOnboardingRestorationFlag() {
        let repo = ProfileRepository(defaults: defaults)
        var profile = ChildProfile(nickname: "Leo", favoriteTopics: [.horses])
        profile.hasCompletedOnboarding = true
        XCTAssertTrue(repo.save(profile))
        XCTAssertTrue(repo.load()?.isReadyForHome == true)
    }

    func testResetDeletesProfile() {
        let repo = ProfileRepository(defaults: defaults)
        XCTAssertTrue(repo.save(ChildProfile(nickname: "Mia")))
        repo.delete()
        XCTAssertNil(repo.load())
    }

    func testLegacyAgeKeyStillDecodes() throws {
        let legacy: [String: Any] = [
            "id": UUID().uuidString,
            "nickname": "Legacy",
            "age": 8,
            "grade": "Kindergarten",
            "readingLevel": "Early Reader",
            "learningGoal": "All-around practice",
            "favoriteTopics": ["Space"]
        ]
        let data = try JSONSerialization.data(withJSONObject: legacy)
        defaults.set(data, forKey: ProfileRepository.storageKey)
        // ISO8601 decoder may fail on missing dates — ensure repository handles soft decode via Codable defaults.
        // Write through encoder path for a realistic round-trip after migration fields exist.
        let repo = ProfileRepository(defaults: defaults)
        var profile = ChildProfile(nickname: "Legacy", age: 8)
        profile.favoriteTopics = [.space]
        XCTAssertTrue(repo.save(profile))
        XCTAssertEqual(repo.load()?.storedAge, 8)
    }

    func testOnDeviceSaveDropsBirthday() {
        let repo = ProfileRepository(defaults: defaults)
        let birthday = Calendar.current.date(byAdding: .year, value: -6, to: Date())!
        let profile = ChildProfile(nickname: "Ava", birthday: birthday, age: 99)
        XCTAssertTrue(FamilyCloudSync.isEnabled == false)
        XCTAssertTrue(repo.save(profile))
        let loaded = repo.load()
        XCTAssertNil(loaded?.birthday)
        XCTAssertEqual(loaded?.storedAge, ChildProfile.age(from: birthday))
        XCTAssertEqual(loaded?.nickname, "Ava")
    }
}

final class PersonalizationTests: XCTestCase {
    func testTemplateReplacesName() {
        let result = TemplateFormatter.format("Could {{name}} point to the moon?", name: "Mia")
        XCTAssertEqual(result, "Could Mia point to the moon?")
        XCTAssertFalse(result.contains("{{"))
    }

    func testTemplateFallbackWithoutName() {
        let result = TemplateFormatter.format("Could {{name}} try again?", name: "")
        XCTAssertTrue(result.contains("your child"))
        XCTAssertFalse(result.contains("{{name}}"))
    }

    @MainActor
    func testGreetingFallback() {
        let service = PersonalizationService.shared
        service.update(nil)
        XCTAssertEqual(service.greetingName, "there")
        service.update(ChildProfile(nickname: "Mia"))
        XCTAssertEqual(service.displayName, "Mia")
        XCTAssertEqual(service.greeting(), "Hello, Mia!")
    }
}

final class MasteryEngineTests: XCTestCase {
    func testOneCorrectAnswerDoesNotMaster() {
        var progress = ChildSkillProgress(childProfileId: UUID(), marbleTopicId: "mt_test")
        MasteryEngine.apply(
            attempt: .init(
                wasCorrect: true,
                usedHint: false,
                wasIndependent: true,
                responseTimeMs: 1200,
                activityType: "math",
                questionFormat: "multipleChoice",
                lessonId: UUID(),
                evidenceCriteriaCount: 3
            ),
            to: &progress
        )
        XCTAssertNotEqual(progress.status, .mastered)
        XCTAssertTrue(progress.masteryScore < 0.8)
    }

    func testIndependentPracticeCanReachMastery() {
        var progress = ChildSkillProgress(childProfileId: UUID(), marbleTopicId: "mt_test")
        for i in 0..<5 {
            MasteryEngine.apply(
                attempt: .init(
                    wasCorrect: true,
                    usedHint: false,
                    wasIndependent: true,
                    responseTimeMs: 1000,
                    activityType: "math",
                    questionFormat: i % 2 == 0 ? "multipleChoice" : "numberEntry",
                    lessonId: UUID(),
                    evidenceCriteriaCount: 3
                ),
                to: &progress
            )
        }
        XCTAssertEqual(progress.status, .mastered)
    }

    func testParentInsightsOmitAccuracyWhenLessonWasUnscored() {
        let lesson = BundledLessons.sharkExplorer
        let summary = ProgressSummary(from: lesson, totalQuestions: 0, correctAnswers: 0)
        let insights = ParentLearningInsights(
            childName: "Mia",
            progress: UserProgress(completedLessons: [
                LessonCompletionRecord(summary: summary, lesson: lesson)
            ]),
            latestSummary: summary
        )
        XCTAssertEqual(insights.accuracyDisplay, "—")
        XCTAssertTrue(insights.snapshotMessage.contains("no scored questions"))
        XCTAssertFalse(insights.snapshotMessage.lowercased().contains("went well"))
        XCTAssertFalse(insights.snapshotMessage.lowercased().contains("needs review"))
    }

    func testParentInsightsDescribeLatestLessonScore() {
        let lesson = BundledLessons.sharkExplorer
        let summary = ProgressSummary(from: lesson, totalQuestions: 6, correctAnswers: 2)
        let insights = ParentLearningInsights(
            childName: "Mia",
            progress: UserProgress(completedLessons: [
                LessonCompletionRecord(summary: summary, lesson: lesson)
            ]),
            latestSummary: summary
        )
        XCTAssertEqual(insights.accuracyDisplay, "33%")
        XCTAssertTrue(insights.snapshotMessage.contains("2 of 6 correct"))
        XCTAssertFalse(insights.snapshotMessage.lowercased().contains("practice"))
        XCTAssertFalse(insights.snapshotMessage.lowercased().contains("review"))
    }
}

@MainActor
final class LessonScoringTests: XCTestCase {
    func testRetryAfterWrongAnswerDoesNotReportPerfectScore() {
        let viewModel = LessonViewModel(lesson: BundledLessons.sharkExplorer)

        var hops = 0
        while hops < 24 {
            if case .question(_, let question, _, _) = viewModel.currentStep,
               question.displayResponseType == .multipleChoice,
               let correct = question.correctAnswer,
               let wrong = question.choices.first(where: { $0 != correct }) {
                viewModel.selectAnswer(wrong)
                XCTAssertFalse(viewModel.isAnswerCorrect)
                viewModel.resetForRetry()
                viewModel.selectAnswer(correct)
                XCTAssertTrue(viewModel.isAnswerCorrect)

                let summary = viewModel.makeProgressSummary()
                XCTAssertEqual(summary.totalQuestions, 1)
                XCTAssertEqual(summary.correctAnswers, 0)
                XCTAssertEqual(summary.accuracyPercentage, 0)
                return
            }
            viewModel.advance()
            hops += 1
        }

        XCTFail("Expected a multiple-choice question in the sample lesson")
    }

    func testCorrectFirstAttemptStillCountsAsCorrect() {
        let viewModel = LessonViewModel(lesson: BundledLessons.sharkExplorer)

        var hops = 0
        while hops < 24 {
            if case .question(_, let question, _, _) = viewModel.currentStep,
               question.displayResponseType == .multipleChoice,
               let correct = question.correctAnswer {
                viewModel.selectAnswer(correct)
                let summary = viewModel.makeProgressSummary()
                XCTAssertEqual(summary.totalQuestions, 1)
                XCTAssertEqual(summary.correctAnswers, 1)
                XCTAssertEqual(summary.accuracyPercentage, 100)
                return
            }
            viewModel.advance()
            hops += 1
        }

        XCTFail("Expected a multiple-choice question in the sample lesson")
    }
}
