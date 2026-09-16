import Foundation

enum TopicLibrary {
    static let all: [TopicDefinition] = [
        sharks, oceanAnimals, horses, dinosaurs, space, planets, rockets,
        soccer, basketball, dogs, cats, jungleAnimals, princesses, castles,
        fairies, airplanes, trains, cars, robots, superheroes, art, music,
        cooking, nature, bugs, volcanoes, weather, farmAnimals, zooAnimals, pirates
    ]

    static func definition(for topic: Topic) -> TopicDefinition {
        all.first { $0.id == topic } ?? sharks
    }

    static var topicsByCategory: [TopicCategory: [TopicDefinition]] {
        Dictionary(grouping: all, by: \.category)
    }

    /// Child-friendly definition for a vocabulary word within a topic.
    static func vocabularyDefinition(for word: String, topic: Topic) -> String {
        let key = word.lowercased()
        if let def = sharedVocabularyDefinitions[key] { return def }

        let def = definition(for: topic)
        if def.vocabularyWords.contains(where: { $0.lowercased() == key }) {
            return "an important word about \(def.name.lowercased())"
        }
        return "an important word about \(def.name.lowercased())"
    }

    private static let sharedVocabularyDefinitions: [String: String] = [
        "gills": "body parts that help fish and sharks breathe underwater",
        "predator": "an animal that hunts other animals for food",
        "reef": "a ridge of rock or coral in the sea where many animals live",
        "cartilage": "a bendy material in a shark's skeleton instead of hard bone",
        "fin": "a flat body part that helps fish and sharks swim",
        "habitat": "the place where an animal or plant naturally lives",
        "tide": "the rise and fall of ocean water along the shore",
        "coral": "tiny sea animals that build hard, colorful homes together",
        "current": "a steady flow of water moving through the ocean",
        "stable": "a building where horses live and sleep",
        "mane": "the long hair along the top of a horse's neck",
        "gallop": "to run fast, the way horses move",
        "hoof": "the hard foot on the bottom of a horse's leg",
        "foal": "a young horse",
        "fossil": "remains of a plant or animal from long ago, preserved in rock",
        "extinct": "no longer living anywhere on Earth",
        "herbivore": "an animal that eats plants",
        "carnivore": "an animal that eats meat",
        "galaxy": "a huge group of stars in space",
        "astronaut": "a person trained to travel and work in space",
        "telescope": "a tool that makes faraway objects in space look closer",
        "orbit": "the path something takes as it moves around another object in space",
        "gravity": "the force that pulls things toward each other",
        "launch": "to send a rocket up into the sky",
        "fuel": "energy that powers engines and rockets",
        "thrust": "the push that moves a rocket forward and upward",
        "lava": "hot melted rock that flows out of a volcano",
        "eruption": "when a volcano bursts and sends out lava, ash, or steam",
        "magma": "hot melted rock beneath Earth's surface",
        "forecast": "a prediction of what the weather will be like",
        "precipitation": "water that falls from clouds, like rain or snow",
        "ecosystem": "a community of plants and animals living together in one place",
        "whiskers": "long stiff hairs on a cat's face that help it feel nearby objects",
        "purr": "the soft rumbling sound a happy cat makes",
        "nocturnal": "active mostly at night",
        "compass": "a tool that points north to help you find your way",
        "treasure": "something valuable that is hidden or hard to find",
        "kingdom": "the land ruled by a king or queen",
        "moat": "a ditch filled with water around a castle",
        "drawbridge": "a bridge that can be raised or lowered at a castle gate",
        "circuit": "a path that electricity follows through wires",
        "sensor": "a part that helps a robot see, hear, or feel the world",
        "program": "a list of steps that tells a robot or computer what to do",
        "rhythm": "a steady beat in music",
        "melody": "the tune you hum or sing in a song",
        "recipe": "a list of steps and ingredients for making food"
    ]

    // MARK: - Animals & Ocean

