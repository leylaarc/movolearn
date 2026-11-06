import XCTest
@testable import MovoLearn

final class ContentQualityCoherenceTests: XCTestCase {

    func testDidYouKnowDropsAFactThatOnlyRepeatsTheScienceNote() {
        let fact = "Farm animals need food, water, and shelter every day."
        let kept = LessonContentCoherenceValidator.nonRepeatingFacts(
            [
                KnowledgeFact(fact: fact, explanation: fact)
            ],
            passage: "Science note: \(fact)",
            vocabulary: []
        )
        XCTAssertTrue(kept.isEmpty)
    }

    func testBarnMorningDrawingDoesNotRepeatItsCareFact() throws {
        let lesson = try XCTUnwrap(LevelSpecificContentFactory.makeApprovedLesson(
            topic: .farmAnimals,
            category: .creative,
            readingLevel: .beginner,
            mathLevel: .emerging
        ))
        let sentence = "farm animals need food, water, and shelter every day"
        let alreadySaid = [
            lesson.storyOpening,
            lesson.readingPassage,
            lesson.creativePrompt
        ].joined(separator: " ").lowercased()
        let repeatedOnCard = lesson.knowledgeFacts.contains { fact in
            let card = (fact.fact + " " + fact.childFacingExplanation).lowercased()
            return card.contains(sentence) && alreadySaid.contains(sentence)
        }
        XCTAssertFalse(repeatedOnCard)
    }

    func testDidYouKnowDropsAFactThatOnlyRepeatsTheStory() {
        let passage = "A habitat is a home for living things. A frog needs a wet stream."
        let kept = LessonContentCoherenceValidator.nonRepeatingFacts(
            [
                KnowledgeFact(
                    fact: "A habitat is a home for living things.",
                    explanation: "A habitat is a home for living things."
                ),
                KnowledgeFact(
                    fact: "A frog's skin dries out without water nearby.",
                    explanation: "That is why a frog stays near water."
                )
            ],
            passage: passage,
            vocabulary: [
                VocabularyWord(word: "habitat", definition: "A home for living things.")
            ]
        )
        XCTAssertEqual(kept.count, 1)
        XCTAssertTrue(kept[0].fact.localizedCaseInsensitiveContains("skin"))
    }

    func testAcademicSkillTitlesAreBlocked() {
        XCTAssertTrue(LessonContentCoherenceValidator.hasAcademicSkillTitle("Horses: Main idea and sequencing"))
        XCTAssertTrue(LessonContentCoherenceValidator.hasAcademicSkillTitle("Horses and Sequencing"))
        XCTAssertTrue(LessonContentCoherenceValidator.hasAcademicSkillTitle("Discover Horses: Main idea and sequencing"))
        XCTAssertTrue(LessonContentCoherenceValidator.hasAcademicSkillTitle("Jungle Animals Math: Addition and subtraction"))
        XCTAssertFalse(LessonContentCoherenceValidator.hasAcademicSkillTitle("Get the Pony Ready"))
        XCTAssertFalse(LessonContentCoherenceValidator.hasAcademicSkillTitle("Who Lives in the Trees?"))
        XCTAssertFalse(LessonContentCoherenceValidator.hasAcademicSkillTitle("Reading a Horse's Ears"))
    }

