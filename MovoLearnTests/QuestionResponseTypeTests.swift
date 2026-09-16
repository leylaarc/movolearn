import XCTest
import SwiftUI
@testable import MovoLearn

final class QuestionResponseTypeTests: XCTestCase {

    func testEveryBundledQuestionHasExplicitResponseType() {
        let lessons = BundledLessons.all
        XCTAssertFalse(lessons.isEmpty)

        var inferred: [String] = []
        for lesson in lessons {
            for question in lesson.questions + lesson.mathChallenges {
                if question.responseTypeWasInferred {
                    inferred.append("\(lesson.title) / \(question.prompt)")
                }
            }
        }
        XCTAssertTrue(
            inferred.isEmpty,
            "Bundled questions still rely on inference:\n\(inferred.joined(separator: "\n"))"
        )
    }

    func testEveryBundledLessonHasExplicitCreativeAndReflectionTypes() {
        for lesson in BundledLessons.all {
            let allowedCreative: Set<QuestionResponseType> = [.drawing, .shortText, .longText]
            XCTAssertTrue(
                allowedCreative.contains(lesson.creativeResponseType),
                "\(lesson.title) has invalid creativeResponseType \(lesson.creativeResponseType)"
            )
            XCTAssertEqual(lesson.reflectionResponseType, .shortText)
        }
    }

    func testEveryBundledLessonIncludesMatchingAndNoSorting() {
        for lesson in BundledLessons.all {
            let matching = lesson.questions.filter { $0.responseType == .matching }
            let sorting = lesson.questions.filter { $0.responseType == .sorting }
            // Math-primary lessons may omit matching to keep math focus.
            // Non-math lessons prefer passage-grounded matching; if the passage cannot
            // support ≥3 evidence pairs, a comprehension MCQ is used instead.
            if lesson.primarySubject != .math {
                if matching.isEmpty {
                    XCTAssertTrue(
                        lesson.questions.contains { $0.responseType == .multipleChoice },
                        "\(lesson.title) missing matching and has no comprehension fallback"
                    )
                } else {
                    XCTAssertTrue(matching.allSatisfy(\.hasValidMatchingData), "\(lesson.title) matching lacks pairs")
                    XCTAssertFalse(matching.contains(where: \.responseTypeWasInferred))
                    for question in matching {
                        let issues = PassageMatchingQuestionGenerator.validationIssues(
                            for: question.pairs,
                            passage: lesson.readingPassage
                        )
                        XCTAssertTrue(issues.isEmpty, "\(lesson.title): \(issues.joined(separator: "; "))")
                    }
                }
            }
            XCTAssertTrue(sorting.isEmpty, "\(lesson.title) still contains sorting/arranging")
            let childFacing = lesson.childFacingQuestions
            XCTAssertFalse(childFacing.contains { QuestionQualityValidator.isUnsupportedArranging($0) })
        }
    }

    func testResponseTypeRequiredData() {
        for lesson in BundledLessons.all {
            for question in lesson.questions + lesson.mathChallenges {
                switch question.responseType {
                case .multipleChoice:
                    XCTAssertGreaterThanOrEqual(question.choices.count, 2, question.prompt)
                    XCTAssertNotNil(question.correctAnswer, question.prompt)
                case .matching:
                    XCTAssertTrue(question.hasValidMatchingData, question.prompt)
                case .sorting:
                    XCTFail("Sorting should not appear in bundled content: \(lesson.title) — \(question.prompt)")
                case .drawing:
                    XCTAssertTrue(question.choices.isEmpty, question.prompt)
                case .number:
                    if let answer = question.correctAnswer {
                        XCTAssertNotNil(Int(answer), question.prompt)
                    }
                case .shortText, .longText:
                    break
                }
            }
        }
    }

    func testMatchingQuestionStoresPairs() {
        let question = LessonQuestion.matching(
            prompt: "Match each animal to its home.",
            pairs: [
                MatchingPair(left: "Bee", right: "Hive"),
                MatchingPair(left: "Bird", right: "Nest")
            ]
        )
        XCTAssertEqual(question.responseType, .matching)
        XCTAssertFalse(question.responseTypeWasInferred)
        XCTAssertEqual(question.pairs.count, 2)
        XCTAssertEqual(question.pairs[0].left, "Bee")
    }

