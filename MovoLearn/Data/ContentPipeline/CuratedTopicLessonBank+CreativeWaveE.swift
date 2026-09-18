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
            return sceneDrawing(
                title: "Tide Pool Drawing",
                scene: "A tide pool sits among wet rocks. Cool water fills it. A tiny crab hides near the edge. Green seaweed sticks to the rocks.",
                vocab: "tide pool",
                vocabDef: "A tide pool is a small pool of ocean water left among rocks.",
                fact: "Tide pools are wet homes that stay among rocks after the tide goes out.",
                goals: ["Rocks", "Tiny crab", "Seaweed"],
                fingerprint: "oceanAnimals.creative.beginner.tide-pool"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Dolphin Leap Drawing",
                scene: "A gray dolphin leaps above a blue wave. Its strong tail makes a white splash. The sky is clear. A pink cloud sits far away.",
                vocab: "leap",
                vocabDef: "A leap is a strong jump up into the air.",
                fact: "Dolphins can leap above the water when their tails push hard.",
                goals: ["Dolphin", "Splash", "Blue wave"],
                fingerprint: "oceanAnimals.creative.early.dolphin-leap"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Design Octopus Camouflage Art",
                scene: "An octopus sits on a rock. It matches rocks, sand, or coral so it is harder to see. One arm is bumpy. The water is green-blue.",
                vocab: "camouflage",
                vocabDef: "Camouflage is a way of blending in so something is hard to see.",
                fact: "Octopuses can change skin color and texture. They match rocks, sand, or coral so they are harder to see.",
                goals: ["Octopus", "Matching rock", "Bumpy arm"],
                fingerprint: "oceanAnimals.creative.growing.octopus-camouflage"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Reef Jobs Drawing",
                scene: "A cleaner fish picks tiny pests off a larger fish. Hard coral builds a home. A grazing fish clears algae. The reef is bright orange and purple.",
                vocab: "reef",
                vocabDef: "A reef is a rocky ocean place where coral and many animals live.",
                fact: "Different reef animals have different helpful jobs.",
                goals: ["Cleaner fish", "Coral home", "Grazing fish"],
                fingerprint: "oceanAnimals.creative.confident.reef-jobs"
            )
        }
    }

    // MARK: - Planets

    private static func planetsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Earth Poster Drawing",
                scene: "Earth is a round planet in black space. Blue oceans cover most of it. Green and brown land shows through. White clouds swirl.",
                vocab: "Earth",
                vocabDef: "Earth is the planet where we live.",
                fact: "Earth has oceans, land, and clouds.",
                goals: ["Blue oceans", "Land", "White clouds"],
                fingerprint: "planets.creative.beginner.earth-poster"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Rocky and Giant Planets",
                scene: "Two groups of planets float in space. Rocky planets look small and solid. Giant planets look huge and cloudy. The Sun is yellow in the corner.",
                vocab: "rocky",
                vocabDef: "Rocky is made of hard solid ground.",
                fact: "Some planets are rocky, and others are giant gas worlds.",
                goals: ["Rocky planets", "Giant planets", "Yellow Sun"],
                fingerprint: "planets.creative.early.rocky-giant-sort"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Venus Glow Drawing",
                scene: "Venus shines with a pale yellow glow. A thick cloud blanket wraps the planet. Sunlight bounces off the clouds. Space around Venus is black.",
                vocab: "glow",
                vocabDef: "A glow is a soft bright shine.",
                fact: "Venus looks bright because sunlight is reflected from thick clouds.",
                goals: ["Venus", "Cloud blanket", "Glow"],
                fingerprint: "planets.creative.growing.venus-glow"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Orbit Path Drawing",
                scene: "The yellow Sun sits in the center. Inner planets travel on short curved paths. Outer planets travel on long curved paths. Each path is an orbit.",
                vocab: "orbit",
                vocabDef: "An orbit is a curved path around another object in space.",
                fact: "Planets are traveling around the Sun on orbit paths.",
                goals: ["Sun", "Inner path", "Outer path"],
                fingerprint: "planets.creative.confident.orbit-yarn"
            )
        }
    }

    // MARK: - Rockets

    private static func rocketsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Countdown Drawing",
                scene: "A red and white rocket stands on a launch pad. The countdown numbers show 3, 2, 1. Orange flame is just starting. The sky is early-morning blue.",
                vocab: "countdown",
                vocabDef: "A countdown is counting down to a launch.",
                fact: "Rockets wait for a countdown before they leave the pad.",
                goals: ["Rocket", "Countdown", "Launch pad"],
                fingerprint: "rockets.creative.beginner.countdown"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Thrust Flame Drawing",
                scene: "A rocket shoots up. Orange and yellow thrust flames push it. White smoke rolls on the ground. The rocket is silver.",
                vocab: "thrust",
                vocabDef: "Thrust is the push that lifts a rocket.",
                fact: "Hot gas rushing down gives a rocket thrust.",
                goals: ["Silver rocket", "Thrust flames", "Smoke"],
                fingerprint: "rockets.creative.early.thrust"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Stage Drop Drawing",
                scene: "An empty rocket stage falls away. The next stage keeps flying. The falling stage is gray. Earth is a blue curve below.",
                vocab: "stage",
                vocabDef: "A stage is one part of a rocket that can drop away.",
                fact: "Dropping empty stages makes the rest of the rocket lighter.",
                goals: ["Flying stage", "Falling stage", "Earth"],
                fingerprint: "rockets.creative.growing.stages"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Orbit Insert Drawing",
                scene: "A spacecraft follows a curved path around Earth. Blue oceans show below. The craft is white. Tiny thrusters make a small orange glow.",
                vocab: "orbit",
                vocabDef: "An orbit is a curved path around a planet.",
                fact: "A spacecraft stays in orbit when it moves fast enough along a curved path.",
                goals: ["Spacecraft", "Curved path", "Earth"],
                fingerprint: "rockets.creative.confident.orbit-insert"
            )
        }
    }

    // MARK: - Soccer

    private static func soccerCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Pass and Trap Drawing",
                scene: "A player in a green jersey traps a black-and-white soccer ball. A teammate in blue waits for a pass. The field is bright green. White lines mark the grass.",
                vocab: "trap",
                vocabDef: "A trap is stopping the ball with a gentle touch.",
                fact: "A soft trap helps a player keep control of the soccer ball.",
                goals: ["Green jersey", "Soccer ball", "Teammate"],
                fingerprint: "soccer.creative.beginner.pass-trap"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Goalkeeper Dive Drawing",
                scene: "A goalkeeper in a yellow jersey dives. The gloves are white. The ball is heading toward the corner. The goal net is red.",
                vocab: "goalkeeper",
                vocabDef: "A goalkeeper is the player who guards the goal.",
                fact: "Goalkeepers can use their hands inside the penalty area.",
                goals: ["Yellow keeper", "Dive", "Goal net"],
                fingerprint: "soccer.creative.early.keeper"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Open Space Drawing",
                scene: "A player in an orange jersey runs into open space. Teammates in blue hold the defenders. The soccer ball is rolling toward the open grass. The sky is sunny.",
                vocab: "space",
                vocabDef: "Space is an empty patch of field a player can use.",
                fact: "Moving into open space can make a pass easier.",
                goals: ["Orange player", "Open grass", "Soccer ball"],
                fingerprint: "soccer.creative.growing.open-space"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Corner Kick Drawing",
                scene: "A player takes a corner kick. The ball is white with black patches. Teammates wait near the goal. The flag is bright yellow.",
                vocab: "corner",
                vocabDef: "A corner is a kick from the corner of the field.",
                fact: "A corner kick starts with the ball on the corner arc.",
                goals: ["Corner kick", "Goal", "Yellow flag"],
                fingerprint: "soccer.creative.confident.corner"
            )
        }
    }

    // MARK: - Basketball

    private static func basketballCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Dribble Drawing",
                scene: "A player in a red jersey dribbles an orange basketball. The ball bounces by the player's side. The court is pale wood. Blue sneakers squeak.",
                vocab: "dribble",
                vocabDef: "A dribble is bouncing the ball while you move.",
                fact: "Players must dribble to move with the basketball.",
                goals: ["Red jersey", "Orange ball", "Court"],
                fingerprint: "basketball.creative.beginner.dribble"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Chest Pass Drawing",
                scene: "Two players face each other. The passer in purple pushes a chest pass. The orange ball flies straight. The receiver holds out both hands.",
                vocab: "pass",
                vocabDef: "A pass is sending the ball to a teammate.",
                fact: "A chest pass uses two hands and a straight push.",
                goals: ["Passer", "Orange ball", "Receiver"],
                fingerprint: "basketball.creative.early.chest-pass"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Layup Drawing",
                scene: "A player in a white jersey jumps near the hoop. The orange ball kisses the backboard. The rim is red. A defender in green watches.",
                vocab: "layup",
                vocabDef: "A layup is a close shot off the backboard.",
                fact: "A layup uses a soft touch near the basket.",
                goals: ["Jump", "Backboard", "Red rim"],
                fingerprint: "basketball.creative.growing.layup"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Box Out Drawing",
                scene: "A player in a blue jersey boxes out under the hoop. The player's back faces a teammate's opponent. The orange basketball is coming off the rim. The paint is a tan rectangle.",
                vocab: "rebound",
                vocabDef: "A rebound is grabbing the ball after a missed shot.",
                fact: "Boxing out helps a player grab a rebound.",
                goals: ["Box out", "Hoop", "Basketball"],
                fingerprint: "basketball.creative.confident.box-out"
            )
        }
    }

    // MARK: - Cats

    private static func catsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Cat Claws Drawing",
                scene: "A tabby cat shows claws on one paw. The claws are out for climbing. The other paw has claws tucked away. The cat is orange with stripes.",
                vocab: "claw",
                vocabDef: "A claw is a sharp nail on an animal's toe.",
                fact: "Cats can pull claws in and push them out when needed.",
                goals: ["Orange cat", "Claws out", "Tucked claws"],
                fingerprint: "cats.creative.beginner.claws"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Night Eyes Drawing",
                scene: "A cat face glows in dim light. The eyes are green. A soft moon is yellow. The night sky is deep blue.",
                vocab: "reflect",
                vocabDef: "Reflect is when light is bounced back.",
                fact: "Cats can see better in dim light because their eyes reflect light.",
                goals: ["Cat face", "Green eyes", "Moon"],
                fingerprint: "cats.creative.early.night-eyes"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Draw Long Whiskers",
                scene: "A gray cat walks through a narrow gap. Long whiskers touch both sides. The gap is between two brown chairs. The floor is a warm rug.",
                vocab: "whisker",
                vocabDef: "A whisker is a long stiff hair that helps an animal feel nearby things.",
                fact: "Long whiskers help cats feel if a gap is too small.",
                goals: ["Gray cat", "Long whiskers", "Narrow gap"],
                fingerprint: "cats.creative.growing.whiskers"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Quiet Paws Drawing",
                scene: "A cat walks with soft, quiet steps. Soft pads show under the paws. The cat is black. The hallway is dim and still.",
                vocab: "quiet",
                vocabDef: "Quiet is when little or no sound is made.",
                fact: "Soft paw pads help cats walk quietly.",
                goals: ["Black cat", "Soft pads", "Hallway"],
                fingerprint: "cats.creative.confident.quiet-paws"
            )
        }
    }

    // MARK: - Princesses

    private static func princessesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Garden Plant Drawing",
                scene: "A princess in a blue dress waters three plants. The watering can is silver. Sunlight is bright yellow. The soil looks dark and healthy.",
                vocab: "garden",
                vocabDef: "A garden is a place where people grow plants with care.",
                fact: "Plants need water, sunlight, and healthy soil to grow.",
                goals: ["Princess", "Three plants", "Watering can"],
                fingerprint: "princesses.creative.beginner.garden-plants"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Kind Helper Drawing",
                scene: "A princess in a pink gown helps carry a basket. The basket holds red apples. A friend in a green cloak smiles. The path is stone gray.",
                vocab: "kind",
                vocabDef: "Kind means helpful and caring.",
                fact: "Kind leaders share work and look after other people.",
                goals: ["Pink gown", "Apple basket", "Friend"],
                fingerprint: "princesses.creative.early.kind-helper"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Map Table Drawing",
                scene: "A princess studies a map on a wooden table. Blue rivers and green hills are drawn on the map. A gold compass sits beside a candle. The room is warm.",
                vocab: "map",
                vocabDef: "A map is a drawing that shows places.",
                fact: "Maps help people plan safe routes.",
                goals: ["Map", "Compass", "Candle"],
                fingerprint: "princesses.creative.growing.map-table"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Council Hall Drawing",
                scene: "A princess listens at a round table. Three advisers sit with her. A scroll with a wax seal lies open. Tall windows let in daylight.",
                vocab: "council",
                vocabDef: "A council is a group that talks and decides together.",
                fact: "Listening to many voices can help a leader choose well.",
                goals: ["Round table", "Advisers", "Scroll"],
                fingerprint: "princesses.creative.confident.council"
            )
        }
    }

    // MARK: - Castles

    private static func castlesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Moat Drawing",
                scene: "A stone castle sits behind a blue moat. A wooden drawbridge is down. Green ducks swim in the water. The towers are gray.",
                vocab: "moat",
                vocabDef: "A moat is a water ditch around a castle.",
                fact: "A moat made it harder for strangers to reach the castle walls.",
                goals: ["Castle", "Blue moat", "Drawbridge"],
                fingerprint: "castles.creative.beginner.moat"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Keep Drawing",
                scene: "The keep is the strongest tower. It is tall and tan. Small windows sit high up. A red banner flies from the top.",
                vocab: "keep",
                vocabDef: "A keep is the strongest inner tower of a castle.",
                fact: "People could shelter in the keep if the outer walls were in danger.",
                goals: ["Keep", "High windows", "Red banner"],
                fingerprint: "castles.creative.early.keep"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Gatehouse Drawing",
                scene: "Guards stand in a gatehouse. The portcullis is a black iron grate. The gate passage is stone. A lantern hangs by the door.",
                vocab: "portcullis",
                vocabDef: "A portcullis is a strong grate that can drop to close a gate.",
                fact: "A gatehouse controlled who could enter a castle.",
                goals: ["Gatehouse", "Iron grate", "Guards"],
                fingerprint: "castles.creative.growing.gatehouse"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Castle Yard Drawing",
                scene: "The bailey is a busy castle yard. A well sits in the center. Brown stables stand near the tower.",
                vocab: "bailey",
                vocabDef: "A bailey is an open yard inside castle walls.",
                fact: "Castle yards held wells and stables.",
                goals: ["Castle yard", "Well", "Stables"],
                fingerprint: "castles.creative.confident.bailey"
            )
        }
    }

    // MARK: - Fairies

    private static func fairiesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Dewdrop Garden Drawing",
                scene: "A small fairy sits on a green leaf. Silver dewdrops shine on the grass. The fairy's wings are pale blue. A yellow daisy stands nearby.",
                vocab: "dew",
                vocabDef: "Dew is tiny water drops that form on cool mornings.",
                fact: "Dewdrops form when air cools and water collects on plants.",
                goals: ["Fairy", "Dewdrops", "Daisy"],
                fingerprint: "fairies.creative.beginner.dew"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Pollinator Friend Drawing",
                scene: "A fairy flies beside a bee. The bee visits a purple flower. Yellow pollen dusts the bee. The meadow is green.",
                vocab: "pollen",
                vocabDef: "Pollen is a fine powder flowers use to make seeds.",
                fact: "Bees carry pollen from flower to flower.",
                goals: ["Fairy", "Bee", "Purple flower"],
                fingerprint: "fairies.creative.early.pollen"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Moonlit Path Drawing",
                scene: "Fairies follow a path of pale mushrooms. Moonlight is silver. The forest is dark green. One lantern is warm gold.",
                vocab: "moonlight",
                vocabDef: "Moonlight is sunlight that bounces off the Moon.",
                fact: "Moonlight is reflected sunlight.",
                goals: ["Mushroom path", "Moonlight", "Lantern"],
                fingerprint: "fairies.creative.growing.moon-path"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Seed Carry Drawing",
                scene: "Fairies help carry a milkweed seed on the wind. The seed has white fluff. The sky is pink at sunset. A garden waits below.",
                vocab: "seed",
                vocabDef: "A seed is a plant's starting package.",
                fact: "Some seeds travel on the wind with fluffy hairs.",
                goals: ["Fairies", "Fluffy seed", "Sunset sky"],
                fingerprint: "fairies.creative.confident.seed"
            )
        }
    }

    // MARK: - Airplanes

    private static func airplanesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Cockpit Drawing",
                scene: "A pilot sits in a cockpit. The windows show blue sky. Dials and switches are on the panel. The airplane nose is white.",
                vocab: "cockpit",
                vocabDef: "A cockpit is where the pilots sit and fly the airplane.",
                fact: "Pilots use cockpit instruments to fly safely.",
                goals: ["Pilot", "Windows", "Panel"],
                fingerprint: "airplanes.creative.beginner.cockpit"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Wing Lift Drawing",
                scene: "An airplane wing cuts through white clouds. Air flows over the curved top. The plane is silver. The ground is a green patch far below.",
                vocab: "lift",
                vocabDef: "Lift is the upward force that helps an airplane fly.",
                fact: "The shape of a wing helps create lift.",
                goals: ["Wing", "Clouds", "Silver plane"],
                fingerprint: "airplanes.creative.early.lift"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Runway Drawing",
                scene: "A runway stretches in two long lines. Lights are white and yellow. A blue airplane waits to take off. The wind sock is orange.",
                vocab: "runway",
                vocabDef: "A runway is a long strip for takeoff and landing.",
                fact: "Airplanes use runways to speed up and slow down.",
                goals: ["Runway", "Airplane", "Wind sock"],
                fingerprint: "airplanes.creative.growing.runway"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Air Traffic Drawing",
                scene: "A control tower stands beside the airport. A controller in the glass room watches two planes. One plane is landing. One plane is taxiing. The sky is clear.",
                vocab: "tower",
                vocabDef: "A control tower is a tall room where people guide airport traffic.",
                fact: "Air traffic controllers help keep airplanes spaced safely.",
                goals: ["Tower", "Landing plane", "Taxiing plane"],
                fingerprint: "airplanes.creative.confident.tower"
            )
        }
    }

    // MARK: - Trains

    private static func trainsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Engine Drawing",
                scene: "A blue engine pulls two yellow cars. The conductor waves from the window. Steel rails shine. Green hills sit behind the train.",
                vocab: "engine",
                vocabDef: "An engine is the machine that pulls a train.",
                fact: "The engine provides the power that moves the train.",
                goals: ["Blue engine", "Yellow cars", "Rails"],
                fingerprint: "trains.creative.beginner.engine"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Station Drawing",
                scene: "A red train waits at a station. The platform is gray. A clock hangs above the bench. A family stands behind the yellow safety line.",
                vocab: "platform",
                vocabDef: "A platform is the raised place where people wait for a train.",
                fact: "People wait behind the safety line until the train stops.",
                goals: ["Red train", "Platform", "Safety line"],
                fingerprint: "trains.creative.early.station"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Signal Light Drawing",
                scene: "A signal light stands by the tracks. The light is green. A silver train rolls toward a bridge. The sky is cloudy gray.",
                vocab: "signal",
                vocabDef: "A signal is a light or sign that tells a train to go or wait.",
                fact: "Train signals help keep trains from meeting on the same track.",
                goals: ["Green signal", "Silver train", "Bridge"],
                fingerprint: "trains.creative.growing.signal"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Freight Yard Drawing",
                scene: "A freight yard holds boxcars, tank cars, and flatcars. A switch engine is orange. Workers wear yellow vests. Rails curve in many directions.",
                vocab: "freight",
                vocabDef: "Freight is goods moved from one place to another.",
                fact: "Freight trains carry goods in many kinds of railcars.",
                goals: ["Boxcars", "Switch engine", "Yellow vests"],
                fingerprint: "trains.creative.confident.freight"
            )
        }
    }

    // MARK: - Cars

    private static func carsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Hubcap Drawing",
                scene: "A red car parks by a curb. A shiny hubcap covers the wheel. The tires are black. A yellow crosswalk sits in front.",
                vocab: "hubcap",
                vocabDef: "A hubcap is the cover on the center of a wheel.",
                fact: "Hubcaps cover the center of a car wheel.",
                goals: ["Red car", "Hubcap", "Crosswalk"],
                fingerprint: "cars.creative.beginner.hubcap"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Seat Belt Drawing",
                scene: "A child sits in a car seat. The gray seat belt crosses the chest. The red car waits by the road. A parent checks the buckle.",
                vocab: "buckle",
                vocabDef: "A buckle is the clasp that locks a seat belt.",
                fact: "Seat belts help keep people in place if a car stops fast.",
                goals: ["Car seat", "Seat belt", "Buckle"],
                fingerprint: "cars.creative.early.seatbelt"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Traffic Light Drawing",
                scene: "The traffic light is red. A blue car waits at the stop line on the road. A walker stands on the sidewalk.",
                vocab: "signal",
                vocabDef: "A traffic signal tells drivers when to stop or go.",
                fact: "Red means stop. Green means go if the way is clear.",
                goals: ["Traffic light", "Blue car", "Walker"],
                fingerprint: "cars.creative.growing.lights"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Engine Bay Drawing",
                scene: "The hood of a car is open. A parent points to the battery and the radiator. The engine is gray. A toolbox is red on the ground.",
                vocab: "engine",
                vocabDef: "An engine is the machine that makes a car move.",
                fact: "Car engines turn fuel or stored power into motion.",
                goals: ["Open hood", "Battery", "Toolbox"],
                fingerprint: "cars.creative.confident.engine-bay"
            )
        }
    }

    // MARK: - Superheroes

    private static func superheroesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Kind Hero Drawing",
                scene: "A hero in a teal cape helps a cat down from a tree. The cat is orange. The tree is green. Neighbors wave from a porch.",
                vocab: "help",
                vocabDef: "Help means to make a job easier for someone.",
                fact: "Everyday helpers solve problems with care, not just power.",
                goals: ["Hero", "Orange cat", "Tree"],
                fingerprint: "superheroes.creative.beginner.kind-help"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Team Rescue Drawing",
                scene: "Two heroes work together. One holds a rope. One guides a boat to shore. The water is blue. Life jackets are orange.",
                vocab: "team",
                vocabDef: "A team is a group that works toward the same goal.",
                fact: "Teams can solve problems that one person cannot finish alone.",
                goals: ["Two heroes", "Rope", "Boat"],
                fingerprint: "superheroes.creative.early.team"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Safe Landing Drawing",
                scene: "A hero in a purple suit lands softly on a rooftop. Knees bend. A weather vane is yellow. The city is gray below.",
                vocab: "balance",
                vocabDef: "Balance is staying steady so you do not fall.",
                fact: "Bending knees can help a person land more safely.",
                goals: ["Hero", "Rooftop", "Bent knees"],
                fingerprint: "superheroes.creative.growing.landing"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Community Helper Drawing",
                scene: "A hero helps at a rescue with firefighters and medics. The fire truck is red. A first-aid bag is white with a green cross.",
                vocab: "community",
                vocabDef: "A community is a group of people who share a place.",
                fact: "Real helpers include firefighters, medics, and neighbors.",
                goals: ["Hero", "Fire truck", "Medic bag"],
                fingerprint: "superheroes.creative.confident.community"
            )
        }
    }

    // MARK: - Art

    private static func artCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Primary Color Drawing",
                scene: "Three paint pots sit on a table. One is red. One is yellow. One is blue. A brush with a wooden handle waits beside paper.",
                vocab: "primary",
                vocabDef: "Primary colors are red, yellow, and blue.",
                fact: "Red, yellow, and blue can mix to make many other colors.",
                goals: ["Red pot", "Yellow pot", "Blue pot"],
                fingerprint: "art.creative.beginner.primary"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Still Life Drawing",
                scene: "A still life sits on a cloth. There is a green apple, a brown jug, and a yellow lemon. A window lights one side. The other side is in shadow.",
                vocab: "still life",
                vocabDef: "A still life is a picture of objects that do not move.",
                fact: "Light and shadow help a still life look solid.",
                goals: ["Apple", "Jug", "Shadow"],
                fingerprint: "art.creative.early.still-life"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Warm Cool Drawing",
                scene: "A landscape splits into warm and cool colors. The sunny hill is orange and yellow. The shady valley is blue and green. A path runs between them.",
                vocab: "cool",
                vocabDef: "Cool colors include blue and green.",
                fact: "Warm and cool colors can show sun and shade.",
                goals: ["Warm hill", "Cool valley", "Path"],
                fingerprint: "art.creative.growing.warm-cool"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Perspective Street Drawing",
                scene: "A street goes back toward a vanishing point. Buildings get smaller as they recede. A red bus is close. A tiny cyclist is far away.",
                vocab: "perspective",
                vocabDef: "Perspective is a way of drawing depth on a flat page.",
                fact: "Things look smaller when they are farther away.",
                goals: ["Street", "Buildings", "Red bus"],
                fingerprint: "art.creative.confident.perspective"
            )
        }
    }

    // MARK: - Music

    private static func musicCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Steady Beat Drawing",
                scene: "A drummer taps a steady beat. The drum is red. Four beat marks sit in a row. Friends clap along. The room is sunny.",
                vocab: "beat",
                vocabDef: "A beat is a steady pulse in music.",
                fact: "A steady beat helps people play music together.",
                goals: ["Drum", "Beat marks", "Clapping"],
                fingerprint: "music.creative.beginner.beat"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "High and Low Drawing",
                scene: "A keyboard shows high notes on the right and low notes on the left. A child in a purple shirt plays. A treble staff hangs on the wall. A cat listens.",
                vocab: "pitch",
                vocabDef: "Pitch is how high or low a sound is.",
                fact: "On a piano, notes get higher as you move to the right.",
                goals: ["Keyboard", "High notes", "Low notes"],
                fingerprint: "music.creative.early.pitch"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Orchestra Seats Drawing",
                scene: "An orchestra sits in curved rows. Strings are in front. Woodwinds sit behind them. Brass and percussion are farther back. The conductor's podium is wood.",
                vocab: "orchestra",
                vocabDef: "An orchestra is a large group of instruments playing together.",
                fact: "Orchestra families sit in groups so the sound blends.",
                goals: ["Strings", "Woodwinds", "Conductor"],
                fingerprint: "music.creative.growing.orchestra"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Dynamics Drawing",
                scene: "A choir sings on risers. One side is labeled soft. One side is labeled loud. The director's hands show the change. Robes are blue.",
                vocab: "dynamics",
                vocabDef: "Dynamics are how loud or soft music is.",
                fact: "Musicians change dynamics to make music more expressive.",
                goals: ["Choir", "Soft side", "Loud side"],
                fingerprint: "music.creative.confident.dynamics"
            )
        }
    }

    // MARK: - Cooking

    private static func cookingCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Heat Change Drawing",
                scene: "A pan sits on a stove. Butter is melting from a yellow stick into a gold puddle. A wooden spoon waits. The burner is orange.",
                vocab: "heat",
                vocabDef: "Heat is warmth that can change food.",
                fact: "Heat can change how food looks and feels.",
                goals: ["Pan", "Melting butter", "Spoon"],
                fingerprint: "cooking.creative.beginner.heat-change"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Measuring Tools Drawing",
                scene: "A measuring cup and a measuring spoon sit by a mixing bowl. The cup is clear. The spoon is silver. Flour waits in a yellow bag.",
                vocab: "measure",
                vocabDef: "Measure means to find out how much of something there is.",
                fact: "Measuring tools help cooks use the right amounts.",
                goals: ["Measuring cup", "Spoon", "Bowl"],
                fingerprint: "cooking.creative.early.measuring"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Draw Sugar Mixing in Water",
                scene: "A clear cup holds water. Sugar goes in from a small spoon. After mixing, the bits disappear but the sugar is still in the water. The cup sits on a blue napkin.",
                vocab: "dissolve",
                vocabDef: "Dissolve means a solid mixes into a liquid until you cannot see the bits.",
                fact: "Sugar can dissolve in water and stay in the liquid.",
                goals: ["Cup of water", "Sugar", "After mixing"],
                fingerprint: "cooking.creative.growing.dissolving"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Draw Ice, Water, and Steam",
                scene: "Three pictures sit in a row. Ice is a solid cube. Melted water sits in a bowl. Steam rises from a kettle. Labels name each state.",
                vocab: "state",
                vocabDef: "A state is the form matter takes, such as solid, liquid, or gas.",
                fact: "Cooking can change matter between solid, liquid, and gas forms.",
                goals: ["Ice", "Water", "Steam"],
                fingerprint: "cooking.creative.confident.states-recipe"
            )
        }
    }

    // MARK: - Nature

    private static func natureCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Habitat Home Drawing",
                scene: "In nature, a rabbit sits in a meadow. Green plants are food. A burrow is shelter. A stream gives water near a tree.",
                vocab: "habitat",
                vocabDef: "A habitat is a place where a plant or animal lives and finds what it needs.",
                fact: "Habitats can give animals food, water, shelter, and space.",
                goals: ["Rabbit", "Burrow", "Stream"],
                fingerprint: "nature.creative.beginner.habitat"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Food Chain Drawing",
                scene: "In nature, green plants grow in sunlight. A rabbit eats the plants. A hawk flies above the field. A tree stands nearby.",
                vocab: "food chain",
                vocabDef: "A food chain shows who eats whom.",
                fact: "Energy in a food chain starts with sunlight and plants.",
                goals: ["Plants", "Rabbit", "Hawk"],
                fingerprint: "nature.creative.early.food-chain"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Rain Gauge Drawing",
                scene: "A rain gauge stands in a garden. Rain fills the tube. Marks show how much rain fell. Leaves are shiny and wet. Clouds are gray.",
                vocab: "rain gauge",
                vocabDef: "A rain gauge is a tool that measures how much rain falls.",
                fact: "A rain gauge collects rain so people can measure it.",
                goals: ["Rain gauge", "Rain", "Garden"],
                fingerprint: "nature.creative.growing.rain-gauge"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Watershed Drawing",
                scene: "In nature, rain falls on a forest hill. Water runs into a creek. The creek joins a river. Trees hold the soil.",
                vocab: "watershed",
                vocabDef: "A watershed is land that drains rain into the same stream or river.",
                fact: "Rain that falls on land can travel downhill into creeks and rivers.",
                goals: ["Hill", "Creek", "River"],
                fingerprint: "nature.creative.confident.watershed"
            )
        }
    }

    // MARK: - Bugs

    private static func bugsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Ladybug Drawing",
                scene: "A red ladybug walks on a green leaf. Black spots mark its wing covers. Tiny legs grip the leaf. A yellow flower is nearby.",
                vocab: "spot",
                vocabDef: "A spot is a small mark of color.",
                fact: "Ladybugs are beetles with hard wing covers.",
                goals: ["Ladybug", "Spots", "Leaf"],
                fingerprint: "bugs.creative.beginner.ladybug"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Ant Trail Drawing",
                scene: "A brown ant walks on a garden trail. Two long antennae feel the ground. The ant is a small bug. Crumbs sit nearby.",
                vocab: "antenna",
                vocabDef: "An antenna is a feeler that helps an insect sense nearby things.",
                fact: "Many insects use antennae to smell and feel nearby things.",
                goals: ["Ant", "Antennae", "Trail"],
                fingerprint: "bugs.creative.early.antennae"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Metamorphosis Drawing",
                scene: "A monarch's life sits in four pictures. An egg is on a milkweed leaf. A caterpillar eats. A chrysalis hangs. An orange butterfly flies.",
                vocab: "chrysalis",
                vocabDef: "A chrysalis is the hard case where a caterpillar changes.",
                fact: "Butterflies change from egg to caterpillar to chrysalis to adult.",
                goals: ["Egg", "Caterpillar", "Butterfly"],
                fingerprint: "bugs.creative.growing.metamorphosis"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Pollinator Garden Drawing",
                scene: "Bees and butterflies visit native flowers. A bee is on a purple coneflower. A butterfly is on milkweed. A shallow water dish sits in the soil.",
                vocab: "pollinator",
                vocabDef: "A pollinator is an animal that moves pollen from flower to flower.",
                fact: "Bees and butterflies help plants make seeds when they visit flowers.",
                goals: ["Bee", "Butterfly", "Flowers"],
                fingerprint: "bugs.creative.confident.pollinator"
            )
        }
    }

    // MARK: - Weather

    private static func weatherCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Sun and Cloud Drawing",
                scene: "A bright yellow sun peeks from behind a white cloud. The sky is light blue. A child wears a hat. Grass is green.",
                vocab: "cloud",
                vocabDef: "A cloud is a collection of tiny water drops in the sky.",
                fact: "Clouds are made of tiny water drops or ice crystals.",
                goals: ["Sun", "Cloud", "Blue sky"],
                fingerprint: "weather.creative.beginner.sun-cloud"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Wind Vane Drawing",
                scene: "A wind vane points toward the blowing wind. The arrow is red. A tree leans the same way. Leaves fly. The sky is gray.",
                vocab: "wind",
                vocabDef: "Wind is moving air.",
                fact: "A wind vane shows the direction the wind comes from.",
                goals: ["Wind vane", "Leaning tree", "Leaves"],
                fingerprint: "weather.creative.early.wind-vane"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Water Cycle Drawing",
                scene: "The sun warms a blue lake. Water vapor rises. A gray cloud forms. Rain falls back to the lake. Arrows show the cycle.",
                vocab: "evaporate",
                vocabDef: "Evaporate means liquid water turns into water vapor.",
                fact: "The water cycle moves water from lakes to clouds and back as rain.",
                goals: ["Lake", "Cloud", "Rain"],
                fingerprint: "weather.creative.growing.water-cycle"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Forecast Map Drawing",
                scene: "A weather map shows a cold front as a blue line. Rain symbols sit ahead of the front. A sun symbol sits behind it. The map key is in the corner.",
                vocab: "forecast",
                vocabDef: "A forecast is a prediction of coming weather.",
                fact: "Weather maps help people predict rain, wind, and temperature.",
                goals: ["Cold front", "Rain symbols", "Map key"],
                fingerprint: "weather.creative.confident.forecast"
            )
        }
    }

    // MARK: - Farm Animals

    private static func farmAnimalsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Barn Morning Drawing",
                scene: "A red barn sits under a yellow sun. A brown cow stands by a water trough. A white chicken pecks grain. Green grass is wet with dew.",
                vocab: "barn",
                vocabDef: "A barn is a farm building that shelters animals and tools.",
                fact: "Farm animals need food, water, and shelter every day.",
                goals: ["Red barn", "Cow", "Chicken"],
                fingerprint: "farmAnimals.creative.beginner.barn"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Sheep Fleece Drawing",
                scene: "A sheep with thick white fleece stands by a fence. A farmer holds shears. A basket waits for wool. The pasture is green.",
                vocab: "fleece",
                vocabDef: "Fleece is a sheep's woolly coat.",
                fact: "Sheep grow a thick fleece that people can shear.",
                goals: ["Sheep", "Fleece", "Basket"],
                fingerprint: "farmAnimals.creative.early.fleece"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Hen Nest Drawing",
                scene: "A hen sits on a nest in straw. One brown egg is beside her. The coop is wood. A waterer is silver. Sunlight comes through a window.",
                vocab: "nest",
                vocabDef: "A nest is a safe place a bird makes for eggs.",
                fact: "Hens lay eggs in nests lined with straw.",
                goals: ["Hen", "Egg", "Straw nest"],
                fingerprint: "farmAnimals.creative.growing.nest"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Pasture Rotation Drawing",
                scene: "Cows graze in one green pasture. A gate is closed to a resting field. The resting field is taller grass. A farmer checks the fence.",
                vocab: "pasture",
                vocabDef: "A pasture is a grassy field where animals graze.",
                fact: "Moving animals between pastures lets grass grow back.",
                goals: ["Cows", "Green pasture", "Gate"],
                fingerprint: "farmAnimals.creative.confident.pasture"
            )
        }
    }

    // MARK: - Zoo Animals

    private static func zooAnimalsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Giraffe Browse Drawing",
                scene: "A giraffe stretches its long neck to high leaves. The giraffe is tan with brown patches. The leaves are green. A keeper watches from a path.",
                vocab: "browse",
                vocabDef: "Browse means to eat leaves from trees and shrubs.",
                fact: "Giraffes use long necks to browse leaves high in trees.",
                goals: ["Giraffe", "Long neck", "Leaves"],
                fingerprint: "zooAnimals.creative.beginner.giraffe"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Penguin Colony Drawing",
                scene: "Black-and-white penguins stand on rocks. One penguin slides into blue water. A nest of pebbles sits nearby. The sky is pale.",
                vocab: "colony",
                vocabDef: "A colony is a group of animals living together.",
                fact: "Many penguins live in colonies and nest with pebbles.",
                goals: ["Penguins", "Water", "Pebble nest"],
                fingerprint: "zooAnimals.creative.early.penguins"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Elephant Dust Bath Drawing",
                scene: "An elephant throws tan dust on its back. The elephant is gray. A water hole is nearby. A calf stands in the shade.",
                vocab: "dust bath",
                vocabDef: "A dust bath is when an animal covers its skin with dry soil.",
                fact: "Elephants can use dust to protect their skin.",
                goals: ["Elephant", "Dust", "Calf"],
                fingerprint: "zooAnimals.creative.growing.dust-bath"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Habitat Care Drawing",
                scene: "A zookeeper rakes a habitat. Fresh branches are enrichment. A pool is clean and blue. A clipboard hangs on the gate.",
                vocab: "enrichment",
                vocabDef: "Enrichment is extra things that help zoo animals stay busy and well.",
                fact: "Keepers give zoo animals enrichment so they can explore and stay healthy.",
                goals: ["Keeper", "Branches", "Pool"],
                fingerprint: "zooAnimals.creative.confident.enrichment"
            )
        }
    }

    // MARK: - Pirates

    private static func piratesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Compass Drawing",
                scene: "A pirate ship sails on blue water. A compass sits on the deck. The needle points north. A red sail catches the wind.",
                vocab: "compass",
                vocabDef: "A compass is a tool that shows direction.",
                fact: "A compass needle points toward north.",
                goals: ["Ship", "Compass", "Red sail"],
                fingerprint: "pirates.creative.beginner.compass"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Tide Chart Drawing",
                scene: "A pirate studies a tide chart by lantern light. High tide and low tide are marked. The harbor is brown at low water. The chart is tan paper.",
                vocab: "tide chart",
                vocabDef: "A tide chart shows when the water will be high or low.",
                fact: "Sailors use tide charts to know when a harbor is deep enough.",
                goals: ["Tide chart", "Lantern", "Harbor"],
                fingerprint: "pirates.creative.early.tide-chart"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Lookout Drawing",
                scene: "A lookout stands in the crow's nest. A spyglass is brown. White clouds sit on the horizon. The sea is dark blue.",
                vocab: "lookout",
                vocabDef: "A lookout is a person who watches for land, ships, or weather.",
                fact: "A high lookout can see farther across the water.",
                goals: ["Lookout", "Spyglass", "Horizon"],
                fingerprint: "pirates.creative.growing.lookout"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Harbor Map Drawing",
                scene: "A harbor map shows a channel, a sandbar, and a lighthouse. The lighthouse is white with a black stripe. Safe water is blue. The sandbar is tan.",
                vocab: "channel",
                vocabDef: "A channel is a deeper path ships use in a harbor.",
                fact: "Harbor maps mark channels so ships can avoid shallow sandbars.",
                goals: ["Channel", "Sandbar", "Lighthouse"],
                fingerprint: "pirates.creative.confident.harbor-map"
            )
        }
    }
}
