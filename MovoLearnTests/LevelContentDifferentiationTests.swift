import XCTest
@testable import MovoLearn

final class LevelContentDifferentiationTests: XCTestCase {

    func testYoungBeginnerReadingAndMathProduceBeginnerContent() {
        let profile = ChildProfile(
            age: 5,
            grade: "Kindergarten",
            readingLevel: .beginner,
            mathLevel: .emerging,
            favoriteTopics: [.sharks, .horses, .space]
        )
        let lessons = ContentLibrarySelector.selectDailyOptions(for: profile).lessons
        XCTAssertFalse(lessons.isEmpty, "Approved beginner content should exist")
        for lesson in lessons {
            XCTAssertEqual(lesson.readingLevel, .beginner)
            if lesson.primarySubject == .math {
                XCTAssertEqual(lesson.mathLevel, .emerging)
            }
            XCTAssertTrue(lesson.isApprovedForChildDisplay)
            XCTAssertFalse(lesson.learningObjectives.isEmpty && lesson.readingSkill.isEmpty)
        }
    }

    func testOlderChildCanHaveBeginnerReadingWithHigherMath() {
        let profile = ChildProfile(
            age: 8,
            grade: "2nd Grade",
            readingLevel: .beginner,
            mathLevel: .secure,
            favoriteTopics: [.sharks, .dinosaurs, .space]
        )
        let ability = LessonDifficultyRules.abilityProfile(for: profile)
        XCTAssertEqual(ability.readingLevel, .beginner, "Age must not override beginner reading")
        XCTAssertEqual(ability.mathLevel, .secure)

        let reading = ApprovedContentLibrary.exactMatches(
            readingLevel: .beginner,
            mathLevel: .secure,
            topics: profile.favoriteTopics,
            category: .story
        )
        let math = ApprovedContentLibrary.exactMatches(
            readingLevel: .beginner,
            mathLevel: .secure,
            topics: profile.favoriteTopics,
            category: .math
        )
        XCTAssertFalse(reading.isEmpty)
        XCTAssertFalse(math.isEmpty)
        XCTAssertNotEqual(reading.first?.readingPassage, math.first?.readingPassage)
        XCTAssertTrue(math.first?.mathSkill.localizedCaseInsensitiveContains("place") == true
            || math.first?.mathSkill.localizedCaseInsensitiveContains("multi") == true
            || math.first?.mathChallenges.contains(where: { $0.prompt.contains("24") || $0.prompt.contains("rows") }) == true)
    }

