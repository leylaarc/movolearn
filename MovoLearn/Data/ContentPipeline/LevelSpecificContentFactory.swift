import Foundation

/// Builds genuinely different lessons per reading and math level.
/// Used to seed the approved library offline — not for live unvalidated generation during child sessions.
enum LevelSpecificContentFactory {

    static func makeApprovedLesson(
        topic: Topic,
        category: LessonCategory,
        readingLevel: ReadingLevel,
        mathLevel: MathLevel,
        age: Int? = nil,
        grade: String? = nil
    ) -> Lesson? {
        let resolvedAge = age ?? LessonDifficultyRules.typicalAge(
            for: readingLevel,
            math: mathLevel,
            category: category
        )
        let resolvedGrade = grade ?? AgeGradeLearningStandards.suggestedGrade(forAge: resolvedAge)
        let standards = MockCASEStandardsProvider.shared
        _ = standards.loadIfNeeded()
        let subject = category == .math ? "Math" : (category == .story ? "Reading" : "Science")
        let skill = standards.recommendSkill(
            subject: subject,
            grade: resolvedGrade,
            readingLevel: category == .math ? nil : readingLevel,
            mathLevel: category == .math ? mathLevel : nil,
            masteredIds: [],
            practiceIds: []
        )

        // Quality over volume: only seed topics with curated, topic-specific packs.
        // Never fall back to noun-swapped Sam/trail skeletons.
        let draft: Lesson?
        switch category {
        case .math:
            draft = makeMathLesson(
                topic: topic,
                readingLevel: readingLevel,
                mathLevel: mathLevel,
                age: resolvedAge,
                grade: resolvedGrade,
                skill: skill
            )
        case .story:
            draft = makeReadingLesson(
                topic: topic,
                readingLevel: readingLevel,
                mathLevel: mathLevel,
                age: resolvedAge,
                grade: resolvedGrade,
                skill: skill
            )
        case .discovery:
            draft = makeDiscoveryLesson(
                topic: topic,
                readingLevel: readingLevel,
                mathLevel: mathLevel,
                age: resolvedAge,
                grade: resolvedGrade,
                skill: skill
            )
        case .creative:
            draft = makeCreativeLesson(
                topic: topic,
                readingLevel: readingLevel,
                mathLevel: mathLevel,
                age: resolvedAge,
                grade: resolvedGrade,
                skill: skill
            )
        }
        guard var draft else { return nil }

        let measurement = MockReadabilityProvider().measure(
            passage: draft.readingPassage,
            intendedReadingLevel: readingLevel
        )

        draft.intendedReadingBand = measurement.intendedBand
        draft.measuredReadingEstimate = measurement.measuredEstimate
        draft.readingMeasurementProvider = measurement.providerName
        draft.creativePrompt = CreativePromptQuality.ensureStoryComprehension(
            prompt: draft.creativePrompt,
            responseType: draft.creativeResponseType,
            lesson: draft
        )
        draft.reflectionPrompt = ReflectionPromptQuality.ensureConcrete(
            prompt: draft.reflectionPrompt,
            lesson: draft
        )

        var lesson = ChildFacingProseQualityValidator.polishLesson(draft)
        let profile = ChildProfile(
            age: resolvedAge,
            grade: resolvedGrade,
            readingLevel: readingLevel,
            mathLevel: mathLevel
        )

        // Factory content is authored to level bands; mock readability is advisory.
        // Require structural/math/safety checks, but don't block solely on mock Lexile heuristics.
        var gate = AutomatedContentQualityGate.validate(
            lesson: lesson,
            profile: profile,
            readingMeasurement: nil
        )

        if !gate.passed {
            lesson = repairForApproval(lesson, mathLevel: mathLevel)
            gate = AutomatedContentQualityGate.validate(
                lesson: lesson,
                profile: profile,
                readingMeasurement: nil
            )
        }

        let coherence = LessonContentCoherenceValidator.validate(lesson)
        guard gate.passed, coherence.passed else {
            #if DEBUG
            let reason = gate.passed ? coherence.summary : gate.summary
            print("Factory approval failed \(topic.rawValue)/\(category.rawValue)/\(readingLevel.rawValue)/\(mathLevel.rawValue): \(reason)")
            #endif
            return nil
        }
        lesson.contentApprovalStatus = .approved
        return lesson
    }

    /// Fix common auto-fail issues so offline seeds remain available.
    private static func repairForApproval(_ lesson: Lesson, mathLevel: MathLevel) -> Lesson {
        let math = MathProblemValidator.validateAll(
            lesson.mathChallenges + lesson.questions.filter { $0.subject == .math },
            mathLevel: mathLevel
        )
        var mathChallenges = lesson.mathChallenges
        var questions = lesson.questions
        if !math.passed {
            questions = questions.filter { $0.subject != .math }
            if lesson.focusesOnMath {
                mathChallenges = Array(mathProblems(topic: lesson.theme, mathLevel: mathLevel, readingLevel: lesson.readingLevel).prefix(max(1, lesson.mathChallenges.count)))
            } else {
                mathChallenges = []
            }
        }
        let missionRaw = lesson.missionPrompt.trimmingCharacters(in: .whitespacesAndNewlines).count >= 12
            ? lesson.missionPrompt
            : "Read carefully. Answer each question."
        let mission = MissionPromptNormalizer.alignedToActivities(
            existing: MissionPromptNormalizer.childFacing(missionRaw),
            questions: questions,
            mathChallenges: mathChallenges
        )
        return ChildFacingProseQualityValidator.polishLesson(Lesson(
            id: lesson.id,
            title: lesson.title,
            theme: lesson.theme,
            lessonType: lesson.lessonType,
            category: lesson.category,
            primarySubject: lesson.primarySubject,
            storyOpening: lesson.storyOpening,
            missionPrompt: mission,
            readingPassage: lesson.readingPassage,
            questions: questions,
            mathChallenges: mathChallenges,
            vocabularyWords: lesson.vocabularyWords,
            knowledgeFacts: lesson.knowledgeFacts,
            creativePrompt: lesson.creativePrompt.isEmpty ? "Draw a picture of one idea from the lesson." : lesson.creativePrompt,
            creativeResponseType: lesson.creativePrompt.isEmpty ? .drawing : lesson.creativeResponseType,
            storyEnding: lesson.storyEnding,
            ageTarget: lesson.ageTarget,
            gradeTarget: lesson.gradeTarget,
            readingLevel: lesson.readingLevel,
            mathLevel: lesson.mathLevel,
            learningGoal: lesson.learningGoal,
            readingSkill: lesson.readingSkill,
            mathSkill: lesson.mathSkill,
            reflectionPrompt: lesson.reflectionPrompt,
            reflectionResponseType: lesson.reflectionResponseType,
            skillsPracticed: lesson.skillsPracticed,
            standardSkillId: lesson.standardSkillId,
            contentApprovalStatus: .pendingValidation,
            hints: lesson.hints,
            commonMistakes: lesson.commonMistakes,
            successCriteria: lesson.successCriteria.isEmpty ? ["Complete the questions using the lesson"] : lesson.successCriteria,
            intendedReadingBand: lesson.intendedReadingBand,
            measuredReadingEstimate: lesson.measuredReadingEstimate,
            readingMeasurementProvider: lesson.readingMeasurementProvider,
            learningObjectives: lesson.learningObjectives.isEmpty ? [lesson.readingSkill, lesson.mathSkill].filter { !$0.isEmpty } : lesson.learningObjectives,
            drawingQuestGoals: lesson.drawingQuestGoals
        ))
    }

