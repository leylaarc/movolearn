import XCTest
@testable import MovoLearn

final class MathQuestionVarietyTests: XCTestCase {

    func testDifferentTopicsDoNotShareTheSameArithmeticExplanations() {
        let topics: [Topic] = [
            .horses, .jungleAnimals, .sharks, .soccer, .dogs, .space, .dinosaurs, .pirates
        ]
        let mathLevels: [MathLevel] = [.emerging, .developing, .secure, .advancing]

        for mathLevel in mathLevels {
            var perTopicEquations: [String: [String]] = [:]
            var explanationToTopics: [String: Set<String>] = [:]
            for topic in topics {
                guard let scene = CuratedTopicLessonBank.mathScene(
                    topic: topic,
                    mathLevel: mathLevel,
                    readingLevel: .earlyReader
                ) else {
                    XCTFail("Missing math scene for \(topic.rawValue) @ \(mathLevel.rawValue)")
                    continue
                }
                XCTAssertGreaterThanOrEqual(scene.problems.count, 3)
                let keys = scene.problems.compactMap { problem -> String? in
                    let key = normalizedEquation(problem.explanation ?? "")
                    guard !key.isEmpty else { return nil }
                    // Focus on true arithmetic skeletons (the old clone failure mode).
                    guard key.contains("+") || key.contains("-") || key.contains("x") || key.contains("/") else {
                        return nil
                    }
                    explanationToTopics[key, default: []].insert(topic.rawValue)
                    return key
                }
                perTopicEquations[topic.rawValue] = keys
            }

            // Old bug: every topic reused the exact same equation list.
            let uniqueLists = Set(perTopicEquations.values.map { $0.joined(separator: "|") })
            XCTAssertGreaterThan(
                uniqueLists.count,
                1,
                "Math level \(mathLevel.rawValue) still uses one shared equation list across topics"
            )

            let heavilyShared = explanationToTopics.filter { $0.value.count >= 5 }
            XCTAssertTrue(
                heavilyShared.isEmpty,
                "Math level \(mathLevel.rawValue) still clones equations across topics: \(heavilyShared)"
            )
        }
    }

    func testSameTopicDifferentMathLevelsUseDifferentNumberSets() {
        let emerging = CuratedTopicLessonBank.mathScene(
            topic: .horses,
            mathLevel: .emerging,
            readingLevel: .beginner
        )
        let advancing = CuratedTopicLessonBank.mathScene(
            topic: .horses,
            mathLevel: .advancing,
            readingLevel: .confidentReader
        )
        XCTAssertNotNil(emerging)
        XCTAssertNotNil(advancing)
        let emergingEquations = Set((emerging?.problems ?? []).compactMap { normalizedEquation($0.explanation ?? "") })
        let advancingEquations = Set((advancing?.problems ?? []).compactMap { normalizedEquation($0.explanation ?? "") })
        XCTAssertTrue(
            emergingEquations.isDisjoint(with: advancingEquations),
            "Emerging and advancing should not reuse the same equations"
        )
    }

