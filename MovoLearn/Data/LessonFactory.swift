import Foundation

/// Builds lessons from topic metadata for offline tooling and tests.
/// Child-facing sessions must NOT call this for unvalidated live content —
/// use `ApprovedContentLibrary` / `backend/content-pipeline` instead.
enum LessonFactory {

    static func generate(
        topic: Topic,
        lessonType: LessonType,
        category: LessonCategory? = nil,
        readingLevel: ReadingLevel = .earlyReader,
        mathLevel: MathLevel = .developing,
        learningGoal: LearningGoal = .allAround,
        grade: String = "K-2",
        age: Int = 6
    ) -> Lesson {
        let resolvedCategory = category ?? LessonCategory.inferred(from: lessonType, learningGoal: learningGoal)
        let def = TopicLibrary.definition(for: topic)
        let seed = topicSeed(topic, lessonType)
        let rules = LessonDifficultyRules.profile(for: readingLevel)

        let vocab = def.vocabularyWords[seed % def.vocabularyWords.count]
        let fact = def.scienceFacts[seed % def.scienceFacts.count]
        let setting = def.storySettings[seed % def.storySettings.count]
        let creativeEntry = def.creativePrompt(at: seed)
        let creative = creativeEntry.text

        let vocabDef = TopicLibrary.vocabularyDefinition(for: vocab, topic: topic)
        let storyOpening = storyOpening(for: lessonType, topic: def, setting: setting, age: age, level: readingLevel)
        let missionPrompt = missionPrompt(for: lessonType, topic: def, setting: setting, age: age, level: readingLevel)
        let passage = readingPassage(
            for: lessonType,
            topic: def,
            setting: setting,
            fact: fact,
            vocab: vocab,
            level: readingLevel
        )
        let storyEnding = storyEnding(for: lessonType, topic: def, age: age)
        let readingSkill = readingSkillName(for: lessonType)
        let mathSkill = MathWordProblemGenerator.primarySkillName(seed: seed, level: readingLevel, mathLevel: mathLevel)
        let readingQuestions = comprehensionQuestions(
            lessonType: lessonType,
            passage: passage,
            topic: def,
            vocab: vocab,
            fact: fact,
            seed: seed,
            level: readingLevel
        )
        let mathQuestions = resolvedCategory == .math
            ? MathWordProblemGenerator.generateQuestions(
                topic: topic,
                seed: seed,
                level: readingLevel,
                mathLevel: mathLevel,
                count: rules.mathQuestionRange.upperBound
            )
            : []

        let vocabularyWords = Lesson.enrichVocabulary(
            primary: VocabularyWord(
                word: vocab,
                definition: vocabDef,
                exampleSentence: "In today's story, \(vocab.lowercased()) helps explain the adventure.",
                storyConnection: "\(vocab) connects to the \(def.name.lowercased()) mission."
            ),
            theme: topic,
            passage: passage,
            level: readingLevel
        )

        let extraFact = def.scienceFacts[(seed + 1) % def.scienceFacts.count]
        let knowledgeFacts = [
            KnowledgeFact(fact: fact, explanation: "Scientists and explorers use this fact to understand \(def.name.lowercased())."),
            KnowledgeFact(fact: extraFact, explanation: "This is another true fact about \(def.name.lowercased()).")
        ].prefix(rules.knowledgeFactRange.upperBound).map { $0 }

        let interactionQuestions = ThemeInteractionQuestions.forPassage(
            passage,
            topic: topic,
            vocabulary: vocabularyWords,
            knowledgeFacts: Array(knowledgeFacts)
        )
        let allReadingQuestions = readingQuestions + interactionQuestions

        let displayTitle = categoryTitle(for: resolvedCategory, topic: def, lessonType: lessonType)
        let teaser = teaserSentence(for: resolvedCategory, topic: def, mission: missionPrompt)
        let skills = skillsFor(category: resolvedCategory, goal: learningGoal)

        let isArtQuest = lessonType == .creativeLab && resolvedCategory == .creative
        let readingForLesson = isArtQuest ? [] : allReadingQuestions
        let mathForLesson = mathQuestions
        let knowledgeForLesson = isArtQuest ? Array(knowledgeFacts.prefix(1)) : Array(knowledgeFacts)
        let vocabForLesson = isArtQuest ? Array(vocabularyWords.prefix(1)) : vocabularyWords

        var lesson = Lesson(
            title: isArtQuest ? "\(def.name) Art Quest" : displayTitle,
            theme: topic,
            lessonType: lessonType,
            category: resolvedCategory,
            primarySubject: isArtQuest ? .creative : nil,
            storyOpening: storyOpening,
            missionPrompt: missionPrompt,
            readingPassage: passage,
            questions: readingForLesson,
            mathChallenges: mathForLesson,
            vocabularyWords: vocabForLesson,
            knowledgeFacts: knowledgeForLesson,
            creativePrompt: creative,
            creativeResponseType: creativeEntry.responseType,
            storyEnding: storyEnding,
            ageTarget: ageTarget(for: age),
            gradeTarget: grade,
            readingLevel: readingLevel,
            learningGoal: isArtQuest ? .writing : learningGoal,
            teaser: teaser,
            readingSkill: readingSkill,
            mathSkill: resolvedCategory == .math ? mathSkill : "",
            reflectionPrompt: reflectionQuestion(for: lessonType, topic: def.name),
            reflectionResponseType: .shortText,
            skillsPracticed: skills
        )
        lesson.creativePrompt = CreativePromptQuality.ensureStoryComprehension(
            prompt: lesson.creativePrompt,
            responseType: lesson.creativeResponseType,
            lesson: lesson
        )
        lesson.reflectionPrompt = ReflectionPromptQuality.ensureConcrete(
            prompt: lesson.reflectionPrompt,
            lesson: lesson
        )
        #if DEBUG
        let qualityIssues = QuestionQualityValidator.validateLesson(lesson)
        assert(qualityIssues.isEmpty, "LessonFactory quality issues:\n\(qualityIssues.joined(separator: "\n"))")
        #endif
        return lesson
    }