    static let sharks = TopicDefinition(
        id: .sharks,
        name: "Sharks",
        category: .animals,
        description: "Dive into the deep and learn about amazing shark helpers of the sea!",
        primaryColorName: "oceanTurquoise",
        secondaryColorName: "skyBlue",
        vocabularyWords: ["Gills", "Predator", "Reef", "Cartilage", "Fin"],
        scienceFacts: [
            "Sharks use gills to breathe underwater.",
            "Sharks do not have bones like humans — their skeletons are made of cartilage.",
            "Some sharks can sense tiny movements in the water with special organs."
        ],
        storySettings: ["a colorful coral reef", "a deep blue trench", "a sunny lagoon"],
        mathContexts: ["sharks swimming near a reef", "baby sharks in a nursery", "sharks passing a shipwreck"],
        creativePrompts: [
            "Design your own friendly shark and give it a name.",
            "Draw a picture of a shark home in the ocean.",
            "Invent a shark superhero who protects the reef."
        ]
    )

    static let oceanAnimals = TopicDefinition(
        id: .oceanAnimals,
        name: "Ocean Animals",
        category: .animals,
        description: "Meet sea turtles, octopuses, and other creatures of the ocean!",
        primaryColorName: "skyBlue",
        secondaryColorName: "oceanTurquoise",
        vocabularyWords: ["Habitat", "Tide", "Coral", "Current", "School"],
        scienceFacts: [
            "Octopuses have three hearts and blue blood.",
            "Sea turtles return to the same beach where they were born to lay eggs.",
            "Dolphins communicate using clicks and whistles."
        ],
        storySettings: ["a kelp forest", "a tide pool at low tide", "a glowing deep-sea cave"],
        mathContexts: ["sea stars on a rock", "fish in a school", "crabs scuttling on the sand"],
        creativePrompts: [
            "Design your own ocean animal.",
            "Draw a picture of an underwater city for sea creatures.",
            "Invent a new kind of fish and describe what it eats."
        ]
    )

    static let horses = TopicDefinition(
        id: .horses,
        name: "Horses",
        category: .animals,
        description: "Gallop into learning about horses, stables, and gentle giants!",
        primaryColorName: "warmOrange",
        secondaryColorName: "sunshineYellow",
        vocabularyWords: ["Stable", "Mane", "Gallop", "Hoof", "Foal"],
        scienceFacts: [
            "Horses use their ears, eyes, and body language to communicate.",
            "A horse can sleep standing up because of special leg locks.",
            "Horses have the biggest eyes of any land mammal."
        ],
        storySettings: ["a sunny stable", "a green meadow", "a horse show arena"],
        mathContexts: ["horses in a stable", "apples for hungry ponies", "riders on a trail"],
        creativePrompts: [
            "Draw a picture of your dream horse and give it a name.",
            "Design a cozy stable for three ponies.",
            "Invent a horse race with fun rules."
        ]
    )

    static let dinosaurs = TopicDefinition(
        id: .dinosaurs,
        name: "Dinosaurs",
        category: .animals,
        description: "Travel back in time to meet mighty dinosaurs and ancient worlds!",
        primaryColorName: "freshGreen",
        secondaryColorName: "warmOrange",
        vocabularyWords: ["Fossil", "Extinct", "Herbivore", "Carnivore", "Paleontologist"],
        scienceFacts: [
            "Fossils help scientists learn about animals that lived long ago.",
            "Birds are related to dinosaurs that lived millions of years ago.",
            "Some dinosaurs had feathers, not just scales."
        ],
        storySettings: ["a misty volcano valley", "a fossil dig site", "a fern-filled jungle"],
        mathContexts: ["dinosaur eggs in a nest", "footprints in mud", "bones in a museum"],
        creativePrompts: [
            "Invent a dinosaur and name it.",
            "Draw a picture of what you think a baby dinosaur looked like.",
            "Design a museum exhibit for your favorite dino."
        ]
    )