    // MARK: - Reading

    private static func makeReadingLesson(
        topic: Topic,
        readingLevel: ReadingLevel,
        mathLevel: MathLevel,
        age: Int,
        grade: String,
        skill: EducationalSkill?
    ) -> Lesson? {
        guard let pack = CuratedTopicLessonBank.readingPack(topic: topic, level: readingLevel) else {
            return nil
        }
        let focus = pack.readingSkill
        var objectives = pack.learningObjectives
        if let statement = skill?.fullStatement, !objectives.contains(statement) {
            objectives.append(statement)
        }
        objectives.append("fp:\(pack.activityFingerprint)")

        return Lesson(
            id: stableID(topic: topic, category: .story, reading: readingLevel, math: mathLevel),
            title: pack.title,
            theme: topic,
            lessonType: .detective,
            category: .story,
            primarySubject: .reading,
            storyOpening: pack.storyOpening,
            missionPrompt: pack.missionPrompt,
            readingPassage: pack.readingPassage,
            questions: pack.questions,
            mathChallenges: [],
            vocabularyWords: pack.vocabularyWords,
            knowledgeFacts: pack.knowledgeFacts,
            creativePrompt: pack.creativePrompt,
            creativeResponseType: pack.creativeResponseType,
            storyEnding: pack.storyEnding,
            ageTarget: ageBand(age),
            gradeTarget: grade,
            readingLevel: readingLevel,
            mathLevel: mathLevel,
            learningGoal: .reading,
            readingSkill: focus,
            mathSkill: "",
            reflectionPrompt: pack.reflectionPrompt,
            reflectionResponseType: .shortText,
            skillsPracticed: recapSkills(family: "Reading", specific: focus, includeVocabulary: !pack.vocabularyWords.isEmpty),
            standardSkillId: skill?.id,
            contentApprovalStatus: .pendingValidation,
            hints: pack.hints,
            commonMistakes: pack.commonMistakes,
            successCriteria: pack.successCriteria,
            learningObjectives: objectives
        )
    }

    private static func readingPassage(topic: String, level: ReadingLevel) -> String {
        let key = topic.lowercased()
        switch (key, level) {
        case ("horses", .beginner):
            return "The ponies stand in the yard. They swish their tails. Mia speaks softly so they stay calm."
        case ("horses", .earlyReader):
            return "Mia walks into the sunny yard. Three ponies flick their tails by the fence. She reminds the visitors to speak softly and move calmly. A foal stays close to its mother. Mia shows everyone how to stand where a horse can see them."
        case ("horses", .growingReader):
            return "Mia led the visitors into the sunny yard where three ponies swished their tails. She explained that horses feel safer when people speak softly, move calmly, and never approach from directly behind. A foal stayed near its mother while Mia pointed out how a horse's ears show curiosity or worry. The visitors practiced standing where the ponies could see them. By the end, everyone understood one clear rule: careful manners keep horses and people safe."
        case ("horses", .confidentReader):
            return """
            Mia guided the group into the sunny yard, where three ponies swished their tails and watched every step. She explained that horses rely on calm voices, steady movement, and clear sight lines to feel safe. Approaching from directly behind can startle them, so visitors learned to stand where a horse can see them first. A foal stayed close to its mother while Mia described how ear position and body language reveal curiosity or worry. Using those clues, the visitors practiced safer greetings before offering a gentle scratch on the neck. Mia finished by connecting each tip to one goal: thoughtful care protects both horses and people.
            """

        case ("sharks", .beginner):
            return "Finn sees a blue wave. He swims slowly. A small fish dashes by."
        case ("ocean animals", .beginner), ("ocean", .beginner):
            return "Willa sees a blue wave. She swims slowly. A small fish dashes by."
        case ("sharks", .earlyReader):
            return "Finn the reef shark glides near a sunny reef. He swims slowly and does not chase the little fish. Soft bubbles rise from the rocks. Then he tells a friend what he saw."
        case ("ocean animals", .earlyReader), ("ocean", .earlyReader):
            return "Willa glides near a sunny reef. She watches a gentle reef shark swim past. The shark moves slowly and does not chase the little fish. Willa counts the bubbles rising from the rocks. Then she tells a friend what she saw."
        case ("sharks", .growingReader):
            return "Finn followed the reef trail after a calm morning swim. Bubbles rose near a dark cave, and tiny fish darted into the coral. Reef sharks often rest in quiet pockets during the day. Finn settled in the cooler shade under the ledge. The details helped him decide where to rest next."
        case ("ocean animals", .growingReader), ("ocean", .growingReader):
            return "Willa followed the reef trail after a calm morning swim. Bubbles rose near a dark cave, and tiny fish darted into the coral. A guide explained that reef sharks often rest in quiet pockets during the day. Willa predicted the shark would return when the water warmed. Later she checked her notes against what she really saw. The details helped her decide what to watch next."
        case ("sharks", .confidentReader):
            return """
            Finn studied the reef like a careful young shark. Morning light made the water look calm, but ripples near the rocks suggested something moved below. Reef sharks choose resting spots for safety and cooler water. Finn compared two clues: fish fleeing inland, and a smooth shape sliding through deeper water. Using both details, he inferred that another shark had already shifted locations. That inference changed his plan for the next rest spot. He noticed two evidence clues before leaving for a quieter ledge.
            """
        case ("ocean animals", .confidentReader), ("ocean", .confidentReader):
            return """
            Willa studied the reef like a careful scientist. Morning light made the water look calm, but ripples near the rocks suggested something moved below. The guide said reef sharks choose resting spots for safety and cooler water. Willa compared two clues: fish fleeing inland, and a smooth shape sliding through deeper water. Using both details, she inferred that the shark had already shifted locations. That inference changed her plan for the next observation. She wrote two evidence notes before leaving for a safer viewing ledge.
            """

        case ("space", .beginner), ("planets", .beginner), ("rockets", .beginner):
            return "Nova sees a bright star. She waves hello. The moon looks soft and close."
        case ("space", .earlyReader), ("planets", .earlyReader), ("rockets", .earlyReader):
            return "Nova checks a glow map beside a quiet moon rock. She marks two safe landing spots. A small robot beeps beside her. Nova shares the map with the crew. They practice the path one more time."
        case ("space", .growingReader), ("planets", .growingReader), ("rockets", .growingReader):
            return "Nova looks at a Moon map before her walk. Near a round crater, the ground looks smooth. In the dark shadows, the ground looks bumpy. A helper says Moon walkers pick paths that are safe to walk on. Nova compares the two paths and chooses the smooth ground by the crater."
        case ("space", .confidentReader), ("planets", .confidentReader), ("rockets", .confidentReader):
            return """
            Nova studied the Moon map like a mission planner. The crater rim looked smooth in the morning light, yet long shadows hinted at hidden ridges. Mission helpers reminded her that landing sites need firm ground and a clear radio path. Nova compared two clues: the robot's scan favored the rim, while older footprints pointed toward a darker basin. Using both details, she inferred that the rim was safer for today's supply drop. That inference changed the crew's order of stops. Nova wrote two evidence notes before the countdown began.
            """

        case ("dinosaurs", .beginner):
            return "Dottie finds a green leaf. She munches slowly. A friend stomps nearby."
        case ("dinosaurs", .earlyReader):
            return "Dottie walks to a cool watering hole. She finds four fern leaves by the water. A friend arrives hungry. Dottie gives two leaves away. They sit and chew together."
        case ("dinosaurs", .growingReader):
            return "Morning mist hung over the valley while Dottie gathered tools for a fossil walk. Footprints led toward a quiet cove of stones. A guide explained that some dinosaurs rested near water in the morning. Dottie predicted fresh tracks would appear when the sun warmed the ground. Later she checked the prediction against what she found. The details helped her decide where to dig next."
        case ("dinosaurs", .confidentReader):
            return """
            Dottie studied the fossil cove like a detective. Morning light made the mud look smooth, but shallow prints near the rocks suggested a larger animal had passed earlier. The guide said dinosaurs chose resting spots for safety and warmth. Dottie compared two clues: the footprints pointed inland, yet broken reeds floated from deeper water. Using both details, she inferred that the animal had already moved on. That inference changed her digging plan. She wrote two evidence notes before choosing a safer observation spot.
            """

        default:
            // Generic but still grammatical — never keyword-stitched fragments.
            switch level {
            case .beginner:
                return "Sam spots a \(key) during today's walk. The \(key) looks important, so Sam stops to look closely. Then Sam counts one, two, three before moving on."
            case .earlyReader:
                return "Sam walks along the \(key) path. A small sign asks visitors to move slowly. Sam reads the sign, takes careful steps, and then shares what happened."
            case .growingReader:
                return "Sam followed the \(key) trail toward a quiet cove after the rain. Footprints along the path suggested that an animal had passed by earlier that morning. A guide explained why animals often rest there at that time of day. Sam predicted that the \(key) would return when the sun warmed the stones, and later checked that prediction against what really happened."
            case .confidentReader:
                return "Sam studied the \(key) cove like a careful detective. Morning light made the water look calm, but ripples near the rocks suggested that something had moved below. Sam compared the footprints on shore with the ripples in the water and inferred that the \(key) had already shifted locations. That conclusion changed Sam's plan for the next observation."
            }
        }
    }