    // MARK: - Content Helpers

    private static func topicSeed(_ topic: Topic, _ type: LessonType) -> Int {
        abs(topic.rawValue.hashValue &+ type.rawValue.hashValue)
    }

    private static func ageTarget(for age: Int) -> String {
        let low = max(4, age - 1)
        let high = min(12, age + 1)
        return "\(low)-\(high)"
    }

    private static func skillsFor(category: LessonCategory, goal: LearningGoal) -> [String] {
        switch category {
        case .story:
            return ["Reading", "Vocabulary", "Comprehension"]
        case .math:
            return ["Math", "Word Problems", "Addition"]
        case .discovery:
            return ["Science", "Reading", "Vocabulary"]
        case .creative:
            return ["Creativity", "Writing", "Vocabulary"]
        }
    }

    private static func categoryTitle(for category: LessonCategory, topic: TopicDefinition, lessonType: LessonType) -> String {
        let typeLabel: String = {
            switch lessonType {
            case .explorer: return "Explorer"
            case .rescue: return "Rescue"
            case .mystery, .detective: return "Mystery"
            case .builder: return "Builder"
            case .animalExpert: return "Animal Expert"
            case .spaceMission: return "Space Mission"
            case .creativeLab: return "Create & Invent"
            }
        }()

        switch category {
        case .story:
            return "\(topic.name) \(typeLabel)"
        case .math:
            return "\(topic.name) Math \(typeLabel == "Explorer" ? "Mission" : typeLabel)"
        case .discovery:
            return "\(topic.name) \(typeLabel == "Explorer" ? "Discovery" : typeLabel)"
        case .creative:
            return "\(topic.name) Create & Invent"
        }
    }

    private static func teaserSentence(for category: LessonCategory, topic: TopicDefinition, mission: String) -> String {
        let trimmed = mission.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        switch category {
        case .story:
            return "Dive into a \(topic.name.lowercased()) story and follow the clues."
        case .math:
            return "Solve counting puzzles and word problems in the \(topic.name.lowercased()) world."
        case .discovery:
            return "Discover real facts and complete a \(topic.name.lowercased()) science mission."
        case .creative:
            return "Invent, draw, and tell your own \(topic.name.lowercased()) story."
        }
    }

