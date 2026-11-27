import XCTest
@testable import MovoLearn

final class StoryPictureTests: XCTestCase {

    func testFairyStoryShowsFairies() {
        let scene = StoryCountScene.story(
            title: "Count the Fairies",
            opening: "Luma needs a careful count in the glade.",
            passage: "Four fairies flutter above the ferns. Two flowers bloom in a ring."
        )
        guard case .beside(let left, let right) = scene?.arrangement else {
            return XCTFail("Expected the fairies and flowers named in the story")
        }
        XCTAssertEqual(left.picture.name, "fairy")
        XCTAssertEqual(left.count, 4)
        XCTAssertEqual(right.picture.name, "flower")
        XCTAssertEqual(right.count, 2)
    }

    func testPigStoryShowsPigsNotCows() {
        let scene = StoryCountScene.story(
            title: "Pigs in the Pen",
            opening: "The farmer counts the pigs.",
            passage: "A cow watches from the next field."
        )
        XCTAssertEqual(scene?.picture.name, "pig")
    }

    func testCowStoryStaysACowWhenAPigIsOnlyMentioned() {
        let scene = StoryCountScene.story(
            title: "Morning Milk",
            opening: "Bessie the cow waits in the barn.",
            passage: "A pig lives next door, but Jo milks the cow."
        )
        XCTAssertEqual(scene?.picture.name, "cow")
    }

    func testPigmentIsNotAPig() {
        let scene = StoryCountScene.story(
            title: "Color Notes",
            opening: "Pigments are tiny color particles.",
            passage: "Mixing pigments changes which light you see."
        )
        XCTAssertNotEqual(scene?.picture.name, "pig")
        XCTAssertNil(scene)
    }

    func testAdditionShowsFairiesJoining() {
        let scene = StoryCountScene.math(
            prompt: "Luma sees 2 fairies, then 2 more join. How many fairies in all?",
            explanation: "2 + 2 = 4.",
            title: "Count the Fairies"
        )
        XCTAssertEqual(scene?.picture.name, "fairy")
        guard case .gather(let shown, let joining) = scene?.arrangement else {
            return XCTFail("Expected fairies joining")
        }
        XCTAssertEqual(shown, 2)
        XCTAssertEqual(joining, 2)
    }

    func testCompareShowsFlowersBesideFairies() {
        let scene = StoryCountScene.math(
            prompt: "There are 2 flowers on the left and 3 fairies on the right. Which side has more?",
            explanation: "3 is more than 2.",
            title: "Count the Fairies"
        )
        guard case .beside(let left, let right) = scene?.arrangement else {
            return XCTFail("Expected two groups")
        }
        XCTAssertEqual(left.picture.name, "flower")
        XCTAssertEqual(left.count, 2)
        XCTAssertEqual(right.picture.name, "fairy")
        XCTAssertEqual(right.count, 3)
    }

    func testDewdropsLeaveInsteadOfFairies() {
        let scene = StoryCountScene.math(
            prompt: "Luma gathered 8 dewdrops at dawn. She gives away 5 to a flower fairy. How many dewdrops does Luma have left?",
            explanation: "8 − 5 = 3.",
            title: "Flowers for the Ring",
            opening: "Luma gathers flowers to freshen the mushroom ring."
        )
        XCTAssertEqual(scene?.picture.name, "dewdrop")
        guard case .depart(let start, let leaving) = scene?.arrangement else {
            return XCTFail("Expected dewdrops leaving")
        }
        XCTAssertEqual(start, 8)
        XCTAssertEqual(leaving, 5)
    }

    func testPigsLeaveThePen() {
        let scene = StoryCountScene.math(
            prompt: "There are 4 pigs in the pen. 1 pig walks out. How many pigs are left?",
            explanation: "4 − 1 = 3."
        )
        XCTAssertEqual(scene?.picture.name, "pig")
        guard case .depart(let start, let leaving) = scene?.arrangement else {
            return XCTFail("Expected pigs leaving")
        }
        XCTAssertEqual(start, 4)
        XCTAssertEqual(leaving, 1)
    }

    func testBerriesAreSharedNotFairies() {
        let scene = StoryCountScene.math(
            prompt: "Luma shares 18 berries among 3 fairy friends equally. How many does each friend get?",
            explanation: "18 ÷ 3 = 6."
        )
        XCTAssertEqual(scene?.picture.name, "berry")
        guard case .rows(let groups, let each) = scene?.arrangement else {
            return XCTFail("Expected berry groups")
        }
        XCTAssertEqual(groups, 3)
        XCTAssertEqual(each, 6)
    }