    private static func readingQuestions(topic: String, passage _: String, level: ReadingLevel) -> [LessonQuestion] {
        let key = topic.lowercased()
        switch (key, level) {
        case ("horses", .beginner):
            return [
                mcq(subject: .reading, "Where do the ponies stand?", choices: ["In the yard", "In a cave", "On a boat"], answer: "In the yard", explanation: "The passage says the ponies stand in the yard."),
                mcq(subject: .reading, "How does Mia speak?", choices: ["Softly", "Loudly", "Only by shouting"], answer: "Softly", explanation: "Mia speaks softly so the ponies stay calm.")
            ]
        case ("horses", .earlyReader):
            return [
                mcq(subject: .reading, "What does Mia remind visitors to do?", choices: ["Speak softly and move calmly", "Run behind the ponies", "Shout near the fence"], answer: "Speak softly and move calmly", explanation: "Mia reminds visitors to speak softly and move calmly."),
                mcq(subject: .reading, "Where should people stand?", choices: ["Where a horse can see them", "Directly behind a horse", "Under the water trough"], answer: "Where a horse can see them", explanation: "Mia shows everyone how to stand where a horse can see them.")
            ]
        case ("horses", .growingReader), ("horses", .confidentReader):
            return [
                mcq(subject: .reading, "What is the main safety lesson?", choices: ["Careful manners keep horses and people safe", "Horses prefer loud surprises", "Visitors should approach from behind"], answer: "Careful manners keep horses and people safe", explanation: "Mia teaches calm, visible approaches for safety."),
                mcq(subject: .reading, "Why avoid approaching from directly behind?", choices: ["It can startle a horse", "It helps a horse nap", "It makes ears point forward"], answer: "It can startle a horse", explanation: "Approaching from behind can startle horses.")
            ]

        case ("sharks", .beginner):
            return [
                mcq(subject: .reading, "What does Finn see?", choices: ["A blue wave", "A red truck", "A tall tree"], answer: "A blue wave", explanation: "Finn sees a blue wave."),
                mcq(subject: .reading, "How does Finn swim?", choices: ["Slowly", "Upside down", "Without moving"], answer: "Slowly", explanation: "He swims slowly.")
            ]
        case ("ocean animals", .beginner), ("ocean", .beginner):
            return [
                mcq(subject: .reading, "What does Willa see?", choices: ["A blue wave", "A red truck", "A tall tree"], answer: "A blue wave", explanation: "Willa sees a blue wave."),
                mcq(subject: .reading, "How does Willa swim?", choices: ["Slowly", "Upside down", "Without moving"], answer: "Slowly", explanation: "She swims slowly.")
            ]
        case ("space", .beginner), ("planets", .beginner), ("rockets", .beginner):
            return [
                mcq(subject: .reading, "What does Nova see?", choices: ["A bright star", "A green frog", "A barn door"], answer: "A bright star", explanation: "Nova sees a bright star."),
                mcq(subject: .reading, "What looks soft and close?", choices: ["The moon", "A train", "A fence"], answer: "The moon", explanation: "The moon looks soft and close.")
            ]
        case ("dinosaurs", .beginner):
            return [
                mcq(subject: .reading, "What does Dottie find?", choices: ["A green leaf", "A rocket", "A soccer ball"], answer: "A green leaf", explanation: "Dottie finds a green leaf."),
                mcq(subject: .reading, "How does Dottie munch?", choices: ["Slowly", "While flying", "Without chewing"], answer: "Slowly", explanation: "She munches slowly.")
            ]

        default:
            switch level {
            case .beginner:
                return [
                    mcq(subject: .reading, "What does Sam spot during the walk?", choices: ["A \(key)", "A racing car", "A snowstorm"], answer: "A \(key)", explanation: "The passage says Sam spots a \(key) during the walk."),
                    mcq(subject: .reading, "What does Sam do before moving on?", choices: ["Counts one, two, three", "Falls asleep on the path", "Jumps into the water"], answer: "Counts one, two, three", explanation: "Sam counts one, two, three before moving on.")
                ]
            case .earlyReader:
                return [
                    mcq(subject: .reading, "What does the sign tell visitors to do?", choices: ["Move slowly", "Move quickly", "Stand still"], answer: "Move slowly", explanation: "The sign asks visitors to move slowly."),
                    mcq(subject: .reading, "What does Sam do after reading?", choices: ["Takes careful steps", "Ignores the sign", "Runs away"], answer: "Takes careful steps", explanation: "Sam reads the sign and takes careful steps.")
                ]
            case .growingReader:
                return [
                    mcq(subject: .reading, "What is the main idea of this passage?", choices: ["Sam observes the trail and checks a prediction", "Sam ignores the guide and runs away", "Sam leaves before noticing any footprints"], answer: "Sam observes the trail and checks a prediction", explanation: "Sam notices details, predicts, then checks what happened."),
                    mcq(subject: .reading, "What did Sam predict?", choices: ["The \(key) would return when the sun warmed the stones", "The trail would stay dry all morning", "The guide would leave before sunrise"], answer: "The \(key) would return when the sun warmed the stones", explanation: "Sam predicted a return when the sun warmed the stones.")
                ]
            case .confidentReader:
                return [
                    mcq(subject: .reading, "What did Sam decide after watching the cove?", choices: ["The \(key) had already shifted locations", "The water stayed empty all morning", "The footprints had never been there"], answer: "The \(key) had already shifted locations", explanation: "Sam inferred that the \(key) had already shifted locations."),
                    mcq(subject: .reading, "Why did Sam change the next observation plan?", choices: ["The footprints and ripples did not match one resting spot", "The guide asked Sam to erase the notes", "The cove was closed for the day"], answer: "The footprints and ripples did not match one resting spot", explanation: "Sam compared footprints with ripples, then changed the plan.")
                ]
            }
        }
    }

