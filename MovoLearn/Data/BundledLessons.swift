import Foundation

/// Hand-crafted sample lessons — **retired from the child browse catalog**.
/// Kept for SwiftUI previews, unit tests, and `LessonLoader.lesson(id:)` resume
/// (Home / daily options use `ApprovedContentLibrary` + curated Swift packs instead).
enum BundledLessons {
    static let all: [Lesson] = [
        // sharkExplorer omitted — sharks.json provides canonical "Reef Rescue"
        sharkRescue, reefMystery,
        // stableBuilder omitted — horses.json provides canonical "Sunny's Stable Mission"
        ponyCare, horseRaceMath,
        rocketMission, planetExplorer, moonMystery,
        fossilDetective, dinoRescue, volcanoValley,
        stadiumMath, teamCaptainReading, soccerStrategy,
        robotRepair, codingLab, futureCity,
        dogParkDetective, catClueHunt,
        coralCaveExplorer, castleStoryLab,
        treasureMapMystery, courtCounting
    ] + BundledLessonsExtended.all

    static func lessons(for topic: Topic) -> [Lesson] {
        all.filter { $0.theme == topic }
    }

    // MARK: - Sharks

    static let sharkExplorer = makeLesson(
        title: "Reef Explorer",
        theme: .sharks, type: .explorer,
        category: .story,
        storyOpening: "Far below the ocean waves, a young reef shark named Finn noticed that the coral garden had gone quiet.",
        missionPrompt: "Help Finn the shark follow the clues and find the missing fish.",
        storyEnding: "The reef hums with life again. Finn swims in happy circles — thanks to you, the reef mystery is solved!",
        readingSkill: "Finding main ideas",
        mathSkill: "Addition within 10",
        vocab: "Gills", vocabDef: "body parts that help sharks breathe underwater",
        fact: "Sharks use gills to breathe underwater, pulling oxygen from the water as they swim.",
        creative: "Design a secret underwater hideout for Finn. What would be inside?",
        creativeResponseType: .drawing,
        reflection: "Which clue helped you the most near the coral cave?",
        reflectionResponseType: .shortText,
        passage: "Blue light shimmered across the coral reef as Finn the young shark searched for his fish friends. He swam past waving sea plants and noticed tiny bubbles rising from a dark cave. Finn uses gills to breathe underwater, just like other fish. His guide pointed to the slits along his neck — gills that pull oxygen from the water with every swim. With a flick of his fin, Finn spotted silver fish hiding below. If Finn follows the bubbles, he might find the missing fish.",
        readingQs: [
            ("What clue did Finn notice near the cave?", ["Tiny bubbles rising from the dark cave", "A school of fish near the reef", "Waving sea plants by the rocks"], "Tiny bubbles rising from the dark cave", "Finn noticed bubbles rising from a dark cave."),
            ("Where does Finn's adventure take place?", ["Under the ocean near a coral reef", "In a kelp forest", "Beside a sandy lagoon"], "Under the ocean near a coral reef", "Finn explores a reef deep under the waves."),
            ("What helps Finn breathe underwater?", ["Gills", "Lungs", "Blowholes"], "Gills", "Sharks use gills to breathe underwater."),
            ("How does Finn move through the water?", ["His fin helps him swim", "He walks on the reef", "He floats without moving"], "His fin helps him swim", "Finn flicks his fin to swim.")
        ],
        mathQs: [
            ("Finn found 4 silver fish hiding near the coral and 3 yellow fish behind a rock. How many fish did Finn find altogether?", ["6", "7", "8"], "7", "4 + 3 = 7 fish."),
            ("You spot 8 fish, then 2 hide inside the coral. How many fish can you still see?", ["5", "6", "7"], "6", "8 − 2 = 6 fish."),
            ("2 hammerheads and 3 reef sharks pass your window. How many sharks in all?", ["4", "5", "6"], "5", "2 + 3 = 5 sharks."),
            ("Finn counts 5 bubbles, then 4 more float up from the cave. How many bubbles now?", ["8", "9", "10"], "9", "5 + 4 = 9 bubbles.")
        ],
        additionalQuestions: [
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "What did Finn do right after he noticed bubbles near the dark cave?",
                choices: [
                    "He swam closer to investigate",
                    "He left the reef and went home",
                    "He waited on the beach for help"
                ],
                correctAnswer: "He swam closer to investigate",
                explanation: "After noticing the bubbles, Finn swam closer to look for the missing fish."
            )
        ],
        extraVocab: [
            ("Reef", "a ridge of rock or coral in the sea where many sea animals live", "Colorful fish dart between the reef rocks.", "Finn's whole adventure happens at the reef."),
            ("Predator", "an animal that hunts other animals for food", "Sharks are careful predators in the ocean.", "Finn is a young predator learning about his home.")
        ],
        extraFacts: [
            ("Sharks do not have bones like humans.", "Their skeletons are made of flexible cartilage. That extra bend helps them swim smoothly."),
            ("Some sharks can sense tiny movements in the water.", "Special organs help them find fish even when they cannot see them clearly.")
        ]
    )

    static let sharkRescue = makeLesson(
        title: "Ocean Rescue",
        theme: .sharks, type: .rescue,
        category: .story,
        storyOpening: "Morning light splashed across the rescue boat as Marina spotted something wrong below the waves.",
        missionPrompt: "A baby shark is tangled in trash near the reef. Read the rescue plan and count supplies before diving in!",
        storyEnding: "The little shark swims free into open water. Marina waves from the boat — you saved the day!",
        readingSkill: "Using context clues",
        mathSkill: "Subtraction within 10",
        vocab: "Predator", vocabDef: "an animal that hunts other animals for food",
        fact: "Sharks do not have bones — their skeletons are made of cartilage.",
        creative: "Draw a poster that tells people to keep oceans clean for sharks.",
        creativeResponseType: .drawing,
        reflection: "Which supply number from the rescue plan did you check before diving?",
        reflectionResponseType: .shortText,
        passage: "The rescue boat rocks gently. Marina shows you a map where a young reef shark circles trash, too nervous to swim free. \"Sharks are predators,\" she says, \"but this little one needs our help.\" You read the checklist: cut the net, stay calm, guide it to open water. Your hands are steady.",
        readingQs: [
            ("Why does the shark need help?", ["It is stuck near trash on the reef", "It is hunting far from the reef", "It is resting in deep open water"], "It is stuck near trash on the reef", "The shark circles trash and cannot swim free."),
            ("What are sharks described as?", ["Predators", "Herbivores", "Scavengers"], "Predators", "Marina says sharks are predators."),
            ("What is the first step on the checklist?", ["Cut the net", "Feed the shark first", "Move the boat closer only"], "Cut the net", "The checklist says cut the net first.")
        ],
        mathQs: [
            ("The team brings 9 rescue bands and uses 2. How many rescue bands are left?", ["6", "7", "8"], "7", "9 − 2 = 7 bands."),
            ("5 divers go in. 2 stay on the boat. How many divers are in the water?", ["2", "3", "4"], "3", "5 − 2 = 3 divers."),
            ("You counted 10 soft reef pads and placed 4 under the shark. How many pads remain?", ["5", "6", "7"], "6", "10 − 4 = 6 pads.")
        ]
    )

    static let reefMystery = makeLesson(
        title: "Reef Mystery",
        theme: .sharks, type: .mystery,
        category: .story,
        storyOpening: "Finn the reef shark paused beside a coral tower. Silver fish suddenly changed direction and vanished into the rocks.",
        missionPrompt: "Help Finn gather reef clues and figure out what was approaching from the deeper water!",
        storyEnding: "Finn swims a calm circle. With careful clues and thoughtful thinking, the reef mystery makes sense.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Counting on",
        vocab: "Reef", vocabDef: "a ridge of rock or coral in the sea, often home to many animals",
        fact: "Some sharks can sense tiny movements in the water with special organs.",
        creative: "Draw the reef scene as Finn noticed the first clue.",
        creativeResponseType: .drawing,
        reflection: "Which clue helped you the most?",
        reflectionResponseType: .shortText,
        passage: "Finn watched from a sunny coral ledge. First, the little fish pressed together and darted away from deeper water. A dark shape briefly broke the surface, then slipped under again. Whatever was coming moved smoothly and quietly, leaving only a thin trail of bubbles. Finn whispered, \"We need more clues before we decide.\"",
        mathQs: [
            ("You find 2 clues near coral, then 1 more by the sand. How many clues total?", ["2", "3", "4"], "3", "2 + 1 = 3 clues."),
            ("4 fish dart past. 3 more follow. How many fish?", ["6", "7", "8"], "7", "4 + 3 = 7 fish."),
            ("Finn counts 5 silver fish beside the coral. 2 swim into a rocky cave. How many fish remain beside the coral?", ["2", "3", "4"], "3", "5 − 2 = 3 fish.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .identity,
                setup: "A marine helper near the reef noticed that some fish suddenly changed direction. What might be nearby?",
                clues: [
                    "The fish stayed close together and moved away from the deeper water.",
                    "A dark fin briefly appeared above the surface.",
                    "The animal had a streamlined body and moved silently through the water."
                ],
                prompt: "Which animal was most likely approaching the reef?",
                choices: ["A reef shark", "A sea turtle", "A manta ray"],
                correctAnswer: "A reef shark",
                explanation: "The reef shark fits best: fish fleeing deeper water, a dark fin at the surface, and a quiet streamlined swim. A turtle’s shell and a ray’s wide wings do not match the fin clue as well."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Which clue best rules out the sea turtle?",
                choices: [
                    "A dark fin briefly appeared above the surface",
                    "The fish stayed close together",
                    "There were bubbles in the water"
                ],
                correctAnswer: "A dark fin briefly appeared above the surface",
                explanation: "Sea turtles do not show a tall dark fin above the water the way a shark can. That clue narrows the choices."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Why did Finn wait for more than one clue?",
                choices: [
                    "One clue alone can fit more than one animal",
                    "Clues are only for counting fish",
                    "The reef has no animals at all"
                ],
                correctAnswer: "One clue alone can fit more than one animal",
                explanation: "Early clues leave a few possibilities. Later clues help you choose carefully."
            ),
            .mystery(
                kind: .number,
                setup: "Finn is thinking of how many silver fish hid behind the coral.",
                clues: [
                    "The number is greater than 4 but less than 8.",
                    "When you subtract 2, the answer is 5.",
                    "The number is odd, not even."
                ],
                prompt: "What number is Finn thinking of?",
                choices: ["7", "6", "5"],
                correctAnswer: "7",
                explanation: "Only 7 is between 4 and 8 and gives 5 when you subtract 2. 6 − 2 = 4, and 5 − 2 = 3."
            )
        ]
    )

    // MARK: - Horses

    static let stableBuilder = makeLesson(
        title: "Stable Builder",
        theme: .horses, type: .builder,
        category: .math,
        storyOpening: "Sweet hay dust floated in sunbeams as Sunny the horse nudged your shoulder in the barn.",
        missionPrompt: "Sunny needs a new stall with room for hay, water, and a window. Grab your blueprint — you're the builder today!",
        storyEnding: "Sunny's new stall is ready. She flicks her tail happily — your design made her feel right at home.",
        readingSkill: "Following directions",
        mathSkill: "Addition within 10",
        vocab: "Stable", vocabDef: "a building where horses live and sleep",
        fact: "Horses use their ears, eyes, and body language to communicate.",
        creative: "Create a new obstacle course for a horse. What does the horse jump over?",
        creativeResponseType: .longText,
        reflection: "What part of your stable design are you most proud of?",
        reflectionResponseType: .shortText,
        passage: "In the barn, wood smells sweet and hay dust floats in sunbeams. Sunny nudges your shoulder as you sketch a stall: a wide door, a window for fresh air, and hooks for a brush. Horses talk with their ears. Sunny's ears point forward, and that means she is curious about your plan.",
        readingQs: [
            ("What are you building?", ["A horse stall in a stable", "A riding arena fence", "A hay storage loft"], "A horse stall in a stable", "You sketch a stall in the barn."),
            ("How do horses communicate?", ["With ears, eyes, and body language", "With loud whinnies only", "By stomping in a pattern"], "With ears, eyes, and body language", "The passage explains horse communication."),
            ("What does Sunny's forward ears mean?", ["She is curious", "She is frightened", "She is angry"], "She is curious", "Forward ears show curiosity.")
        ],
        mathQs: [
            ("You nail 4 boards, then 3 more. How many boards total?", ["6", "7", "8"], "7", "4 + 3 = 7 boards."),
            ("6 bales of hay are stacked. You use 1. How many bales remain?", ["4", "5", "6"], "5", "6 − 1 = 5 bales."),
            ("2 windows plus 2 doors — how many openings?", ["3", "4", "5"], "4", "2 + 2 = 4 openings.")
        ]
    )

    static let ponyCare = makeLesson(
        title: "Pony Care",
        theme: .horses, type: .animalExpert,
        category: .discovery,
        storyOpening: "Three ponies swish their tails in the sunny yard while curious visitors gather at the gate.",
        missionPrompt: "You're the pony expert today — teach the kids how to care for horses safely!",
        storyEnding: "The visitors leave smiling, and the ponies nuzzle your hand. You taught them well!",
        readingSkill: "Learning from nonfiction",
        mathSkill: "Word problems",
        vocab: "Foal", vocabDef: "a young horse",
        fact: "A horse can sleep standing up because of special leg locks.",
        creative: "Draw a pony care checklist with pictures.",
        creativeResponseType: .drawing,
        reflection: "What pony care tip will you remember?",
        reflectionResponseType: .shortText,
        passage: "Three ponies flick their tails in the yard. You show the visitors how to stand sideways, speak softly, and never walk behind a horse. A foal prances near its mother. \"Horses can nap standing up,\" you explain, \"their legs lock like gentle brakes.\" The kids listen with wide eyes.",
        readingQs: [
            ("Where are the ponies?", ["In the yard", "On a racing track", "In a pasture"], "In the yard", "The story is set in the pony yard."),
            ("What is a foal?", ["A young horse", "An adult horse", "A baby goat"], "A young horse", "A foal is a young horse."),
            ("How should visitors speak near horses?", ["Softly", "Very loudly", "Only by shouting"], "Softly", "You teach visitors to speak softly."),
            ("How can horses nap?", ["Standing up with leg locks", "Only while lying down", "Only while galloping"], "Standing up with leg locks", "Horses lock their legs to rest standing.")
        ],
        mathQs: [
            ("3 ponies eat 2 apples each. How many apples do they need?", ["5", "6", "7"], "6", "3 × 2 = 6 apples (or 3 + 3 = 6)."),
            ("You brush 5 horses and 1 more arrives. How many horses now?", ["5", "6", "7"], "6", "5 + 1 = 6 horses."),
            ("10 carrots are shared among 2 ponies equally. Each gets how many?", ["4", "5", "6"], "5", "10 ÷ 2 = 5 carrots each.")
        ]
    )

    static let horseRaceMath = makeLesson(
        title: "Horse Race Math",
        theme: .horses, type: .explorer,
        category: .math,
        storyOpening: "Flags snapped in the breeze above the meadow as five horses lined up at the starting gate.",
        missionPrompt: "The meadow race is about to begin! Read the program, count the horses, and cheer them on!",
        storyEnding: "The crowd roars as the horses gallop past. What an exciting race you helped count!",
        readingSkill: "Reading for details",
        mathSkill: "Addition within 10",
        vocab: "Gallop", vocabDef: "to run fast, the way horses move",
        fact: "Horses have the biggest eyes of any land mammal.",
        creative: "Invent a horse race with fun team names.",
        creativeResponseType: .longText,
        reflection: "How many horses lined up at the starting gate?",
        reflectionResponseType: .shortText,
        passage: "Flags snap in the breeze above the meadow track. Five horses line up — chestnut, paint, black, palomino, and gray. Their big eyes watch the gate. When the bell rings, hooves gallop in a thunder of dust. The crowd cheers as the paint horse pulls ahead at the first bend.",
        readingQs: [
            ("How many horses line up?", ["Five", "Three", "Four"], "Five", "Five horses are named at the start."),
            ("What happens when the bell rings?", ["The horses gallop", "The horses walk slowly", "The horses turn back to the barn"], "The horses gallop", "Hooves gallop when the bell rings."),
            ("Which horse leads at the first bend?", ["The paint horse", "The gray horse", "The chestnut horse"], "The paint horse", "The paint horse pulls ahead.")
        ],
        mathQs: [
            ("5 horses race and 2 finish last. How many are ahead of them?", ["2", "3", "4"], "3", "5 − 2 = 3 horses ahead."),
            ("Round 1 has 4 horses. Round 2 adds 3 more. Total horses?", ["6", "7", "8"], "7", "4 + 3 = 7 horses."),
            ("You count 6 hoof prints, then 2 more appear. How many prints?", ["7", "8", "9"], "8", "6 + 2 = 8 prints.")
        ]
    )

    // MARK: - Space

    static let rocketMission = makeLesson(
        title: "Rocket Mission",
        theme: .space, type: .spaceMission,
        category: .discovery,
        storyOpening: "Red lights blinked across mission control as steam rose from the rocket on the launch pad.",
        missionPrompt: "A supply rocket must reach the space station by sunset. You're on the crew — let's go!",
        storyEnding: "The rocket lifts off into the stars. Mission control cheers — you helped launch the mission!",
        readingSkill: "Reading for details",
        mathSkill: "Addition within 10",
        vocab: "Orbit", vocabDef: "the path something takes moving around another object in space",
        fact: "Planets move around the sun in paths called orbits.",
        creative: "Draw a rocket for a mission to Mars.",
        creativeResponseType: .drawing,
        reflection: "What would you pack for a space mission?",
        reflectionResponseType: .shortText,
        passage: "Headsets crackle in mission control. Your rocket sits on the pad, packed with food, tools, and books for the astronauts. Earth maps show a curved path — an orbit — that the space station follows. \"T-minus ten,\" says the captain. Steam hisses. Stars wait above the clouds.",
        readingQs: [
            ("What is the rocket carrying?", ["Food, tools, and books", "Only spare helmets", "Only empty crates"], "Food, tools, and books", "The rocket is packed with supplies."),
            ("What is an orbit?", ["A path around another object in space", "A straight line away from Earth", "A tunnel through a planet"], "A path around another object in space", "Orbits are paths in space."),
            ("Who says \"T-minus ten\"?", ["The captain", "The supply clerk", "The ground crew chef"], "The captain", "The captain counts down.")
        ],
        mathQs: [
            ("The rocket carries 6 food packs and 3 tool kits. How many items?", ["8", "9", "10"], "9", "6 + 3 = 9 items."),
            ("Mission control has 8 screens. 2 turn off. How many stay on?", ["5", "6", "7"], "6", "8 − 2 = 6 screens."),
            ("4 astronauts wave, then 2 more board. How many astronauts?", ["5", "6", "7"], "6", "4 + 2 = 6 astronauts.")
        ]
    )

    static let planetExplorer = makeLesson(
        title: "Planet Explorer",
        theme: .space, type: .explorer,
        category: .discovery,
        storyOpening: "Nova the Star twinkled above the classroom telescope as Jupiter's stripes glowed on the screen.",
        missionPrompt: "Today you explore planets! Read carefully and discover the wonders of our solar system.",
        storyEnding: "You've traveled across the solar system without leaving your seat. Nova is proud of you!",
        readingSkill: "Finding main ideas",
        mathSkill: "Counting on",
        vocab: "Galaxy", vocabDef: "a huge group of stars in space",
        fact: "The sun is a star — it is the closest star to Earth.",
        creative: "Imagine you found a new planet. What color is it? Who lives there?",
        creativeResponseType: .longText,
        reflection: "Which planet would you visit first?",
        reflectionResponseType: .shortText,
        passage: "You click through planet photos on the big screen. Mars looks rusty red. Jupiter swirls with storms bigger than Earth. Saturn wears icy rings like a hula hoop. Our solar system lives in the Milky Way galaxy — a sea of stars so wide it would take years to cross.",
        readingQs: [
            ("What color does Mars look?", ["Rusty red", "Icy blue", "Cloudy white"], "Rusty red", "Mars looks rusty red."),
            ("Which planet has icy rings?", ["Saturn", "Mars", "The sun"], "Saturn", "Saturn wears icy rings."),
            ("Where is our solar system?", ["In the Milky Way galaxy", "In a nearby asteroid belt only", "Beside a single lonely star"], "In the Milky Way galaxy", "We live in the Milky Way galaxy.")
        ],
        mathQs: [
            ("You view 3 planets before lunch and 2 after. How many planets today?", ["4", "5", "6"], "5", "3 + 2 = 5 planets."),
            ("8 moons orbit a planet. 1 moon hides behind it. How many visible?", ["6", "7", "8"], "7", "8 − 1 = 7 moons."),
            ("2 rocky planets and 4 gas giants — how many planets?", ["5", "6", "7"], "6", "2 + 4 = 6 planets.")
        ]
    )

    static let moonMystery = makeLesson(
        title: "Moon Mystery",
        theme: .space, type: .mystery,
        category: .story,
        storyOpening: "Boot prints dotted the gray moon dust outside the base, sharp and clear in the silent air.",
        missionPrompt: "The astronauts left puzzling notes. Use each observation to explain what is happening on the moon!",
        storyEnding: "You connect the moon observations like a scientist. The quiet base makes sense at last.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Subtraction within 10",
        vocab: "Gravity", vocabDef: "the force that pulls things toward each other",
        fact: "There is no air in space, so astronauts wear special suits.",
        creative: "Draw the moon base log with your own discovery.",
        creativeResponseType: .drawing,
        reflection: "Which clue changed your first guess?",
        reflectionResponseType: .shortText,
        passage: "Outside the moon base, Nova studies fresh boot prints. They look sharp along the edges. Nearby, an astronaut bounces in slow arcs across the dust. Another crewmate checks a sealed suit before stepping into the open. Nova writes each observation carefully — the answer should come from evidence, not one quick guess.",
        mathQs: [
            ("6 moon rocks collected. 2 go to the lab. How many stay in the bin?", ["3", "4", "5"], "4", "6 − 2 = 4 rocks."),
            ("The crew plants 5 flags and finds 3 more packed away. Total flags?", ["7", "8", "9"], "8", "5 + 3 = 8 flags."),
            ("10 supply boxes arrive. 4 are opened. How many are still closed?", ["5", "6", "7"], "6", "10 − 4 = 6 boxes.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .science,
                setup: "Nova finds sharp boot prints outside the moon base and wonders why they stay so clear.",
                clues: [
                    "The dust around the prints looks undisturbed for a long time.",
                    "No breezes move a flag hanging near the airlock.",
                    "There are no clouds, raindrops, or swirling dust trails anywhere outside."
                ],
                prompt: "Why do the boot prints stay sharp?",
                choices: [
                    "There is no wind on the moon",
                    "Soft moon dust blows them away later",
                    "Rain washes the prints each day"
                ],
                correctAnswer: "There is no wind on the moon",
                explanation: "The clues show no breeze, no rain, and dust that stays put — so wind is not smoothing the prints."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "An astronaut bounces in slow arcs. What best explains that?",
                choices: [
                    "Gravity is weaker on the moon",
                    "Gravity is stronger on the moon",
                    "Their boots are filled with air only"
                ],
                correctAnswer: "Gravity is weaker on the moon",
                explanation: "Weaker gravity makes big, slow bounces easier."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Why are suits sealed tightly before going outside?",
                choices: [
                    "There is no air outside",
                    "To keep moon dust out only",
                    "To help them hear better"
                ],
                correctAnswer: "There is no air outside",
                explanation: "Sealed suits protect astronauts where there is no breathable air."
            )
        ]
    )

    // MARK: - Dinosaurs

    static let fossilDetective = makeLesson(
        title: "Fossil Detective",
        theme: .dinosaurs, type: .detective,
        category: .discovery,
        storyOpening: "Dust rose brush by brush as Dr. Dottie uncovered a curved shape in the rocky dig site.",
        missionPrompt: "Read the field notes like a detective and discover what ancient secret hides in the rock!",
        storyEnding: "You found it — a fossil time capsule from millions of years ago. Dottie high-fives you!",
        readingSkill: "Close reading",
        mathSkill: "Addition within 10",
        vocab: "Fossil", vocabDef: "remains of a plant or animal from long ago, preserved in rock",
        fact: "Fossils help scientists learn about animals that lived long ago.",
        creative: "Draw a fossil you would love to discover.",
        creativeResponseType: .drawing,
        reflection: "What question would you ask a paleontologist?",
        reflectionResponseType: .shortText,
        passage: "Brush by brush, dust rises from the dig site. A curved fossil looks like a giant rib. Notes say the bones are hard as stone and layered in mud from an ancient river. Fossils are nature's time capsules — they keep secrets from millions of years ago.",
        readingQs: [
            ("What does the curved fossil look like?", ["A giant rib", "A tiny tooth", "A flat footprint"], "A giant rib", "The fossil looks like a rib."),
            ("What are fossils compared to?", ["Nature's time capsules", "Fresh mud puddles", "Fallen leaves"], "Nature's time capsules", "Fossils keep ancient secrets."),
            ("What tool does the dig use?", ["A brush", "A shovel", "A hammer"], "A brush", "Brush by brush, dust rises.")
        ],
        mathQs: [
            ("You uncover 3 bones in the morning and 4 in the afternoon. How many bones?", ["6", "7", "8"], "7", "3 + 4 = 7 bones."),
            ("9 tools are in a box. 2 are brushes. How many are not brushes?", ["6", "7", "8"], "7", "9 − 2 = 7 tools."),
            ("2 small fossils and 5 big fossils — how many total?", ["6", "7", "8"], "7", "2 + 5 = 7 fossils.")
        ]
    )

    static let dinoRescue = makeLesson(
        title: "Dino Rescue",
        theme: .dinosaurs, type: .rescue,
        category: .story,
        storyOpening: "A triceratops statue waited on a cart in the museum workshop with an empty horn slot.",
        missionPrompt: "The triceratops lost a horn! Read the repair guide and help the dino look proud again.",
        storyEnding: "The triceratops stands tall with a brand-new horn. Dottie the Dino cheers for you!",
        readingSkill: "Using context clues",
        mathSkill: "Subtraction within 10",
        vocab: "Herbivore", vocabDef: "an animal that eats plants",
        fact: "Some dinosaurs had feathers, not just scales.",
        creative: "Invent a plant-eating dinosaur and name it.",
        creativeResponseType: .longText,
        reflection: "Which repair step put the triceratops horn back in place?",
        reflectionResponseType: .shortText,
        passage: "In the museum workshop, the triceratops statue waits on a cart. A sign reads: \"Herbivore — eats ferns, not meat.\" The missing horn slot is empty. You mix plaster, match the color, and attach a new horn gently. Feathers might have topped some real dinos, but this friend needs sturdy horns.",
        readingQs: [
            ("What kind of dinosaur is the statue?", ["A herbivore", "A carnivore", "A scavenger"], "A herbivore", "The sign says herbivore."),
            ("What does a herbivore eat?", ["Plants like ferns", "Only meat", "Only eggs"], "Plants like ferns", "Herbivores eat plants."),
            ("What was missing from the statue?", ["A horn", "A tail spike", "A claw"], "A horn", "The missing horn slot was empty.")
        ],
        mathQs: [
            ("You mix 7 cups of plaster and use 3. How many cups remain?", ["3", "4", "5"], "4", "7 − 3 = 4 cups."),
            ("5 workers help. 2 go to lunch. How many still working?", ["2", "3", "4"], "3", "5 − 2 = 3 workers."),
            ("The dino had 3 horns. 1 was broken. How many good horns before repair?", ["1", "2", "3"], "2", "3 − 1 = 2 good horns.")
        ]
    )

    static let volcanoValley = makeLesson(
        title: "Dino Valley Explorer",
        theme: .dinosaurs, type: .explorer,
        category: .discovery,
        storyOpening: "Fern trees brushed your jeep as your time-travel team rolled into a misty dinosaur valley.",
        missionPrompt: "Explore the dinosaur valley carefully and learn what this ancient place holds!",
        storyEnding: "You traveled through time and back, carrying amazing dinosaur discoveries in your mind.",
        readingSkill: "Finding main ideas",
        mathSkill: "Word problems",
        vocab: "Extinct", vocabDef: "no longer living anywhere on Earth",
        fact: "Birds are related to dinosaurs that lived millions of years ago.",
        creative: "Invent a dinosaur no one has discovered yet. What does it eat? What is its name?",
        creativeResponseType: .longText,
        reflection: "What was the valley like in your imagination?",
        reflectionResponseType: .shortText,
        passage: "Mist rises between fern trees as a long-neck dinosaur munches leaves. Your guide whispers that real dinosaurs are extinct, but birds are their distant cousins. A small feathered dino hops across a stream, glittering in the morning light. Footprints in the mud show where herds walked together.",
        readingQs: [
            ("What does the long-neck dinosaur eat?", ["Leaves", "Fish", "Eggs from other nests"], "Leaves", "It munches leaves."),
            ("Are dinosaurs still alive today?", ["No — they are extinct", "Yes — they still roam every valley", "Only baby dinosaurs remain"], "No — they are extinct", "Dinosaurs are extinct."),
            ("What modern animals are related to dinosaurs?", ["Birds", "Frogs", "Horses"], "Birds", "Birds are dinosaur cousins.")
        ],
        mathQs: [
            ("You spot 4 dinos on the left and 3 on the right. How many dinos?", ["6", "7", "8"], "7", "4 + 3 = 7 dinos."),
            ("6 ferns eaten. 2 more ferns added to the pile. Total ferns?", ["7", "8", "9"], "8", "6 + 2 = 8 ferns."),
            ("10 footprints and you circle 3. How many not circled?", ["6", "7", "8"], "7", "10 − 3 = 7 footprints.")
        ]
    )

    // MARK: - Soccer

    static let stadiumMath = makeLesson(
        title: "Stadium Math",
        theme: .soccer, type: .builder,
        category: .math,
        storyOpening: "Orange cones dotted the field behind the school as you unrolled your stadium blueprint.",
        missionPrompt: "Design a mini stadium for practice games. Count seats, goals, and cones!",
        storyEnding: "Your mini stadium is ready for kickoff. The team can't wait to play on your field!",
        readingSkill: "Following directions",
        mathSkill: "Addition within 10",
        vocab: "Strategy", vocabDef: "a plan to help your team play well",
        fact: "Soccer is played by more people worldwide than any other sport.",
        creative: "Create a soccer team mascot.",
        creativeResponseType: .longText,
        reflection: "What strategy would you use in a game?",
        reflectionResponseType: .shortText,
        passage: "Orange cones mark a field behind the school. You tape a stadium plan to a clipboard: two goals, four rows of seats, and a snack table. Coach says good teams use strategy — passing to open teammates instead of chasing the ball alone. The whistle blows and practice begins.",
        readingQs: [
            ("What marks the field?", ["Orange cones", "Blue goal nets", "Yellow practice jerseys"], "Orange cones", "Orange cones mark the field."),
            ("What does strategy mean for teams?", ["Having a smart plan", "Chasing the ball alone", "Never passing to teammates"], "Having a smart plan", "Strategy is a plan to play well."),
            ("How many goals are on the plan?", ["Two", "Four", "One"], "Two", "The plan has two goals.")
        ],
        mathQs: [
            ("Each row has 3 seats and there are 3 rows. How many seats?", ["8", "9", "10"], "9", "3 × 3 = 9 seats."),
            ("5 players pass the ball. 2 more join. How many players?", ["6", "7", "8"], "7", "5 + 2 = 7 players."),
            ("You set 8 cones and pick up 3. How many cones remain?", ["4", "5", "6"], "5", "8 − 3 = 5 cones.")
        ]
    )

    static let teamCaptainReading = makeLesson(
        title: "Team Captain Reading",
        theme: .soccer, type: .detective,
        category: .story,
        storyOpening: "Your captain's armband gleamed as the team gathered around the playbook before the big match.",
        missionPrompt: "You're team captain! Read the playbook carefully and lead your team to victory.",
        storyEnding: "You led with kindness and smarts. Your team is ready for the big match thanks to you!",
        readingSkill: "Close reading",
        mathSkill: "Subtraction within 10",
        vocab: "Pass", vocabDef: "to kick the ball to a teammate",
        fact: "Running during soccer strengthens your heart and lungs.",
        creative: "Design a soccer jersey for your team.",
        creativeResponseType: .drawing,
        reflection: "What does a good captain do?",
        reflectionResponseType: .shortText,
        passage: "The playbook page shows arrows for passes, not solo dribbles. Rule 1: look up. Rule 2: pass to open friends. Rule 3: cheer when teammates try hard. Running lots during games makes hearts strong. You tap your armband — captains read carefully and lead kindly.",
        readingQs: [
            ("What does Rule 1 say?", ["Look up", "Look only at your feet", "Keep your head down"], "Look up", "Rule 1 is look up."),
            ("What should captains do?", ["Read carefully and lead kindly", "Keep every play secret from the team", "Take every shot alone"], "Read carefully and lead kindly", "Captains lead with care."),
            ("What makes hearts strong?", ["Running during games", "Sitting on the bench all game", "Holding the ball without moving"], "Running during games", "Running strengthens hearts.")
        ],
        mathQs: [
            ("Your team scores 5 goals and the other team scores 2. How many more did you score?", ["2", "3", "4"], "3", "5 − 2 = 3 more goals."),
            ("11 players start. 3 rest on the bench. How many on the field?", ["7", "8", "9"], "8", "11 − 3 = 8 players."),
            ("You practice 9 passes and miss 2. How many good passes?", ["6", "7", "8"], "7", "9 − 2 = 7 good passes.")
        ]
    )

    static let soccerStrategy = makeLesson(
        title: "Soccer Strategy",
        theme: .soccer, type: .builder,
        category: .math,
        storyOpening: "Circles for players covered the whiteboard in strategy lab, arrows showing the perfect play.",
        missionPrompt: "Mix math, reading, and wild ideas to plan the most fun soccer play ever!",
        storyEnding: "Your strategy is a winner! The lab is buzzing with creative soccer ideas you helped build.",
        readingSkill: "Connecting ideas",
        mathSkill: "Counting on",
        vocab: "Defender", vocabDef: "a player who tries to stop the other team from scoring",
        fact: "Team sports help kids learn cooperation and communication.",
        creative: "Invent a fun new soccer rule for beginners.",
        creativeResponseType: .longText,
        reflection: "What play would you draw on the board?",
        reflectionResponseType: .shortText,
        passage: "On the whiteboard you draw circles for players. Defenders stand near the goal like friendly guards. Forwards wait to score. You write a plan: pass, pass, shoot! Teams that talk to each other play smarter. Your lab partner adds star marks for every kind idea.",
        readingQs: [
            ("Where do defenders stand?", ["Near the goal", "Near midfield only", "Beside the snack table"], "Near the goal", "Defenders guard the goal."),
            ("What is the plan on the board?", ["Pass, pass, shoot", "Dribble, dribble, stop", "Defend, defend, wait"], "Pass, pass, shoot", "The plan is pass then shoot."),
            ("What helps teams play smarter?", ["Talking to each other", "Playing in silence", "Watching from the sideline only"], "Talking to each other", "Communication helps teams.")
        ],
        mathQs: [
            ("3 forwards and 4 defenders — how many players drawn?", ["6", "7", "8"], "7", "3 + 4 = 7 players."),
            ("You earn 2 star marks, then 3 more. How many stars?", ["4", "5", "6"], "5", "2 + 3 = 5 stars."),
            ("8 plays are listed. You try 5. How many left to try?", ["2", "3", "4"], "3", "8 − 5 = 3 plays.")
        ]
    )

    // MARK: - Robots

    static let robotRepair = makeLesson(
        title: "Robot Repair",
        theme: .robots, type: .rescue,
        category: .math,
        storyOpening: "Beep's chest panel blinked yellow on the workbench, wheels still and quiet.",
        missionPrompt: "Beep the helper robot stopped moving! Read the repair manual and count the parts.",
        storyEnding: "Beep whirs, beeps happily, and rolls toward you. The robot is alive again thanks to you!",
        readingSkill: "Following directions",
        mathSkill: "Addition within 10",
        vocab: "Battery", vocabDef: "a pack that stores power for robots and toys",
        fact: "Robots use sensors to see, hear, or feel the world around them.",
        creative: "Build a robot helper in your imagination. What problem does it solve?",
        creativeResponseType: .longText,
        reflection: "What tool helped you fix Beep?",
        reflectionResponseType: .shortText,
        passage: "Beep's chest panel blinks yellow. Step one: turn off power. Step two: swap the battery. Step three: test sensors — eyes that see light, wheels that feel bumps. You slide a fresh battery in. Beep whirs, beeps happily, and rolls toward you.",
        readingQs: [
            ("What color is Beep's warning blink?", ["Yellow", "Green", "Blue"], "Yellow", "The panel blinks yellow."),
            ("What is step two?", ["Swap the battery", "Tighten the wheels first", "Rewrite the whole program"], "Swap the battery", "Step two is swap the battery."),
            ("What do sensors help robots do?", ["Sense the world around them", "Store extra spare parts", "Charge other robots only"], "Sense the world around them", "Sensors help robots sense.")
        ],
        mathQs: [
            ("Beep needs 4 screws. You find 3 in the tray. How many more?", ["0", "1", "2"], "1", "4 − 3 = 1 more screw."),
            ("You test 2 sensors, then 3 more. How many sensors tested?", ["4", "5", "6"], "5", "2 + 3 = 5 sensors."),
            ("6 batteries on the shelf. 2 are used. How many fresh batteries?", ["3", "4", "5"], "4", "6 − 2 = 4 batteries.")
        ]
    )

    static let codingLab = makeLesson(
        title: "Coding Lab",
        theme: .robots, type: .explorer,
        category: .creative,
        storyOpening: "Music played softly as you opened your coding notebook in the robot lab.",
        missionPrompt: "Write steps for a robot dance. Each line is an instruction — let's make Beep boogie!",
        storyEnding: "You press RUN and the robot wiggles. The whole lab claps for your amazing program!",
        readingSkill: "Connecting ideas",
        mathSkill: "Number patterns",
        vocab: "Program", vocabDef: "a list of steps that tells a robot or computer what to do",
        fact: "Engineers write programs that tell robots what to do step by step.",
        creative: "Write three dance steps for your robot.",
        creativeResponseType: .shortText,
        reflection: "What was your favorite dance move?",
        reflectionResponseType: .shortText,
        passage: "Line 1: lift left arm. Line 2: spin once. Line 3: beep a song. That program makes your robot boogie! Engineers build programs the same way — one clear step at a time. You press RUN and the robot wiggles while classmates clap.",
        readingQs: [
            ("What does Line 2 tell the robot?", ["Spin once", "Lift the right arm", "Beep a song"], "Spin once", "Line 2 says spin once."),
            ("What is a program?", ["A list of steps for a robot", "A drawing of the robot", "A spare battery pack"], "A list of steps for a robot", "Programs are step lists."),
            ("What happens when you press RUN?", ["The robot wiggles", "The robot powers down", "The robot rolls backward only"], "The robot wiggles", "The robot dances when RUN is pressed.")
        ],
        mathQs: [
            ("Your program has 5 lines. You add 2 more. How many lines?", ["6", "7", "8"], "7", "5 + 2 = 7 lines."),
            ("The robot spins 3 times, then 2 more. Total spins?", ["4", "5", "6"], "5", "3 + 2 = 5 spins."),
            ("9 dance moves planned. 4 are done. How many left?", ["4", "5", "6"], "5", "9 − 4 = 5 moves.")
        ]
    )

    static let futureCity = makeLesson(
        title: "Future City",
        theme: .robots, type: .builder,
        category: .creative,
        storyOpening: "Cardboard boxes and colorful tape covered the table as city plans spread open.",
        missionPrompt: "Build a future city where robots and people share the streets. Count blocks and plan roads!",
        storyEnding: "Your future city glows with life — robot helpers and people working together on every street.",
        readingSkill: "Following directions",
        mathSkill: "Addition within 10",
        vocab: "Engineer", vocabDef: "a person who designs and builds machines or cities",
        fact: "Some robots explore places too dangerous for humans, like deep oceans.",
        creative: "Draw a future city with robot helpers.",
        creativeResponseType: .drawing,
        reflection: "What would your city look like?",
        reflectionResponseType: .shortText,
        passage: "Cardboard boxes become towers. A robot crossing guard beeps gently at tiny cars. Engineers draw bridges that lift for boats. You add a park where robot gardeners plant real flowers. Deep-sea robots might explore oceans, but your city robots help people cross streets safely.",
        readingQs: [
            ("What does the robot crossing guard do?", ["Helps people cross safely", "Waters the park flowers", "Builds cardboard towers"], "Helps people cross safely", "The guard helps people cross."),
            ("Who draws bridges?", ["Engineers", "Crossing guards", "Garden robots"], "Engineers", "Engineers design bridges."),
            ("Where might other robots explore?", ["Deep oceans", "Busy city sidewalks", "Quiet classroom shelves"], "Deep oceans", "Deep-sea robots explore oceans.")
        ],
        mathQs: [
            ("You stack 3 boxes, then 4 more for towers. How many boxes?", ["6", "7", "8"], "7", "3 + 4 = 7 boxes."),
            ("5 robot helpers and 3 human helpers — total helpers?", ["7", "8", "9"], "8", "5 + 3 = 8 helpers."),
            ("10 road pieces and you use 6. How many pieces left?", ["3", "4", "5"], "4", "10 − 6 = 4 pieces.")
        ]
    )

    // MARK: - Dogs & Cats

    static let dogParkDetective = makeLesson(
        title: "Dog Park Detective",
        theme: .dogs, type: .detective,
        category: .story,
        storyOpening: "A lonely leash dangled from the park gate, fluttering in the afternoon breeze.",
        missionPrompt: "Someone left a leash at the park gate. Gather witness notes and decide which dog it belongs to!",
        storyEnding: "A happy dog trots back to its person. Your careful clue work reunited them.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Subtraction within 10",
        vocab: "Companion", vocabDef: "a friend who stays by your side",
        fact: "Dogs can learn over 100 words and gestures.",
        creative: "Draw your dream dog with a superpower.",
        creativeResponseType: .drawing,
        reflection: "Did any clue change your first guess?",
        reflectionResponseType: .shortText,
        passage: "At the park gate hangs a forgotten leash. A neighbor says the missing dog loves long ears that flop when it runs. Another notes that fetch happens here every Tuesday after school. A trainer adds that the dog sits the moment someone says the cue word. Three dogs wait nearby — you will need every note before you choose.",
        mathQs: [
            ("7 dogs play. 2 go home. How many dogs remain?", ["4", "5", "6"], "5", "7 − 2 = 5 dogs."),
            ("You throw 6 balls. 4 are caught. How many missed?", ["1", "2", "3"], "2", "6 − 4 = 2 missed."),
            ("3 treats in one hand and 4 in the other. Total treats?", ["6", "7", "8"], "7", "3 + 4 = 7 treats.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .character,
                setup: "A leash was left at the park gate. Which dog most likely belongs with it?",
                clues: [
                    "Witnesses say the dog’s ears flop when it runs.",
                    "The owner always plays fetch here after school on Tuesdays.",
                    "When someone says “sit,” the dog plants its back legs right away."
                ],
                prompt: "Which dog best matches all the evidence?",
                choices: [
                    "A golden retriever waiting by the fetch lawn",
                    "A tiny puppy who has never learned sit",
                    "A dog that only visits on weekend mornings"
                ],
                correctAnswer: "A golden retriever waiting by the fetch lawn",
                explanation: "Floppy ears, Tuesday fetch, and knowing sit all point to the patient retriever by the fetch lawn — a loyal companion."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Which clue rules out the weekend-only visitor?",
                choices: [
                    "Fetch happens every Tuesday after school",
                    "The leash is blue",
                    "The park has a water bowl"
                ],
                correctAnswer: "Fetch happens every Tuesday after school",
                explanation: "A weekend-only visitor would not match the Tuesday fetch note."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "What is a loyal companion?",
                choices: [
                    "A friend who stays by your side",
                    "A toy left at the gate",
                    "A leash without an owner"
                ],
                correctAnswer: "A friend who stays by your side",
                explanation: "Companions are loyal friends who stick with you."
            )
        ]
    )

    static let catClueHunt = makeLesson(
        title: "Cat Clue Hunt",
        theme: .cats, type: .mystery,
        category: .story,
        storyOpening: "A jingle bell went missing, and tiny paw prints led away from the sofa.",
        missionPrompt: "Whiskers the cat hid a toy somewhere in the house. Follow the trail without spoiling the surprise!",
        storyEnding: "You find the quiet sunny spot and reunite Whiskers with her toy. Careful clues made the difference.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Counting on",
        vocab: "Whiskers", vocabDef: "long stiff hairs on a cat's face that help it feel nearby objects",
        fact: "Cats use whiskers to feel spaces in the dark.",
        creative: "Draw a cat with a secret job.",
        creativeResponseType: .drawing,
        reflection: "Which clue ruled out the wrong hiding place?",
        reflectionResponseType: .shortText,
        passage: "Whiskers bats a loose thread near the sofa, then slips away. Later you notice her pause at the bed, back out, and shake her head as if the space feels too tight for her sensitive face hairs. A soft jingle drifts from the bright side of the living room. The toy is still missing — the clues will have to lead you.",
        mathQs: [
            ("3 paw prints in the hall and 2 in the room. Total prints?", ["4", "5", "6"], "5", "3 + 2 = 5 prints."),
            ("You check 4 rooms and find the toy in the 5th. How many empty rooms?", ["3", "4", "5"], "4", "4 rooms had no toy."),
            ("6 bells on a string. 1 jingles loose. How many still attached?", ["4", "5", "6"], "5", "6 − 1 = 5 bells.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .missingObject,
                setup: "Whiskers hid a jingling toy. Where is it most likely waiting?",
                clues: [
                    "A strand of yarn starts by the sofa and trails across the rug.",
                    "The space under the bed is too tight for Whiskers’ face hairs to fit comfortably.",
                    "A soft jingle comes from the bright side of the room near the curtains."
                ],
                prompt: "Where should you look for the toy?",
                choices: [
                    "By the sunny window",
                    "Under the bed",
                    "Inside a closed kitchen cupboard"
                ],
                correctAnswer: "By the sunny window",
                explanation: "The yarn trail, the too-tight bed, and the jingle by the bright curtains all point to the sunny window — not the bed or a closed cupboard."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Which clue rules out under the bed?",
                choices: [
                    "The space feels too tight for Whiskers’ face hairs",
                    "The yarn strand is soft",
                    "The kitchen has a cupboard"
                ],
                correctAnswer: "The space feels too tight for Whiskers’ face hairs",
                explanation: "Cats use whiskers to feel tight spaces. That clue eliminates the bed."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "What do whiskers help a cat do?",
                choices: [
                    "Feel nearby spaces in the dark",
                    "Change the weather",
                    "Open cupboard doors"
                ],
                correctAnswer: "Feel nearby spaces in the dark",
                explanation: "Whiskers help cats sense spaces around them."
            )
        ]
    )

    // MARK: - More Topics

    static let coralCaveExplorer = makeLesson(
        title: "Coral Cave Explorer",
        theme: .oceanAnimals, type: .explorer,
        category: .discovery,
        storyOpening: "Blue light rippled across the coral cave walls as angelfish sparkled like jewels.",
        missionPrompt: "Dive deeper into the cave and discover what ocean animals call this place home!",
        storyEnding: "You explored the coral cave and met amazing ocean neighbors. Willa the Whale is impressed!",
        readingSkill: "Finding main ideas",
        mathSkill: "Addition within 10",
        vocab: "Habitat", vocabDef: "the place where an animal naturally lives",
        fact: "Octopuses have three hearts and blue blood.",
        creative: "Design your own ocean animal. What makes it special?",
        creativeResponseType: .drawing,
        reflection: "Which ocean animal was your favorite?",
        reflectionResponseType: .shortText,
        passage: "Blue light ripples across the coral cave walls. An octopus changes color to match the rocks. Tiny angelfish dart between branches. This reef is their habitat — home, food, and shelter all in one busy underwater neighborhood.",
        readingQs: [
            ("What animals appear in the cave?", ["Octopus and angelfish", "Sea turtles and crabs", "Dolphins and rays"], "Octopus and angelfish", "Octopus and angelfish appear."),
            ("What is a habitat?", ["A natural home for an animal", "A temporary hiding spot only", "A path animals travel once"], "A natural home for an animal", "Habitat means natural home."),
            ("What does the octopus do?", ["Changes color to match rocks", "Swims in a straight line only", "Hides inside a shell"], "Changes color to match rocks", "It camouflages on rocks.")
        ],
        mathQs: [
            ("5 angelfish swim in, then 3 more arrive. How many fish?", ["7", "8", "9"], "8", "5 + 3 = 8 fish."),
            ("You count 9 shells and give 2 to a friend. How many shells left?", ["6", "7", "8"], "7", "9 − 2 = 7 shells."),
            ("2 octopus arms wave, and 6 angelfish pass. Total animals counted?", ["7", "8", "9"], "8", "2 + 6 = 8 (counting together).")
        ]
    )

    static let castleStoryLab = makeLesson(
        title: "Castle Story Lab",
        theme: .princesses, type: .explorer,
        category: .creative,
        storyOpening: "Cool stone walls surrounded the castle library as your story pages waited to be filled.",
        missionPrompt: "Write a story mixing kind heroes and real castle facts. Your adventure begins here!",
        storyEnding: "Your story is written, and the dragon who eats burnt toast makes everyone laugh. Well done!",
        readingSkill: "Connecting ideas",
        mathSkill: "Word problems",
        vocab: "Kingdom", vocabDef: "the land ruled by a king or queen",
        fact: "Real castles were built with thick walls to stay cool in summer and warm in winter.",
        creative: "Write about a kind princess who solves a problem.",
        creativeResponseType: .shortText,
        reflection: "What happened in your story?",
        reflectionResponseType: .shortText,
        passage: "Stone walls keep the library cool while you write. Your hero walks through a kingdom of farms and rivers, helping people repair a bridge. Thick castle walls once protected real families too — warm in winter, cool in summer. You add a dragon who only eats burnt toast for fun.",
        readingQs: [
            ("Where does the hero travel?", ["Through a kingdom", "Through a castle garden", "Across a drawbridge"], "Through a kingdom", "The hero walks through a kingdom."),
            ("Why were castle walls thick?", ["To stay cool in summer and warm in winter", "To hold up colorful flags", "To store treasure maps"], "To stay cool in summer and warm in winter", "Thick walls regulate temperature."),
            ("What does your dragon eat?", ["Burnt toast for fun", "Fresh apples from the farm", "River stones from the moat"], "Burnt toast for fun", "The dragon eats burnt toast.")
        ],
        mathQs: [
            ("The kingdom has 4 villages and 3 castles. How many places?", ["6", "7", "8"], "7", "4 + 3 = 7 places."),
            ("You write 6 pages and add 2 more. Total pages?", ["7", "8", "9"], "8", "6 + 2 = 8 pages."),
            ("10 candles lit. 3 blow out. How many still lit?", ["6", "7", "8"], "7", "10 − 3 = 7 candles.")
        ]
    )

    static let treasureMapMystery = makeLesson(
        title: "Treasure Map Mystery",
        theme: .pirates, type: .mystery,
        category: .story,
        storyOpening: "An old map crackled in your hands, showing twin palms and rocky steps along the shore.",
        missionPrompt: "Use landmark clues in order to decide where the X should be!",
        storyEnding: "You dig at the place every landmark supports. The map mystery rewards careful steps.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Subtraction within 10",
        vocab: "Compass", vocabDef: "a tool that points north to help you find your way",
        fact: "Compasses use Earth's magnetic field to point north.",
        creative: "Draw a treasure map with five landmarks.",
        creativeResponseType: .drawing,
        reflection: "Which landmark clue was most important?",
        reflectionResponseType: .shortText,
        passage: "The cracked map shows three marks along the beach. First, you notice a pair of tall palm trees leaning toward each other. A faded compass rose sits beside them, its needle painted toward the same direction every time. Farther along, rocks form a rough staircase down toward the sand. The map’s final mark is blank — you must decide from the landmarks, not from a spoiled answer.",
        mathQs: [
            ("12 rock steps and you climb 7. How many steps left?", ["4", "5", "6"], "5", "12 − 7 = 5 steps."),
            ("You find 4 coins, then 5 more. Total coins?", ["8", "9", "10"], "9", "4 + 5 = 9 coins."),
            ("10 map pieces taped. 3 fall off. How many still taped?", ["6", "7", "8"], "7", "10 − 3 = 7 pieces.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .location,
                setup: "The map’s X is missing. Where should you dig?",
                clues: [
                    "Start facing the twin palm trees that lean toward each other.",
                    "Your compass keeps pointing north past those palms.",
                    "After twelve rock steps toward the water, the sand flattens into a quiet dig spot."
                ],
                prompt: "Where is the treasure most likely buried?",
                choices: [
                    "Past the twelve rock steps",
                    "Before the twelve rock steps",
                    "On top of the twin palm trees"
                ],
                correctAnswer: "Past the twelve rock steps",
                explanation: "The palms and north heading set the path, and the final clue places the dig spot after the twelve steps — not before them or in the trees."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "What does a compass help you find?",
                choices: ["North", "The nearest island", "The buried treasure"],
                correctAnswer: "North",
                explanation: "Compasses point north to help you find your way."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Which clue rules out digging before the steps?",
                choices: [
                    "The dig spot comes after twelve rock steps",
                    "The palms are tall",
                    "The map paper is old"
                ],
                correctAnswer: "The dig spot comes after twelve rock steps",
                explanation: "If the quiet dig spot is after the steps, digging before them would miss the place."
            )
        ]
    )

    static let courtCounting = makeLesson(
        title: "Court Counting",
        theme: .basketball, type: .builder,
        category: .math,
        storyOpening: "Chalk dust floated in the gym as the empty court waited for practice day.",
        missionPrompt: "Paint lines on the court and count hoops, cones, and players. Let's get ready!",
        storyEnding: "The court is ready for friendly games. Your counting made practice day possible!",
        readingSkill: "Following directions",
        mathSkill: "Addition within 10",
        vocab: "Dribble", vocabDef: "to bounce the ball while moving on the court",
        fact: "A basketball hoop is 10 feet high — about twice as tall as many kids.",
        creative: "Design a basketball team logo.",
        creativeResponseType: .drawing,
        reflection: "How many points would you score?",
        reflectionResponseType: .shortText,
        passage: "Chalk dust floats as you draw the free-throw line. The hoop towers ten feet up — twice as tall as most kids! You dribble slowly, counting each bounce: one, two, three. Coach sets six cones for drills. The court is ready for friendly games.",
        readingQs: [
            ("How high is the hoop?", ["10 feet", "5 feet", "15 feet"], "10 feet", "The hoop is ten feet high."),
            ("What do you draw with?", ["Chalk", "Paint", "Tape"], "Chalk", "Chalk dust floats as you draw."),
            ("What does dribble mean?", ["Bounce the ball while moving", "Throw the ball into the hoop", "Pass the ball without bouncing"], "Bounce the ball while moving", "Dribbling is bouncing while moving.")
        ],
        mathQs: [
            ("You dribble 4 times, then 3 more. Total bounces?", ["6", "7", "8"], "7", "4 + 3 = 7 bounces."),
            ("6 cones set out. 2 knocked over. How many standing?", ["3", "4", "5"], "4", "6 − 2 = 4 cones."),
            ("Team A scores 8 points. Team B scores 5. Combined points?", ["12", "13", "14"], "13", "8 + 5 = 13 points.")
        ]
    )

    // MARK: - Builder Helper

    static func makeLesson(
        title: String,
        theme: Topic,
        type: LessonType,
        category: LessonCategory? = nil,
        storyOpening: String,
        missionPrompt: String,
        storyEnding: String,
        readingSkill: String,
        mathSkill: String,
        vocab: String,
        vocabDef: String,
        fact: String,
        creative: String,
        creativeResponseType: QuestionResponseType,
        reflection: String,
        reflectionResponseType: QuestionResponseType = .shortText,
        passage: String,
        readingQs: [(String, [String], String, String)] = [],
        mathQs: [(String, [String], String, String)],
        additionalQuestions: [LessonQuestion] = [],
        customReadingQuestions: [LessonQuestion]? = nil,
        readingLevel: ReadingLevel = .earlyReader,
        learningGoal: LearningGoal = .allAround,
        gradeTarget: String = "K-2",
        ageTarget: String = "5-8",
        estimatedMinutes: Int? = nil,
        teaser: String? = nil,
        extraVocab: [(String, String, String, String)] = [],
        extraFacts: [(String, String)] = []
    ) -> Lesson {
        let resolvedCategory = category ?? LessonCategory.inferred(from: type, learningGoal: learningGoal)
        var vocabularyWords = [
            VocabularyWord(
                word: vocab,
                definition: vocabDef,
                exampleSentence: "In the story, \(vocab.lowercased()) helps explain what is happening.",
                storyConnection: "This word is part of today's \(theme.rawValue.lowercased()) mission."
            )
        ]
        for entry in extraVocab {
            vocabularyWords.append(
                VocabularyWord(word: entry.0, definition: entry.1, exampleSentence: entry.2, storyConnection: entry.3)
            )
        }
        if vocabularyWords.count < 2 {
            vocabularyWords = Lesson.enrichVocabulary(
                primary: vocabularyWords[0],
                theme: theme,
                passage: passage,
                level: readingLevel
            )
        }

        var knowledgeFacts = [KnowledgeFact(fact: fact)]
        for entry in extraFacts {
            knowledgeFacts.append(KnowledgeFact(fact: entry.0, explanation: entry.1))
        }

        var readingQuestions = customReadingQuestions ?? readingQs.map {
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: $0.0,
                choices: $0.1,
                correctAnswer: $0.2,
                explanation: $0.3,
                difficultyLevel: readingLevel
            )
        }

        // Math-primary lessons keep story context light so scored work stays mostly math.
        if resolvedCategory == .math {
            readingQuestions = Array(readingQuestions.prefix(1))
            if !additionalQuestions.isEmpty {
                readingQuestions.append(contentsOf: additionalQuestions.filter { !QuestionQualityValidator.isUnsupportedArranging($0) })
            }
        } else {
            var extras = additionalQuestions.filter { !QuestionQualityValidator.isUnsupportedArranging($0) }
            // Drop matching that is not grounded in this lesson's passage.
            extras = extras.filter { question in
                guard question.responseType == .matching || question.displayResponseType == .matching else {
                    return true
                }
                return PassageMatchingQuestionGenerator.pairsArePassageGrounded(question.pairs, passage: passage)
            }
            let hasGroundedMatching = extras.contains {
                $0.responseType == .matching || $0.displayResponseType == .matching
            }
            if !hasGroundedMatching {
                extras.append(contentsOf: ThemeInteractionQuestions.forPassage(
                    passage,
                    topic: theme,
                    vocabulary: vocabularyWords,
                    knowledgeFacts: knowledgeFacts
                ))
            }
            readingQuestions.append(contentsOf: extras)
        }

        let mathQuestions = mathQs.map {
            LessonQuestion(
                subject: .math,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: $0.0,
                choices: $0.1,
                correctAnswer: $0.2,
                explanation: $0.3,
                difficultyLevel: readingLevel
            )
        }

        return Lesson(
            title: title,
            theme: theme,
            lessonType: type,
            category: resolvedCategory,
            primarySubject: PrimarySubject.from(category: resolvedCategory),
            storyOpening: storyOpening,
            missionPrompt: missionPrompt,
            readingPassage: passage,
            questions: readingQuestions,
            mathChallenges: mathQuestions,
            vocabularyWords: vocabularyWords,
            knowledgeFacts: knowledgeFacts,
            creativePrompt: creative,
            creativeResponseType: creativeResponseType,
            storyEnding: storyEnding,
            ageTarget: ageTarget,
            gradeTarget: gradeTarget,
            readingLevel: readingLevel,
            learningGoal: learningGoal,
            estimatedMinutes: estimatedMinutes,
            teaser: teaser ?? missionPrompt,
            readingSkill: readingSkill,
            mathSkill: mathSkill,
            reflectionPrompt: reflection,
            reflectionResponseType: reflectionResponseType,
            skillsPracticed: resolvedCategory.focusSkills
        )
    }
}