    func testGeneratedWordProblemsAgreeInNumber() {
        var failures: [String] = []
        var sawSingularChicken = false
        let readings: [ReadingLevel] = [.beginner, .earlyReader, .growingReader, .confidentReader]
        for topic in Topic.allCases {
            for math in MathLevel.allCases {
                for reading in readings {
                    for age in [5, 7] {
                        let seed = MathWordProblemGenerator.varietySeed(
                            topic: topic,
                            mathLevel: math,
                            readingLevel: reading
                        ) &+ age
                        let questions = MathWordProblemGenerator.generateQuestions(
                            topic: topic,
                            seed: seed,
                            level: reading,
                            mathLevel: math,
                            count: 4,
                            age: age
                        ) + MathWordProblemGenerator.generateGroupingQuestions(
                            topic: topic,
                            seed: seed,
                            level: reading,
                            mathLevel: math,
                            count: 3,
                            age: age
                        )
                        for question in questions {
                            let fields = [question.prompt, question.explanation].compactMap { $0 }
                            for field in fields {
                                let result = ChildFacingProseQualityValidator.validate(
                                    field,
                                    allowShortImperative: true
                                )
                                if !result.passed {
                                    failures.append(
                                        "\(topic.rawValue) \(math.rawValue) age \(age): \(field) :: \(result.issues.map(\.description).joined(separator: "; "))"
                                    )
                                }
                                if field.localizedCaseInsensitiveContains("one chicken was")
                                    || field.localizedCaseInsensitiveContains("there was 1 chicken") {
                                    sawSingularChicken = true
                                }
                            }
                        }
                    }
                }
            }
        }
        for seed in 0..<60 {
            let questions = MathWordProblemGenerator.generateQuestions(
                topic: .farmAnimals,
                seed: seed,
                level: .beginner,
                mathLevel: .emerging,
                count: 4,
                age: 5
            )
            for question in questions where question.prompt.localizedCaseInsensitiveContains("chicken") {
                XCTAssertFalse(
                    question.prompt.localizedCaseInsensitiveContains("chicken were"),
                    question.prompt
                )
                if question.prompt.localizedCaseInsensitiveContains("one chicken was")
                    || question.prompt.localizedCaseInsensitiveContains("there was 1 chicken") {
                    sawSingularChicken = true
                }
            }
        }
        XCTAssertTrue(sawSingularChicken, "Expected a singular chicken sentence such as \"One chicken was pecking\".")
        XCTAssertTrue(
            failures.isEmpty,
            failures.prefix(12).joined(separator: "\n")
        )
    }

    func testGeneratorProducesDistinctEquationsAcrossTopicSeeds() {
        let topics: [Topic] = [.horses, .sharks, .space, .cooking, .robots, .fairies]
        var allEquations = Set<String>()
        var uniqueCount = 0
        for topic in topics {
            let seed = MathWordProblemGenerator.varietySeed(
                topic: topic,
                mathLevel: .developing,
                readingLevel: .earlyReader
            )
            let questions = MathWordProblemGenerator.generateQuestions(
                topic: topic,
                seed: seed,
                level: .earlyReader,
                mathLevel: .developing,
                count: 4
            )
            XCTAssertEqual(questions.count, 4)
            for question in questions {
                let key = normalizedEquation(question.explanation ?? "")
                if allEquations.insert(key).inserted {
                    uniqueCount += 1
                }
            }
        }
        // 6 topics × 4 questions = 24; expect most equations to be unique
        XCTAssertGreaterThanOrEqual(uniqueCount, 16, "Expected wide numeric variety across topics, got \(uniqueCount)")
    }

    func testDevelopingMathDrawingPromptsAreNotClonedAsDrawNine() {
        let topics: [Topic] = [
            .horses, .jungleAnimals, .sharks, .soccer, .dogs, .cooking, .robots, .fairies
        ]
        var prompts: [String] = []
        var drawNineCount = 0
        for topic in topics {
            guard let scene = CuratedTopicLessonBank.mathScene(
                topic: topic,
                mathLevel: .developing,
                readingLevel: .earlyReader
            ) else {
                XCTFail("Missing math scene for \(topic.rawValue)")
                continue
            }
            prompts.append(scene.creativePrompt)
            XCTAssertTrue(
                QuestionResponseTypeResolver.looksLikeDrawingPrompt(scene.creativePrompt.lowercased()),
                "Expected a drawing prompt for \(topic.rawValue), got \(scene.creativePrompt)"
            )
            XCTAssertTrue(
                ChildFacingProseQualityValidator.passes(scene.creativePrompt, allowShortImperative: true),
                "Drawing prompt failed prose checks: \(scene.creativePrompt)"
            )
            if scene.creativePrompt.lowercased().contains("draw 9 ") {
                drawNineCount += 1
            }
        }
        XCTAssertLessThan(
            drawNineCount,
            3,
            "Developing math drawing still clones 'Draw 9' across topics: \(prompts)"
        )
        XCTAssertGreaterThan(
            Set(prompts).count,
            4,
            "Drawing prompts should change with the topic, not repeat one count-the-objects line: \(prompts)"
        )
    }