    private static func readingVocabulary(topic: String, level: ReadingLevel) -> [VocabularyWord] {
        switch level {
        case .beginner:
            return [VocabularyWord(word: "see", definition: "To look at something.", exampleSentence: "Sam can see the \(topic).")]
        case .earlyReader:
            return [VocabularyWord(word: "slowly", definition: "Not fast.", exampleSentence: "Sam moves slowly near the \(topic).")]
        case .growingReader:
            return [
                VocabularyWord(word: "predict", definition: "To say what you think will happen.", exampleSentence: "Sam can predict the \(topic)'s return."),
                VocabularyWord(word: "observe", definition: "To watch carefully.", exampleSentence: "Sam observes the trail.")
            ]
        case .confidentReader:
            return [
                VocabularyWord(word: "infer", definition: "To figure something out using clues.", exampleSentence: "Sam can infer where the \(topic) went."),
                VocabularyWord(word: "evidence", definition: "Clues that support an idea.", exampleSentence: "Footprints are evidence.")
            ]
        }
    }

    // MARK: - Math

    private static func makeMathLesson(
        topic: Topic,
        readingLevel: ReadingLevel,
        mathLevel: MathLevel,
        age: Int,
        grade: String,
        skill: EducationalSkill?
    ) -> Lesson? {
        guard let scene = CuratedTopicLessonBank.mathScene(
            topic: topic,
            mathLevel: mathLevel,
            readingLevel: readingLevel
        ) else {
            return nil
        }
        let focus = scene.mathSkill
        let problems = scene.problems.map { problem in
            LessonQuestion(
                id: problem.id,
                subject: problem.subject,
                type: problem.type,
                responseType: problem.responseType,
                prompt: problem.prompt,
                choices: problem.choices,
                correctAnswer: problem.correctAnswer,
                explanation: problem.explanation,
                pairs: problem.pairs,
                items: problem.items
            )
        }
        let mathProblems = problems.filter { $0.responseType != .matching && $0.subject == .math }
            + problems.filter { $0.responseType != .matching && $0.subject != .math && $0.responseType == .multipleChoice }
        let authoredMatching = problems.filter { $0.responseType == .matching }
        let sortQuestion = authoredMatching.first ?? ThemeInteractionQuestions.groupingMatch(from: scene.readingPassage)
        var objectives = [skill?.fullStatement ?? focus]
        objectives.append("fp:\(scene.activityFingerprint)")
        let readingQuestions = sortQuestion.map { [$0] } ?? []
        let mathProblemsFinal = mathProblems.isEmpty ? problems.filter { $0.responseType != .matching } : mathProblems
        let alignedMission = MissionPromptNormalizer.alignedToActivities(
            existing: scene.missionPrompt,
            questions: readingQuestions,
            mathChallenges: mathProblemsFinal
        )

        return Lesson(
            id: stableID(topic: topic, category: .math, reading: readingLevel, math: mathLevel),
            title: scene.title,
            theme: topic,
            lessonType: .builder,
            category: .math,
            primarySubject: .math,
            storyOpening: scene.storyOpening,
            missionPrompt: alignedMission,
            readingPassage: scene.readingPassage,
            questions: readingQuestions,
            mathChallenges: mathProblemsFinal,
            vocabularyWords: scene.vocabularyWords,
            knowledgeFacts: scene.knowledgeFacts,
            creativePrompt: scene.creativePrompt,
            creativeResponseType: .drawing,
            storyEnding: scene.storyEnding,
            ageTarget: ageBand(age),
            gradeTarget: grade,
            readingLevel: readingLevel,
            mathLevel: mathLevel,
            learningGoal: .math,
            readingSkill: "",
            mathSkill: focus,
            reflectionPrompt: scene.reflectionPrompt,
            reflectionResponseType: .shortText,
            skillsPracticed: recapSkills(family: "Math", specific: focus, includeVocabulary: false),
            standardSkillId: skill?.id,
            contentApprovalStatus: .pendingValidation,
            hints: scene.hints,
            commonMistakes: ["Adding when the story asks to subtract", "Ignoring a number in the problem"],
            successCriteria: ["Solves problems within the number range for this math level", "Chooses the matching operation"],
            learningObjectives: objectives
        )
    }

    private static func mathProblems(topic: Topic, mathLevel: MathLevel, readingLevel: ReadingLevel) -> [LessonQuestion] {
        guard let scene = CuratedTopicLessonBank.mathScene(
            topic: topic,
            mathLevel: mathLevel,
            readingLevel: readingLevel
        ) else {
            return []
        }
        return scene.problems.map { problem in
            LessonQuestion(
                id: problem.id,
                subject: .math,
                type: problem.type,
                responseType: .multipleChoice,
                prompt: problem.prompt,
                choices: problem.choices,
                correctAnswer: problem.correctAnswer,
                explanation: problem.explanation
            )
        }
    }

    // MARK: - Discovery / Creative

