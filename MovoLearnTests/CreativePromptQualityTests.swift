import XCTest
@testable import MovoLearn

final class CreativePromptQualityTests: XCTestCase {

    func testFlagsHypotheticalWritingPrompts() {
        let banned = [
            "Write two sentences explaining what you would check before assuming why a market stall was empty.",
            "Which clue felt most convincing to you, and why?",
            "Write two sentences about what you would do if a pony pinned its ears during a visit."
        ]
        for prompt in banned {
            XCTAssertTrue(
                CreativePromptQuality.isOpinionOrHypothetical(prompt),
                "Expected hypothetical: \(prompt)"
            )
        }
    }

    func testConvertsWriteInstructionIntoAQuestion() {
        let converted = CreativePromptQuality.ensureStoryComprehension(
            prompt: "Write two sentences about why the weaver's stall was empty and how Elin helped shoppers return.",
            responseType: .shortText,
            questions: [
                LessonQuestion(
                    subject: .reading,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "What did Elin conclude was the real reason for the empty stall?",
                    choices: ["A new road", "Lost skill", "No cloth"],
                    correctAnswer: "A new road",
                    explanation: "The new road explained it."
                )
            ],
            title: "The Mystery of the Empty Stall",
            category: .story
        )
        XCTAssertFalse(converted.lowercased().hasPrefix("write two sentences"))
        XCTAssertFalse(CreativePromptQuality.isOpinionOrHypothetical(converted))
        XCTAssertTrue(
            converted.localizedCaseInsensitiveContains("stall")
                || converted.localizedCaseInsensitiveContains("Elin"),
            "Expected a stall/Elin question, got: \(converted)"
        )
    }

    func testRewritesHypotheticalPromptUsingTheStoryQuestion() {
        let rewritten = CreativePromptQuality.ensureStoryComprehension(
            prompt: "Write two sentences explaining what you would check before assuming why a market stall was empty.",
            responseType: .shortText,
            questions: [
                LessonQuestion(
                    subject: .reading,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "What did Elin conclude was the real reason for the empty stall?",
                    choices: ["A new road", "Lost skill", "No cloth"],
                    correctAnswer: "A new road",
                    explanation: "The new road explained it."
                ),
                LessonQuestion(
                    subject: .reading,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "What did Elin do to help the weaver?",
                    choices: ["Put up a sign", "Closed the market", "Changed her craft"],
                    correctAnswer: "Put up a sign",
                    explanation: "She arranged a sign."
                )
            ],
            title: "The Mystery of the Empty Stall",
            category: .story
        )
        XCTAssertFalse(CreativePromptQuality.isOpinionOrHypothetical(rewritten))
        XCTAssertTrue(
            rewritten.localizedCaseInsensitiveContains("Elin")
                || rewritten.localizedCaseInsensitiveContains("weaver")
                || rewritten.localizedCaseInsensitiveContains("stall"),
            "Expected a story question, got: \(rewritten)"
        )
    }

    func testLeavesDrawingPromptsAlone() {
        let prompt = "Draw Elin putting up a sign for the weaver's stall."
        let kept = CreativePromptQuality.ensureStoryComprehension(
            prompt: prompt,
            responseType: .drawing,
            questions: [],
            title: "The Mystery of the Empty Stall",
            category: .story
        )
        XCTAssertEqual(kept, prompt)
    }

    func testEmptyStallLessonAsksStoryComprehension() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .princesses,
            category: .story,
            readingLevel: .confidentReader,
            mathLevel: .secure
        ) else {
            return XCTFail("Expected Empty Stall story lesson")
        }
        XCTAssertEqual(lesson.title, "The Mystery of the Empty Stall")
        XCTAssertFalse(CreativePromptQuality.isOpinionOrHypothetical(lesson.creativePrompt))
        XCTAssertFalse(CreativePromptQuality.isOpinionOrHypothetical(lesson.reflectionPrompt))
        XCTAssertFalse(lesson.creativePrompt.lowercased().contains("make it yours"))
        XCTAssertFalse(lesson.creativePrompt.lowercased().hasPrefix("write two sentences"))
        XCTAssertTrue(
            lesson.creativePrompt.localizedCaseInsensitiveContains("Elin")
                || lesson.creativePrompt.localizedCaseInsensitiveContains("road")
                || lesson.creativePrompt.localizedCaseInsensitiveContains("stall"),
            "Create Time should ask about the story, got: \(lesson.creativePrompt)"
        )
        XCTAssertTrue(
            lesson.reflectionPrompt.localizedCaseInsensitiveContains("Elin")
                || lesson.reflectionPrompt.localizedCaseInsensitiveContains("weaver")
                || lesson.reflectionPrompt.localizedCaseInsensitiveContains("shopper")
                || lesson.reflectionPrompt.localizedCaseInsensitiveContains("stall"),
            "Star Moment should ask about the story, got: \(lesson.reflectionPrompt)"
        )
    }

    func testRewritesOpinionReflectionForStoryLessons() {
        let fixed = ReflectionPromptQuality.ensureConcrete(
            prompt: "Which clue felt most convincing to you, and why?",
            questions: [
                LessonQuestion(
                    subject: .reading,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "What did Elin conclude was the real reason for the empty stall?",
                    choices: ["A new road", "Lost skill", "No cloth"],
                    correctAnswer: "A new road",
                    explanation: "The new road explained it."
                ),
                LessonQuestion(
                    subject: .reading,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "How long had the weaver's stall stood empty?",
                    choices: ["Third week", "One morning", "A year"],
                    correctAnswer: "Third week",
                    explanation: "It was empty for the third week."
                )
            ],
            title: "The Mystery of the Empty Stall",
            category: .story
        )
        XCTAssertFalse(CreativePromptQuality.isOpinionOrHypothetical(fixed))
        XCTAssertTrue(fixed.localizedCaseInsensitiveContains("stall") || fixed.localizedCaseInsensitiveContains("Elin"))
    }
}
