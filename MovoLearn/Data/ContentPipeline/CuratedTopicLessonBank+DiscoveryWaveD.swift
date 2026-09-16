import Foundation

extension CuratedTopicLessonBank {

    // MARK: - Wave D Discovery lookup

    /// Discovery science packs for Wave D topics (22 topics × 4 reading levels).
    /// Returns nil for topics authored in Wave A (`CuratedTopicLessonBank+Discovery.swift`).
    static func waveDDiscoveryPack(topic: Topic, level: ReadingLevel) -> DiscoveryPack? {
        switch topic {
        case .oceanAnimals: return oceanAnimalsDiscovery(level)
        case .planets: return planetsDiscovery(level)
        case .rockets: return rocketsDiscovery(level)
        case .soccer: return soccerDiscovery(level)
        case .basketball: return basketballDiscovery(level)
        case .cats: return catsDiscovery(level)
        case .princesses: return princessesDiscovery(level)
        case .castles: return castlesDiscovery(level)
        case .fairies: return fairiesDiscovery(level)
        case .airplanes: return airplanesDiscovery(level)
        case .trains: return trainsDiscovery(level)
        case .cars: return carsDiscovery(level)
        case .superheroes: return superheroesDiscovery(level)
        case .art: return artDiscovery(level)
        case .music: return musicDiscovery(level)
        case .cooking: return cookingDiscovery(level)
        case .nature: return natureDiscovery(level)
        case .bugs: return bugsDiscovery(level)
        case .weather: return weatherDiscovery(level)
        case .farmAnimals: return farmAnimalsDiscovery(level)
        case .zooAnimals: return zooAnimalsDiscovery(level)
        case .pirates: return piratesDiscovery(level)
        default: return nil
        }
    }

    // MARK: - Ocean Animals Discovery

