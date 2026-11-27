import Foundation

/// A coherent countable scene for theme-aware math word problems.
/// Objects, settings, and actions are chosen together so sentences stay logical.
struct MathCountableScene: Equatable {
    /// Optional named or role-based character who performs collecting/sharing actions.
    let character: String?
    /// Subject pronoun for the character ("she", "he", "they").
    let pronoun: String
    /// Possessive pronoun ("her", "his", "their").
    let possessive: String

    let objectSingular: String
    let objectPlural: String

    /// Where the objects are, e.g. "on a rock", "in the castle garden".
    let location: String

    /// Opening state verb phrase for a group, e.g. "were resting".
    /// Stored in the plural. Use `stateVerb(forCount:)` so one object takes "was".
    let groupStateVerb: String
    /// How more objects join, e.g. "arrived", "swam over".
    let joinVerb: String
    /// How one object leaves (singular subject), e.g. "crawled away".
    let leaveVerbSingular: String
    /// How several objects leave, e.g. "crawled away".
    let leaveVerbPlural: String
    /// How a character gathers objects, e.g. "collected", "found".
    let collectVerb: String
    /// How a character gives some away, e.g. "shared", "gave".
    let giveVerb: String

    func applyingStory(
        character: String?,
        pronoun: String?,
        objectSingular: String,
        objectPlural: String
    ) -> MathCountableScene {
        let resolvedPronoun = pronoun ?? self.pronoun
        let resolvedPossessive: String
        if pronoun == nil {
            resolvedPossessive = possessive
        } else {
            switch resolvedPronoun {
            case "she": resolvedPossessive = "her"
            case "he": resolvedPossessive = "his"
            case "it": resolvedPossessive = "its"
            default: resolvedPossessive = "their"
            }
        }
        return MathCountableScene(
            character: character ?? self.character,
            pronoun: resolvedPronoun,
            possessive: resolvedPossessive,
            objectSingular: objectSingular,
            objectPlural: objectPlural,
            location: location,
            groupStateVerb: groupStateVerb,
            joinVerb: joinVerb,
            leaveVerbSingular: leaveVerbSingular,
            leaveVerbPlural: leaveVerbPlural,
            collectVerb: collectVerb,
            giveVerb: giveVerb
        )
    }

    /// Plural scene verbs are stored as "were …" or "are …".
    /// One object needs the singular match: "was …" or "is …".
    func stateVerb(forCount count: Int) -> String {
        guard count == 1 else { return groupStateVerb }
        if groupStateVerb.hasPrefix("were ") {
            return "was \(groupStateVerb.dropFirst(5))"
        }
        if groupStateVerb.hasPrefix("are ") {
            return "is \(groupStateVerb.dropFirst(4))"
        }
        return groupStateVerb
    }
}

/// Approved theme scenes used by `MathWordProblemGenerator`.
enum MathWordProblemScenes {