    private static func storyOpening(for type: LessonType, topic: TopicDefinition, setting: String, age: Int, level: ReadingLevel) -> String {
        if age <= 6 || level == .beginner {
            switch type {
            case .explorer:
                return "You visit \(setting). Today you learn about \(topic.name.lowercased())."
            case .rescue:
                return "Someone needs help at \(setting). You can help!"
            case .mystery, .detective:
                return "A clue waits at \(setting). Can you solve the mystery?"
            case .builder:
                return "At \(setting), you will build something new."
            case .animalExpert:
                return "Friends gather at \(setting) to learn about \(topic.name.lowercased())."
            case .spaceMission:
                return "Mission time at \(setting)! Check your gear."
            case .creativeLab:
                return "The creative lab is open at \(setting). Let's make something!"
            }
        }
        switch type {
        case .explorer:
            return "A hush falls over \(setting) as you step forward, ready to discover secrets of the \(topic.name.lowercased()) world."
        case .rescue:
            return "A worried voice calls from \(setting) — someone needs help, and you are the one who answered."
        case .mystery, .detective:
            return "A folded note waits at \(setting), the first clue in a mystery wrapped in \(topic.name.lowercased()) wonders."
        case .builder:
            return "Blueprints and bright ideas cover the table at \(setting). Today, you build something that was not there before."
        case .animalExpert:
            return "Visitors gather at \(setting), eyes wide, waiting for you to teach them about \(topic.name.lowercased())."
        case .spaceMission:
            return "Mission lights blink at \(setting). Your crew prepares for a bold \(topic.name.lowercased()) mission."
        case .creativeLab:
            return "Color and imagination swirl through \(setting) — the creative lab is open for today's adventure."
        }
    }

    private static func missionPrompt(for type: LessonType, topic: TopicDefinition, setting: String, age: Int, level: ReadingLevel) -> String {
        if age <= 6 || level == .beginner {
            switch type {
            case .explorer:
                return "Look around \(setting) and learn one new thing about \(topic.name.lowercased())."
            case .rescue:
                return "Read the plan. Help solve the problem at \(setting)."
            case .mystery, .detective:
                return "Follow the clues at \(setting) and find the answer."
            case .builder:
                return "Use counting and reading to build at \(setting)."
            case .animalExpert:
                return "Teach one true fact about \(topic.name.lowercased())."
            case .spaceMission:
                return "Finish each mission step at \(setting)."
            case .creativeLab:
                return "Make something new about \(topic.name.lowercased())."
            }
        }
        switch type {
        case .explorer:
            return "Explore \(setting), read every clue, and uncover something amazing about \(topic.name.lowercased())!"
        case .rescue:
            return "Someone at \(setting) is counting on you. Read the plan, solve the puzzles, and save the day!"
        case .mystery, .detective:
            return "Follow each clue at \(setting) and piece together the hidden answer!"
        case .builder:
            return "Use reading and math to build something wonderful at \(setting)!"
        case .animalExpert:
            return "Share what you know about \(topic.name.lowercased()) and help everyone become an expert!"
        case .spaceMission:
            return "Mission control needs you at \(setting). Complete every step — the mission depends on you!"
        case .creativeLab:
            return "Mix real facts about \(topic.name.lowercased()) with wild imagination to create something new!"
        }
    }

    private static func storyEnding(for type: LessonType, topic: TopicDefinition, age: Int) -> String {
        let name = topic.name.lowercased()
        if age <= 6 {
            return "You did it! You learned something new about \(name)."
        }
        switch type {
        case .rescue:
            return "You helped save the day in the \(name) world. Kindness and careful thinking made all the difference!"
        case .mystery, .detective:
            return "Mystery solved! Your sharp reading cracked the \(name) case wide open."
        case .spaceMission:
            return "Mission accomplished! The \(name) crew celebrates your brave, careful work."
        case .builder:
            return "You built something wonderful today. The \(name) world looks better because of your plan."
        case .creativeLab:
            return "Your imagination made this \(name) adventure unforgettable. What will you create next?"
        case .animalExpert:
            return "You taught with confidence today. Everyone left knowing more about \(name)!"
        default:
            return "You explored the \(name) world and discovered something wonderful. What an adventure!"
        }
    }

