import Foundation

/// Additional hand-crafted lessons covering topics not yet in the core bundled set.
enum BundledLessonsExtended {
    static let all: [Lesson] = [
        ringExplorer, countdownBuilder, canopyClassroom, lavaFieldDiscovery,
        stormClueHunter, barnyardRescue, zookeeperDay, gardenBugMystery,
        forestTrailWalk, colorMixLab, rhythmWorkshop, cityHelperMission,
        skyHighExplorer, stationBuilder, secretPassage, gladeMystery,
        garageMysteryShift, bakeSaleCountdown
    ]

    // MARK: - Planets & Rockets

    static let ringExplorer = BundledLessons.makeLesson(
        title: "Saturn's Ring Explorer",
        theme: .planets, type: .spaceMission,
        category: .discovery,
        storyOpening: "Nova the Star blinked beside the classroom screen as icy glitter swirled around a golden planet with wide, shimmering rings.",
        missionPrompt: "Mission control needs you to study Saturn's rings and count the supplies before the probe launches!",
        storyEnding: "The probe sails through the rings and sends back sparkling data. Nova twinkles proudly — mission accomplished!",
        readingSkill: "Reading for details",
        mathSkill: "Addition within 10",
        vocab: "Ring", vocabDef: "a circle of ice and rock that travels around a planet",
        fact: "Saturn's rings are made of ice and rock pieces, some as small as grains of sand.",
        creative: "Invent a new moon for Saturn and draw what it looks like.",
        creativeResponseType: .longText,
        reflection: "Which planet would you visit after Saturn?",
        reflectionResponseType: .shortText,
        passage: "On the big screen, Saturn glows like a golden marble wrapped in icy ribbons. A mission voice explains that the rings are not one solid hoop — they are billions of icy chunks orbiting together. Your job is to read the supply list: 5 sensor pods, 3 solar panels, and 2 antenna dishes. The countdown clock ticks softly while stars drift past the window.",
        readingQs: [
            ("What planet is on the screen?", ["Saturn", "Mars", "Jupiter"], "Saturn", "Saturn glows on the big screen."),
            ("What are Saturn's rings made of?", ["Ice and rock pieces", "Thick clouds of gas", "Solid metal rings"], "Ice and rock pieces", "The rings are icy chunks orbiting together."),
            ("How many sensor pods are on the list?", ["3", "5", "8"], "5", "The list includes 5 sensor pods.")
        ],
        mathQs: [
            ("The probe carries 5 sensor pods and 3 solar panels. How many parts altogether?", ["7", "8", "9"], "8", "5 + 3 = 8 parts."),
            ("8 ring samples are collected. 2 are stored for later. How many are studied now?", ["5", "6", "7"], "6", "8 − 2 = 6 samples."),
            ("4 icy chunks and 4 rocky chunks float by. How many chunks total?", ["7", "8", "9"], "8", "4 + 4 = 8 chunks.")
        ]
    )

    static let countdownBuilder = BundledLessons.makeLesson(
        title: "Rocket Countdown Builder",
        theme: .rockets, type: .builder,
        category: .math,
        storyOpening: "Steam curled off the launch pad as engineers in orange suits checked bolts and fuel lines one last time.",
        missionPrompt: "Help the crew finish the rocket before countdown reaches zero — every part must be counted and placed!",
        storyEnding: "T-minus zero! The rocket roars upward in a pillar of fire. Your careful building made the launch possible.",
        readingSkill: "Following directions",
        mathSkill: "Subtraction within 10",
        vocab: "Thrust", vocabDef: "the push that moves a rocket forward and upward",
        fact: "Rockets need thrust to push against gravity and lift off the ground.",
        creative: "Design a rocket with three special features and name each one.",
        creativeResponseType: .drawing,
        reflection: "What part of building the rocket was hardest?",
        reflectionResponseType: .shortText,
        passage: "Blueprints spread across a metal table. Step one: attach four fins for steady flight. Step two: fill two fuel tanks. Step three: lock the capsule door. Engineers explain that thrust — a powerful push — must beat gravity at liftoff. You tighten the last bolt as the loudspeaker crackles: \"T-minus ten... nine...\"",
        readingQs: [
            ("What is step one on the blueprint?", ["Attach four fins", "Fill the fuel tanks first", "Test the landing legs"], "Attach four fins", "Step one is attach four fins."),
            ("What is thrust?", ["A powerful push that moves the rocket", "A gentle pull toward Earth", "A soft glow from the stars"], "A powerful push that moves the rocket", "Thrust pushes the rocket upward."),
            ("What happens at liftoff?", ["The rocket must beat gravity", "The rocket must float sideways", "The rocket must wait for night"], "The rocket must beat gravity", "Thrust must beat gravity at liftoff.")
        ],
        mathQs: [
            ("You attach 4 fins, then 2 more on a test rocket. How many fins total?", ["5", "6", "7"], "6", "4 + 2 = 6 fins."),
            ("10 bolts are ready. 3 are used. How many bolts remain?", ["6", "7", "8"], "7", "10 − 3 = 7 bolts."),
            ("The crew fills 6 fuel canisters and uses 2. How many are still full?", ["3", "4", "5"], "4", "6 − 2 = 4 canisters.")
        ]
    )

    // MARK: - Jungle & Nature