    static let dogs = TopicDefinition(
        id: .dogs,
        name: "Dogs",
        category: .animals,
        description: "Play and learn with loyal, tail-wagging friends!",
        primaryColorName: "warmOrange",
        secondaryColorName: "coralPink",
        vocabularyWords: ["Breed", "Puppy", "Leash", "Wag", "Companion"],
        scienceFacts: [
            "Dogs can learn over 100 words and gestures.",
            "A dog's nose has up to 300 million smell receptors.",
            "Puppies are born blind and deaf, but their senses grow quickly."
        ],
        storySettings: ["a dog park", "a cozy living room", "a training class"],
        mathContexts: ["puppies playing fetch", "dog treats in a bowl", "dogs at a parade"],
        creativePrompts: [
            "Draw a picture of your dream dog and give it a superpower.",
            "Invent a new dog toy.",
            "Create a dog hero who helps people."
        ]
    )

    static let cats = TopicDefinition(
        id: .cats,
        name: "Cats",
        category: .animals,
        description: "Pounce into fun facts about curious, clever cats!",
        primaryColorName: "brightLavender",
        secondaryColorName: "coralPink",
        vocabularyWords: ["Whiskers", "Purr", "Kitten", "Claw", "Nocturnal"],
        scienceFacts: [
            "Cats use whiskers to feel spaces in the dark.",
            "A cat's purr may help its bones heal faster.",
            "Cats spend about 12 to 16 hours a day sleeping."
        ],
        storySettings: ["a sunny windowsill", "a cozy cat tree", "a garden at dusk"],
        mathContexts: ["kittens in a basket", "yarn balls on the floor", "cats on a fence"],
        creativePrompts: [
            "Draw a picture of a cat with a secret job.",
            "Invent a cat café and name the menu items.",
            "Design a playground just for cats."
        ]
    )

    static let jungleAnimals = TopicDefinition(
        id: .jungleAnimals,
        name: "Jungle Animals",
        category: .animals,
        description: "Swing through the jungle and meet wild, wonderful animals!",
        primaryColorName: "freshGreen",
        secondaryColorName: "warmOrange",
        vocabularyWords: ["Canopy", "Habitat", "Tropical", "Predator", "Camouflage"],
        scienceFacts: [
            "Jaguars are strong swimmers and often hunt near rivers.",
            "Sloths move slowly to save energy in the hot jungle.",
            "Toucans use their big beaks to reach fruit on thin branches."
        ],
        storySettings: ["a rainforest canopy", "a riverbank", "a hidden waterfall"],
        mathContexts: ["monkeys in the trees", "parrots on a branch", "frogs on lily pads"],
        creativePrompts: [
            "Draw a picture of a jungle treehouse for animals.",
            "Invent a new jungle animal.",
            "Design a jungle rescue mission."
        ]
    )

    static let farmAnimals = TopicDefinition(
        id: .farmAnimals,
        name: "Farm Animals",
        category: .animals,
        description: "Visit the farm and learn about animals that live there!",
        primaryColorName: "freshGreen",
        secondaryColorName: "sunshineYellow",
        vocabularyWords: ["Barn", "Pasture", "Harvest", "Herd", "Chick"],
        scienceFacts: [
            "Cows have best friends and get stressed when separated.",
            "Chickens can remember over 100 different faces.",
            "Pigs are very smart and can learn tricks like dogs."
        ],
        storySettings: ["a red barn at sunrise", "a vegetable garden", "a muddy pig pen"],
        mathContexts: ["chickens in the coop", "cows in a pasture", "eggs in a basket"],
        creativePrompts: [
            "Draw a picture of your dream farm.",
            "Invent a new farm animal.",
            "Design a barn with room for every animal."
        ]
    )

    static let zooAnimals = TopicDefinition(
        id: .zooAnimals,
        name: "Zoo Animals",
        category: .animals,
        description: "Explore the zoo and discover animals from around the world!",
        primaryColorName: "warmOrange",
        secondaryColorName: "freshGreen",
        vocabularyWords: ["Enclosure", "Keeper", "Species", "Conservation", "Exhibit"],
        scienceFacts: [
            "Zoos help protect endangered animals and teach people about wildlife.",
            "Elephants can recognize themselves in a mirror.",
            "Giraffes have the same number of neck bones as humans — seven!"
        ],
        storySettings: ["a zoo entrance", "the big cat habitat", "the aviary"],
        mathContexts: ["visitors at the zoo", "peanuts for elephants", "penguins on ice"],
        creativePrompts: [
            "Design a zoo exhibit for your favorite animal.",
            "Draw a picture of a day as a zookeeper.",
            "Invent a new animal habitat."
        ]
    )