    private static func makeDiscoveryLesson(
        topic: Topic,
        readingLevel: ReadingLevel,
        mathLevel: MathLevel,
        age: Int,
        grade: String,
        skill: EducationalSkill?
    ) -> Lesson? {
        if let pack = CuratedTopicLessonBank.discoveryPack(topic: topic, level: readingLevel) {
            return Lesson(
                id: stableID(topic: topic, category: .discovery, reading: readingLevel, math: mathLevel),
                title: pack.title,
                theme: topic,
                lessonType: .explorer,
                category: .discovery,
                primarySubject: .science,
                storyOpening: pack.storyOpening,
                missionPrompt: pack.missionPrompt,
                readingPassage: pack.readingPassage,
                questions: pack.questions,
                mathChallenges: [],
                vocabularyWords: pack.vocabularyWords,
                knowledgeFacts: pack.knowledgeFacts,
                creativePrompt: pack.creativePrompt,
                creativeResponseType: .drawing,
                storyEnding: pack.storyEnding,
                ageTarget: ageBand(age),
                gradeTarget: grade,
                readingLevel: readingLevel,
                mathLevel: mathLevel,
                learningGoal: .science,
                teaser: "Find real facts about \(topic.rawValue.lowercased()).",
                readingSkill: pack.readingSkill,
                mathSkill: "",
                reflectionPrompt: ReflectionPromptQuality.ensureConcrete(
                    prompt: pack.reflectionPrompt,
                    questions: pack.questions,
                    knowledgeFacts: pack.knowledgeFacts,
                    vocabularyWords: pack.vocabularyWords,
                    title: pack.title
                ),
                skillsPracticed: recapSkills(family: "Science", specific: pack.readingSkill, includeVocabulary: !pack.vocabularyWords.isEmpty),
                standardSkillId: skill?.id,
                contentApprovalStatus: .pendingValidation,
                hints: pack.hints,
                commonMistakes: pack.commonMistakes,
                successCriteria: pack.successCriteria,
                learningObjectives: pack.learningObjectives.isEmpty
                    ? [
                        "Identify a real fact about \(topic.rawValue)",
                        "fp:discovery.\(topic.rawValue).\(readingLevel.rawValue)"
                    ]
                    : pack.learningObjectives
            )
        }

        // Fallback until dedicated Discovery packs are authored for this topic.
        guard let pack = CuratedTopicLessonBank.readingPack(topic: topic, level: readingLevel) else {
            return nil
        }
        let passage = discoveryPassage(from: pack, topic: topic, level: readingLevel)
        let questions = discoveryQuestions(from: pack, topic: topic, level: readingLevel)
        guard !questions.isEmpty else { return nil }

        return Lesson(
            id: stableID(topic: topic, category: .discovery, reading: readingLevel, math: mathLevel),
            title: discoveryTitle(topic: topic, level: readingLevel),
            theme: topic,
            lessonType: .explorer,
            category: .discovery,
            primarySubject: .science,
            storyOpening: discoveryOpening(topic: topic, level: readingLevel),
            missionPrompt: discoveryMission(topic: topic),
            readingPassage: passage,
            questions: questions,
            mathChallenges: [],
            vocabularyWords: pack.vocabularyWords,
            knowledgeFacts: pack.knowledgeFacts,
            creativePrompt: "Draw one real fact you learned about \(topic.rawValue.lowercased()).",
            creativeResponseType: .drawing,
            storyEnding: "You logged a new discovery in the \(topic.rawValue.lowercased()) world!",
            ageTarget: ageBand(age),
            gradeTarget: grade,
            readingLevel: readingLevel,
            mathLevel: mathLevel,
            learningGoal: .science,
            teaser: "Find real facts about \(topic.rawValue.lowercased()).",
            readingSkill: "Use facts from a science note",
            mathSkill: "",
            reflectionPrompt: ReflectionPromptQuality.ensureConcrete(
                prompt: "",
                questions: questions,
                knowledgeFacts: pack.knowledgeFacts,
                vocabularyWords: pack.vocabularyWords,
                title: discoveryTitle(topic: topic, level: readingLevel)
            ),
            skillsPracticed: recapSkills(family: "Science", specific: "Use facts from a science note", includeVocabulary: !pack.vocabularyWords.isEmpty),
            standardSkillId: skill?.id,
            contentApprovalStatus: .pendingValidation,
            hints: ["Look back at the fact notes", "Choose the answer the notes support"],
            commonMistakes: ["Guessing without using the notes"],
            successCriteria: ["Answers using a stated fact"],
            learningObjectives: [
                "Identify a real fact about \(topic.rawValue)",
                "fp:discovery.\(topic.rawValue).\(readingLevel.rawValue)"
            ]
        )
    }

    private static func makeCreativeLesson(
        topic: Topic,
        readingLevel: ReadingLevel,
        mathLevel: MathLevel,
        age: Int,
        grade: String,
        skill: EducationalSkill?
    ) -> Lesson? {
        if let pack = CuratedTopicLessonBank.creativePack(topic: topic, level: readingLevel) {
            let art = QuestionResponseTypeResolver.preferDrawingForCreativeSession(
                title: pack.title,
                mission: pack.missionPrompt,
                prompt: pack.creativePrompt,
                responseType: pack.creativeResponseType,
                category: .creative
            )
            return Lesson(
                id: stableID(topic: topic, category: .creative, reading: readingLevel, math: mathLevel),
                title: pack.title,
                theme: topic,
                lessonType: .creativeLab,
                category: .creative,
                primarySubject: .creative,
                storyOpening: pack.storyOpening,
                missionPrompt: art.mission,
                readingPassage: pack.inspiration,
                questions: [],
                mathChallenges: [],
                vocabularyWords: pack.vocabularyWords,
                knowledgeFacts: pack.knowledgeFacts,
                creativePrompt: art.prompt,
                creativeResponseType: art.responseType,
                storyEnding: pack.storyEnding,
                ageTarget: ageBand(age),
                gradeTarget: grade,
                readingLevel: readingLevel,
                mathLevel: mathLevel,
                learningGoal: .writing,
                teaser: "Draw a scene about \(topic.rawValue.lowercased()).",
                readingSkill: "",
                mathSkill: "",
                reflectionPrompt: ReflectionPromptQuality.ensureConcrete(
                    prompt: pack.reflectionPrompt,
                    questions: [],
                    knowledgeFacts: pack.knowledgeFacts,
                    vocabularyWords: pack.vocabularyWords,
                    title: pack.title
                ),
                skillsPracticed: ["Creative Thinking"],
                standardSkillId: skill?.id,
                contentApprovalStatus: .pendingValidation,
                hints: pack.hints,
                commonMistakes: ["Ignoring the inspiration details"],
                successCriteria: pack.successCriteria,
                learningObjectives: pack.learningObjectives.isEmpty
                    ? [
                        "Express an idea connected to \(topic.rawValue)",
                        "fp:creative.\(topic.rawValue).\(readingLevel.rawValue)"
                    ]
                    : pack.learningObjectives,
                drawingQuestGoals: pack.drawingGoals
            )
        }

        // Fallback until dedicated Creative packs are authored for this topic.
        guard let pack = CuratedTopicLessonBank.readingPack(topic: topic, level: readingLevel) else {
            return nil
        }
        let inspiration = creativeInspiration(from: pack, level: readingLevel)
        return Lesson(
            id: stableID(topic: topic, category: .creative, reading: readingLevel, math: mathLevel),
            title: creativeTitle(topic: topic, level: readingLevel),
            theme: topic,
            lessonType: .creativeLab,
            category: .creative,
            primarySubject: .creative,
            storyOpening: pack.storyOpening,
            missionPrompt: creativeMission(topic: topic),
            readingPassage: inspiration,
            questions: [],
            mathChallenges: [],
            vocabularyWords: Array(pack.vocabularyWords.prefix(2)),
            knowledgeFacts: Array(pack.knowledgeFacts.prefix(1)),
            creativePrompt: pack.creativePrompt.isEmpty
                ? creativeQuestPrompt(topic: topic, level: readingLevel, drawing: true)
                : pack.creativePrompt,
            creativeResponseType: .drawing,
            storyEnding: creativeEnding(topic: topic),
            ageTarget: ageBand(age),
            gradeTarget: grade,
            readingLevel: readingLevel,
            mathLevel: mathLevel,
            learningGoal: .writing,
            teaser: "Draw a scene about \(topic.rawValue.lowercased()).",
            readingSkill: "",
            mathSkill: "",
            reflectionPrompt: creativeReflection(topic: topic, drawing: true),
            skillsPracticed: ["Creative Thinking"],
            standardSkillId: skill?.id,
            contentApprovalStatus: .pendingValidation,
            hints: ["Use one real detail from the inspiration note", "Add your own idea too"],
            commonMistakes: ["Ignoring the inspiration details"],
            successCriteria: ["Creates a response connected to the topic"],
            learningObjectives: [
                "Express an idea connected to \(topic.rawValue)",
                "fp:creative.\(topic.rawValue).\(readingLevel.rawValue)"
            ],
            drawingQuestGoals: DrawingQuestGoals.goals(for: topic)
        )
    }