    static let canopyClassroom = BundledLessons.makeLesson(
        title: "Canopy Classroom",
        theme: .jungleAnimals, type: .animalExpert,
        category: .discovery,
        storyOpening: "Green light filtered through the rainforest canopy as curious visitors climbed the wooden lookout steps.",
        missionPrompt: "You're the jungle expert today! Teach the group about the animals living high in the trees.",
        storyEnding: "Everyone leaves knowing three new jungle facts. The toucans call goodbye from the branches above.",
        readingSkill: "Learning from nonfiction",
        mathSkill: "Word problems",
        vocab: "Canopy", vocabDef: "the top layer of branches in a forest where many animals live",
        fact: "Toucans use their big beaks to reach fruit on thin branches.",
        creative: "Draw a jungle treehouse for three different animals.",
        creativeResponseType: .drawing,
        reflection: "What is the canopy in the jungle?",
        reflectionResponseType: .shortText,
        passage: "From the lookout, you point to a jaguar padding along a riverbank far below. A sloth hangs like a fuzzy backpack on a branch. \"The canopy is the sunny roof of the jungle,\" you explain. Toucans hop between twigs, using long colorful beaks to pluck berries. Visitors scribble notes and grin.",
        readingQs: [
            ("Where are you teaching from?", ["A wooden lookout in the jungle", "A riverbank clearing", "A canopy walkway"], "A wooden lookout in the jungle", "The lesson happens on a jungle lookout."),
            ("What is the canopy?", ["The top layer of branches in the forest", "The forest floor covered in leaves", "A hollow tree trunk den"], "The top layer of branches in the forest", "The canopy is the forest's sunny roof."),
            ("How do toucans reach berries?", ["With their long colorful beaks", "With their claws only", "By shaking the branches"], "With their long colorful beaks", "Toucans use big beaks to pluck berries.")
        ],
        mathQs: [
            ("3 toucans sit on one branch and 2 on another. How many toucans?", ["4", "5", "6"], "5", "3 + 2 = 5 toucans."),
            ("6 visitors arrive. 1 leaves early. How many stay?", ["4", "5", "6"], "5", "6 − 1 = 5 visitors."),
            ("You spot 4 monkeys and 3 parrots. How many animals total?", ["6", "7", "8"], "7", "4 + 3 = 7 animals.")
        ]
    )

    static let forestTrailWalk = BundledLessons.makeLesson(
        title: "Wild Trails Discovery",
        theme: .nature, type: .explorer,
        category: .discovery,
        storyOpening: "Pine needles crunched under your boots as a wooden trail sign pointed toward a misty lake ahead.",
        missionPrompt: "Explore the forest trail, read the nature signs, and discover how plants and animals depend on each other.",
        storyEnding: "You reach the lake just as a heron lifts off the water. The forest shared its secrets with you today.",
        readingSkill: "Finding main ideas",
        mathSkill: "Counting on",
        vocab: "Ecosystem", vocabDef: "a community of plants and animals living together in one place",
        fact: "Trees make oxygen that humans and animals need to breathe.",
        creative: "Draw a nature spot you would love to visit and label three living things there.",
        creativeResponseType: .drawing,
        reflection: "What did you notice on the trail?",
        reflectionResponseType: .shortText,
        passage: "A sign reads: \"Welcome to the pine forest ecosystem.\" Tall trees filter sunlight while squirrels bury seeds near the path. Roots drink water from the soil, and leaves above make fresh oxygen. You count six birds at a feeder and hear a woodpecker tapping rhythm on an old trunk.",
        readingQs: [
            ("What does the trail sign call this place?", ["A pine forest ecosystem", "A grassy meadow habitat", "A rocky mountain trail"], "A pine forest ecosystem", "The sign welcomes you to an ecosystem."),
            ("What do leaves make?", ["Fresh oxygen", "Cool shade only", "Soft pine needles"], "Fresh oxygen", "Leaves make oxygen."),
            ("What is tapping on the old trunk?", ["A woodpecker", "A squirrel", "A rabbit"], "A woodpecker", "You hear a woodpecker tapping.")
        ],
        mathQs: [
            ("You count 6 birds, then 2 more fly in. How many birds now?", ["7", "8", "9"], "8", "6 + 2 = 8 birds."),
            ("9 trail markers and you pass 4. How many markers remain ahead?", ["4", "5", "6"], "5", "9 − 4 = 5 markers."),
            ("3 squirrels and 3 rabbits near the path. How many animals?", ["5", "6", "7"], "6", "3 + 3 = 6 animals.")
        ]
    )

    // MARK: - Science

    static let lavaFieldDiscovery = BundledLessons.makeLesson(
        title: "Lava Field Discovery",
        theme: .volcanoes, type: .explorer,
        category: .discovery,
        storyOpening: "Orange light pulsed on the horizon as Dr. Rivera adjusted her heat-proof helmet near a smoking lava field.",
        missionPrompt: "Explore the lava field safely and learn what happens when melted rock meets cool air.",
        storyEnding: "You watch shiny obsidian form as lava cools. Dr. Rivera stamps your explorer badge with a tiny volcano.",
        readingSkill: "Finding main ideas",
        mathSkill: "Addition within 10",
        vocab: "Magma", vocabDef: "hot melted rock beneath Earth's surface",
        fact: "Obsidian is a shiny rock made when lava cools very quickly.",
        creative: "Draw a volcano that is safe for animals to live near.",
        creativeResponseType: .drawing,
        reflection: "Why do scientists study volcanoes?",
        reflectionResponseType: .shortText,
        passage: "Heat ripples above black rock as Dr. Rivera points downhill. \"Magma lives deep underground,\" she says. \"When it reaches the surface, we call it lava.\" A glowing stream hits cold air and hardens into glassy obsidian. You stay behind the safety rope and sketch the steam clouds in your notebook.",
        readingQs: [
            ("What is magma?", ["Hot melted rock beneath Earth's surface", "Cool ash on the crater rim", "Hard rock on the mountain path"], "Hot melted rock beneath Earth's surface", "Magma is melted rock underground."),
            ("What is lava called when magma reaches the surface?", ["Lava", "Magma", "Ash"], "Lava", "Magma on the surface is lava."),
            ("What forms when lava cools quickly?", ["Obsidian", "Soft soil", "River clay"], "Obsidian", "Quick-cooling lava becomes obsidian.")
        ],
        mathQs: [
            ("Dr. Rivera collects 3 rock samples in the morning and 4 in the afternoon. How many total?", ["6", "7", "8"], "7", "3 + 4 = 7 samples."),
            ("8 safety cones mark the trail. 2 blow over. How many cones still stand?", ["5", "6", "7"], "6", "8 − 2 = 6 cones."),
            ("5 scientists at camp and 2 more arrive. How many scientists?", ["6", "7", "8"], "7", "5 + 2 = 7 scientists.")
        ]
    )

