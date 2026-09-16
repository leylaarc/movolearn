import Foundation

/// Educator-style quality gate run before a lesson is shown to a child.
/// External or generated material must pass these checks; failing items are repaired or blocked.
/// Checks measure **adapted content quality against age/grade expectations**, not just labels
/// (labels are rewritten to the child during adaptation).
enum LessonPreDisplayGate {

    struct Check: Equatable {
        let number: Int
        let question: String
        let passed: Bool
        let detail: String
    }

    struct Result: Equatable {
        let checks: [Check]
        let failingQuestionIDs: Set<UUID>
        let repairNotes: [String]

        var passed: Bool { checks.allSatisfy(\.passed) }

        /// True when child-facing prose failed grammar/punctuation/completeness checks.
        var proseQualityFailed: Bool {
            checks.contains { $0.number == 11 && !$0.passed }
        }

        var failedSummaries: [String] {
            checks.filter { !$0.passed }.map { "\($0.number). \($0.question) — \($0.detail)" }
        }
    }

    /// Runs the 10 required educational quality questions.
    static func validate(
        lesson: Lesson,
        ability: LearnerAbilityProfile,
        profile: ChildProfile,
        expectations: AgeGradeLearningStandards.Expectations? = nil,
        originalLesson: Lesson? = nil
    ) -> Result {
        let expectations = expectations ?? AgeGradeLearningStandards.expectations(
            age: ability.age,
            grade: ability.grade,
            readingLevel: ability.readingLevel,
            mathLevel: ability.mathLevel
        )

        var checks: [Check] = []
        var failingIDs = Set<UUID>()
        var notes: [String] = []

        // 1. Age / grade match — content metrics vs expectations (+ original catalog fit)
        let avgWords = AgeGradeLearningStandards.averageWordsPerSentence(in: lesson.readingPassage)
        let sentences = AgeGradeLearningStandards.sentenceCount(of: lesson.readingPassage)
        let wordingFitsAge = avgWords <= Double(expectations.maxWordsPerSentence) + 4
            && sentences <= expectations.maxPassageSentences + 2
        let originalAgeOK: Bool = {
            guard let original = originalLesson else { return true }
            let ageHit = LessonDifficultyRules.ageMatches(original.ageTarget, ability.age)
                || LessonDifficultyRules.ageMatches(original.recommendedAgeRange ?? original.ageTarget, ability.age)
            let gradeHit = LessonDifficultyRules.gradeMatches(original.gradeTarget, ability.grade)
            // Wide K–2 catalog lessons are OK if adaptation reshaped the prose.
            let catalogBandOK = original.gradeTarget.contains("K-2")
                || original.gradeTarget.contains("1-3")
                || original.ageTarget.contains("5-8")
                || original.ageTarget.contains("6-9")
            return ageHit || gradeHit || (catalogBandOK && wordingFitsAge)
        }()
        let ageGradeOK = wordingFitsAge && originalAgeOK
        checks.append(
            Check(
                number: 1,
                question: "Does this match the child’s age and grade?",
                passed: ageGradeOK,
                detail: ageGradeOK
                    ? "Content shaped for \(expectations.band.displayName) (avg \(Int(avgWords)) words/sentence)"
                    : "Wording still too complex for age \(ability.age)"
            )
        )

        // 2. Skill level match
        let levelDelta = abs(lesson.readingLevel.sortOrder - ability.readingLevel.sortOrder)
        checks.append(
            Check(
                number: 2,
                question: "Does it match the child’s current skill level?",
                passed: levelDelta <= 1,
                detail: levelDelta <= 1
                    ? "Reading level \(lesson.readingLevel.rawValue) fits \(ability.readingLevel.rawValue)"
                    : "Lesson level \(lesson.readingLevel.rawValue) far from \(ability.readingLevel.rawValue)"
            )
        )

        // 3. Accuracy / quality of questions
        let allQuestions = lesson.childFacingQuestions + lesson.childFacingMathChallenges
        var accuracyOK = true
        for question in allQuestions {
            let result = QuestionQualityValidator.validate(
                question,
                topic: lesson.theme,
                topicKeywords: QuestionQualityValidator.topicKeywords(for: lesson.theme),
                context: LessonContextBank.from(lesson: lesson),
                primarySubject: lesson.primarySubject,
                passage: lesson.readingPassage
            )
            let fatal = result.issues.contains { issue in
                switch issue {
                case .jokeOrAbsurdChoice, .missingCorrectAnswer, .emptyChoices,
                     .scenarioIllogical, .matchingNotPassageGrounded, .unsupportedArrangingActivity,
                     .answerNotVerifiable, .metaComprehensionPrompt:
                    return true
                default:
                    return false
                }
            }
            if fatal {
                accuracyOK = false
                failingIDs.insert(question.id)
            }
        }
        checks.append(
            Check(
                number: 3,
                question: "Is the information accurate?",
                passed: accuracyOK,
                detail: accuracyOK ? "No fatal accuracy issues" : "Removed \(failingIDs.count) unsafe question(s)"
            )
        )
        if !failingIDs.isEmpty {
            notes.append("Dropped \(failingIDs.count) question(s) that failed accuracy checks")
        }

        // 4. Wording understandable
        let wordingOK = avgWords <= Double(expectations.maxWordsPerSentence) + 6
            && sentences <= expectations.maxPassageSentences + 3
        checks.append(
            Check(
                number: 4,
                question: "Is the wording understandable?",
                passed: wordingOK,
                detail: wordingOK
                    ? "Passage has \(sentences) sentence(s), ~\(Int(avgWords)) words each"
                    : "Passage still too long or dense for \(expectations.band.displayName)"
            )
        )

        // 5. Activity teaches intended skill (and title/mission are not academic mismatches)
        let teachesSkill = !lesson.skillsPracticed.isEmpty
            || !lesson.readingSkill.isEmpty
            || !lesson.mathSkill.isEmpty
            || lesson.isCurriculumMapped
            || !expectations.readingFocus.isEmpty
        let coherence = LessonContentCoherenceValidator.validate(lesson)
        let titleOK = !LessonContentCoherenceValidator.hasAcademicSkillTitle(lesson.title)
            && !coherence.issues.contains { $0.code == "title_skill_mismatch" || $0.code == "mission_story_mismatch" }
        let skillOK = teachesSkill && titleOK
        checks.append(
            Check(
                number: 5,
                question: "Does the activity teach the intended skill?",
                passed: skillOK,
                detail: skillOK
                    ? "Skills: \(lesson.skillsPracticed.prefix(3).joined(separator: ", "))"
                    : titleOK
                        ? "No skill targets"
                        : "Title/mission does not match the exercise (\(coherence.summary))"
            )
        )

        // 6. Questions match what was taught
        let readingQs = allQuestions.filter { $0.subject != .math }
        let groundedRatio = groundedQuestionRatio(questions: readingQs, passage: lesson.readingPassage)
        let vocabTaught = Set(lesson.vocabularyWords.map { $0.word.lowercased() })
        let testsUntaught: Bool = {
            guard expectations.teachVocabularyBeforeTesting else { return false }
            return readingQs.contains { question in
                guard let answer = question.correctAnswer?.lowercased() else { return false }
                guard AgeGradeLearningStandards.requiresPreTeaching(answer, expectations: expectations) else {
                    return false
                }
                let inPassage = lesson.readingPassage.lowercased().contains(answer)
                return !vocabTaught.contains(answer) && !inPassage
            }
        }()
        let matchTaught = (allQuestions.isEmpty || groundedRatio >= 0.5 || lesson.primarySubject == .math)
            && !testsUntaught
        checks.append(
            Check(
                number: 6,
                question: "Do the questions match what was taught?",
                passed: matchTaught,
                detail: matchTaught
                    ? "Passage-grounded ratio \(Int(groundedRatio * 100))%"
                    : testsUntaught
                        ? "Question tests a concept before it was taught"
                        : "Too many questions lack passage support"
            )
        )
        if testsUntaught {
            for question in readingQs {
                if let answer = question.correctAnswer?.lowercased(),
                   AgeGradeLearningStandards.requiresPreTeaching(answer, expectations: expectations),
                   !vocabTaught.contains(answer),
                   !lesson.readingPassage.lowercased().contains(answer) {
                    failingIDs.insert(question.id)
                }
            }
            notes.append("Dropped question(s) that tested untaught concepts")
        }

        // 7. Difficulty appropriate
        let choiceOK = allQuestions
            .filter { !$0.choices.isEmpty }
            .allSatisfy { $0.choices.count <= expectations.maxAnswerChoices }
        let countOK = lesson.childFacingQuestions.count <= ability.rules.readingQuestionRange.upperBound + 1
            && lesson.childFacingMathChallenges.count <= ability.rules.mathQuestionRange.upperBound + 1
        let inferenceOK = expectations.allowInference
            || !allQuestions.contains(where: isInferenceHeavy)
        checks.append(
            Check(
                number: 7,
                question: "Is the difficulty appropriate?",
                passed: choiceOK && countOK && inferenceOK,
                detail: choiceOK && countOK && inferenceOK
                    ? "Choice counts, volume, and reasoning fit \(ability.readingLevel.rawValue)"
                    : "Difficulty still exceeds learner profile limits"
            )
        )
        if !inferenceOK {
            for question in allQuestions where isInferenceHeavy(question) {
                failingIDs.insert(question.id)
            }
            notes.append("Dropped inference-heavy items for this age/skill band")
        }

        // 8. Engaging without sacrificing education
        let hasStory = !lesson.storyOpening.isEmpty && !lesson.readingPassage.isEmpty
        let hasPractice = !allQuestions.isEmpty || !lesson.creativePrompt.isEmpty
        checks.append(
            Check(
                number: 8,
                question: "Is the content engaging without sacrificing educational value?",
                passed: hasStory && hasPractice,
                detail: hasStory && hasPractice ? "Story + practice present" : "Missing story or practice"
            )
        )

        // 9. No confusing / unrelated elements
        let unrelated = allQuestions.contains { question in
            QuestionQualityValidator.validate(
                question,
                topic: lesson.theme,
                topicKeywords: QuestionQualityValidator.topicKeywords(for: lesson.theme),
                context: LessonContextBank.from(lesson: lesson),
                primarySubject: lesson.primarySubject,
                passage: lesson.readingPassage
            ).issues.contains {
                if case .jokeOrAbsurdChoice = $0 { return true }
                if case .scenarioIllogical = $0 { return true }
                return false
            }
        }
        checks.append(
            Check(
                number: 9,
                question: "Are there confusing, misleading, random, or unrelated elements?",
                passed: !unrelated,
                detail: unrelated ? "Unrelated or illogical items detected" : "No unrelated elements found"
            )
        )

        // 10. Educator meaningfulness
        let educatorOK = teachesSkill && hasPractice && accuracyOK && matchTaught && wordingOK
        checks.append(
            Check(
                number: 10,
                question: "Would an educator consider this a meaningful learning activity?",
                passed: educatorOK,
                detail: educatorOK
                    ? "Meaningful practice aligned to skill, story, and \(expectations.band.displayName)"
                    : "Needs stronger skill alignment or cleaner age-fit questions"
            )
        )

        // 11. Child-facing prose quality (grammar, punctuation, no malformed splits)
        let proseResult = ChildFacingProseQualityValidator.validateLessonProse(lesson)
        let proseOK = proseResult.passed
        checks.append(
            Check(
                number: 11,
                question: "Is every child-facing passage grammatically correct and natural?",
                passed: proseOK,
                detail: proseOK
                    ? "Prose passed grammar, punctuation, and completeness checks"
                    : proseResult.issues.prefix(3).map(\.description).joined(separator: "; ")
            )
        )
        if !proseOK {
            notes.append("Prose quality failed — restore or regenerate before display")
        }

        // 12. Mission / story / questions coherence (passage must support reading answers)
        let coherenceOK: Bool = {
            guard lesson.primarySubject == .reading || lesson.category == .story || lesson.category == .discovery else {
                return true
            }
            let passage = lesson.readingPassage.lowercased()
            guard !passage.isEmpty else { return false }
            let readingQs = lesson.childFacingQuestions.filter { $0.subject != .math }
            guard !readingQs.isEmpty else { return true }
            let answerable = readingQs.filter { question in
                guard let answer = question.correctAnswer?.lowercased(), !answer.isEmpty else {
                    return question.isProgressiveMystery || !question.pairs.isEmpty
                }
                if passage.contains(answer) { return true }
                let words = answer.split(separator: " ").map(String.init).filter { $0.count > 3 }
                return words.contains { passage.contains($0) }
            }
            return Double(answerable.count) / Double(readingQs.count) >= 0.5
        }()
        checks.append(
            Check(
                number: 12,
                question: "Do story, mission, and questions form one coherent lesson?",
                passed: coherenceOK,
                detail: coherenceOK
                    ? "Questions are answerable from the passage"
                    : "Too many questions cannot be answered from the story"
            )
        )

        #if DEBUG
        if !checks.allSatisfy(\.passed) {
            print("⚠️ LessonPreDisplayGate issues for \(lesson.title):\n\(checks.filter { !$0.passed }.map(\.detail).joined(separator: "\n"))")
        }
        #endif

        _ = profile
        return Result(checks: checks, failingQuestionIDs: failingIDs, repairNotes: notes)
    }

    private static func groundedQuestionRatio(questions: [LessonQuestion], passage: String) -> Double {
        guard !questions.isEmpty else { return 1 }
        let haystack = passage.lowercased()
        let grounded = questions.filter { question in
            guard let answer = question.correctAnswer?.lowercased(), !answer.isEmpty else {
                return question.isProgressiveMystery || !question.pairs.isEmpty
            }
            if haystack.contains(answer) { return true }
            let words = answer.split(separator: " ").map(String.init).filter { $0.count > 3 }
            return words.contains { haystack.contains($0) }
        }
        return Double(grounded.count) / Double(questions.count)
    }

    private static func isInferenceHeavy(_ question: LessonQuestion) -> Bool {
        let lower = question.prompt.lowercased()
        if question.isProgressiveMystery { return true }
        let markers = [
            "why do you think", "what can you infer", "most likely",
            "best conclusion", "based on all the clues", "what best explains"
        ]
        return markers.contains { lower.contains($0) }
    }
}
