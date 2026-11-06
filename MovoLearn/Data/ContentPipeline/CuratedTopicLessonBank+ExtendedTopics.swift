import Foundation

/// Extended hand-authored, topic-specific lesson content for topics beyond the
/// original curated five (horses, jungle, ocean, space, dinosaurs).
/// Same quality bar: each topic x level pack has its own characters, facts,
/// vocabulary, story, and questions — never a noun-swapped template.
extension CuratedTopicLessonBank {

    // MARK: - Public lookup

    static func extendedReadingPack(topic: Topic, level: ReadingLevel) -> ReadingPack? {
        switch topic {
        case .soccer: return soccerReading(level)
        case .basketball: return basketballReading(level)
        case .dogs: return dogsReading(level)
        case .cats: return catsReading(level)
        case .princesses: return princessesReading(level)
        case .castles: return castlesReading(level)
        case .fairies: return fairiesReading(level)
        case .airplanes: return airplanesReading(level)
        case .trains: return trainsReading(level)
        case .cars: return carsReading(level)
        case .robots: return robotsReading(level)
        case .superheroes: return superheroesReading(level)
        case .art: return artReading(level)
        case .music: return musicReading(level)
        case .cooking: return cookingReading(level)
        case .nature: return natureReading(level)
        case .bugs: return bugsReading(level)
        case .volcanoes: return volcanoesReading(level)
        case .weather: return weatherReading(level)
        case .farmAnimals: return farmAnimalsReading(level)
        case .zooAnimals: return zooAnimalsReading(level)
        case .pirates: return piratesReading(level)
        default: return nil
        }
    }

    static func extendedMathScene(topic: Topic, mathLevel: MathLevel, readingLevel: ReadingLevel) -> MathScene? {
        switch topic {
        case .soccer: return soccerMath(mathLevel, reading: readingLevel)
        case .basketball: return basketballMath(mathLevel, reading: readingLevel)
        case .dogs: return dogsMath(mathLevel, reading: readingLevel)
        case .cats: return catsMath(mathLevel, reading: readingLevel)
        case .princesses: return princessesMath(mathLevel, reading: readingLevel)
        case .castles: return castlesMath(mathLevel, reading: readingLevel)
        case .fairies: return fairiesMath(mathLevel, reading: readingLevel)
        case .airplanes: return airplanesMath(mathLevel, reading: readingLevel)
        case .trains: return trainsMath(mathLevel, reading: readingLevel)
        case .cars: return carsMath(mathLevel, reading: readingLevel)
        case .robots: return robotsMath(mathLevel, reading: readingLevel)
        case .superheroes: return superheroesMath(mathLevel, reading: readingLevel)
        case .art: return artMath(mathLevel, reading: readingLevel)
        case .music: return musicMath(mathLevel, reading: readingLevel)
        case .cooking: return cookingMath(mathLevel, reading: readingLevel)
        case .nature: return natureMath(mathLevel, reading: readingLevel)
        case .bugs: return bugsMath(mathLevel, reading: readingLevel)
        case .volcanoes: return volcanoesMath(mathLevel, reading: readingLevel)
        case .weather: return weatherMath(mathLevel, reading: readingLevel)
        case .farmAnimals: return farmAnimalsMath(mathLevel, reading: readingLevel)
        case .zooAnimals: return zooAnimalsMath(mathLevel, reading: readingLevel)
        case .pirates: return piratesMath(mathLevel, reading: readingLevel)
        default: return nil
        }
    }

    // MARK: - Soccer (Lena, Coach Priya — field drills, passing, defense clues)

    private static func soccerReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Lena's First Kick",
                storyOpening: "Lena laces up her cleats. Will you join her on the field?",
                missionPrompt: "Check what Lena does with the ball.",
                readingPassage: "Lena kicks the soccer ball across the grass. She passes to Coach Priya. The ball rolls to a teammate. Everyone claps for the pass.",
                questions: [
                    mcq("What does Lena kick?", ["The ball", "A traffic cone", "A water bottle"], "The ball", "Lena kicks the ball."),
                    mcq("Who does Lena pass to?", ["Coach Priya", "A stranger", "No one"], "Coach Priya", "Lena passes to Coach Priya."),
                    mcq("Where does the ball roll?", ["To a teammate", "Off the field", "Under the goal net"], "To a teammate", "The ball rolls to a teammate.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "kick", definition: "To hit something with your foot.", exampleSentence: "Lena can kick the ball."),
                    VocabularyWord(word: "pass", definition: "To send the ball to a teammate.", exampleSentence: "Lena will pass to a friend.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Passing the ball to a teammate is a key soccer skill.", explanation: "Good passes help a team move the ball down the field.")
                ],
                creativePrompt: "Draw Lena kicking the ball to a teammate.",
                creativeResponseType: .drawing,
                storyEnding: "Lena's pass helps the team. Great teamwork!",
                readingSkill: "Follow a simple soccer play",
                reflectionPrompt: "What did Lena do with the ball?",
                hints: ["Find the word kick", "Look for the word pass"],
                commonMistakes: ["Choosing an object that is not the ball"],
                successCriteria: ["Names a real soccer action from the story"],
                learningObjectives: ["Identify concrete details in a short soccer story"],
                activityFingerprint: "soccer.k.first-kick.detail",
                characterNames: ["Lena", "Coach Priya"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Warm-Up Before the Game",
                storyOpening: "The field is green and the whistle is ready. It is warm-up time!",
                missionPrompt: "Discover how Lena warms up before the game.",
                readingPassage: "Lena jogs around the field to warm up her legs. Coach Priya asks the team to stretch before any kicking. Lena dribbles the ball between orange cones without looking down. A teammate passes the ball back, and Lena traps it with her foot. Coach Priya cheers for the careful dribbling.",
                questions: [
                    mcq("What does Coach Priya ask the team to do first?", ["Stretch before kicking", "Skip the warm-up", "Score a goal right away"], "Stretch before kicking", "Coach Priya asks the team to stretch before any kicking."),
                    mcq("What does Lena dribble between?", ["Orange cones", "Tall trees", "Parked cars"], "Orange cones", "Lena dribbles the ball between orange cones."),
                    mcq("What does Lena do when the ball comes back?", ["Traps it with her foot", "Throws it over the fence", "Ignores it completely"], "Traps it with her foot", "Lena traps the ball with her foot.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "dribble", definition: "To move the ball with quick, light kicks.", exampleSentence: "Lena can dribble between the cones."),
                    VocabularyWord(word: "stretch", definition: "To gently loosen your muscles before exercise.", exampleSentence: "The team stretches before practice.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Stretching before a game helps muscles warm up and move safely.", explanation: "Warm muscles are less likely to get hurt during a fast game.")
                ],
                creativePrompt: "Draw Lena dribbling the ball between two cones.",
                creativeResponseType: .drawing,
                storyEnding: "Lena's careful dribbling earns a cheer from Coach Priya.",
                readingSkill: "Recall warm-up details from a soccer passage",
                reflectionPrompt: "Why might stretching before a game be a good idea?",
                hints: ["Find the sentence about stretching", "Look for the word dribble"],
                commonMistakes: ["Skipping the stretching detail"],
                successCriteria: ["Uses a warm-up detail from the story"],
                learningObjectives: ["Recall key details from a short soccer passage"],
                activityFingerprint: "soccer.early.warmup.detail",
                characterNames: ["Lena", "Coach Priya"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Lena Passes Instead of Racing Alone",
                storyOpening: "Lena races toward the goal — but a defender blocks her path.",
                missionPrompt: "Figure out why Lena passes instead of racing alone.",
                readingPassage: "During a practice game, Lena dribbled toward the goal until a defender stepped into her path. Instead of trying to push through alone, Lena looked up and spotted a teammate open near the goal. She passed the ball across the field, and her teammate scored. Coach Priya explained that soccer works best when players share the ball instead of racing alone. Passing to an open teammate can create a better chance to score than one player trying everything alone. Lena's team ended practice with three goals, each one built on a smart pass.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Sharing the ball with teammates can create better scoring chances", "Only one player should ever touch the ball", "Defenders should be ignored completely"], "Sharing the ball with teammates can create better scoring chances", "Coach Priya explains that sharing the ball creates better chances to score."),
                    mcq("Why did Lena pass instead of racing alone?", ["A defender blocked her path and a teammate was open", "She was too tired to run", "She forgot how to dribble"], "A defender blocked her path and a teammate was open", "A defender blocked Lena's path, so she passed to an open teammate."),
                    mcq("How did practice end?", ["With three goals built on smart passes", "With no goals at all", "With the team quitting early"], "With three goals built on smart passes", "Practice ended with three goals, each built on a smart pass.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "defender", definition: "A player who tries to stop the other team from scoring.", exampleSentence: "A defender blocked Lena's path."),
                    VocabularyWord(word: "teamwork", definition: "Working together toward the same goal.", exampleSentence: "Teamwork helped the team score three goals.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Passing to an open teammate often creates a better scoring chance than dribbling alone.", explanation: "A defender can only guard one player at a time.")
                ],
                creativePrompt: "Draw the moment Lena passes to her open teammate near the goal.",
                creativeResponseType: .drawing,
                storyEnding: "Lena learns that a smart pass can be stronger than racing alone.",
                readingSkill: "Identify the main idea in a soccer teamwork passage",
                reflectionPrompt: "When have you shared with a teammate to reach a bigger goal?",
                hints: ["Reread what Coach Priya explained", "Compare racing alone with passing"],
                commonMistakes: ["Thinking dribbling alone is always the best choice"],
                successCriteria: ["States the teamwork main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction sports passage"],
                activityFingerprint: "soccer.growing.teamwork.main-idea",
                characterNames: ["Lena", "Coach Priya"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Reading the Defender's Next Move",
                storyOpening: "Lena watches the defender's feet before she decides what to do.",
                missionPrompt: "Figure out why Lena changes her plan with the ball.",
                readingPassage: """
                During the second half, Lena dribbled toward midfield while watching how the defender moved. She noticed the defender leaned toward the left side of the field, leaving the right side more open. At the same time, a teammate near the right sideline waved for the ball. Lena compared both clues — the defender's lean and her teammate's position — before deciding to pass right instead of dribbling left. The pass reached her teammate cleanly. Then her teammate carried the ball forward for a shot on goal. Coach Priya later explained that reading a defender's balance and a teammate's position together often reveals the smartest next move. Lena realized that soccer decisions work best when a player weighs more than one clue at a time, not just the ball at her feet.
                """,
                questions: [
                    mcq("Why did Lena pass right instead of dribbling left?", ["The defender leaned left, leaving the right side more open", "The defender was covering the right sideline, so left looked safer", "Coach Priya told her to stop using her teammates"], "The defender leaned left, leaving the right side more open", "The defender leaned left, so Lena passed to the open teammate on the right."),
                    mcq("Where was Lena's teammate when she passed?", ["Near the right sideline", "Standing in the goal", "Waiting on the bench"], "Near the right sideline", "A teammate near the right sideline waved for the ball."),
                    mcq("What happened after Lena's pass reached her teammate?", ["The teammate carried the ball forward for a shot on goal", "The defender stole the ball and the play ended", "Coach Priya stopped the game immediately"], "The teammate carried the ball forward for a shot on goal", "The teammate carried the ball forward for a shot on goal.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "balance", definition: "How steadily a person is standing or leaning.", exampleSentence: "The defender's balance leaned to the left."),
                    VocabularyWord(word: "position", definition: "Where a player is standing on the field.", exampleSentence: "Lena's teammate called out her position.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Skilled soccer players often watch a defender's balance to guess which way they can move.", explanation: "A defender leaning one way is slower to recover on the other side.")
                ],
                creativePrompt: "Why did Lena pass to the right, and what did her teammate do next?",
                creativeResponseType: .shortText,
                storyEnding: "Lena's pass works because she reads more than one clue before deciding.",
                readingSkill: "Use game clues to explain a soccer decision",
                reflectionPrompt: "What happened after Lena's pass reached her teammate?",
                hints: ["Look for where the defender leaned", "Reread what happened after the pass"],
                commonMistakes: ["Using only one clue instead of comparing both"],
                successCriteria: ["Explains Lena's decision using two details from the passage"],
                learningObjectives: ["Infer a player's reasoning using two pieces of game evidence"],
                activityFingerprint: "soccer.confident.defender-clues.inference",
                characterNames: ["Lena", "Coach Priya"]
            )
        }
    }

    private static func soccerMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Soccer Balls",
                storyOpening: "Lena needs a careful count before practice.",
                missionPrompt: "Count the soccer gear and compare the groups.",
                readingPassage: "Four soccer balls sit in the equipment bag. Two cones stand on the field. Lena points and counts out loud.",
                problems: [
                    mcq("Lena sees 2 soccer balls, then 2 more join. How many soccer balls in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 cones on the left and 3 soccer balls on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Lena counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Lena can count the soccer balls.")],
                knowledgeFacts: [KnowledgeFact(fact: "Coaches count gear before every practice to make sure nothing is missing.")],
                creativePrompt: "Draw 4 soccer balls in the bag.",
                storyEnding: "Lena's gear count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 cones on the left and 3 soccer balls on the right. Which side has more?",
                hints: ["Point to each ball", "Compare the two groups"],
                activityFingerprint: "soccer.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Jerseys for the Team",
                storyOpening: "Lena helps hand out gear before the match.",
                missionPrompt: "Add and subtract to finish the equipment jobs.",
                readingPassage: "Lena counts soccer balls for practice drills. She checks how many she has and how many jerseys still need numbers.",
                problems: [
                    mcq("Lena finds 6 soccer balls. Then she finds 3 more. How many soccer balls in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A duffel bag holds 10 jerseys. Lena hands 4 jerseys to teammates. How many jerseys are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Lena started practice with 8 cones. She gives away 5 cones to Coach Priya. How many cones does Lena have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total soccer balls.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking equipment numbers helps a team get ready faster.")],
                creativePrompt: "Draw 9 soccer balls ready for the match.",
                storyEnding: "The team has everything it needs for the match.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A duffel bag holds 10 jerseys. Lena hands 4 jerseys to teammates. How many jerseys are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "soccer.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Lena",
                pronoun: "she",
                items: [
                    ("cones", "in the gear bag"),
                    ("water bottles", "in the drink cooler"),
                    ("flags", "on the field line")
                ],
                packItem: "cones",
                purpose: "for the scrimmage"
            )
            return MathScene(
                title: "Groups on the Practice Field",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Lena sets out 3 equal groups of 4 water bottles for drills. How many water bottles is that?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A corner flag pole is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten cones.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that all the gear is ready.")],
                creativePrompt: "Draw 3 equal groups of 4 water bottles.",
                storyEnding: "The field is ready for the scrimmage.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Lena sets out 3 equal groups of 4 water bottles for drills. How many water bottles is that?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "soccer.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Match Day Snacks" : "Equal Shares of Orange Slices",
                storyOpening: "Lena plans snacks and gear for the whole team.",
                missionPrompt: multi ? "Solve each soccer problem." : "Solve each soccer problem carefully.",
                readingPassage: "Goal medals and orange slices are shared with the team after the match.",
                problems: [
                    mcq("Lena fills 3 boxes with 8 goal medals in each box. How many medals does she have in all?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Lena shares 18 orange slices among 3 teammates equally. How many does each teammate get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One corner flag pole is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "fair", definition: "The same amount for everyone.", exampleSentence: "A fair share of medals is the same for each.")],
                knowledgeFacts: [KnowledgeFact(fact: "Teams often share orange slices at halftime.")],
                creativePrompt: "Draw the medal packs.",
                storyEnding: "Every teammate gets a fair share. Great teamwork, Lena!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water cooler holds 4 cups of water. Lena adds 2 more cups. How many cups are in the cooler now?",
                hints: mathHints(level),
                activityFingerprint: "soccer.math.advancing.medals"
            )
        }
    }

    // MARK: - Basketball (Theo, Coach Marcus — drills, passing, reading defense)

    private static func basketballReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Theo's First Basket",
                storyOpening: "Theo bounces the ball on the shiny gym floor. He is ready to play.",
                missionPrompt: "Check what Theo does on the court.",
                readingPassage: "Theo dribbles the basketball down the court. He shoots at the hoop. The ball swishes through the net. Coach Marcus claps for Theo.",
                questions: [
                    mcq("What does Theo dribble?", ["The ball", "A traffic cone", "A water bottle"], "The ball", "Theo dribbles the ball."),
                    mcq("Where does Theo shoot?", ["At the hoop", "Out the door", "Into a bag"], "At the hoop", "Theo shoots at the hoop."),
                    mcq("Who claps for Theo?", ["Coach Marcus", "A stranger", "No one"], "Coach Marcus", "Coach Marcus claps for Theo.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "dribble", definition: "To bounce the ball with one hand.", exampleSentence: "Theo can dribble the ball."),
                    VocabularyWord(word: "hoop", definition: "The round rim a basketball goes through.", exampleSentence: "Theo shoots at the hoop.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Dribbling with control helps a player move safely around the court.")
                ],
                creativePrompt: "Draw Theo dribbling toward the hoop.",
                creativeResponseType: .drawing,
                storyEnding: "Theo's basket makes the whole gym cheer!",
                readingSkill: "Follow a simple basketball play",
                reflectionPrompt: "What did Theo do with the ball?",
                hints: ["Find the word dribble", "Look for the word hoop"],
                commonMistakes: ["Choosing an object that is not the ball"],
                successCriteria: ["Names a real basketball action from the story"],
                learningObjectives: ["Identify concrete details in a short basketball story"],
                activityFingerprint: "basketball.k.first-basket.detail",
                characterNames: ["Theo", "Coach Marcus"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Passing Drills Before the Game",
                storyOpening: "Squeaky sneakers echo across the gym. It is drill time!",
                missionPrompt: "Find out what happens in Theo's passing drill.",
                readingPassage: "Theo lines up with his team for a passing drill. Coach Marcus asks every player to pass with two hands on the ball. Theo bounces a pass to a teammate near the free-throw line. His teammate catches it and shoots. The ball drops through the net, and the team cheers for the clean pass.",
                questions: [
                    mcq("What does Coach Marcus ask players to use when passing?", ["Two hands on the ball", "Only one finger", "A rolled-up towel"], "Two hands on the ball", "Coach Marcus asks every player to pass with two hands."),
                    mcq("Where does Theo's pass go?", ["To a teammate near the free-throw line", "Out of the gym", "Onto the bench"], "To a teammate near the free-throw line", "Theo passes to a teammate near the free-throw line."),
                    mcq("What happens after the teammate catches the pass?", ["The teammate shoots and scores", "The ball rolls away unused", "Practice ends immediately"], "The teammate shoots and scores", "The teammate catches the pass, shoots, and scores.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "pass", definition: "To send the ball to a teammate.", exampleSentence: "Theo's pass reached his teammate."),
                    VocabularyWord(word: "free-throw line", definition: "A marked line where players shoot foul shots.", exampleSentence: "The teammate stood near the free-throw line.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Using two hands on a pass helps a player control where the ball goes.")
                ],
                creativePrompt: "Draw Theo passing the ball to a teammate near the free-throw line.",
                creativeResponseType: .drawing,
                storyEnding: "The clean pass turns into a basket the whole team celebrates.",
                readingSkill: "Recall passing details from a basketball passage",
                reflectionPrompt: "Why might two hands help control a pass?",
                hints: ["Find the sentence about two hands", "Look for the free-throw line"],
                commonMistakes: ["Skipping the two-hands detail"],
                successCriteria: ["Uses a passing detail from the story"],
                learningObjectives: ["Recall key details from a short basketball passage"],
                activityFingerprint: "basketball.early.passing-drill.detail",
                characterNames: ["Theo", "Coach Marcus"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Theo Passes to the Open Player",
                storyOpening: "Two defenders crowd Theo near the top of the key. What should he do?",
                missionPrompt: "Figure out why Theo passes to the open player.",
                readingPassage: "During a scrimmage, Theo dribbled near the top of the key until two defenders closed in around him. Instead of forcing a shot through both defenders, Theo spotted a teammate standing wide open near the corner. He passed the ball across the court, and his teammate made an easy shot. Coach Marcus explained that basketball rewards players who notice an open teammate instead of forcing a difficult shot. Passing to open space often creates a better scoring chance than shooting through a crowd. Theo's team scored on three straight plays built on smart, unselfish passes.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Passing to an open teammate can create a better scoring chance", "Every player should always shoot immediately", "Defenders never affect a player's choices"], "Passing to an open teammate can create a better scoring chance", "Coach Marcus explains that passing to open space creates better chances."),
                    mcq("Why did Theo pass instead of shooting?", ["Two defenders crowded him and a teammate was open", "He forgot how to dribble", "The coach told him to sit down"], "Two defenders crowded him and a teammate was open", "Two defenders closed in, so Theo passed to an open teammate."),
                    mcq("How did the scrimmage end?", ["With three scores built on smart passes", "With no scores at all", "With the team leaving early"], "With three scores built on smart passes", "The scrimmage ended with three scores built on smart passes.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "defender", definition: "A player trying to stop the other team from scoring.", exampleSentence: "Two defenders crowded around Theo."),
                    VocabularyWord(word: "open", definition: "Free from defenders, with room to move or shoot.", exampleSentence: "Theo's teammate was wide open.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Passing out of a crowd often leads to an easier shot than forcing one through defenders.")
                ],
                creativePrompt: "Draw the moment Theo passes to his open teammate in the corner.",
                creativeResponseType: .drawing,
                storyEnding: "Theo learns that finding open space can beat forcing a shot.",
                readingSkill: "Identify the main idea in a basketball teamwork passage",
                reflectionPrompt: "When has sharing helped you reach a goal, on or off the court?",
                hints: ["Reread what Coach Marcus explained", "Compare shooting through defenders with passing to open space"],
                commonMistakes: ["Thinking a forced shot is always the best choice"],
                successCriteria: ["States the passing main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction sports passage"],
                activityFingerprint: "basketball.growing.open-pass.main-idea",
                characterNames: ["Theo", "Coach Marcus"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Reading the Defense Before the Shot",
                storyOpening: "Theo studies how the defenders are spaced before he chooses a move.",
                missionPrompt: "Figure out why Theo changes his plan late in the game.",
                readingPassage: """
                Late in the game, Theo dribbled near half-court while watching how the defense was spread out. He noticed one defender drifting toward the ball, leaving a teammate open near the three-point line. At the same time, his coach signaled for a faster pace from the sideline. Theo compared both clues — the drifting defender and the coach's signal — before deciding to pass instead of driving toward the hoop himself. The pass reached his teammate. Then his teammate calmly made the open shot. Coach Marcus later explained that reading a defender's position and a coach's signal together often reveals the smartest next move. Theo realized that basketball decisions work best when a player weighs more than one clue instead of reacting to just the nearest defender.
                """,
                questions: [
                    mcq("Why did Theo pass instead of driving to the hoop?", ["A defender drifted toward the ball, leaving a teammate open", "The hoop was closed for the rest of the game", "Coach Marcus told him to sit on the bench"], "A defender drifted toward the ball, leaving a teammate open", "A drifting defender left a teammate open near the three-point line."),
                    mcq("Where was the open teammate standing?", ["Near the three-point line", "Under the opposite basket", "On the sideline bench"], "Near the three-point line", "A teammate was open near the three-point line."),
                    mcq("What happened after Theo passed the ball?", ["The teammate calmly made the open shot", "The defender stole the pass right away", "The referee ended the game"], "The teammate calmly made the open shot", "The teammate caught the pass and made the open shot.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "signal", definition: "A gesture or sign that sends a message.", exampleSentence: "The coach gave a signal from the sideline."),
                    VocabularyWord(word: "drift", definition: "To move slowly in one direction.", exampleSentence: "The defender began to drift toward the ball.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Skilled basketball players often watch where a defender drifts to find an open teammate.")
                ],
                creativePrompt: "Why did Theo pass instead of driving to the hoop?",
                creativeResponseType: .shortText,
                storyEnding: "Theo's pass works because he reads more than one clue before deciding.",
                readingSkill: "Use game clues to explain a basketball decision",
                reflectionPrompt: "What happened after Theo passed the ball?",
                hints: ["Look for where the open teammate stood", "Reread what happened after Theo passed"],
                commonMistakes: ["Using only one clue instead of comparing both"],
                successCriteria: ["Explains Theo's decision using two details from the passage"],
                learningObjectives: ["Infer a player's reasoning using two pieces of game evidence"],
                activityFingerprint: "basketball.confident.defense-clues.inference",
                characterNames: ["Theo", "Coach Marcus"]
            )
        }
    }

    private static func basketballMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Basketballs",
                storyOpening: "Theo needs a careful count before practice.",
                missionPrompt: "Count the gear and compare the groups.",
                readingPassage: "Four basketballs sit by the court. Two team jerseys hang on the bench. Theo points and counts out loud.",
                problems: [
                    mcq("Theo sees 2 basketballs, then 2 more join. How many basketballs in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 jerseys on the left and 3 basketballs on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Theo counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Theo can count the basketballs.")],
                knowledgeFacts: [KnowledgeFact(fact: "Coaches count gear before every practice to make sure nothing is missing.")],
                creativePrompt: "Draw 4 basketballs by the court.",
                storyEnding: "Theo's gear count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 jerseys on the left and 3 basketballs on the right. Which side has more?",
                hints: ["Point to each ball", "Compare the two groups"],
                activityFingerprint: "basketball.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Jerseys for the Team",
                storyOpening: "Theo helps hand out gear before the game.",
                missionPrompt: "Add and subtract to finish the equipment jobs.",
                readingPassage: "Theo stacks basketballs into the equipment cart. He checks how many balls he has and how many jerseys are still missing.",
                problems: [
                    mcq("Theo finds 6 basketballs. Then he finds 3 more. How many basketballs in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A cone bin holds 10 practice cones. Theo hands 4 cones to another team. How many cones are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Theo needs 8 jerseys for the team. He already has 5. How many more jerseys does he need?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total basketballs.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking equipment numbers helps a team get ready faster.")],
                creativePrompt: "Draw 9 basketballs ready for the game.",
                storyEnding: "The team has everything it needs for the game.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A cone bin holds 10 practice cones. Theo hands 4 cones to another team. How many cones are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "basketball.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Theo",
                pronoun: "he",
                items: [
                    ("trophies", "in the prize box"),
                    ("scorebooks", "in the bench bag"),
                    ("water cups", "on the drink table")
                ],
                packItem: "scorebooks",
                purpose: "for the tournament"
            )
            return MathScene(
                title: "Groups by the Court",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Theo packs 3 boxes of trophies with 4 trophies in each box. How many trophies does he pack in all?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A hoop net string is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten scorebooks.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that all the gear is ready.")],
                creativePrompt: "Draw 3 boxes of trophies with 4 trophies in each box.",
                storyEnding: "The court is ready for the tournament.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Theo packs 3 boxes of trophies with 4 trophies in each box. How many trophies does he pack in all?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "basketball.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Game Day Snacks" : "Equal Shares of Orange Slices",
                storyOpening: "Theo plans snacks and gear for the whole team.",
                missionPrompt: multi ? "Solve each basketball problem." : "Solve each basketball problem carefully.",
                readingPassage: "Victory medals and orange slices are shared with the team after the game.",
                problems: [
                    mcq("Theo packs 3 boxes with 8 victory medals in each box. How many medals does he pack?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Theo shares 18 orange slices among 3 teammates equally. How many does each teammate get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One hoop net string is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "difference", definition: "How much more one number is than another.", exampleSentence: "The difference tells how much longer the first net string is.")],
                knowledgeFacts: [KnowledgeFact(fact: "Players score in basketball by shooting the ball through a hoop.")],
                creativePrompt: "Draw the medal packs.",
                storyEnding: "Every teammate gets a fair share. Great teamwork, Theo!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water station holds 4 cups of water. Theo adds 2 more cups. How many cups are at the station now?",
                hints: mathHints(level),
                activityFingerprint: "basketball.math.advancing.medals"
            )
        }
    }

    // MARK: - Dogs (Ben and puppy Scout — training, manners, body language)

    private static func dogsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Scout Learns to Sit",
                storyOpening: "Ben holds a treat for his puppy, Scout. Can Scout learn a new trick?",
                missionPrompt: "Find out what happens when Ben asks Scout to sit.",
                readingPassage: "Ben says sit to Scout in a calm voice. Scout sits down right away. Ben gives Scout a treat. Scout wags his tail with joy.",
                questions: [
                    mcq("What does Ben say?", ["Sit", "Jump", "Sleep"], "Sit", "Ben says sit."),
                    mcq("What does Scout do?", ["Sits down", "Runs away", "Barks loudly"], "Sits down", "Scout sits down."),
                    mcq("What does Ben give Scout?", ["A treat", "A leash", "A brush"], "A treat", "Ben gives Scout a treat.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "sit", definition: "To lower your body down onto the ground.", exampleSentence: "Scout can sit on command."),
                    VocabularyWord(word: "treat", definition: "A small snack given as a reward.", exampleSentence: "Ben gives Scout a treat.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Puppies can learn simple words like sit with practice and treats.", explanation: "Rewards help puppies remember what to do.")
                ],
                creativePrompt: "Draw Scout sitting for a treat.",
                creativeResponseType: .drawing,
                storyEnding: "Scout learns a new trick and wags his tail with joy!",
                readingSkill: "Follow a simple training story",
                reflectionPrompt: "What trick did Scout learn?",
                hints: ["Find the word sit", "Look for the word treat"],
                commonMistakes: ["Choosing an action Scout did not do"],
                successCriteria: ["Names a real training step from the story"],
                learningObjectives: ["Identify concrete details in a short training story"],
                activityFingerprint: "dogs.k.sit-treat.detail",
                characterNames: ["Ben", "Scout"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Walking Scout on a Leash",
                storyOpening: "Scout tugs hard on his leash at the park gate.",
                missionPrompt: "Follow Scout's walk. Use clues from the text to answer.",
                readingPassage: "Ben clips a leash onto Scout's collar before the walk. Scout wants to run ahead, but Ben asks him to walk beside his leg. Every time Scout walks calmly, Ben says a happy word and gives a small treat. Scout learns that calm walking beside Ben earns rewards. By the end of the walk, Scout trots calmly next to Ben.",
                questions: [
                    mcq("What does Ben clip onto Scout's collar?", ["A leash", "A blanket", "A bell"], "A leash", "Ben clips a leash onto Scout's collar."),
                    mcq("Where does Ben ask Scout to walk?", ["Beside his leg", "Far ahead of him", "Behind a fence"], "Beside his leg", "Ben asks Scout to walk beside his leg."),
                    mcq("What does Ben do when Scout walks calmly?", ["Says a happy word and gives a treat", "Yells loudly", "Ignores Scout completely"], "Says a happy word and gives a treat", "Ben says a happy word and gives a small treat.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "leash", definition: "A strap that connects a person to a dog.", exampleSentence: "Ben clips on the leash before the walk."),
                    VocabularyWord(word: "reward", definition: "Something given for doing well.", exampleSentence: "A treat can be a reward for good walking.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Dogs often repeat behaviors that earn a reward, like a treat or kind word.", explanation: "This is one reason gentle training works well.")
                ],
                creativePrompt: "Draw Scout walking calmly beside Ben on his leash.",
                creativeResponseType: .drawing,
                storyEnding: "Scout trots calmly beside Ben — a walk full of good choices.",
                readingSkill: "Recall training details from a dog passage",
                reflectionPrompt: "Why did Scout start walking calmly?",
                hints: ["Find the sentence about the leash", "Look for the word reward"],
                commonMistakes: ["Skipping the reward detail"],
                successCriteria: ["Uses a training detail from the story"],
                learningObjectives: ["Recall key details from a short training passage"],
                activityFingerprint: "dogs.early.leash-walk.detail",
                characterNames: ["Ben", "Scout"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Scout Stopped Jumping on Guests",
                storyOpening: "When visitors knock, Scout used to leap up to say hello.",
                missionPrompt: "Find the main idea about gentle dog training. Use Ben's practice details.",
                readingPassage: "Scout used to jump on every visitor who walked through the door, even though Ben asked him to stop. Instead of scolding Scout, Ben started rewarding him only when all four paws stayed on the floor. Each time a visitor arrived and Scout stayed calm, Ben gave a treat and gentle praise. Slowly, Scout learned that calm greetings earned more rewards than jumping ever did. After several weeks of practice, Scout greeted new visitors with a wagging tail instead of a jump. Patient, reward-based training changed Scout's habit — and Ben never needed to yell.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Rewarding calm behavior can change a dog's habit over time", "Yelling is the fastest way to train a dog", "Scout never learned to greet visitors calmly"], "Rewarding calm behavior can change a dog's habit over time", "Ben's patient, reward-based training changed Scout's jumping habit."),
                    mcq("What did Ben reward Scout for?", ["Keeping all four paws on the floor", "Jumping higher each time", "Barking at every visitor"], "Keeping all four paws on the floor", "Ben rewarded Scout when all four paws stayed on the floor."),
                    mcq("How did Scout greet visitors after weeks of practice?", ["With a wagging tail instead of a jump", "By hiding under the table", "By jumping even higher"], "With a wagging tail instead of a jump", "Scout greeted visitors with a wagging tail instead of a jump.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "habit", definition: "Something a person or animal does often, almost without thinking.", exampleSentence: "Jumping on guests became a habit for Scout."),
                    VocabularyWord(word: "praise", definition: "Kind words that show approval.", exampleSentence: "Ben's praise helped Scout learn.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Rewarding a calm behavior, instead of punishing an unwanted one, can gently reshape a dog's habits.", explanation: "Positive training focuses on what to reward, not just what to stop.")
                ],
                creativePrompt: "Draw Scout greeting a visitor calmly with all four paws on the floor.",
                creativeResponseType: .drawing,
                storyEnding: "Scout's calm greeting shows how patient training changed a habit.",
                readingSkill: "Identify the main idea in a dog-training passage",
                reflectionPrompt: "Why might rewarding good behavior work better than yelling?",
                hints: ["Reread the last two sentences", "Compare jumping with staying calm"],
                commonMistakes: ["Thinking scolding was what changed Scout's habit"],
                successCriteria: ["States the reward-training main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction training passage"],
                activityFingerprint: "dogs.growing.reward-training.main-idea",
                characterNames: ["Ben", "Scout"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Reading Scout's Tail and Ears",
                storyOpening: "Scout meets a new dog at the park, and Ben watches both animals before they play.",
                missionPrompt: "Use body-language clues to explain why Ben waits, then lets the dogs greet.",
                readingPassage: """
                At the park, Scout trotted toward a new dog with his tail wagging loosely and his ears relaxed. Ben noticed the other dog's tail was tucked low and its ears were pinned back against its head. Instead of letting the dogs meet right away, Ben compared both sets of clues — Scout's relaxed body and the other dog's tense posture — and chose to wait. He walked Scout in a wide, calm circle first, giving the nervous dog space and time to settle. A few minutes later, the other dog's tail loosened and its ears lifted, so Ben allowed a slow greeting. The two dogs sniffed calmly and soon began to play. Ben explained that reading a tail and ears together often shows more about a dog's feelings than either clue alone.
                """,
                questions: [
                    mcq("Why did Ben wait before letting the dogs meet?", ["Scout was relaxed, but the other dog looked tense", "Scout refused to walk any farther", "The park was closing soon"], "Scout was relaxed, but the other dog looked tense", "The other dog's tucked tail and pinned ears showed it was tense."),
                    mcq("How did the other dog look at first?", ["Its tail was tucked low and its ears were pinned back", "Its tail was wagging loosely and its ears were relaxed", "It was already playing with Scout"], "Its tail was tucked low and its ears were pinned back", "The other dog's tail was tucked low and its ears were pinned back."),
                    mcq("What happened after the other dog's tail loosened?", ["Ben allowed a slow, calm greeting", "Ben took Scout home immediately", "The dogs never met at all"], "Ben allowed a slow, calm greeting", "Once the other dog relaxed, Ben allowed a slow greeting.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "posture", definition: "The way a body is held or positioned.", exampleSentence: "The nervous dog's posture looked tense."),
                    VocabularyWord(word: "relaxed", definition: "Calm, with loose and easy body movements.", exampleSentence: "Scout's tail looked relaxed and loose.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "A dog's tail and ears together often reveal more about its mood than either clue alone.", explanation: "Comparing multiple body-language signals leads to safer decisions around dogs.")
                ],
                creativePrompt: "Why did Ben wait before letting the dogs meet?",
                creativeResponseType: .shortText,
                storyEnding: "Ben's patient choice, guided by two clues, leads to a safe and happy play session.",
                readingSkill: "Use body-language clues to explain a decision",
                reflectionPrompt: "What happened after the other dog's tail loosened?",
                hints: ["Look at the other dog's tail and ears", "Reread what Ben did after the dog relaxed"],
                commonMistakes: ["Using only one clue instead of comparing both dogs"],
                successCriteria: ["Explains Ben's decision using two details from the passage"],
                learningObjectives: ["Infer an animal's feelings using two pieces of body-language evidence"],
                activityFingerprint: "dogs.confident.body-language.inference",
                characterNames: ["Ben", "Scout"]
            )
        }
    }

    private static func dogsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Puppies",
                storyOpening: "Ben needs a careful count at the dog park.",
                missionPrompt: "Count the puppies and compare the groups.",
                readingPassage: "Four puppies play in the yard. Two dog treats sit in a bowl. Ben points and counts out loud.",
                problems: [
                    mcq("Ben sees 2 puppies, then 2 more join. How many puppies in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 treats on the left and 3 puppies on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Ben counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Ben can count the puppies.")],
                knowledgeFacts: [KnowledgeFact(fact: "Trainers count treats carefully so every puppy gets a fair turn.")],
                creativePrompt: "Draw 4 puppies in the yard.",
                storyEnding: "Ben's puppy count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 treats on the left and 3 puppies on the right. Which side has more?",
                hints: ["Point to each puppy", "Compare the two groups"],
                activityFingerprint: "dogs.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Treats for Training Time",
                storyOpening: "Ben checks his treat jar before a training session.",
                missionPrompt: "Add and subtract to finish the training jobs.",
                readingPassage: "Ben lines up dog treats for Scout's training session. He checks how many treats he has and how many chew toys are left in the bin.",
                problems: [
                    mcq("Ben finds 6 dog treats. Then he finds 3 more. How many treats in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A toy bin holds 10 chew toys. Ben hands 4 chew toys to other puppies. How many chew toys are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Before fetch, Ben counted 8 tennis balls. After the dogs played, only 5 are left. How many tennis balls are missing?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total dog treats.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking treat numbers helps trainers plan a fair practice session.")],
                creativePrompt: "Draw 9 dog treats ready for training.",
                storyEnding: "Training time is ready to begin.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A toy bin holds 10 chew toys. Ben hands 4 chew toys to other puppies. How many chew toys are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "dogs.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Ben",
                pronoun: "he",
                items: [
                    ("treats", "in the treat pouch"),
                    ("bandanas", "in the scarf bin"),
                    ("leashes", "on the hook")
                ],
                packItem: "treats",
                purpose: "for class"
            )
            return MathScene(
                title: "Groups at the Training Class",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Ben opens 3 packs of puppy bandanas with 4 bandanas in each pack. How many bandanas does he open?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("Scout's leash is 15 centimeters long. Another leash is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten treats.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that all the gear is ready for class.")],
                creativePrompt: "Draw 3 packs with 4 puppy bandanas in each pack.",
                storyEnding: "The training class is ready to begin.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Ben opens 3 packs of puppy bandanas with 4 bandanas in each pack. How many bandanas does he open?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "dogs.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Puppy Playdate Treats" : "Equal Shares of Training Treats",
                storyOpening: "Ben plans treats for a puppy playdate.",
                missionPrompt: multi ? "Solve each puppy problem." : "Solve each puppy problem carefully.",
                readingPassage: "Dog biscuits and training treats are shared with puppy friends after the playdate.",
                problems: [
                    mcq("Ben fills 3 treat jars with 8 dog biscuits in each jar. How many biscuits are in the jars?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Ben shares 18 training treats among 3 puppy friends equally. How many does each puppy get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One leash is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "each", definition: "For every one group.", exampleSentence: "Each box holds the same number of biscuits.")],
                knowledgeFacts: [KnowledgeFact(fact: "Dogs learn faster when trainers reward the behavior they want.")],
                creativePrompt: "Draw the biscuit packs.",
                storyEnding: "Every puppy gets a fair share. Great planning, Ben!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "Scout's water bowl holds 4 cups of water. Ben adds 2 more cups. How many cups are in the bowl now?",
                hints: mathHints(level),
                activityFingerprint: "dogs.math.advancing.biscuits"
            )
        }
    }