    static let bugs = TopicDefinition(
        id: .bugs,
        name: "Bugs",
        category: .nature,
        description: "Crawl, buzz, and flutter into the tiny world of insects!",
        primaryColorName: "freshGreen",
        secondaryColorName: "sunshineYellow",
        vocabularyWords: ["Insect", "Antenna", "Metamorphosis", "Pollinate", "Colony"],
        scienceFacts: [
            "Bees pollinate flowers. That work helps plants grow food.",
            "Butterflies taste with their feet.",
            "Ants can carry objects many times their own weight."
        ],
        storySettings: ["a garden full of flowers", "a log in the forest", "a meadow at noon"],
        mathContexts: ["ladybugs on a leaf", "ants carrying crumbs", "butterflies in a field"],
        creativePrompts: [
            "Invent a friendly bug superhero.",
            "Draw a picture of a bug's-eye view of your backyard.",
            "Design a tiny house for a beetle."
        ]
    )

    // MARK: - Science & Space

    static let space = TopicDefinition(
        id: .space,
        name: "Space",
        category: .science,
        description: "Blast off into stars, galaxies, and cosmic wonders!",
        primaryColorName: "brightLavender",
        secondaryColorName: "deepNavy",
        vocabularyWords: ["Galaxy", "Astronaut", "Telescope", "Orbit", "Gravity"],
        scienceFacts: [
            "Planets move around the sun in paths called orbits.",
            "There is no air in space, so astronauts wear special suits.",
            "The sun is a star — it is the closest star to Earth."
        ],
        storySettings: ["a space station", "a rocket launch pad", "a star-filled sky"],
        mathContexts: ["rockets on a launch pad", "stars in a constellation", "supplies for astronauts"],
        creativePrompts: [
            "Draw a picture of a rocket for a mission to Mars.",
            "Design your own space station.",
            "Invent a planet and describe who lives there."
        ]
    )

    static let planets = TopicDefinition(
        id: .planets,
        name: "Planets",
        category: .science,
        description: "Visit rocky, icy, and giant worlds in our solar system!",
        primaryColorName: "brightLavender",
        secondaryColorName: "skyBlue",
        vocabularyWords: ["Orbit", "Solar System", "Ring", "Atmosphere", "Rotate"],
        scienceFacts: [
            "Earth is the only planet we know of with liquid water on the surface.",
            "Jupiter is the largest planet and has a Great Red Spot storm.",
            "Saturn's rings are made of ice and rock."
        ],
        storySettings: ["the rings of Saturn", "a rocky Mars landscape", "a view from the moon"],
        mathContexts: ["moons orbiting a planet", "rocks on Mars", "days on different planets"],
        creativePrompts: [
            "Draw a picture of your favorite planet up close.",
            "Invent a new moon and name it.",
            "Design a vehicle for exploring icy planets."
        ]
    )

    static let rockets = TopicDefinition(
        id: .rockets,
        name: "Rockets",
        category: .science,
        description: "Count down and learn how rockets soar into space!",
        primaryColorName: "coralPink",
        secondaryColorName: "brightLavender",
        vocabularyWords: ["Launch", "Fuel", "Thrust", "Capsule", "Engineer"],
        scienceFacts: [
            "Rockets need thrust to push against gravity and lift off.",
            "Engineers test rockets many times before people ride them.",
            "The first rockets were invented over a thousand years ago in China."
        ],
        storySettings: ["a launch control room", "a rocket on the pad", "a cargo bay in orbit"],
        mathContexts: ["rockets carrying supplies", "fuel tanks being filled", "countdown numbers"],
        creativePrompts: [
            "Design a rocket with three special features.",
            "Draw a picture of the inside of a rocket where astronauts live.",
            "Invent a rocket that visits a made-up planet."
        ]
    )