    func testBeadsInPouchesShowBeads() {
        let scene = StoryCountScene.math(
            prompt: "Luma gathers 3 pouches with 8 sparkle beads in each pouch. How many beads does she gather?",
            explanation: "3 × 8 = 24."
        )
        XCTAssertEqual(scene?.picture.name, "bead")
        guard case .rows(let groups, let each) = scene?.arrangement else {
            return XCTFail("Expected bead rows")
        }
        XCTAssertEqual(groups, 3)
        XCTAssertEqual(each, 8)
    }

    func testGroupsOfBeadsShowRows() {
        let scene = StoryCountScene.math(
            prompt: "Luma has 10 beads. She puts them in groups of 5. How many groups is that?",
            explanation: "10 ÷ 5 = 2."
        )
        XCTAssertEqual(scene?.picture.name, "bead")
        guard case .rows(let groups, let each) = scene?.arrangement else {
            return XCTFail("Expected groups of beads")
        }
        XCTAssertEqual(groups, 2)
        XCTAssertEqual(each, 5)
    }

    func testMushroomRows() {
        let scene = StoryCountScene.math(
            prompt: "Luma arranges mushroom caps into 3 rows with 4 caps in each row. How many mushroom caps are there?",
            explanation: "3 × 4 = 12."
        )
        XCTAssertEqual(scene?.picture.name, "mushroom")
        guard case .rows(let groups, let each) = scene?.arrangement else {
            return XCTFail("Expected mushroom rows")
        }
        XCTAssertEqual(groups, 3)
        XCTAssertEqual(each, 4)
    }

    func testLengthDoesNotShowFifteenFerns() {
        let scene = StoryCountScene.math(
            prompt: "A fern stem is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?",
            explanation: "15 − 9 = 6."
        )
        XCTAssertEqual(scene?.picture.name, "fern")
        guard case .visit(let count) = scene?.arrangement else {
            return XCTFail("Expected two ferns, not a length turned into a count")
        }
        XCTAssertEqual(count, 2)
    }

    func testStarfishIsNotANightStar() {
        let scene = StoryCountScene.math(
            prompt: "Count the starfish: there are three starfish on a rock. How many starfish are there?",
            explanation: "The total is 3."
        )
        XCTAssertEqual(scene?.picture.name, "sea star")
        guard case .gather(let shown, let joining) = scene?.arrangement else {
            return XCTFail("Expected starfish to count")
        }
        XCTAssertEqual(shown, 3)
        XCTAssertNil(joining)
    }

    func testMissingStartShowsTheTotalAlreadyNamed() {
        let scene = StoryCountScene.math(
            prompt: "Some fairies were glowing. 2 more fairies arrived, and now there are 7. How many fairies were there at the start?",
            explanation: "7 − 2 = 5."
        )
        XCTAssertEqual(scene?.picture.name, "fairy")
        guard case .gather(let shown, let joining) = scene?.arrangement else {
            return XCTFail("Expected the 7 fairies the question already names")
        }
        XCTAssertEqual(shown, 7)
        XCTAssertNil(joining)
    }

    func testGrainScoopsAreNotStoryEggs() {
        let scene = StoryCountScene.math(
            prompt: "A feed bin holds 10 scoops of grain. Farmer Jo gives 4 scoops to the hens. How many scoops are left?",
            explanation: nil,
            title: "Eggs for the Basket",
            opening: "Farmer Jo sorts eggs before a busy morning.",
            passage: "Farmer Jo collects eggs from the henhouse at dawn. She checks how many eggs she has gathered and how many feed buckets still need filling."
        )
        XCTAssertEqual(scene?.picture.name, "scoop")
        guard case .depart(let start, let leaving) = scene?.arrangement else {
            return XCTFail("Expected 10 scoops with 4 given away, not the story's eggs")
        }
        XCTAssertEqual(start, 10)
        XCTAssertEqual(leaving, 4)
    }

