import Foundation

/// Blocks lessons that look polished but are educationally incoherent:
/// academic titles, unsupported questions, theme mismatch, recycled skeletons.
enum LessonContentCoherenceValidator {

    struct Issue: Equatable {
        let code: String
        let detail: String
    }

    struct Result: Equatable {
        let issues: [Issue]
        var passed: Bool { issues.isEmpty }

        var summary: String {
            issues.map { "\($0.code): \($0.detail)" }.joined(separator: "; ")
        }
    }

    /// Academic skill labels that must not be glued into child-facing titles.
    private static let academicTitleFragments = [
        "sequencing", "inference", "main idea", "comprehension", "prediction",
        "phonics", "letter and sound", "character motivation", "place value",
        "multi-step", "number recognition", "addition and subtraction"
    ]

    private static let recycledSkeletonMarkers = [
        "followed the", "trail after rain", "quiet cove",
        "sam predicted the", "sun warmed the stones",
        "studied the", "cove like a detective",
        "\(Topic.jungleAnimals.rawValue.lowercased()) trail",
        "horses toys", "sharks stickers", "dinosaurs tokens"
    ]

    static func validate(_ lesson: Lesson) -> Result {
        var issues: [Issue] = []

        if hasAcademicSkillTitle(lesson.title) {
            issues.append(Issue(
                code: "title_academic_label",
                detail: "Child-facing title looks like a curriculum label: \"\(lesson.title)\""
            ))
        }

        if titleImpliesMissingSkill(lesson) {
            issues.append(Issue(
                code: "title_skill_mismatch",
                detail: "Title implies a skill the questions/passage do not practice"
            ))
        }

        if !themeMatchesContent(lesson) {
            issues.append(Issue(
                code: "theme_mismatch",
                detail: "Passage/questions lack topic-specific content for \(lesson.theme.rawValue)"
            ))
        }

        for question in lesson.questions where question.subject != .math {
            if let detail = unsupportedQuestionDetail(question, lesson: lesson) {
                issues.append(Issue(code: "unsupported_question", detail: detail))
            }
        }

        if reflectionMentionsMissingCharacter(lesson) {
            issues.append(Issue(
                code: "reflection_character_mismatch",
                detail: "Reflection mentions a character who never appears in the lesson"
            ))
        }

        if looksLikeRecycledSkeleton(lesson) {
            issues.append(Issue(
                code: "recycled_template",
                detail: "Content matches a recycled noun-swap skeleton"
            ))
        }

        if missionClaimsMissingBeat(lesson) {
            issues.append(Issue(
                code: "mission_story_mismatch",
                detail: "Mission asks for a prediction/inference beat the story does not provide"
            ))
        }

        if let invented = inventedKnowledgeTerm(in: lesson) {
            issues.append(Issue(
                code: "invented_knowledge_term",
                detail: invented
            ))
        }

        if hasTemplatePacksTitle(lesson.title) {
            issues.append(Issue(
                code: "invented_title",
                detail: "Child-facing title uses leftover Packs template: \"\(lesson.title)\""
            ))
        }

        #if DEBUG
        if !issues.isEmpty {
            print("🚫 LessonContentCoherenceValidator blocked \"\(lesson.title)\": \(Result(issues: issues).summary)")
        }
        #endif

        return Result(issues: issues)
    }

    // MARK: - Checks

    static func hasAcademicSkillTitle(_ title: String) -> Bool {
        let lower = title.lowercased()
        // "Horses: Main idea and sequencing" / "Horses and Sequencing" / "Discover Horses: …"
        if lower.contains(": ") {
            let after = lower.split(separator: ":", maxSplits: 1).last.map(String.init) ?? ""
            if academicTitleFragments.contains(where: { after.contains($0) }) {
                return true
            }
        }
        if academicTitleFragments.contains(where: { lower.contains(" and \($0)") || lower.hasSuffix($0) }) {
            // Allow natural titles like "Reading a Horse's Ears" — only flag Topic-and-Skill patterns.
            let topicLike = Topic.allCases.contains { lower.hasPrefix($0.rawValue.lowercased()) }
            if topicLike { return true }
        }
        if lower.contains(" math: ") { return true }
        return false
    }

