import Foundation

/// Runtime adaptation so the same canonical lesson becomes age- and skill-appropriate.
/// Age sets the curriculum ceiling (ages 5–6 skills for a 6-year-old, and so on).
/// School-grade labels are not used.
/// Canonical bundled content stays immutable; children receive an adapted session copy.
enum ContentAdaptationService {

    struct PreparedLesson {
        let lesson: Lesson
        let ability: LearnerAbilityProfile
        let gate: LessonPreDisplayGate.Result
        let adaptationsApplied: [String]
        let expectations: AgeGradeLearningStandards.Expectations
    }

    /// Adapts content, then runs the educator-style quality gate before display.
    static func prepare(
        lesson: Lesson,
        profile: ChildProfile,
        learningState: ChildLearningState? = nil
    ) -> PreparedLesson {
        let ability = LessonDifficultyRules.abilityProfile(for: profile, learningState: learningState)
        let expectations = AgeGradeLearningStandards.expectations(
            age: ability.age,
            grade: ability.grade,
            readingLevel: ability.readingLevel,
            mathLevel: ability.mathLevel
        )
        var notes: [String] = []

        notes.append("Band: \(expectations.band.displayName); reading \(ability.readingLevel.rawValue); math \(ability.mathLevel.rawValue)")

        let opening = adaptProse(lesson.storyOpening, ability: ability, expectations: expectations, kind: .opening, protectedTerms: protectedVocab(lesson))
        // Normalize before adapting so bare questions become imperatives; adaptation must not
        // reintroduce "What … off." statement shapes for young readers.
        let normalizedMission = MissionPromptNormalizer.childFacing(lesson.missionPrompt)
        var mission = adaptProse(normalizedMission, ability: ability, expectations: expectations, kind: .mission, protectedTerms: protectedVocab(lesson))
        mission = MissionPromptNormalizer.childFacing(mission)
        if !MissionPromptNormalizer.passes(mission) {
            mission = normalizedMission
            notes.append("Kept normalized mission — adapted mission failed mission quality")
        }
        var passage = adaptPassage(lesson.readingPassage, ability: ability, expectations: expectations, protectedTerms: protectedVocab(lesson), notes: &notes)
        let ending = adaptProse(lesson.storyEnding, ability: ability, expectations: expectations, kind: .ending, protectedTerms: protectedVocab(lesson))

        var vocabulary = adaptVocabulary(
            lesson.vocabularyWords,
            ability: ability,
            expectations: expectations,
            notes: &notes
        )
        var facts = adaptFacts(
            lesson.knowledgeFacts,
            ability: ability,
            expectations: expectations,
            notes: &notes
        )

        var readingQuestions = adaptQuestions(
            lesson.childFacingQuestions,
            ability: ability,
            expectations: expectations,
            passage: passage,
            vocabulary: vocabulary,
            notes: &notes,
            includeWordWork: !lesson.focusesOnMath
        )
        if !lesson.focusesOnMath {
            readingQuestions.removeAll { $0.subject == .math }
        }
        var mathQuestions = adaptMathQuestions(
            lesson: lesson,
            ability: ability,
            expectations: expectations,
            notes: &notes
        )
        restorePromisedGroupingActivities(
            original: lesson,
            ability: ability,
            passage: &passage,
            readingQuestions: &readingQuestions,
            mathQuestions: &mathQuestions,
            notes: &notes
        )

        readingQuestions = QuestionQualityValidator.prefixPreservingMatching(
            readingQuestions,
            cap: ability.rules.readingQuestionRange.upperBound
        )
        mathQuestions = Array(mathQuestions.prefix(ability.rules.mathQuestionRange.upperBound))
        mission = MissionPromptNormalizer.alignedToActivities(
            existing: lesson.missionPrompt,
            questions: readingQuestions,
            mathChallenges: mathQuestions,
            maxSentences: max(1, expectations.maxInstructionSentences)
        )
        vocabulary = Array(vocabulary.prefix(ability.rules.vocabularyWordRange.upperBound))
        facts = Array(facts.prefix(ability.rules.knowledgeFactRange.upperBound))

        if ability.readingLevel != lesson.readingLevel {
            notes.append("Reading level adjusted to \(ability.readingLevel.rawValue)")
        }
        if ability.skillDelta != 0 {
            notes.append(ability.skillDelta < 0 ? "Difficulty eased from recent struggle" : "Difficulty raised from strong progress")
        }

        let adaptedCreativePrompt = adaptProse(
            lesson.creativePrompt,
            ability: ability,
            expectations: expectations,
            kind: .creative
        )
        let preferredType = preferredCreativeType(
            lesson.creativeResponseType,
            expectations: expectations,
            ability: ability
        )
        let artAligned = QuestionResponseTypeResolver.preferDrawingForCreativeSession(
            title: lesson.title,
            mission: mission,
            prompt: adaptedCreativePrompt,
            responseType: preferredType,
            category: lesson.category
        )
        mission = artAligned.mission
        let alignedCreative = QuestionResponseTypeResolver.alignedCreative(
            prompt: artAligned.prompt,
            responseType: artAligned.responseType
        )
        let storyCreative = CreativePromptQuality.ensureStoryComprehension(
            prompt: alignedCreative.prompt,
            responseType: alignedCreative.responseType,
            questions: readingQuestions,
            mathChallenges: mathQuestions,
            knowledgeFacts: facts,
            vocabularyWords: vocabulary,
            title: lesson.title,
            category: lesson.category,
            isArtQuest: lesson.isArtQuest
        )
        let reflection = adaptReflection(
            lesson.reflectionPrompt,
            ability: ability,
            expectations: expectations,
            lesson: lesson,
            avoiding: storyCreative
        )

        var adapted = Lesson(
            id: lesson.id,
            title: lesson.title,
            theme: lesson.theme,
            lessonType: lesson.lessonType,
            category: lesson.category,
            primarySubject: lesson.primarySubject,
            storyOpening: opening,
            missionPrompt: mission,
            readingPassage: passage,
            questions: readingQuestions,
            mathChallenges: mathQuestions,
            vocabularyWords: vocabulary,
            knowledgeFacts: facts,
            creativePrompt: storyCreative,
            creativeResponseType: alignedCreative.responseType,
            storyEnding: ending,
            ageTarget: ageTarget(for: ability.age),
            gradeTarget: ability.grade,
            readingLevel: ability.readingLevel,
            mathLevel: ability.mathLevel,
            learningGoal: ability.learningGoal,
            estimatedMinutes: LessonDifficultyRules.estimatedMinutes(for: ability.readingLevel),
            teaser: lesson.teaser,
            difficultyLabel: ability.readingLevel.rawValue,
            readingSkill: lesson.readingSkill.isEmpty
                ? (expectations.readingFocus.first ?? "Reading")
                : lesson.readingSkill,
            mathSkill: lesson.focusesOnMath ? mathSkillLabel(for: ability) : "",
            reflectionPrompt: reflection,
            reflectionResponseType: expectations.preferConcreteLanguage ? .shortText : lesson.reflectionResponseType,
            skillsPracticed: lesson.skillsPracticed.isEmpty
                ? expectations.readingFocus + (lesson.focusesOnMath ? Array(expectations.mathFocus.prefix(1)) : [])
                : lesson.skillsPracticed,
            standardSkillId: lesson.standardSkillId,
            contentApprovalStatus: lesson.contentApprovalStatus,
            hints: lesson.hints,
            commonMistakes: lesson.commonMistakes,
            successCriteria: lesson.successCriteria,
            intendedReadingBand: lesson.intendedReadingBand,
            measuredReadingEstimate: lesson.measuredReadingEstimate,
            readingMeasurementProvider: lesson.readingMeasurementProvider,
            primaryTopicId: lesson.primaryTopicId,
            supportingTopicIds: lesson.supportingTopicIds,
            prerequisiteTopicIds: lesson.prerequisiteTopicIds,
            curriculumSubject: lesson.curriculumSubject,
            curriculumDomain: lesson.curriculumDomain,
            curriculumDifficulty: lesson.curriculumDifficulty,
            recommendedAgeRange: ageTarget(for: ability.age),
            learningObjectives: lesson.learningObjectives,
            evidenceTargets: lesson.evidenceTargets
        )

        adapted.primaryTopicId = lesson.primaryTopicId
        adapted.supportingTopicIds = lesson.supportingTopicIds

        adapted = ChildFacingProseQualityValidator.polishLesson(adapted)

        var gate = LessonPreDisplayGate.validate(
            lesson: adapted,
            ability: ability,
            profile: profile,
            expectations: expectations,
            originalLesson: lesson
        )
        if !gate.passed {
            // Restore canonical prose if adaptation corrupted grammar/punctuation.
            if gate.proseQualityFailed {
                adapted = restoreCanonicalProse(adapted, from: lesson)
                notes.append("Restored original prose after quality failure")
            }
            adapted = repair(adapted, failingQuestionIDs: gate.failingQuestionIDs, ability: ability)
            adapted = reapplyGroupingAfterRepair(
                adapted,
                original: lesson,
                ability: ability,
                expectations: expectations,
                notes: &notes
            )
            adapted = ChildFacingProseQualityValidator.polishLesson(adapted)
            gate = LessonPreDisplayGate.validate(
                lesson: adapted,
                ability: ability,
                profile: profile,
                expectations: expectations,
                originalLesson: lesson
            )
            // Final safety: if prose still fails, block corrupt fields with safe fallbacks.
            if gate.proseQualityFailed {
                adapted = applySafeProseFallbacks(adapted, theme: lesson.theme)
                adapted = ChildFacingProseQualityValidator.polishLesson(adapted)
                notes.append("Applied safe prose fallbacks")
                gate = LessonPreDisplayGate.validate(
                    lesson: adapted,
                    ability: ability,
                    profile: profile,
                    expectations: expectations,
                    originalLesson: lesson
                )
            }
            return PreparedLesson(
                lesson: adapted,
                ability: ability,
                gate: gate,
                adaptationsApplied: notes + gate.repairNotes,
                expectations: expectations
            )
        }

        return PreparedLesson(
            lesson: adapted,
            ability: ability,
            gate: gate,
            adaptationsApplied: notes,
            expectations: expectations
        )
    }