    static let volcanoes = TopicDefinition(
        id: .volcanoes,
        name: "Volcanoes",
        category: .science,
        description: "Explore fiery mountains and the power beneath Earth's crust!",
        primaryColorName: "coralPink",
        secondaryColorName: "warmOrange",
        vocabularyWords: ["Lava", "Eruption", "Magma", "Crater", "Geologist"],
        scienceFacts: [
            "Volcanoes form when hot melted rock called magma pushes up from below.",
            "Some volcanoes erupt under the ocean and build new islands.",
            "Obsidian is a shiny rock made when lava cools very quickly."
        ],
        storySettings: ["a volcano observatory", "a lava field", "an island being born"],
        mathContexts: ["rocks rolling down a slope", "scientists at a camp", "layers of ash"],
        creativePrompts: [
            "Draw a picture of a volcano that is safe for animals to live near.",
            "Invent a tool scientists use to study lava.",
            "Design a volcano museum."
        ]
    )

    static let weather = TopicDefinition(
        id: .weather,
        name: "Weather",
        category: .science,
        description: "Watch clouds, rain, and sunshine — weather is all around us!",
        primaryColorName: "skyBlue",
        secondaryColorName: "sunshineYellow",
        vocabularyWords: ["Forecast", "Cloud", "Precipitation", "Temperature", "Meteorologist"],
        scienceFacts: [
            "Rain forms when water droplets in clouds grow heavy and fall.",
            "Lightning is a giant spark of electricity in the sky.",
            "Meteorologists use tools like radar to predict the weather."
        ],
        storySettings: ["a weather station", "a rainy playground", "a rainbow after a storm"],
        mathContexts: ["raindrops on a window", "thermometer readings", "days of sunshine"],
        creativePrompts: [
            "Draw a picture of your favorite kind of weather.",
            "Invent a machine that makes gentle rain for gardens.",
            "Design a weather report for your town."
        ]
    )

    static let nature = TopicDefinition(
        id: .nature,
        name: "Nature",
        category: .nature,
        description: "Discover forests, rivers, and the beauty of the outdoors!",
        primaryColorName: "freshGreen",
        secondaryColorName: "skyBlue",
        vocabularyWords: ["Ecosystem", "Seed", "Root", "Trail", "Conservation"],
        scienceFacts: [
            "Trees make oxygen that humans and animals need to breathe.",
            "Roots help plants drink water from the soil.",
            "National parks protect wild places for animals and people to enjoy."
        ],
        storySettings: ["a forest trail", "a mountain lake", "a wildflower meadow"],
        mathContexts: ["leaves on a tree", "steps on a hike", "birds at a feeder"],
        creativePrompts: [
            "Draw a picture of a nature spot you would love to visit.",
            "Invent a tree that grows something surprising.",
            "Design a park sign that teaches visitors about nature."
        ]
    )

    // MARK: - Sports

    static let soccer = TopicDefinition(
        id: .soccer,
        name: "Soccer",
        category: .sports,
        description: "Kick, pass, and score with soccer skills and team spirit!",
        primaryColorName: "freshGreen",
        secondaryColorName: "skyBlue",
        vocabularyWords: ["Goal", "Pass", "Strategy", "Teammate", "Defender"],
        scienceFacts: [
            "Running during soccer strengthens your heart and lungs.",
            "Team sports help kids learn cooperation and communication.",
            "Soccer is played by more people worldwide than any other sport."
        ],
        storySettings: ["a green stadium", "a practice field", "a championship game"],
        mathContexts: ["players scoring goals", "soccer balls in a bag", "teams on the field"],
        creativePrompts: [
            "Create a soccer team mascot.",
            "Design a soccer jersey for your team.",
            "Invent a fun new soccer rule."
        ]
    )