    static let stormClueHunter = BundledLessons.makeLesson(
        title: "Storm Clue Hunter",
        theme: .weather, type: .detective,
        category: .story,
        storyOpening: "Rain tapped the weather station window while a radar screen glowed with moving green shapes.",
        missionPrompt: "Read the weather clues in order and decide what kind of afternoon is coming!",
        storyEnding: "Your forecast helps families grab umbrellas in time. Evidence made the weather clear.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Subtraction within 10",
        vocab: "Forecast", vocabDef: "a prediction of what the weather will be like",
        fact: "Meteorologists use tools like radar to predict the weather.",
        creative: "Design a weather report for your town with three symbols.",
        creativeResponseType: .drawing,
        reflection: "Which weather clue was most helpful?",
        reflectionResponseType: .shortText,
        passage: "At the weather station, the barometer needle slips lower than it was at breakfast. Outside, clouds pile into tall gray stacks. On the radar screen, a green blob creeps in from the west toward town. The meteorologist waits for you to connect the clues before writing the afternoon forecast.",
        mathQs: [
            ("The thermometer reads 8 in the morning and drops 2 by noon. What is the noon reading?", ["5", "6", "7"], "6", "8 − 2 = 6."),
            ("10 umbrellas are stocked. 3 are taken. How many remain?", ["6", "7", "8"], "7", "10 − 3 = 7 umbrellas."),
            ("4 rain gauges and 5 wind socks are set up. How many tools total?", ["8", "9", "10"], "9", "4 + 5 = 9 tools.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .cause,
                setup: "The town wants a careful afternoon forecast. What is most likely coming?",
                clues: [
                    "The barometer shows air pressure falling since morning.",
                    "Dark clouds stack high like gray pancakes over the hills.",
                    "Radar shows a rain band moving in from the west."
                ],
                prompt: "What weather is most likely this afternoon?",
                choices: [
                    "A rainy afternoon",
                    "A clear sunny afternoon",
                    "A snowy blizzard right now"
                ],
                correctAnswer: "A rainy afternoon",
                explanation: "Falling pressure, stacked dark clouds, and west-moving rain on radar all support a rainy afternoon — not clear skies or an instant blizzard."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Who uses radar to help make a forecast?",
                choices: ["Meteorologists", "Sailors only", "Farmers only"],
                correctAnswer: "Meteorologists",
                explanation: "Meteorologists study tools like radar to predict weather."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Which clue most rules out a clear sunny afternoon?",
                choices: [
                    "Dark stacked clouds and rain on radar",
                    "The weather station has a window",
                    "Umbrellas are counted in a closet"
                ],
                correctAnswer: "Dark stacked clouds and rain on radar",
                explanation: "Tall dark clouds plus rain on radar do not match a clear sunny afternoon."
            )
        ]
    )

    // MARK: - Farm & Zoo

    static let barnyardRescue = BundledLessons.makeLesson(
        title: "Barnyard Rescue",
        theme: .farmAnimals, type: .rescue,
        category: .story,
        storyOpening: "A worried bleat echoed from the red barn as rain began to drum on the tin roof.",
        missionPrompt: "A baby goat is stuck on the wrong side of a muddy fence! Read the rescue steps and help bring it back safely.",
        storyEnding: "The little goat trots to its mother and nuzzles her soft fur. The barnyard is peaceful again.",
        readingSkill: "Using context clues",
        mathSkill: "Addition within 10",
        vocab: "Herd", vocabDef: "a group of animals that stay together, like cows or goats",
        fact: "Pigs are very smart and can learn tricks like dogs.",
        creative: "Draw your dream farm with room for every animal.",
        creativeResponseType: .drawing,
        reflection: "What was the first rescue step for the baby goat?",
        reflectionResponseType: .shortText,
        passage: "Rain drums the barn roof while you read the rescue card: stay calm, open the lower gate, guide the kid toward its herd. A spotted kid waits in the mud, shivering. You speak softly — animals trust quiet voices. The mother goat calls back, and the kid's ears perk up.",
        readingQs: [
            ("What animal needs help?", ["A baby goat", "A mother hen", "A farm dog"], "A baby goat", "A spotted kid goat is stuck."),
            ("What is the first rescue step?", ["Stay calm", "Chase the goat quickly", "Call loudly from far away"], "Stay calm", "The card says stay calm first."),
            ("What is a herd?", ["A group of animals that stay together", "A single animal alone", "A fenced garden bed"], "A group of animals that stay together", "Goats live in herds.")
        ],
        mathQs: [
            ("4 goats are in the pen and 2 more join them. How many goats now?", ["5", "6", "7"], "6", "4 + 2 = 6 goats."),
            ("You carry 7 towels and use 3. How many towels remain?", ["3", "4", "5"], "4", "7 − 3 = 4 towels."),
            ("3 chickens and 4 ducks in the yard. How many birds total?", ["6", "7", "8"], "7", "3 + 4 = 7 birds.")
        ]
    )

