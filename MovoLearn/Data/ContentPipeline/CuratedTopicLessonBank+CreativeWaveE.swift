import Foundation

extension CuratedTopicLessonBank {

    // MARK: - Wave E Creative lookup

    /// Creative packs for Wave E topics (22 topics × 4 reading levels).
    /// Returns nil for topics authored in Wave C (`CuratedTopicLessonBank+Creative.swift`).
    static func waveECreativePack(topic: Topic, level: ReadingLevel) -> CreativePack? {
        switch topic {
        case .oceanAnimals: return oceanAnimalsCreative(level)
        case .planets: return planetsCreative(level)
        case .rockets: return rocketsCreative(level)
        case .soccer: return soccerCreative(level)
        case .basketball: return basketballCreative(level)
        case .cats: return catsCreative(level)
        case .princesses: return princessesCreative(level)
        case .castles: return castlesCreative(level)
        case .fairies: return fairiesCreative(level)
        case .airplanes: return airplanesCreative(level)
        case .trains: return trainsCreative(level)
        case .cars: return carsCreative(level)
        case .superheroes: return superheroesCreative(level)
        case .art: return artCreative(level)
        case .music: return musicCreative(level)
        case .cooking: return cookingCreative(level)
        case .nature: return natureCreative(level)
        case .bugs: return bugsCreative(level)
        case .weather: return weatherCreative(level)
        case .farmAnimals: return farmAnimalsCreative(level)
        case .zooAnimals: return zooAnimalsCreative(level)
        case .pirates: return piratesCreative(level)
        default: return nil
        }
    }

    // MARK: - Ocean Animals