    private static func discoveryPassage(
        from pack: CuratedTopicLessonBank.ReadingPack,
        topic: Topic,
        level: ReadingLevel
    ) -> String {
        let facts = pack.knowledgeFacts.map(\.fact)
        let primaryFact = facts.first ?? "Scientists learn new things about \(topic.rawValue.lowercased()) every day."
        let secondFact = facts.dropFirst().first
        let vocabLine: String = {
            guard let word = pack.vocabularyWords.first else { return "" }
            return " A useful word is \(word.word.lowercased()): \(word.definition)"
        }()

        switch level {
        case .beginner:
            return "Field note: \(primaryFact)\(vocabLine)"
        case .earlyReader:
            if let secondFact {
                return "Field notebook: \(primaryFact) \(secondFact)\(vocabLine) Look for these clues when you explore."
            }
            return "Field notebook: \(primaryFact)\(vocabLine) Look for these clues when you explore."
        case .growingReader:
            let extra = secondFact.map { " Another clue: \($0)" } ?? ""
            return "Science notebook: Today we study \(topic.rawValue.lowercased()). \(primaryFact)\(extra)\(vocabLine) Use only these notes when you answer."
        case .confidentReader:
            let joined = facts.prefix(3).joined(separator: " ")
            return "Investigator notes on \(topic.rawValue.lowercased()): \(joined)\(vocabLine) Compare the clues carefully before you decide what is true."
        }
    }

    private static func discoveryQuestions(
        from pack: CuratedTopicLessonBank.ReadingPack,
        topic: Topic,
        level: ReadingLevel
    ) -> [LessonQuestion] {
        var questions: [LessonQuestion] = []

        if let fact = pack.knowledgeFacts.first {
            let correct = discoveryFactChoice(fact.fact)
            let distractors = discoveryDistractors(topic: topic, avoiding: correct)
            questions.append(
                mcq(
                    subject: .science,
                    "According to the notes, which idea is true?",
                    choices: [correct] + distractors,
                    answer: correct,
                    explanation: fact.explanation.isEmpty ? "That idea was in the science notes." : fact.explanation
                )
            )
        }

        if let word = pack.vocabularyWords.first {
            let distractors = discoveryVocabDistractors(topic: topic, avoiding: word.definition)
            questions.append(
                mcq(
                    subject: .reading,
                    "In these notes, what does \"\(word.word)\" mean?",
                    choices: [word.definition] + distractors,
                    answer: word.definition,
                    explanation: "The notes define \(word.word.lowercased()) that way."
                )
            )
        }

        if level == .growingReader || level == .confidentReader {
            questions.append(
                mcq(
                    subject: .science,
                    "How should you check a claim about \(topic.rawValue.lowercased())?",
                    choices: [
                        "Look back at the science notes for evidence",
                        "Guess without reading the notes",
                        "Skip the notes and change topics"
                    ],
                    answer: "Look back at the science notes for evidence",
                    explanation: "Good investigators check the notes for evidence."
                )
            )
        }

        return Array(questions.prefix(level == .beginner ? 2 : 3))
    }

    private static func discoveryFactChoice(_ fact: String) -> String {
        let trimmed = fact.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= 64 { return trimmed }
        if let dot = trimmed.firstIndex(of: ".") {
            let sentence = String(trimmed[..<dot])
            if sentence.count >= 18 { return sentence }
        }
        return String(trimmed.prefix(64))
    }

    private static func discoveryDistractors(topic: Topic, avoiding: String) -> [String] {
        let pool: [String]
        switch topic {
        case .horses:
            pool = ["Horses only need food once a month", "Ponies drink salt water only", "Barns keep horses warm with no air flow"]
        case .jungleAnimals:
            pool = ["Toucans live only in dry deserts", "The canopy grows under the soil", "Jaguars avoid rivers completely"]
        case .sharks, .oceanAnimals:
            pool = ["Reef sharks live in desert dunes", "Ocean fish breathe only dry air", "Coral grows best on dry land"]
        case .dogs:
            pool = ["Dogs learn best when people yell", "Calm walking slows every dog down", "Treats confuse every dog forever"]
        case .cooking:
            pool = ["Recipes skip measuring on purpose", "Cold ovens bake bread quickly", "Flour is only used for painting walls"]
        case .space, .planets, .rockets:
            pool = ["The Moon has thick blue oceans", "Rockets launch best underwater", "Stars are tiny lamps on Earth"]
        case .dinosaurs:
            pool = ["Fossils form in one quick minute", "Dinosaurs only lived in ice castles", "Bones leave no diggable clues"]
        default:
            pool = [
                "\(topic.rawValue) need no careful study",
                "All \(topic.rawValue.lowercased()) facts are about city traffic",
                "Notes about \(topic.rawValue.lowercased()) are unused leftovers"
            ]
        }
        return Array(pool.filter { $0.caseInsensitiveCompare(avoiding) != .orderedSame }.prefix(2))
    }

    private static func discoveryVocabDistractors(topic: Topic, avoiding: String) -> [String] {
        let topical: [String]
        switch topic {
        case .horses: topical = ["A type of barn window latch", "A color painted on fence posts"]
        case .jungleAnimals: topical = ["A dry desert plant juice", "A tool for opening paint cans"]
        case .dogs: topical = ["A tag used only for cats", "A flavor of toothpaste brand"]
        case .cooking: topical = ["A shelf used only for toys", "A sound made by a timer bell"]
        default:
            topical = [
                "A label used for unrelated tools",
                "A pattern found only on backpacks",
                "A signal used in board games"
            ]
        }
        return Array(topical.filter { $0.caseInsensitiveCompare(avoiding) != .orderedSame }.prefix(2))
    }

    private static func discoveryOpening(topic: Topic, level: ReadingLevel) -> String {
        switch level {
        case .beginner, .earlyReader:
            return "Open your field notebook. Today we hunt for true \(topic.rawValue.lowercased()) facts."
        case .growingReader, .confidentReader:
            return "You investigate \(topic.rawValue.lowercased()) using evidence from the science notes."
        }
    }

    private static func creativeInspiration(
        from pack: CuratedTopicLessonBank.ReadingPack,
        level: ReadingLevel
    ) -> String {
        switch level {
        case .beginner:
            return "Inspiration: \(pack.storyOpening)"
        case .earlyReader:
            return "Inspiration: \(pack.storyOpening) Think about one detail you can draw or invent."
        case .growingReader, .confidentReader:
            let detail = pack.knowledgeFacts.first.map { " True detail: \($0.fact)" } ?? ""
            return "Inspiration for your creation: \(pack.storyOpening)\(detail) Use at least one real detail in your idea."
        }
    }

    private static func leveledLabel(_ base: String, level: ReadingLevel) -> String {
        switch level {
        case .beginner: return "\(base) · First Steps"
        case .earlyReader: return "\(base) · Early"
        case .growingReader: return "\(base) · Growing"
        case .confidentReader: return "\(base) · Challenge"
        }
    }