    static let basketball = TopicDefinition(
        id: .basketball,
        name: "Basketball",
        category: .sports,
        description: "Dribble, shoot, and learn math on the basketball court!",
        primaryColorName: "warmOrange",
        secondaryColorName: "coralPink",
        vocabularyWords: ["Dribble", "Rebound", "Court", "Coach", "Assist"],
        scienceFacts: [
            "Jumping and running in basketball builds strong leg muscles.",
            "A basketball hoop is 10 feet high — about twice as tall as many kids.",
            "Spinning a ball on your finger uses balance and friction."
        ],
        storySettings: ["a gym with squeaky floors", "a neighborhood court", "a buzzer-beater moment"],
        mathContexts: ["points on the scoreboard", "players on the court", "baskets in a row"],
        creativePrompts: [
            "Design a basketball team logo.",
            "Draw a picture of the perfect basketball shoe.",
            "Invent a basketball trick shot."
        ]
    )

    // MARK: - Fantasy & Adventure

    static let princesses = TopicDefinition(
        id: .princesses,
        name: "Princesses",
        category: .fantasy,
        description: "Enter a world of kindness, courage, and royal adventures!",
        primaryColorName: "coralPink",
        secondaryColorName: "brightLavender",
        vocabularyWords: ["Kingdom", "Crown", "Kindness", "Castle", "Royal"],
        scienceFacts: [
            "Real castles were built with thick walls to stay cool in summer and warm in winter.",
            "Many castles had gardens that grew food for the people inside.",
            "Historians study old paintings and books to learn about royal life long ago."
        ],
        storySettings: ["a grand ballroom", "a castle garden", "a tower with a view"],
        mathContexts: ["guests at a feast", "steps to the tower", "banners in the hall"],
        creativePrompts: [
            "Draw a picture of a kind princess and her brave pet.",
            "Design a crown with three special gems.",
            "Write about a princess who solves a problem."
        ]
    )

    static let castles = TopicDefinition(
        id: .castles,
        name: "Castles",
        category: .fantasy,
        description: "Explore towers, drawbridges, and mighty stone castles!",
        primaryColorName: "brightLavender",
        secondaryColorName: "warmOrange",
        vocabularyWords: ["Tower", "Moat", "Drawbridge", "Fortress", "Knight"],
        scienceFacts: [
            "Castle moats were ditches filled with water that made it harder to walk up to the walls.",
            "Narrow slits in castle walls let people look out while staying behind the stone.",
            "Some castles took decades to build."
        ],
        storySettings: ["a castle gate at dawn", "the great hall", "a secret passage"],
        mathContexts: ["stones in a wall", "guards on the wall", "torches in a corridor"],
        creativePrompts: [
            "Design your own castle with five rooms.",
            "Draw a picture of a castle that floats on clouds.",
            "Invent a drawbridge that works in a new way."
        ]
    )

    static let fairies = TopicDefinition(
        id: .fairies,
        name: "Fairies",
        category: .fantasy,
        description: "Flutter into magical forests with tiny, sparkling fairies!",
        primaryColorName: "brightLavender",
        secondaryColorName: "freshGreen",
        vocabularyWords: ["Sparkle", "Wings", "Enchant", "Glade", "Pixie"],
        scienceFacts: [
            "Fireflies glow because of a chemical reaction — nature's own sparkles!",
            "Flowers attract pollinators with bright colors and sweet smells.",
            "Mushrooms help break down old plants in the forest."
        ],
        storySettings: ["a moonlit glade", "a mushroom ring", "a dewdrop on a leaf"],
        mathContexts: ["fairies in a garden", "sparkles in the air", "flowers in a ring"],
        creativePrompts: [
            "Draw a picture of a fairy with a special power.",
            "Design a fairy house in a tree stump.",
            "Invent a fairy festival with games."
        ]
    )

