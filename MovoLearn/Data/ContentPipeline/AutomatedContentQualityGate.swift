import Foundation

/// Automated quality checks that must pass before a lesson can reach children.
/// Human educator review dashboard can be added later without changing this model.
enum AutomatedContentQualityGate {

    struct Check: Equatable {
        let code: String
        let passed: Bool
        let required: Bool
        let detail: String
    }

    struct Result: Equatable {
        let passed: Bool
        let checks: [Check]
        let approvalStatus: ContentApprovalStatus

        var failedRequired: [Check] {
            checks.filter { $0.required && !$0.passed }
        }

        var summary: String {
            failedRequired.map(\.detail).joined(separator: "; ")
        }
    }

    static let maxRegenerationAttempts = 3

    static func validate(
        lesson: Lesson,
        profile: ChildProfile? = nil,
        readingMeasurement: ReadingLevelMeasurement? = nil,
        existingTitles: [String] = []
    ) -> Result {
        var checks: [Check] = []

        let hasObjective = !lesson.learningObjectives.isEmpty
            || !lesson.readingSkill.isEmpty
            || !lesson.mathSkill.isEmpty
        checks.append(Check(
            code: "learning_objective",
            passed: hasObjective,
            required: true,
            detail: hasObjective ? "Has learning objective" : "Missing learning objective"
        ))

        if let profile {
            let readingOK = abs(lesson.readingLevel.sortOrder - profile.readingLevel.sortOrder) <= 1
            checks.append(Check(
                code: "reading_level",
                passed: readingOK,
                required: true,
                detail: readingOK
                    ? "Reading level appropriate"
                    : "Reading level \(lesson.readingLevel.rawValue) does not match profile \(profile.readingLevel.rawValue)"
            ))

            let mathOK: Bool
            if lesson.primarySubject == .math || !lesson.mathChallenges.isEmpty {
                mathOK = abs(lesson.mathLevel.sortOrder - profile.mathLevel.sortOrder) <= 1
            } else {
                mathOK = true
            }
            checks.append(Check(
                code: "math_level",
                passed: mathOK,
                required: lesson.primarySubject == .math,
                detail: mathOK
                    ? "Math level appropriate"
                    : "Math level \(lesson.mathLevel.rawValue) does not match profile \(profile.mathLevel.rawValue)"
            ))

            let ageOK = LessonDifficultyRules.ageMatches(lesson.ageTarget, profile.currentAge)
                || LessonDifficultyRules.ageMatches(lesson.recommendedAgeRange ?? lesson.ageTarget, profile.currentAge)
            checks.append(Check(
                code: "age_range",
                passed: ageOK,
                required: false,
                detail: ageOK ? "Age range OK" : "Age target may not match child age"
            ))
        }

        checks.append(Check(
            code: "subject",
            passed: true,
            required: true,
            detail: "Subject \(lesson.primarySubject.displayName)"
        ))

        let displayMission = MissionPromptNormalizer.childFacing(lesson.missionPrompt)
        let instructionsClear = !displayMission.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && displayMission.count >= 12
            && MissionPromptNormalizer.passes(displayMission)
        checks.append(Check(
            code: "clear_instructions",
            passed: instructionsClear,
            required: true,
            detail: instructionsClear
                ? "Instructions present"
                : "Mission instructions missing, unclear, or grammatically broken"
        ))

        let passage = lesson.readingPassage.trimmingCharacters(in: .whitespacesAndNewlines)
        if lesson.primarySubject == .reading || lesson.category == .story {
            let sentenceCount = passage
                .components(separatedBy: CharacterSet(charactersIn: ".!?"))
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                .count
            let target = LevelSkillProgressions.passageSentenceTarget(for: lesson.readingLevel)
            // Allow a wider band so authored level variants are not rejected for off-by-one sentence counts.
            let expanded = (max(1, target.lowerBound - 2))...(target.upperBound + 4)
            let passageOK = !passage.isEmpty && expanded.contains(sentenceCount)
            checks.append(Check(
                code: "passage_complexity",
                passed: passageOK,
                required: true,
                detail: passageOK
                    ? "Passage length fits reading level"
                    : "Passage sentence count \(sentenceCount) outside \(target.lowerBound)–\(target.upperBound) for \(lesson.readingLevel.rawValue)"
            ))
        }

        if let measurement = readingMeasurement, !passage.isEmpty {
            checks.append(Check(
                code: "reading_measurement",
                passed: measurement.passesIntendedRange,
                required: true,
                detail: measurement.passesIntendedRange
                    ? "Reading measurement within intended band (\(measurement.providerName))"
                    : "Reading measurement outside intended band (\(measurement.providerName))"
            ))
        }

        let readingQs = lesson.childFacingQuestions
        let questionsRelate = readingQs.isEmpty || readingQs.allSatisfy { question in
            questionRelatesToContent(question, passage: passage, vocabulary: lesson.vocabularyWords)
        }
        checks.append(Check(
            code: "questions_relate",
            passed: questionsRelate,
            required: true,
            detail: questionsRelate ? "Questions relate to taught content" : "Some questions do not relate to the passage"
        ))

        let answersOK = (readingQs + lesson.childFacingMathChallenges).allSatisfy { q in
            guard q.responseType == .multipleChoice || q.responseType == .number else { return true }
            return !(q.correctAnswer?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        }
        checks.append(Check(
            code: "answers_present",
            passed: answersOK,
            required: true,
            detail: answersOK ? "Answers present" : "Missing unambiguous answers"
        ))

        let mathResult = MathProblemValidator.validateAll(
            lesson.childFacingMathChallenges + lesson.childFacingQuestions.filter { $0.subject == .math },
            mathLevel: lesson.mathLevel
        )
        checks.append(Check(
            code: "math_correctness",
            passed: mathResult.passed,
            required: !lesson.mathChallenges.isEmpty || lesson.primarySubject == .math,
            detail: mathResult.passed
                ? "Math answers validated"
                : "Math validation failed: \(mathResult.issues.map(\.message).joined(separator: "; "))"
        ))

        let explanationsOK = (readingQs + lesson.mathChallenges).allSatisfy { q in
            guard q.responseType == .multipleChoice else { return true }
            return !(q.explanation?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        }
        checks.append(Check(
            code: "explanations",
            passed: explanationsOK,
            required: false,
            detail: explanationsOK ? "Explanations present" : "Some explanations missing"
        ))

        let qualityIssues = QuestionQualityValidator.validateLesson(lesson)
        let blockingQuality = qualityIssues.filter {
            $0.localizedCaseInsensitiveContains("absurd")
                || $0.localizedCaseInsensitiveContains("joke")
                || $0.localizedCaseInsensitiveContains("without choices")
                || $0.localizedCaseInsensitiveContains("without pairs")
                || $0.localizedCaseInsensitiveContains("restates the answer")
        }
        checks.append(Check(
            code: "question_quality",
            passed: blockingQuality.isEmpty,
            required: true,
            detail: blockingQuality.isEmpty
                ? "Question quality OK"
                : blockingQuality.prefix(3).joined(separator: "; ")
        ))

        let unsafe = containsUnsafeContent(lesson)
        checks.append(Check(
            code: "safety",
            passed: !unsafe,
            required: true,
            detail: unsafe ? "Inappropriate or unsafe material detected" : "Safety OK"
        ))

        let filler = looksLikeFiller(lesson)
        checks.append(Check(
            code: "no_filler",
            passed: !filler,
            required: true,
            detail: filler ? "Meaningless filler detected" : "Content is substantive"
        ))

        let prose = ChildFacingProseQualityValidator.validateLessonProse(lesson)
        checks.append(Check(
            code: "prose_quality",
            passed: prose.passed,
            required: true,
            detail: prose.passed
                ? "Child-facing prose is grammatically clean"
                : prose.issues.prefix(3).map(\.description).joined(separator: "; ")
        ))

        let titleKey = normalizedTitle(lesson.title)
        let duplicateTitle = existingTitles.map(normalizedTitle).contains(titleKey)
            && existingTitles.contains(where: { normalizedTitle($0) == titleKey && $0 != lesson.title })
        checks.append(Check(
            code: "no_duplicate_title",
            passed: !duplicateTitle,
            required: false,
            detail: duplicateTitle ? "Duplicate title under different content risk" : "Title unique enough"
        ))

        let misleadingTeaser = lesson.teaser.localizedCaseInsensitiveContains("adventure")
            && lesson.readingPassage.isEmpty
            && lesson.primarySubject == .math
        checks.append(Check(
            code: "no_misleading_preview",
            passed: !misleadingTeaser,
            required: false,
            detail: misleadingTeaser ? "Teaser may mislead about content" : "Teaser OK"
        ))

        let coherence = LessonContentCoherenceValidator.validate(lesson)
        checks.append(Check(
            code: "content_coherence",
            passed: coherence.passed,
            required: true,
            detail: coherence.passed
                ? "Title, theme, story, and questions are coherent"
                : coherence.summary
        ))

        let reflectionOK = !ReflectionPromptQuality.isGeneric(lesson.reflectionPrompt)
        checks.append(Check(
            code: "concrete_reflection",
            passed: reflectionOK,
            required: true,
            detail: reflectionOK
                ? "Reflection prompt is lesson-specific"
                : "Reflection prompt is too generic: \"\(lesson.reflectionPrompt)\""
        ))

        let requiredFailed = checks.contains { $0.required && !$0.passed }
        let status: ContentApprovalStatus = requiredFailed ? .unavailable : .approved
        return Result(passed: !requiredFailed, checks: checks, approvalStatus: status)
    }

    private static func questionRelatesToContent(
        _ question: LessonQuestion,
        passage: String,
        vocabulary: [VocabularyWord]
    ) -> Bool {
        if question.subject == .math { return true }
        if question.responseType == .matching, !question.pairs.isEmpty {
            return true
        }
        let haystack = (
            passage + " " + vocabulary.map(\.word).joined(separator: " ") + " "
                + (question.correctAnswer ?? "")
        ).lowercased()
        let tokens = question.prompt.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 3 }
        guard !tokens.isEmpty else { return !passage.isEmpty }
        let overlap = tokens.filter { haystack.contains($0) }.count
        if overlap >= 1 { return true }
        // Accept if the correct answer appears in the passage (literal comprehension).
        if let answer = question.correctAnswer?.lowercased(), !answer.isEmpty, haystack.contains(answer) {
            return true
        }
        return question.subject == .vocabulary
    }

    private static func containsUnsafeContent(_ lesson: Lesson) -> Bool {
        let blob = [
            lesson.title, lesson.storyOpening, lesson.missionPrompt, lesson.readingPassage,
            lesson.storyEnding, lesson.creativePrompt
        ].joined(separator: " ").lowercased()
        let banned = ["\\bkill\\b", "\\bblood\\b", "\\bweapon\\b", "\\bhate\\b", "\\bnude\\b", "\\bsuicide\\b"]
        if banned.contains(where: { pattern in
            blob.range(of: pattern, options: .regularExpression) != nil
        }) {
            return true
        }
        return LessonContentCoherenceValidator.childFacingUnsafeLanguage(in: lesson) != nil
    }

    private static func looksLikeFiller(_ lesson: Lesson) -> Bool {
        let passage = lesson.readingPassage.trimmingCharacters(in: .whitespacesAndNewlines)
        if lesson.primarySubject == .reading && passage.count < 20 { return true }
        if lesson.questions.isEmpty && lesson.mathChallenges.isEmpty && lesson.creativePrompt.isEmpty {
            return true
        }
        return false
    }

    private static func normalizedTitle(_ title: String) -> String {
        title.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined()
    }
}
