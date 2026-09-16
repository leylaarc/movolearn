import XCTest
@testable import MovoLearn

final class MysteryQualityTests: XCTestCase {
    func testWeakOneShotRiddleIsRejected() {
        let weak = LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "I have fins and live in the ocean. What am I?",
            choices: ["A shark", "A toaster", "A castle"],
            correctAnswer: "A shark",
            mysteryKind: .identity,
            mysterySetup: "Guess the animal.",
            clues: ["I have fins and live in the ocean."]
        )
        let result = MysteryQualityValidator.validate(weak, topic: .sharks)
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.issues.contains(.tooFewClues(1)) || result.issues.contains(.answerObviousFromFirstClue) || result.issues.contains(.absurdDistractor("A toaster")))
    }

    func testStrongProgressiveMysteryPasses() {
        let strong = LessonQuestion.mystery(
            kind: .identity,
            setup: "Fish near the reef suddenly changed direction. What might be nearby?",
            clues: [
                "The fish stayed close together and moved away from the deeper water.",
                "A dark fin briefly appeared above the surface.",
                "The animal had a streamlined body and moved silently through the water."
            ],
            prompt: "Which animal was most likely approaching the reef?",
            choices: ["A reef shark", "A sea turtle", "A manta ray"],
            correctAnswer: "A reef shark",
            explanation: "The fin, quiet streamlined swim, and fleeing fish support a reef shark."
        )
        let result = MysteryQualityValidator.validate(strong, topic: .sharks, passage: "Finn watched fish dart from deeper water.")
        XCTAssertTrue(result.isValid, "\(result.issues)")
        XCTAssertTrue(strong.isProgressiveMystery)
    }

    func testClueThatNamesAnswerIsRejected() {
        let bad = LessonQuestion.mystery(
            kind: .identity,
            setup: "What animal is nearby?",
            clues: [
                "It swims near coral.",
                "The animal is a reef shark.",
                "It moves quietly."
            ],
            prompt: "What is it?",
            choices: ["A reef shark", "A sea turtle", "A dolphin"],
            correctAnswer: "A reef shark",
            explanation: "Because it is a reef shark."
        )
        let result = MysteryQualityValidator.validate(bad, topic: .sharks)
        XCTAssertTrue(result.issues.contains(where: {
            if case .clueNamesAnswer = $0 { return true }
            return false
        }))
    }

    func testReefMysteryLessonUsesProgressiveMystery() {
        let lesson = BundledLessons.reefMystery
        let mysteries = lesson.questions.filter(\.isProgressiveMystery)
        XCTAssertFalse(mysteries.isEmpty)
        for question in mysteries {
            let result = MysteryQualityValidator.validate(
                question,
                topic: lesson.theme,
                passage: lesson.readingPassage,
                lessonTitle: lesson.title
            )
            XCTAssertTrue(result.isValid, "\(question.prompt) → \(result.issues)")
        }
        // Passage should not spoil with “case closed / reef shark fits every clue”
        let passage = lesson.readingPassage.lowercased()
        XCTAssertFalse(passage.contains("case closed"))
        XCTAssertFalse(passage.contains("fits every clue"))
    }

    func testFakeRecallMysteryIsFlagged() {
        let recall = LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "What does Clue A say the animal swims?",
            choices: ["Where coral grows tall", "Where seaweed floats", "Where waves break"],
            correctAnswer: "Where coral grows tall",
            mysteryKind: .identity,
            mysterySetup: "Read clue A.",
            clues: [
                "Where coral grows tall.",
                "The animal has fins.",
                "It senses fish nearby."
            ]
        )
        let result = MysteryQualityValidator.validate(recall, topic: .sharks)
        XCTAssertTrue(result.issues.contains(.fakeMysteryRecall))
    }
}