    static let pirates = TopicDefinition(
        id: .pirates,
        name: "Pirates",
        category: .fantasy,
        description: "Sail the seas, read maps, and hunt for learning treasure!",
        primaryColorName: "warmOrange",
        secondaryColorName: "oceanTurquoise",
        vocabularyWords: ["Compass", "Treasure", "Map", "Crew", "Anchor"],
        scienceFacts: [
            "Compasses use Earth's magnetic field to point north.",
            "Sailors used stars to navigate before GPS existed.",
            "Ships float because they push aside enough water to balance their weight."
        ],
        storySettings: ["a ship deck at sunset", "a hidden island", "a cave with a map"],
        mathContexts: ["gold coins in a chest", "sailors on a ship", "steps to the crow's nest"],
        creativePrompts: [
            "Draw a picture of a treasure map with five landmarks.",
            "Design a friendly pirate ship.",
            "Invent a treasure that is not gold."
        ]
    )

    static let superheroes = TopicDefinition(
        id: .superheroes,
        name: "Superheroes",
        category: .fantasy,
        description: "Discover heroes who use brains, bravery, and kind hearts!",
        primaryColorName: "coralPink",
        secondaryColorName: "skyBlue",
        vocabularyWords: ["Hero", "Courage", "Rescue", "Power", "Mission"],
        scienceFacts: [
            "Real heroes include doctors, teachers, and firefighters who help others.",
            "Exercise makes muscles stronger — just like heroes train!",
            "Working as a team helps people solve big problems."
        ],
        storySettings: ["a city skyline", "a secret hideout", "a rescue scene"],
        mathContexts: ["heroes saving the day", "gadgets in a belt", "citizens to help"],
        creativePrompts: [
            "Invent a superhero who helps with reading or math.",
            "Draw a picture of your superhero costume.",
            "Create a sidekick with a funny power."
        ]
    )

    // MARK: - Vehicles & Machines

    static let airplanes = TopicDefinition(
        id: .airplanes,
        name: "Airplanes",
        category: .vehicles,
        description: "Soar through clouds and learn how planes fly!",
        primaryColorName: "skyBlue",
        secondaryColorName: "sunshineYellow",
        vocabularyWords: ["Wing", "Pilot", "Runway", "Altitude", "Cockpit"],
        scienceFacts: [
            "Airplane wings are curved so air moves faster over the top, creating lift.",
            "Pilots use radios to talk to air traffic controllers.",
            "Jet engines push air backward to move the plane forward."
        ],
        storySettings: ["a busy airport", "above the clouds", "a small airstrip"],
        mathContexts: ["passengers on a plane", "suitcases being loaded", "miles flown today"],
        creativePrompts: [
            "Design an airplane with a rainbow tail.",
            "Draw a picture of the view from a pilot's seat.",
            "Invent an airplane that carries something silly."
        ]
    )

    static let trains = TopicDefinition(
        id: .trains,
        name: "Trains",
        category: .vehicles,
        description: "Chug along tracks and explore the world by rail!",
        primaryColorName: "warmOrange",
        secondaryColorName: "deepNavy",
        vocabularyWords: ["Engine", "Track", "Station", "Conductor", "Freight"],
        scienceFacts: [
            "Trains use steel wheels on steel tracks to roll with very little friction.",
            "Maglev trains float above tracks using magnets.",
            "The longest train journeys can cross entire continents."
        ],
        storySettings: ["a mountain tunnel", "a busy station", "a bridge over a river"],
        mathContexts: ["train cars on a track", "tickets sold today", "stops on the route"],
        creativePrompts: [
            "Design a train that visits every topic you love.",
            "Draw a picture of a train station with a snack shop.",
            "Invent a train powered by something unexpected."
        ]
    )

    static let cars = TopicDefinition(
        id: .cars,
        name: "Cars",
        category: .vehicles,
        description: "Vroom into learning about cars, roads, and safe travels!",
        primaryColorName: "coralPink",
        secondaryColorName: "sunshineYellow",
        vocabularyWords: ["Engine", "Wheel", "Highway", "Mechanic", "Electric"],
        scienceFacts: [
            "Electric cars use batteries instead of gasoline for power.",
            "Seat belts keep passengers safe by holding them during sudden stops.",
            "Engineers test cars in wind tunnels to make them use less fuel."
        ],
        storySettings: ["a car wash", "a race track", "a family road trip"],
        mathContexts: ["cars in a parking lot", "miles on a trip", "wheels on vehicles"],
        creativePrompts: [
            "Draw a picture of your dream car.",
            "Invent a car that helps the environment.",
            "Design a car wash that plays music."
        ]
    )

