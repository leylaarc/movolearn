import Foundation

extension CuratedTopicLessonBank {

    // MARK: - Discovery lookup

    /// Dedicated science packs. Returns nil until a topic is authored (factory falls back to Story facts).
    static func discoveryPack(topic: Topic, level: ReadingLevel) -> DiscoveryPack? {
        switch topic {
        case .horses: return horsesDiscovery(level)
        case .jungleAnimals: return jungleDiscovery(level)
        case .sharks: return sharksDiscovery(level)
        case .dinosaurs: return dinosaursDiscovery(level)
        case .space: return spaceDiscovery(level)
        case .dogs: return dogsDiscovery(level)
        case .robots: return robotsDiscovery(level)
        case .volcanoes: return volcanoesDiscovery(level)
        default: return waveDDiscoveryPack(topic: topic, level: level)
        }
    }

    // MARK: - Horses Discovery (science — not barn-story clones)

    /// Real horse biology and care science across four reading bands.
    private static func horsesDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "What Horses Eat",
                storyOpening: "Sunny the pony tips her head toward the hay. Crunch! A horse's big teeth grind plants like a quiet mill.",
                missionPrompt: "Spot one fact about what horses eat.",
                readingPassage: "Horses are plant eaters. They chew grass and hay. Fresh water helps them stay strong. Their big flat teeth keep grinding plants almost all day long.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what do horses eat?",
                        ["Grass and hay", "Meat and fish", "Insects and worms"],
                        "Grass and hay",
                        "Horses are plant eaters, so they chew grass and hay for energy."
                    ),
                    discoveryMCQ(
                        "What helps horses stay strong?",
                        ["Fresh water", "Salt ocean water", "Thick sticky mud"],
                        "Fresh water",
                        "Clean fresh water keeps a horse healthy and strong each day."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "hay",
                        definition: "Dried grass that horses eat.",
                        exampleSentence: "The barn holds bales of hay."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Horses are plant eaters that need grass or hay every day.",
                        explanation: "Horses get energy from plants, not from meat."
                    ),
                    KnowledgeFact(
                        fact: "Fresh water helps a horse stay healthy.",
                        explanation: "A thirsty horse cannot stay strong."
                    )
                ],
                creativePrompt: "Draw a horse eating hay next to a full water bucket.",
                storyEnding: "Sunny the pony nickers — you logged a real food fact. Great science work!",
                readingSkill: "Use a science note to name what horses eat",
                reflectionPrompt: "Name one food from the notes that horses chew.",
                hints: ["Look for the words grass and hay", "Find the sentence about water"],
                commonMistakes: ["Choosing a food that is not in the notes"],
                successCriteria: ["Names a plant food from the notes", "Uses a stated water fact"],
                learningObjectives: [
                    "Identify that horses eat plants such as grass and hay",
                    "fp:discovery.Horses.beginner"
                ],
                activityFingerprint: "horses.discovery.beginner.diet"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Horse Eyes See Sideways",
                storyOpening: "Sunny the pony blinks her big side eyes. Come see how horse eyes watch a wide field!",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "A horse has eyes on the sides of its head. Side eyes help a horse watch a wide field. This helps a prey animal spot danger early. A horse still has a small blind spot right behind its body. Standing where a horse can see you feels safer for the animal.",
                questions: [
                    discoveryMCQ(
                        "Where are a horse's eyes?",
                        ["On the sides of its head", "On the front like a person's", "Under its thick mane"],
                        "On the sides of its head",
                        "Side-placed eyes let a horse see a wide field around its body."
                    ),
                    discoveryMCQ(
                        "What do side eyes help a horse do?",
                        ["Watch a wide field", "See only straight ahead", "See clearly underwater"],
                        "Watch a wide field",
                        "Eyes on the sides help a prey animal watch a wide field for danger."
                    ),
                    discoveryMCQ(
                        "Where is a horse's small blind spot?",
                        ["Right behind its body", "Far across the open field", "High above the treetops"],
                        "Right behind its body",
                        "A horse cannot see well right behind its body, so that spot is a blind spot."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "prey",
                        definition: "An animal that other animals may hunt.",
                        exampleSentence: "A horse is a prey animal that watches for danger."
                    ),
                    VocabularyWord(
                        word: "blind spot",
                        definition: "A place an animal cannot see well.",
                        exampleSentence: "A horse has a blind spot behind its body."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Horses have eyes on the sides of their heads so they can watch a wide field.",
                        explanation: "Wide vision helps prey animals notice danger."
                    ),
                    KnowledgeFact(
                        fact: "A horse has a small blind spot directly behind its body.",
                        explanation: "Approaching from behind can startle a horse."
                    )
                ],
                creativePrompt: "Draw a horse head and mark the side eyes. Add an arrow to the blind spot behind.",
                storyEnding: "Sunny the pony soft-nuzzles you — you used eye clues like a real horse scientist!",
                readingSkill: "Connect eye placement to how horses watch for danger",
                reflectionPrompt: "Why should a visitor stand where a horse can see them?",
                hints: ["Find the sentence about side eyes", "Look for the words blind spot"],
                commonMistakes: ["Guessing a fact that is not in the notes"],
                successCriteria: ["Explains side vision using the notes", "Names the blind-spot idea"],
                learningObjectives: [
                    "Explain how side-placed eyes help a horse watch for danger",
                    "fp:discovery.Horses.earlyReader"
                ],
                activityFingerprint: "horses.discovery.early.vision"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Ears Tell a Horse Story",
                storyOpening: "Sunny the pony flicks an ear toward a soft sound. Let's find out how horse ears catch clues!",
                missionPrompt: "Find the main science idea. Use details from the notes as evidence.",
                readingPassage: "Horse ears can turn to catch soft sounds from many directions. When both ears point forward, a horse often shows interest in what is ahead. Ears pinned flat back can signal worry or anger, so calm handlers give the horse space. Scientists and riders read ear position as a clue, not as a joke. Body clues plus soft voices help people stay safe around horses.",
                questions: [
                    discoveryMCQ(
                        "What is the main science idea in these notes?",
                        [
                            "Ear position can give clues about how a horse feels",
                            "Horse ears never move or change position",
                            "Horse ears are used only for chewing food"
                        ],
                        "Ear position can give clues about how a horse feels",
                        "Moving ears show feelings and help catch sounds from many directions."
                    ),
                    discoveryMCQ(
                        "What can ears pinned flat back signal?",
                        ["Worry or anger", "Calm friendly interest", "Deep sleepy rest"],
                        "Worry or anger",
                        "Ears pinned flat back often mean worry or anger, so people give the horse space."
                    ),
                    discoveryMCQ(
                        "Why can horse ears turn?",
                        [
                            "To catch soft sounds from many directions",
                            "To help a horse chew grass faster",
                            "To keep rain out of its eyes"
                        ],
                        "To catch soft sounds from many directions",
                        "Turning ears help a horse catch soft sounds coming from many directions."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "signal",
                        definition: "A clue that shows a feeling or message.",
                        exampleSentence: "Pinned ears can signal worry."
                    ),
                    VocabularyWord(
                        word: "handler",
                        definition: "A person who carefully works with an animal.",
                        exampleSentence: "A calm handler watches the horse's ears."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Horse ears can turn to catch sounds from many directions.",
                        explanation: "Movable ears help horses notice quiet changes nearby."
                    ),
                    KnowledgeFact(
                        fact: "Ears pinned flat back can signal worry or anger in a horse.",
                        explanation: "Reading ear clues helps people give a worried horse space."
                    )
                ],
                creativePrompt: "Draw two horse heads: ears forward for interest, and ears pinned back for worry. Label each clue.",
                storyEnding: "Sunny the pony flicks both ears forward. You used ear evidence the way careful observers do.",
                readingSkill: "Identify the main idea and supporting ear-clue details",
                reflectionPrompt: "Which ear clue would make you give a horse more space?",
                hints: ["Reread the sentence about ears pinned flat back", "Look for what forward ears often show"],
                commonMistakes: ["Treating ear clues as jokes instead of evidence"],
                successCriteria: ["States the main ear-communication idea", "Cites one supporting detail from the notes"],
                learningObjectives: [
                    "Explain how ear position can signal a horse's interest or worry",
                    "fp:discovery.Horses.growingReader"
                ],
                activityFingerprint: "horses.discovery.growing.ears"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Built to Run With the Herd",
                storyOpening: "Sunny the pony stands with her herd friends. Be her science partner — which body clues help horses stay safe?",
                missionPrompt: "Use evidence from the notes. Explain why herd life and strong legs work together.",
                readingPassage: "Wild horses often stay in herds because many eyes and ears can notice danger faster than one animal alone. Long, powerful legs help a horse run when it needs to escape. Hard hooves protect the feet as the horse travels over rough ground. A horse's digestive system is built for almost constant grazing on plants, so long periods without forage are hard on the animal. Together, herd watchfulness and a running body plan help horses stay safe in open spaces.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, why do wild horses often stay in herds?",
                        [
                            "Many eyes and ears can notice danger faster",
                            "A lone horse notices danger faster alone",
                            "Herds help horses climb tall trees"
                        ],
                        "Many eyes and ears can notice danger faster",
                        "In a herd, many eyes and ears can spot danger faster than one horse alone."
                    ),
                    discoveryMCQ(
                        "What do long, powerful legs help a horse do?",
                        ["Run when it needs to escape", "Climb trees like a monkey", "Dig dens under the ground"],
                        "Run when it needs to escape",
                        "Long, powerful legs help a horse run quickly when it needs to escape danger."
                    ),
                    discoveryMCQ(
                        "What can you infer from the grazing fact?",
                        [
                            "Going long periods without plant food is hard on a horse",
                            "Horses can skip plant food for weeks easily",
                            "Horses need meat more than they need plants"
                        ],
                        "Going long periods without plant food is hard on a horse",
                        "A horse's body is built for steady plant grazing, so long gaps without forage are hard."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "herd",
                        definition: "A group of animals that live and move together.",
                        exampleSentence: "The herd watched the open field together."
                    ),
                    VocabularyWord(
                        word: "forage",
                        definition: "Plant food that animals find and eat.",
                        exampleSentence: "Horses need steady forage like grass or hay."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Wild horses often stay in herds so many eyes and ears can notice danger faster.",
                        explanation: "Group watchfulness is a survival advantage in open spaces."
                    ),
                    KnowledgeFact(
                        fact: "A horse's body is built for running and for almost constant plant grazing.",
                        explanation: "Strong legs and a plant-based digestive system support survival."
                    ),
                    KnowledgeFact(
                        fact: "Hard hooves protect a horse's feet on rough ground.",
                        explanation: "Hooves are part of the horse's traveling body plan."
                    )
                ],
                creativePrompt: "Draw a small herd in an open field. Label one survival clue: eyes, ears, legs, or hooves.",
                storyEnding: "Sunny the pony trots beside you. You connected herd and body clues like a careful investigator.",
                readingSkill: "Infer survival advantages from scientific evidence",
                reflectionPrompt: "Which body or herd clue from the notes best explains how horses stay safe?",
                hints: ["Compare the herd sentence with the legs sentence", "Reread the forage detail before you infer"],
                commonMistakes: ["Picking a claim the notes never support"],
                successCriteria: ["Uses herd evidence", "Links a body adaptation to survival"],
                learningObjectives: [
                    "Infer how herd life and running adaptations help horses survive",
                    "fp:discovery.Horses.confidentReader"
                ],
                activityFingerprint: "horses.discovery.confident.herd-adapt"
            )
        }
    }

    // MARK: - Jungle Animals Discovery (science — not rainforest story clones)

    /// Real rainforest science across four reading bands.
    private static func jungleDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Why Jungles Stay Wet",
                storyOpening: "Movo, your spark buddy, holds still in the wet air. Listen — drip, drip, drip on your cheeks.",
                missionPrompt: "Hunt for one real fact that explains why jungles stay wet.",
                readingPassage: "Jungles get a lot of rain. Rain falls on leaves and soil. Wet air helps green plants grow. Some jungles get more rain in one year than a dry place gets in many years.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what do jungles get a lot of?",
                        ["Rain", "Snow", "Dry desert wind"],
                        "Rain",
                        "Jungles stay wet because they get a lot of rain on leaves and soil."
                    ),
                    discoveryMCQ(
                        "What helps green plants grow in the jungle?",
                        ["Wet air", "Dry dusty air", "Cold icy wind"],
                        "Wet air",
                        "Wet air gives jungle plants the moisture they need to grow green."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "jungle",
                        definition: "A warm forest that gets a lot of rain.",
                        exampleSentence: "Rain keeps the jungle green."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Jungles get a lot of rain, so plants and animals live in a wet home.",
                        explanation: "Heavy rainfall shapes rainforest life."
                    ),
                    KnowledgeFact(
                        fact: "Wet air helps green jungle plants grow.",
                        explanation: "Moisture supports dense plant growth."
                    )
                ],
                creativePrompt: "Draw rain falling on tall green jungle leaves.",
                storyEnding: "Movo sparkles — you logged a real jungle rain fact. Great science work!",
                readingSkill: "Use a science note to explain why jungles stay wet",
                reflectionPrompt: "Name one thing from the notes that keeps a jungle wet or green.",
                hints: ["Look for the word rain", "Find the sentence about wet air"],
                commonMistakes: ["Choosing a dry-place fact that is not in the notes"],
                successCriteria: ["Names rain or wet air from the notes"],
                learningObjectives: [
                    "Identify that jungles stay wet because of heavy rain",
                    "fp:discovery.Jungle Animals.beginner"
                ],
                activityFingerprint: "jungle.discovery.beginner.rainfall"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Leaves Built for Rain",
                storyOpening: "Movo peeks at a shiny leaf. Come feel how jungle leaves handle all that rain!",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "Many rainforest leaves are broad and smooth. Water slides off them after a storm. Pointed tips help drops drip away faster. This leaf shape helps plants stay healthy in heavy rain. Scientists call these helpful tips drip tips.",
                questions: [
                    discoveryMCQ(
                        "What are many rainforest leaves like?",
                        ["Broad and smooth", "Tiny and needle-thin", "Thick and fuzzy like fur"],
                        "Broad and smooth",
                        "Broad, smooth leaves let rainwater slide off after a heavy storm."
                    ),
                    discoveryMCQ(
                        "What do pointed tips help drops do?",
                        ["Drip away faster", "Stick on the leaf longer", "Freeze into ice beads"],
                        "Drip away faster",
                        "Pointed drip tips guide raindrops off the leaf so water does not sit too long."
                    ),
                    discoveryMCQ(
                        "What do scientists call these helpful tips?",
                        ["Drip tips", "Root tips", "Flower tips"],
                        "Drip tips",
                        "Scientists call these pointed leaf ends drip tips because they shed rain."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "drip tip",
                        definition: "A pointed leaf tip that helps water slide off.",
                        exampleSentence: "A drip tip lets rain leave the leaf quickly."
                    ),
                    VocabularyWord(
                        word: "rainforest",
                        definition: "A warm forest that gets heavy rain.",
                        exampleSentence: "Rainforest plants grow large wet leaves."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Many rainforest leaves are broad and smooth so water can slide off.",
                        explanation: "Leaf shape is an adaptation to heavy rain."
                    ),
                    KnowledgeFact(
                        fact: "Pointed drip tips help raindrops leave a leaf faster.",
                        explanation: "Shedding water helps plants stay healthy in wet climates."
                    )
                ],
                creativePrompt: "Draw one broad leaf with a pointed drip tip and falling raindrops.",
                storyEnding: "Movo twinkles — you used leaf clues like a real rainforest scientist!",
                readingSkill: "Connect leaf shape to life in heavy rain",
                reflectionPrompt: "Why might a pointed tip help a leaf after a storm?",
                hints: ["Find the sentence about drip tips", "Look for broad and smooth"],
                commonMistakes: ["Guessing a leaf fact that is not in the notes"],
                successCriteria: ["Explains how leaves shed water using the notes"],
                learningObjectives: [
                    "Explain how drip tips help rainforest leaves shed water",
                    "fp:discovery.Jungle Animals.earlyReader"
                ],
                activityFingerprint: "jungle.discovery.early.drip-tips"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Hide or Warn",
                storyOpening: "Movo holds still and stays quiet. Jungle animals have clever ways to stay safe — let's look together!",
                missionPrompt: "Find the main science idea. Use details from the notes as evidence.",
                readingPassage: "Some rainforest animals blend into leaves and twigs so predators miss them. Stick insects hold still and look like plant parts. Jaguars have spotted coats that break up their shape in leafy shade. Other animals use bright colors as a warning that they may be unsafe to eat. A poison dart frog's bold colors can tell predators to stay away. Camouflage and warning colors are two different survival tools in the same forest.",
                questions: [
                    discoveryMCQ(
                        "What is the main science idea in these notes?",
                        [
                            "Jungle animals stay safe with camouflage or warning colors",
                            "Every jungle animal hides in exactly the same way",
                            "Bright colors always mean an animal wants to play"
                        ],
                        "Jungle animals stay safe with camouflage or warning colors",
                        "Some animals blend in to hide, while others use bright colors to warn predators away."
                    ),
                    discoveryMCQ(
                        "How can a jaguar's spots help?",
                        [
                            "They break up the jaguar's shape in leafy shade",
                            "They make the jaguar stand out in bright sun",
                            "They keep the jaguar dry after rain"
                        ],
                        "They break up the jaguar's shape in leafy shade",
                        "Spotted coats break up a jaguar's shape so it is harder to spot in leafy shade."
                    ),
                    discoveryMCQ(
                        "What can a poison dart frog's bright colors signal?",
                        [
                            "A warning to stay away",
                            "That the frog is perfectly camouflaged",
                            "That the frog wants predators to come closer"
                        ],
                        "A warning to stay away",
                        "Bold warning colors can tell predators the frog may be unsafe to eat."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "camouflage",
                        definition: "Colors or shapes that help an animal blend in.",
                        exampleSentence: "Camouflage helps a stick insect hide on a twig."
                    ),
                    VocabularyWord(
                        word: "predator",
                        definition: "An animal that hunts other animals for food.",
                        exampleSentence: "A predator may miss a well-camouflaged insect."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Camouflage helps some rainforest animals blend into leaves and twigs.",
                        explanation: "Blending in makes prey harder for predators to spot."
                    ),
                    KnowledgeFact(
                        fact: "Bright warning colors can tell predators that an animal may be unsafe to eat.",
                        explanation: "Warning coloration is a different survival strategy from camouflage."
                    )
                ],
                creativePrompt: "Draw one camouflaged animal and one brightly colored warning animal. Label each strategy.",
                storyEnding: "Movo nods proudly. You compared two survival tools the way careful investigators do.",
                readingSkill: "Identify the main idea and supporting camouflage details",
                reflectionPrompt: "Which survival tool from the notes would help more in deep green shade?",
                hints: ["Reread the last sentence about two survival tools", "Compare the jaguar and the frog"],
                commonMistakes: ["Thinking every animal uses only one kind of color trick"],
                successCriteria: ["States the hide-or-warn main idea", "Cites one supporting detail"],
                learningObjectives: [
                    "Compare camouflage and warning colors as rainforest survival strategies",
                    "fp:discovery.Jungle Animals.growingReader"
                ],
                activityFingerprint: "jungle.discovery.growing.camouflage-warn"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Four Layers of the Rainforest",
                storyOpening: "Movo points up through green layers. Partner up — how do rainforest floors and tops shape where life lives?",
                missionPrompt: "Use evidence from the notes. Explain why different animals use different layers.",
                readingPassage: "A rainforest is built in layers from bright sunlight to shady ground. The emergent layer has the tallest treetops that catch strong sun and wind. Below that, the canopy is a thick leafy roof where many birds and monkeys find fruit. The understory is dimmer and wetter, with shorter plants and quieter hunters. The forest floor is darkest; fallen leaves recycle nutrients back into the soil. Because light, food, and cover change by layer, animals are not spread evenly through the forest.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what is the canopy?",
                        [
                            "A thick leafy roof where many birds and monkeys find fruit",
                            "The darkest ground layer where leaves recycle nutrients",
                            "The tallest emergent tips that catch the strongest wind"
                        ],
                        "A thick leafy roof where many birds and monkeys find fruit",
                        "The canopy is the thick leafy roof where many birds and monkeys find fruit."
                    ),
                    discoveryMCQ(
                        "What happens on the forest floor?",
                        [
                            "Fallen leaves recycle nutrients back into the soil",
                            "Tall emergent trees grow their tops there",
                            "Most monkeys find most of their fruit there"
                        ],
                        "Fallen leaves recycle nutrients back into the soil",
                        "On the dark forest floor, fallen leaves break down and return nutrients to the soil."
                    ),
                    discoveryMCQ(
                        "What can you infer from the layer facts?",
                        [
                            "Animals use different layers because light, food, and cover change",
                            "Every animal must live in the emergent layer",
                            "Rainforest layers all share the same sunlight and food"
                        ],
                        "Animals use different layers because light, food, and cover change",
                        "Light, food, and cover change by layer, so animals are not spread evenly through the forest."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "canopy",
                        definition: "The high leafy roof of rainforest trees.",
                        exampleSentence: "Monkeys move through the canopy looking for fruit."
                    ),
                    VocabularyWord(
                        word: "emergent",
                        definition: "The tallest treetop layer above the canopy.",
                        exampleSentence: "Emergent trees catch strong sun and wind."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Rainforests have layers such as emergent, canopy, understory, and forest floor.",
                        explanation: "Each layer offers different light, food, and cover."
                    ),
                    KnowledgeFact(
                        fact: "Fallen leaves on the forest floor recycle nutrients back into the soil.",
                        explanation: "Decomposition returns nutrients that plants can use again."
                    ),
                    KnowledgeFact(
                        fact: "Animals are not spread evenly because conditions change by layer.",
                        explanation: "Habitat differences drive where species live and feed."
                    )
                ],
                creativePrompt: "Draw a rainforest cross-section with four labeled layers. Place one animal in a fitting layer.",
                storyEnding: "Movo floats beside the canopy. You connected rainforest layers to animal homes like a careful investigator.",
                readingSkill: "Infer why animals use different rainforest layers",
                reflectionPrompt: "Which layer from the notes would you study first, and why?",
                hints: ["Compare canopy fruit with floor nutrients", "Reread the sentence about light, food, and cover"],
                commonMistakes: ["Picking a layer claim the notes never support"],
                successCriteria: ["Names a layer with a correct detail", "Infers why animals split across layers"],
                learningObjectives: [
                    "Explain how rainforest layers create different habitats",
                    "fp:discovery.Jungle Animals.confidentReader"
                ],
                activityFingerprint: "jungle.discovery.confident.layers"
            )
        }
    }

    // MARK: - Sharks Discovery (science — not Willa ocean-story clones)

    /// Real shark biology and ocean-science concepts across four reading bands.
    private static func sharksDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "How Sharks Breathe",
                storyOpening: "Finn the reef shark glides under the waves. He never comes up for air.",
                missionPrompt: "Look for one true clue about how sharks breathe underwater.",
                readingPassage: "Sharks live in the ocean. They breathe with gills. Gills help them breathe underwater. A shark needs water over its gills to breathe — and it never needs air like people do.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what do sharks use to breathe?",
                        ["Gills", "Lungs like people on land", "Noses like land mammals"],
                        "Gills",
                        "Sharks live underwater and breathe with gills, not lungs like people on land."
                    ),
                    discoveryMCQ(
                        "What does a shark need over its gills to breathe?",
                        ["Water", "Dry air from the surface", "Warm sand from the beach"],
                        "Water",
                        "Water must move over a shark's gills so the shark can breathe underwater."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "gills",
                        definition: "Body parts that help a shark breathe underwater.",
                        exampleSentence: "A shark breathes with gills."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sharks breathe with gills that help them breathe underwater.",
                        explanation: "Gills let sharks get what they need from ocean water."
                    ),
                    KnowledgeFact(
                        fact: "A shark needs water moving over its gills to breathe.",
                        explanation: "Water flow helps gills work."
                    )
                ],
                creativePrompt: "Draw a shark in the ocean and mark the gill slits on its side.",
                storyEnding: "Finn the reef shark flicks his tail — you logged a real shark breathing fact. Great science work!",
                readingSkill: "Use a science note to explain how sharks breathe",
                reflectionPrompt: "Name one thing from the notes that helps a shark breathe.",
                hints: ["Look for the word gills", "Find the sentence about water"],
                commonMistakes: ["Choosing a land-breathing idea that is not in the notes"],
                successCriteria: ["Names gills or water flow from the notes"],
                learningObjectives: [
                    "Identify that sharks breathe with gills underwater",
                    "fp:discovery.Sharks.beginner"
                ],
                activityFingerprint: "sharks.discovery.beginner.gills"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Skin Like Tiny Teeth",
                storyOpening: "Finn the reef shark flicks his rough-smooth skin. Come feel why that skin helps a shark slip through water!",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "Shark skin feels rough if you rub it one way. Tiny tooth-like scales cover the skin. Scientists call these scales denticles. Denticles help water slide past as the shark swims. Smooth swim motion uses less energy in the ocean.",
                questions: [
                    discoveryMCQ(
                        "What covers shark skin?",
                        ["Tiny tooth-like scales", "Soft smooth fur", "Hard turtle shell plates"],
                        "Tiny tooth-like scales",
                        "Shark skin is covered with tiny tooth-like scales that feel rough one way."
                    ),
                    discoveryMCQ(
                        "What do scientists call these scales?",
                        ["Denticles", "Seashells", "Fish bones"],
                        "Denticles",
                        "Scientists call these tiny tooth-like scales denticles."
                    ),
                    discoveryMCQ(
                        "How do denticles help a shark?",
                        ["They help water slide past as the shark swims", "They help the shark breathe air on land", "They keep the shark warm like thick fur"],
                        "They help water slide past as the shark swims",
                        "Denticles help water slide past so the shark can swim more smoothly."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "denticle",
                        definition: "A tiny tooth-like scale on shark skin.",
                        exampleSentence: "Denticles make shark skin feel rough one way."
                    ),
                    VocabularyWord(
                        word: "scale",
                        definition: "A small hard plate that covers some animal skin.",
                        exampleSentence: "Shark scales are shaped like tiny teeth."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Shark skin is covered with tiny tooth-like scales called denticles.",
                        explanation: "Denticles are a real body feature of sharks."
                    ),
                    KnowledgeFact(
                        fact: "Denticles help water slide past as a shark swims.",
                        explanation: "This skin design supports smooth ocean swimming."
                    )
                ],
                creativePrompt: "Draw a close-up of shark skin with tiny denticle shapes. Label one scale.",
                storyEnding: "Finn the reef shark grins — you used skin clues like a real shark scientist!",
                readingSkill: "Connect denticles to how sharks move through water",
                reflectionPrompt: "Why might rough, tooth-like skin help a swimming shark?",
                hints: ["Find the word denticles", "Look for how water slides past"],
                commonMistakes: ["Guessing a skin fact that is not in the notes"],
                successCriteria: ["Names denticles", "Links them to swimming"],
                learningObjectives: [
                    "Explain how denticles help sharks swim smoothly",
                    "fp:discovery.Sharks.earlyReader"
                ],
                activityFingerprint: "sharks.discovery.early.denticles"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "A Skeleton of Cartilage",
                storyOpening: "Finn the reef shark wonders what is inside a shark's body. Let's investigate the bendy frame together!",
                missionPrompt: "Find the main science idea. Use details from the notes as evidence.",
                readingPassage: "Unlike many bony fish, sharks have skeletons made of cartilage. Cartilage is strong but more flexible than hard bone. A lighter, bendy frame helps many sharks twist and turn while chasing prey. Cartilage also supports the fins that steer the shark through water. Scientists study cartilage skeletons to understand how sharks move so well in the ocean.",
                questions: [
                    discoveryMCQ(
                        "What is the main science idea in these notes?",
                        [
                            "Sharks have flexible cartilage skeletons instead of hard bone frames",
                            "Sharks have the same hard bone skeletons as many fish",
                            "Sharks have no skeleton supporting their fins"
                        ],
                        "Sharks have flexible cartilage skeletons instead of hard bone frames",
                        "Unlike many bony fish, sharks have strong, flexible cartilage skeletons."
                    ),
                    discoveryMCQ(
                        "How does cartilage compare with hard bone?",
                        [
                            "It is strong but more flexible",
                            "It is softer and weaker than jelly",
                            "It is harder and less bendy than bone"
                        ],
                        "It is strong but more flexible",
                        "Cartilage is strong like bone but bends more. That extra bend helps sharks twist in water."
                    ),
                    discoveryMCQ(
                        "What can a lighter, bendy frame help sharks do?",
                        [
                            "Twist and turn while chasing prey",
                            "Walk long distances on beaches",
                            "Stay stiff and straight without bending"
                        ],
                        "Twist and turn while chasing prey",
                        "A lighter, bendy cartilage frame helps many sharks twist and turn while chasing prey."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "cartilage",
                        definition: "Strong, flexible tissue that forms a shark's skeleton.",
                        exampleSentence: "A shark's skeleton is made of cartilage."
                    ),
                    VocabularyWord(
                        word: "flexible",
                        definition: "Able to bend without breaking.",
                        exampleSentence: "Cartilage is more flexible than hard bone."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sharks have skeletons made of cartilage, not hard bone like many fish.",
                        explanation: "Cartilage is a key body plan difference for sharks."
                    ),
                    KnowledgeFact(
                        fact: "A flexible cartilage frame helps sharks twist and turn in water.",
                        explanation: "Body structure supports how sharks hunt and swim."
                    )
                ],
                creativePrompt: "Draw a simple shark outline. Label the skeleton idea: cartilage, flexible frame.",
                storyEnding: "Finn the reef shark circles once. You used body-structure evidence the way careful investigators do.",
                readingSkill: "Identify the main idea about shark cartilage skeletons",
                reflectionPrompt: "Why might flexibility matter more than hard bone for a swimming hunter?",
                hints: ["Reread the first sentence about cartilage", "Find the twist-and-turn detail"],
                commonMistakes: ["Assuming sharks have the same bony skeleton as people"],
                successCriteria: ["States the cartilage main idea", "Cites one movement benefit"],
                learningObjectives: [
                    "Explain how cartilage skeletons support shark swimming",
                    "fp:discovery.Sharks.growingReader"
                ],
                activityFingerprint: "sharks.discovery.growing.cartilage"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Sharks Keep Reefs in Balance",
                storyOpening: "Finn the reef shark circles a bright reef. Be his science partner — why do sharks matter to ocean life?",
                missionPrompt: "Use evidence from the notes. Explain how sharks affect reef food webs.",
                readingPassage: "Healthy reefs need more than bright coral and tiny fish. Sharks often sit near the top of ocean food webs as apex predators. By hunting, they help keep mid-level predator numbers from growing unchecked. When mid-level hunters stay in balance, plant-eating fish can still graze algae that would otherwise smother coral. Scientists studying reef health look for shark presence as one clue that the whole system is working. Losing sharks can tip the balance toward algae overgrowth and weaker coral communities.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, where do sharks often sit in ocean food webs?",
                        [
                            "Near the top as apex predators",
                            "At the bottom as tiny algae eaters",
                            "In the middle as plant-eating grazers"
                        ],
                        "Near the top as apex predators",
                        "Sharks often sit near the top of ocean food webs as apex predators."
                    ),
                    discoveryMCQ(
                        "What can happen when mid-level hunters stay in balance?",
                        [
                            "Plant-eating fish can still graze algae that would smother coral",
                            "Plant-eating fish disappear and algae cover the coral",
                            "Coral no longer needs any plant-eating fish"
                        ],
                        "Plant-eating fish can still graze algae that would smother coral",
                        "When mid-level hunters stay in balance, plant-eating fish can still graze algae off coral."
                    ),
                    discoveryMCQ(
                        "What can you infer from the reef-health clues?",
                        [
                            "Shark presence can signal that a reef food web is working",
                            "Shark presence always means coral is already dead",
                            "Losing sharks never changes algae or coral health"
                        ],
                        "Shark presence can signal that a reef food web is working",
                        "Scientists treat shark presence as one clue that the whole reef food web is working."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "apex predator",
                        definition: "A hunter near the top of a food web.",
                        exampleSentence: "Sharks are apex predators on many reefs."
                    ),
                    VocabularyWord(
                        word: "food web",
                        definition: "A map of who eats whom in an ecosystem.",
                        exampleSentence: "Reef sharks sit high in the ocean food web."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sharks often act as apex predators near the top of ocean food webs.",
                        explanation: "Top hunters influence how many animals live at lower levels."
                    ),
                    KnowledgeFact(
                        fact: "Balanced shark hunting can help plant-eating fish keep algae from smothering coral.",
                        explanation: "Indirect effects link sharks to reef health."
                    ),
                    KnowledgeFact(
                        fact: "Scientists may treat shark presence as one clue that a reef system is working.",
                        explanation: "Missing sharks can tip reefs toward algae overgrowth."
                    )
                ],
                creativePrompt: "Draw a simple reef food-web sketch: shark, mid-level hunter, plant-eating fish, algae, coral. Label one balance arrow.",
                storyEnding: "Finn the reef shark glides proud. You connected sharks to reef balance like a careful investigator.",
                readingSkill: "Infer ecosystem effects from scientific evidence",
                reflectionPrompt: "Which clue from the notes best shows why losing sharks can hurt coral?",
                hints: ["Trace the path from sharks to algae to coral", "Reread the scientist clue about shark presence"],
                commonMistakes: ["Picking a claim the notes never support"],
                successCriteria: ["Uses apex-predator evidence", "Links sharks to reef balance"],
                learningObjectives: [
                    "Infer how sharks help keep reef food webs in balance",
                    "fp:discovery.Sharks.confidentReader"
                ],
                activityFingerprint: "sharks.discovery.confident.reef-balance"
            )
        }
    }

    // MARK: - Dinosaurs Discovery (science — not Dottie story clones)

    /// Real paleontology and dinosaur science across four reading bands.
    private static func dinosaursDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "What Fossils Are",
                storyOpening: "Dottie the dino presses a paw to cool stone. Imagine finding a footprint from long, long ago!",
                missionPrompt: "Find one fact about what fossils really are.",
                readingPassage: "Dinosaurs lived long ago. Fossils are old clues in rock. A fossil can be a bone or a print. Some footprints stayed in mud that later turned into hard rock.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what are fossils?",
                        ["Old clues in rock", "Fresh bones from living animals", "New plants growing on trees"],
                        "Old clues in rock",
                        "Fossils are old clues from living things that were kept in rock long ago."
                    ),
                    discoveryMCQ(
                        "What can a fossil be?",
                        ["A bone or a print", "A fresh flower still growing", "A puddle of rainwater"],
                        "A bone or a print",
                        "A fossil can be a bone or a print left in rock from long ago."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "fossil",
                        definition: "An old clue from a plant or animal kept in rock.",
                        exampleSentence: "A fossil bone can hide inside rock."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Fossils are old clues in rock from living things long ago.",
                        explanation: "Fossils help scientists learn about dinosaurs."
                    ),
                    KnowledgeFact(
                        fact: "A fossil can be a bone or a print left in rock.",
                        explanation: "Different fossil types give different clues."
                    )
                ],
                creativePrompt: "Draw a fossil bone or footprint inside a rock. Label it fossil.",
                storyEnding: "Dottie the dino stomps happily — you logged a real fossil fact. Great science work!",
                readingSkill: "Use a science note to explain what fossils are",
                reflectionPrompt: "Name one kind of fossil from the notes.",
                hints: ["Look for the word fossil", "Find bone or print"],
                commonMistakes: ["Choosing a new living plant that is not a fossil"],
                successCriteria: ["Defines fossil using the notes"],
                learningObjectives: [
                    "Identify fossils as old clues preserved in rock",
                    "fp:discovery.Dinosaurs.beginner"
                ],
                activityFingerprint: "dinos.discovery.beginner.fossils"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Plant Eaters and Meat Eaters",
                storyOpening: "Dottie the dino grins at two kinds of teeth. Come sort plant-chewers from meat-tearers with her!",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "Not all dinosaurs ate the same food. Some dinosaurs were plant eaters. Flat teeth helped them chew leaves and ferns. Other dinosaurs were meat eaters. Sharp teeth helped them tear food. Scientists look at teeth to learn what a dinosaur ate.",
                questions: [
                    discoveryMCQ(
                        "What helped plant-eating dinosaurs chew leaves?",
                        ["Flat teeth", "Sharp tearing teeth", "No teeth at all"],
                        "Flat teeth",
                        "Flat teeth helped plant eaters grind and chew leaves and ferns."
                    ),
                    discoveryMCQ(
                        "What helped meat-eating dinosaurs tear food?",
                        ["Sharp teeth", "Flat chewing teeth", "Smooth toothless gums"],
                        "Sharp teeth",
                        "Sharp teeth helped meat eaters tear food, unlike flat plant-chewing teeth."
                    ),
                    discoveryMCQ(
                        "How do scientists learn what a dinosaur ate?",
                        ["They look at teeth", "They watch living dinosaurs eat", "They ignore tooth shape completely"],
                        "They look at teeth",
                        "Tooth shape gives scientists clues about whether a dinosaur ate plants or meat."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "diet",
                        definition: "The kinds of food an animal eats.",
                        exampleSentence: "Teeth give clues about a dinosaur's diet."
                    ),
                    VocabularyWord(
                        word: "fern",
                        definition: "A green plant with feathery leaves.",
                        exampleSentence: "Plant eaters chewed ferns."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Some dinosaurs ate plants; others ate meat.",
                        explanation: "Diet differences show up in tooth shape."
                    ),
                    KnowledgeFact(
                        fact: "Scientists study teeth to learn what a dinosaur ate.",
                        explanation: "Flat teeth suit chewing plants; sharp teeth suit tearing meat."
                    )
                ],
                creativePrompt: "Draw two dinosaur mouths: flat plant-eater teeth and sharp meat-eater teeth. Label each.",
                storyEnding: "Dottie the dino claps her tiny arms — you used tooth clues like a real dinosaur scientist!",
                readingSkill: "Connect tooth shape to dinosaur diet",
                reflectionPrompt: "Which tooth clue would you check first on a fossil jaw?",
                hints: ["Find flat teeth for plants", "Find sharp teeth for meat"],
                commonMistakes: ["Mixing up which teeth match which diet"],
                successCriteria: ["Matches tooth type to diet using the notes"],
                learningObjectives: [
                    "Explain how tooth shape gives clues about dinosaur diets",
                    "fp:discovery.Dinosaurs.earlyReader"
                ],
                activityFingerprint: "dinos.discovery.early.diet-teeth"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "How a Fossil Forms",
                storyOpening: "Dottie the dino digs carefully beside you. Let's uncover how a living thing becomes a fossil!",
                missionPrompt: "Find the main science idea. Use details from the notes as evidence.",
                readingPassage: "A fossil does not form in one quick minute. First, a dinosaur body or print can be buried by mud or sand. Over a very long time, minerals in water can harden the remains into rock. Layers of earth build up above the fossil. Much later, wind or water may wear the rock away so scientists can find the clue. Careful digging protects the fossil while it is studied.",
                questions: [
                    discoveryMCQ(
                        "What is the main science idea in these notes?",
                        [
                            "Fossils form slowly through burial, minerals, and rock layers",
                            "Fossils form in one quick minute on the surface",
                            "Fossils appear fully formed without burial or rock"
                        ],
                        "Fossils form slowly through burial, minerals, and rock layers",
                        "Fossil formation is a slow process of burial, minerals hardening remains, and rock layers."
                    ),
                    discoveryMCQ(
                        "What can bury a dinosaur body or print first?",
                        ["Mud or sand", "Loose dry leaves only", "Open empty air"],
                        "Mud or sand",
                        "Mud or sand can cover remains first so they are protected while rock forms."
                    ),
                    discoveryMCQ(
                        "What can minerals in water do over a long time?",
                        [
                            "Harden the remains into rock",
                            "Wash the remains away in one day",
                            "Turn the remains back into living bone"
                        ],
                        "Harden the remains into rock",
                        "Over a long time, minerals in water can harden buried remains into rock fossils."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "mineral",
                        definition: "A natural material in water or rock that can harden remains.",
                        exampleSentence: "Minerals help turn buried bones into rock fossils."
                    ),
                    VocabularyWord(
                        word: "bury",
                        definition: "To cover something under earth or sand.",
                        exampleSentence: "Mud can bury a footprint before it becomes a fossil."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Fossil formation starts when remains are buried by mud or sand.",
                        explanation: "Burial protects clues long enough for rock to form."
                    ),
                    KnowledgeFact(
                        fact: "Minerals can harden buried remains into rock over a very long time.",
                        explanation: "Fossilization is a slow earth process, not a quick event."
                    )
                ],
                creativePrompt: "Draw three steps: burial in mud, minerals hardening the clue, scientists finding the fossil. Number the steps.",
                storyEnding: "Dottie the dino dusts off a pebble. You traced fossil formation the way careful investigators do.",
                readingSkill: "Identify the main idea of a fossil-formation process",
                reflectionPrompt: "Which step from the notes do you think takes the longest time?",
                hints: ["Reread the first sentence about time", "Follow burial, then minerals, then discovery"],
                commonMistakes: ["Thinking fossils appear fully formed in one minute"],
                successCriteria: ["States the slow-formation main idea", "Orders at least two process steps"],
                learningObjectives: [
                    "Explain the main steps in how a fossil forms",
                    "fp:discovery.Dinosaurs.growingReader"
                ],
                activityFingerprint: "dinos.discovery.growing.fossil-form"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Reading Clues in Bones",
                storyOpening: "Dottie the dino lays out footprint and bone cards. Partner up — which fossil clues help scientists understand dinosaur life?",
                missionPrompt: "Use evidence from the notes. Explain what bones and teeth can reveal.",
                readingPassage: "Paleontologists rarely see a living dinosaur, so they read body clues left in stone. Long leg bones can suggest a dinosaur was built for walking or running across open ground. Tooth shape still points to plant diets or meat diets. Trackways of footprints can show whether animals moved alone or in groups. Incomplete skeletons force scientists to compare related fossils and note what is missing. Strong conclusions come from more than one kind of evidence, not from a single broken bone alone.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what can long leg bones suggest?",
                        [
                            "A dinosaur built for walking or running across open ground",
                            "A dinosaur that lived only underwater",
                            "A dinosaur that never used its legs to move"
                        ],
                        "A dinosaur built for walking or running across open ground",
                        "Long leg bones can suggest a dinosaur was built for walking or running on open ground."
                    ),
                    discoveryMCQ(
                        "What can trackways of footprints show?",
                        [
                            "Whether animals moved alone or in groups",
                            "The exact color of every scale",
                            "The exact sound of every call"
                        ],
                        "Whether animals moved alone or in groups",
                        "Footprint trackways can show whether dinosaurs moved alone or traveled in groups."
                    ),
                    discoveryMCQ(
                        "What can you infer about strong scientific conclusions?",
                        [
                            "They come from more than one kind of evidence",
                            "They need only one broken bone and no other clues",
                            "They ignore teeth and footprints completely"
                        ],
                        "They come from more than one kind of evidence",
                        "Strong conclusions use bones, teeth, footprints, and more—not just one broken bone."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "paleontologist",
                        definition: "A scientist who studies fossils from long ago.",
                        exampleSentence: "A paleontologist compares bones and teeth for clues."
                    ),
                    VocabularyWord(
                        word: "trackway",
                        definition: "A line of footprints left by an animal.",
                        exampleSentence: "A trackway can show group travel."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Paleontologists infer dinosaur life from bones, teeth, and footprints in stone.",
                        explanation: "No living dinosaurs remain, so evidence must be read carefully."
                    ),
                    KnowledgeFact(
                        fact: "Strong conclusions use more than one kind of fossil evidence.",
                        explanation: "Comparing clues reduces mistakes from incomplete skeletons."
                    ),
                    KnowledgeFact(
                        fact: "Tooth shape and leg bones give different kinds of information about diet and movement.",
                        explanation: "Each fossil type answers a different science question."
                    )
                ],
                creativePrompt: "Draw a scientist's evidence board with three labeled clues: bone, tooth, and trackway.",
                storyEnding: "Dottie the dino stacks the cards neatly. You connected multiple fossil clues like a careful investigator.",
                readingSkill: "Infer dinosaur traits from multiple lines of evidence",
                reflectionPrompt: "Which clue type from the notes would you trust least by itself, and why?",
                hints: ["Compare leg bones with teeth", "Reread the sentence about more than one kind of evidence"],
                commonMistakes: ["Building a big claim from a single broken bone"],
                successCriteria: ["Uses at least two evidence types", "States why multiple clues matter"],
                learningObjectives: [
                    "Infer dinosaur diet and movement from multiple fossil clues",
                    "fp:discovery.Dinosaurs.confidentReader"
                ],
                activityFingerprint: "dinos.discovery.confident.multi-evidence"
            )
        }
    }

    // MARK: - Space Discovery (science — not Nova story clones)

    /// Real space science across four reading bands. Planets/Rockets get unique packs later.
    private static func spaceDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Day and Night",
                storyOpening: "Nova the star twinkles over half the Earth. Right now, half the world is bright and half is dark — at the same time!",
                missionPrompt: "Catch one fact that explains why we have day and night.",
                readingPassage: "Earth spins like a top. One side faces the Sun and has day. The other side faces away and has night. The Sun does not turn off. Earth keeps spinning even while you sleep.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what does Earth do?",
                        ["It spins like a top", "It turns the Sun off each night", "It stays still and never turns"],
                        "It spins like a top",
                        "Earth spins like a top, so different sides face the Sun through the day."
                    ),
                    discoveryMCQ(
                        "What makes day and night?",
                        ["Earth's spin", "The Sun turning off at night", "The Moon covering the Sun each day"],
                        "Earth's spin",
                        "Day and night happen because Earth spins; the Sun keeps shining the whole time."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "spin",
                        definition: "To turn around and around.",
                        exampleSentence: "Earth spins to make day and night."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Earth spins, so one side has day while the other side has night.",
                        explanation: "Day and night come from Earth's rotation, not from the Sun turning off."
                    ),
                    KnowledgeFact(
                        fact: "The Sun keeps shining while Earth turns.",
                        explanation: "Night happens when your side of Earth faces away from the Sun."
                    )
                ],
                creativePrompt: "Draw Earth beside the Sun. Shade the night side and label day and night.",
                storyEnding: "Nova the star sparkles — you logged a real day-and-night fact. Great science work!",
                readingSkill: "Use a science note to explain day and night",
                reflectionPrompt: "Why is it night on one side of Earth?",
                hints: ["Look for the word spin", "Find which side faces the Sun"],
                commonMistakes: ["Thinking the Sun turns off at night"],
                successCriteria: ["Links Earth's spin to day and night"],
                learningObjectives: [
                    "Identify that Earth's spin causes day and night",
                    "fp:discovery.Space.beginner"
                ],
                activityFingerprint: "space.discovery.beginner.day-night"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "The Moon Reflects Light",
                storyOpening: "Nova the star softens her glow. Come wonder with her — where does moonlight really come from?",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "The Moon looks bright in the night sky. The Moon does not make its own light like the Sun. Sunlight hits the Moon and bounces toward Earth. That bounced light is what we call moonlight. Different amounts of the lit side face Earth as the Moon moves, so the shape we see can change.",
                questions: [
                    discoveryMCQ(
                        "Does the Moon make its own light like the Sun?",
                        ["No", "Yes, always", "Yes, but only on cloudy nights"],
                        "No",
                        "The Moon does not make its own light; it shines because sunlight bounces off it."
                    ),
                    discoveryMCQ(
                        "What hits the Moon and bounces toward Earth?",
                        ["Sunlight", "Earth's ocean water", "Heat from volcanoes"],
                        "Sunlight",
                        "Sunlight hits the Moon and bounces toward Earth as the glow we see."
                    ),
                    discoveryMCQ(
                        "What do we call that bounced light?",
                        ["Moonlight", "Sunlight made on the Moon", "Starlight from inside the Moon"],
                        "Moonlight",
                        "We call that bounced sunlight moonlight when it reaches Earth."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "reflect",
                        definition: "To bounce light back from a surface.",
                        exampleSentence: "The Moon reflects sunlight toward Earth."
                    ),
                    VocabularyWord(
                        word: "moonlight",
                        definition: "Sunlight that bounces off the Moon to Earth.",
                        exampleSentence: "Moonlight is reflected sunlight."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "The Moon does not make its own light; it reflects sunlight.",
                        explanation: "Moonlight is bounced sunlight, not a second sun."
                    ),
                    KnowledgeFact(
                        fact: "The Moon's shape in the sky can change as different lit parts face Earth.",
                        explanation: "Motion changes how much of the lit side we see."
                    )
                ],
                creativePrompt: "Draw the Sun, Moon, and Earth with an arrow showing sunlight bouncing to Earth.",
                storyEnding: "Nova the star brightens — you used light clues like a real space scientist!",
                readingSkill: "Connect moonlight to reflected sunlight",
                reflectionPrompt: "If clouds hid the Sun completely for a week, what would happen to bright moonlight?",
                hints: ["Find the sentence about bouncing light", "Look for moonlight"],
                commonMistakes: ["Thinking the Moon is a second Sun"],
                successCriteria: ["States that moonlight is reflected sunlight"],
                learningObjectives: [
                    "Explain that moonlight is sunlight reflected by the Moon",
                    "fp:discovery.Space.earlyReader"
                ],
                activityFingerprint: "space.discovery.early.moonlight"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Stars Are Distant Suns",
                storyOpening: "Nova the star sparkles farther than you can imagine. Let's investigate what stars really are!",
                missionPrompt: "Find the main science idea. Use details from the notes as evidence.",
                readingPassage: "Stars look like tiny lights because they are extremely far away. Up close, a star is a giant ball of hot glowing gas, much like our Sun. Our Sun is the closest star to Earth, so it looks huge and bright. Other stars are so distant that their light takes years to reach us. Scientists compare brightness and color to learn about a star's temperature and size. Distance, not small size, is why most stars look like pinpoints.",
                questions: [
                    discoveryMCQ(
                        "What is the main science idea in these notes?",
                        [
                            "Stars are giant glowing suns that look tiny because they are far away",
                            "Stars are tiny lamps hanging just above Earth",
                            "Our Sun is a star, but other night lights are only moons"
                        ],
                        "Stars are giant glowing suns that look tiny because they are far away",
                        "Stars are giant glowing balls of gas; they look tiny because they are extremely far away."
                    ),
                    discoveryMCQ(
                        "What is our Sun?",
                        [
                            "The closest star to Earth",
                            "Not a star at all",
                            "A cold rock that makes no light"
                        ],
                        "The closest star to Earth",
                        "Our Sun is the closest star to Earth. That is why it looks so big and bright."
                    ),
                    discoveryMCQ(
                        "Why do most stars look like pinpoints?",
                        [
                            "Because of distance, not because they are tiny",
                            "Because they are smaller than pebbles",
                            "Because they never make any light"
                        ],
                        "Because of distance, not because they are tiny",
                        "Most stars look like pinpoints because of distance, not because the stars themselves are tiny."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "distant",
                        definition: "Very far away.",
                        exampleSentence: "Distant stars look like tiny points of light."
                    ),
                    VocabularyWord(
                        word: "star",
                        definition: "A giant ball of hot glowing gas in space.",
                        exampleSentence: "Our Sun is a star."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Stars are giant balls of hot glowing gas; they look tiny because they are far away.",
                        explanation: "Appearance in the night sky is shaped by distance."
                    ),
                    KnowledgeFact(
                        fact: "Our Sun is the closest star to Earth.",
                        explanation: "Nearness makes the Sun look huge compared with other stars."
                    )
                ],
                creativePrompt: "Draw our Sun large and nearby, then tiny distant stars. Label closest star.",
                storyEnding: "Nova the star winks from afar. You used distance evidence the way careful investigators do.",
                readingSkill: "Identify the main idea about stars and distance",
                reflectionPrompt: "Why does the Sun look so different from other stars if they are similar objects?",
                hints: ["Reread the last sentence about distance", "Find the closest-star detail"],
                commonMistakes: ["Thinking stars are tiny nearby lamps"],
                successCriteria: ["States the distance main idea", "Names the Sun as our closest star"],
                learningObjectives: [
                    "Explain why distant stars look tiny compared with the Sun",
                    "fp:discovery.Space.growingReader"
                ],
                activityFingerprint: "space.discovery.growing.stars-distance"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Gravity Holds Orbits",
                storyOpening: "Nova the star invites you to study orbits. Be her science partner — how do gravity and motion keep worlds looping?",
                missionPrompt: "Use evidence from the notes. Explain why moons and planets stay on curved paths.",
                readingPassage: "Gravity is a pull between objects with mass. Earth's gravity keeps the Moon in orbit instead of letting it fly away in a straight line. The Sun's stronger gravity keeps Earth and the other planets on their paths around the Sun. An orbit is a curved path made when forward motion and gravitational pull work together. Without gravity, moving objects in space would not settle into those looping routes. Scientists use gravity ideas to predict where a moon or planet will be later.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what is gravity?",
                        [
                            "A pull between objects with mass",
                            "A wind that blows only on Earth",
                            "A light made by the Moon"
                        ],
                        "A pull between objects with mass",
                        "Gravity is a pull between objects that have mass, across Earth and space."
                    ),
                    discoveryMCQ(
                        "What keeps the Moon in orbit around Earth?",
                        [
                            "Earth's gravity",
                            "Ocean waves pulling from below",
                            "The Moon's own bright light"
                        ],
                        "Earth's gravity",
                        "Earth's gravity pulls on the Moon and keeps it in a curved orbit."
                    ),
                    discoveryMCQ(
                        "What can you infer about an orbit?",
                        [
                            "It is a curved path from forward motion plus gravitational pull",
                            "It is a straight line with no pull at all",
                            "It only happens when gravity disappears"
                        ],
                        "It is a curved path from forward motion plus gravitational pull",
                        "An orbit is a curved path made when forward motion and gravity work together."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "gravity",
                        definition: "A pull between objects that have mass.",
                        exampleSentence: "Gravity keeps the Moon near Earth."
                    ),
                    VocabularyWord(
                        word: "orbit",
                        definition: "A curved path one object follows around another.",
                        exampleSentence: "Earth is in orbit around the Sun."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Gravity is a pull between objects with mass.",
                        explanation: "That pull shapes motion across the solar system."
                    ),
                    KnowledgeFact(
                        fact: "Earth's gravity keeps the Moon in orbit; the Sun's gravity keeps planets on their paths.",
                        explanation: "Orbits depend on gravitational pull plus forward motion."
                    ),
                    KnowledgeFact(
                        fact: "An orbit is a curved path, not a straight line through empty space.",
                        explanation: "Without gravity, objects would not settle into looping routes."
                    )
                ],
                creativePrompt: "Draw Earth with the Moon on a curved orbit path. Label gravity pull and forward motion.",
                storyEnding: "Nova the star loops once for joy. You connected gravity to orbits like a careful investigator.",
                readingSkill: "Infer how gravity and motion create orbits",
                reflectionPrompt: "Which clue from the notes best explains why the Moon does not fly away in a straight line?",
                hints: ["Find the definition of orbit", "Compare Earth's pull with the Moon's path"],
                commonMistakes: ["Thinking orbits are straight lines with no pull"],
                successCriteria: ["Defines gravity from the notes", "Links gravity to a curved orbit"],
                learningObjectives: [
                    "Explain how gravity and motion work together to make orbits",
                    "fp:discovery.Space.confidentReader"
                ],
                activityFingerprint: "space.discovery.confident.gravity-orbit"
            )
        }
    }

    // MARK: - Dogs Discovery (science — not Ben/Scout training-story clones)

    /// Real dog biology and senses across four reading bands.
    private static func dogsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "A Dog's Super Nose",
                storyOpening: "Scout the puppy freezes. His nose twitches. What tiny smell did that strong nose just catch?",
                missionPrompt: "Sniff out one fact about a dog's nose.",
                readingPassage: "Dogs have strong noses. A dog uses smell to learn about the world. Wet noses help pick up scents. A dog can smell things people miss — even a tiny treat hiding across a room.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what do dogs have?",
                        ["Strong noses", "Almost no sense of smell", "Eyes but no useful noses"],
                        "Strong noses",
                        "Dogs have strong noses and use smell as a main way to learn about the world."
                    ),
                    discoveryMCQ(
                        "What can a dog smell?",
                        ["Things people miss", "Bright colors on a wall", "Loud sounds in the air"],
                        "Things people miss",
                        "A dog's nose can pick up faint scents that people usually miss."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "scent",
                        definition: "A smell left by a person, animal, or thing.",
                        exampleSentence: "A wet nose helps pick up a scent."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Dogs have strong noses and use smell to learn about the world.",
                        explanation: "Smell is one of a dog's most important senses."
                    ),
                    KnowledgeFact(
                        fact: "A dog can smell things people miss.",
                        explanation: "Dogs detect many faint scents that humans overlook."
                    )
                ],
                creativePrompt: "Draw a dog sniffing a trail. Label the nose and one scent swirl.",
                storyEnding: "Scout the puppy wags — you logged a real nose fact. Great science work!",
                readingSkill: "Use a science note to explain dog smelling",
                reflectionPrompt: "Name one way a dog's nose helps it learn.",
                hints: ["Look for the word noses", "Find what dogs can smell"],
                commonMistakes: ["Choosing a fact about eyes that is not in the notes"],
                successCriteria: ["Names strong smell from the notes"],
                learningObjectives: [
                    "Identify that dogs use strong noses to learn about the world",
                    "fp:discovery.Dogs.beginner"
                ],
                activityFingerprint: "dogs.discovery.beginner.nose"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Ears That Catch Soft Sounds",
                storyOpening: "Scout the puppy tips an ear. Come listen — dog ears catch soft sounds people might miss!",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "Dogs can hear many soft or high sounds. Their ears can move to catch a noise. Moving ears help a dog find where a sound comes from. A dog may notice a quiet footstep before a person does. Careful listening is part of how dogs stay alert.",
                questions: [
                    discoveryMCQ(
                        "What can dogs hear?",
                        ["Many soft or high sounds", "Just deep drum sounds", "Just very loud thunder sounds"],
                        "Many soft or high sounds",
                        "Dogs can hear many soft or high sounds that people often miss."
                    ),
                    discoveryMCQ(
                        "Why can dog ears move?",
                        ["To catch a noise and find where it comes from", "To taste food better while chewing", "To help the dog see colors more clearly"],
                        "To catch a noise and find where it comes from",
                        "Moving ears help a dog catch a noise and figure out where it comes from."
                    ),
                    discoveryMCQ(
                        "What may a dog notice before a person does?",
                        ["A quiet footstep", "A silent color on the wall", "A taste with no smell nearby"],
                        "A quiet footstep",
                        "Careful dog hearing can notice a quiet footstep before a person hears it."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "alert",
                        definition: "Ready to notice what is happening nearby.",
                        exampleSentence: "Careful listening helps a dog stay alert."
                    ),
                    VocabularyWord(
                        word: "sound",
                        definition: "Something you can hear.",
                        exampleSentence: "A dog can catch a soft sound."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Dogs can hear many soft or high sounds that people may miss.",
                        explanation: "Sensitive hearing helps dogs notice quiet changes."
                    ),
                    KnowledgeFact(
                        fact: "Moving ears help a dog find where a sound comes from.",
                        explanation: "Ear motion supports locating noises."
                    )
                ],
                creativePrompt: "Draw a dog with ears turned toward a quiet footstep. Label listening.",
                storyEnding: "Scout the puppy perks both ears — you used hearing clues like a real dog scientist!",
                readingSkill: "Connect ear movement to finding sounds",
                reflectionPrompt: "Why might a dog turn its ears before it looks?",
                hints: ["Find soft or high sounds", "Look for moving ears"],
                commonMistakes: ["Guessing a hearing fact that is not in the notes"],
                successCriteria: ["Names soft/high hearing", "Links ear movement to locating sound"],
                learningObjectives: [
                    "Explain how dog ears help catch and locate sounds",
                    "fp:discovery.Dogs.earlyReader"
                ],
                activityFingerprint: "dogs.discovery.early.hearing"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Why Dogs Pant",
                storyOpening: "Scout the puppy pants after a sunny run. Let's investigate how dogs cool their bodies!",
                missionPrompt: "Find the main science idea. Use details from the notes as evidence.",
                readingPassage: "People cool down by sweating through much of their skin. Dogs have far fewer sweat glands for cooling, so they use another tool: panting. Panting moves air quickly over the moist tongue and mouth. Water evaporates there and carries heat away from the body. On hot days, a panting dog is often working hard to stay cool, not just being noisy. Fresh water and shade help that cooling system work safely.",
                questions: [
                    discoveryMCQ(
                        "What is the main science idea in these notes?",
                        [
                            "Dogs cool their bodies mainly by panting",
                            "Dogs cool down mainly by sweating like people",
                            "Panting is noisy but does not help cool the body"
                        ],
                        "Dogs cool their bodies mainly by panting",
                        "Dogs have fewer sweat glands for cooling, so panting is their main way to cool down."
                    ),
                    discoveryMCQ(
                        "What happens when water evaporates from the mouth during panting?",
                        [
                            "Heat is carried away from the body",
                            "The dog instantly grows thicker fur",
                            "The dog stops needing drinking water"
                        ],
                        "Heat is carried away from the body",
                        "When water evaporates from the moist mouth, heat leaves the dog's body."
                    ),
                    discoveryMCQ(
                        "What helps a panting dog stay safer on hot days?",
                        [
                            "Fresh water and shade",
                            "A closed hot car with no air",
                            "Extra heavy blankets on its back"
                        ],
                        "Fresh water and shade",
                        "Fresh water and shade help a panting dog's cooling system work safely."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "panting",
                        definition: "Breathing quickly with an open mouth to help cool the body.",
                        exampleSentence: "Panting helps a hot dog cool down."
                    ),
                    VocabularyWord(
                        word: "evaporate",
                        definition: "To change from liquid water into invisible vapor in the air.",
                        exampleSentence: "Water can evaporate from a dog's tongue."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Dogs cool mainly by panting because they have fewer sweat glands for cooling than people.",
                        explanation: "Panting moves air over a moist mouth so heat can leave the body."
                    ),
                    KnowledgeFact(
                        fact: "Fresh water and shade help a panting dog cool safely on hot days.",
                        explanation: "Cooling still needs water and a cooler place to rest."
                    )
                ],
                creativePrompt: "Draw a dog panting in shade next to a water bowl. Label heat leaving the mouth.",
                storyEnding: "Scout the puppy cools down beside you. You used cooling evidence the way careful investigators do.",
                readingSkill: "Identify the main idea about dog thermoregulation",
                reflectionPrompt: "Why is panting more useful for dogs than trying to sweat like people?",
                hints: ["Compare people sweating with dog panting", "Find evaporate / heat leaving"],
                commonMistakes: ["Treating panting as meaningless noise"],
                successCriteria: ["States panting-as-cooling main idea", "Cites water or shade support"],
                learningObjectives: [
                    "Explain why dogs pant to cool their bodies",
                    "fp:discovery.Dogs.growingReader"
                ],
                activityFingerprint: "dogs.discovery.growing.panting"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Smell Leads the Way",
                storyOpening: "Scout the puppy sniffs, listens, and watches. Partner up — how do dogs and people gather clues from the world?",
                missionPrompt: "Use evidence from the notes. Explain why smell guides many dog choices.",
                readingPassage: "People often explore a new place with their eyes first. Dogs usually lead with smell. A dog's nose has many more scent detectors than a human nose, so faint trails can still be useful clues. Sniffing the ground, the air, and other animals builds a scent map of who was here and which way they went. That is why a dog may stop to investigate a patch of grass that looks empty to you. Trainers and scientists who work with detection dogs rely on this smell-first way of knowing. Vision still matters, but for many dogs smell is the main sense for understanding the world.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, how do dogs usually explore a new place?",
                        [
                            "They lead with smell",
                            "They lead with vision like people",
                            "They use only taste and never smell"
                        ],
                        "They lead with smell",
                        "Unlike people who often look first, dogs usually explore a new place with smell first."
                    ),
                    discoveryMCQ(
                        "Why can faint trails still be useful clues for dogs?",
                        [
                            "A dog's nose has many more scent detectors than a human nose",
                            "Dogs have fewer scent detectors than people",
                            "Grass and air never hold any smell"
                        ],
                        "A dog's nose has many more scent detectors than a human nose",
                        "Extra scent detectors let dogs use faint trails that people cannot notice."
                    ),
                    discoveryMCQ(
                        "What can you infer about a dog sniffing empty-looking grass?",
                        [
                            "The dog may be reading scent clues you cannot see",
                            "The dog is only confused by green colors",
                            "Smell never matters once the dog can see"
                        ],
                        "The dog may be reading scent clues you cannot see",
                        "Sniffing builds a scent map of who was there, even when the grass looks empty to people."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "detector",
                        definition: "A body part that notices a signal such as a scent.",
                        exampleSentence: "A dog's nose has many scent detectors."
                    ),
                    VocabularyWord(
                        word: "trail",
                        definition: "A path of scent left behind by someone or something.",
                        exampleSentence: "A faint trail can still guide a dog's nose."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Dogs usually explore with smell first, while people often lead with vision.",
                        explanation: "Different senses shape how each species understands a place."
                    ),
                    KnowledgeFact(
                        fact: "A dog's nose has many more scent detectors than a human nose.",
                        explanation: "That difference lets dogs use faint trails as clues."
                    ),
                    KnowledgeFact(
                        fact: "Detection work relies on a dog's smell-first way of knowing the world.",
                        explanation: "Sniffing builds a scent map of who was here and which way they went."
                    )
                ],
                creativePrompt: "Draw a person looking and a dog sniffing the same path. Label vision-first and smell-first.",
                storyEnding: "Scout the puppy sits proud. You connected senses to behavior like a careful investigator.",
                readingSkill: "Infer why smell guides many dog decisions",
                reflectionPrompt: "Which clue from the notes best explains why detection dogs are useful?",
                hints: ["Compare people leading with eyes to dogs leading with smell", "Reread scent detectors"],
                commonMistakes: ["Assuming dogs and people gather clues the same way"],
                successCriteria: ["States smell-first exploration", "Uses detector or trail evidence"],
                learningObjectives: [
                    "Infer how a smell-first nose shapes how dogs understand the world",
                    "fp:discovery.Dogs.confidentReader"
                ],
                activityFingerprint: "dogs.discovery.confident.olfaction"
            )
        }
    }

    // MARK: - Robots Discovery (science/engineering — not Max story clones)

    /// Real robotics concepts across four reading bands.
    private static func robotsDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Robots Follow Steps",
                storyOpening: "Max the robot freezes mid-step. Beep — did someone forget a step in its list?",
                missionPrompt: "Pick out one fact about how a robot knows what to do.",
                readingPassage: "A robot is a machine. People write steps for the robot. The steps are called a program. The robot does the steps in order. Skip one step, and the robot may stop or get stuck.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what is a robot?",
                        ["A machine", "A living animal", "A growing plant"],
                        "A machine",
                        "A robot is a machine that follows steps people write for it."
                    ),
                    discoveryMCQ(
                        "What are the steps for a robot called?",
                        ["A program", "A paper map", "A random guess"],
                        "A program",
                        "The ordered steps a robot follows are called a program."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "program",
                        definition: "A list of steps a robot follows.",
                        exampleSentence: "The program tells the robot what to do."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A robot is a machine that follows steps written by people.",
                        explanation: "Those steps are called a program."
                    ),
                    KnowledgeFact(
                        fact: "A robot does program steps in order.",
                        explanation: "Order matters when a machine follows instructions."
                    )
                ],
                creativePrompt: "Draw a robot and three numbered steps it follows. Label program.",
                storyEnding: "Max the robot beeps twice — you logged a real program fact. Great science work!",
                readingSkill: "Use a science note to explain robot programs",
                reflectionPrompt: "What does a program tell a robot?",
                hints: ["Look for the word program", "Find steps in order"],
                commonMistakes: ["Choosing a living-thing idea that is not in the notes"],
                successCriteria: ["Names program or ordered steps from the notes"],
                learningObjectives: [
                    "Identify that robots follow programmed steps in order",
                    "fp:discovery.Robots.beginner"
                ],
                activityFingerprint: "robots.discovery.beginner.program"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Sensors Are Robot Senses",
                storyOpening: "Max the robot lights a sensor. Come see how robot sensors help a machine notice the world!",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "Robots cannot feel the world the way people do. Sensors collect information such as light, sound, or touch. A touch sensor can notice a bump. A light sensor can notice bright or dark places. The robot uses sensor clues to choose the next safe step.",
                questions: [
                    discoveryMCQ(
                        "What do sensors collect?",
                        ["Information such as light, sound, or touch", "Food and water for the robot", "Feelings like hunger or joy"],
                        "Information such as light, sound, or touch",
                        "Sensors collect information such as light, sound, or touch from the world around the robot."
                    ),
                    discoveryMCQ(
                        "What can a touch sensor notice?",
                        ["A bump", "A faraway color change", "A quiet smell in the air"],
                        "A bump",
                        "A touch sensor notices contact, such as a bump, so the robot can react."
                    ),
                    discoveryMCQ(
                        "How does a robot use sensor clues?",
                        ["To choose the next safe step", "To grow and heal like an animal", "To invent feelings on its own"],
                        "To choose the next safe step",
                        "Sensor clues help the robot choose the next safe step based on what it detects."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "sensor",
                        definition: "A part that collects information from the world.",
                        exampleSentence: "A light sensor notices bright and dark places."
                    ),
                    VocabularyWord(
                        word: "information",
                        definition: "Facts or clues a machine can use.",
                        exampleSentence: "Sensors send information to the robot."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Sensors collect information such as light, sound, or touch for a robot.",
                        explanation: "Sensors are how robots detect the world around them."
                    ),
                    KnowledgeFact(
                        fact: "Robot sensor clues help the machine choose safer next steps.",
                        explanation: "Without sensors, a robot would move with fewer clues."
                    )
                ],
                creativePrompt: "Draw a robot with a touch sensor and a light sensor labeled.",
                storyEnding: "Max the robot blinks green — you used sensor clues like a real robotics scientist!",
                readingSkill: "Connect sensors to how robots detect the world",
                reflectionPrompt: "Which sensor from the notes would help most in a dark hallway?",
                hints: ["Find light, sound, or touch", "Look for next safe step"],
                commonMistakes: ["Guessing a sensor fact that is not in the notes"],
                successCriteria: ["Names a sensor type", "Links sensors to choosing steps"],
                learningObjectives: [
                    "Explain how sensors give robots information about the world",
                    "fp:discovery.Robots.earlyReader"
                ],
                activityFingerprint: "robots.discovery.early.sensors"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Sense, Decide, Act",
                storyOpening: "Max the robot lifts one careful arm. Let's investigate how a robot decides to make a move!",
                missionPrompt: "Find the main science idea. Use details from the notes as evidence.",
                readingPassage: "Many robots work in a simple loop: sense, decide, act. First, sensors gather input from the surroundings. Next, the program decides what the input means. Then motors or other parts act by moving, stopping, or signaling. After the action, the robot can sense again to check what changed. Engineers test this loop so the robot does not act on missing or wrong clues. Clear sensing and clear rules make safer robot behavior.",
                questions: [
                    discoveryMCQ(
                        "What is the main science idea in these notes?",
                        [
                            "Many robots work by sensing, deciding, then acting",
                            "Robots move first and never use sensors",
                            "Robots act once and never check what changed"
                        ],
                        "Many robots work by sensing, deciding, then acting",
                        "Many robots follow a loop: sense the world, decide what it means, then act."
                    ),
                    discoveryMCQ(
                        "What gathers input first in the loop?",
                        ["Sensors", "Motors that already finished moving", "Labels printed on the robot"],
                        "Sensors",
                        "Sensors gather input from the surroundings before the program decides what to do."
                    ),
                    discoveryMCQ(
                        "Why do engineers test the loop?",
                        [
                            "So the robot does not act on missing or wrong clues",
                            "So the robot can ignore all sensors",
                            "So programs never need clear rules"
                        ],
                        "So the robot does not act on missing or wrong clues",
                        "Engineers test the loop so the robot does not act on missing or wrong sensor clues."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "input",
                        definition: "Information a robot receives from sensors.",
                        exampleSentence: "Light readings are one kind of input."
                    ),
                    VocabularyWord(
                        word: "motor",
                        definition: "A part that makes a robot move.",
                        exampleSentence: "Motors act when the program chooses a move."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Many robots follow a sense, decide, act loop.",
                        explanation: "Input leads to a program decision, then an action."
                    ),
                    KnowledgeFact(
                        fact: "Engineers test robot loops so machines do not act on missing or wrong clues.",
                        explanation: "Clear sensing and clear rules support safer behavior."
                    )
                ],
                creativePrompt: "Draw a three-box loop labeled Sense, Decide, and Act. Add one arrow back to Sense.",
                storyEnding: "Max the robot resets for the next try. You traced a control loop the way careful investigators do.",
                readingSkill: "Identify the main idea of a robot control loop",
                reflectionPrompt: "Which step in the loop would fail first if a sensor broke?",
                hints: ["Reread sense, decide, act", "Find why engineers test"],
                commonMistakes: ["Skipping sensing and jumping straight to random action"],
                successCriteria: ["States the three-step loop", "Cites testing for safer behavior"],
                learningObjectives: [
                    "Explain the sense-decide-act loop robots use",
                    "fp:discovery.Robots.growingReader"
                ],
                activityFingerprint: "robots.discovery.growing.control-loop"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Machines Are Not Alive",
                storyOpening: "Max the robot stands beside a living animal for a science check. Partner up — how do robots compare with living things?",
                missionPrompt: "Use evidence from the notes. Explain what robots can and cannot do on their own.",
                readingPassage: "Robots can sense, decide, and act, but they are still machines built by people. They do not grow, heal, or feel hunger the way living animals do. A robot only follows the rules and data it is given, even when those rules look clever. If the program or sensors fail, the robot cannot invent a brand-new goal the way a curious animal might. That limit is why engineers add safety checks and human supervision for important jobs. Understanding both the power and the limits of robots helps people use them wisely.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what are robots still?",
                        [
                            "Machines built by people",
                            "Living animals that feel hunger",
                            "Plants that grow and heal themselves"
                        ],
                        "Machines built by people",
                        "Robots can sense and act, but they are still machines built by people."
                    ),
                    discoveryMCQ(
                        "What happens if the program or sensors fail?",
                        [
                            "The robot cannot invent a brand-new goal the way a curious animal might",
                            "The robot instantly becomes a living creature",
                            "The robot no longer needs any safety checks"
                        ],
                        "The robot cannot invent a brand-new goal the way a curious animal might",
                        "If programs or sensors fail, a robot cannot invent a new goal the way a curious animal might."
                    ),
                    discoveryMCQ(
                        "What can you infer about using robots wisely?",
                        [
                            "People should understand both robot power and robot limits",
                            "Robots never need human supervision for important jobs",
                            "Safety checks are useless once a robot can move"
                        ],
                        "People should understand both robot power and robot limits",
                        "Using robots wisely means knowing both what they can do and where their machine limits are."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "supervision",
                        definition: "Careful watching and guidance by a person.",
                        exampleSentence: "Important robot jobs often need human supervision."
                    ),
                    VocabularyWord(
                        word: "limit",
                        definition: "A point beyond which something cannot go.",
                        exampleSentence: "A robot's program sets limits on what it can decide."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Robots are machines built by people; they are not living animals.",
                        explanation: "They do not grow, heal, or feel hunger like living creatures."
                    ),
                    KnowledgeFact(
                        fact: "A robot follows the rules and data it is given.",
                        explanation: "Clever-looking behavior still depends on programs and sensors."
                    ),
                    KnowledgeFact(
                        fact: "Safety checks and human supervision matter because robot goals are limited when systems fail.",
                        explanation: "Knowing power and limits helps people use robots wisely."
                    )
                ],
                creativePrompt: "Draw a two-column chart: Living animal vs Robot. Add one true trait in each column from the notes.",
                storyEnding: "Max the robot logs the finding. You compared machines and living things like a careful investigator.",
                readingSkill: "Infer robot capabilities and limits from evidence",
                reflectionPrompt: "Which limit from the notes would matter most during a hospital-delivery robot job?",
                hints: ["Compare living traits with machine traits", "Reread safety checks and supervision"],
                commonMistakes: ["Treating robots as living animals with feelings and hunger"],
                successCriteria: ["States robots are machines", "Uses a limit or supervision detail"],
                learningObjectives: [
                    "Infer what robots can do and where their machine limits matter",
                    "fp:discovery.Robots.confidentReader"
                ],
                activityFingerprint: "robots.discovery.confident.machine-limits"
            )
        }
    }

    // MARK: - Volcanoes Discovery (science — not Dr. Nolan story clones)

    /// Real volcano earth science across four reading bands.
    private static func volcanoesDiscovery(_ level: ReadingLevel) -> DiscoveryPack {
        switch level {
        case .beginner:
            return DiscoveryPack(
                title: "Hot Rock Inside Earth",
                storyOpening: "Dottie the dino stomps and feels warmth under her feet. Deep down, rock can get so hot it softens and moves.",
                missionPrompt: "Discover one fact about where a volcano's hot rock comes from.",
                readingPassage: "A volcano is a mountain that can open. Hot rock can rise from deep inside Earth. When hot rock comes out, it can be hotter than a kitchen oven. People stay far away when a volcano is unsafe.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what is a volcano?",
                        ["A mountain that can open", "A quiet pond of cold water", "A hill made only of soft soil"],
                        "A mountain that can open",
                        "A volcano is a mountain that can open and let hot rock come out from deep Earth."
                    ),
                    discoveryMCQ(
                        "Where can hot rock rise from?",
                        ["Deep inside Earth", "Cold rain clouds in the sky", "Shallow puddles on the ground"],
                        "Deep inside Earth",
                        "Hot rock in a volcano rises from deep inside Earth, not from the sky or surface puddles."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "volcano",
                        definition: "A mountain that can open and let hot rock come out.",
                        exampleSentence: "A volcano can release hot rock from deep Earth."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "A volcano is a mountain that can open so hot rock can come out.",
                        explanation: "Hot rock rises from deep inside Earth."
                    ),
                    KnowledgeFact(
                        fact: "People stay far away when a volcano is unsafe.",
                        explanation: "Hot erupting rock is dangerous to be near."
                    )
                ],
                creativePrompt: "Draw a volcano mountain with a label for hot rock deep inside Earth.",
                storyEnding: "Dottie the dino stomps once — you logged a real volcano fact. Great science work!",
                readingSkill: "Use a science note to explain what a volcano is",
                reflectionPrompt: "Where does the hot rock come from?",
                hints: ["Look for mountain that can open", "Find deep inside Earth"],
                commonMistakes: ["Choosing a safe soft object that is not a volcano"],
                successCriteria: ["Names volcano as an opening mountain", "Links hot rock to deep Earth"],
                learningObjectives: [
                    "Identify that volcanoes can release hot rock from deep Earth",
                    "fp:discovery.Volcanoes.beginner"
                ],
                activityFingerprint: "volcanoes.discovery.beginner.hot-rock"
            )

        case .earlyReader:
            return DiscoveryPack(
                title: "Magma and Lava",
                storyOpening: "Dottie the dino points at glowing rock. Come learn the difference between magma and lava with her!",
                missionPrompt: "Read the science notes. Answer using evidence from the notes.",
                readingPassage: "Hot melted rock under the ground is called magma. When that melted rock reaches the surface, scientists call it lava. Magma and lava are the same kind of hot rock in different places. Lava can cool and harden into new rock. Learning the two names helps you read volcano maps and news carefully.",
                questions: [
                    discoveryMCQ(
                        "What is hot melted rock under the ground called?",
                        ["Magma", "Lava", "Ash"],
                        "Magma",
                        "Hot melted rock still under the ground is called magma."
                    ),
                    discoveryMCQ(
                        "What do scientists call melted rock at the surface?",
                        ["Lava", "Magma", "Ash clouds"],
                        "Lava",
                        "When melted rock reaches the surface, scientists call it lava."
                    ),
                    discoveryMCQ(
                        "What can lava do when it cools?",
                        ["Harden into new rock", "Turn back into underground magma", "Stay melted with no change"],
                        "Harden into new rock",
                        "When lava cools, it hardens into new rock on Earth's surface."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "magma",
                        definition: "Hot melted rock still under the ground.",
                        exampleSentence: "Magma rises inside a volcano."
                    ),
                    VocabularyWord(
                        word: "lava",
                        definition: "Hot melted rock that has reached Earth's surface.",
                        exampleSentence: "Lava can cool into hard rock."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Magma is melted rock underground; lava is melted rock at the surface.",
                        explanation: "The two names mark location, not two totally different materials."
                    ),
                    KnowledgeFact(
                        fact: "Lava can cool and harden into new rock.",
                        explanation: "Cooled lava builds new landforms over time."
                    )
                ],
                creativePrompt: "Draw underground magma and surface lava. Label both words.",
                storyEnding: "Dottie the dino grins at the glow — you used magma and lava clues like a real earth scientist!",
                readingSkill: "Distinguish magma underground from lava at the surface",
                reflectionPrompt: "If melted rock is still underground, which word from the notes fits?",
                hints: ["Find under the ground", "Find at the surface"],
                commonMistakes: ["Mixing up magma and lava locations"],
                successCriteria: ["Matches magma to underground", "Matches lava to surface"],
                learningObjectives: [
                    "Explain the difference between magma and lava",
                    "fp:discovery.Volcanoes.earlyReader"
                ],
                activityFingerprint: "volcanoes.discovery.early.magma-lava"
            )

        case .growingReader:
            return DiscoveryPack(
                title: "Pressure Builds Toward Eruption",
                storyOpening: "Dottie the dino feels the ground tremble. Let's investigate why volcanoes erupt!",
                missionPrompt: "Find the main science idea. Use details from the notes as evidence.",
                readingPassage: "Deep underground, magma and gas can push upward. As more melted rock and gas collect, pressure inside the volcano rises. When the pressure becomes too great for the rock above to hold, an eruption can begin. Gas bubbles help drive magma toward openings at the surface. Not every rumble means a giant eruption, but rising pressure is a key reason volcanoes can suddenly release lava, ash, and gas. Scientists watch for clues that pressure is changing.",
                questions: [
                    discoveryMCQ(
                        "What is the main science idea in these notes?",
                        [
                            "Rising pressure from magma and gas can lead to an eruption",
                            "Volcanoes erupt only when the sky turns cloudy",
                            "Pressure inside a volcano never changes or matters"
                        ],
                        "Rising pressure from magma and gas can lead to an eruption",
                        "As magma and gas collect, rising pressure can push until an eruption begins."
                    ),
                    discoveryMCQ(
                        "What helps drive magma toward surface openings?",
                        ["Gas bubbles", "Cold rainwater alone", "Quiet moonlight on the peak"],
                        "Gas bubbles",
                        "Gas bubbles help push magma toward openings at the surface."
                    ),
                    discoveryMCQ(
                        "When can an eruption begin?",
                        [
                            "When pressure becomes too great for the rock above to hold",
                            "When the volcano runs out of all rock",
                            "When Earth's heat is switched off completely"
                        ],
                        "When pressure becomes too great for the rock above to hold",
                        "An eruption can begin when pressure grows too great for the rock above to hold."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "pressure",
                        definition: "A strong push from inside.",
                        exampleSentence: "Pressure rises as magma and gas collect."
                    ),
                    VocabularyWord(
                        word: "eruption",
                        definition: "When a volcano releases lava, ash, or gas.",
                        exampleSentence: "An eruption can begin when pressure gets too high."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Magma and gas can raise pressure inside a volcano until an eruption begins.",
                        explanation: "Pressure is a key driver of volcanic eruptions."
                    ),
                    KnowledgeFact(
                        fact: "Gas bubbles help drive magma toward openings at the surface.",
                        explanation: "Gas and melted rock move together as pressure rises."
                    )
                ],
                creativePrompt: "Draw a volcano cross-section with arrows for rising magma and gas. Label pressure.",
                storyEnding: "Dottie the dino steadies her feet. You traced eruption pressure the way careful investigators do.",
                readingSkill: "Identify the main idea about volcanic pressure",
                reflectionPrompt: "Which clue from the notes would make you take a volcano warning seriously?",
                hints: ["Reread rising pressure", "Find gas bubbles"],
                commonMistakes: ["Thinking eruptions happen with no pressure change"],
                successCriteria: ["States pressure-to-eruption main idea", "Cites magma or gas"],
                learningObjectives: [
                    "Explain how rising magma and gas pressure can cause eruptions",
                    "fp:discovery.Volcanoes.growingReader"
                ],
                activityFingerprint: "volcanoes.discovery.growing.pressure"
            )

        case .confidentReader:
            return DiscoveryPack(
                title: "Watching for Warning Signs",
                storyOpening: "Dottie the dino checks shake and steam clues. Partner up — how do scientists monitor restless volcanoes?",
                missionPrompt: "Use evidence from the notes. Explain why many signals together matter more than one rumble.",
                readingPassage: "Volcanologists cannot see every underground change, so they watch a set of warning signs. Tiny earthquakes may increase when magma shifts. Ground can swell slightly as pressure builds. Gas escaping from vents can change in amount or type. Satellites and ground sensors help track these clues over time. One small rumble alone does not prove a big eruption is coming, but several signs rising together make scientists more concerned. Sharing clear warnings helps communities prepare and stay safer.",
                questions: [
                    discoveryMCQ(
                        "According to the notes, what may increase when magma shifts?",
                        [
                            "Tiny earthquakes",
                            "Rainbow colors across the sky",
                            "Cool ponds on the summit"
                        ],
                        "Tiny earthquakes",
                        "Tiny earthquakes may increase when magma shifts underground."
                    ),
                    discoveryMCQ(
                        "What can happen to the ground as pressure builds?",
                        [
                            "It can swell slightly",
                            "It always sinks into ocean water",
                            "It disappears before sensors can notice"
                        ],
                        "It can swell slightly",
                        "As pressure builds, ground can swell slightly—a clue scientists watch carefully."
                    ),
                    discoveryMCQ(
                        "What can you infer about volcano warnings?",
                        [
                            "Several rising signs together are more concerning than one rumble alone",
                            "One tiny rumble always proves a giant eruption will happen today",
                            "Scientists ignore gas and ground clues on purpose"
                        ],
                        "Several rising signs together are more concerning than one rumble alone",
                        "Several warning signs rising together matter more than one small rumble alone."
                    )
                ],
                vocabularyWords: [
                    VocabularyWord(
                        word: "volcanologist",
                        definition: "A scientist who studies volcanoes.",
                        exampleSentence: "A volcanologist watches earthquakes, gas, and ground changes."
                    ),
                    VocabularyWord(
                        word: "monitor",
                        definition: "To watch carefully for changes over time.",
                        exampleSentence: "Sensors help scientists monitor a volcano."
                    )
                ],
                knowledgeFacts: [
                    KnowledgeFact(
                        fact: "Scientists monitor volcanoes using earthquakes, ground swelling, and gas changes.",
                        explanation: "Multiple instruments track clues that magma may be moving."
                    ),
                    KnowledgeFact(
                        fact: "Several warning signs rising together are more concerning than one rumble alone.",
                        explanation: "Patterns of clues support better eruption warnings."
                    ),
                    KnowledgeFact(
                        fact: "Clear volcano warnings help communities prepare and stay safer.",
                        explanation: "Monitoring is useful when people can act on the information."
                    )
                ],
                creativePrompt: "Draw a scientist dashboard with three labeled clues: earthquakes, ground swell, and gas.",
                storyEnding: "Dottie the dino logs the last clue. You connected monitoring clues like a careful investigator.",
                readingSkill: "Infer eruption risk from multiple warning signs",
                reflectionPrompt: "Which pair of clues from the notes would you want before evacuating a town?",
                hints: ["Compare one rumble with several signs together", "Find earthquakes, swell, and gas"],
                commonMistakes: ["Treating a single small rumble as full proof of a giant eruption"],
                successCriteria: ["Names at least two monitoring clues", "States why multiple signs matter"],
                learningObjectives: [
                    "Infer how scientists use multiple signals to monitor volcanoes",
                    "fp:discovery.Volcanoes.confidentReader"
                ],
                activityFingerprint: "volcanoes.discovery.confident.monitoring"
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
