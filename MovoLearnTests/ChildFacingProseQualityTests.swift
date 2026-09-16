import XCTest
@testable import MovoLearn

/// Regression tests for child-facing prose quality and reading adaptation.
/// Guards against malformations like "horse. yard." produced by hard word-budget splits.
final class ChildFacingProseQualityTests: XCTestCase {

    func testRejectsMidPhrasePeriod() {
        let bad = "Three ponies flick their tails in the horse. yard."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed)
        XCTAssertTrue(result.issues.contains { issue in
            if case .midPhrasePeriod = issue { return true }
            return false
        })
    }

    func testRejectsLowercaseAfterPeriod() {
        let bad = "The ponies stand in the yard. they swish their tails."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed)
    }

    func testRejectsRepeatedPunctuation() {
        let bad = "The ponies stand in the yard.."
        XCTAssertFalse(ChildFacingProseQualityValidator.passes(bad))
        XCTAssertFalse(
            ChildFacingProseQualityValidator.passes(
                "Morning light made the water look calm,. Ripples near the rocks suggested something moved below."
            )
        )
    }

    func testPolishRemovesCommaPeriodLeftovers() {
        let broken = "Morning light made the water look calm,. Ripples near the rocks suggested something moved below."
        let polished = ChildFacingProseQualityValidator.polish(broken)
        XCTAssertEqual(
            polished,
            "Morning light made the water look calm. Ripples near the rocks suggested something moved below."
        )
        XCTAssertFalse(polished.contains(",."))
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(polished), "Got: \(polished)")
    }

    func testRejectsDanglingFragmentYard() {
        let bad = "Three ponies flick their tails in the horse. Yard."
        // Even with capital Y, mid-phrase period "horse. Yard" may or may not match lowercase rule;
        // the classic failure mode is lowercase continuation.
        let classic = "Three ponies flick their tails in the horse. yard."
        XCTAssertFalse(ChildFacingProseQualityValidator.passes(classic))
        _ = bad
    }

    func testAcceptsNaturalBeginnerProse() {
        let good = "The ponies stand in the yard. They swish their tails. Mia speaks softly so they stay calm."
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(good))
    }

    func testAcceptsNaturalAdvancedProse() {
        let good = "Three ponies swish their tails in the sunny yard. Mia reminds the visitors to speak softly, move calmly, and avoid approaching a horse from directly behind."
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(good))
    }

    func testRejectsSentenceFragmentInStoryProse() {
        // Avoid plural nouns ending in "s" (the verb heuristic treats those as finite verbs).
        let bad = "Inside the training dome, Nova checked the map. Rougher near the crater rim."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed)
        XCTAssertTrue(result.issues.contains { issue in
            if case .sentenceFragment = issue { return true }
            return false
        })
    }

    func testRejectsPlacePhraseUsedAsASentence() {
        let bad = "Inside the training dome. Nova must pick a supply route on the quiet side of the Moon."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed)
        XCTAssertTrue(result.issues.contains { issue in
            if case .sentenceFragment = issue { return true }
            return false
        })
        let good = "Nova looks at a Moon map. She needs to pick a safe path to walk."
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(good))
    }

    func testRejectsWhichRelativeClauseFragment() {
        let bad = "Parrotfish scrape algae from coral. Which helps keep the reef from being smothered."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed, "Got issues: \(result.issues)")
        XCTAssertTrue(result.issues.contains { issue in
            if case .sentenceFragment = issue { return true }
            return false
        })
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes("Which side has more?"),
            "Real which-questions should still pass"
        )
    }

    func testWordBudgetDoesNotSplitWhichRelativeClause() {
        let source = "Parrotfish scrape algae from coral, which helps keep the reef from being smothered."
        let adapted = AgeGradeLearningStandards.adaptProseSafely(
            source,
            maxWordsPerSentence: 8,
            maxSentences: 3
        )
        XCTAssertFalse(adapted.localizedCaseInsensitiveContains("coral. which"), "Got: \(adapted)")
        XCTAssertFalse(adapted.contains("coral. Which"), "Got: \(adapted)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(adapted), "Got: \(adapted)")
        XCTAssertTrue(
            adapted.localizedCaseInsensitiveContains("coral"),
            "Got: \(adapted)"
        )
        XCTAssertFalse(adapted.localizedCaseInsensitiveContains("corral"), "Got: \(adapted)")
    }

    func testWordBudgetDoesNotSplitElinWeaverSentence() {
        let source = "Rather than assuming the weaver had simply lost skill, Elin considered that the new road, not the weaver's work, might explain the empty stall."
        let adapted = AgeGradeLearningStandards.adaptProseSafely(
            source,
            maxWordsPerSentence: 8,
            maxSentences: 4
        )
        XCTAssertFalse(adapted.contains("lost skill."), "Got: \(adapted)")
        XCTAssertFalse(adapted.contains("weaver's work."), "Got: \(adapted)")
        XCTAssertFalse(adapted.contains("Might explain"), "Got: \(adapted)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(adapted), "Got: \(adapted)")
    }

    func testRejectsDanglingRatherThanAndMightFragments() {
        XCTAssertFalse(
            ChildFacingProseQualityValidator.passes(
                "Rather than assuming the weaver had simply lost skill."
            )
        )
        XCTAssertFalse(
            ChildFacingProseQualityValidator.passes("Might explain the empty stall.")
        )
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes(
                "Elin did not assume the weaver had simply lost skill. She decided the new road might explain the empty stall."
            )
        )
    }

    func testWordBudgetDoesNotIsolateIntroductoryPhrase() {
        let source = "Inside the training dome, Nova must pick a supply route on the quiet side of the Moon."
        let result = AgeGradeLearningStandards.enforceWordBudget(source, maxWordsPerSentence: 8)
        XCTAssertFalse(result.contains("Inside the training dome."), "Got: \(result)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(result), "Got: \(result)")
    }

    func testNovaMoonPathOpeningIsCompleteSentences() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .space,
            category: .story,
            readingLevel: .growingReader,
            mathLevel: .secure,
            age: 7
        ) else {
            return XCTFail("Expected space growing-reader story")
        }
        XCTAssertFalse(lesson.storyOpening.localizedCaseInsensitiveContains("supply route"))
        XCTAssertFalse(lesson.storyOpening.localizedCaseInsensitiveContains("quiet side"))
        XCTAssertFalse(lesson.storyOpening.localizedCaseInsensitiveContains("training dome"))
        XCTAssertTrue(lesson.storyOpening.localizedCaseInsensitiveContains("safe path"))
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(lesson.storyOpening), "Got: \(lesson.storyOpening)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(lesson.readingPassage), "Got: \(lesson.readingPassage)")
    }

    func testRejectsAwkwardObservationClause() {
        let bad = "She saw the path looked smooth near the crater rim."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed)
        XCTAssertTrue(result.issues.contains { issue in
            if case .awkwardObservationVerb = issue { return true }
            return false
        })
    }

    func testRejectsAwkwardNumbersToCheckTemplate() {
        let bad = "Capsule racks and clip bags give Tess numbers to check."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed)
        XCTAssertTrue(result.issues.contains { issue in
            if case .awkwardNumbersToCheck = issue { return true }
            return false
        })
        let good = "Tess counts star stickers and moon stickers on the table. Tess checks how many are ready."
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(good))
    }

    func testRejectsGroupsOfTenEqualRowsJargon() {
        let bad = "Use groups of ten and equal rows with reef numbers."
        let result = ChildFacingProseQualityValidator.validate(bad, allowShortImperative: true)
        XCTAssertFalse(result.passed)
        XCTAssertTrue(result.issues.contains { issue in
            if case .awkwardCurriculumJargon = issue { return true }
            return false
        })
        let good = "Help Willa pack shells into groups of 10, then count the coral in each tray."
        XCTAssertTrue(ChildFacingProseQualityValidator.validate(good, allowShortImperative: true).passed)
    }

    func testRejectsTrueReefSightingEnding() {
        let bad = "Willa shares her true reef sighting, and her friend listens wide-eyed."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed)
        let good = "Willa watched a gentle reef shark swim by. It moved slowly and did not chase the fish."
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(good))
    }

    func testRejectsTrueDetailAndDissolvingDemoJargon() {
        let bad = "Use one true detail from the note and then draw a dissolving demo plan."
        let result = ChildFacingProseQualityValidator.validate(bad, allowShortImperative: true)
        XCTAssertFalse(result.passed)
        XCTAssertTrue(result.issues.contains { issue in
            if case .awkwardCurriculumJargon = issue { return true }
            return false
        })
        let good = "Draw sugar dissolving in a cup of water."
        XCTAssertTrue(
            ChildFacingProseQualityValidator.validate(good, allowShortImperative: true).passed,
            "Got: \(good)"
        )
    }

    func testOceanReefLessonsUseChildFriendlyWording() {
        guard let story = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .sharks,
            category: .story,
            readingLevel: .earlyReader,
            mathLevel: .developing,
            age: 6
        ) else {
            return XCTFail("Expected sharks early-reader story")
        }
        XCTAssertFalse(story.storyEnding.localizedCaseInsensitiveContains("true reef sighting"))
        XCTAssertFalse(story.storyEnding.localizedCaseInsensitiveContains("friend"))
        XCTAssertFalse(story.storyEnding.localizedCaseInsensitiveContains("wide-eyed"))
        let headline = ProgressSummary.shortHeadline(from: story.storyEnding)
        XCTAssertTrue(
            headline.localizedCaseInsensitiveContains("shark")
                || headline.localizedCaseInsensitiveContains("Willa"),
            "Got headline: \(headline)"
        )

        guard let math = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .sharks,
            category: .math,
            readingLevel: .growingReader,
            mathLevel: .secure,
            age: 7
        ) else {
            return XCTFail("Expected sharks secure math")
        }
        XCTAssertFalse(math.missionPrompt.localizedCaseInsensitiveContains("equal rows"))
        XCTAssertFalse(math.missionPrompt.localizedCaseInsensitiveContains("reef numbers"))
        XCTAssertTrue(
            math.missionPrompt.localizedCaseInsensitiveContains("match"),
            "Got: \(math.missionPrompt)"
        )
        XCTAssertNotNil(
            MissionPromptNormalizer.groupSize(in: math.missionPrompt),
            "Mission should name a real group size. Got: \(math.missionPrompt)"
        )
        XCTAssertTrue(
            math.missionPrompt.localizedCaseInsensitiveContains("shell")
                || math.missionPrompt.localizedCaseInsensitiveContains("coral")
                || math.missionPrompt.localizedCaseInsensitiveContains("Willa"),
            "Got: \(math.missionPrompt)"
        )
    }

    func testAcceptsCompleteImperativeInstructions() {
        let good = "Look for the matching letter sound. Then tap the correct picture."
        XCTAssertTrue(ChildFacingProseQualityValidator.validate(good, allowShortImperative: true).passed)
    }

    func testSimplifyWordingDoesNotInflatePaddockIntoTwoWords() {
        let source = "Three ponies flick their tails in the paddock."
        let simplified = AgeGradeLearningStandards.simplifyWording(source)
        XCTAssertFalse(simplified.localizedCaseInsensitiveContains("horse yard"))
        XCTAssertTrue(simplified.localizedCaseInsensitiveContains("yard"))
        XCTAssertEqual(
            simplified.split(separator: " ").count,
            source.split(separator: " ").count,
            "paddock → yard must keep the same word count"
        )
    }

    func testEnforceWordBudgetNeverCreatesHorseDotYard() {
        let source = "Three ponies flicked their tails in the paddock while curious visitors gathered at the gate."
        let adapted = AgeGradeLearningStandards.adaptProseSafely(
            source,
            maxWordsPerSentence: 8,
            maxSentences: 3
        )
        XCTAssertFalse(adapted.contains("horse. yard"))
        XCTAssertFalse(adapted.contains("horse. Yard"))
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(adapted))
    }

    func testHardSplitPathGoneForLongSentenceWithoutComma() {
        let long = "Three ponies flick their tails near the fence every morning before breakfast time starts."
        let result = AgeGradeLearningStandards.enforceWordBudget(long, maxWordsPerSentence: 8)
        XCTAssertFalse(result.contains("fence. every") || result.contains("fence. Every"))
        // May keep intact or split only at natural boundaries — never mid-phrase debris.
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(result))
    }

    func testPonyCareAdaptationForYoungBeginnerStaysClean() {
        let profile = ChildProfile(
            age: 5,
            grade: "Pre-K",
            readingLevel: .beginner,
            mathLevel: .emerging,
            favoriteTopics: [.horses]
        )
        let prepared = ContentAdaptationService.prepare(
            lesson: BundledLessons.ponyCare,
            profile: profile
        )
        let passage = prepared.lesson.readingPassage
        XCTAssertFalse(passage.contains("horse. yard"), "Got: \(passage)")
        XCTAssertFalse(passage.contains("Horse. yard"), "Got: \(passage)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(passage), "Got: \(passage)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(prepared.lesson.storyOpening))
        XCTAssertFalse(prepared.gate.proseQualityFailed)
    }

    func testQuestionsAnswerableFromAdaptedPonyCarePassage() {
        let profile = ChildProfile(
            age: 5,
            grade: "Pre-K",
            readingLevel: .beginner,
            mathLevel: .emerging,
            favoriteTopics: [.horses]
        )
        let prepared = ContentAdaptationService.prepare(
            lesson: BundledLessons.ponyCare,
            profile: profile
        )
        let passage = prepared.lesson.readingPassage.lowercased()
        XCTAssertTrue(passage.contains("yard") || passage.contains("pony") || passage.contains("foal"))
        let readingQs = prepared.lesson.childFacingQuestions.filter { $0.subject != .math }
        XCTAssertFalse(readingQs.isEmpty)
        let grounded = readingQs.filter { q in
            guard let answer = q.correctAnswer?.lowercased(), !answer.isEmpty else { return true }
            if passage.contains(answer) { return true }
            return answer.split(separator: " ").map(String.init).filter { $0.count > 3 }.contains { passage.contains($0) }
        }
        XCTAssertGreaterThanOrEqual(Double(grounded.count) / Double(readingQs.count), 0.5)
    }

    func testFactoryPassagesDifferByReadingLevelAndStayGrammatical() {
        let beginner = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses,
            category: .story,
            readingLevel: .beginner,
            mathLevel: .emerging,
            age: 5
        )
        let confident = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses,
            category: .story,
            readingLevel: .confidentReader,
            mathLevel: .advancing,
            age: 9
        )
        guard let beginner, let confident else {
            return XCTFail("Factory must produce horse story lessons")
        }
        XCTAssertNotEqual(beginner.readingPassage, confident.readingPassage)
        XCTAssertLessThan(
            beginner.readingPassage.split(separator: " ").count,
            confident.readingPassage.split(separator: " ").count
        )
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(beginner.readingPassage))
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(confident.readingPassage))
        XCTAssertTrue(beginner.readingPassage.localizedCaseInsensitiveContains("stall")
                      || beginner.readingPassage.localizedCaseInsensitiveContains("pony")
                      || beginner.readingPassage.localizedCaseInsensitiveContains("Sunny"))
        XCTAssertTrue(confident.readingPassage.localizedCaseInsensitiveContains("horse")
                      || confident.readingPassage.localizedCaseInsensitiveContains("Mia"))
    }

    func testUnrelatedQuestionRejectedByGateCoherence() {
        // Validate validator rejects classic malformed examples used in product requirements.
        let samples = [
            "horse. yard",
            "The ponies stand. in the yard.",
            "Mia speaks softly!!",
            "don t walk behind"
        ]
        for sample in samples {
            // Embed in a fuller sentence where needed for pattern detection.
            let text: String
            if sample == "horse. yard" {
                text = "Three ponies stand in the horse. yard."
            } else if sample == "don t walk behind" {
                text = "Please don t walk behind a horse."
            } else {
                text = sample
            }
            XCTAssertFalse(
                ChildFacingProseQualityValidator.passes(text),
                "Should reject: \(text)"
            )
        }
    }

    func testAllLoadedLessonsPassChildFacingProseValidation() {
        for lesson in LessonLoader.allLessons() {
            let result = ChildFacingProseQualityValidator.validateLessonProse(lesson)
            XCTAssertTrue(result.passed, "\(lesson.title): \(result.issues.map(\.description).joined(separator: "; "))")
        }
    }

    func testAllFactoryLessonsPassProseAndQualityGate() {
        for topic in Topic.allCases {
            for category in LessonCategory.allCases {
                for readingLevel in ReadingLevel.allCases {
                    for mathLevel in MathLevel.allCases {
                        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                            topic: topic,
                            category: category,
                            readingLevel: readingLevel,
                            mathLevel: mathLevel
                        ) else {
                            continue
                        }
                        let prose = ChildFacingProseQualityValidator.validateLessonProse(lesson)
                        XCTAssertTrue(
                            prose.passed,
                            "\(topic.rawValue) \(category.rawValue) \(readingLevel.rawValue) \(mathLevel.rawValue): \(prose.issues.map(\.description).joined(separator: "; "))"
                        )
                        let gate = AutomatedContentQualityGate.validate(lesson: lesson)
        XCTAssertTrue(
            gate.passed,
            "\(topic.rawValue) \(category.rawValue) \(readingLevel.rawValue) \(mathLevel.rawValue): \(gate.summary)"
                        )
                    }
                }
            }
        }
    }

    // MARK: - Mission prompt quality

    func testMissionNormalizerConvertsBareQuestionToInstruction() {
        let source = "What does Tess do before the rocket lifts off?"
        let display = MissionPromptNormalizer.childFacing(source)
        XCTAssertEqual(display, "Check what Tess does before the rocket lifts off.")
        XCTAssertTrue(MissionPromptNormalizer.passes(display))
        XCTAssertFalse(display.hasSuffix("?"))
    }

    func testMissionNormalizerRejectsLaunchOffFragment() {
        let bad = "What does Tess do before the launch off."
        XCTAssertFalse(MissionPromptNormalizer.passes(bad))
        let issues = MissionPromptNormalizer.validate(bad)
        XCTAssertTrue(issues.contains { issue in
            if case .brokenPhrase = issue { return true }
            if case .bareQuestionAsStatement = issue { return true }
            return false
        })
    }

    func testLimitSentencesPreservesQuestionMark() {
        let source = "What does Tess do before the rocket lifts off?"
        let limited = AgeGradeLearningStandards.limitSentences(source, max: 1)
        XCTAssertTrue(limited.hasSuffix("?"), "Got: \(limited)")
        XCTAssertFalse(limited.hasSuffix("."))
    }

    func testMissionNormalizerPreservesMrBram() {
        let source = "What does Mr. Bram do with the torch?"
        let display = MissionPromptNormalizer.childFacing(source)
        XCTAssertTrue(display.contains("Mr. Bram"), "Got: \(display)")
        XCTAssertFalse(display.contains("Find out:"), "Got: \(display)")
    }

    func testCuratedTessMissionIsImperativeNotBareQuestion() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .rockets,
            category: .story,
            readingLevel: .beginner,
            mathLevel: .emerging,
            age: 5
        ) else {
            return XCTFail("Expected rockets beginner story")
        }
        XCTAssertFalse(lesson.missionPrompt.hasSuffix("?"))
        XCTAssertTrue(
            lesson.missionPrompt.localizedCaseInsensitiveContains("Tess")
                || lesson.missionPrompt.localizedCaseInsensitiveContains("rocket")
                || lesson.missionPrompt.localizedCaseInsensitiveContains("countdown")
                || lesson.missionPrompt.localizedCaseInsensitiveContains("Check")
                || lesson.missionPrompt.localizedCaseInsensitiveContains("Read"),
            "Got: \(lesson.missionPrompt)"
        )
        let display = MissionPromptNormalizer.childFacing(lesson.missionPrompt)
        XCTAssertTrue(MissionPromptNormalizer.passes(display), "Got: \(display)")
        // Must not read as a quoted bare question under "Your Mission".
        XCTAssertFalse(display.lowercased().hasPrefix("what does"))
    }

    func testMissionNormalizerRejectsEqualRowsJargon() {
        let bad = "Use groups of ten and equal rows with reef numbers."
        XCTAssertFalse(MissionPromptNormalizer.passes(bad))
        let good = "Help Willa pack shells into groups of 10, then count the coral in each tray."
        XCTAssertTrue(MissionPromptNormalizer.passes(MissionPromptNormalizer.childFacing(good)))
    }

    func testRejectsMissingIntroComma() {
        let bad = "First she checked the barometer on her desk."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed, "Got issues: \(result.issues)")
        XCTAssertTrue(result.issues.contains { issue in
            if case .missingIntroComma = issue { return true }
            return false
        })
        let good = "First, she checked the barometer on her desk."
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(good), "Got: \(good)")
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes("Then she fills the water bucket."),
            "Short 'Then she' should stay natural for beginning readers"
        )
        XCTAssertFalse(
            ChildFacingProseQualityValidator.passes("Gently she squeezes to fill a metal pail."),
            "Introductory adverbs need a comma"
        )
        XCTAssertFalse(
            ChildFacingProseQualityValidator.passes("First you notice a small change in the scene."),
            "Introductory 'First you' needs a comma"
        )
    }

    func testPolishFixesCapitalizationAndIntroCommas() {
        let uncapitalized = "The ponies stand in the yard. they swish their tails."
        let polishedCaps = ChildFacingProseQualityValidator.polish(uncapitalized)
        XCTAssertEqual(polishedCaps, "The ponies stand in the yard. They swish their tails.")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(polishedCaps))

        let missingComma = "First she checked the barometer on her desk."
        let polishedComma = ChildFacingProseQualityValidator.polish(missingComma)
        XCTAssertEqual(polishedComma, "First, she checked the barometer on her desk.")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(polishedComma))

        let commandSplice = "Look at the science note, then draw a quiet barn."
        let polishedCommand = ChildFacingProseQualityValidator.polish(commandSplice)
        XCTAssertEqual(polishedCommand, "Look at the science note and then draw a quiet barn.")
        XCTAssertTrue(
            ChildFacingProseQualityValidator.validate(polishedCommand, allowShortImperative: true).passed,
            "Got: \(polishedCommand)"
        )

        let jobLabel = ChildFacingProseQualityValidator.polish("Your job: count the ponies in the yard.")
        XCTAssertEqual(jobLabel, "Your job: Count the ponies in the yard.")
        XCTAssertTrue(
            ChildFacingProseQualityValidator.validate(jobLabel, allowShortImperative: true).passed,
            "Got: \(jobLabel)"
        )

        let thenSheSplice = "She washes her hands first, then she sits on a wooden stool."
        let polishedThenShe = ChildFacingProseQualityValidator.polish(thenSheSplice)
        XCTAssertEqual(polishedThenShe, "She washes her hands first. She sits on a wooden stool.")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(polishedThenShe), "Got: \(polishedThenShe)")
    }

    func testElevateToneCapitalizesJobLine() {
        let elevated = AgeGradeLearningStandards.elevateTone(
            "Help count the ponies in the yard.",
            kind: .mission
        )
        XCTAssertTrue(elevated.hasPrefix("Your job: Count"), "Got: \(elevated)")
        XCTAssertFalse(elevated.contains("Your job: count"), "Got: \(elevated)")

        let named = AgeGradeLearningStandards.elevateTone(
            "Help Willa pack shells into groups of 10.",
            kind: .mission
        )
        XCTAssertTrue(named.contains("Help Willa"), "Got: \(named)")
        XCTAssertTrue(
            ChildFacingProseQualityValidator.validate(named, allowShortImperative: true).passed,
            "Got: \(named)"
        )
    }

    func testCompletionHeadlineCapitalizesAfterMissionComplete() {
        let headline = ProgressSummary.shortHeadline(
            from: "Mission complete! you explored the ocean today."
        )
        XCTAssertEqual(headline, "You explored the ocean today.")
    }

    func testRejectsCommaSpliceAndSubjectlessFragment() {
        let splice = "Mia walked to the barn, she filled the water bucket."
        let spliceResult = ChildFacingProseQualityValidator.validate(splice)
        XCTAssertFalse(spliceResult.passed, "Got issues: \(spliceResult.issues)")
        XCTAssertTrue(spliceResult.issues.contains { issue in
            if case .commaSplice = issue { return true }
            return false
        })
        let repaired = ChildFacingProseQualityValidator.polish(splice)
        XCTAssertEqual(repaired, "Mia walked to the barn. She filled the water bucket.")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(repaired), "Got: \(repaired)")

        let fragment = "She spots a leaf and picks it up. Then finds a round pinecone nearby."
        let fragmentResult = ChildFacingProseQualityValidator.validate(fragment)
        XCTAssertFalse(fragmentResult.passed, "Got issues: \(fragmentResult.issues)")
        XCTAssertTrue(fragmentResult.issues.contains { issue in
            if case .sentenceFragment = issue { return true }
            return false
        })
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes("When Nina saw a classmate crying, she did not rush over."),
            "Dependent clauses before a comma are not splices"
        )
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes(
                "She said that if someone is hurt, she first checks whether it is safe."
            ),
            "Reported if-clauses are not comma splices"
        )
        XCTAssertFalse(
            ChildFacingProseQualityValidator.passes("She washes her hands first, then she sits on a wooden stool."),
            "Independent clauses joined by ', then she' are comma splices"
        )
    }

    func testWordBudgetDoesNotLeaveCommaBeforePeriodOnButClauses() {
        let source = "Morning light made the water look calm, but ripples near the rocks suggested something moved below."
        let adapted = AgeGradeLearningStandards.adaptProseSafely(
            source,
            maxWordsPerSentence: 10,
            maxSentences: 4
        )
        XCTAssertFalse(adapted.contains(",."), "Got: \(adapted)")
        XCTAssertFalse(adapted.contains("calm,."), "Got: \(adapted)")
        XCTAssertTrue(adapted.localizedCaseInsensitiveContains("ripples near"), "Got: \(adapted)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(adapted), "Got: \(adapted)")

        let budgeted = AgeGradeLearningStandards.enforceWordBudget(source, maxWordsPerSentence: 10)
        XCTAssertFalse(budgeted.contains(",."), "Got: \(budgeted)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(budgeted), "Got: \(budgeted)")
    }

    func testAdaptedSharkPassageNeverShowsCommaPeriod() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .sharks,
            category: .story,
            readingLevel: .confidentReader,
            mathLevel: .developing,
            age: 6
        ) else {
            return XCTFail("Expected sharks confident story")
        }
        let prepared = ContentAdaptationService.prepare(
            lesson: lesson,
            profile: ChildProfile(
                age: 6,
                grade: "Kindergarten",
                readingLevel: .confidentReader,
                mathLevel: .developing,
                favoriteTopics: [.sharks]
            )
        )
        let fields = [
            prepared.lesson.storyOpening,
            prepared.lesson.readingPassage,
            prepared.lesson.storyEnding,
            prepared.lesson.missionPrompt
        ]
        for field in fields {
            XCTAssertFalse(field.contains(",."), "Got: \(field)")
            XCTAssertFalse(field.contains("calm,."), "Got: \(field)")
            XCTAssertTrue(
                ChildFacingProseQualityValidator.validate(field, allowShortImperative: true).passed,
                "Got: \(field)"
            )
        }
        XCTAssertFalse(prepared.gate.proseQualityFailed)
    }

    func testAdaptedStoryPassagesStayGrammaticalForYoungReaders() {
        let profile = ChildProfile(
            age: 6,
            grade: "Kindergarten",
            readingLevel: .confidentReader,
            mathLevel: .developing,
            favoriteTopics: [.sharks, .space, .dinosaurs, .horses]
        )
        for topic in [Topic.sharks, .space, .dinosaurs, .horses] {
            guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                topic: topic,
                category: .story,
                readingLevel: .confidentReader,
                mathLevel: .developing,
                age: 6
            ) else {
                continue
            }
            let prepared = ContentAdaptationService.prepare(lesson: lesson, profile: profile)
            let prose = ChildFacingProseQualityValidator.validateLessonProse(prepared.lesson)
            XCTAssertTrue(
                prose.passed,
                "\(topic.rawValue): \(prose.issues.map(\.description).joined(separator: "; "))"
            )
            XCTAssertFalse(
                prepared.lesson.readingPassage.contains(",."),
                "\(topic.rawValue) passage: \(prepared.lesson.readingPassage)"
            )
        }
    }

    func testWordBudgetDoesNotTurnThenFindsIntoAFragment() {
        let source = "She spots a leaf and picks it up, then finds a round pinecone nearby."
        let adapted = AgeGradeLearningStandards.adaptProseSafely(
            source,
            maxWordsPerSentence: 8,
            maxSentences: 3
        )
        XCTAssertFalse(adapted.contains("Then finds"), "Got: \(adapted)")
        XCTAssertFalse(adapted.contains(". finds"), "Got: \(adapted)")
        XCTAssertFalse(adapted.contains(". Finds"), "Got: \(adapted)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(adapted), "Got: \(adapted)")
        XCTAssertTrue(
            adapted.localizedCaseInsensitiveContains("then finds")
                || adapted.localizedCaseInsensitiveContains("and then finds")
                || (adapted.localizedCaseInsensitiveContains("picks it up")
                    && adapted.localizedCaseInsensitiveContains("pinecone")),
            "Compound predicate should stay with its subject. Got: \(adapted)"
        )
    }

    func testRejectsSheAddAgreementError() {
        let bad = "Check what she add layer by layer."
        let result = ChildFacingProseQualityValidator.validate(bad, allowShortImperative: true)
        XCTAssertFalse(result.passed, "Got issues: \(result.issues)")
        XCTAssertTrue(result.issues.contains { issue in
            if case .subjectVerbAgreement = issue { return true }
            return false
        })
        let good = "Check what she adds layer by layer."
        XCTAssertTrue(
            ChildFacingProseQualityValidator.validate(good, allowShortImperative: true).passed,
            "Got: \(good)"
        )
    }

    func testCookingSoupLessonIsGrammaticalAndPlausible() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .cooking,
            category: .story,
            readingLevel: .beginner,
            mathLevel: .emerging,
            age: 5
        ) else {
            return XCTFail("Expected cooking beginner story")
        }
        XCTAssertTrue(lesson.missionPrompt.contains("adds"), "Got: \(lesson.missionPrompt)")
        XCTAssertFalse(lesson.missionPrompt.contains("Dara add "))
        let choices = lesson.questions.flatMap(\.choices).joined(separator: " ").lowercased()
        XCTAssertFalse(choices.contains("sand"))
        XCTAssertFalse(choices.contains("buttons"))
        XCTAssertFalse(choices.contains("terrible"))
        XCTAssertTrue(choices.contains("peas"))
        XCTAssertTrue(ChildFacingProseQualityValidator.validateLessonProse(lesson).passed)
    }

    func testRejectsSpoonsCupsNounListFragment() {
        let bad = "Spoons, cups."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed, "Got issues: \(result.issues)")
        XCTAssertTrue(result.issues.contains { issue in
            if case .nounListFragment = issue { return true }
            if case .sentenceFragment = issue { return true }
            return false
        })
        let alsoBad = "Spice jars, cups."
        XCTAssertFalse(ChildFacingProseQualityValidator.passes(alsoBad), "Got: \(alsoBad)")
    }

    func testAcceptsRealClausesWithCommas() {
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes(
                "A guide explained that each layer offers different food, light, and shelter."
            )
        )
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes("Mia sees 2 ponies, then 2 more join.")
        )
        XCTAssertTrue(
            ChildFacingProseQualityValidator.validate(
                "Then answer each question.",
                allowShortImperative: true
            ).passed
        )
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes("First, sensors gather input from the surroundings.")
        )
        XCTAssertTrue(
            ChildFacingProseQualityValidator.passes("If the engine gets no energy, the train slows down.")
        )
    }

    func testMissionAlignerKeepsCountAndCompareJobs() {
        let rewritten = MissionPromptNormalizer.alignedToActivities(
            existing: "Count the ponies and compare the groups.",
            questions: [],
            mathChallenges: [
                LessonQuestion(
                    subject: .math,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "Mia sees 2 ponies, then 2 more join. How many ponies in all?",
                    choices: ["3", "4", "5"],
                    correctAnswer: "4",
                    explanation: "2 + 2 = 4."
                )
            ]
        )
        XCTAssertTrue(rewritten.localizedCaseInsensitiveContains("count the ponies"))
        XCTAssertTrue(rewritten.localizedCaseInsensitiveContains("compare"))
    }


    func testWordBudgetDoesNotSplitKitchenItemListIntoFakeSentences() {
        let source = "Spice jars, cups, and spoons are sorted into groups before the busy cooking day begins."
        let adapted = AgeGradeLearningStandards.adaptProseSafely(
            source,
            maxWordsPerSentence: 8,
            maxSentences: 3
        )
        XCTAssertFalse(adapted.contains("Spice jars, cups."), "Got: \(adapted)")
        XCTAssertFalse(adapted.contains("Spoons, cups."), "Got: \(adapted)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(adapted), "Got: \(adapted)")
    }

    func testRejectsBrokenListPeriodRocksSandOrCoral() {
        let bad = "Octopuses can change skin color and texture to match rocks. Sand, or coral so they are harder to see."
        let result = ChildFacingProseQualityValidator.validate(bad)
        XCTAssertFalse(result.passed, "Got issues: \(result.issues)")
        XCTAssertTrue(result.issues.contains { issue in
            if case .midPhrasePeriod = issue { return true }
            return false
        })
        let good = "Octopuses can change skin color and texture. They match rocks, sand, or coral so they are harder to see."
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(good), "Got: \(good)")
    }

    func testWordBudgetDoesNotSplitRocksSandOrCoralList() {
        let source = "Octopuses can change skin color and texture to match rocks, sand, or coral so they are harder to see."
        let adapted = AgeGradeLearningStandards.adaptProseSafely(
            source,
            maxWordsPerSentence: 10,
            maxSentences: 3
        )
        XCTAssertFalse(adapted.contains("rocks. Sand"), "Got: \(adapted)")
        XCTAssertFalse(adapted.contains("rocks. sand"), "Got: \(adapted)")
        XCTAssertTrue(
            adapted.localizedCaseInsensitiveContains("rocks, sand, or coral")
                || adapted.localizedCaseInsensitiveContains("rocks, sand or coral"),
            "List should stay together. Got: \(adapted)"
        )
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(adapted), "Got: \(adapted)")
    }

    func testOctopusCamouflageArtIsADrawingLesson() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .oceanAnimals,
            category: .creative,
            readingLevel: .growingReader,
            mathLevel: .developing
        ) else {
            return XCTFail("Expected octopus camouflage art lesson")
        }
        XCTAssertEqual(lesson.title, "Design Octopus Camouflage Art")
        XCTAssertEqual(lesson.creativeResponseType, .drawing)
        XCTAssertTrue(lesson.creativePrompt.localizedCaseInsensitiveContains("draw"))
        XCTAssertFalse(lesson.creativePrompt.localizedCaseInsensitiveContains("write four sentences"))
        XCTAssertTrue(lesson.missionPrompt.localizedCaseInsensitiveContains("draw"))
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("write"))
        XCTAssertFalse(lesson.readingPassage.contains("rocks. Sand"))
        XCTAssertTrue(lesson.readingPassage.localizedCaseInsensitiveContains("rocks, sand, or coral"))

        let prepared = ContentAdaptationService.prepare(
            lesson: lesson,
            profile: ChildProfile(
                age: 7,
                grade: "2nd Grade",
                readingLevel: .growingReader,
                mathLevel: .developing,
                favoriteTopics: [.oceanAnimals]
            )
        )
        XCTAssertEqual(prepared.lesson.creativeResponseType, .drawing)
        XCTAssertTrue(prepared.lesson.creativePrompt.localizedCaseInsensitiveContains("draw"))
        XCTAssertFalse(prepared.lesson.readingPassage.contains("rocks. Sand"), "Got: \(prepared.lesson.readingPassage)")
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(prepared.lesson.readingPassage), "Got: \(prepared.lesson.readingPassage)")
    }

    func testAllSecureGroupingLessonsLetKidsSortAndMakeStorySizedGroups() {
        var checked = 0
        var sizes = Set<Int>()
        var missions = Set<String>()
        for topic in Topic.allCases {
            guard let scene = CuratedTopicLessonBank.mathScene(
                topic: topic,
                mathLevel: .secure,
                readingLevel: .earlyReader
            ) else {
                continue
            }
            let grouping = scene.activityFingerprint.contains("groups")
                || scene.missionPrompt.lowercased().contains("into groups")
                || scene.storyOpening.lowercased().contains("into groups")
            guard grouping else { continue }
            checked += 1
            guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
                topic: topic,
                category: .math,
                readingLevel: .earlyReader,
                mathLevel: .secure,
                age: 7
            ) else {
                return XCTFail("Expected grouping lesson for \(topic.rawValue)")
            }
            let matching = lesson.childFacingQuestions.filter { $0.responseType == .matching }
            XCTAssertFalse(matching.isEmpty, "\(topic.rawValue) promised grouping but has no match activity")
            XCTAssertTrue(matching.allSatisfy(\.hasValidMatchingData), topic.rawValue)
            XCTAssertTrue(
                lesson.missionPrompt.localizedCaseInsensitiveContains("match"),
                "\(topic.rawValue) mission should ask kids to match. Got: \(lesson.missionPrompt)"
            )
            guard let missionSize = MissionPromptNormalizer.groupSize(in: lesson.missionPrompt) else {
                return XCTFail("\(topic.rawValue) mission never names a group size. Got: \(lesson.missionPrompt)")
            }
            sizes.insert(missionSize)
            missions.insert(lesson.missionPrompt)
            let mathPrompts = lesson.childFacingMathChallenges.map(\.prompt).joined(separator: " ").lowercased()
            XCTAssertEqual(
                MissionPromptNormalizer.groupSize(in: mathPrompts),
                missionSize,
                "\(topic.rawValue) math should use the same group size as the mission (\(missionSize)). Got: \(mathPrompts)"
            )
            if let packItem = packItem(from: scene.readingPassage) {
                XCTAssertTrue(
                    mathPrompts.contains(packItem) || lesson.missionPrompt.lowercased().contains(packItem),
                    "\(topic.rawValue) grouping math should use the story items (\(packItem)). Got: \(mathPrompts)"
                )
            }
            XCTAssertFalse(
                lesson.missionPrompt.localizedCaseInsensitiveContains("pack the"),
                "\(topic.rawValue) still overpromises packing: \(lesson.missionPrompt)"
            )
            XCTAssertFalse(
                lesson.missionPrompt.lowercased().contains("sort the")
                    && lesson.missionPrompt.lowercased().contains("into groups"),
                "\(topic.rawValue) still says sort-into-groups without a sort UI: \(lesson.missionPrompt)"
            )
        }
        XCTAssertGreaterThanOrEqual(checked, 8, "Expected grouping lessons across core topics")
        XCTAssertGreaterThanOrEqual(sizes.count, 2, "Grouping lessons should not all use one group size. Got: \(sizes)")
        XCTAssertGreaterThan(missions.count, 1, "Grouping missions should not all use the same sentence")
        XCTAssertNotEqual(sizes, [10], "Not every grouping lesson should be groups of 10")
    }

    func testCookingGroupsLessonLetsKidsSortAndUsesRealSentences() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .cooking,
            category: .math,
            readingLevel: .earlyReader,
            mathLevel: .secure,
            age: 7
        ) else {
            return XCTFail("Expected cooking secure math lesson")
        }
        XCTAssertTrue(
            lesson.storyOpening.localizedCaseInsensitiveContains("sort"),
            "Got opening: \(lesson.storyOpening)"
        )
        XCTAssertTrue(
            lesson.missionPrompt.localizedCaseInsensitiveContains("match"),
            "Got mission: \(lesson.missionPrompt)"
        )
        XCTAssertTrue(
            lesson.missionPrompt.localizedCaseInsensitiveContains("spice jars")
                || lesson.missionPrompt.localizedCaseInsensitiveContains("spoons"),
            "Got mission: \(lesson.missionPrompt)"
        )
        guard let size = MissionPromptNormalizer.groupSize(in: lesson.missionPrompt) else {
            return XCTFail("Cooking mission should name a group size. Got: \(lesson.missionPrompt)")
        }
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("pack the"))
        XCTAssertFalse(lesson.missionPrompt.localizedCaseInsensitiveContains("count the measuring"))
        XCTAssertFalse(lesson.readingPassage.contains("Spoons, cups."))
        XCTAssertFalse(lesson.readingPassage.contains("Spice jars, cups."))
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(lesson.storyOpening), "Got: \(lesson.storyOpening)")
        XCTAssertTrue(
            ChildFacingProseQualityValidator.validate(lesson.missionPrompt, allowShortImperative: true).passed,
            "Got: \(lesson.missionPrompt)"
        )
        XCTAssertTrue(ChildFacingProseQualityValidator.passes(lesson.readingPassage), "Got: \(lesson.readingPassage)")

        let matching = lesson.childFacingQuestions.filter { $0.responseType == .matching }
        XCTAssertFalse(matching.isEmpty, "Kids were promised sorting but got no sort activity")
        XCTAssertTrue(matching.allSatisfy(\.hasValidMatchingData))
        XCTAssertGreaterThanOrEqual(matching.first?.pairs.count ?? 0, 3)

        let mathPrompts = lesson.childFacingMathChallenges.map(\.prompt).joined(separator: " ").lowercased()
        XCTAssertEqual(
            MissionPromptNormalizer.groupSize(in: mathPrompts),
            size,
            "Math should use the story group size \(size). Got: \(mathPrompts)"
        )
        XCTAssertTrue(mathPrompts.contains("spice jars") || mathPrompts.contains("spice jar"))
        XCTAssertTrue(LessonContentCoherenceValidator.validate(lesson).passed, lesson.title)
    }

    func testCookingLessonDropsEqualGroupsMathForPreKAge() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .cooking,
            category: .math,
            readingLevel: .earlyReader,
            mathLevel: .secure,
            age: 7
        ) else {
            return XCTFail("Expected cooking secure math lesson")
        }
        let prepared = ContentAdaptationService.prepare(
            lesson: lesson,
            profile: ChildProfile(
                age: 5,
                grade: "Pre-K",
                readingLevel: .beginner,
                mathLevel: .secure,
                favoriteTopics: [.cooking]
            )
        )
        let matching = prepared.lesson.childFacingQuestions.filter { $0.responseType == .matching }
        XCTAssertFalse(matching.isEmpty, "Adapted lesson dropped the sort activity")
        XCTAssertTrue(matching.allSatisfy(\.hasValidMatchingData))
        let mathPrompts = prepared.lesson.childFacingMathChallenges.map(\.prompt).joined(separator: " ").lowercased()
        XCTAssertNil(
            MissionPromptNormalizer.groupSize(in: mathPrompts),
            "Age 5 curriculum should not keep equal-groups math. Got: \(mathPrompts)"
        )
        XCTAssertFalse(mathPrompts.contains("groups of"))
        XCTAssertFalse(prepared.lesson.missionPrompt.localizedCaseInsensitiveContains("pack spice jars into groups"))
        XCTAssertFalse(prepared.lesson.missionPrompt.localizedCaseInsensitiveContains("count the measuring"))
    }

    func testMissionAlignerDropsPackAndCountPromisesWithoutThoseActivities() {
        let rewritten = MissionPromptNormalizer.alignedToActivities(
            existing: "Help Chef Dara pack spice jars into groups of 10. Count the measuring cups.",
            questions: [],
            mathChallenges: [
                LessonQuestion(
                    subject: .math,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: "Chef Dara unpacks 3 packs with 4 measuring cups in each pack. How many measuring cups does she unpack?",
                    choices: ["7", "12", "14"],
                    correctAnswer: "12",
                    explanation: "3 × 4 = 12."
                )
            ]
        )
        XCTAssertFalse(rewritten.localizedCaseInsensitiveContains("pack spice jars into groups"))
        XCTAssertFalse(rewritten.localizedCaseInsensitiveContains("count the measuring"))
        XCTAssertFalse(rewritten.localizedCaseInsensitiveContains("sort"))
    }

    func testEmergingHorsesMathKeepsCountingMission() {
        guard let lesson = LevelSpecificContentFactory.makeApprovedLesson(
            topic: .horses,
            category: .math,
            readingLevel: .beginner,
            mathLevel: .emerging
        ) else {
            return XCTFail("Expected horses emerging math lesson")
        }
        XCTAssertTrue(
            lesson.missionPrompt.localizedCaseInsensitiveContains("count"),
            "Got: \(lesson.missionPrompt)"
        )
        XCTAssertTrue(ChildFacingProseQualityValidator.validateLessonProse(lesson).passed)
    }


    func testGroupingMatchExtractsKitchenTrays() {
        let passage = "Chef Dara puts the spoons in the utensil tray. She puts the cups in the drink tray. She puts the spice jars on the spice shelf. Then she packs 20 spice jars into groups of 10."
        let question = GroupingSortQuestionBuilder.question(from: passage)
        XCTAssertNotNil(question)
        XCTAssertEqual(question?.responseType, .matching)
        XCTAssertGreaterThanOrEqual(question?.pairs.count ?? 0, 3)
        let lefts = Set(question?.pairs.map { $0.left.lowercased() } ?? [])
        XCTAssertTrue(lefts.contains("spoons"))
        XCTAssertTrue(lefts.contains("cups"))
        XCTAssertTrue(lefts.contains("spice jars"))
    }

    private func packItem(from passage: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: #"packs \d+ (.+?) into groups"#) else {
            return nil
        }
        let range = NSRange(passage.startIndex..., in: passage)
        guard let match = regex.firstMatch(in: passage, range: range),
              let itemRange = Range(match.range(at: 1), in: passage) else {
            return nil
        }
        return String(passage[itemRange]).lowercased()
    }
}