    static let zookeeperDay = BundledLessons.makeLesson(
        title: "Zookeeper for a Day",
        theme: .zooAnimals, type: .animalExpert,
        category: .discovery,
        storyOpening: "The zoo gates swung open as Keeper Mia handed you a clipboard and a bucket of crunchy snacks.",
        missionPrompt: "Help Keeper Mia care for the animals and teach visitors why zoos protect wildlife.",
        storyEnding: "The elephants trumpet a thank-you as the sun sets. You earned your zookeeper badge today.",
        readingSkill: "Learning from nonfiction",
        mathSkill: "Word problems",
        vocab: "Conservation", vocabDef: "protecting animals and nature so they stay healthy for the future",
        fact: "Giraffes have the same number of neck bones as humans — seven!",
        creative: "Design a zoo exhibit for your favorite animal.",
        creativeResponseType: .drawing,
        reflection: "What zoo animal fact surprised you?",
        reflectionResponseType: .shortText,
        passage: "Keeper Mia points to the giraffe enclosure. \"Seven neck bones — same as us,\" she says, \"just much longer.\" Zoos practice conservation by protecting endangered animals and teaching visitors. You measure peanuts for the elephants: two scoops per trunk, no more, no less. A penguin waddles over for fish time.",
        readingQs: [
            ("How many neck bones do giraffes have?", ["Seven", "Twelve", "Five"], "Seven", "Giraffes have seven neck bones."),
            ("What do zoos practice to protect animals?", ["Conservation", "Entertainment only", "Keeping animals apart"], "Conservation", "Zoos help with conservation."),
            ("What are you measuring for elephants?", ["Peanuts", "Hay bales", "Water buckets"], "Peanuts", "You measure peanut scoops.")
        ],
        mathQs: [
            ("2 elephant scoops in the morning and 2 in the afternoon. Total scoops?", ["3", "4", "5"], "4", "2 + 2 = 4 scoops."),
            ("9 visitors watch the penguins. 3 leave. How many remain?", ["5", "6", "7"], "6", "9 − 3 = 6 visitors."),
            ("5 penguins get 2 fish each. How many fish are needed?", ["8", "9", "10"], "10", "5 × 2 = 10 fish.")
        ]
    )

    // MARK: - Bugs & Fantasy

    static let gardenBugMystery = BundledLessons.makeLesson(
        title: "Garden Bug Mystery",
        theme: .bugs, type: .mystery,
        category: .story,
        storyOpening: "Something had been nibbling the sunflower leaves, leaving tiny crescent bites along the edges.",
        missionPrompt: "Follow connected garden clues to discover which visitor nibbled overnight!",
        storyEnding: "You identify the leaf nibbler with careful evidence. The garden keeps growing.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Counting on",
        vocab: "Pollinate", vocabDef: "to move pollen between flowers so plants can make seeds",
        fact: "Bees pollinate flowers. That work helps plants grow food.",
        creative: "Invent a friendly bug superhero who protects the garden.",
        creativeResponseType: .longText,
        reflection: "Which clue cracked the case?",
        reflectionResponseType: .shortText,
        passage: "Overnight, crescent bites appeared along a sunflower leaf. Under the leaf you find tiny dark droppings. A magnifying glass shows a trail of footprints made by six little legs. Nearby bees buzz from blossom to blossom, moving pollen so plants can make seeds. The nibbler itself is still hidden — the clues must do the talking.",
        mathQs: [
            ("You count 3 bees on one flower and 4 on another. How many bees?", ["6", "7", "8"], "7", "3 + 4 = 7 bees."),
            ("8 leaves are checked. 5 have bite marks. How many are untouched?", ["2", "3", "4"], "3", "8 − 5 = 3 leaves."),
            ("2 ladybugs arrive, then 3 more. How many ladybugs?", ["4", "5", "6"], "5", "2 + 3 = 5 ladybugs.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .identity,
                setup: "Something nibbled the sunflower leaves overnight. Who was the visitor?",
                clues: [
                    "Waxy droppings sit under the bitten leaf.",
                    "Tiny footprints show six legs, not eight.",
                    "The bites are crescent-shaped along the leaf edge, as if something chewed slowly while hanging underneath."
                ],
                prompt: "Which visitor best matches the evidence?",
                choices: [
                    "A caterpillar",
                    "A spider",
                    "A honeybee"
                ],
                correctAnswer: "A caterpillar",
                explanation: "Six legs and leaf-edge chewing fit a caterpillar. Spiders have eight legs, and bees were busy pollinating blossoms, not leaving crescent leaf bites."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Which clue rules out the spider?",
                choices: [
                    "The footprints show six legs, not eight",
                    "Bees were buzzing nearby",
                    "The sunflower is tall"
                ],
                correctAnswer: "The footprints show six legs, not eight",
                explanation: "Spiders have eight legs, so six-leg prints do not match a spider."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "What do bees do in the garden?",
                choices: [
                    "Pollinate blossoms",
                    "Eat only leaves",
                    "Dig tunnels under roots"
                ],
                correctAnswer: "Pollinate blossoms",
                explanation: "Bees move pollen between flowers so plants can make seeds."
            )
        ]
    )