    func testKindergartenHorseAndJungleAreDistinct() {
        let horse = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses,
            category: .story,
            readingLevel: .beginner,
            mathLevel: .emerging
        )
        let jungle = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .jungleAnimals,
            category: .story,
            readingLevel: .beginner,
            mathLevel: .emerging
        )
        guard let horse, let jungle else {
            return XCTFail("Kindergarten horse/jungle lessons must approve. horse=\(String(describing: horse?.title)) jungle=\(String(describing: jungle?.title))")
        }
        XCTAssertEqual(horse.title, "Get the Pony Ready")
        XCTAssertEqual(jungle.title, "Who Lives in the Trees?")
        XCTAssertNotEqual(horse.readingPassage, jungle.readingPassage)
        XCTAssertNotEqual(horse.questions.map(\.prompt), jungle.questions.map(\.prompt))
        XCTAssertTrue(horse.readingPassage.localizedCaseInsensitiveContains("pony")
            || horse.readingPassage.localizedCaseInsensitiveContains("stall")
            || horse.readingPassage.localizedCaseInsensitiveContains("Sunny"))
        XCTAssertTrue(jungle.readingPassage.localizedCaseInsensitiveContains("canopy")
            || jungle.readingPassage.localizedCaseInsensitiveContains("toucan"))
        XCTAssertFalse(horse.title.contains(":"))
        XCTAssertFalse(jungle.title.contains("Sequencing"))
    }

    func testAdvancedHorseAndJungleAreDistinctAndHarder() {
        let horseK = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses, category: .story, readingLevel: .beginner, mathLevel: .emerging
        )
        let horseAdv = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses, category: .story, readingLevel: .confidentReader, mathLevel: .secure
        )
        let jungleAdv = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .jungleAnimals, category: .story, readingLevel: .confidentReader, mathLevel: .secure
        )
        XCTAssertNotNil(horseAdv)
        XCTAssertNotNil(jungleAdv)
        XCTAssertEqual(horseAdv?.title, "Reading a Horse's Ears")
        XCTAssertEqual(jungleAdv?.title, "Layers of the Rainforest")
        XCTAssertNotEqual(horseAdv?.title, jungleAdv?.title)
        XCTAssertNotEqual(horseAdv?.readingPassage, jungleAdv?.readingPassage)
        XCTAssertGreaterThan(horseAdv?.readingPassage.count ?? 0, horseK?.readingPassage.count ?? 0)
        XCTAssertTrue(horseAdv?.readingPassage.localizedCaseInsensitiveContains("ears") == true)
        XCTAssertTrue(jungleAdv?.readingPassage.localizedCaseInsensitiveContains("canopy") == true)
    }

    func testUnsupportedPredictionQuestionIsBlocked() {
        let base = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses, category: .story, readingLevel: .beginner, mathLevel: .emerging
        )!
        let badQuestion = LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "What did Sam predict about the pony?",
            choices: ["It would return", "It would fly", "It would sing"],
            correctAnswer: "It would return",
            explanation: "Unsupported on purpose."
        )
        let lesson = Lesson(
            id: base.id,
            title: base.title,
            theme: base.theme,
            lessonType: base.lessonType,
            category: base.category,
            primarySubject: base.primarySubject,
            storyOpening: base.storyOpening,
            missionPrompt: base.missionPrompt,
            readingPassage: base.readingPassage,
            questions: base.questions + [badQuestion],
            mathChallenges: base.mathChallenges,
            vocabularyWords: base.vocabularyWords,
            knowledgeFacts: base.knowledgeFacts,
            creativePrompt: base.creativePrompt,
            creativeResponseType: base.creativeResponseType,
            storyEnding: base.storyEnding,
            ageTarget: base.ageTarget,
            gradeTarget: base.gradeTarget,
            readingLevel: base.readingLevel,
            mathLevel: base.mathLevel,
            learningGoal: base.learningGoal,
            readingSkill: base.readingSkill,
            mathSkill: base.mathSkill,
            reflectionPrompt: base.reflectionPrompt,
            skillsPracticed: base.skillsPracticed,
            contentApprovalStatus: base.contentApprovalStatus,
            learningObjectives: base.learningObjectives
        )
        let result = LessonContentCoherenceValidator.validate(lesson)
        XCTAssertFalse(result.passed, result.summary)
        XCTAssertTrue(result.issues.contains { $0.code == "unsupported_question" })
    }

    func testReviewExemplarsExistAndPassGates() {
        let exemplars = CuratedTopicLessonBank.reviewExemplars()
        XCTAssertEqual(exemplars.count, 4)
        let titles = exemplars.map(\.title)
        XCTAssertTrue(titles.contains("Get the Pony Ready"))
        XCTAssertTrue(titles.contains("Who Lives in the Trees?"))
        XCTAssertTrue(titles.contains("Reading a Horse's Ears"))
        XCTAssertTrue(titles.contains("Layers of the Rainforest"))
        for lesson in exemplars {
            XCTAssertEqual(lesson.contentApprovalStatus, .approved)
            XCTAssertTrue(LessonContentCoherenceValidator.validate(lesson).passed, lesson.title)
            XCTAssertFalse(LessonContentCoherenceValidator.hasAcademicSkillTitle(lesson.title), lesson.title)
        }
    }

    func testNoFactoryLessonUsesTopicColonSkillTitle() {
        for topic in [Topic.horses, .jungleAnimals, .sharks, .space, .dinosaurs] {
            for reading in ReadingLevel.allCases {
                guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                    topic: topic,
                    category: .story,
                    readingLevel: reading,
                    mathLevel: .emerging
                ) else {
                    XCTFail("Missing curated story for \(topic.rawValue) \(reading.rawValue)")
                    continue
                }
                XCTAssertFalse(
                    LessonContentCoherenceValidator.hasAcademicSkillTitle(lesson.title),
                    lesson.title
                )
            }
        }
    }

    func testEveryTopicHasCuratedStoryAndMath() {
        for topic in Topic.allCases {
            let story = LevelSpecificContentFactory.makeApprovedLesson(
                topic: topic,
                category: .story,
                readingLevel: .earlyReader,
                mathLevel: .developing
            )
            let math = LevelSpecificContentFactory.makeApprovedLesson(
                topic: topic,
                category: .math,
                readingLevel: .earlyReader,
                mathLevel: .developing
            )
            XCTAssertNotNil(story, "Missing story pack for \(topic.rawValue)")
            XCTAssertNotNil(math, "Missing math pack for \(topic.rawValue)")
            if let story {
                XCTAssertEqual(story.theme, topic)
                XCTAssertFalse(LessonContentCoherenceValidator.hasAcademicSkillTitle(story.title), story.title)
            }
            if let math {
                XCTAssertEqual(math.theme, topic)
            }
        }
    }

    func testLegacyJungleReplacementNeverSwapsToHorses() {
        let profile = ChildProfile(
            age: 7,
            readingLevel: .confidentReader,
            mathLevel: .advancing,
            favoriteTopics: [.jungleAnimals, .horses, .space]
        )
        let legacyJungle = BundledLessonsExtended.canopyClassroom
        XCTAssertEqual(legacyJungle.theme, .jungleAnimals)
        XCTAssertEqual(legacyJungle.contentApprovalStatus, .legacyBundled)

        let replacement = ContentLibrarySelector.replacement(for: legacyJungle, profile: profile)
        XCTAssertNotNil(replacement, "Jungle must have an approved same-topic replacement")
        XCTAssertEqual(replacement?.theme, .jungleAnimals)
        XCTAssertNotEqual(replacement?.theme, .horses)
        XCTAssertFalse(
            replacement?.readingPassage.localizedCaseInsensitiveContains("pony") == true
                && replacement?.readingPassage.localizedCaseInsensitiveContains("canopy") != true,
            "Replacement must stay jungle-themed: \(replacement?.title ?? "nil")"
        )
    }

    func testPreferredLessonPreservesRequestedTopic() {
        let profile = ChildProfile(
            age: 6,
            readingLevel: .earlyReader,
            mathLevel: .developing,
            favoriteTopics: [.horses, .jungleAnimals, .dinosaurs]
        )
        for topic in [Topic.jungleAnimals, .horses, .dinosaurs, .cars, .cooking] {
            let lesson = ContentLibrarySelector.preferredLesson(for: topic, profile: profile)
            XCTAssertNotNil(lesson, "Expected preferred lesson for \(topic.rawValue)")
            XCTAssertEqual(lesson?.theme, topic, "Preferred lesson theme mismatch for \(topic.rawValue)")
        }
    }

    func testNatureSubjectDoesNotMixHorsesOrOcean() {
        let nature = ExploreSubjectCategory.nature.topics
        XCTAssertTrue(nature.contains(.jungleAnimals))
        XCTAssertTrue(nature.contains(.nature))
        XCTAssertFalse(nature.contains(.horses))
        XCTAssertFalse(nature.contains(.dogs))
        XCTAssertFalse(nature.contains(.cats))
        XCTAssertFalse(nature.contains(.sharks))
        XCTAssertFalse(nature.contains(.oceanAnimals))
        XCTAssertTrue(ExploreSubjectCategory.science.topics.contains(.sharks))
        XCTAssertTrue(ExploreSubjectCategory.lifeSkills.topics.contains(.horses))
    }

    func testCatalogBrowseKeepsTopicFidelity() {
        let profile = ChildProfile(
            age: 7,
            readingLevel: .earlyReader,
            mathLevel: .developing,
            favoriteTopics: [.jungleAnimals, .horses, .space]
        )
        let jungle = CatalogBrowseSelector.lessons(for: .jungleAnimals, profile: profile)
        XCTAssertFalse(jungle.isEmpty)
        XCTAssertTrue(jungle.allSatisfy { $0.theme == .jungleAnimals })
        XCTAssertTrue(jungle.allSatisfy(\.isApprovedForChildDisplay))

        let natureWorld = CatalogBrowseSelector.lessons(for: ExploreSubjectCategory.nature, profile: profile)
        XCTAssertFalse(natureWorld.isEmpty)
        XCTAssertTrue(natureWorld.allSatisfy { ExploreSubjectCategory.nature.topics.contains($0.theme) })
        XCTAssertFalse(natureWorld.contains { $0.theme == Topic.horses })
    }

    func testLevelMatchedCatalogShowsAllCategoriesAtExactLevel() {
        let profile = ChildProfile(
            age: 7,
            readingLevel: .earlyReader,
            mathLevel: .developing,
            favoriteTopics: [.jungleAnimals, .horses, .space]
        )
        let catalog = LessonLoader.allLessons()
        let matched = CatalogBrowseSelector.levelMatchedLessons(from: catalog, profile: profile)
        XCTAssertFalse(matched.isEmpty)
        XCTAssertTrue(matched.allSatisfy { $0.readingLevel == .earlyReader })
        XCTAssertTrue(matched.allSatisfy { $0.mathLevel == .developing })
        XCTAssertTrue(matched.allSatisfy(\.isApprovedForChildDisplay))

        let jungle = matched.filter { $0.theme == .jungleAnimals }
        XCTAssertGreaterThanOrEqual(jungle.count, 2, "Expected multiple lesson kinds for the same topic and level")
        XCTAssertTrue(Set(jungle.map(\.category)).count >= 2)

        let groups = CatalogBrowseSelector.groupedByTopic(matched, favoriteTopics: profile.favoriteTopics)
        XCTAssertEqual(groups.first?.topic, .jungleAnimals)
        XCTAssertFalse(groups.contains { $0.topic == .horses && $0.lessons.contains { $0.theme != .horses } })
    }

    func testStoryDiscoveryCreativeAreDistinctAtSameLevel() {
        let story = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .jungleAnimals, category: .story, readingLevel: .earlyReader, mathLevel: .developing
        )
        let discovery = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .jungleAnimals, category: .discovery, readingLevel: .earlyReader, mathLevel: .developing
        )
        let creative = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .jungleAnimals, category: .creative, readingLevel: .earlyReader, mathLevel: .developing
        )
        XCTAssertNotNil(story)
        XCTAssertNotNil(discovery)
        XCTAssertNotNil(creative)
        XCTAssertNotEqual(story?.readingPassage, discovery?.readingPassage)
        XCTAssertNotEqual(story?.readingPassage, creative?.readingPassage)
        XCTAssertNotEqual(story?.title, discovery?.title)
        XCTAssertFalse(discovery?.title.contains("Art Quest") == true)
    }

    func testDiscoveryAndCreativeSeedForEmergingAndAdvancingMath() {
        for math in [MathLevel.emerging, .advancing] {
            let discovery = ApprovedContentLibrary.exactMatches(
                readingLevel: .earlyReader,
                mathLevel: math,
                topics: [.horses, .jungleAnimals],
                category: .discovery
            )
            let creative = ApprovedContentLibrary.exactMatches(
                readingLevel: .earlyReader,
                mathLevel: math,
                topics: [.horses, .jungleAnimals],
                category: .creative
            )
            XCTAssertFalse(
                discovery.isEmpty,
                "Expected discovery seeds for math=\(math.rawValue)"
            )
            XCTAssertFalse(
                creative.isEmpty,
                "Expected creative seeds for math=\(math.rawValue)"
            )
            XCTAssertTrue(discovery.allSatisfy { $0.mathLevel == math })
            XCTAssertTrue(creative.allSatisfy { $0.mathLevel == math })
        }
    }

    func testDifferentReadingLevelsShowDifferentStoryTitles() {
        let beginner = CatalogBrowseSelector.lessons(
            for: .jungleAnimals,
            profile: ChildProfile(age: 5, readingLevel: .beginner, mathLevel: .emerging, favoriteTopics: [.jungleAnimals])
        )
        let confident = CatalogBrowseSelector.lessons(
            for: .jungleAnimals,
            profile: ChildProfile(age: 8, readingLevel: .confidentReader, mathLevel: .advancing, favoriteTopics: [.jungleAnimals])
        )
        let beginnerStory = beginner.first { $0.category == .story }
        let confidentStory = confident.first { $0.category == .story }
        XCTAssertNotNil(beginnerStory)
        XCTAssertNotNil(confidentStory)
        XCTAssertNotEqual(beginnerStory?.title, confidentStory?.title)
        XCTAssertNotEqual(beginnerStory?.readingPassage, confidentStory?.readingPassage)
        XCTAssertEqual(beginnerStory?.readingLevel, .beginner)
        XCTAssertEqual(confidentStory?.readingLevel, .confidentReader)
    }

    func testPoolDoesNotBroadenAwayFromFavorites() {
        let profile = ChildProfile(
            age: 6,
            readingLevel: .earlyReader,
            mathLevel: .developing,
            favoriteTopics: [.jungleAnimals]
        )
        let pool = ContentLibrarySelector.pool(for: profile)
        XCTAssertFalse(pool.isEmpty)
        XCTAssertTrue(pool.allSatisfy { $0.theme == .jungleAnimals })
    }

    func testAdaptationKeepsCuratedMathWhenOnLevel() {
        let profile = ChildProfile(
            age: 6,
            readingLevel: .earlyReader,
            mathLevel: .developing,
            favoriteTopics: [.dogs]
        )
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .dogs,
            category: .math,
            readingLevel: .earlyReader,
            mathLevel: .developing
        ) else {
            return XCTFail("Dogs math lesson must exist")
        }
        let prepared = ContentAdaptationService.prepare(
            lesson: lesson,
            profile: profile,
            learningState: .empty(childId: profile.id)
        )
        let prompts = prepared.lesson.childFacingMathChallenges.map(\.prompt).joined(separator: " ")
        XCTAssertFalse(prompts.localizedCaseInsensitiveContains("Sam"), "Adapted math should not invent Sam")
        XCTAssertTrue(
            prompts.localizedCaseInsensitiveContains("Ben")
                || prompts.localizedCaseInsensitiveContains("Scout")
                || prompts.localizedCaseInsensitiveContains("puppy")
                || prompts.localizedCaseInsensitiveContains("treat"),
            "Expected dogs-themed math. Got: \(prompts)"
        )
    }

    /// Residual QC gate: every Topic × Category × Reading × Math combo must approve.
    func testAllFactoryCombosApprove() {
        var failures: [String] = []
        for topic in Topic.allCases {
            for category in LessonCategory.allCases {
                for reading in ReadingLevel.allCases {
                    for math in MathLevel.allCases {
                        if LevelSpecificContentFactory.makeApprovedLesson(
                            topic: topic,
                            category: category,
                            readingLevel: reading,
                            mathLevel: math
                        ) == nil {
                            failures.append("\(topic.rawValue)/\(category.rawValue)/\(reading.rawValue)/\(math.rawValue)")
                        }
                    }
                }
            }
        }
        XCTAssertTrue(
            failures.isEmpty,
            "Factory approval failures (\(failures.count)):\n" + failures.prefix(60).joined(separator: "\n")
        )
    }

    func testMathLessonSummaryDoesNotClaimReadingPractice() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses,
            category: .math,
            readingLevel: .earlyReader,
            mathLevel: .developing
        ) else {
            return XCTFail("Expected a horses math lesson")
        }
        let summary = ProgressSummary(from: lesson, totalQuestions: 3, correctAnswers: 2)
        XCTAssertEqual(summary.category, .math)
        XCTAssertTrue(summary.readingSkill.isEmpty, "Math recap should not list a reading skill")
        XCTAssertFalse(summary.mathSkill.isEmpty)
        XCTAssertTrue(summary.scienceFact.isEmpty)
        XCTAssertTrue(summary.creativePrompt.isEmpty)
        XCTAssertTrue(summary.skillsPracticed.contains("Math"))
        XCTAssertFalse(summary.skillsPracticed.contains("Reading"))
        XCTAssertFalse(summary.missionCompleteMessage.lowercased().hasPrefix("mission complete"))
        XCTAssertLessThanOrEqual(summary.missionCompleteMessage.count, 90)
        XCTAssertTrue(lesson.questions.isEmpty, "Math problems should not also sit in the reading question list")
        XCTAssertFalse(lesson.mathChallenges.isEmpty)
    }

    func testNonMathLessonsStayMathFreeAfterAdaptation() {
        let profile = ChildProfile(
            age: 6,
            grade: "1st Grade",
            readingLevel: .earlyReader,
            mathLevel: .developing,
            favoriteTopics: [.sharks]
        )
        for category in [LessonCategory.story, .discovery, .creative] {
            guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                topic: .sharks,
                category: category,
                readingLevel: .earlyReader,
                mathLevel: .developing
            ) else {
                return XCTFail("Expected sharks \(category.rawValue) lesson")
            }
            let prepared = ContentAdaptationService.prepare(lesson: lesson, profile: profile)
            XCTAssertTrue(
                prepared.lesson.childFacingMathChallenges.isEmpty,
                "\(category.rawValue) '\(prepared.lesson.title)' should not add math. Got: \(prepared.lesson.childFacingMathChallenges.map(\.prompt))"
            )
            XCTAssertFalse(
                prepared.lesson.childFacingQuestions.contains { $0.subject == .math },
                "\(category.rawValue) '\(prepared.lesson.title)' mixed math into reading questions"
            )
            let blob = (
                prepared.lesson.missionPrompt
                    + prepared.lesson.childFacingQuestions.map(\.prompt).joined()
                    + prepared.lesson.childFacingMathChallenges.map(\.prompt).joined()
            ).lowercased()
            XCTAssertFalse(blob.contains("groups of"), "\(category.rawValue) still promises grouping math: \(blob)")
            XCTAssertFalse(blob.contains("how many full groups"), "\(category.rawValue) still has division grouping: \(blob)")
        }
    }

    func testSharkArtQuestIsADrawingOnlyScene() {
        let profile = ChildProfile(
            age: 7,
            grade: "2nd Grade",
            readingLevel: .growingReader,
            mathLevel: .secure,
            favoriteTopics: [.sharks]
        )
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .sharks,
            category: .creative,
            readingLevel: .growingReader,
            mathLevel: .secure
        ) else {
            return XCTFail("Expected shark drawing Art Quest")
        }
        XCTAssertEqual(lesson.title, "Smooth Shark Skin Drawing")
        let prepared = ContentAdaptationService.prepare(lesson: lesson, profile: profile)
        XCTAssertEqual(prepared.lesson.title, "Smooth Shark Skin Drawing")
        XCTAssertEqual(prepared.lesson.category, .creative)
        XCTAssertTrue(prepared.lesson.childFacingMathChallenges.isEmpty)
        XCTAssertTrue(prepared.lesson.childFacingQuestions.isEmpty)
        XCTAssertTrue(prepared.lesson.isArtQuest)
        XCTAssertEqual(prepared.lesson.creativeResponseType, .drawing)
        XCTAssertTrue(prepared.lesson.creativePrompt.localizedCaseInsensitiveContains("denticle"))
        XCTAssertFalse(prepared.lesson.missionPrompt.localizedCaseInsensitiveContains("groups of"))
        let facts = prepared.lesson.knowledgeFacts
        XCTAssertFalse(facts.isEmpty)
        let blob = facts.map { $0.fact + " " + $0.childFacingExplanation }.joined(separator: " ").lowercased()
        XCTAssertFalse(blob.contains("builders and artists"), "Got: \(blob)")
        XCTAssertFalse(blob.contains("true details like this"), "Got: \(blob)")
        XCTAssertFalse(blob.contains("use this fact so your creation"), "Got: \(blob)")
        XCTAssertTrue(
            facts.contains { $0.fact.localizedCaseInsensitiveContains("denticle") },
            "Expected a denticle fact. Got: \(facts.map(\.fact))"
        )
        if let extra = facts.first?.childFacingExplanation, !extra.isEmpty {
            XCTAssertTrue(
                extra.localizedCaseInsensitiveContains("skin")
                    || extra.localizedCaseInsensitiveContains("scale")
                    || extra.localizedCaseInsensitiveContains("water"),
                "Explanation should be simple shark science. Got: \(extra)"
            )
        }
    }

    func testMathLessonStillHasMathAfterAdaptation() {
        let profile = ChildProfile(
            age: 7,
            grade: "2nd Grade",
            readingLevel: .growingReader,
            mathLevel: .secure,
            favoriteTopics: [.sharks]
        )
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .sharks,
            category: .math,
            readingLevel: .growingReader,
            mathLevel: .secure
        ) else {
            return XCTFail("Expected sharks math lesson")
        }
        let prepared = ContentAdaptationService.prepare(lesson: lesson, profile: profile)
        XCTAssertFalse(prepared.lesson.childFacingMathChallenges.isEmpty)
        XCTAssertEqual(prepared.lesson.category, .math)
    }

    func testStoryLessonSummaryDoesNotClaimMathPractice() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses,
            category: .story,
            readingLevel: .earlyReader,
            mathLevel: .developing
        ) else {
            return XCTFail("Expected a horses story lesson")
        }
        let summary = ProgressSummary(from: lesson, totalQuestions: 3, correctAnswers: 3)
        XCTAssertEqual(summary.category, .story)
        XCTAssertTrue(summary.mathSkill.isEmpty, "Story recap should not list a math skill")
        XCTAssertFalse(summary.readingSkill.isEmpty)
        XCTAssertTrue(summary.scienceFact.isEmpty)
        XCTAssertTrue(summary.skillsPracticed.contains("Reading"))
        XCTAssertFalse(summary.skillsPracticed.contains("Math"))
    }

    func testLetterStartChoicesShareTitleCase() {
        let profile = ChildProfile(
            age: 6,
            grade: "Kindergarten",
            readingLevel: .beginner,
            mathLevel: .emerging,
            favoriteTopics: [.superheroes]
        )
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .superheroes,
            category: .discovery,
            readingLevel: .beginner,
            mathLevel: .emerging
        ) else {
            return XCTFail("Expected superheroes beginner discovery lesson")
        }
        let prepared = ContentAdaptationService.prepare(lesson: lesson, profile: profile)
        guard let question = prepared.lesson.childFacingQuestions.first(where: {
            $0.prompt.localizedCaseInsensitiveContains("starts with the letter")
        }) else {
            return XCTFail("Expected a letter-start question. Got: \(prepared.lesson.childFacingQuestions.map(\.prompt))")
        }
        for choice in question.choices {
            XCTAssertEqual(
                choice,
                choice.capitalized,
                "Letter-start choices should all be title case. Got: \(question.choices)"
            )
        }
        XCTAssertEqual(question.correctAnswer, question.correctAnswer?.capitalized)
        XCTAssertTrue(
            question.choices.contains(question.correctAnswer ?? ""),
            "Correct answer must match a displayed choice. choices=\(question.choices) answer=\(question.correctAnswer ?? "nil")"
        )
    }

    func testLetterStartQuestionsStayOffScienceStoriesForNonBeginners() {
        let profiles: [(ChildProfile, Topic, LessonCategory, ReadingLevel)] = [
            (
                ChildProfile(age: 6, grade: "Kindergarten", readingLevel: .growingReader, mathLevel: .developing, favoriteTopics: [.basketball]),
                .basketball, .discovery, .growingReader
            ),
            (
                ChildProfile(age: 6, grade: "Kindergarten", readingLevel: .confidentReader, mathLevel: .developing, favoriteTopics: [.cats]),
                .cats, .story, .confidentReader
            ),
            (
                ChildProfile(age: 6, grade: "Kindergarten", readingLevel: .earlyReader, mathLevel: .developing, favoriteTopics: [.basketball]),
                .basketball, .discovery, .growingReader
            )
        ]
        for (profile, topic, category, reading) in profiles {
            guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                topic: topic,
                category: category,
                readingLevel: reading,
                mathLevel: .developing
            ) else {
                return XCTFail("Expected \(topic.rawValue) \(category.rawValue) lesson")
            }
            let prepared = ContentAdaptationService.prepare(lesson: lesson, profile: profile)
            let prompts = prepared.lesson.childFacingQuestions.map(\.prompt)
            XCTAssertFalse(
                prompts.contains { $0.localizedCaseInsensitiveContains("starts with the letter") },
                "\(profile.readingLevel.rawValue) should not get a letter-start quiz on '\(lesson.title)'. Got: \(prompts)"
            )
        }
    }

    func testDidYouKnowFactsUseRealSubjectTerms() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .oceanAnimals,
            category: .math,
            readingLevel: .growingReader,
            mathLevel: .advancing
        ) else {
            return XCTFail("Expected Ocean Sighting Day")
        }
        XCTAssertEqual(lesson.title, "Ocean Sighting Day")
        let factBlob = lesson.knowledgeFacts.map(\.fact).joined(separator: " ").lowercased()
        XCTAssertTrue(
            factBlob.contains("tide chart"),
            "Did You Know should use the real term tide chart. Got: \(factBlob)"
        )
        XCTAssertNil(
            LessonContentCoherenceValidator.inventedKnowledgeTerm(in: lesson),
            "Ocean Sighting Day still has an invented Did You Know term"
        )
        XCTAssertFalse(
            lesson.title.localizedCaseInsensitiveContains("pack"),
            "Title should name the ocean-sighting day, not packs. Got: \(lesson.title)"
        )

        for topic in Topic.allCases {
            for category in LessonCategory.allCases {
                for reading in ReadingLevel.allCases {
                    let mathLevel: MathLevel = category == .math ? .advancing : .developing
                    guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                        topic: topic,
                        category: category,
                        readingLevel: reading,
                        mathLevel: mathLevel
                    ) else {
                        if category == .math {
                            return XCTFail("Missing math lesson for \(topic.rawValue) \(reading.rawValue)")
                        }
                        continue
                    }
                    XCTAssertNil(
                        LessonContentCoherenceValidator.inventedKnowledgeTerm(in: lesson),
                        "\(topic.rawValue) \(category.rawValue) \(reading.rawValue): \(lesson.knowledgeFacts.map(\.fact))"
                    )
                    XCTAssertFalse(
                        LessonContentCoherenceValidator.hasTemplatePacksTitle(lesson.title),
                        "\(topic.rawValue) title still uses Packs: \(lesson.title)"
                    )
                }
            }
        }
    }

    func testInventedKnowledgeTermDetectorCatchesShellPack() {
        let fact = KnowledgeFact(fact: "Tide charts and shell packs help watchers record ocean animals.")
        XCTAssertEqual(
            LessonContentCoherenceValidator.inventedKnowledgeTerm(inFacts: [fact])?.contains("shell pack"),
            true
        )
    }

    func testAdvancingMathDoesNotLabelOneStepAsTwoPart() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .oceanAnimals,
            category: .math,
            readingLevel: .growingReader,
            mathLevel: .advancing
        ) else {
            return XCTFail("Expected Ocean Sighting Day")
        }
        XCTAssertNil(
            LessonContentCoherenceValidator.childFacingStepJargon(in: lesson),
            "Ocean Sighting Day still tells the child this is a two-part question"
        )
        for question in lesson.mathChallenges {
            XCTAssertFalse(
                question.prompt.localizedCaseInsensitiveContains(" then "),
                "Math prompt still chains two operations: \(question.prompt)"
            )
            XCTAssertFalse(
                (question.explanation ?? "").localizedCaseInsensitiveContains(", then "),
                "Explanation still describes two steps: \(question.explanation ?? "")"
            )
        }
        XCTAssertFalse(lesson.skillsPracticed.contains { $0.localizedCaseInsensitiveContains("multi-step") })
        XCTAssertFalse(lesson.skillsPracticed.contains { $0.localizedCaseInsensitiveContains("two-part") })
    }

    func testUnsafeChildLanguageDetectorCatchesCastleViolenceNotPlay() {
        XCTAssertNotNil(
            LessonContentCoherenceValidator.childFacingUnsafeLanguage(
                in: "Arrow slits let archers shoot while staying protected.",
                label: "passage"
            )
        )
        XCTAssertNil(
            LessonContentCoherenceValidator.childFacingUnsafeLanguage(
                in: "Read the rescue plan before diving in!",
                label: "mission"
            ),
            "Diving in water is allowed"
        )
        XCTAssertNil(
            LessonContentCoherenceValidator.childFacingUnsafeLanguage(
                in: "Ignoring the tide table has wrecked many careless ships throughout history.",
                label: "passage"
            ),
            "Shipwrecks are allowed"
        )
        XCTAssertNil(
            LessonContentCoherenceValidator.childFacingUnsafeLanguage(
                in: "Nina climbs up the tree slowly to help the cat.",
                label: "passage"
            ),
            "Climbing trees is allowed"
        )
        XCTAssertNil(
            LessonContentCoherenceValidator.childFacingUnsafeLanguage(
                in: "Narrow slits let people look out while staying behind the wall.",
                label: "passage"
            ),
            "\"Narrow slits\" must not match \"arrow slit\""
        )
    }

    func testRewrittenLessonsStayChildAppropriate() {
        let nina = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .superheroes, category: .story, readingLevel: .beginner, mathLevel: .emerging
        )
        let castle = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .castles, category: .story, readingLevel: .earlyReader, mathLevel: .developing
        )
        let castleGrowing = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .castles, category: .story, readingLevel: .growingReader, mathLevel: .secure
        )
        let forest = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .nature, category: .story, readingLevel: .growingReader, mathLevel: .secure
        )
        let pirates = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .pirates, category: .story, readingLevel: .growingReader, mathLevel: .secure
        )
        guard let nina, let castle, let castleGrowing, let forest, let pirates else {
            return XCTFail(
                "Expected helper, castle, forest, and pirate lessons. nina=\(nina?.title ?? "nil") castle=\(castle?.title ?? "nil") castleGrowing=\(castleGrowing?.title ?? "nil") forest=\(forest?.title ?? "nil") pirates=\(pirates?.title ?? "nil")"
            )
        }
        XCTAssertEqual(nina.title, "Nina Saves the Cat")
        XCTAssertTrue(nina.readingPassage.localizedCaseInsensitiveContains("climbs up"))
        XCTAssertEqual(castle.title, "A Tour of the Castle Wall")
        XCTAssertNil(LessonContentCoherenceValidator.childFacingUnsafeLanguage(in: castle))
        XCTAssertNil(LessonContentCoherenceValidator.childFacingUnsafeLanguage(in: castleGrowing))
        XCTAssertEqual(forest.title, "Why Old Trees Still Help the Forest")
        XCTAssertFalse(forest.title.localizedCaseInsensitiveContains("Dead Trees"))
        XCTAssertTrue(pirates.readingPassage.localizedCaseInsensitiveContains("wrecked many"))
        XCTAssertTrue(pirates.storyEnding.localizedCaseInsensitiveContains("shipwreck"))
        XCTAssertNil(LessonContentCoherenceValidator.childFacingUnsafeLanguage(in: nina))
        XCTAssertNil(LessonContentCoherenceValidator.childFacingUnsafeLanguage(in: pirates))
    }

    func testCatalogCopyHasNoUnsafeChildLanguage() {
        var failures: [String] = []
        for topic in Topic.allCases {
            for category in LessonCategory.allCases {
                for reading in ReadingLevel.allCases {
                    for math in MathLevel.allCases {
                        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                            topic: topic,
                            category: category,
                            readingLevel: reading,
                            mathLevel: math
                        ) else { continue }
                        if let issue = LessonContentCoherenceValidator.childFacingUnsafeLanguage(in: lesson) {
                            failures.append("\(lesson.title): \(issue)")
                        }
                    }
                }
            }
        }
        for lesson in BundledLessons.all {
            if let issue = LessonContentCoherenceValidator.childFacingUnsafeLanguage(in: lesson) {
                failures.append("bundled \(lesson.title): \(issue)")
            }
        }
        for topic in TopicLibrary.all {
            for fact in topic.scienceFacts {
                if let issue = LessonContentCoherenceValidator.childFacingUnsafeLanguage(in: fact, label: topic.name) {
                    failures.append("topic fact \(issue)")
                }
            }
        }
        XCTAssertTrue(
            failures.isEmpty,
            "Unsafe child language (\(failures.count)):\n" + failures.prefix(40).joined(separator: "\n")
        )
    }

    func testPirateDiscoveryUsesCaptainWrenNotWilla() {
        for level in ReadingLevel.allCases {
            guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                topic: .pirates,
                category: .discovery,
                readingLevel: level,
                mathLevel: .emerging
            ) else {
                return XCTFail("Expected pirate discovery lesson for \(level.rawValue)")
            }
            let blob = (lesson.storyOpening + " " + lesson.storyEnding).lowercased()
            XCTAssertFalse(
                blob.contains("willa") || blob.contains("whale"),
                "Pirate discovery should star Captain Wren, not Willa the whale. Got: \(lesson.storyOpening)"
            )
            XCTAssertTrue(
                lesson.storyOpening.localizedCaseInsensitiveContains("Captain Wren"),
                "Pirate discovery opening should name Captain Wren. Got: \(lesson.storyOpening)"
            )
        }
        let compass = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .pirates,
            category: .discovery,
            readingLevel: .growingReader,
            mathLevel: .emerging
        )
        XCTAssertTrue(
            compass?.storyOpening.localizedCaseInsensitiveContains("compass needle") == true,
            "Growing-reader pirate discovery should still open on the compass. Got: \(compass?.storyOpening ?? "nil")"
        )
    }

    func testCaptainWrenTreasureLessonGroundsTheChestQuestion() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .pirates,
            category: .story,
            readingLevel: .beginner,
            mathLevel: .emerging
        ) else {
            return XCTFail("Expected Captain Wren treasure lesson")
        }
        XCTAssertEqual(lesson.title, "Captain Wren Finds Treasure")
        XCTAssertTrue(
            lesson.readingPassage.localizedCaseInsensitiveContains("where the X marks the spot"),
            "The story should say she digs where the X marks the spot. Got: \(lesson.readingPassage)"
        )
        XCTAssertTrue(
            lesson.readingPassage.localizedCaseInsensitiveContains("gold coins"),
            "The story should put gold coins in the chest. Got: \(lesson.readingPassage)"
        )

        guard let lastQuestion = lesson.questions.last else {
            return XCTFail("Expected a last reading question about the chest")
        }
        XCTAssertTrue(
            lastQuestion.prompt.localizedCaseInsensitiveContains("chest"),
            "The last question should ask what is in the chest. Got: \(lastQuestion.prompt)"
        )
        XCTAssertEqual(lastQuestion.correctAnswer, "Gold coins")
        XCTAssertTrue(
            lesson.readingPassage.localizedCaseInsensitiveContains(lastQuestion.correctAnswer ?? ""),
            "The chest answer must appear in the passage"
        )
    }

    func testEveryTopicHasADrawingOnlyArtQuest() {
        var missing: [String] = []
        var problems: [String] = []
        for topic in Topic.allCases {
            for level in ReadingLevel.allCases {
                guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                    topic: topic,
                    category: .creative,
                    readingLevel: level,
                    mathLevel: .developing
                ) else {
                    missing.append("\(topic.rawValue) \(level.rawValue)")
                    continue
                }
                if !lesson.isArtQuest {
                    problems.append("\(topic.rawValue) \(level.rawValue) is not Art Quest")
                }
                if lesson.creativeResponseType != .drawing {
                    problems.append("\(topic.rawValue) \(level.rawValue) type=\(lesson.creativeResponseType.rawValue)")
                }
                if !lesson.questions.isEmpty || !lesson.mathChallenges.isEmpty {
                    problems.append("\(topic.rawValue) \(level.rawValue) still has quiz items")
                }
                if !lesson.creativePrompt.localizedCaseInsensitiveContains("draw this scene") {
                    problems.append("\(topic.rawValue) \(level.rawValue) prompt: \(lesson.creativePrompt)")
                }
                if lesson.creativePrompt.localizedCaseInsensitiveContains("write four") {
                    problems.append("\(topic.rawValue) \(level.rawValue) still asks kids to write")
                }
                if lesson.drawingQuestGoals.isEmpty {
                    problems.append("\(topic.rawValue) \(level.rawValue) missing drawing goals")
                }
            }
        }
        XCTAssertTrue(missing.isEmpty, "Missing creative lessons: \(missing.joined(separator: ", "))")
        XCTAssertTrue(problems.isEmpty, problems.joined(separator: "\n"))
    }

    func testSharkBeginnerArtQuestIsTheFriendsAdventureScene() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .sharks,
            category: .creative,
            readingLevel: .beginner,
            mathLevel: .emerging
        ) else {
            return XCTFail("Expected shark friends drawing")
        }
        XCTAssertEqual(lesson.title, "Shark Friends Adventure")
        XCTAssertTrue(lesson.isArtQuest)
        XCTAssertEqual(lesson.creativeResponseType, .drawing)
        let prompt = lesson.creativePrompt.lowercased()
        XCTAssertTrue(prompt.contains("gills"))
        XCTAssertTrue(prompt.contains("dark blue"))
        XCTAssertTrue(prompt.contains("red") && prompt.contains("pink") && prompt.contains("green"))
        XCTAssertTrue(prompt.contains("seaweed"))
        XCTAssertTrue(prompt.contains("starfish"))
        XCTAssertEqual(lesson.drawingQuestGoals, ["Dark blue shark", "Gills", "Fish friends", "Starfish"])
    }
}