    private static func discoveryTitle(topic: Topic, level: ReadingLevel) -> String {
        let base: String
        switch topic {
        case .horses: base = "Barn Fact Finders"
        case .jungleAnimals: base = "Rainforest Detectives"
        case .sharks, .oceanAnimals: base = "Reef Fact Finders"
        case .space, .planets, .rockets: base = "Moon Map Detectives"
        case .dinosaurs: base = "Fossil Fact Finders"
        case .soccer: base = "Field Fact Finders"
        case .basketball: base = "Court Clue Hunters"
        case .dogs: base = "Puppy Clue Squad"
        case .cats: base = "Whisker Watchers"
        case .princesses: base = "Castle Clue Keepers"
        case .castles: base = "Tower Trace Detectives"
        case .fairies: base = "Glade Glow Spotters"
        case .airplanes: base = "Runway Fact Finders"
        case .trains: base = "Station Signal Scouts"
        case .cars: base = "Garage Clue Crew"
        case .robots: base = "Circuit Clue Crew"
        case .superheroes: base = "Hero Help Detectives"
        case .art: base = "Studio Color Detectives"
        case .music: base = "Rhythm Clue Keepers"
        case .cooking: base = "Kitchen Clue Cooks"
        case .nature: base = "Trail Trace Spotters"
        case .bugs: base = "Bug Trail Detectives"
        case .volcanoes: base = "Lava Lab Detectives"
        case .weather: base = "Sky Map Spotters"
        case .farmAnimals: base = "Barn Yard Spotters"
        case .zooAnimals: base = "Habitat Helpers"
        case .pirates: base = "Map Clue Captains"
        }
        return leveledLabel(base, level: level)
    }

    private static func discoveryMission(topic: Topic) -> String {
        switch topic {
        case .horses: return "Explore a true horse-care idea and answer using only the barn passage."
        case .jungleAnimals: return "Explore a true rainforest idea and answer using only the jungle passage."
        case .sharks, .oceanAnimals: return "Explore a true ocean idea and answer using only the reef passage."
        case .space, .planets, .rockets: return "Explore a true space idea and answer using only Nova's mission notes."
        case .dinosaurs: return "Explore a true fossil idea and answer using only Dottie's dig notes."
        case .dogs: return "Explore a true dog-care idea and answer using only Ben and Scout's passage."
        case .cooking: return "Explore a true cooking idea and answer using only Chef Dara's recipe notes."
        case .volcanoes: return "Explore a true volcano idea and answer using only Dr. Nolan's field notes."
        default:
            return "Explore a true idea about \(topic.rawValue.lowercased()) and answer from the passage."
        }
    }

    private static func creativeTitle(topic: Topic, level: ReadingLevel) -> String {
        let base: String
        switch topic {
        case .horses: base = "Sunny's Stable Sketch"
        case .jungleAnimals: base = "Canopy Color Quest"
        case .sharks: base = "Finn's Reef Picture"
        case .oceanAnimals: base = "Willa's Ocean Picture"
        case .space, .planets, .rockets: base = "Nova's Star Sketch"
        case .dinosaurs: base = "Dottie's Fossil Drawing"
        case .soccer: base = "Lena's Field Sketch"
        case .basketball: base = "Theo's Court Sketch"
        case .dogs: base = "Scout's Park Picture"
        case .cats: base = "Biscuit's Window Sketch"
        case .princesses: base = "Rose Garden Sketch"
        case .castles: base = "Tower Blueprint Quest"
        case .fairies: base = "Glade Glow Drawing"
        case .airplanes: base = "Zoe's Cockpit Sketch"
        case .trains: base = "Station Builder Sketch"
        case .cars: base = "Rosa's Garage Sketch"
        case .robots: base = "Robot Blueprint Quest"
        case .superheroes: base = "Nina's Hero Sketch"
        case .art: base = "Iris Color Studio Quest"
        case .music: base = "Milo's Rhythm Sketch"
        case .cooking: base = "Chef Dara's Kitchen Sketch"
        case .nature: base = "Ranger Wren's Trail Sketch"
        case .bugs: base = "Sam's Ant Trail Sketch"
        case .volcanoes: base = "Dr. Nolan's Lava Sketch"
        case .weather: base = "Piper's Sky Map Sketch"
        case .farmAnimals: base = "Farmer Jo's Barn Sketch"
        case .zooAnimals: base = "Keeper Amara's Habitat Sketch"
        case .pirates: base = "Captain Wren's Map Sketch"
        }
        return leveledLabel(base, level: level)
    }

    private static func creativeMission(topic: Topic) -> String {
        switch topic {
        case .horses:
            return "Art Quest: Read Sunny's story, then draw a scene that helps keep ponies calm and happy."
        case .jungleAnimals:
            return "Art Quest: Read the rainforest story, then draw one animal in its jungle home."
        case .sharks:
            return "Art Quest: Read Finn's reef story, then draw a scene from the reef."
        case .oceanAnimals:
            return "Art Quest: Read Willa's ocean story, then draw a scene from the reef."
        case .space, .planets, .rockets:
            return "Art Quest: Read Nova's space story, then sketch one moment from the mission."
        case .dinosaurs:
            return "Art Quest: Read Dottie's story, then draw what she found."
        case .dogs:
            return "Art Quest: Read about Ben and Scout, then draw Scout practicing a calm walk."
        case .cooking:
            return "Art Quest: Read Chef Dara's kitchen story, then draw one careful cooking step."
        case .volcanoes:
            return "Art Quest: Read Dr. Nolan's volcano notes, then draw a safe observation scene."
        case .soccer:
            return "Art Quest: Read Lena's soccer story, then draw one smart play from the field."
        case .superheroes:
            return "Art Quest: Read Nina's helper story, then draw one kind heroic action."
        default:
            return "Art Quest: Read the \(topic.rawValue.lowercased()) story, then create a scene that uses one real detail from it."
        }
    }

    private static func creativeEnding(topic: Topic) -> String {
        switch topic {
        case .horses: return "You finished Sunny's Art Quest and earned a star in the barn world!"
        case .jungleAnimals: return "You finished the canopy Art Quest and earned a rainforest star!"
        case .dogs: return "You finished Scout's Art Quest and earned a park star!"
        case .cooking: return "You finished Chef Dara's Art Quest and earned a kitchen star!"
        default:
            return "You finished the Art Quest and earned a star in the \(topic.rawValue.lowercased()) world!"
        }
    }

    private static func creativeReflection(topic: Topic, drawing: Bool) -> String {
        if drawing {
            switch topic {
            case .horses: return "What did you add to Sunny's world in your picture?"
            case .jungleAnimals: return "What jungle detail did you put in your picture?"
            case .sharks, .oceanAnimals: return "What ocean detail did you put in your picture?"
            case .space, .planets, .rockets: return "What space detail did you include?"
            case .dinosaurs: return "What detail did you put in Dottie's adventure picture?"
            case .dogs: return "What detail about Scout did you put in your picture?"
            case .cooking: return "What cooking detail from Chef Dara did you include?"
            case .volcanoes: return "What safe volcano detail did you draw?"
            default: return "What is one story detail you put in your picture?"
            }
        }
        switch topic {
        case .horses: return "What did you add to Sunny's world in your idea?"
        case .jungleAnimals: return "What jungle detail did you include?"
        case .dogs: return "What detail about Scout did you include?"
        case .cooking: return "What cooking detail from Chef Dara did you include?"
        default: return "What story detail did you use in your idea?"
        }
    }

    private static func creativeQuestPrompt(topic: Topic, level: ReadingLevel, drawing: Bool) -> String {
        if drawing {
            if let pack = CuratedTopicLessonBank.readingPack(topic: topic, level: level),
               !pack.creativePrompt.isEmpty {
                return pack.creativePrompt
            }
            return "Draw one clear scene from today's \(topic.rawValue.lowercased()) story."
        }
        switch level {
        case .beginner, .earlyReader:
            return "Describe one scene from the \(topic.rawValue.lowercased()) story in your own words."
        case .growingReader:
            return "Write two sentences about a new scene that could happen next in the \(topic.rawValue.lowercased()) story."
        case .confidentReader:
            return "Invent a short sequel scene that uses one detail from today's \(topic.rawValue.lowercased()) story."
        }
    }