    private static func readingPassage(
        for type: LessonType,
        topic: TopicDefinition,
        setting: String,
        fact: String,
        vocab: String,
        level: ReadingLevel
    ) -> String {
        switch type {
        case .explorer:
            if level == .beginner {
                return "You visit \(setting). You see \(topic.name.lowercased()) all around. A guide says: \(fact) You learn a new word: \(vocab)."
            }
            if level == .confidentReader || level == .growingReader {
                return """
                Warm light fills \(setting) as your adventure begins. Shapes, sounds, and colors of the \(topic.name.lowercased()) world surround you on every side. \
                A friendly guide walks beside you and points out something important: \(fact) \
                You pause to write \"\(vocab)\" in your notebook — a powerful new word for a new discovery. \
                As you read the signs and listen closely, you realize this place holds more secrets than you first expected. \
                Every detail in the story might become a clue for the mission ahead.
                """
            }
            return "Warm light fills \(setting) as you explore. Shapes and sounds of \(topic.name.lowercased()) surround you. A guide points out something important: \(fact) You write \"\(vocab)\" in your notebook — a new word for a new discovery."
        case .rescue:
            if level == .beginner {
                return "At \(setting), a friend looks worried. You remember: \(fact) That fact might help you save the day!"
            }
            return "Wind rustles through \(setting). Someone needs help with a \(topic.name.lowercased()) problem. You read the rescue notes twice and recall: \(fact) You take a steady breath — \(vocab.lowercased()) is a clue you can use."
        case .mystery, .detective:
            if level == .beginner {
                return "At \(setting), something unexpected happens in the \(topic.name.lowercased()) world. You notice one change, then another. A helper reminds you: \(fact) Write down each clue before you decide."
            }
            return """
            At \(setting), a puzzle unfolds around \(topic.name.lowercased()). \
            First, you notice a small change in the scene. Next, a second detail does not quite match your first guess. \
            A careful note reminds you: \(fact) \
            You whisper \"\(vocab)\" and keep gathering evidence — the answer should come from several connected clues, not one giveaway word.
            """
        case .builder:
            if level == .beginner {
                return "At \(setting), you build something. Remember: \(fact) Count each piece. Use the word \(vocab)."
            }
            if level == .confidentReader || level == .growingReader {
                return "Blueprints spread across a table at \(setting). You learn that \(fact) With careful steps, you measure, count, and fit each piece about \(topic.name.lowercased()). You check the plan twice and write \"\(vocab)\" beside the final sketch."
            }
            return "Blueprints spread across a table at \(setting). You learn that \(fact) With careful steps, you begin building something wonderful — measuring, counting, and fitting each piece about \(topic.name.lowercased())."
        case .animalExpert:
            if level == .beginner {
                return "Friends meet at \(setting). You share one fact: \(fact) You teach the word \(vocab)."
            }
            if level == .confidentReader || level == .growingReader {
                return "Visitors gather at \(setting) to learn from you. You share careful facts about \(topic.name.lowercased()). \(fact) You teach the word \"\(vocab),\" answer follow-up questions, and help everyone leave feeling like an expert."
            }
            return "Visitors gather at \(setting) to learn from you. You share your best facts about \(topic.name.lowercased()). \(fact) You teach the word \"\(vocab)\" and answer questions until everyone feels like an expert."
        case .spaceMission:
            if level == .beginner {
                return "At \(setting), your team gets ready. Remember: \(fact) Check your gear. Learn the word \(vocab)."
            }
            if level == .confidentReader || level == .growingReader {
                return "Countdown echoes through \(setting). Your team prepares for a \(topic.name.lowercased()) mission. Mission notes remind you: \(fact) You review \"\(vocab),\" confirm every supply, and give a clear thumbs-up before launch."
            }
            return "Countdown echoes through \(setting). Your team prepares for a \(topic.name.lowercased()) mission. Mission notes remind you: \(fact) You check your gear, review \"\(vocab),\" and give a thumbs-up."
        case .creativeLab:
            if level == .beginner {
                return "At \(setting), makers create. A poster says: \(fact) You use the word \(vocab) in your idea."
            }
            if level == .confidentReader || level == .growingReader {
                return "Music plays softly at \(setting) while creators work. A poster reads: \(fact) You mix real facts about \(topic.name.lowercased()) with imagination, sketching plans that use \"\(vocab)\" with purpose in the story."
            }
            return "Music plays softly at \(setting) while creators work. A poster reads: \(fact) You mix facts about \(topic.name.lowercased()) with wild imagination, sketching plans that include \"\(vocab)\" in the story."
        }
    }

