import Foundation

/// Converts backend content-pipeline JSON into the app `Lesson` model.
/// Pipeline output uses snake_case educational fields; the app uses the SwiftUI Lesson schema.
enum PipelineLessonAdapter {

    static func lesson(from data: Data) -> Lesson? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return lesson(from: json)
    }

    static func lesson(from json: [String: Any]) -> Lesson? {
        let status = (json["approval_status"] as? String)?.lowercased()
        guard status == "approved" || status == nil else { return nil }

        let title = json["title"] as? String ?? "Untitled Lesson"
        let theme = mapTopic(json["theme"] as? String)
        let readingLevel = mapReading(json["intended_reading_level"] as? String)
        let mathLevel = mapMath(json["intended_math_level"] as? String)
        let subjectRaw = (json["subject"] as? String)?.lowercased() ?? "reading"
        let primarySubject: PrimarySubject = {
            if subjectRaw.contains("math") { return .math }
            if subjectRaw.contains("science") { return .science }
            if subjectRaw.contains("creat") { return .creative }
            return .reading
        }()
        let category: LessonCategory = {
            switch primarySubject {
            case .math: return .math
            case .science: return .discovery
            case .creative: return .creative
            case .reading: return .story
            }
        }()

        let story = json["story_content"] as? [String: Any]
        let opening = json["story_opening"] as? String
            ?? story?["opening"] as? String
            ?? ""
        let passage = json["reading_passage"] as? String
            ?? story?["passage"] as? String
            ?? ""
        let ending = json["story_ending"] as? String
            ?? story?["ending"] as? String
            ?? "Great work today!"
        let rawInstructions = json["instructions"] as? String ?? "Read carefully and answer the questions."
        let objective = json["learning_objective"] as? String ?? ""
        let skillId = json["standard_skill_id"] as? String
        let childSkill = childFacingSkill(
            objective: objective,
            subject: primarySubject,
            readingLevel: readingLevel,
            mathLevel: mathLevel
        )
        let instructions = containsStepJargon(rawInstructions)
            ? "Solve each problem carefully."
            : rawInstructions
        let factText = childFacingFact(objective: objective, theme: theme)
        let rawHints = (json["questions"] as? [[String: Any]])?.compactMap { ($0["hints"] as? [String])?.first } ?? []
        let hints = rawHints.filter { !containsStepJargon($0) }
        let age = json["intended_age"] as? String ?? "5-8"
        let grade = json["intended_grade"] as? String ?? "K-2"

        let rawQuestions = json["questions"] as? [[String: Any]] ?? []
        var readingQs: [LessonQuestion] = []
        var mathQs: [LessonQuestion] = []
        for raw in rawQuestions {
            guard let q = mapQuestion(raw) else { continue }
            if q.subject == .math {
                mathQs.append(q)
            } else {
                readingQs.append(q)
            }
        }

        let measurement = json["reading_measurement"] as? [String: Any]
        let id: UUID = {
            if let raw = json["id"] as? String, let uuid = UUID(uuidString: raw) { return uuid }
            return UUID()
        }()

        let lesson = Lesson(
            id: id,
            title: title,
            theme: theme,
            lessonType: primarySubject == .math ? .builder : .explorer,
            category: category,
            primarySubject: primarySubject,
            storyOpening: opening,
            missionPrompt: instructions,
            readingPassage: passage,
            questions: readingQs,
            mathChallenges: mathQs,
            vocabularyWords: [
                VocabularyWord(
                    word: primarySubject == .math ? "total" : "explore",
                    definition: primarySubject == .math ? "How many in all." : "To look and learn.",
                    exampleSentence: "Today we explore new ideas."
                )
            ],
            knowledgeFacts: [
                KnowledgeFact(fact: factText)
            ],
            creativePrompt: readingLevel == .beginner
                ? "Draw a picture of one idea from today's lesson."
                : "Write one idea from today's lesson.",
            creativeResponseType: readingLevel == .beginner ? .drawing : .shortText,
            storyEnding: ending,
            ageTarget: age,
            gradeTarget: grade,
            readingLevel: readingLevel,
            mathLevel: mathLevel,
            learningGoal: primarySubject == .math ? .math : .reading,
            readingSkill: primarySubject == .reading ? childSkill : LevelSkillProgressions.readingFocus(for: readingLevel),
            mathSkill: primarySubject == .math ? childSkill : LevelSkillProgressions.mathFocus(for: mathLevel),
            reflectionPrompt: ReflectionPromptQuality.ensureConcrete(
                prompt: mathQs.first?.prompt
                    ?? readingQs.first?.prompt
                    ?? "What did you learn in this \(theme.rawValue.lowercased()) lesson?",
                questions: readingQs,
                mathChallenges: mathQs,
                knowledgeFacts: [
                    KnowledgeFact(fact: factText)
                ],
                title: title
            ),
            skillsPracticed: primarySubject == .math ? ["Math", childSkill] : [childSkill].filter { !$0.isEmpty },
            standardSkillId: skillId,
            contentApprovalStatus: .approved,
            hints: hints,
            commonMistakes: json["common_mistakes"] as? [String] ?? [],
            successCriteria: json["success_criteria"] as? [String] ?? [],
            intendedReadingBand: measurement?["intendedBand"] as? String,
            measuredReadingEstimate: measurement?["measuredEstimate"] as? Int,
            readingMeasurementProvider: measurement?["providerName"] as? String,
            learningObjectives: objective.isEmpty ? [] : [objective]
        )
        guard ChildFacingProseQualityValidator.validateLessonProse(lesson).passed else {
            return nil
        }
        return lesson
    }

    private static func mapQuestion(_ raw: [String: Any]) -> LessonQuestion? {
        let prompt = raw["prompt"] as? String ?? ""
        guard !prompt.isEmpty else { return nil }
        let subjectRaw = (raw["subject"] as? String)?.lowercased() ?? "reading"
        let subject: QuestionSubject = subjectRaw.contains("math") ? .math : .reading
        let choices = raw["choices"] as? [String] ?? []
        let answers = raw["correct_answers"] as? [String]
            ?? (raw["correct_answer"] as? String).map { [$0] }
            ?? []
        let answer = answers.first
        let explanation = raw["explanation"] as? String
        let id: UUID = {
            if let rawID = raw["id"] as? String, let uuid = UUID(uuidString: rawID) { return uuid }
            return UUID()
        }()
        return LessonQuestion(
            id: id,
            subject: subject,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: prompt,
            choices: choices,
            correctAnswer: answer,
            explanation: explanation
        )
    }

    private static func mapTopic(_ raw: String?) -> Topic {
        let value = (raw ?? "").lowercased()
        if value.contains("shark") { return .sharks }
        if value.contains("horse") { return .horses }
        if value.contains("dino") { return .dinosaurs }
        if value.contains("space") || value.contains("star") { return .space }
        if value.contains("ocean") { return .oceanAnimals }
        return Topic.allCases.first { $0.rawValue.lowercased().contains(value) } ?? .sharks
    }

    private static func mapReading(_ raw: String?) -> ReadingLevel {
        switch (raw ?? "").lowercased() {
        case "beginner": return .beginner
        case "early reader", "earlyreader": return .earlyReader
        case "growing reader", "growingreader": return .growingReader
        case "confident reader", "confidentreader": return .confidentReader
        default: return .earlyReader
        }
    }

    private static func mapMath(_ raw: String?) -> MathLevel {
        switch (raw ?? "").lowercased() {
        case "emerging": return .emerging
        case "developing": return .developing
        case "secure": return .secure
        case "advancing": return .advancing
        default: return .developing
        }
    }

    private static func containsStepJargon(_ text: String) -> Bool {
        let lower = text.lowercased()
        return LessonContentCoherenceValidator.stepJargonPhrases.contains { lower.contains($0) }
    }

    private static func childFacingSkill(
        objective: String,
        subject: PrimarySubject,
        readingLevel: ReadingLevel,
        mathLevel: MathLevel
    ) -> String {
        if objective.isEmpty || containsStepJargon(objective) {
            return subject == .math
                ? LevelSkillProgressions.mathFocus(for: mathLevel)
                : LevelSkillProgressions.readingFocus(for: readingLevel)
        }
        return objective
    }

    private static func childFacingFact(objective: String, theme: Topic) -> String {
        if !objective.isEmpty && !containsStepJargon(objective) {
            return objective
        }
        switch theme {
        case .sharks, .oceanAnimals:
            return "Reef sharks often hunt along the drop-off where the reef meets deeper water."
        case .horses:
            return "Horses can eat apples as a treat, along with hay and grass."
        case .space, .planets, .rockets:
            return "A countdown helps a launch team get ready before a rocket lifts off."
        case .dinosaurs:
            return "Fossils are traces of ancient life preserved in rock."
        default:
            return "Check the story numbers before you choose an answer."
        }
    }
}