    private static func oceanAnimalsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Tide Pool Homes",
                storyOpening: "Willa the whale nudges you toward the shore. When the ocean pulls back, little pools of water stay trapped like secret bathtubs in the rocks.",
                missionPrompt: "Hunt for one true science fact about tide pools in the notes.",
                readingPassage: "A tide pool is a small pool of ocean water. Rocks hold the water when the tide goes out. Tiny crabs can hide there between wet stones. Cool water keeps the pool wet even in the sun.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what is a tide pool?",
                        ["A small pool of ocean water", "A deep open-ocean trench", "A freshwater pond on a hill"],
                        "A small pool of ocean water",
                        "When the tide goes out, seawater stays trapped among rocks and forms a small pool."
                    ),
                    discoveryMCQ(
                        "What holds the water when the tide goes out?",
                        ["Rocks", "Loose sand alone", "Open water with no rim"],
                        "Rocks",
                        "Hard rock edges act like a bowl and trap seawater after the tide drops."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "tide pool",
                        definition: "A small pool of ocean water left among rocks.",
                        exampleSentence: "A crab hides in a tide pool."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Tide pools hold ocean water among rocks when the tide goes out.",
                        explanation: "Rocks trap seawater and make tiny wet homes."
                    ),
                    KnowledgeFact(
                        fact: "Tiny crabs can hide in tide pools.",
                        explanation: "Cool water and rocks give small animals shelter."
                    )
                ],
                creativePrompt: "Draw a tide pool with a rock edge and one tiny crab.",
                storyEnding: "Willa the whale smiles. You logged a real tide-pool fact. Great science work!",
                readingSkill: "Use a science note to name what a tide pool is",
                reflectionPrompt: "Name one thing that helps make a tide pool.",
                hints: [
                    "Look for the words tide pool",
                    "Find the sentence about rocks"
                ],
                commonMistakes: [
                    "Choosing a place that is not wet ocean water"
                ],
                successCriteria: [
                    "Names a tide-pool detail from the notes",
                    "Uses a stated rock fact"
                ],
                learningObjectives: [
                    "Identify that tide pools are small pools of ocean water among rocks",
                    "fp:discovery.Ocean Animals.beginner"
                ],
                activityFingerprint: "ocean-animals.discovery.beginner.tide-pools"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Dolphins Need Air",
                storyOpening: "Willa the whale surfaces beside you with a soft splash. Come wonder with her—how do dolphins breathe?",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "Dolphins are mammals that live in the ocean. They must breathe air at the surface. A dolphin rises, takes a breath, and can dive again. Dolphins do not use gills like fish. Fresh air keeps a dolphin alive under the waves.",
                questions: [
                    discoveryMCQ(
                        "What kind of animals are dolphins?",
                        ["Mammals", "Fish with gills", "Birds with feathers"],
                        "Mammals",
                        "Dolphins are mammals: they breathe air and cannot pull oxygen from water with gills."
                    ),
                    discoveryMCQ(
                        "Where must dolphins breathe air?",
                        ["At the surface", "Only through gills underwater", "Only from the ocean floor"],
                        "At the surface",
                        "A dolphin must rise to the top of the water to take a breath of air."
                    ),
                    discoveryMCQ(
                        "What do dolphins not use like fish?",
                        ["Gills", "Lungs for air", "A blowhole at the surface"],
                        "Gills",
                        "Fish take oxygen from water with gills, but dolphins use lungs and must breathe air."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "mammal",
                        definition: "A warm animal that breathes air and often has hair or fur.",
                        exampleSentence: "A dolphin is a mammal that breathes air."
                    ),
                    VocabularyWord(
                        word: "surface",
                        definition: "The top of the water.",
                        exampleSentence: "Dolphins breathe at the surface."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Dolphins are mammals that breathe air at the ocean surface.",
                        explanation: "They rise to breathe, then can dive again."
                    ),
                    KnowledgeFact(
                        fact: "Dolphins do not use gills like fish.",
                        explanation: "Air, not water through gills, keeps them alive."
                    )
                ],
                creativePrompt: "Draw a dolphin rising to breathe, and label the surface.",
                storyEnding: "Willa the whale nods. You used evidence about dolphin breathing. Careful science reading!",
                readingSkill: "Use evidence to explain how dolphins breathe",
                reflectionPrompt: "Why must a dolphin come to the surface?",
                hints: [
                    "Find the mammal sentence",
                    "Look for gills"
                ],
                commonMistakes: [
                    "Thinking dolphins breathe like fish with gills"
                ],
                successCriteria: [
                    "States that dolphins breathe air",
                    "Cites a surface detail"
                ],
                learningObjectives: [
                    "Explain that dolphins are air-breathing mammals",
                    "fp:discovery.Ocean Animals.earlyReader"
                ],
                activityFingerprint: "ocean-animals.discovery.early.dolphin-air"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Octopus Camouflage",
                storyOpening: "Willa the whale glides past a reef crack and invites you closer. Watch carefully—an octopus can hide in plain sight!",
                missionPrompt: "Find the main idea about how an octopus stays safe. Use details from the notes.",
                readingPassage: "An octopus can change the color and texture of its skin. Matching the reef helps it hide from hunters. The same camouflage can help it sneak toward crabs. Soft arms feel ahead as it moves into a narrow crack. The main idea is clear: camouflage and careful movement help an octopus stay safe on a busy reef.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Camouflage and careful movement help an octopus stay safe", "An octopus stays safe only by swimming fast", "An octopus stays safe only by living in deep open water"],
                        "Camouflage and careful movement help an octopus stay safe",
                        "Blending into the reef and moving carefully into cracks both help an octopus avoid hunters."
                    ),
                    discoveryMCQ(
                        "What can an octopus change on its skin?",
                        ["Color and texture", "Only its eye color", "Only the length of its arms"],
                        "Color and texture",
                        "Changing both color and how bumpy the skin feels helps the octopus match rocks and coral."
                    ),
                    discoveryMCQ(
                        "How else does camouflage help an octopus?",
                        ["It can sneak toward crabs", "It can breathe air on dry land", "It can swim faster than every fish"],
                        "It can sneak toward crabs",
                        "Matching the reef hides the octopus so it can creep close to crabs it wants to catch."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "camouflage",
                        definition: "Colors or patterns that help an animal blend in.",
                        exampleSentence: "Octopus camouflage matches the reef."
                    ),
                    VocabularyWord(
                        word: "texture",
                        definition: "How a surface feels, such as smooth or bumpy.",
                        exampleSentence: "Octopus skin can change texture."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Octopuses can change skin color and texture to blend into the reef.",
                        explanation: "Camouflage helps them hide and hunt."
                    ),
                    KnowledgeFact(
                        fact: "Careful movement into cracks also helps an octopus stay safe.",
                        explanation: "Hiding spots and blending colors work together."
                    )
                ],
                creativePrompt: "Draw an octopus that matches nearby seaweed, and label camouflage.",
                storyEnding: "Willa the whale glows with pride. You found the camouflage main idea like a careful reef scientist.",
                readingSkill: "Identify the main idea in octopus camouflage notes",
                reflectionPrompt: "Which octopus clue best explains how it stays safe?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find color and texture"
                ],
                commonMistakes: [
                    "Missing the camouflage main idea"
                ],
                successCriteria: [
                    "States the safety main idea",
                    "Cites one supporting detail"
                ],
                learningObjectives: [
                    "Explain how octopus camouflage supports safety on a reef",
                    "fp:discovery.Ocean Animals.growingReader"
                ],
                activityFingerprint: "ocean-animals.discovery.growing.octopus-camouflage"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Jobs on One Reef",
                storyOpening: "Willa the whale circles a busy reef and asks you to notice the neighbors. Together you investigate how reef animals share one home.",
                missionPrompt: "Use evidence from the notes. Explain why many ocean animals can live on the same reef.",
                readingPassage: "A coral reef can work like a busy neighborhood with many jobs. Parrotfish scrape algae from coral so the reef is not smothered. Cleaner shrimp nibble tiny pests off larger fish that visit their station. Sea turtles may feed on nearby seagrass and rest in the area. Animals that use different foods and spaces compete less for one resource. When one neighbor disappears, the whole balance can tip. Diversity of jobs helps one reef support many ocean animals.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about why many animals share one reef?",
                        ["They use different foods and spaces", "They all eat only the same coral rock", "They all need the exact same hiding spot"],
                        "They use different foods and spaces",
                        "When neighbors eat different foods and use different spaces, they compete less and can share one reef."
                    ),
                    discoveryMCQ(
                        "How do parrotfish help the reef?",
                        ["They scrape algae so coral is not smothered", "They nibble pests off visiting fish", "They feed only on nearby seagrass"],
                        "They scrape algae so coral is not smothered",
                        "Too much algae can cover coral; parrotfish scrape it away so the reef stays healthy."
                    ),
                    discoveryMCQ(
                        "What do cleaner shrimp do?",
                        ["Nibble tiny pests off larger fish", "Scrape algae from coral rocks", "Feed only on seagrass beds"],
                        "Nibble tiny pests off larger fish",
                        "Cleaner shrimp pick tiny pests off larger fish that visit their station. That is a different reef job than parrotfish or turtles."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "balance",
                        definition: "A steady mix where parts work well together.",
                        exampleSentence: "Reef balance depends on many animal neighbors."
                    ),
                    VocabularyWord(
                        word: "resource",
                        definition: "Something living things need, such as food or space.",
                        exampleSentence: "Animals share different resources on a reef."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Reef animals can share one home by using different foods and spaces.",
                        explanation: "Diverse roles help keep coral reefs in balance."
                    ),
                    KnowledgeFact(
                        fact: "Parrotfish help coral by scraping algae.",
                        explanation: "Too much algae can smother a reef."
                    ),
                    KnowledgeFact(
                        fact: "Cleaner shrimp remove tiny pests from larger fish.",
                        explanation: "Different jobs support reef neighbors."
                    )
                ],
                creativePrompt: "Write three sentences naming two reef neighbors and how their jobs differ.",
                storyEnding: "Willa the whale swims beside you. You connected reef jobs and balance like a careful investigator.",
                readingSkill: "Infer ecosystem roles from reef neighbor evidence",
                reflectionPrompt: "Which reef job from the notes would you want to study first?",
                hints: [
                    "Compare parrotfish with cleaner shrimp",
                    "Reread the idea about foods and spaces"
                ],
                commonMistakes: [
                    "Treating the reef as one animal with one job"
                ],
                successCriteria: [
                    "Explains shared reef life using passage evidence",
                    "Links jobs to balance"
                ],
                learningObjectives: [
                    "Infer why diverse ocean animals can share a reef",
                    "fp:discovery.Ocean Animals.confidentReader"
                ],
                activityFingerprint: "ocean-animals.discovery.confident.reef-jobs"
            )
        }
    }


    // MARK: - Planets Discovery

    private static func planetsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Earth Is Our Home",
                storyOpening: "Nova the star twinkles beside you in the night sky. Look up—our whole world is one bright blue ball spinning in space.",
                missionPrompt: "Spot one true fact about Earth from the science notes.",
                readingPassage: "Earth is the planet where we live. It has land, water, and air. The Sun gives Earth light and warmth. Without that warmth, oceans would freeze solid. Earth is our home in space.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, which planet is our home?",
                        ["Earth", "The Moon", "The Sun"],
                        "Earth",
                        "Earth is the planet with land, water, and air where people live."
                    ),
                    discoveryMCQ(
                        "What does the Sun give Earth?",
                        ["Light and warmth", "Only cold darkness", "Only empty space dust"],
                        "Light and warmth",
                        "Sunlight reaches Earth and warms it so living things can survive."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "planet",
                        definition: "A large world that moves around a star.",
                        exampleSentence: "Earth is the planet where we live."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Earth is the planet where people live.",
                        explanation: "It has land, water, and air."
                    ),
                    KnowledgeFact(
                        fact: "The Sun gives Earth light and warmth.",
                        explanation: "Without the Sun, Earth would be dark and cold."
                    )
                ],
                creativePrompt: "Draw Earth with land, water, and sunlight.",
                storyEnding: "Nova the star sparkles. You logged a real Earth fact. Great science work!",
                readingSkill: "Use a science note to name Earth as our home planet",
                reflectionPrompt: "Name one thing Earth has that helps living things.",
                hints: [
                    "Look for the word Earth",
                    "Find the Sun sentence"
                ],
                commonMistakes: [
                    "Choosing a place that is not Earth"
                ],
                successCriteria: [
                    "Names Earth as home",
                    "Uses a Sun fact"
                ],
                learningObjectives: [
                    "Identify Earth as the planet where we live",
                    "fp:discovery.Planets.beginner"
                ],
                activityFingerprint: "planets.discovery.beginner.earth-home"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Rocky Worlds and Gas Giants",
                storyOpening: "Nova the star glows warmly and invites you to compare worlds. Some planets are rocky, and some are giant balls of gas!",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "Some planets are rocky worlds with solid ground. Earth is a rocky planet. Other planets are gas giants made mostly of thick gases. Jupiter is a gas giant. Rocky and gas planets are not built the same way.",
                questions: [
                    discoveryMCQ(
                        "What kind of planet is Earth?",
                        ["A rocky planet", "A gas giant", "An icy moon only"],
                        "A rocky planet",
                        "Earth has solid ground, so scientists call it a rocky planet, not a gas giant."
                    ),
                    discoveryMCQ(
                        "What are gas giants made mostly of?",
                        ["Thick gases", "Mostly solid rock", "Mostly liquid water"],
                        "Thick gases",
                        "Gas giants are huge worlds built mostly of thick gases instead of hard rocky ground."
                    ),
                    discoveryMCQ(
                        "Which planet is named as a gas giant?",
                        ["Jupiter", "Earth", "The Moon"],
                        "Jupiter",
                        "Jupiter is a gas giant made mostly of thick gases, unlike rocky Earth."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "rocky",
                        definition: "Made of solid rock or hard ground.",
                        exampleSentence: "Earth is a rocky planet."
                    ),
                    VocabularyWord(
                        word: "gas giant",
                        definition: "A huge planet made mostly of thick gases.",
                        exampleSentence: "Jupiter is a gas giant."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Earth is a rocky planet with solid ground.",
                        explanation: "Rocky planets have hard surfaces."
                    ),
                    KnowledgeFact(
                        fact: "Gas giants like Jupiter are made mostly of thick gases.",
                        explanation: "They are not built like Earth."
                    )
                ],
                creativePrompt: "Draw one rocky planet and one gas giant, and label each kind.",
                storyEnding: "Nova the star shines. You compared rocky and gas planets with evidence.",
                readingSkill: "Use evidence to tell rocky planets from gas giants",
                reflectionPrompt: "How is Earth different from a gas giant?",
                hints: [
                    "Find Earth as rocky",
                    "Look for Jupiter"
                ],
                commonMistakes: [
                    "Mixing up rocky planets with gas giants"
                ],
                successCriteria: [
                    "Names Earth as rocky",
                    "Names a gas giant fact"
                ],
                learningObjectives: [
                    "Distinguish rocky planets from gas giants",
                    "fp:discovery.Planets.earlyReader"
                ],
                activityFingerprint: "planets.discovery.early.rocky-gas"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Why Venus Looks Bright",
                storyOpening: "Nova the star points to a bright spot near the horizon. Come wonder with her—why does Venus look so bright?",
                missionPrompt: "Find the main idea about Venus brightness. Use details from the notes.",
                readingPassage: "Venus can look very bright in the sky. Thick clouds wrap around the planet. Those clouds reflect a lot of sunlight back toward Earth. The reflected light makes Venus easy to notice. The main idea is that Venus looks bright because its clouds bounce sunlight toward us.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Venus looks bright because its clouds bounce sunlight toward us", "Venus looks bright because it is closer than every star", "Venus looks bright because it makes its own firelight"],
                        "Venus looks bright because its clouds bounce sunlight toward us",
                        "Thick clouds around Venus reflect sunlight back toward Earth, so Venus looks bright in our sky."
                    ),
                    discoveryMCQ(
                        "What wraps around Venus?",
                        ["Thick clouds", "A thin clear sky only", "A ring of solid ice only"],
                        "Thick clouds",
                        "A thick cloud layer wraps Venus and covers much of the planet."
                    ),
                    discoveryMCQ(
                        "What do the clouds do to sunlight?",
                        ["Reflect a lot of sunlight back toward Earth", "Absorb all sunlight so none returns", "Block the Sun from ever warming Venus"],
                        "Reflect a lot of sunlight back toward Earth",
                        "The clouds bounce sunlight outward, and some of that reflected light reaches our eyes on Earth."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "reflect",
                        definition: "To bounce light back from a surface.",
                        exampleSentence: "Clouds reflect sunlight."
                    ),
                    VocabularyWord(
                        word: "cloud",
                        definition: "A thick layer of tiny drops or ice in the air.",
                        exampleSentence: "Venus has thick clouds."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Venus looks bright because thick clouds reflect sunlight toward Earth.",
                        explanation: "Reflected light makes Venus easy to notice."
                    ),
                    KnowledgeFact(
                        fact: "Thick clouds wrap around Venus.",
                        explanation: "Those clouds bounce a lot of sunlight."
                    )
                ],
                creativePrompt: "Draw Venus with cloud layers. Add arrows for reflected sunlight.",
                storyEnding: "Nova the star twinkles proudly. You found the brightness main idea like a careful sky scientist.",
                readingSkill: "Identify the main idea about Venus reflecting sunlight",
                reflectionPrompt: "What do Venus clouds do to sunlight?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find reflect"
                ],
                commonMistakes: [
                    "Missing the reflection main idea"
                ],
                successCriteria: [
                    "States the brightness main idea",
                    "Cites clouds reflecting light"
                ],
                learningObjectives: [
                    "Explain why Venus looks bright using cloud reflection",
                    "fp:discovery.Planets.growingReader"
                ],
                activityFingerprint: "planets.discovery.growing.venus-bright"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Orbits Need Motion and Gravity",
                storyOpening: "Nova the star shines like a curious science partner. Together you investigate how gravity and motion shape planet paths.",
                missionPrompt: "Use evidence from the notes. Explain why planets stay in orbits around the Sun.",
                readingPassage: "A planet moves forward through space with steady motion. The Sun pulls on the planet with gravity. Gravity bends the path so the planet curves instead of flying straight away. Together, motion and gravity make an orbit. Without forward motion, a planet would fall toward the Sun. Without gravity, a planet would not curve into a path around the Sun. Orbit science joins pull and travel.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about why planets stay in orbits?",
                        ["Motion and gravity work together to make a curved path", "Only gravity matters and motion does not", "Only forward motion matters and gravity does not"],
                        "Motion and gravity work together to make a curved path",
                        "Forward motion keeps a planet traveling, while the Sun's gravity bends that path into a curve called an orbit."
                    ),
                    discoveryMCQ(
                        "What does the Sun pull with?",
                        ["Gravity", "Magnetism only", "Wind from empty space"],
                        "Gravity",
                        "The Sun's gravity pulls on planets and helps bend their paths into orbits."
                    ),
                    discoveryMCQ(
                        "What would happen without forward motion?",
                        ["A planet would fall toward the Sun", "A planet would fly straight into deep space", "A planet would stop feeling any pull"],
                        "A planet would fall toward the Sun",
                        "Without forward motion, gravity alone would pull the planet inward toward the Sun."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "orbit",
                        definition: "A curved path one object follows around another.",
                        exampleSentence: "Earth follows an orbit around the Sun."
                    ),
                    VocabularyWord(
                        word: "gravity",
                        definition: "A pull that draws objects toward each other.",
                        exampleSentence: "The Sun pulls planets with gravity."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Planets orbit the Sun because motion and gravity work together.",
                        explanation: "Gravity curves a planet path while motion keeps it traveling."
                    ),
                    KnowledgeFact(
                        fact: "Without forward motion, a planet would fall toward the Sun.",
                        explanation: "Orbits need both pull and travel."
                    ),
                    KnowledgeFact(
                        fact: "Without gravity, a planet would not curve into a path around the Sun.",
                        explanation: "Gravity bends the path."
                    )
                ],
                creativePrompt: "Draw the Sun and one planet path, and label gravity and motion.",
                storyEnding: "Nova the star glows beside you. You connected gravity and motion like a careful investigator.",
                readingSkill: "Infer how gravity and motion create orbits",
                reflectionPrompt: "Which orbit clue from the notes feels most important?",
                hints: [
                    "Compare gravity with forward motion",
                    "Reread what happens without each one"
                ],
                commonMistakes: [
                    "Picking a claim the notes never support"
                ],
                successCriteria: [
                    "Uses gravity evidence",
                    "Links motion to orbit shape"
                ],
                learningObjectives: [
                    "Infer why planets stay in orbits using gravity and motion",
                    "fp:discovery.Planets.confidentReader"
                ],
                activityFingerprint: "planets.discovery.confident.orbits"
            )
        }
    }


    // MARK: - Rockets Discovery

    private static func rocketsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Countdown Ready",
                storyOpening: "Nova the star hovers near the launch pad and counts with you. Before a rocket leaves the ground, every number in the countdown matters.",
                missionPrompt: "Find one true science fact about how countdown checks keep a launch ready.",
                readingPassage: "A countdown helps a rocket team get ready. Each step checks a part of the launch. Teams listen for go or wait. Careful checks keep people safe. One missed check can stop a whole liftoff.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what does a countdown help a team do?",
                        ["Get ready", "Skip every safety check", "Launch with no waiting"],
                        "Get ready",
                        "A countdown is a timed set of steps that helps the team prepare before launch."
                    ),
                    discoveryMCQ(
                        "What do careful checks keep?",
                        ["People safe", "The fuel unused forever", "The engines silent only"],
                        "People safe",
                        "Checking each step for go or wait helps the team notice problems and keep people safe."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "countdown",
                        definition: "A timed set of steps before a launch.",
                        exampleSentence: "The countdown checks each launch step."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A countdown helps a rocket team prepare for launch.",
                        explanation: "Each step checks part of the plan."
                    ),
                    KnowledgeFact(
                        fact: "Careful checks help keep people safe.",
                        explanation: "Teams listen for go or wait."
                    )
                ],
                creativePrompt: "Draw a countdown board with the word go and the word wait.",
                storyEnding: "Nova the star sparkles. You logged a real countdown fact. Great science work!",
                readingSkill: "Use a science note to explain countdown readiness",
                reflectionPrompt: "Name one reason teams use a countdown.",
                hints: [
                    "Look for get ready",
                    "Find the safety sentence"
                ],
                commonMistakes: [
                    "Choosing a claim that skips checks"
                ],
                successCriteria: [
                    "Names a countdown purpose",
                    "Uses a safety fact"
                ],
                learningObjectives: [
                    "Identify that countdowns prepare teams with careful checks",
                    "fp:discovery.Rockets.beginner"
                ],
                activityFingerprint: "rockets.discovery.beginner.countdown"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Thrust Pushes Up",
                storyOpening: "Nova the star sparks with excitement by the rocket engines. Feel that push—today we wonder how thrust lifts a rocket.",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "A rocket burns fuel and pushes hot gas downward. When gas pushes down, the rocket is pushed up. That upward push is called thrust. Thrust must be strong enough to lift the rocket. Downward gas and upward push work as a pair.",
                questions: [
                    discoveryMCQ(
                        "Where does the rocket push hot gas?",
                        ["Downward", "Only upward into the sky", "Only sideways into open air"],
                        "Downward",
                        "Burning fuel sends hot gas down; that downward push is what starts the upward lift."
                    ),
                    discoveryMCQ(
                        "What is the upward push called?",
                        ["Thrust", "Drag only", "Weight only"],
                        "Thrust",
                        "Thrust is the upward push that lifts the rocket when gas is forced downward."
                    ),
                    discoveryMCQ(
                        "What must thrust be strong enough to do?",
                        ["Lift the rocket", "Cool the fuel only", "Push the rocket downward"],
                        "Lift the rocket",
                        "If thrust is weaker than the rocket's weight, the rocket cannot rise into the sky."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "thrust",
                        definition: "A push that can lift or move a rocket.",
                        exampleSentence: "Thrust lifts the rocket upward."
                    ),
                    VocabularyWord(
                        word: "fuel",
                        definition: "Material a rocket burns to make hot gas.",
                        exampleSentence: "The rocket burns fuel for thrust."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Rockets push hot gas downward to create upward thrust.",
                        explanation: "Downward gas and upward push work as a pair."
                    ),
                    KnowledgeFact(
                        fact: "Thrust must be strong enough to lift the rocket.",
                        explanation: "Weak thrust cannot raise a heavy rocket into the sky."
                    )
                ],
                creativePrompt: "Draw a rocket with arrows down for gas and up for thrust.",
                storyEnding: "Nova the star shines. You used evidence about thrust. Careful science reading!",
                readingSkill: "Use evidence to explain rocket thrust",
                reflectionPrompt: "Why does gas going down help a rocket go up?",
                hints: [
                    "Find downward gas",
                    "Look for the word thrust"
                ],
                commonMistakes: [
                    "Thinking rockets rise with no push"
                ],
                successCriteria: [
                    "States thrust as an upward push",
                    "Links gas direction to lift"
                ],
                learningObjectives: [
                    "Explain that downward gas creates upward thrust",
                    "fp:discovery.Rockets.earlyReader"
                ],
                activityFingerprint: "rockets.discovery.early.thrust"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Stages Shed Weight",
                storyOpening: "Nova the star watches a stage fall away and invites you to ask why. Come see how dropping empty parts helps a rocket climb.",
                missionPrompt: "Find the main idea about rocket stages. Use details from the notes.",
                readingPassage: "Many rockets travel in stages. A lower stage burns fuel and then drops away. Shedding an empty stage makes the rocket lighter. A lighter rocket needs less thrust to keep climbing. The main idea is that stages help a rocket by dropping weight after fuel is used.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Stages help a rocket by dropping weight after fuel is used", "Stages help a rocket by adding weight after fuel is used", "Stages stop a rocket from climbing higher"],
                        "Stages help a rocket by dropping weight after fuel is used",
                        "Empty stages fall away so the rocket is lighter and can keep climbing with less thrust."
                    ),
                    discoveryMCQ(
                        "What happens to a lower stage after it burns fuel?",
                        ["It drops away", "It fills with more fuel", "It stays attached forever"],
                        "It drops away",
                        "After a lower stage uses its fuel, it separates and drops away so the rest of the rocket is lighter."
                    ),
                    discoveryMCQ(
                        "Why does a lighter rocket help?",
                        ["It needs less thrust to keep climbing", "It must carry more empty tanks forever", "It must stay on the ground"],
                        "It needs less thrust to keep climbing",
                        "Less weight means the same engines can push the rocket higher more easily."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "stage",
                        definition: "One part of a rocket that can burn fuel and then separate.",
                        exampleSentence: "The first stage drops away after use."
                    ),
                    VocabularyWord(
                        word: "weight",
                        definition: "How heavy something is.",
                        exampleSentence: "Dropping a stage lowers weight."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Rocket stages drop away after their fuel is used.",
                        explanation: "Shedding empty stages makes the rocket lighter."
                    ),
                    KnowledgeFact(
                        fact: "A lighter rocket needs less thrust to keep climbing.",
                        explanation: "Stages help manage weight during flight."
                    )
                ],
                creativePrompt: "Draw a rocket with one stage falling away, and label lighter.",
                storyEnding: "Nova the star twinkles proudly. You found the stages main idea like a careful flight scientist.",
                readingSkill: "Identify the main idea about rocket stages and weight",
                reflectionPrompt: "How does dropping a stage help a climbing rocket?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find lighter"
                ],
                commonMistakes: [
                    "Missing the weight main idea"
                ],
                successCriteria: [
                    "States the stages main idea",
                    "Cites dropping weight"
                ],
                learningObjectives: [
                    "Explain how rocket stages shed weight to help climbing",
                    "fp:discovery.Rockets.growingReader"
                ],
                activityFingerprint: "rockets.discovery.growing.stages"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Checklists Catch Mistakes",
                storyOpening: "Nova the star joins your launch team as a careful science partner. Together you investigate how checklists help teams launch more safely.",
                missionPrompt: "Use evidence from the notes. Explain why launch teams use checklists and cross-checks.",
                readingPassage: "Launch teams follow checklists so each important step is reviewed. A second person may cross-check the same item to catch a missed detail. Small errors can grow into big problems during a fast countdown. Cross-checks slow the rush just enough to notice trouble early. Together, written steps and second looks reduce the chance that one person overlooks a hazard. Careful process is part of rocket science, not only engines and fuel.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about why teams use checklists and cross-checks?",
                        ["They help catch missed details before launch", "They make the countdown finish faster by skipping steps", "They replace the need for trained launch teams"],
                        "They help catch missed details before launch",
                        "Written steps plus a second look help the team notice hazards before a fast countdown begins."
                    ),
                    discoveryMCQ(
                        "What may a second person do?",
                        ["Cross-check the same item", "Rewrite the checklist from memory only", "Skip items the first person already marked"],
                        "Cross-check the same item",
                        "A second person reviews the same step so a missed detail is less likely to slip through."
                    ),
                    discoveryMCQ(
                        "Why can small errors matter in a countdown?",
                        ["They can grow into big problems", "They only matter after the rocket lands", "They disappear once the countdown starts"],
                        "They can grow into big problems",
                        "During a fast countdown, a small missed detail can turn into a serious hazard if nobody catches it early."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "checklist",
                        definition: "A written list of steps to review.",
                        exampleSentence: "The team follows a launch checklist."
                    ),
                    VocabularyWord(
                        word: "cross-check",
                        definition: "A second look that confirms a step was done correctly.",
                        exampleSentence: "A cross-check can catch a missed detail."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Launch checklists help teams review each important step.",
                        explanation: "Written steps reduce overlooked hazards."
                    ),
                    KnowledgeFact(
                        fact: "Cross-checks let a second person catch missed details.",
                        explanation: "Two looks are safer than one rushed look."
                    ),
                    KnowledgeFact(
                        fact: "Small errors can grow into big problems during a fast countdown.",
                        explanation: "Careful process is part of rocket science."
                    )
                ],
                creativePrompt: "Write three sentences about a checklist item and a cross-check.",
                storyEnding: "Nova the star glows beside you. You connected process and safety like a careful investigator.",
                readingSkill: "Infer why checklists and cross-checks support safer launches",
                reflectionPrompt: "Which checklist idea from the notes would you trust most?",
                hints: [
                    "Compare checklist with cross-check",
                    "Reread the small-errors sentence"
                ],
                commonMistakes: [
                    "Treating process as unrelated to rocket science"
                ],
                successCriteria: [
                    "Uses checklist evidence",
                    "Links cross-checks to catching mistakes"
                ],
                learningObjectives: [
                    "Infer how checklists and cross-checks reduce launch mistakes",
                    "fp:discovery.Rockets.confidentReader"
                ],
                activityFingerprint: "rockets.discovery.confident.checklist"
            )
        }
    }


    // MARK: - Soccer Discovery

    private static func soccerDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Kick Force",
                storyOpening: "Movo, your spark buddy, taps the soccer ball with a grin. Feel how hard a kick pushes—that force is real science at work.",
                missionPrompt: "Pick out one true fact about kicking force from the notes.",
                readingPassage: "A kick pushes the ball with force. A stronger kick can make the ball travel farther. Your foot transfers energy to the ball. Force starts the ball moving. The harder the push, the longer the roll across the grass.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what does a kick push the ball with?",
                        ["Force", "Only gravity with no push", "Only the ball's color"],
                        "Force",
                        "A kick pushes the ball with force from your foot."
                    ),
                    discoveryMCQ(
                        "What can a stronger kick make the ball do?",
                        ["Travel farther", "Always stop in one step", "Float upward forever"],
                        "Travel farther",
                        "More force from a stronger kick can send the ball farther."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "force",
                        definition: "A push or pull that can start motion.",
                        exampleSentence: "A kick uses force to move the ball."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A kick pushes a soccer ball with force.",
                        explanation: "Force starts the ball moving."
                    ),
                    KnowledgeFact(
                        fact: "A stronger kick can send the ball farther.",
                        explanation: "More force can mean more travel."
                    )
                ],
                creativePrompt: "Draw a foot kicking a ball. Add an arrow for force.",
                storyEnding: "You logged a real kicking-force fact. Great science work!",
                readingSkill: "Use a science note to name kicking force",
                reflectionPrompt: "Name one thing force does to a soccer ball.",
                hints: [
                    "Look for the word force",
                    "Find farther"
                ],
                commonMistakes: [
                    "Choosing a claim with no push"
                ],
                successCriteria: [
                    "Names force as a push",
                    "Uses a travel fact"
                ],
                learningObjectives: [
                    "Identify that a kick applies force to move a ball",
                    "fp:discovery.Soccer.beginner"
                ],
                activityFingerprint: "soccer.discovery.beginner.force"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Bounce Energy",
                storyOpening: "Movo watches a soccer ball hit the grass with you. It flattens for a blink, then leaps back up—come see the bounce energy!",
                missionPrompt: "Hunt for one true science fact about bounce energy in the notes.",
                readingPassage: "When a soccer ball hits the ground, it squashes a little. Stored energy pushes the ball back up. A bouncy ball returns more energy than a soft flat ball. The ground and the ball share the bounce. Bounce is energy changing form during the hit.",
                questions: [
                    discoveryMCQ(
                        "What does the ball do when it hits the ground?",
                        ["It squashes a little", "It turns into water", "It grows leaves"],
                        "It squashes a little",
                        "The ball squashes a little on impact."
                    ),
                    discoveryMCQ(
                        "What pushes the ball back up?",
                        ["Stored energy", "Only the grass color", "Only the wind's smell"],
                        "Stored energy",
                        "When the ball squashes, stored energy pushes it back up."
                    ),
                    discoveryMCQ(
                        "What returns more energy in a bounce?",
                        ["A bouncy ball", "A soft flat ball", "A pile of sand only"],
                        "A bouncy ball",
                        "A bouncy ball returns more energy than a soft flat ball."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "bounce",
                        definition: "A spring back after a hit.",
                        exampleSentence: "The ball bounce sends it upward again."
                    ),
                    VocabularyWord(
                        word: "energy",
                        definition: "The ability to make things move or change.",
                        exampleSentence: "Stored energy pushes the ball up."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A soccer ball stores energy when it squashes against the ground.",
                        explanation: "That energy can push the ball back up."
                    ),
                    KnowledgeFact(
                        fact: "Bouncier balls return more energy than soft flat balls.",
                        explanation: "Material affects the bounce."
                    )
                ],
                creativePrompt: "Draw a ball squashing on grass, then rising, and label energy.",
                storyEnding: "You used bounce evidence carefully. Great science reading!",
                readingSkill: "Use evidence to explain ball bounce energy",
                reflectionPrompt: "What happens to energy when a ball hits the ground?",
                hints: [
                    "Find squash",
                    "Look for stored energy"
                ],
                commonMistakes: [
                    "Thinking bounce needs no energy change"
                ],
                successCriteria: [
                    "States squash stores energy",
                    "Compares bouncy and flat balls"
                ],
                learningObjectives: [
                    "Explain that bounce involves energy during a hit",
                    "fp:discovery.Soccer.earlyReader"
                ],
                activityFingerprint: "soccer.discovery.early.bounce"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Cleat Friction",
                storyOpening: "Movo kneels by muddy cleats and asks a sharp question. Why don't they slip on wet grass? Tiny studs dig in and grab the ground.",
                missionPrompt: "Find the main idea about cleats and friction. Use details from the notes.",
                readingPassage: "Cleats have small studs on the bottom of the shoe. Studs dig into grass and raise friction with the ground. Higher friction helps a player push without sliding as easily. Smooth shoes slip more on wet turf. The main idea is that cleats increase friction so players can plant and change direction with better grip.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Cleats increase friction so players can plant and change direction with better grip", "Cleats remove all friction from the field", "Cleats only change shoe color"],
                        "Cleats increase friction so players can plant and change direction with better grip",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What do studs dig into?",
                        ["Grass", "Only smooth ice", "Only open sky"],
                        "Grass",
                        "Studs dig into grass so shoes grip the field."
                    ),
                    discoveryMCQ(
                        "What happens with smooth shoes on wet turf?",
                        ["They slip more", "They grip wet grass better", "They never slip at all"],
                        "They slip more",
                        "Smooth shoes slip more on wet turf."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "friction",
                        definition: "A force that resists sliding between surfaces.",
                        exampleSentence: "Cleats raise friction with the ground."
                    ),
                    VocabularyWord(
                        word: "stud",
                        definition: "A small spike on a cleat that digs into grass.",
                        exampleSentence: "Studs help the shoe grip."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Cleat studs dig into grass and increase friction.",
                        explanation: "Higher friction helps players push without sliding as easily."
                    ),
                    KnowledgeFact(
                        fact: "Smooth shoes slip more on wet turf.",
                        explanation: "Less friction means less grip."
                    )
                ],
                creativePrompt: "Draw a cleat bottom with studs, and label friction.",
                storyEnding: "You found the friction main idea like a careful field scientist.",
                readingSkill: "Identify the main idea about cleats and friction",
                reflectionPrompt: "How do studs help a player change direction?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Compare cleats with smooth shoes"
                ],
                commonMistakes: [
                    "Missing the friction main idea"
                ],
                successCriteria: [
                    "States the cleat-friction main idea",
                    "Cites grip or sliding detail"
                ],
                learningObjectives: [
                    "Explain how cleats increase friction for grip",
                    "fp:discovery.Soccer.growingReader"
                ],
                activityFingerprint: "soccer.discovery.growing.friction"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Aim Needs Force and Direction",
                storyOpening: "Movo joins your science team on the field. Together you investigate how force and aim shape a ball path.",
                missionPrompt: "Use evidence from the notes. Explain why aim and force both matter for a pass.",
                readingPassage: "A pass needs enough force to reach a teammate. Force alone is not enough if the direction is wrong. Aim sets the direction of the kick. Grass friction can slow the ball along the path. Players adjust force and aim together for a useful pass. Science of the kick joins how hard you push with where you push.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about a useful pass?",
                        ["Force and aim must work together", "Only force matters and aim never matters", "Balls ignore direction"],
                        "Force and aim must work together",
                        "A useful pass needs enough force and the right aim together."
                    ),
                    discoveryMCQ(
                        "What does aim set?",
                        ["The direction of the kick", "Only the weight of the ball", "Only the length of the grass"],
                        "The direction of the kick",
                        "Aim sets which way the kick sends the ball."
                    ),
                    discoveryMCQ(
                        "What can grass friction do to the ball?",
                        ["Slow the ball along the path", "Make the ball heavier", "Make the ball speed up by itself"],
                        "Slow the ball along the path",
                        "Grass friction can slow the ball."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "aim",
                        definition: "Choosing the direction of a kick or throw.",
                        exampleSentence: "Good aim sends the ball toward a teammate."
                    ),
                    VocabularyWord(
                        word: "pass",
                        definition: "A kick that sends the ball to a teammate.",
                        exampleSentence: "A pass needs force and aim."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A useful pass needs both enough force and correct aim.",
                        explanation: "Force alone fails if direction is wrong."
                    ),
                    KnowledgeFact(
                        fact: "Grass friction can slow a rolling ball.",
                        explanation: "Players must account for slowing on the path."
                    ),
                    KnowledgeFact(
                        fact: "Aim sets the direction of the kick.",
                        explanation: "Direction and force together shape the pass."
                    )
                ],
                creativePrompt: "Draw two arrows on a kick: one for force size and one for aim direction.",
                storyEnding: "You connected force and aim like a careful investigator.",
                readingSkill: "Infer why force and aim both matter for passes",
                reflectionPrompt: "Which pass clue from the notes would you practice first?",
                hints: [
                    "Compare force with aim",
                    "Reread the friction detail"
                ],
                commonMistakes: [
                    "Treating aim as unrelated to science of the kick"
                ],
                successCriteria: [
                    "Uses force evidence",
                    "Links aim to direction"
                ],
                learningObjectives: [
                    "Infer how force and aim together create a useful pass",
                    "fp:discovery.Soccer.confidentReader"
                ],
                activityFingerprint: "soccer.discovery.confident.aim"
            )
        }
    }


    // MARK: - Basketball Discovery

    private static func basketballDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Ball Bounce",
                storyOpening: "Movo bounces a basketball beside you. Watch it hit the floor—it squishes, then springs back up like a tiny trampoline.",
                missionPrompt: "Catch one true science fact about bounce in the notes.",
                readingPassage: "A basketball bounces when it hits the floor. Air inside the ball helps it spring back. A soft flat ball bounces less. Bounce helps you dribble. The air acts like a hidden spring under your hand.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, when does a basketball bounce?",
                        ["When it hits the floor", "When it sits still on a shelf", "When it stays in the air with no bounce"],
                        "When it hits the floor",
                        "A basketball bounces when it hits the floor."
                    ),
                    discoveryMCQ(
                        "What helps the ball spring back?",
                        ["Air inside the ball", "Only the painted lines", "Only the hoop's height"],
                        "Air inside the ball",
                        "Compressed air inside the ball helps it spring back."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "bounce",
                        definition: "A spring back after a hit.",
                        exampleSentence: "The basketball bounce lifts it off the floor."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A basketball bounces when it hits the floor.",
                        explanation: "Air inside helps it spring back."
                    ),
                    KnowledgeFact(
                        fact: "A soft flat ball bounces less.",
                        explanation: "Air pressure affects bounce."
                    )
                ],
                creativePrompt: "Draw a basketball hitting the floor and rising, and label air.",
                storyEnding: "You logged a real bounce fact. Great science work!",
                readingSkill: "Use a science note to explain basketball bounce",
                reflectionPrompt: "Name one thing that helps a basketball bounce.",
                hints: [
                    "Look for hits the floor",
                    "Find air inside"
                ],
                commonMistakes: [
                    "Choosing a claim with no bounce"
                ],
                successCriteria: [
                    "Names floor impact",
                    "Uses an air fact"
                ],
                learningObjectives: [
                    "Identify that air inside helps a basketball bounce",
                    "fp:discovery.Basketball.beginner"
                ],
                activityFingerprint: "basketball.discovery.beginner.bounce"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Shot Arc",
                storyOpening: "Movo tosses a soft arc toward the hoop with you. Gravity pulls the ball back down—come wonder about that path!",
                missionPrompt: "Spot one true fact about a basketball shot's path in the notes.",
                readingPassage: "A basketball shot often follows a curved path called an arc. The ball rises, then falls toward the hoop. Gravity pulls the ball downward after the rise. A flat throw may hit the rim more often. Arc shape matters for aiming at the basket.",
                questions: [
                    discoveryMCQ(
                        "What is the curved path of a shot called?",
                        ["An arc", "A square tunnel", "A silent shadow"],
                        "An arc",
                        "The curved path is called an arc."
                    ),
                    discoveryMCQ(
                        "What pulls the ball downward after the rise?",
                        ["Gravity", "Only the crowd noise", "Only the ball's color"],
                        "Gravity",
                        "Gravity pulls the ball back down after it rises."
                    ),
                    discoveryMCQ(
                        "What may a flat throw do more often?",
                        ["Hit the rim", "Always go through the net", "Float without falling"],
                        "Hit the rim",
                        "A flat throw may hit the rim more often than a soft arc."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "arc",
                        definition: "A curved path through the air.",
                        exampleSentence: "The shot follows an arc toward the hoop."
                    ),
                    VocabularyWord(
                        word: "gravity",
                        definition: "A pull that draws objects toward Earth.",
                        exampleSentence: "Gravity pulls the ball down."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Basketball shots often travel in a curved arc.",
                        explanation: "The ball rises, then falls toward the hoop."
                    ),
                    KnowledgeFact(
                        fact: "Gravity pulls the ball downward after it rises.",
                        explanation: "Arc shape matters for aiming."
                    )
                ],
                creativePrompt: "Draw a ball path as an arc into a hoop, and label gravity.",
                storyEnding: "You used arc evidence carefully. Great science reading!",
                readingSkill: "Use evidence to explain shot arc and gravity",
                reflectionPrompt: "Why does a basketball shot curve down toward the hoop?",
                hints: [
                    "Find the word arc",
                    "Look for gravity"
                ],
                commonMistakes: [
                    "Thinking shots travel in a forever-flat line"
                ],
                successCriteria: [
                    "Names the arc path",
                    "Cites gravity pulling down"
                ],
                learningObjectives: [
                    "Explain that shots follow an arc shaped by gravity",
                    "fp:discovery.Basketball.earlyReader"
                ],
                activityFingerprint: "basketball.discovery.early.arc"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Grip Friction",
                storyOpening: "Movo places a basketball in your hands. Run your fingers over it—those tiny bumps help your grip with friction.",
                missionPrompt: "Find the main idea about grip and friction. Use details from the notes.",
                readingPassage: "The pebbled surface of a basketball raises friction with your hands. Higher friction helps you control the ball when you catch or dribble. Sweaty smooth hands can lower grip. Clean dry hands often hold better. The main idea is that friction between hands and ball surface supports control.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Friction between hands and ball surface supports control", "Friction removes all bounce from the ball", "Grip never matters in basketball"],
                        "Friction between hands and ball surface supports control",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What does the pebbled surface raise?",
                        ["Friction with your hands", "Only the color of the sky", "Only the smell of the court"],
                        "Friction with your hands",
                        "The pebbled surface raises friction so hands can grip the ball."
                    ),
                    discoveryMCQ(
                        "What can sweaty smooth hands do?",
                        ["Lower grip", "Turn the ball into ice", "Make gravity stop"],
                        "Lower grip",
                        "Sweaty smooth hands can lower grip."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "friction",
                        definition: "A force that resists sliding between surfaces.",
                        exampleSentence: "Ball pebbles raise friction with hands."
                    ),
                    VocabularyWord(
                        word: "grip",
                        definition: "How well hands hold onto something.",
                        exampleSentence: "Good grip helps control the ball."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A pebbled basketball surface increases friction with hands.",
                        explanation: "Higher friction supports control."
                    ),
                    KnowledgeFact(
                        fact: "Sweaty smooth hands can lower grip.",
                        explanation: "Clean dry hands often hold better."
                    )
                ],
                creativePrompt: "Draw a hand on a pebbled ball, and label friction.",
                storyEnding: "You found the grip main idea like a careful sports scientist.",
                readingSkill: "Identify the main idea about grip friction",
                reflectionPrompt: "How does a pebbled surface help a player?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find pebbled"
                ],
                commonMistakes: [
                    "Missing the friction main idea"
                ],
                successCriteria: [
                    "States the grip-friction main idea",
                    "Cites a surface or sweat detail"
                ],
                learningObjectives: [
                    "Explain how ball surface friction supports grip",
                    "fp:discovery.Basketball.growingReader"
                ],
                activityFingerprint: "basketball.discovery.growing.grip"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Energy Transfer in a Pass",
                storyOpening: "Movo high-fives your science plan. Together you investigate how energy moves from hands to ball to teammate.",
                missionPrompt: "Use evidence from the notes. Explain how energy moves during a basketball pass.",
                readingPassage: "When you push a basketball, your muscles give energy to the ball. The moving ball carries that energy across the court. A teammate's hands absorb some energy when they catch. Soft hands spread the force over a longer time so the catch stings less. Energy transfer links the passer, the ball, and the catcher. Science of the pass is about moving energy safely and accurately.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about a basketball pass?",
                        ["Energy moves from passer to ball to catcher", "Energy disappears and never transfers", "Only the hoop receives energy"],
                        "Energy moves from passer to ball to catcher",
                        "A pass moves energy from the passer through the ball to the catcher."
                    ),
                    discoveryMCQ(
                        "What gives energy to the ball when you push?",
                        ["Your muscles", "Only the floorboards", "Only the painted key"],
                        "Your muscles",
                        "Your muscles give energy to the ball when you push."
                    ),
                    discoveryMCQ(
                        "Why can soft hands help a catch?",
                        ["They spread the force over a longer time", "They make the catch happen faster", "They make the ball lighter than air"],
                        "They spread the force over a longer time",
                        "Soft hands spread force over a longer time."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "transfer",
                        definition: "To move from one place or object to another.",
                        exampleSentence: "Energy can transfer from hands to ball."
                    ),
                    VocabularyWord(
                        word: "absorb",
                        definition: "To take in energy or force.",
                        exampleSentence: "Hands absorb energy on a catch."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A pass transfers energy from muscles to the ball to the catcher.",
                        explanation: "Moving balls carry energy across the court."
                    ),
                    KnowledgeFact(
                        fact: "Soft hands spread catching force over a longer time.",
                        explanation: "That can make a catch sting less."
                    ),
                    KnowledgeFact(
                        fact: "Muscles give energy to the ball when you push.",
                        explanation: "Energy transfer links each part of the pass."
                    )
                ],
                creativePrompt: "Write three sentences tracing energy from push to catch.",
                storyEnding: "You traced energy transfer like a careful investigator.",
                readingSkill: "Infer how energy moves through a basketball pass",
                reflectionPrompt: "Which energy step from the notes feels most important?",
                hints: [
                    "Follow passer to ball to catcher",
                    "Reread soft hands"
                ],
                commonMistakes: [
                    "Treating energy as unrelated to passing"
                ],
                successCriteria: [
                    "Uses transfer evidence",
                    "Links soft hands to force over time"
                ],
                learningObjectives: [
                    "Infer how energy transfers during a basketball pass",
                    "fp:discovery.Basketball.confidentReader"
                ],
                activityFingerprint: "basketball.discovery.confident.energy-transfer"
            )
        }
    }


    // MARK: - Cats Discovery

    private static func catsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Claws That Hide",
                storyOpening: "Movo tiptoes beside a quiet cat. It walks so softly you barely hear it—because its claws can vanish into soft paws.",
                missionPrompt: "Discover one true fact about cat claws in the science notes.",
                readingPassage: "Cats can pull their claws in and out. Hidden claws stay sharp. Claws help a cat climb and grip. Soft paws hide the claws when a cat walks. That secret hide keeps the tips ready for the next climb.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what can cats do with their claws?",
                        ["Pull them in and out", "Keep them stuck out all the time", "Turn them into soft fur"],
                        "Pull them in and out",
                        "Cats can pull their claws in and out."
                    ),
                    discoveryMCQ(
                        "What do hidden claws stay?",
                        ["Sharp", "Always soft and rounded", "Loud like a drumbeat"],
                        "Sharp",
                        "Hidden claws stay sharp because sheaths protect the tips."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "claw",
                        definition: "A sharp nail on an animal toe.",
                        exampleSentence: "A cat can hide its claws."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Cats can pull their claws in and out.",
                        explanation: "Hidden claws stay sharp."
                    ),
                    KnowledgeFact(
                        fact: "Claws help a cat climb and grip.",
                        explanation: "Soft paws can hide claws while walking."
                    )
                ],
                creativePrompt: "Draw a cat paw with claws in and claws out.",
                storyEnding: "You logged a real claw fact. Great science work!",
                readingSkill: "Use a science note to explain retractable claws",
                reflectionPrompt: "Name one way claws help a cat.",
                hints: [
                    "Look for in and out",
                    "Find sharp"
                ],
                commonMistakes: [
                    "Choosing a claim that claws never hide"
                ],
                successCriteria: [
                    "Names claws that pull in and out",
                    "Uses a sharp or grip fact"
                ],
                learningObjectives: [
                    "Identify that cats can retract claws to keep them sharp",
                    "fp:discovery.Cats.beginner"
                ],
                activityFingerprint: "cats.discovery.beginner.claws"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Night Eyes",
                storyOpening: "Movo peeks down a dim hallway with you. A cat's eyes still catch shapes you might miss—come wonder how!",
                missionPrompt: "Hunt for one true science fact about night vision in the notes.",
                readingPassage: "Cats can see well in dim light. Their eyes open wide to take in more light. A special layer in the eye can bounce light back. That bounce helps night vision. Bright noon sun still looks strong to a cat, so shade can feel easier.",
                questions: [
                    discoveryMCQ(
                        "What can cats do in dim light?",
                        ["See well", "Only see in bright noon sun", "Only see moving things"],
                        "See well",
                        "Cats' eyes help them see well in dim light."
                    ),
                    discoveryMCQ(
                        "Why do cat eyes open wide?",
                        ["To take in more light", "To keep extra light out", "To make the room darker"],
                        "To take in more light",
                        "Eyes open wide to take in more light."
                    ),
                    discoveryMCQ(
                        "What can a special eye layer do?",
                        ["Bounce light back", "Bounce heat back only", "Block all incoming light"],
                        "Bounce light back",
                        "A special layer can bounce light back."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "dim",
                        definition: "Not bright; low light.",
                        exampleSentence: "Cats see well in dim light."
                    ),
                    VocabularyWord(
                        word: "vision",
                        definition: "The sense of seeing.",
                        exampleSentence: "Night vision helps a cat hunt."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Cats see well in dim light by taking in more light.",
                        explanation: "Wide pupils help gather light."
                    ),
                    KnowledgeFact(
                        fact: "A special eye layer can bounce light back to help night vision.",
                        explanation: "That bounce supports seeing in low light."
                    )
                ],
                creativePrompt: "Draw cat eyes in dim light, and label wide open.",
                storyEnding: "You used night-vision evidence carefully.",
                readingSkill: "Use evidence to explain cat night vision",
                reflectionPrompt: "How do cat eyes help in dim light?",
                hints: [
                    "Find dim light",
                    "Look for bounce light"
                ],
                commonMistakes: [
                    "Thinking cats need noon sun to see at all"
                ],
                successCriteria: [
                    "States dim-light seeing",
                    "Cites wide eyes or bounce layer"
                ],
                learningObjectives: [
                    "Explain how cats gather light for night vision",
                    "fp:discovery.Cats.earlyReader"
                ],
                activityFingerprint: "cats.discovery.early.night-vision"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Whiskers as Sensors",
                storyOpening: "Movo freezes as a whisker brushes a doorway. The cat already knows the gap is tight—let's study those sensors!",
                missionPrompt: "Find the main idea about whiskers. Use details from the notes.",
                readingPassage: "Whiskers are long stiff hairs that sense touch. Moving air or a nearby wall can bend a whisker. Nerves at the whisker base send signals to the brain. Whiskers help a cat judge space in the dark. The main idea is that whiskers work as touch sensors that guide safe movement.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Whiskers work as touch sensors that guide safe movement", "Whiskers only decorate a cat face", "Whiskers remove all sound"],
                        "Whiskers work as touch sensors that guide safe movement",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What can bend a whisker?",
                        ["Moving air or a nearby wall", "Only faraway mountains", "Only the color of fur"],
                        "Moving air or a nearby wall",
                        "Whiskers bend when moving air or a nearby wall touches them."
                    ),
                    discoveryMCQ(
                        "What do nerves at the whisker base do?",
                        ["Send signals to the brain", "Send signals only to the paws", "Block all light from the room"],
                        "Send signals to the brain",
                        "Nerves send signals to the brain."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "whisker",
                        definition: "A long stiff hair that senses touch.",
                        exampleSentence: "A cat whisker bends when it touches a wall."
                    ),
                    VocabularyWord(
                        word: "sensor",
                        definition: "A part that detects a change such as touch.",
                        exampleSentence: "Whiskers act as touch sensors."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Cat whiskers sense touch and help judge space.",
                        explanation: "Nerves at the base send signals to the brain."
                    ),
                    KnowledgeFact(
                        fact: "Moving air or walls can bend whiskers.",
                        explanation: "That feedback guides safe movement."
                    )
                ],
                creativePrompt: "Draw a cat face with whiskers touching a wall, and label sensor.",
                storyEnding: "You found the whisker main idea like a careful biologist.",
                readingSkill: "Identify the main idea about whiskers as sensors",
                reflectionPrompt: "How do whiskers help a cat in the dark?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find nerves"
                ],
                commonMistakes: [
                    "Missing the sensor main idea"
                ],
                successCriteria: [
                    "States the sensor main idea",
                    "Cites touch or space detail"
                ],
                learningObjectives: [
                    "Explain that whiskers are touch sensors for safe movement",
                    "fp:discovery.Cats.growingReader"
                ],
                activityFingerprint: "cats.discovery.growing.whiskers"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Silent Paw Pads",
                storyOpening: "Movo becomes your quiet science partner. Together you investigate how paw pads help a cat take quiet hunting steps.",
                missionPrompt: "Use evidence from the notes. Explain why soft paw pads help a cat move quietly.",
                readingPassage: "Soft paw pads cushion each step and spread the force of landing. Fur between the toes can dampen sound on hard floors. Retracted claws stay off the ground during a quiet walk so they do not click. Together, pads, fur, and hidden claws reduce noise. Quiet steps help a hunting cat avoid giving an early warning. Body design and careful movement both matter.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about quiet cat walking?",
                        ["Pads, fur, and hidden claws work together to reduce noise", "Cats are quiet because floors remove all sound", "Only whiskers make walking silent"],
                        "Pads, fur, and hidden claws work together to reduce noise",
                        "Soft pads, fur, and hidden claws work together to keep steps quiet."
                    ),
                    discoveryMCQ(
                        "What do soft paw pads do?",
                        ["Cushion each step and spread landing force", "Make each step louder", "Remove all fur from the toes"],
                        "Cushion each step and spread landing force",
                        "Pads cushion steps and spread force."
                    ),
                    discoveryMCQ(
                        "Why stay claws retracted on a quiet walk?",
                        ["So they do not click on the ground", "So they stay extra long and loud", "So they scrape the floor for extra grip"],
                        "So they do not click on the ground",
                        "Retracted claws do not click."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "pad",
                        definition: "A soft cushion on the bottom of a paw.",
                        exampleSentence: "Paw pads cushion each step."
                    ),
                    VocabularyWord(
                        word: "retract",
                        definition: "To pull back in.",
                        exampleSentence: "Cats retract claws during a quiet walk."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Soft paw pads cushion steps and can help reduce noise.",
                        explanation: "Spreading force softens landings."
                    ),
                    KnowledgeFact(
                        fact: "Fur between toes can dampen sound on hard floors.",
                        explanation: "Quiet steps avoid early warnings."
                    ),
                    KnowledgeFact(
                        fact: "Retracted claws stay off the ground so they do not click.",
                        explanation: "Hidden claws support silent walking."
                    )
                ],
                creativePrompt: "Draw a cat paw underside, and label pad, fur, and retracted claw.",
                storyEnding: "You connected body clues to quiet steps like a careful investigator.",
                readingSkill: "Infer how paw design supports silent movement",
                reflectionPrompt: "Which quiet-step clue from the notes feels strongest?",
                hints: [
                    "Compare pads with retracted claws",
                    "Reread fur between toes"
                ],
                commonMistakes: [
                    "Picking a claim the notes never support"
                ],
                successCriteria: [
                    "Uses pad evidence",
                    "Links hidden claws to less noise"
                ],
                learningObjectives: [
                    "Infer why soft pads and retracted claws support quiet walking",
                    "fp:discovery.Cats.confidentReader"
                ],
                activityFingerprint: "cats.discovery.confident.silent-paws"
            )
        }
    }


    // MARK: - Princesses Discovery

    private static func princessesDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Metal Crowns",
                storyOpening: "Movo gazes at a sparkling crown under candlelight. What keeps those heavy gems from falling? Let's find out together!",
                missionPrompt: "Look for one true science fact about crown metals in the notes.",
                readingPassage: "Some crowns are made of metal. Metal can be strong and shiny. Soft cloth alone cannot hold heavy gems well. Strong metal supports the shape. One solid band can carry gems that would tear soft fabric.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what are some crowns made of?",
                        ["Metal", "Only woven grass", "Only soft cloth"],
                        "Metal",
                        "Some crowns are made of metal that can be shaped and polished."
                    ),
                    discoveryMCQ(
                        "What can metal be?",
                        ["Strong and shiny", "Always soft like cloth", "Only made of leaves"],
                        "Strong and shiny",
                        "Metal can be strong and shiny when it is polished."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "metal",
                        definition: "A strong material that can look shiny.",
                        exampleSentence: "A crown may be made of metal."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Some crowns are made of strong metal.",
                        explanation: "Metal can look shiny and hold shape."
                    ),
                    KnowledgeFact(
                        fact: "Strong metal supports heavy gems better than soft cloth alone.",
                        explanation: "Material choice matters for strength."
                    )
                ],
                creativePrompt: "Draw a metal crown, and label strong metal.",
                storyEnding: "You logged a real materials fact. Great science work!",
                readingSkill: "Use a science note to name crown metal properties",
                reflectionPrompt: "Name one property of metal from the notes.",
                hints: [
                    "Look for metal",
                    "Find strong and shiny"
                ],
                commonMistakes: [
                    "Choosing a material the notes never name"
                ],
                successCriteria: [
                    "Names metal",
                    "Uses strong or shiny"
                ],
                learningObjectives: [
                    "Identify that metal crowns can be strong and shiny",
                    "fp:discovery.Princesses.beginner"
                ],
                activityFingerprint: "princesses.discovery.beginner.metal"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Stained-Glass Light",
                storyOpening: "Movo steps into rainbow spots on the floor. Sunlight pours through colored glass—come see how stained glass works!",
                missionPrompt: "Hunt for one true fact about stained glass and light in the notes.",
                readingPassage: "Stained glass is colored glass set in a window. Sunlight passes through the glass. Colors appear on the floor as light shines through. Darker glass lets less light pass. Light and color work together in the window.",
                questions: [
                    discoveryMCQ(
                        "What is stained glass?",
                        ["Colored glass set in a window", "Clear ice frozen in a frame", "Painted wood with no glass"],
                        "Colored glass set in a window",
                        "Stained glass is colored glass pieces set into a window."
                    ),
                    discoveryMCQ(
                        "What passes through the glass?",
                        ["Sunlight", "Only solid stone blocks", "Only heavy raindrops that stay outside"],
                        "Sunlight",
                        "Sunlight passes through the colored glass and lights the room."
                    ),
                    discoveryMCQ(
                        "What does darker glass do?",
                        ["Lets less light pass", "Lets more light pass", "Stops all color from showing"],
                        "Lets less light pass",
                        "Darker glass lets less light pass."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "stained glass",
                        definition: "Colored glass used in windows.",
                        exampleSentence: "Sunlight shines through stained glass."
                    ),
                    VocabularyWord(
                        word: "pass through",
                        definition: "To go from one side to the other.",
                        exampleSentence: "Light can pass through glass."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sunlight passing through stained glass makes colored light indoors.",
                        explanation: "Colors appear where light shines through."
                    ),
                    KnowledgeFact(
                        fact: "Darker glass lets less light pass.",
                        explanation: "Glass color changes how much light gets through."
                    )
                ],
                creativePrompt: "Draw a window with colored glass and light on the floor.",
                storyEnding: "You used light evidence carefully. Great science reading!",
                readingSkill: "Use evidence to explain stained-glass light",
                reflectionPrompt: "What happens when sunlight passes through colored glass?",
                hints: [
                    "Find sunlight",
                    "Look for darker glass"
                ],
                commonMistakes: [
                    "Thinking stained glass blocks all light always"
                ],
                successCriteria: [
                    "States sunlight passes through",
                    "Cites color on the floor or darker glass"
                ],
                learningObjectives: [
                    "Explain how sunlight through stained glass creates colored light",
                    "fp:discovery.Princesses.earlyReader"
                ],
                activityFingerprint: "princesses.discovery.early.stained-glass"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Maps for Travel",
                storyOpening: "Movo unfolds a travel map with you. A tiny mark can stand for a whole river, road, or town outside.",
                missionPrompt: "Find the main idea about maps. Use details from the notes.",
                readingPassage: "A map is a drawing that shows places and paths. Symbols mark roads, rivers, and towns. Distance on a map stands for a longer real distance. Travelers use maps to plan safer routes. The main idea is that maps turn real places into scaled pictures that guide travel.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Maps turn real places into scaled pictures that guide travel", "Maps only decorate walls and never guide", "Maps remove all roads"],
                        "Maps turn real places into scaled pictures that guide travel",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What can symbols mark on a map?",
                        ["Roads, rivers, and towns", "Only the map's paper color", "Only the artist's favorite food"],
                        "Roads, rivers, and towns",
                        "Map symbols mark real places like roads, rivers, and towns."
                    ),
                    discoveryMCQ(
                        "What does distance on a map stand for?",
                        ["A longer real distance", "Only the color blue", "Only the thickness of ink"],
                        "A longer real distance",
                        "A short map distance stands for a longer distance in the real world."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "map",
                        definition: "A drawing that shows places and paths.",
                        exampleSentence: "A map can guide travel."
                    ),
                    VocabularyWord(
                        word: "symbol",
                        definition: "A mark that stands for something real.",
                        exampleSentence: "A blue line may be a river symbol."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Maps show places with symbols and scaled distances.",
                        explanation: "Map distance stands for longer real distance."
                    ),
                    KnowledgeFact(
                        fact: "Travelers use maps to plan safer routes.",
                        explanation: "Maps guide travel decisions."
                    )
                ],
                creativePrompt: "Draw a simple map with a road symbol and a river symbol.",
                storyEnding: "You found the map main idea like a careful navigator.",
                readingSkill: "Identify the main idea about maps guiding travel",
                reflectionPrompt: "How does a map help a traveler?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find symbols"
                ],
                commonMistakes: [
                    "Missing the scaled-picture main idea"
                ],
                successCriteria: [
                    "States the map main idea",
                    "Cites symbols or distance"
                ],
                learningObjectives: [
                    "Explain that maps are scaled pictures that guide travel",
                    "fp:discovery.Princesses.growingReader"
                ],
                activityFingerprint: "princesses.discovery.growing.maps"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Fair Rules as Agreements",
                storyOpening: "Movo sits in the castle hall as your science partner. Together you investigate how fair rules become shared agreements.",
                missionPrompt: "Use evidence from the notes. Explain why communities write fair rules.",
                readingPassage: "In a castle kingdom, fair rules are agreements a princess and her people share so games and duties stay clear. Written castle rules help everyone know the same expectations. When kingdom rules are fair, people can trust the process more. Unclear rules can cause confusion and conflict in the castle hall. Science of social living studies how agreements guide behavior. Clear shared rules support safer, kinder groups across the princess's kingdom.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about fair rules in a castle kingdom?",
                        ["They are shared agreements that make expectations clear", "They remove the need for any talking forever", "They only decorate paper"],
                        "They are shared agreements that make expectations clear",
                        "Fair rules are shared agreements with clear expectations."
                    ),
                    discoveryMCQ(
                        "What do written castle rules help everyone know?",
                        ["The same expectations", "Only secret codes nobody shares", "Only the color of the paint"],
                        "The same expectations",
                        "Written rules help everyone know the same expectations."
                    ),
                    discoveryMCQ(
                        "What can unclear rules cause in the castle hall?",
                        ["Confusion and conflict", "Perfect quiet agreement always", "Rules that write themselves"],
                        "Confusion and conflict",
                        "Unclear rules can cause confusion and conflict in the hall."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "agreement",
                        definition: "A shared decision people accept together.",
                        exampleSentence: "Fair kingdom rules are community agreements."
                    ),
                    VocabularyWord(
                        word: "expectation",
                        definition: "What people believe should happen.",
                        exampleSentence: "Clear castle rules set shared expectations."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Fair castle rules are shared agreements that clarify expectations in a kingdom.",
                        explanation: "Clear rules support trust for a princess and her people."
                    ),
                    KnowledgeFact(
                        fact: "Unclear rules can cause confusion and conflict in the castle hall.",
                        explanation: "Written kingdom rules help everyone know the same plan."
                    ),
                    KnowledgeFact(
                        fact: "Shared rules can support safer, kinder groups across a princess's kingdom.",
                        explanation: "Social agreements guide behavior."
                    )
                ],
                creativePrompt: "Write three sentences about one fair castle rule and why it helps a kingdom.",
                storyEnding: "You connected kingdom agreements to fairness like a careful investigator.",
                readingSkill: "Infer why fair rules support clear shared expectations",
                reflectionPrompt: "Which fair castle-rule idea from the notes would help your group most?",
                hints: [
                    "Compare clear kingdom rules with unclear rules",
                    "Reread shared agreements for the princess's people"
                ],
                commonMistakes: [
                    "Treating rules as only decoration"
                ],
                successCriteria: [
                    "Uses agreement evidence",
                    "Links clarity to less conflict"
                ],
                learningObjectives: [
                    "Infer how fair rules function as shared social agreements",
                    "fp:discovery.Princesses.confidentReader"
                ],
                activityFingerprint: "princesses.discovery.confident.fair-rules"
            )
        }
    }


    // MARK: - Castles Discovery

    private static func castlesDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Strong Stone Walls",
                storyOpening: "Movo presses a paw to an old castle wall. It feels cold and solid, built to last for hundreds of years.",
                missionPrompt: "Find one true fact about stone walls in the science notes.",
                readingPassage: "Castle walls were often built from stone. Stone is hard and strong. Soft mud alone cannot hold a tall wall well. Strong stone supports heavy walls. Blocks stacked high can hold towers that mud would crumble under.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what were castle walls often built from?",
                        ["Stone", "Only soft cloth", "Only piled leaves"],
                        "Stone",
                        "Castle walls were often built from hard stone."
                    ),
                    discoveryMCQ(
                        "What is stone like?",
                        ["Hard and strong", "Soft like a pillow", "Light as a feather always"],
                        "Hard and strong",
                        "Stone is hard and strong. That strength helps walls last."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "stone",
                        definition: "A hard rock material used in building.",
                        exampleSentence: "Stone walls can be strong."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Castle walls were often built from hard stone.",
                        explanation: "Stone is strong for tall walls."
                    ),
                    KnowledgeFact(
                        fact: "Soft mud alone cannot hold a tall wall well.",
                        explanation: "Material strength matters in building."
                    )
                ],
                creativePrompt: "Draw a stone wall, and label hard stone.",
                storyEnding: "You logged a real stone-strength fact. Great science work!",
                readingSkill: "Use a science note to name stone strength",
                reflectionPrompt: "Name one reason builders used stone.",
                hints: [
                    "Look for stone",
                    "Find hard and strong"
                ],
                commonMistakes: [
                    "Choosing a soft material as the wall answer"
                ],
                successCriteria: [
                    "Names stone",
                    "Uses hard or strong"
                ],
                learningObjectives: [
                    "Identify that stone is a strong building material for walls",
                    "fp:discovery.Castles.beginner"
                ],
                activityFingerprint: "castles.discovery.beginner.stone"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Arches Share Weight",
                storyOpening: "Movo points up at a stone arch. Look how the curve shares the weight so the opening stays strong!",
                missionPrompt: "Hunt for one true science fact about arches in the notes.",
                readingPassage: "An arch is a curved opening in a wall. The curve spreads weight outward to the sides. Strong sides support the top of the arch. A flat weak span may crack under heavy load. Arches help stone buildings carry weight.",
                questions: [
                    discoveryMCQ(
                        "What is an arch?",
                        ["A curved opening in a wall", "A flat square hole only", "A soft cloth doorway"],
                        "A curved opening in a wall",
                        "An arch is a curved opening that can carry weight around the gap."
                    ),
                    discoveryMCQ(
                        "What does the curve do to weight?",
                        ["Spreads weight outward to the sides", "Pushes all weight straight down through the gap", "Makes the stones float in the air"],
                        "Spreads weight outward to the sides",
                        "The curve spreads weight outward to the sides."
                    ),
                    discoveryMCQ(
                        "What may a flat weak span do under heavy load?",
                        ["Crack", "Grow stronger by itself", "Turn into soft sand"],
                        "Crack",
                        "A flat weak span may crack when a heavy load presses on it."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "arch",
                        definition: "A curved opening that can carry weight.",
                        exampleSentence: "The stone arch spreads weight."
                    ),
                    VocabularyWord(
                        word: "weight",
                        definition: "How heavy something is.",
                        exampleSentence: "Walls must support heavy weight."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Arches spread weight outward to the sides.",
                        explanation: "Curved openings help carry load."
                    ),
                    KnowledgeFact(
                        fact: "Strong sides support the top of an arch.",
                        explanation: "Weak flat spans may crack under heavy load."
                    )
                ],
                creativePrompt: "Draw an arch with arrows showing weight spreading to the sides.",
                storyEnding: "You used arch evidence carefully. Great science reading!",
                readingSkill: "Use evidence to explain how arches share weight",
                reflectionPrompt: "How does an arch help a stone wall?",
                hints: [
                    "Find curved opening",
                    "Look for spreads weight"
                ],
                commonMistakes: [
                    "Thinking arches only decorate"
                ],
                successCriteria: [
                    "Names the curved opening",
                    "Cites weight spreading"
                ],
                learningObjectives: [
                    "Explain that arches spread weight to the sides",
                    "fp:discovery.Castles.earlyReader"
                ],
                activityFingerprint: "castles.discovery.early.arches"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Drawbridge Levers",
                storyOpening: "Movo listens as a heavy drawbridge rises with a creak. A hinge acts like a clever pivot—come investigate!",
                missionPrompt: "Find the main idea about drawbridge levers. Use details from the notes.",
                readingPassage: "A drawbridge can work like a lever that lifts and lowers a heavy path. Chains or ropes pull one end while a hinge acts as a pivot. A small pull at the right place can move a large bridge. Without a pivot, the bridge would not swing cleanly. The main idea is that lever action helps people raise and lower a heavy drawbridge with controlled force.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Lever action helps people raise and lower a heavy drawbridge with controlled force", "Drawbridges float with no hinges", "Levers only decorate castle doors"],
                        "Lever action helps people raise and lower a heavy drawbridge with controlled force",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What can act as a pivot?",
                        ["A hinge", "A loose rope with no fixed point", "A painted line on the wall"],
                        "A hinge",
                        "A hinge acts as a pivot so a drawbridge can turn."
                    ),
                    discoveryMCQ(
                        "What can a small pull at the right place do?",
                        ["Move a large bridge", "Remove all stone", "Make the bridge heavier"],
                        "Move a large bridge",
                        "A small pull at the right place can move a large bridge."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "lever",
                        definition: "A bar that turns on a pivot to move a load.",
                        exampleSentence: "A drawbridge can work like a lever."
                    ),
                    VocabularyWord(
                        word: "pivot",
                        definition: "The point a lever turns around.",
                        exampleSentence: "The hinge is the pivot."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Drawbridges can work as levers with a hinge pivot.",
                        explanation: "Chains or ropes pull one end."
                    ),
                    KnowledgeFact(
                        fact: "A small pull at the right place can move a large bridge.",
                        explanation: "Lever action controls heavy motion."
                    )
                ],
                creativePrompt: "Draw a drawbridge with a hinge pivot and a pulling chain.",
                storyEnding: "You found the lever main idea like a careful engineer.",
                readingSkill: "Identify the main idea about drawbridge levers",
                reflectionPrompt: "How does a pivot help lift a drawbridge?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find hinge"
                ],
                commonMistakes: [
                    "Missing the lever main idea"
                ],
                successCriteria: [
                    "States the lever main idea",
                    "Cites pivot or pull"
                ],
                learningObjectives: [
                    "Explain how lever action raises and lowers a drawbridge",
                    "fp:discovery.Castles.growingReader"
                ],
                activityFingerprint: "castles.discovery.growing.drawbridge"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Moats and Access Control",
                storyOpening: "Movo joins your castle science team. Together you investigate how water barriers change castle access.",
                missionPrompt: "Use evidence from the notes. Explain how a moat changes who can approach a castle.",
                readingPassage: "A moat is a water-filled ditch around a castle. Crossing water is harder than walking on dry ground. Bridges and gates become controlled entry points. Attackers must plan around the water barrier. Defenders gain time because approaches are limited. A moat does not stop every threat, but it shapes access using water as a barrier. Design and place work together for defense.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about a moat?",
                        ["It shapes access by making water a barrier around limited entry points", "It removes the need for any walls", "It makes every wall disappear"],
                        "It shapes access by making water a barrier around limited entry points",
                        "A moat limits approaches so bridges and gates become the main entry points."
                    ),
                    discoveryMCQ(
                        "What is a moat?",
                        ["A water-filled ditch around a castle", "A dry empty trench with no water", "A tall wooden fence only"],
                        "A water-filled ditch around a castle",
                        "A moat is a water-filled ditch that surrounds a castle."
                    ),
                    discoveryMCQ(
                        "What become controlled entry points?",
                        ["Bridges and gates", "Only distant hilltops", "Only the castle kitchens"],
                        "Bridges and gates",
                        "Bridges and gates become the controlled ways in and out."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "moat",
                        definition: "A water-filled ditch around a castle.",
                        exampleSentence: "The moat surrounds the walls."
                    ),
                    VocabularyWord(
                        word: "barrier",
                        definition: "Something that blocks or slows a path.",
                        exampleSentence: "Water acts as a barrier."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A moat is a water-filled ditch that makes approach harder.",
                        explanation: "Crossing water is harder than dry ground."
                    ),
                    KnowledgeFact(
                        fact: "Bridges and gates become controlled entry points.",
                        explanation: "Limited approaches give defenders time."
                    ),
                    KnowledgeFact(
                        fact: "A moat shapes access but does not stop every threat.",
                        explanation: "Design and place work together for defense."
                    )
                ],
                creativePrompt: "Draw a castle with a moat and one bridge entry, and label barrier.",
                storyEnding: "You connected water barriers to access like a careful investigator.",
                readingSkill: "Infer how moats control castle access",
                reflectionPrompt: "Which moat clue from the notes best explains defense?",
                hints: [
                    "Compare dry ground with water",
                    "Reread bridges and gates"
                ],
                commonMistakes: [
                    "Claiming a moat stops every threat always"
                ],
                successCriteria: [
                    "Uses barrier evidence",
                    "Links limited entry to defense"
                ],
                learningObjectives: [
                    "Infer how moats shape access using water barriers",
                    "fp:discovery.Castles.confidentReader"
                ],
                activityFingerprint: "castles.discovery.confident.moats"
            )
        }
    }


    // MARK: - Fairies Discovery

    private static func fairiesDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Seed Parachutes",
                storyOpening: "Movo tiptoes through a fairy garden. Some seeds wear fluffy tops and drift away like tiny parachutes on the breeze.",
                missionPrompt: "Hunt for one true science fact about seed parachutes in the notes.",
                readingPassage: "In the fairy garden, some seeds have fluffy tops like tiny parachutes. Wind can carry those fairy seeds far across the leaf tips. A heavy seed without fluff falls sooner onto the soil. Light fluff helps fairy seeds travel on soft wing-like fluff. One puff of wind can send a fluffy seed farther than you can throw.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what can wind carry far?",
                        ["Fairy seeds with fluffy tops", "Only heavy rocks", "Only wet clay clumps"],
                        "Fairy seeds with fluffy tops",
                        "Wind can carry fluffy fairy seeds far because they are light."
                    ),
                    discoveryMCQ(
                        "What helps fairy seeds travel?",
                        ["Light fluff", "Heavy stone shells", "Thick wet mud coats"],
                        "Light fluff",
                        "Light fluff helps fairy seeds catch the wind and travel."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "seed",
                        definition: "A part that can grow into a new plant.",
                        exampleSentence: "A fluffy fairy seed can ride the wind across the garden."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Some fairy-garden seeds have fluffy tops that act like parachutes.",
                        explanation: "Wind can carry those seeds far across the leaf tips."
                    ),
                    KnowledgeFact(
                        fact: "Light fluff helps fairy seeds travel while heavy seeds fall sooner onto the soil.",
                        explanation: "Shape and weight affect how a fairy seed travels."
                    )
                ],
                creativePrompt: "Draw a fluffy fairy seed floating above a garden leaf, and label parachute.",
                storyEnding: "You logged a real fairy-garden seed-travel fact. Great science work!",
                readingSkill: "Use a science note to explain seed parachutes",
                reflectionPrompt: "Name one thing that helps a fairy seed travel on wind.",
                hints: [
                    "Look for fluffy tops in the fairy garden",
                    "Find wind"
                ],
                commonMistakes: [
                    "Choosing heavy rocks as wind travelers"
                ],
                successCriteria: [
                    "Names fluffy seeds",
                    "Uses a wind fact"
                ],
                learningObjectives: [
                    "Identify that fluffy seeds can travel on wind",
                    "fp:discovery.Fairies.beginner"
                ],
                activityFingerprint: "fairies.discovery.beginner.seed-parachutes"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Firefly Light",
                storyOpening: "Movo gasps at tiny lights blinking in the dusk garden. They are cool, not hot like a flame—come wonder why!",
                missionPrompt: "Hunt for one true science fact about firefly light in the notes.",
                readingPassage: "In the magic garden, fireflies glow near fairy wings at dusk. Fireflies can make their own light. A chemical reaction in the body releases light energy. The cool glow can help fireflies find each other among the garden leaves. Firefly light is cool, not a hot flame. Living chemistry can create a gentle glow for fairy friends watching nearby.",
                questions: [
                    discoveryMCQ(
                        "What can fireflies make in the magic garden?",
                        ["Their own light", "Only heat with no glow", "Only sound with no light"],
                        "Their own light",
                        "Fireflies make their own light inside their bodies."
                    ),
                    discoveryMCQ(
                        "What releases light energy in a firefly?",
                        ["A chemical reaction in the body", "A tiny store-bought battery", "Only reflected moonlight"],
                        "A chemical reaction in the body",
                        "A chemical reaction in the firefly's body releases light energy."
                    ),
                    discoveryMCQ(
                        "What is firefly light like near fairy wings?",
                        ["Cool, not a hot flame", "Hot like a campfire flame", "Made of dry sand only"],
                        "Cool, not a hot flame",
                        "Firefly light is cool, not a hot flame."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "firefly",
                        definition: "An insect that can make its own light.",
                        exampleSentence: "A firefly glows near fairy wings in the magic garden."
                    ),
                    VocabularyWord(
                        word: "chemical reaction",
                        definition: "A change that makes new materials or energy.",
                        exampleSentence: "A chemical reaction can release light for fairy friends to see."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Fireflies make light with a chemical reaction in their bodies.",
                        explanation: "The glow can help them find each other among garden leaves."
                    ),
                    KnowledgeFact(
                        fact: "Firefly light is cool, not a hot flame, even beside fairy wings.",
                        explanation: "Living chemistry can create a gentle glow in the magic garden."
                    )
                ],
                creativePrompt: "Draw a firefly with a soft glow near fairy wings in a magic garden, and label cool light.",
                storyEnding: "You used fairy-garden firefly light evidence carefully.",
                readingSkill: "Use evidence to explain firefly light",
                reflectionPrompt: "How do fireflies make light without a hot flame in the magic garden?",
                hints: [
                    "Find chemical reaction",
                    "Look for cool light near fairy wings"
                ],
                commonMistakes: [
                    "Thinking firefly light is a hot flame"
                ],
                successCriteria: [
                    "States fireflies make light",
                    "Cites chemical reaction or cool glow"
                ],
                learningObjectives: [
                    "Explain that fireflies make cool light with chemistry",
                    "fp:discovery.Fairies.earlyReader"
                ],
                activityFingerprint: "fairies.discovery.early.firefly"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Insect Wings",
                storyOpening: "Movo watches fairy-garden insects hover. They beat their wings so fast the air pushes them up—let's study lift!",
                missionPrompt: "Find the main idea about insect wings. Use details from the notes.",
                readingPassage: "Many insects have thin wings that beat quickly. Fast wing beats push air and create lift. Light bodies help insects stay aloft. Torn wings make flight harder. The main idea is that insect wings move air to support flight.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Insect wings move air to support flight", "Insect wings only decorate and never fly", "Insects fly without moving air"],
                        "Insect wings move air to support flight",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What do fast wing beats create?",
                        ["Lift", "Only downward pull with no rise", "Only stillness in the air"],
                        "Lift",
                        "Fast wing beats push air and create lift."
                    ),
                    discoveryMCQ(
                        "What makes flight harder?",
                        ["Torn wings", "Only bright sunshine", "Only soft grass"],
                        "Torn wings",
                        "Torn wings make it harder to push air and stay aloft."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "wing",
                        definition: "A body part used for flying.",
                        exampleSentence: "Insect wings beat quickly."
                    ),
                    VocabularyWord(
                        word: "lift",
                        definition: "An upward force that helps flying.",
                        exampleSentence: "Wing beats can create lift."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Fast insect wing beats push air and create lift.",
                        explanation: "Light bodies help insects stay aloft."
                    ),
                    KnowledgeFact(
                        fact: "Torn wings make flight harder.",
                        explanation: "Healthy wing motion supports flight."
                    )
                ],
                creativePrompt: "Draw an insect with wing-beat arrows pushing air, and label lift.",
                storyEnding: "You found the wing main idea like a careful flight scientist.",
                readingSkill: "Identify the main idea about insect wings and lift",
                reflectionPrompt: "How do insect wings help an insect stay up?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find lift"
                ],
                commonMistakes: [
                    "Missing the move-air main idea"
                ],
                successCriteria: [
                    "States the wing main idea",
                    "Cites lift or wing beats"
                ],
                learningObjectives: [
                    "Explain that insect wings move air to create lift",
                    "fp:discovery.Fairies.growingReader"
                ],
                activityFingerprint: "fairies.discovery.growing.insect-wings"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Pollen on the Move",
                storyOpening: "Movo becomes your garden science partner. Together you investigate how pollen helps plants reproduce.",
                missionPrompt: "Use evidence from the notes. Explain why pollen travel matters for plants.",
                readingPassage: "Pollen is a powdery material from flowers. Insects may carry pollen from one flower to another as they feed. Wind can also move lightweight pollen. When pollen reaches the right flower part, a seed can begin. Plants that share pollen can make the next generation. Travel of pollen links insects, wind, and plant life cycles.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about pollen travel?",
                        ["It helps plants make seeds for the next generation", "It only decorates insect wings forever", "It removes all flowers"],
                        "It helps plants make seeds for the next generation",
                        "Pollen travel links to seed beginnings."
                    ),
                    discoveryMCQ(
                        "What may insects carry from flower to flower?",
                        ["Pollen", "Only stone chips", "Only drops of metal"],
                        "Pollen",
                        "Insects may carry pollen from flower to flower."
                    ),
                    discoveryMCQ(
                        "What can begin when pollen reaches the right flower part?",
                        ["A seed", "A metal spoon", "A glass window"],
                        "A seed",
                        "A seed can begin when pollen reaches the right flower part."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "pollen",
                        definition: "A powdery flower material that can help make seeds.",
                        exampleSentence: "Bees may carry pollen."
                    ),
                    VocabularyWord(
                        word: "generation",
                        definition: "A new group of living things that comes next.",
                        exampleSentence: "Seeds grow the next plant generation."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Insects and wind can move pollen between flowers.",
                        explanation: "Pollen travel supports plant reproduction."
                    ),
                    KnowledgeFact(
                        fact: "When pollen reaches the right flower part, a seed can begin.",
                        explanation: "Pollen links to the next generation."
                    ),
                    KnowledgeFact(
                        fact: "Pollen is a powdery material from flowers.",
                        explanation: "Lightweight pollen can ride the wind."
                    )
                ],
                creativePrompt: "Write three sentences about how an insect helps move pollen.",
                storyEnding: "You connected pollen travel to plant life like a careful investigator.",
                readingSkill: "Infer why pollen travel matters for plant life cycles",
                reflectionPrompt: "Which pollen clue from the notes would you study outside?",
                hints: [
                    "Follow flower to insect to seed",
                    "Reread next generation"
                ],
                commonMistakes: [
                    "Treating pollen as only decoration"
                ],
                successCriteria: [
                    "Uses pollen travel evidence",
                    "Links pollen to seeds"
                ],
                learningObjectives: [
                    "Infer how pollen travel supports plant reproduction",
                    "fp:discovery.Fairies.confidentReader"
                ],
                activityFingerprint: "fairies.discovery.confident.pollen"
            )
        }
    }


    // MARK: - Airplanes Discovery

    private static func airplanesDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Wings and Lift",
                storyOpening: "Movo stares up at a heavy plane. How can it rise into the sky? Its wings push on the air in a special way.",
                missionPrompt: "Spot one true fact about lift from the science notes.",
                readingPassage: "Airplane wings help create lift. Lift is an upward push from air. Wings need moving air to work well. Lift helps a plane rise. Fast air over the wings can lift something as heavy as a school bus.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what do airplane wings help create?",
                        ["Lift", "Only extra weight with no rise", "Only heat from the engines"],
                        "Lift",
                        "Airplane wings help create lift that holds the plane up."
                    ),
                    discoveryMCQ(
                        "What is lift?",
                        ["An upward push from air", "A downward pile of rocks", "A push that only moves the plane sideways"],
                        "An upward push from air",
                        "Lift is an upward push from air on the wings."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "lift",
                        definition: "An upward push that helps a plane rise.",
                        exampleSentence: "Wings help create lift."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Airplane wings help create lift.",
                        explanation: "Lift is an upward push from air."
                    ),
                    KnowledgeFact(
                        fact: "Wings need moving air to work well.",
                        explanation: "Lift helps a plane rise."
                    )
                ],
                creativePrompt: "Draw a plane wing with an up arrow labeled lift.",
                storyEnding: "You logged a real lift fact. Great science work!",
                readingSkill: "Use a science note to name lift",
                reflectionPrompt: "Name one thing wings help create.",
                hints: [
                    "Look for lift",
                    "Find upward push"
                ],
                commonMistakes: [
                    "Choosing a downward-only claim"
                ],
                successCriteria: [
                    "Names lift",
                    "Uses upward push"
                ],
                learningObjectives: [
                    "Identify that wings help create upward lift",
                    "fp:discovery.Airplanes.beginner"
                ],
                activityFingerprint: "airplanes.discovery.beginner.lift"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Wing Shape Matters",
                storyOpening: "Movo traces a wing's curve with you. Air races differently above and below that shape—come see why it matters!",
                missionPrompt: "Hunt for one true fact about wing shape in the notes.",
                readingPassage: "Wing shape guides how air flows above and below. Faster air over a curved top can relate to lower pressure. The pressure difference can add to lift. Flat boards without careful shape lift less well. Engineers design wings for flight.",
                questions: [
                    discoveryMCQ(
                        "What does wing shape guide?",
                        ["How air flows above and below", "Only the color of the paint", "Only the smell of fuel"],
                        "How air flows above and below",
                        "Wing shape guides how air flows above and below the wing."
                    ),
                    discoveryMCQ(
                        "What can a pressure difference add to?",
                        ["Lift", "Only cabin noise", "Only runway length"],
                        "Lift",
                        "A pressure difference above and below the wing can add to lift."
                    ),
                    discoveryMCQ(
                        "What lift less well than carefully shaped wings?",
                        ["Flat boards without careful shape", "All curved wings always", "Moving air itself"],
                        "Flat boards without careful shape",
                        "Flat boards without careful shape lift less well."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "pressure",
                        definition: "How hard air pushes on a surface.",
                        exampleSentence: "Pressure differences can help lift."
                    ),
                    VocabularyWord(
                        word: "engineer",
                        definition: "A person who designs machines or structures.",
                        exampleSentence: "Engineers design airplane wings."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Wing shape guides air flow above and below the wing.",
                        explanation: "Shape matters for lift."
                    ),
                    KnowledgeFact(
                        fact: "Pressure differences around a wing can add to lift.",
                        explanation: "Engineers design wings for flight."
                    )
                ],
                creativePrompt: "Draw a curved wing with air arrows above and below.",
                storyEnding: "You used wing-shape evidence carefully.",
                readingSkill: "Use evidence to explain wing shape and lift",
                reflectionPrompt: "Why does wing shape matter for flight?",
                hints: [
                    "Find air flows",
                    "Look for pressure"
                ],
                commonMistakes: [
                    "Thinking any flat board flies the same"
                ],
                successCriteria: [
                    "States shape guides air flow",
                    "Cites pressure or lift"
                ],
                learningObjectives: [
                    "Explain that wing shape affects air flow and lift",
                    "fp:discovery.Airplanes.earlyReader"
                ],
                activityFingerprint: "airplanes.discovery.early.wing-shape"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Thrust Moves Forward",
                storyOpening: "Movo covers its ears as engines roar. That thrust pushes the plane forward so wings can keep making lift.",
                missionPrompt: "Find the main idea about thrust. Use details from the notes.",
                readingPassage: "Engines create thrust that pushes an airplane forward. Forward motion sends air over the wings. Wings need that moving air to keep making lift. Without thrust, a plane cannot keep steady flight for long. The main idea is that thrust provides forward motion that supports continued lift.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Thrust provides forward motion that supports continued lift", "Thrust only paints the wings", "Planes fly with no forward motion"],
                        "Thrust provides forward motion that supports continued lift",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What do engines create?",
                        ["Thrust that pushes an airplane forward", "Only sideways spinning with no push", "Only cabin lighting"],
                        "Thrust that pushes an airplane forward",
                        "Engines create thrust that pushes the airplane forward."
                    ),
                    discoveryMCQ(
                        "What do wings need to keep making lift?",
                        ["Moving air", "Still air that never flows", "Only dry sand on the runway"],
                        "Moving air",
                        "Wings need moving air to keep making lift."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "thrust",
                        definition: "A forward push from engines.",
                        exampleSentence: "Engine thrust moves the plane forward."
                    ),
                    VocabularyWord(
                        word: "motion",
                        definition: "Movement from one place to another.",
                        exampleSentence: "Forward motion sends air over wings."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Airplane engines create thrust for forward motion.",
                        explanation: "Moving air over wings supports lift."
                    ),
                    KnowledgeFact(
                        fact: "Without thrust, a plane cannot keep steady flight for long.",
                        explanation: "Thrust and lift work together."
                    )
                ],
                creativePrompt: "Draw a plane with a forward thrust arrow and lift arrow.",
                storyEnding: "You found the thrust main idea like a careful flight scientist.",
                readingSkill: "Identify the main idea about thrust and continued lift",
                reflectionPrompt: "How does thrust help wings keep making lift?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find forward motion"
                ],
                commonMistakes: [
                    "Missing the thrust-and-lift link"
                ],
                successCriteria: [
                    "States the thrust main idea",
                    "Cites moving air over wings"
                ],
                learningObjectives: [
                    "Explain that thrust provides forward motion for continued lift",
                    "fp:discovery.Airplanes.growingReader"
                ],
                activityFingerprint: "airplanes.discovery.growing.thrust"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Air Resistance",
                storyOpening: "Movo joins your flight science team. Together you investigate how air resistance shapes airplane design.",
                missionPrompt: "Use evidence from the notes. Explain why airplane shapes try to reduce air resistance.",
                readingPassage: "Air resistance is a push of air that opposes motion. A blunt shape hits more air and slows more. A smoother pointed shape can slip through air with less drag. Engines must work harder against high resistance. Designers balance lift needs with lower drag. Efficient flight depends on managing air resistance as well as creating lift and thrust.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about airplane shape?",
                        ["Smoother shapes can reduce air resistance during flight", "Blunt shapes always fly with less drag", "Air resistance never opposes motion"],
                        "Smoother shapes can reduce air resistance during flight",
                        "Smoother pointed shapes can slip through with less drag."
                    ),
                    discoveryMCQ(
                        "What is air resistance?",
                        ["A push of air that opposes motion", "A pull that removes gravity", "A force that only increases lift"],
                        "A push of air that opposes motion",
                        "Air resistance is a push of air that opposes the plane's motion."
                    ),
                    discoveryMCQ(
                        "What must engines do against high resistance?",
                        ["Work harder", "Use less fuel instead", "Stop making thrust"],
                        "Work harder",
                        "Engines must work harder against high resistance."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "resistance",
                        definition: "A force that opposes motion through air.",
                        exampleSentence: "Air resistance can slow a plane."
                    ),
                    VocabularyWord(
                        word: "drag",
                        definition: "Another word for air resistance on a moving object.",
                        exampleSentence: "Lower drag helps efficient flight."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Air resistance opposes airplane motion.",
                        explanation: "Blunt shapes hit more air and slow more."
                    ),
                    KnowledgeFact(
                        fact: "Smoother pointed shapes can reduce drag.",
                        explanation: "Engines work harder against high resistance."
                    ),
                    KnowledgeFact(
                        fact: "Designers balance lift needs with lower drag.",
                        explanation: "Efficient flight manages air resistance."
                    )
                ],
                creativePrompt: "Draw a blunt shape and a smooth shape, and label more drag and less drag.",
                storyEnding: "You connected shape to air resistance like a careful investigator.",
                readingSkill: "Infer why shapes that reduce drag support efficient flight",
                reflectionPrompt: "Which air-resistance clue from the notes would you test with paper planes?",
                hints: [
                    "Compare blunt with smooth",
                    "Reread engines work harder"
                ],
                commonMistakes: [
                    "Claiming resistance never matters"
                ],
                successCriteria: [
                    "Uses resistance evidence",
                    "Links smoother shape to less drag"
                ],
                learningObjectives: [
                    "Infer how reducing air resistance supports efficient flight",
                    "fp:discovery.Airplanes.confidentReader"
                ],
                activityFingerprint: "airplanes.discovery.confident.drag"
            )
        }
    }


    // MARK: - Trains Discovery

    private static func trainsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Wheels on Tracks",
                storyOpening: "Movo watches a long train stay on one thin path. Metal wheels roll on metal rails—come see how!",
                missionPrompt: "Find one true science fact about tracks in the notes.",
                readingPassage: "Train wheels roll on metal tracks. Tracks guide the train path. Smooth rails help wheels roll. Tracks keep the train on course. Steel rails can stretch for miles without a bend that would tip the cars.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, where do train wheels roll?",
                        ["On metal tracks", "Only on loose sand with no rails", "Only on open grass with no rails"],
                        "On metal tracks",
                        "Train wheels roll on metal tracks that guide the train."
                    ),
                    discoveryMCQ(
                        "What do tracks do?",
                        ["Guide the train path", "Lift the train off the rails", "Make the wheels spin backward"],
                        "Guide the train path",
                        "Tracks guide the train path."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "track",
                        definition: "A metal rail path for trains.",
                        exampleSentence: "Train wheels roll on the track."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Train wheels roll on metal tracks that guide the path.",
                        explanation: "Tracks keep the train on course."
                    ),
                    KnowledgeFact(
                        fact: "Smooth rails help wheels roll.",
                        explanation: "Guided rails support train motion."
                    )
                ],
                creativePrompt: "Draw train wheels on two rails, and label track.",
                storyEnding: "You logged a real track fact. Great science work!",
                readingSkill: "Use a science note to explain wheels on tracks",
                reflectionPrompt: "Name one job tracks do for a train.",
                hints: [
                    "Look for metal tracks",
                    "Find guide"
                ],
                commonMistakes: [
                    "Choosing clouds as the rolling surface"
                ],
                successCriteria: [
                    "Names metal tracks",
                    "Uses a guide fact"
                ],
                learningObjectives: [
                    "Identify that train wheels roll on guiding metal tracks",
                    "fp:discovery.Trains.beginner"
                ],
                activityFingerprint: "trains.discovery.beginner.tracks"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Friction on Rails",
                storyOpening: "Movo peeks at steel wheels on steel rails. They look slippery—yet that low friction helps the train roll.",
                missionPrompt: "Hunt for one true science fact about rail friction in the notes.",
                readingPassage: "Steel wheels on steel rails have low friction when rolling. Low friction helps a train coast with less drag. Brakes increase friction to slow the train. Wet leaves on rails can change grip. Friction control starts and stops train motion.",
                questions: [
                    discoveryMCQ(
                        "What do steel wheels on steel rails have when rolling?",
                        ["Low friction", "Endless sticky glue grip", "Only rubber tire tread"],
                        "Low friction",
                        "Steel wheels on steel rails have low friction when rolling."
                    ),
                    discoveryMCQ(
                        "What do brakes do to friction?",
                        ["Increase friction to slow the train", "Make the rails extra slippery", "Make the train speed up"],
                        "Increase friction to slow the train",
                        "Brakes increase friction to slow the train."
                    ),
                    discoveryMCQ(
                        "What can wet leaves on rails change?",
                        ["Grip", "Only the color of the sky", "Only the smell of fuel"],
                        "Grip",
                        "Wet leaves on rails can change grip and make wheels slip."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "friction",
                        definition: "A force that resists sliding between surfaces.",
                        exampleSentence: "Brakes use friction to slow a train."
                    ),
                    VocabularyWord(
                        word: "brake",
                        definition: "A device that slows or stops motion.",
                        exampleSentence: "Train brakes increase friction."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Steel wheels on steel rails roll with low friction.",
                        explanation: "Low friction helps coasting."
                    ),
                    KnowledgeFact(
                        fact: "Brakes increase friction to slow a train.",
                        explanation: "Friction control starts and stops motion."
                    )
                ],
                creativePrompt: "Draw wheels on rails with a brake label for more friction.",
                storyEnding: "You used friction evidence carefully.",
                readingSkill: "Use evidence to explain rail friction and brakes",
                reflectionPrompt: "How do brakes use friction on a train?",
                hints: [
                    "Find low friction",
                    "Look for brakes"
                ],
                commonMistakes: [
                    "Thinking trains never need friction"
                ],
                successCriteria: [
                    "States low rolling friction",
                    "Cites brakes increasing friction"
                ],
                learningObjectives: [
                    "Explain how friction helps trains roll and stop",
                    "fp:discovery.Trains.earlyReader"
                ],
                activityFingerprint: "trains.discovery.early.friction"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Engine Energy",
                storyOpening: "Movo cheers as a long train starts to move. Fuel or electricity feeds the engine that pushes—let's find the energy!",
                missionPrompt: "Find the main idea about engine energy. Use details from the notes.",
                readingPassage: "A train engine changes stored energy into motion. Fuel or electricity can supply that energy. The engine turns wheels that push against the track. Without energy input, the train slows from friction and air resistance. The main idea is that engines supply energy so trains can keep moving against opposing forces.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Engines supply energy so trains can keep moving against opposing forces", "Trains move forever with no energy", "Engines only decorate the front car"],
                        "Engines supply energy so trains can keep moving against opposing forces",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What can supply energy to a train engine?",
                        ["Fuel or electricity", "Only painted logos", "Only quiet station lights"],
                        "Fuel or electricity",
                        "Fuel or electricity can supply energy to a train engine."
                    ),
                    discoveryMCQ(
                        "What happens without energy input?",
                        ["The train slows from friction and air resistance", "The train keeps rolling just as fast", "The train needs no wheels"],
                        "The train slows from friction and air resistance",
                        "If the engine gets no energy, the train slows down."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "engine",
                        definition: "A machine that supplies energy for motion.",
                        exampleSentence: "The train engine turns the wheels."
                    ),
                    VocabularyWord(
                        word: "energy",
                        definition: "The ability to make things move or change.",
                        exampleSentence: "Fuel stores energy for the engine."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Train engines change stored energy into motion.",
                        explanation: "Fuel or electricity can supply energy."
                    ),
                    KnowledgeFact(
                        fact: "Without energy input, trains slow from friction and air resistance.",
                        explanation: "Engines overcome opposing forces."
                    )
                ],
                creativePrompt: "Draw an engine car with an arrow from energy to wheel motion.",
                storyEnding: "You found the engine-energy main idea like a careful engineer.",
                readingSkill: "Identify the main idea about engines supplying motion energy",
                reflectionPrompt: "Why does a train need ongoing energy input?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find opposing forces"
                ],
                commonMistakes: [
                    "Missing the energy main idea"
                ],
                successCriteria: [
                    "States the engine-energy main idea",
                    "Cites fuel, electricity, or slowing"
                ],
                learningObjectives: [
                    "Explain that engines supply energy for continued train motion",
                    "fp:discovery.Trains.growingReader"
                ],
                activityFingerprint: "trains.discovery.growing.engine-energy"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Momentum on the Rails",
                storyOpening: "Movo joins your rail science team. Together you investigate how mass and speed change stopping distance.",
                missionPrompt: "Use evidence from the notes. Explain why heavy fast trains need long stopping distances.",
                readingPassage: "Momentum is the combination of mass and speed that keeps an object moving. A heavy train at high speed has large momentum. Large momentum means brakes need more distance to stop safely. Slippery rails can reduce braking friction and lengthen stopping distance further. Engineers plan for momentum when they set speed limits near stations. Safe train travel respects momentum science.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about heavy fast trains?",
                        ["They need longer distances to stop because of large momentum", "They stop instantly with no distance", "Momentum never affects braking"],
                        "They need longer distances to stop because of large momentum",
                        "Large momentum means more stopping distance."
                    ),
                    discoveryMCQ(
                        "What is momentum a combination of?",
                        ["Mass and speed", "Only color and smell", "Only the ticket design"],
                        "Mass and speed",
                        "Momentum combines mass and speed, so heavy fast trains are harder to stop."
                    ),
                    discoveryMCQ(
                        "What can slippery rails do?",
                        ["Reduce braking friction and lengthen stopping distance", "Remove all mass from the train", "Turn rails into soft clay"],
                        "Reduce braking friction and lengthen stopping distance",
                        "Slippery rails can lengthen stopping distance."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "momentum",
                        definition: "How hard it is to stop a moving object, based on mass and speed.",
                        exampleSentence: "A fast heavy train has large momentum."
                    ),
                    VocabularyWord(
                        word: "mass",
                        definition: "How much matter is in an object.",
                        exampleSentence: "A heavy train has large mass."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Momentum depends on mass and speed.",
                        explanation: "Heavy fast trains have large momentum."
                    ),
                    KnowledgeFact(
                        fact: "Large momentum means longer safe stopping distances.",
                        explanation: "Brakes need distance to overcome momentum."
                    ),
                    KnowledgeFact(
                        fact: "Slippery rails can reduce braking friction.",
                        explanation: "Engineers plan speed limits near stations."
                    )
                ],
                creativePrompt: "Write three sentences about why a heavy train needs space to stop.",
                storyEnding: "You connected momentum to stopping distance like a careful investigator.",
                readingSkill: "Infer why momentum affects train stopping distance",
                reflectionPrompt: "Which momentum clue from the notes would you tell a new engineer?",
                hints: [
                    "Join mass with speed",
                    "Reread stopping distance"
                ],
                commonMistakes: [
                    "Claiming heavy trains stop instantly"
                ],
                successCriteria: [
                    "Uses momentum evidence",
                    "Links speed or mass to stopping distance"
                ],
                learningObjectives: [
                    "Infer how mass and speed create momentum that lengthens stopping distance",
                    "fp:discovery.Trains.confidentReader"
                ],
                activityFingerprint: "trains.discovery.confident.momentum"
            )
        }
    }


    // MARK: - Cars Discovery

    private static func carsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Wheels Roll",
                storyOpening: "Movo spins a round wheel and grins. Wheels look simple, but they are a clever trick for moving with less drag.",
                missionPrompt: "Catch one true fact about why wheels are round from the notes.",
                readingPassage: "Car wheels are round so they can roll. Rolling reduces rubbing on the road. Round wheels help a car move. Flat blocks would drag more. One roll turns a hard scrape into a smooth ride.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, why are car wheels round?",
                        ["So they can roll", "So they can float above the ground", "So they can stick and never roll"],
                        "So they can roll",
                        "Car wheels are round so they can roll along the road."
                    ),
                    discoveryMCQ(
                        "What does rolling reduce?",
                        ["Rubbing on the road", "Only the engine's heat", "Only the car's paint color"],
                        "Rubbing on the road",
                        "Rolling reduces rubbing on the road compared with sliding."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "roll",
                        definition: "To move by turning over and over.",
                        exampleSentence: "Round wheels roll on the road."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Round car wheels roll to reduce rubbing on the road.",
                        explanation: "Rolling helps cars move."
                    ),
                    KnowledgeFact(
                        fact: "Flat blocks would drag more than round wheels.",
                        explanation: "Shape matters for easy motion."
                    )
                ],
                creativePrompt: "Draw a round wheel and a flat block, and label roll and drag.",
                storyEnding: "You logged a real wheel fact. Great science work!",
                readingSkill: "Use a science note to explain why wheels are round",
                reflectionPrompt: "Name one reason round wheels help a car.",
                hints: [
                    "Look for round",
                    "Find rubbing"
                ],
                commonMistakes: [
                    "Choosing flat blocks as better rollers"
                ],
                successCriteria: [
                    "Names rolling",
                    "Uses reduced rubbing"
                ],
                learningObjectives: [
                    "Identify that round wheels roll to reduce road rubbing",
                    "fp:discovery.Cars.beginner"
                ],
                activityFingerprint: "cars.discovery.beginner.wheels"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Brakes Use Friction",
                storyOpening: "Movo pretends to press a brake pedal with you. Pads squeeze a spinning part—friction slows the car.",
                missionPrompt: "Hunt for one true science fact about brakes in the notes.",
                readingPassage: "Car brakes slow a car by increasing friction. Brake pads press against a spinning part on the wheel. Rubbing turns motion energy into heat. More friction means a faster slowdown for the cars on the road. Wet roads can lower tire grip and make stopping harder.",
                questions: [
                    discoveryMCQ(
                        "How do brakes slow a car?",
                        ["By increasing friction", "By removing all roads", "By turning cars into birds"],
                        "By increasing friction",
                        "Brakes slow a car by increasing friction on spinning parts."
                    ),
                    discoveryMCQ(
                        "What do brake pads press against?",
                        ["A spinning part", "Only the seat cushions", "Only the side mirrors"],
                        "A spinning part",
                        "Brake pads press against a spinning part to slow the wheels."
                    ),
                    discoveryMCQ(
                        "What can wet roads lower?",
                        ["Tire grip", "Only the color blue", "Only engine paint"],
                        "Tire grip",
                        "Wet roads can lower tire grip so cars slide more easily."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "brake",
                        definition: "A device that slows or stops a car.",
                        exampleSentence: "Brakes use friction to slow the car."
                    ),
                    VocabularyWord(
                        word: "friction",
                        definition: "A force that resists sliding between surfaces.",
                        exampleSentence: "More friction slows the car."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Car brakes increase friction to slow the vehicle.",
                        explanation: "Rubbing turns motion energy into heat."
                    ),
                    KnowledgeFact(
                        fact: "Wet roads can lower tire grip and make stopping harder.",
                        explanation: "Friction at tires also matters for stopping."
                    )
                ],
                creativePrompt: "Draw brake pads pressing a spinning disk, and label friction.",
                storyEnding: "You used brake-friction evidence carefully.",
                readingSkill: "Use evidence to explain braking friction",
                reflectionPrompt: "What happens to motion energy when brakes rub?",
                hints: [
                    "Find increasing friction",
                    "Look for heat"
                ],
                commonMistakes: [
                    "Thinking brakes work with no friction"
                ],
                successCriteria: [
                    "States brakes increase friction",
                    "Cites heat or wet-road grip"
                ],
                learningObjectives: [
                    "Explain that brakes slow cars by increasing friction",
                    "fp:discovery.Cars.earlyReader"
                ],
                activityFingerprint: "cars.discovery.early.brakes"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Seatbelts and Force",
                storyOpening: "Movo clicks a seatbelt and nods. It holds you across a wider area so a sudden stop feels safer.",
                missionPrompt: "Find the main idea about seatbelts. Use details from the notes.",
                readingPassage: "When a car stops suddenly, your body still tends to keep moving forward. A seatbelt in cars applies a holding force across a wider area. That force slows your body with the car. Without a belt, a sudden stop can throw a body forward toward the dashboard. The main idea is that seatbelts manage force during a sudden stop to keep riders safer in cars.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Seatbelts manage force during a sudden stop to keep riders safer", "Seatbelts only decorate seats", "Sudden stops never involve force"],
                        "Seatbelts manage force during a sudden stop to keep riders safer",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What does your body tend to do when a car stops suddenly?",
                        ["Keep moving forward", "Slow down too quickly", "Slide without stopping"],
                        "Keep moving forward",
                        "The body tends to keep moving forward."
                    ),
                    discoveryMCQ(
                        "How does a seatbelt apply holding force?",
                        ["Across a wider area", "Only on one tiny hair", "Only through loud music"],
                        "Across a wider area",
                        "A seatbelt spreads holding force across a wider area of the body."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "seatbelt",
                        definition: "A strap that holds a rider during a sudden stop.",
                        exampleSentence: "A seatbelt slows your body with the car."
                    ),
                    VocabularyWord(
                        word: "force",
                        definition: "A push or pull.",
                        exampleSentence: "Seatbelts apply a holding force."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Bodies tend to keep moving forward when a car stops suddenly.",
                        explanation: "Seatbelts apply holding force across a wider area."
                    ),
                    KnowledgeFact(
                        fact: "Seatbelts help riders slow with the car during a sudden stop.",
                        explanation: "Managing force keeps riders safer."
                    )
                ],
                creativePrompt: "Draw a rider with a seatbelt, and label holding force.",
                storyEnding: "You found the seatbelt main idea like a careful safety scientist.",
                readingSkill: "Identify the main idea about seatbelts and force",
                reflectionPrompt: "How does a seatbelt help in a sudden stop?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find keep moving forward"
                ],
                commonMistakes: [
                    "Missing the force-management main idea"
                ],
                successCriteria: [
                    "States the seatbelt main idea",
                    "Cites forward motion or wider area"
                ],
                learningObjectives: [
                    "Explain that seatbelts manage force in sudden stops",
                    "fp:discovery.Cars.growingReader"
                ],
                activityFingerprint: "cars.discovery.growing.seatbelts"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Energy from Fuel",
                storyOpening: "Movo joins your car science team. Together you investigate how fuel energy becomes car motion.",
                missionPrompt: "Use evidence from the notes. Explain how fuel energy becomes car motion.",
                readingPassage: "Many cars store energy in fuel. An engine can change fuel energy into motion of pistons and wheels. Some energy becomes heat that is not useful for moving. Electric cars store energy in batteries instead of liquid fuel. In every case, stored energy must change form before wheels turn. Understanding energy flow helps explain why cars need fuel or charging.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about car motion?",
                        ["Stored energy must change form before wheels turn", "Wheels turn with no energy change", "Fuel only paints the car"],
                        "Stored energy must change form before wheels turn",
                        "Stored energy must change form before wheels turn."
                    ),
                    discoveryMCQ(
                        "What can an engine change fuel energy into?",
                        ["Motion of pistons and wheels", "Only cabin lights forever", "Only the radio volume"],
                        "Motion of pistons and wheels",
                        "An engine can change fuel energy into motion of pistons and wheels."
                    ),
                    discoveryMCQ(
                        "Where do electric cars store energy?",
                        ["In batteries", "Only in the painted doors", "Only in dry leaves"],
                        "In batteries",
                        "Electric cars store energy in batteries."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "fuel",
                        definition: "A material that stores energy a car can use.",
                        exampleSentence: "Liquid fuel stores energy for many cars."
                    ),
                    VocabularyWord(
                        word: "battery",
                        definition: "A device that stores electric energy.",
                        exampleSentence: "Electric cars store energy in batteries."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Car engines can change fuel energy into wheel motion.",
                        explanation: "Some energy becomes unused heat."
                    ),
                    KnowledgeFact(
                        fact: "Electric cars store energy in batteries instead of liquid fuel.",
                        explanation: "Stored energy must change form before wheels turn."
                    ),
                    KnowledgeFact(
                        fact: "Understanding energy flow explains why cars need fuel or charging.",
                        explanation: "Energy does not appear from nowhere."
                    )
                ],
                creativePrompt: "Write three sentences tracing energy from fuel or battery to wheels.",
                storyEnding: "You traced energy flow like a careful investigator.",
                readingSkill: "Infer how stored energy becomes car motion",
                reflectionPrompt: "Which energy step from the notes feels most important?",
                hints: [
                    "Follow stored energy to wheels",
                    "Compare fuel with batteries"
                ],
                commonMistakes: [
                    "Claiming wheels turn with no energy change"
                ],
                successCriteria: [
                    "Uses energy-change evidence",
                    "Links fuel or battery to motion"
                ],
                learningObjectives: [
                    "Infer how stored fuel or battery energy becomes car motion",
                    "fp:discovery.Cars.confidentReader"
                ],
                activityFingerprint: "cars.discovery.confident.fuel-energy"
            )
        }
    }


    // MARK: - Superheroes Discovery

    private static func superheroesDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Strong Materials",
                storyOpening: "Movo inspects shiny hero gear with you. What really keeps a tool from snapping in a tough moment?",
                missionPrompt: "Discover one true science fact about strong materials in the notes.",
                readingPassage: "Hero gear can use strong materials. Strong materials resist breaking. Soft paper alone tears too easily. Material strength matters for safe tools. A strong shield can take a hit that would rip paper in one tear.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what do strong materials resist?",
                        ["Breaking", "Only changing color", "Only getting warm"],
                        "Breaking",
                        "Strong materials resist breaking under force."
                    ),
                    discoveryMCQ(
                        "What tears too easily for tough gear?",
                        ["Soft paper alone", "Only thick steel always", "Only metal beams"],
                        "Soft paper alone",
                        "Soft paper alone tears too easily for tough gear."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "material",
                        definition: "What something is made of.",
                        exampleSentence: "Strong materials resist breaking."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Strong materials resist breaking better than soft paper.",
                        explanation: "Material strength matters for safe tools."
                    ),
                    KnowledgeFact(
                        fact: "Hero gear can use strong materials for protection.",
                        explanation: "Choosing materials is real science."
                    )
                ],
                creativePrompt: "Draw a shield labeled strong material.",
                storyEnding: "You logged a real materials fact. Great science work!",
                readingSkill: "Use a science note to name material strength",
                reflectionPrompt: "Name one reason strong materials matter for gear.",
                hints: [
                    "Look for resist breaking",
                    "Find soft paper"
                ],
                commonMistakes: [
                    "Choosing soft paper as the strong choice"
                ],
                successCriteria: [
                    "Names resist breaking",
                    "Uses a materials contrast"
                ],
                learningObjectives: [
                    "Identify that strong materials resist breaking for safer gear",
                    "fp:discovery.Superheroes.beginner"
                ],
                activityFingerprint: "superheroes.discovery.beginner.materials"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Levers Lift Loads",
                storyOpening: "Movo tries a hero tool that turns on a pivot. A small push makes a bigger lift on the other end—come see!",
                missionPrompt: "Hunt for one true science fact about levers in the notes.",
                readingPassage: "A lever is a bar that turns on a pivot. Gadgets can use levers to lift heavy loads with less effort. The pivot placement changes how hard you must push. Crowbars are everyday levers. Levers turn a small force into helpful motion.",
                questions: [
                    discoveryMCQ(
                        "What is a lever?",
                        ["A bar that turns on a pivot", "A soft rope with no fixed point", "A bowl that never turns"],
                        "A bar that turns on a pivot",
                        "A lever is a bar that turns on a pivot to move a load."
                    ),
                    discoveryMCQ(
                        "What can levers help lift?",
                        ["Heavy loads with less effort", "Only silent shadows", "Only piles of dry sand"],
                        "Heavy loads with less effort",
                        "Levers can help lift heavy loads with less effort."
                    ),
                    discoveryMCQ(
                        "What changes how hard you must push?",
                        ["The pivot placement", "Only the color of paint", "Only the smell of fuel"],
                        "The pivot placement",
                        "Where you place the pivot changes how hard you must push."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "lever",
                        definition: "A bar that turns on a pivot to move a load.",
                        exampleSentence: "A crowbar is a lever."
                    ),
                    VocabularyWord(
                        word: "pivot",
                        definition: "The turning point of a lever.",
                        exampleSentence: "The pivot placement changes effort."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Levers turn on a pivot to move loads with less effort.",
                        explanation: "Gadgets can use levers."
                    ),
                    KnowledgeFact(
                        fact: "Pivot placement changes how hard you must push.",
                        explanation: "Crowbars are everyday levers."
                    )
                ],
                creativePrompt: "Draw a lever with a pivot and a heavy load, and label effort.",
                storyEnding: "You used lever evidence carefully.",
                readingSkill: "Use evidence to explain levers in gadgets",
                reflectionPrompt: "How can a lever help lift a heavy load?",
                hints: [
                    "Find pivot",
                    "Look for less effort"
                ],
                commonMistakes: [
                    "Thinking levers need magic"
                ],
                successCriteria: [
                    "Names bar on a pivot",
                    "Cites load or pivot placement"
                ],
                learningObjectives: [
                    "Explain that levers use pivots to lift loads with less effort",
                    "fp:discovery.Superheroes.earlyReader"
                ],
                activityFingerprint: "superheroes.discovery.early.levers"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Sensors Detect Change",
                storyOpening: "Movo points at a blinking gadget. It notices when light, sound, or motion changes—sensors detect first!",
                missionPrompt: "Find the main idea about sensors. Use details from the notes.",
                readingPassage: "A sensor detects a change such as light, sound, or motion. The sensor sends a signal to a computer or display. Gadgets can warn people when a sensor notices danger. A broken sensor may miss an important change. The main idea is that sensors turn real-world changes into signals gadgets can use.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Sensors turn real-world changes into signals gadgets can use", "Sensors only decorate helmets", "Gadgets never need signals"],
                        "Sensors turn real-world changes into signals gadgets can use",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What can a sensor detect?",
                        ["A change such as light, sound, or motion", "Only the gadget's paint color", "Only the length of a cape"],
                        "A change such as light, sound, or motion",
                        "A sensor can detect a change such as light, sound, or motion."
                    ),
                    discoveryMCQ(
                        "What may a broken sensor do?",
                        ["Miss an important change", "Always warn even when nothing changes", "Ignore every change around it"],
                        "Miss an important change",
                        "A broken sensor may miss an important change."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "sensor",
                        definition: "A part that detects a change and can send a signal.",
                        exampleSentence: "A motion sensor can notice movement."
                    ),
                    VocabularyWord(
                        word: "signal",
                        definition: "A message sent from one part to another.",
                        exampleSentence: "Sensors send signals to a display."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sensors detect changes such as light, sound, or motion.",
                        explanation: "They send signals gadgets can use."
                    ),
                    KnowledgeFact(
                        fact: "Broken sensors may miss important changes.",
                        explanation: "Reliable sensors support warnings."
                    )
                ],
                creativePrompt: "Draw a gadget with a sensor noticing motion, and label signal.",
                storyEnding: "You found the sensor main idea like a careful engineer.",
                readingSkill: "Identify the main idea about sensors and signals",
                reflectionPrompt: "How can a sensor help a gadget warn someone?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find detect"
                ],
                commonMistakes: [
                    "Missing the signal main idea"
                ],
                successCriteria: [
                    "States the sensor main idea",
                    "Cites a change type or warning"
                ],
                learningObjectives: [
                    "Explain that sensors convert real-world changes into usable signals",
                    "fp:discovery.Superheroes.growingReader"
                ],
                activityFingerprint: "superheroes.discovery.growing.sensors"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Forces in Action Gear",
                storyOpening: "Movo suits up as your science partner. Together you investigate how forces make action gear work.",
                missionPrompt: "Use evidence from the notes. Explain why gadget design must respect real forces.",
                readingPassage: "Gadgets that jump, swing, or catch must handle real forces. A rope must be strong enough for the pulling force. A hinge must survive repeated twisting force. If a force is too strong, the parts break. Designers choose materials and shapes to spread force safely. Real science, not magic, makes durable action gear possible.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about action gear?",
                        ["Design must match materials to the forces the gear will face", "Any material can handle any force", "Force never affects materials"],
                        "Design must match materials to the forces the gear will face",
                        "Designers match materials and shapes to forces."
                    ),
                    discoveryMCQ(
                        "What must a rope be strong enough for?",
                        ["The pulling force", "Only the rope's color", "Only how long the rope is"],
                        "The pulling force",
                        "A rope must be strong enough for the pulling force on it."
                    ),
                    discoveryMCQ(
                        "What happens if a force is too strong?",
                        ["The parts break", "The parts stretch but stay just as strong", "The parts become lighter than air"],
                        "The parts break",
                        "If a force is too strong, the parts break.",
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "force",
                        definition: "A push or pull that can change motion or stress materials.",
                        exampleSentence: "Pulling force acts on a rope."
                    ),
                    VocabularyWord(
                        word: "durable",
                        definition: "Able to last through hard use.",
                        exampleSentence: "Durable gear survives repeated forces."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Action gadgets must handle real forces such as pulling and twisting.",
                        explanation: "Materials must match expected forces."
                    ),
                    KnowledgeFact(
                        fact: "If a force is too strong, the parts break.",
                        explanation: "Designers spread force safely with shape and material choice."
                    ),
                    KnowledgeFact(
                        fact: "Real science, not magic, makes durable gear possible.",
                        explanation: "Force limits guide safe design."
                    )
                ],
                creativePrompt: "Write three sentences about one gadget part and the force it must handle.",
                storyEnding: "You connected forces to durable design like a careful investigator.",
                readingSkill: "Infer why gadget design must respect real forces",
                reflectionPrompt: "Which force example from the notes would you test with classroom tools?",
                hints: [
                    "Compare rope pull with hinge twist",
                    "Reread parts fail"
                ],
                commonMistakes: [
                    "Treating gear as magic without force limits"
                ],
                successCriteria: [
                    "Uses force evidence",
                    "Cites a force that is too strong"
                ],
                learningObjectives: [
                    "Infer how matching materials to forces makes durable gadgets",
                    "fp:discovery.Superheroes.confidentReader"
                ],
                activityFingerprint: "superheroes.discovery.confident.forces"
            )
        }
    }


    // MARK: - Art Discovery

    private static func artDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Primary Colors Mix",
                storyOpening: "Movo dips a brush in red, then yellow with you. Watch a brand-new color appear on the page!",
                missionPrompt: "Hunt for one true fact about mixing primary colors in the notes.",
                readingPassage: "Red, yellow, and blue are primary colors in paint. Mixing two primaries can make a new color. Red and yellow can make orange. Mixing is a real color change. Two blobs swirled together can make a pumpkin-bright orange.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, which colors are primary in paint?",
                        ["Red, yellow, and blue", "Only gray and brown forever", "Only black and white always"],
                        "Red, yellow, and blue",
                        "In paint, the primary colors are red, yellow, and blue."
                    ),
                    discoveryMCQ(
                        "What can red and yellow make?",
                        ["Orange", "Only green with no yellow", "Only purple with no red"],
                        "Orange",
                        "Mixing red and yellow paint can make orange."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "primary",
                        definition: "A basic paint color used to mix other colors.",
                        exampleSentence: "Red is a primary color in paint."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Red, yellow, and blue are primary colors in paint.",
                        explanation: "Mixing two primaries can make a new color."
                    ),
                    KnowledgeFact(
                        fact: "Red and yellow can make orange.",
                        explanation: "Mixing causes a real color change."
                    )
                ],
                creativePrompt: "Draw three primary paint blobs and one mixed orange.",
                storyEnding: "You logged a real color-mix fact. Great science work!",
                readingSkill: "Use a science note to name primary paint colors",
                reflectionPrompt: "Name one new color you can make by mixing.",
                hints: [
                    "Look for red, yellow, and blue",
                    "Find orange"
                ],
                commonMistakes: [
                    "Choosing colors the notes never name as primary"
                ],
                successCriteria: [
                    "Names primary colors",
                    "Uses a mixing fact"
                ],
                learningObjectives: [
                    "Identify primary paint colors and a mix result",
                    "fp:discovery.Art.beginner"
                ],
                activityFingerprint: "art.discovery.beginner.primary-mix"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Light Reflection",
                storyOpening: "Movo holds up a red apple in the light. It looks red because it bounces more red light toward your eyes.",
                missionPrompt: "Hunt for one true science fact about reflected light in the notes.",
                readingPassage: "We see an object when light reflects from it to our eyes. A red apple reflects more red light than other colors. A black surface reflects little light. Without light, colors are hard to see. Seeing needs bouncing light, objects, and our eyes.",
                questions: [
                    discoveryMCQ(
                        "When do we see an object?",
                        ["When light reflects from it to our eyes", "When it makes its own light", "When it absorbs all sound"],
                        "When light reflects from it to our eyes",
                        "We see when light reflects to our eyes."
                    ),
                    discoveryMCQ(
                        "What does a red apple reflect more of?",
                        ["Red light", "Only blue light", "Only all light equally"],
                        "Red light",
                        "A red apple reflects more red light than other colors."
                    ),
                    discoveryMCQ(
                        "What does a black surface reflect?",
                        ["Little light", "All colors equally", "Only bright white light"],
                        "Little light",
                        "A black surface reflects little light, so it looks dark."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "reflect",
                        definition: "To bounce light back from a surface.",
                        exampleSentence: "An apple can reflect red light."
                    ),
                    VocabularyWord(
                        word: "vision",
                        definition: "The sense of seeing.",
                        exampleSentence: "Vision depends on light reaching the eyes."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "We see objects when light reflects to our eyes.",
                        explanation: "Color depends on which light is reflected."
                    ),
                    KnowledgeFact(
                        fact: "A black surface reflects little light.",
                        explanation: "Without light, colors are hard to see."
                    )
                ],
                creativePrompt: "Draw an apple with light arrows reflecting to an eye.",
                storyEnding: "You used reflection evidence carefully.",
                readingSkill: "Use evidence to explain seeing color by reflection",
                reflectionPrompt: "Why does a red apple look red in light?",
                hints: [
                    "Find reflects",
                    "Look for red light"
                ],
                commonMistakes: [
                    "Thinking we see color with no light"
                ],
                successCriteria: [
                    "States light reflects to eyes",
                    "Cites red or black detail"
                ],
                learningObjectives: [
                    "Explain that seeing color depends on reflected light",
                    "fp:discovery.Art.earlyReader"
                ],
                activityFingerprint: "art.discovery.early.reflection"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Pigments Color Paint",
                storyOpening: "Movo swirls paint and whispers a clue. Tiny color particles hide inside—those pigments make the hue you see.",
                missionPrompt: "Find the main idea about pigments. Use details from the notes.",
                readingPassage: "Pigments are tiny color particles mixed into paint. Different pigments absorb and reflect different light. Mixing pigments changes which light reaches your eyes. Fading can happen when light or air changes a pigment. The main idea is that pigments control paint color by interacting with light.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Pigments control paint color by interacting with light", "Pigments only add smell to paint", "Paint color never depends on light"],
                        "Pigments control paint color by interacting with light",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What are pigments?",
                        ["Tiny color particles mixed into paint", "Only water with no color", "Only clear glass chips"],
                        "Tiny color particles mixed into paint",
                        "Pigments are tiny color particles mixed into paint."
                    ),
                    discoveryMCQ(
                        "What can cause fading?",
                        ["Light or air changing a pigment", "Only louder footsteps", "Only thicker paper"],
                        "Light or air changing a pigment",
                        "Light or air can change a pigment and cause fading."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "pigment",
                        definition: "A tiny color particle used in paint.",
                        exampleSentence: "Red pigment can color paint."
                    ),
                    VocabularyWord(
                        word: "absorb",
                        definition: "To take in light instead of bouncing it.",
                        exampleSentence: "Some pigments absorb more light."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Pigments are color particles that absorb and reflect light.",
                        explanation: "Mixing pigments changes the light you see."
                    ),
                    KnowledgeFact(
                        fact: "Light or air can change pigments and cause fading.",
                        explanation: "Pigments control paint color through light interaction."
                    )
                ],
                creativePrompt: "Draw paint with pigment dots, and label absorb and reflect.",
                storyEnding: "You found the pigment main idea like a careful color scientist.",
                readingSkill: "Identify the main idea about pigments and light",
                reflectionPrompt: "How do pigments change what color you see?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find absorb and reflect"
                ],
                commonMistakes: [
                    "Missing the light-interaction main idea"
                ],
                successCriteria: [
                    "States the pigment main idea",
                    "Cites absorb, reflect, or fading"
                ],
                learningObjectives: [
                    "Explain that pigments control paint color by interacting with light",
                    "fp:discovery.Art.growingReader"
                ],
                activityFingerprint: "art.discovery.growing.pigments"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Warm and Cool Colors",
                storyOpening: "Movo joins your art science studio. Together you investigate how warm and cool colors guide light choices.",
                missionPrompt: "Use evidence from the notes. Explain how artists use warm and cool colors.",
                readingPassage: "Artists often group colors as warm or cool. Warm colors such as red and orange can feel closer and more energetic. Cool colors such as blue and green can feel calmer or farther. These feelings come from how we perceive light and color together. Artists choose warm or cool groups to guide mood in a picture. Perception science helps explain those design choices.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about warm and cool colors?",
                        ["Artists use them to guide mood based on how we perceive color", "Warm and cool labels remove all meaning from art", "Color never affects mood"],
                        "Artists use them to guide mood based on how we perceive color",
                        "Artists choose warm or cool groups to guide mood."
                    ),
                    discoveryMCQ(
                        "Which colors are named as warm?",
                        ["Red and orange", "Only blue and green", "Only gray forever"],
                        "Red and orange",
                        "Red and orange are often named as warm colors."
                    ),
                    discoveryMCQ(
                        "How can cool colors such as blue and green feel?",
                        ["Calmer or farther", "Always hotter than fire", "Exactly like metal"],
                        "Calmer or farther",
                        "Cool colors such as blue and green can feel calmer or farther away."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "warm color",
                        definition: "A color such as red or orange that can feel energetic.",
                        exampleSentence: "Orange is a warm color."
                    ),
                    VocabularyWord(
                        word: "cool color",
                        definition: "A color such as blue or green that can feel calmer.",
                        exampleSentence: "Blue is a cool color."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Warm colors such as red and orange can feel closer and more energetic.",
                        explanation: "Cool colors such as blue and green can feel calmer or farther."
                    ),
                    KnowledgeFact(
                        fact: "Artists choose warm or cool groups to guide mood.",
                        explanation: "Perception of light and color supports those choices."
                    ),
                    KnowledgeFact(
                        fact: "Warm and cool groupings are tools, not magic rules.",
                        explanation: "Perception science helps explain design choices."
                    )
                ],
                creativePrompt: "Draw one warm scene corner and one cool scene corner, and label each.",
                storyEnding: "You connected color groups to mood like a careful investigator.",
                readingSkill: "Infer how warm and cool colors guide mood in art",
                reflectionPrompt: "Which warm or cool clue from the notes would you use in a drawing?",
                hints: [
                    "Compare warm with cool examples",
                    "Reread guide mood"
                ],
                commonMistakes: [
                    "Treating warm and cool as meaningless labels"
                ],
                successCriteria: [
                    "Uses warm/cool evidence",
                    "Links color choice to mood"
                ],
                learningObjectives: [
                    "Infer how artists use warm and cool colors to guide mood",
                    "fp:discovery.Art.confidentReader"
                ],
                activityFingerprint: "art.discovery.confident.warm-cool"
            )
        }
    }


    // MARK: - Music Discovery

    private static func musicDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Sound Is Vibration",
                storyOpening: "Movo puts a paw on a drum with you. Feel the skin shake? That vibration is how sound begins.",
                missionPrompt: "Spot one true science fact about sound in the notes.",
                readingPassage: "Sound begins when something vibrates. Vibration means fast tiny shaking. The shaking moves air toward your ears. No vibration means no sound from that object. Even a soft whisper starts with tiny shakes you can barely see.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, when does sound begin?",
                        ["When something vibrates", "When something stays perfectly still", "When it absorbs all sound"],
                        "When something vibrates",
                        "Sound begins when something vibrates."
                    ),
                    discoveryMCQ(
                        "What does vibration mean?",
                        ["Fast tiny shaking", "Only stillness with no motion", "Only a change in color"],
                        "Fast tiny shaking",
                        "Vibration means fast tiny shaking that can make sound."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "vibrate",
                        definition: "To shake back and forth quickly.",
                        exampleSentence: "A drum skin can vibrate to make sound."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sound begins when something vibrates.",
                        explanation: "Vibration is fast tiny shaking."
                    ),
                    KnowledgeFact(
                        fact: "Vibrations move air toward your ears.",
                        explanation: "No vibration means no sound from that object."
                    )
                ],
                creativePrompt: "Draw a drum with shaking lines, and label vibration.",
                storyEnding: "You logged a real sound fact. Great science work!",
                readingSkill: "Use a science note to link sound to vibration",
                reflectionPrompt: "Name one thing that must happen for sound to begin.",
                hints: [
                    "Look for vibrates",
                    "Find shaking"
                ],
                commonMistakes: [
                    "Choosing a claim with no vibration"
                ],
                successCriteria: [
                    "Names vibration",
                    "Uses shaking or air"
                ],
                learningObjectives: [
                    "Identify that sound begins with vibration",
                    "fp:discovery.Music.beginner"
                ],
                activityFingerprint: "music.discovery.beginner.vibration"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Pitch High and Low",
                storyOpening: "Movo plucks a short tight string, then a long loose one. Hear how pitch changes? Come wonder why!",
                missionPrompt: "Hunt for one true science fact about pitch in the notes.",
                readingPassage: "Pitch tells whether a sound is high or low. Faster vibrations often make higher pitch. Slower vibrations often make lower pitch. A short tight string can sound higher than a long loose string. Pitch depends on how the object vibrates.",
                questions: [
                    discoveryMCQ(
                        "What does pitch tell?",
                        ["Whether a sound is high or low", "Only the color of a drum", "Only the smell of wood"],
                        "Whether a sound is high or low",
                        "Pitch tells whether a sound is high or low."
                    ),
                    discoveryMCQ(
                        "What do faster vibrations often make?",
                        ["Higher pitch", "Only lower pitch always", "Only silence with no tone"],
                        "Higher pitch",
                        "Faster vibrations often make a higher pitch."
                    ),
                    discoveryMCQ(
                        "What can sound higher than a long loose string?",
                        ["A short tight string", "Only a long loose string", "Only a heavy mute cloth"],
                        "A short tight string",
                        "A short tight string can sound higher than a long loose string."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "pitch",
                        definition: "How high or low a sound is.",
                        exampleSentence: "A whistle can have a high pitch."
                    ),
                    VocabularyWord(
                        word: "string",
                        definition: "A thin cord that can vibrate on an instrument.",
                        exampleSentence: "A tight string can sound higher."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Pitch is how high or low a sound is.",
                        explanation: "Faster vibrations often mean higher pitch."
                    ),
                    KnowledgeFact(
                        fact: "A short tight string can sound higher than a long loose string.",
                        explanation: "Pitch depends on how an object vibrates."
                    )
                ],
                creativePrompt: "Draw a short tight string and a long loose string, and label high and low pitch.",
                storyEnding: "You used pitch evidence carefully.",
                readingSkill: "Use evidence to explain high and low pitch",
                reflectionPrompt: "How can string tightness change pitch?",
                hints: [
                    "Find high or low",
                    "Look for faster vibrations"
                ],
                commonMistakes: [
                    "Mixing up pitch with volume only"
                ],
                successCriteria: [
                    "Defines pitch as high or low",
                    "Cites vibration speed or string"
                ],
                learningObjectives: [
                    "Explain that pitch depends on vibration speed",
                    "fp:discovery.Music.earlyReader"
                ],
                activityFingerprint: "music.discovery.early.pitch"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Volume and Energy",
                storyOpening: "Movo taps soft, then bangs hard on the same drum. Volume is how loud that shake sounds—let's compare!",
                missionPrompt: "Find the main idea about volume. Use details from the notes.",
                readingPassage: "Volume is how loud or soft a sound is. Bigger vibrations can push air with more energy and sound louder. Smaller vibrations often sound softer. Covering your ears lowers the energy that reaches you. The main idea is that volume relates to the energy of the vibrating sound source.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Volume relates to the energy of the vibrating sound source", "Volume is only the color of an instrument", "Louder sound needs no vibration energy"],
                        "Volume relates to the energy of the vibrating sound source",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What is volume?",
                        ["How loud or soft a sound is", "How high or low a sound is only", "Only the smell of wood"],
                        "How loud or soft a sound is",
                        "Volume is how loud or soft a sound is."
                    ),
                    discoveryMCQ(
                        "What can bigger vibrations do?",
                        ["Push air with more energy and sound louder", "Make the room completely silent", "Change sound into color"],
                        "Push air with more energy and sound louder",
                        "Bigger vibrations can sound louder."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "volume",
                        definition: "How loud or soft a sound is.",
                        exampleSentence: "A shout has high volume."
                    ),
                    VocabularyWord(
                        word: "energy",
                        definition: "The ability to make things move or change.",
                        exampleSentence: "Bigger vibrations carry more sound energy."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Volume is how loud or soft a sound is.",
                        explanation: "Bigger vibrations can sound louder."
                    ),
                    KnowledgeFact(
                        fact: "Covering your ears lowers the energy that reaches you.",
                        explanation: "Volume relates to vibration energy."
                    )
                ],
                creativePrompt: "Draw a soft tap and a hard hit on a drum, and label soft and loud volume.",
                storyEnding: "You found the volume main idea like a careful sound scientist.",
                readingSkill: "Identify the main idea about volume and energy",
                reflectionPrompt: "How does vibration size relate to loudness?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find louder"
                ],
                commonMistakes: [
                    "Missing the energy main idea"
                ],
                successCriteria: [
                    "States the volume-energy main idea",
                    "Cites bigger or smaller vibrations"
                ],
                learningObjectives: [
                    "Explain that volume relates to vibration energy",
                    "fp:discovery.Music.growingReader"
                ],
                activityFingerprint: "music.discovery.growing.volume"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Instrument Materials",
                storyOpening: "Movo joins your music science band. Together you investigate how materials shape the sounds instruments make.",
                missionPrompt: "Use evidence from the notes. Explain why instrument materials matter for sound.",
                readingPassage: "Different materials vibrate in different ways. Wood, metal, and plastic can change how long a sound rings. A thin metal bar may ring longer than a soft cloth. Hollow shapes can amplify vibrating air. Builders choose materials to shape tone, not only looks. Material science and sound science come together in every instrument.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about instrument materials?",
                        ["They change how vibrations sound and how long tones ring", "Materials never affect sound", "Only paint color makes tone"],
                        "They change how vibrations sound and how long tones ring",
                        "Instrument materials change how vibrations sound and how long tones ring."
                    ),
                    discoveryMCQ(
                        "What may ring longer than a soft cloth?",
                        ["A thin metal bar", "Only a folded towel", "Only a pile of cotton"],
                        "A thin metal bar",
                        "A thin metal bar may ring longer than a soft cloth."
                    ),
                    discoveryMCQ(
                        "What can hollow shapes do?",
                        ["Amplify vibrating air", "Remove all vibration", "Change sound into color"],
                        "Amplify vibrating air",
                        "Hollow shapes can amplify vibrating air."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "amplify",
                        definition: "To make a sound stronger or easier to hear.",
                        exampleSentence: "A hollow body can amplify sound."
                    ),
                    VocabularyWord(
                        word: "tone",
                        definition: "The character of a sound.",
                        exampleSentence: "Material choices shape instrument tone."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Different materials vibrate in different ways.",
                        explanation: "Wood, metal, and plastic can change ringing time."
                    ),
                    KnowledgeFact(
                        fact: "Hollow shapes can amplify vibrating air.",
                        explanation: "Builders choose materials to shape tone."
                    ),
                    KnowledgeFact(
                        fact: "Material science and sound science come together in instruments.",
                        explanation: "Looks alone do not decide tone."
                    )
                ],
                creativePrompt: "Write three sentences comparing a metal sound with a soft-cloth sound.",
                storyEnding: "You connected materials to tone like a careful investigator.",
                readingSkill: "Infer why instrument materials shape sound",
                reflectionPrompt: "Which material clue from the notes would you test with classroom objects?",
                hints: [
                    "Compare metal with cloth",
                    "Reread hollow shapes"
                ],
                commonMistakes: [
                    "Claiming materials never affect sound"
                ],
                successCriteria: [
                    "Uses material evidence",
                    "Links hollow shape to amplify"
                ],
                learningObjectives: [
                    "Infer how instrument materials shape vibration and tone",
                    "fp:discovery.Music.confidentReader"
                ],
                activityFingerprint: "music.discovery.confident.materials"
            )
        }
    }


    // MARK: - Cooking Discovery

    private static func cookingDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Heat Changes Food",
                storyOpening: "Movo cracks an egg into a hot pan with you. Watch liquid turn firm before your eyes—heat is changing food!",
                missionPrompt: "Find one true fact about heat and food in the science notes.",
                readingPassage: "Heat can change food. An egg can go from liquid to firm when heated. Bread can turn brown in a toaster. Heat is a cooking tool. Warmth can flip wobbly egg white into a solid bite.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what can heat do to food?",
                        ["Change food", "Only hide food forever", "Only freeze food solid always"],
                        "Change food",
                        "Heat can change food by cooking it."
                    ),
                    discoveryMCQ(
                        "What can happen to an egg when heated?",
                        ["It can go from liquid to firm", "It turns into a metal spoon", "It becomes a glass bowl"],
                        "It can go from liquid to firm",
                        "When heated, an egg can go from liquid to firm."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "heat",
                        definition: "Energy that can make things warmer and change them.",
                        exampleSentence: "Heat can make an egg firm."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Heat can change food during cooking.",
                        explanation: "An egg can go from liquid to firm when heated."
                    ),
                    KnowledgeFact(
                        fact: "Bread can turn brown in a toaster from heat.",
                        explanation: "Heat is a cooking tool."
                    )
                ],
                creativePrompt: "Draw an egg before and after heat, and label liquid and firm.",
                storyEnding: "You logged a real heat fact. Great science work!",
                readingSkill: "Use a science note to explain heat changing food",
                reflectionPrompt: "Name one food change heat can cause.",
                hints: [
                    "Look for change food",
                    "Find egg"
                ],
                commonMistakes: [
                    "Choosing a claim that heat never changes food"
                ],
                successCriteria: [
                    "Names heat changing food",
                    "Uses egg or bread detail"
                ],
                learningObjectives: [
                    "Identify that heat can change food",
                    "fp:discovery.Cooking.beginner"
                ],
                activityFingerprint: "cooking.discovery.beginner.heat"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Measuring Matters",
                storyOpening: "Movo levels a measuring scoop carefully. A scoop too full can spoil a cake—tools help cooks repeat a recipe.",
                missionPrompt: "Hunt for one true fact about measuring in the notes.",
                readingPassage: "Cooking often needs careful measuring. Too much salt can make food taste too strong. Too little water can make dough dry. Measuring tools help cooks repeat a recipe. Amounts are part of cooking science.",
                questions: [
                    discoveryMCQ(
                        "What does cooking often need?",
                        ["Careful measuring", "Only guessing with closed eyes", "Only louder kitchen noise"],
                        "Careful measuring",
                        "Cooking often needs careful measuring so recipes work."
                    ),
                    discoveryMCQ(
                        "What can too much salt do?",
                        ["Make food taste too strong", "Make food taste milder", "Make food colder only"],
                        "Make food taste too strong",
                        "Too much salt can make food taste too strong."
                    ),
                    discoveryMCQ(
                        "What helps cooks repeat a recipe?",
                        ["Measuring tools", "Only random pinches every time", "Only the color of the bowl"],
                        "Measuring tools",
                        "Measuring tools help cooks repeat a recipe the same way."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "measure",
                        definition: "To find an exact amount.",
                        exampleSentence: "Cooks measure salt carefully."
                    ),
                    VocabularyWord(
                        word: "recipe",
                        definition: "A plan that lists foods and steps.",
                        exampleSentence: "A recipe needs measured amounts."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Careful measuring helps cooking turn out as planned.",
                        explanation: "Too much salt can taste too strong."
                    ),
                    KnowledgeFact(
                        fact: "Measuring tools help cooks repeat a recipe.",
                        explanation: "Amounts are part of cooking science."
                    )
                ],
                creativePrompt: "Draw a measuring cup with a fill line, and label amount.",
                storyEnding: "You used measuring evidence carefully.",
                readingSkill: "Use evidence to explain why measuring matters",
                reflectionPrompt: "Why do cooks measure instead of guessing every time?",
                hints: [
                    "Find careful measuring",
                    "Look for recipe"
                ],
                commonMistakes: [
                    "Thinking amounts never matter"
                ],
                successCriteria: [
                    "States careful measuring",
                    "Cites salt, water, or tools"
                ],
                learningObjectives: [
                    "Explain that measuring controls cooking amounts",
                    "fp:discovery.Cooking.earlyReader"
                ],
                activityFingerprint: "cooking.discovery.early.measuring"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Dissolving in Water",
                storyOpening: "Movo stirs sugar into water with you. The grains seem to vanish as they spread through the liquid—come see dissolving!",
                missionPrompt: "Find the main idea about dissolving. Use details from the notes.",
                readingPassage: "Sugar can dissolve in water and seem to disappear. The sugar particles spread through the liquid. Stirring can help dissolving happen faster. Not every solid dissolves well in water. The main idea is that dissolving mixes a solid into a liquid at a tiny scale.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Dissolving mixes a solid into a liquid at a tiny scale", "Dissolving removes all water forever", "Sugar never mixes with water"],
                        "Dissolving mixes a solid into a liquid at a tiny scale",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What happens to sugar particles in water?",
                        ["They spread through the liquid", "They turn into metal spoons", "They become ice crystals at once"],
                        "They spread through the liquid",
                        "Sugar particles spread through the liquid when they dissolve."
                    ),
                    discoveryMCQ(
                        "What can help dissolving happen faster?",
                        ["Stirring", "Leaving the sugar in one clump", "Cooling the water until it freezes"],
                        "Stirring",
                        "Stirring can help dissolving happen faster."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "dissolve",
                        definition: "To mix into a liquid so particles spread out.",
                        exampleSentence: "Sugar can dissolve in water."
                    ),
                    VocabularyWord(
                        word: "particle",
                        definition: "A tiny bit of a material.",
                        exampleSentence: "Sugar particles spread in water."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sugar can dissolve in water as particles spread through the liquid.",
                        explanation: "Stirring can speed dissolving."
                    ),
                    KnowledgeFact(
                        fact: "Not every solid dissolves well in water.",
                        explanation: "Dissolving mixes solid into liquid at a tiny scale."
                    )
                ],
                creativePrompt: "Draw sugar going into water with spread-out dots, and label dissolve.",
                storyEnding: "You found the dissolving main idea like a careful kitchen scientist.",
                readingSkill: "Identify the main idea about dissolving",
                reflectionPrompt: "What happens to sugar when it dissolves in water?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find particles"
                ],
                commonMistakes: [
                    "Missing the tiny-scale mix main idea"
                ],
                successCriteria: [
                    "States the dissolving main idea",
                    "Cites particles or stirring"
                ],
                learningObjectives: [
                    "Explain that dissolving mixes a solid into a liquid at tiny scale",
                    "fp:discovery.Cooking.growingReader"
                ],
                activityFingerprint: "cooking.discovery.growing.dissolving"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Solid and Liquid Changes",
                storyOpening: "Movo joins your kitchen science team. Together you investigate how heating and cooling change solid and liquid states.",
                missionPrompt: "Use evidence from the notes. Explain how heat can change food between solid and liquid.",
                readingPassage: "Butter can melt from solid to liquid when heated. Melted chocolate can cool and become solid again. Water can freeze into ice or melt back to liquid. These changes are physical state changes. Cooking uses state changes to shape texture and form. Understanding solids and liquids helps cooks predict what heat will do.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about heating and cooling food?",
                        ["Heat and cooling can move food between solid and liquid states", "Food states never change with heat", "Only color changes matter"],
                        "Heat and cooling can move food between solid and liquid states",
                        "Heating and cooling can move food between solid and liquid states."
                    ),
                    discoveryMCQ(
                        "What can butter do when heated?",
                        ["Melt from solid to liquid", "Turn into a metal pan", "Become a glass block"],
                        "Melt from solid to liquid",
                        "Butter can melt from solid to liquid when heated."
                    ),
                    discoveryMCQ(
                        "What kind of changes are melting and freezing?",
                        ["Physical state changes", "Only color changes", "Only sound vibrations"],
                        "Physical state changes",
                        "Melting and freezing are physical state changes."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "melt",
                        definition: "To change from solid to liquid with heat.",
                        exampleSentence: "Butter can melt when heated."
                    ),
                    VocabularyWord(
                        word: "freeze",
                        definition: "To change from liquid to solid with cold.",
                        exampleSentence: "Water can freeze into ice."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Heat can melt solids such as butter into liquids.",
                        explanation: "Cooling can make liquids solid again."
                    ),
                    KnowledgeFact(
                        fact: "Melting and freezing are physical state changes.",
                        explanation: "Cooking uses state changes to shape texture."
                    ),
                    KnowledgeFact(
                        fact: "Water can freeze into ice or melt back to liquid.",
                        explanation: "State knowledge helps cooks predict heat effects."
                    )
                ],
                creativePrompt: "Write three sentences about one food that melts and then becomes solid again.",
                storyEnding: "You connected heat to state changes like a careful investigator.",
                readingSkill: "Infer how heat and cooling change solid and liquid states",
                reflectionPrompt: "Which state-change example from the notes would you try with a grown-up?",
                hints: [
                    "Compare melt with freeze",
                    "Reread physical state changes"
                ],
                commonMistakes: [
                    "Claiming food states never change"
                ],
                successCriteria: [
                    "Uses melt or freeze evidence",
                    "Links heat to solid/liquid change"
                ],
                learningObjectives: [
                    "Infer how heat and cooling change food between solid and liquid",
                    "fp:discovery.Cooking.confidentReader"
                ],
                activityFingerprint: "cooking.discovery.confident.states"
            )
        }
    }


    // MARK: - Nature Discovery

    private static func natureDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Habitats Are Homes",
                storyOpening: "Movo pauses on a forest trail. Every animal needs a place that fits—food, water, and a safe spot to rest.",
                missionPrompt: "Look for one true science fact about habitats in the notes.",
                readingPassage: "A habitat is a home for living things in nature. A forest trail can give food, water, and shelter. A frog may need a wet stream near plants and leaf cover. Habitats help animals stay alive among the trees. One shady stream can be a whole frog neighborhood.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what is a habitat?",
                        ["A home for living things in nature", "A toy shelf indoors only", "A single rock with no water or food"],
                        "A home for living things in nature",
                        "A habitat is a home for living things in nature."
                    ),
                    discoveryMCQ(
                        "What can a forest trail habitat give?",
                        ["Food, water, and shelter", "Only painted trail signs", "Only empty dry air forever"],
                        "Food, water, and shelter",
                        "A forest trail habitat can give food, water, and shelter."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "habitat",
                        definition: "A home that gives living things what they need.",
                        exampleSentence: "A wet stream habitat can help a frog."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A habitat is a nature home that gives food, water, and shelter.",
                        explanation: "Forest trails and streams help animals stay alive."
                    ),
                    KnowledgeFact(
                        fact: "Different animals need different habitats among plants and trees.",
                        explanation: "A frog may need a wet stream near leaf cover."
                    )
                ],
                creativePrompt: "Draw an animal on a forest trail habitat with a plant, a stream, and leaf cover.",
                storyEnding: "You logged a real nature habitat fact. Great science work!",
                readingSkill: "Use a science note to define habitat",
                reflectionPrompt: "Name one thing a forest trail habitat gives living things.",
                hints: [
                    "Look for forest trail",
                    "Find food, water, and shelter"
                ],
                commonMistakes: [
                    "Choosing a claim with no needs met"
                ],
                successCriteria: [
                    "Defines habitat as a home",
                    "Lists a need"
                ],
                learningObjectives: [
                    "Identify that habitats provide food, water, and shelter",
                    "fp:discovery.Nature.beginner"
                ],
                activityFingerprint: "nature.discovery.beginner.habitats"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Seasons Change Conditions",
                storyOpening: "Movo points at waking leaf buds. Warm bright months arrive as seasons change temperature and daylight.",
                missionPrompt: "Hunt for one true science fact about seasons in the notes.",
                readingPassage: "Seasons change temperature and daylight over the year on a nature trail. Forest plants may grow faster in warm bright seasons when leaf buds open. Some animals grow thicker coats in cold seasons beside the trees. Food can be harder to find in winter near the frozen stream. Living things in the garden and forest respond to seasonal changes.",
                questions: [
                    discoveryMCQ(
                        "What do seasons change over the year?",
                        ["Temperature and daylight", "Only the names of months", "Only the shape of rocks"],
                        "Temperature and daylight",
                        "Seasons change temperature and daylight over the year."
                    ),
                    discoveryMCQ(
                        "When may forest plants grow faster?",
                        ["In warm bright seasons when leaf buds open", "Only in total darkness always", "Only under deep frozen snow"],
                        "In warm bright seasons when leaf buds open",
                        "Forest plants may grow faster in warm bright seasons when leaf buds open."
                    ),
                    discoveryMCQ(
                        "What can be harder to find in winter near the frozen stream?",
                        ["Food", "Only the frozen ice itself", "Only the sound of wind"],
                        "Food",
                        "Food can be harder to find in winter near a frozen stream."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "season",
                        definition: "A time of year with typical weather patterns.",
                        exampleSentence: "Winter is a cold season along the nature trail."
                    ),
                    VocabularyWord(
                        word: "temperature",
                        definition: "How hot or cold something is.",
                        exampleSentence: "Seasons can change temperature in the forest."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Seasons change temperature and daylight over the year on a nature trail.",
                        explanation: "Forest plants and animals respond to those changes."
                    ),
                    KnowledgeFact(
                        fact: "Food can be harder to find in winter near a frozen stream.",
                        explanation: "Some animals grow thicker coats in cold seasons beside the trees."
                    )
                ],
                creativePrompt: "Draw one warm-season forest plant with open leaf buds and one cold-season animal coat by the trees.",
                storyEnding: "You used nature season evidence carefully.",
                readingSkill: "Use evidence to explain seasonal changes",
                reflectionPrompt: "How might an animal beside the trees respond to a cold season?",
                hints: [
                    "Find temperature and daylight",
                    "Look for winter near the stream"
                ],
                commonMistakes: [
                    "Thinking seasons never affect living things"
                ],
                successCriteria: [
                    "Names temperature or daylight change",
                    "Cites a living response"
                ],
                learningObjectives: [
                    "Explain that seasons change conditions living things respond to",
                    "fp:discovery.Nature.earlyReader"
                ],
                activityFingerprint: "nature.discovery.early.seasons"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Soil Supports Plants",
                storyOpening: "Movo digs a handful of soil with you. Roots drink water and nutrients stored in that dark earth.",
                missionPrompt: "Find the main idea about soil. Use details from the notes.",
                readingPassage: "Soil holds plant roots in place. It can store water and nutrients plants need. Healthy soil often includes tiny living things that help recycle materials. Hard packed soil can make root growth harder. The main idea is that soil is a living support system for plants, not just dirt underfoot.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Soil is a living support system for plants, not just dirt underfoot", "Soil only decorates gardens", "Plants never need soil support"],
                        "Soil is a living support system for plants, not just dirt underfoot",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What can soil store for plants?",
                        ["Water and nutrients", "Only shiny pebbles", "Only empty air pockets with no food"],
                        "Water and nutrients",
                        "Soil can store water and nutrients for plants."
                    ),
                    discoveryMCQ(
                        "What can hard packed soil make harder?",
                        ["Root growth", "Only the color of leaves", "Only the smell of rain"],
                        "Root growth",
                        "Hard packed soil can make root growth harder."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "soil",
                        definition: "The ground material that can hold roots, water, and nutrients.",
                        exampleSentence: "Plant roots grow in soil."
                    ),
                    VocabularyWord(
                        word: "nutrient",
                        definition: "A material living things need to grow.",
                        exampleSentence: "Soil can store nutrients for plants."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Soil holds roots and can store water and nutrients.",
                        explanation: "Healthy soil may include tiny living recyclers."
                    ),
                    KnowledgeFact(
                        fact: "Hard packed soil can make root growth harder.",
                        explanation: "Soil is a support system for plants."
                    )
                ],
                creativePrompt: "Draw plant roots in soil with water drops, and label nutrients.",
                storyEnding: "You found the soil main idea like a careful earth scientist.",
                readingSkill: "Identify the main idea about soil supporting plants",
                reflectionPrompt: "Why is soil more than just dirt underfoot?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find roots"
                ],
                commonMistakes: [
                    "Missing the support-system main idea"
                ],
                successCriteria: [
                    "States the soil main idea",
                    "Cites water, nutrients, or roots"
                ],
                learningObjectives: [
                    "Explain that soil supports plants with anchorage, water, and nutrients",
                    "fp:discovery.Nature.growingReader"
                ],
                activityFingerprint: "nature.discovery.growing.soil"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Water for Plants",
                storyOpening: "Movo joins your nature science walk. Together you investigate how water movement helps plants survive.",
                missionPrompt: "Use evidence from the notes. Explain why plants need a steady water supply.",
                readingPassage: "Roots take in water from soil. Water travels up through plant tubes to leaves. Leaves use water in making food with sunlight. Too little water can wilt a plant. Too much standing water can harm roots that need air. Plants survive when water amount and timing fit their needs.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about plant water needs?",
                        ["Plants need the right amount of water delivered from roots to leaves", "Plants never use water in leaves", "Any amount of standing water always helps"],
                        "Plants need the right amount of water delivered from roots to leaves",
                        "Amount and timing must fit plant needs."
                    ),
                    discoveryMCQ(
                        "Where do roots take in water from?",
                        ["Soil", "Only from dry empty air", "Only from sunlight alone"],
                        "Soil",
                        "Roots take in water from the soil."
                    ),
                    discoveryMCQ(
                        "What can too little water do?",
                        ["Wilt a plant", "Make a plant grow without any water", "Help the plant make extra sunlight"],
                        "Wilt a plant",
                        "Too little water can wilt a plant."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "root",
                        definition: "A plant part that takes in water from soil.",
                        exampleSentence: "Roots pull water from the ground."
                    ),
                    VocabularyWord(
                        word: "wilt",
                        definition: "To droop from lack of water.",
                        exampleSentence: "A dry plant can wilt."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Roots take in water that travels up to leaves.",
                        explanation: "Leaves use water when making food with sunlight."
                    ),
                    KnowledgeFact(
                        fact: "Too little water can wilt a plant.",
                        explanation: "Too much standing water can harm roots that need air."
                    ),
                    KnowledgeFact(
                        fact: "Plants survive when water amount and timing fit their needs.",
                        explanation: "Water balance matters."
                    )
                ],
                creativePrompt: "Write three sentences tracing water from soil to leaf.",
                storyEnding: "You traced plant water flow like a careful investigator.",
                readingSkill: "Infer why water amount and path matter for plants",
                reflectionPrompt: "Which water clue from the notes would you check in a garden?",
                hints: [
                    "Follow roots to leaves",
                    "Compare too little with too much"
                ],
                commonMistakes: [
                    "Claiming any water amount always helps"
                ],
                successCriteria: [
                    "Uses root-to-leaf evidence",
                    "Links water balance to survival"
                ],
                learningObjectives: [
                    "Infer how water moves through plants and why balance matters",
                    "fp:discovery.Nature.confidentReader"
                ],
                activityFingerprint: "nature.discovery.confident.water"
            )
        }
    }


    // MARK: - Bugs Discovery

    private static func bugsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Six Legs",
                storyOpening: "Movo counts legs on a bug with you. Six means insect, eight means something else!",
                missionPrompt: "Pick out one true fact about insect legs from the notes.",
                readingPassage: "Insects have six legs. The legs help them walk and climb. Spiders are not insects because they have eight legs. Counting legs helps scientists sort animals. Six tiny feet can climb a vertical wall of glass.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, how many legs do insects have?",
                        ["Six", "Only two", "Twenty"],
                        "Six",
                        "Insects have six legs."
                    ),
                    discoveryMCQ(
                        "Why are spiders not insects?",
                        ["They have eight legs", "They have six legs too", "They have no legs"],
                        "They have eight legs",
                        "Spiders have eight legs, so they are not insects."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "insect",
                        definition: "A small animal with six legs and a body in parts.",
                        exampleSentence: "An ant is an insect with six legs."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Insects have six legs.",
                        explanation: "Legs help them walk and climb."
                    ),
                    KnowledgeFact(
                        fact: "Spiders have eight legs, so they are not insects.",
                        explanation: "Counting legs helps sort animals."
                    )
                ],
                creativePrompt: "Draw an insect with six legs. Count them out loud.",
                storyEnding: "You logged a real insect fact. Great science work!",
                readingSkill: "Use a science note to count insect legs",
                reflectionPrompt: "How many legs should you count on an insect?",
                hints: [
                    "Look for six",
                    "Find spiders"
                ],
                commonMistakes: [
                    "Counting spiders as insects"
                ],
                successCriteria: [
                    "Names six legs",
                    "Uses spider contrast"
                ],
                learningObjectives: [
                    "Identify that insects have six legs",
                    "fp:discovery.Bugs.beginner"
                ],
                activityFingerprint: "bugs.discovery.beginner.six-legs"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Hard Outer Armor",
                storyOpening: "Movo peeks at an insect's hard outer armor. It protects soft parts inside—come study the exoskeleton!",
                missionPrompt: "Hunt for one true science fact about exoskeletons in the notes.",
                readingPassage: "Many insects wear a hard outer covering called an exoskeleton. The exoskeleton protects soft parts inside. As an insect grows, it may shed the old covering. Soft skin alone would not protect as well. Armor on the outside is part of insect body design.",
                questions: [
                    discoveryMCQ(
                        "What is an exoskeleton?",
                        ["A hard outer covering", "A soft inner pillow only", "A thin fur coat only"],
                        "A hard outer covering",
                        "An exoskeleton is a hard outer covering."
                    ),
                    discoveryMCQ(
                        "What does an exoskeleton protect?",
                        ["Soft parts inside", "Only the insect's shadow", "Only distant tree tops"],
                        "Soft parts inside",
                        "An exoskeleton protects soft parts inside the insect."
                    ),
                    discoveryMCQ(
                        "What may an insect do as it grows?",
                        ["Shed the old covering", "Keep one shell forever without change", "Break into tiny pieces"],
                        "Shed the old covering",
                        "As it grows, an insect may shed the old covering."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "exoskeleton",
                        definition: "A hard outer covering that supports and protects an animal.",
                        exampleSentence: "A beetle exoskeleton feels hard."
                    ),
                    VocabularyWord(
                        word: "shed",
                        definition: "To drop an old covering.",
                        exampleSentence: "An insect may shed its old exoskeleton."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Many insects have a hard exoskeleton that protects soft parts.",
                        explanation: "Outside armor is part of insect design."
                    ),
                    KnowledgeFact(
                        fact: "Growing insects may shed an old covering.",
                        explanation: "Soft skin alone would not protect as well."
                    )
                ],
                creativePrompt: "Draw a beetle with a hard outer shell, and label exoskeleton.",
                storyEnding: "You used exoskeleton evidence carefully.",
                readingSkill: "Use evidence to explain insect exoskeletons",
                reflectionPrompt: "How does an exoskeleton help an insect?",
                hints: [
                    "Find hard outer covering",
                    "Look for protect"
                ],
                commonMistakes: [
                    "Thinking insects have only soft skin"
                ],
                successCriteria: [
                    "Defines exoskeleton",
                    "Cites protection or shedding"
                ],
                learningObjectives: [
                    "Explain that insect exoskeletons protect soft parts",
                    "fp:discovery.Bugs.earlyReader"
                ],
                activityFingerprint: "bugs.discovery.early.exoskeleton"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Pollination Helpers",
                storyOpening: "Movo watches a bee dip into a flower for nectar. It may carry pollen to the next bloom—let's follow the science!",
                missionPrompt: "Find the main idea about pollination. Use details from the notes.",
                readingPassage: "Some insects visit flowers for nectar. Pollen sticks to their bodies and moves to other flowers. That move is called pollination. Pollination helps plants make seeds and fruit. The main idea is that insect visits can transfer pollen and support plant reproduction.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Insect visits can transfer pollen and support plant reproduction", "Insects visit flowers only to remove all plants", "Pollination never involves insects"],
                        "Insect visits can transfer pollen and support plant reproduction",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "Why do some insects visit flowers?",
                        ["For nectar", "Only for stone chips", "Only for empty petals with no food"],
                        "For nectar",
                        "Some insects visit flowers for nectar."
                    ),
                    discoveryMCQ(
                        "What does pollination help plants make?",
                        ["Seeds and fruit", "Only more leaves forever", "Only thicker bark alone"],
                        "Seeds and fruit",
                        "Pollination helps plants make seeds and fruit."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "nectar",
                        definition: "A sweet liquid in flowers that insects may drink.",
                        exampleSentence: "Bees visit flowers for nectar."
                    ),
                    VocabularyWord(
                        word: "pollination",
                        definition: "Moving pollen that helps plants make seeds.",
                        exampleSentence: "Insect pollination helps plants."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Insects can carry pollen while visiting flowers for nectar.",
                        explanation: "Pollination helps plants make seeds and fruit."
                    ),
                    KnowledgeFact(
                        fact: "Pollination is the move of pollen to other flowers.",
                        explanation: "Insect visits support plant reproduction."
                    )
                ],
                creativePrompt: "Draw an insect with pollen dots moving between two flowers.",
                storyEnding: "You found the pollination main idea like a careful biologist.",
                readingSkill: "Identify the main idea about insect pollination",
                reflectionPrompt: "How can a bug help a plant make seeds?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find pollen"
                ],
                commonMistakes: [
                    "Missing the pollen-transfer main idea"
                ],
                successCriteria: [
                    "States the pollination main idea",
                    "Cites nectar or seeds"
                ],
                learningObjectives: [
                    "Explain that insects can transfer pollen and support plant reproduction",
                    "fp:discovery.Bugs.growingReader"
                ],
                activityFingerprint: "bugs.discovery.growing.pollination"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Metamorphosis Stages",
                storyOpening: "Movo joins your bug science team. Together you investigate how life stages work in insect metamorphosis.",
                missionPrompt: "Use evidence from the notes. Explain why metamorphosis is more than one body form.",
                readingPassage: "Complete metamorphosis has four stages. Those stages are egg, larva, pupa, and adult. A caterpillar larva eats and grows before becoming a pupa. Inside the pupa, the body reorganizes into an adult form such as a butterfly. Adults may have different food needs than larvae. Metamorphosis lets one species use different habitats and foods across life. Stage science explains big body changes without magic.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about metamorphosis?",
                        ["One species can use different forms, foods, and habitats across stages", "Insects stay one form forever with no stages", "Pupa stages remove all growth"],
                        "One species can use different forms, foods, and habitats across stages",
                        "Metamorphosis uses different stages across life."
                    ),
                    discoveryMCQ(
                        "What stages does complete metamorphosis include?",
                        ["Egg, larva, pupa, and adult", "Only adult forever", "Only egg and adult with nothing between"],
                        "Egg, larva, pupa, and adult",
                        "Complete metamorphosis has four stages: egg, larva, pupa, and adult."
                    ),
                    discoveryMCQ(
                        "What happens inside the pupa?",
                        ["The body reorganizes into an adult form", "The insect skips every stage", "The insect stays a caterpillar forever"],
                        "The body reorganizes into an adult form",
                        "Inside the pupa, the body reorganizes into an adult form."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "metamorphosis",
                        definition: "A big body change through life stages.",
                        exampleSentence: "Butterfly metamorphosis has a pupa stage."
                    ),
                    VocabularyWord(
                        word: "larva",
                        definition: "A young stage that often eats and grows, such as a caterpillar.",
                        exampleSentence: "A caterpillar is a larva."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Complete metamorphosis has four stages: egg, larva, pupa, and adult.",
                        explanation: "A pupa reorganizes the body into an adult form."
                    ),
                    KnowledgeFact(
                        fact: "Adults may have different food needs than larvae.",
                        explanation: "Stages can use different habitats and foods."
                    ),
                    KnowledgeFact(
                        fact: "Metamorphosis explains big body changes with stage science.",
                        explanation: "It is not magic."
                    )
                ],
                creativePrompt: "Draw four boxes for egg, larva, pupa, and adult, and label each stage.",
                storyEnding: "You connected life stages like a careful investigator.",
                readingSkill: "Infer why metamorphosis uses multiple body forms",
                reflectionPrompt: "Which metamorphosis stage from the notes would you watch for outside?",
                hints: [
                    "List the four stages",
                    "Compare larva food with adult food"
                ],
                commonMistakes: [
                    "Treating metamorphosis as a single unchanging form"
                ],
                successCriteria: [
                    "Uses stage evidence",
                    "Links different forms to different needs"
                ],
                learningObjectives: [
                    "Infer how metamorphosis stages allow different forms and needs",
                    "fp:discovery.Bugs.confidentReader"
                ],
                activityFingerprint: "bugs.discovery.confident.metamorphosis"
            )
        }
    }


    // MARK: - Weather Discovery

    private static func weatherDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Clouds Hold Water",
                storyOpening: "Movo looks up at white fluffy shapes in the sky. They are not cotton—they are made of tiny water!",
                missionPrompt: "Catch one true science fact about clouds in the notes.",
                readingPassage: "Clouds are made of tiny water drops or ice. They float high in the air. Some clouds look white and fluffy. Clouds are part of weather. One cloud can hold millions of drops too small to see alone.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what are clouds made of?",
                        ["Tiny water drops or ice", "Only solid rock dust", "Only empty dry air"],
                        "Tiny water drops or ice",
                        "Clouds are made of tiny water drops or ice."
                    ),
                    discoveryMCQ(
                        "Where do clouds float?",
                        ["High in the air", "Only under the ground", "Only inside a closed book"],
                        "High in the air",
                        "Clouds float high in the air."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "cloud",
                        definition: "A group of tiny water drops or ice in the sky.",
                        exampleSentence: "A white cloud floats high in the air."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Clouds are made of tiny water drops or ice.",
                        explanation: "They float high in the air."
                    ),
                    KnowledgeFact(
                        fact: "Clouds are part of weather.",
                        explanation: "Some clouds look white and fluffy."
                    )
                ],
                creativePrompt: "Draw a fluffy cloud and label water drops.",
                storyEnding: "You logged a real cloud fact. Great science work!",
                readingSkill: "Use a science note to explain what clouds are",
                reflectionPrompt: "Name one thing clouds are made of.",
                hints: [
                    "Look for water drops or ice",
                    "Find float"
                ],
                commonMistakes: [
                    "Choosing metal as cloud material"
                ],
                successCriteria: [
                    "Names water drops or ice",
                    "Uses air fact"
                ],
                learningObjectives: [
                    "Identify that clouds are tiny water drops or ice in the air",
                    "fp:discovery.Weather.beginner"
                ],
                activityFingerprint: "weather.discovery.beginner.clouds"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Wind Is Moving Air",
                storyOpening: "Movo's scarf flaps in the breeze. Leaves and flags move for a reason—wind is simply air that is moving.",
                missionPrompt: "Hunt for one true science fact about wind in the notes.",
                readingPassage: "Wind is air that is moving. Moving air can push leaves and flags. Strong wind has more push than a gentle breeze. Wind can feel cool on hot skin. Weather includes wind speed and direction.",
                questions: [
                    discoveryMCQ(
                        "What is wind?",
                        ["Air that is moving", "Still air that never shifts", "Only sunlight with no air"],
                        "Air that is moving",
                        "Wind is air that is moving."
                    ),
                    discoveryMCQ(
                        "What can moving air push?",
                        ["Leaves and flags", "Only buried underground rocks", "Only locked indoor doors"],
                        "Leaves and flags",
                        "Moving air can push leaves and flags."
                    ),
                    discoveryMCQ(
                        "What does strong wind have compared with a gentle breeze?",
                        ["More push", "Less push always", "No air at all"],
                        "More push",
                        "Strong wind has more push than a gentle breeze."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "wind",
                        definition: "Moving air.",
                        exampleSentence: "Wind can push a flag."
                    ),
                    VocabularyWord(
                        word: "breeze",
                        definition: "A gentle wind.",
                        exampleSentence: "A soft breeze feels light."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Wind is moving air that can push objects.",
                        explanation: "Strong wind has more push than a breeze."
                    ),
                    KnowledgeFact(
                        fact: "Weather includes wind speed and direction.",
                        explanation: "Wind can feel cool on hot skin."
                    )
                ],
                creativePrompt: "Draw a flag bending in wind, and label moving air.",
                storyEnding: "You used wind evidence carefully.",
                readingSkill: "Use evidence to define wind as moving air",
                reflectionPrompt: "How can you tell strong wind from a gentle breeze?",
                hints: [
                    "Find moving air",
                    "Look for more push"
                ],
                commonMistakes: [
                    "Thinking wind is not air"
                ],
                successCriteria: [
                    "Defines wind as moving air",
                    "Cites push comparison"
                ],
                learningObjectives: [
                    "Explain that wind is moving air with different push strengths",
                    "fp:discovery.Weather.earlyReader"
                ],
                activityFingerprint: "weather.discovery.early.wind"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Rain from Cooling",
                storyOpening: "Movo watches gray clouds gather with you. Drops grow heavier and heavier until they fall as rain.",
                missionPrompt: "Find the main idea about rain. Use details from the notes.",
                readingPassage: "Warm air can hold water vapor. When air cools, vapor can turn into tiny drops. Drops can join and grow heavy enough to fall as rain. Cooling is a key step before rainfall. The main idea is that rain forms when cooled vapor becomes drops heavy enough to fall.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Rain forms when cooled vapor becomes drops heavy enough to fall", "Rain falls only from dry warm rocks", "Cooling never relates to rain"],
                        "Rain forms when cooled vapor becomes drops heavy enough to fall",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What can warm air hold?",
                        ["Water vapor", "Only solid ice blocks always", "Only dry dust with no water"],
                        "Water vapor",
                        "Warm air can hold water vapor."
                    ),
                    discoveryMCQ(
                        "What happens when drops grow heavy enough?",
                        ["They fall as rain", "They float upward forever", "They become dry dust"],
                        "They fall as rain",
                        "When drops grow heavy enough, they fall as rain."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "vapor",
                        definition: "Water in gas form in the air.",
                        exampleSentence: "Warm air can hold water vapor."
                    ),
                    VocabularyWord(
                        word: "cool",
                        definition: "To become less warm.",
                        exampleSentence: "When air cools, drops can form."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Cooling can turn water vapor into tiny drops.",
                        explanation: "Drops may join and fall as rain."
                    ),
                    KnowledgeFact(
                        fact: "Warm air can hold water vapor.",
                        explanation: "Cooling is a key step before rainfall."
                    )
                ],
                creativePrompt: "Draw vapor cooling into drops that fall, and label rain.",
                storyEnding: "You found the rain main idea like a careful weather scientist.",
                readingSkill: "Identify the main idea about rain forming from cooling",
                reflectionPrompt: "Why is cooling important before rain falls?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find vapor"
                ],
                commonMistakes: [
                    "Missing the cooling-to-drops main idea"
                ],
                successCriteria: [
                    "States the rain main idea",
                    "Cites cooling or heavy drops"
                ],
                learningObjectives: [
                    "Explain that rain forms when cooled vapor becomes falling drops",
                    "fp:discovery.Weather.growingReader"
                ],
                activityFingerprint: "weather.discovery.growing.rain"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Storm Safety Science",
                storyOpening: "Movo joins your weather science team. Together you investigate how storm hazards lead to safe choices.",
                missionPrompt: "Use evidence from the notes. Explain why storm safety rules follow weather science.",
                readingPassage: "Thunderstorms can bring lightning, strong wind, and heavy rain. Lightning is a powerful electric spark that can injure people outdoors. Strong wind can move loose objects. Heavy rain can create slippery roads and flooding in low places. Safety rules such as seeking sturdy shelter reduce exposure to those hazards. Storm science guides choices that lower risk.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about storm safety rules?",
                        ["They reduce exposure to hazards explained by weather science", "They exist only to decorate posters", "Storms never create real hazards"],
                        "They reduce exposure to hazards explained by weather science",
                        "Safety rules reduce exposure to storm hazards."
                    ),
                    discoveryMCQ(
                        "What is lightning?",
                        ["A powerful electric spark", "Only a quiet cloud shadow", "Only warm steam with no spark"],
                        "A powerful electric spark",
                        "Lightning is a powerful electric spark."
                    ),
                    discoveryMCQ(
                        "What can heavy rain create in low places?",
                        ["Flooding", "Only dry cracked ground", "Only hotter sunshine"],
                        "Flooding",
                        "Heavy rain can create flooding in low places."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "lightning",
                        definition: "A powerful electric spark during a storm.",
                        exampleSentence: "Lightning can be dangerous outdoors."
                    ),
                    VocabularyWord(
                        word: "shelter",
                        definition: "A safe place that protects from weather hazards.",
                        exampleSentence: "Sturdy shelter reduces storm risk."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Thunderstorms can bring lightning, strong wind, and heavy rain.",
                        explanation: "Each hazard can cause harm."
                    ),
                    KnowledgeFact(
                        fact: "Seeking sturdy shelter reduces exposure to storm hazards.",
                        explanation: "Safety rules follow weather science."
                    ),
                    KnowledgeFact(
                        fact: "Heavy rain can cause slippery roads and flooding in low places.",
                        explanation: "Strong wind can move loose objects."
                    )
                ],
                creativePrompt: "Write three sentences about one storm hazard and one safe action.",
                storyEnding: "You connected hazards to safety choices like a careful investigator.",
                readingSkill: "Infer why storm safety rules follow weather science",
                reflectionPrompt: "Which storm-safety clue from the notes would you practice at home?",
                hints: [
                    "List lightning, wind, and rain hazards",
                    "Reread sturdy shelter"
                ],
                commonMistakes: [
                    "Treating safety rules as unrelated to real hazards"
                ],
                successCriteria: [
                    "Uses hazard evidence",
                    "Links shelter to lower risk"
                ],
                learningObjectives: [
                    "Infer how storm safety rules reduce exposure to weather hazards",
                    "fp:discovery.Weather.confidentReader"
                ],
                activityFingerprint: "weather.discovery.confident.storm-safety"
            )
        }
    }


    // MARK: - Farm Animals Discovery

    private static func farmAnimalsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Mammals and Milk",
                storyOpening: "Sunny the pony nuzzles you near the barn. On a farm, a cow's baby drinks milk made by its mother—just like other mammal babies.",
                missionPrompt: "Discover one true fact about mammals and milk in the science notes.",
                readingPassage: "Cows are mammals. Mammal mothers can make milk for babies. Milk helps young mammals grow. Not all farm animals make milk for people. A calf can drink milk that its mother makes right after birth.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what are cows?",
                        ["Mammals", "Insects with six legs", "Fish with gills"],
                        "Mammals",
                        "Cows are mammals."
                    ),
                    discoveryMCQ(
                        "What can mammal mothers make for babies?",
                        ["Milk", "Only dry grain for adults", "Only water from puddles"],
                        "Milk",
                        "Mammal mothers can make milk for babies."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "mammal",
                        definition: "An animal that can make milk for babies.",
                        exampleSentence: "A cow is a mammal."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Cows are mammals whose mothers can make milk.",
                        explanation: "Milk helps young mammals grow."
                    ),
                    KnowledgeFact(
                        fact: "Not all farm animals make milk for people.",
                        explanation: "Mammal science explains milk."
                    )
                ],
                creativePrompt: "Draw a cow and a milk pail, and label the cow as a mammal.",
                storyEnding: "You logged a real mammal fact. Great science work!",
                readingSkill: "Use a science note to link mammals and milk",
                reflectionPrompt: "Name one thing mammal mothers can make for babies.",
                hints: [
                    "Look for mammals",
                    "Find milk"
                ],
                commonMistakes: [
                    "Calling cows insects"
                ],
                successCriteria: [
                    "Names cows as mammals",
                    "Uses milk fact"
                ],
                learningObjectives: [
                    "Identify that cows are mammals that can make milk",
                    "fp:discovery.Farm Animals.beginner"
                ],
                activityFingerprint: "farm-animals.discovery.beginner.mammals-milk"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Chickens and Eggs",
                storyOpening: "Sunny the pony peeks at a warm nest with you. Inside a fertilized egg, a chick grows until it is ready to hatch.",
                missionPrompt: "Hunt for one true science fact about chicken eggs in the notes.",
                readingPassage: "Chickens are birds that can lay eggs. An eggshell protects the soft inside. Warmth helps a chick grow inside a fertilized egg. Not every egg on a farm will become a chick. Eggs are part of bird life cycles.",
                questions: [
                    discoveryMCQ(
                        "What kind of animals are chickens?",
                        ["Birds that can lay eggs", "Fish that breathe with gills only", "Insects with six legs only"],
                        "Birds that can lay eggs",
                        "Chickens are birds that can lay eggs."
                    ),
                    discoveryMCQ(
                        "What does an eggshell do?",
                        ["Protects the soft inside", "Turns eggs into metal", "Removes all warmth"],
                        "Protects the soft inside",
                        "An eggshell protects the soft inside."
                    ),
                    discoveryMCQ(
                        "What helps a chick grow inside a fertilized egg?",
                        ["Warmth", "Only freezing cold air", "Only total darkness with no heat"],
                        "Warmth",
                        "Warmth helps a chick grow inside a fertilized egg."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "eggshell",
                        definition: "The hard outer covering of an egg.",
                        exampleSentence: "The eggshell protects the inside."
                    ),
                    VocabularyWord(
                        word: "fertilized",
                        definition: "Able to grow into a baby animal when conditions are right.",
                        exampleSentence: "A fertilized egg can become a chick with warmth."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Chickens are birds that can lay eggs.",
                        explanation: "Eggshells protect the soft inside."
                    ),
                    KnowledgeFact(
                        fact: "Warmth helps a chick grow inside a fertilized egg.",
                        explanation: "Not every farm egg becomes a chick."
                    )
                ],
                creativePrompt: "Draw an egg with a shell label and a warmth arrow.",
                storyEnding: "You used egg evidence carefully.",
                readingSkill: "Use evidence to explain chicken eggs",
                reflectionPrompt: "How does an eggshell help?",
                hints: [
                    "Find birds",
                    "Look for warmth"
                ],
                commonMistakes: [
                    "Thinking every egg becomes a chick"
                ],
                successCriteria: [
                    "Names chickens as birds",
                    "Cites shell or warmth"
                ],
                learningObjectives: [
                    "Explain that chicken eggs have protective shells and may need warmth",
                    "fp:discovery.Farm Animals.earlyReader"
                ],
                activityFingerprint: "farm-animals.discovery.early.eggs"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Plant Eaters on the Farm",
                storyOpening: "Sunny the pony munches a mouthful of hay. Cows and horses chew grass, hay, or grain—many farm animals are plant eaters.",
                missionPrompt: "Find the main idea about plant-eating farm animals. Use details from the notes.",
                readingPassage: "Many farm animals eat plants such as grass, hay, or grain. Teeth and stomachs are built for chewing and digesting plant food. Plant eaters need enough forage each day. A diet without plants would not match their body plan. The main idea is that many farm animals are plant eaters whose bodies match a plant diet.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Many farm animals are plant eaters whose bodies match a plant diet", "Farm animals never eat plants", "Teeth never relate to diet"],
                        "Many farm animals are plant eaters whose bodies match a plant diet",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What do many farm animals eat?",
                        ["Plants such as grass, hay, or grain", "Only metal tools", "Only plastic toys"],
                        "Plants such as grass, hay, or grain",
                        "Many farm animals eat plants such as grass, hay, or grain."
                    ),
                    discoveryMCQ(
                        "What would not match their body plan?",
                        ["A diet without plants", "A diet with grass", "A diet with hay"],
                        "A diet without plants",
                        "A diet without plants would not match their body plan."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "forage",
                        definition: "Plant food animals find or are given to eat.",
                        exampleSentence: "Cows need forage such as grass or hay."
                    ),
                    VocabularyWord(
                        word: "digest",
                        definition: "To break down food inside the body.",
                        exampleSentence: "Stomachs help digest plant food."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Many farm animals eat plants such as grass, hay, or grain.",
                        explanation: "Teeth and stomachs match plant diets."
                    ),
                    KnowledgeFact(
                        fact: "Plant eaters need enough forage each day.",
                        explanation: "Bodies are built for plant food."
                    )
                ],
                creativePrompt: "Draw a farm animal eating hay, and label it as a plant eater.",
                storyEnding: "You found the plant-eater main idea like a careful farm scientist.",
                readingSkill: "Identify the main idea about farm plant eaters",
                reflectionPrompt: "How do teeth and stomachs relate to a plant diet?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find forage"
                ],
                commonMistakes: [
                    "Missing the body-plan main idea"
                ],
                successCriteria: [
                    "States the plant-eater main idea",
                    "Cites grass, hay, or body match"
                ],
                learningObjectives: [
                    "Explain that many farm animals are plant eaters matched to plant diets",
                    "fp:discovery.Farm Animals.growingReader"
                ],
                activityFingerprint: "farm-animals.discovery.growing.plant-eaters"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Clean Water and Care",
                storyOpening: "Sunny the pony stands by the water trough as your science partner. Together you investigate how clean water keeps farm animals healthy.",
                missionPrompt: "Use evidence from the notes. Explain why clean water is part of animal care science.",
                readingPassage: "Farm animals need fresh water every day. Dirty water can carry germs that make animals sick. Clean tanks and troughs reduce that risk. Hot days increase how much water animals drink. Care routines that refresh water support health as much as food does. Water quality is a real part of farm science.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about clean water on a farm?",
                        ["It supports health by reducing germ risk and meeting daily needs", "Animals never need fresh water", "Only food matters and water never matters"],
                        "It supports health by reducing germ risk and meeting daily needs",
                        "Clean water supports health by reducing germ risk and meeting daily needs."
                    ),
                    discoveryMCQ(
                        "What can dirty water carry?",
                        ["Germs that make animals sick", "Only harmless clean air", "Only extra vitamins always"],
                        "Germs that make animals sick",
                        "Dirty water can carry germs that make animals sick."
                    ),
                    discoveryMCQ(
                        "What do hot days increase?",
                        ["How much water animals drink", "How little water animals need", "How animals avoid all water"],
                        "How much water animals drink",
                        "Hot days increase drinking needs."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "trough",
                        definition: "A container that holds water or food for animals.",
                        exampleSentence: "A clean trough holds fresh water."
                    ),
                    VocabularyWord(
                        word: "germ",
                        definition: "A tiny living thing that can cause sickness.",
                        exampleSentence: "Dirty water can carry germs."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Farm animals need fresh water every day.",
                        explanation: "Hot days increase drinking needs."
                    ),
                    KnowledgeFact(
                        fact: "Dirty water can carry germs that make animals sick.",
                        explanation: "Clean tanks and troughs reduce risk."
                    ),
                    KnowledgeFact(
                        fact: "Water quality is part of farm animal care science.",
                        explanation: "Care routines support health with food and water."
                    )
                ],
                creativePrompt: "Write three sentences about refreshing a water trough on a hot day.",
                storyEnding: "You connected water quality to health like a careful investigator.",
                readingSkill: "Infer why clean water is essential farm care science",
                reflectionPrompt: "Which water-care clue from the notes would you check first on a farm visit?",
                hints: [
                    "Compare clean water with dirty water in the notes.",
                    "Reread the sentence about hot days and drinking."
                ],
                commonMistakes: [
                    "Treating water as optional care"
                ],
                successCriteria: [
                    "Uses clean-water evidence",
                    "Links germs or heat to care needs"
                ],
                learningObjectives: [
                    "Infer how clean water routines support farm animal health",
                    "fp:discovery.Farm Animals.confidentReader"
                ],
                activityFingerprint: "farm-animals.discovery.confident.clean-water"
            )
        }
    }


    // MARK: - Zoo Animals Discovery

    private static func zooAnimalsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Habitat Needs",
                storyOpening: "Movo stands by a zoo habitat sign. A polar bear would overheat in a desert cage—animals need homes that fit their bodies.",
                missionPrompt: "Find one true science fact about habitat needs in the notes.",
                readingPassage: "Zoo animals need habitats that fit them. A polar animal needs cool space. A desert animal needs dry space. Good homes match animal needs. Cool ice and rock can keep a polar animal from getting too hot.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what do zoo animals need?",
                        ["Habitats that fit them", "Only empty concrete rooms", "Only the same space for every species"],
                        "Habitats that fit them",
                        "Zoo animals need habitats that fit them."
                    ),
                    discoveryMCQ(
                        "What does a polar animal need?",
                        ["Cool space", "Only hot dry sand always", "Only steamy jungle heat"],
                        "Cool space",
                        "A polar animal needs cool space that matches its home climate."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "habitat",
                        definition: "A home that fits an animal's needs.",
                        exampleSentence: "A cool habitat can fit a polar animal."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Zoo habitats should match animal needs.",
                        explanation: "Polar animals need cool space."
                    ),
                    KnowledgeFact(
                        fact: "Desert animals need dry space.",
                        explanation: "Good homes match animal needs."
                    )
                ],
                creativePrompt: "Draw two zoo homes, one cool and one dry, and label each animal need.",
                storyEnding: "You logged a real habitat-need fact. Great science work!",
                readingSkill: "Use a science note to match habitats to needs",
                reflectionPrompt: "Name one way a zoo home can fit an animal.",
                hints: [
                    "Look for habitats that fit",
                    "Find cool space"
                ],
                commonMistakes: [
                    "Giving every animal the same home"
                ],
                successCriteria: [
                    "Names fitting habitats",
                    "Uses polar or desert detail"
                ],
                learningObjectives: [
                    "Identify that zoo habitats should match animal needs",
                    "fp:discovery.Zoo Animals.beginner"
                ],
                activityFingerprint: "zoo-animals.discovery.beginner.habitat-needs"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Adaptations Help Survival",
                storyOpening: "Movo looks up at a long-necked zoo friend. A long neck can reach high leaves—body features help animals survive.",
                missionPrompt: "Hunt for one true science fact about adaptations in the notes.",
                readingPassage: "An adaptation is a body trait or behavior that helps survival. Thick fur can help in cold air. Long necks can help reach high leaves. Sharp claws can help climb or grip food. Zoo teachers study adaptations to care for each species.",
                questions: [
                    discoveryMCQ(
                        "What is an adaptation?",
                        ["A body trait or behavior that helps survival", "A random body color with no use", "A temporary shadow on the ground"],
                        "A body trait or behavior that helps survival",
                        "An adaptation helps survival."
                    ),
                    discoveryMCQ(
                        "What can thick fur help with?",
                        ["Cold air", "Only hot desert sun", "Only underwater breathing"],
                        "Cold air",
                        "Thick fur can help animals stay warm in cold air."
                    ),
                    discoveryMCQ(
                        "What can long necks help animals do?",
                        ["Reach high leaves", "Dig deeper underground roots", "Reach underground water only"],
                        "Reach high leaves",
                        "Long necks can help animals reach high leaves."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "adaptation",
                        definition: "A trait that helps an animal survive.",
                        exampleSentence: "Thick fur is a cold-air adaptation."
                    ),
                    VocabularyWord(
                        word: "species",
                        definition: "A specific kind of living thing.",
                        exampleSentence: "Each species may need different care."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Adaptations are traits or behaviors that help survival.",
                        explanation: "Thick fur can help in cold air."
                    ),
                    KnowledgeFact(
                        fact: "Long necks and sharp claws are examples of helpful traits.",
                        explanation: "Zoo teachers study adaptations for care."
                    )
                ],
                creativePrompt: "Draw one animal adaptation and write a short label that explains how it helps.",
                storyEnding: "You used adaptation evidence carefully.",
                readingSkill: "Use evidence to explain animal adaptations",
                reflectionPrompt: "Which adaptation from the notes helps in cold air?",
                hints: [
                    "Find helps survival",
                    "Look for thick fur"
                ],
                commonMistakes: [
                    "Thinking adaptations are only decorations"
                ],
                successCriteria: [
                    "Defines adaptation",
                    "Cites fur, neck, or claws"
                ],
                learningObjectives: [
                    "Explain that adaptations help animals survive",
                    "fp:discovery.Zoo Animals.earlyReader"
                ],
                activityFingerprint: "zoo-animals.discovery.early.adaptations"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Enrichment Keeps Minds Busy",
                storyOpening: "Movo watches keepers add safe puzzles and toys. Enrichment helps animals stay curious and active—come see why!",
                missionPrompt: "Find the main idea about enrichment. Use details from the notes.",
                readingPassage: "Enrichment means safe activities that keep zoo animals curious and active. Climbing structures can invite natural movement. Puzzle feeders can make animals work for food. Bored animals may repeat stress behaviors. The main idea is that enrichment supports healthy animal minds and bodies by offering meaningful challenges.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["Enrichment supports healthy animal minds and bodies by offering meaningful challenges", "Enrichment only decorates empty cages", "Animals never need activity"],
                        "Enrichment supports healthy animal minds and bodies by offering meaningful challenges",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "What is enrichment?",
                        ["Safe activities that keep zoo animals curious and active", "Only locked empty rooms", "Only louder crowd noise"],
                        "Safe activities that keep zoo animals curious and active",
                        "Enrichment means safe activities that keep zoo animals curious and active."
                    ),
                    discoveryMCQ(
                        "What may bored animals do?",
                        ["Repeat stress behaviors", "Sleep without moving for days", "Ignore all food and water"],
                        "Repeat stress behaviors",
                        "Bored animals may repeat stress behaviors."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "enrichment",
                        definition: "Safe activities that keep animals curious and active.",
                        exampleSentence: "A puzzle feeder is enrichment."
                    ),
                    VocabularyWord(
                        word: "curious",
                        definition: "Wanting to explore and learn.",
                        exampleSentence: "Enrichment keeps animals curious."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Enrichment offers safe challenges that keep animals active.",
                        explanation: "Climbing structures invite natural movement."
                    ),
                    KnowledgeFact(
                        fact: "Bored animals may repeat stress behaviors.",
                        explanation: "Puzzle feeders can make animals work for food."
                    )
                ],
                creativePrompt: "Draw a climbing structure and a puzzle feeder, and label both as enrichment.",
                storyEnding: "You found the enrichment main idea like a careful zookeeper scientist.",
                readingSkill: "Identify the main idea about enrichment",
                reflectionPrompt: "How can a puzzle feeder help an animal?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find curious and active"
                ],
                commonMistakes: [
                    "Missing the healthy-minds main idea"
                ],
                successCriteria: [
                    "States the enrichment main idea",
                    "Cites climbing or puzzle detail"
                ],
                learningObjectives: [
                    "Explain that enrichment supports healthy animal minds and bodies",
                    "fp:discovery.Zoo Animals.growingReader"
                ],
                activityFingerprint: "zoo-animals.discovery.growing.enrichment"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Conservation Care",
                storyOpening: "Movo joins your zoo science team. Together you investigate how zoos support conservation science.",
                missionPrompt: "Use evidence from the notes. Explain how zoos can support animal conservation.",
                readingPassage: "Conservation means protecting species and the wild places they need. Some zoos join breeding programs for animals that are rare in the wild. Careful records track family lines and health. Teaching visitors builds support for habitat protection. Zoos cannot replace every wild home, but they can partner in recovery science. Conservation joins care, learning, and habitat protection.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about zoos and conservation?",
                        ["Zoos can partner in recovery through breeding, records, and teaching", "Zoos always replace every wild home completely", "Conservation never involves learning"],
                        "Zoos can partner in recovery through breeding, records, and teaching",
                        "Zoos partner with breeding, records, and teaching."
                    ),
                    discoveryMCQ(
                        "What does conservation mean?",
                        ["Protecting species and the wild places they need", "Only decorating posters", "Only counting ticket sales"],
                        "Protecting species and the wild places they need",
                        "Conservation means protecting species and the wild places they need."
                    ),
                    discoveryMCQ(
                        "What do careful records track?",
                        ["Family lines and health", "Only snack-bar menus", "Only gift-shop toys"],
                        "Family lines and health",
                        "Careful records track family lines and health."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "conservation",
                        definition: "Protecting species and the places they need.",
                        exampleSentence: "Conservation can include breeding programs."
                    ),
                    VocabularyWord(
                        word: "breeding program",
                        definition: "A careful plan to help rare animals have healthy young.",
                        exampleSentence: "Some zoos join breeding programs."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Conservation protects species and wild places.",
                        explanation: "Some zoos join breeding programs for rare animals."
                    ),
                    KnowledgeFact(
                        fact: "Records track family lines and health.",
                        explanation: "Teaching visitors builds support for habitat protection."
                    ),
                    KnowledgeFact(
                        fact: "Zoos cannot replace every wild home but can partner in recovery science.",
                        explanation: "Conservation joins care, learning, and habitat protection."
                    )
                ],
                creativePrompt: "Write three sentences about one way a zoo can help a rare species.",
                storyEnding: "You connected zoo care to conservation like a careful investigator.",
                readingSkill: "Infer how zoos can support conservation science",
                reflectionPrompt: "Which conservation action from the notes feels most important?",
                hints: [
                    "Find how breeding programs join with teaching visitors.",
                    "Reread the sentence that says zoos cannot replace every wild home."
                ],
                commonMistakes: [
                    "Claiming zoos fully replace all wild habitats"
                ],
                successCriteria: [
                    "Uses conservation evidence",
                    "Links breeding, records, or teaching to recovery"
                ],
                learningObjectives: [
                    "Infer how zoos partner in conservation through care and learning",
                    "fp:discovery.Zoo Animals.confidentReader"
                ],
                activityFingerprint: "zoo-animals.discovery.confident.conservation"
            )
        }
    }


    // MARK: - Pirates Discovery

    private static func piratesDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Boats Can Float",
                storyOpening: "Willa the whale swims beside a pirate ship and wonders with you. How can a heavy ship sit on top of the sea without sinking?",
                missionPrompt: "Hunt for one true science fact about floating boats in the notes.",
                readingPassage: "A boat can float on water. Floating means water pushes up on the boat. A boat shape spreads weight. Too much weight can make a boat sink. The water’s upward push can hold a wooden hull as heavy as treasure chests.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what can a boat do on water?",
                        ["Float", "Sink right away", "Stay stuck on the sand"],
                        "Float",
                        "A boat can float on water."
                    ),
                    discoveryMCQ(
                        "What does water do on a floating boat?",
                        ["Pushes up on the boat", "Only pulls it into space", "Only paints it blue"],
                        "Pushes up on the boat",
                        "Water pushes up on a floating boat."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "float",
                        definition: "To stay on top of water without sinking.",
                        exampleSentence: "A boat can float on water."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Boats float when water pushes up on them.",
                        explanation: "Boat shape spreads weight."
                    ),
                    KnowledgeFact(
                        fact: "Too much weight can make a boat sink.",
                        explanation: "Floating is real water science."
                    )
                ],
                creativePrompt: "Draw a floating boat with an up arrow from water, and label the upward push as float.",
                storyEnding: "You logged a real floating fact. Great science work!",
                readingSkill: "Use a science note to explain floating",
                reflectionPrompt: "Name one thing that helps a boat float.",
                hints: [
                    "Look for float",
                    "Find pushes up"
                ],
                commonMistakes: [
                    "Choosing a claim that boats never float"
                ],
                successCriteria: [
                    "Names floating",
                    "Uses upward push or weight"
                ],
                learningObjectives: [
                    "Identify that boats float because water pushes up",
                    "fp:discovery.Pirates.beginner"
                ],
                activityFingerprint: "pirates.discovery.beginner.buoyancy"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Sails Catch Wind",
                storyOpening: "Willa the whale watches canvas snap tight. A sail catches wind and helps push the boat across the water—come feel that push!",
                missionPrompt: "Hunt for one true science fact about sails in the notes.",
                readingPassage: "A sail is a large cloth that catches wind. Moving air pushes on the sail and can move the boat. Sailors adjust sail angle to use the wind. No wind means the sail gives little push. Wind energy can power a sailing ship.",
                questions: [
                    discoveryMCQ(
                        "What does a sail catch?",
                        ["Wind", "Only still air with no push", "Only sunlight with no breeze"],
                        "Wind",
                        "A sail catches wind to help push the boat."
                    ),
                    discoveryMCQ(
                        "What does moving air do to the sail?",
                        ["Pushes on the sail and can move the boat", "Removes all water", "Pushes the boat straight underwater"],
                        "Pushes on the sail and can move the boat",
                        "Moving air pushes on the sail."
                    ),
                    discoveryMCQ(
                        "What happens with no wind?",
                        ["The sail gives little push", "The sail pushes harder with no wind", "The sail catches more rain than wind"],
                        "The sail gives little push",
                        "No wind means the sail gives little push."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "sail",
                        definition: "A large cloth that catches wind to move a boat.",
                        exampleSentence: "The sail fills with wind."
                    ),
                    VocabularyWord(
                        word: "angle",
                        definition: "The direction something is turned.",
                        exampleSentence: "Sailors adjust sail angle."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sails catch wind so moving air can push a boat.",
                        explanation: "Sailors adjust sail angle to use the wind."
                    ),
                    KnowledgeFact(
                        fact: "No wind means the sail gives little push.",
                        explanation: "Wind energy can power a sailing ship."
                    )
                ],
                creativePrompt: "Draw a sail with wind arrows pushing the boat forward.",
                storyEnding: "You used sail-and-wind evidence carefully.",
                readingSkill: "Use evidence to explain how sails use wind",
                reflectionPrompt: "How can wind move a sailing ship?",
                hints: [
                    "Find catches wind",
                    "Look for pushes"
                ],
                commonMistakes: [
                    "Thinking sails work with no wind"
                ],
                successCriteria: [
                    "States sails catch wind",
                    "Cites push or no-wind detail"
                ],
                learningObjectives: [
                    "Explain that sails convert wind push into boat motion",
                    "fp:discovery.Pirates.earlyReader"
                ],
                activityFingerprint: "pirates.discovery.early.sails"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Compass Navigation",
                storyOpening: "Willa the whale peers at a tiny compass needle. It swings and steadies, pointing toward magnetic north for sailors.",
                missionPrompt: "Find the main idea about compasses. Use details from the notes.",
                readingPassage: "A compass needle points toward magnetic north. Sailors use that clue to choose a heading. Maps and compasses work together for navigation. Without a direction tool, travel over open water is harder. The main idea is that a compass provides a reliable direction reference for navigation.",
                questions: [
                    discoveryMCQ(
                        "What is the main idea of the notes?",
                        ["A compass provides a reliable direction reference for navigation", "Compasses only decorate ship walls", "Direction never matters at sea"],
                        "A compass provides a reliable direction reference for navigation",
                        "The notes end with that main idea."
                    ),
                    discoveryMCQ(
                        "Where does a compass needle point?",
                        ["Toward magnetic north", "Only toward the nearest island", "Only toward the tallest mast"],
                        "Toward magnetic north",
                        "A compass needle points toward magnetic north."
                    ),
                    discoveryMCQ(
                        "What work together for navigation?",
                        ["Maps and compasses", "Only songs and dances", "Only sand and leaves"],
                        "Maps and compasses",
                        "Maps and compasses work together for navigation."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "compass",
                        definition: "A tool with a needle that points toward magnetic north.",
                        exampleSentence: "Sailors read a compass for direction."
                    ),
                    VocabularyWord(
                        word: "navigation",
                        definition: "Finding and following a path from place to place.",
                        exampleSentence: "Compasses help navigation at sea."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A compass needle points toward magnetic north.",
                        explanation: "Sailors use that clue to choose a heading."
                    ),
                    KnowledgeFact(
                        fact: "Maps and compasses work together for navigation.",
                        explanation: "Direction tools help open-water travel."
                    )
                ],
                creativePrompt: "Draw a compass rose and a ship heading arrow, and label north clearly.",
                storyEnding: "You found the compass main idea like a careful navigator.",
                readingSkill: "Identify the main idea about compass navigation",
                reflectionPrompt: "How does a compass help a sailor choose a path?",
                hints: [
                    "Reread the last sentence for the main idea.",
                    "Find magnetic north"
                ],
                commonMistakes: [
                    "Missing the direction-reference main idea"
                ],
                successCriteria: [
                    "States the compass main idea",
                    "Cites magnetic north or maps"
                ],
                learningObjectives: [
                    "Explain that compasses provide direction references for navigation",
                    "fp:discovery.Pirates.growingReader"
                ],
                activityFingerprint: "pirates.discovery.growing.compass"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Map Scale Simplified",
                storyOpening: "Willa the whale joins your navigation team. Together you investigate how map scale relates to real travel distance.",
                missionPrompt: "Use evidence from the notes. Explain why map scale matters for planning a voyage.",
                readingPassage: "Map scale tells how map distance relates to real distance. A short line on a map may stand for many miles at sea. Travelers who ignore scale may misjudge supplies and time. Scale lets a small paper stand for a huge ocean. Planning a voyage uses scale to estimate how far a route really is. Navigation science joins maps, scale, and careful measurement.",
                questions: [
                    discoveryMCQ(
                        "What can you infer about map scale?",
                        ["It helps travelers estimate real distance, supplies, and time", "It only decorates map edges", "Scale never relates to real miles"],
                        "It helps travelers estimate real distance, supplies, and time",
                        "Scale helps travelers estimate distance, supplies, and time."
                    ),
                    discoveryMCQ(
                        "What does map scale tell?",
                        ["How map distance relates to real distance", "Only the color of the ocean ink", "Only the smell of paper"],
                        "How map distance relates to real distance",
                        "Map scale tells how map distance relates to real distance."
                    ),
                    discoveryMCQ(
                        "What may travelers who ignore scale misjudge?",
                        ["Supplies and time", "Only the color of sails", "Only the shape of clouds"],
                        "Supplies and time",
                        "Travelers who ignore scale may misjudge supplies and time."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "scale",
                        definition: "A rule that relates map distance to real distance.",
                        exampleSentence: "Map scale turns a short line into many miles."
                    ),
                    VocabularyWord(
                        word: "voyage",
                        definition: "A long trip, often by sea.",
                        exampleSentence: "Sailors plan a voyage with maps."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Map scale relates map distance to real distance.",
                        explanation: "A short map line may stand for many miles."
                    ),
                    KnowledgeFact(
                        fact: "Ignoring scale can misjudge supplies and time.",
                        explanation: "Voyage planning uses scale to estimate real route length."
                    ),
                    KnowledgeFact(
                        fact: "Navigation science joins maps, scale, and measurement.",
                        explanation: "Small paper can stand for a huge ocean."
                    )
                ],
                creativePrompt: "Write three sentences explaining why a short map line can mean a long sea trip.",
                storyEnding: "You connected map scale to voyage planning like a careful investigator.",
                readingSkill: "Infer why map scale matters for voyage planning",
                reflectionPrompt: "Which scale clue from the notes would help you pack for a trip?",
                hints: [
                    "Find how a map line relates to real miles.",
                    "Reread the sentence about supplies and time."
                ],
                commonMistakes: [
                    "Treating scale as only decoration"
                ],
                successCriteria: [
                    "Uses scale evidence",
                    "Links distance estimates to planning"
                ],
                learningObjectives: [
                    "Infer how map scale supports real-distance voyage planning",
                    "fp:discovery.Pirates.confidentReader"
                ],
                activityFingerprint: "pirates.discovery.confident.map-scale"
            )
        }
    }


    private static func discoveryMCQ(
        _ prompt: String,
        _ choices: [String],
        _ answer: String,
        _ explanation: String
    ) -> LessonQuestion {
        LessonQuestion(
            subject: .science,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: prompt,
            choices: choices,
            correctAnswer: answer,
            explanation: explanation
        )
    }
}