    static let robots = TopicDefinition(
        id: .robots,
        name: "Robots",
        category: .vehicles,
        description: "Build, fix, and imagine helpful robots of the future!",
        primaryColorName: "skyBlue",
        secondaryColorName: "brightLavender",
        vocabularyWords: ["Circuit", "Sensor", "Program", "Engineer", "Battery"],
        scienceFacts: [
            "Robots use sensors to see, hear, or feel the world around them.",
            "Engineers write programs that tell robots what to do step by step.",
            "Some robots explore places too dangerous for humans, like deep oceans."
        ],
        storySettings: ["a robot workshop", "a future city", "a space rover lab"],
        mathContexts: ["robots collecting batteries", "parts on a workbench", "robots in a line"],
        creativePrompts: [
            "Describe a robot that helps your family.",
            "Draw a picture of a robot with three special tools.",
            "Invent a robot pet."
        ]
    )

    // MARK: - Arts & Creativity

    static let art = TopicDefinition(
        id: .art,
        name: "Art",
        category: .arts,
        description: "Paint, sculpt, and express yourself with colors and shapes!",
        primaryColorName: "coralPink",
        secondaryColorName: "sunshineYellow",
        vocabularyWords: ["Canvas", "Palette", "Sketch", "Sculpture", "Primary Colors"],
        scienceFacts: [
            "Mixing red and blue paint makes purple — colors combine in fun ways!",
            "Artists use shapes and lines to show feelings without words.",
            "Cave paintings from long ago tell stories about early human life."
        ],
        storySettings: ["an art studio", "a gallery wall", "a sidewalk chalk scene"],
        mathContexts: ["brushes in a cup", "shapes on a canvas", "colors on a palette"],
        creativePrompts: [
            "Draw a picture using only circles.",
            "Invent a new color and name it.",
            "Design a sculpture for your school."
        ]
    )

    static let music = TopicDefinition(
        id: .music,
        name: "Music",
        category: .arts,
        description: "Clap, sing, and discover rhythm, melody, and instruments!",
        primaryColorName: "brightLavender",
        secondaryColorName: "coralPink",
        vocabularyWords: ["Rhythm", "Melody", "Instrument", "Tempo", "Composer"],
        scienceFacts: [
            "Sound travels in waves through the air to your ears.",
            "Drums and string instruments make sound by vibrating.",
            "Learning music can help your brain with math and reading."
        ],
        storySettings: ["a concert stage", "a music classroom", "a parade with a band"],
        mathContexts: ["beats in a song", "musicians on stage", "notes on a page"],
        creativePrompts: [
            "Invent an instrument that no one has seen before.",
            "Draw a picture of a song using colors and shapes.",
            "Write lyrics for a song about your favorite topic."
        ]
    )

    static let cooking = TopicDefinition(
        id: .cooking,
        name: "Cooking",
        category: .arts,
        description: "Measure, mix, and create tasty treats in the kitchen!",
        primaryColorName: "warmOrange",
        secondaryColorName: "coralPink",
        vocabularyWords: ["Recipe", "Measure", "Ingredient", "Whisk", "Nutrition"],
        scienceFacts: [
            "Heat changes food — eggs become solid and bread turns golden brown.",
            "Measuring carefully helps recipes turn out just right.",
            "Fruits and vegetables give your body vitamins to grow strong."
        ],
        storySettings: ["a sunny kitchen", "a bakery", "a picnic being packed"],
        mathContexts: ["cupcakes on a tray", "ingredients on the counter", "minutes on the timer"],
        creativePrompts: [
            "Invent a smoothie with three fruits.",
            "Draw a picture of a recipe card for your favorite snack.",
            "Design a restaurant that serves only silly foods."
        ]
    )
}
