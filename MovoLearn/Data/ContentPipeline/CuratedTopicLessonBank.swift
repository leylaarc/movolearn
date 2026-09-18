import Foundation

/// Hand-authored, topic-specific lesson content for the approved library.
/// Quality over volume: each topic×level pack has its own facts, vocabulary,
/// story, activity shape, and questions — never a noun-swapped template.
enum CuratedTopicLessonBank {

    struct ReadingPack {
        let title: String
        let storyOpening: String
        let missionPrompt: String
        let readingPassage: String
        let questions: [LessonQuestion]
        let vocabularyWords: [VocabularyWord]
        let knowledgeFacts: [KnowledgeFact]
        let creativePrompt: String
        let creativeResponseType: QuestionResponseType
        let storyEnding: String
        let readingSkill: String
        let reflectionPrompt: String
        let hints: [String]
        let commonMistakes: [String]
        let successCriteria: [String]
        let learningObjectives: [String]
        /// Internal fingerprint for diversity tracking (not shown to children).
        let activityFingerprint: String
        let characterNames: [String]
    }

    struct MathScene {
        let title: String
        let storyOpening: String
        let missionPrompt: String
        let readingPassage: String
        let problems: [LessonQuestion]
        let vocabularyWords: [VocabularyWord]
        let knowledgeFacts: [KnowledgeFact]
        let creativePrompt: String
        let storyEnding: String
        let mathSkill: String
        let reflectionPrompt: String
        let hints: [String]
        let activityFingerprint: String
    }

    /// Science investigation packs — mini-scenes with real facts, not story clones.
    struct DiscoveryPack {
        let title: String
        let storyOpening: String
        let missionPrompt: String
        let readingPassage: String
        let questions: [LessonQuestion]
        let vocabularyWords: [VocabularyWord]
        let knowledgeFacts: [KnowledgeFact]
        let creativePrompt: String
        let storyEnding: String
        let readingSkill: String
        let reflectionPrompt: String
        let hints: [String]
        let commonMistakes: [String]
        let successCriteria: [String]
        let learningObjectives: [String]
        let activityFingerprint: String
    }

    /// Creative-lab packs — short inspiration + make/draw/write prompt (not story quizzes).
    struct CreativePack {
        let title: String
        let storyOpening: String
        let missionPrompt: String
        let inspiration: String
        let vocabularyWords: [VocabularyWord]
        let knowledgeFacts: [KnowledgeFact]
        let creativePrompt: String
        let creativeResponseType: QuestionResponseType
        let storyEnding: String
        let reflectionPrompt: String
        let hints: [String]
        let successCriteria: [String]
        let learningObjectives: [String]
        let activityFingerprint: String
        /// Checklist chips on the Art Quest drawing board.
        let drawingGoals: [String]
    }

    // MARK: - Public lookup

    static func readingPack(topic: Topic, level: ReadingLevel) -> ReadingPack? {
        switch topic {
        case .horses: return horsesReading(level)
        case .jungleAnimals: return jungleReading(level)
        case .sharks: return oceanReading(level)
        case .oceanAnimals: return oceanAnimalsReading(level)
        case .space: return spaceReading(level)
        case .planets: return planetsReading(level)
        case .rockets: return rocketsReading(level)
        case .dinosaurs: return dinosaursReading(level)
        default: return extendedReadingPack(topic: topic, level: level)
        }
    }

    static func mathScene(topic: Topic, mathLevel: MathLevel, readingLevel: ReadingLevel) -> MathScene? {
        guard let authored = authoredMathScene(topic: topic, mathLevel: mathLevel, readingLevel: readingLevel) else {
            return nil
        }
        return withVariedMathProblems(
            authored,
            topic: topic,
            mathLevel: mathLevel,
            readingLevel: readingLevel
        )
    }

    /// Hand-authored story framing for math lessons (titles, openings, facts).
    /// Numeric problems are diversified in `mathScene` so topics do not share one number skeleton.
    private static func authoredMathScene(topic: Topic, mathLevel: MathLevel, readingLevel: ReadingLevel) -> MathScene? {
        switch topic {
        case .horses: return horsesMath(mathLevel, reading: readingLevel)
        case .jungleAnimals: return jungleMath(mathLevel, reading: readingLevel)
        case .sharks: return oceanMath(mathLevel, reading: readingLevel)
        case .oceanAnimals: return oceanAnimalsMath(mathLevel, reading: readingLevel)
        case .space: return spaceMath(mathLevel, reading: readingLevel)
        case .planets: return planetsMath(mathLevel, reading: readingLevel)
        case .rockets: return rocketsMath(mathLevel, reading: readingLevel)
        case .dinosaurs: return dinosaursMath(mathLevel, reading: readingLevel)
        default: return extendedMathScene(topic: topic, mathLevel: mathLevel, readingLevel: readingLevel)
        }
    }

    /// Keep curated theme framing; replace cloned arithmetic with topic-seeded variety.
    private static func withVariedMathProblems(
        _ scene: MathScene,
        topic: Topic,
        mathLevel: MathLevel,
        readingLevel: ReadingLevel
    ) -> MathScene {
        let groupingLesson = scene.activityFingerprint.contains("groups")
            || scene.mathSkill.lowercased().contains("group")
            || scene.missionPrompt.lowercased().contains("into groups")
        let matching = scene.problems.filter { $0.responseType == .matching }
        let mathCount = max(scene.problems.filter { $0.responseType != .matching }.count, 3)
        let seed = MathWordProblemGenerator.varietySeed(
            topic: topic,
            mathLevel: mathLevel,
            readingLevel: readingLevel
        )
        let generated = groupingLesson
            ? MathWordProblemGenerator.generateGroupingQuestions(
                topic: topic,
                seed: seed,
                level: readingLevel,
                mathLevel: mathLevel,
                count: mathCount,
                passage: scene.readingPassage
            )
            : MathWordProblemGenerator.generateQuestions(
                topic: topic,
                seed: seed,
                level: readingLevel,
                mathLevel: mathLevel,
                count: mathCount,
                passage: scene.readingPassage
            )
        let mathProblems = generated.isEmpty
            ? scene.problems.filter { $0.responseType != .matching }
            : Array(generated.prefix(mathCount))
        let problems = matching + mathProblems
        return MathScene(
            title: scene.title,
            storyOpening: scene.storyOpening,
            missionPrompt: scene.missionPrompt,
            readingPassage: scene.readingPassage,
            problems: problems,
            vocabularyWords: scene.vocabularyWords,
            knowledgeFacts: scene.knowledgeFacts,
            creativePrompt: mathDrawingPrompt(
                topic: topic,
                mathLevel: mathLevel,
                seed: seed,
                problems: problems
            ),
            storyEnding: scene.storyEnding,
            mathSkill: scene.mathSkill,
            reflectionPrompt: scene.reflectionPrompt,
            hints: scene.hints,
            activityFingerprint: "\(scene.activityFingerprint).nums.\(seed % 997)"
        )
    }

    /// Drawing wrap-up that matches this lesson's objects and numbers — not a cloned "Draw 9 X" line.
    private static func mathDrawingPrompt(
        topic: Topic,
        mathLevel: MathLevel,
        seed: Int,
        problems: [LessonQuestion]
    ) -> String {
        let scene = MathWordProblemScenes.scenes(for: topic).first
            ?? MathCountableScene(
                character: nil,
                pronoun: "they",
                possessive: "their",
                objectSingular: "object",
                objectPlural: "objects",
                location: "in the picture",
                groupStateVerb: "are waiting",
                joinVerb: "arrived",
                leaveVerbSingular: "left",
                leaveVerbPlural: "left",
                collectVerb: "counted",
                giveVerb: "shared"
            )
        let objects = scene.objectPlural
        let location = scene.location

        switch mathLevel {
        case .emerging:
            let count = drawableCount(from: problems, min: 2, max: 6)
                ?? (3 + abs(seed) % 4)
            return "Draw \(count) \(noun(count, scene)) \(location)."
        case .developing:
            if let addition = firstEquation(from: problems, operators: ["+"]),
               addition.lhs <= 6, addition.rhs <= 6, addition.lhs + addition.rhs <= 10 {
                return "Draw \(addition.lhs) \(noun(addition.lhs, scene)) \(location). Then draw \(addition.rhs) more \(noun(addition.rhs, scene))."
            }
            let count = drawableCount(from: problems, min: 3, max: 8)
                ?? (4 + abs(seed) % 4)
            return "Draw \(count) \(noun(count, scene)) \(location)."
        case .secure:
            let groups = firstEquation(from: problems, operators: ["×", "x"])
            if let groups, (2...5).contains(groups.lhs), (2...5).contains(groups.rhs) {
                return "Draw \(groups.lhs) groups with \(groups.rhs) \(objects) in each group."
            }
            let groupCount = 2 + abs(seed) % 3
            let perGroup = 3 + abs(seed / 5) % 3
            return "Draw \(groupCount) groups with \(perGroup) \(objects) in each group."
        case .advancing:
            return "Draw the \(objects) in equal groups."
        }
    }

    private static func noun(_ count: Int, _ scene: MathCountableScene) -> String {
        count == 1 ? scene.objectSingular : scene.objectPlural
    }

    private static func drawableCount(from problems: [LessonQuestion], min: Int, max: Int) -> Int? {
        for problem in problems {
            if let value = Int(problem.correctAnswer ?? ""), (min...max).contains(value) {
                return value
            }
        }
        return nil
    }