    private static func oceanAnimalsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Tide Pool Scene",
                opening: "Cool ocean water is held among rocks in a small pool.",
                mission: "Use the inspiration. Draw one tide pool scene.",
                inspiration: "Inspiration: When the tide goes out, rocks hold small pools where tiny crabs can hide.",
                vocab: "tide pool",
                vocabDef: "A tide pool is a small pool of ocean water left among rocks.",
                fact: "Tide pools are wet homes that stay among rocks after the tide goes out.",
                prompt: "Draw a tide pool with rock edges, cool water, and one tiny crab.",
                response: .drawing,
                ending: "Your tide pool scene is a real ocean home!",
                reflection: "What animal did you hide in your tide pool?",
                fingerprint: "oceanAnimals.creative.beginner.tide-pool"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw a Dolphin Leap",
                opening: "A dolphin is ready for a joyful leap above blue waves.",
                mission: "Use the inspiration. Draw one joyful leap.",
                inspiration: "Inspiration: Dolphins can push hard with their strong tails and leap above the water for a breath of air.",
                vocab: "leap",
                vocabDef: "A leap is a strong jump up into the air.",
                fact: "Dolphins can leap above the water when their tails push hard.",
                prompt: "Draw a dolphin leaping above a wave with one splash and a clear sky.",
                response: .drawing,
                ending: "Your dolphin leap is full of energy!",
                reflection: "Where did you place the splash under the dolphin?",
                fingerprint: "oceanAnimals.creative.early.dolphin-leap"
            )
        case .growingReader:
            return waveECreative(
                title: "Design Octopus Camouflage Art",
                opening: "An octopus can blend into rock and sand.",
                mission: "Use the inspiration. Draw camouflage art.",
                inspiration: "Inspiration: Octopuses can change skin color and texture. They match rocks, sand, or coral so they are harder to see.",
                vocab: "camouflage",
                vocabDef: "Camouflage is a way of blending in so something is hard to see.",
                fact: "Octopuses can change color and texture to hide.",
                prompt: "Draw an octopus that matches rocks, sand, or coral. Show one bumpy or smooth texture that helps it hide.",
                response: .drawing,
                ending: "Your camouflage art is ready for the ocean notebook!",
                reflection: "Which texture detail made your octopus hardest to spot?",
                fingerprint: "oceanAnimals.creative.growing.octopus-camouflage"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Reef Jobs Map",
                opening: "A coral reef is busy with living jobs.",
                mission: "Use the inspiration. Write a reef jobs map plan.",
                inspiration: "Inspiration: Cleaner fish can remove tiny pests from larger fish. Coral can build hard homes. Grazing fish can clear algae so coral can grow.",
                vocab: "reef",
                vocabDef: "A reef is a rocky ocean place where coral and many animals live.",
                fact: "Different reef animals have different helpful jobs.",
                prompt: "Write a short map plan naming three reef jobs, who does each job, and one sentence on how the jobs work together.",
                response: .longText,
                ending: "Your reef jobs map is ready for a young ocean scientist!",
                reflection: "Which reef job do you think keeps coral healthiest, and why?",
                fingerprint: "oceanAnimals.creative.confident.reef-jobs"
            )
        }
    }

    // MARK: - Planets

    private static func planetsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw an Earth Poster",
                opening: "Earth is our blue and green home.",
                mission: "Use the inspiration. Draw one Earth poster.",
                inspiration: "Inspiration: From space, Earth has blue oceans, green and brown land, and swirling white clouds.",
                vocab: "Earth",
                vocabDef: "Earth is the planet where we live.",
                fact: "Earth has oceans, land, and clouds.",
                prompt: "Draw Earth as a round planet with blue oceans, land, and white clouds.",
                response: .drawing,
                ending: "Your Earth poster is a celebration of our home planet!",
                reflection: "What color did you use most for the oceans?",
                fingerprint: "planets.creative.beginner.earth-poster"
            )
        case .earlyReader:
            return waveECreative(
                title: "Sort Rocky and Giant Planets",
                opening: "Planets are different kinds of worlds.",
                mission: "Use the inspiration. Draw a sorting chart.",
                inspiration: "Inspiration: Rocky planets are smaller and solid. Giant planets are much larger and made mostly of gas.",
                vocab: "rocky",
                vocabDef: "Rocky is made of hard solid ground.",
                fact: "Some planets are rocky, and others are giant gas worlds.",
                prompt: "Draw two labeled boxes called Rocky Planets and Giant Planets with at least two planet names or pictures in each box.",
                response: .drawing,
                ending: "Your sorting chart is a clear map of two big planet groups!",
                reflection: "Which planet did you place in the rocky group?",
                fingerprint: "planets.creative.early.rocky-giant-sort"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Venus Glow Diagram",
                opening: "Venus is bright even though thick clouds hide its surface.",
                mission: "Use the inspiration. Write a glow diagram plan.",
                inspiration: "Inspiration: Venus has a thick cloud blanket that traps heat and looks bright when sunlight is reflected off the clouds.",
                vocab: "glow",
                vocabDef: "A glow is a soft bright shine.",
                fact: "Venus looks bright because sunlight is reflected from thick clouds.",
                prompt: "Write four sentences for a diagram: title, what the thick clouds do, why Venus glows, and one label you would draw.",
                response: .longText,
                ending: "Your Venus glow diagram is ready for the planet wall!",
                reflection: "Which label on your diagram teaches the most important idea?",
                fingerprint: "planets.creative.growing.venus-glow"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write an Orbit Yarn Kit Plan",
                opening: "Planets are traveling around the Sun on paths called orbits.",
                mission: "Use the inspiration. Write a yarn-kit design.",
                inspiration: "Inspiration: An orbit is a curved path. Inner planets can finish a trip around the Sun faster than outer planets because their paths are shorter.",
                vocab: "orbit",
                vocabDef: "An orbit is a curved path around another object in space.",
                fact: "Planets are traveling around the Sun on orbit paths.",
                prompt: "Write a short kit writeup naming your yarn model, three setup steps, and one sentence explaining why outer orbits take longer.",
                response: .longText,
                ending: "Your orbit yarn kit plan is ready for a classroom demo!",
                reflection: "Which step helps kids see that outer paths are longer?",
                fingerprint: "planets.creative.confident.orbit-yarn"
            )
        }
    }

    // MARK: - Rockets

    private static func rocketsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Countdown Art Card",
                opening: "A rocket is waiting for a careful countdown.",
                mission: "Use the inspiration. Draw countdown art.",
                inspiration: "Inspiration: Before launch, a countdown helps the team check that every part is ready and safe.",
                vocab: "countdown",
                vocabDef: "A countdown is counting down the seconds before something starts.",
                fact: "A countdown helps rocket teams check that everything is ready.",
                prompt: "Draw a rocket on a launch pad with big numbers from five to one.",
                response: .drawing,
                ending: "Your countdown art is launch-day ready!",
                reflection: "Which countdown number did you make the largest?",
                fingerprint: "rockets.creative.beginner.countdown-art"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Thrust Arrow Art",
                opening: "A rocket has a strong push that can lift it upward.",
                mission: "Use the inspiration. Draw thrust arrows.",
                inspiration: "Inspiration: Burning fuel makes hot gas rush downward. That push, called thrust, can send the rocket up.",
                vocab: "thrust",
                vocabDef: "Thrust is a strong push that moves something forward or up.",
                fact: "Thrust can push a rocket upward when hot gas rushes down.",
                prompt: "Draw a rocket with clear arrows for gas going down and the rocket moving up.",
                response: .drawing,
                ending: "Your thrust arrows are a real rocket science picture!",
                reflection: "Which arrow shows the rocket moving up?",
                fingerprint: "rockets.creative.early.thrust-arrows"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Rocket Stages Comic",
                opening: "Big rockets can drop empty parts as they climb.",
                mission: "Use the inspiration. Write a stages comic plan.",
                inspiration: "Inspiration: Rocket stages hold fuel. When a stage is empty, it can fall away so the next stage is lighter and can keep climbing.",
                vocab: "stage",
                vocabDef: "A stage is one part of a rocket that does a job and then may drop away.",
                fact: "Rocket stages can drop away after their fuel is used.",
                prompt: "Write four sentences for a three-panel comic: launch, empty stage falling away, and the lighter top stage climbing higher.",
                response: .longText,
                ending: "Your stages comic is ready for the rocket board!",
                reflection: "Why does dropping an empty stage help the rocket climb?",
                fingerprint: "rockets.creative.growing.stages-comic"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Launch Checklist Poster",
                opening: "Safe launches are built on careful checks.",
                mission: "Use the inspiration. Write a checklist poster plan.",
                inspiration: "Inspiration: Teams check fuel, weather, engines, and escape plans before a rocket leaves the pad.",
                vocab: "checklist",
                vocabDef: "A checklist is a list of important things to check.",
                fact: "Launch teams use checklists so people and rockets are safer.",
                prompt: "Write a short poster plan with a title, four checklist items, and one sentence explaining why checklists matter.",
                response: .longText,
                ending: "Your launch checklist poster is ready for a mission room!",
                reflection: "Which checklist item would you never skip, and why?",
                fingerprint: "rockets.creative.confident.checklist-poster"
            )
        }
    }

    // MARK: - Soccer

    private static func soccerCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Kick Force Poster",
                opening: "A soccer kick is a strong, careful push from the foot.",
                mission: "Use the inspiration. Draw a kick-force poster.",
                inspiration: "Inspiration: When a player kicks the ball, the foot pushes the ball and the ball is moved away.",
                vocab: "kick",
                vocabDef: "A kick is a strong hit with the foot.",
                fact: "A kick can push the ball so the ball is moved.",
                prompt: "Draw a player kicking a soccer ball with one arrow for the ball moving away.",
                response: .drawing,
                ending: "Your kick-force poster is a clear picture of how the ball is moved!",
                reflection: "Where did you put the arrow after the kick?",
                fingerprint: "soccer.creative.beginner.kick-poster"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw a Bounce Path",
                opening: "Soccer balls can bounce and roll on the field.",
                mission: "Use the inspiration. Draw a bounce path.",
                inspiration: "Inspiration: When a ball hits the ground, it can bounce up and then travel forward in a curved path.",
                vocab: "bounce",
                vocabDef: "Bounce is a spring back up after something is hit.",
                fact: "A soccer ball can bounce and then keep moving forward.",
                prompt: "Draw a soccer ball path with two bounces and arrows for the direction.",
                response: .drawing,
                ending: "Your bounce path is a clear map of how the ball travels!",
                reflection: "How many bounce marks did you draw on the path?",
                fingerprint: "soccer.creative.early.bounce-path"
            )
        case .growingReader:
            return waveECreative(
                title: "Design Cleat Grip Art",
                opening: "Soccer cleats can help shoes grip grass.",
                mission: "Use the inspiration. Write a cleat-grip design.",
                inspiration: "Inspiration: Cleats are small studs under the shoe. They dig into soft ground so a player can push without sliding.",
                vocab: "grip",
                vocabDef: "Grip is a firm hold that stops slipping.",
                fact: "Cleats help soccer shoes grip soft ground.",
                prompt: "Write four sentences describing your cleat design, where the studs go, how they help grip, and one place the shoes should not be worn.",
                response: .longText,
                ending: "Your cleat-grip design is ready for the sports board!",
                reflection: "Which part of your design most improves grip?",
                fingerprint: "soccer.creative.growing.cleat-grip"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write an Aiming Target Design",
                opening: "Good kicks are helped by careful aiming.",
                mission: "Use the inspiration. Write a target-practice design.",
                inspiration: "Inspiration: Players aim by looking at a target, planting a support foot, and swinging the kicking foot toward the spot they chose.",
                vocab: "aim",
                vocabDef: "Aim means to point carefully toward a chosen spot.",
                fact: "Aiming helps a kick send the ball where the player wants.",
                prompt: "Write a short target design with a target name, three aiming steps, and one sentence explaining how your target helps practice.",
                response: .longText,
                ending: "Your aiming target design is ready for real practice!",
                reflection: "Which aiming step do you think matters most?",
                fingerprint: "soccer.creative.confident.aiming-target"
            )
        }
    }

    // MARK: - Basketball

    private static func basketballCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Bounce Ball Scene",
                opening: "A basketball can bounce when it hits the floor.",
                mission: "Use the inspiration. Draw one bounce scene.",
                inspiration: "Inspiration: When a basketball hits the floor, the ball is pushed down and then springs back up into the hands.",
                vocab: "bounce",
                vocabDef: "Bounce is a spring back up after something is hit.",
                fact: "A basketball can bounce up after it hits the floor.",
                prompt: "Draw a basketball bouncing once on the floor toward waiting hands.",
                response: .drawing,
                ending: "Your bounce scene is a clear picture of how the ball returns!",
                reflection: "Where did you draw the hands catching the bounce?",
                fingerprint: "basketball.creative.beginner.bounce-scene"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw an Arc Shot",
                opening: "A shot is often traveling in a curved path.",
                mission: "Use the inspiration. Draw an arc shot.",
                inspiration: "Inspiration: A good shot rises in a curve, called an arc, then falls toward the hoop.",
                vocab: "arc",
                vocabDef: "An arc is a curved path through the air.",
                fact: "Basketball shots can follow a curved arc toward the hoop.",
                prompt: "Draw a player shooting with a curved arc path from the ball to the hoop.",
                response: .drawing,
                ending: "Your arc shot drawing is a real shooting idea!",
                reflection: "Did your arc rise high before falling toward the hoop?",
                fingerprint: "basketball.creative.early.arc-shot"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Grip Guide",
                opening: "Hands can control the basketball with a steady grip.",
                mission: "Use the inspiration. Write a grip guide.",
                inspiration: "Inspiration: Spreading the fingers and keeping the ball on the pads of the hands helps players control dribbles and passes.",
                vocab: "grip",
                vocabDef: "Grip is a firm, careful hold.",
                fact: "A steady hand grip helps control a basketball.",
                prompt: "Write four sentences naming your grip guide, how fingers spread, why pads of the hands matter, and one tip for a soft catch.",
                response: .longText,
                ending: "Your grip guide is ready for the gym wall!",
                reflection: "Which grip tip would help a new player most?",
                fingerprint: "basketball.creative.growing.grip-guide"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Court Energy Diagram",
                opening: "Players can use energy to run, jump, and pass.",
                mission: "Use the inspiration. Write a court energy diagram plan.",
                inspiration: "Inspiration: Stored energy in muscles turns into motion when a player runs or jumps. Passes and shots move energy into the ball.",
                vocab: "energy",
                vocabDef: "Energy is the power that makes things move or change.",
                fact: "Players can turn body energy into running, jumping, and ball motion.",
                prompt: "Write a short diagram writeup with a title, three labeled energy moments on the court, and one sentence explaining how energy moves to the ball.",
                response: .longText,
                ending: "Your court energy diagram is ready to teach a whole team!",
                reflection: "Which labeled moment best shows energy moving into the ball?",
                fingerprint: "basketball.creative.confident.court-energy"
            )
        }
    }

    // MARK: - Cats

    private static func catsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw Careful Cat Claws",
                opening: "Cats can use claws for climbing and holding.",
                mission: "Use the inspiration. Draw claws that can hide.",
                inspiration: "Inspiration: Many cats can pull their claws in when they walk and push them out when they climb or hold.",
                vocab: "claw",
                vocabDef: "A claw is a sharp nail on an animal's toe.",
                fact: "Cats can pull claws in and push them out when needed.",
                prompt: "Draw a cat paw with claws out for climbing and a note that claws can tuck away.",
                response: .drawing,
                ending: "Your claw picture is a real cat body lesson!",
                reflection: "Did you show claws out, tucked in, or both?",
                fingerprint: "cats.creative.beginner.claws"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Night Eyes Glow",
                opening: "Cat eyes are helpful in dim light.",
                mission: "Use the inspiration. Draw night eyes.",
                inspiration: "Inspiration: A special layer in a cat's eye can reflect light and help the cat see better in the dark.",
                vocab: "reflect",
                vocabDef: "Reflect is when light is bounced back.",
                fact: "Cats can see better in dim light because their eyes reflect light.",
                prompt: "Draw a cat face at night with glowing eyes and a soft moon nearby.",
                response: .drawing,
                ending: "Your night-eyes art is a clear picture of dim-light seeing!",
                reflection: "What color glow did you choose for the eyes?",
                fingerprint: "cats.creative.early.night-eyes"
            )
        case .growingReader:
            return waveECreative(
                title: "Draw Long Whiskers",
                opening: "Whiskers help a cat feel if a space is too tight.",
                mission: "Draw a cat using its long whiskers.",
                inspiration: "Inspiration: Whiskers are long stiff hairs. They help a cat feel the sides of a tight space. Leave them long so they can do that job.",
                vocab: "whisker",
                vocabDef: "A whisker is a long stiff hair that helps an animal feel nearby things.",
                fact: "Long whiskers help cats feel if a gap is too small.",
                prompt: "Draw a cat walking through a narrow gap. Make the whiskers long enough to touch both sides.",
                response: .drawing,
                ending: "Your picture shows how whiskers help a cat stay safe!",
                reflection: "Where did the whiskers touch in your picture?",
                fingerprint: "cats.creative.growing.whiskers"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write Quiet Paws Poster",
                opening: "Cats can walk with soft, quiet steps.",
                mission: "Use the inspiration. Write a quiet-paws poster plan.",
                inspiration: "Inspiration: Soft pads under cat paws and careful foot placement help cats walk quietly while hunting or exploring.",
                vocab: "quiet",
                vocabDef: "Quiet is when little or no sound is made.",
                fact: "Soft paw pads help cats walk quietly.",
                prompt: "Write a short poster plan with a title, three quiet-walking tips based on real cat bodies, and one sentence on why quiet steps help a cat.",
                response: .longText,
                ending: "Your quiet-paws poster is ready for young cat observers!",
                reflection: "Which quiet-walking tip came straight from a real cat body part?",
                fingerprint: "cats.creative.confident.quiet-paws"
            )
        }
    }

    // MARK: - Princesses

    private static func princessesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Garden Plant Plan",
                opening: "A kind princess is tending a useful garden.",
                mission: "Use the inspiration. Draw helpful plants.",
                inspiration: "Inspiration: Gardens grow food and flowers when people water plants, give them sunlight, and keep soil healthy.",
                vocab: "garden",
                vocabDef: "A garden is a place where people grow plants with care.",
                fact: "Plants need water, sunlight, and healthy soil to grow.",
                prompt: "Draw a garden with three plants, a watering can, and sunlight.",
                response: .drawing,
                ending: "Your garden plan is a real plant-care picture!",
                reflection: "Which plant did you give the most sunlight?",
                fingerprint: "princesses.creative.beginner.garden-plants"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Stained Glass Light",
                opening: "Colored glass can paint rooms with light.",
                mission: "Use the inspiration. Draw stained glass light.",
                inspiration: "Inspiration: Sunlight passing through colored glass can make colored patches of light on floors and walls.",
                vocab: "stained glass",
                vocabDef: "Stained glass is colored glass used in windows to shape light.",
                fact: "Colored glass can change sunlight into colored light patches.",
                prompt: "Draw a tall window of colored glass with colored light spots on the floor.",
                response: .drawing,
                ending: "Your stained glass art is a clear picture of how light can change!",
                reflection: "Which color of light did you place on the floor?",
                fingerprint: "princesses.creative.early.stained-glass"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Kind Travel Map",
                opening: "A journey can help neighboring towns.",
                mission: "Use the inspiration. Write a travel map plan.",
                inspiration: "Inspiration: Real maps show roads, rivers, and safe resting places. A helpful journey plan marks water, food, and places to share tools.",
                vocab: "map",
                vocabDef: "A map is a drawing that shows places and paths.",
                fact: "Good travel maps mark paths and useful stopping places.",
                prompt: "Write four sentences naming your map, two stops that help travelers, one river or road, and one kind act along the route.",
                response: .longText,
                ending: "Your kind travel map is ready for the castle hall!",
                reflection: "Which stop on your map helps travelers the most?",
                fingerprint: "princesses.creative.growing.map-travel"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Fair-Rules Charter",
                opening: "Fair rules can help everyone feel safe and heard.",
                mission: "Use the inspiration. Write a fair-rules charter.",
                inspiration: "Inspiration: Good community rules are clear, kind, and the same for everyone. They explain how to share, listen, and fix mistakes.",
                vocab: "charter",
                vocabDef: "A charter is a written set of important rules.",
                fact: "Fair rules work best when they are clear and apply to everyone.",
                prompt: "Write a short charter with a title, four fair rules, and one sentence explaining how the rules keep people safe and kind.",
                response: .longText,
                ending: "Your fair-rules charter is ready to guide a real community!",
                reflection: "Which rule in your charter protects kindness the best?",
                fingerprint: "princesses.creative.confident.fair-rules"
            )
        }
    }

    // MARK: - Castles

    private static func castlesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Strong Stone Wall",
                opening: "Castle walls were built to be thick and strong.",
                mission: "Use the inspiration. Draw a stone wall.",
                inspiration: "Inspiration: Builders stacked heavy stones carefully so walls could stand tall and stay sturdy.",
                vocab: "stone",
                vocabDef: "Stone is a hard piece of rock used in building.",
                fact: "Thick stone walls helped castles stay strong.",
                prompt: "Draw a castle wall made of stacked stones with one tall tower.",
                response: .drawing,
                ending: "Your stone wall is sturdy and real!",
                reflection: "How many stone rows did you stack in the wall?",
                fingerprint: "castles.creative.beginner.stone-wall"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw a Strong Arch",
                opening: "Arches can help doorways hold weight.",
                mission: "Use the inspiration. Draw an arch.",
                inspiration: "Inspiration: An arch is a curved doorway shape. The stones push against each other so the opening can hold weight above it.",
                vocab: "arch",
                vocabDef: "An arch is a curved opening that can hold weight above it.",
                fact: "Arches help castle doorways hold the weight above them.",
                prompt: "Draw a castle doorway with a clear arch and stones meeting at the top.",
                response: .drawing,
                ending: "Your arch drawing is a real building idea!",
                reflection: "Where did the stones meet at the top of your arch?",
                fingerprint: "castles.creative.early.arch"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Drawbridge Lever",
                opening: "A drawbridge can rise and lower with a lever system.",
                mission: "Use the inspiration. Write a lever design.",
                inspiration: "Inspiration: A lever uses a long bar and a turning point so a smaller push can lift a heavy bridge.",
                vocab: "lever",
                vocabDef: "A lever is a bar that turns on a point to help lift or move something.",
                fact: "Levers help people lift heavy drawbridges with less force.",
                prompt: "Write four sentences naming your drawbridge, where the lever turns, how chains or ropes help, and one safety rule while the bridge moves.",
                response: .longText,
                ending: "Your drawbridge lever design is ready for the builder board!",
                reflection: "Which part of your design makes lifting easier?",
                fingerprint: "castles.creative.growing.drawbridge-lever"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Moat Plan",
                opening: "A moat is water around a castle for protection.",
                mission: "Use the inspiration. Write a moat plan.",
                inspiration: "Inspiration: Moats used water as a barrier. Builders also planned bridges, banks, and ways to keep the water from flooding rooms.",
                vocab: "moat",
                vocabDef: "A moat is a water-filled ditch around a castle.",
                fact: "Moats used water as a protective barrier around castles.",
                prompt: "Write a short moat plan with a name, three design choices, and one sentence explaining how your plan keeps the castle safer without flooding rooms.",
                response: .longText,
                ending: "Your moat plan is ready for a careful castle builder!",
                reflection: "Which design choice best keeps rooms dry?",
                fingerprint: "castles.creative.confident.moat-plan"
            )
        }
    }

    // MARK: - Fairies

    private static func fairiesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Seed Parachute",
                opening: "Some seeds can travel on the wind.",
                mission: "Use the inspiration. Draw a seed parachute.",
                inspiration: "Inspiration: For a fairies nature art board, dandelion seeds have fluffy tops that act like tiny parachutes so the wind can carry them to new soil.",
                vocab: "seed",
                vocabDef: "A seed is a tiny part that can grow into a new plant.",
                fact: "Fluffy seed tops help some seeds ride the wind.",
                prompt: "Draw a seed with a fluffy parachute top floating above grass.",
                response: .drawing,
                ending: "Your seed parachute is a real nature trick!",
                reflection: "What color did you choose for the fluffy parachute?",
                fingerprint: "fairies.creative.beginner.seed-parachute"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Firefly Light Art",
                opening: "Fireflies can make their own soft light.",
                mission: "Use the inspiration. Draw firefly light.",
                inspiration: "Inspiration: For a fairies light study, fireflies can make light in their bodies with a special chemical reaction. The glow helps them find one another.",
                vocab: "glow",
                vocabDef: "A glow is a soft light that shines.",
                fact: "Fireflies can make soft light inside their bodies.",
                prompt: "Draw three fireflies glowing above evening grass with soft light circles.",
                response: .drawing,
                ending: "Your firefly art is real living light!",
                reflection: "How many glowing circles did you add around the fireflies?",
                fingerprint: "fairies.creative.early.firefly-light"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Wing Shape Study",
                opening: "Insect wings are thin, strong, and shaped for flight.",
                mission: "Use the inspiration. Write a wing design plan.",
                inspiration: "Inspiration: For a fairies wing study, many insect wings are thin with strong veins. The shape helps lift and balance while the insect flies.",
                vocab: "vein",
                vocabDef: "A vein is a thin line that strengthens a leaf or wing.",
                fact: "Insect wings can use thin strong veins to stay light and sturdy.",
                prompt: "Write four sentences describing your wing study: wing shape, vein pattern, how the shape helps flight, and one material you would use in a model.",
                response: .longText,
                ending: "Your wing shape study is ready for a nature notebook!",
                reflection: "Which vein detail makes your wing model strongest?",
                fingerprint: "fairies.creative.growing.wing-study"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Pollen Path Plan",
                opening: "Pollen can travel from flower to flower.",
                mission: "Use the inspiration. Write a pollen path plan.",
                inspiration: "Inspiration: For a fairies garden path, bees and other insects can brush pollen onto their bodies and carry it to the next flower, helping plants make seeds.",
                vocab: "pollen",
                vocabDef: "Pollen is tiny powder from flowers that helps make seeds.",
                fact: "Insects can carry pollen from one flower to another.",
                prompt: "Write a short path plan naming two flowers, one insect helper, three steps of pollen travel, and why the path helps plants.",
                response: .longText,
                ending: "Your pollen path plan is ready for a garden science walk!",
                reflection: "Which step in your path best shows how plants get help?",
                fingerprint: "fairies.creative.confident.pollen-path"
            )
        }
    }

    // MARK: - Airplanes

    private static func airplanesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Lift Wing",
                opening: "Airplane wings can help lift the plane into the air.",
                mission: "Use the inspiration. Draw a lift wing.",
                inspiration: "Inspiration: Air moving over and under a wing helps create lift, the upward force that helps a plane fly.",
                vocab: "lift",
                vocabDef: "Lift is an upward force that helps something rise.",
                fact: "Wings help create lift so airplanes can fly.",
                prompt: "Draw an airplane wing with arrows for air moving and the plane lifting up.",
                response: .drawing,
                ending: "Your lift wing drawing is a real flight idea!",
                reflection: "Which arrow shows the plane lifting up?",
                fingerprint: "airplanes.creative.beginner.lift-wing"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Thrust Force Art",
                opening: "Engines can push an airplane forward.",
                mission: "Use the inspiration. Draw thrust force.",
                inspiration: "Inspiration: Engines create thrust, a forward push. When thrust is strong enough, the plane can move down the runway and into the air.",
                vocab: "thrust",
                vocabDef: "Thrust is a strong push that moves something forward.",
                fact: "Airplane engines can create thrust that pushes the plane forward.",
                prompt: "Draw an airplane with clear arrows for forward thrust and moving air behind the engines.",
                response: .drawing,
                ending: "Your thrust art is a clear picture of what pushes a plane ahead!",
                reflection: "Where did you place the thrust arrows?",
                fingerprint: "airplanes.creative.early.thrust"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Flight Path Map",
                opening: "Planes can follow planned paths through the sky.",
                mission: "Use the inspiration. Write a flight path plan.",
                inspiration: "Inspiration: Pilots and planners choose routes that avoid storms, save fuel when possible, and keep planes safely spaced.",
                vocab: "route",
                vocabDef: "A route is a planned path from one place to another.",
                fact: "Flight routes are planned for safety and clear spacing.",
                prompt: "Write four sentences naming your flight path, start and end cities, one weather check, and one safety spacing idea.",
                response: .longText,
                ending: "Your flight path map is ready for the control board!",
                reflection: "Which safety choice on your route matters most?",
                fingerprint: "airplanes.creative.growing.flight-path"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Cockpit Checklist",
                opening: "Pilots can use checklists before every flight.",
                mission: "Use the inspiration. Write a cockpit checklist writeup.",
                inspiration: "Inspiration: Cockpit checklists help pilots check fuel, flaps, weather, and instruments before takeoff.",
                vocab: "checklist",
                vocabDef: "A checklist is a list of important steps to check.",
                fact: "Pilots can use checklists to make takeoffs safer.",
                prompt: "Write a short checklist writeup with a title, five items, and one sentence explaining why skipping steps is unsafe.",
                response: .longText,
                ending: "Your cockpit checklist is ready beside a training simulator!",
                reflection: "Which checklist item would you check first, and why?",
                fingerprint: "airplanes.creative.confident.cockpit-checklist"
            )
        }
    }

    // MARK: - Trains

    private static func trainsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw Wheels on Tracks",
                opening: "Train wheels are riding on steel tracks.",
                mission: "Use the inspiration. Draw wheels and tracks.",
                inspiration: "Inspiration: Train wheels have a special shape that keeps them on steel rails so the train stays on the track.",
                vocab: "track",
                vocabDef: "A track is a pair of rails that guide train wheels.",
                fact: "Train wheels ride on tracks that guide the train.",
                prompt: "Draw a train with wheels sitting firmly on two rails.",
                response: .drawing,
                ending: "Your wheels-and-tracks picture is real train travel!",
                reflection: "Did both rails sit under the train wheels?",
                fingerprint: "trains.creative.beginner.wheels-tracks"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Train Energy Art",
                opening: "Trains need energy to move heavy cars.",
                mission: "Use the inspiration. Draw train energy.",
                inspiration: "Inspiration: Engines turn fuel or electricity into motion energy that pulls many train cars along the track.",
                vocab: "energy",
                vocabDef: "Energy is the power that makes things move or change.",
                fact: "Train engines can turn energy into motion to pull cars.",
                prompt: "Draw an engine pulling cars with one arrow for energy becoming motion.",
                response: .drawing,
                ending: "Your energy art is a clear picture of what makes a train move!",
                reflection: "Where did you place the arrow for motion?",
                fingerprint: "trains.creative.early.energy"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Station Map",
                opening: "Stations can help people board and leave safely.",
                mission: "Use the inspiration. Write a station map plan.",
                inspiration: "Inspiration: Good stations mark platforms, waiting areas, exits, and clear paths so crowds move safely.",
                vocab: "platform",
                vocabDef: "A platform is the raised place beside the tracks where people wait.",
                fact: "Station platforms can give people a safe place to wait for trains.",
                prompt: "Write four sentences naming your station, two labeled areas, one safe walking path, and one rule for staying behind the platform edge.",
                response: .longText,
                ending: "Your station map is ready to guide real travelers!",
                reflection: "Which labeled area keeps waiting passengers safest?",
                fingerprint: "trains.creative.growing.station-map"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Momentum Safety Poster",
                opening: "Heavy trains need long distances to stop.",
                mission: "Use the inspiration. Write a momentum safety poster.",
                inspiration: "Inspiration: A moving train has momentum, so it cannot stop instantly. Safety signs and long braking distances protect people near tracks.",
                vocab: "momentum",
                vocabDef: "Momentum is the push a moving object keeps as it travels.",
                fact: "Heavy moving trains need long distances to stop safely.",
                prompt: "Write a short poster plan with a title, three safety rules near tracks, and one sentence explaining why trains need long stopping room.",
                response: .longText,
                ending: "Your momentum safety poster is ready to protect people near tracks!",
                reflection: "Which safety rule connects most clearly to momentum?",
                fingerprint: "trains.creative.confident.momentum-safety"
            )
        }
    }

    // MARK: - Cars

    private static func carsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw Rolling Wheels",
                opening: "Car wheels can roll to move the car.",
                mission: "Use the inspiration. Draw rolling wheels.",
                inspiration: "Inspiration: Round car wheels can roll smoothly so a car can move with less rubbing against the road.",
                vocab: "wheel",
                vocabDef: "A wheel is a round part that rolls to help a vehicle move.",
                fact: "Round wheels help cars roll along the road.",
                prompt: "Draw a car with four round wheels and one arrow for rolling motion.",
                response: .drawing,
                ending: "Your rolling wheels picture is a clear map of how cars move!",
                reflection: "Which arrow shows the wheels rolling?",
                fingerprint: "cars.creative.beginner.wheels"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Brake Force Art",
                opening: "Brakes can slow a car by making a stopping force.",
                mission: "Use the inspiration. Draw brake force.",
                inspiration: "Inspiration: When a driver presses the car brake, pads can press on the wheels and create force that slows the car.",
                vocab: "brake",
                vocabDef: "A brake is a part that slows or stops a vehicle.",
                fact: "Brakes can create force that slows the wheels and the car.",
                prompt: "Draw a car slowing down with arrows for brake force at the wheels.",
                response: .drawing,
                ending: "Your brake force art is a real safety idea!",
                reflection: "Where did you place the brake-force arrows?",
                fingerprint: "cars.creative.early.brakes"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Seatbelt Force Poster",
                opening: "Seatbelts can protect riders when a car stops suddenly.",
                mission: "Use the inspiration. Write a seatbelt poster plan.",
                inspiration: "Inspiration: If cars stop quickly, riders keep moving forward unless a seatbelt can hold them safely in place.",
                vocab: "force",
                vocabDef: "Force is a push or pull that can change motion.",
                fact: "Seatbelts can hold riders safely when a car stops suddenly.",
                prompt: "Write four sentences explaining your poster title, what happens without a belt, how the belt holds a rider, and one rule for buckling up.",
                response: .longText,
                ending: "Your seatbelt force poster is ready for a safety classroom!",
                reflection: "Which sentence best explains why the belt must hold the rider?",
                fingerprint: "cars.creative.growing.seatbelt-force"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Fuel Energy Guide",
                opening: "Cars need energy to move.",
                mission: "Use the inspiration. Write a simplified fuel-energy guide.",
                inspiration: "Inspiration: Fuel or battery energy is stored in the car. Engines or motors can change that stored energy into motion for the car wheels.",
                vocab: "fuel",
                vocabDef: "Fuel is a stored energy source that can power a machine.",
                fact: "Cars can change stored fuel or battery energy into wheel motion.",
                prompt: "Write a short guide with a title, three energy steps from storage to motion, and one sentence comparing fuel and battery power in simple words.",
                response: .longText,
                ending: "Your fuel energy guide is ready for young engineers!",
                reflection: "Which energy step shows storage turning into motion?",
                fingerprint: "cars.creative.confident.fuel-energy"
            )
        }
    }

    // MARK: - Superheroes

    private static func superheroesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Strong Material Gadget",
                opening: "A helper gadget can be made of a strong material.",
                mission: "Use the inspiration. Draw one strong gadget.",
                inspiration: "Inspiration: Real tools use strong materials like metal or thick plastic so they do not break during hard jobs.",
                vocab: "material",
                vocabDef: "Material is what something is made from.",
                fact: "Strong materials help tools last during hard jobs.",
                prompt: "Draw a helper gadget and label the strong material it is made from.",
                response: .drawing,
                ending: "Your strong material gadget is ready for a helpful mission!",
                reflection: "Which strong material did you choose for your gadget?",
                fingerprint: "superheroes.creative.beginner.material-gadget"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw a Lever Helper Tool",
                opening: "Levers can help people lift heavy things.",
                mission: "Use the inspiration. Draw a lever tool.",
                inspiration: "Inspiration: A lever is a bar that turns on a point. A small push on the long end can lift a heavier load on the short end.",
                vocab: "lever",
                vocabDef: "A lever is a bar that turns on a point to help lift something.",
                fact: "Levers help people lift heavy loads with less force.",
                prompt: "Draw a lever tool lifting a heavy box with the turning point marked clearly.",
                response: .drawing,
                ending: "Your lever tool is a real science helper idea!",
                reflection: "Where did you mark the turning point on your lever?",
                fingerprint: "superheroes.creative.early.lever-tool"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Sensor Gadget",
                opening: "Sensors can help people notice important changes.",
                mission: "Use the inspiration. Write a sensor gadget plan.",
                inspiration: "Inspiration: Real sensors can detect heat, light, sound, or motion and send a signal so people can respond safely.",
                vocab: "sensor",
                vocabDef: "A sensor is a device that notices a change and sends a signal.",
                fact: "Sensors can notice changes like heat, light, sound, or motion.",
                prompt: "Write four sentences naming your sensor gadget, what it detects, how it warns people, and one helpful rescue use.",
                response: .longText,
                ending: "Your sensor gadget plan is ready for the inventor lab!",
                reflection: "What change does your sensor notice first?",
                fingerprint: "superheroes.creative.growing.sensor-gadget"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Force Training Poster",
                opening: "Training can build strength and control safely.",
                mission: "Use the inspiration. Write a force training poster.",
                inspiration: "Inspiration: Practice with careful form helps muscles apply force safely. Warm-ups, rest, and good technique protect the body.",
                vocab: "force",
                vocabDef: "Force is a push or pull that can move something.",
                fact: "Careful training helps people apply force safely and with control.",
                prompt: "Write a short poster plan with a title, three safe training tips, and one sentence explaining how good technique protects the body.",
                response: .longText,
                ending: "Your force training poster is ready for a real practice room!",
                reflection: "Which training tip best protects the body while building strength?",
                fingerprint: "superheroes.creative.confident.force-training"
            )
        }
    }

    // MARK: - Art

    private static func artCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Color Mix Chart",
                opening: "Mixing colors can make new colors.",
                mission: "Use the inspiration. Draw a color mix.",
                inspiration: "Inspiration: Mixing yellow and blue can make green. Mixing red and yellow can make orange.",
                vocab: "mix",
                vocabDef: "Mix is when things are stirred together.",
                fact: "Mixing two colors can make a new color.",
                prompt: "Draw two paint puddles mixing into a new color with labels for the colors you used.",
                response: .drawing,
                ending: "Your color mix chart is a real art science idea!",
                reflection: "Which new color did your mix create?",
                fingerprint: "art.creative.beginner.color-mix"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Light Reflection Art",
                opening: "Smooth shiny surfaces can bounce light.",
                mission: "Use the inspiration. Draw reflection.",
                inspiration: "Inspiration: Light can bounce off a shiny surface and travel to your eyes so you see a reflection.",
                vocab: "reflect",
                vocabDef: "Reflect is when light is bounced back.",
                fact: "Shiny surfaces can reflect light so we see reflections.",
                prompt: "Draw a shiny circle reflecting a window with a light arrow bouncing off it.",
                response: .drawing,
                ending: "Your reflection art is a clear picture of how light can bounce!",
                reflection: "Where did the light arrow bounce in your drawing?",
                fingerprint: "art.creative.early.light-reflection"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Pigment Poster",
                opening: "Pigments can give paint its color.",
                mission: "Use the inspiration. Write a pigment poster plan.",
                inspiration: "Inspiration: Pigments are tiny colored particles. When mixed into paint, they give the paint its color.",
                vocab: "pigment",
                vocabDef: "Pigment is made of tiny colored particles that give paint its color.",
                fact: "Pigments are the colored bits that make paint colorful.",
                prompt: "Write four sentences naming your poster, what pigment is, one paint color example, and why stirring pigment evenly matters.",
                response: .longText,
                ending: "Your pigment poster is ready for the art studio wall!",
                reflection: "Which sentence best explains what pigment does?",
                fingerprint: "art.creative.growing.pigment"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Warm and Cool Gallery Plan",
                opening: "Warm and cool colors can change a picture's feeling.",
                mission: "Use the inspiration. Write a gallery plan.",
                inspiration: "Inspiration: Warm colors like red and orange can feel energetic. Cool colors like blue and green can feel calm. Artists choose them on purpose.",
                vocab: "gallery",
                vocabDef: "A gallery is a place that shows artwork for people to view.",
                fact: "Warm and cool colors can change how a picture feels.",
                prompt: "Write a short gallery plan with a title, two warm-color artworks, two cool-color artworks, and one sentence explaining the feeling you want visitors to notice.",
                response: .longText,
                ending: "Your warm and cool gallery plan is ready for a real exhibit!",
                reflection: "Which artwork pair best shows the feeling contrast?",
                fingerprint: "art.creative.confident.warm-cool-gallery"
            )
        }
    }

    // MARK: - Music

    private static func musicCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Vibration Sound Scene",
                opening: "Sound often begins with a vibration.",
                mission: "Use the inspiration. Draw vibration.",
                inspiration: "Inspiration: When a drum skin shakes, it vibrates the air and we hear a sound.",
                vocab: "vibrate",
                vocabDef: "Vibrate is when something shakes back and forth quickly.",
                fact: "Vibrating objects can make sounds we hear.",
                prompt: "Draw a drum being tapped with tiny vibration lines in the air.",
                response: .drawing,
                ending: "Your vibration scene is a clear picture of how sound can begin!",
                reflection: "Where did you put the vibration lines?",
                fingerprint: "music.creative.beginner.vibration"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw High and Low Pitch",
                opening: "Pitch tells whether a sound is high or low.",
                mission: "Use the inspiration. Draw pitch.",
                inspiration: "Inspiration: A short tight string can make a higher pitch. A longer looser string can make a lower pitch.",
                vocab: "pitch",
                vocabDef: "Pitch is how high or low a sound is.",
                fact: "String length and tightness can change pitch.",
                prompt: "Draw two strings, one short and one long, with labels for high pitch and low pitch.",
                response: .drawing,
                ending: "Your pitch drawing is a real music science idea!",
                reflection: "Which string did you label as high pitch?",
                fingerprint: "music.creative.early.pitch"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Volume Control Chart",
                opening: "Volume is how loud or soft a sound is.",
                mission: "Use the inspiration. Write a volume chart plan.",
                inspiration: "Inspiration: Hitting a drum harder can make a louder volume. Touching it gently makes a softer sound.",
                vocab: "volume",
                vocabDef: "Volume is how loud or soft a sound is.",
                fact: "Stronger vibrations can make louder volume.",
                prompt: "Write four sentences naming your chart, one loud action, one soft action, and one place where soft volume is kind.",
                response: .longText,
                ending: "Your volume control chart is ready for the music room!",
                reflection: "Where would soft volume matter most in your chart?",
                fingerprint: "music.creative.growing.volume"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write an Instrument Material Guide",
                opening: "Materials can change how instruments sound.",
                mission: "Use the inspiration. Write a material guide.",
                inspiration: "Inspiration: Wood, metal, and stretched skin vibrate differently. Material choice changes tone and loudness.",
                vocab: "material",
                vocabDef: "Material is what something is made from.",
                fact: "Instrument materials can change the sound when they vibrate.",
                prompt: "Write a short guide with a title, three instrument materials, how each might sound, and one sentence on choosing a material for a soft tone.",
                response: .longText,
                ending: "Your instrument material guide is ready for young builders!",
                reflection: "Which material would you choose for the softest tone, and why?",
                fingerprint: "music.creative.confident.instrument-material"
            )
        }
    }

    // MARK: - Cooking

    private static func cookingCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Heat Change Scene",
                opening: "Heat can change food.",
                mission: "Use the inspiration. Draw a heat change.",
                inspiration: "Inspiration: Heat can melt butter, warm soup, and turn batter firmer as it cooks.",
                vocab: "heat",
                vocabDef: "Heat is warmth that can change food.",
                fact: "Heat can change how food looks and feels.",
                prompt: "Draw a pan with food changing as heat warms it, and label before and after.",
                response: .drawing,
                ending: "Your heat change scene is real kitchen science!",
                reflection: "What food did you show changing with heat?",
                fingerprint: "cooking.creative.beginner.heat-change"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw a Measuring Tools Card",
                opening: "Cooking can use careful measuring.",
                mission: "Use the inspiration. Draw measuring tools.",
                inspiration: "Inspiration: Cups and spoons help cooks measure the same amount each time so recipes work.",
                vocab: "measure",
                vocabDef: "Measure means to find out how much of something there is.",
                fact: "Measuring tools help cooks use the right amounts.",
                prompt: "Draw two measuring tools with labels and one bowl waiting for ingredients.",
                response: .drawing,
                ending: "Your measuring card is ready for a kitchen helper!",
                reflection: "Which measuring tool did you draw first?",
                fingerprint: "cooking.creative.early.measuring"
            )
        case .growingReader:
            return waveECreative(
                title: "Draw Sugar Mixing in Water",
                opening: "Sugar can mix into water until you cannot see the bits.",
                mission: "Draw sugar dissolving in a cup of water.",
                inspiration: "Inspiration: Sugar can dissolve in warm water. The bits seem to disappear, but the sugar is still in the water.",
                vocab: "dissolve",
                vocabDef: "Dissolve means a solid mixes into a liquid until you cannot see the bits.",
                fact: "Sugar can dissolve in water and stay in the liquid.",
                prompt: "Draw a cup of water. Show sugar going in. Then show the water after the sugar mixes in.",
                response: .drawing,
                ending: "You showed how sugar mixes into water!",
                reflection: "What happened to the sugar in your picture?",
                fingerprint: "cooking.creative.growing.dissolving"
            )
        case .confidentReader:
            return waveECreative(
                title: "Draw Ice, Water, and Steam",
                opening: "Heat can change ice into water, and water into steam.",
                mission: "Draw ice, water, and steam.",
                inspiration: "Inspiration: Ice is solid water. Melting makes liquid water. Boiling can make steam, a gas.",
                vocab: "state",
                vocabDef: "A state is the form matter takes, such as solid, liquid, or gas.",
                fact: "Cooking can change matter between solid, liquid, and gas forms.",
                prompt: "Draw three pictures in a row: ice, melted water, and steam. Label each one.",
                response: .drawing,
                ending: "You showed how water can change form!",
                reflection: "Which picture shows steam?",
                fingerprint: "cooking.creative.confident.states-recipe"
            )
        }
    }

    // MARK: - Nature

    private static func natureCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Habitat Home",
                opening: "A habitat is a living place with what animals need.",
                mission: "Use the inspiration. Draw one habitat.",
                inspiration: "Inspiration: A nature habitat can give animals food, water, shelter, and space to live.",
                vocab: "habitat",
                vocabDef: "A habitat is a place where a plant or animal lives and finds what it needs.",
                fact: "Habitats can give animals food, water, shelter, and space.",
                prompt: "Draw a habitat with one animal, one food source, and one shelter.",
                response: .drawing,
                ending: "Your habitat home is a clear picture of what a living place needs!",
                reflection: "What shelter did you give your animal?",
                fingerprint: "nature.creative.beginner.habitat"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw a Season Change Scene",
                opening: "Seasons can change light, temperature, and plant life.",
                mission: "Use the inspiration. Draw a season scene.",
                inspiration: "Inspiration: In nature, trees can grow green leaves in warm seasons and drop leaves when days get cooler and shorter.",
                vocab: "season",
                vocabDef: "A season is a time of year with its own weather pattern.",
                fact: "Seasons can change leaves, light, and temperature.",
                prompt: "Draw one tree in two season boxes labeled leafy and bare.",
                response: .drawing,
                ending: "Your season scene is a real nature pattern!",
                reflection: "Which season box shows the leafy tree?",
                fingerprint: "nature.creative.early.season"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Soil Layers Card",
                opening: "Healthy soil has layers and living helpers.",
                mission: "Use the inspiration. Write a soil card plan.",
                inspiration: "Inspiration: Topsoil has nutrients for plants. Deeper layers may be denser. Worms and tiny living things help mix and enrich soil.",
                vocab: "soil",
                vocabDef: "Soil is the ground material plants grow in.",
                fact: "Healthy soil has nutrients and living helpers for plants.",
                prompt: "Write four sentences naming your soil card, two layers, one living helper, and why plants need healthy soil.",
                response: .longText,
                ending: "Your soil layers card is ready for a garden notebook!",
                reflection: "Which living helper did you include in the soil?",
                fingerprint: "nature.creative.growing.soil"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Plant Water Path Plan",
                opening: "Water can travel through plants.",
                mission: "Use the inspiration. Write a plant water path.",
                inspiration: "Inspiration: Roots can take in water. Tiny tubes can carry water up the stem to leaves, where plants use water for growth.",
                vocab: "root",
                vocabDef: "A root is the part of a plant that grows in soil and takes in water.",
                fact: "Roots take in water that travels up to leaves.",
                prompt: "Write a short path plan with a title, three labeled stops for water travel, and one sentence explaining why roots matter.",
                response: .longText,
                ending: "Your plant water path is ready for a science walk!",
                reflection: "Which stop on the path shows water entering the plant?",
                fingerprint: "nature.creative.confident.plant-water"
            )
        }
    }

    // MARK: - Bugs

    private static func bugsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Six-Leg Bug",
                opening: "Insects have six legs.",
                mission: "Use the inspiration. Draw one insect.",
                inspiration: "Inspiration: True insects have six legs. Counting legs helps scientists tell insects from spiders.",
                vocab: "insect",
                vocabDef: "An insect is a small animal with six legs.",
                fact: "Insects have six legs.",
                prompt: "Draw an insect with six clearly counted legs and one antenna pair.",
                response: .drawing,
                ending: "Your six-leg bug is a real insect fact!",
                reflection: "Did you count six legs on your insect?",
                fingerprint: "bugs.creative.beginner.six-legs"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw an Exoskeleton Shield",
                opening: "Many bugs have a hard outer skeleton.",
                mission: "Use the inspiration. Draw an exoskeleton.",
                inspiration: "Inspiration: An exoskeleton is a hard outer covering that protects a bug's soft body and gives it shape.",
                vocab: "exoskeleton",
                vocabDef: "An exoskeleton is a hard outer covering that protects a bug's body.",
                fact: "An exoskeleton can protect a bug like a hard suit of armor.",
                prompt: "Draw a beetle with a labeled hard outer shell and a soft body note underneath.",
                response: .drawing,
                ending: "Your exoskeleton art is a clear picture of how bugs stay protected!",
                reflection: "Where did you place the exoskeleton label?",
                fingerprint: "bugs.creative.early.exoskeleton"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Pollination Poster",
                opening: "Some bugs can help flowers make seeds.",
                mission: "Use the inspiration. Write a pollination poster plan.",
                inspiration: "Inspiration: Bees and butterflies can carry pollen from flower to flower as they sip nectar, helping plants make seeds.",
                vocab: "pollination",
                vocabDef: "Pollination is moving pollen so plants can make seeds.",
                fact: "Bug helpers can move pollen between flowers.",
                prompt: "Write four sentences naming your poster, one bug helper, how pollen moves, and why flowers benefit.",
                response: .longText,
                ending: "Your pollination poster is ready for a garden classroom!",
                reflection: "Which detail best shows how pollen moves?",
                fingerprint: "bugs.creative.growing.pollination"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write Metamorphosis Stages Art",
                opening: "Some insects can change form as they grow.",
                mission: "Use the inspiration. Write a stages art plan.",
                inspiration: "Inspiration: A butterfly grows through stages: egg, caterpillar, chrysalis, and adult butterfly. Each stage looks different.",
                vocab: "metamorphosis",
                vocabDef: "Metamorphosis is a big change in body form as an animal grows.",
                fact: "Butterflies change through egg, caterpillar, chrysalis, and adult stages.",
                prompt: "Write a short stages art plan naming all four stages in order and one detail to draw for each stage.",
                response: .longText,
                ending: "Your metamorphosis stages plan is ready for a science gallery!",
                reflection: "Which stage looks most different from the adult, and why?",
                fingerprint: "bugs.creative.confident.metamorphosis"
            )
        }
    }

    // MARK: - Weather

    private static func weatherCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Cloud Shapes Card",
                opening: "Clouds are made of tiny water drops.",
                mission: "Use the inspiration. Draw clouds.",
                inspiration: "Inspiration: Clouds are formed when tiny water drops gather in the air. Different shapes can hint at different weather.",
                vocab: "cloud",
                vocabDef: "A cloud is a group of tiny water drops floating in the air.",
                fact: "Clouds are made of tiny water drops in the air.",
                prompt: "Draw two cloud shapes and label them with soft gray or white colors.",
                response: .drawing,
                ending: "Your cloud card is a clear picture of what clouds are made of!",
                reflection: "Which cloud shape did you draw first?",
                fingerprint: "weather.creative.beginner.cloud"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Wind Direction Art",
                opening: "Wind is moving air.",
                mission: "Use the inspiration. Draw wind.",
                inspiration: "Inspiration: Weather wind can push flags, leaves, and clouds in the same direction as the moving air.",
                vocab: "wind",
                vocabDef: "Wind is moving air.",
                fact: "Wind is air that moves and can push things.",
                prompt: "Draw a flag and leaves blowing the same way with one wind arrow.",
                response: .drawing,
                ending: "Your wind art is a clear picture of the direction of moving air!",
                reflection: "Which way does your wind arrow point?",
                fingerprint: "weather.creative.early.wind"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Rain Cycle Diagram",
                opening: "Water can travel in a cycle through air and land.",
                mission: "Use the inspiration. Write a rain cycle plan.",
                inspiration: "Inspiration: In the weather rain cycle, water can evaporate into the air, form clouds, fall as rain, and return to rivers and oceans.",
                vocab: "cycle",
                vocabDef: "A cycle is a pattern that repeats again and again.",
                fact: "The rain cycle moves water between land, air, and clouds.",
                prompt: "Write four sentences naming your diagram, three cycle steps in order, and why the pattern can repeat.",
                response: .longText,
                ending: "Your rain cycle diagram is ready for the weather board!",
                reflection: "Which cycle step returns water to the ground?",
                fingerprint: "weather.creative.growing.rain-cycle"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Storm Safety Kit Plan",
                opening: "Storms need careful safety plans.",
                mission: "Use the inspiration. Write a storm safety kit writeup.",
                inspiration: "Inspiration: A good weather storm kit may include a flashlight, water, a radio, and a clear indoor meeting place away from windows.",
                vocab: "safety",
                vocabDef: "Safety means actions and tools that help keep people from harm.",
                fact: "Storm safety kits help families prepare before weather turns severe.",
                prompt: "Write a short kit plan with a title, four items, one indoor meeting place rule, and one sentence explaining why planning early helps.",
                response: .longText,
                ending: "Your storm safety kit plan is ready to help a real family prepare!",
                reflection: "Which kit item would you pack first, and why?",
                fingerprint: "weather.creative.confident.storm-safety"
            )
        }
    }

    // MARK: - Farm Animals

    private static func farmAnimalsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Milk Mammal Scene",
                opening: "Cows are mammals that make milk.",
                mission: "Use the inspiration. Draw a milk mammal.",
                inspiration: "Inspiration: Mammals feed their babies milk. Dairy cows make milk that people can drink after careful farming care.",
                vocab: "mammal",
                vocabDef: "A mammal is an animal that feeds its babies milk.",
                fact: "Cows are mammals that make milk for their babies.",
                prompt: "Draw a cow and a calf with a soft milk label nearby.",
                response: .drawing,
                ending: "Your milk mammal scene is a real farm fact!",
                reflection: "Did you include both the cow and the calf?",
                fingerprint: "farmAnimals.creative.beginner.milk-mammal"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw an Egg Nest Card",
                opening: "Many farm birds can lay eggs.",
                mission: "Use the inspiration. Draw an egg nest.",
                inspiration: "Inspiration: Hens can lay eggs in nests. Warm, clean nests help keep eggs safe until they are collected.",
                vocab: "nest",
                vocabDef: "A nest is a soft place birds make for eggs.",
                fact: "Hens lay eggs in nests that need to stay clean and safe.",
                prompt: "Draw a hen beside a nest with two eggs and clean straw.",
                response: .drawing,
                ending: "Your egg nest card is careful farm care!",
                reflection: "How many eggs did you place in the nest?",
                fingerprint: "farmAnimals.creative.early.egg-nest"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Plant Eater Menu",
                opening: "Some farm animals can eat plants.",
                mission: "Use the inspiration. Write a plant-eater menu.",
                inspiration: "Inspiration: Cows, sheep, and horses eat plants like grass and hay. Their teeth and stomachs help them handle tough plant food.",
                vocab: "graze",
                vocabDef: "Graze is when an animal eats grass and plants in a field.",
                fact: "Many farm animals are plant eaters that graze on grass and hay.",
                prompt: "Write four sentences naming your menu, two plant foods, one animal that eats them, and one reason plant eaters need fresh water too.",
                response: .longText,
                ending: "Your plant eater menu is ready for the barn board!",
                reflection: "Which plant food on your menu is most important each day?",
                fingerprint: "farmAnimals.creative.growing.plant-eater"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Water Care Plan",
                opening: "Farm animals need clean water every day.",
                mission: "Use the inspiration. Write a water care plan.",
                inspiration: "Inspiration: Clean water keeps animals healthy. Farmers check troughs, refill them, and keep dirt and ice from blocking drinking water.",
                vocab: "trough",
                vocabDef: "A trough is a long container that holds water or food for animals.",
                fact: "Farm animals need clean drinking water checked every day.",
                prompt: "Write a short care plan with a title, three water-check steps, and one sentence explaining why dirty water is a problem.",
                response: .longText,
                ending: "Your water care plan is ready for a real farm helper!",
                reflection: "Which water-check step would you do first each morning?",
                fingerprint: "farmAnimals.creative.confident.water-care"
            )
        }
    }

    // MARK: - Zoo Animals

    private static func zooAnimalsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Habitat Exhibit",
                opening: "Zoo habitats can match what animals need.",
                mission: "Use the inspiration. Draw one exhibit.",
                inspiration: "Inspiration: A good zoo habitat gives space, shelter, water, and features like rocks or trees that fit the animal.",
                vocab: "habitat",
                vocabDef: "A habitat is a living place with what an animal needs.",
                fact: "Zoo habitats can give animals space, shelter, and water.",
                prompt: "Draw a zoo habitat with one animal, shelter, and water.",
                response: .drawing,
                ending: "Your habitat exhibit is thoughtful animal care!",
                reflection: "What shelter did you include for the animal?",
                fingerprint: "zooAnimals.creative.beginner.habitat"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw an Adaptation Trait",
                opening: "Adaptations can help animals survive.",
                mission: "Use the inspiration. Draw one adaptation.",
                inspiration: "Inspiration: A giraffe's long neck helps it reach high leaves. Thick fur can help other animals stay warm.",
                vocab: "adaptation",
                vocabDef: "An adaptation is a body trait or behavior that helps an animal survive.",
                fact: "Adaptations help animals get food, stay safe, or stay warm.",
                prompt: "Draw one zoo animal and clearly label one helpful body trait.",
                response: .drawing,
                ending: "Your adaptation art is a real survival idea!",
                reflection: "Which body trait did you label on your animal?",
                fingerprint: "zooAnimals.creative.early.adaptation"
            )
        case .growingReader:
            return waveECreative(
                title: "Design Enrichment Play Ideas",
                opening: "Enrichment can keep zoo animals active and curious.",
                mission: "Use the inspiration. Write enrichment ideas.",
                inspiration: "Inspiration: Enrichment can include climbing structures, puzzle feeders, and scent trails that encourage natural behaviors.",
                vocab: "enrichment",
                vocabDef: "Enrichment is activities and objects that keep animals active and curious.",
                fact: "Enrichment helps zoo animals practice natural behaviors.",
                prompt: "Write four sentences naming your enrichment plan, two activities, which animal they help, and why curiosity matters.",
                response: .longText,
                ending: "Your enrichment plan is ready for a zookeeper notebook!",
                reflection: "Which enrichment activity best matches the animal's natural behavior?",
                fingerprint: "zooAnimals.creative.growing.enrichment"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Conservation Poster",
                opening: "Conservation can protect animals and wild places.",
                mission: "Use the inspiration. Write a conservation poster plan.",
                inspiration: "Inspiration: Conservation can mean protecting habitats, reducing litter, and supporting careful wildlife science.",
                vocab: "conservation",
                vocabDef: "Conservation is actions that protect animals, plants, and wild places.",
                fact: "Conservation helps protect animals and the places they need.",
                prompt: "Write a short poster plan with a title, three helpful actions, and one sentence explaining how kids can help.",
                response: .longText,
                ending: "Your conservation poster is ready to inspire a whole community!",
                reflection: "Which helpful action on your poster feels most doable for kids?",
                fingerprint: "zooAnimals.creative.confident.conservation"
            )
        }
    }

    // MARK: - Pirates

    private static func piratesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return waveECreative(
                title: "Draw a Floating Boat",
                opening: "Boats can float when water pushes up enough.",
                mission: "Use the inspiration. Draw a floating boat.",
                inspiration: "Inspiration: A boat floats when the upward push of water, called buoyancy, supports the boat's weight.",
                vocab: "float",
                vocabDef: "Float is when something stays on top of water without sinking.",
                fact: "Boats can float when water pushes up enough to support them.",
                prompt: "Draw a wooden boat floating on water with one upward arrow under the hull.",
                response: .drawing,
                ending: "Your floating boat is a real water science idea!",
                reflection: "Where did you place the upward arrow under the boat?",
                fingerprint: "pirates.creative.beginner.float-boat"
            )
        case .earlyReader:
            return waveECreative(
                title: "Draw Sail and Wind Power",
                opening: "Sails can catch wind to move a boat.",
                mission: "Use the inspiration. Draw sail and wind.",
                inspiration: "Inspiration: Wind pushes against a sail. That push can move the boat forward across the water.",
                vocab: "sail",
                vocabDef: "A sail is a large cloth that catches wind to move a boat.",
                fact: "Wind pushing on sails can move a boat forward.",
                prompt: "Draw a sailboat with a full sail and wind arrows pushing the sail.",
                response: .drawing,
                ending: "Your sail and wind art is a clear picture of how boats can move!",
                reflection: "Which way do your wind arrows push the sail?",
                fingerprint: "pirates.creative.early.sail-wind"
            )
        case .growingReader:
            return waveECreative(
                title: "Design a Compass Guide Card",
                opening: "A compass can help travelers find direction.",
                mission: "Use the inspiration. Write a compass guide.",
                inspiration: "Inspiration: A compass needle points toward magnetic north. Travelers can use north to judge east, south, and west.",
                vocab: "compass",
                vocabDef: "A compass is a tool that shows direction using a magnetic needle.",
                fact: "A compass needle points toward magnetic north to help with direction.",
                prompt: "Write four sentences naming your guide, what the needle does, how to find east from north, and one reason direction matters at sea.",
                response: .longText,
                ending: "Your compass guide card is ready for a navigation kit!",
                reflection: "How would you find east using your compass guide?",
                fingerprint: "pirates.creative.growing.compass"
            )
        case .confidentReader:
            return waveECreative(
                title: "Write a Map Scale Plan",
                opening: "Map scale can show how map distance relates to real distance.",
                mission: "Use the inspiration. Write a map scale plan.",
                inspiration: "Inspiration: A map scale might say one finger width equals one kilometer. Scale helps sailors estimate how far a journey really is.",
                vocab: "scale",
                vocabDef: "Scale is a rule that shows how map distance matches real distance.",
                fact: "Map scale helps people estimate real travel distance.",
                prompt: "Write a short map scale plan with a title, your scale rule, two measured journey lengths, and one sentence explaining why scale prevents wrong distance guesses.",
                response: .longText,
                ending: "Your map scale plan is ready for a real navigation lesson!",
                reflection: "Which journey length on your plan uses the scale most clearly?",
                fingerprint: "pirates.creative.confident.map-scale"
            )
        }
    }

    // MARK: - Wave E Creative helper

    /// Wave E packs share Wave C's creative builder (unique missions / hints / vocab examples).
    private static func waveECreative(
        title: String,
        opening: String,
        mission: String,
        inspiration: String,
        vocab: String,
        vocabDef: String,
        fact: String,
        prompt: String,
        response: QuestionResponseType,
        ending: String,
        reflection: String,
        fingerprint: String
    ) -> CreativePack {
        creative(
            title: title,
            opening: opening,
            mission: mission,
            inspiration: inspiration,
            vocab: vocab,
            vocabDef: vocabDef,
            fact: fact,
            prompt: prompt,
            response: response,
            ending: ending,
            reflection: reflection,
            fingerprint: fingerprint
        )
    }
}