    // MARK: - Prose

    private static func adaptProse(
        _ text: String,
        ability: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations,
        kind: AgeGradeLearningStandards.ProseKind,
        protectedTerms: Set<String> = []
    ) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return trimmed }

        if expectations.preferConcreteLanguage || ability.prefersConcreteLanguage {
            let limit = kind == .mission
                ? expectations.maxInstructionSentences
                : min(3, expectations.maxPassageSentences)
            return ChildFacingProseQualityValidator.polish(
                AgeGradeLearningStandards.adaptProseSafely(
                    trimmed,
                    maxWordsPerSentence: expectations.maxWordsPerSentence,
                    maxSentences: max(1, limit),
                    protectedTerms: protectedTerms
                )
            )
        }

        if ability.age >= 8 {
            return ChildFacingProseQualityValidator.polish(
                AgeGradeLearningStandards.elevateTone(trimmed, kind: kind)
            )
        }
        return ChildFacingProseQualityValidator.polish(trimmed)
    }

    private static func adaptPassage(
        _ passage: String,
        ability: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations,
        protectedTerms: Set<String>,
        notes: inout [String]
    ) -> String {
        var text = passage
        let sentenceCap = min(ability.rules.passageSentenceRange.upperBound, expectations.maxPassageSentences)
        let sentences = AgeGradeLearningStandards.sentenceCount(of: text)
        if sentences > sentenceCap {
            notes.append("Passage shortened to \(sentenceCap) sentences for \(expectations.band.displayName)")
            text = AgeGradeLearningStandards.limitSentences(text, max: sentenceCap)
        }
        if expectations.preferConcreteLanguage || ability.prefersConcreteLanguage {
            let adapted = AgeGradeLearningStandards.adaptProseSafely(
                text,
                maxWordsPerSentence: expectations.maxWordsPerSentence,
                maxSentences: sentenceCap,
                protectedTerms: protectedTerms
            )
            if adapted != text {
                notes.append("Passage wording simplified for younger / beginner readers")
            }
            // Never ship malformed adaptation artifacts to children.
            if ChildFacingProseQualityValidator.passes(adapted) {
                text = adapted
            } else if ChildFacingProseQualityValidator.passes(passage) {
                notes.append("Kept original passage — adapted wording failed prose quality")
                text = AgeGradeLearningStandards.limitSentences(passage, max: sentenceCap)
            } else {
                text = adapted
            }
        }
        return ChildFacingProseQualityValidator.polish(text)
    }

    private static func protectedVocab(_ lesson: Lesson) -> Set<String> {
        Set(lesson.vocabularyWords.map(\.word))
    }

    private static func adaptReflection(
        _ prompt: String,
        ability: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations,
        lesson: Lesson,
        avoiding: String? = nil
    ) -> String {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let base = ReflectionPromptQuality.ensureConcrete(
            prompt: trimmed,
            lesson: lesson,
            avoiding: avoiding
        )

        if ability.age <= 6 || expectations.band == .preK || expectations.preferConcreteLanguage {
            let simplified = AgeGradeLearningStandards.simplifyWording(base)
            return ChildFacingProseQualityValidator.polish(
                ReflectionPromptQuality.ensureConcrete(
                    prompt: simplified,
                    lesson: lesson,
                    avoiding: avoiding
                )
            )
        }
        if ability.age >= 8 {
            let elevated = AgeGradeLearningStandards.elevateTone(base, kind: .reflection)
            return ChildFacingProseQualityValidator.polish(
                ReflectionPromptQuality.ensureConcrete(
                    prompt: elevated,
                    lesson: lesson,
                    avoiding: avoiding
                )
            )
        }
        return ChildFacingProseQualityValidator.polish(base)
    }

    private static func preferredCreativeType(
        _ original: QuestionResponseType,
        expectations: AgeGradeLearningStandards.Expectations,
        ability: LearnerAbilityProfile
    ) -> QuestionResponseType {
        if expectations.visualSupportLevel == .high, original == .longText {
            return .drawing
        }
        if ability.age <= 6, original == .longText {
            return .drawing
        }
        return original
    }

    // MARK: - Vocabulary & facts

    private static func adaptVocabulary(
        _ words: [VocabularyWord],
        ability _: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations,
        notes _: inout [String]
    ) -> [VocabularyWord] {
        words.map { word in
            var definition = word.definition
            var example = word.exampleSentence
            var connection = word.storyConnection
            if expectations.preferConcreteLanguage {
                let protected: Set<String> = [word.word]
                definition = AgeGradeLearningStandards.simplifyWording(definition, protectedTerms: protected)
                example = AgeGradeLearningStandards.simplifyWording(example, protectedTerms: protected)
                connection = AgeGradeLearningStandards.simplifyWording(connection, protectedTerms: protected)
            }
            // Keep advanced science terms only when the band allows; otherwise simplify the label in definition.
            if !expectations.allowAdvancedScienceTerms {
                definition = AgeGradeLearningStandards.simplifyWording(definition, protectedTerms: [word.word])
            }
            return VocabularyWord(
                id: word.id,
                word: word.word,
                definition: ChildFacingProseQualityValidator.polish(definition),
                exampleSentence: ChildFacingProseQualityValidator.polish(example),
                storyConnection: ChildFacingProseQualityValidator.polish(connection)
            )
        }
    }

    private static func adaptFacts(
        _ facts: [KnowledgeFact],
        ability _: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations,
        notes _: inout [String]
    ) -> [KnowledgeFact] {
        facts.map { fact in
            var statement = fact.fact
            var explanation = fact.explanation
            if expectations.preferConcreteLanguage || !expectations.allowAdvancedScienceTerms {
                statement = AgeGradeLearningStandards.simplifyWording(statement)
                explanation = AgeGradeLearningStandards.simplifyWording(explanation)
                explanation = AgeGradeLearningStandards.limitSentences(explanation, max: 2)
            }
            explanation = KnowledgeFact.childFacingExplanation(fact: statement, explanation: explanation)
            return KnowledgeFact(
                id: fact.id,
                fact: ChildFacingProseQualityValidator.polish(statement),
                explanation: ChildFacingProseQualityValidator.polish(explanation)
            )
        }
    }

    // MARK: - Questions

    private static func adaptQuestions(
        _ questions: [LessonQuestion],
        ability: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations,
        passage: String,
        vocabulary: [VocabularyWord],
        notes: inout [String],
        includeWordWork: Bool = false
    ) -> [LessonQuestion] {
        let taughtTerms = Set(vocabulary.map { $0.word.lowercased() })
        var result: [LessonQuestion] = []

        for question in questions {
            if !expectations.allowInference, isInferenceHeavy(question) {
                notes.append("Skipped advanced inference question for \(expectations.band.displayName)")
                continue
            }
            if !ability.allowsAdvancedReasoning, isInferenceHeavy(question) {
                notes.append("Skipped advanced inference question for this skill level")
                continue
            }
            if question.isProgressiveMystery {
                if expectations.band == .preK || ability.readingLevel == .beginner {
                    notes.append("Skipped mystery question for beginner scaffolding")
                    continue
                }
                if !expectations.allowInference, ability.age <= 6 {
                    notes.append("Skipped mystery question until inference is appropriate")
                    continue
                }
            }

            // Do not test a concept that was never taught for scaffolded learners.
            if expectations.teachVocabularyBeforeTesting,
               let answer = question.correctAnswer?.lowercased(),
               AgeGradeLearningStandards.requiresPreTeaching(answer, expectations: expectations),
               !taughtTerms.contains(answer),
               !passage.lowercased().contains(answer) {
                notes.append("Skipped untaught concept question: \(answer)")
                continue
            }

            var adapted = limitChoices(question, maxChoices: expectations.maxAnswerChoices)
            adapted = adaptQuestionLanguage(
                adapted,
                expectations: expectations,
                protectedTerms: Set(vocabulary.map(\.word)),
                preserveMatchingPairs: question.responseType == .matching
            )
            adapted = ensureCorrectAnswerInChoices(adapted)
            result.append(adapted)
        }

        // Letter-start quizzes belong only to beginner readers, and only when
        // a story does not already have a full set of comprehension questions.
        if includeWordWork,
           ability.readingLevel == .beginner,
           result.count < ability.rules.readingQuestionRange.upperBound,
           let wordWork = makeLetterSoundQuestion(
            passage: passage,
            vocabulary: vocabulary,
            existing: result
           ) {
            result.append(wordWork)
            notes.append("Added letter-sound practice for beginner readers")
        }

        if ability.needsScaffolding || expectations.teachVocabularyBeforeTesting {
            let grounded = result.filter { isGroundedInPassage($0, passage: passage) || $0.subject == .math }
            if grounded.count >= ability.rules.readingQuestionRange.lowerBound {
                result = grounded + result.filter { item in !grounded.contains(where: { $0.id == item.id }) }
            }
        }
        return result
    }

    private static func adaptQuestionLanguage(
        _ question: LessonQuestion,
        expectations: AgeGradeLearningStandards.Expectations,
        protectedTerms: Set<String> = [],
        preserveMatchingPairs: Bool = false
    ) -> LessonQuestion {
        var prompt = question.prompt
        var explanation = question.explanation
        var setup = question.mysterySetup
        var clues = question.clues
        var pairs = question.pairs

        if expectations.preferConcreteLanguage {
            prompt = AgeGradeLearningStandards.simplifyWording(prompt, protectedTerms: protectedTerms)
            explanation = explanation.map { AgeGradeLearningStandards.simplifyWording($0, protectedTerms: protectedTerms) }
            setup = setup.map { AgeGradeLearningStandards.simplifyWording($0, protectedTerms: protectedTerms) }
            clues = clues.map { AgeGradeLearningStandards.simplifyWording($0, protectedTerms: protectedTerms) }
            if !preserveMatchingPairs {
                pairs = pairs.map { pair in
                    MatchingPair(
                        left: AgeGradeLearningStandards.simplifyWording(pair.left, protectedTerms: protectedTerms),
                        right: AgeGradeLearningStandards.simplifyWording(pair.right, protectedTerms: protectedTerms),
                        supportingEvidence: AgeGradeLearningStandards.simplifyWording(pair.supportingEvidence ?? "", protectedTerms: protectedTerms)
                    )
                }
            }
        }

        // Younger learners get clearer, shorter explanations.
        if expectations.feedbackTone == .warmScaffolded, let exp = explanation, !exp.isEmpty {
            explanation = AgeGradeLearningStandards.limitSentences(exp, max: 1)
        }

        prompt = ChildFacingProseQualityValidator.polish(prompt)
        explanation = explanation.map(ChildFacingProseQualityValidator.polish)
        setup = setup.map(ChildFacingProseQualityValidator.polish)
        clues = clues.map(ChildFacingProseQualityValidator.polish)

        return LessonQuestion(
            id: question.id,
            subject: question.subject,
            type: question.type,
            responseType: question.responseType,
            prompt: prompt,
            choices: question.choices.map {
                expectations.preferConcreteLanguage
                    ? AgeGradeLearningStandards.simplifyWording($0, protectedTerms: protectedTerms)
                    : $0
            },
            correctAnswer: question.correctAnswer.map {
                expectations.preferConcreteLanguage
                    ? AgeGradeLearningStandards.simplifyWording($0, protectedTerms: protectedTerms)
                    : $0
            },
            explanation: explanation,
            difficultyLevel: question.difficultyLevel,
            pairs: pairs,
            items: question.items,
            mysteryKind: question.mysteryKind,
            mysterySetup: setup,
            clues: clues
        )
    }

    private static func adaptMathQuestions(
        lesson: Lesson,
        ability: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations,
        notes: inout [String]
    ) -> [LessonQuestion] {
        guard lesson.focusesOnMath else { return [] }

        let targetCount = ability.rules.mathQuestionRange.upperBound
        let sessionMath = AgeGradeLearningStandards.cappedMathLevel(ability.mathLevel, age: ability.age)
        let mathReading = LessonDifficultyRules.readingLevel(forMath: sessionMath)
        let existing = lesson.childFacingMathChallenges

        // Prefer authored topic-specific math unless it sits above the age curriculum.
        let mathLevelMismatch = lesson.mathLevel != sessionMath
        let aboveCurriculum = existing.contains { exceedsAgeCurriculum($0, ability: ability, expectations: expectations) }
        let shouldRegenerate = existing.isEmpty
            || aboveCurriculum
            || (mathLevelMismatch && abs(lesson.mathLevel.sortOrder - sessionMath.sortOrder) >= 2)

        if shouldRegenerate {
            notes.append("Math challenges matched to age \(ability.age) curriculum (\(expectations.mathFocus.prefix(2).joined(separator: ", ")))")
            if let scene = CuratedTopicLessonBank.mathScene(
                topic: lesson.theme,
                mathLevel: sessionMath,
                readingLevel: ability.readingLevel
            ), !scene.problems.isEmpty {
                let capped = scene.problems.filter { !exceedsAgeCurriculum($0, ability: ability, expectations: expectations) }
                if !capped.isEmpty {
                    return Array(capped.prefix(targetCount)).map { q in
                        var limited = limitChoices(q, maxChoices: expectations.maxAnswerChoices)
                        limited = adaptQuestionLanguage(limited, expectations: expectations)
                        return ensureCorrectAnswerInChoices(limited)
                    }
                }
            }
            let generated = MathWordProblemGenerator.generateQuestions(
                topic: lesson.theme,
                seed: MathWordProblemGenerator.varietySeed(
                    topic: lesson.theme,
                    mathLevel: sessionMath,
                    readingLevel: ability.readingLevel
                ),
                level: mathReading,
                mathLevel: sessionMath,
                count: targetCount,
                age: ability.age
            )
            if !generated.isEmpty {
                return generated.map { q in
                    var limited = limitChoices(q, maxChoices: expectations.maxAnswerChoices)
                    limited = adaptQuestionLanguage(limited, expectations: expectations)
                    return ensureCorrectAnswerInChoices(limited)
                }
            }
        }

        var kept = existing.map { q -> LessonQuestion in
            var limited = limitChoices(q, maxChoices: expectations.maxAnswerChoices)
            limited = adaptQuestionLanguage(limited, expectations: expectations)
            return ensureCorrectAnswerInChoices(limited)
        }
        if !expectations.allowMultiStepMath || !ability.rules.supportsMultiStepMath {
            kept = kept.filter { !looksMultiStep($0.prompt) }
        }
        kept = kept.filter { !exceedsAgeCurriculum($0, ability: ability, expectations: expectations) }
        return Array(kept.prefix(targetCount))
    }

    private static func limitChoices(_ question: LessonQuestion, maxChoices: Int) -> LessonQuestion {
        guard question.choices.count > maxChoices,
              let correct = question.correctAnswer,
              !correct.isEmpty else {
            return question
        }
        var limited: [String] = [correct]
        for choice in question.choices where choice.caseInsensitiveCompare(correct) != .orderedSame {
            limited.append(choice)
            if limited.count == maxChoices { break }
        }
        if limited.count > 1 {
            let pivot = abs(question.prompt.hashValue) % limited.count
            if pivot > 0 {
                let head = Array(limited[pivot...])
                let tail = Array(limited[..<pivot])
                limited = head + tail
            }
        }
        return LessonQuestion(
            id: question.id,
            subject: question.subject,
            type: question.type,
            responseType: question.responseType,
            prompt: question.prompt,
            choices: limited,
            correctAnswer: question.correctAnswer,
            explanation: question.explanation,
            difficultyLevel: question.difficultyLevel,
            pairs: question.pairs,
            items: question.items,
            mysteryKind: question.mysteryKind,
            mysterySetup: question.mysterySetup,
            clues: question.clues
        )
    }

    private static func repair(
        _ lesson: Lesson,
        failingQuestionIDs: Set<UUID>,
        ability: LearnerAbilityProfile
    ) -> Lesson {
        let reading = lesson.questions.filter { !failingQuestionIDs.contains($0.id) }
        let math = lesson.mathChallenges.filter { !failingQuestionIDs.contains($0.id) }
        return Lesson(
            id: lesson.id,
            title: lesson.title,
            theme: lesson.theme,
            lessonType: lesson.lessonType,
            category: lesson.category,
            primarySubject: lesson.primarySubject,
            storyOpening: lesson.storyOpening,
            missionPrompt: lesson.missionPrompt,
            readingPassage: lesson.readingPassage,
            questions: reading,
            mathChallenges: math.isEmpty && lesson.focusesOnMath
                ? MathWordProblemGenerator.generateQuestions(
                    topic: lesson.theme,
                    seed: 11,
                    level: LessonDifficultyRules.readingLevel(forMath: ability.mathLevel),
                    mathLevel: AgeGradeLearningStandards.cappedMathLevel(ability.mathLevel, age: ability.age),
                    count: ability.rules.mathQuestionRange.lowerBound,
                    age: ability.age
                )
                : math,
            vocabularyWords: lesson.vocabularyWords,
            knowledgeFacts: lesson.knowledgeFacts,
            creativePrompt: lesson.creativePrompt,
            creativeResponseType: lesson.creativeResponseType,
            storyEnding: lesson.storyEnding,
            ageTarget: lesson.ageTarget,
            gradeTarget: lesson.gradeTarget,
            readingLevel: ability.readingLevel,
            learningGoal: lesson.learningGoal,
            estimatedMinutes: lesson.estimatedMinutes,
            teaser: lesson.teaser,
            difficultyLabel: ability.readingLevel.rawValue,
            readingSkill: lesson.readingSkill,
            mathSkill: lesson.mathSkill,
            reflectionPrompt: lesson.reflectionPrompt,
            reflectionResponseType: lesson.reflectionResponseType,
            skillsPracticed: lesson.skillsPracticed,
            primaryTopicId: lesson.primaryTopicId,
            supportingTopicIds: lesson.supportingTopicIds,
            prerequisiteTopicIds: lesson.prerequisiteTopicIds,
            curriculumSubject: lesson.curriculumSubject,
            curriculumDomain: lesson.curriculumDomain,
            curriculumDifficulty: lesson.curriculumDifficulty,
            recommendedAgeRange: lesson.recommendedAgeRange,
            learningObjectives: lesson.learningObjectives,
            evidenceTargets: lesson.evidenceTargets
        )
    }

    private static func reapplyGroupingAfterRepair(
        _ lesson: Lesson,
        original: Lesson,
        ability: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations,
        notes: inout [String]
    ) -> Lesson {
        var passage = lesson.readingPassage
        var readingQuestions = lesson.questions
        var mathQuestions = lesson.mathChallenges
        restorePromisedGroupingActivities(
            original: original,
            ability: ability,
            passage: &passage,
            readingQuestions: &readingQuestions,
            mathQuestions: &mathQuestions,
            notes: &notes
        )
        readingQuestions = QuestionQualityValidator.prefixPreservingMatching(
            readingQuestions,
            cap: ability.rules.readingQuestionRange.upperBound
        )
        mathQuestions = Array(mathQuestions.prefix(ability.rules.mathQuestionRange.upperBound))
        let mission = MissionPromptNormalizer.alignedToActivities(
            existing: original.missionPrompt,
            questions: readingQuestions,
            mathChallenges: mathQuestions,
            maxSentences: max(1, expectations.maxInstructionSentences)
        )
        return withProse(
            lesson,
            mission: mission,
            passage: passage,
            questions: readingQuestions,
            mathChallenges: mathQuestions
        )
    }
    private static func restoreCanonicalProse(_ adapted: Lesson, from original: Lesson) -> Lesson {
        var copy = adapted
        if !ChildFacingProseQualityValidator.passes(adapted.storyOpening),
           ChildFacingProseQualityValidator.passes(original.storyOpening) {
            copy = withProse(copy, opening: original.storyOpening)
        }
        if !ChildFacingProseQualityValidator.passes(adapted.missionPrompt, allowShortImperative: true),
           ChildFacingProseQualityValidator.passes(original.missionPrompt, allowShortImperative: true) {
            copy = withProse(copy, mission: original.missionPrompt)
        }
        if !ChildFacingProseQualityValidator.passes(adapted.readingPassage),
           ChildFacingProseQualityValidator.passes(original.readingPassage) {
            copy = withProse(copy, passage: original.readingPassage)
        }
        if !ChildFacingProseQualityValidator.passes(adapted.storyEnding),
           ChildFacingProseQualityValidator.passes(original.storyEnding) {
            copy = withProse(copy, ending: original.storyEnding)
        }
        return copy
    }

    /// Last-resort topic-safe prose so children never see corrupt fragments.
    private static func applySafeProseFallbacks(_ lesson: Lesson, theme: Topic) -> Lesson {
        let topic = theme.rawValue.lowercased()
        let safePassage: String = {
            switch theme {
            case .horses:
                return "The ponies stand in the yard. They swish their tails. Mia speaks softly so they stay calm."
            case .sharks, .oceanAnimals:
                return "Willa sees a blue wave. She swims slowly. A small fish dashes by."
            case .space, .planets, .rockets:
                return "Nova sees a bright star. She waves hello. The moon looks close and kind."
            case .dinosaurs:
                return "Dottie finds a green leaf. She munches slowly. A friend stomps nearby."
            default:
                return "Sam looks carefully. Sam listens. Sam learns one new fact about \(topic)."
            }
        }()
        let safeOpening = "Today we explore \(theme.rawValue) together."
        let safeMission = "Read the short story. Then answer with clues from the text."
        let safeEnding = "Great work exploring \(theme.rawValue) today!"

        var opening = lesson.storyOpening
        var mission = lesson.missionPrompt
        var passage = lesson.readingPassage
        var ending = lesson.storyEnding
        if !ChildFacingProseQualityValidator.passes(opening) { opening = safeOpening }
        if !ChildFacingProseQualityValidator.passes(mission, allowShortImperative: true) { mission = safeMission }
        if !ChildFacingProseQualityValidator.passes(passage) { passage = safePassage }
        if !ChildFacingProseQualityValidator.passes(ending) { ending = safeEnding }
        return withProse(lesson, opening: opening, mission: mission, passage: passage, ending: ending)
    }

    private static func withProse(
        _ lesson: Lesson,
        opening: String? = nil,
        mission: String? = nil,
        passage: String? = nil,
        ending: String? = nil,
        questions: [LessonQuestion]? = nil,
        mathChallenges: [LessonQuestion]? = nil
    ) -> Lesson {
        Lesson(
            id: lesson.id,
            title: lesson.title,
            theme: lesson.theme,
            lessonType: lesson.lessonType,
            category: lesson.category,
            primarySubject: lesson.primarySubject,
            storyOpening: opening ?? lesson.storyOpening,
            missionPrompt: mission ?? lesson.missionPrompt,
            readingPassage: passage ?? lesson.readingPassage,
            questions: questions ?? lesson.questions,
            mathChallenges: mathChallenges ?? lesson.mathChallenges,
            vocabularyWords: lesson.vocabularyWords,
            knowledgeFacts: lesson.knowledgeFacts,
            creativePrompt: lesson.creativePrompt,
            creativeResponseType: lesson.creativeResponseType,
            storyEnding: ending ?? lesson.storyEnding,
            ageTarget: lesson.ageTarget,
            gradeTarget: lesson.gradeTarget,
            readingLevel: lesson.readingLevel,
            mathLevel: lesson.mathLevel,
            learningGoal: lesson.learningGoal,
            estimatedMinutes: lesson.estimatedMinutes,
            teaser: lesson.teaser,
            difficultyLabel: lesson.difficultyLabel,
            readingSkill: lesson.readingSkill,
            mathSkill: lesson.mathSkill,
            reflectionPrompt: lesson.reflectionPrompt,
            reflectionResponseType: lesson.reflectionResponseType,
            skillsPracticed: lesson.skillsPracticed,
            standardSkillId: lesson.standardSkillId,
            contentApprovalStatus: lesson.contentApprovalStatus,
            hints: lesson.hints,
            commonMistakes: lesson.commonMistakes,
            successCriteria: lesson.successCriteria,
            primaryTopicId: lesson.primaryTopicId,
            supportingTopicIds: lesson.supportingTopicIds,
            prerequisiteTopicIds: lesson.prerequisiteTopicIds,
            curriculumSubject: lesson.curriculumSubject,
            curriculumDomain: lesson.curriculumDomain,
            curriculumDifficulty: lesson.curriculumDifficulty,
            recommendedAgeRange: lesson.recommendedAgeRange,
            learningObjectives: lesson.learningObjectives,
            evidenceTargets: lesson.evidenceTargets
        )
    }

    /// If the story promised sorting / sized groups, keep those activities after adaptation.
    private static func restorePromisedGroupingActivities(
        original: Lesson,
        ability: LearnerAbilityProfile,
        passage: inout String,
        readingQuestions: inout [LessonQuestion],
        mathQuestions: inout [LessonQuestion],
        notes: inout [String]
    ) {
        guard original.focusesOnMath else { return }
        let blob = (original.missionPrompt + " " + original.storyOpening + " " + original.readingPassage).lowercased()
        let promisedSort = blob.contains("into groups") || blob.contains("sort the")
        let promisedSize = MissionPromptNormalizer.groupSize(in: blob)
        guard promisedSort || promisedSize != nil else { return }

        if promisedSort {
            let adaptedPairs = GroupingSortQuestionBuilder.pairs(from: passage)
            if adaptedPairs.count < 3, GroupingSortQuestionBuilder.pairs(from: original.readingPassage).count >= 3 {
                passage = original.readingPassage
                notes.append("Kept original grouping sentences so the sort activity still works")
            }
            let hasMatching = readingQuestions.contains { $0.responseType == .matching }
                || mathQuestions.contains { $0.responseType == .matching }
            if !hasMatching {
                let match = ThemeInteractionQuestions.groupingMatch(from: passage)
                    ?? ThemeInteractionQuestions.groupingMatch(from: original.readingPassage)
                if let match {
                    if GroupingSortQuestionBuilder.pairs(from: passage).count < 3 {
                        passage = original.readingPassage
                    }
                    readingQuestions.insert(match, at: 0)
                    notes.append("Restored the item-matching sort activity")
                }
            }
        }

        if let promisedSize, AgeGradeLearningStandards.allowsMultiplicativeMath(forAge: ability.age) {
            let mathBlob = mathQuestions.map(\.prompt).joined(separator: " ").lowercased()
            let hasSizedGroups = MissionPromptNormalizer.groupSize(in: mathBlob) == promisedSize
            if !hasSizedGroups {
                let sessionMath = AgeGradeLearningStandards.cappedMathLevel(ability.mathLevel, age: ability.age)
                let generated = MathWordProblemGenerator.generateGroupingQuestions(
                    topic: original.theme,
                    seed: MathWordProblemGenerator.varietySeed(
                        topic: original.theme,
                        mathLevel: sessionMath,
                        readingLevel: ability.readingLevel
                    ),
                    level: ability.readingLevel,
                    mathLevel: sessionMath,
                    count: max(3, ability.rules.mathQuestionRange.lowerBound),
                    passage: passage,
                    age: ability.age
                )
                if let groups = generated.first(where: {
                    MissionPromptNormalizer.groupSize(in: $0.prompt) == promisedSize
                }) {
                    mathQuestions.insert(groups, at: 0)
                    notes.append("Restored groups-of-\(promisedSize) math")
                }
            }
        }
    }

    // MARK: - Helpers

    private static func ensureCorrectAnswerInChoices(_ question: LessonQuestion) -> LessonQuestion {
        guard !question.choices.isEmpty,
              let correct = question.correctAnswer,
              !correct.isEmpty else {
            return question
        }
        if question.choices.contains(where: { $0.caseInsensitiveCompare(correct) == .orderedSame }) {
            return question
        }
        // Prefer a choice that shares most words with the correct answer after simplification.
        let correctWords = Set(correct.lowercased().split(separator: " ").map(String.init))
        if let best = question.choices.max(by: { a, b in
            let aScore = Set(a.lowercased().split(separator: " ").map(String.init)).intersection(correctWords).count
            let bScore = Set(b.lowercased().split(separator: " ").map(String.init)).intersection(correctWords).count
            return aScore < bScore
        }), !correctWords.isEmpty {
            return LessonQuestion(
                id: question.id,
                subject: question.subject,
                type: question.type,
                responseType: question.responseType,
                prompt: question.prompt,
                choices: question.choices,
                correctAnswer: best,
                explanation: question.explanation,
                difficultyLevel: question.difficultyLevel,
                pairs: question.pairs,
                items: question.items,
                mysteryKind: question.mysteryKind,
                mysterySetup: question.mysterySetup,
                clues: question.clues
            )
        }
        return question
    }

    private static func isInferenceHeavy(_ question: LessonQuestion) -> Bool {
        let lower = question.prompt.lowercased()
        if question.isProgressiveMystery { return true }
        let markers = [
            "why do you think", "what can you infer", "most likely",
            "best conclusion", "based on all the clues", "what best explains",
            "why might"
        ]
        return markers.contains { lower.contains($0) }
    }

    private static func isGroundedInPassage(_ question: LessonQuestion, passage: String) -> Bool {
        guard let answer = question.correctAnswer?.lowercased(), !answer.isEmpty else {
            return question.isProgressiveMystery || !question.pairs.isEmpty
        }
        let haystack = passage.lowercased()
        if haystack.contains(answer) { return true }
        let words = answer.split(separator: " ").map(String.init).filter { $0.count > 3 }
        return words.contains { haystack.contains($0) }
    }

    private static func looksMultiStep(_ prompt: String) -> Bool {
        let lower = prompt.lowercased()
        return lower.contains("then") && (lower.contains("first") || lower.contains("after that") || lower.contains("next"))
    }

    private static func looksMultiplicative(_ prompt: String) -> Bool {
        let lower = prompt.lowercased()
        return lower.contains("groups of")
            || lower.contains("equal groups")
            || lower.contains("in each")
            || lower.contains("share equally")
            || lower.contains("how many groups")
            || lower.contains("times as many")
            || prompt.contains("×")
            || prompt.contains("÷")
    }

    private static func exceedsAgeCurriculum(
        _ question: LessonQuestion,
        ability: LearnerAbilityProfile,
        expectations: AgeGradeLearningStandards.Expectations
    ) -> Bool {
        if !expectations.allowMultiStepMath, looksMultiStep(question.prompt) { return true }
        if !AgeGradeLearningStandards.allowsMultiplicativeMath(forAge: ability.age), looksMultiplicative(question.prompt) {
            return true
        }
        let cap = AgeGradeLearningStandards.mathOperandUpperBound(forAge: ability.age)
        let numbers = MathProblemValidator.extractIntegers(from: question.prompt)
        if numbers.contains(where: { $0 > cap }) { return true }
        if let answer = question.correctAnswer,
           let value = Int(answer.trimmingCharacters(in: .whitespaces)),
           value > cap {
            return true
        }
        return false
    }

    private static func makeLetterSoundQuestion(
        passage: String,
        vocabulary: [VocabularyWord],
        existing: [LessonQuestion]
    ) -> LessonQuestion? {
        if existing.contains(where: { $0.prompt.lowercased().contains("starts with") }) {
            return nil
        }
        let storyWords = passage
            .split { !$0.isLetter }
            .map(String.init)
        let vocabTargets = vocabulary
            .map { $0.word.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { word in
                isBeginnerPhonicsWord(word)
                    && passage.localizedCaseInsensitiveContains(word)
            }
        let simpleStoryWords = storyWords.filter(isBeginnerPhonicsWord)
        let pool = uniquedWords(vocabTargets + simpleStoryWords)
        guard let target = pool.first, let letter = target.first, letter.isLetter else { return nil }
        let letterName = String(letter).uppercased()
        let distractors = pool
            .filter { $0.compare(target, options: .caseInsensitive) != .orderedSame }
            .filter { $0.uppercased().hasPrefix(letterName) == false }
        guard distractors.count >= 2 else { return nil }
        var choices = [target, distractors[0], distractors[1]]
        let pivot = abs(target.hashValue) % choices.count
        if pivot > 0 {
            choices = Array(choices[pivot...]) + Array(choices[..<pivot])
        }
        return LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "Which word starts with the letter \(letterName)?",
            choices: choices,
            correctAnswer: target,
            explanation: "\(target.capitalized) starts with \(letterName)."
        )
    }

    /// Short, decodable words only. Skip "the" and science vocab like "friction".
    private static func isBeginnerPhonicsWord(_ word: String) -> Bool {
        let trimmed = word.trimmingCharacters(in: .whitespacesAndNewlines)
        guard (3...5).contains(trimmed.count), trimmed.allSatisfy(\.isLetter) else { return false }
        let stopwords: Set<String> = [
            "the", "and", "she", "his", "her", "for", "was", "with", "that", "this",
            "they", "but", "not", "you", "are", "from", "had", "have", "has", "were",
            "been", "one", "two", "all", "can", "him", "who", "how", "why", "when",
            "then", "than", "into", "onto", "over", "just", "like", "more", "some",
            "very", "also", "only", "even", "much", "many", "each", "both", "few"
        ]
        return !stopwords.contains(trimmed.lowercased())
    }

    private static func uniquedWords(_ words: [String]) -> [String] {
        words.reduce(into: [String]()) { unique, word in
            if !unique.contains(where: { $0.compare(word, options: .caseInsensitive) == .orderedSame }) {
                unique.append(word)
            }
        }
    }

    private static func ageTarget(for age: Int) -> String {
        let low = max(4, age - 1)
        let high = min(12, age + 1)
        return "\(low)-\(high)"
    }

    private static func mathSkillLabel(for ability: LearnerAbilityProfile) -> String {
        MathWordProblemGenerator.primarySkillName(
            seed: ability.age,
            level: LessonDifficultyRules.readingLevel(forMath: ability.mathLevel),
            mathLevel: ability.mathLevel
        )
    }
}