    static func scenes(for topic: Topic) -> [MathCountableScene] {
        switch topic {
        case .sharks:
            return [
                scene(nil, "it", "its", "shark", "sharks", "near the reef", "were swimming", "swam over", "swam away", "swam away", "counted", "watched"),
                scene("Finn", "he", "his", "baby shark", "baby sharks", "in the nursery", "were resting", "joined them", "darted away", "darted away", "spotted", "sent back"),
                scene(nil, "they", "their", "reef shark", "reef sharks", "beside a shipwreck", "were gliding", "arrived", "turned away", "turned away", "saw", "followed")
            ]
        case .oceanAnimals:
            return [
                scene(nil, "they", "their", "sea star", "sea stars", "on a rock", "were resting", "arrived", "crawled away", "crawled away", "found", "moved"),
                scene("Mia", "she", "her", "seashell", "seashells", "on the beach", "were lying", "washed up", "washed away", "washed away", "collected", "shared"),
                scene(nil, "they", "their", "dolphin", "dolphins", "near the boat", "were swimming", "swam over", "swam away", "swam away", "counted", "watched"),
                scene(nil, "they", "their", "crab", "crabs", "on the sand", "were crawling", "scuttled over", "scuttled away", "scuttled away", "spotted", "followed"),
                scene("a diver", "she", "her", "pearl", "pearls", "in a treasure chest", "were glowing", "were found", "was taken", "were taken", "gathered", "gave")
            ]
        case .horses:
            return [
                scene(nil, "they", "their", "horse", "horses", "in the stable", "were waiting", "trotted in", "trotted out", "trotted out", "counted", "led"),
                scene("Sunny", "she", "her", "apple", "apples", "in a bucket", "were waiting", "were added", "was eaten", "were eaten", "picked", "shared"),
                scene(nil, "they", "their", "pony", "ponies", "on the trail", "were walking", "joined the line", "turned back", "turned back", "spotted", "guided")
            ]
        case .dinosaurs:
            return [
                scene(nil, "they", "their", "dinosaur egg", "dinosaur eggs", "in a nest", "were resting", "were found", "rolled away", "rolled away", "discovered", "moved"),
                scene("Dottie", "she", "her", "horned dinosaur", "horned dinosaurs", "by the fossil trail", "were walking", "walked up", "walked away", "walked away", "counted", "led"),
                scene("a paleontologist", "she", "her", "fossil", "fossils", "at the dig site", "were waiting", "were uncovered", "was packed away", "were packed away", "collected", "gave"),
                scene("Dottie", "she", "her", "dinosaur bone", "dinosaur bones", "in the sand", "were half buried", "were dug up", "was carried off", "were carried off", "found", "shared")
            ]
        case .space, .planets, .rockets:
            return [
                scene(nil, "they", "their", "moon rock", "moon rocks", "in a sample bin", "were waiting", "were added", "was sent to the lab", "were sent to the lab", "collected", "packed"),
                scene("Nova", "she", "her", "star crystal", "star crystals", "near the moon base", "were glowing", "were found", "was stored", "were stored", "gathered", "shared"),
                scene(nil, "they", "their", "rocket", "rockets", "on the launch pad", "were ready", "rolled into place", "rolled away", "rolled away", "counted", "checked"),
                scene("a robot helper", "it", "its", "space tool", "space tools", "on the repair table", "were lined up", "were handed over", "was used", "were used", "sorted", "gave")
            ]
        case .princesses:
            return [
                scene(nil, "they", "their", "rose", "roses", "in the castle garden", "were blooming", "bloomed nearby", "was picked", "were picked", "gathered", "shared"),
                scene("the princess", "she", "her", "cupcake", "cupcakes", "at the party", "were waiting", "were brought out", "was eaten", "were eaten", "baked", "shared"),
                scene(nil, "they", "their", "jewel", "jewels", "in the crown", "were sparkling", "were set in place", "was removed", "were removed", "counted", "polished"),
                scene(nil, "they", "their", "guest", "guests", "in the ballroom", "were dancing", "arrived", "went home", "went home", "welcomed", "thanked"),
                scene(nil, "they", "their", "bird", "birds", "in the castle garden", "were singing", "flew over", "flew away", "flew away", "watched", "fed")
            ]
        case .castles:
            return [
                scene(nil, "they", "their", "torch", "torches", "in the hall", "were burning", "were lit", "went out", "went out", "counted", "replaced"),
                scene(nil, "they", "their", "guard", "guards", "on the wall", "were watching", "arrived", "went to the gate", "went to the gate", "spotted", "sent"),
                scene(nil, "they", "their", "stone", "stones", "in the castle wall", "were stacked", "were placed", "slipped out", "slipped out", "counted", "moved")
            ]
        case .fairies:
            return [
                scene(nil, "they", "their", "fairy", "fairies", "in the garden", "were glowing", "fluttered over", "fluttered away", "fluttered away", "counted", "followed"),
                scene(nil, "they", "their", "flower", "flowers", "in a ring", "were blooming", "opened nearby", "closed", "closed", "picked", "shared"),
                scene(nil, "they", "their", "firefly", "fireflies", "above the ferns", "were blinking", "blinked nearby", "blinked out", "blinked out", "watched", "counted")
            ]
        case .pirates:
            return [
                scene("a pirate", "he", "his", "gold coin", "gold coins", "in a wooden chest", "were shining", "were added", "was spent", "were spent", "found", "shared"),
                scene(nil, "they", "their", "sailor", "sailors", "on the ship deck", "were working", "climbed aboard", "went below", "went below", "counted", "called"),
                scene(nil, "they", "their", "map clue", "map clues", "on the island path", "were waiting", "were discovered", "was solved", "were solved", "found", "checked")
            ]
        case .dogs:
            return [
                scene(nil, "they", "their", "puppy", "puppies", "in the yard", "were playing", "ran over", "ran inside", "ran inside", "counted", "pet"),
                scene("Ben", "he", "his", "dog treat", "dog treats", "in a bowl", "were waiting", "were poured in", "was eaten", "were eaten", "poured", "shared"),
                scene("Scout", "he", "his", "tennis ball", "tennis balls", "near the park gate", "were waiting", "rolled over", "rolled away", "rolled away", "fetched", "shared")
            ]
        case .cats:
            return [
                scene(nil, "they", "their", "kitten", "kittens", "in a basket", "were sleeping", "climbed in", "climbed out", "climbed out", "counted", "pet"),
                scene(nil, "they", "their", "yarn ball", "yarn balls", "on the floor", "were sitting", "rolled over", "rolled away", "rolled away", "found", "put away")
            ]
        case .soccer:
            return [
                scene("Lena", "she", "her", "soccer ball", "soccer balls", "in a bag", "were ready", "were added", "was taken out", "were taken out", "packed", "shared"),
                scene(nil, "they", "their", "player", "players", "on the field", "were practicing", "joined practice", "sat on the bench", "sat on the bench", "counted", "coached"),
                scene("Coach Priya", "she", "her", "cone", "cones", "on the practice field", "were lined up", "were set down", "was picked up", "were picked up", "placed", "moved")
            ]
        case .basketball:
            return [
                scene("Theo", "he", "his", "basketball", "basketballs", "by the court", "were waiting", "were brought out", "was put away", "were put away", "counted", "passed"),
                scene(nil, "they", "their", "player", "players", "on the court", "were warming up", "joined the drill", "rested", "rested", "counted", "coached")
            ]
        case .robots:
            return [
                scene(nil, "they", "their", "robot", "robots", "in a line", "were waiting", "rolled over", "rolled away", "rolled away", "counted", "checked"),
                scene("a builder", "he", "his", "battery", "batteries", "on the workbench", "were ready", "were delivered", "was used", "were used", "sorted", "shared"),
                scene(nil, "they", "their", "robot part", "robot parts", "on the repair table", "were sorted", "were added", "was installed", "were installed", "gathered", "handed out")
            ]
        case .bugs:
            return [
                scene(nil, "they", "their", "ladybug", "ladybugs", "on a leaf", "were crawling", "landed nearby", "flew away", "flew away", "counted", "watched"),
                scene(nil, "they", "their", "bee", "bees", "on a flower", "were buzzing", "flew over", "flew away", "flew away", "spotted", "followed")
            ]
        case .nature:
            return [
                scene(nil, "they", "their", "bird", "birds", "at the feeder", "were eating", "flew over", "flew away", "flew away", "counted", "watched"),
                scene(nil, "they", "their", "leaf", "leaves", "on the trail", "were lying", "fell nearby", "blew away", "blew away", "picked", "shared")
            ]
        case .farmAnimals:
            return [
                scene(nil, "they", "their", "chicken", "chickens", "in the coop", "were pecking", "walked in", "walked out", "walked out", "counted", "fed"),
                scene(nil, "they", "their", "egg", "eggs", "in a basket", "were resting", "were gathered", "was used", "were used", "collected", "shared")
            ]
        case .zooAnimals:
            return [
                scene(nil, "they", "their", "penguin", "penguins", "on the ice", "were waddling", "waddled over", "waddled away", "waddled away", "counted", "watched"),
                scene(nil, "they", "their", "visitor", "visitors", "at the zoo gate", "were waiting", "arrived", "went home", "went home", "welcomed", "guided")
            ]
        case .jungleAnimals:
            return [
                scene(nil, "they", "their", "toucan", "toucans", "on a branch", "were sitting", "landed nearby", "flew away", "flew away", "spotted", "watched"),
                scene(nil, "they", "their", "monkey", "monkeys", "in the trees", "were climbing", "swung over", "swung away", "swung away", "counted", "followed")
            ]
        case .volcanoes:
            return [
                scene("Dr. Nolan", "she", "her", "rock sample", "rock samples", "at base camp", "were labeled", "were collected", "was packed", "were packed", "gathered", "shared"),
                scene(nil, "they", "their", "safety cone", "safety cones", "on the trail", "were standing", "were placed", "blew over", "blew over", "set out", "picked up")
            ]
        case .weather:
            return [
                scene(nil, "they", "their", "umbrella", "umbrellas", "by the door", "were waiting", "were hung up", "was taken", "were taken", "counted", "shared"),
                scene(nil, "they", "their", "rain gauge", "rain gauges", "in the yard", "were ready", "were set out", "was put away", "were put away", "placed", "checked")
            ]
        case .airplanes:
            return [
                scene(nil, "they", "their", "suitcase", "suitcases", "on the cart", "were stacked", "were loaded", "was taken off", "were taken off", "counted", "moved"),
                scene(nil, "they", "their", "passenger", "passengers", "at the gate", "were waiting", "boarded", "sat down", "sat down", "welcomed", "guided")
            ]
        case .trains:
            return [
                scene(nil, "they", "their", "train car", "train cars", "on the track", "were lined up", "were coupled on", "was uncoupled", "were uncoupled", "counted", "checked"),
                scene(nil, "they", "their", "ticket", "tickets", "at the window", "were ready", "were sold", "was used", "were used", "printed", "handed out")
            ]
        case .cars:
            return [
                scene(nil, "they", "their", "car", "cars", "in the parking lot", "were parked", "pulled in", "drove away", "drove away", "counted", "watched"),
                scene(nil, "they", "their", "wheel", "wheels", "on the workbench", "were ready", "were delivered", "was installed", "were installed", "sorted", "used")
            ]
        case .superheroes:
            return [
                scene(nil, "they", "their", "hero", "heroes", "in the city square", "were ready", "arrived", "flew off", "flew off", "counted", "cheered"),
                scene(nil, "they", "their", "gadget", "gadgets", "on the utility belt", "were clipped on", "were added", "was used", "were used", "packed", "shared")
            ]
        case .art:
            return [
                scene(nil, "they", "their", "paintbrush", "paintbrushes", "in a cup", "were waiting", "were added", "was taken", "were taken", "counted", "shared"),
                scene(nil, "they", "their", "paint dot", "paint dots", "on the palette", "were ready", "were squeezed out", "was used", "were used", "made", "blended")
            ]
        case .music:
            return [
                scene(nil, "they", "their", "drum", "drums", "on the stage", "were ready", "were set out", "was put away", "were put away", "counted", "shared"),
                scene(nil, "they", "their", "musician", "musicians", "in the band", "were practicing", "joined in", "took a break", "took a break", "welcomed", "coached")
            ]
        case .cooking:
            return [
                scene("Chef Dara", "she", "her", "wooden spoon", "wooden spoons", "in the drawer", "were waiting", "were washed", "was used", "were used", "counted", "shared"),
                scene("Chef Dara", "she", "her", "measuring cup", "measuring cups", "on the counter", "were lined up", "were added", "was used", "were used", "gathered", "shared"),
                scene("Chef Dara", "she", "her", "spice jar", "spice jars", "on the shelf", "were ready", "were unpacked", "was used", "were used", "sorted", "packed")
            ]
        }
    }

    // MARK: - Helpers

    private static func scene(
        _ character: String?,
        _ pronoun: String,
        _ possessive: String,
        _ singular: String,
        _ plural: String,
        _ location: String,
        _ groupState: String,
        _ join: String,
        _ leaveSingular: String,
        _ leavePlural: String,
        _ collect: String,
        _ give: String
    ) -> MathCountableScene {
        MathCountableScene(
            character: character,
            pronoun: pronoun,
            possessive: possessive,
            objectSingular: singular,
            objectPlural: plural,
            location: location,
            groupStateVerb: groupState,
            joinVerb: join,
            leaveVerbSingular: leaveSingular,
            leaveVerbPlural: leavePlural,
            collectVerb: collect,
            giveVerb: give
        )
    }
}