    func testEmergingMathDrawingCountsAreNotAllFour() {
        let topics: [Topic] = [.horses, .sharks, .soccer, .dogs, .cooking, .robots]
        let prompts = topics.compactMap {
            CuratedTopicLessonBank.mathScene(
                topic: $0,
                mathLevel: .emerging,
                readingLevel: .beginner
            )?.creativePrompt
        }
        XCTAssertEqual(prompts.count, topics.count)
        let drawFourCount = prompts.filter { $0.lowercased().contains("draw 4 ") }.count
        XCTAssertLessThan(drawFourCount, topics.count, "Emerging drawing still clones 'Draw 4': \(prompts)")
        XCTAssertGreaterThan(Set(prompts).count, 1, "Emerging drawing prompts should vary: \(prompts)")
    }

    func testMathDrawingPromptsDoNotAskKidsToCircleAsTheyCount() {
        let banned = [
            "circle them as you count",
            "circle them when you count",
            "circle both groups as you add",
            "circle each as you count",
            "circle each one as you count"
        ]
        func assertClean(_ text: String, label: String) {
            let displayed = PromptWordingNormalizer.normalize(text)
            let blob = "\(text) \(displayed)".lowercased()
            for phrase in banned {
                XCTAssertFalse(blob.contains(phrase), "\(label) still asks kids to circle while counting: \(text)")
            }
        }
        for topic in Topic.allCases {
            for level in MathLevel.allCases {
                guard let scene = CuratedTopicLessonBank.mathScene(
                    topic: topic,
                    mathLevel: level,
                    readingLevel: .beginner
                ) else {
                    continue
                }
                assertClean(scene.creativePrompt, label: "\(topic.rawValue) @ \(level.rawValue) drawing")
                for problem in scene.problems {
                    assertClean(problem.prompt, label: "\(topic.rawValue) @ \(level.rawValue) question")
                }
                for hint in scene.hints {
                    assertClean(hint, label: "\(topic.rawValue) @ \(level.rawValue) hint")
                }
            }
        }
    }

    func testStaleCircleWhileCountingPromptsAreStrippedBeforeKidsSeeThem() {
        let stale = [
            "Draw 5 roses in the castle garden and circle them as you count.",
            "Draw 4 ponies by a fence. Circle them as you count.",
            "Draw 3 fish by coral. Then draw 2 more fish. Circle both groups as you add."
        ]
        for prompt in stale {
            let cleaned = PromptWordingNormalizer.normalize(prompt)
            XCTAssertFalse(
                cleaned.lowercased().contains("circle"),
                "Stale circling instruction still shown: \(cleaned)"
            )
            XCTAssertTrue(
                cleaned.lowercased().hasPrefix("draw"),
                "Drawing instruction should remain: \(cleaned)"
            )
        }
    }

    func testSecureGroupingMathUsesTheStoryGroupSize() {
        let topics: [Topic] = [.cooking, .sharks, .soccer, .horses, .space]
        var sizes = Set<Int>()
        for topic in topics {
            guard let scene = CuratedTopicLessonBank.mathScene(
                topic: topic,
                mathLevel: .secure,
                readingLevel: .earlyReader
            ) else {
                XCTFail("Missing secure math for \(topic.rawValue)")
                continue
            }
            let blob = scene.problems.map(\.prompt).joined(separator: " ").lowercased()
            guard let size = MissionPromptNormalizer.groupSize(in: scene.missionPrompt)
                    ?? MissionPromptNormalizer.groupSize(in: scene.readingPassage) else {
                XCTFail("\(topic.rawValue) never names a group size")
                continue
            }
            sizes.insert(size)
            XCTAssertEqual(
                MissionPromptNormalizer.groupSize(in: blob),
                size,
                "\(topic.rawValue) math should ask about groups of \(size). Got: \(blob)"
            )
        }
        XCTAssertGreaterThanOrEqual(sizes.count, 2, "Grouping sizes should vary. Got: \(sizes)")
    }

    private func normalizedEquation(_ explanation: String) -> String {
        explanation
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "×", with: "x")
            .replacingOccurrences(of: "÷", with: "/")
            .filter { $0.isNumber || "+-x/=,".contains($0) }
    }
}
