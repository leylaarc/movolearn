import AVFoundation
import XCTest
@testable import MovoLearn

final class LessonReadAloudScriptTests: XCTestCase {

    func testStoryOpeningSpeaksTheStory() {
        let page = makePage(step: .moment(.storyOpening), opening: "Nova counted down beside the rocket.")
        let spoken = joined(LessonReadAloudScript.lines(for: page))
        XCTAssertTrue(spoken.contains("Nova counted down beside the rocket."))
    }

    func testReadingSkipsAnOpeningThatRetellsThePassage() {
        let captain = makePage(
            step: .moment(.reading),
            opening: "A new crew member wonders why Captain Wren studies a chart of numbers before sailing near the reef.",
            passage: "A new crew member once asked Captain Wren why she carefully studied a chart of numbers, called a tide table, before sailing near the rocky reef."
        )
        let captainSpoken = joined(LessonReadAloudScript.lines(for: captain))
        XCTAssertEqual(captainSpoken.components(separatedBy: "Captain Wren").count - 1, 1)

        let earth = makePage(
            step: .moment(.reading),
            opening: "A student asks why tiny earthquakes matter when studying a volcano.",
            passage: "A student once asked Dr. Nolan why she paid so much attention to tiny earthquakes that people could not even feel, when studying whether a volcano might erupt soon."
        )
        let earthSpoken = joined(LessonReadAloudScript.lines(for: earth))
        XCTAssertFalse(earthSpoken.localizedCaseInsensitiveContains("A student asks why"))
        XCTAssertTrue(earthSpoken.localizedCaseInsensitiveContains("tiny earthquakes"))
    }

    func testQuestionDropsARepeatedStoryAndQuestion() {
        let doubled = "Captain Wren checks the tide table before the reef. How many hours until high tide? Captain Wren checks the tide table before the reef. How many hours until high tide?"
        let once = StoryTextDedup.withoutRepeatedBlock(doubled)
        XCTAssertEqual(
            once,
            "Captain Wren checks the tide table before the reef. How many hours until high tide?"
        )

        let besideStory = StoryTextDedup.questionBesideStory(
            "A new crew member once asked Captain Wren why she studied the tide table. What is the main idea of this passage?",
            passage: "A new crew member once asked Captain Wren why she studied the tide table before sailing."
        )
        XCTAssertEqual(besideStory, "What is the main idea of this passage?")
    }

    func testReadingSpeaksOpeningAndPassageOnce() {
        let page = makePage(
            step: .moment(.reading),
            opening: "The tide chart hung by the rocks.",
            passage: "The tide chart hung by the rocks."
        )
        let lines = LessonReadAloudScript.lines(for: page)
        XCTAssertEqual(lines.filter { $0.contains("tide chart") }.count, 1)
    }

    func testReadingKeepsADecimalAmountTogether() {
        let page = makePage(
            step: .moment(.reading),
            opening: "",
            passage: "Mia counted 3.5 cups of water."
        )
        let spoken = joined(LessonReadAloudScript.lines(for: page))
        XCTAssertTrue(spoken.contains("3.5"))
        XCTAssertFalse(spoken.contains("3. 5"))
    }

    func testVocabularySpeaksEachWordAndDefinition() {
        let page = makePage(
            step: .moment(.vocabulary),
            words: [VocabularyWord(word: "Tide pool", definition: "A rocky pool left behind by the tide.")]
        )
        let spoken = joined(LessonReadAloudScript.lines(for: page))
        XCTAssertTrue(spoken.contains("Tide pool"))
        XCTAssertTrue(spoken.contains("rocky pool left behind by the tide"))
    }