    static let secretPassage = BundledLessons.makeLesson(
        title: "The Secret Passage",
        theme: .castles, type: .detective,
        category: .story,
        storyOpening: "A loose stone in the castle wall wobbled when you pressed the carved shield beside the fireplace.",
        missionPrompt: "Read the old castle map and find where the secret passage leads!",
        storyEnding: "The passage opens into the library, where a forgotten storybook waits on a velvet chair. Case closed!",
        readingSkill: "Close reading",
        mathSkill: "Subtraction within 10",
        vocab: "Fortress", vocabDef: "a strong castle built to keep people safe",
        fact: "Narrow slits in castle walls let people look out while staying behind the stone.",
        creative: "Design your own castle with five rooms and label each one.",
        creativeResponseType: .drawing,
        reflection: "Where did the secret passage lead?",
        reflectionResponseType: .shortText,
        passage: "The map shows a fortress with thick walls and narrow looking-out slits. A dotted line runs from the great hall to the library — the secret way servants used long ago. You count twelve stone steps down, then eight more along a damp corridor. Torchlight flickers on a wooden door carved with stars.",
        readingQs: [
            ("What does the map show?", ["A fortress with thick walls", "A garden courtyard", "A wooden watchtower"], "A fortress with thick walls", "The map shows a fortress."),
            ("Where does the secret passage lead?", ["To the library", "To the throne room", "To the castle kitchen"], "To the library", "The dotted line leads to the library."),
            ("What are the narrow slits for?", ["Letting people look out while staying behind the wall", "Letting sunlight fill the hall", "Letting rain drain from the roof"], "Letting people look out while staying behind the wall", "The slits let people look out from the wall."),
        ],
        mathQs: [
            ("You count 12 steps down and 8 more along the corridor. Total steps?", ["19", "20", "21"], "20", "12 + 8 = 20 steps."),
            ("10 torches light the hall. 3 go out. How many still burn?", ["6", "7", "8"], "7", "10 − 3 = 7 torches."),
            ("4 guards on the wall and 2 at the gate. How many guards?", ["5", "6", "7"], "6", "4 + 2 = 6 guards.")
        ]
    )

    static let gladeMystery = BundledLessons.makeLesson(
        title: "Moonlit Glade Mystery",
        theme: .fairies, type: .mystery,
        category: .story,
        storyOpening: "Silver moonlight pooled in a forest clearing where Luma the fairy waited beside a ring of mushrooms.",
        missionPrompt: "Luma asks for your help: tiny lights blink above the ferns. Use the glade clues to decide what is glowing!",
        storyEnding: "Luma twirls with joy. The glade still feels magical — and now you know what evidence supports the glow.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Counting on",
        vocab: "Glade", vocabDef: "an open sunny space in a forest",
        fact: "Fireflies glow because of a chemical reaction — nature's own sparkles!",
        creative: "Draw a fairy house inside a tree stump for Luma and her firefly friends.",
        creativeResponseType: .drawing,
        reflection: "What evidence supports your answer?",
        reflectionResponseType: .shortText,
        passage: "Luma the fairy lands softly on a mushroom ring in the open forest glade. Dew dots the moss in tiny curved trails. Soft blinking lights hover above the ferns. \"Fairies love mysteries,\" Luma whispers, \"but we solve them with careful clues.\" You do not shout an answer yet — first you line up what you can see and hear.",
        mathQs: [
            ("6 fireflies blink, then 3 more join. How many fireflies?", ["8", "9", "10"], "9", "6 + 3 = 9 fireflies."),
            ("10 dewdrops and 4 dry up. How many dewdrops remain?", ["5", "6", "7"], "6", "10 − 4 = 6 dewdrops."),
            ("2 mushroom rings and 3 fern patches. How many features?", ["4", "5", "6"], "5", "2 + 3 = 5 features.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .science,
                setup: "Luma and you watch soft lights blink above the ferns in the moonlit glade. What is most likely glowing?",
                clues: [
                    "The lights move gently from fern to fern, not from the moon itself.",
                    "When one light lands on a leaf, you see a tiny living body behind the glow.",
                    "The glow continues even when a cloud covers the moon for a moment."
                ],
                prompt: "What best explains the blinking lights?",
                choices: [
                    "Fireflies",
                    "Moonbeams bouncing only",
                    "Heat rising from the mushrooms"
                ],
                correctAnswer: "Fireflies",
                explanation: "Moving lights on living bodies that keep glowing when the moon is covered fit fireflies. Moonbeams alone would dim with the cloud, and mushrooms do not make blinking lights."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Why do fireflies glow?",
                choices: [
                    "A chemical reaction in their bodies",
                    "Light reflected from the moon only",
                    "Heat from the mushrooms"
                ],
                correctAnswer: "A chemical reaction in their bodies",
                explanation: "Fireflies make light with a chemical reaction — nature’s sparkles."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Who asks for your help in the glade?",
                choices: ["Luma the fairy", "A forest ranger only", "A talking mushroom"],
                correctAnswer: "Luma the fairy",
                explanation: "Luma the fairy waits by the mushroom ring and asks for help."
            )
        ]
    )

    // MARK: - Arts, Heroes & Vehicles

