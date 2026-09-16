import XCTest
@testable import MovoLearn

final class ReflectionPromptQualityTests: XCTestCase {

    func testFlagsClassicGenericReflections() {
        let banned = [
            "What did you learn?",
            "How did groups help in this lesson today?",
            "Where did equal groups help you today?",
            "What did you count today?",
            "Which step did you check twice?",
            "Which fact surprised you most?",
            "What is one new thing you learned today?",
            "What is one detail from today you want to remember?",
            "Would you like to watch or join a horse race?",
            "How did you help the triceratops?"
        ]
        for prompt in banned {
            XCTAssertTrue(
                ReflectionPromptQuality.isGeneric(prompt),
                "Expected generic: \(prompt)"
            )
        }
    }

    func testFlagsOpinionAndHypotheticalReflections() {
        let banned = [
            "Which clue felt most convincing to you, and why?",
            "Which clue would you trust most before passing the ball?",
            "Would you rather make a choice that looks impressive or one that helps the most people?"
        ]
        for prompt in banned {
            XCTAssertTrue(
                CreativePromptQuality.isOpinionOrHypothetical(prompt),
                "Expected opinion/hypothetical: \(prompt)"
            )
        }
    }

    func testAllowsConcreteLessonSpecificReflections() {
        let allowed = [
            "How many full groups of 10 seed pods could Lina make?",
            "A tray has 3 rows of 4 berries. How many berries are there?",
            "What does Mia brush?",
            "How did thick walls help during ordinary weather?",
            "What is the canopy in the jungle?",
            "Which repair step put the triceratops horn back in place?"
        ]
        for prompt in allowed {
            XCTAssertFalse(
                ReflectionPromptQuality.isGeneric(prompt),
                "Expected concrete: \(prompt)"
            )
        }
    }

    func testEnsureConcreteRewritesGenericUsingLessonQuestions() {
        let lesson = Lesson(
            title: "Groups in the Canopy",
            theme: .jungleAnimals,
            lessonType: .builder,
            category: .math,
            primarySubject: .math,
            storyOpening: "Lina sorts fruit samples.",
            missionPrompt: "Use groups of ten.",
            readingPassage: "Fruit samples from the canopy are sorted into trays.",
            questions: [],
            mathChallenges: [
                LessonQuestion(
                    subject: .math,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "Lina packs 20 seed pods into groups of 10. How many full groups can she make?",
                    choices: ["1", "2", "3"],
                    correctAnswer: "2",
                    explanation: "20 ÷ 10 = 2."
                ),
                LessonQuestion(
                    subject: .math,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "A tray has 3 rows of 4 berries. How many berries are there?",
                    choices: ["7", "12", "14"],
                    correctAnswer: "12",
                    explanation: "3 × 4 = 12."
                )
            ],
            vocabularyWords: [],
            knowledgeFacts: [],
            creativePrompt: "Draw the berry tray.",
            creativeResponseType: .drawing,
            storyEnding: "Done!",
            readingSkill: "Details",
            mathSkill: "Equal groups",
            reflectionPrompt: "Where did equal groups help in the jungle lab?",
            skillsPracticed: ["Equal groups"]
        )

        let fixed = ReflectionPromptQuality.ensureConcrete(
            prompt: lesson.reflectionPrompt,
            lesson: lesson
        )
        XCTAssertFalse(ReflectionPromptQuality.isGeneric(fixed))
        XCTAssertTrue(fixed.localizedCaseInsensitiveContains("berries") || fixed.localizedCaseInsensitiveContains("seed"))
    }

    func testJungleGroupsSecureSceneUsesConcreteReflection() {
        guard let scene = CuratedTopicLessonBank.mathScene(
            topic: .jungleAnimals,
            mathLevel: .secure,
            readingLevel: .earlyReader
        ) else {
            return XCTFail("Missing jungle secure math scene")
        }
        XCTAssertEqual(scene.title, "Groups in the Canopy")
        XCTAssertFalse(
            ReflectionPromptQuality.isGeneric(scene.reflectionPrompt),
            "Jungle groups reflection still generic: \(scene.reflectionPrompt)"
        )
        XCTAssertTrue(
            scene.reflectionPrompt.localizedCaseInsensitiveContains("berr")
                || scene.reflectionPrompt.localizedCaseInsensitiveContains("seed")
                || scene.reflectionPrompt.localizedCaseInsensitiveContains("group")
                || scene.reflectionPrompt.localizedCaseInsensitiveContains("vine"),
            "Expected canopy-specific wording, got: \(scene.reflectionPrompt)"
        )
    }

    func testApprovedFactoryLessonsHaveConcreteReflections() {
        let topics: [Topic] = [.horses, .jungleAnimals, .soccer, .dinosaurs]
        let levels: [ReadingLevel] = [.beginner, .confidentReader]
        let mathLevels: [MathLevel] = [.emerging, .secure, .advancing]
        var checked = 0

        for topic in topics {
            for reading in levels {
                for math in mathLevels {
                    for category in [LessonCategory.story, .math, .discovery] {
                        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                            topic: topic,
                            category: category,
                            readingLevel: reading,
                            mathLevel: math
                        ) else { continue }
                        checked += 1
                        XCTAssertFalse(
                            ReflectionPromptQuality.isGeneric(lesson.reflectionPrompt),
                            "\(topic.rawValue)/\(category.rawValue)/\(reading.rawValue)/\(math.rawValue): \(lesson.reflectionPrompt)"
                        )
                    }
                }
            }
        }

        XCTAssertGreaterThan(checked, 10, "Expected several approved lessons to validate")
    }
}
