import XCTest
@testable import MovoLearn

final class QuestionQualityTests: XCTestCase {

    func testEducationalChoicesAreNotFlaggedAsJokes() {
        let cases: [(Topic, String)] = [
            (.rockets, "The hatch-sensor warning needed a second reading"),
            (.airplanes, "A wing's curved shape is carefully designed to create lift"),
            (.cars, "Blows air over a car the way wind would on a highway"),
            (.planets, "Reflect a lot of sunlight toward Earth"),
            (.cats, "Under a cold porch")
        ]
        for (topic, educational) in cases {
            let question = LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Which detail fits the lesson?",
                choices: [educational, "A sandwich for lunch", "Magic only"],
                correctAnswer: educational
            )
            let result = QuestionQualityValidator.validate(
                question,
                topic: topic,
                topicKeywords: QuestionQualityValidator.topicKeywords(for: topic),
                context: LessonContextBank.from(topic: topic, primarySubject: .reading)
            )
            let jokedEducational = result.issues.contains { issue in
                if case .jokeOrAbsurdChoice(let choice) = issue {
                    return choice == educational
                }
                return false
            }
            XCTAssertFalse(jokedEducational, "False-positive joke flag for \(topic.rawValue): \(educational)")
            XCTAssertTrue(result.issues.contains { issue in
                if case .jokeOrAbsurdChoice(let choice) = issue {
                    return choice == "A sandwich for lunch" || choice == "Magic only"
                }
                return false
            }, "Still expect real joke distractors to fail for \(topic.rawValue)")
        }
    }

    func testAbsurdDistractorsAreRejected() {
        let question = LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "Where does a reef shark live?",
            choices: [
                "Near coral reefs",
                "Inside a toaster",
                "On a classroom desk"
            ],
            correctAnswer: "Near coral reefs"
        )
        let result = QuestionQualityValidator.validate(
            question,
            topic: .sharks,
            topicKeywords: QuestionQualityValidator.topicKeywords(for: .sharks),
            context: LessonContextBank.from(topic: .sharks, primarySubject: .science)
        )
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.issues.contains { issue in
            if case .jokeOrAbsurdChoice = issue { return true }
            if case .unrelatedNoun = issue { return true }
            return false
        })
    }

    func testJuiceAndTransformJokeChoicesAreRejected() {
        let question = LessonQuestion(
            subject: .science,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "When does a basketball bounce?",
            choices: [
                "When it hits the floor",
                "When it melts into juice",
                "When it turns into a bird"
            ],
            correctAnswer: "When it hits the floor"
        )
        let result = QuestionQualityValidator.validate(
            question,
            topic: .basketball,
            topicKeywords: QuestionQualityValidator.topicKeywords(for: .basketball)
        )
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.issues.contains { issue in
            if case .jokeOrAbsurdChoice(let choice) = issue {
                return choice.localizedCaseInsensitiveContains("juice")
                    || choice.localizedCaseInsensitiveContains("bird")
            }
            return false
        })
    }

    func testDiscoveryAndStoryBanksHaveNoJokeTransforms() {
        let banned = ["into juice", "into a bird", "into candy", "sing a song", "grow feathers"]
        for topic in Topic.allCases {
            for category in [LessonCategory.discovery, .story] {
                for reading in ReadingLevel.allCases {
                    guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                        topic: topic,
                        category: category,
                        readingLevel: reading,
                        mathLevel: .emerging
                    ) else { continue }
                    let blob = (
                        lesson.questions.flatMap(\.choices)
                            + lesson.mathChallenges.flatMap(\.choices)
                    ).joined(separator: " | ").lowercased()
                    for phrase in banned {
                        XCTAssertFalse(
                            blob.contains(phrase),
                            "\(topic.rawValue) \(category.rawValue) \(reading.rawValue) still has \"\(phrase)\""
                        )
                    }
                }
            }
        }
    }

    func testArrangingPromptIsRejected() {
        let question = LessonQuestion(
            subject: .reading,
            type: .openEnded,
            responseType: .sorting,
            prompt: "Put Finn's adventure in the correct order.",
            items: [
                SortingItem(id: "1", text: "Notice bubbles", correctPosition: 1),
                SortingItem(id: "2", text: "Investigate", correctPosition: 2)
            ]
        )
        let result = QuestionQualityValidator.validate(question)
        XCTAssertTrue(result.issues.contains(.unsupportedArrangingActivity))
    }

    func testOffThemeMathNotesQuestionIsRejected() {
        let question = LessonQuestion(
            subject: .math,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "There are 5 notes and you read 2. How many notes are left to read?",
            choices: ["2", "3", "4"],
            correctAnswer: "3"
        )
        let context = LessonContextBank.from(topic: .sharks, primarySubject: .math)
        let result = QuestionQualityValidator.validate(
            question,
            topic: .sharks,
            context: context,
            primarySubject: .math
        )
        XCTAssertTrue(result.issues.contains { issue in
            if case .unrelatedNoun = issue { return true }
            if case .subjectMismatch = issue { return true }
            return false
        })
    }

    func testSharkLessonHasNoAbsurdChoices() throws {
        guard let url = Bundle.main.url(forResource: "sharks", withExtension: "json") else {
            return XCTFail("sharks.json missing")
        }
        let lesson = try LessonLoader.decodeLesson(from: try Data(contentsOf: url))
        let messages = QuestionQualityValidator.validateLesson(lesson)
        let absurd = messages.filter {
            $0.lowercased().contains("joke") || $0.lowercased().contains("absurd") || $0.lowercased().contains("arranging")
        }
        XCTAssertTrue(absurd.isEmpty, absurd.joined(separator: "\n"))
    }

    func testMathLessonsMeetMathFocusRatio() {
        let mathLessons = BundledLessons.all.filter { $0.primarySubject == .math }
        XCTAssertFalse(mathLessons.isEmpty)
        for lesson in mathLessons {
            XCTAssertGreaterThanOrEqual(
                lesson.mathAssessmentRatio,
                0.70,
                "\(lesson.title) math ratio \(lesson.mathAssessmentRatio)"
            )
            for question in lesson.childFacingMathChallenges {
                let lower = question.prompt.lowercased()
                XCTAssertFalse(lower.contains("notes and you read"), question.prompt)
            }
        }
    }

    func testPrimarySubjectFiltersMathSection() {
        let math = BundledLessons.all.filter { $0.primarySubject == .math }
        let reading = BundledLessons.all.filter { $0.primarySubject == .reading }
        XCTAssertFalse(math.isEmpty)
        XCTAssertFalse(reading.isEmpty)
        XCTAssertTrue(math.allSatisfy { $0.category == .math || $0.primarySubject == .math })
        XCTAssertFalse(math.contains { $0.title == "Reef Mystery Lesson" })
    }

    func testContextBankIncludesLessonCharacters() {
        let bank = LessonContextBank.from(lesson: BundledLessons.sharkExplorer)
        XCTAssertTrue(bank.characters.contains("Finn") || bank.allowedNouns.contains("finn"))
        XCTAssertFalse(bank.excludedConcepts.isEmpty)
        XCTAssertEqual(bank.primarySubject, .reading)
    }

    func testChildFacingStepsOmitSorting() {
        let lesson = BundledLessons.sharkExplorer
        let prompts = (lesson.childFacingQuestions + lesson.childFacingMathChallenges).map(\.prompt)
        XCTAssertFalse(prompts.contains { QuestionQualityValidator.looksLikeArrangingPrompt($0) })
        XCTAssertFalse(lesson.questions.contains { $0.responseType == .sorting })
    }

    func testMetaClueReadingPromptIsRejected() {
        let question = LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "Which two clues did Lena compare?",
            choices: [
                "The defender's lean and her teammate's position",
                "Only the color of the jerseys",
                "Only the sound of the whistle"
            ],
            correctAnswer: "The defender's lean and her teammate's position"
        )
        let result = QuestionQualityValidator.validate(
            question,
            topic: .soccer,
            topicKeywords: QuestionQualityValidator.topicKeywords(for: .soccer)
        )
        XCTAssertTrue(result.issues.contains { issue in
            if case .metaComprehensionPrompt = issue { return true }
            return false
        })
        XCTAssertTrue(result.issues.contains { issue in
            if case .jokeOrAbsurdChoice(let choice) = issue {
                return choice.localizedCaseInsensitiveContains("only the color")
            }
            return false
        })
    }

    func testApprovedStoryQuestionsAskAboutThePassage() {
        for topic in Topic.allCases {
            guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                topic: topic,
                category: .story,
                readingLevel: .confidentReader,
                mathLevel: .developing
            ) else {
                if let pack = CuratedTopicLessonBank.readingPack(topic: topic, level: .confidentReader) {
                    var draft = Lesson(
                        title: pack.title,
                        theme: topic,
                        lessonType: .detective,
                        category: .story,
                        primarySubject: .reading,
                        storyOpening: pack.storyOpening,
                        missionPrompt: pack.missionPrompt,
                        readingPassage: pack.readingPassage,
                        questions: pack.questions,
                        mathChallenges: [],
                        vocabularyWords: pack.vocabularyWords,
                        knowledgeFacts: pack.knowledgeFacts,
                        creativePrompt: pack.creativePrompt,
                        creativeResponseType: pack.creativeResponseType,
                        storyEnding: pack.storyEnding,
                        readingLevel: .confidentReader,
                        mathLevel: .developing,
                        readingSkill: pack.readingSkill,
                        mathSkill: "",
                        reflectionPrompt: pack.reflectionPrompt,
                        skillsPracticed: ["Reading"],
                        hints: pack.hints,
                        commonMistakes: pack.commonMistakes,
                        successCriteria: pack.successCriteria,
                        learningObjectives: pack.learningObjectives
                    )
                    draft.reflectionPrompt = ReflectionPromptQuality.ensureConcrete(
                        prompt: draft.reflectionPrompt,
                        lesson: draft
                    )
                    let lesson = ChildFacingProseQualityValidator.polishLesson(draft)
                    let profile = ChildProfile(
                        age: 8,
                        readingLevel: .confidentReader,
                        mathLevel: .developing
                    )
                    let gate = AutomatedContentQualityGate.validate(
                        lesson: lesson,
                        profile: profile,
                        readingMeasurement: nil
                    )
                    let coherence = LessonContentCoherenceValidator.validate(lesson)
                    let prose = ChildFacingProseQualityValidator.validateLessonProse(lesson)
                    XCTFail("Expected an approved confident-reader story for \(topic.rawValue). gate=\(gate.summary) coherence=\(coherence.summary) prose=\(prose.issues.map(\.description))")
                } else {
                    XCTFail("Expected an approved confident-reader story for \(topic.rawValue)")
                }
                continue
            }
            for question in lesson.questions where question.subject == .reading {
                XCTAssertFalse(
                    QuestionQualityValidator.looksLikeMetaComprehensionPrompt(question.prompt),
                    "\(topic.rawValue) still has a clue-template prompt: \(question.prompt)"
                )
                for choice in question.choices {
                    XCTAssertFalse(
                        QuestionQualityValidator.looksLikeLazyClueDistractor(choice),
                        "\(topic.rawValue) still has a lazy distractor: \(choice)"
                    )
                }
            }
            XCTAssertFalse(
                QuestionQualityValidator.looksLikeMetaComprehensionPrompt(lesson.creativePrompt),
                "\(topic.rawValue) creative prompt still asks the child to invent clues: \(lesson.creativePrompt)"
            )
        }
    }
}