    static let colorMixLab = BundledLessons.makeLesson(
        title: "Color Mix Lab",
        theme: .art, type: .explorer,
        category: .creative,
        storyOpening: "Squeezes of red, blue, and yellow paint lined the studio table like bright little suns.",
        missionPrompt: "Mix colors, read the art facts, and create a painting that tells a story!",
        storyEnding: "Your painting dries on the rack — a swirl of new colors nobody had mixed before. The art lab applauds.",
        readingSkill: "Connecting ideas",
        mathSkill: "Addition within 10",
        vocab: "Palette", vocabDef: "a board or tray where an artist mixes paints",
        fact: "Mixing red and blue paint makes purple — colors combine in fun ways!",
        creative: "Invent a new color, name it, and draw something using only that color.",
        creativeResponseType: .longText,
        reflection: "What new color did you create?",
        reflectionResponseType: .shortText,
        passage: "On your palette, red meets blue and becomes purple like twilight. Yellow brushes over blue and turns green like spring leaves. Shapes and lines can show feelings without a single word. You paint a happy sun with orange rays and a calm lake with one careful swipe.",
        readingQs: [
            ("What color do red and blue make?", ["Purple", "Orange", "Brown"], "Purple", "Red and blue mix to purple."),
            ("What do yellow and blue make?", ["Green", "Orange", "Pink"], "Green", "Yellow and blue make green."),
            ("How can artists show feelings?", ["With shapes and lines", "With only one color", "With blank paper only"], "With shapes and lines", "Art uses shapes and lines.")
        ],
        mathQs: [
            ("You squeeze 3 red dots and 2 blue dots on the palette. How many dots?", ["4", "5", "6"], "5", "3 + 2 = 5 dots."),
            ("7 brushes in a cup. 2 are taken. How many remain?", ["4", "5", "6"], "5", "7 − 2 = 5 brushes."),
            ("4 yellow blobs and 4 blue blobs. Total blobs?", ["7", "8", "9"], "8", "4 + 4 = 8 blobs.")
        ]
    )

    static let rhythmWorkshop = BundledLessons.makeLesson(
        title: "Rhythm Workshop",
        theme: .music, type: .explorer,
        category: .creative,
        storyOpening: "Drums, shakers, and a shiny xylophone waited on the music room rug as the class settled in a circle.",
        missionPrompt: "Clap the rhythm, count the beats, and compose a short pattern for the class to play!",
        storyEnding: "The whole circle plays your pattern together — boom, tap, tap, boom! Music fills the room.",
        readingSkill: "Connecting ideas",
        mathSkill: "Number patterns",
        vocab: "Tempo", vocabDef: "how fast or slow a piece of music is played",
        fact: "Sound travels in waves through the air to your ears.",
        creative: "Invent an instrument no one has seen before and describe its sound.",
        creativeResponseType: .longText,
        reflection: "What rhythm pattern did you create?",
        reflectionResponseType: .shortText,
        passage: "Your teacher taps a slow tempo — one, two, three, four. Drums vibrate and send sound waves through the air to your ears. You write a pattern: clap, clap, stomp, rest. When everyone plays together, the beats stack like building blocks into a song.",
        readingQs: [
            ("What is tempo?", ["How fast or slow music is played", "How loud a single note is", "Which instrument plays first"], "How fast or slow music is played", "Tempo is the speed of music."),
            ("How does sound reach your ears?", ["In waves through the air", "In straight beams of light", "Only through solid walls"], "In waves through the air", "Sound travels in waves."),
            ("What does your pattern include?", ["Clap, clap, stomp, rest", "Stomp, clap, clap, rest", "Clap, rest, rest, stomp"], "Clap, clap, stomp, rest", "That is the written pattern.")
        ],
        mathQs: [
            ("Your pattern has 4 beats per line and 2 lines. How many beats total?", ["6", "7", "8"], "8", "4 + 4 = 8 beats."),
            ("6 students play drums and 3 play shakers. How many musicians?", ["8", "9", "10"], "9", "6 + 3 = 9 musicians."),
            ("You practice 9 times and nail it on the 10th. How many tries before success?", ["8", "9", "10"], "9", "9 tries before the 10th success.")
        ]
    )

    static let cityHelperMission = BundledLessons.makeLesson(
        title: "Cape Helper Mission",
        theme: .superheroes, type: .rescue,
        category: .math,
        storyOpening: "Your bright helper cape flutters as a kitten mews from a low tree branch on the sunny city sidewalk.",
        missionPrompt: "Today you are Caped Helper Number One! Read the rescue steps, count supplies, and help the kitten down safely.",
        storyEnding: "The kitten purrs in its owner's arms. Your cape did not give super strength — kindness and a smart plan did!",
        readingSkill: "Using context clues",
        mathSkill: "Subtraction within 10",
        vocab: "Courage", vocabDef: "being brave enough to help even when something feels hard",
        fact: "Real heroes include doctors, teachers, and firefighters who help others every day.",
        creative: "Invent a superhero who helps kids with reading or math. Draw their cape and power.",
        creativeResponseType: .drawing,
        reflection: "What made you a hero today?",
        reflectionResponseType: .shortText,
        passage: "You straighten your helper cape and follow the Caped Helper Club plan. Step one: stay calm so the kitten does not climb higher. Step two: ask a grown-up for a sturdy ladder. Step three: speak softly and offer food. Real heroes — firefighters, teachers, neighbors — use courage and teamwork, not magic powers. The kitten steps into a cozy carrier, safe at last.",
        readingQs: [
            ("What is step one?", ["Stay calm", "Shout loudly", "Climb the tree yourself"], "Stay calm", "Staying calm is step one."),
            ("What do real heroes use?", ["Courage and teamwork", "Working completely alone", "Waiting without a plan"], "Courage and teamwork", "Heroes use courage and teamwork."),
            ("Where is the kitten at the end?", ["Safe in a cozy carrier", "Still high in the tree", "Hidden under the porch"], "Safe in a cozy carrier", "The kitten ends up safe in a carrier.")
        ],
        mathQs: [
            ("9 neighbors watch. 4 go home. How many remain?", ["4", "5", "6"], "5", "9 − 4 = 5 neighbors."),
            ("You bring 6 treats and the kitten eats 2. How many treats left?", ["3", "4", "5"], "4", "6 − 2 = 4 treats."),
            ("3 rescue steps and 2 safety rules to remember. Total items?", ["4", "5", "6"], "5", "3 + 2 = 5 items.")
        ]
    )