    func testYoungAdvancedReadingAndMathDifferFromBeginner() {
        let beginner = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .sharks,
            category: .story,
            readingLevel: .beginner,
            mathLevel: .emerging
        )
        let advanced = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .sharks,
            category: .story,
            readingLevel: .confidentReader,
            mathLevel: .advancing
        )
        XCTAssertNotNil(beginner)
        XCTAssertNotNil(advanced)
        XCTAssertNotEqual(beginner?.readingPassage, advanced?.readingPassage)
        XCTAssertNotEqual(beginner?.readingSkill, advanced?.readingSkill)
        XCTAssertTrue((advanced?.readingPassage.count ?? 0) > (beginner?.readingPassage.count ?? 0))
    }

    func testSameAgeDifferentLevelsGetDifferentContent() {
        let a = ChildProfile(age: 7, readingLevel: .earlyReader, mathLevel: .developing, favoriteTopics: [.horses, .space, .sharks])
        let b = ChildProfile(age: 7, readingLevel: .confidentReader, mathLevel: .advancing, favoriteTopics: [.horses, .space, .sharks])
        let lessonsA = ContentLibrarySelector.selectDailyOptions(for: a).lessons
        let lessonsB = ContentLibrarySelector.selectDailyOptions(for: b).lessons
        XCTAssertFalse(lessonsA.isEmpty)
        XCTAssertFalse(lessonsB.isEmpty)
        let titlesA = Set(lessonsA.map(\.title))
        let titlesB = Set(lessonsB.map(\.title))
        XCTAssertTrue(titlesA.isDisjoint(with: titlesB) || lessonsA.map(\.readingPassage) != lessonsB.map(\.readingPassage))
    }

    func testReadingAndMathOperateIndependently() {
        let readingLowMathHigh = ApprovedContentLibrary.exactMatches(
            readingLevel: .beginner,
            mathLevel: .advancing,
            topics: [.sharks, .space],
            category: .math
        )
        let readingHighMathLow = ApprovedContentLibrary.exactMatches(
            readingLevel: .confidentReader,
            mathLevel: .emerging,
            topics: [.sharks, .space],
            category: .story
        )
        XCTAssertFalse(readingLowMathHigh.isEmpty, "Expected beginner-reading + advancing-math lessons")
        XCTAssertFalse(readingHighMathLow.isEmpty, "Expected confident-reading + emerging-math lessons")
        XCTAssertEqual(readingLowMathHigh.first?.mathLevel, .advancing)
        XCTAssertEqual(readingHighMathLow.first?.readingLevel, .confidentReader)
        XCTAssertEqual(readingHighMathLow.first?.mathLevel, .emerging)
    }

    func testProfileLevelChangeInvalidatesOldSelection() {
        let before = ChildProfile(age: 6, readingLevel: .earlyReader, mathLevel: .developing, favoriteTopics: [.sharks, .horses, .space])
        let after = ChildProfile(id: before.id, age: 6, readingLevel: .confidentReader, mathLevel: .emerging, favoriteTopics: before.favoriteTopics)
        let changed = ProfileContentInvalidator.invalidateIfAcademicSettingsChanged(from: before, to: after)
        XCTAssertTrue(changed)
        let options = ContentLibrarySelector.selectDailyOptions(for: after).lessons
        XCTAssertTrue(options.allSatisfy { $0.readingLevel == .confidentReader })
        XCTAssertFalse(options.contains { $0.readingLevel == .earlyReader && $0.mathLevel == .developing })
    }

    func testFailedContentCannotBeApproved() {
        let bad = Lesson(
            id: UUID(),
            title: "Broken Math",
            theme: .horses,
            lessonType: .builder,
            category: .math,
            primarySubject: .math,
            storyOpening: "Ready for a horses challenge?",
            missionPrompt: "",
            readingPassage: "Sam counts horses carefully in the yard.",
            questions: [],
            mathChallenges: [
                LessonQuestion(
                    subject: .math,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "Sam sees 2 horses and 2 more. How many horses in all?",
                    choices: ["3", "3", "4"],
                    correctAnswer: "5",
                    explanation: ""
                )
            ],
            vocabularyWords: [
                VocabularyWord(word: "total", definition: "How many altogether.", exampleSentence: "Find the total.")
            ],
            knowledgeFacts: [
                KnowledgeFact(fact: "Math problems need every number stated in the story.")
            ],
            creativePrompt: "Draw one idea from the lesson.",
            creativeResponseType: .drawing,
            storyEnding: "You finished today's horse math practice.",
            readingLevel: .earlyReader,
            mathLevel: .developing,
            readingSkill: "Reading",
            mathSkill: "Addition",
            reflectionPrompt: "Which problem made you think?",
            skillsPracticed: ["Math"],
            contentApprovalStatus: .pendingValidation
        )
        let gate = AutomatedContentQualityGate.validate(
            lesson: bad,
            profile: ChildProfile(readingLevel: .earlyReader, mathLevel: .developing)
        )
        XCTAssertFalse(gate.passed, gate.summary)
        XCTAssertEqual(gate.approvalStatus, .unavailable)
    }

    func testMathAnswersAreProgrammaticallyValidated() {
        let good = LessonQuestion(
            subject: .math,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "Sam finds 6 cards. Then Sam finds 3 more. How many cards in all?",
            choices: ["8", "9", "10"],
            correctAnswer: "9",
            explanation: "6 + 3 = 9."
        )
        let bad = LessonQuestion(
            subject: .math,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "Sam finds 6 cards. Then Sam finds 3 more. How many cards in all?",
            choices: ["8", "9", "10"],
            correctAnswer: "10",
            explanation: "Wrong on purpose."
        )
        XCTAssertTrue(MathProblemValidator.validate(good, mathLevel: .developing).passed)
        XCTAssertFalse(MathProblemValidator.validate(bad, mathLevel: .developing).passed)
    }

    func testMockProvidersWorkWithoutCredentials() {
        XCTAssertFalse(MockCASEStandardsProvider.shared.isLiveCASEIntegration)
        XCTAssertTrue(MockCASEStandardsProvider.shared.loadIfNeeded())
        XCTAssertFalse(MockCASEStandardsProvider.shared.skills(subject: "Reading", grade: "1").isEmpty)

        let measurement = MockReadabilityProvider().measure(
            passage: "Sam sees a shark. The shark is big.",
            intendedReadingLevel: .beginner
        )
        XCTAssertFalse(measurement.isLicensedLexile)
        XCTAssertEqual(LicensedLexileProvider().isLicensedLexile, false)

        let progression = MockQuantileAlignedProgression()
        XCTAssertFalse(progression.isLicensedQuantile)
        XCTAssertFalse(progression.orderedSkills(for: .developing, grade: "1").isEmpty)
    }

    func testHomeSliceIsAvailableWithoutBuildingFullCatalog() {
        let slice = ApprovedContentLibrary.ensureHomeSlice(
            topics: [.sharks, .horses, .space],
            readingLevel: .beginner,
            mathLevel: .emerging
        )
        XCTAssertFalse(slice.isEmpty, "Home should seed the child's interests without the full matrix")
        XCTAssertTrue(slice.contains { $0.theme == .sharks && $0.readingLevel == .beginner })
    }

    func testEveryApprovedLessonHasLearningObjective() {
        let sample = ApprovedContentLibrary.ensureHomeSlice(
            topics: [.sharks, .horses, .space],
            readingLevel: .beginner,
            mathLevel: .emerging
        )
        XCTAssertFalse(sample.isEmpty)
        for lesson in sample {
            let hasObjective = !lesson.learningObjectives.isEmpty
                || !lesson.readingSkill.isEmpty
                || !lesson.mathSkill.isEmpty
            XCTAssertTrue(hasObjective, lesson.title)
            XCTAssertEqual(lesson.contentApprovalStatus, .approved)
        }
    }

    func testCurriculumBandFollowsAgeNotGrade() {
        XCTAssertEqual(AgeGradeLearningStandards.band(age: 6, grade: "2nd Grade"), .kindergarten)
        XCTAssertEqual(AgeGradeLearningStandards.band(age: 7, grade: "Kindergarten"), .grade1)
        XCTAssertEqual(AgeGradeLearningStandards.suggestedGrade(forAge: 6), "K")
        XCTAssertEqual(AgeGradeLearningStandards.curriculumKey(forAge: 5), "K")
        XCTAssertEqual(AgeGradeLearningStandards.curriculumKey(forAge: 7), "1")
        XCTAssertEqual(AgeGradeLearningStandards.curriculumKey(forAge: 8), "2")
        XCTAssertEqual(AgeGradeLearningStandards.band(age: 6).displayName, "Ages 5–6")
        XCTAssertEqual(AgeGradeLearningStandards.mathOperandUpperBound(forAge: 6), 10)
        XCTAssertFalse(AgeGradeLearningStandards.allowsMultiplicativeMath(forAge: 6))
        XCTAssertEqual(AgeGradeLearningStandards.cappedMathLevel(.advancing, age: 6), .developing)
    }

    func testProfileGradeAlwaysFollowsAgeNotSchoolLabels() {
        var profile = ChildProfile(age: 6, grade: "3rd Grade")
        XCTAssertEqual(profile.grade, "K")
        profile.grade = "2nd Grade"
        XCTAssertEqual(profile.grade, "K")
        profile.storedAge = 8
        XCTAssertEqual(profile.grade, "2")
        XCTAssertEqual(AgeGradeLearningStandards.band(age: profile.currentAge).displayName, "Ages 7–8")
    }

    func testCurriculumMapReadingSkillsFollowAgeKey() {
        let six = MockCASEStandardsProvider.shared.skills(
            subject: "Reading",
            grade: AgeGradeLearningStandards.curriculumKey(forAge: 6)
        )
        XCTAssertFalse(six.isEmpty)
        XCTAssertTrue(
            six.contains { $0.educationLevels.contains { $0.localizedCaseInsensitiveContains("K") } },
            "Age 6 should load K curriculum-map skills. Got: \(six.map(\.humanCodingScheme))"
        )
        let nine = MockCASEStandardsProvider.shared.skills(
            subject: "Reading",
            grade: AgeGradeLearningStandards.curriculumKey(forAge: 9)
        )
        XCTAssertTrue(
            nine.contains { $0.educationLevels.contains(where: { $0.contains("3") }) },
            "Age 9 should load band-3 curriculum-map skills. Got: \(nine.map(\.humanCodingScheme))"
        )
    }

    func testSixYearOldKeepsKindergartenCeilingIfLevelsAreRaised() {
        let expectations = AgeGradeLearningStandards.expectations(
            age: 6,
            grade: "2nd Grade",
            readingLevel: .confidentReader,
            mathLevel: .advancing
        )
        XCTAssertEqual(expectations.band, .kindergarten)
        XCTAssertEqual(expectations.maxPassageSentences, 4)
        XCTAssertEqual(expectations.maxWordsPerSentence, 10)
        XCTAssertFalse(expectations.allowInference)
        XCTAssertFalse(expectations.allowMultiStepMath)
        XCTAssertFalse(expectations.allowAdvancedScienceTerms)
        XCTAssertTrue(expectations.mathFocus.contains(where: { $0.localizedCaseInsensitiveContains("within 10") }))
    }

    func testSixYearOldMathSessionStaysWithinTen() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses,
            category: .math,
            readingLevel: .earlyReader,
            mathLevel: .advancing,
            age: 6,
            grade: "Kindergarten"
        ) else {
            return XCTFail("Expected an approved horses math lesson")
        }
        let profile = ChildProfile(
            age: 6,
            grade: "2nd Grade",
            readingLevel: .earlyReader,
            mathLevel: .advancing,
            favoriteTopics: [.horses]
        )
        let prepared = ContentAdaptationService.prepare(lesson: lesson, profile: profile)
        XCTAssertFalse(prepared.lesson.mathChallenges.isEmpty)
        let cap = AgeGradeLearningStandards.mathOperandUpperBound(forAge: 6)
        for question in prepared.lesson.mathChallenges {
            let numbers = MathProblemValidator.extractIntegers(from: question.prompt)
            XCTAssertFalse(numbers.contains { $0 > cap }, question.prompt)
            XCTAssertFalse(
                question.prompt.lowercased().contains("groups of")
                    || question.prompt.contains("×"),
                question.prompt
            )
        }
    }

    func testAgeBasedCurriculumDefaultsSyncGradeAndLevels() {
        var profile = ChildProfile(age: 8, readingLevel: .beginner, mathLevel: .emerging)
        profile.applyAgeBasedCurriculumDefaults()
        XCTAssertEqual(profile.grade, "2")
        XCTAssertEqual(profile.readingLevel, .confidentReader)
        XCTAssertEqual(profile.mathLevel, .advancing)
        XCTAssertEqual(AgeGradeLearningStandards.band(age: 8).displayName, "Ages 7–8")
    }
}