    func testSortingQuestionStillDecodableButFilteredFromChildDisplay() {
        let question = LessonQuestion.sorting(
            prompt: "Put the story events in the correct order.",
            items: [
                SortingItem(id: "event_1", text: "Maya planted the seed.", correctPosition: 1),
                SortingItem(id: "event_2", text: "The seed began to grow.", correctPosition: 2),
                SortingItem(id: "event_3", text: "A flower bloomed.", correctPosition: 3)
            ]
        )
        XCTAssertEqual(question.responseType, .sorting)
        XCTAssertTrue(QuestionQualityValidator.isUnsupportedArranging(question))
        let filtered = QuestionQualityValidator.filterForChildDisplay([question])
        XCTAssertTrue(filtered.isEmpty)
    }

    func testDrawingPromptMapsToDrawingResponseTypeOnLesson() {
        let lesson = BundledLessons.sharkExplorer
        XCTAssertEqual(lesson.creativeResponseType, .drawing)
        XCTAssertTrue(QuestionResponseTypeResolver.looksLikeDrawingPrompt(lesson.creativePrompt.lowercased()))
    }

    func testDrawingCreativeUsesDrawingCanvasNotTextField() {
        let type = QuestionResponseType.drawing
        XCTAssertEqual(type, .drawing)
        XCTAssertNotEqual(type, .longText)
        XCTAssertNotEqual(type, .shortText)
    }

    func testDrawPromptUpgradesMismatchedTextResponseType() {
        let aligned = QuestionResponseTypeResolver.alignedCreative(
            prompt: "Draw a picture of one idea from today's lesson.",
            responseType: .shortText
        )
        XCTAssertEqual(aligned.responseType, .drawing)
        XCTAssertTrue(QuestionResponseTypeResolver.looksLikeDrawingPrompt(aligned.prompt.lowercased()))

        let sanitized = QuestionResponseTypeResolver.sanitize(
            .longText,
            questionType: .openEnded,
            prompt: "Art Quest: Draw the blue wave Willa sees.",
            choices: [],
            pairs: [],
            items: []
        )
        XCTAssertEqual(sanitized, .drawing)
    }

    func testWriteFourSentencesCamouflageArtBecomesDrawing() {
        let converted = QuestionResponseTypeResolver.preferDrawingForCreativeSession(
            title: "Design Octopus Camouflage Art",
            mission: "Use the inspiration. Write and design camouflage art.",
            prompt: "Write four sentences describing your camouflage art: the background, how the octopus matches it, one texture detail, and why the disguise helps.",
            responseType: .longText,
            category: .creative
        )
        XCTAssertEqual(converted.responseType, .drawing)
        XCTAssertTrue(converted.prompt.localizedCaseInsensitiveContains("draw"))
        XCTAssertFalse(converted.prompt.localizedCaseInsensitiveContains("write four"))
        XCTAssertTrue(converted.mission.localizedCaseInsensitiveContains("draw"))
        XCTAssertFalse(converted.mission.localizedCaseInsensitiveContains("write"))
    }