    static let skyHighExplorer = BundledLessons.makeLesson(
        title: "Sky High Explorer",
        theme: .airplanes, type: .explorer,
        category: .discovery,
        storyOpening: "White contrails streaked the sky above the airport fence as a silver plane lifted off the runway.",
        missionPrompt: "Explore how airplanes fly and count the parts that help them soar above the clouds!",
        storyEnding: "The plane disappears into the sunlit clouds. You understand lift, wings, and wonder — ready for your next flight.",
        readingSkill: "Finding main ideas",
        mathSkill: "Addition within 10",
        vocab: "Altitude", vocabDef: "how high something is above the ground",
        fact: "Airplane wings are curved so air moves faster over the top, creating lift.",
        creative: "Design an airplane with a rainbow tail and name it.",
        creativeResponseType: .drawing,
        reflection: "What do curved airplane wings create?",
        reflectionResponseType: .shortText,
        passage: "Curved wings slice through the air. Faster air above the wing pushes up — that is lift. The pilot radios the tower and climbs to a higher altitude while wheels tuck into the belly. You watch from the fence as luggage carts roll below, loading suitcases for travelers.",
        readingQs: [
            ("What pushes the plane up?", ["Lift from curved wings", "Push from the landing wheels", "Pull from the tail fin only"], "Lift from curved wings", "Curved wings create lift."),
            ("What is altitude?", ["How high something is above the ground", "How fast the plane is flying", "How heavy the cargo is"], "How high something is above the ground", "Altitude means height above ground."),
            ("Who radios the tower?", ["The pilot", "A passenger", "The baggage crew"], "The pilot", "The pilot radios the tower.")
        ],
        mathQs: [
            ("4 suitcases on one cart and 5 on another. How many suitcases?", ["8", "9", "10"], "9", "4 + 5 = 9 suitcases."),
            ("The plane climbs past 7 cloud layers and 2 more. Total layers passed?", ["8", "9", "10"], "9", "7 + 2 = 9 layers."),
            ("10 passengers board. 3 sit in the back first. How many still boarding elsewhere?", ["6", "7", "8"], "7", "10 − 3 = 7 passengers.")
        ]
    )

    static let stationBuilder = BundledLessons.makeLesson(
        title: "Mountain Station Builder",
        theme: .trains, type: .builder,
        category: .math,
        storyOpening: "Hammer taps rang through the mountain valley as workers laid shiny tracks toward a half-built station.",
        missionPrompt: "Help finish the train station before the first locomotive arrives — count tracks, benches, and signs!",
        storyEnding: "The whistle blows and the first train glides in. Your station welcomes passengers from near and far.",
        readingSkill: "Following directions",
        mathSkill: "Addition within 10",
        vocab: "Conductor", vocabDef: "the person who helps run a train and checks tickets",
        fact: "Trains use steel wheels on steel tracks to roll with very little friction.",
        creative: "Design a train station with a snack shop and name three foods it sells.",
        creativeResponseType: .drawing,
        reflection: "Where would your train travel?",
        reflectionResponseType: .shortText,
        passage: "Steel wheels roll smoothly because steel on steel has little friction. You nail four benches, hang two platform signs, and bolt six track sections. The conductor checks tickets with a friendly punch. Steam curls from the approaching engine as the mountain tunnel echoes.",
        readingQs: [
            ("Why do train wheels roll smoothly?", ["Steel on steel has little friction", "The tracks are covered in sand", "The wheels are made of wood"], "Steel on steel has little friction", "Little friction helps wheels roll."),
            ("Who checks tickets?", ["The conductor", "The engineer", "A station greeter"], "The conductor", "The conductor checks tickets."),
            ("How many benches do you nail?", ["Four", "Six", "Two"], "Four", "You nail four benches.")
        ],
        mathQs: [
            ("4 benches and 2 platform signs. How many items installed?", ["5", "6", "7"], "6", "4 + 2 = 6 items."),
            ("6 track sections are laid. 1 needs fixing. How many are ready?", ["4", "5", "6"], "5", "6 − 1 = 5 sections."),
            ("3 workers in the morning and 4 in the afternoon. Total workers?", ["6", "7", "8"], "7", "3 + 4 = 7 workers.")
        ]
    )

    // MARK: - Cars & Cooking