    private static func comprehensionQuestions(
        lessonType: LessonType,
        passage: String,
        topic: TopicDefinition,
        vocab: String,
        fact: String,
        seed: Int,
        level: ReadingLevel
    ) -> [LessonQuestion] {
        let setting = topic.storySettings[seed % topic.storySettings.count]
        let altFact = topic.scienceFacts[(seed + 1) % topic.scienceFacts.count]
        let altFact2 = topic.scienceFacts[(seed + 2) % topic.scienceFacts.count]
        let rules = LessonDifficultyRules.profile(for: level)
        let topicName = topic.name.lowercased()

        var prompts = passageComprehensionPrompts(
            passage: passage,
            topic: topic,
            setting: setting,
            fact: fact,
            altFact: altFact,
            altFact2: altFact2,
            seed: seed,
            level: level
        )

        if prompts.isEmpty {
            prompts = [
                (
                    "Where does most of this story happen?",
                    settingDistractors(for: topic, correct: setting, seed: seed),
                    setting,
                    "The adventure takes place at \(setting)."
                )
            ]
        }

        if rules.supportsInference, !prompts.contains(where: { $0.0.lowercased().contains("why") }) {
            prompts.append((
                "What is this story mostly about?",
                [
                    "A character solving a \(topicName) problem using details from the scene",
                    "A list of \(topicName) words with no story",
                    "A character ignoring the \(topicName) setting completely"
                ],
                "A character solving a \(topicName) problem using details from the scene",
                "The story follows a \(topicName) adventure and the details that matter."
            ))
        }

        let count = rules.readingQuestionRange.upperBound
        var questions = Array(prompts.prefix(count)).map { prompt in
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: prompt.0,
                choices: prompt.1,
                correctAnswer: prompt.2,
                explanation: prompt.3,
                difficultyLevel: level
            )
        }

        if lessonType == .mystery || lessonType == .detective {
            let mystery = LessonQuestion.mystery(
                kind: .science,
                setup: "At \(setting), something unexpected happens in the \(topicName) world. What conclusion fits the evidence?",
                clues: [
                    "First, you notice a change that belongs to this \(topicName) place.",
                    "A second detail matches what you learned: \(fact)",
                    "The word \"\(vocab)\" helps you describe the evidence carefully."
                ],
                prompt: "Which conclusion is best supported by the clues?",
                choices: uniqueChoices([fact, altFact, altFact2], correct: fact),
                correctAnswer: fact,
                explanation: "The connected clues and the passage fact support \"\(fact)\" better than the other options.",
                difficultyLevel: level
            )
            // Prefer a real progressive mystery over a meta “read carefully” quiz item.
            if questions.isEmpty {
                questions = [mystery]
            } else {
                questions[0] = mystery
            }
        }