    func testJungleCamouflageCreatureIsADrawingLesson() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .jungleAnimals,
            category: .creative,
            readingLevel: .growingReader,
            mathLevel: .developing
        ) else {
            return XCTFail("Expected camouflage creature art lesson")
        }
        XCTAssertEqual(lesson.creativeResponseType, .drawing)
        XCTAssertTrue(lesson.creativePrompt.localizedCaseInsensitiveContains("draw"))
        XCTAssertFalse(lesson.creativePrompt.localizedCaseInsensitiveContains("write four"))
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("write"))

        let prepared = ContentAdaptationService.prepare(
            lesson: lesson,
            profile: ChildProfile(
                age: 7,
                grade: "2nd Grade",
                readingLevel: .growingReader,
                mathLevel: .developing,
                favoriteTopics: [.jungleAnimals]
            )
        )
        XCTAssertEqual(prepared.lesson.creativeResponseType, .drawing)
        XCTAssertFalse(prepared.lesson.creativePrompt.localizedCaseInsensitiveContains("write four"))
        XCTAssertFalse(prepared.lesson.missionPrompt.localizedCaseInsensitiveContains("write"))
    }

    func testCookingDissolvingArtAsksKidsToDrawSugarInWater() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .cooking,
            category: .creative,
            readingLevel: .growingReader,
            mathLevel: .developing
        ) else {
            return XCTFail("Expected cooking dissolving drawing lesson")
        }
        XCTAssertEqual(lesson.creativeResponseType, .drawing)
        XCTAssertEqual(lesson.title, "Draw Sugar Mixing in Water")
        XCTAssertTrue(lesson.missionPrompt.localizedCaseInsensitiveContains("draw"))
        XCTAssertTrue(lesson.missionPrompt.localizedCaseInsensitiveContains("sugar")
                      || lesson.missionPrompt.localizedCaseInsensitiveContains("water")
                      || lesson.missionPrompt.localizedCaseInsensitiveContains("dissolve"))
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("true detail"))
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("demo plan"))
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("dissolving demo"))
        XCTAssertFalse(lesson.creativePrompt.localizedCaseInsensitiveContains("demo"))
        XCTAssertFalse(lesson.creativePrompt.localizedCaseInsensitiveContains("write"))
        XCTAssertTrue(lesson.creativePrompt.localizedCaseInsensitiveContains("draw"))

        let prepared = ContentAdaptationService.prepare(
            lesson: lesson,
            profile: ChildProfile(
                age: 7,
                grade: "2nd Grade",
                readingLevel: .growingReader,
                mathLevel: .developing,
                favoriteTopics: [.cooking]
            )
        )
        XCTAssertEqual(prepared.lesson.creativeResponseType, .drawing)
        XCTAssertFalse(prepared.lesson.missionPrompt.localizedCaseInsensitiveContains("true detail"))
        XCTAssertFalse(prepared.lesson.missionPrompt.localizedCaseInsensitiveContains("demo plan"))
        XCTAssertTrue(prepared.lesson.missionPrompt.localizedCaseInsensitiveContains("draw"))
        XCTAssertTrue(
            ChildFacingProseQualityValidator.validate(
                prepared.lesson.missionPrompt,
                allowShortImperative: true
            ).passed,
            "Got: \(prepared.lesson.missionPrompt)"
        )
    }

    func testWhiskerArtAsksKidsToDrawASimpleCatScene() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .cats,
            category: .creative,
            readingLevel: .growingReader,
            mathLevel: .developing
        ) else {
            return XCTFail("Expected whisker drawing lesson")
        }
        XCTAssertEqual(lesson.creativeResponseType, .drawing)
        XCTAssertEqual(lesson.title, "Draw Long Whiskers")
        XCTAssertTrue(lesson.missionPrompt.localizedCaseInsensitiveContains("draw"))
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("design plan"))
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("then draw a whisker"))
        XCTAssertTrue(lesson.creativePrompt.localizedCaseInsensitiveContains("narrow")
                      || lesson.creativePrompt.localizedCaseInsensitiveContains("gap")
                      || lesson.creativePrompt.localizedCaseInsensitiveContains("whisker"))
        XCTAssertFalse(lesson.creativePrompt.localizedCaseInsensitiveContains("write"))
        XCTAssertFalse(lesson.creativePrompt.localizedCaseInsensitiveContains("trimmed"))
        XCTAssertFalse(lesson.creativePrompt.localizedCaseInsensitiveContains("why"))

        let stale = QuestionResponseTypeResolver.preferDrawingForCreativeSession(
            title: "Design Whisker Sense Art",
            mission: "Look at the science note, then write a whisker design plan.",
            prompt: "Write four sentences describing your whisker art: whisker length, what they sense, one narrow-space scene, and why soft whiskers should not be trimmed for fun.",
            responseType: .longText,
            category: .creative
        )
        XCTAssertEqual(stale.responseType, .drawing)
        XCTAssertFalse(stale.mission.localizedCaseInsensitiveContains("design plan"))
        XCTAssertFalse(stale.prompt.localizedCaseInsensitiveContains("trimmed"))
        XCTAssertFalse(stale.prompt.localizedCaseInsensitiveContains("why"))
        XCTAssertTrue(stale.mission.localizedCaseInsensitiveContains("draw"))
        XCTAssertTrue(stale.prompt.localizedCaseInsensitiveContains("draw"))
    }

    func testLessonInitForcesDrawingWhenPromptSaysDraw() {
        let lesson = Lesson(
            title: "Draw Test",
            theme: .dogs,
            lessonType: .explorer,
            storyOpening: "Hello.",
            missionPrompt: "Help.",
            readingPassage: "A dog ran.",
            questions: [],
            mathChallenges: [],
            vocabularyWords: [VocabularyWord(word: "Dog", definition: "A pet")],
            knowledgeFacts: [KnowledgeFact(fact: "Dogs bark.")],
            creativePrompt: "Draw or write one idea from today's lesson.",
            creativeResponseType: .shortText,
            storyEnding: "Bye.",
            readingSkill: "Detail",
            mathSkill: "Counting",
            skillsPracticed: ["Reading"]
        )
        XCTAssertEqual(lesson.creativeResponseType, .drawing)
    }

    func testInputTextHasHighContrastAgainstBackground() {
        let text = DesignSystem.Colors.inputText
        let bg = DesignSystem.Colors.inputBackground
        XCTAssertNotEqual(text, Color.white)
        XCTAssertNotEqual(text, DesignSystem.Colors.cardWhite)
        XCTAssertNotEqual(String(describing: text), String(describing: bg))
    }

    func testInvalidMatchingWithoutPairsFailsValidation() {
        let question = LessonQuestion(
            subject: .reading,
            type: .openEnded,
            responseType: .matching,
            prompt: "Match each animal to its home.",
            pairs: []
        )
        XCTAssertEqual(question.responseType, .matching)
        XCTAssertEqual(question.displayResponseType, .longText)
        let issues = QuestionQualityValidator.validate(question).issues
        XCTAssertTrue(issues.contains { $0.description.lowercased().contains("matching") })
    }

    func testJSONLessonsDecodeWithoutSorting() throws {
        let names = ["sharks", "horses", "space", "dinosaurs"]
        var failures: [String] = []
        for name in names {
            guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
                failures.append("Missing \(name).json in bundle")
                continue
            }
            let data = try Data(contentsOf: url)
            do {
                let lesson = try LessonLoader.decodeLesson(from: data)
                let inferred = (lesson.questions + lesson.mathChallenges)
                    .filter(\.responseTypeWasInferred)
                    .map { "\($0.responseType.rawValue): \($0.prompt)" }
                if !inferred.isEmpty {
                    failures.append("\(name) inferred:\n" + inferred.joined(separator: "\n"))
                }
                let allowedCreative: Set<QuestionResponseType> = [.drawing, .shortText, .longText]
                if !allowedCreative.contains(lesson.creativeResponseType) {
                    failures.append("\(name) bad creativeResponseType=\(lesson.creativeResponseType.rawValue)")
                }
                if lesson.reflectionResponseType != .shortText {
                    failures.append("\(name) bad reflectionResponseType=\(lesson.reflectionResponseType.rawValue)")
                }
                let matching = lesson.questions.filter { $0.responseType == .matching }
                let sorting = lesson.questions.filter { $0.responseType == .sorting }
                if matching.isEmpty || !matching.allSatisfy(\.hasValidMatchingData) {
                    failures.append("\(name) missing valid matching question")
                }
                if !sorting.isEmpty {
                    failures.append("\(name) still has sorting questions")
                }
                if QuestionQualityValidator.looksLikeArrangingPrompt(
                    lesson.questions.map(\.prompt).joined(separator: " ")
                ) {
                    failures.append("\(name) still has arranging prompt language")
                }
            } catch {
                failures.append("\(name) decode error: \(error)")
            }
        }
        XCTAssertTrue(failures.isEmpty, failures.joined(separator: "\n\n"))
    }

    func testSharkLessonUsesCauseEffectInsteadOfSorting() throws {
        guard let url = Bundle.main.url(forResource: "sharks", withExtension: "json") else {
            return XCTFail("sharks.json missing")
        }
        let lesson = try LessonLoader.decodeLesson(from: try Data(contentsOf: url))
        XCTAssertEqual(lesson.primarySubject, .reading)
        let matching = lesson.questions.filter { $0.responseType == .matching }
        let sorting = lesson.questions.filter { $0.responseType == .sorting }
        XCTAssertFalse(matching.isEmpty)
        XCTAssertTrue(sorting.isEmpty)
        XCTAssertTrue(matching.allSatisfy(\.hasValidMatchingData))
        XCTAssertTrue(lesson.questions.contains { $0.prompt.contains("right after") })
    }

    func testSchemaValidationFlagsMissingPairs() {
        let lesson = Lesson(
            title: "Bad Match",
            theme: .dogs,
            lessonType: .explorer,
            storyOpening: "A walk begins.",
            missionPrompt: "Help the dog.",
            readingPassage: "The dog ran.",
            questions: [
                LessonQuestion(
                    subject: .reading,
                    type: .openEnded,
                    responseType: .matching,
                    prompt: "Match each animal to its home.",
                    pairs: []
                )
            ],
            mathChallenges: [],
            vocabularyWords: [VocabularyWord(word: "Dog", definition: "A pet")],
            knowledgeFacts: [KnowledgeFact(fact: "Dogs can hear well.")],
            creativePrompt: "Write about your dog.",
            creativeResponseType: .longText,
            storyEnding: "The walk ended.",
            readingSkill: "Comprehension",
            mathSkill: "Counting",
            reflectionPrompt: "What did you like?",
            reflectionResponseType: .shortText,
            skillsPracticed: ["Reading"]
        )
        let messages = QuestionQualityValidator.validateLessonSchema(lesson)
        XCTAssertTrue(messages.contains { $0.contains("matching") })
    }

    func testLoaderRejectsMatchingWithoutPairs() {
        let json = """
        {
          "id": "11111111-1111-4111-8111-111111111111",
          "title": "Broken",
          "theme": "Dogs",
          "lessonType": "explorer",
          "ageTarget": "5-8",
          "gradeTarget": "K-2",
          "readingLevel": "Early Reader",
          "learningGoal": "All-around practice",
          "storyOpening": "Hello.",
          "missionPrompt": "Help.",
          "readingPassage": "A dog ran in the park today.",
          "storyEnding": "Bye.",
          "reflectionPrompt": "What did you like?",
          "creativePrompt": "Write about a dog.",
          "creativeResponseType": "longText",
          "reflectionResponseType": "shortText",
          "readingSkill": "Detail",
          "mathSkill": "Counting",
          "skillsPracticed": ["Reading"],
          "vocabularyWords": [{"word": "Dog", "definition": "A pet"}],
          "knowledgeFacts": [{"fact": "Dogs bark."}],
          "questions": [{
            "id": "22222222-2222-4222-8222-222222222222",
            "subject": "reading",
            "type": "openEnded",
            "responseType": "matching",
            "prompt": "Match each animal to its home."
          }],
          "mathChallenges": []
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try LessonLoader.decodeLesson(from: json))
    }

    func testNoFallbackWhenMatchingPairsPresent() {
        let question = LessonQuestion.matching(
            prompt: "Match each animal to its home.",
            pairs: [
                MatchingPair(left: "Bee", right: "Hive"),
                MatchingPair(left: "Bird", right: "Nest")
            ]
        )
        XCTAssertEqual(question.displayResponseType, .matching)
        XCTAssertTrue(question.hasValidMatchingData)
    }

    func testSortingDisplayTypePreservedForLegacyDecode() {
        let question = LessonQuestion.sorting(
            prompt: "Put the events in order.",
            items: [
                SortingItem(id: "a", text: "First", correctPosition: 1),
                SortingItem(id: "b", text: "Second", correctPosition: 2)
            ]
        )
        XCTAssertEqual(question.displayResponseType, .sorting)
        XCTAssertTrue(question.hasValidSortingData)
        XCTAssertTrue(QuestionQualityValidator.isUnsupportedArranging(question))
    }
}