    // MARK: - Cats (Ana and Biscuit — grooming routine, cat body language)

    private static func catsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Biscuit Naps in the Sun",
                storyOpening: "Ana's cat, Biscuit, finds a warm sunny spot. Come watch her nap!",
                missionPrompt: "Check what Biscuit does in the sun.",
                readingPassage: "Biscuit stretches her body nice and slow. She curls up in the sun. Ana strokes her soft fur. Biscuit purrs softly.",
                questions: [
                    mcq("What does Biscuit stretch?", ["Her body", "A toy", "A blanket"], "Her body", "Biscuit stretches her body slowly."),
                    mcq("Where does Biscuit curl up?", ["In the sun", "In a cold cave", "Under a cold porch"], "In the sun", "She curls up in the sun."),
                    mcq("What does Biscuit do when Ana strokes her?", ["Purrs softly", "Runs away fast", "Hisses loudly"], "Purrs softly", "Biscuit purrs softly.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "purr", definition: "The soft rumbling sound a happy cat makes.", exampleSentence: "Biscuit purrs softly."),
                    VocabularyWord(word: "stretch", definition: "To reach the body out long.", exampleSentence: "Biscuit likes to stretch.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Cats often purr when they feel calm and happy.", explanation: "A soft purr can be a sign of comfort.")
                ],
                creativePrompt: "Draw Biscuit curled up in a sunny spot.",
                creativeResponseType: .drawing,
                storyEnding: "Biscuit enjoys a warm, peaceful nap in the sun.",
                readingSkill: "Follow a simple cat story",
                reflectionPrompt: "What did Biscuit do in the sun?",
                hints: ["Find the word stretch", "Look for the word purr"],
                commonMistakes: ["Choosing an action Biscuit did not do"],
                successCriteria: ["Names a real detail from Biscuit's nap"],
                learningObjectives: ["Identify concrete details in a short cat story"],
                activityFingerprint: "cats.k.sun-nap.detail",
                characterNames: ["Ana", "Biscuit"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Biscuit's Grooming Time",
                storyOpening: "Biscuit sits on the windowsill after a busy morning. Time to get clean!",
                missionPrompt: "Discover how Biscuit grooms, and what she notices.",
                readingPassage: "Biscuit licks her paw and wipes it over her ear. She uses her rough tongue to smooth down her fur. Her whiskers twitch as she listens for sounds outside the window. When Ana calls her name, Biscuit's ears perk up right away. Biscuit finishes grooming and hops down for a snack.",
                questions: [
                    mcq("What does Biscuit use to clean her fur?", ["Her rough tongue", "A wet towel", "A soft brush only"], "Her rough tongue", "She uses her rough tongue to smooth her fur."),
                    mcq("What do Biscuit's whiskers do?", ["Twitch as she listens for sounds", "Turn a bright color", "Fall off completely"], "Twitch as she listens for sounds", "Her whiskers twitch as she listens for sounds."),
                    mcq("What happens when Ana calls Biscuit's name?", ["Her ears perk up right away", "She stays completely asleep", "She hides under the bed"], "Her ears perk up right away", "Biscuit's ears perk up right away.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "whiskers", definition: "Long stiff hairs on a cat's face that help it feel nearby objects.", exampleSentence: "Biscuit's whiskers twitched."),
                    VocabularyWord(word: "groom", definition: "To clean and smooth fur.", exampleSentence: "Biscuit likes to groom her fur.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Cats use whiskers to feel changes in the air and nearby objects.", explanation: "Whiskers help cats sense their surroundings even in dim light.")
                ],
                creativePrompt: "Draw Biscuit grooming her fur on the windowsill.",
                creativeResponseType: .drawing,
                storyEnding: "Biscuit finishes her grooming routine, clean and ready for a snack.",
                readingSkill: "Recall grooming details from a cat passage",
                reflectionPrompt: "Why might whiskers be helpful to a cat?",
                hints: ["Find the sentence about whiskers", "Look for the word groom"],
                commonMistakes: ["Skipping the whiskers detail"],
                successCriteria: ["Uses a grooming detail from the story"],
                learningObjectives: ["Recall key details from a short cat passage"],
                activityFingerprint: "cats.early.grooming.detail",
                characterNames: ["Ana", "Biscuit"]
            )
        case .growingReader:
            return ReadingPack(
                title: "What Biscuit's Tail Tells Ana",
                storyOpening: "Ana watches Biscuit's tail — it changes with every mood.",
                missionPrompt: "Find out what Biscuit's tail tells Ana about her mood.",
                readingPassage: "Ana began keeping notes about Biscuit's tail because she noticed it moved in different ways. When Biscuit's tail stood straight up with a slight curve, she seemed happy and confident, often trotting toward her food bowl. When her tail swished quickly back and forth, Biscuit usually looked annoyed or overstimulated during playtime. A low, tucked tail appeared only when a loud noise startled her. Ana realized that a cat's tail works like a mood signal, showing feelings before Biscuit ever made a sound. Watching the tail helped Ana know exactly when to play, when to give Biscuit space, and when to speak softly.",
                questions: [
                    mcq("What is the main idea of this passage?", ["A cat's tail can show its mood before it makes a sound", "Cats never move their tails for any reason", "Biscuit's tail always means the same thing"], "A cat's tail can show its mood before it makes a sound", "Ana realized the tail works like a mood signal."),
                    mcq("What did a straight, slightly curved tail usually mean?", ["Biscuit seemed happy and confident", "Biscuit was startled by a noise", "Biscuit wanted to be left alone"], "Biscuit seemed happy and confident", "A straight, curved tail meant Biscuit seemed happy and confident."),
                    mcq("When did Biscuit's tail tuck low?", ["When a loud noise startled her", "Only right before a nap", "Only when she was hungry"], "When a loud noise startled her", "A low, tucked tail appeared when a loud noise startled her.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "signal", definition: "A movement or sound that sends a message.", exampleSentence: "Biscuit's tail works like a mood signal."),
                    VocabularyWord(word: "overstimulated", definition: "Feeling too much excitement or activity at once.", exampleSentence: "Fast tail swishing can mean a cat feels overstimulated.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "A cat's tail position and movement often reveal its mood before any sound is made.", explanation: "Watching tail signals helps people respond kindly to a cat's feelings.")
                ],
                creativePrompt: "Draw Biscuit with a happy, confident tail near her food bowl.",
                creativeResponseType: .drawing,
                storyEnding: "Ana's notes turn tail-watching into a way to understand Biscuit better.",
                readingSkill: "Identify the main idea in a cat body-language passage",
                reflectionPrompt: "Which tail signal would help you know a cat wants space?",
                hints: ["Reread the sentence about the mood signal", "Compare the three tail positions"],
                commonMistakes: ["Thinking every tail movement means the same thing"],
                successCriteria: ["States the tail-signal main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction animal-behavior passage"],
                activityFingerprint: "cats.growing.tail-signals.main-idea",
                characterNames: ["Ana", "Biscuit"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Reading Biscuit's Warning Signs",
                storyOpening: "Vet day feels different — Biscuit is hiding, and Ana wants to know why.",
                missionPrompt: "Check what Biscuit's clues tell Ana before the vet visit.",
                readingPassage: """
                On the morning of Biscuit's vet appointment, Ana noticed her cat hiding under the bed instead of greeting her at the door. Biscuit's ears were flattened slightly, and her usual loud purring had turned into silence. Ana compared two clues: the unfamiliar cat carrier sitting by the door, and the quiet, guarded way Biscuit was sitting. Instead of assuming Biscuit was sick, Ana considered that many cats react to carriers and car rides with stress rather than illness. She gently placed a soft blanket in the carrier and let Biscuit sniff it calmly before the trip. Within a few minutes, Biscuit's ears relaxed slightly, though she stayed quiet during the ride. The vet confirmed Biscuit was healthy — her behavior had been about the unfamiliar carrier, not sickness. Ana learned that comparing more than one clue helps separate stress from illness in a cat's behavior.
                """,
                questions: [
                    mcq("What did Ana conclude about Biscuit's hiding?", ["It was likely stress about the carrier, not illness", "Biscuit was definitely very sick", "Biscuit no longer liked Ana at all"], "It was likely stress about the carrier, not illness", "Ana decided the carrier, not sickness, explained Biscuit's hiding."),
                    mcq("Where was Biscuit hiding that morning?", ["Under the bed", "Inside the carrier", "By the front door"], "Under the bed", "Biscuit was hiding under the bed instead of greeting Ana."),
                    mcq("What did the vet visit confirm?", ["Biscuit was healthy", "Biscuit needed medicine right away", "Biscuit had hurt her paw"], "Biscuit was healthy", "The vet confirmed Biscuit was healthy.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "stress", definition: "A feeling of worry caused by something unfamiliar or difficult.", exampleSentence: "The unfamiliar carrier caused Biscuit stress."),
                    VocabularyWord(word: "guarded", definition: "Careful and a little bit closed off, as if protecting oneself.", exampleSentence: "Biscuit sat in a quiet and guarded way.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Cats can show stress-related behaviors, like hiding, that look similar to signs of illness.", explanation: "Comparing more than one clue helps tell the difference between stress and sickness.")
                ],
                creativePrompt: "Write two sentences about why Biscuit hid and what Ana did to help before the trip.",
                creativeResponseType: .shortText,
                storyEnding: "Ana's careful comparison of clues keeps Biscuit calm and correctly cared for.",
                readingSkill: "Use behavior clues to explain a conclusion about a cat",
                reflectionPrompt: "Which clue would help you the most in a confusing moment like this?",
                hints: ["Look for where Biscuit hid", "Reread what the vet confirmed"],
                commonMistakes: ["Assuming hiding always means illness"],
                successCriteria: ["Explains Ana's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of behavior evidence"],
                activityFingerprint: "cats.confident.stress-clues.conclusion",
                characterNames: ["Ana", "Biscuit"]
            )
        }
    }

    private static func catsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Kittens",
                storyOpening: "Ana needs a careful count at the cat café.",
                missionPrompt: "Count the kittens and compare the groups.",
                readingPassage: "Four kittens sleep in a basket. Two yarn balls sit on the floor. Ana points and counts out loud.",
                problems: [
                    mcq("Ana sees 2 kittens, then 2 more join. How many kittens in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 yarn balls on the left and 3 kittens on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Ana counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Ana can count the kittens.")],
                knowledgeFacts: [KnowledgeFact(fact: "Cat caretakers count kittens carefully to make sure everyone is safe.")],
                creativePrompt: "Draw 4 kittens in a basket.",
                storyEnding: "Ana's kitten count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 yarn balls on the left and 3 kittens on the right. Which side has more?",
                hints: ["Point to each kitten", "Compare the two groups"],
                activityFingerprint: "cats.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Yarn Balls for Playtime",
                storyOpening: "Ana sorts toys before Biscuit's playtime.",
                missionPrompt: "Add and subtract to finish the playtime jobs.",
                readingPassage: "Ana pulls yarn balls out of the toy basket for Biscuit. She checks how many yarn balls she has and how many feather toys still need mending.",
                problems: [
                    mcq("Ana finds 6 yarn balls. Then she finds 3 more. How many yarn balls in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A toy basket holds 10 feather toys. Ana gives 4 feather toys to other kittens. How many feather toys are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Ana started with 8 cat treats in a jar. Then 5 treats roll under the couch. How many treats does she have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total yarn balls.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking toy numbers helps caretakers make sure every kitten has something to play with.")],
                creativePrompt: "Draw 9 yarn balls ready for playtime.",
                storyEnding: "Playtime is ready to begin.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A toy basket holds 10 feather toys. Ana gives 4 feather toys to other kittens. How many feather toys are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "cats.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Ana",
                pronoun: "she",
                items: [
                    ("cat treats", "in the snack jar"),
                    ("blankets", "in the nap basket"),
                    ("toys", "on the play shelf")
                ],
                packItem: "cat treats",
                purpose: "before the café opens"
            )
            return MathScene(
                title: "Groups at the Cat Café",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Ana lays out 3 groups of soft blankets with 4 blankets in each group. How many blankets does she use?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A scratching post is 15 centimeters taller than a mark. Another is 9 centimeters taller. How much taller is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten treats.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that all the café supplies are ready.")],
                creativePrompt: "Draw 3 groups of soft blankets with 4 blankets in each group.",
                storyEnding: "The cat café is ready to open.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Ana lays out 3 groups of soft blankets with 4 blankets in each group. How many blankets does she use?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "cats.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Kitten Playdate Treats" : "Equal Shares of Fish Treats",
                storyOpening: "Ana plans treats for a kitten playdate.",
                missionPrompt: multi ? "Solve each kitten problem." : "Solve each kitten problem carefully.",
                readingPassage: "Cat treats and fish-shaped snacks are shared with kitten friends after the playdate.",
                problems: [
                    mcq("Ana fills 3 treat jars with 8 cat treats in each jar. How many treats does she prepare in all?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Ana shares 18 fish-shaped treats among 3 kitten friends equally. How many does each kitten get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One scratching post is 15 centimeters taller than a mark. Another is 9. How much taller is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "share", definition: "To split into equal parts.", exampleSentence: "Share the treats equally.")],
                knowledgeFacts: [KnowledgeFact(fact: "Cats use whiskers to feel nearby objects, even in dim light.")],
                creativePrompt: "Draw the treat jars.",
                storyEnding: "Every kitten gets a fair share. Great planning, Ana!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "Biscuit's water dish holds 4 cups of water. Ana adds 2 more cups. How many cups are in the dish now?",
                hints: mathHints(level),
                activityFingerprint: "cats.math.advancing.treats"
            )
        }
    }

    // MARK: - Princesses (Princess Elin — kindness, garden, wise choices)

    private static func princessesReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Elin Shares Her Bread",
                storyOpening: "Princess Elin walks through the castle garden. Who needs a kind share?",
                missionPrompt: "Find out what kind thing Elin does.",
                readingPassage: "Elin sees a hungry little bird. She breaks her bread in two. She shares a soft piece. The bird chirps happily.",
                questions: [
                    mcq("What does Elin see?", ["A hungry bird", "A golden crown", "A tall tower"], "A hungry bird", "Elin sees a hungry bird."),
                    mcq("What does Elin break?", ["Her bread", "Her crown", "A stone"], "Her bread", "She breaks her bread."),
                    mcq("What does the bird do?", ["Chirps happily", "Stops singing and hides", "Hides in a tree"], "Chirps happily", "The bird chirps happily.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "share", definition: "To give part of what you have.", exampleSentence: "Elin can share her bread."),
                    VocabularyWord(word: "garden", definition: "A place where plants and flowers grow.", exampleSentence: "Elin walks through the garden.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Many castle gardens grew food that helped feed the people who lived there.", explanation: "Gardens were an important part of castle life.")
                ],
                creativePrompt: "Draw Elin sharing bread with a bird in the garden.",
                creativeResponseType: .drawing,
                storyEnding: "Elin's kind sharing makes the little bird happy.",
                readingSkill: "Follow a simple kindness story",
                reflectionPrompt: "What kind thing did Elin do?",
                hints: ["Find the word share", "Look for the word bird"],
                commonMistakes: ["Choosing an action Elin did not do"],
                successCriteria: ["Names a real kind action from the story"],
                learningObjectives: ["Identify concrete details in a short kindness story"],
                activityFingerprint: "princesses.k.share-bread.detail",
                characterNames: ["Elin"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Elin Visits the Village",
                storyOpening: "Elin trades silk shoes for sturdy boots. She is off to the village!",
                missionPrompt: "Check what Elin does when she visits the baker.",
                readingPassage: "Elin walks to the village to visit the baker and the farmer. She listens carefully as the baker explains that flour prices have risen. Elin does not offer gold right away — she asks questions first to understand the problem. After listening, she arranges for extra wheat from the castle stores to be sent to the village. The baker thanks Elin for listening before deciding what to do.",
                questions: [
                    mcq("What does Elin do before offering help?", ["Asks questions to understand the problem", "Gives gold without listening", "Ignores the baker completely"], "Asks questions to understand the problem", "Elin asks questions first to understand the problem."),
                    mcq("What has happened to flour prices?", ["They have risen", "They have disappeared", "They never change"], "They have risen", "The baker explains that flour prices have risen."),
                    mcq("What does Elin arrange to send?", ["Extra wheat from the castle stores", "A new castle wall", "A royal parade"], "Extra wheat from the castle stores", "She arranges for extra wheat from the castle stores.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "village", definition: "A small community of homes and shops.", exampleSentence: "Elin walks to the village."),
                    VocabularyWord(word: "listen", definition: "To pay careful attention to what someone says.", exampleSentence: "Elin listens before she decides.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Historians study old records to learn how royal families helped villages during hard times.", explanation: "Listening to a problem before acting often leads to better help.")
                ],
                creativePrompt: "Draw Elin listening to the baker in the village.",
                creativeResponseType: .drawing,
                storyEnding: "The baker's thanks show that listening mattered as much as the wheat.",
                readingSkill: "Recall details from a village-visit passage",
                reflectionPrompt: "Why might listening first be a wise choice?",
                hints: ["Find the sentence about asking questions", "Look for what Elin arranges to send"],
                commonMistakes: ["Skipping the listening detail"],
                successCriteria: ["Uses a detail from Elin's village visit"],
                learningObjectives: ["Recall key details from a short passage"],
                activityFingerprint: "princesses.early.village-visit.detail",
                characterNames: ["Elin"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Elin Chose Wheat Over a Parade",
                storyOpening: "Advisors want a grand parade — but Elin has another idea.",
                missionPrompt: "Figure out why Elin chooses wheat over a parade.",
                readingPassage: "When the harvest season arrived, castle advisors suggested a grand parade to celebrate and impress visiting nobles. Elin listened politely, but she had already heard from village farmers that a dry summer had shrunk the wheat supply. Instead of spending the castle's gold on banners and feasts, Elin used it to buy extra grain for families who might run short before spring. Some advisors worried this choice looked less impressive than a parade. Elin explained that a kind decision does not always look the most exciting — it simply helps the most people. By winter, every village family had enough bread, and the story of Elin's quiet choice spread further than any parade could have.",
                questions: [
                    mcq("What is the main idea of this passage?", ["A kind, practical decision can matter more than an impressive show", "Parades are always the wisest use of gold", "Elin ignored the farmers' problem completely"], "A kind, practical decision can matter more than an impressive show", "Elin's choice to help villagers mattered more than an impressive parade."),
                    mcq("Why did Elin buy extra grain instead of planning a parade?", ["A dry summer had shrunk the wheat supply", "She wanted more banners for the castle", "She forgot the parade was planned"], "A dry summer had shrunk the wheat supply", "Village farmers had told her about the dry summer's effect on the wheat supply."),
                    mcq("What happened by winter?", ["Every village family had enough bread", "The village ran out of food completely", "The castle canceled all harvest plans"], "Every village family had enough bread", "By winter, every village family had enough bread.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "advisor", definition: "A person who gives helpful suggestions to a leader.", exampleSentence: "Castle advisors suggested a grand parade."),
                    VocabularyWord(word: "practical", definition: "Useful and sensible, focused on what really helps.", exampleSentence: "Elin made a practical choice instead of a showy one.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Real castles sometimes stored extra grain to help villages survive a difficult harvest.", explanation: "Planning ahead for food shortages was an important part of caring for a kingdom.")
                ],
                creativePrompt: "Draw Elin arranging for extra grain to be sent to the village.",
                creativeResponseType: .drawing,
                storyEnding: "Elin's quiet, practical choice ends up helping more people than a parade ever could.",
                readingSkill: "Identify the main idea in a leadership passage",
                reflectionPrompt: "Would you rather make a choice that looks impressive or one that helps the most people?",
                hints: ["Reread Elin's explanation to her advisors", "Compare the parade idea with the grain idea"],
                commonMistakes: ["Thinking the exciting choice is always the wisest one"],
                successCriteria: ["States the practical-leadership main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction leadership passage"],
                activityFingerprint: "princesses.growing.wise-choice.main-idea",
                characterNames: ["Elin"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "The Mystery of the Empty Stall",
                storyOpening: "One market stall sits empty. Elin wants a real answer before she acts.",
                missionPrompt: "Check what the market clues tell Elin about the empty stall.",
                readingPassage: """
                While visiting the village market, Elin noticed that the weaver's stall stood empty for the third week in a row, while every other stall was busy with customers. She compared two clues before deciding what to do: the weaver's usual customers were now buying cloth from a stall two streets away, and a merchant mentioned that a new road had recently made that farther stall easier to reach. Elin did not assume the weaver had simply lost skill. She decided the new road might explain the empty stall. She arranged for a small sign pointing shoppers toward the weaver's shortcut path through the square. Within two weeks, customers returned, and the weaver's stall filled with visitors again. Elin explained to her advisors that comparing the change in customer habits with the new road told a clearer story than either clue alone.
                """,
                questions: [
                    mcq("What did Elin conclude was the real reason for the empty stall?", ["A new road made a farther stall easier to reach", "The weaver had lost all of her skill", "No one in the village needed cloth anymore"], "A new road made a farther stall easier to reach", "Elin decided the new road, not the weaver's skill, explained the empty stall."),
                    mcq("How long had the weaver's stall stood empty?", ["For the third week in a row", "For one quiet morning", "For a whole year"], "For the third week in a row", "The weaver's stall stood empty for the third week in a row."),
                    mcq("What did Elin do to help the weaver?", ["Arranged a sign pointing shoppers toward a shortcut path", "Closed the market completely", "Told the weaver to change her craft"], "Arranged a sign pointing shoppers toward a shortcut path", "She arranged a sign pointing shoppers toward the weaver's shortcut path.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "merchant", definition: "A person who buys and sells goods.", exampleSentence: "A merchant mentioned the new road."),
                    VocabularyWord(word: "conclude", definition: "To decide something after comparing clues.", exampleSentence: "Elin can conclude what really caused the empty stall.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Village markets could be affected by changes like new roads, not just the quality of what a seller offered.", explanation: "Comparing more than one clue helps avoid an unfair conclusion.")
                ],
                creativePrompt: "Why did Elin decide a new road explained the empty stall?",
                creativeResponseType: .shortText,
                storyEnding: "Elin's careful comparison of clues helps the weaver without any unfair blame.",
                readingSkill: "Use market clues to explain a leader's conclusion",
                reflectionPrompt: "What did Elin do to help shoppers find the weaver's stall?",
                hints: ["Look for why customers had switched stalls", "Reread what Elin did to help"],
                commonMistakes: ["Assuming the empty stall was only the weaver's fault"],
                successCriteria: ["Explains Elin's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "princesses.confident.market-clues.conclusion",
                characterNames: ["Elin"]
            )
        }
    }

    private static func princessesMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Roses",
                storyOpening: "Elin needs a careful count in the castle garden.",
                missionPrompt: "Count the garden items and compare the groups.",
                readingPassage: "Four roses bloom by the fountain. Two jewels sparkle in the crown box. Elin points and counts out loud.",
                problems: [
                    mcq("Elin sees 2 roses, then 2 more join. How many roses in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 jewels on the left and 3 roses on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Elin counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Elin can count the roses.")],
                knowledgeFacts: [KnowledgeFact(fact: "Castle gardeners counted flowers and jewels carefully to keep everything in order.")],
                creativePrompt: "Draw 4 roses by the fountain.",
                storyEnding: "Elin's garden count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 jewels on the left and 3 roses on the right. Which side has more?",
                hints: ["Point to each rose", "Compare the two groups"],
                activityFingerprint: "princesses.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Cupcakes for the Feast",
                storyOpening: "Elin helps plan treats before the feast.",
                missionPrompt: "Add and subtract to finish the feast jobs.",
                readingPassage: "Elin arranges roses for the garden feast. She checks how many roses she has and how many cupcakes still need frosting.",
                problems: [
                    mcq("Elin finds 6 roses. Then she finds 3 more. How many roses in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A gift basket holds 10 cupcakes. Elin gives 4 cupcakes to guests. How many cupcakes are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Elin started with 8 ribbons for the party and handed out 5. How many ribbons does she have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total cupcakes.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking feast numbers helps everyone get a fair share.")],
                creativePrompt: "Draw 9 roses ready for the feast.",
                storyEnding: "The feast is ready for every guest.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A gift basket holds 10 cupcakes. Elin gives 4 cupcakes to guests. How many cupcakes are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "princesses.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Elin",
                pronoun: "she",
                items: [
                    ("roses", "in the flower vase"),
                    ("table settings", "on the feast table"),
                    ("banners", "on the ballroom wall")
                ],
                packItem: "roses",
                purpose: "for the ball"
            )
            return MathScene(
                title: "Groups in the Ballroom",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Elin places 3 rows of banquet settings with 4 settings in each row. How many table settings is that?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A ballroom banner is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten roses.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the ballroom is ready for guests.")],
                creativePrompt: "Draw 3 rows of banquet settings with 4 settings in each row.",
                storyEnding: "The ballroom is ready for the ball.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Elin places 3 rows of banquet settings with 4 settings in each row. How many table settings is that?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "princesses.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Castle Feast Day" : "Equal Shares of Berry Tarts",
                storyOpening: "Elin plans treats and gifts for the whole feast.",
                missionPrompt: multi ? "Solve each feast problem." : "Solve each feast problem carefully.",
                readingPassage: "Jeweled hairpins and berry tarts are shared with guests after the feast.",
                problems: [
                    mcq("Elin makes 3 pouches with 8 jeweled hairpins in each pouch. How many hairpins does she make?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Elin shares 18 berry tarts among 3 tables of guests equally. How many does each table get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One ballroom banner is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "equal", definition: "The same number in each group.", exampleSentence: "Equal groups of hairpins have the same count.")],
                knowledgeFacts: [KnowledgeFact(fact: "A banquet is a large feast held in a castle hall.")],
                creativePrompt: "Draw the hairpin packs.",
                storyEnding: "Every guest gets a fair share. Elin planned the feast well!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A feast pitcher holds 4 cups of lemonade. Elin adds 2 more cups. How many cups are in the pitcher now?",
                hints: mathHints(level),
                activityFingerprint: "princesses.math.advancing.hairpins"
            )
        }
    }

    // MARK: - Castles (Guide Mr. Bram — towers, defense, design clues)

    private static func castlesReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Mr. Bram Lights a Torch",
                storyOpening: "Mr. Bram walks the stone hall at dusk. Can you help light the way?",
                missionPrompt: "Check what Mr. Bram does with the torch.",
                readingPassage: "Mr. Bram lifts a tall torch. He lights the bright flame. He hangs it on the wall. The hall glows warm and bright.",
                questions: [
                    mcq("What does Mr. Bram lift?", ["A torch", "A shield", "A ladder"], "A torch", "Mr. Bram lifts a torch."),
                    mcq("What does he light?", ["The flame", "A candle box", "A wooden door"], "The flame", "He lights the flame."),
                    mcq("Where does he hang the torch?", ["On the wall", "On the roof", "In the moat"], "On the wall", "He hangs it on the wall.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "torch", definition: "A stick with fire used for light.", exampleSentence: "Mr. Bram lifts a torch."),
                    VocabularyWord(word: "hall", definition: "A large room inside a castle.", exampleSentence: "The hall glows warm and bright.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Castles used torches to light dark stone hallways at night.", explanation: "Thick castle walls kept out light, so torches were needed indoors.")
                ],
                creativePrompt: "Draw Mr. Bram hanging a glowing torch on the wall.",
                creativeResponseType: .drawing,
                storyEnding: "The hall glows warm because Mr. Bram lit the torch.",
                readingSkill: "Follow a simple castle story",
                reflectionPrompt: "What did Mr. Bram light?",
                hints: ["Find the word torch", "Look for the word hall"],
                commonMistakes: ["Choosing an object Mr. Bram did not use"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short castle story"],
                activityFingerprint: "castles.k.torch-hall.detail",
                characterNames: ["Mr. Bram"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "A Tour of the Castle Wall",
                storyOpening: "Mr. Bram leads visitors along the thick stone wall. Look carefully!",
                missionPrompt: "Discover how the wall and moat help keep the castle safer.",
                readingPassage: "Mr. Bram points to narrow openings cut into the stone wall. He explains that these slits let people look out while staying behind the thick wall. Below, a deep moat filled with water circles the entire castle. Mr. Bram tells visitors that the moat made it harder for strangers to walk up to the walls. Everyone leans over carefully to peek at the water far below.",
                questions: [
                    mcq("What are the narrow slits used for?", ["Looking out while staying behind the wall", "Letting in fresh air only", "Draining rainwater from the roof"], "Looking out while staying behind the wall", "The slits let people look out while staying behind the thick wall."),
                    mcq("What circles the entire castle?", ["A deep moat filled with water", "A row of tall trees", "A sandy desert path"], "A deep moat filled with water", "A deep moat filled with water circles the entire castle."),
                    mcq("Why did the moat help the castle?", ["It made it harder for strangers to walk up to the walls", "It gave visitors a place to swim", "It grew food for the kitchen"], "It made it harder for strangers to walk up to the walls", "The moat made it harder for strangers to walk up to the walls.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "slit", definition: "A narrow opening in a wall.", exampleSentence: "The slit let people look out from the castle."),
                    VocabularyWord(word: "moat", definition: "A ditch filled with water around a castle.", exampleSentence: "The moat circles the entire castle.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Castle moats were ditches filled with water that made it harder to walk up to the walls.", explanation: "A wide moat helped keep the castle grounds safer.")
                ],
                creativePrompt: "Draw the castle wall with a narrow looking-out slit and the moat below.",
                creativeResponseType: .drawing,
                storyEnding: "Visitors leave understanding how the wall and moat worked together to keep the castle safer.",
                readingSkill: "Recall castle details from a short passage",
                reflectionPrompt: "Which castle feature seems the cleverest to you?",
                hints: ["Find the sentence about the narrow slits", "Look for the word moat"],
                commonMistakes: ["Mixing up what the wall and moat each did"],
                successCriteria: ["Uses a castle detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "castles.early.wall-tour.detail",
                characterNames: ["Mr. Bram"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Castle Walls Were So Thick",
                storyOpening: "A visitor asks why castle walls are so much thicker than house walls.",
                missionPrompt: "Figure out why castle walls were built so thick.",
                readingPassage: "A visitor once asked Mr. Bram why the castle's stone walls stood so much thicker than the walls of an ordinary house. Mr. Bram explained that thick walls served more than one purpose at once. Thick stone made the castle stronger and harder to damage. During ordinary weather, the same thick walls kept the castle cool in summer and warmer in winter, since stone changes temperature slowly. Builders also added narrow looking-out slits and a surrounding moat, so the wall's thickness worked alongside other safety features rather than standing alone. Mr. Bram summed it up simply: a castle's walls were built to protect people from weather and to keep the castle strong at the same time.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Thick castle walls protected people from weather and kept the castle strong", "Thick walls were only useful in rainy weather", "Castle walls were thick purely by accident"], "Thick castle walls protected people from weather and kept the castle strong", "Mr. Bram explains that thick walls served both comfort and strength."),
                    mcq("How did thick walls help during ordinary weather?", ["They kept the castle cool in summer and warmer in winter", "They made the castle always freezing cold", "They had no effect on temperature at all"], "They kept the castle cool in summer and warmer in winter", "Thick stone changes temperature slowly, keeping the castle comfortable."),
                    mcq("What worked alongside the wall's thickness?", ["Looking-out slits and a surrounding moat", "A grand ballroom only", "A single wooden gate"], "Looking-out slits and a surrounding moat", "Builders added looking-out slits and a moat alongside the thick walls.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "purpose", definition: "The reason something is made or done.", exampleSentence: "The thick wall served more than one purpose."),
                    VocabularyWord(word: "strong", definition: "Not easy to break or damage.", exampleSentence: "Thick stone made the castle strong.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Real castles were built with thick walls to stay cool in summer and warm in winter.", explanation: "Thick stone also made the walls stronger.")
                ],
                creativePrompt: "Draw a cross-section of a thick castle wall showing a narrow looking-out slit inside it.",
                creativeResponseType: .drawing,
                storyEnding: "Visitors leave understanding that a castle wall was designed for more than one job.",
                readingSkill: "Identify the main idea in a castle-design passage",
                reflectionPrompt: "How did thick walls help during ordinary weather?",
                hints: ["Reread Mr. Bram's summary sentence", "List both purposes of the thick walls"],
                commonMistakes: ["Thinking thick walls only mattered in rainy weather"],
                successCriteria: ["States the dual-purpose main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction architecture passage"],
                activityFingerprint: "castles.growing.thick-walls.main-idea",
                characterNames: ["Mr. Bram"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "The Mystery of the Sealed Passage",
                storyOpening: "Mr. Bram finds a bricked-up doorway that is missing from every map.",
                missionPrompt: "Check what the wall clues tell Mr. Bram about the sealed spot.",
                readingPassage: """
                While studying an old castle wall, Mr. Bram noticed a section of bricks that looked slightly newer and less weathered than the stone around it. No castle map showed a doorway in that spot, yet the shape of the bricked-up area matched the size of a passage exactly. Mr. Bram compared two clues before drawing a conclusion: the mismatched brick age, and the doorway-shaped outline hidden beneath years of grime. Mr. Bram did not assume the wall had always looked that way. He decided a passage might have been sealed after the map was drawn. Careful tapping along the bricks revealed a hollow sound behind them, matching what an empty passage would sound like. Mr. Bram concluded that a secret passage likely existed there before later builders chose to seal it for safety. He explained that comparing brick age with the hidden outline told a clearer story than either clue alone.
                """,
                questions: [
                    mcq("What did Mr. Bram conclude about the bricked-up area?", ["A secret passage likely existed there before being sealed", "The wall had always been solid stone", "The map was completely wrong about the castle"], "A secret passage likely existed there before being sealed", "Mr. Bram concluded a passage was sealed after the map was drawn."),
                    mcq("What did no castle map show in that spot?", ["A doorway", "A tower", "A moat"], "A doorway", "No castle map showed a doorway in that spot."),
                    mcq("What did the tapping sound reveal?", ["A hollow sound matching an empty passage", "A solid sound matching thick stone", "No sound at all"], "A hollow sound matching an empty passage", "Careful tapping revealed a hollow sound behind the bricks.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "weathered", definition: "Worn or changed by wind, rain, and time.", exampleSentence: "The old stone looked more weathered than the new bricks."),
                    VocabularyWord(word: "conclude", definition: "To decide something after comparing clues.", exampleSentence: "Mr. Bram can conclude what the wall once held.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Some castles have sealed passages that were closed off long after they were first built.", explanation: "Comparing brick age and hidden shapes can reveal a castle's hidden history.")
                ],
                creativePrompt: "Write two sentences about what Mr. Bram noticed in the wall and what the tapping sound proved.",
                creativeResponseType: .shortText,
                storyEnding: "Mr. Bram's careful comparison of clues uncovers a piece of the castle's hidden past.",
                readingSkill: "Use structural clues to explain a historical conclusion",
                reflectionPrompt: "Which clue would convince you the most, and why?",
                hints: ["Look for what the map did not show", "Reread what the tapping sound revealed"],
                commonMistakes: ["Using only one clue instead of comparing both"],
                successCriteria: ["Explains Mr. Bram's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "castles.confident.sealed-passage.conclusion",
                characterNames: ["Mr. Bram"]
            )
        }
    }

    private static func castlesMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Torches",
                storyOpening: "Mr. Bram needs a careful count in the great hall.",
                missionPrompt: "Count the castle items and compare the groups.",
                readingPassage: "Four torches light the hall. Two stones sit in the wall pile. Mr. Bram points and counts out loud.",
                problems: [
                    mcq("Mr. Bram sees 2 torches, then 2 more join. How many torches in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 stones on the left and 3 torches on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Mr. Bram counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Mr. Bram can count the torches.")],
                knowledgeFacts: [KnowledgeFact(fact: "Castle guards counted torches each night to make sure the halls stayed lit.")],
                creativePrompt: "Draw 4 torches in the hall.",
                storyEnding: "Mr. Bram's torch count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 stones on the left and 3 torches on the right. Which side has more?",
                hints: ["Point to each torch", "Compare the two groups"],
                activityFingerprint: "castles.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Candles for the Tower",
                storyOpening: "Mr. Bram checks supplies before nightfall.",
                missionPrompt: "Add and subtract to finish the tower jobs.",
                readingPassage: "Mr. Bram lights torches along the castle wall. He checks how many are lit and how many candles still need placing before nightfall.",
                problems: [
                    mcq("Mr. Bram finds 6 torches. Then he finds 3 more. How many torches in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A supply crate holds 10 candles. Mr. Bram sends 4 candles to another tower. How many candles are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Mr. Bram lined up 8 shields for the hall. A guard lined up only 5. How many more shields did Mr. Bram line up?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total torches.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking supply numbers helped castle staff prepare for cold nights.")],
                creativePrompt: "Draw 9 torches ready for nightfall.",
                storyEnding: "The tower is ready for the night.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A supply crate holds 10 candles. Mr. Bram sends 4 candles to another tower. How many candles are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "castles.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Mr. Bram",
                pronoun: "he",
                items: [
                    ("wall stones", "in the repair cart"),
                    ("banners", "in the hall chest"),
                    ("iron keys", "on the key hook")
                ],
                packItem: "wall stones",
                purpose: "for the repair work"
            )
            return MathScene(
                title: "Groups Along the Wall",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Mr. Bram fills 3 trays of banners with 4 banners in each tray. How many banners are ready?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("The drawbridge chain is 15 centimeters long. Another chain is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten stones.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that wall repairs have enough materials.")],
                creativePrompt: "Draw 3 trays of banners with 4 banners in each tray.",
                storyEnding: "The wall is ready for repairs.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Mr. Bram fills 3 trays of banners with 4 banners in each tray. How many banners are ready?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "castles.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Castle Guard Shift" : "Equal Shares of Bread Rolls",
                storyOpening: "Mr. Bram plans supplies for the whole castle staff.",
                missionPrompt: multi ? "Solve each castle problem." : "Solve each castle problem carefully.",
                readingPassage: "Iron keys and bread rolls are shared with the castle guards after their shift.",
                problems: [
                    mcq("Mr. Bram packs 3 cases with 8 iron keys in each case. How many keys does he pack?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Mr. Bram shares 18 bread rolls among 3 guard posts equally. How many does each post get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One drawbridge chain is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "times", definition: "Groups of the same size counted that many times.", exampleSentence: "3 times 8 is 24 keys.")],
                knowledgeFacts: [KnowledgeFact(fact: "A moat is a water-filled ditch that helped protect a castle.")],
                creativePrompt: "Draw the key cases.",
                storyEnding: "Every guard post gets a fair share. Well organized, Mr. Bram!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A moat bucket holds 4 cups of water. Mr. Bram adds 2 more cups. How many cups are in the bucket now?",
                hints: mathHints(level),
                activityFingerprint: "castles.math.advancing.keys"
            )
        }
    }

    // MARK: - Fairies (Luma — glade, fireflies, evidence-based wonder)

    private static func fairiesReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Luma Finds a Firefly",
                storyOpening: "Luma the fairy flutters through the moonlit glade. Come see!",
                missionPrompt: "Check what Luma sees, and what she does.",
                readingPassage: "Luma sees a tiny firefly. It blinks a soft light. Luma flutters a little closer. The firefly blinks again.",
                questions: [
                    mcq("What does Luma see?", ["A firefly", "A big rock", "A red apple"], "A firefly", "Luma sees a firefly."),
                    mcq("What does the firefly do?", ["Blinks a soft light", "Roars loudly", "Turns bright red"], "Blinks a soft light", "It blinks a soft light."),
                    mcq("What does Luma do next?", ["Flutters closer", "Flies far away", "Falls asleep"], "Flutters closer", "Luma flutters closer.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "flutter", definition: "To fly with quick, light wing movements.", exampleSentence: "Luma can flutter through the glade."),
                    VocabularyWord(word: "glade", definition: "An open sunny space in a forest.", exampleSentence: "Luma flutters through the glade.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Fireflies glow because of a chemical reaction inside their bodies.", explanation: "Nature makes its own kind of sparkle.")
                ],
                creativePrompt: "Draw Luma fluttering near a blinking firefly.",
                creativeResponseType: .drawing,
                storyEnding: "Luma watches the firefly's soft glow with wonder.",
                readingSkill: "Follow a simple fairy story",
                reflectionPrompt: "What did Luma see glow?",
                hints: ["Find the word firefly", "Look for the word blinks"],
                commonMistakes: ["Choosing an object that did not glow"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short fairy story"],
                activityFingerprint: "fairies.k.firefly-glow.detail",
                characterNames: ["Luma"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Luma's Mushroom Ring",
                storyOpening: "Dew sparkles on the moss around a circle of mushrooms. Soft landings!",
                missionPrompt: "Check what Luma notices in the quiet glade.",
                readingPassage: "Luma lands softly on a ring of mushrooms in the quiet glade. She counts three fireflies blinking above the ferns. Dewdrops shine like tiny beads on every leaf. Luma taps a mushroom cap and listens for the faint hum of the forest. A gentle breeze carries the smell of damp moss through the clearing.",
                questions: [
                    mcq("Where does Luma land?", ["On a ring of mushrooms", "On a tall rock", "On a dry sand dune"], "On a ring of mushrooms", "Luma lands softly on a ring of mushrooms."),
                    mcq("How many fireflies does Luma count?", ["Three", "Ten", "One"], "Three", "She counts three fireflies blinking above the ferns."),
                    mcq("What does the breeze carry?", ["The smell of damp moss", "A loud drumbeat", "Bright flashing light"], "The smell of damp moss", "A gentle breeze carries the smell of damp moss.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "moss", definition: "A soft, low-growing green plant.", exampleSentence: "Dew sparkles on the moss."),
                    VocabularyWord(word: "dewdrop", definition: "A small drop of water formed on plants overnight.", exampleSentence: "Dewdrops shine on every leaf.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Dew forms on plants overnight when air cools and moisture collects on leaves.", explanation: "That is why glades often sparkle in the early morning.")
                ],
                creativePrompt: "Draw Luma on the mushroom ring with three fireflies above the ferns.",
                creativeResponseType: .drawing,
                storyEnding: "The quiet glade sparkles around Luma's ring of mushrooms.",
                readingSkill: "Recall glade details from a fairy passage",
                reflectionPrompt: "What glade detail would you remember most?",
                hints: ["Find the sentence about the fireflies", "Look for the word dewdrop"],
                commonMistakes: ["Guessing a number not stated in the story"],
                successCriteria: ["Uses a glade detail from the story"],
                learningObjectives: ["Recall key details from a short fairy passage"],
                activityFingerprint: "fairies.early.mushroom-ring.detail",
                characterNames: ["Luma"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why the Glade Glows at Night",
                storyOpening: "Luma wonders why some parts of the glade glow more than others.",
                missionPrompt: "Figure out why the glade glow brighter in some spots.",
                readingPassage: "Luma noticed that fireflies gathered thickest near the damp edge of the glade, where ferns grew tall and moist. Farther out, near the drier path, hardly any fireflies blinked at all. Instead of guessing, Luma watched for several nights and noticed the same pattern each time. She realized that fireflies seemed to prefer the cool, damp air near the ferns rather than the drier open path. This pattern helped Luma understand that a glowing glade is not magic alone — it depends on where the right conditions for fireflies exist. Luma began guiding her fairy friends toward the damp fern edge whenever they wanted to see the brightest glow.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Fireflies gather where damp, cool conditions exist", "Fireflies glow the same everywhere in the glade", "The glow in the glade is pure magic with no pattern"], "Fireflies gather where damp, cool conditions exist", "Luma realized fireflies prefer the cool, damp fern edge."),
                    mcq("Where did fireflies gather thickest?", ["Near the damp edge with tall ferns", "Along the dry, sunny path", "Deep inside a stone cave"], "Near the damp edge with tall ferns", "Fireflies gathered thickest near the damp edge of the glade."),
                    mcq("How did Luma confirm the pattern?", ["She watched for several nights and saw it repeat", "She guessed after one quick look", "She asked a stranger who had never visited"], "She watched for several nights and saw it repeat", "Luma watched for several nights and noticed the same pattern.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "pattern", definition: "Something that repeats in a noticeable way.", exampleSentence: "Luma noticed a pattern in where fireflies gathered."),
                    VocabularyWord(word: "conditions", definition: "The state of things around a place, like temperature or moisture.", exampleSentence: "Damp conditions attracted more fireflies.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Fireflies are often found near damp, grassy areas rather than dry, open ground.", explanation: "Moist places tend to have more of the small insects fireflies eat.")
                ],
                creativePrompt: "Draw the damp fern edge of the glade glowing with many fireflies.",
                creativeResponseType: .drawing,
                storyEnding: "Luma's careful watching turns wonder into a real understanding of the glade.",
                readingSkill: "Identify the main idea in a nature-observation passage",
                reflectionPrompt: "Why might watching for several nights be better than guessing after one look?",
                hints: ["Reread the sentence about the pattern", "Compare the damp edge with the dry path"],
                commonMistakes: ["Assuming the glow has no explainable pattern"],
                successCriteria: ["States the pattern main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction nature passage"],
                activityFingerprint: "fairies.growing.firefly-pattern.main-idea",
                characterNames: ["Luma"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Why the Fairy Ring Went Dark",
                storyOpening: "One night the mushroom ring stays dark. Luma wants to know why.",
                missionPrompt: "Check what the glade clues tell Luma about the missing glow.",
                readingPassage: """
                One night, Luma arrived at the mushroom ring expecting the usual soft glow of fireflies, but the clearing stayed dark and silent. She compared two clues before deciding what had happened: the ferns nearby looked unusually dry, and a warm wind had blown steadily through the glade since sunset. Luma did not assume the fireflies had vanished forever. She remembered that fireflies prefer cool, damp air near the ferns. She reasoned that the dry ferns and warm wind together had likely pushed the fireflies toward a cooler, damper part of the forest that night. Following a faint trail of moisture past the ring, Luma found the fireflies gathered near a small hidden stream, glowing exactly as she expected. She explained to her fairy friends that comparing the dry ferns with the warm wind told a clearer story than either clue alone — the fireflies had not disappeared, they had simply moved to damper ground.
                """,
                questions: [
                    mcq("What did Luma conclude about the missing fireflies?", ["They had moved to damper ground near a hidden stream", "They had vanished from the forest forever", "They no longer needed damp, cool air at all"], "They had moved to damper ground near a hidden stream", "Luma concluded the fireflies moved to a cooler, damper spot."),
                    mcq("Why did Luma think the fireflies left the mushroom ring?", ["Fireflies prefer cool, damp air near the ferns", "Fireflies only glow during loud storms", "Fireflies cannot fly at night"], "Fireflies prefer cool, damp air near the ferns", "Luma remembered that fireflies prefer cool, damp air near the ferns."),
                    mcq("Where did Luma find the fireflies?", ["Near a small hidden stream", "Back at the same dry ring", "Nowhere at all in the forest"], "Near a small hidden stream", "She found the fireflies gathered near a small hidden stream.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "moisture", definition: "A small amount of water in the air or ground.", exampleSentence: "Luma followed a trail of moisture past the ring."),
                    VocabularyWord(word: "reason", definition: "To think through clues carefully before deciding.", exampleSentence: "Luma had to reason about the dry ferns and warm wind.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Fireflies may move to a different damp area if their usual spot becomes too dry or windy.", explanation: "Comparing weather clues helps explain changes in where fireflies gather.")
                ],
                creativePrompt: "Why did Luma think the fireflies left the mushroom ring?",
                creativeResponseType: .shortText,
                storyEnding: "Luma's comparison of two clues turns a worrying mystery into a happy discovery.",
                readingSkill: "Use nature clues to explain a fairy's conclusion",
                reflectionPrompt: "Where did Luma find the fireflies?",
                hints: ["Look for why fireflies like damp air", "Reread where Luma found them"],
                commonMistakes: ["Assuming the fireflies vanished with no explanation"],
                successCriteria: ["Explains Luma's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of nature evidence"],
                activityFingerprint: "fairies.confident.silent-ring.conclusion",
                characterNames: ["Luma"]
            )
        }
    }

    private static func fairiesMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Fairies",
                storyOpening: "Luma needs a careful count in the glade.",
                missionPrompt: "Count the glade friends and compare the groups.",
                readingPassage: "Four fairies flutter above the ferns. Two flowers bloom in a ring. Luma points and counts out loud.",
                problems: [
                    mcq("Luma sees 2 fairies, then 2 more join. How many fairies in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 flowers on the left and 3 fairies on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Luma counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Luma can count the fairies.")],
                knowledgeFacts: [KnowledgeFact(fact: "Fairies in the glade like to count fireflies and flowers together each night.")],
                creativePrompt: "Draw 4 fairies above the ferns.",
                storyEnding: "Luma's glade count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 flowers on the left and 3 fairies on the right. Which side has more?",
                hints: ["Point to each fairy", "Compare the two groups"],
                activityFingerprint: "fairies.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Flowers for the Ring",
                storyOpening: "Luma gathers flowers to freshen the mushroom ring.",
                missionPrompt: "Add and subtract to finish the glade jobs.",
                readingPassage: "Luma gathers glowing flowers for the glade party. She checks how many flowers she has and how many dewdrops still need gathering.",
                problems: [
                    mcq("Luma finds 6 flowers. Then she finds 3 more. How many flowers in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A petal basket holds 10 glowing petals. Luma shares 4 petals with friends. How many petals are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Luma gathered 8 dewdrops at dawn. She gives away 5 to a flower fairy. How many dewdrops does Luma have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total flowers.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking flower numbers helps fairies plan a fair glade gathering.")],
                creativePrompt: "Draw 9 flowers ready for the ring.",
                storyEnding: "The glade gathering is ready to begin.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A petal basket holds 10 glowing petals. Luma shares 4 petals with friends. How many petals are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "fairies.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Luma",
                pronoun: "she",
                items: [
                    ("beads", "in the bead pouch"),
                    ("mushroom caps", "in the picnic basket"),
                    ("fern stems", "on the festival path")
                ],
                packItem: "beads",
                purpose: "for the fairy festival"
            )
            return MathScene(
                title: "Groups Under the Ferns",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Luma arranges mushroom caps into 3 rows with 4 caps in each row. How many mushroom caps are there?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A fern stem is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten beads.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the festival supplies are ready.")],
                creativePrompt: "Draw mushroom caps in 3 rows with 4 caps in each row.",
                storyEnding: "The glade is ready for the fairy festival.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Luma arranges mushroom caps into 3 rows with 4 caps in each row. How many mushroom caps are there?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "fairies.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Fairy Festival Night" : "Equal Shares of Berries",
                storyOpening: "Luma plans treats for the whole fairy festival.",
                missionPrompt: multi ? "Solve each fairy problem." : "Solve each fairy problem carefully.",
                readingPassage: "Sparkle beads and berries are shared with fairy friends after the festival.",
                problems: [
                    mcq("Luma gathers 3 pouches with 8 sparkle beads in each pouch. How many beads does she gather?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Luma shares 18 berries among 3 fairy friends equally. How many does each friend get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One fern stem is 15 centimeters long. Another is 9. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "split", definition: "To divide into parts.", exampleSentence: "Split the beads into equal shares.")],
                knowledgeFacts: [KnowledgeFact(fact: "Fireflies make their own light with a chemical reaction in their bodies.")],
                creativePrompt: "Draw the bead packs.",
                storyEnding: "Every fairy gets a fair share. Great planning, Luma!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A leaf bowl holds 4 cups of dew. Luma adds 2 more cups. How many cups are in the leaf bowl now?",
                hints: mathHints(level),
                activityFingerprint: "fairies.math.advancing.beads"
            )
        }
    }

    // MARK: - Airplanes (Zoe and Captain Reyes — flight checks, weather clues)

    private static func airplanesReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Zoe Checks the Wing",
                storyOpening: "Zoe walks around the small airplane. What will she check before takeoff?",
                missionPrompt: "Check what Zoe checks before the plane can fly.",
                readingPassage: "Zoe starts her check at the wing. Next, she checks the wheels. Captain Reyes checks the fuel. Now the plane is ready.",
                questions: [
                    mcq("What does Zoe check first?", ["The wing", "The snack tray", "The seatbelt sign"], "The wing", "Zoe checks the wing."),
                    mcq("What else does Zoe check?", ["The wheels", "The passenger seats", "The runway lights"], "The wheels", "She checks the wheels."),
                    mcq("What does Captain Reyes check?", ["The fuel", "The weather map", "The passenger list"], "The fuel", "Captain Reyes checks the fuel.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "wing", definition: "The flat part of a plane that helps it fly.", exampleSentence: "Zoe checks the wing."),
                    VocabularyWord(word: "fuel", definition: "Energy that powers an engine.", exampleSentence: "Captain Reyes checks the fuel.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Pilots check every part of a plane before takeoff.", explanation: "Careful checks help keep every flight safe.")
                ],
                creativePrompt: "Draw Zoe checking the wing of the airplane.",
                creativeResponseType: .drawing,
                storyEnding: "The plane is checked and ready for a safe flight.",
                readingSkill: "Follow a simple airplane story",
                reflectionPrompt: "What did Zoe check?",
                hints: ["Find the word wing", "Look for the word fuel"],
                commonMistakes: ["Choosing a part that was not checked"],
                successCriteria: ["Names a real checklist step from the story"],
                learningObjectives: ["Identify concrete details in a short airplane story"],
                activityFingerprint: "airplanes.k.wing-check.detail",
                characterNames: ["Zoe", "Captain Reyes"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "The Pre-Flight Checklist",
                storyOpening: "A clipboard waits by the cockpit door. Zoe and Captain Reyes are ready to begin.",
                missionPrompt: "Follow the checklist. Check what Zoe and Captain Reyes finish before takeoff.",
                readingPassage: "Zoe reads each step on the pre-flight checklist out loud. Captain Reyes tests the radio and waits for a clear reply from the tower. Together they check that the wings, wheels, and fuel are all in order. Zoe crosses off each finished step with a pencil. When every box is checked, Captain Reyes gives a thumbs-up for takeoff.",
                questions: [
                    mcq("What does Zoe read out loud?", ["Each step on the checklist", "A weather forecast only", "A snack menu"], "Each step on the checklist", "Zoe reads each step on the checklist out loud."),
                    mcq("What does Captain Reyes test?", ["The radio", "The snack cart", "The luggage cart"], "The radio", "Captain Reyes tests the radio."),
                    mcq("What happens when every box is checked?", ["Captain Reyes gives a thumbs-up for takeoff", "The flight is canceled", "Zoe starts the checklist over"], "Captain Reyes gives a thumbs-up for takeoff", "Captain Reyes gives a thumbs-up for takeoff.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "checklist", definition: "A list of steps to check one by one.", exampleSentence: "Zoe reads the pre-flight checklist."),
                    VocabularyWord(word: "tower", definition: "A place where controllers guide planes by radio.", exampleSentence: "Captain Reyes waits for a reply from the tower.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Pilots use radios to talk to air traffic controllers before every flight.", explanation: "Clear radio contact helps planes take off and land safely.")
                ],
                creativePrompt: "Draw Zoe crossing off steps on the checklist while Captain Reyes tests the radio.",
                creativeResponseType: .drawing,
                storyEnding: "With every box checked, the plane is ready for a safe takeoff.",
                readingSkill: "Recall checklist details from an airplane passage",
                reflectionPrompt: "Why might a checklist help keep a flight safe?",
                hints: ["Find the sentence about the radio", "Look for the thumbs-up detail"],
                commonMistakes: ["Skipping the radio-check detail"],
                successCriteria: ["Uses a checklist detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "airplanes.early.checklist.detail",
                characterNames: ["Zoe", "Captain Reyes"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Wings Are Curved on Top",
                storyOpening: "Zoe tilts her head at the curved wing. Why isn't it flat?",
                missionPrompt: "Find the main idea about how wings create lift. Use Captain Reyes's explanation.",
                readingPassage: "Zoe noticed that the top of the airplane's wing curved upward while the bottom stayed flatter. She wondered why the shape mattered. Captain Reyes explained that this curved shape makes air move faster over the top of the wing than underneath it. Faster-moving air above the wing creates lower pressure, while slower air below creates higher pressure. That pressure difference pushes the wing upward, creating the lift a plane needs to fly. Captain Reyes added that engineers test many wing shapes in special wind tunnels before choosing the best curve for each plane. Zoe realized that a plane's wing shape is not just for looks — it is carefully designed to make flight possible.",
                questions: [
                    mcq("What is the main idea of this passage?", ["A wing's curved shape is carefully designed to create lift", "Wing shape has no effect on flying at all", "Every wing on every plane looks completely flat"], "A wing's curved shape is carefully designed to create lift", "Captain Reyes explains that the curved shape creates the lift a plane needs."),
                    mcq("Why does air move faster over the top of the wing?", ["The curved shape makes it travel faster than the air below", "The top of the wing is colder than the bottom", "Pilots blow air over the wing by hand"], "The curved shape makes it travel faster than the air below", "The curved top shape makes air move faster than the flatter bottom."),
                    mcq("What do engineers use to test wing shapes?", ["Special wind tunnels", "A children's playground", "A kitchen oven"], "Special wind tunnels", "Engineers test wing shapes in special wind tunnels.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "lift", definition: "The upward push that helps a plane fly.", exampleSentence: "The curved wing creates lift."),
                    VocabularyWord(word: "pressure", definition: "The push of air or another force against something.", exampleSentence: "Lower air pressure forms above the curved wing.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Airplane wings are curved so air moves faster over the top, creating lift.", explanation: "This pressure difference is one of the basic ideas behind how planes fly.")
                ],
                creativePrompt: "Draw a wing shape and label where the faster air and slower air move.",
                creativeResponseType: .drawing,
                storyEnding: "Zoe now understands that a wing's curve is a careful design, not just a shape.",
                readingSkill: "Identify the main idea in a flight-science passage",
                reflectionPrompt: "Why might testing wing shapes in a wind tunnel be a smart step before building a real plane?",
                hints: ["Reread the sentence about pressure difference", "Compare the air above and below the wing"],
                commonMistakes: ["Thinking wing shape does not matter for flying"],
                successCriteria: ["States the lift main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction science passage"],
                activityFingerprint: "airplanes.growing.wing-lift.main-idea",
                characterNames: ["Zoe", "Captain Reyes"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "The Decision Before Takeoff",
                storyOpening: "Dark clouds gather on the horizon. Captain Reyes studies a data screen before the takeoff call.",
                missionPrompt: "Compare the weather clues. Figure out why Captain Reyes delay takeoff.",
                readingPassage: """
                Before an afternoon flight, Captain Reyes noticed dark clouds building steadily on the western horizon while checking the sky from the cockpit window. At the same time, a weather radar screen showed a band of storms moving toward the airport from that same direction. Captain Reyes compared both clues — the darkening sky and the radar's storm band — before deciding to delay takeoff by twenty minutes rather than risk flying into rough weather. Zoe wondered whether either clue alone would have been enough to make the call. Captain Reyes explained that a dark sky alone might just mean passing clouds, and a radar blip alone might be a weak, harmless patch, but together they painted a clearer picture of real storm risk. Twenty minutes later, the storm band moved past the airport exactly as predicted, and the flight departed safely under clear skies.
                """,
                questions: [
                    mcq("Why did Captain Reyes delay takeoff by twenty minutes?", ["Dark clouds and a radar storm band showed real storm risk", "The plane had run out of fuel completely", "Zoe asked for the delay for no reason"], "Dark clouds and a radar storm band showed real storm risk", "The darkening sky and radar storm band showed real storm risk."),
                    mcq("How long did Captain Reyes delay the flight?", ["Twenty minutes", "The whole afternoon", "Until the next morning"], "Twenty minutes", "Captain Reyes delayed takeoff by twenty minutes."),
                    mcq("What happened twenty minutes later?", ["The storm band moved past, and the flight departed safely", "The airport closed for the rest of the week", "The radar screen stopped working"], "The storm band moved past, and the flight departed safely", "Twenty minutes later, the storm band moved past and the flight departed safely.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "radar", definition: "A tool that uses radio waves to detect things like storms far away.", exampleSentence: "The radar screen showed a band of storms."),
                    VocabularyWord(word: "risk", definition: "A chance that something dangerous or unwanted might happen.", exampleSentence: "Flying into a storm carries real risk.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Pilots often compare more than one weather clue, like radar and visible clouds, before deciding to delay a flight.", explanation: "Comparing multiple clues leads to safer decisions than relying on just one.")
                ],
                creativePrompt: "Why did Captain Reyes delay takeoff?",
                creativeResponseType: .shortText,
                storyEnding: "Captain Reyes's careful comparison of two clues keeps the flight safe and only slightly delayed.",
                readingSkill: "Use weather clues to explain a pilot's decision",
                reflectionPrompt: "What happened twenty minutes later?",
                hints: ["Look for how long the delay lasted", "Reread what happened after twenty minutes"],
                commonMistakes: ["Using only one clue instead of comparing both"],
                successCriteria: ["Explains Captain Reyes's decision using two details from the passage"],
                learningObjectives: ["Infer a decision using two pieces of weather evidence"],
                activityFingerprint: "airplanes.confident.storm-clues.inference",
                characterNames: ["Zoe", "Captain Reyes"]
            )
        }
    }

    private static func airplanesMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Suitcases",
                storyOpening: "Zoe needs a careful count before boarding.",
                missionPrompt: "Count the airport items and compare the groups.",
                readingPassage: "Four suitcases sit on the luggage cart. Two boarding passes wait at the gate. Zoe points and counts out loud.",
                problems: [
                    mcq("Zoe sees 2 suitcases, then 2 more join. How many suitcases in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 boarding passes on the left and 3 suitcases on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Zoe counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Zoe can count the suitcases.")],
                knowledgeFacts: [KnowledgeFact(fact: "Airport workers count luggage carefully so every bag reaches the right plane.")],
                creativePrompt: "Draw 4 suitcases on the cart.",
                storyEnding: "Zoe's suitcase count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 boarding passes on the left and 3 suitcases on the right. Which side has more?",
                hints: ["Point to each suitcase", "Compare the two groups"],
                activityFingerprint: "airplanes.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Suitcases for the Flight",
                storyOpening: "Zoe helps load supplies before the flight.",
                missionPrompt: "Add and subtract to finish the gate jobs.",
                readingPassage: "Zoe loads suitcases onto the cart before boarding. She checks how many suitcases are loaded and how many boarding passes still need checking.",
                problems: [
                    mcq("Zoe finds 6 suitcases. Then she finds 3 more. How many suitcases in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A luggage cart holds 10 suitcases. Zoe rolls 4 suitcases to another gate. How many suitcases are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Zoe needs 8 boarding passes for her cabin check. She has collected 5 so far. How many more does she need?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total suitcases.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking luggage numbers helps a flight crew load the plane efficiently.")],
                creativePrompt: "Draw 9 suitcases ready for the flight.",
                storyEnding: "The gate is ready for boarding.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A luggage cart holds 10 suitcases. Zoe rolls 4 suitcases to another gate. How many suitcases are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "airplanes.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Zoe",
                pronoun: "she",
                items: [
                    ("luggage tags", "in the tag box"),
                    ("boarding passes", "in the ticket folder"),
                    ("wing pins", "on the crew board")
                ],
                packItem: "luggage tags",
                purpose: "for the busy travel day"
            )
            return MathScene(
                title: "Groups at the Terminal",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Zoe counts seats in 3 cabin sections with 4 seats in each section. How many seats does she count?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A runway marker is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten luggage tags.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the terminal is ready for travelers.")],
                creativePrompt: "Draw 3 cabin sections with 4 seats in each section.",
                storyEnding: "The terminal is ready for the busy travel day.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Zoe counts seats in 3 cabin sections with 4 seats in each section. How many seats does she count?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "airplanes.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Flight Day Snacks" : "Equal Shares of Pretzel Bags",
                storyOpening: "Zoe plans snacks and gear for a full flight.",
                missionPrompt: multi ? "Solve each flight problem." : "Solve each flight problem carefully.",
                readingPassage: "Pilot wing pins and pretzel bags are shared with passengers during the flight.",
                problems: [
                    mcq("Zoe fills 3 gift bags with 8 pilot wing pins in each bag. How many pins does she put in the bags?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Zoe shares 18 pretzel bags among 3 rows of passengers equally. How many does each row get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One runway marker is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "fair", definition: "The same amount for everyone.", exampleSentence: "A fair share of pins is the same for each.")],
                knowledgeFacts: [KnowledgeFact(fact: "The cockpit is where the pilots sit to fly the plane.")],
                creativePrompt: "Draw the wing pin packs.",
                storyEnding: "Every row gets a fair share. Zoe keeps every row fair so the flight stays smooth.",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A drink cart holds 4 cups of juice. Zoe adds 2 more cups. How many cups are on the cart now?",
                hints: mathHints(level),
                activityFingerprint: "airplanes.math.advancing.wingpins"
            )
        }
    }

    // MARK: - Trains (Owen — station chores, signals, delay clues)

    private static func trainsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Owen Rings the Bell",
                storyOpening: "Owen stands on the platform. The train is pulling in — what will he do?",
                missionPrompt: "Check what Owen does as the train arrives.",
                readingPassage: "Owen rings the bell to greet the train. Then he checks each ticket. Passengers climb aboard. The train chugs away.",
                questions: [
                    mcq("What does Owen ring?", ["The bell", "A drum", "A horn only"], "The bell", "Owen rings the bell."),
                    mcq("What does Owen check?", ["Each ticket", "Each shoe", "Each window"], "Each ticket", "He checks each ticket."),
                    mcq("What do passengers do?", ["Climb aboard", "Run away", "Fall asleep"], "Climb aboard", "Passengers climb aboard.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "ticket", definition: "A paper that lets someone ride the train.", exampleSentence: "Owen checks each ticket."),
                    VocabularyWord(word: "platform", definition: "The place where people wait for a train.", exampleSentence: "Owen stands on the platform.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Conductors check tickets to make sure every passenger is on the right train.", explanation: "Checking tickets keeps the ride organized for everyone.")
                ],
                creativePrompt: "Draw Owen checking tickets on the platform.",
                creativeResponseType: .drawing,
                storyEnding: "The train chugs away with every passenger checked and ready.",
                readingSkill: "Follow a simple train story",
                reflectionPrompt: "What did Owen check?",
                hints: ["Find the word ticket", "Look for the word bell"],
                commonMistakes: ["Choosing an object Owen did not check"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short train story"],
                activityFingerprint: "trains.k.ticket-check.detail",
                characterNames: ["Owen"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Loading Cargo Before Departure",
                storyOpening: "Crates and boxes wait beside the freight car. Owen is ready to load.",
                missionPrompt: "Follow the loading steps. Check what Owen checks and locks.",
                readingPassage: "Owen counts each crate before it is loaded onto the freight car. He checks a paper list to make sure nothing is missing. A heavy crate needs two workers to lift it safely. Once every crate is loaded, Owen slides the freight door shut and locks it tight. The train is ready to roll down the track.",
                questions: [
                    mcq("What does Owen count?", ["Each crate", "Each passenger", "Each window"], "Each crate", "Owen counts each crate before it is loaded."),
                    mcq("What does Owen check to make sure nothing is missing?", ["A paper list", "A weather report", "A menu card"], "A paper list", "He checks a paper list."),
                    mcq("What does Owen do after loading is finished?", ["Slides the freight door shut and locks it", "Leaves the door wide open", "Removes the crates again"], "Slides the freight door shut and locks it", "Owen slides the freight door shut and locks it tight.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "cargo", definition: "Goods carried by a train, truck, or ship.", exampleSentence: "The freight car carries cargo."),
                    VocabularyWord(word: "freight", definition: "Goods transported by train or truck.", exampleSentence: "Owen loads the freight car.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Freight trains carry heavy cargo across long distances more efficiently than trucks alone.", explanation: "Steel wheels on steel tracks roll with very little friction.")
                ],
                creativePrompt: "Draw Owen counting crates beside the freight car.",
                creativeResponseType: .drawing,
                storyEnding: "With the freight door locked tight, the train is ready to roll.",
                readingSkill: "Recall loading details from a train passage",
                reflectionPrompt: "Why might counting crates before loading be important?",
                hints: ["Find the sentence about the paper list", "Look for the word freight"],
                commonMistakes: ["Skipping the counting detail"],
                successCriteria: ["Uses a loading detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "trains.early.cargo-loading.detail",
                characterNames: ["Owen"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Steel Wheels Roll So Smoothly",
                storyOpening: "A young visitor asks Owen a big question: how can trains pull such heavy loads?",
                missionPrompt: "Find the main idea about how trains move heavy loads. Use Owen's explanation.",
                readingPassage: "A visitor once asked Owen how a train could pull so many heavy cars without struggling the way a truck might on a bumpy road. Owen explained that steel train wheels roll on steel rails. That steel-on-steel contact creates very little friction compared to rubber tires on pavement. Less friction means the train's engine does not have to work as hard to keep the cars moving once they get started. Owen added that the flat, smooth rails also spread the weight of the cargo evenly, so heavy crates do not sink or slow the wheels down. Together, low friction and evenly spread weight let one engine pull far more cargo than a truck ever could in a single trip.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Steel wheels on steel rails create low friction, letting trains pull heavy loads efficiently", "Trains struggle more than trucks to move heavy cargo", "Rails have no effect on how a train moves"], "Steel wheels on steel rails create low friction, letting trains pull heavy loads efficiently", "Owen explains that low friction lets one engine pull far more cargo."),
                    mcq("Why does less friction help the train's engine?", ["It does not have to work as hard to keep cars moving", "It makes the engine run out of fuel faster", "It causes the wheels to stop spinning"], "It does not have to work as hard to keep cars moving", "Less friction means the engine works less hard once cars are moving."),
                    mcq("What do the flat, smooth rails do for heavy crates?", ["Spread their weight evenly so they do not slow the wheels", "Make the crates heavier than before", "Cause the crates to sink into the ground"], "Spread their weight evenly so they do not slow the wheels", "The rails spread the cargo's weight evenly.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "friction", definition: "A force that slows down movement between two surfaces.", exampleSentence: "Steel wheels create little friction on steel rails."),
                    VocabularyWord(word: "efficient", definition: "Able to do a job well without wasting effort.", exampleSentence: "Low friction makes trains an efficient way to move cargo.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Trains use steel wheels on steel tracks to roll with very little friction.", explanation: "This is one reason trains can pull extremely heavy loads efficiently.")
                ],
                creativePrompt: "Draw a steel wheel on a steel rail and label why there is so little friction.",
                creativeResponseType: .drawing,
                storyEnding: "The visitor leaves understanding that smooth steel rails, not magic, let trains pull such heavy loads.",
                readingSkill: "Identify the main idea in a train-mechanics passage",
                reflectionPrompt: "Why might understanding friction help engineers design better trains?",
                hints: ["Reread Owen's explanation about steel-on-steel contact", "Compare a train's rails with a truck's road"],
                commonMistakes: ["Thinking trucks and trains use the same amount of friction"],
                successCriteria: ["States the low-friction main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction science passage"],
                activityFingerprint: "trains.growing.low-friction.main-idea",
                characterNames: ["Owen"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Solving the Late Train Puzzle",
                storyOpening: "The express train is overdue. Owen has two signals that might explain why.",
                missionPrompt: "Compare the signal-board clues. Check what Owen conclude.",
                readingPassage: """
                When the express train failed to arrive on schedule, Owen checked the station's signal board for clues instead of guessing right away. He noticed the signal for the mountain tunnel section had switched to a cautious yellow light, and a radio report mentioned heavy fog rolling through that same stretch of track. Owen compared both clues — the yellow signal and the fog report — before concluding that the train was likely moving slowly and safely through reduced visibility, not stalled or broken down. He explained to worried passengers that a red signal or a silent radio would have worried him far more than a yellow light paired with a weather explanation. Fifteen minutes later, the express train rolled in exactly as Owen had predicted, slowed by fog but running safely. Owen told his trainee that comparing the signal color with the weather report gave a clearer answer than either clue alone.
                """,
                questions: [
                    mcq("What did Owen conclude about the late train?", ["It was moving slowly and safely through fog, not broken down", "It had crashed somewhere on the mountain track", "It had been canceled for the day"], "It was moving slowly and safely through fog, not broken down", "Owen concluded the fog was slowing the train safely."),
                    mcq("What color was the mountain tunnel signal?", ["Yellow", "Red", "Green"], "Yellow", "The signal for the mountain tunnel section had switched to a cautious yellow light."),
                    mcq("What would have worried Owen more than a yellow signal?", ["A red signal or a silent radio", "A radio report about sunny weather", "A train arriving early"], "A red signal or a silent radio", "Owen said a red signal or silent radio would have worried him more.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "visibility", definition: "How far or clearly something can be seen.", exampleSentence: "Fog reduced visibility along the mountain track."),
                    VocabularyWord(word: "signal", definition: "A colored light or sign that gives train drivers instructions.", exampleSentence: "The signal switched to a cautious yellow light.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Train signals combined with weather reports can help explain a delay without assuming the worst.", explanation: "Comparing more than one clue leads to calmer, more accurate conclusions.")
                ],
                creativePrompt: "Write two sentences about why the express train was late and how Owen knew it was still safe.",
                creativeResponseType: .shortText,
                storyEnding: "Owen's comparison of two clues turns a worrying delay into a calm, correct explanation.",
                readingSkill: "Use signal clues to explain a conductor's conclusion",
                reflectionPrompt: "Which clue would reassure you most if a train were running late?",
                hints: ["Look at the signal color", "Reread why Owen was not as worried as the passengers"],
                commonMistakes: ["Assuming the worst from only one clue"],
                successCriteria: ["Explains Owen's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "trains.confident.signal-clues.conclusion",
                characterNames: ["Owen"]
            )
        }
    }

    private static func trainsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Train Cars",
                storyOpening: "Owen needs a careful count before departure.",
                missionPrompt: "Count the train cars and compare the groups.",
                readingPassage: "Four train cars line up on the track. Two tickets wait at the window. Owen points and counts out loud.",
                problems: [
                    mcq("Owen sees 2 train cars, then 2 more join. How many train cars in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 tickets on the left and 3 train cars on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Owen counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Owen can count the train cars.")],
                knowledgeFacts: [KnowledgeFact(fact: "Conductors count train cars carefully before every departure.")],
                creativePrompt: "Draw 4 train cars on the track.",
                storyEnding: "Owen's train car count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 tickets on the left and 3 train cars on the right. Which side has more?",
                hints: ["Point to each train car", "Compare the two groups"],
                activityFingerprint: "trains.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Tickets for the Trip",
                storyOpening: "Owen sells tickets before the train departs.",
                missionPrompt: "Add and subtract to finish the station jobs.",
                readingPassage: "Owen counts train cars lined up at the platform. He checks how many cars are ready and how many tickets still need stamping.",
                problems: [
                    mcq("Owen finds 6 train cars. Then he finds 3 more. How many train cars in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A ticket box holds 10 tickets. Owen stamps 4 tickets for passengers. How many tickets are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Owen counted 8 luggage tags before the stop. After tagging bags, only 5 tags are left. How many tags were used?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total train cars.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking ticket numbers helps a station run smoothly.")],
                creativePrompt: "Draw 9 train cars ready for the trip.",
                storyEnding: "The station is ready for departure.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A ticket box holds 10 tickets. Owen stamps 4 tickets for passengers. How many tickets are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "trains.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Owen",
                pronoun: "he",
                items: [
                    ("track bolts", "in the tool crate"),
                    ("train benches", "in the waiting car"),
                    ("conductor badges", "on the crew hook")
                ],
                packItem: "track bolts",
                purpose: "for the busy travel day"
            )
            return MathScene(
                title: "Groups at the Station",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Owen sets out 3 rows of train benches with 4 benches in each row. How many benches does he place?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A rail section is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten bolts.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the station is ready for travelers.")],
                creativePrompt: "Draw 3 rows of train benches with 4 benches in each row.",
                storyEnding: "The station is ready for the busy travel day.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Owen sets out 3 rows of train benches with 4 benches in each row. How many benches does he place?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "trains.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Train Trip Snacks" : "Equal Shares of Biscuits",
                storyOpening: "Owen plans snacks and gear for a full train.",
                missionPrompt: multi ? "Solve each train problem." : "Solve each train problem carefully.",
                readingPassage: "Conductor badges and biscuits are shared with passengers during the trip.",
                problems: [
                    mcq("Owen stacks 3 trays with 8 conductor badges in each tray. How many badges does he prepare in all?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Owen shares 18 biscuits among 3 train cars of passengers equally. How many does each car get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One rail section is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "difference", definition: "How much more one number is than another.", exampleSentence: "The difference tells how much longer the first rail section is.")],
                knowledgeFacts: [KnowledgeFact(fact: "A conductor helps passengers and checks that the train is ready to leave.")],
                creativePrompt: "Draw the badge trays.",
                storyEnding: "Every train car gets a fair share. Owen keeps every train car fair so the trip stays smooth.",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water pitcher in the dining car holds 4 cups. Owen adds 2 more cups. How many cups are in the pitcher now?",
                hints: mathHints(level),
                activityFingerprint: "trains.math.advancing.badges"
            )
        }
    }

    // MARK: - Cars (Rosa — garage checks, safety, wind-tunnel clues)

    private static func carsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Rosa Checks the Wheel",
                storyOpening: "Rosa the mechanic looks under a shiny car. What will she check first?",
                missionPrompt: "Check what Rosa checks before the car is ready.",
                readingPassage: "Rosa checks the wheel first. Then she checks the seat belt. Last, she checks the oil. Now the car is ready.",
                questions: [
                    mcq("What does Rosa check first?", ["The wheel", "A window sticker", "A radio dial"], "The wheel", "Rosa checks the wheel."),
                    mcq("What else does Rosa check?", ["The seat belt", "The trunk color", "The horn sound"], "The seat belt", "She checks the seat belt."),
                    mcq("What does Rosa check last?", ["The oil", "The mirrors", "The trunk"], "The oil", "She checks the oil.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "wheel", definition: "The round part that helps a car roll.", exampleSentence: "Rosa checks the wheel."),
                    VocabularyWord(word: "seat belt", definition: "A strap that keeps a passenger safe in a car.", exampleSentence: "Rosa checks the seat belt.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Seat belts keep passengers safe by holding them during sudden stops.", explanation: "Checking a seat belt is an important safety step.")
                ],
                creativePrompt: "Draw Rosa checking the wheel of the car.",
                creativeResponseType: .drawing,
                storyEnding: "The car is checked and ready for a safe drive.",
                readingSkill: "Follow a simple car story",
                reflectionPrompt: "What did Rosa check?",
                hints: ["Find the word wheel", "Look for the word oil"],
                commonMistakes: ["Choosing a part Rosa did not check"],
                successCriteria: ["Names a real checklist step from the story"],
                learningObjectives: ["Identify concrete details in a short car story"],
                activityFingerprint: "cars.k.wheel-check.detail",
                characterNames: ["Rosa"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "A Trip Through the Car Wash",
                storyOpening: "Suds and water swirl around the shiny car outside Rosa's shop.",
                missionPrompt: "Follow the car wash steps. Find out what cleans, rinses, and dries the car.",
                readingPassage: "Rosa guides the car slowly into the car wash lane. Soft brushes spin and cover the car with soapy suds. Warm water rinses every bit of soap away. A big fan blows air across the car to dry it. Rosa checks that the windows shine before handing the keys back to the driver.",
                questions: [
                    mcq("What covers the car with suds?", ["Soft, spinning brushes", "A pile of leaves", "A stack of towels"], "Soft, spinning brushes", "Soft brushes spin and cover the car with suds."),
                    mcq("What rinses the soap away?", ["Warm water", "Cold sand", "Loud music"], "Warm water", "Warm water rinses every bit of soap away."),
                    mcq("What dries the car?", ["A big fan", "A hand towel only", "Sunlight alone"], "A big fan", "A big fan blows air across the car to dry it.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "suds", definition: "Bubbly soap and water used for washing.", exampleSentence: "Soft brushes cover the car with suds."),
                    VocabularyWord(word: "rinse", definition: "To wash away soap with clean water.", exampleSentence: "Warm water rinses the car.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Car washes use spinning brushes and warm water to clean a car quickly and safely.", explanation: "This keeps a car's paint clean without scratching it.")
                ],
                creativePrompt: "Draw the car covered in suds inside the car wash.",
                creativeResponseType: .drawing,
                storyEnding: "The car shines bright as Rosa hands the keys back to the driver.",
                readingSkill: "Recall car wash details from a passage",
                reflectionPrompt: "What rinses the soap away?",
                hints: ["Find the sentence about the brushes", "Look for the word rinse"],
                commonMistakes: ["Skipping the drying-fan detail"],
                successCriteria: ["Uses a car wash detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "cars.early.car-wash.detail",
                characterNames: ["Rosa"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Rosa Tests Cars in a Wind Tunnel",
                storyOpening: "A customer asks Rosa why some new cars look so smooth and rounded.",
                missionPrompt: "Find the main idea about car shape and fuel use. Use Rosa's explanation.",
                readingPassage: "A customer once asked Rosa why newer car designs looked so smooth and rounded compared to older, boxier models. Rosa explained that engineers test car shapes inside wind tunnels — powerful machines that blow air over a car the way wind would on a highway. A boxy shape pushes against more air resistance, forcing the engine to work harder and use more fuel. A smooth, rounded shape lets air flow around the car more easily, reducing resistance and helping the car use less fuel for the same distance. Rosa added that even small shape changes, tested again and again in the wind tunnel, can add up to real fuel savings over thousands of miles.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Smoother car shapes reduce air resistance and help save fuel", "Boxy cars always use less fuel than rounded cars", "Wind tunnels have no real use for car design"], "Smoother car shapes reduce air resistance and help save fuel", "Rosa explains that smooth shapes reduce resistance and help save fuel."),
                    mcq("What does a wind tunnel do?", ["Blows air over a car the way wind would on a highway", "Washes a car with soap and water", "Paints a car a new color"], "Blows air over a car the way wind would on a highway", "A wind tunnel blows air over a car like highway wind."),
                    mcq("Why does a boxy shape use more fuel?", ["It pushes against more air resistance", "It weighs less than a rounded car", "It has more wheels than other cars"], "It pushes against more air resistance", "A boxy shape pushes against more air resistance, so the engine works harder.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "resistance", definition: "A force that pushes against and slows down movement.", exampleSentence: "A boxy shape creates more air resistance."),
                    VocabularyWord(word: "wind tunnel", definition: "A machine that blows air over an object to test its shape.", exampleSentence: "Engineers test car shapes in a wind tunnel.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Engineers test cars in wind tunnels to make them use less fuel.", explanation: "Reducing air resistance is one way to improve a car's fuel efficiency.")
                ],
                creativePrompt: "Draw a boxy car and a rounded car and label which one has less air resistance.",
                creativeResponseType: .drawing,
                storyEnding: "The customer leaves understanding that a car's shape is designed to save fuel, not just to look nice.",
                readingSkill: "Identify the main idea in a car-engineering passage",
                reflectionPrompt: "Why might even a small shape change matter over thousands of miles?",
                hints: ["Reread Rosa's explanation about air resistance", "Compare the boxy shape with the rounded shape"],
                commonMistakes: ["Thinking car shape has no effect on fuel use"],
                successCriteria: ["States the aerodynamics main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction engineering passage"],
                activityFingerprint: "cars.growing.wind-tunnel.main-idea",
                characterNames: ["Rosa"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Diagnosing the Strange Engine Sound",
                storyOpening: "A strange clicking sound comes from the car. Rosa reaches for her gauge before guessing why.",
                missionPrompt: "Compare the garage clues. Check what Rosa conclude.",
                readingPassage: """
                When a customer brought in a car making a faint clicking sound, Rosa did not guess at a repair right away. She compared two clues before deciding what was wrong: the clicking grew louder specifically when the car turned corners, and the temperature gauge stayed completely normal the entire time. Rosa reasoned that an engine problem would likely affect the temperature gauge, while a steering or wheel issue would mainly show up during turns, exactly as the customer described. Based on both clues together, she concluded the sound most likely came from a small part near the front wheel rather than the engine itself. A closer look confirmed a loose heat shield near the wheel, an easy and inexpensive fix. Rosa explained to her apprentice that comparing when a sound happens with what the gauges show can point to the right answer faster than checking every part one by one.
                """,
                questions: [
                    mcq("What did Rosa conclude was causing the clicking sound?", ["A small part near the front wheel, not the engine", "A serious problem with the engine itself", "Nothing at all was wrong with the car"], "A small part near the front wheel, not the engine", "Rosa concluded the sound came from a part near the front wheel."),
                    mcq("When did the clicking grow louder?", ["When the car turned corners", "When the engine first started", "When the car sat still in the garage"], "When the car turned corners", "The clicking grew louder specifically when the car turned corners."),
                    mcq("What did the closer look reveal?", ["A loose heat shield near the wheel", "A completely broken engine", "A missing seat belt"], "A loose heat shield near the wheel", "A closer look confirmed a loose heat shield near the wheel.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "gauge", definition: "A dial or display that shows a measurement, like temperature.", exampleSentence: "The temperature gauge stayed normal."),
                    VocabularyWord(word: "apprentice", definition: "A person learning a skill by working with an experienced person.", exampleSentence: "Rosa explained her thinking to her apprentice.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Comparing when a car sound happens with what the gauges show can help mechanics find a problem faster.", explanation: "Combining more than one clue narrows down the possible cause.")
                ],
                creativePrompt: "Why did Rosa decide the clicking was not the engine?",
                creativeResponseType: .shortText,
                storyEnding: "Rosa's comparison of two clues leads to a quick, correct, and inexpensive fix.",
                readingSkill: "Use mechanical clues to explain a conclusion",
                reflectionPrompt: "What did the closer look reveal?",
                hints: ["Look for when the clicking grew louder", "Reread what the closer look revealed"],
                commonMistakes: ["Assuming every strange sound means a serious engine problem"],
                successCriteria: ["Explains Rosa's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "cars.confident.engine-clues.conclusion",
                characterNames: ["Rosa"]
            )
        }
    }

    private static func carsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Cars",
                storyOpening: "Rosa needs a careful count in the parking lot.",
                missionPrompt: "Count the cars and compare the groups.",
                readingPassage: "Four cars sit in the parking lot. Two wheels rest on the workbench. Rosa points and counts out loud.",
                problems: [
                    mcq("Rosa sees 2 cars, then 2 more join. How many cars in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 wheels on the left and 3 cars on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Rosa counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Rosa can count the cars.")],
                knowledgeFacts: [KnowledgeFact(fact: "Mechanics count parts carefully before starting any repair.")],
                creativePrompt: "Draw 4 cars in the parking lot.",
                storyEnding: "Rosa's car count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 wheels on the left and 3 cars on the right. Which side has more?",
                hints: ["Point to each car", "Compare the two groups"],
                activityFingerprint: "cars.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Wheels for the Workbench",
                storyOpening: "Rosa sorts parts before a busy repair day.",
                missionPrompt: "Add and subtract to finish the garage jobs.",
                readingPassage: "Rosa rolls tires into the garage bay. She checks how many wheels are ready and how many oil bottles still need refilling.",
                problems: [
                    mcq("Rosa finds 6 wheels. Then she finds 3 more. How many wheels in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A parts bin holds 10 oil bottles. Rosa hands 4 oil bottles to other mechanics. How many oil bottles are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Rosa found 8 tools on her bench. Later she noticed 5 had rolled under a car. How many tools are left on the bench?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total wheels.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking part numbers helps a garage finish repairs faster.")],
                creativePrompt: "Draw 9 wheels ready for the repair day.",
                storyEnding: "The garage is ready for the repair day.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A parts bin holds 10 oil bottles. Rosa hands 4 oil bottles to other mechanics. How many oil bottles are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "cars.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Rosa",
                pronoun: "she",
                items: [
                    ("engine bolts", "in the bolt tin"),
                    ("spare wheels", "in the tire rack"),
                    ("fuel caps", "on the parts shelf")
                ],
                packItem: "engine bolts",
                purpose: "for the busy garage shift"
            )
            return MathScene(
                title: "Groups in the Garage",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Rosa unpacks 3 boxes with 4 wheels in each box. How many wheels does she unpack?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("One fuel hose is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten engine bolts.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the garage has enough car parts.")],
                creativePrompt: "Draw 3 boxes with 4 wheels in each box in Rosa's garage.",
                storyEnding: "The garage is ready for the busy shift.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Rosa unpacks 3 boxes with 4 wheels in each box. How many wheels does she unpack?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "cars.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Garage Repair Day" : "Equal Shares of Hubcaps",
                storyOpening: "Rosa plans supplies for a full day of repairs.",
                missionPrompt: multi ? "Solve each garage problem." : "Solve each garage problem carefully.",
                readingPassage: "Shiny hubcaps and spare bolts are shared with customers after each repair.",
                problems: [
                    mcq("Rosa builds 3 sets of shiny hubcaps with 8 hubcaps in each set. How many hubcaps does she build?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Rosa shares 18 spare bolts among 3 customers equally. How many does each customer get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One seat belt strap is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "each", definition: "For every one group.", exampleSentence: "Each box holds the same number of hubcaps.")],
                knowledgeFacts: [KnowledgeFact(fact: "A hubcap covers the center of a car's wheel.")],
                creativePrompt: "Draw the hubcap packs.",
                storyEnding: "Every customer gets a fair share. Great work, Rosa!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A car wash bucket holds 4 cups of soapy water. Rosa adds 2 more cups. How many cups are in the bucket now?",
                hints: mathHints(level),
                activityFingerprint: "cars.math.advancing.hubcaps"
            )
        }
    }

    // MARK: - Robots (Max — circuits, sensors, troubleshooting clues)

    private static func robotsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Max Turns On the Robot",
                storyOpening: "Max stands beside a small silver robot. Will it wake up today?",
                missionPrompt: "Find out what happens when Max turns the robot on.",
                readingPassage: "Max wants to know if his robot still works. He presses the button on its side. The robot beeps awake. Its blinking light shows it is ready.",
                questions: [
                    mcq("Why does Max press the button?", ["To see if his robot still works", "To turn off the lights", "To call a friend"], "To see if his robot still works", "Max wants to know if his robot still works, so he presses the button."),
                    mcq("What does the robot do first?", ["It beeps awake", "It sings a song", "It falls asleep"], "It beeps awake", "The robot beeps awake."),
                    mcq("What shows the robot is ready?", ["Its blinking light", "A loud horn", "A written note"], "Its blinking light", "Its light blinks to show it is ready.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "robot", definition: "A machine that can move and do jobs.", exampleSentence: "Max turns on the robot."),
                    VocabularyWord(word: "blink", definition: "To turn on and off quickly.", exampleSentence: "The robot's light blinks.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Many robots use blinking lights to show that they are turned on and working.", explanation: "A blinking light is one way a robot tells us it is active.")
                ],
                creativePrompt: "Draw the robot with its blinking light.",
                creativeResponseType: .drawing,
                storyEnding: "The little robot is on and ready to help.",
                readingSkill: "Follow a simple robot story",
                reflectionPrompt: "What did the robot do?",
                hints: ["Find the word beep", "Look for the word blink"],
                commonMistakes: ["Choosing an action the robot did not do"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short robot story"],
                activityFingerprint: "robots.k.button-press.detail",
                characterNames: ["Max"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Max Builds a Sensor Arm",
                storyOpening: "Max clears space on his workbench for a careful build.",
                missionPrompt: "Follow Max's building steps. Answer with clues from the text.",
                readingPassage: "Max connects a sensor to a thin wire on the robot's arm. The sensor lets the robot feel when it bumps into something soft or hard. Next, Max screws a small gear into place so the arm can bend at the elbow. He tests the arm by tapping it gently to see if the sensor reacts. Soft buzzing shows the sensor is working correctly.",
                questions: [
                    mcq("What does the sensor let the robot do?", ["Feel when it bumps into something", "Hear how loud the room is", "See in the dark"], "Feel when it bumps into something", "The sensor lets the robot feel when it bumps into something."),
                    mcq("What does Max screw into place?", ["A small gear", "A tiny mirror", "A paper wheel"], "A small gear", "Max screws a small gear into place."),
                    mcq("How does Max test the arm?", ["By tapping it gently", "By throwing it across the room", "By painting it a new color"], "By tapping it gently", "He tests the arm by tapping it gently.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "sensor", definition: "A part that detects things like touch, light, or sound.", exampleSentence: "The sensor lets the robot feel a bump."),
                    VocabularyWord(word: "gear", definition: "A small wheel with teeth that helps parts move together.", exampleSentence: "Max screws a small gear into place.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Sensors help robots detect the world around them, like touch, light, or sound.", explanation: "Without sensors, a robot would not know when it bumped into something.")
                ],
                creativePrompt: "Draw the robot's arm with its sensor and gear.",
                creativeResponseType: .drawing,
                storyEnding: "The arm buzzes softly, and Max knows the sensor is working correctly.",
                readingSkill: "Recall building details from a robot passage",
                reflectionPrompt: "Why might a robot need a sensor on its arm?",
                hints: ["Find the sentence about the gear", "Look for the word sensor"],
                commonMistakes: ["Skipping the sensor detail"],
                successCriteria: ["Uses a building detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "robots.early.sensor-arm.detail",
                characterNames: ["Max"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Robots Need Sensors, Not Just Motors",
                storyOpening: "A student asks Max why his robot needs sensors when it already has motors.",
                missionPrompt: "Find the main idea about why robots use sensors. Use Max's explanation.",
                readingPassage: "A student once asked Max why his robot needed sensors when it already had motors to move its arms and wheels. Max explained that motors alone only make a robot move — they cannot tell the robot anything about the world around it. Sensors give the robot information, such as how close it is to an object, how bright the room is, or whether it has bumped into something. Without sensors, a robot with only motors would move blindly and could crash into walls or drop things it was supposed to hold carefully. Combining motors with sensors lets a robot both act and react. That is what makes it seem intelligent instead of just repeating the same motion over and over.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Sensors give robots information that motors alone cannot provide", "Motors are more important than sensors for every robot", "Robots do not need sensors if they have strong motors"], "Sensors give robots information that motors alone cannot provide", "Max explains that sensors give information motors cannot provide."),
                    mcq("What might happen to a robot with only motors and no sensors?", ["It could crash into walls or drop things", "It would move faster than any other robot", "It would need no electricity at all"], "It could crash into walls or drop things", "Without sensors, a robot could crash into walls or drop things."),
                    mcq("What does combining motors with sensors let a robot do?", ["Both act and react to its surroundings", "Only repeat the same motion forever", "Turn off automatically after one use"], "Both act and react to its surroundings", "Combining motors with sensors lets a robot act and react.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "motor", definition: "A part that makes something move using electricity.", exampleSentence: "Motors move the robot's arms and wheels."),
                    VocabularyWord(word: "react", definition: "To respond to something that happens.", exampleSentence: "Sensors let a robot react to its surroundings.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Robots combine motors for movement with sensors for information about their surroundings.", explanation: "This combination lets robots act and react instead of moving blindly.")
                ],
                creativePrompt: "Draw a robot and label one motor part and one sensor part.",
                creativeResponseType: .drawing,
                storyEnding: "The student leaves understanding that sensors, not just motors, make a robot seem smart.",
                readingSkill: "Identify the main idea in a robotics passage",
                reflectionPrompt: "Why might a robot without sensors be dangerous around fragile objects?",
                hints: ["Reread Max's explanation about motors versus sensors", "Think about what happens without sensors"],
                commonMistakes: ["Thinking motors alone are enough for a robot to work well"],
                successCriteria: ["States the sensors-versus-motors main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction technology passage"],
                activityFingerprint: "robots.growing.sensors-motors.main-idea",
                characterNames: ["Max"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Why the Robot Suddenly Stopped",
                storyOpening: "Max's robot freezes during a demonstration, and two screen readings may explain why.",
                missionPrompt: "Figure out why the robot froze and what happened after it cooled.",
                readingPassage: """
                When Max's robot suddenly froze in the middle of a demonstration, he did not assume the motor was broken. Instead, he checked two pieces of information on the robot's diagnostic screen. The battery level still showed seventy percent charge, and the error log displayed a repeated overheating warning from the arm's motor. Max reasoned that if the battery were the problem, the screen would likely show a very low charge — but seventy percent was more than enough power to keep running. The overheating warning matched a motor that had been used continuously for nearly an hour without a break. Comparing both clues, Max concluded that the motor had automatically shut down to protect itself from overheating, not because the robot had run out of power. After letting the robot cool down for ten minutes, the arm moved normally again, confirming his conclusion. Max told his younger cousin that checking two pieces of evidence, rather than guessing at the first idea, helped him find the real answer faster.
                """,
                questions: [
                    mcq("Why did Max's robot freeze during the demonstration?", ["The arm motor shut down to protect itself from overheating", "The battery had completely run out of power", "The robot's arm had broken permanently"], "The arm motor shut down to protect itself from overheating", "Max concluded the motor shut down to protect itself from overheating."),
                    mcq("How much charge did the battery still show?", ["Seventy percent", "No charge at all", "One hundred percent"], "Seventy percent", "The battery level still showed seventy percent charge."),
                    mcq("What happened after Max let the robot cool for ten minutes?", ["The arm moved normally again", "The robot never worked again", "The battery recharged itself"], "The arm moved normally again", "After ten minutes of cooling, the arm moved normally again.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "diagnostic", definition: "A diagnostic check finds out what is wrong with a machine.", exampleSentence: "Max checked the robot's diagnostic screen."),
                    VocabularyWord(word: "overheating", definition: "Overheating means a machine is becoming too hot to keep working safely.", exampleSentence: "The error log showed an overheating warning.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Many robots automatically shut down a motor if it overheats, to protect the motor from damage.", explanation: "This safety feature prevents permanent harm to the robot's parts.")
                ],
                creativePrompt: "Write two sentences retelling why the robot froze and what happened after it cooled.",
                creativeResponseType: .shortText,
                storyEnding: "Max's comparison of two clues turns a scary freeze into a simple cooling break.",
                readingSkill: "Use diagnostic clues to explain a conclusion",
                reflectionPrompt: "Why did cooling the robot confirm Max was right about the motor?",
                hints: ["Look at the battery level on the screen", "Reread what happened after the robot cooled"],
                commonMistakes: ["Assuming the battery was dead without checking the error log"],
                successCriteria: ["Explains Max's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "robots.confident.overheat-clues.conclusion",
                characterNames: ["Max"]
            )
        }
    }

    private static func robotsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Gears",
                storyOpening: "Max needs a careful count on his workbench.",
                missionPrompt: "Count the gears and compare the groups.",
                readingPassage: "Four gears sit on the workbench. Two sensors rest beside them. Max points and counts out loud.",
                problems: [
                    mcq("Max sees 2 gears, then 2 more join. How many gears in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 sensors on the left and 3 gears on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Max counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Max can count the gears.")],
                knowledgeFacts: [KnowledgeFact(fact: "Robot builders count small parts carefully before every project.")],
                creativePrompt: "Draw 4 gears on the workbench.",
                storyEnding: "Max's gear count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 sensors on the left and 3 gears on the right. Which side has more?",
                hints: ["Point to each gear", "Compare the two groups"],
                activityFingerprint: "robots.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Wires for the Robot",
                storyOpening: "Max sorts parts before building a new robot.",
                missionPrompt: "Add and subtract to finish the robot jobs.",
                readingPassage: "Max sorts wires into a parts tray before the build. He checks how many wires he has and how many batteries still need testing.",
                problems: [
                    mcq("Max finds 6 wires. Then he finds 3 more. How many wires in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A parts box holds 10 batteries. Max hands 4 batteries to another builder. How many batteries are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Max began with 8 screws and gave away 5 to his helper. How many screws does Max have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total wires.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking part numbers helps a robot get built correctly.")],
                creativePrompt: "Draw 9 wires ready for the new robot.",
                storyEnding: "The workbench is ready for building.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A parts box holds 10 batteries. Max hands 4 batteries to another builder. How many batteries are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "robots.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Max",
                pronoun: "he",
                items: [
                    ("circuit boards", "in the board bin"),
                    ("sensors", "in the sensor tray"),
                    ("screws", "in the screw cup")
                ],
                packItem: "screws",
                purpose: "for the big build"
            )
            return MathScene(
                title: "Groups on the Workbench",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Max builds 3 groups of sensors with 4 sensors in each group. How many sensors does he build?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A robot arm is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten screws.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the workbench has enough parts.")],
                creativePrompt: "Draw 3 groups of sensors with 4 sensors in each group.",
                storyEnding: "The workbench is ready for the big build.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Max builds 3 groups of sensors with 4 sensors in each group. How many sensors does he build?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "robots.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Robot Build Day" : "Equal Shares of Batteries",
                storyOpening: "Max plans parts for a full day of building.",
                missionPrompt: multi ? "Solve each robot problem." : "Solve each robot problem carefully.",
                readingPassage: "Circuit boards and batteries are shared with the robotics team during the build.",
                problems: [
                    mcq("Max assembles 3 kits with 8 circuit boards in each kit. How many boards does he assemble?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Max shares 18 batteries among 3 robots equally. How many does each robot get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One robot arm is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "share", definition: "To split into equal parts.", exampleSentence: "Share the boards equally.")],
                knowledgeFacts: [KnowledgeFact(fact: "A circuit board carries electricity to a robot's parts.")],
                creativePrompt: "Draw the circuit board packs.",
                storyEnding: "Every robot gets a fair share. Great build, Max!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A test tray holds 4 sensors. Max adds 2 more sensors. How many sensors are on the tray now?",
                hints: mathHints(level),
                activityFingerprint: "robots.math.advancing.circuit-boards"
            )
        }
    }

    // MARK: - Superheroes (Nina — training, courage, choice-based clues)

    private static func superheroesReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Nina Saves the Cat",
                storyOpening: "Nina wears a bright cape in the park. Can she help the stuck cat?",
                missionPrompt: "Discover how Nina saves the cat.",
                readingPassage: "Nina sees a cat stuck in a tree. She climbs up slowly. Then she lifts the cat gently. Now the cat is safe.",
                questions: [
                    mcq("Where is the cat stuck?", ["In a tree", "In a box", "In a pond"], "In a tree", "Nina sees a cat stuck in a tree."),
                    mcq("How does Nina climb?", ["Slowly", "Backwards", "Sideways"], "Slowly", "She climbs up slowly."),
                    mcq("How does Nina lift the cat?", ["Gently", "Roughly", "Quickly and loudly"], "Gently", "She lifts the cat gently.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "gently", definition: "In a soft, careful way.", exampleSentence: "Nina lifts the cat gently."),
                    VocabularyWord(word: "rescue", definition: "To save someone or something from danger.", exampleSentence: "Nina helps rescue the cat.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Real-life helpers, like firefighters, often climb carefully and slowly to rescue animals safely.", explanation: "Moving carefully helps keep both the helper and the animal safe.")
                ],
                creativePrompt: "Draw Nina gently lifting the cat down from the tree.",
                creativeResponseType: .drawing,
                storyEnding: "The cat is safe on the ground, thanks to Nina's careful climb.",
                readingSkill: "Follow a simple hero story",
                reflectionPrompt: "How does Nina climb?",
                hints: ["Find the word tree", "Look for the word gently"],
                commonMistakes: ["Choosing a place the cat was not stuck in"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short hero story"],
                activityFingerprint: "superheroes.k.cat-rescue.detail",
                characterNames: ["Nina"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Nina Helps at the Playground",
                storyOpening: "A little boy trips near the swings. Nina is close enough to help.",
                missionPrompt: "Follow Nina's helping steps. Discover how she cares for the boy.",
                readingPassage: "Nina notices a little boy trip and scrape his knee near the swings. She kneels down and asks him gently if he is okay. Nina walks with him to find his mother nearby on a bench. She helps clean the small scrape with a tissue from her bag. The little boy smiles and thanks Nina before running off to play again.",
                questions: [
                    mcq("What happens to the little boy?", ["He trips and scrapes his knee", "He falls asleep on a bench", "He climbs to the top of a slide"], "He trips and scrapes his knee", "A little boy trips and scrapes his knee near the swings."),
                    mcq("What does Nina ask the boy?", ["If he is okay", "What his favorite color is", "If he wants to race"], "If he is okay", "She asks him gently if he is okay."),
                    mcq("What does Nina use to clean the scrape?", ["A tissue from her bag", "A leaf from the ground", "Water from a fountain"], "A tissue from her bag", "She helps clean the small scrape with a tissue from her bag.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "scrape", definition: "A small injury where skin is rubbed off.", exampleSentence: "The boy scraped his knee."),
                    VocabularyWord(word: "kneel", definition: "To bend down onto one or both knees.", exampleSentence: "Nina kneels down to help the boy.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Helping someone who is hurt, even in a small way, is one form of everyday heroism.", explanation: "Heroes are not only in stories — small acts of kindness matter too.")
                ],
                creativePrompt: "Draw Nina kneeling down to help the little boy.",
                creativeResponseType: .drawing,
                storyEnding: "The little boy smiles and runs off to play again, thanks to Nina's kindness.",
                readingSkill: "Recall helping details from a hero passage",
                reflectionPrompt: "What is one small way you could help someone who is hurt?",
                hints: ["Find the sentence about the tissue", "Look for the word scrape"],
                commonMistakes: ["Skipping the detail about finding the boy's mother"],
                successCriteria: ["Uses a helping detail from the story"],
                learningObjectives: ["Recall key details from a short narrative passage"],
                activityFingerprint: "superheroes.early.playground-help.detail",
                characterNames: ["Nina"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Nina Thinks Before She Acts",
                storyOpening: "A younger student asks Nina how she chooses the right way to help.",
                missionPrompt: "Find the main idea about how Nina makes good choices. Use her explanation.",
                readingPassage: "A younger student once asked Nina how she always seemed to know the right way to help when something went wrong. Nina explained that being a good helper is not about running in without thinking — it is about pausing for just a moment to notice what is actually happening before acting. She said that if someone is hurt, she first checks whether it is safe to approach, then decides whether she can help herself or needs to get an adult. Nina added that rushing in without checking can sometimes make a situation worse, even when someone means well. By taking a brief moment to observe and think, Nina is able to choose the action that helps the most without causing new problems.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Pausing to think before acting leads to better, safer choices", "Helping always means running in as fast as possible", "Thinking before acting makes a person less helpful"], "Pausing to think before acting leads to better, safer choices", "Nina explains that pausing to think leads to safer, better choices."),
                    mcq("What does Nina check first when someone is hurt?", ["Whether it is safe to approach", "What color the person's clothes are", "How far away the nearest store is"], "Whether it is safe to approach", "She first checks whether it is safe to approach."),
                    mcq("What can happen if someone rushes in without checking?", ["The situation can sometimes get worse", "The problem always disappears instantly", "Nothing changes at all"], "The situation can sometimes get worse", "Rushing in without checking can sometimes make things worse.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "observe", definition: "To watch carefully and notice details.", exampleSentence: "Nina takes a moment to observe before acting."),
                    VocabularyWord(word: "approach", definition: "To move closer to someone or something.", exampleSentence: "Nina checks if it is safe to approach.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Trained helpers, like lifeguards and first responders, are taught to check for safety before rushing to help.", explanation: "Checking safety first protects both the helper and the person who needs help.")
                ],
                creativePrompt: "Draw Nina pausing to observe before she decides how to help.",
                creativeResponseType: .drawing,
                storyEnding: "The younger student learns that real helpers think carefully before they act.",
                readingSkill: "Identify the main idea in a decision-making passage",
                reflectionPrompt: "Why might pausing for a moment lead to a better choice than acting instantly?",
                hints: ["Reread Nina's explanation about pausing to observe", "Think about what happens when someone rushes into the room."],
                commonMistakes: ["Thinking a good helper always acts as fast as possible"],
                successCriteria: ["States the pause-before-acting main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction character-education passage"],
                activityFingerprint: "superheroes.growing.pause-think.main-idea",
                characterNames: ["Nina"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Reading the Situation Before Helping",
                storyOpening: "A classmate is crying at recess. Nina pauses to notice two small details before she steps in.",
                missionPrompt: "Compare the social clues. Check what Nina conclude is the kindest way to help.",
                readingPassage: """
                When Nina saw a classmate crying quietly at recess, she did not rush over and ask loud questions in front of everyone. Instead, she noticed two things first: the classmate had moved to a spot away from the other kids, and he kept glancing toward the group as if worried about being noticed. Nina reasoned that someone who wanted a lot of attention would likely be crying somewhere more visible, while someone who moved away and kept checking who was watching probably wanted privacy, not a crowd. Based on these two clues, Nina concluded that the kindest way to help was to walk over calmly, sit down quietly beside him, and ask a simple, gentle question instead of announcing the situation to the whole playground. Her calm approach worked, and the classmate soon opened up about a hard morning at home. Nina later told a teacher that noticing where a classmate chooses to sit, and how he acts around other kids, can show what kind of help he needs.
                """,
                questions: [
                    mcq("What did Nina conclude was the kindest way to help?", ["Walk over calmly and ask a gentle question quietly", "Announce the situation loudly to the whole playground", "Ignore the classmate completely"], "Walk over calmly and ask a gentle question quietly", "Nina concluded a calm, quiet approach was kindest."),
                    mcq("Where had the classmate moved before Nina walked over?", ["To a spot away from the other kids", "To the middle of a noisy game", "To the teacher's office"], "To a spot away from the other kids", "The classmate had moved to a spot away from the other kids."),
                    mcq("What did Nina's calm approach lead to?", ["The classmate opened up about a hard morning at home", "The classmate ran away from her", "The classmate stopped talking to her completely"], "The classmate opened up about a hard morning at home", "The classmate soon opened up about his hard morning.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "privacy", definition: "Freedom from being watched or bothered by others.", exampleSentence: "The classmate seemed to want privacy, not a crowd."),
                    VocabularyWord(word: "approach", definition: "A way of dealing with a situation.", exampleSentence: "Nina's calm approach helped her classmate feel safe.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Noticing small social clues, like where a person chooses to sit, can show how he or she wants to be helped.", explanation: "Paying attention to behavior, not just words, helps people offer the right kind of support.")
                ],
                creativePrompt: "Write two sentences about why Nina approached quietly and how that helped her classmate.",
                creativeResponseType: .shortText,
                storyEnding: "Nina's careful noticing turns a hard moment into a caring, quiet connection.",
                readingSkill: "Use social clues to explain a conclusion",
                reflectionPrompt: "Why might a quiet, private approach feel kinder than a loud, public one?",
                hints: ["Look for where the classmate chose to sit", "Reread what happened after Nina sat beside him"],
                commonMistakes: ["Assuming loud attention is always the most helpful response"],
                successCriteria: ["Explains Nina's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "superheroes.confident.quiet-clues.conclusion",
                characterNames: ["Nina"]
            )
        }
    }

    private static func superheroesMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Capes",
                storyOpening: "Nina needs a careful count before training starts.",
                missionPrompt: "Count the capes and compare the groups.",
                readingPassage: "Four capes hang on hooks. Two masks rest on the shelf. Nina points and counts out loud.",
                problems: [
                    mcq("Nina sees 2 capes, then 2 more join. How many capes in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 masks on the left and 3 capes on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Nina counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Nina can count the capes.")],
                knowledgeFacts: [KnowledgeFact(fact: "Helpers count their gear carefully before starting any job.")],
                creativePrompt: "Draw 4 capes on hooks.",
                storyEnding: "Nina's cape count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 masks on the left and 3 capes on the right. Which side has more?",
                hints: ["Point to each cape", "Compare the two groups"],
                activityFingerprint: "superheroes.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Badges for Training",
                storyOpening: "Nina sorts gear before a busy training day.",
                missionPrompt: "Add and subtract to finish the training jobs.",
                readingPassage: "Nina lines up training badges before the drill. She checks how many badges are ready and how many masks still need cleaning.",
                problems: [
                    mcq("Nina finds 6 badges. Then she finds 3 more. How many badges in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A training box holds 10 masks. Nina hands 4 masks to new trainees. How many masks are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Nina packed 8 training capes. A trainee packed only 5. How many more capes did Nina pack?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total badges.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking gear numbers helps training days run smoothly.")],
                creativePrompt: "Draw 9 badges ready for training.",
                storyEnding: "Training day is ready to begin.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A training box holds 10 masks. Nina hands 4 masks to new trainees. How many masks are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "superheroes.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Nina",
                pronoun: "she",
                items: [
                    ("capes", "in the cape closet"),
                    ("masks", "in the mask tray"),
                    ("badges", "on the hero board")
                ],
                packItem: "badges",
                purpose: "for the busy training day"
            )
            return MathScene(
                title: "Groups in Training",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Nina fills 3 trays of masks with 4 masks in each tray. How many masks are ready for training?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A training cape is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten badges.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that training gear is ready.")],
                creativePrompt: "Draw 3 trays of masks with 4 masks in each tray.",
                storyEnding: "Training day is ready to begin.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Nina fills 3 trays of masks with 4 masks in each tray. How many masks are ready for training?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "superheroes.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Helper Training Day" : "Equal Shares of Badges",
                storyOpening: "Nina plans supplies for a full day of training.",
                missionPrompt: multi ? "Solve each training problem." : "Solve each training problem carefully.",
                readingPassage: "Badges and wristbands are shared with new trainees during the training day.",
                problems: [
                    mcq("Nina packs 3 boxes with 8 badges in each box. How many badges does she pack?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Nina shares 18 wristbands among 3 trainees equally. How many does each trainee get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One training cape is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "equal", definition: "The same number in each group.", exampleSentence: "Equal groups of badges have the same count.")],
                knowledgeFacts: [KnowledgeFact(fact: "Emergency helpers often wear a badge so people can recognize them.")],
                creativePrompt: "Draw the badge trays.",
                storyEnding: "Every trainee gets a fair share. Great work, Nina!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A training kit holds 4 wristbands. Nina adds 2 more wristbands. How many wristbands are in the kit now?",
                hints: mathHints(level),
                activityFingerprint: "superheroes.math.advancing.badges"
            )
        }
    }

    // MARK: - Art (Iris — studio mixing, color clues, technique)

    private static func artReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Iris Mixes a Color",
                storyOpening: "Iris dips a brush into blue paint. What color will she make next?",
                missionPrompt: "Check what Iris mixes, and what she paints.",
                readingPassage: "Iris mixes blue and yellow. The paint turns green. Then she paints a leaf. The leaf looks real.",
                questions: [
                    mcq("What two colors does Iris mix?", ["Blue and yellow", "Red and black", "White and pink"], "Blue and yellow", "Iris mixes blue and yellow."),
                    mcq("What color does the paint turn?", ["Green", "Purple", "Orange"], "Green", "The paint turns green."),
                    mcq("What does Iris paint?", ["A leaf", "A circle", "A wheel"], "A leaf", "She paints a leaf.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "mix", definition: "To combine two or more things together.", exampleSentence: "Iris mixes blue and yellow paint."),
                    VocabularyWord(word: "brush", definition: "A tool with bristles used to paint.", exampleSentence: "Iris dips her brush into paint.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Mixing blue and yellow paint always makes green.", explanation: "Artists mix colors together to make brand-new colors.")
                ],
                creativePrompt: "Draw a leaf using green paint you imagine mixing.",
                creativeResponseType: .drawing,
                storyEnding: "Iris's green leaf looks so real that it seems ready to grow.",
                readingSkill: "Follow a simple art story",
                reflectionPrompt: "What color did Iris make?",
                hints: ["Find the word green", "Look for the word leaf"],
                commonMistakes: ["Choosing a color Iris did not mix"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short art story"],
                activityFingerprint: "art.k.color-mix.detail",
                characterNames: ["Iris"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Iris Paints Layer by Layer",
                storyOpening: "A blank canvas sits on Iris's easel in the sunny studio.",
                missionPrompt: "Follow Iris's painting steps. Check what she adds layer by layer.",
                readingPassage: "Iris starts with a light wash of pale blue across the whole canvas for the sky. She waits for that layer to dry completely before adding darker clouds on top. Next, she paints tall green trees along the bottom edge of the canvas. Finally, Iris adds small white highlights to make the clouds look soft and puffy. Each layer builds on the one before it.",
                questions: [
                    mcq("What does Iris paint first?", ["A light wash of pale blue for the sky", "Tall green trees", "Small white highlights"], "A light wash of pale blue for the sky", "Iris starts with a light wash of pale blue for the sky."),
                    mcq("What does Iris wait for before adding clouds?", ["The first layer to dry completely", "The sun to set", "Her brush to break"], "The first layer to dry completely", "She waits for that layer to dry completely."),
                    mcq("What makes the clouds look soft and puffy?", ["Small white highlights", "Tall green trees", "A light blue wash"], "Small white highlights", "Iris adds small white highlights to make the clouds look soft.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "layer", definition: "One thin coat of paint added on top of another.", exampleSentence: "Each paint layer builds on the one before it."),
                    VocabularyWord(word: "highlight", definition: "A bright spot added to show light hitting something.", exampleSentence: "Iris adds white highlights to the clouds.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Painters often let one layer of paint dry before adding the next layer on top.", explanation: "This keeps colors from blending together by accident.")
                ],
                creativePrompt: "Draw Iris's canvas with the sky, clouds, and trees.",
                creativeResponseType: .drawing,
                storyEnding: "The finished painting glows with soft clouds and tall green trees.",
                readingSkill: "Recall painting steps from an art passage",
                reflectionPrompt: "Why might Iris wait for one layer to dry before adding another?",
                hints: ["Find the sentence about drying", "Look for the word highlights"],
                commonMistakes: ["Mixing up the order of the painting steps"],
                successCriteria: ["Uses a painting-step detail from the story"],
                learningObjectives: ["Recall key details and sequence from a short passage"],
                activityFingerprint: "art.early.layer-painting.detail",
                characterNames: ["Iris"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Iris Studies Light Before Painting",
                storyOpening: "A student asks Iris why she stares at a bowl of fruit so long before she paints.",
                missionPrompt: "Find the main idea about why artists study light. Use Iris's explanation.",
                readingPassage: "A student once asked Iris why she spent so much time just looking at a bowl of fruit before ever picking up a brush. Iris explained that she was studying exactly where the light hit the fruit and where the shadows fell, because those details make a painting look three-dimensional instead of flat. She pointed out that the side of an apple facing a window would be bright, while the opposite side would be darker, with the darkest shadow appearing where the apple met the table. Iris said that if she skipped this study and simply painted the apple one flat color, it would look like a sticker instead of a real object sitting on a table. By carefully observing light and shadow first, Iris is able to paint fruit that looks like it could be picked up.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Studying light and shadow helps a painting look three-dimensional", "Looking at fruit before painting is a waste of time", "Flat colors always make the best paintings"], "Studying light and shadow helps a painting look three-dimensional", "Iris explains that studying light and shadow makes a painting look three-dimensional."),
                    mcq("What happens if Iris paints the apple one flat color?", ["It would look like a sticker instead of a real object", "It would look exactly like a real apple", "It would take much longer to paint"], "It would look like a sticker instead of a real object", "She says it would look like a sticker instead of a real object."),
                    mcq("Where does the darkest shadow on the apple appear?", ["Where the apple meets the table", "On the side facing the window", "On the very top of the apple"], "Where the apple meets the table", "The darkest shadow appears where the apple meets the table.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "three-dimensional", definition: "Having depth, so something looks real instead of flat.", exampleSentence: "Shadows make a painting look three-dimensional."),
                    VocabularyWord(word: "observe", definition: "To watch something carefully and notice details.", exampleSentence: "Iris observes the light on the fruit before painting.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Artists study where light and shadow fall on an object to make paintings look three-dimensional.", explanation: "Without shadows, a painted object can look flat like a sticker.")
                ],
                creativePrompt: "Draw an apple with a bright side and a shadow side.",
                creativeResponseType: .drawing,
                storyEnding: "The student learns that noticing light and shadow is the secret to painting something that looks real.",
                readingSkill: "Identify the main idea in an art-technique passage",
                reflectionPrompt: "Why might shadows be just as important as color in a painting?",
                hints: ["Reread Iris's explanation about light and shadow", "Think about the flat sticker comparison"],
                commonMistakes: ["Thinking color alone makes a painting look real"],
                successCriteria: ["States the light-and-shadow main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction art passage"],
                activityFingerprint: "art.growing.light-shadow.main-idea",
                characterNames: ["Iris"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "What Went Wrong With the Painting",
                storyOpening: "A student's painting turned muddy brown. Iris looks for two clues before she explains why.",
                missionPrompt: "Compare the painting clues. Check what Iris conclude caused the muddy color.",
                readingPassage: """
                When a young student showed Iris a painting that had turned an unexpected muddy brown color, Iris did not immediately say the student had used the wrong colors. Instead, she looked for two clues on the canvas: the brushstrokes showed clear signs of colors being blended directly on the wet canvas rather than mixed on a palette first, and the student's palette itself still had small, mostly separate blobs of blue, red, and yellow that had not been fully combined. Iris reasoned that mixing too many colors directly on the canvas, especially complementary colors like blue and orange, tends to create murky brown or gray tones rather than the bright colors a painter usually wants. Based on both clues, she concluded that the muddiness came from over-blending on the canvas itself, not from choosing the wrong paint colors to begin with. She showed the student how mixing smaller amounts on the palette first, then applying clean strokes, kept colors vivid. The student's next painting glowed with color instead of turning muddy, confirming Iris's explanation.
                """,
                questions: [
                    mcq("What did Iris conclude caused the muddy brown color?", ["Over-blending too many colors directly on the canvas", "Using the completely wrong paint colors", "Not enough paint on the brush"], "Over-blending too many colors directly on the canvas", "Iris concluded the muddiness came from over-blending on the canvas."),
                    mcq("What was still sitting in separate blobs on the palette?", ["Blue, red, and yellow paint", "Only muddy brown paint", "Water instead of paint"], "Blue, red, and yellow paint", "The palette still had small, mostly separate blobs of blue, red, and yellow."),
                    mcq("What fixed the muddiness in the student's next painting?", ["Mixing smaller amounts on the palette first, then applying clean strokes", "Using only one color for the whole painting", "Painting in complete darkness"], "Mixing smaller amounts on the palette first, then applying clean strokes", "Mixing on the palette first and applying clean strokes kept colors vivid.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "palette", definition: "A flat surface artists use to mix paint colors.", exampleSentence: "The student's palette had blobs of unmixed paint."),
                    VocabularyWord(word: "complementary", definition: "Describes colors that are opposite each other, like blue and orange.", exampleSentence: "Mixing complementary colors can create muddy tones.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Mixing too many colors directly on a canvas, especially complementary colors, often creates muddy brown or gray tones.", explanation: "Mixing smaller amounts on a palette first helps keep colors bright and clear.")
                ],
                creativePrompt: "Write two sentences about why the painting turned muddy and how the student fixed it next time.",
                creativeResponseType: .shortText,
                storyEnding: "Iris's two clues turn a confusing muddy painting into a clear lesson about color mixing.",
                readingSkill: "Use technique clues to explain a conclusion",
                reflectionPrompt: "Why might mixing on a palette first help keep colors bright?",
                hints: ["Look at how the colors were blended", "Reread what kept the next painting vivid"],
                commonMistakes: ["Assuming muddy colors always mean the wrong paint was chosen"],
                successCriteria: ["Explains Iris's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "art.confident.muddy-clues.conclusion",
                characterNames: ["Iris"]
            )
        }
    }

    private static func artMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Paintbrushes",
                storyOpening: "Iris needs a careful count before class starts.",
                missionPrompt: "Count the paintbrushes and compare the groups.",
                readingPassage: "Four paintbrushes stand in a cup. Two paint tubes rest beside them. Iris points and counts out loud.",
                problems: [
                    mcq("Iris sees 2 paintbrushes, then 2 more join. How many paintbrushes in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 paint tubes on the left and 3 paintbrushes on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Iris counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Iris can count the paintbrushes.")],
                knowledgeFacts: [KnowledgeFact(fact: "Artists count their supplies carefully before starting a new painting.")],
                creativePrompt: "Draw 4 paintbrushes in a cup.",
                storyEnding: "Iris's paintbrush count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 paint tubes on the left and 3 paintbrushes on the right. Which side has more?",
                hints: ["Point to each paintbrush", "Compare the two groups"],
                activityFingerprint: "art.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Paint Tubes for the Studio",
                storyOpening: "Iris sorts supplies before a busy art class.",
                missionPrompt: "Add and subtract to finish the studio jobs.",
                readingPassage: "Iris lines up paint tubes on the studio shelf. She checks how many tubes are ready and how many brushes still need cleaning.",
                problems: [
                    mcq("Iris finds 6 paint tubes. Then she finds 3 more. How many paint tubes in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A supply box holds 10 brushes. Iris hands 4 brushes to her students. How many brushes are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Iris started the day with 8 blank canvases. She gives away 5 canvases to her students. How many canvases does Iris have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total paint tubes.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking supply numbers helps an art class run smoothly.")],
                creativePrompt: "Draw 9 paint tubes ready for class.",
                storyEnding: "The studio is ready for the art class.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A supply box holds 10 brushes. Iris hands 4 brushes to her students. How many brushes are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "art.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Iris",
                pronoun: "she",
                items: [
                    ("colored pencils", "in the pencil cup"),
                    ("brushes", "in the brush jar"),
                    ("canvases", "on the art rack")
                ],
                packItem: "colored pencils",
                purpose: "for the busy class"
            )
            return MathScene(
                title: "Groups in the Studio",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Iris stacks canvases into 3 equal groups of 4 canvases. How many canvases are there?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A canvas frame is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten pencils.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the studio has enough supplies.")],
                creativePrompt: "Draw 3 equal groups of 4 canvases.",
                storyEnding: "The studio is ready for the busy class.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Iris stacks canvases into 3 equal groups of 4 canvases. How many canvases are there?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "art.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Art Show Day" : "Equal Shares of Paint Tubes",
                storyOpening: "Iris plans supplies for a full day of the art show.",
                missionPrompt: multi ? "Solve each studio problem." : "Solve each studio problem carefully.",
                readingPassage: "Paint sets and paint tubes are shared with young artists during the art show.",
                problems: [
                    mcq("Iris fills 3 trays with 8 paint tubes in each tray. How many tubes does she prepare?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Iris shares 18 paint tubes among 3 young artists equally. How many does each artist get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One canvas frame is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "times", definition: "Groups of the same size counted that many times.", exampleSentence: "3 times 8 is 24 paint tubes.")],
                knowledgeFacts: [KnowledgeFact(fact: "Paint in tubes stays fresh until an artist squeezes some out.")],
                creativePrompt: "Draw the paint-tube trays.",
                storyEnding: "Every young artist gets a fair share. Great show, Iris!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water cup holds 4 rinsed brushes. Iris adds 2 more brushes. How many brushes are in the cup now?",
                hints: mathHints(level),
                activityFingerprint: "art.math.advancing.paint-sets"
            )
        }
    }

    // MARK: - Music (Milo — practice, tempo, listening clues)

    private static func musicReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Milo Plays a Drum",
                storyOpening: "Milo sits behind a small drum. What sound will it make?",
                missionPrompt: "Check what Milo plays, and how he taps.",
                readingPassage: "Milo taps the drum. The drum says boom, boom, boom. He taps fast, then slow. The drum sounds happy.",
                questions: [
                    mcq("What does Milo tap?", ["The drum", "A window", "A plate"], "The drum", "Milo taps the drum."),
                    mcq("What sound does the drum make?", ["Boom, boom, boom", "Ring, ring, ring", "Buzz, buzz, buzz"], "Boom, boom, boom", "The drum says boom, boom, boom."),
                    mcq("How does Milo tap at the end?", ["Fast, then slow", "Only slow", "Only backwards"], "Fast, then slow", "He taps fast, then slow.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "tap", definition: "To hit something lightly and quickly.", exampleSentence: "Milo taps the drum."),
                    VocabularyWord(word: "rhythm", definition: "A pattern of sound that repeats.", exampleSentence: "Milo's tapping makes a rhythm.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Drums make sound when their tight surface, called a drumhead, vibrates after being tapped.", explanation: "Tapping the drumhead makes it shake quickly. That shaking creates the boom sound.")
                ],
                creativePrompt: "Draw Milo tapping his drum.",
                creativeResponseType: .drawing,
                storyEnding: "Milo's happy drumbeat fills the room.",
                readingSkill: "Follow a simple music story",
                reflectionPrompt: "What did Milo tap?",
                hints: ["Find the word drum", "Look for the word boom"],
                commonMistakes: ["Choosing an object Milo did not tap"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short music story"],
                activityFingerprint: "music.k.drum-tap.detail",
                characterNames: ["Milo"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Milo Learns a New Song",
                storyOpening: "Sheet music sits open on the stand in front of Milo.",
                missionPrompt: "Follow Milo's practice steps. Check what he does when he makes a mistake.",
                readingPassage: "Milo looks at the sheet music and hums the first few notes quietly to himself. He plays the notes slowly on his keyboard, checking each one against the page. When he makes a mistake, Milo goes back to the start of that line and tries again. After several tries, Milo plays the whole line without a single mistake. He smiles and moves on to the next line of the song.",
                questions: [
                    mcq("What does Milo do with the first few notes?", ["Hums them quietly to himself", "Sings them very loudly", "Skips them completely"], "Hums them quietly to himself", "Milo hums the first few notes quietly to himself."),
                    mcq("What does Milo do when he makes a mistake?", ["Goes back to the start of that line and tries again", "Stops practicing for the day", "Skips to a different song"], "Goes back to the start of that line and tries again", "He goes back to the start of that line and tries again."),
                    mcq("What happens after Milo plays the line without mistakes?", ["He smiles and moves on to the next line", "He starts the whole song over", "He puts his keyboard away"], "He smiles and moves on to the next line", "Milo smiles and moves on to the next line of the song.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "notes", definition: "Symbols on sheet music that show which sounds to play.", exampleSentence: "Milo checks each note against the page."),
                    VocabularyWord(word: "practice", definition: "Doing something again and again to get better at it.", exampleSentence: "Milo needs practice to learn the new song.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Musicians often practice one small line of a song at a time before playing the whole piece.", explanation: "Breaking a song into small parts makes it easier to learn without mistakes.")
                ],
                creativePrompt: "Draw Milo practicing at his keyboard with the sheet music.",
                creativeResponseType: .drawing,
                storyEnding: "Milo finishes practicing, ready to learn the very next line of his new song.",
                readingSkill: "Recall practice details from a music passage",
                reflectionPrompt: "Why might practicing one line at a time help Milo learn faster?",
                hints: ["Find the sentence about mistakes", "Look for the word notes"],
                commonMistakes: ["Skipping the detail about repeating a line after a mistake"],
                successCriteria: ["Uses a practice detail from the story"],
                learningObjectives: ["Recall key details and sequence from a short passage"],
                activityFingerprint: "music.early.practice-steps.detail",
                characterNames: ["Milo"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Milo Practices Slowly First",
                storyOpening: "A younger student asks Milo why he plays a new song so slowly before he speeds up.",
                missionPrompt: "Find the main idea about why musicians practice slowly. Use Milo's explanation.",
                readingPassage: "A younger student once asked Milo why he always played a brand-new song extremely slowly, even though he could play his favorite songs quickly. Milo explained that playing slowly at first lets his fingers learn the correct pattern of notes without making mistakes along the way. He said that if he tried to play a new song at full speed right away, his fingers would likely stumble and learn the wrong pattern. That would be much harder to fix later. Once Milo's fingers can play a passage slowly and correctly several times in a row, he gradually speeds up a little bit at a time until he reaches the song's normal tempo. Milo added that rushing the learning process usually takes longer overall than practicing patiently and slowly at the start.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Practicing slowly at first helps musicians learn a song correctly", "Playing a new song at full speed is always the fastest way to learn it", "Slow practice has no real benefit for musicians"], "Practicing slowly at first helps musicians learn a song correctly", "Milo explains that slow practice helps him learn a song correctly."),
                    mcq("What might happen if Milo played a new song at full speed right away?", ["His fingers would likely stumble and learn the wrong pattern", "He would immediately play it perfectly", "The song would sound exactly like the sheet music"], "His fingers would likely stumble and learn the wrong pattern", "Playing too fast right away could cause mistakes and a wrong pattern."),
                    mcq("What does Milo do once he can play a passage slowly and correctly?", ["He gradually speeds up a little at a time", "He immediately jumps to the fastest possible speed", "He stops practicing that song completely"], "He gradually speeds up a little at a time", "He gradually speeds up until he reaches the normal tempo.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "tempo", definition: "The speed at which a piece of music is played.", exampleSentence: "Milo speeds up until he reaches the song's normal tempo."),
                    VocabularyWord(word: "passage", definition: "A short section of a piece of music.", exampleSentence: "Milo practices one passage at a time.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Musicians often practice new music slowly before gradually increasing speed to the normal tempo.", explanation: "This helps fingers learn correct note patterns instead of practicing mistakes.")
                ],
                creativePrompt: "Draw Milo practicing slowly, then playing at full speed.",
                creativeResponseType: .drawing,
                storyEnding: "The younger student learns that slow, patient practice is the secret to playing a song well.",
                readingSkill: "Identify the main idea in a music-practice passage",
                reflectionPrompt: "Why might rushing to learn a song too fast actually take longer in the end?",
                hints: ["Reread Milo's explanation about fingers learning patterns", "Think about what happens with mistakes practiced at full speed"],
                commonMistakes: ["Thinking faster practice always leads to faster learning"],
                successCriteria: ["States the slow-practice main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction music passage"],
                activityFingerprint: "music.growing.slow-practice.main-idea",
                characterNames: ["Milo"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Tracking Down the Wrong Note",
                storyOpening: "Something in the song sounds off. Milo listens for two clues before he decides what went wrong.",
                missionPrompt: "Compare Milo's listening clues. Check what he concludes.",
                readingPassage: """
                When Milo's band played through a new song and something sounded slightly off, he did not immediately blame any single musician. Instead, he listened for two specific clues: the drummer's beat stayed steady and on time throughout the entire song, while the guitarist's chords seemed to rush slightly ahead of the beat during the chorus specifically. Milo reasoned that if the whole band were out of time together, every instrument would likely sound uneven, but since only the guitar rushed and only during one section, the timing problem was probably isolated to that single part rather than the whole band. Based on comparing the steady drumbeat with the rushing chords, Milo concluded that the guitarist needed extra practice specifically on the chorus timing, not a complete relearning of the song. Sure enough, after the guitarist practiced the chorus alone with a metronome, the whole band's next run-through sounded perfectly in time. Milo told his bandmates that listening for exactly where a problem starts, rather than guessing at the whole song, saves everyone practice time.
                """,
                questions: [
                    mcq("What did Milo conclude was causing the song to sound off?", ["The guitarist was rushing ahead of the beat during the chorus", "The whole band was completely out of time", "The drummer had stopped playing entirely"], "The guitarist was rushing ahead of the beat during the chorus", "Milo concluded the guitarist was rushing during the chorus specifically."),
                    mcq("Which part of the song had the timing problem?", ["The chorus", "The very first note", "The ending silence"], "The chorus", "The guitarist's chords rushed ahead of the beat during the chorus."),
                    mcq("What fixed the timing problem?", ["The guitarist practiced the chorus alone with a metronome", "The whole band stopped playing the song forever", "The drummer played much louder than before"], "The guitarist practiced the chorus alone with a metronome", "After practicing the chorus with a metronome, the timing was fixed.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "metronome", definition: "A device that clicks at a steady beat to help musicians keep time.", exampleSentence: "The guitarist practiced with a metronome."),
                    VocabularyWord(word: "isolated", definition: "Separate or apart from everything else.", exampleSentence: "The timing problem was isolated to one section.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Comparing which instrument stays steady and which one rushes can help musicians find exactly where a timing problem starts.", explanation: "Pinpointing the exact section saves practice time compared to relearning an entire song.")
                ],
                creativePrompt: "Write two sentences about which part of the song was rushing and how the guitarist fixed it.",
                creativeResponseType: .shortText,
                storyEnding: "Milo's two clues turn a confusing off-sounding song into a quick, targeted fix.",
                readingSkill: "Use listening clues to explain a musical conclusion",
                reflectionPrompt: "Why might comparing two instruments help you find a problem faster than listening to the whole band at once?",
                hints: ["Look for which section sounded off", "Reread how the guitarist practiced"],
                commonMistakes: ["Assuming every musician made a mistake instead of pinpointing one"],
                successCriteria: ["Explains Milo's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "music.confident.timing-clues.conclusion",
                characterNames: ["Milo"]
            )
        }
    }

    private static func musicMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Drums",
                storyOpening: "Milo needs a careful count before practice starts.",
                missionPrompt: "Count the drums and compare the groups.",
                readingPassage: "Four small drums sit in a row. Two shakers rest beside them. Milo points and counts out loud.",
                problems: [
                    mcq("Milo sees 2 drums, then 2 more join. How many drums in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 shakers on the left and 3 drums on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Milo counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Milo can count the drums.")],
                knowledgeFacts: [KnowledgeFact(fact: "Musicians count beats carefully to stay together while playing.")],
                creativePrompt: "Draw 4 drums in a row.",
                storyEnding: "Milo's drum count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 shakers on the left and 3 drums on the right. Which side has more?",
                hints: ["Point to each drum", "Compare the two groups"],
                activityFingerprint: "music.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Shakers for the Band",
                storyOpening: "Milo sorts instruments before a busy practice.",
                missionPrompt: "Add and subtract to finish the band jobs.",
                readingPassage: "Milo sets out shakers for band practice. He checks how many shakers are ready and how many drumsticks still need sorting.",
                problems: [
                    mcq("Milo finds 6 shakers. Then he finds 3 more. How many shakers in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("An instrument box holds 10 drumsticks. Milo hands 4 drumsticks to bandmates. How many drumsticks are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Milo wants 8 songs on tonight's list. He has chosen 5 already. How many more songs does he need?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total shakers.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking instrument numbers helps a band practice run smoothly.")],
                creativePrompt: "Draw 9 shakers ready for practice.",
                storyEnding: "The band is ready for practice.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "An instrument box holds 10 drumsticks. Milo hands 4 drumsticks to bandmates. How many drumsticks are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "music.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Milo",
                pronoun: "he",
                items: [
                    ("music sheets", "in the folder"),
                    ("shakers", "in the rhythm bin"),
                    ("drumsticks", "on the drum shelf")
                ],
                packItem: "music sheets",
                purpose: "for the busy rehearsal"
            )
            return MathScene(
                title: "Groups in the Band Room",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Milo opens 3 packs of shakers with 4 shakers in each pack. How many shakers does he carry?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A drumstick is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten sheets.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the band has enough supplies.")],
                creativePrompt: "Draw 3 packs of shakers with 4 shakers in each pack.",
                storyEnding: "The band room is ready for rehearsal.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Milo opens 3 packs of shakers with 4 shakers in each pack. How many shakers does he carry?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "music.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Concert Day" : "Equal Shares of Shakers",
                storyOpening: "Milo plans supplies for a full day of the concert.",
                missionPrompt: multi ? "Solve each band problem." : "Solve each band problem carefully.",
                readingPassage: "Songbooks and shakers are shared with young musicians during the concert.",
                problems: [
                    mcq("Milo packs 3 crates with 8 songbooks in each crate. How many songbooks does he pack?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Milo shares 18 shakers among 3 young musicians equally. How many does each musician get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One drumstick is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "split", definition: "To divide into parts.", exampleSentence: "Split the songbooks into equal shares.")],
                knowledgeFacts: [KnowledgeFact(fact: "A beat is the steady pulse musicians count together.")],
                creativePrompt: "Draw the songbook crates.",
                storyEnding: "Every young musician gets a fair share. Great concert, Milo!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A tambourine case holds 4 shakers. Milo adds 2 more shakers. How many shakers are in the case now?",
                hints: mathHints(level),
                activityFingerprint: "music.math.advancing.songbooks"
            )
        }
    }

    // MARK: - Cooking (Chef Dara — kitchen steps, measuring, taste clues)

    private static func cookingReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Chef Dara Stirs the Soup",
                storyOpening: "Chef Dara stands at a warm stove. How will she fix the soup?",
                missionPrompt: "Check what Chef Dara adds to make the soup taste better.",
                readingPassage: "Chef Dara tastes the soup. It needs more flavor, so she stirs in carrots. She stirs in peas too. Now the soup smells yummy and ready to share.",
                questions: [
                    mcq("Why does Chef Dara stir in carrots?", ["The soup needs more flavor", "The pot is too full", "The stove turned off"], "The soup needs more flavor", "Chef Dara tastes the soup, and it needs more flavor, so she stirs in carrots."),
                    mcq("What does she stir in next?", ["Peas", "Salt", "Cold water"], "Peas", "She stirs in peas too."),
                    mcq("How does the soup smell after she adds the vegetables?", ["Yummy and ready to share", "Burned and smoky", "Still bland and watery"], "Yummy and ready to share", "Now the soup smells yummy and ready to share.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "stir", definition: "To mix something with a spoon.", exampleSentence: "Chef Dara stirs the soup."),
                    VocabularyWord(word: "ingredient", definition: "One item used to make a recipe.", exampleSentence: "Carrots are an ingredient in the soup.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Stirring soup helps mix all the ingredients so every bite tastes good.", explanation: "Without stirring, some parts of the soup could taste very different from others.")
                ],
                creativePrompt: "Draw Chef Dara stirring a big pot of soup.",
                creativeResponseType: .drawing,
                storyEnding: "The soup is ready, warm and full of yummy vegetables.",
                readingSkill: "Follow a simple cooking story",
                reflectionPrompt: "What did Chef Dara add to the soup?",
                hints: ["Find the word carrots", "Look for the word peas"],
                commonMistakes: ["Choosing an item Chef Dara did not add"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short cooking story"],
                activityFingerprint: "cooking.k.soup-stir.detail",
                characterNames: ["Chef Dara"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Chef Dara Follows a Recipe",
                storyOpening: "A recipe card sits propped against the flour jar in Chef Dara's kitchen.",
                missionPrompt: "Follow the baking steps. Check what Chef Dara measure, mix, and bake.",
                readingPassage: "Chef Dara reads the recipe card carefully before starting to bake. She measures exactly one cup of flour using a measuring cup and pours it into a big bowl. Next, she cracks two eggs into the bowl and mixes everything together with a wooden spoon. Chef Dara pours the batter into a pan and slides it into a warm oven. After twenty minutes, a golden loaf of bread comes out smelling delicious.",
                questions: [
                    mcq("What does Chef Dara measure first?", ["One cup of flour", "Two cups of sugar", "A pound of butter"], "One cup of flour", "She measures exactly one cup of flour."),
                    mcq("What does Chef Dara crack into the bowl?", ["Two eggs", "Two apples", "Two spoons"], "Two eggs", "She cracks two eggs into the bowl."),
                    mcq("What comes out of the oven after twenty minutes?", ["A golden loaf of bread", "A plate of cold soup", "A tray of raw dough"], "A golden loaf of bread", "A golden loaf of bread comes out smelling delicious.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "measure", definition: "To find the exact amount of something.", exampleSentence: "Chef Dara measures one cup of flour."),
                    VocabularyWord(word: "batter", definition: "A mixed liquid used to bake bread or cake.", exampleSentence: "Chef Dara pours the batter into a pan.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Bakers measure ingredients carefully because baking recipes need exact amounts to work correctly.", explanation: "Too much or too little flour can change how bread turns out.")
                ],
                creativePrompt: "Draw Chef Dara measuring flour for her bread recipe.",
                creativeResponseType: .drawing,
                storyEnding: "The golden loaf of bread cools on the counter, ready to be sliced and shared.",
                readingSkill: "Recall baking steps from a cooking passage",
                reflectionPrompt: "Why might measuring flour carefully matter when baking bread?",
                hints: ["Find the sentence about the measuring cup", "Look for the word batter"],
                commonMistakes: ["Mixing up the order of the baking steps"],
                successCriteria: ["Uses a baking-step detail from the story"],
                learningObjectives: ["Recall key details and sequence from a short passage"],
                activityFingerprint: "cooking.early.bread-recipe.detail",
                characterNames: ["Chef Dara"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Chef Dara Tastes as She Cooks",
                storyOpening: "A young helper asks Chef Dara why she keeps tasting the soup instead of only following the recipe.",
                missionPrompt: "Find the main idea about why chefs taste while cooking. Use Chef Dara's explanation.",
                readingPassage: "A young helper once asked Chef Dara why she kept dipping a spoon into the soup and tasting it again and again, even though she was following a written recipe. Chef Dara explained that recipes are a helpful starting point, but ingredients like tomatoes or onions can vary in sweetness or strength from one batch to another. Tasting as she cooks lets Chef Dara notice if the soup needs a little more salt, a touch more lemon, or a bit more time to simmer before the flavors blend together properly. She said that a chef who only follows a recipe without tasting might end up with a dish that is too bland or too salty, depending on the exact ingredients used that day. By tasting throughout the cooking process, Chef Dara can adjust the recipe in small ways to make sure the final dish always tastes just right.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Tasting while cooking helps a chef adjust a recipe to taste right", "Recipes always produce the exact same taste no matter what", "Tasting food while cooking is unnecessary and wastes time"], "Tasting while cooking helps a chef adjust a recipe to taste right", "Chef Dara explains that tasting lets her adjust the recipe as needed."),
                    mcq("Why might ingredients vary from one batch to another?", ["Things like tomatoes or onions can differ in sweetness or strength", "All vegetables always taste exactly the same", "Recipes never depend on ingredient quality"], "Things like tomatoes or onions can differ in sweetness or strength", "Ingredients like tomatoes or onions can vary in sweetness or strength."),
                    mcq("What might happen if a chef never tastes while cooking?", ["The dish could end up too bland or too salty", "The dish would always taste perfect", "The recipe would cook itself correctly"], "The dish could end up too bland or too salty", "Without tasting, a dish might turn out too bland or too salty.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "simmer", definition: "To cook gently at a low, steady heat.", exampleSentence: "The soup needs more time to simmer."),
                    VocabularyWord(word: "adjust", definition: "To change something slightly to make it better.", exampleSentence: "Chef Dara can adjust the recipe by tasting.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Chefs taste food throughout cooking because natural ingredients can vary in flavor from batch to batch.", explanation: "Tasting helps a chef adjust seasoning so the final dish tastes balanced.")
                ],
                creativePrompt: "Draw Chef Dara tasting the soup with a spoon and adding a pinch of salt.",
                creativeResponseType: .drawing,
                storyEnding: "The young helper learns that tasting throughout cooking, not just following the recipe, makes food taste its best.",
                readingSkill: "Identify the main idea in a cooking-technique passage",
                reflectionPrompt: "Why might two batches of the same soup need slightly different amounts of salt?",
                hints: ["Reread Chef Dara's explanation about ingredient variation", "Think about what happens without tasting"],
                commonMistakes: ["Thinking a recipe always guarantees the exact same taste"],
                successCriteria: ["States the taste-while-cooking main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction cooking passage"],
                activityFingerprint: "cooking.growing.taste-adjust.main-idea",
                characterNames: ["Chef Dara"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Why the Bread Didn't Rise",
                storyOpening: "A loaf of bread comes out flat and dense. Chef Dara has two clues to explain why.",
                missionPrompt: "Compare the kitchen clues. Check what Chef Dara conclude caused the flat bread.",
                readingPassage: """
                When a loaf of bread came out of the oven flat and dense instead of light and fluffy, Chef Dara did not immediately blame the recipe itself. She looked for two clues before deciding what had gone wrong: the yeast packet in the pantry showed an expiration date from several months earlier, and the dough had barely doubled in size during its rise, instead of nearly tripling as it usually did. Chef Dara reasoned that if the recipe's measurements had been wrong, the dough's texture would likely have looked different from the start, but the dough had felt and looked correct — it simply had not risen enough. Since old yeast loses its ability to make dough rise properly over time, the expired yeast paired with the under-risen dough pointed clearly to one cause. Chef Dara concluded that the yeast had lost its strength, not that the recipe or her technique was at fault. She bought a fresh packet of yeast, and her next loaf rose beautifully, confirming exactly what the two clues had suggested.
                """,
                questions: [
                    mcq("What did Chef Dara conclude caused the flat bread?", ["The yeast was expired and had lost its ability to rise", "The recipe's measurements were completely wrong", "The oven was not turned on at all"], "The yeast was expired and had lost its ability to rise", "Chef Dara concluded the expired yeast caused the flat bread."),
                    mcq("How much had the dough risen compared with usual?", ["It had barely doubled instead of nearly tripling", "It had tripled just as usual", "It had not been mixed at all"], "It had barely doubled instead of nearly tripling", "The dough had barely doubled in size instead of nearly tripling as it usually did."),
                    mcq("What confirmed Chef Dara's conclusion was correct?", ["A fresh packet of yeast made the next loaf rise beautifully", "The bread stayed flat no matter what she tried", "She stopped baking bread completely"], "A fresh packet of yeast made the next loaf rise beautifully", "The next loaf with fresh yeast rose beautifully, confirming her idea.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "yeast", definition: "A tiny living ingredient that makes bread dough rise.", exampleSentence: "The expired yeast could not make the dough rise."),
                    VocabularyWord(word: "expiration", definition: "The date after which a food ingredient may not work well anymore.", exampleSentence: "The yeast packet's expiration date had already passed.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Yeast is a living ingredient that loses its rising power over time, especially after its expiration date.", explanation: "Fresh yeast is important for bread dough to rise properly.")
                ],
                creativePrompt: "Write two sentences about why the first loaf stayed flat and what Chef Dara changed next.",
                creativeResponseType: .shortText,
                storyEnding: "Chef Dara's two clues turn a confusing flat loaf into a simple, fixable kitchen lesson.",
                readingSkill: "Use kitchen clues to explain a cooking conclusion",
                reflectionPrompt: "Why might checking an ingredient's freshness matter as much as following the recipe exactly?",
                hints: ["Look at the yeast packet's date", "Reread what happened with the next loaf"],
                commonMistakes: ["Assuming the recipe itself was wrong instead of checking the ingredients"],
                successCriteria: ["Explains Chef Dara's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "cooking.confident.yeast-clues.conclusion",
                characterNames: ["Chef Dara"]
            )
        }
    }

    private static func cookingMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Eggs",
                storyOpening: "Chef Dara needs a careful count before baking starts.",
                missionPrompt: "Count the eggs and compare the groups.",
                readingPassage: "Four eggs sit in a bowl. Two lemons rest beside them. Chef Dara points and counts out loud.",
                problems: [
                    mcq("Chef Dara sees 2 eggs, then 2 more join. How many eggs in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 lemons on the left and 3 eggs on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Chef Dara counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Chef Dara can count the eggs.")],
                knowledgeFacts: [KnowledgeFact(fact: "Chefs count ingredients carefully before starting any recipe.")],
                creativePrompt: "Draw 4 eggs in a bowl.",
                storyEnding: "Chef Dara's egg count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 lemons on the left and 3 eggs on the right. Which side has more?",
                hints: ["Point to each egg", "Compare the two groups"],
                activityFingerprint: "cooking.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Cups for the Recipe",
                storyOpening: "Chef Dara sorts supplies before a busy cooking day.",
                missionPrompt: "Add and subtract to finish the kitchen jobs.",
                readingPassage: "Chef Dara lines up measuring cups on the counter. She checks how many cups are clean and how many spoons still need washing.",
                problems: [
                    mcq("Chef Dara finds 6 measuring cups. Then she finds 3 more. How many measuring cups in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A drawer holds 10 wooden spoons. Chef Dara hands 4 spoons to helpers. How many spoons are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Chef Dara counted 8 recipe cards before prep. After handing some out, only 5 cards are left. How many cards did she hand out?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total measuring cups.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking supply numbers helps a kitchen run smoothly.")],
                creativePrompt: "Draw 9 measuring cups ready for cooking.",
                storyEnding: "The kitchen is ready for the cooking day.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A drawer holds 10 wooden spoons. Chef Dara hands 4 spoons to helpers. How many spoons are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "cooking.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Chef Dara",
                pronoun: "she",
                items: [
                    ("spoons", "in the utensil tray"),
                    ("cups", "in the drink tray"),
                    ("spice jars", "on the spice shelf")
                ],
                packItem: "spice jars",
                purpose: "for the busy cooking day"
            )
            return MathScene(
                title: "Groups in the Kitchen",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Chef Dara unpacks 3 packs with 4 measuring cups in each pack. How many measuring cups does she unpack?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A rolling pin is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten spice jars.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the kitchen has enough supplies.")],
                creativePrompt: "Draw 3 packs with 4 measuring cups in each pack.",
                storyEnding: "The kitchen is ready for the busy cooking day.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Chef Dara unpacks 3 packs with 4 measuring cups in each pack. How many measuring cups does she unpack?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "cooking.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Bake Sale Day" : "Equal Shares of Muffins",
                storyOpening: "Chef Dara plans supplies for a full day of the bake sale.",
                missionPrompt: multi ? "Solve each kitchen problem." : "Solve each kitchen problem carefully.",
                readingPassage: "Fresh muffins and cookies are shared with customers during the bake sale.",
                problems: [
                    mcq("Chef Dara bakes 3 trays of muffins with 8 muffins in each tray. How many muffins does she bake in all?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Chef Dara shares 18 cookies among 3 customers equally. How many does each customer get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One rolling pin is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "fair", definition: "The same amount for everyone.", exampleSentence: "A fair share of muffins is the same for each.")],
                knowledgeFacts: [KnowledgeFact(fact: "A recipe lists ingredients and the steps for making food.")],
                creativePrompt: "Draw the muffin trays.",
                storyEnding: "Every customer gets a fair share. Great bake sale, Chef Dara!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A mixing bowl holds 4 cups of batter. Chef Dara adds 2 more cups. How many cups are in the bowl now?",
                hints: mathHints(level),
                activityFingerprint: "cooking.math.advancing.muffins"
            )
        }
    }

    // MARK: - Nature (Ranger Wren — trail walks, observation, habitat clues)

    private static func natureReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Ranger Wren Finds a Leaf",
                storyOpening: "Leaves crunch under Ranger Wren's boots. Come gather trail treasures with her.",
                missionPrompt: "Find what treasures Ranger Wren gathers for class.",
                readingPassage: "Ranger Wren needs three trail treasures for tomorrow's nature class. She spots a leaf and picks it up, then finds a round pinecone nearby. A soft feather catches her eye next. She puts all three treasures in her bag for the class.",
                questions: [
                    mcq("Why does Ranger Wren pick up trail treasures?", ["She needs them for tomorrow's nature class", "She is cleaning the trail", "She lost her bag"], "She needs them for tomorrow's nature class", "Ranger Wren needs three trail treasures for tomorrow's nature class."),
                    mcq("What round item does she find?", ["A pinecone", "A stone step", "A tree stump"], "A pinecone", "Next, she finds a round pinecone."),
                    mcq("Where does she put the three treasures?", ["In her bag", "On the road", "In a pond"], "In her bag", "She puts all three treasures in her bag for the class.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "trail", definition: "A path through nature for walking.", exampleSentence: "Ranger Wren walks on a green trail."),
                    VocabularyWord(word: "pinecone", definition: "The hard, round part that grows on pine trees.", exampleSentence: "Ranger Wren finds a pinecone.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Pinecones hold the seeds that grow into new pine trees.", explanation: "Each pinecone can protect many tiny seeds inside it.")
                ],
                creativePrompt: "Draw the leaf, pinecone, and feather Ranger Wren found.",
                creativeResponseType: .drawing,
                storyEnding: "Ranger Wren's bag is full of treasures from the trail.",
                readingSkill: "Follow a simple nature story",
                reflectionPrompt: "What did Ranger Wren find on her walk?",
                hints: ["Find the word leaf", "Look for the word feather"],
                commonMistakes: ["Choosing an item Ranger Wren did not find"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short nature story"],
                activityFingerprint: "nature.k.trail-finds.detail",
                characterNames: ["Ranger Wren"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Ranger Wren Spots Animal Tracks",
                storyOpening: "Soft mud beside the creek holds a set of small footprints. Ranger Wren kneels close to look.",
                missionPrompt: "Check what the footprints tell Ranger Wren.",
                readingPassage: "Ranger Wren kneels beside the creek on the nature trail and studies small footprints pressed into the soft mud. The tracks have four toes and no claw marks, so she thinks a fox likely passed through recently. She measures the print with her fingers and writes the size in her notebook. Then she follows the tracks a short way until they disappear into tall grass near the trees.",
                questions: [
                    mcq("Where does Ranger Wren find the footprints?", ["In the soft mud beside the creek", "On top of a large rock", "Inside her backpack"], "In the soft mud beside the creek", "She studies footprints pressed into the soft mud beside the creek."),
                    mcq("What tells Ranger Wren a fox passed through?", ["Four toes and no claw marks", "A loud bark she heard", "A patch of orange fur"], "Four toes and no claw marks", "The tracks have four toes and no claw marks, suggesting a fox."),
                    mcq("What does Ranger Wren do with the print's size?", ["Writes it in her notebook", "Erases it from the mud", "Paints it a bright color"], "Writes it in her notebook", "She measures the print and writes the size in her notebook.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "tracks", definition: "Footprints left behind by an animal.", exampleSentence: "Ranger Wren studies the fox tracks."),
                    VocabularyWord(word: "notebook", definition: "A small book used for writing notes.", exampleSentence: "Ranger Wren writes the size in her notebook.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Animal tracks can show details like the number of toes. Those details help identify which animal passed by.", explanation: "Foxes typically leave four-toed tracks without visible claw marks.")
                ],
                creativePrompt: "Draw Ranger Wren studying the fox tracks in the mud.",
                creativeResponseType: .drawing,
                storyEnding: "The tracks disappear into the tall grass, leaving Ranger Wren curious about where the fox went next.",
                readingSkill: "Recall tracking details from a nature passage",
                reflectionPrompt: "What detail helped Ranger Wren guess the tracks belonged to a fox?",
                hints: ["Find the sentence about toes and claw marks", "Look for the word notebook"],
                commonMistakes: ["Skipping the detail about the number of toes"],
                successCriteria: ["Uses a tracking detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "nature.early.fox-tracks.detail",
                characterNames: ["Ranger Wren"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Old Trees Still Help the Forest",
                storyOpening: "A visitor stops beside an old snag and asks why the park leaves standing trees that no longer grow leaves.",
                missionPrompt: "Figure out why old snags still matter in Ranger Wren's park.",
                readingPassage: "A visitor once asked Ranger Wren why the park left so many old, dead trees standing instead of clearing them away to look neater. Ranger Wren explained that dead trees, sometimes called snags, are full of life even though they no longer grow leaves. Woodpeckers dig holes in the soft, rotting wood to build nests, and owls often use the hollow trunks as safe places to raise their young. Insects live inside the decaying bark and become important food for birds and small mammals. If the park removed every dead tree, many animals would lose their homes and food. Then fewer kinds of animals might live in the forest. Leaving dead trees standing, she said, helps keep the whole forest healthier and more alive.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Dead trees provide important homes and food for many forest animals", "Dead trees should always be removed to keep forests looking neat", "Dead trees have no real use in a forest ecosystem"], "Dead trees provide important homes and food for many forest animals", "Ranger Wren explains that dead trees provide homes and food for animals."),
                    mcq("What do owls often do with hollow tree trunks?", ["Use them as safe places to raise their young", "Avoid them completely out of fear", "Chew them into small pieces"], "Use them as safe places to raise their young", "Owls often use hollow trunks as safe places to raise their young."),
                    mcq("What might happen if the park removed every dead tree?", ["Many animals would lose their homes and food", "The forest would immediately grow more trees", "Nothing in the forest would change at all"], "Many animals would lose their homes and food", "Removing dead trees could cause many animals to lose homes and food.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "snag", definition: "A standing dead or dying tree, often full of wildlife.", exampleSentence: "Woodpeckers dig holes into snags to build nests."),
                    VocabularyWord(word: "decaying", definition: "Slowly breaking down or rotting over time.", exampleSentence: "Insects live inside the decaying bark.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Dead trees, called snags, provide homes for woodpeckers, owls, and insects, supporting the whole forest ecosystem.", explanation: "Removing dead trees can reduce the number of animal species living in a forest.")
                ],
                creativePrompt: "Draw a dead tree snag with a woodpecker hole and an owl inside it.",
                creativeResponseType: .drawing,
                storyEnding: "The visitor leaves understanding that a dead tree is still full of life for many forest animals.",
                readingSkill: "Identify the main idea in an ecosystem passage",
                reflectionPrompt: "Why might a forest with no dead trees have fewer kinds of animals?",
                hints: ["Reread Ranger Wren's explanation about snags", "Think about which animals use dead trees"],
                commonMistakes: ["Thinking dead trees serve no purpose in a forest"],
                successCriteria: ["States the dead-tree main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction ecology passage"],
                activityFingerprint: "nature.growing.dead-trees.main-idea",
                characterNames: ["Ranger Wren"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "The Case of the Missing Berries",
                storyOpening: "Overnight, a berry bush was stripped bare. Ranger Wren gathers two clues before she names the culprit.",
                missionPrompt: "Discover how Ranger Wren's trail clues lead to her conclusion.",
                readingPassage: """
                When Ranger Wren discovered a berry bush completely stripped of fruit overnight, she did not assume the biggest animal nearby was responsible. She looked for two clues before drawing a conclusion: the branches were bent downward rather than broken, and small piles of seeds mixed with berry skins were scattered on the ground beneath the bush. A large animal like a bear would likely have broken branches or left large tracks, but bent, unbroken branches suggested something lighter had climbed and fed there. The scattered seeds and skins matched the kind of mess raccoons typically leave after a nighttime feeding, rather than the larger, less selective damage a bear usually causes. Comparing both clues, Ranger Wren concluded that a family of raccoons, not a bear, had visited the bush during the night. A trail camera she set up the following evening confirmed her conclusion, capturing clear footage of raccoons climbing the same bush. Later she told a new trail volunteer that comparing the type of damage with the leftover evidence often reveals an animal's identity more reliably than assuming the largest possible culprit.
                """,
                questions: [
                    mcq("What did Ranger Wren conclude was responsible for the stripped bush?", ["A family of raccoons feeding overnight", "A large bear passing through", "No animal at all — the wind caused it"], "A family of raccoons feeding overnight", "Ranger Wren concluded raccoons, not a bear, visited the bush."),
                    mcq("What did the bent, unbroken branches suggest?", ["Something lighter had climbed and fed there", "A bear had snapped the bush apart", "The wind had stripped every berry"], "Something lighter had climbed and fed there", "Bent, unbroken branches suggested something lighter had climbed and fed there."),
                    mcq("What confirmed Ranger Wren's conclusion?", ["A trail camera captured footage of raccoons climbing the bush", "The berries grew back overnight", "A bear was spotted far away from the bush"], "A trail camera captured footage of raccoons climbing the bush", "The trail camera confirmed raccoons had visited the bush.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "evidence", definition: "Facts or signs that help prove something is true.", exampleSentence: "The scattered seeds were evidence of a raccoon's visit."),
                    VocabularyWord(word: "culprit", definition: "The one responsible for causing something.", exampleSentence: "Ranger Wren looked for clues to find the real culprit.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Comparing the type of damage left behind with scattered evidence can help identify which animal visited an area.", explanation: "Different animals leave distinct clues, like bent versus broken branches.")
                ],
                creativePrompt: "Write two sentences about why Ranger Wren blamed raccoons, not a bear, and how she proved it.",
                creativeResponseType: .shortText,
                storyEnding: "Ranger Wren's two clues turn a nighttime mystery into a confirmed raccoon visit.",
                readingSkill: "Use trail clues to explain a naturalist's conclusion",
                reflectionPrompt: "Why might assuming the largest animal is always responsible lead to a wrong conclusion?",
                hints: ["Look at how the branches were bent", "Reread what the trail camera showed"],
                commonMistakes: ["Assuming the biggest possible animal caused the damage without checking evidence"],
                successCriteria: ["Explains Ranger Wren's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "nature.confident.raccoon-clues.conclusion",
                characterNames: ["Ranger Wren"]
            )
        }
    }

    private static func natureMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Pinecones",
                storyOpening: "Ranger Wren needs a careful count on the trail.",
                missionPrompt: "Count the pinecones and compare the groups.",
                readingPassage: "Four pinecones sit on a log. Two feathers rest beside them. Ranger Wren points and counts out loud.",
                problems: [
                    mcq("Ranger Wren sees 2 pinecones, then 2 more join. How many pinecones in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 feathers on the left and 3 pinecones on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Ranger Wren counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Ranger Wren can count the pinecones.")],
                knowledgeFacts: [KnowledgeFact(fact: "Rangers count plants and animal signs carefully during every trail walk.")],
                creativePrompt: "Draw 4 pinecones on a log.",
                storyEnding: "Ranger Wren's pinecone count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 feathers on the left and 3 pinecones on the right. Which side has more?",
                hints: ["Point to each pinecone", "Compare the two groups"],
                activityFingerprint: "nature.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Leaves for the Nature Journal",
                storyOpening: "Ranger Wren sorts finds before a busy trail day.",
                missionPrompt: "Add and subtract to finish the trail jobs.",
                readingPassage: "Ranger Wren sorts leaves into her collecting bag. She checks how many leaves she has and how many feathers still need labeling.",
                problems: [
                    mcq("Ranger Wren finds 6 leaves. Then she finds 3 more. How many leaves in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A collecting bag holds 10 feathers. Ranger Wren hands 4 feathers to young hikers. How many feathers are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Ranger Wren started with 8 acorns on the trail. Then 5 acorns fall through a hole in her bag. How many acorns does she have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total leaves.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking how many finds you have helps organize a nature journal.")],
                creativePrompt: "Draw 9 leaves ready for the nature journal.",
                storyEnding: "The nature journal is ready for the trail day.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A collecting bag holds 10 feathers. Ranger Wren hands 4 feathers to young hikers. How many feathers are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "nature.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Ranger Wren",
                pronoun: "she",
                items: [
                    ("acorns", "in the seed pouch"),
                    ("leaves", "in the leaf press"),
                    ("feathers", "on the nature board")
                ],
                packItem: "acorns",
                purpose: "for the busy hike"
            )
            return MathScene(
                title: "Groups on the Trail",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Ranger Wren fills 3 trays of leaves with 4 leaves in each tray. How many leaves does she save?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A fallen branch is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten acorns.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check how many nature finds you have collected.")],
                creativePrompt: "Draw 3 trays of leaves with 4 leaves in each tray.",
                storyEnding: "The trail bag is ready for the busy hike.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Ranger Wren fills 3 trays of leaves with 4 leaves in each tray. How many leaves does she save?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "nature.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Trail Day" : "Seeds on the Trail",
                storyOpening: "Ranger Wren plans supplies for a full day on the trail.",
                missionPrompt: multi ? "Solve each trail problem." : "Solve each trail problem carefully.",
                readingPassage: "Pinecones and trail maps are shared with young hikers during the trail day.",
                problems: [
                    mcq("Ranger Wren gathers 3 baskets with 8 pinecones in each basket. How many pinecones in all?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Ranger Wren shares 18 pinecones among 3 hiking groups equally. How many does each group get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One branch is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "difference", definition: "How much more one number is than another.", exampleSentence: "The difference tells how much longer the first branch is.")],
                knowledgeFacts: [KnowledgeFact(fact: "A trail map shows the paths hikers can follow.")],
                creativePrompt: "Draw the pinecone baskets.",
                storyEnding: "Every hiking group gets a fair share. Great hike, Ranger Wren!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water bottle holder holds 4 bottles. Ranger Wren adds 2 more bottles. How many bottles are in the holder now?",
                hints: mathHints(level),
                activityFingerprint: "nature.math.advancing.seed-packets"
            )
        }
    }

    // MARK: - Bugs (Sam — magnifying glass, insect parts, habitat clues)

    private static func bugsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Sam Finds a Ladybug",
                storyOpening: "Sam holds a magnifying glass in the garden. Will you help him spot a tiny bug?",
                missionPrompt: "Check what Sam sees on the leaf.",
                readingPassage: "Sam searches the garden with his bug notebook ready. A flash of red catches his eye — a ladybug! Its red wings and black spots warn other animals to stay away. Sam watches it crawl safely across a leaf.",
                questions: [
                    mcq("What catches Sam's eye in the garden?", ["A flash of red", "A loud buzzing", "A falling leaf"], "A flash of red", "A flash of red catches his eye — a ladybug!"),
                    mcq("What do the ladybug's colors do?", ["Warn other animals to stay away", "Help it fly faster", "Keep it warm at night"], "Warn other animals to stay away", "Its red wings and black spots warn other animals to stay away."),
                    mcq("Where does the ladybug crawl safely?", ["Across a leaf", "Into a pond", "Under a cold stone"], "Across a leaf", "Sam watches it crawl safely across a leaf.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "ladybug", definition: "A small round bug with spots.", exampleSentence: "Sam finds a ladybug on a leaf."),
                    VocabularyWord(word: "spot", definition: "A small round mark.", exampleSentence: "The ladybug has black spots.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Ladybugs use their bright red color and black spots to warn other animals that they taste bad.", explanation: "This bright coloring helps keep ladybugs safe from being eaten.")
                ],
                creativePrompt: "Draw the red ladybug with black spots crawling on a leaf.",
                creativeResponseType: .drawing,
                storyEnding: "The ladybug crawls off the leaf and flies away into the garden.",
                readingSkill: "Follow a simple bug story",
                reflectionPrompt: "What did the ladybug look like?",
                hints: ["Find the word red", "Look for the word spots"],
                commonMistakes: ["Choosing a color the ladybug did not have"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short bug story"],
                activityFingerprint: "bugs.k.ladybug-find.detail",
                characterNames: ["Sam"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Sam Watches an Ant Trail",
                storyOpening: "A long line of tiny ants marches across the sidewalk near Sam's shoes.",
                missionPrompt: "Discover how the ants find their way.",
                readingPassage: "Sam crouches down to watch a long line of ants marching in a straight trail. Each ant carries a small crumb or leaf piece back toward a hole in the ground. The ants never bump into each other, even though they move quickly in two directions at once. Sam learns that ants leave an invisible scent trail so other ants can follow the same safe path. One by one, the line of ants disappears into the small hole.",
                questions: [
                    mcq("What does each ant carry?", ["A small crumb or leaf piece", "A tiny rock", "Another ant"], "A small crumb or leaf piece", "Each ant carries a small crumb or leaf piece."),
                    mcq("What does Sam notice about the ants?", ["They do not bump into each other", "They stop moving completely", "They move in only one direction"], "They do not bump into each other", "Sam notices the ants never bump into each other."),
                    mcq("How do other ants know which path to follow?", ["A scent trail left by other ants", "A drawn map on the ground", "A loud buzzing sound"], "A scent trail left by other ants", "Ants leave a scent trail so others can follow.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "trail", definition: "A path that something follows.", exampleSentence: "The ants march along a trail."),
                    VocabularyWord(word: "scent", definition: "A smell that can be left behind or followed.", exampleSentence: "Ants leave a scent trail for others to follow.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Ants leave invisible scent trails made of chemicals so other ants can find the same path.", explanation: "This helps a whole colony of ants work together efficiently.")
                ],
                creativePrompt: "Draw the line of ants carrying crumbs back to their hole.",
                creativeResponseType: .drawing,
                storyEnding: "The last ant disappears into the hole, leaving the sidewalk trail quiet again.",
                readingSkill: "Recall trail details from a bug passage",
                reflectionPrompt: "Why might a scent trail help ants avoid getting lost?",
                hints: ["Find the sentence about bumping into each other", "Look for the word scent"],
                commonMistakes: ["Skipping the detail about the scent trail"],
                successCriteria: ["Uses a trail detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "bugs.early.ant-trail.detail",
                characterNames: ["Sam"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Sam Looks for Bugs Under Logs",
                storyOpening: "A younger cousin wonders why Sam always flips old logs when he looks for bugs.",
                missionPrompt: "Figure out why so many bugs live under logs.",
                readingPassage: "A younger cousin once asked Sam why he always flipped over old, rotting logs whenever he went looking for interesting bugs. Sam explained that the underside of a log stays dark, cool, and damp — exactly the conditions many bugs need to survive. Beetles, worms, and centipedes can dry out quickly in bright, hot sunlight, so they hide under logs during the day where moisture stays trapped in the soil. The rotting wood itself also provides food for some insects, since decaying wood is softer and easier to chew through than living trees. By checking under logs, Sam almost always finds several different kinds of bugs living together, taking advantage of the shade, moisture, and food all in one spot.",
                questions: [
                    mcq("What is the main idea of this passage?", ["The underside of logs provides shade, moisture, and food that many bugs need", "Bugs prefer bright, hot sunlight over shady spots", "Logs have no effect on where bugs choose to live"], "The underside of logs provides shade, moisture, and food that many bugs need", "Sam explains that logs provide shade, moisture, and food bugs need."),
                    mcq("Why might bugs dry out in bright sunlight?", ["Many bugs need dark, cool, damp conditions to survive", "Bugs actually prefer very hot, dry places", "Sunlight makes bugs grow bigger and stronger"], "Many bugs need dark, cool, damp conditions to survive", "Many bugs need dark, cool, damp conditions and can dry out in sunlight."),
                    mcq("Why does rotting wood provide food for some insects?", ["It is softer and easier to chew through than living trees", "It tastes sweeter than fresh wood", "It glows and attracts insects at night"], "It is softer and easier to chew through than living trees", "Decaying wood is softer and easier to chew through than living trees.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "damp", definition: "Slightly wet.", exampleSentence: "The soil under the log stays damp."),
                    VocabularyWord(word: "decaying", definition: "Slowly breaking down or rotting.", exampleSentence: "Decaying wood is softer for insects to chew.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Rotting logs provide bugs with shade, moisture, and food all in one place.", explanation: "This is why flipping over a log often reveals many different kinds of insects.")
                ],
                creativePrompt: "Draw the underside of a log with three different bugs living there.",
                creativeResponseType: .drawing,
                storyEnding: "Sam's cousin learns that a rotting log is like a tiny bug apartment building, full of shade, moisture, and food.",
                readingSkill: "Identify the main idea in a habitat passage",
                reflectionPrompt: "Why might several different bugs choose to live under the very same log?",
                hints: ["Reread Sam's explanation about dark, cool, damp conditions", "Think about what rotting wood provides"],
                commonMistakes: ["Thinking bugs prefer sunny, dry places over shaded ones"],
                successCriteria: ["States the log-habitat main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction science passage"],
                activityFingerprint: "bugs.growing.log-habitat.main-idea",
                characterNames: ["Sam"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Who Has Been Eating the Leaves?",
                storyOpening: "Ragged holes appear in the garden's leaves overnight. Sam gathers two clues before he names the culprit.",
                missionPrompt: "Discover how Sam's garden clues lead to his conclusion.",
                readingPassage: """
                When several leaves in the garden turned up with ragged holes chewed through them, Sam did not assume the biggest bug he could find was responsible. He examined two clues before drawing a conclusion: the holes were located mostly along the leaf edges rather than scattered randomly across the surface, and small piles of tiny dark droppings sat on the ground directly beneath the damaged leaves. Caterpillars typically chew inward from a leaf's edge as they eat, leaving a ragged border, while beetles that chew random holes in the middle of leaves usually leave differently shaped droppings. The edge-focused holes matched caterpillar feeding patterns almost exactly, and the dark droppings beneath the leaves were consistent with caterpillar frass rather than beetle waste. Comparing both clues, Sam concluded that caterpillars, not beetles, were responsible for the damage. A careful search of the plant's underside confirmed his conclusion, revealing three green caterpillars resting on the stems. Sam later explained to a friend that comparing the pattern of damage with the leftover evidence on the ground often reveals an insect's identity more reliably than guessing based on which bug seems most likely.
                """,
                questions: [
                    mcq("What did Sam conclude was eating the leaves?", ["Caterpillars, based on the edge damage and droppings", "Large beetles chewing random holes", "Birds pecking at the leaves"], "Caterpillars, based on the edge damage and droppings", "Sam concluded caterpillars caused the damage."),
                    mcq("Where were most of the holes in the leaves?", ["Along the leaf edges", "Only in the very center", "Scattered randomly across every leaf"], "Along the leaf edges", "The holes were located mostly along the leaf edges."),
                    mcq("What confirmed Sam's conclusion?", ["A search revealed three green caterpillars on the stems", "The leaves grew back overnight", "A large beetle was found nearby"], "A search revealed three green caterpillars on the stems", "The search confirmed caterpillars were on the plant's stems.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "frass", definition: "The waste droppings left behind by insects like caterpillars.", exampleSentence: "The dark frass beneath the leaves matched caterpillar feeding."),
                    VocabularyWord(word: "pattern", definition: "A repeated or noticeable arrangement of something.", exampleSentence: "The pattern of chewed holes matched a caterpillar's feeding style.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Different insects leave different feeding patterns on leaves. Those patterns can help identify which bug caused the damage.", explanation: "Comparing damage patterns with leftover evidence like droppings narrows down the likely culprit.")
                ],
                creativePrompt: "Write two sentences about why Sam blamed caterpillars and what he found under the leaves.",
                creativeResponseType: .shortText,
                storyEnding: "Sam's two clues turn a chewed-up mystery into a confirmed caterpillar discovery.",
                readingSkill: "Use garden clues to explain an insect conclusion",
                reflectionPrompt: "Why might checking leftover droppings be as useful as checking the damage itself?",
                hints: ["Look at where the holes were chewed", "Reread what Sam found on the stems"],
                commonMistakes: ["Assuming the biggest bug found nearby caused the damage"],
                successCriteria: ["Explains Sam's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "bugs.confident.caterpillar-clues.conclusion",
                characterNames: ["Sam"]
            )
        }
    }

    private static func bugsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Ladybugs",
                storyOpening: "Sam needs a careful count in the garden.",
                missionPrompt: "Count the ladybugs and compare the groups.",
                readingPassage: "Four ladybugs sit on a leaf. Two ants march beside them. Sam points and counts out loud.",
                problems: [
                    mcq("Sam sees 2 ladybugs, then 2 more join. How many ladybugs in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 ants on the left and 3 ladybugs on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Sam counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Sam can count the ladybugs.")],
                knowledgeFacts: [KnowledgeFact(fact: "Bug watchers count insects carefully to learn how many live in one place.")],
                creativePrompt: "Draw 4 ladybugs on a leaf.",
                storyEnding: "Sam's ladybug count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 ants on the left and 3 ladybugs on the right. Which side has more?",
                hints: ["Point to each ladybug", "Compare the two groups"],
                activityFingerprint: "bugs.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Ants for the Bug Journal",
                storyOpening: "Sam sorts his bug notes before a busy garden day.",
                missionPrompt: "Add and subtract to finish the bug-watching jobs.",
                readingPassage: "Sam counts ants marching past his notebook. He checks how many ants he has counted and how many beetles are still hiding.",
                problems: [
                    mcq("Sam finds 6 ants. Then he finds 3 more. How many ants in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A jar holds 10 beetles. Sam lets 4 beetles go back into the garden. How many beetles are left in the jar?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Sam spotted 8 ladybugs. Then 5 flew away. How many ladybugs are left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total ants.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking how many bugs you find helps keep a good bug journal.")],
                creativePrompt: "Draw 9 ants ready for the bug journal.",
                storyEnding: "The bug journal is ready for the garden day.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A jar holds 10 beetles. Sam lets 4 beetles go back into the garden. How many beetles are left in the jar?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "bugs.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Sam",
                pronoun: "he",
                items: [
                    ("bug jars", "in the jar crate"),
                    ("magnifying glasses", "in the tool pouch"),
                    ("nets", "on the trail hook")
                ],
                packItem: "bug jars",
                purpose: "for the busy exploring day"
            )
            return MathScene(
                title: "Groups in the Garden",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Sam sets out 3 equal groups of 4 magnifying glasses for bug club. How many magnifying glasses is that?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A butterfly net handle is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten bug jars.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check insect collections.")],
                creativePrompt: "Draw 3 equal groups of 4 magnifying glasses.",
                storyEnding: "The exploring kit is ready for the busy day.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Sam sets out 3 equal groups of 4 magnifying glasses for bug club. How many magnifying glasses is that?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "bugs.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Bug Hunt Day" : "Equal Shares of Bug Jars",
                storyOpening: "Sam plans supplies for a full day of the bug hunt.",
                missionPrompt: multi ? "Solve each bug-watching problem." : "Solve each bug-watching problem carefully.",
                readingPassage: "Magnifying glasses and bug jars are shared with young bug watchers during the bug hunt.",
                problems: [
                    mcq("Sam packs 3 boxes with 8 magnifying glasses in each box. How many glasses does he pack?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Sam shares 18 bug jars among 3 young bug watchers equally. How many does each watcher get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One butterfly net handle is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "each", definition: "For every one group.", exampleSentence: "Each box holds the same number of glasses.")],
                knowledgeFacts: [KnowledgeFact(fact: "A magnifying glass makes tiny insect parts look bigger.")],
                creativePrompt: "Draw the magnifying glass packs.",
                storyEnding: "Every bug watcher gets a fair share. Great hunt, Sam!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A bug jar holds 4 ladybugs. Sam adds 2 more ladybugs he found. How many ladybugs are in the jar now?",
                hints: mathHints(level),
                activityFingerprint: "bugs.math.advancing.magnifying-glasses"
            )
        }
    }

    // MARK: - Volcanoes (Dr. Nolan — layers, pressure, eruption clues)

    private static func volcanoesReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Dr. Nolan Studies a Volcano",
                storyOpening: "Dr. Nolan stands near a tall mountain. Will you watch the volcano with her?",
                missionPrompt: "Check what Dr. Nolan sees at the mountain.",
                readingPassage: "Dr. Nolan sees smoke rising high from the mountain. Hot rock glows red near the top. The mountain rumbles under her boots.",
                questions: [
                    mcq("What rises high?", ["Smoke", "A leaf", "A bird"], "Smoke", "The smoke rises high."),
                    mcq("What color is the hot rock?", ["Red", "Blue", "Green"], "Red", "Hot rock glows red."),
                    mcq("What does the mountain do?", ["Rumbles", "Sings", "Sleeps"], "Rumbles", "The mountain rumbles.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "volcano", definition: "A mountain that can shoot out hot rock and smoke.", exampleSentence: "Dr. Nolan studies the volcano."),
                    VocabularyWord(word: "rumble", definition: "A deep, low sound like distant thunder.", exampleSentence: "The mountain rumbles.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Volcanoes rumble because hot, melted rock and gas are moving deep underground.", explanation: "The rumbling sound is a sign that pressure is building inside the volcano.")
                ],
                creativePrompt: "Draw the volcano with smoke and glowing red rock.",
                creativeResponseType: .drawing,
                storyEnding: "Dr. Nolan watches carefully as the volcano rumbles from a safe distance.",
                readingSkill: "Follow a simple volcano story",
                reflectionPrompt: "What did Dr. Nolan see at the volcano?",
                hints: ["Find the word smoke", "Look for the word rumbles"],
                commonMistakes: ["Choosing a color the rock was not"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short volcano story"],
                activityFingerprint: "volcanoes.k.mountain-sight.detail",
                characterNames: ["Dr. Nolan"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Dr. Nolan Checks the Volcano's Vents",
                storyOpening: "Steam hisses out of small cracks near the top of the volcano.",
                missionPrompt: "Check what Dr. Nolan learns from the vents.",
                readingPassage: "Dr. Nolan walks carefully near small cracks called vents, where steam and gas escape from deep inside the volcano. She holds a special tool that measures the temperature of the gas coming out. Warmer gas can mean that melted rock is moving closer to the surface. Every day she writes the temperature in her notebook. By comparing the numbers, she can tell if the volcano is becoming more active over time.",
                questions: [
                    mcq("What escapes from the vents?", ["Steam and gas", "Cold water", "Loud music"], "Steam and gas", "Steam and gas escape from the vents."),
                    mcq("What does Dr. Nolan's tool measure?", ["The temperature of the gas", "The color of the rocks", "The height of the mountain"], "The temperature of the gas", "She holds a tool that measures the temperature of the gas."),
                    mcq("What can warmer gas mean?", ["Melted rock may be moving closer to the surface", "The volcano has stopped forever", "Nothing important is happening"], "Melted rock may be moving closer to the surface", "Warmer gas can mean melted rock is moving closer to the surface.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "vent", definition: "A small opening where gas or steam escapes.", exampleSentence: "Steam escapes from the volcano's vents."),
                    VocabularyWord(word: "temperature", definition: "A measurement of how hot or cold something is.", exampleSentence: "Dr. Nolan measures the gas temperature.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Scientists measure the temperature of gas escaping from volcanic vents to help predict eruptions.", explanation: "Rising gas temperature can be an early warning sign of volcanic activity.")
                ],
                creativePrompt: "Draw Dr. Nolan measuring the temperature at a volcano's vent.",
                creativeResponseType: .drawing,
                storyEnding: "Dr. Nolan closes her notebook, ready to compare today's numbers with yesterday's.",
                readingSkill: "Recall vent-checking details from a volcano passage",
                reflectionPrompt: "Why might Dr. Nolan write down the temperature every single day?",
                hints: ["Find the sentence about the tool", "Look for the word vent"],
                commonMistakes: ["Skipping the detail about writing numbers daily"],
                successCriteria: ["Uses a vent-checking detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "volcanoes.early.vent-check.detail",
                characterNames: ["Dr. Nolan"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Dr. Nolan Watches for Small Earthquakes",
                storyOpening: "A student asks why tiny earthquakes matter when studying a volcano.",
                missionPrompt: "Figure out why Dr. Nolan watches for small earthquakes.",
                readingPassage: "A student once asked Dr. Nolan why she paid so much attention to tiny earthquakes that people could not even feel, when studying whether a volcano might erupt soon. Dr. Nolan explained that as melted rock, called magma, pushes upward through cracks in a volcano, it can crack the surrounding rock and cause small tremors. These tiny earthquakes are often too small for people to notice, but sensitive instruments can detect them clearly. When the number of these small earthquakes increases day after day, it often means magma is actively moving closer to the surface. Scientists combine this earthquake data with other clues, like gas temperature and ground swelling, to make a more complete and accurate prediction about when a volcano might erupt.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Small, undetectable earthquakes can signal that magma is moving toward the surface", "Small earthquakes have no connection to volcanic activity at all", "Only large earthquakes matter when studying volcanoes"], "Small, undetectable earthquakes can signal that magma is moving toward the surface", "Dr. Nolan explains that small earthquakes can signal magma movement."),
                    mcq("What causes the tiny earthquakes near a volcano?", ["Magma pushing upward and cracking surrounding rock", "Wind blowing across the mountain", "Rain falling on the volcano's surface"], "Magma pushing upward and cracking surrounding rock", "Magma pushing upward can crack rock and cause small tremors."),
                    mcq("What do scientists combine with earthquake data to predict eruptions?", ["Gas temperature and ground swelling", "The color of the sky", "The number of tourists visiting"], "Gas temperature and ground swelling", "Scientists combine earthquake data with gas temperature and ground swelling.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "magma", definition: "Melted rock found beneath the Earth's surface.", exampleSentence: "Magma pushes upward through cracks in the volcano."),
                    VocabularyWord(word: "tremor", definition: "A small shaking or vibration of the ground.", exampleSentence: "Tiny tremors can signal magma movement.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Scientists track tiny, often unnoticeable earthquakes to help predict when a volcano might erupt.", explanation: "An increase in small earthquakes can mean magma is moving toward the surface.")
                ],
                creativePrompt: "Draw a cross-section of a volcano showing magma moving upward and cracking rock.",
                creativeResponseType: .drawing,
                storyEnding: "The student learns that even earthquakes too small to feel can be an important clue for volcano scientists.",
                readingSkill: "Identify the main idea in a volcano-science passage",
                reflectionPrompt: "Why might scientists want more than one clue before predicting an eruption?",
                hints: ["Reread Dr. Nolan's explanation about magma and tremors", "Think about the other clues mentioned"],
                commonMistakes: ["Thinking only large, noticeable earthquakes matter for volcano science"],
                successCriteria: ["States the small-earthquake main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction earth-science passage"],
                activityFingerprint: "volcanoes.growing.small-earthquakes.main-idea",
                characterNames: ["Dr. Nolan"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Two Clues Behind Dr. Nolan's Warning",
                storyOpening: "Unusual readings flash on Dr. Nolan's instruments. She studies two clues before she issues a warning.",
                missionPrompt: "Discover how Dr. Nolan's monitoring clues lead to her warning.",
                readingPassage: """
                When instruments near a long-quiet volcano suddenly showed unusual readings, Dr. Nolan did not issue an eruption warning based on a single piece of data. She compared two specific clues before making her decision: the number of small earthquakes detected each day had tripled over the past week, and ground sensors showed the volcano's surface had swelled outward by several centimeters, indicating that something was pushing up from below. If only the earthquakes had increased without any ground swelling, the activity might simply be settling rock with no real danger of eruption. Ground swelling paired with a sharp rise in small earthquakes, however, strongly suggested that magma was actively pushing toward the surface — a combination she had seen before earlier eruptions at similar volcanoes. Comparing both clues, Dr. Nolan concluded that the volcano was showing genuine signs of an approaching eruption, not simply random settling activity. She issued a cautious warning to nearby communities, and three weeks later the volcano erupted with small amounts of ash, confirming that her two-clue analysis had accurately predicted the danger.
                """,
                questions: [
                    mcq("What did Dr. Nolan conclude from the unusual readings?", ["The volcano was showing genuine signs of an approaching eruption", "The volcano was completely safe with no activity", "The earthquakes were unrelated to the volcano entirely"], "The volcano was showing genuine signs of an approaching eruption", "Dr. Nolan concluded the volcano was truly approaching eruption."),
                    mcq("What had happened to the small earthquakes over the past week?", ["Their number had tripled", "They had stopped completely", "They happened only at night"], "Their number had tripled", "The number of small earthquakes detected each day had tripled over the past week."),
                    mcq("What confirmed Dr. Nolan's conclusion was correct?", ["The volcano erupted with ash three weeks later", "The volcano stayed completely silent forever", "The earthquakes stopped completely the next day"], "The volcano erupted with ash three weeks later", "The volcano erupted three weeks later, confirming her prediction.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "swelled", definition: "Grew larger or expanded outward.", exampleSentence: "The ground swelled outward by several centimeters."),
                    VocabularyWord(word: "analysis", definition: "A careful study of information to understand something.", exampleSentence: "Dr. Nolan's two-clue analysis predicted the eruption.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Scientists compare earthquake activity with ground swelling to more accurately predict volcanic eruptions.", explanation: "Combining more than one clue reduces the chance of a false warning.")
                ],
                creativePrompt: "Write two sentences about why Dr. Nolan warned nearby communities and what happened three weeks later.",
                creativeResponseType: .shortText,
                storyEnding: "Dr. Nolan's comparison of two clues turns uncertain readings into an accurate, life-saving warning.",
                readingSkill: "Use monitoring clues to explain a scientific conclusion",
                reflectionPrompt: "Why might relying on only one clue have led to a less accurate warning?",
                hints: ["Look at how the earthquakes changed", "Reread what happened three weeks later"],
                commonMistakes: ["Assuming earthquakes alone always mean an eruption is coming"],
                successCriteria: ["Explains Dr. Nolan's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "volcanoes.confident.eruption-clues.conclusion",
                characterNames: ["Dr. Nolan"]
            )
        }
    }

    private static func volcanoesMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Rocks",
                storyOpening: "Dr. Nolan needs a careful count near the volcano.",
                missionPrompt: "Count the rocks and compare the groups.",
                readingPassage: "Four rocks sit near the volcano. Two sensors rest beside them. Dr. Nolan points and counts out loud.",
                problems: [
                    mcq("Dr. Nolan sees 2 rocks, then 2 more join. How many rocks in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 sensors on the left and 3 rocks on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Dr. Nolan counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Dr. Nolan can count the rocks.")],
                knowledgeFacts: [KnowledgeFact(fact: "Volcano scientists count and label rock samples carefully during every visit.")],
                creativePrompt: "Draw 4 rocks near the volcano.",
                storyEnding: "Dr. Nolan's rock count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 sensors on the left and 3 rocks on the right. Which side has more?",
                hints: ["Point to each rock", "Compare the two groups"],
                activityFingerprint: "volcanoes.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Sensors for the Volcano",
                storyOpening: "Dr. Nolan sorts equipment before a busy monitoring day.",
                missionPrompt: "Add and subtract to finish the monitoring jobs.",
                readingPassage: "Dr. Nolan lines up sensors near the crater rim. He checks how many sensors are working and how many rock samples still need labeling.",
                problems: [
                    mcq("Dr. Nolan finds 6 sensors. Then she finds 3 more. How many sensors in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("An equipment box holds 10 rock samples. Dr. Nolan gives 4 samples to another scientist. How many samples are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Dr. Nolan recorded 8 temperature readings. A colleague recorded only 5. How many more readings did Dr. Nolan take?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total sensors.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking equipment numbers helps a monitoring day run smoothly.")],
                creativePrompt: "Draw 9 sensors ready for monitoring.",
                storyEnding: "The monitoring station is ready for the day.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "An equipment box holds 10 rock samples. Dr. Nolan gives 4 samples to another scientist. How many samples are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "volcanoes.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Dr. Nolan",
                pronoun: "she",
                items: [
                    ("rock samples", "in the sample box"),
                    ("sensors", "in the sensor tray"),
                    ("notebooks", "on the lab desk")
                ],
                packItem: "rock samples",
                purpose: "for the busy research day"
            )
            return MathScene(
                title: "Groups at the Monitoring Station",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Dr. Nolan loads 3 trays of sensors with 4 sensors in each tray. How many sensors are loaded?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A crack in the volcano's slope is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten rock samples.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the monitoring station has enough supplies.")],
                creativePrompt: "Draw 3 trays of sensors with 4 sensors in each tray.",
                storyEnding: "The monitoring station is ready for the busy research day.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Dr. Nolan loads 3 trays of sensors with 4 sensors in each tray. How many sensors are loaded?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "volcanoes.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Volcano Research Day" : "Equal Shares of Data Sheets",
                storyOpening: "Dr. Nolan plans supplies for a full day of volcano research.",
                missionPrompt: multi ? "Solve each research problem." : "Solve each research problem carefully.",
                readingPassage: "Rock samples and data sheets are shared with the research team during the study.",
                problems: [
                    mcq("Dr. Nolan loads 3 crates with 8 rock samples in each crate. How many samples does she load?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Dr. Nolan shares 18 data sheets among 3 research teams equally. How many does each team get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One crack in the volcano's slope is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "share", definition: "To split into equal parts.", exampleSentence: "Share the sensors equally.")],
                knowledgeFacts: [KnowledgeFact(fact: "Lava is melted rock that flows out of a volcano.")],
                creativePrompt: "Draw the rock-sample crates.",
                storyEnding: "Every research team gets a fair share. Great research, Dr. Nolan!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A sample case holds 4 rock samples. Dr. Nolan adds 2 more samples. How many samples are in the case now?",
                hints: mathHints(level),
                activityFingerprint: "volcanoes.math.advancing.sensors"
            )
        }
    }

    // MARK: - Weather (Meteorologist Piper — clouds, forecasting, sky clues)

    private static func weatherReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Piper Watches the Clouds",
                storyOpening: "Piper looks up at the big gray sky. Will you watch the weather with her?",
                missionPrompt: "Find out what weather clues Piper notices.",
                readingPassage: "Piper sees gray clouds gathering overhead. The wind blows hard across the yard. Rain begins to fall, so Piper grabs an umbrella.",
                questions: [
                    mcq("What color are the clouds?", ["Gray", "Pink", "Yellow"], "Gray", "Piper sees gray clouds."),
                    mcq("What does the wind do?", ["Blows hard", "Stops completely", "Sings a song"], "Blows hard", "The wind blows hard."),
                    mcq("What does Piper grab?", ["An umbrella", "A scarf", "A sled"], "An umbrella", "Piper grabs an umbrella.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "cloud", definition: "A fluffy or gray shape in the sky made of tiny water drops.", exampleSentence: "Piper sees gray clouds."),
                    VocabularyWord(word: "umbrella", definition: "A tool that keeps you dry in the rain.", exampleSentence: "Piper grabs an umbrella.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Gray clouds often mean rain is coming because they are full of tiny water drops.", explanation: "The darker and thicker a cloud looks, the more rain it might be holding.")
                ],
                creativePrompt: "Draw Piper holding an umbrella under gray weather clouds.",
                creativeResponseType: .drawing,
                storyEnding: "Piper stays dry under the umbrella as the rain falls softly.",
                readingSkill: "Follow a simple weather story",
                reflectionPrompt: "What weather clues did Piper see in the sky?",
                hints: ["Find the word gray", "Look for the word umbrella"],
                commonMistakes: ["Choosing a color the clouds were not"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short weather story"],
                activityFingerprint: "weather.k.cloud-watch.detail",
                characterNames: ["Piper"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Piper Reads the Weather Map",
                storyOpening: "Colorful swirls and arrows cover the weather map on Piper's screen.",
                missionPrompt: "Check what Piper's weather map tell her.",
                readingPassage: "Piper studies a weather map covered in colorful swirls and arrows. Blue arrows show cold air moving in from the north, while red arrows show warm air moving up from the south. Where the cold and warm air meet, Piper marks a line called a front. A front often brings clouds and rain. She checks the wind speed numbers next to the arrows to see how fast the air is moving. Based on the map, Piper predicts rain will arrive in her city by tomorrow afternoon.",
                questions: [
                    mcq("What do the blue arrows show?", ["Cold air moving in from the north", "Warm air moving up from the south", "Birds flying south for winter"], "Cold air moving in from the north", "Blue arrows show cold air moving in from the north."),
                    mcq("What does Piper mark where cold and warm air meet?", ["A line called a front", "A picture of the sun", "A list of city names"], "A line called a front", "She marks a line called a front where the air meets."),
                    mcq("What does Piper predict based on the map?", ["Rain will arrive by tomorrow afternoon", "It will snow for a whole week", "The weather will never change"], "Rain will arrive by tomorrow afternoon", "Piper predicts rain will arrive by tomorrow afternoon.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "front", definition: "The line where two different kinds of air meet.", exampleSentence: "Piper marks a front where cold and warm air meet."),
                    VocabularyWord(word: "predict", definition: "To say what will likely happen before it happens.", exampleSentence: "Piper predicts rain will come tomorrow.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Weather fronts form where warm and cold air meet, often bringing clouds and rain.", explanation: "Meteorologists track fronts on maps to help predict changing weather.")
                ],
                creativePrompt: "Draw a weather map with blue arrows for cold air and red arrows for warm air.",
                creativeResponseType: .drawing,
                storyEnding: "Piper closes her weather map, confident that rain is on its way by tomorrow afternoon.",
                readingSkill: "Recall weather-map details from a nonfiction passage",
                reflectionPrompt: "Why might a front often bring clouds and rain?",
                hints: ["Find the sentence about the front", "Look for the word predict"],
                commonMistakes: ["Mixing up which color arrow shows cold air"],
                successCriteria: ["Uses a weather-map detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "weather.early.weather-map.detail",
                characterNames: ["Piper"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Piper Watches Air Pressure",
                storyOpening: "A curious neighbor asks why Piper keeps checking a strange dial in her weather station.",
                missionPrompt: "Figure out why air pressure matter for Piper's forecasts.",
                readingPassage: "A curious neighbor once asked Piper why she kept checking a strange dial called a barometer in her small backyard weather station. Piper explained that the barometer measures air pressure — how hard the air above us is pushing down. When air pressure starts dropping quickly, it usually means a storm is approaching, because rising warm air creates lower pressure near the ground. Rising air pressure often signals clear, calm weather is on the way, since cooler, heavier air is settling in. Watching the barometer's changes over several hours gives Piper clues about the weather even before clouds appear in the sky. By combining barometer readings with cloud patterns and wind direction, she can make forecasts that are much more accurate than guessing from clouds alone.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Air pressure changes give early clues about upcoming weather", "A barometer has no real use for predicting weather", "Air pressure never changes no matter the weather"], "Air pressure changes give early clues about upcoming weather", "Piper explains that air pressure changes give early weather clues."),
                    mcq("What does dropping air pressure usually mean?", ["A storm is likely approaching", "Clear, calm weather is coming", "The barometer is broken"], "A storm is likely approaching", "Dropping air pressure usually means a storm is approaching."),
                    mcq("What does Piper combine with barometer readings for a more accurate forecast?", ["Cloud patterns and wind direction", "The color of the sky at noon", "The number of birds she sees"], "Cloud patterns and wind direction", "Piper combines barometer readings with cloud patterns and wind direction.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "barometer", definition: "A tool that measures air pressure.", exampleSentence: "Piper checks the barometer in her weather station."),
                    VocabularyWord(word: "forecast", definition: "A prediction of what the weather will be like.", exampleSentence: "Piper makes an accurate forecast using several clues.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Dropping air pressure often signals an approaching storm, while rising pressure often signals clear weather.", explanation: "Meteorologists use barometers to detect these changes before storms arrive.")
                ],
                creativePrompt: "Draw Piper checking her barometer with an arrow showing pressure dropping.",
                creativeResponseType: .drawing,
                storyEnding: "The neighbor learns that a simple dial can give clues about tomorrow's weather before a single cloud appears.",
                readingSkill: "Identify the main idea in a weather-science passage",
                reflectionPrompt: "Why might combining several clues make a weather forecast more accurate than using just one?",
                hints: ["Reread Piper's explanation about dropping and rising pressure", "Think about what she combines with the barometer"],
                commonMistakes: ["Thinking air pressure has no connection to storms"],
                successCriteria: ["States the air-pressure main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction science passage"],
                activityFingerprint: "weather.growing.air-pressure.main-idea",
                characterNames: ["Piper"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Two Clues Behind Piper's Storm Warning",
                storyOpening: "Unusual readings flash at Piper's station. She studies two clues before she warns the town.",
                missionPrompt: "Discover how Piper's weather clues lead to her storm warning.",
                readingPassage: """
                When Piper's instruments showed unusual readings one afternoon, she did not issue a storm warning based on a single number alone. First, she checked the barometer on her weather-station desk. The dial showed air pressure dropping rapidly over just three hours, far faster than a typical daily change. Next, she opened the satellite feed on her screen. The images revealed a thick band of dark clouds moving steadily toward her town from the west. A slow, gradual pressure drop paired with scattered clouds would likely mean only mild weather changes. A rapid pressure drop combined with a dense, organized cloud band moving directly toward the area suggested a much stronger storm system was approaching. Comparing both clues, Piper concluded that a significant storm, possibly with strong winds and heavy rain, would likely reach her town within the next few hours. She issued a timely warning to residents so families could prepare. The storm arrived almost exactly when she predicted, confirming that her two-clue comparison had accurately forecasted the danger ahead of time.
                """,
                questions: [
                    mcq("What did Piper conclude from her weather readings?", ["A significant storm was likely approaching within hours", "The weather would remain calm and clear", "Her instruments were broken and unreliable"], "A significant storm was likely approaching within hours", "Piper concluded a significant storm was approaching soon."),
                    mcq("Where were the dark clouds moving?", ["Toward her town from the west", "Away from town toward the ocean", "In a small circle over the station"], "Toward her town from the west", "Satellite images revealed a thick band of dark clouds moving toward her town from the west."),
                    mcq("What confirmed Piper's forecast was accurate?", ["The storm arrived almost exactly when she predicted", "No storm ever appeared at all", "The pressure suddenly rose back to normal"], "The storm arrived almost exactly when she predicted", "The storm arrived almost exactly when Piper predicted it would.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "satellite", definition: "A machine in space that can take pictures of Earth's weather.", exampleSentence: "Satellite images showed a band of clouds approaching."),
                    VocabularyWord(word: "rapidly", definition: "Very quickly.", exampleSentence: "The air pressure dropped rapidly over three hours.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Comparing the speed of a pressure drop with satellite cloud images helps meteorologists forecast storm strength more accurately.", explanation: "Combining more than one clue reduces the chance of missing or overstating a storm warning.")
                ],
                creativePrompt: "Write two sentences about why Piper warned families and whether the storm arrived as she expected.",
                creativeResponseType: .shortText,
                storyEnding: "Piper's comparison of two clues turns uncertain instrument readings into a timely, life-saving warning.",
                readingSkill: "Use forecasting clues to explain a scientific conclusion",
                reflectionPrompt: "Why might a rapid pressure drop be more concerning than a slow one?",
                hints: ["Look at the satellite cloud band", "Reread when the storm arrived"],
                commonMistakes: ["Assuming any pressure drop always means a dangerous storm"],
                successCriteria: ["Explains Piper's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "weather.confident.storm-clues.conclusion",
                characterNames: ["Piper"]
            )
        }
    }

    private static func weatherMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Clouds",
                storyOpening: "Piper needs a careful count before her forecast.",
                missionPrompt: "Count the clouds and compare the groups.",
                readingPassage: "Four fluffy clouds float in the sky. Two raindrops fall beside them. Piper points and counts out loud.",
                problems: [
                    mcq("Piper sees 2 clouds, then 2 more join. How many clouds in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 raindrops on the left and 3 clouds on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Piper counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Piper can count the clouds.")],
                knowledgeFacts: [KnowledgeFact(fact: "Weather watchers count clouds carefully to help understand the sky.")],
                creativePrompt: "Draw 4 clouds in the sky.",
                storyEnding: "Piper's cloud count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 raindrops on the left and 3 clouds on the right. Which side has more?",
                hints: ["Point to each cloud", "Compare the two groups"],
                activityFingerprint: "weather.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Raindrops for the Forecast",
                storyOpening: "Piper sorts weather notes before a busy forecasting day.",
                missionPrompt: "Add and subtract to finish the forecasting jobs.",
                readingPassage: "Piper reads rain gauges outside the weather station. She checks how many gauges she has read and how many charts still need updating.",
                problems: [
                    mcq("Piper finds 6 rain gauges. Then she finds 3 more. How many rain gauges in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A storage box holds 10 weather charts. Piper hands 4 charts to other forecasters. How many charts are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Piper started with 8 wind readings on her clipboard. She gives away 5 readings to a trainee. How many readings does Piper have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total rain gauges.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking equipment numbers helps a forecasting day run smoothly.")],
                creativePrompt: "Draw 9 rain gauges ready for the forecast.",
                storyEnding: "The weather station is ready for the forecast.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A storage box holds 10 weather charts. Piper hands 4 charts to other forecasters. How many charts are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "weather.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Piper",
                pronoun: "she",
                items: [
                    ("weather charts", "in the chart folder"),
                    ("rain gauges", "in the gauge box"),
                    ("thermometers", "on the weather board")
                ],
                packItem: "weather charts",
                purpose: "for the busy forecasting day"
            )
            return MathScene(
                title: "Groups at the Weather Station",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Piper checks 3 boxes of thermometers with 4 thermometers in each box. How many thermometers does she use?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A wind vane pole is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten weather charts.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the weather station has enough supplies.")],
                creativePrompt: "Draw 3 boxes of thermometers with 4 thermometers in each box.",
                storyEnding: "The weather station is ready for the busy forecasting day.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Piper checks 3 boxes of thermometers with 4 thermometers in each box. How many thermometers does she use?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "weather.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Forecast Day" : "Equal Shares of Weather Charts",
                storyOpening: "Piper plans supplies for a full day of forecasting.",
                missionPrompt: multi ? "Solve each forecasting problem." : "Solve each forecasting problem carefully.",
                readingPassage: "Weather charts and rain gauges are shared with the forecasting team during the busy day.",
                problems: [
                    mcq("Piper orders 3 boxes with 8 rain gauges in each box. How many gauges does she order?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Piper shares 18 weather charts among 3 forecasting teams equally. How many does each team get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One wind vane pole is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "equal", definition: "The same number in each group.", exampleSentence: "Equal groups of gauges have the same count.")],
                knowledgeFacts: [KnowledgeFact(fact: "A rain gauge measures how much rain has fallen.")],
                creativePrompt: "Draw the rain gauge boxes.",
                storyEnding: "Every forecasting team gets a fair share. Great forecast, Piper!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A supply case holds 4 thermometers. Piper adds 2 more thermometers. How many thermometers are in the case now?",
                hints: mathHints(level),
                activityFingerprint: "weather.math.advancing.rain-gauges"
            )
        }
    }

    // MARK: - Farm Animals (Farmer Jo — chores, animal care, morning clues)

    private static func farmAnimalsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Farmer Jo Feeds the Hens",
                storyOpening: "Farmer Jo carries a bucket of seeds. Come help with the morning chores.",
                missionPrompt: "Find out what happens when Farmer Jo feeds the hens.",
                readingPassage: "Farmer Jo feeds the hens as they gather around. The hens peck the seeds from the ground. A rooster crows loudly while the sun comes up.",
                questions: [
                    mcq("Who does Farmer Jo feed?", ["The hens", "The fish", "The bears"], "The hens", "Farmer Jo feeds the hens."),
                    mcq("What do the hens do?", ["Peck the seeds", "Fly away", "Swim in a pond"], "Peck the seeds", "The hens peck the seeds."),
                    mcq("Who crows loudly?", ["A rooster", "A duck", "A pig"], "A rooster", "A rooster crows loudly.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "hen", definition: "A female chicken.", exampleSentence: "Farmer Jo feeds the hens."),
                    VocabularyWord(word: "crow", definition: "The loud sound a rooster makes.", exampleSentence: "The rooster crows loudly.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Roosters often crow early in the morning to greet the sunrise.", explanation: "A rooster's crow can be heard from far away across the farm.")
                ],
                creativePrompt: "Draw Farmer Jo feeding seeds to the hens.",
                creativeResponseType: .drawing,
                storyEnding: "The farm wakes up as the sun rises over the barn.",
                readingSkill: "Follow a simple farm story",
                reflectionPrompt: "What did Farmer Jo feed the hens?",
                hints: ["Find the word hens", "Look for the word rooster"],
                commonMistakes: ["Choosing an animal Farmer Jo did not feed"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short farm story"],
                activityFingerprint: "farmAnimals.k.hen-feed.detail",
                characterNames: ["Farmer Jo"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Farmer Jo Milks the Cow",
                storyOpening: "Soft morning light fills the barn where Bessie the cow waits patiently.",
                missionPrompt: "Discover how Farmer Jo milk Bessie this morning.",
                readingPassage: "Farmer Jo walks into the barn every morning to milk Bessie, the gentle brown cow. She washes her hands first, then sits on a small wooden stool beside Bessie. Gently, she squeezes to fill a metal pail with fresh, warm milk. Bessie chews hay calmly the whole time, seeming to enjoy the quiet routine. When the pail is full, Farmer Jo carries the milk inside to pour into clean glass jars.",
                questions: [
                    mcq("What does Farmer Jo do first before milking?", ["Washes her hands", "Feeds the chickens", "Cleans the barn floor"], "Washes her hands", "She washes her hands first, then sits on the stool."),
                    mcq("What does Bessie do while being milked?", ["Chews hay calmly", "Runs around the barn", "Falls asleep standing up"], "Chews hay calmly", "Bessie chews hay calmly the whole time."),
                    mcq("What does Farmer Jo do with the full pail?", ["Carries it inside to pour into glass jars", "Leaves it in the barn overnight", "Gives it directly to Bessie"], "Carries it inside to pour into glass jars", "She carries the milk inside to pour into glass jars.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "pail", definition: "A round metal or plastic container for carrying liquid.", exampleSentence: "Farmer Jo fills a pail with milk."),
                    VocabularyWord(word: "routine", definition: "Something done the same way regularly.", exampleSentence: "Milking Bessie is part of Farmer Jo's morning routine.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Cows need to be milked regularly, often twice a day, to stay healthy and comfortable.", explanation: "A calm, gentle routine helps cows like Bessie feel relaxed during milking.")
                ],
                creativePrompt: "Draw Farmer Jo milking Bessie the cow on the wooden stool.",
                creativeResponseType: .drawing,
                storyEnding: "Farmer Jo pours the fresh milk into clean glass jars, ready for the day ahead.",
                readingSkill: "Recall milking-routine details from a farm passage",
                reflectionPrompt: "Why might Bessie stay calm during the milking routine?",
                hints: ["Find the sentence about washing hands", "Look for the word routine"],
                commonMistakes: ["Skipping the detail about washing hands first"],
                successCriteria: ["Uses a milking-routine detail from the story"],
                learningObjectives: ["Recall key details and sequence from a short passage"],
                activityFingerprint: "farmAnimals.early.cow-milking.detail",
                characterNames: ["Farmer Jo"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Farmer Jo Rotates Her Fields",
                storyOpening: "A visiting student wonders why Farmer Jo moves her animals to a different field every few weeks.",
                missionPrompt: "Figure out why Farmer Jo rotate her animals between fields.",
                readingPassage: "A visiting student once asked Farmer Jo why she moved her sheep and cows to a different field every few weeks instead of letting them graze in the same spot all season. Farmer Jo explained that when animals eat grass down to the roots in one small area for too long, the grass struggles to grow back and the soil can become worn out. By moving animals to a fresh field regularly, the grass in the old field gets time to rest and regrow before the animals return. This rotation also helps keep the animals healthier, since spreading out their waste across different fields naturally fertilizes the soil without overloading any single spot. A farm using rotation usually stays green and productive for many more years than a farm that lets animals graze in one place constantly.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Rotating animals between fields keeps grass and soil healthy over time", "Animals should always stay in the exact same field all season", "Field rotation has no real benefit for a farm"], "Rotating animals between fields keeps grass and soil healthy over time", "Farmer Jo explains that rotating fields keeps grass and soil healthy."),
                    mcq("What happens if animals graze the same small area for too long?", ["The grass struggles to grow back and soil can wear out", "The grass grows twice as fast as normal", "Nothing changes about the field at all"], "The grass struggles to grow back and soil can wear out", "Grazing too long in one spot can wear out the grass and soil."),
                    mcq("How does moving animals help fertilize the soil?", ["Spreading their waste across different fields naturally fertilizes it", "The animals carry fertilizer bags with them", "Farmer Jo sprays fertilizer on empty fields"], "Spreading their waste across different fields naturally fertilizes it", "Spreading waste across different fields naturally fertilizes the soil.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "rotation", definition: "Moving something through a repeated cycle or order.", exampleSentence: "Farmer Jo uses field rotation to keep her farm healthy."),
                    VocabularyWord(word: "fertilize", definition: "To add nutrients that help plants grow better.", exampleSentence: "Animal waste can fertilize a field naturally.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Rotating farm animals between different fields helps grass regrow and keeps soil healthy over many years.", explanation: "This farming method is called field rotation and is used on many real farms.")
                ],
                creativePrompt: "Draw two farm fields, one resting and one being grazed by animals.",
                creativeResponseType: .drawing,
                storyEnding: "The visiting student learns that moving animals between fields is a smart way to keep a whole farm healthy for years.",
                readingSkill: "Identify the main idea in a farming-practices passage",
                reflectionPrompt: "Why might a farm using rotation stay productive longer than one that does not?",
                hints: ["Reread Farmer Jo's explanation about resting fields", "Think about what happens to soil without rotation"],
                commonMistakes: ["Thinking animals should always graze in the exact same spot"],
                successCriteria: ["States the field-rotation main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction agriculture passage"],
                activityFingerprint: "farmAnimals.growing.field-rotation.main-idea",
                characterNames: ["Farmer Jo"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Two Clues Behind the Quiet Hens",
                storyOpening: "Fewer eggs this week make Farmer Jo pause. She studies two clues before she decides why.",
                missionPrompt: "Discover how Farmer Jo's henhouse clues lead to her conclusion.",
                readingPassage: """
                When Farmer Jo noticed her hens had laid noticeably fewer eggs over the past week, she did not immediately assume the hens were sick. She looked for two clues before drawing a conclusion: the daylight hours had grown shorter as autumn arrived, and the hens' feed bin still had plenty of food remaining, ruling out hunger as an obvious cause. Hens rely on long daylight hours to trigger their egg-laying cycle, so if the hens were seriously ill, she would likely also notice other warning signs, such as the hens eating less or acting unusually quiet — neither of which she observed. She also checked the coop for drafts and found the nesting boxes dry and clean. Since the feed levels were normal and shortening daylight matched the exact time of year when hens naturally slow down their laying, Farmer Jo concluded that the shorter days, not illness, explained the drop in eggs. She decided to add a gentle indoor light to extend the hens' daylight hours artificially, and kept notes each morning so she could compare egg counts before and after the change. Within two weeks, egg production returned to its usual level, confirming her conclusion had been correct all along.
                """,
                questions: [
                    mcq("What did Farmer Jo conclude was causing fewer eggs?", ["Shorter daylight hours as autumn arrived", "A serious illness among the hens", "The hens had stopped eating completely"], "Shorter daylight hours as autumn arrived", "Farmer Jo concluded shorter daylight hours caused the drop in eggs."),
                    mcq("Why did Farmer Jo rule out hunger as the cause?", ["The hens' feed bin still had plenty of food", "The hens refused to enter the coop", "The rooster ate all of the feed"], "The hens' feed bin still had plenty of food", "The hens' feed bin still had plenty of food remaining."),
                    mcq("What confirmed Farmer Jo's conclusion was correct?", ["Egg production returned to normal after adding indoor light", "The hens stopped laying eggs completely", "A veterinarian found a serious illness"], "Egg production returned to normal after adding indoor light", "Adding light restored normal egg production, confirming her idea.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "cycle", definition: "A series of events that repeats regularly.", exampleSentence: "Daylight hours affect a hen's egg-laying cycle."),
                    VocabularyWord(word: "artificially", definition: "Made by people rather than occurring naturally.", exampleSentence: "Farmer Jo extended daylight artificially with indoor light.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Hens rely on long daylight hours to trigger regular egg-laying, and shorter autumn days can reduce how many eggs they lay.", explanation: "Farmers sometimes add artificial light to keep egg production steady through the fall and winter.")
                ],
                creativePrompt: "Write two sentences about why the hens laid fewer eggs and what Farmer Jo changed in the coop.",
                creativeResponseType: .shortText,
                storyEnding: "Farmer Jo's two clues turn a worrying drop in eggs into a simple, fixable daylight solution.",
                readingSkill: "Use farm clues to explain an agricultural conclusion",
                reflectionPrompt: "Why might checking for other warning signs help rule out illness as a cause?",
                hints: ["Look at the feed bin and the season", "Reread what happened after she added light"],
                commonMistakes: ["Assuming fewer eggs always means the hens are sick"],
                successCriteria: ["Explains Farmer Jo's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "farmAnimals.confident.egg-clues.conclusion",
                characterNames: ["Farmer Jo"]
            )
        }
    }

    private static func farmAnimalsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Chicks",
                storyOpening: "Farmer Jo needs a careful count in the henhouse.",
                missionPrompt: "Count the chicks and compare the groups.",
                readingPassage: "Four fluffy chicks peep near the hen. Two eggs rest in the nest. Farmer Jo points and counts out loud.",
                problems: [
                    mcq("Farmer Jo sees 2 chicks, then 2 more join. How many chicks in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 eggs on the left and 3 chicks on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Farmer Jo counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Farmer Jo can count the chicks.")],
                knowledgeFacts: [KnowledgeFact(fact: "Farmers count their animals every day to make sure everyone is safe and healthy.")],
                creativePrompt: "Draw 4 chicks near the hen.",
                storyEnding: "Farmer Jo's chick count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 eggs on the left and 3 chicks on the right. Which side has more?",
                hints: ["Point to each chick", "Compare the two groups"],
                activityFingerprint: "farmAnimals.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Eggs for the Basket",
                storyOpening: "Farmer Jo sorts eggs before a busy morning.",
                missionPrompt: "Add and subtract to finish the farm jobs.",
                readingPassage: "Farmer Jo collects eggs from the henhouse at dawn. She checks how many eggs she has gathered and how many feed buckets still need filling.",
                problems: [
                    mcq("Farmer Jo finds 6 eggs. Then she finds 3 more. How many eggs in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A feed bin holds 10 scoops of grain. Farmer Jo gives 4 scoops to the hens. How many scoops are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Farmer Jo needs 8 baskets of eggs for market. She has filled 5 so far. How many more baskets does she need?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total eggs.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking egg numbers helps a farm morning run smoothly.")],
                creativePrompt: "Draw 9 eggs ready for the basket.",
                storyEnding: "The farm is ready for the morning chores.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A feed bin holds 10 scoops of grain. Farmer Jo gives 4 scoops to the hens. How many scoops are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "farmAnimals.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Farmer Jo",
                pronoun: "she",
                items: [
                    ("hay bales", "in the barn loft"),
                    ("eggs", "in the egg basket"),
                    ("feed buckets", "on the stall wall")
                ],
                packItem: "hay bales",
                purpose: "for the busy harvest day"
            )
            return MathScene(
                title: "Groups in the Barn",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Farmer Jo sets out 3 rows with 4 feed buckets in each row. How many feed buckets does she set out?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A fence post is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten hay bales.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the barn has enough supplies.")],
                creativePrompt: "Draw 3 rows with 4 feed buckets in each row.",
                storyEnding: "The barn is ready for the busy harvest day.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Farmer Jo sets out 3 rows with 4 feed buckets in each row. How many feed buckets does she set out?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "farmAnimals.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Harvest Day" : "Equal Shares of Apples",
                storyOpening: "Farmer Jo plans supplies for a full day of the harvest.",
                missionPrompt: multi ? "Solve each farm problem." : "Solve each farm problem carefully.",
                readingPassage: "Fresh apples and eggs are shared with visitors during the harvest day.",
                problems: [
                    mcq("Farmer Jo picks 3 baskets with 8 apples in each basket. How many apples does she pick?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Farmer Jo shares 18 apples among 3 visiting families equally. How many does each family get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One fence post is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "times", definition: "Groups of the same size counted that many times.", exampleSentence: "3 times 8 is 24 apples.")],
                knowledgeFacts: [KnowledgeFact(fact: "Harvest is the time farmers gather crops from the fields.")],
                creativePrompt: "Draw the apple baskets.",
                storyEnding: "Every visiting family gets a fair share. Great harvest, Farmer Jo!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water trough holds 4 buckets of water. Farmer Jo adds 2 more buckets. How many buckets are in the trough now?",
                hints: mathHints(level),
                activityFingerprint: "farmAnimals.math.advancing.apples"
            )
        }
    }

    // MARK: - Zoo Animals (Keeper Amara — feeding rounds, enrichment, behavior clues)

    private static func zooAnimalsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Keeper Amara Feeds the Giraffe",
                storyOpening: "Keeper Amara carries a bucket of leaves. Come meet the giraffe with her.",
                missionPrompt: "Find out what happens when Keeper Amara feeds the giraffe.",
                readingPassage: "Keeper Amara feeds the giraffe from her bucket. The giraffe bends its long neck down low. It eats the leaves, then licks its lips.",
                questions: [
                    mcq("Who does Keeper Amara feed?", ["The giraffe", "The penguin", "The turtle"], "The giraffe", "Keeper Amara feeds the giraffe."),
                    mcq("What does the giraffe bend?", ["Its long neck", "Its short tail", "Its tiny ear"], "Its long neck", "The giraffe bends its long neck."),
                    mcq("What does the giraffe eat?", ["The leaves", "The dry hay", "The orange carrots"], "The leaves", "It eats the leaves.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "giraffe", definition: "A tall animal with a very long neck.", exampleSentence: "Keeper Amara feeds the giraffe."),
                    VocabularyWord(word: "bucket", definition: "A container used to carry things like food.", exampleSentence: "Keeper Amara carries a bucket of leaves.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "A giraffe's long neck helps it reach leaves high up in tall trees.", explanation: "Giraffes are the tallest land animals in the world.")
                ],
                creativePrompt: "Draw the giraffe bending its long neck to eat leaves.",
                creativeResponseType: .drawing,
                storyEnding: "The giraffe finishes its leaves and looks happily at Keeper Amara.",
                readingSkill: "Follow a simple zoo story",
                reflectionPrompt: "What did the giraffe eat?",
                hints: ["Find the word giraffe", "Look for the word leaves"],
                commonMistakes: ["Choosing an animal Keeper Amara did not feed"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short zoo story"],
                activityFingerprint: "zooAnimals.k.giraffe-feed.detail",
                characterNames: ["Keeper Amara"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Keeper Amara Hides a Puzzle Treat",
                storyOpening: "A hollow puzzle toy waits in Keeper Amara's hands near the elephant enclosure.",
                missionPrompt: "Discover how the elephant solve Keeper Amara's puzzle.",
                readingPassage: "Keeper Amara hides small fruit treats inside a hollow puzzle toy before placing it in the elephant enclosure. The elephant sniffs the toy curiously, using its trunk to roll it across the ground. After several tries, the elephant figures out how to tip the toy just right, and the treats spill out onto the grass. Puzzle toys like this keep the elephant's mind active and give it something fun to solve. Watching the elephant work out the puzzle is just as important as the tasty treats inside.",
                questions: [
                    mcq("What does Keeper Amara hide inside the puzzle toy?", ["Small fruit treats", "Loud bells", "Heavy rocks"], "Small fruit treats", "Keeper Amara hides small fruit treats inside the toy."),
                    mcq("How does the elephant move the toy at first?", ["Rolls it across the ground with its trunk", "Throws it high into the air", "Buries it under the dirt"], "Rolls it across the ground with its trunk", "The elephant rolls the toy using its trunk."),
                    mcq("Why does Keeper Amara use puzzle toys?", ["To keep the elephant's mind active", "To make the elephant sleepy", "To clean the enclosure faster"], "To keep the elephant's mind active", "Puzzle toys keep the elephant's mind active and give it something to solve.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "enrichment", definition: "Activities that keep an animal's mind and body active.", exampleSentence: "The puzzle toy is a type of enrichment for the elephant."),
                    VocabularyWord(word: "curiously", definition: "In a way that shows interest in learning more.", exampleSentence: "The elephant sniffs the toy curiously.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Zoo keepers use puzzle toys, called enrichment, to keep animals' minds active and engaged.", explanation: "Enrichment activities help animals stay curious and healthy, similar to how they might behave in the wild.")
                ],
                creativePrompt: "Draw the elephant using its trunk to solve the puzzle toy.",
                creativeResponseType: .drawing,
                storyEnding: "The elephant enjoys its fruit treats, proud of solving Keeper Amara's clever puzzle.",
                readingSkill: "Recall enrichment details from a zoo passage",
                reflectionPrompt: "Why might solving the puzzle be just as important as the treats themselves?",
                hints: ["Find the sentence about the elephant's trunk", "Look for the word enrichment"],
                commonMistakes: ["Skipping the detail about the elephant's mind staying active"],
                successCriteria: ["Uses an enrichment detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction passage"],
                activityFingerprint: "zooAnimals.early.puzzle-treat.detail",
                characterNames: ["Keeper Amara"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Keeper Amara Changes the Habitat Layout",
                storyOpening: "A visitor wonders why Keeper Amara keeps rearranging logs and rocks in the tiger habitat.",
                missionPrompt: "Figure out why Keeper Amara changes the habitat layout.",
                readingPassage: "A visitor once asked Keeper Amara why she frequently moved logs, rocks, and plants around in the tiger habitat instead of leaving everything in the same place. Keeper Amara explained that tigers in the wild constantly explore new areas, climb different rocks, and investigate changing surroundings as they search for food and mark their territory. If a zoo habitat never changed, the tiger might become bored and less active, since there would be nothing new left to explore. By regularly rearranging the habitat, she gives the tiger fresh things to sniff, climb, and investigate — similar to what it would experience in a wild environment. Keeping animals mentally engaged through habitat changes is just as important to their overall health as providing good food and medical care.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Rearranging a habitat keeps zoo animals mentally engaged and active", "Zoo habitats should never be changed once they are set up", "Tigers in the wild never explore new areas"], "Rearranging a habitat keeps zoo animals mentally engaged and active", "Keeper Amara explains that rearranging habitats keeps animals engaged."),
                    mcq("What might happen if a habitat never changed?", ["The tiger might become bored and less active", "The tiger would immediately become sick", "The tiger would stop eating completely"], "The tiger might become bored and less active", "An unchanging habitat could make the tiger bored and less active."),
                    mcq("What does Keeper Amara say is just as important as food and medical care?", ["Keeping animals mentally engaged through habitat changes", "Painting the enclosure a bright color", "Playing loud music near the habitat"], "Keeping animals mentally engaged through habitat changes", "Mental engagement through habitat changes matters as much as food and care.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "territory", definition: "An area an animal considers its own and defends.", exampleSentence: "Wild tigers mark their territory as they explore."),
                    VocabularyWord(word: "engaged", definition: "Interested and actively involved in something.", exampleSentence: "Habitat changes keep the tiger mentally engaged.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Zoo keepers regularly rearrange habitats to keep animals mentally engaged, similar to their natural wild behavior.", explanation: "This practice is part of animal enrichment. Enrichment supports overall animal health and well-being.")
                ],
                creativePrompt: "Draw the tiger habitat before and after Keeper Amara rearranges the logs and rocks.",
                creativeResponseType: .drawing,
                storyEnding: "The visitor learns that a zoo habitat is not just decoration — it is designed to keep animals curious and active.",
                readingSkill: "Identify the main idea in an animal-care passage",
                reflectionPrompt: "Why might mental activity matter just as much as food for an animal's health?",
                hints: ["Reread Keeper Amara's explanation about wild tiger behavior carefully.", "Think about what happens without habitat changes"],
                commonMistakes: ["Thinking habitat decoration has no real purpose for animal health"],
                successCriteria: ["States the habitat-change main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction animal-care passage"],
                activityFingerprint: "zooAnimals.growing.habitat-change.main-idea",
                characterNames: ["Keeper Amara"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Two Clues Behind the Restless Otter",
                storyOpening: "An otter paces and seems restless. Keeper Amara studies two clues before she decides why.",
                missionPrompt: "Discover how Keeper Amara's enclosure clues lead to her conclusion.",
                readingPassage: """
                When one of the zoo's otters started pacing back and forth along the same short stretch of its enclosure, Keeper Amara did not assume right away that the otter was sick. She looked for two clues before drawing a conclusion: the otter's appetite remained completely normal, with every meal finished quickly, and the pacing only happened during the busiest visitor hours, calming down significantly once the crowds thinned out in the evening. A genuinely ill otter would likely show reduced appetite or other physical symptoms throughout the day, not just during specific busy hours. Since the otter ate normally and the restless pacing lined up exactly with peak crowd noise and movement near the glass, she concluded that the otter was feeling stressed by the crowds rather than experiencing a health problem. She added extra hiding spots and a partial visual barrier to the enclosure, giving the otter places to retreat from view during busy hours. Within a week, the pacing behavior decreased noticeably, confirming that crowd stress, not illness, had been the true cause.
                """,
                questions: [
                    mcq("What did Keeper Amara conclude was causing the otter's pacing?", ["Stress from busy crowds, not a health problem", "A serious illness affecting its appetite", "Boredom from having no enrichment toys"], "Stress from busy crowds, not a health problem", "Keeper Amara concluded the otter was stressed by crowds."),
                    mcq("When did the otter pace the most?", ["During the busiest visitor hours", "Only late at night after closing", "All day, even when the zoo was empty"], "During the busiest visitor hours", "The pacing only happened during the busiest visitor hours."),
                    mcq("What confirmed Keeper Amara's conclusion?", ["The pacing decreased after adding hiding spots and a visual barrier", "The otter completely stopped eating", "The zoo closed the exhibit permanently"], "The pacing decreased after adding hiding spots and a visual barrier", "Adding hiding spots reduced the pacing, confirming her conclusion.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "retreat", definition: "To move back to a safer or calmer place.", exampleSentence: "The otter could retreat from view during busy hours."),
                    VocabularyWord(word: "barrier", definition: "Something that blocks or separates one area from another.", exampleSentence: "A visual barrier helped hide the otter from crowds.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Zoo animals can show stress-related behaviors, like pacing, especially during busy visitor hours.", explanation: "Adding hiding spots or visual barriers can help reduce stress in zoo enclosures.")
                ],
                creativePrompt: "Write two sentences about why the otter paced and what Keeper Amara changed in the enclosure.",
                creativeResponseType: .shortText,
                storyEnding: "Keeper Amara's two clues turn a worrying behavior into a simple, effective enclosure improvement.",
                readingSkill: "Use behavioral clues to explain an animal-care conclusion",
                reflectionPrompt: "Why might timing be an important clue when figuring out the cause of an animal's behavior?",
                hints: ["Look at when the otter paced", "Reread what happened after hiding spots were added"],
                commonMistakes: ["Assuming unusual behavior always means an animal is sick"],
                successCriteria: ["Explains Keeper Amara's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "zooAnimals.confident.otter-clues.conclusion",
                characterNames: ["Keeper Amara"]
            )
        }
    }

    private static func zooAnimalsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Penguins",
                storyOpening: "Keeper Amara needs a careful count before feeding time.",
                missionPrompt: "Count the penguins and compare the groups.",
                readingPassage: "Four penguins waddle by the pool. Two fish rest in the bucket. Keeper Amara points and counts out loud.",
                problems: [
                    mcq("Keeper Amara sees 2 penguins, then 2 more join. How many penguins in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 fish on the left and 3 penguins on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Keeper Amara counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Keeper Amara can count the penguins.")],
                knowledgeFacts: [KnowledgeFact(fact: "Zoo keepers count their animals every day to make sure everyone is healthy and accounted for.")],
                creativePrompt: "Draw 4 penguins by the pool.",
                storyEnding: "Keeper Amara's penguin count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 fish on the left and 3 penguins on the right. Which side has more?",
                hints: ["Point to each penguin", "Compare the two groups"],
                activityFingerprint: "zooAnimals.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Fish for Feeding Time",
                storyOpening: "Keeper Amara sorts food before a busy feeding round.",
                missionPrompt: "Add and subtract to finish the zoo jobs.",
                readingPassage: "Keeper Amara buckets fish for the morning feeding round. She checks how many buckets are filled and how many fruit trays still need sorting.",
                problems: [
                    mcq("Keeper Amara finds 6 fish. Then she finds 3 more. How many fish in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A feeding bin holds 10 pieces of fruit. Keeper Amara hands 4 pieces to the monkeys. How many pieces are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Keeper Amara counted 8 feeding charts before rounds. After lending some, only 5 charts are left. How many charts did she lend?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total fish.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking food numbers helps a feeding round run smoothly.")],
                creativePrompt: "Draw 9 fish ready for feeding time.",
                storyEnding: "The zoo is ready for the feeding round.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A feeding bin holds 10 pieces of fruit. Keeper Amara hands 4 pieces to the monkeys. How many pieces are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "zooAnimals.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Keeper Amara",
                pronoun: "she",
                items: [
                    ("toys", "in the play crate"),
                    ("fish", "in the feed bucket"),
                    ("fruit", "on the snack cart")
                ],
                packItem: "toys",
                purpose: "for the busy zoo day"
            )
            return MathScene(
                title: "Groups at the Zoo",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Keeper Amara packs 3 crates of fruit baskets with 4 baskets in each crate. How many fruit baskets does she carry?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A fence rail is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten enrichment toys.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the zoo has enough supplies.")],
                creativePrompt: "Draw 3 crates of fruit baskets with 4 baskets in each crate.",
                storyEnding: "The zoo is ready for the busy day.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Keeper Amara packs 3 crates of fruit baskets with 4 baskets in each crate. How many fruit baskets does she carry?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "zooAnimals.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Zoo Feeding Day" : "Equal Shares of Fruit",
                storyOpening: "Keeper Amara plans supplies for a full day at the zoo.",
                missionPrompt: multi ? "Solve each zoo problem." : "Solve each zoo problem carefully.",
                readingPassage: "Fresh fruit and enrichment toys are shared with the animals during the busy zoo day.",
                problems: [
                    mcq("Keeper Amara packs 3 crates with 8 pieces of fruit in each crate. How many pieces of fruit does she pack?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Keeper Amara shares 18 pieces of fruit among 3 monkey enclosures equally. How many does each enclosure get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One fence rail is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "split", definition: "To divide into parts.", exampleSentence: "Split the pieces into equal shares.")],
                knowledgeFacts: [KnowledgeFact(fact: "Zookeepers check every animal each day to be sure it is healthy.")],
                creativePrompt: "Draw the fruit crates.",
                storyEnding: "Every enclosure gets a fair share. Great work, Keeper Amara!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water pool holds 4 buckets of fresh water. Keeper Amara adds 2 more buckets. How many buckets are in the pool now?",
                hints: mathHints(level),
                activityFingerprint: "zooAnimals.math.advancing.fruit-crates"
            )
        }
    }

    // MARK: - Pirates (Captain Wren — treasure maps, navigation, riddle clues)

    private static func piratesReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Captain Wren Finds Treasure",
                storyOpening: "Captain Wren holds an old map. An X marks a spot on an island. Will you help her follow it?",
                missionPrompt: "Find what Captain Wren uncovers where the X marks the spot.",
                readingPassage: "Captain Wren follows her map to an island. An X marks a spot in the sand. She digs where the X marks the spot. She opens a chest. Gold coins shine inside.",
                questions: [
                    mcq("What marks a spot on the map?", ["An X", "A star", "A circle"], "An X", "An X marks a spot on the map."),
                    mcq("Where does Captain Wren dig?", ["Where the X marks the spot", "Under the ship", "Beside a lantern"], "Where the X marks the spot", "She digs where the X marks the spot."),
                    mcq("What is in the chest?", ["Gold coins", "A spyglass", "A lantern"], "Gold coins", "Gold coins shine inside the chest.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "map", definition: "A drawing that shows where places are.", exampleSentence: "Captain Wren follows her map to an island."),
                    VocabularyWord(word: "chest", definition: "A strong box used to hold things.", exampleSentence: "Captain Wren opens a chest.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "A map can mark an important place with an X so a traveler can find it again.", explanation: "Captain Wren follows the X on her map and finds a chest of gold coins.")
                ],
                creativePrompt: "Draw the chest of gold coins Captain Wren found where the X marked the spot.",
                creativeResponseType: .drawing,
                storyEnding: "Captain Wren found gold coins where the X marked the spot!",
                readingSkill: "Follow a simple pirate story",
                reflectionPrompt: "What did Captain Wren find in the chest?",
                hints: ["Find the word chest", "Look for gold coins"],
                commonMistakes: ["Choosing an item that was not in the chest"],
                successCriteria: ["Names a real detail from the story"],
                learningObjectives: ["Identify concrete details in a short pirate story"],
                activityFingerprint: "pirates.k.map-find.detail",
                characterNames: ["Captain Wren"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Captain Wren Reads the Compass",
                storyOpening: "A brass compass rests in Captain Wren's palm as the ship rocks gently.",
                missionPrompt: "Discover how Captain Wren uses the compass to steer.",
                readingPassage: "Captain Wren holds a brass compass steady in one hand, watching the needle settle toward the north. She compares the compass direction with a line drawn on her old, worn map. The map shows the ship must sail east for two more days to reach the hidden island. She calls out directions to her crew. Her crew adjusts the sails to catch the wind. Slowly, the ship turns east and picks up speed across the waves.",
                questions: [
                    mcq("What does Captain Wren hold steady?", ["A brass compass", "A wooden sword", "A glass telescope"], "A brass compass", "Captain Wren holds a brass compass steady."),
                    mcq("Which direction does the needle settle toward?", ["North", "South", "West"], "North", "She watches the needle settle toward the north."),
                    mcq("What must the crew adjust to catch the wind?", ["The sails", "The anchor", "The map"], "The sails", "The crew adjusts the sails to catch the wind.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "compass", definition: "A tool with a needle that always points north.", exampleSentence: "Captain Wren holds a brass compass."),
                    VocabularyWord(word: "sail", definition: "A large piece of cloth that catches wind to move a ship.", exampleSentence: "The crew adjusts the sails.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "A compass needle always points toward north because it lines up with Earth's magnetic field.", explanation: "Sailors have used compasses for hundreds of years to find their direction at sea.")
                ],
                creativePrompt: "Draw Captain Wren holding the compass with the ship's sails catching the wind.",
                creativeResponseType: .drawing,
                storyEnding: "The ship turns east and speeds toward the hidden island, guided by the compass.",
                readingSkill: "Recall navigation details from a pirate passage",
                reflectionPrompt: "Why might a compass be an important tool for a ship's captain?",
                hints: ["Find the sentence about the needle", "Look for the word sails"],
                commonMistakes: ["Skipping the detail about the compass needle's direction"],
                successCriteria: ["Uses a navigation detail from the story"],
                learningObjectives: ["Recall key details from a short nonfiction-style passage"],
                activityFingerprint: "pirates.early.compass-read.detail",
                characterNames: ["Captain Wren"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Captain Wren Checks the Tide Tables",
                storyOpening: "A new crew member wonders why Captain Wren studies a chart of numbers before sailing near the reef.",
                missionPrompt: "Figure out why Captain Wren checks the tide tables.",
                readingPassage: "A new crew member once asked Captain Wren why she carefully studied a chart of numbers, called a tide table, before sailing near the rocky reef surrounding the hidden island. Captain Wren explained that ocean water rises and falls throughout the day in a pattern called the tide, and at low tide, parts of the reef that are normally underwater can become dangerously shallow. If the ship tried to sail over the reef during low tide, it could scrape against rocks and take on damaging water. By checking the tide table, she can time the ship's journey to cross the reef safely during high tide, when there is enough deep water beneath the hull. Ignoring the tide table has wrecked many careless ships throughout history. That is why she checks it every single time before approaching unfamiliar waters.",
                questions: [
                    mcq("What is the main idea of this passage?", ["Checking tide tables helps a captain safely time a ship's journey near reefs", "Tides have no real effect on how ships travel", "A ship should always sail during low tide near a reef"], "Checking tide tables helps a captain safely time a ship's journey near reefs", "Captain Wren explains that tide tables help her time journeys safely."),
                    mcq("What can happen if a ship sails over a reef during low tide?", ["It could scrape against rocks and take on damaging water", "It would automatically float higher above the water", "Nothing at all would happen to the ship"], "It could scrape against rocks and take on damaging water", "Sailing over a reef at low tide could scrape the ship on rocks."),
                    mcq("When does Captain Wren time the ship to cross the reef?", ["During high tide, when there is enough deep water", "During a storm, for extra excitement", "At midnight, when it is hardest to see"], "During high tide, when there is enough deep water", "She times the crossing for high tide, with enough deep water.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "tide", definition: "The regular rising and falling of ocean water.", exampleSentence: "Captain Wren checks the tide before sailing near the reef."),
                    VocabularyWord(word: "hull", definition: "The main body of a ship that sits in the water.", exampleSentence: "There must be enough deep water beneath the hull.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Sailors use tide tables to predict when ocean water will be high or low, helping them navigate safely near reefs and shallow areas.", explanation: "Ignoring tide patterns has caused many real ships to run aground throughout history.")
                ],
                creativePrompt: "Draw the ship crossing the reef safely during high tide.",
                creativeResponseType: .drawing,
                storyEnding: "The new crew member learns that a simple chart of tide numbers can be the difference between a safe voyage and a shipwreck.",
                readingSkill: "Identify the main idea in a navigation-science passage",
                reflectionPrompt: "Why might ignoring a tide table be especially risky near a rocky reef?",
                hints: ["Reread Captain Wren's explanation about low and high tide", "Think about what happens to the reef at low tide"],
                commonMistakes: ["Thinking tides have no effect on how safely a ship can sail"],
                successCriteria: ["States the tide-table main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea of a nonfiction navigation passage"],
                activityFingerprint: "pirates.growing.tide-tables.main-idea",
                characterNames: ["Captain Wren"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Two Clues Behind the Hidden Cove",
                storyOpening: "Captain Wren reaches the island at last. She studies two map clues before she decides where to dig.",
                missionPrompt: "Figure out why Captain Wren dug near the three rocks instead of the faded mark.",
                readingPassage: """
                When Captain Wren finally reached the island marked on her weathered treasure map, she noticed the map's faded X sat directly on top of a description reading "where three tall rocks watch the sunrise." Captain Wren did not dig at the faded X right away. She compared two map details before she decided where to dig. First, she noticed the map's coastline shape did not quite match the island's actual coastline, suggesting the map's drawing had shifted slightly over its many years of age. Second, she found a cove on the eastern shore with exactly three tall standing rocks, matching the map's written description precisely, even though it sat a short distance from where the faded X appeared to point. Written descriptions on old maps were often more reliable than exact drawn positions, since ink could fade and paper could stretch unevenly over decades of folding and unfolding. Trusting the three-rock cove description over the shifted X, she ordered her crew to dig near the rocks instead of the map's faded mark. A few feet down, the crew uncovered a chest of old coins, confirming that Captain Wren's comparison of two clues had led her to the true treasure location.
                """,
                questions: [
                    mcq("Why did Captain Wren dig near the three rocks instead of the faded X?", ["The written cove description matched the island better than the shifted X", "The faded X was definitely the exact right spot", "The treasure map was completely useless"], "The written cove description matched the island better than the shifted X", "Captain Wren trusted the written description over the shifted X."),
                    mcq("Where did Captain Wren find three tall standing rocks?", ["In a cove on the eastern shore", "Under the faded X", "In the middle of the forest"], "In a cove on the eastern shore", "She found a cove on the eastern shore with exactly three tall standing rocks."),
                    mcq("What happened after the crew dug near the rocks?", ["They uncovered a chest of old coins", "The X on the map turned out to be exact", "The island had no treasure"], "They uncovered a chest of old coins", "The crew uncovered a chest of old coins near the rocks.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "weathered", definition: "A weathered map is worn or damaged by weather over time.", exampleSentence: "The weathered map had faded ink."),
                    VocabularyWord(word: "reliable", definition: "Reliable information can be trusted as accurate or correct.", exampleSentence: "The written description proved more reliable than the faded X.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Old maps can shift or fade over time, so written descriptions of landmarks are sometimes more reliable than exact drawn positions.", explanation: "Comparing multiple clues on a historic map can help find an accurate location despite aging or damage.")
                ],
                creativePrompt: "Write two sentences retelling why Captain Wren dug near the three rocks instead of the faded mark.",
                creativeResponseType: .shortText,
                storyEnding: "Captain Wren's comparison of two clues turns a faded, uncertain map into a genuine treasure discovery.",
                readingSkill: "Use map clues to explain a navigational conclusion",
                reflectionPrompt: "Why did the three-rock cove turn out to be the right place to dig?",
                hints: ["Look for the three-rock cove on the eastern shore", "Reread what the crew uncovered"],
                commonMistakes: ["Assuming the exact drawn X must always be the correct spot"],
                successCriteria: ["Explains Captain Wren's conclusion using two details from the passage"],
                learningObjectives: ["Draw a text-based conclusion using two pieces of evidence"],
                activityFingerprint: "pirates.confident.map-clues.conclusion",
                characterNames: ["Captain Wren"]
            )
        }
    }

    private static func piratesMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Gold Coins",
                storyOpening: "Captain Wren needs a careful count on the ship's deck.",
                missionPrompt: "Count the gold coins and compare the groups.",
                readingPassage: "Four gold coins shine in the chest. Two maps rest beside them. Captain Wren points and counts out loud.",
                problems: [
                    mcq("Captain Wren sees 2 gold coins, then 2 more join. How many gold coins in all?", ["3", "4", "5"], "4", "2 + 2 = 4.", subject: .math),
                    mcq("There are 2 maps on the left and 3 gold coins on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "3 is more than 2.", subject: .math),
                    mcq("Captain Wren counts 6, then one more. Which number comes next?", ["7", "5", "9"], "7", "6 + 1 = 7, so 7 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Captain Wren can count the gold coins.")],
                knowledgeFacts: [KnowledgeFact(fact: "Pirates in stories often count their treasure carefully before sailing anywhere new.")],
                creativePrompt: "Draw 4 gold coins in a chest.",
                storyEnding: "Captain Wren's coin count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 maps on the left and 3 gold coins on the right. Which side has more?",
                hints: ["Point to each coin", "Compare the two groups"],
                activityFingerprint: "pirates.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Maps for the Voyage",
                storyOpening: "Captain Wren sorts supplies before a busy voyage.",
                missionPrompt: "Add and subtract to finish the ship jobs.",
                readingPassage: "Captain Wren rolls up maps for the voyage ahead. She checks how many maps are packed and how many compasses still need testing.",
                problems: [
                    mcq("Captain Wren finds 6 maps. Then she finds 3 more. How many maps in all?", ["8", "9", "10"], "9", "6 + 3 = 9.", subject: .math),
                    mcq("A supply chest holds 10 compasses. Captain Wren hands 4 compasses to her crew. How many compasses are left?", ["5", "6", "7"], "6", "10 − 4 = 6.", subject: .math),
                    mcq("Captain Wren found 8 gold coins in a pouch. Then 5 coins slipped into a crack. How many coins does she have left?", ["2", "3", "4"], "3", "8 − 5 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total maps.")],
                knowledgeFacts: [KnowledgeFact(fact: "Checking supply numbers helps a voyage run smoothly.")],
                creativePrompt: "Draw 9 maps ready for the voyage.",
                storyEnding: "The ship is ready for the voyage.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A supply chest holds 10 compasses. Captain Wren hands 4 compasses to her crew. How many compasses are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "pirates.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Captain Wren",
                pronoun: "she",
                items: [
                    ("treasure chests", "in the hold"),
                    ("maps", "in the chart drawer"),
                    ("compasses", "on the helm shelf")
                ],
                packItem: "gold coins",
                purpose: "for the busy voyage"
            )
            return MathScene(
                title: "Groups on the Ship",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("Captain Wren stacks 3 equal groups of 4 treasure chests. How many treasure chests are there?", ["7", "12", "14"], "12", "3 × 4 = 12.", subject: .math),
                    mcq("A ship's plank is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten gold coins.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make it easier to check that the ship has enough supplies.")],
                creativePrompt: "Draw 3 equal groups of 4 treasure chests.",
                storyEnding: "The ship is ready for the busy voyage.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "Captain Wren stacks 3 equal groups of 4 treasure chests. How many treasure chests are there?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "pirates.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Voyage Day" : "Equal Shares of Gold Coins",
                storyOpening: "Captain Wren plans supplies for a full day of the voyage.",
                missionPrompt: multi ? "Solve each ship problem." : "Solve each ship problem carefully.",
                readingPassage: "Gold coins and supplies are shared with the crew during the long voyage.",
                problems: [
                    mcq("Captain Wren opens 3 chests with 8 gold coins in each chest. How many coins does she open?", ["16", "24", "32"], "24", "3 × 8 = 24.", subject: .math),
                    mcq("Captain Wren shares 18 gold coins among 3 crew members equally. How many does each crew member get?", ["5", "6", "9"], "6", "18 ÷ 3 = 6.", subject: .math),
                    mcq("One ship's plank is 15 centimeters long. Another is 9 centimeters long. How much longer is the first?", ["5", "6", "7"], "6", "15 − 9 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "fair", definition: "The same amount for everyone.", exampleSentence: "A fair share of coins is the same for each.")],
                knowledgeFacts: [KnowledgeFact(fact: "A compass shows sailors which direction they are going.")],
                creativePrompt: "Draw the treasure chests.",
                storyEnding: "Every crew member gets a fair share. Captain Wren celebrates a great voyage with her crew!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "A water barrel holds 4 cups of fresh water. Captain Wren adds 2 more cups. How many cups are in the barrel now?",
                hints: mathHints(level),
                activityFingerprint: "pirates.math.advancing.gold-coins"
            )
        }
    }

    // MARK: - Shared helpers (mirrors CuratedTopicLessonBank's private helpers)

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

    private static func mathHints(_ level: MathLevel) -> [String] {
        switch level {
        case .emerging: return ["Count on your fingers", "Point to each object"]
        case .developing: return ["Write the numbers", "Decide add or subtract"]
        case .secure: return ["Think about tens and ones", "Draw equal groups"]
        case .advancing: return ["Read the numbers carefully", "Choose add, subtract, multiply, or divide"]
        }
    }
}