    // MARK: - Shared helpers

    private static func lightMath(topic: Topic, readingLevel: ReadingLevel, mathLevel: MathLevel, count: Int) -> [LessonQuestion] {
        Array(mathProblems(topic: topic, mathLevel: mathLevel, readingLevel: readingLevel).prefix(count))
    }

    private static func mcq(
        subject: QuestionSubject = .math,
        _ prompt: String,
        choices: [String],
        answer: String,
        explanation: String
    ) -> LessonQuestion {
        LessonQuestion(
            subject: subject,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: prompt,
            choices: choices,
            correctAnswer: answer,
            explanation: explanation
        )
    }

    private static func stableID(topic: Topic, category: LessonCategory, reading: ReadingLevel, math: MathLevel) -> UUID {
        let key = "approved.\(topic.rawValue).\(category.rawValue).\(reading.rawValue).\(math.rawValue)"
        return uuidFromStableKey(key)
    }

    private static func uuidFromStableKey(_ key: String) -> UUID {
        var hash: UInt64 = 5381
        for byte in key.utf8 {
            hash = ((hash << 5) &+ hash) &+ UInt64(byte)
        }
        let bytes = withUnsafeBytes(of: hash.bigEndian) { Data($0) }
        var uuidBytes = [UInt8](repeating: 0, count: 16)
        for i in 0..<8 { uuidBytes[i] = bytes[i % bytes.count] }
        for i in 8..<16 { uuidBytes[i] = bytes[(i - 8) % bytes.count] ^ 0x5A }
        uuidBytes[6] = (uuidBytes[6] & 0x0F) | 0x40
        uuidBytes[8] = (uuidBytes[8] & 0x3F) | 0x80
        return UUID(uuid: (
            uuidBytes[0], uuidBytes[1], uuidBytes[2], uuidBytes[3],
            uuidBytes[4], uuidBytes[5], uuidBytes[6], uuidBytes[7],
            uuidBytes[8], uuidBytes[9], uuidBytes[10], uuidBytes[11],
            uuidBytes[12], uuidBytes[13], uuidBytes[14], uuidBytes[15]
        ))
    }

    private static func ageBand(_ age: Int) -> String {
        switch age {
        case ...5: return "4-6"
        case 6: return "5-7"
        case 7: return "6-8"
        default: return "7-10"
        }
    }

    private static func ageToneOpening(topic: String, age: Int, level: ReadingLevel) -> String {
        if age <= 5 {
            return "Come explore \(topic) with a friend!"
        }
        if age >= 8 {
            return "Today's \(topic) mission needs careful thinking."
        }
        return level == .beginner
            ? "Let's look at \(topic) together."
            : "Ready for a \(topic) challenge?"
    }

    private static func readingTitle(topic: String, level: ReadingLevel) -> String {
        "\(topic.capitalized): \(LevelSkillProgressions.readingFocus(for: level))"
    }

    private static func mathTitle(topic: String, level: MathLevel) -> String {
        "\(topic.capitalized) Math: \(LevelSkillProgressions.mathFocus(for: level))"
    }

    private static func readingMission(level: ReadingLevel, focus: String) -> String {
        switch level {
        case .beginner: return "Read each short sentence. Find who and what."
        case .earlyReader: return "Read the short story. Answer with clues from the text."
        case .growingReader: return "Find the main idea and check the prediction with details from the story."
        case .confidentReader: return "Use evidence to explain an inference about \(focus.lowercased())."
        }
    }

    private static func readingCreative(topic: String, level: ReadingLevel) -> String {
        let key = topic.lowercased()
        switch (key, level) {
        case ("horses", .beginner):
            return "Art Quest: Draw the ponies in the sunny yard. Can you add Sunny too?"
        case ("horses", .earlyReader), ("horses", .growingReader), ("horses", .confidentReader):
            return "Art Quest: Draw one pony-care tip from the story — soft voices, calm steps, or standing where a horse can see you."
        case ("sharks", .beginner):
            return "Art Quest: Draw the blue wave Finn sees. Add a little fish if you like!"
        case ("ocean", .beginner), ("ocean animals", .beginner):
            return "Art Quest: Draw the blue wave Willa sees. Add a little fish if you like!"
        case ("sharks", .earlyReader), ("sharks", .growingReader), ("sharks", .confidentReader):
            return "Art Quest: Draw Finn near the reef and one clue from the story."
        case ("ocean", .earlyReader), ("ocean animals", .earlyReader),
             ("ocean", .growingReader), ("ocean animals", .growingReader),
             ("ocean", .confidentReader), ("ocean animals", .confidentReader):
            return "Art Quest: Draw Willa near the reef and one clue from the story."
        case ("space", .beginner), ("planets", .beginner), ("rockets", .beginner):
            return "Art Quest: Draw the bright star Nova sees. Add a moon rock if you can!"
        case ("space", .earlyReader), ("planets", .earlyReader), ("rockets", .earlyReader),
             ("space", .growingReader), ("planets", .growingReader), ("rockets", .growingReader),
             ("space", .confidentReader), ("planets", .confidentReader), ("rockets", .confidentReader):
            return "Art Quest: Draw Nova's map and one safe landing spot from the story."
        case ("dinosaurs", .beginner):
            return "Art Quest: Draw Dottie's green leaf. Add a friend nearby!"
        case ("dinosaurs", .earlyReader), ("dinosaurs", .growingReader), ("dinosaurs", .confidentReader):
            return "Art Quest: Draw Dottie's watering hole and one thing she found."
        default:
            switch level {
            case .beginner: return "Art Quest: Draw the \(topic) Sam sees. Add one extra detail!"
            case .earlyReader: return "Art Quest: Draw Sam following the sign from the story."
            case .growingReader: return "Write one sentence about the prediction in the story."
            case .confidentReader: return "Explain another clue a careful observer could collect next."
            }
        }
    }

    private static func readingReflection(level: ReadingLevel) -> String {
        switch level {
        case .beginner: return "Who or what did you read about in the story?"
        case .earlyReader: return "Which story detail answered the mission?"
        case .growingReader: return "Was the prediction in the story right? What clue tells you?"
        case .confidentReader: return "Which clue in the story was strongest, and why?"
        }
    }

    private static func readingHints(level: ReadingLevel) -> [String] {
        switch level {
        case .beginner: return ["Point to the words", "Say the sounds"]
        case .earlyReader: return ["Find the same word in the story"]
        case .growingReader: return ["Look for the sentence that says what Sam predicted"]
        case .confidentReader: return ["Compare both clues before you choose"]
        }
    }

    private static func recapSkills(family: String, specific: String, includeVocabulary: Bool) -> [String] {
        var tags = [family]
        let trimmed = specific.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty, trimmed.caseInsensitiveCompare(family) != .orderedSame {
            tags.append(trimmed)
        }
        if includeVocabulary {
            tags.append("Vocabulary")
        }
        return tags
    }

    private static func mathHints(level: MathLevel) -> [String] {
        switch level {
        case .emerging: return ["Count on your fingers", "Point to each object"]
        case .developing: return ["Write the numbers", "Decide add or subtract"]
        case .secure: return ["Think about tens and ones", "Draw equal groups"]
        case .advancing: return ["Read the numbers carefully", "Choose add, subtract, multiply, or divide"]
        }
    }
}