        return questions
    }

    /// Keeps the correct answer and fills remaining slots with unique plausible alternatives.
    private static func uniqueChoices(_ options: [String], correct: String) -> [String] {
        var result: [String] = [correct]
        for option in options where option.caseInsensitiveCompare(correct) != .orderedSame {
            if !result.contains(where: { $0.caseInsensitiveCompare(option) == .orderedSame }) {
                result.append(option)
            }
            if result.count == 3 { break }
        }
        return result
    }

    private static func settingDistractors(for topic: TopicDefinition, correct: String, seed: Int) -> [String] {
        var options = topic.storySettings
        let extras = topicPlausibleSettings(for: topic.id)
        options.append(contentsOf: extras)
        return uniqueChoices(options, correct: correct)
    }

    /// Builds story-grounded reading questions from the passage itself.
    private static func passageComprehensionPrompts(
        passage: String,
        topic: TopicDefinition,
        setting: String,
        fact: String,
        altFact: String,
        altFact2: String,
        seed: Int,
        level: ReadingLevel
    ) -> [(String, [String], String, String)] {
        let sentences = PassageMatchingQuestionGenerator.splitSentences(passage)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.count >= 28 }
        let topicName = topic.name.lowercased()
        var prompts: [(String, [String], String, String)] = []

        if passage.localizedCaseInsensitiveContains(setting) {
            prompts.append((
                "Where does most of this story happen?",
                settingDistractors(for: topic, correct: setting, seed: seed),
                setting,
                "The story takes place at \(setting)."
            ))
        }

        if passage.localizedCaseInsensitiveContains(fact), fact.count > 12 {
            prompts.append((
                "Which detail from the story is true?",
                uniqueChoices([fact, altFact, altFact2], correct: fact),
                fact,
                "That detail appears in the reading passage."
            ))
        }

        if let actionSentence = sentences.first(where: { sentence in
            let lower = sentence.lowercased()
            return lower.contains(" because ")
                || lower.contains(" so ")
                || lower.contains(" instead ")
                || lower.hasPrefix("she ")
                || lower.hasPrefix("he ")
        }) {
            let correct = shortenSentence(actionSentence, limit: 72)
            let distractors = uniqueChoices(
                [correct] + topicPlausibleSettings(for: topic.id).map { "The story is only about \($0)." },
                correct: correct
            )
            if distractors.count >= 3 {
                prompts.append((
                    "According to the story, which sentence is true?",
                    Array(distractors.prefix(3)),
                    correct,
                    "That idea is stated in the passage."
                ))
            }
        }

        if level == .confidentReader || level == .growingReader,
           let later = sentences.dropFirst().last {
            let correct = shortenSentence(later, limit: 72)
            let wrongs = [
                "The character left before anything in the story happened.",
                "The \(topicName) setting is never mentioned in the passage."
            ]
            prompts.append((
                "How does this story end?",
                uniqueChoices([correct] + wrongs, correct: correct),
                correct,
                "The last part of the passage tells what happens next."
            ))
        }

        return prompts
    }

    private static func shortenSentence(_ text: String, limit: Int) -> String {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleaned.count > limit else { return cleaned }
        let idx = cleaned.index(cleaned.startIndex, offsetBy: limit)
        if let space = cleaned[..<idx].lastIndex(of: " ") {
            return String(cleaned[..<space])
        }
        return String(cleaned.prefix(limit))
    }

    private static func topicPlausibleSettings(for topic: Topic) -> [String] {
        switch topic {
        case .sharks, .oceanAnimals:
            return ["a kelp forest", "a sandy lagoon", "a shipwreck reef"]
        case .horses:
            return ["a green pasture", "a riding trail", "a quiet barn aisle"]
        case .dinosaurs:
            return ["a fern hillside", "a muddy riverbank", "a rocky dig site"]
        case .space, .planets, .rockets:
            return ["a glowing moon base", "an asteroid observation deck", "mission control"]
        case .princesses, .castles, .fairies:
            return ["a garden courtyard", "a watch tower", "a candlelit ballroom"]
        case .soccer, .basketball:
            return ["the practice field", "the team bench", "the equipment room"]
        case .dogs, .cats:
            return ["a sunny living room", "a quiet hallway", "a backyard path"]
        case .robots:
            return ["the repair workshop", "the coding lab", "a city sidewalk"]
        case .pirates:
            return ["a sandy cove", "a rocky overlook", "a wooden ship deck"]
        default:
            return ["a quiet lookout", "a winding path", "a busy gathering place"]
        }
    }

    private static func readingSkillName(for type: LessonType) -> String {
        switch type {
        case .detective, .mystery: return "Close reading"
        case .explorer: return "Finding main ideas"
        case .rescue: return "Using context clues"
        case .builder: return "Following directions"
        case .animalExpert: return "Learning from nonfiction"
        case .spaceMission: return "Reading for details"
        case .creativeLab: return "Connecting ideas"
        }
    }

    private static func reflectionQuestion(for type: LessonType, topic: String) -> String {
        let name = topic.lowercased()
        switch type {
        case .explorer: return "What real detail about \(name) did you use to answer a question?"
        case .rescue: return "What step from the \(name) rescue plan did you follow?"
        case .mystery, .detective: return "Which \(name) clue from the story pointed to the answer?"
        case .builder: return "Which number from the \(name) plan did you need to finish the job?"
        case .animalExpert: return "What fact about \(name) from the lesson can you say in your own words?"
        case .spaceMission: return "Which mission step from the \(name) checklist came first?"
        case .creativeLab: return "What \(name) detail from the story did you put in your creation?"
        }
    }
}