    func testMultipleChoiceSpeaksEveryChoiceAndDoesNotAnnounceTheAnswer() {
        let question = LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "Where do the ponies stand?",
            choices: ["In the yard", "In a cave", "On a boat"],
            correctAnswer: "In the yard",
            explanation: "The passage says the ponies stand in the yard."
        )
        let spoken = joined(LessonReadAloudScript.lines(for: makePage(step: .question(.question, question, index: 1, total: 1))))
        XCTAssertTrue(spoken.contains("Where do the ponies stand?"))
        XCTAssertTrue(spoken.contains("In the yard"))
        XCTAssertTrue(spoken.contains("In a cave"))
        XCTAssertTrue(spoken.contains("On a boat"))
        XCTAssertFalse(spoken.localizedCaseInsensitiveContains("correct answer"))
        XCTAssertFalse(spoken.contains("The passage says"))
    }

    func testSortingListDoesNotFollowTheAnswerOrder() {
        let question = LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .sorting,
            prompt: "Put the launch steps in order.",
            items: [
                SortingItem(text: "Crate", correctPosition: 1),
                SortingItem(text: "Apple", correctPosition: 2),
                SortingItem(text: "Bucket", correctPosition: 3)
            ]
        )
        let spoken = joined(LessonReadAloudScript.lines(for: makePage(step: .question(.question, question, index: 1, total: 1))))
        let apple = spoken.range(of: "Apple")
        let bucket = spoken.range(of: "Bucket")
        let crate = spoken.range(of: "Crate")
        XCTAssertNotNil(apple)
        XCTAssertNotNil(bucket)
        XCTAssertNotNil(crate)
        XCTAssertLessThan(apple!.lowerBound, bucket!.lowerBound)
        XCTAssertLessThan(bucket!.lowerBound, crate!.lowerBound)
    }

    func testMatchingSpeaksBothSidesWithoutPairingThem() {
        let question = LessonQuestion(
            subject: .vocabulary,
            type: .multipleChoice,
            responseType: .matching,
            prompt: "Match each word.",
            pairs: [
                MatchingPair(left: "Kelp", right: "A forest of seaweed"),
                MatchingPair(left: "Tide", right: "The rise and fall of the sea")
            ]
        )
        let spoken = joined(LessonReadAloudScript.lines(for: makePage(step: .question(.question, question, index: 1, total: 1))))
        let left = spoken.range(of: "On the left.")!
        let right = spoken.range(of: "On the right.")!
        XCTAssertLessThan(left.lowerBound, right.lowerBound)
        XCTAssertLessThan(spoken.range(of: "Kelp")!.lowerBound, right.lowerBound)
        XCTAssertGreaterThan(spoken.range(of: "A forest of seaweed")!.lowerBound, right.lowerBound)
    }

    func testMysteryHidesCluesThatAreNotOnScreen() {
        let question = mysteryQuestion()
        let spoken = joined(LessonReadAloudScript.lines(for: makePage(
            step: .question(.question, question, index: 1, total: 1),
            revealedClueCount: 0
        )))
        XCTAssertTrue(spoken.contains("A pool is left behind on the rocks."))
        XCTAssertTrue(spoken.contains("Reveal the first clue"))
        XCTAssertFalse(spoken.contains("salty"))
        XCTAssertFalse(spoken.contains("Barnacles"))
        XCTAssertFalse(spoken.contains("swimming pool"))
    }

    func testNewClueSpeaksOnlyThatClueUntilTheLastOne() {
        let question = mysteryQuestion()
        let first = joined(LessonReadAloudScript.newClueLines(question: question, clueNumber: 1))
        XCTAssertTrue(first.contains("salty"))
        XCTAssertFalse(first.contains("Barnacles"))

        let last = joined(LessonReadAloudScript.newClueLines(question: question, clueNumber: 2))
        XCTAssertTrue(last.contains("Barnacles"))
        XCTAssertTrue(last.contains("What kind of pool is this?"))
        XCTAssertTrue(last.contains("A tide pool"))
        XCTAssertFalse(last.contains("salty"))
    }

    func testFeedbackDoesNotRepeatAnExplanationAlreadyInTheHint() {
        let lines = LessonReadAloudScript.feedbackLines(
            message: "Almost! Here's a tip: Look at the tide chart.",
            explanation: "Look at the tide chart."
        )
        XCTAssertEqual(lines.filter { $0.localizedCaseInsensitiveContains("tide chart") }.count, 1)
    }

    func testSpokenPassagesKeepAStoryInOneBreath() {
        let passages = LessonSpeechReader.spokenPassages(from: [
            "The tide chart hung by the rocks.",
            "Kelp swayed in the pool."
        ])
        XCTAssertEqual(passages, [
            "The tide chart hung by the rocks. Kelp swayed in the pool."
        ])
    }

    func testSpokenPassagesPauseBeforeChoices() {
        let passages = LessonSpeechReader.spokenPassages(from: [
            "Where do the ponies stand?",
            "The choices are.",
            "In the yard.",
            "In a cave."
        ])
        XCTAssertEqual(passages, [
            "Where do the ponies stand?",
            "The choices are. In the yard. In a cave."
        ])
    }

    func testFriendlyVoiceUsesAvaWhenInstalled() {
        let voice = LessonSpeechReader.friendlyVoice()
        XCTAssertNotNil(voice)
        let ava = AVSpeechSynthesisVoice.speechVoices().filter { $0.name == "Ava" }
        guard let best = ava.first(where: { $0.quality == .premium })
            ?? ava.first(where: { $0.quality == .enhanced }) else {
            XCTAssertNotEqual(voice?.name, "Bubbles")
            return
        }
        XCTAssertEqual(voice?.identifier, best.identifier)
    }

    func testEarthQuestionIsNotTheStoryTwice() {
        let earth = CuratedTopicLessonBank.readingPack(topic: .planets, level: .beginner)
        XCTAssertEqual(earth?.title, "Earth Is Our Planet")
        let passage = earth?.readingPassage ?? ""
        let prompts = earth?.questions.map(\.prompt) ?? []
        XCTAssertEqual(Set(prompts).count, prompts.count)
        for prompt in prompts {
            XCTAssertFalse(prompt.contains(passage))
            XCTAssertEqual(
                StoryTextDedup.questionBesideStory(prompt, passage: passage),
                prompt
            )
        }
        XCTAssertFalse(StoryTextDedup.openingIsRetold(by: passage, opening: earth?.storyOpening ?? ""))

        let dayNight = CuratedTopicLessonBank.discoveryPack(topic: .space, level: .beginner)
        XCTAssertEqual(dayNight?.title, "Day and Night")
        let notes = dayNight?.readingPassage ?? ""
        XCTAssertEqual(notes.components(separatedBy: "spins").count - 1, 1)
        let earthQuestions = dayNight?.questions.map(\.prompt) ?? []
        XCTAssertEqual(Set(earthQuestions).count, earthQuestions.count)
        XCTAssertFalse(earthQuestions.contains("What makes day and night?"))
    }

    func testFeedbackSpeaksASeparateExplanation() {
        let spoken = joined(LessonReadAloudScript.feedbackLines(
            message: "Great work!",
            explanation: "The passage says the ponies stand in the yard."
        ))
        XCTAssertTrue(spoken.contains("Great work!"))
        XCTAssertTrue(spoken.contains("ponies stand in the yard"))
    }

    private func mysteryQuestion() -> LessonQuestion {
        LessonQuestion.mystery(
            kind: .habitat,
            setup: "A pool is left behind on the rocks.",
            clues: ["The water is salty.", "Barnacles cling to the stone."],
            prompt: "What kind of pool is this?",
            choices: ["A tide pool", "A swimming pool", "A rain puddle"],
            correctAnswer: "A tide pool",
            explanation: "Salt water left by the tide makes a tide pool."
        )
    }

    private func makePage(
        step: LessonStep,
        opening: String = "The reef was bright.",
        passage: String = "Kelp swayed in the tide.",
        words: [VocabularyWord] = [],
        revealedClueCount: Int = 0
    ) -> LessonReadAloudScript.Page {
        LessonReadAloudScript.Page(
            story: LessonStoryContent(
                storyOpening: opening,
                missionPrompt: "Help count the shells.",
                readingPassage: passage,
                readingQuestions: [],
                mathQuestions: [],
                vocabularyWords: words,
                knowledgeFacts: [KnowledgeFact(fact: "A tide chart shows when the water will rise.")],
                creativePrompt: "Draw the tide pool.",
                creativeResponseType: .drawing,
                reflectionPrompt: "What did the tide chart show?",
                reflectionResponseType: .shortText,
                storyEnding: "The pool was calm again."
            ),
            step: step,
            lessonTitle: "Ocean Sighting Day",
            missionCompleteMessage: "You finished the tide pool visit.",
            playKind: nil,
            showsPassageWithQuestion: false,
            includePassageOnReflection: false,
            revealedClueCount: revealedClueCount,
            drawingGoals: [],
            leadIn: ""
        )
    }

    private func joined(_ lines: [String]) -> String {
        lines.joined(separator: " ")
    }
}