    private static func titleImpliesMissingSkill(_ lesson: Lesson) -> Bool {
        let title = lesson.title.lowercased()
        let blob = combinedText(lesson).lowercased()
        let questionBlob = (lesson.questions + lesson.mathChallenges)
            .map(\.prompt)
            .joined(separator: " ")
            .lowercased()

        if title.contains("predict") || title.contains("prediction") {
            return !(blob.contains("predict") || questionBlob.contains("predict"))
        }
        if title.contains("sequence") || title.contains("first, next") || title.contains("what happened first") {
            // Sequencing via MCQ details is OK if ordered events exist; block if nothing ordered.
            let orderSignals = ["first", "then", "after", "before", "next", "last"]
            return !orderSignals.contains(where: { blob.contains($0) })
        }
        if title.contains("count") {
            return lesson.primarySubject != .math
                && !questionBlob.contains("how many")
                && !blob.contains("count")
        }
        return false
    }

    private static func themeMatchesContent(_ lesson: Lesson) -> Bool {
        let keywords = QuestionQualityValidator.topicKeywords(for: lesson.theme)
        guard !keywords.isEmpty else { return true }
        let blob = combinedText(lesson).lowercased()
        let hits = keywords.filter { blob.contains($0.lowercased()) }
        // Math lessons may be shorter; require at least one strong theme hit.
        if lesson.primarySubject == .math {
            return hits.count >= 1 || blob.contains(lesson.theme.rawValue.lowercased())
        }
        return hits.count >= 2 || blob.contains(lesson.theme.rawValue.lowercased())
    }