    static let garageMysteryShift = BundledLessons.makeLesson(
        title: "Garage Mystery Shift",
        theme: .cars, type: .mystery,
        category: .story,
        storyOpening: "A faint clicking sound came from beneath a shiny blue car the moment it rolled into Rosa's garage.",
        missionPrompt: "Follow the garage clues to figure out what is really making that clicking sound before Rosa starts any repair!",
        storyEnding: "The loose heat shield near the front wheel is tightened in minutes. The clicking stops, and the car purrs quietly again.",
        readingSkill: "Evidence-based reasoning",
        mathSkill: "Counting on",
        vocab: "Gauge", vocabDef: "a dial or display that shows a measurement, like temperature",
        fact: "Mechanics compare when a sound happens with what the gauges show to find a problem faster.",
        creative: "Invent a friendly garage robot that helps mechanics find tricky car problems.",
        creativeResponseType: .longText,
        reflection: "Which clue helped you solve the mystery?",
        reflectionResponseType: .shortText,
        passage: "The clicking sound grows louder only when the car turns a corner, never when it drives straight. Rosa checks the temperature gauge, and it stays perfectly normal the whole time. A quick look near the front wheel shows a small metal heat shield sitting loose instead of snug against its bracket. Rosa does not guess — she lines up what she has seen and heard before deciding what to fix.",
        mathQs: [
            ("Rosa counts 4 wheels and 2 mirrors to check before the test drive. How many parts?", ["5", "6", "7"], "6", "4 + 2 = 6 parts."),
            ("9 bolts need tightening. Rosa tightens 3. How many bolts are left?", ["5", "6", "7"], "6", "9 − 3 = 6 bolts."),
            ("3 heat shields and 4 hose clamps sit on the workbench. How many parts total?", ["6", "7", "8"], "7", "3 + 4 = 7 parts.")
        ],
        customReadingQuestions: [
            .mystery(
                kind: .cause,
                setup: "A car makes a clicking sound only when it turns. What is most likely causing it?",
                clues: [
                    "The clicking only happens when the car turns a corner, not when driving straight.",
                    "The temperature gauge stays completely normal the whole time.",
                    "A small heat shield near the front wheel sits loose instead of snug against its bracket."
                ],
                prompt: "What is most likely causing the clicking sound?",
                choices: [
                    "A loose heat shield near the front wheel",
                    "A serious problem with the engine",
                    "Nothing at all is wrong with the car"
                ],
                correctAnswer: "A loose heat shield near the front wheel",
                explanation: "A normal temperature gauge rules out an engine problem, and the turning-only clicking matches a loose part near the wheel, not the engine."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "Why does the normal temperature gauge matter for this mystery?",
                choices: [
                    "It suggests the engine is probably not the cause",
                    "It proves the car has no fuel",
                    "It shows the mirrors are broken"
                ],
                correctAnswer: "It suggests the engine is probably not the cause",
                explanation: "An engine problem usually raises the temperature gauge, so a normal reading points away from the engine."
            ),
            LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "What did Rosa find near the front wheel?",
                choices: ["A loose heat shield", "A flat tire", "A broken mirror"],
                correctAnswer: "A loose heat shield",
                explanation: "A small metal heat shield sat loose instead of snug against its bracket."
            )
        ]
    )

    static let bakeSaleCountdown = BundledLessons.makeLesson(
        title: "Bake Sale Countdown",
        theme: .cooking, type: .builder,
        category: .math,
        storyOpening: "Trays of cookie dough lined Chef Dara's counter as the clock ticked toward the school bake sale.",
        missionPrompt: "Help Chef Dara measure, count, and bake enough treats before the bake sale doors open!",
        storyEnding: "The last tray of muffins cools just as the doors open. Every table is stacked with treats, ready to share.",
        readingSkill: "Following directions",
        mathSkill: "Addition and subtraction within 20",
        vocab: "Batter", vocabDef: "a mixed liquid used to bake bread, muffins, or cake",
        fact: "Bakers measure ingredients carefully because baking recipes need exact amounts to work correctly.",
        creative: "Invent a brand-new treat for the bake sale and describe what makes it special.",
        creativeResponseType: .longText,
        reflection: "How many muffins did Chef Dara bake in both batches together?",
        reflectionResponseType: .shortText,
        passage: "Chef Dara reads the recipe card before mixing anything. Step one: measure exactly one cup of flour. Step two: crack two eggs into the bowl and stir until the batter turns smooth. Step three: pour the batter into muffin cups and slide the tray into a warm oven. Chef Dara sets a timer for twenty minutes so nothing bakes too long or too short.",
        readingQs: [
            ("What does Chef Dara do before mixing anything?", ["Reads the recipe card", "Turns on the radio", "Sweeps the kitchen floor"], "Reads the recipe card", "Chef Dara reads the recipe card first."),
            ("What is step two of the recipe?", ["Crack two eggs into the bowl", "Pour batter into muffin cups", "Set a timer for twenty minutes"], "Crack two eggs into the bowl", "Step two is cracking two eggs into the bowl."),
            ("Why does Chef Dara set a timer?", ["So nothing bakes too long or too short", "So the oven turns off forever", "So the muffins stay cold"], "So nothing bakes too long or too short", "The timer keeps the baking time exact.")
        ],
        mathQs: [
            ("Chef Dara bakes 8 muffins in the first batch and 6 in the second. How many muffins total?", ["12", "13", "14"], "14", "8 + 6 = 14 muffins."),
            ("A tray holds 20 cookies. 7 are sold before the bake sale starts. How many are left?", ["12", "13", "14"], "13", "20 − 7 = 13 cookies."),
            ("Chef Dara has 9 trays ready and bakes 5 more. How many trays in all?", ["13", "14", "15"], "14", "9 + 5 = 14 trays.")
        ]
    )
}