    func testMathQuestionsPictureTheNumbersTheyAsk() {
        var mismatches: [String] = []
        for topic in Topic.allCases {
            for mathLevel in MathLevel.allCases {
                guard let lesson = CuratedTopicLessonBank.mathScene(
                    topic: topic,
                    mathLevel: mathLevel,
                    readingLevel: .earlyReader
                ) else { continue }
                let prompts = lesson.problems.map { ($0.prompt, $0.explanation) }
                    + [(lesson.reflectionPrompt, nil as String?)]
                for (prompt, explanation) in prompts {
                    guard Self.statesACount(prompt) else { continue }
                    guard let scene = StoryCountScene.math(
                        prompt: prompt,
                        explanation: explanation,
                        title: lesson.title,
                        opening: lesson.storyOpening,
                        passage: lesson.readingPassage
                    ) else {
                        mismatches.append("\(topic.rawValue): no picture for \(prompt)")
                        continue
                    }
                    let shown = Self.amounts(in: scene.arrangement)
                    let named = Self.numbers(in: prompt)
                    if !Self.amountsMatch(shown, named: named) {
                        mismatches.append("\(topic.rawValue): \(scene.picture.plural) \(shown) not in \"\(prompt)\"")
                    }
                }
            }
        }
        XCTAssertTrue(mismatches.isEmpty, mismatches.prefix(24).joined(separator: "\n"))
    }