    private static func unsupportedQuestionDetail(_ question: LessonQuestion, lesson: Lesson) -> String? {
        let passage = lesson.readingPassage.lowercased()
        let prompt = question.prompt.lowercased()
        let opening = lesson.storyOpening.lowercased()
        let full = (passage + " " + opening)

        if prompt.contains("predict") || prompt.contains("prediction") {
            if !(full.contains("predict") || full.contains("prediction") || full.contains("predicted")) {
                return "Asks about a prediction that never appears: \(question.prompt)"
            }
        }

        // Flag classic template characters that appear in the prompt but never in the story.
        for name in ["Sam", "Alex"] {
            let lower = name.lowercased()
            if question.prompt.range(of: #"\b\#(lower)\b"#, options: [.regularExpression, .caseInsensitive]) != nil,
               !full.contains(lower),
               !lesson.storyEnding.lowercased().contains(lower) {
                return "Mentions \"\(name)\" who is not in the story: \(question.prompt)"
            }
        }

        guard let answer = question.correctAnswer?.lowercased(), !answer.isEmpty else { return nil }
        if question.subject == .math { return nil }
        if QuestionQualityValidator.looksLikeMetaComprehensionPrompt(question.prompt) {
            return "Asks about inventing clues instead of the story: \(question.prompt)"
        }
        if passage.contains(answer) { return nil }
        let words = answer.split(separator: " ").map(String.init).filter { $0.count > 3 }
        if words.contains(where: { passage.contains($0) }) { return nil }
        // Allow short yes/no and directional answers.
        if ["yes", "no", "left", "right", "same"].contains(answer) { return nil }
        return "Correct answer not supported by passage: \(question.prompt)"
    }

    private static func reflectionMentionsMissingCharacter(_ lesson: Lesson) -> Bool {
        let reflection = lesson.reflectionPrompt
        guard !reflection.isEmpty else { return false }
        let body = (lesson.readingPassage + " " + lesson.storyOpening + " " + lesson.storyEnding).lowercased()
        // Classic bug: "Was Sam's prediction right?" on a Mia horse lesson.
        for name in ["Sam", "Alex"] {
            let pattern = #"\b\#(name.lowercased())\b"#
            if reflection.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil {
                if !body.contains(name.lowercased()) { return true }
            }
        }
        return false
    }

    private static func looksLikeRecycledSkeleton(_ lesson: Lesson) -> Bool {
        let blob = combinedText(lesson).lowercased()
        let hits = recycledSkeletonMarkers.filter { blob.contains($0) }
        if hits.count >= 2 { return true }
        // Generic "Sam sees a <topic>" beginner skeleton
        if blob.contains("sam sees a \(lesson.theme.rawValue.lowercased())") { return true }
        if blob.contains("\(lesson.theme.rawValue.lowercased()) toys") { return true }
        return false
    }

    private static func missionClaimsMissingBeat(_ lesson: Lesson) -> Bool {
        let mission = lesson.missionPrompt.lowercased()
        let passage = lesson.readingPassage.lowercased()
        if mission.contains("prediction") || mission.contains("predict") {
            return !(passage.contains("predict") || passage.contains("prediction") || passage.contains("predicted"))
        }
        if mission.contains("inference") || mission.contains("infer") {
            // Inference missions need clue language in the story.
            let clueSignals = ["clue", "infer", "evidence", "compare", "concluded", "decided", "because"]
            return !clueSignals.contains(where: { passage.contains($0) })
        }
        if (mission.contains("sort") && mission.contains("into groups"))
            || (mission.contains("match") && mission.contains("place"))
            || (lesson.storyOpening.lowercased().contains("sort")
                && lesson.storyOpening.lowercased().contains("into groups")) {
            let hasMatchingSort = lesson.questions.contains { $0.responseType == .matching }
                || lesson.mathChallenges.contains { $0.responseType == .matching }
            if !hasMatchingSort {
                return true
            }
        }
        if let size = MissionPromptNormalizer.groupSize(in: mission) {
            let questionBlob = (lesson.questions + lesson.mathChallenges)
                .map(\.prompt)
                .joined(separator: " ")
                .lowercased()
            let hasSizedMath = MissionPromptNormalizer.groupSize(in: questionBlob) == size
                || questionBlob.contains("groups of \(size)")
            if !hasSizedMath {
                return true
            }
        }
        return false
    }

    /// Phrases that sound like subject facts but are not real terms.
    static let inventedKnowledgeTerms = [
        "two-part",
        "two-step",
        "multi-step",
        "shell pack",
        "card pack",
        "launch kit",
        "sparkle bead",
        "beach math",
        "poster math",
        "barn math",
        "glow marker",
        "planet card",
        "wing pin",
        "goal medal",
        "victory medal",
        "exploring kit"
    ]

    static func inventedKnowledgeTerm(in lesson: Lesson) -> String? {
        inventedKnowledgeTerm(inFacts: lesson.knowledgeFacts)
    }

    static func inventedKnowledgeTerm(inFacts facts: [KnowledgeFact]) -> String? {
        for fact in facts {
            let blob = (fact.fact + " " + fact.childFacingExplanation).lowercased()
            if let term = inventedKnowledgeTerms.first(where: { blob.contains($0) }) {
                return "Did You Know uses invented term \"\(term)\": \(fact.fact)"
            }
        }
        return nil
    }

    /// Leftover math-template titles like "Dolphin Watch Packs" that do not name the story.
    static func hasTemplatePacksTitle(_ title: String) -> Bool {
        title.range(of: #"\bpacks\b"#, options: [.regularExpression, .caseInsensitive]) != nil
    }

    /// Labels that tell a child a question has two parts when it may only have one.
    static let stepJargonPhrases = [
        "two-part", "two part",
        "two-step", "two step",
        "multi-step", "multi step",
        "check every step",
        "one step at a time",
        "plan the steps"
    ]

    static func childFacingStepJargon(in lesson: Lesson) -> String? {
        let fields: [(String, String)] = [
            ("title", lesson.title),
            ("mission", lesson.missionPrompt),
            ("teaser", lesson.teaser),
            ("mathSkill", lesson.mathSkill),
            ("creative", lesson.creativePrompt),
            ("reflection", lesson.reflectionPrompt)
        ]
            + lesson.skillsPracticed.map { ("skill", $0) }
            + lesson.hints.map { ("hint", $0) }
            + lesson.knowledgeFacts.map { ("Did You Know", $0.fact + " " + $0.childFacingExplanation) }
            + (lesson.questions + lesson.mathChallenges).map { ("question", $0.prompt) }
            + (lesson.questions + lesson.mathChallenges).compactMap { q in
                q.explanation.map { ("explanation", $0) }
            }
        let patterns = [
            #"\btwo-part\b"#,
            #"\btwo part\b"#,
            #"\btwo-step\b"#,
            #"\btwo step\b"#,
            #"\bmulti-step\b"#,
            #"\bmulti step\b"#,
            #"\bcheck every step\b"#,
            #"\bone step at a time\b"#,
            #"\bplan the steps\b"#
        ]
        for (label, text) in fields {
            for pattern in patterns {
                if text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil {
                    return "\(label) uses step jargon: \(text)"
                }
            }
        }
        return nil
    }

    /// Language that is too violent for ages 5–8 (castle shooting, invaders, TV-show echoes).
    static let unsafeChildPatterns = [
        #"\bbay watch\b"#,
        #"\barrow slits?\b"#,
        #"\binvaders?\b"#,
        #"\bduring an attack\b"#,
        #"\bmurder holes?\b"#,
        #"\barchers shoot\b"#
    ]

    static func childFacingUnsafeLanguage(in lesson: Lesson) -> String? {
        let fields: [(String, String)] = [
            ("title", lesson.title),
            ("opening", lesson.storyOpening),
            ("mission", lesson.missionPrompt),
            ("passage", lesson.readingPassage),
            ("ending", lesson.storyEnding),
            ("creative", lesson.creativePrompt),
            ("reflection", lesson.reflectionPrompt),
            ("teaser", lesson.teaser)
        ]
            + lesson.hints.map { ("hint", $0) }
            + lesson.knowledgeFacts.map { ("Did You Know", $0.fact + " " + $0.childFacingExplanation) }
            + lesson.vocabularyWords.map { ("vocab", $0.word + " " + $0.definition + " " + $0.exampleSentence) }
            + (lesson.questions + lesson.mathChallenges).map { ("question", $0.prompt) }
            + (lesson.questions + lesson.mathChallenges).compactMap { q in
                q.correctAnswer.map { ("answer", $0) }
            }
            + (lesson.questions + lesson.mathChallenges).compactMap { q in
                q.explanation.map { ("explanation", $0) }
            }
        for (label, text) in fields {
            if let issue = childFacingUnsafeLanguage(in: text, label: label) {
                return issue
            }
        }
        return nil
    }

    static func childFacingUnsafeLanguage(in text: String, label: String = "text") -> String? {
        for pattern in unsafeChildPatterns {
            if text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil {
                return "\(label) uses unsafe child language: \(text)"
            }
        }
        return nil
    }

    private static func combinedText(_ lesson: Lesson) -> String {
        ([
            lesson.title,
            lesson.storyOpening,
            lesson.missionPrompt,
            lesson.readingPassage,
            lesson.storyEnding,
            lesson.reflectionPrompt,
            lesson.creativePrompt
        ] + lesson.questions.map(\.prompt) + lesson.mathChallenges.map(\.prompt)
            + lesson.vocabularyWords.map(\.word)
            + lesson.knowledgeFacts.map(\.fact))
            .joined(separator: " ")
    }

}