    private static func firstEquation(
        from problems: [LessonQuestion],
        operators: [String]
    ) -> (lhs: Int, rhs: Int, result: Int)? {
        let escapedOps = operators.map { NSRegularExpression.escapedPattern(for: $0) }.joined(separator: "|")
        let pattern = "(\\d+)\\s*(?:" + escapedOps + ")\\s*(\\d+)\\s*=\\s*(\\d+)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        for problem in problems {
            let explanation = problem.explanation?.replacingOccurrences(of: "−", with: "-") ?? ""
            let range = NSRange(explanation.startIndex..., in: explanation)
            if let match = regex.firstMatch(in: explanation, range: range),
               let lhsRange = Range(match.range(at: 1), in: explanation),
               let rhsRange = Range(match.range(at: 2), in: explanation),
               let resultRange = Range(match.range(at: 3), in: explanation),
               let lhs = Int(explanation[lhsRange]),
               let rhs = Int(explanation[rhsRange]),
               let result = Int(explanation[resultRange]) {
                return (lhs, rhs, result)
            }
        }
        return nil
    }

    /// Review exemplars requested for product QA (K + advanced × horses + jungle).
    static func reviewExemplars() -> [Lesson] {
        let specs: [(Topic, LessonCategory, ReadingLevel, MathLevel)] = [
            (.horses, .story, .beginner, .emerging),
            (.jungleAnimals, .story, .beginner, .emerging),
            (.horses, .story, .confidentReader, .secure),
            (.jungleAnimals, .story, .confidentReader, .secure)
        ]
        return specs.compactMap {
            LevelSpecificContentFactory.makeApprovedLesson(
                topic: $0.0,
                category: $0.1,
                readingLevel: $0.2,
                mathLevel: $0.3
            )
        }
    }

    // MARK: - Horses (barn, care, safety — never a trail/cove skeleton)

    private static func horsesReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Get the Pony Ready",
                storyOpening: "Sunny the pony stamps softly in the barn. Will you help Mia get him ready?",
                missionPrompt: "Follow Mia's morning steps with Sunny.",
                readingPassage: "Mia opens the stall door for Sunny. She brushes Sunny's soft coat with gentle strokes. Then she fills the water bucket. Sunny stamps one foot and waits for hay.",
                questions: [
                    mcq("What does Mia open first?", ["The stall door", "The barn window", "The hay loft"], "The stall door", "Mia opens the stall door first."),
                    mcq("What does Mia brush?", ["Sunny's soft coat", "Sunny's hoof pick", "The stall latch"], "Sunny's soft coat", "Mia brushes Sunny's soft coat."),
                    mcq("What does Mia fill?", ["The water bucket", "The grain scoop", "The bridle hook"], "The water bucket", "Mia fills the water bucket.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "stall", definition: "A small room in a barn for a horse.", exampleSentence: "Sunny waits in the stall."),
                    VocabularyWord(word: "brush", definition: "To clean a coat with soft strokes.", exampleSentence: "Mia will brush Sunny.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Horses drink fresh water every day.", explanation: "A full water bucket helps a pony stay healthy.")
                ],
                creativePrompt: "Draw Mia brushing Sunny in the stall. Add the water bucket.",
                creativeResponseType: .drawing,
                storyEnding: "Sunny is clean, calm, and ready for a gentle day in the sun.",
                readingSkill: "Follow a simple barn routine",
                reflectionPrompt: "What is one kind thing Mia did for Sunny?",
                hints: ["Look at the first sentence", "Find the word brush in the story"],
                commonMistakes: ["Guessing without reading each sentence"],
                successCriteria: ["Names a real barn step from the story", "Matches an action to Mia or Sunny"],
                learningObjectives: ["Identify concrete details in a short barn story"],
                activityFingerprint: "horses.k.barn-routine.detail",
                characterNames: ["Mia", "Sunny"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "A Morning at the Horse Barn",
                storyOpening: "Hay dust floats in the sunny light as Mia opens the barn doors.",
                missionPrompt: "Notice how Mia keeps the ponies calm this morning.",
                readingPassage: "Mia walks into the sunny barn. Three ponies flick their tails by the fence. She speaks softly so they stay calm. A foal stands close to its mother. Mia shows visitors how to stand where a horse can see them.",
                questions: [
                    mcq("How does Mia speak near the ponies?", ["Softly", "Loudly", "Only by shouting"], "Softly", "Mia speaks softly so the ponies stay calm."),
                    mcq("Where does a foal stand?", ["Close to its mother", "Far across the road", "Under a boat"], "Close to its mother", "A foal stands close to its mother."),
                    mcq("Where should visitors stand?", ["Where a horse can see them", "Directly behind a horse", "On the roof"], "Where a horse can see them", "Mia shows visitors how to stand where a horse can see them.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "foal", definition: "A baby horse.", exampleSentence: "The foal stays near its mother."),
                    VocabularyWord(word: "calm", definition: "Quiet and gentle.", exampleSentence: "Soft voices help ponies stay calm.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "A foal is a young horse that often stays near its mother.", explanation: "Young horses feel safer with an adult horse nearby.")
                ],
                creativePrompt: "Draw the sunny barn with one foal standing beside its mother.",
                creativeResponseType: .drawing,
                storyEnding: "Soft voices and careful steps leave the ponies calm and easy.",
                readingSkill: "Find key details about horse care",
                reflectionPrompt: "Which barn tip helps ponies feel safe?",
                hints: ["Find the sentence about soft voices", "Look for the word foal"],
                commonMistakes: ["Choosing a loud or startling action"],
                successCriteria: ["Uses a story detail about manners around horses"],
                learningObjectives: ["Recall horse-safety details from a short passage"],
                activityFingerprint: "horses.early.barn-manners.detail",
                characterNames: ["Mia"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Soft Voices Keep Ponies Safe",
                storyOpening: "New visitors gather at the fence while Mia waits with a calm smile.",
                missionPrompt: "Find the safety lesson Mia wants everyone to remember.",
                readingPassage: "Mia led the visitors into the sunny yard where three ponies swished their tails. She explained that horses feel safer when people speak softly, move calmly, and never sneak up from directly behind, because that can startle a horse. A foal stayed near its mother while Mia pointed out how a horse's ears show curiosity or worry. The visitors practiced standing where the ponies could see them. By the end, everyone understood one clear rule: careful manners keep horses and people safe.",
                questions: [
                    mcq("What is the main safety lesson?", ["Careful manners keep horses and people safe", "Horses prefer loud surprises", "Visitors should sneak up from behind"], "Careful manners keep horses and people safe", "The passage ends with that clear rule."),
                    mcq("Why should people not approach from directly behind?", ["It can startle a horse", "It helps a horse nap", "It makes ears point forward"], "It can startle a horse", "Approaching from behind can startle horses."),
                    mcq("What can a horse's ears show?", ["Curiosity or worry", "The weather tomorrow", "How fast to run a race"], "Curiosity or worry", "Mia explained that ear position can show curiosity or worry.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "approach", definition: "To come near something.", exampleSentence: "Do not approach a horse from behind."),
                    VocabularyWord(word: "manners", definition: "Careful, polite ways to act.", exampleSentence: "Good manners keep ponies calm.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Horses cannot see well directly behind them.", explanation: "Standing where a horse can see you feels safer for the animal.")
                ],
                creativePrompt: "Draw a visitor standing where a pony can see them. Add soft speech bubbles.",
                creativeResponseType: .drawing,
                storyEnding: "The visitors leave with real horse manners they can use on their next visit.",
                readingSkill: "Identify the main idea in a horse-safety passage",
                reflectionPrompt: "What is the main safety lesson Mia wants visitors to remember?",
                hints: ["Reread the last sentence", "Find the tip about standing where horses can see you"],
                commonMistakes: ["Picking an exciting but unsafe action"],
                successCriteria: ["States the main safety idea in own words"],
                learningObjectives: ["Identify the main idea of a nonfiction horse-safety passage"],
                activityFingerprint: "horses.growing.safety-main-idea",
                characterNames: ["Mia"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Reading a Horse's Ears",
                storyOpening: "Mia asks the group to watch how the ponies talk with their bodies before anyone steps closer.",
                missionPrompt: "Check what the ponies' clues tell you, and why Mia changes the plan.",
                readingPassage: """
                Mia guided the group into the sunny yard, where three ponies swished their tails and watched every step. She explained that horses rely on calm voices, steady movement, and clear sight lines to feel safe. Approaching from directly behind can startle them, so visitors learned to stand where a horse can see them first. A foal stayed close to its mother while Mia described how ear position and body language reveal curiosity or worry. When one pony pinned its ears back, Mia asked everyone to pause and step sideways into the pony's view, because pinned ears can mean the pony might be worried or upset. Using those clues, the visitors practiced safer greetings before offering a gentle scratch on the neck. Mia finished by connecting each tip to one goal: thoughtful care for horses and people.
                """,
                questions: [
                    mcq("Why did Mia ask everyone to pause when a pony pinned its ears?", ["The pony might be worried or upset", "The pony wanted a louder song", "The pony was asking for a race"], "The pony might be worried or upset", "Pinned ears can show worry; Mia paused for safety."),
                    mcq("What can you tell about Mia's goal?", ["She wants thoughtful care for horses and people", "She wants visitors to sneak up faster", "She wants ponies to ignore body language"], "She wants thoughtful care for horses and people", "Mia connects each tip to protecting horses and people."),
                    mcq("Which clue helped visitors choose a safer greeting?", ["Standing where the horse can see them", "Walking directly behind the horse", "Shouting near the fence"], "Standing where the horse can see them", "Clear sight lines help horses feel safe.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "body language", definition: "Messages shown with ears, posture, or movement.", exampleSentence: "Horse body language can show worry."),
                    VocabularyWord(word: "sight line", definition: "The path where someone or something can see.", exampleSentence: "Stand in a horse's sight line.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Pinned-back ears can mean a horse feels tense or upset.", explanation: "Readers use that clue to choose a calmer action.")
                ],
                creativePrompt: "Why did Mia ask everyone to pause when a pony pinned its ears?",
                creativeResponseType: .shortText,
                storyEnding: "The group leaves knowing how to listen to horse clues, not only to rules on a sign.",
                readingSkill: "Use horse body-language evidence to explain actions",
                reflectionPrompt: "Which clue helped visitors choose a safer greeting?",
                hints: ["Look for the sentence about pinned ears", "Connect Mia's pause to safety"],
                commonMistakes: ["Ignoring body-language clues"],
                successCriteria: ["Explains an action using a detail from the passage"],
                learningObjectives: ["Infer a character's reason using horse body-language evidence"],
                activityFingerprint: "horses.confident.body-language.inference",
                characterNames: ["Mia"]
            )
        }
    }

    // MARK: - Jungle (rainforest layers, animals, camouflage — distinct from barn)

    private static func jungleReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Who Lives in the Trees?",
                storyOpening: "The jungle hums with green leaves and soft rain. Come see who lives here.",
                missionPrompt: "Find where each animal makes its home.",
                readingPassage: "A toucan sits high in the leafy canopy. Down low, a jaguar walks near the river below. A bright frog hides on a damp leaf. Soft rain drips from the tall trees.",
                questions: [
                    mcq("Where does the toucan sit?", ["High in the leafy canopy", "On the muddy forest floor", "Inside a hollow log"], "High in the leafy canopy", "The toucan sits high in the leafy canopy."),
                    mcq("Where does the jaguar walk?", ["Near the river below", "High on a dry cliff", "Inside a flower bud"], "Near the river below", "The jaguar walks near the river below."),
                    mcq("Where does the frog hide?", ["On a damp leaf", "On a sunny rock with no shade", "In a dry desert burrow"], "On a damp leaf", "The frog hides on a damp leaf.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "canopy", definition: "The high leafy tops of jungle trees.", exampleSentence: "The toucan sits in the canopy."),
                    VocabularyWord(word: "jungle", definition: "A warm, rainy forest with many plants.", exampleSentence: "Rain drips in the jungle.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Many jungle birds live high in the canopy where fruit grows.", explanation: "Different animals use different layers of the rainforest.")
                ],
                creativePrompt: "Draw a toucan in the canopy and a jaguar by the river.",
                creativeResponseType: .drawing,
                storyEnding: "Three animals, three homes — the rainforest stacks its neighbors in layers.",
                readingSkill: "Match jungle animals to habitats",
                reflectionPrompt: "Where does the jaguar walk?",
                hints: ["Find the word canopy", "Look for the river sentence"],
                commonMistakes: ["Mixing up canopy and river homes"],
                successCriteria: ["Pairs an animal with the place named in the story"],
                learningObjectives: ["Match animals to rainforest places using story details"],
                activityFingerprint: "jungle.k.habitat-match",
                characterNames: []
            )
        case .earlyReader:
            return ReadingPack(
                title: "Rain on the Jungle Path",
                storyOpening: "Soft rain taps the leaves as Lina sets out on the muddy path.",
                missionPrompt: "Check what Lina notices on her rainy walk.",
                readingPassage: "Lina steps onto a muddy jungle path after a soft rain. She hears howler monkeys call from high branches. Broad leaves catch the water like little umbrellas. A line of leafcutter ants carries green bits toward a nest. Lina writes one new word in her notebook: rainforest.",
                questions: [
                    mcq("What does Lina hear?", ["Howler monkeys", "Quiet owls only", "Silent snakes only"], "Howler monkeys", "She hears howler monkeys call from high branches."),
                    mcq("What do the broad leaves do?", ["Catch the water like little umbrellas", "Hold dry desert sand", "Block every animal path"], "Catch the water like little umbrellas", "Broad leaves catch the water like little umbrellas."),
                    mcq("What new word does Lina write?", ["Rainforest", "Desert", "Tundra"], "Rainforest", "Lina writes the word rainforest.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "rainforest", definition: "A warm forest that gets a lot of rain.", exampleSentence: "A rainforest stays green and wet."),
                    VocabularyWord(word: "path", definition: "A place to walk through the trees.", exampleSentence: "Lina walks on a muddy path.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Rainforests get heavy rain, so plants grow large leaves that shed water.", explanation: "Leaf shapes help plants live in wet climates.")
                ],
                creativePrompt: "Draw Lina on the muddy path with ants carrying green bits.",
                creativeResponseType: .drawing,
                storyEnding: "Lina closes her notebook with a wet-path memory and a brand-new word.",
                readingSkill: "Recall details from a jungle walk",
                reflectionPrompt: "What jungle sound or sight do you remember most?",
                hints: ["Find the monkeys sentence", "Look for the notebook word"],
                commonMistakes: ["Choosing a detail from another theme"],
                successCriteria: ["Names a rainforest detail from the passage"],
                learningObjectives: ["Identify key details in a short rainforest narrative"],
                activityFingerprint: "jungle.early.rain-path.detail",
                characterNames: ["Lina"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Hidden in Green",
                storyOpening: "Lina wonders how so many animals stay hard to spot in the green shade.",
                missionPrompt: "Discover how jungle animals stay safe in different ways.",
                readingPassage: "Lina watched a stick insect hold perfectly still on a twig in the green shade. Nearby, a jaguar's spotted coat broke up its shape in the shadows. A bright poison dart frog sat on a damp leaf, using bold color as a warning to stay away instead of a hiding trick. Lina realized that jungle animals stay safe in different ways. Camouflage helps some animals blend in, while bright colors can tell others to stay away. She sketched both ideas before the rain returned.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Jungle animals stay safe in different ways", "Every animal lives only by the river", "Rain never falls in a rainforest"], "Jungle animals stay safe in different ways", "Lina realizes the jungle uses more than one way to stay safe."),
                    mcq("How does the jaguar's coat help?", ["It breaks up the jaguar's shape in the shadows", "It makes the jaguar glow at night", "It helps the jaguar climb like a frog"], "It breaks up the jaguar's shape in the shadows", "Spots help break up the jaguar's shape among leafy shadows."),
                    mcq("Why might a frog use bright color?", ["As a warning to stay away", "To call other frogs to play", "To dry the frog's skin faster"], "As a warning to stay away", "Bold color can warn others to stay away.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "camouflage", definition: "Colors or shapes that help an animal blend in.", exampleSentence: "Camouflage helps the stick insect hide."),
                    VocabularyWord(word: "warning", definition: "A signal that means be careful.", exampleSentence: "Bright color can be a warning.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Some rainforest animals blend into leaves; others use bright colors as a warning.", explanation: "Camouflage and warning colors are both survival strategies.")
                ],
                creativePrompt: "Draw one camouflaged animal and one brightly colored animal from the story.",
                creativeResponseType: .drawing,
                storyEnding: "Lina leaves with two jungle ideas tucked in her sketch: blend in, or warn.",
                readingSkill: "Identify the main idea about rainforest camouflage",
                reflectionPrompt: "Would you rather blend in like the stick insect or warn like the frog? Why?",
                hints: ["Reread the sentence that starts with Lina realized", "Compare the jaguar and the frog"],
                commonMistakes: ["Thinking every animal hides the same way"],
                successCriteria: ["States the main camouflage idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a camouflage passage"],
                activityFingerprint: "jungle.growing.camouflage-main-idea",
                characterNames: ["Lina"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Layers of the Rainforest",
                storyOpening: "Lina looks down from a rope bridge through green layers stacked like floors of one tall house.",
                missionPrompt: "Discover how the rainforest's layers shape where each animal lives.",
                readingPassage: """
                From the canopy walkway, Lina compared two worlds stacked in one forest. High above, toucans hopped between sunlit twigs, snapping fruit with long beaks. Mist clung to broad leaves, and the air felt warmer than the shaded floor — fruit and sunlight are easier to find in the canopy. Far below, a jaguar padded along a riverbank where light was dim and roots tangled like ropes. That quiet bank offered cover and water for a hunting cat. A guide explained that each layer offers different food, light, and shelter. Lina inferred that a fruit-eating bird thrives in the canopy, while a hunting cat needs the quieter ground near water. When clouds thickened, she revised her sketch labels: canopy for fruit and light, understory and floor for cover and rivers. The layers were not just pretty scenery — they explained why neighbors in the same jungle live so differently.
                """,
                questions: [
                    mcq("What can you infer about why toucans stay high up?", ["Fruit and sunlight are easier to find in the canopy", "The forest floor is brighter than the canopy", "Rivers only form above the treetops"], "Fruit and sunlight are easier to find in the canopy", "Toucans snap fruit in the sunlit canopy."),
                    mcq("Why might a jaguar use the riverbank area?", ["It offers cover and water for a hunting cat", "It is the brightest fruit market", "It is the windiest open meadow"], "It offers cover and water for a hunting cat", "The jaguar pads along a dim riverbank with tangled roots."),
                    mcq("What did the guide say each layer offers?", ["Different food, light, and shelter", "The same dry desert sand", "Only deep ocean water"], "Different food, light, and shelter", "Each layer offers different food, light, and shelter.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "understory", definition: "The shady plant layer under the tall treetops.", exampleSentence: "Little light reaches the understory."),
                    VocabularyWord(word: "infer", definition: "To figure something out using clues.", exampleSentence: "Lina can infer where each animal thrives.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Rainforests have layers such as canopy and forest floor with different light and food.", explanation: "Habitat layers help explain animal homes.")
                ],
                creativePrompt: "Write three sentences comparing life in the canopy with life near the riverbank.",
                creativeResponseType: .shortText,
                storyEnding: "Lina's labeled sketch now shows why one jungle can hold so many different homes.",
                readingSkill: "Infer habitat needs from rainforest layer details",
                reflectionPrompt: "Which rainforest layer would be hardest for people to visit, and why?",
                hints: ["Compare the toucan details with the jaguar details", "Use the guide's sentence about food, light, and shelter"],
                commonMistakes: ["Treating the whole jungle as one identical place"],
                successCriteria: ["Explains an animal's layer using passage evidence"],
                learningObjectives: ["Infer why animals live in different rainforest layers"],
                activityFingerprint: "jungle.confident.layers.inference",
                characterNames: ["Lina"]
            )
        }
    }

    // MARK: - Sharks

    private static func oceanReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Finn's Blue Wave",
                storyOpening: "Finn the reef shark wakes to a calm ocean morning. Will you swim beside him?",
                missionPrompt: "Check what Finn sees and does in the blue water.",
                readingPassage: "Finn sees a blue wave rolling toward him. He swims slowly through the calm water. A small fish dashes by. Soft bubbles rise from the rocks.",
                questions: [
                    mcq("What does Finn see?", ["A blue wave", "A dry sand dune", "A quiet tide pool only"], "A blue wave", "Finn sees a blue wave."),
                    mcq("How does Finn swim?", ["Slowly", "Only backward", "Without moving"], "Slowly", "He swims slowly."),
                    mcq("What dashes by?", ["A small fish", "A large whale", "A sleeping crab"], "A small fish", "A small fish dashes by.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "wave", definition: "Moving water on the ocean surface.", exampleSentence: "Finn sees a blue wave."),
                    VocabularyWord(word: "swim", definition: "To move through water.", exampleSentence: "Finn can swim slowly.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Sharks move through water in different ways.", explanation: "Reef sharks can swim slowly; small fish can dash quickly.")
                ],
                creativePrompt: "Draw Finn near a blue wave and a small fish.",
                creativeResponseType: .drawing,
                storyEnding: "Finn finishes his calm swim, and the reef feels quiet and kind.",
                readingSkill: "Find who and what in a short ocean story",
                reflectionPrompt: "What is one ocean thing you remember?",
                hints: ["Point to the word wave", "Find how Finn moves"],
                commonMistakes: ["Choosing land animals not in the story"],
                successCriteria: ["Names a detail from Finn's swim"],
                learningObjectives: ["Identify concrete details in a short ocean passage"],
                activityFingerprint: "ocean.k.wave-swim.detail",
                characterNames: ["Finn"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Reef Shark Visit",
                storyOpening: "Coral glows under sunny water as Finn the reef shark glides toward the reef.",
                missionPrompt: "Watch how Finn the reef shark moves past the little fish.",
                readingPassage: "Finn the reef shark glides near a sunny reef. He swims slowly and does not chase the little fish. Soft bubbles rise from the rocks. Finn stays still and watches until he glides away.",
                questions: [
                    mcq("What kind of shark is Finn?", ["A reef shark", "A giant whale shark only", "A tiny pond minnow"], "A reef shark", "Finn is a reef shark."),
                    mcq("Does Finn chase the little fish?", ["No", "Yes, very fast", "Only at night on land"], "No", "Finn does not chase the little fish."),
                    mcq("What rises from the rocks?", ["Soft bubbles", "Shells on the beach only", "Boats far out at sea"], "Soft bubbles", "Soft bubbles rise from the rocks.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "reef", definition: "A rocky ocean place where coral and fish live.", exampleSentence: "Finn glides near a sunny reef."),
                    VocabularyWord(word: "gentle", definition: "Soft and careful, not rough.", exampleSentence: "Finn moves in a gentle way.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Many reef sharks swim calmly and are not hunting every fish they pass.", explanation: "Watching carefully helps us learn real ocean behavior.")
                ],
                creativePrompt: "Draw the sunny reef with Finn and one little fish.",
                creativeResponseType: .drawing,
                storyEnding: "Finn the reef shark swam by. He moved slowly and did not chase the fish.",
                readingSkill: "Recall reef details from the passage",
                reflectionPrompt: "What reef detail would you tell a friend?",
                hints: ["Find the shark sentence", "Look for bubbles"],
                commonMistakes: ["Assuming every shark is chasing prey"],
                successCriteria: ["Uses a reef detail from the story"],
                learningObjectives: ["Recall key details from a short reef passage"],
                activityFingerprint: "ocean.early.reef-shark.detail",
                characterNames: ["Finn"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Where Reef Sharks Rest",
                storyOpening: "Finn the reef shark just finished a calm swim. He wants to find a quiet daytime rest spot.",
                missionPrompt: "Find where reef sharks rest, and why those spots matter.",
                readingPassage: "Finn followed a sandy channel beside the coral after a calm morning swim. Bubbles rose near a dark ledge, and tiny fish darted into holes in the reef. Reef sharks often rest in quiet pockets during the day. Finn settled in the cooler shade under the ledge. The details helped him understand that resting places matter as much as hunting places in ocean life.",
                questions: [
                    mcq("What is the main idea?", ["Reef sharks often rest in quiet pockets during the day", "Reef sharks never rest during the day", "Reef sharks only rest on dry land"], "Reef sharks often rest in quiet pockets during the day", "Reef sharks rest in quiet pockets during the day."),
                    mcq("Where did Finn settle?", ["In the cooler shade under the ledge", "On the brightest wave top", "In an empty boat"], "In the cooler shade under the ledge", "Finn settled under the ledge."),
                    mcq("Where do the tiny fish dart?", ["Into holes in the reef", "Onto dry sand far inland", "Into a floating bottle"], "Into holes in the reef", "Tiny fish darted into holes in the reef.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "channel", definition: "A path of water between coral or sand.", exampleSentence: "Finn followed a sandy channel."),
                    VocabularyWord(word: "rest", definition: "To stay quiet and still for a while.", exampleSentence: "Reef sharks rest in quiet pockets.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Reef sharks may rest in calm, shaded pockets during the day.", explanation: "Habitat knowledge includes resting places, not only swimming.")
                ],
                creativePrompt: "Draw the ledge resting spot and label one ocean detail from the story.",
                creativeResponseType: .drawing,
                storyEnding: "Finn now knows why quiet reef pockets matter on a sunny day.",
                readingSkill: "Identify the main idea about shark resting habitat",
                reflectionPrompt: "Why might a quiet pocket be a good daytime place for a reef shark?",
                hints: ["Reread the rest sentence", "Find where Finn settled"],
                commonMistakes: ["Inventing a hunt that the story does not describe"],
                successCriteria: ["States the resting-habitat main idea"],
                learningObjectives: ["Identify the main idea of a reef habitat passage"],
                activityFingerprint: "ocean.growing.resting-habitat.main-idea",
                characterNames: ["Finn"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Clues Along the Reef",
                storyOpening: "Ripples and fish dart past as Finn compares ocean clues before he picks a rest spot.",
                missionPrompt: "Explain what conclusion Finn reaches, and how the reef clues lead him there.",
                readingPassage: """
                Finn studied the reef like a careful young shark. Morning light made the water look calm, but ripples near the rocks suggested something moved below. Reef sharks choose resting spots for safety and cooler water. Finn compared two clues: fish fleeing toward the reef holes, and a smooth shape sliding through deeper water. Using both details, he concluded that another shark had already shifted locations. That conclusion changed his plan, so he moved toward a quieter rest ledge. He noticed two clear clues before leaving the busy channel.
                """,
                questions: [
                    mcq("What can you conclude about the other shark?", ["It had already shifted locations", "It never left the ledge", "It was resting on the beach"], "It had already shifted locations", "Finn concluded the other shark had shifted locations."),
                    mcq("Where did the fish flee?", ["Toward the reef holes", "Onto the dry beach", "Into the fishing boat"], "Toward the reef holes", "Fish were fleeing toward the reef holes."),
                    mcq("Where did Finn go after he changed his plan?", ["Toward a quieter rest ledge", "Into the busy channel", "Back to the beach"], "Toward a quieter rest ledge", "He moved toward a quieter rest ledge."),
                ],
                vocabularyWords: [
                    VocabularyWord(word: "evidence", definition: "Clues that support an idea.", exampleSentence: "Bubbles and ripples can be evidence."),
                    VocabularyWord(word: "conclude", definition: "To decide something after looking at clues.", exampleSentence: "Finn can conclude where the other shark went.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Ocean observers use more than one clue before deciding what an animal is doing.", explanation: "Comparing clues leads to stronger conclusions.")
                ],
                creativePrompt: "Write two sentences about why Finn thought the other shark had moved and where he went next.",
                creativeResponseType: .shortText,
                storyEnding: "Finn's quieter ledge came from two clear clues, not a lucky guess.",
                readingSkill: "Draw a conclusion using reef evidence",
                reflectionPrompt: "Which clue was stronger for you, and why?",
                hints: ["Look for where the fish fled", "Reread where Finn moved after his plan changed"],
                commonMistakes: ["Using only one clue and ignoring the other"],
                successCriteria: ["Supports a conclusion with two passage details"],
                learningObjectives: ["Draw a text-based conclusion about animal movement"],
                activityFingerprint: "ocean.confident.reef-clues.conclusion",
                characterNames: ["Finn"]
            )
        }
    }

    // MARK: - Space

    private static func spaceReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Nova Sees a Star",
                storyOpening: "Nova the star twinkles in the quiet night. Come look at the sky with her.",
                missionPrompt: "Notice what bright things Nova notices tonight.",
                readingPassage: "Nova sees a bright star in the night sky. She waves hello with a happy sparkle. The moon looks soft and close. A small rock floats nearby.",
                questions: [
                    mcq("What does Nova see?", ["A bright star", "A dark cloud only", "A nearby planet ring"], "A bright star", "Nova sees a bright star."),
                    mcq("What looks soft and close?", ["The moon", "A comet tail only", "A distant galaxy map"], "The moon", "The moon looks soft and close."),
                    mcq("What floats nearby?", ["A small rock", "A large crater", "A bright satellite"], "A small rock", "A small rock floats nearby.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "star", definition: "A bright light in the night sky.", exampleSentence: "Nova sees a bright star."),
                    VocabularyWord(word: "moon", definition: "The big light that circles Earth.", exampleSentence: "The moon looks soft and close.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Stars look like tiny lights because they are very far away.", explanation: "Space objects can look small even when they are huge.")
                ],
                creativePrompt: "Draw Nova waving at a bright star beside the moon.",
                creativeResponseType: .drawing,
                storyEnding: "Nova's night sky feels friendly, bright, and close enough to wave to.",
                readingSkill: "Find space details in short sentences",
                reflectionPrompt: "What space thing do you remember?",
                hints: ["Find the word star", "Look for the moon sentence"],
                commonMistakes: ["Picking Earth animals not in the story"],
                successCriteria: ["Names a detail from Nova's night sky"],
                learningObjectives: ["Identify concrete details in a short space story"],
                activityFingerprint: "space.k.star-moon.detail",
                characterNames: ["Nova"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Safe Landing Spots",
                storyOpening: "Nova unrolls a glow map beside a quiet moon rock for the crew.",
                missionPrompt: "Discover how Nova helps the crew get ready to land.",
                readingPassage: "Nova checks a glow map beside a quiet moon rock. She marks two safe landing spots. A small robot beeps beside her. Nova shares the map with the crew. They practice the path one more time.",
                questions: [
                    mcq("What does Nova mark on the map?", ["Two safe landing spots", "Two risky crater pits", "Two radio towers only"], "Two safe landing spots", "She marks two safe landing spots."),
                    mcq("What beeps beside her?", ["A small robot", "A large rover only", "A silent beacon"], "A small robot", "A small robot beeps beside her."),
                    mcq("What does the crew practice?", ["The path", "A random jump", "A skipped checklist"], "The path", "They practice the path one more time.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "landing", definition: "The place a craft comes down safely.", exampleSentence: "Nova marks safe landing spots."),
                    VocabularyWord(word: "crew", definition: "The team working together on a mission.", exampleSentence: "Nova shares the map with the crew.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Space crews plan safe landing spots before they move.", explanation: "Maps and practice help teams stay safe.")
                ],
                creativePrompt: "Draw Nova's glow map with two landing spots marked.",
                creativeResponseType: .drawing,
                storyEnding: "The crew feels ready because they practiced the path together one more time.",
                readingSkill: "Recall mission details from the passage",
                reflectionPrompt: "Why is practicing the path a smart idea?",
                hints: ["Find the landing spots sentence", "Look for the robot"],
                commonMistakes: ["Inventing map details not in the story"],
                successCriteria: ["Uses a map or crew detail from the story"],
                learningObjectives: ["Recall key details from a short mission passage"],
                activityFingerprint: "space.early.landing-map.detail",
                characterNames: ["Nova"]
            )
        case .growingReader:
            return ReadingPack(
                title: "A Safe Path on the Moon",
                storyOpening: "Nova looks at a Moon map. She needs to pick a safe path to walk.",
                missionPrompt: "Find out why Nova picks one Moon path instead of the other.",
                readingPassage: "Nova looks at a Moon map before her walk. Near a round crater, the ground looks smooth. In the dark shadows, the ground looks bumpy. A helper says Moon walkers pick paths that are safe to walk on. Nova compares the two paths and chooses the smooth ground by the crater.",
                questions: [
                    mcq("What is the main idea?", ["Moon walkers pick paths that are safe to walk on", "Moon walkers pick paths only for speed", "Moon walkers never look at the ground"], "Moon walkers pick paths that are safe to walk on", "The helper says Moon walkers pick safe paths."),
                    mcq("How did the ground near the crater look?", ["Smooth", "Full of deep cracks", "Covered in soft dust only"], "Smooth", "The ground near the crater looks smooth."),
                    mcq("Which path did Nova choose?", ["The smooth ground by the crater", "The bumpy ground in the dark shadows", "A path she never looked at"], "The smooth ground by the crater", "She chooses the smooth ground by the crater.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "crater", definition: "A round hole on the Moon's surface.", exampleSentence: "The ground near the crater looks smooth."),
                    VocabularyWord(word: "path", definition: "A way to walk from one place to another.", exampleSentence: "Nova picks a safe path on the Moon.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Moon walkers look for smooth, firm ground so they can walk safely.", explanation: "Bumpy or shadowy ground can hide rocks and holes.")
                ],
                creativePrompt: "Draw the two Moon paths. Circle the smooth one Nova chose.",
                creativeResponseType: .drawing,
                storyEnding: "Nova picked the smooth path by the crater.",
                readingSkill: "Identify the main idea in a Moon-path passage",
                reflectionPrompt: "Why is smooth ground a safer place to walk on the Moon?",
                hints: ["Find what the helper said", "Compare the smooth path and the bumpy path"],
                commonMistakes: ["Picking a reason that is not in the story"],
                successCriteria: ["States the main idea about picking a safe path"],
                learningObjectives: ["Identify the main idea of a short Moon-path passage"],
                activityFingerprint: "space.growing.moon-path.main-idea",
                characterNames: ["Nova"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Two Clues on the Moon Map",
                storyOpening: "Countdown is close, and Nova weighs two map clues that do not quite agree.",
                missionPrompt: "Decide which way Nova should go, and which clues tip the scale.",
                readingPassage: """
                Nova studied the Moon map like a mission planner. The crater rim looked smooth in the morning light, yet long shadows hinted at hidden ridges. Mission helpers reminded her that landing sites need firm ground and a clear radio path. Nova compared two clues: the robot's scan favored the rim, while older footprints pointed toward a darker basin. Using both details — the robot scan and older footprints — she decided the rim was safer for today's supply drop. That decision changed the crew's order of stops. Nova wrote two evidence notes before the countdown began.
                """,
                questions: [
                    mcq("What did Nova decide about today's supply drop?", ["The rim was safer", "The basin was the only choice", "They should skip landing today"], "The rim was safer", "She decided the rim was safer for today's supply drop."),
                    mcq("What did the robot's scan favor?", ["The crater rim", "The darker basin", "A skip of the landing"], "The crater rim", "The robot's scan favored the rim."),
                    mcq("Why did the decision matter?", ["It changed the crew's order of stops", "It erased the map", "It stopped the robot scan"], "It changed the crew's order of stops", "The decision changed the crew's order of stops.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "ridge", definition: "A raised line of rock or ground.", exampleSentence: "Shadows can hide a ridge."),
                    VocabularyWord(word: "evidence", definition: "Clues that support a choice.", exampleSentence: "Nova wrote two evidence notes.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Mission teams compare instruments and older trails before choosing a route.", explanation: "More than one clue makes a safer plan.")
                ],
                creativePrompt: "Write two sentences about why Nova chose the crater rim and how that changed the crew's stops.",
                creativeResponseType: .shortText,
                storyEnding: "Countdown starts with a plan backed by two clues, not a hurried guess.",
                readingSkill: "Support a mission decision with map evidence",
                reflectionPrompt: "Which clue would you trust more on a real Moon walk?",
                hints: ["Look at what the robot scan favored", "Reread how the crew's stops changed"],
                commonMistakes: ["Choosing without using both clues"],
                successCriteria: ["Supports Nova's decision with passage evidence"],
                learningObjectives: ["Explain a decision using two pieces of textual evidence"],
                activityFingerprint: "space.confident.map-clues.decision",
                characterNames: ["Nova"]
            )
        }
    }

    // MARK: - Dinosaurs

    private static func dinosaursReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Dottie's Green Leaf",
                storyOpening: "Dottie the dino is hungry for plants. Will you find a snack with her?",
                missionPrompt: "Check what Dottie finds, and how she shares her shady spot.",
                readingPassage: "Dottie finds a green leaf by the trail. She munches slowly under the warm sun. A friend stomps nearby. They share a shady spot together.",
                questions: [
                    mcq("What does Dottie find?", ["A green leaf", "A gray stone", "A dry twig only"], "A green leaf", "Dottie finds a green leaf."),
                    mcq("How does Dottie munch?", ["Slowly", "Without chewing", "Only at night"], "Slowly", "She munches slowly."),
                    mcq("Who stomps nearby?", ["A friend", "A stranger far away", "A sleeping hatchling only"], "A friend", "A friend stomps nearby.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "leaf", definition: "A flat green part of a plant.", exampleSentence: "Dottie finds a green leaf."),
                    VocabularyWord(word: "munch", definition: "To chew food loudly or happily.", exampleSentence: "Dottie will munch the leaf.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Some dinosaurs ate plants instead of meat.", explanation: "Plant-eating dinosaurs looked for leaves and ferns.")
                ],
                creativePrompt: "Draw Dottie munching a green leaf in the shade.",
                creativeResponseType: .drawing,
                storyEnding: "Dottie and her friend finish their plant snack side by side in the shade.",
                readingSkill: "Find details in a short dinosaur story",
                reflectionPrompt: "What did Dottie eat?",
                hints: ["Find the word leaf", "Look at how Dottie munches"],
                commonMistakes: ["Choosing meat when the story shows a leaf"],
                successCriteria: ["Names Dottie's plant snack from the story"],
                learningObjectives: ["Identify concrete details in a short dinosaur passage"],
                activityFingerprint: "dinos.k.leaf-munch.detail",
                characterNames: ["Dottie"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Sharing at the Watering Hole",
                storyOpening: "Cool water shines in the valley as Dottie walks down for a drink.",
                missionPrompt: "Discover how Dottie share at the watering hole.",
                readingPassage: "Dottie walks to a cool watering hole. She finds four fern leaves by the water. A friend arrives hungry. Dottie gives two leaves away. They sit and chew together.",
                questions: [
                    mcq("Where does Dottie walk?", ["To a cool watering hole", "To a dry hilltop", "To an empty cave"], "To a cool watering hole", "Dottie walks to a cool watering hole."),
                    mcq("How many fern leaves does she find?", ["Four", "One", "Ten"], "Four", "She finds four fern leaves."),
                    mcq("How many leaves does Dottie give away?", ["Two", "Four", "One"], "Two", "Dottie gives two leaves away.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "fern", definition: "A green plant with feathery leaves.", exampleSentence: "Dottie finds fern leaves."),
                    VocabularyWord(word: "share", definition: "To give part of what you have.", exampleSentence: "Dottie can share leaves.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Plant-eating dinosaurs needed places with water and green plants.", explanation: "Watering holes gathered animals that ate plants.")
                ],
                creativePrompt: "Draw Dottie and a friend chewing fern leaves by the water.",
                creativeResponseType: .drawing,
                storyEnding: "Two shared leaves turn a snack into a friendly moment by the water.",
                readingSkill: "Recall details and simple amounts from the story",
                reflectionPrompt: "Why was giving two leaves a kind choice?",
                hints: ["Count the leaves in the story", "Find the watering hole sentence"],
                commonMistakes: ["Mixing up how many leaves she found and gave"],
                successCriteria: ["Uses a number detail from the passage"],
                learningObjectives: ["Recall key details including quantities"],
                activityFingerprint: "dinos.early.watering-hole.share",
                characterNames: ["Dottie"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Tracks by the Stone Cove",
                storyOpening: "Morning mist hangs over the valley while Dottie gathers brushes for a fossil walk.",
                missionPrompt: "Figure out why Dottie decide the stone cove is the best place to dig next.",
                readingPassage: "Morning mist hung over the valley while Dottie gathered brushes and a notebook for a fossil walk. Wide footprints pressed into soft mud led toward a quiet cove of stones. A guide explained that some plant-eating dinosaurs rested near water in the morning. Dottie compared the muddy tracks with broken fern stems along the bank. The details helped her decide the cove was the best place to dig next — dinosaur clues near water can show a good place to dig.",
                questions: [
                    mcq("What is the main idea?", ["Dinosaur clues near water can show a good place to dig", "Dinosaur clues only appear on dry hilltops", "Footprints never form near water"], "Dinosaur clues near water can show a good place to dig", "Tracks and ferns near water guide Dottie's dig choice."),
                    mcq("What led toward the stone cove?", ["Wide footprints in soft mud", "A smooth empty stone", "A broken digging tool only"], "Wide footprints in soft mud", "Footprints led toward a quiet cove of stones."),
                    mcq("Where did some plant-eating dinosaurs rest in the morning?", ["Near water", "On a windy dry ridge", "Inside a deep dark cave only"], "Near water", "The guide said some rested near water in the morning.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "fossil", definition: "A preserved clue from an animal or plant of long ago.", exampleSentence: "Dottie looks for fossil clues."),
                    VocabularyWord(word: "track", definition: "A footprint left in mud or sand.", exampleSentence: "Wide tracks lead to the cove.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Fossil hunters look for tracks and plant clues near ancient water places.", explanation: "Watering areas often preserve footprints.")
                ],
                creativePrompt: "Draw the stone cove and one footprint clue from the story.",
                creativeResponseType: .drawing,
                storyEnding: "Dottie's next dig starts where the muddy tracks and ferns agree.",
                readingSkill: "Identify the main idea in a fossil-walk passage",
                reflectionPrompt: "Which clue would you follow first — tracks or fern stems?",
                hints: ["Reread the guide's sentence", "Find why Dottie chose the cove"],
                commonMistakes: ["Ignoring the water connection"],
                successCriteria: ["States the main idea about digging near water clues"],
                learningObjectives: ["Identify the main idea of a fossil observation passage"],
                activityFingerprint: "dinos.growing.fossil-cove.main-idea",
                characterNames: ["Dottie"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Two Clues in the Fossil Mud",
                storyOpening: "Dottie is at the fossil cove. She must decide whether the animal is still nearby.",
                missionPrompt: "Check what Dottie concludes from the muddy clues, and how that changes her plan.",
                readingPassage: """
                Dottie studied the fossil cove like a field scientist. Morning light made the mud look smooth, but shallow prints near the rocks suggested a larger animal had passed earlier. The guide said dinosaurs chose resting spots for safety and warmth. Dottie compared two clues: the footprints pointed inland, yet broken reeds floated from deeper water. Using both details — inland footprints and broken reeds from deeper water — she concluded that the animal had already moved on. That conclusion changed her digging plan. She wrote two evidence notes before choosing a safer observation spot farther from the bank.
                """,
                questions: [
                    mcq("What did Dottie conclude?", ["The animal had already moved on", "The animal was still resting nearby", "The animal never left any tracks"], "The animal had already moved on", "She concluded the animal had already moved on."),
                    mcq("Which way did the footprints point?", ["Inland", "Straight into deeper water", "Up a dry hillside"], "Inland", "The footprints pointed inland."),
                    mcq("How did the conclusion change her work?", ["She chose a safer observation spot farther from the bank", "She dug in the softest mud by the water", "She ignored both clues"], "She chose a safer observation spot farther from the bank", "She chose a safer spot farther from the bank.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "conclude", definition: "To decide after weighing clues.", exampleSentence: "Dottie can conclude the animal moved on."),
                    VocabularyWord(word: "observation", definition: "Careful watching to learn something.", exampleSentence: "She chose a safer observation spot.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Scientists compare footprints and plant clues before deciding what happened.", explanation: "One clue alone can be misleading.")
                ],
                creativePrompt: "Write two sentences about why Dottie thought the animal had moved on and where she observed next.",
                creativeResponseType: .shortText,
                storyEnding: "A safer dig begins once two muddy clues point the same way.",
                readingSkill: "Draw a conclusion from fossil-site evidence",
                reflectionPrompt: "Which clue felt stronger to you, and why?",
                hints: ["Look which way the footprints pointed", "Reread where Dottie chose to observe next"],
                commonMistakes: ["Using only one clue"],
                successCriteria: ["Supports a conclusion with two details"],
                learningObjectives: ["Draw a text-based conclusion from competing clues"],
                activityFingerprint: "dinos.confident.mud-clues.conclusion",
                characterNames: ["Dottie"]
            )
        }
    }

    // MARK: - Topic-specific math scenes

    private static func horsesMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Ponies",
                storyOpening: "Mia needs a careful count in the yard.",
                missionPrompt: "Count the ponies and compare the groups.",
                readingPassage: "Four ponies stand by the fence. Two foals nap near the hay. Mia points and counts out loud.",
                problems: [
                    mcq("Mia sees 2 ponies, then 2 more join. How many ponies in all?", ["3", "4", "5"], "4", "2 + 2 = 4."),
                    mcq("There are 2 foals on the left and 3 ponies on the right. Which side has more animals?", ["Right", "Left", "Same"], "Right", "3 is more than 2."),
                    mcq("Mia counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.")
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Mia can count the ponies.")],
                knowledgeFacts: [KnowledgeFact(fact: "Stable hands count animals to keep every pony safe.")],
                creativePrompt: "Draw 4 ponies by a fence.",
                storyEnding: "Mia's count matches the yard. Every pony is accounted for!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 foals on the left and 3 ponies on the right. Which side has more animals?",
                hints: ["Point to each pony", "Compare the two groups"],
                activityFingerprint: "horses.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Hay Bales for the Stall",
                storyOpening: "The ponies need hay before evening.",
                missionPrompt: "Add and subtract to finish the barn chores.",
                readingPassage: "Mia stacks hay bales and apple treats for three stalls. She checks how many she has and how many she still needs.",
                problems: [
                    mcq("Mia finds 6 hay bales. Then she finds 3 more. How many bales in all?", ["8", "9", "10"], "9", "6 + 3 = 9."),
                    mcq("A stall holds 10 hay bales. Mia moves 4 bales to another stall. How many bales are left?", ["5", "6", "7"], "6", "10 − 4 = 6."),
                    mcq("Mia wants 8 apple treats in the lesson jar. She has dropped in 5 so far. How many more treats does she still need?", ["2", "3", "4"], "3", "8 − 5 = 3.")
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total hay bales.")],
                knowledgeFacts: [KnowledgeFact(fact: "Horses eat hay, and caretakers measure feed so each horse gets enough.")],
                creativePrompt: "Draw 9 hay bales stacked for the stalls.",
                storyEnding: "The stalls are stocked because the numbers added up.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A stall holds 10 hay bales. Mia moves 4 bales to another stall. How many bales are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "horses.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Mia",
                pronoun: "she",
                items: [
                    ("brushes", "in the grooming bin"),
                    ("reins", "on the hook"),
                    ("saddle pads", "on the shelf")
                ],
                packItem: "hoof picks",
                purpose: "for riding lessons"
            )
            return MathScene(
                title: "Groups in the Tack Room",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Mia sets out 3 boxes of grooming brushes with 4 brushes in each box. How many brushes is that?", ["7", "12", "14"], "12", "3 × 4 = 12."),
                    mcq("A jump pole is 15 centimeters past a mark. Another is 9 centimeters past. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.")
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make barn supplies easier to check.")],
                creativePrompt: "Draw 3 boxes of grooming brushes with 4 brushes in each box.",
                storyEnding: "The tack room is ready for lessons.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Mia sets out 3 boxes of grooming brushes with 4 brushes in each box. How many brushes is that?",
                hints: ["Think about tens and ones", "Draw the equal groups"],
                activityFingerprint: "horses.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Pony Treats After Practice" : "Equal Shares of Treats",
                storyOpening: "Mia plans treats for a lesson group.",
                missionPrompt: multi ? "Solve each treat problem." : "Solve each treat problem carefully.",
                readingPassage: "Apple treats come in packs. Mia shares them fairly among riders after practice.",
                problems: [
                    mcq("Mia stacks 3 crates of apple treats with 8 treats in each crate. How many treats is that in all?", ["16", "24", "32"], "24", "3 × 8 = 24."),
                    mcq("Mia shares 18 carrot sticks among 3 ponies equally. How many does each pony get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6."),
                    mcq("One jump rail is 15 centimeters longer than a mark. Another is 9 centimeters longer. How much longer is the first than the second?", ["5", "6", "7"], "6", "15 − 9 = 6.")
                ],
                vocabularyWords: [VocabularyWord(word: "each", definition: "For every one group.", exampleSentence: "Each box holds the same number of treats.")],
                knowledgeFacts: [KnowledgeFact(fact: "Horses can eat apples as a treat, along with hay and grass.")],
                creativePrompt: "Draw the treat jars or crates.",
                storyEnding: "Every pony gets a fair share. Nice math, Mia!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water trough holds 4 buckets of water. Mia adds 2 more buckets. How many buckets are in the trough now?",
                hints: mathHints(level),
                activityFingerprint: "horses.math.advancing.treats"
            )
        }
    }

    private static func jungleMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Toucans",
                storyOpening: "Lina counts bright birds in the canopy.",
                missionPrompt: "Count the jungle animals you hear about.",
                readingPassage: "Four toucans sit in the canopy. Two frogs hide on leaves. Lina points and counts.",
                problems: [
                    mcq("Lina sees 2 toucans, then 2 more join. How many toucans in all?", ["3", "4", "5"], "4", "2 + 2 = 4."),
                    mcq("There are 2 frogs on the left and 3 ants on the right. Which side has more animals?", ["Right", "Left", "Same"], "Right", "3 is more than 2."),
                    mcq("Lina counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.")
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Lina can count the toucans.")],
                knowledgeFacts: [KnowledgeFact(fact: "Scientists count animals to learn about a habitat.")],
                creativePrompt: "Draw 4 toucans.",
                storyEnding: "Lina's canopy count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "What jungle animal did you count?",
                hints: ["Point to each toucan", "Compare the two groups"],
                activityFingerprint: "jungle.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Leaves for the Ant Trail",
                storyOpening: "Leafcutter ants carry green bits home.",
                missionPrompt: "Add and subtract to finish the ant-trail problems.",
                readingPassage: "Lina watches ants carry leaf pieces along a jungle path after rain.",
                problems: [
                    mcq("The ants carry 6 leaf pieces. Then they carry 3 more. How many pieces in all?", ["8", "9", "10"], "9", "6 + 3 = 9."),
                    mcq("A branch holds 10 berries. Birds eat 4. How many berries are left?", ["5", "6", "7"], "6", "10 − 4 = 6."),
                    mcq("Lina starts with 8 seed pods on the trail. Ants carry 5 away. How many seed pods are left?", ["2", "3", "4"], "3", "8 − 5 = 3.")
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total leaf pieces.")],
                knowledgeFacts: [KnowledgeFact(fact: "Ant colonies move many leaf pieces to grow food.")],
                creativePrompt: "Draw ants carrying 9 leaf pieces.",
                storyEnding: "The ant trail numbers add up!",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A branch holds 10 berries. Birds eat 4. How many berries are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "jungle.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Lina",
                pronoun: "she",
                items: [
                    ("seed pods", "in the study tray"),
                    ("berries", "in the snack dish"),
                    ("fruit samples", "on the canopy table")
                ],
                packItem: "seed pods",
                purpose: "for study"
            )
            return MathScene(
                title: "Groups in the Canopy",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Lina fills 3 trays of berries with 4 berries in each tray. How many berries did she gather?", ["7", "12", "14"], "12", "3 × 4 = 12."),
                    mcq("A vine is 15 centimeters long. Another is 9 centimeters long. How much longer is the first vine?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.")
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten seed pods.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups help scientists organize samples.")],
                creativePrompt: "Draw 3 trays of berries with 4 berries in each tray.",
                storyEnding: "The canopy samples are neatly grouped.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Lina fills 3 trays of berries with 4 berries in each tray. How many berries did she gather?",
                hints: ["Think about tens and ones", "Count each trip"],
                activityFingerprint: "jungle.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Rainforest Garden Seeds" : "Equal Shares of Seeds",
                storyOpening: "Lina prepares seed packs for a rainforest garden plot.",
                missionPrompt: multi ? "Solve each rainforest problem." : "Solve each seed problem carefully.",
                readingPassage: "Seed packs help growers plant trees that love warm, wet weather.",
                problems: [
                    mcq("Lina packs 3 boxes of seeds with 8 seeds in each box. How many seeds is that in all?", ["16", "24", "32"], "24", "3 × 8 = 24."),
                    mcq("Lina shares 18 seed pods among 3 friends equally. How many does each friend get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6."),
                    mcq("A vine is 15 centimeters long. Another is 9. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.")
                ],
                vocabularyWords: [VocabularyWord(word: "share", definition: "To split into equal parts.", exampleSentence: "Share the seeds equally.")],
                knowledgeFacts: [KnowledgeFact(fact: "Rainforests get heavy rain, so many trees grow large leaves that shed water.")],
                creativePrompt: "Draw the seed boxes and one sorting step.",
                storyEnding: "The rainforest garden supplies are ready!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A rain gauge holds 4 cups of rainwater. Lina adds 2 more cups. How many cups are there now?",
                hints: mathHints(level),
                activityFingerprint: "jungle.math.advancing.seeds"
            )
        }
    }

    private static func oceanMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Fish",
                storyOpening: "Finn counts ocean friends near the reef.",
                missionPrompt: "Count the fish and compare the groups.",
                readingPassage: "Four fish dart by the coral. Two shells rest on the sand. Finn points and counts.",
                problems: [
                    mcq("Finn sees 2 fish, then 2 more join. How many fish in all?", ["3", "4", "5"], "4", "2 + 2 = 4."),
                    mcq("There are 2 shells on the left and 3 fish on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2."),
                    mcq("Finn counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.")
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Finn can count the fish.")],
                knowledgeFacts: [KnowledgeFact(fact: "Ocean watchers count animals to learn about the reef.")],
                creativePrompt: "Draw 4 fish by coral.",
                storyEnding: "Finn's reef count is done!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "What ocean thing did you count?",
                hints: ["Point to each fish", "Compare the two groups"],
                activityFingerprint: "ocean.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Shells on the Sand",
                storyOpening: "Finn sorts shells after a gentle tide.",
                missionPrompt: "Add and subtract to finish the beach jobs.",
                readingPassage: "Finn sorts clam shells and sand dollars into piles on the sand. He checks each total before the next tide.",
                problems: [
                    mcq("Finn finds 6 clam shells. Then he finds 3 more. How many clam shells in all?", ["8", "9", "10"], "9", "6 + 3 = 9."),
                    mcq("A bucket holds 10 sand dollars. Finn shares 4 with friends. How many sand dollars are left?", ["5", "6", "7"], "6", "10 − 4 = 6."),
                    mcq("Finn finds 8 shells on the tide line. A wave washes 5 shells away. How many shells are left?", ["2", "3", "4"], "3", "8 − 5 = 3.")
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total shells.")],
                knowledgeFacts: [KnowledgeFact(fact: "Seashells on a beach can show which ocean animals live nearby.")],
                creativePrompt: "Draw 9 shells on the sand.",
                storyEnding: "The shell count matches the tide line.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A bucket holds 10 sand dollars. Finn shares 4 with friends. How many sand dollars are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "ocean.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Finn",
                pronoun: "he",
                items: [
                    ("shells", "in the tide pool tray"),
                    ("coral", "in the display dish"),
                    ("sand dollars", "on the sand")
                ],
                packItem: "shells",
                groupSize: 10,
                purpose: "for the reef display"
            )
            return MathScene(
                title: "Groups by the Reef",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Finn fills 3 trays of coral pieces. Each tray has 4 pieces. How many pieces is that?", ["7", "12", "14"], "12", "3 × 4 = 12."),
                    mcq("A kelp strand is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.")
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten shell samples.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make reef samples easier to study.")],
                creativePrompt: "Draw 3 trays with 4 coral pieces in each tray.",
                storyEnding: "The reef display is ready for visitors.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Finn fills 3 trays of coral pieces. Each tray has 4 pieces. How many pieces is that?",
                hints: ["Think about tens and ones", "Count the packs"],
                activityFingerprint: "ocean.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Reef Field Trip" : "Equal Shares of Kelp Strips",
                storyOpening: "Finn plans kelp samples for a reef field trip.",
                missionPrompt: multi ? "Solve each ocean problem." : "Solve each ocean problem carefully.",
                readingPassage: "Kelp strips and shell samples are shared after the reef walk.",
                problems: [
                    mcq("Finn packs 3 boxes with 8 shell samples in each box. How many shell samples in all?", ["16", "24", "32"], "24", "3 × 8 = 24."),
                    mcq("Finn shares 18 kelp strips among 3 friends equally. How many does each friend get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6."),
                    mcq("One kelp strand is 15 centimeters long. Another is 9. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.")
                ],
                vocabularyWords: [VocabularyWord(word: "equal", definition: "The same number in each group.", exampleSentence: "Equal groups of kelp strips have the same count.")],
                knowledgeFacts: [KnowledgeFact(fact: "Kelp is a large seaweed that grows in cold ocean water.")],
                creativePrompt: "Draw the kelp trays or sample boxes.",
                storyEnding: "Everyone gets a fair ocean share!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A tide pool tank holds 4 cups of water. Finn adds 2 more cups. How many cups are in the tank now?",
                hints: mathHints(level),
                activityFingerprint: "ocean.math.advancing.supplies"
            )
        }
    }

    private static func spaceMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Stars",
                storyOpening: "Nova counts lights on the glow map.",
                missionPrompt: "Count and compare space numbers.",
                readingPassage: "Four bright stars shine on Nova's map. Two moon rocks sit nearby.",
                problems: [
                    mcq("Nova sees 2 stars, then 2 more join. How many stars in all?", ["3", "4", "5"], "4", "2 + 2 = 4."),
                    mcq("There are 2 rocks on the left and 3 stars on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2."),
                    mcq("Nova counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.")
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Nova can count the stars.")],
                knowledgeFacts: [KnowledgeFact(fact: "Astronauts count tools and map marks carefully.")],
                creativePrompt: "Draw 4 stars.",
                storyEnding: "Nova's star count matches the map!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "What did you count in space today?",
                hints: ["Point to each star", "Compare the groups"],
                activityFingerprint: "space.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Glow Markers for the Crew",
                storyOpening: "Nova checks glow markers and tool kits before practice.",
                missionPrompt: "Add and subtract to finish the supply jobs.",
                readingPassage: "Nova counts glow markers and tool kits on the shelf. She checks how many the crew still needs.",
                problems: [
                    mcq("Nova finds 6 glow markers. Then she finds 3 more. How many markers in all?", ["8", "9", "10"], "9", "6 + 3 = 9."),
                    mcq("A shelf holds 10 tool kits. Nova sends 4 to another dome. How many kits are left?", ["5", "6", "7"], "6", "10 − 4 = 6."),
                    mcq("Nova's checklist shows 8 moon markers. She crosses off 5 used markers. How many markers are left on the list?", ["2", "3", "4"], "3", "8 − 5 = 3.")
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total markers.")],
                knowledgeFacts: [KnowledgeFact(fact: "Crews check supply math before missions.")],
                creativePrompt: "Draw 9 glow markers for the crew.",
                storyEnding: "Supplies are ready for training.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "Which supply problem was hardest?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "space.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Nova",
                pronoun: "she",
                items: [
                    ("map markers", "in the map bin"),
                    ("moon badges", "in the badge tray"),
                    ("tool clips", "on the supply shelf")
                ],
                packItem: "moon badges",
                purpose: "before countdown"
            )
            return MathScene(
                title: "Groups on the Glow Map",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Nova's glow map uses 3 rows of badges with 4 badges in each row. How many badges are on the map?", ["7", "12", "14"], "12", "3 × 4 = 12."),
                    mcq("An antenna is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.")
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten moon badges.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups keep mission gear organized.")],
                creativePrompt: "Draw 3 rows of badges with 4 badges in each row.",
                storyEnding: "The glow map table is ready.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Nova's glow map uses 3 rows of badges with 4 badges in each row. How many badges are on the map?",
                hints: ["Think about tens and ones", "Count the panels"],
                activityFingerprint: "space.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Crew Practice" : "Equal Shares of Glow Markers",
                storyOpening: "Nova plans glow markers for the training crew.",
                missionPrompt: multi ? "Solve each space problem." : "Solve each space problem carefully.",
                readingPassage: "Glow markers and battery cells are shared after practice.",
                problems: [
                    mcq("Nova charges 3 battery trays with 8 cells in each tray. How many cells in all?", ["16", "24", "32"], "24", "3 × 8 = 24."),
                    mcq("Nova shares 18 glow markers among 3 friends equally. How many does each friend get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6."),
                    mcq("One antenna is 15 centimeters long. Another is 9. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.")
                ],
                vocabularyWords: [VocabularyWord(word: "times", definition: "Groups of the same size counted that many times.", exampleSentence: "3 times 8 is 24 cells.")],
                knowledgeFacts: [KnowledgeFact(fact: "Astronauts use checklists so they do not lose tools in space.")],
                creativePrompt: "Draw the marker boxes or battery trays.",
                storyEnding: "The crew shares fairly before countdown!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A battery tray holds 4 cells. Nova adds 2 more cells. How many cells are in the tray now?",
                hints: mathHints(level),
                activityFingerprint: "space.math.advancing.supplies"
            )
        }
    }

    private static func dinosaursMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Dinos",
                storyOpening: "Dottie counts friends near the watering hole.",
                missionPrompt: "Count the dinos and compare the groups.",
                readingPassage: "Four dinos rest by the bank. Two hatchlings nap in the ferns. Dottie points and counts.",
                problems: [
                    mcq("Dottie sees 2 dinos, then 2 more join. How many dinos in all?", ["3", "4", "5"], "4", "2 + 2 = 4."),
                    mcq("There are 2 hatchlings on the left and 3 dinos on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2."),
                    mcq("Dottie counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.")
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Dottie can count the dinos.")],
                knowledgeFacts: [KnowledgeFact(fact: "Paleontology helpers count tracks and friends carefully.")],
                creativePrompt: "Draw 4 dinos by the bank.",
                storyEnding: "Dottie's valley count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "What did you count in the valley?",
                hints: ["Point to each dino", "Compare the two groups"],
                activityFingerprint: "dinos.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Ferns by the Water",
                storyOpening: "Dottie gathers fern piles for a snack share.",
                missionPrompt: "Add and subtract to finish the valley jobs.",
                readingPassage: "Dottie sorts fern piles and leaf snacks by the water. She checks each total before the group eats.",
                problems: [
                    mcq("Dottie finds 6 fern piles. Then she finds 3 more. How many piles in all?", ["8", "9", "10"], "9", "6 + 3 = 9."),
                    mcq("A tray holds 10 leaf snacks. Dottie shares 4 with friends. How many leaf snacks are left?", ["5", "6", "7"], "6", "10 − 4 = 6."),
                    mcq("Dottie gathers 8 leaf snacks for the share. A hatchling brings only 5. How many more snacks did Dottie gather?", ["2", "3", "4"], "3", "8 − 5 = 3.")
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total fern piles.")],
                knowledgeFacts: [KnowledgeFact(fact: "Sharing plant snacks needs careful counting.")],
                creativePrompt: "Draw 9 fern piles by the water.",
                storyEnding: "The snack share numbers add up!",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "Which valley problem was hardest?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "dinos.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Dottie",
                pronoun: "she",
                items: [
                    ("fossil tags", "in the tag box"),
                    ("leaf pads", "in the snack basket"),
                    ("bone chips", "on the dig tray")
                ],
                packItem: "fossil tags",
                purpose: "at the cove"
            )
            return MathScene(
                title: "Groups at the Dig",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("At the dig, Dottie sets out 3 baskets of leaf pads with 4 pads in each basket. How many leaf pads are there?", ["7", "12", "14"], "12", "3 × 4 = 12."),
                    mcq("A fern stem is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.")
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten fossil tags.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups keep dig finds organized.")],
                creativePrompt: "Draw 3 baskets of leaf pads with 4 pads in each basket.",
                storyEnding: "The dig tray is ready.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "At the dig, Dottie sets out 3 baskets of leaf pads with 4 pads in each basket. How many leaf pads are there?",
                hints: ["Think about tens and ones", "Count the baskets"],
                activityFingerprint: "dinos.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "After the Fossil Walk" : "Equal Shares of Fern Tips",
                storyOpening: "Dottie plans snacks after the fossil walk.",
                missionPrompt: multi ? "Solve each dig problem." : "Solve each dig problem carefully.",
                readingPassage: "Leaf snacks and fern tips are shared after the cove visit.",
                problems: [
                    mcq("Dottie packs 3 boxes with 8 leaf snacks in each box. How many snacks in all?", ["16", "24", "32"], "24", "3 × 8 = 24."),
                    mcq("Dottie shares 18 fern tips among 3 friends equally. How many does each friend get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6."),
                    mcq("One fern stem is 15 centimeters long. Another is 9. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.")
                ],
                vocabularyWords: [VocabularyWord(word: "split", definition: "To divide into parts.", exampleSentence: "Split the snacks into equal shares.")],
                knowledgeFacts: [KnowledgeFact(fact: "Fossils are traces of ancient plants and animals preserved in rock.")],
                creativePrompt: "Draw the lunch bags or snack boxes and one munching step.",
                storyEnding: "Every friend gets a fair fossil-walk share!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A watering-hole bucket holds 4 scoops of water. Dottie adds 2 more scoops. How many scoops are there now?",
                hints: mathHints(level),
                activityFingerprint: "dinos.math.advancing.supplies"
            )
        }
    }

    // MARK: - Helpers

    private static func mcq(
        _ prompt: String,
        _ choices: [String],
        _ answer: String,
        _ explanation: String,
        subject: QuestionSubject = .reading
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

    private static func mathMCQ(
        _ prompt: String,
        _ choices: [String],
        _ answer: String,
        _ explanation: String
    ) -> LessonQuestion {
        mcq(prompt, choices, answer, explanation, subject: .math)
    }

    /// Child-facing copy for equal-group math: kids match named items, then solve a story-sized group problem.
    /// The Read Along only names where items go. Grouping numbers live on the math question so younger
    /// sessions can drop equal-groups math without leaving an unused "packs 20 into groups of 10" sentence.
    static func groupingSortCopy(
        character: String,
        pronoun: String,
        items: [(item: String, group: String)],
        packItem: String,
        packCount: Int? = nil,
        groupSize: Int? = nil,
        purpose: String
    ) -> (
        opening: String,
        mission: String,
        passage: String,
        groupSize: Int,
        packCount: Int,
        groupingQuestion: LessonQuestion
    ) {
        let size = groupSize ?? groupingSize(character: character, packItem: packItem, packCount: packCount ?? 20)
        let count = packCount ?? groupingPackCount(character: character, packItem: packItem, groupSize: size)
        let trio = Array(items.prefix(3))
        let names = trio.map(\.item)
        let itemList: String
        if names.count == 3 {
            itemList = "\(names[0]), \(names[1]), and \(names[2])"
        } else {
            itemList = names.joined(separator: " and ")
        }
        let put = pronoun == "they" ? "put" : "puts"
        let be = pronoun == "they" ? "are" : "is"
        let they = pronoun.capitalized

        var sentences: [String] = []
        if let first = trio.first {
            sentences.append("\(character) \(put) the \(first.item) \(first.group).")
        }
        for extra in trio.dropFirst() {
            sentences.append("\(they) \(put) the \(extra.item) \(extra.group).")
        }
        sentences.append("Now \(pronoun) \(be) ready \(purpose).")

        return (
            opening: "\(character) is going to sort \(itemList) into groups.",
            mission: "Match the \(itemList) to their groups. Then find how many groups of \(size) \(packItem) \(character) can make.",
            passage: sentences.joined(separator: " "),
            groupSize: size,
            packCount: count,
            groupingQuestion: groupingMathQuestion(
                character: character,
                pronoun: pronoun,
                packItem: packItem,
                packCount: count,
                groupSize: size
            )
        )
    }

    /// Self-contained grouping math. Numbers live here, not in the Read Along.
    static func groupingMathQuestion(
        character: String,
        pronoun: String,
        packItem: String,
        packCount: Int,
        groupSize: Int
    ) -> LessonQuestion {
        let size = max(groupSize, 1)
        let groups = max(1, packCount / size)
        var nums = [groups]
        for delta in [-1, 1, 2, -2, 3] {
            let value = groups + delta
            if value >= 1, !nums.contains(value) {
                nums.append(value)
            }
            if nums.count == 3 { break }
        }
        let choices = nums.sorted().map(String.init)
        let actor = pronoun == "they" ? character : pronoun.capitalized
        let put = pronoun == "they" ? "put" : "puts"
        return mcq(
            "\(character) has \(packCount) \(packItem). \(actor) \(put) them in groups of \(size). How many groups is that?",
            choices,
            "\(groups)",
            "\(packCount) ÷ \(size) = \(groups).",
            subject: .math
        )
    }

    /// Stable per-story group size so grouping lessons are not all "groups of 10".
    static func groupingSize(character: String, packItem: String, packCount: Int) -> Int {
        let preferred = [5, 10, 4]
        let sizes = preferred.filter { packCount % $0 == 0 }
        let pool = sizes.isEmpty ? [10] : sizes
        var hash: UInt64 = 2_166_132_661
        for byte in (character.lowercased() + "#" + packItem.lowercased()).utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 16_777_619
        }
        return pool[Int(hash % UInt64(pool.count))]
    }

    /// Stable per-story total so grouping math is not always 20 ÷ 10.
    static func groupingPackCount(character: String, packItem: String, groupSize: Int) -> Int {
        let size = max(groupSize, 1)
        let groupCounts = [2, 3, 4]
        var hash: UInt64 = 7_654_321
        for byte in (character.lowercased() + "@" + packItem.lowercased()).utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 16_777_619
        }
        return groupCounts[Int(hash % UInt64(groupCounts.count))] * size
    }

    private static func mathHints(_ level: MathLevel) -> [String] {
        switch level {
        case .emerging: return ["Count on your fingers", "Point to each object"]
        case .developing: return ["Write the numbers", "Decide add or subtract"]
        case .secure: return ["Think about tens and ones", "Draw equal groups"]
        case .advancing: return ["Read the numbers carefully", "Choose add, subtract, multiply, or divide"]
        }
    }
}