    private static func statesACount(_ prompt: String) -> Bool {
        let lower = prompt.lowercased()
        if lower.range(of: #"\d+"#, options: .regularExpression) != nil { return true }
        let words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve"]
        return words.contains { word in
            lower.range(of: "\\b\(word)\\b", options: .regularExpression) != nil
        }
    }

    private static func numbers(in prompt: String) -> Set<Int> {
        let lower = prompt.lowercased()
        var found = Set<Int>()
        if let regex = try? NSRegularExpression(pattern: #"\d+"#) {
            let ns = lower as NSString
            for match in regex.matches(in: lower, range: NSRange(location: 0, length: ns.length)) {
                if let value = Int(ns.substring(with: match.range)) {
                    found.insert(value)
                }
            }
        }
        let words = [
            "twelve": 12, "eleven": 11, "ten": 10, "nine": 9, "eight": 8, "seven": 7,
            "six": 6, "five": 5, "four": 4, "three": 3, "two": 2, "one": 1
        ]
        for (word, value) in words where lower.range(of: "\\b\(word)\\b", options: .regularExpression) != nil {
            found.insert(value)
        }
        return found
    }

    /// A pictured amount has to be a number the question says, one of the subject when the
    /// real total is too big to draw, or the groups that multiply or add back to a stated number.
    private static func amountsMatch(_ shown: [Int], named: Set<Int>) -> Bool {
        if shown.allSatisfy({ named.contains($0) || $0 == 1 }) { return true }
        if shown.count == 2 {
            let a = shown[0]
            let b = shown[1]
            if named.contains(a + b) || named.contains(a * b) || named.contains(abs(a - b)) {
                return true
            }
        }
        return false
    }

    private static func amounts(in arrangement: StoryCountScene.Arrangement) -> [Int] {
        switch arrangement {
        case .gather(let shown, let joining):
            return [shown] + (joining.map { [$0] } ?? [])
        case .depart(let start, let leaving):
            return [start, leaving]
        case .rows(let groups, let each):
            return [groups, each]
        case .beside(let left, let right):
            return [left.count, right.count]
        case .visit(let count):
            return [count]
        }
    }

    func testFossilsShowTheWaitingGroupThenTheNewTotal() {
        let scene = StoryCountScene.math(
            prompt: "Eight fossils were waiting at the dig site. Some more arrived, and now there are 9. How many fossils joined?",
            explanation: "9 − 8 = 1."
        )
        XCTAssertEqual(scene?.picture.name, "fossil")
        guard case .gather(let shown, let joining) = scene?.arrangement else {
            return XCTFail("Expected 8 fossils, then enough to make 9")
        }
        XCTAssertEqual(shown, 8)
        XCTAssertEqual(joining, 1)
    }

    func testHeroesInTheCitySquareAreHeroesNotSquares() {
        let scene = StoryCountScene.math(
            prompt: "There are 8 heroes in the city square. How many heroes are there?",
            explanation: "The total is 8."
        )
        XCTAssertEqual(scene?.picture.name, "hero")
        XCTAssertEqual(scene?.picture.motion, .float)
        guard case .gather(let shown, let joining) = scene?.arrangement else {
            return XCTFail("Expected heroes to count")
        }
        XCTAssertEqual(shown, 8)
        XCTAssertNil(joining)
    }

    func testCountedSquaresStaySquares() {
        let scene = StoryCountScene.math(
            prompt: "There are 8 squares on the page. How many squares are there?",
            explanation: "The total is 8."
        )
        XCTAssertEqual(scene?.picture.name, "square")
    }

    func testVolcanoStoryShowsTheRocksAndSensorsItCounts() {
        let scene = StoryCountScene.story(
            title: "Count the Rocks",
            opening: "Dr. Nolan needs a careful count near the volcano.",
            passage: "Four rocks sit near the volcano. Two sensors rest beside them. Dr. Nolan points and counts out loud."
        )
        guard case .beside(let left, let right) = scene?.arrangement else {
            return XCTFail("Expected the counted rocks and sensors")
        }
        XCTAssertEqual(left.picture.name, "rock")
        XCTAssertEqual(left.count, 4)
        XCTAssertEqual(right.picture.name, "sensor")
        XCTAssertEqual(right.count, 2)
        XCTAssertEqual(scene?.spokenLabel, "4 rocks and 2 sensors.")
    }

    func testDrNolanVolcanoStoryShowsOneVolcano() {
        let scene = StoryCountScene.story(
            title: "Dr. Nolan Studies a Volcano",
            opening: "Dr. Nolan stands near a tall mountain. Will you watch the volcano with her?",
            passage: "Dr. Nolan sees smoke rising high from the mountain. Hot rock glows red near the top. The mountain rumbles under her boots."
        )
        XCTAssertEqual(scene?.picture.name, "volcano")
        guard case .visit(let count) = scene?.arrangement else {
            return XCTFail("Expected one volcano")
        }
        XCTAssertEqual(count, 1)
        XCTAssertEqual(scene?.spokenLabel, "Volcano")
    }

    func testHotRockQuestionUsesOneGlowingRock() {
        let scene = StoryCountScene.math(
            prompt: "What color is the hot rock?",
            explanation: "Hot rock glows red.",
            title: "Dr. Nolan Studies a Volcano",
            opening: "Dr. Nolan stands near a tall mountain. Will you watch the volcano with her?",
            passage: "Dr. Nolan sees smoke rising high from the mountain. Hot rock glows red near the top. The mountain rumbles under her boots."
        )
        XCTAssertEqual(scene?.picture.name, "hot rock")
        guard case .visit(let count) = scene?.arrangement else {
            return XCTFail("Expected the one hot rock from the question")
        }
        XCTAssertEqual(count, 1)
    }

    func testWeeksLaterIsNotACountOfVolcanoes() {
        let scene = StoryCountScene.story(
            title: "Two Clues Behind Dr. Nolan's Warning",
            opening: "Unusual readings flash on Dr. Nolan's instruments.",
            passage: "Fifteen weeks later the volcano erupted with small amounts of ash."
        )
        guard case .visit = scene?.arrangement else {
            return XCTFail("A span of weeks should not become fifteen volcanoes")
        }
        XCTAssertEqual(scene?.picture.name, "volcano")
    }

    func testCountingVolcanicRocksShowsThatMany() {
        let scene = StoryCountScene.math(
            prompt: "Count the volcanic rocks: there are five volcanic rocks near the crater. How many volcanic rocks are there?",
            explanation: "Count each rock.",
            title: "Count the Rocks",
            passage: "Four rocks sit near the volcano. Two sensors rest beside them."
        )
        XCTAssertEqual(scene?.picture.name, "rock")
        guard case .gather(let shown, let joining) = scene?.arrangement else {
            return XCTFail("Expected five volcanic rocks to count")
        }
        XCTAssertEqual(shown, 5)
        XCTAssertNil(joining)
    }

    func testVolcanicRocksJoinInTheAmountsTheProblemStates() {
        let scene = StoryCountScene.math(
            prompt: "Dr. Nolan sees 2 volcanic rocks, then 2 more join. How many volcanic rocks in all?",
            explanation: "2 + 2 = 4.",
            title: "Count the Rocks",
            passage: "Four rocks sit near the volcano. Two sensors rest beside them."
        )
        XCTAssertEqual(scene?.picture.name, "rock")
        guard case .gather(let shown, let joining) = scene?.arrangement else {
            return XCTFail("Expected volcanic rocks joining")
        }
        XCTAssertEqual(shown, 2)
        XCTAssertEqual(joining, 2)
    }

    func testKindBarnDrawingShowsThePonyNotTheBarn() {
        let scene = StoryCountScene.story(
            title: "Kind Barn Drawing",
            opening: "A brown pony stands in a quiet barn.",
            passage: "Soft voices help ponies stay calm.",
            goals: ["Brown pony", "Blue bucket", "Gold hay"]
        )
        XCTAssertEqual(scene?.picture.name, "pony")
    }

    func testOctopusSceneShowsTheOctopusNotTheRock() {
        let scene = StoryCountScene.story(
            title: "Design Octopus Camouflage Art",
            opening: "An octopus sits on a rock.",
            passage: "One arm is bumpy. The water is green-blue.",
            goals: ["Octopus", "Matching rock", "Bumpy arm"]
        )
        XCTAssertEqual(scene?.picture.name, "octopus")
    }

    func testTwoDinosaurSpeciesLeadsWithTriceratops() {
        let scene = StoryCountScene.story(
            title: "Two Dinosaur Species",
            opening: "Triceratops stands with three horns and flat teeth.",
            passage: "Triceratops ate plants. Tyrannosaurus ate meat.",
            goals: ["Triceratops", "Three horns", "Tyrannosaurus"]
        )
        XCTAssertEqual(scene?.picture.name, "triceratops")
    }

    func testStoryPicturesMatchTheNamedSubjects() {
        let samples: [(String, [String], String)] = [
            ("A giraffe stretches its long neck to high leaves.", ["Giraffe", "Long neck", "Leaves"], "giraffe"),
            ("An elephant throws tan dust on its back.", ["Elephant", "Dust", "Calf"], "elephant"),
            ("A wind vane points toward the blowing wind.", ["Wind vane", "Leaning tree", "Leaves"], "wind vane"),
            ("Earth spins beside the bright yellow Sun.", ["Earth", "Yellow Sun", "Night side"], "earth"),
            ("Venus shines with a pale yellow glow.", ["Venus", "Cloud blanket", "Glow"], "venus"),
            ("A spacecraft follows a curved path around Earth.", ["Spacecraft", "Curved path", "Earth"], "spacecraft"),
            ("Orange magma sits under the ground.", ["Magma", "Lava", "Color key"], "magma"),
            ("The traffic light is red.", ["Traffic light", "Blue car", "Walker"], "traffic light"),
            ("A shiny hubcap covers the wheel.", ["Hubcap", "Crosswalk"], "hubcap"),
            ("A hawk flies above the field.", ["Hawk"], "hawk"),
            ("A caterpillar eats.", ["Caterpillar"], "caterpillar")
        ]
        for (opening, goals, name) in samples {
            let scene = StoryCountScene.story(title: "Story", opening: opening, passage: "", goals: goals)
            XCTAssertEqual(scene?.picture.name, name, opening)
        }
    }

    func testHarborMapShowsTheLighthouse() {
        let scene = StoryCountScene.story(
            title: "Harbor Map Drawing",
            opening: "A harbor map shows a channel, a sandbar, and a lighthouse.",
            passage: "The lighthouse is white with a black stripe.",
            goals: ["Channel", "Sandbar", "Lighthouse"]
        )
        XCTAssertEqual(scene?.picture.name, "lighthouse")
    }

    func testBarnMorningShowsTheRedBarn() {
        let scene = StoryCountScene.story(
            title: "Barn Morning Drawing",
            opening: "A red barn sits under a yellow sun.",
            passage: "A brown cow stands by a water trough. A white chicken pecks grain."
        )
        XCTAssertEqual(scene?.picture.name, "barn")
    }

    func testYellowSunShowsTheSun() {
        let scene = StoryCountScene.story(
            title: "Morning Light",
            opening: "A yellow sun rises over the field.",
            passage: "The grass warms up."
        )
        XCTAssertEqual(scene?.picture.name, "sun")
    }

    func testNextNumberStillUsesTheStorySubject() {
        let scene = StoryCountScene.math(
            prompt: "Luma counts 6, then one more. Which number comes next?",
            explanation: "6 + 1 = 7, so 7 comes next.",
            title: "Count the Fairies",
            passage: "Four fairies flutter above the ferns. Two flowers bloom in a ring."
        )
        XCTAssertEqual(scene?.picture.name, "fairy")
        guard case .gather(let shown, let joining) = scene?.arrangement else {
            return XCTFail("Expected one more fairy joining")
        }
        XCTAssertEqual(shown, 6)
        XCTAssertEqual(joining, 1)
    }
}
