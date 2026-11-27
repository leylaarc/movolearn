import Foundation

extension CuratedTopicLessonBank {

    // MARK: - Ocean Animals (tide pools & reef neighbors — not shark/Willa clones)

    static func oceanAnimalsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Tide Pool Peek",
                storyOpening: "Kai leans over a quiet tide pool. What tiny neighbors live here?",
                missionPrompt: "Check what Kai finds in the cool pool.",
                readingPassage: "Kai sees a tiny crab by the stones. The crab hides under a rock. A green anemone waves softly. Cool water fills the pool.",
                questions: [
                    mcq("What does Kai see?", ["A tiny crab", "A dry desert lizard", "A flying hawk only"], "A tiny crab", "Kai sees a tiny crab."),
                    mcq("Where does the crab hide?", ["Under a rock", "In a tall tree", "On a sunny roof"], "Under a rock", "The crab hides under a rock."),
                    mcq("What waves softly?", ["A green anemone", "A loud truck", "A dry leaf pile"], "A green anemone", "A green anemone waves softly.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "tide pool", definition: "A small pool of ocean water left among rocks.", exampleSentence: "Kai peeks into a tide pool."),
                    VocabularyWord(word: "crab", definition: "A small animal with a hard shell and claws.", exampleSentence: "A tiny crab hides under a rock.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Tide pools hold small ocean animals when the tide goes out.", explanation: "Rocks trap seawater and create tiny habitats.")
                ],
                creativePrompt: "Draw Kai's tide pool with a crab under a rock and a green anemone.",
                creativeResponseType: .drawing,
                storyEnding: "Kai leaves the pool calm and full of tiny ocean life.",
                readingSkill: "Find concrete details in a short tide-pool story",
                reflectionPrompt: "What is one animal Kai saw in the pool?",
                hints: ["Find the crab sentence", "Look for anemone"],
                commonMistakes: ["Choosing land animals not in the story"],
                successCriteria: ["Names a tide-pool detail from the passage"],
                learningObjectives: ["Identify concrete details in a tide-pool passage"],
                activityFingerprint: "ocean-animals.k.tide-pool.detail",
                characterNames: ["Kai"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Dolphin Breath at the Surface",
                storyOpening: "Kai rides a small boat across the quiet bay.",
                missionPrompt: "Listen for dolphin clues. Answer with words from the story.",
                readingPassage: "Kai watches two dolphins rise beside the boat. They breathe at the surface, then dive again. Smooth gray backs shine in the sun. Kai writes in a wet notebook. He smiles as he counts three gentle leaps.",
                questions: [
                    mcq("How many dolphins does Kai watch?", ["Two", "Five", "Ten"], "Two", "Kai watches two dolphins."),
                    mcq("Where do the dolphins breathe?", ["At the surface", "Only deep under rock", "Only on dry sand"], "At the surface", "They breathe at the surface."),
                    mcq("What does Kai count?", ["Three gentle leaps", "Two quiet turns", "Five long rests"], "Three gentle leaps", "Kai counts three gentle leaps.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "surface", definition: "The top of the water.", exampleSentence: "Dolphins breathe at the surface."),
                    VocabularyWord(word: "dive", definition: "To go down under the water.", exampleSentence: "The dolphins dive again.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Dolphins are mammals that breathe air at the ocean surface.", explanation: "They rise to breathe, then can dive again.")
                ],
                creativePrompt: "Draw two dolphins rising beside a boat. Add three leap arcs.",
                creativeResponseType: .drawing,
                storyEnding: "Kai's notebook holds a true dolphin sighting from the bay.",
                readingSkill: "Recall key details from a dolphin passage",
                reflectionPrompt: "Why must dolphins come to the surface?",
                hints: ["Find breathe at the surface", "Count the leaps"],
                commonMistakes: ["Thinking dolphins never need air"],
                successCriteria: ["Uses a dolphin detail from the story"],
                learningObjectives: ["Recall details about dolphins breathing at the surface"],
                activityFingerprint: "ocean-animals.early.dolphin-surface.detail",
                characterNames: ["Kai"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Octopus in the Crevice",
                storyOpening: "Kai hopes to spot an octopus hiding in plain sight on a rocky reef walk.",
                missionPrompt: "Find the main idea about how an octopus stays safe. Use reef details.",
                readingPassage: "Kai spotted an octopus pressed into a narrow crevice along the rocky reef. Its skin shifted from speckled brown to a softer green that matched nearby seaweed. A guide explained that octopuses change color and texture to hide from hunters and to sneak up on crabs. Kai watched one arm feel ahead before the animal slipped deeper into the crack. Camouflage and careful movement help an octopus stay safe in a busy reef.",
                questions: [
                    mcq("What is the main idea?", ["Camouflage and careful movement help an octopus stay safe", "Octopuses never hide on reefs", "Octopuses only live in dry deserts"], "Camouflage and careful movement help an octopus stay safe", "The passage ends with that clear lesson."),
                    mcq("How did the octopus skin change?", ["From speckled brown to a softer green", "From bright orange to pitch black", "From wet to completely dry"], "From speckled brown to a softer green", "Its skin shifted to match nearby seaweed."),
                    mcq("Why do octopuses change color and texture?", ["To hide from hunters and sneak up on crabs", "To look more like a sea turtle", "To dry out faster on land"], "To hide from hunters and sneak up on crabs", "The guide explained both hiding and hunting uses.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "camouflage", definition: "Colors or patterns that help an animal blend in.", exampleSentence: "Octopus camouflage matches the reef."),
                    VocabularyWord(word: "crevice", definition: "A narrow crack in rock.", exampleSentence: "The octopus slipped into a crevice.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Octopuses can change color and texture to blend into the reef.", explanation: "Camouflage helps them hide and hunt.")
                ],
                creativePrompt: "Draw an octopus in a crevice that matches seaweed colors. Label camouflage.",
                creativeResponseType: .drawing,
                storyEnding: "Kai leaves knowing a real octopus safety strategy — not just a fun reef visit.",
                readingSkill: "Identify the main idea in an octopus camouflage passage",
                reflectionPrompt: "Which octopus clue would help you spot one on a real reef walk?",
                hints: ["Reread the last sentence", "Find color and texture"],
                commonMistakes: ["Missing the camouflage main idea"],
                successCriteria: ["States the safety main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea about octopus camouflage"],
                activityFingerprint: "ocean-animals.growing.octopus-camouflage.main-idea",
                characterNames: ["Kai"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Neighbors on One Reef",
                storyOpening: "Kai studies how many animals share one reef home from a glass-bottom boat.",
                missionPrompt: "Use the clues to infer why so many ocean animals can live together on one reef.",
                readingPassage: """
                Kai's guide pointed out that a single reef is like a busy neighborhood with many jobs. Parrotfish scrape algae from coral. This keeps the reef from being smothered. Cleaner shrimp nibble tiny pests off larger fish that visit their station. Sea turtles glide through to rest and feed on seagrass nearby. Kai inferred that the reef works because animals use different foods and spaces instead of competing for only one resource. When one neighbor disappears, the whole balance can tip. Kai's notebook began to feel like a map of living teamwork — not just a list of pretty animals.
                """,
                questions: [
                    mcq("What can you infer about why many animals share one reef?", ["They use different foods and spaces", "They all eat only the same coral rock", "They never interact at all"], "They use different foods and spaces", "Kai inferred different foods and spaces reduce competition."),
                    mcq("How do parrotfish help the reef?", ["They scrape algae so coral is not smothered", "They remove all the water", "They build dry sandcastles only"], "They scrape algae so coral is not smothered", "Parrotfish scrape algae from coral so the reef stays healthy."),
                    mcq("What do cleaner shrimp do?", ["Nibble tiny pests off larger fish", "Chase turtles onto land", "Chase crabs onto dry sand"], "Nibble tiny pests off larger fish", "Cleaner shrimp nibble pests at their station.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "balance", definition: "A steady mix where parts work well together.", exampleSentence: "Reef balance depends on many animal neighbors."),
                    VocabularyWord(word: "resource", definition: "Something living things need, such as food or space.", exampleSentence: "Animals share different resources on a reef.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Reef animals can share one home by using different foods and spaces.", explanation: "Diverse roles help keep coral reefs in balance.")
                ],
                creativePrompt: "Write three sentences naming two reef neighbors and how their jobs differ.",
                creativeResponseType: .shortText,
                storyEnding: "Kai's reef map now shows teamwork among ocean animals — not a shark-only story.",
                readingSkill: "Infer ecosystem roles from reef neighbor details",
                reflectionPrompt: "Which reef neighbor's job from the story would you want to study first?",
                hints: ["Compare parrotfish with cleaner shrimp", "Reread the clue about foods and spaces"],
                commonMistakes: ["Treating the reef as one animal with one job"],
                successCriteria: ["Explains shared reef life using passage evidence"],
                learningObjectives: ["Infer why diverse ocean animals can share a reef"],
                activityFingerprint: "ocean-animals.confident.reef-neighbors.inference",
                characterNames: ["Kai"]
            )
        }
    }

    static func oceanAnimalsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Tide-Pool Friends",
                storyOpening: "Kai needs a careful count at the tide pool.",
                missionPrompt: "Count the animals and compare the groups.",
                readingPassage: "Five hermit crabs line the rock edge. Two starfish cling lower down. Kai points and counts out loud.",
                problems: [
                    mcq("Kai sees 2 crabs, then 3 more join. How many crabs in all?", ["4", "5", "6"], "5", "2 + 3 = 5.", subject: .math),
                    mcq("There are 2 starfish on the left and 4 crabs on the right. Which side has more animals?", ["Right", "Left", "Same"], "Right", "4 is more than 2.", subject: .math),
                    mcq("Kai counts 5, then one more. Which number comes next?", ["6", "4", "8"], "6", "5 + 1 = 6, so 6 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Kai can count the crabs.")],
                knowledgeFacts: [KnowledgeFact(fact: "Tide-pool watchers count animals to learn what lives between the rocks.")],
                creativePrompt: "Draw 5 hermit crabs.",
                storyEnding: "Kai's tide-pool count is complete!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 starfish on the left and 4 crabs on the right. Which side has more animals?",
                hints: ["Point to each animal", "Compare the two groups"],
                activityFingerprint: "ocean-animals.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Shells for the Beach Table",
                storyOpening: "Kai sorts empty shells after a beach walk.",
                missionPrompt: "Add and subtract to finish the shell jobs.",
                readingPassage: "Kai sorts clam shells and sand dollars into piles for the beach table. Before the tide turns, Kai checks each total.",
                problems: [
                    mcq("Kai finds 7 clam shells. Then Kai finds 4 more. How many clam shells in all?", ["10", "11", "12"], "11", "7 + 4 = 11.", subject: .math),
                    mcq("A tray holds 12 sand dollars. Kai shares 5 with friends. How many sand dollars are left?", ["6", "7", "8"], "7", "12 − 5 = 7.", subject: .math),
                    mcq("Kai has 9 spiral shells. A friend has 6. How many more spiral shells does Kai have?", ["2", "3", "4"], "3", "9 − 6 = 3.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total shells.")],
                knowledgeFacts: [KnowledgeFact(fact: "Seashells on the shore can show which ocean animals live nearby.")],
                creativePrompt: "Draw 11 shells in two piles that add to the total.",
                storyEnding: "The beach table shells match Kai's numbers.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A tray holds 12 sand dollars. Kai shares 5 with friends. How many sand dollars are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "ocean-animals.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Kai",
                pronoun: "he",
                items: [
                    ("dolphin tags", "in the blue tray"),
                    ("turtle tags", "in the green tray"),
                    ("octopus tags", "in the purple tray")
                ],
                packItem: "reef tags",
                packCount: 30,
                purpose: "for the museum corner"
            )
            return MathScene(
                title: "Groups of Reef Specimens",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("A tray has 4 rows of 5 turtle tags. How many tags are there?", ["9", "20", "25"], "20", "4 × 5 = 20.", subject: .math),
                    mcq("A kelp strip is 18 centimeters long. Another is 11 centimeters long. How much longer is the first?", ["6", "7", "8"], "7", "18 − 11 = 7 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten tags.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make ocean samples easier to display.")],
                creativePrompt: "Draw 4 rows of 5 turtle tags.",
                storyEnding: "The museum corner is ready for visitors.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "A tray has 4 rows of 5 turtle tags. How many tags are there?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "ocean-animals.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Ocean Sighting Day" : "Equal Shares of Shell Samples",
                storyOpening: "Kai plans supplies for an ocean-sighting day.",
                missionPrompt: multi ? "Solve each bay problem." : "Solve each bay problem carefully.",
                readingPassage: "Shell samples and tide charts help the team record ocean-animal sightings.",
                problems: [
                    mcq("Kai has 4 trays with 6 shell samples in each tray. How many samples in all?", ["18", "24", "30"], "24", "4 × 6 = 24.", subject: .math),
                    mcq("Kai shares 24 shell samples among 4 friends equally. How many does each friend get?", ["5", "6", "8"], "6", "24 ÷ 4 = 6.", subject: .math),
                    mcq("A rope is 16 centimeters long. Another is 9. How much longer is the first?", ["6", "7", "8"], "7", "16 − 9 = 7.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "difference", definition: "How much more one number is than another.", exampleSentence: "The difference tells how much longer the first rope is.")],
                knowledgeFacts: [KnowledgeFact(fact: "A tide chart shows when the ocean will be high or low.")],
                creativePrompt: "Draw the shell-sample trays.",
                storyEnding: "The sighting supplies are ready!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "Kai has 4 trays with 6 shell samples in each tray. How many samples in all?",
                hints: mathHints(level),
                activityFingerprint: "ocean-animals.math.advancing.packs"
            )
        }
    }

    // MARK: - Planets (solar-system worlds — not Nova Moon-path clones)

    static func planetsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Earth Is Our Planet",
                storyOpening: "Remy stops in front of a bright solar-system poster.",
                missionPrompt: "Check what Remy learns about Earth.",
                readingPassage: "Remy taps the blue-and-green world on the poster. That world is our home planet, Earth. Land and blue oceans cover it, and soft clouds float high above. A curved arrow shows Earth going around the Sun.",
                questions: [
                    mcq("Which world does Remy tap?", ["Earth", "The Moon", "The Sun"], "Earth", "Remy taps Earth, our home planet."),
                    mcq("What covers Earth?", ["Land and blue oceans", "Only dry sand", "Only clouds"], "Land and blue oceans", "Land and blue oceans cover Earth."),
                    mcq("What does the curved arrow show?", ["Earth going around the Sun", "The Sun going around Earth", "Earth going around the Moon"], "Earth going around the Sun", "The arrow shows Earth going around the Sun.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "planet", definition: "A large world that moves around a star.", exampleSentence: "Earth is our planet."),
                    VocabularyWord(word: "ocean", definition: "A huge body of salt water.", exampleSentence: "Earth has blue oceans.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Earth has one moon.", explanation: "The Moon travels around Earth.")
                ],
                creativePrompt: "Draw Earth with land, blue oceans, and clouds. Label Earth.",
                creativeResponseType: .drawing,
                storyEnding: "Remy can point to Earth on the poster with confidence.",
                readingSkill: "Find concrete details about Earth",
                reflectionPrompt: "Where do the soft clouds float?",
                hints: ["Find land and oceans", "Look for the Sun"],
                commonMistakes: ["Choosing objects that are not planets"],
                successCriteria: ["Names an Earth detail from the passage"],
                learningObjectives: ["Identify concrete details about planet Earth"],
                activityFingerprint: "planets.k.earth-home.detail",
                characterNames: ["Remy"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Rocky Worlds and Giant Worlds",
                storyOpening: "Remy looks at the planets. Can you help him decide which are rocky and which are giant?",
                missionPrompt: "Decide which planets are rocky, and which are giant.",
                readingPassage: "Remy places Mercury, Venus, Earth, and Mars in the rocky tray. Those planets have solid surfaces you could stand on. Jupiter and Saturn go in the giant tray because they are huge and made mostly of gas. Remy labels each tray before he shares with the class.",
                questions: [
                    mcq("Which planets go in the rocky tray?", ["Mercury, Venus, Earth, and Mars", "Only Jupiter and Saturn", "Only the Sun"], "Mercury, Venus, Earth, and Mars", "Those four are placed in the rocky tray."),
                    mcq("What do rocky planets have?", ["Solid surfaces", "Only soft clouds and no rock", "Nearby moons instead of rock"], "Solid surfaces", "Rocky planets have solid surfaces."),
                    mcq("Why do Jupiter and Saturn go in the giant tray?", ["They are huge and made mostly of gas", "They are tiny pebbles", "They are Earth's oceans"], "They are huge and made mostly of gas", "The giant tray is for huge gas worlds.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "rocky", definition: "Made mostly of solid rock.", exampleSentence: "Earth is a rocky planet."),
                    VocabularyWord(word: "giant", definition: "Very large.", exampleSentence: "Jupiter is a giant planet.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Some planets are rocky with solid surfaces; others are giant worlds made mostly of gas.", explanation: "Sorting planets by type helps compare solar-system neighbors.")
                ],
                creativePrompt: "Draw two trays labeled rocky and giant. Place at least one planet name in each.",
                creativeResponseType: .drawing,
                storyEnding: "Remy's class can now sort planets by type, not just by pretty colors.",
                readingSkill: "Recall planet-type details from the passage",
                reflectionPrompt: "Which tray would you put Earth in, and why?",
                hints: ["Find the rocky tray list", "Look for mostly of gas"],
                commonMistakes: ["Mixing rocky and giant planet traits"],
                successCriteria: ["Uses a planet-type detail from the story"],
                learningObjectives: ["Recall differences between rocky and giant planets"],
                activityFingerprint: "planets.early.rocky-giant.detail",
                characterNames: ["Remy"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Why Venus Looks Bright",
                storyOpening: "Remy looks up at dusk and wonders why Venus shines so brightly.",
                missionPrompt: "Figure out why Venus looks so bright in the evening sky.",
                readingPassage: "Remy noticed Venus glowing like a steady lamp above the trees at dusk. A guide explained that Venus is covered in thick clouds that reflect a lot of sunlight back toward Earth. Venus is also one of our closest planetary neighbors, so its reflected light can look especially bright. Remy compared that glow with tiny distant stars that look fainter. The main lesson was clear: cloud cover and closeness help Venus shine so boldly from our view.",
                questions: [
                    mcq("What is the main idea?", ["Cloud cover and closeness help Venus look very bright", "Venus is bright because it is a tiny flashlight on Earth", "Venus never reflects sunlight"], "Cloud cover and closeness help Venus look very bright", "The passage ends with that clear lesson."),
                    mcq("What do Venus's thick clouds do?", ["Reflect a lot of sunlight toward Earth", "Make Venus spin the opposite way forever", "Turn Venus into a rocky desert moon"], "Reflect a lot of sunlight toward Earth", "Thick clouds reflect sunlight."),
                    mcq("Why can Venus look especially bright to us?", ["It is one of our closest planetary neighbors", "It is farther than every star", "It sits inside Earth's oceans"], "It is one of our closest planetary neighbors", "Closeness helps its reflected light look bright.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "reflect", definition: "To bounce light back.", exampleSentence: "Venus's clouds reflect sunlight."),
                    VocabularyWord(word: "neighbor", definition: "Something nearby.", exampleSentence: "Venus is a close planetary neighbor.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Venus can look very bright because thick clouds reflect sunlight and the planet is relatively close to Earth.", explanation: "Brightness in the sky depends on reflection and distance.")
                ],
                creativePrompt: "Draw evening Venus above trees with arrows for sunlight reflecting toward Earth.",
                creativeResponseType: .drawing,
                storyEnding: "Remy now explains Venus's glow with real planet science.",
                readingSkill: "Identify the main idea about Venus's brightness",
                reflectionPrompt: "Name two clues from the story that help Venus look bright.",
                hints: ["Reread the last sentence", "Find reflect sunlight"],
                commonMistakes: ["Thinking Venus makes its own star-like fire"],
                successCriteria: ["States the brightness main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea about why Venus looks bright"],
                activityFingerprint: "planets.growing.venus-bright.main-idea",
                characterNames: ["Remy"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "One Sun, Many Paths",
                storyOpening: "Remy lays yarn loops around a paper Sun. What keeps planets on their paths?",
                missionPrompt: "Find out what keeps planets traveling on curved paths around the Sun.",
                readingPassage: """
                Remy laid yarn loops around a bright paper Sun. Inner planets sat on smaller loops, while outer giants needed longer paths. The teacher explained that the Sun's gravity pulls on every planet, and each planet's forward motion keeps it from falling straight into the Sun. Remy inferred that planets are not stuck in place; they travel on curved paths that balance pull and motion. When Remy moved Jupiter's loop farther out, the journey around the Sun took longer in the model. That change helped Remy see why outer planets need more time to complete one trip.
                """,
                questions: [
                    mcq("What can you infer keeps planets on curved paths?", ["The Sun's gravity plus each planet's forward motion", "Sticky tape on the classroom floor only", "Ocean waves pushing each planet"], "The Sun's gravity plus each planet's forward motion", "Pull and motion together make curved orbits."),
                    mcq("What happened when Remy moved Jupiter's loop farther out?", ["The journey around the Sun took longer in the model", "Jupiter became an inner rocky planet", "The Sun disappeared"], "The journey around the Sun took longer in the model", "Moving the loop farther out made the trip longer in the model."),
                    mcq("Are planets stuck in one fixed spot?", ["No; they travel on curved paths", "Yes; they never move", "They only hop between stars each minute"], "No; they travel on curved paths", "Remy inferred planets travel on curved paths.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "orbit", definition: "A curved path around another object.", exampleSentence: "Earth's orbit goes around the Sun."),
                    VocabularyWord(word: "gravity", definition: "A pull between objects with mass.", exampleSentence: "The Sun's gravity pulls on the planets.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Planets orbit the Sun on curved paths shaped by gravity and forward motion.", explanation: "Outer planets on longer paths take more time to complete one trip.")
                ],
                creativePrompt: "Write three sentences explaining why a farther planet path takes longer in Remy's model.",
                creativeResponseType: .shortText,
                storyEnding: "Remy's yarn Sun model shows a solar system of moving worlds — not a single Moon landing tale.",
                readingSkill: "Infer orbital motion from planet-path evidence",
                reflectionPrompt: "Which planet path would you model next, and what would you measure?",
                hints: ["Compare inner and outer loops", "Reread gravity plus forward motion"],
                commonMistakes: ["Thinking planets sit still beside the Sun"],
                successCriteria: ["Explains curved orbits using passage evidence"],
                learningObjectives: ["Infer how gravity and motion shape planet orbits"],
                activityFingerprint: "planets.confident.orbits.inference",
                characterNames: ["Remy"]
            )
        }
    }

    static func planetsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Planets",
                storyOpening: "Remy needs a careful count of the planets.",
                missionPrompt: "Count the planets and compare the groups.",
                readingPassage: "Eight planets orbit the Sun. Remy puts 3 planets on the left. He puts 5 planets on the right. Remy points and counts.",
                problems: [
                    mcq("Remy lines up 4 rocky planets and 4 giant planets. How many planets in all?", ["6", "8", "10"], "8", "4 + 4 = 8.", subject: .math),
                    mcq("There are 3 planets on the left and 5 planets on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "5 is more than 3.", subject: .math),
                    mcq("There are 7 planets in a line. 1 more planet joins the line. How many planets in all?", ["8", "6", "10"], "8", "7 + 1 = 8.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "planet", definition: "A large world that orbits a star.", exampleSentence: "Earth is a planet.")],
                knowledgeFacts: [KnowledgeFact(fact: "Our solar system has eight planets. Four are rocky, and four are giant.")],
                creativePrompt: "Draw 8 planets around the Sun.",
                storyEnding: "Remy's count matches the eight planets!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 3 planets on the left and 5 planets on the right. Which side has more?",
                hints: ["Point to each planet", "Compare the two groups"],
                activityFingerprint: "planets.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Planets and Their Moons",
                storyOpening: "Remy names the planets and the moons that travel with them.",
                missionPrompt: "Add and subtract to finish the planet count.",
                readingPassage: "Eight planets orbit the Sun. Four are rocky and four are giant. Earth has 1 moon. Mars has 2 moons. Jupiter has 4 big moons.",
                problems: [
                    mcq("Remy lists 4 rocky planets and 4 giant planets. How many planets in all?", ["6", "8", "10"], "8", "4 + 4 = 8.", subject: .math),
                    mcq("There are 8 planets. Remy has named 3. How many planets are left to name?", ["4", "5", "6"], "5", "8 − 3 = 5.", subject: .math),
                    mcq("Jupiter has 4 big moons. Mars has 2 moons. How many of these moons in all?", ["5", "6", "7"], "6", "4 + 2 = 6.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "orbit", definition: "The path a planet or moon takes around another world.", exampleSentence: "Earth's orbit goes around the Sun.")],
                knowledgeFacts: [KnowledgeFact(fact: "There are eight planets. Earth has one moon, and Mars has two moons.")],
                creativePrompt: "Draw the 8 planets. Add Earth's moon beside Earth.",
                storyEnding: "The planet and moon count is complete.",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "There are 8 planets. Remy has named 3. How many planets are left to name?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "planets.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Remy",
                pronoun: "he",
                items: [
                    ("orbit rings", "in the ring box"),
                    ("planet models", "in the model tray"),
                    ("moon models", "on the chart")
                ],
                packItem: "moon models",
                purpose: "for the model"
            )
            return MathScene(
                title: "Groups of Orbit Rings",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("A chart has 5 rows of 3 moons. How many moons are there?", ["8", "15", "20"], "15", "5 × 3 = 15.", subject: .math),
                    mcq("An orbit ribbon is 22 centimeters long. Another is 14 centimeters long. How much longer is the first?", ["7", "8", "9"], "8", "22 − 14 = 8 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of moons.")],
                knowledgeFacts: [KnowledgeFact(fact: "Many planets have moons. Earth has one moon.")],
                creativePrompt: "Draw 5 rows of 3 moons.",
                storyEnding: "The orbit model is ready.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "A chart has 5 rows of 3 moons. How many moons are there?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "planets.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Planets Around the Sun" : "Eight Planets",
                storyOpening: "Remy lines up the eight planets for a solar-system model.",
                missionPrompt: multi ? "Solve each planet problem." : "Solve each planet problem carefully.",
                readingPassage: "Rocky planets have solid ground. Giant planets are made mostly of gas. There are 4 rocky planets and 4 giant planets.",
                problems: [
                    mcq("Remy sets out 2 rows with 4 planets in each row. How many planets are there?", ["6", "8", "10"], "8", "2 × 4 = 8.", subject: .math),
                    mcq("Remy shares 8 planets between 2 groups equally. How many planets does each group get?", ["3", "4", "6"], "4", "8 ÷ 2 = 4.", subject: .math),
                    mcq("A yarn orbit is 19 centimeters long. Another is 12. How much longer is the first?", ["6", "7", "8"], "7", "19 − 12 = 7.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "orbit", definition: "The curved path a planet takes around the Sun.", exampleSentence: "Each planet has its own orbit.")],
                knowledgeFacts: [KnowledgeFact(fact: "There are eight planets. Four are rocky and four are giant.")],
                creativePrompt: "Draw 2 rows with 4 planets in each row.",
                storyEnding: "The eight planets are lined up in the model!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "Remy sets out 2 rows with 4 planets in each row. How many planets are there?",
                hints: mathHints(level),
                activityFingerprint: "planets.math.advancing.packs"
            )
        }
    }

    // MARK: - Rockets (launch & thrust — not Moon-path story clones)

    static func rocketsReading(_ level: ReadingLevel) -> ReadingPack {
        switch level {
        case .beginner:
            return ReadingPack(
                title: "Countdown to Launch",
                storyOpening: "Tess stands by a small model rocket pad. She is ready for countdown.",
                missionPrompt: "Check what Tess does before the rocket lifts off.",
                readingPassage: "Tess checks the rocket one more time. She counts down from five. Then the rocket lifts off. Soft smoke floats near the pad.",
                questions: [
                    mcq("What does Tess check?", ["The rocket", "A lunchbox only", "A picnic basket only"], "The rocket", "Tess checks the rocket."),
                    mcq("What does Tess count down from?", ["Five", "Twenty", "Fifty with no countdown"], "Five", "She counts down from five."),
                    mcq("What lifts off?", ["The rocket", "A parked bike", "A quiet pillow"], "The rocket", "The rocket lifts off.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "launch", definition: "To send a rocket upward.", exampleSentence: "Tess is ready for launch."),
                    VocabularyWord(word: "countdown", definition: "Counting backward before something starts.", exampleSentence: "The countdown goes five, four, three.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "A countdown helps a launch team get ready before a rocket lifts off.", explanation: "Checks and counting prepare a safe start.")
                ],
                creativePrompt: "Draw Tess's rocket lifting off with a countdown bubble: 5, 4, 3.",
                creativeResponseType: .drawing,
                storyEnding: "Tess's model launch finishes with a careful countdown.",
                readingSkill: "Find concrete details in a short launch story",
                reflectionPrompt: "What number did Tess start counting from?",
                hints: ["Find checks the rocket", "Look for countdown"],
                commonMistakes: ["Choosing objects that never launch"],
                successCriteria: ["Names a launch detail from the passage"],
                learningObjectives: ["Identify concrete details in a rocket launch passage"],
                activityFingerprint: "rockets.k.countdown.detail",
                characterNames: ["Tess"]
            )
        case .earlyReader:
            return ReadingPack(
                title: "Thrust Pushes Up",
                storyOpening: "Tess leans in close. What makes a rocket rise?",
                missionPrompt: "Learn what thrust is, and when the rocket climbs.",
                readingPassage: "Tess's coach shows a diagram of hot gas shooting downward. That downward push makes an upward push called thrust. Tess feels the model shake as thrust builds. The rocket climbs when thrust is strong enough to lift its weight.",
                questions: [
                    mcq("What is the upward push called?", ["Thrust", "Only soft whispering", "A sleepy nap"], "Thrust", "The upward push is called thrust."),
                    mcq("Which way does the hot gas shoot in the diagram?", ["Downward", "Only sideways forever", "Straight into the ground with no push"], "Downward", "Hot gas shoots downward."),
                    mcq("When does the rocket climb?", ["When thrust can lift its weight", "When it has no thrust at all", "When it stays glued to the pad"], "When thrust can lift its weight", "It climbs when thrust lifts its weight.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "thrust", definition: "The push that lifts a rocket upward.", exampleSentence: "Thrust helps the rocket climb."),
                    VocabularyWord(word: "weight", definition: "How heavy something is.", exampleSentence: "Thrust must lift the rocket's weight.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Rocket thrust is an upward push that comes from gas shooting downward.", explanation: "Strong enough thrust lifts the rocket's weight.")
                ],
                creativePrompt: "Draw a rocket with arrows: gas down, thrust up.",
                creativeResponseType: .drawing,
                storyEnding: "Tess can explain thrust without mixing it up with a Moon walking story.",
                readingSkill: "Recall thrust details from the passage",
                reflectionPrompt: "Why must gas shoot downward for a rocket to rise?",
                hints: ["Find the word thrust", "Look for lift its weight"],
                commonMistakes: ["Thinking rockets rise with no push"],
                successCriteria: ["Uses a thrust detail from the story"],
                learningObjectives: ["Recall how thrust lifts a rocket"],
                activityFingerprint: "rockets.early.thrust.detail",
                characterNames: ["Tess"]
            )
        case .growingReader:
            return ReadingPack(
                title: "Stages Lighten the Climb",
                storyOpening: "Tess watches a big rocket on the hangar screen. Why does it leave empty parts behind?",
                missionPrompt: "Figure out why rockets climb in stages.",
                readingPassage: "Tess watched a rocket climb in stages on the hangar screen. The first stage gave a powerful push, then dropped away when its fuel was used. A lighter upper stage fired next and continued the journey. A guide explained that dropping empty tanks reduces weight so later engines do not waste energy. Tess realized the main idea: stages help a rocket climb higher by shedding weight it no longer needs.",
                questions: [
                    mcq("What is the main idea?", ["Stages help a rocket climb by shedding weight it no longer needs", "Rockets never drop any parts", "Stages only decorate the paint"], "Stages help a rocket climb by shedding weight it no longer needs", "The passage ends with that clear idea."),
                    mcq("What happens when the first stage's fuel is used?", ["It drops away", "It turns into a planet", "It fills with ocean water"], "It drops away", "The first stage drops away when fuel is used."),
                    mcq("Why reduce weight with empty tanks gone?", ["So later engines do not waste energy", "So the rocket becomes heavier on purpose", "So countdown numbers reverse forever"], "So later engines do not waste energy", "Dropping empty tanks reduces wasted energy.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "stage", definition: "A section of a rocket that fires, then may drop away.", exampleSentence: "The first stage gives a powerful push."),
                    VocabularyWord(word: "fuel", definition: "What an engine burns to make thrust.", exampleSentence: "Empty fuel tanks can be dropped away.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Multi-stage rockets drop empty sections to reduce weight for the climb ahead.", explanation: "Shedding unused mass helps later stages use energy wisely.")
                ],
                creativePrompt: "Draw a two-stage rocket: first stage dropping away, upper stage still firing.",
                creativeResponseType: .drawing,
                storyEnding: "Tess now explains stages as smart weight-shedding — not just fireworks.",
                readingSkill: "Identify the main idea about rocket stages",
                reflectionPrompt: "Which stage detail would you teach a younger flyer first?",
                hints: ["Reread the main idea sentence", "Find empty tanks"],
                commonMistakes: ["Thinking stages are only for looks"],
                successCriteria: ["States the stages main idea with a supporting detail"],
                learningObjectives: ["Identify the main idea about multi-stage rockets"],
                activityFingerprint: "rockets.growing.stages.main-idea",
                characterNames: ["Tess"]
            )
        case .confidentReader:
            return ReadingPack(
                title: "Checklist Before Ignition",
                storyOpening: "Tess joins launch-control practice. Is the team truly ready?",
                missionPrompt: "Figure out why launch teams trust checklists more than guesses.",
                readingPassage: """
                In the practice room, Tess followed a launch checklist line by line. Fuel levels looked steady, the pad was clear, and the weather sensor reported calm wind. One warning light blinked for a loose hatch sensor, so Tess compared that clue with a second reading before calling a hold. The director explained that ignition only happens when required checks agree. Tess inferred that careful teams treat a single green light as incomplete evidence. Cross-checking protects the rocket, the crew, and the people watching nearby.
                """,
                questions: [
                    mcq("What can you infer about launch readiness?", ["Teams need required checks to agree before ignition", "One green light is always enough forever", "Weather never matters on launch day"], "Teams need required checks to agree before ignition", "Ignition happens when required checks agree."),
                    mcq("Why did Tess call a hold?", ["The hatch-sensor warning needed a second reading", "The rocket had already landed on Mars", "The countdown finished with no checklist"], "The hatch-sensor warning needed a second reading", "Tess compared the warning with a second reading."),
                    mcq("What do checklists protect?", ["The rocket, the crew, and nearby people", "Only the paint color", "Only forgotten lunch bags"], "The rocket, the crew, and nearby people", "Cross-checking protects the rocket, the crew, and the people watching nearby.")
                ],
                vocabularyWords: [
                    VocabularyWord(word: "checklist", definition: "A list of required steps to finish before a job.", exampleSentence: "Tess follows the launch checklist."),
                    VocabularyWord(word: "ignition", definition: "The moment engines start with fire and thrust.", exampleSentence: "Ignition waits until checks agree.")
                ],
                knowledgeFacts: [
                    KnowledgeFact(fact: "Launch teams use checklists and cross-checks so ignition happens only when systems agree.", explanation: "Multiple agreeing clues are safer than one green light alone.")
                ],
                creativePrompt: "Write three sentences about a checklist item you would verify before ignition.",
                creativeResponseType: .shortText,
                storyEnding: "Tess trusts evidence over guesses — a rocket lesson distinct from planet tours.",
                readingSkill: "Infer why evidence and checklists guide launch decisions",
                reflectionPrompt: "Which checklist clue from the story would make you wait?",
                hints: ["Compare one light with agreeing checks", "Find why Tess called a hold"],
                commonMistakes: ["Launching on a single unchecked green light"],
                successCriteria: ["Explains checklist safety using passage evidence"],
                learningObjectives: ["Infer why launch teams cross-check before ignition"],
                activityFingerprint: "rockets.confident.checklist.inference",
                characterNames: ["Tess"]
            )
        }
    }

    static func rocketsMath(_ level: MathLevel, reading: ReadingLevel) -> MathScene {
        switch level {
        case .emerging:
            return MathScene(
                title: "Count the Launch Tools",
                storyOpening: "Tess needs a careful count on the pad table.",
                missionPrompt: "Count the tools and compare the groups.",
                readingPassage: "Seven wrenches rest near the model. Two helmets wait in a box. Tess points and counts.",
                problems: [
                    mcq("Tess sees 3 wrenches, then 4 more join. How many wrenches in all?", ["6", "7", "8"], "7", "3 + 4 = 7.", subject: .math),
                    mcq("There are 2 helmets on the left and 5 wrenches on the right. Which side has more?", ["Right", "Left", "Same"], "Right", "5 is more than 2.", subject: .math),
                    mcq("Tess counts 8, then one more. Which number comes next?", ["9", "7", "11"], "9", "8 + 1 = 9, so 9 comes next.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "count", definition: "To find how many.", exampleSentence: "Tess can count the wrenches.")],
                knowledgeFacts: [KnowledgeFact(fact: "Launch teams count tools so nothing important is missing.")],
                creativePrompt: "Draw 7 wrenches.",
                storyEnding: "Tess's tool count matches the pad table!",
                mathSkill: "Number recognition and counting",
                reflectionPrompt: "There are 2 helmets on the left and 5 wrenches on the right. Which side has more?",
                hints: ["Point to each tool", "Compare the two groups"],
                activityFingerprint: "rockets.math.emerging.count"
            )
        case .developing:
            return MathScene(
                title: "Patches for the Rocket Table",
                storyOpening: "Tess sorts mission patches before launch practice.",
                missionPrompt: "Add and subtract to finish the rocket jobs.",
                readingPassage: "Tess counts star patches and moon patches on the table. Tess checks how many are ready for the rocket project.",
                problems: [
                    mcq("Tess finds 9 star patches. Then Tess finds 6 more. How many patches in all?", ["14", "15", "16"], "15", "9 + 6 = 15.", subject: .math),
                    mcq("A box holds 14 moon patches. Tess uses 5. How many patches are left?", ["8", "9", "10"], "9", "14 − 5 = 9.", subject: .math),
                    mcq("Tess has 12 red rocket patches. A friend has 8. How many more patches does Tess have?", ["3", "4", "5"], "4", "12 − 8 = 4.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "total", definition: "How many in all.", exampleSentence: "Find the total patches.")],
                knowledgeFacts: [KnowledgeFact(fact: "Rocket teams count supplies so each person has the right tools.")],
                creativePrompt: "Draw 15 star patches in two groups that add to the total.",
                storyEnding: "The rocket patches are ready for practice!",
                mathSkill: "Addition and subtraction",
                reflectionPrompt: "A box holds 14 moon patches. Tess uses 5. How many patches are left?",
                hints: ["Write the numbers", "Decide add or subtract"],
                activityFingerprint: "rockets.math.developing.add-sub"
            )
        case .secure:
            let sort = groupingSortCopy(
                character: "Tess",
                pronoun: "she",
                items: [
                    ("rocket cards", "in the card bin"),
                    ("countdown chips", "in the chip cup"),
                    ("mission patches", "on the launch board")
                ],
                packItem: "countdown chips",
                packCount: 50,
                purpose: "for the launch display"
            )
            return MathScene(
                title: "Groups of Rocket Cards",
                storyOpening: sort.opening,
                missionPrompt: sort.mission,
                readingPassage: sort.passage,
                problems: [
                    sort.groupingQuestion,
                    mcq("A tray has 3 rows of 6 rocket cards. How many cards are there?", ["9", "18", "24"], "18", "3 × 6 = 18.", subject: .math),
                    mcq("A model fin is 25 centimeters long. Another is 17 centimeters long. How much longer is the first?", ["7", "8", "9"], "8", "25 − 17 = 8 centimeters.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "group", definition: "A set of things counted together.", exampleSentence: "Make groups of ten chips.")],
                knowledgeFacts: [KnowledgeFact(fact: "Equal groups make rocket displays easier to check.")],
                creativePrompt: "Draw 3 rows of 6 rocket cards.",
                storyEnding: "The launch display is ready.",
                mathSkill: "Place value and equal groups",
                reflectionPrompt: "A tray has 3 rows of 6 rocket cards. How many cards are there?",
                hints: ["Think about tens and ones", "Draw the rows"],
                activityFingerprint: "rockets.math.secure.groups"
            )
        case .advancing:
            let multi = reading.sortOrder >= ReadingLevel.growingReader.sortOrder
            return MathScene(
                title: multi ? "Rocket Club Meet" : "Equal Shares of Mission Patches",
                storyOpening: "Tess plans kits for a rocket club meet.",
                missionPrompt: multi ? "Solve each launch problem." : "Solve each launch problem carefully.",
                readingPassage: "Kits and patches help new flyers practice countdown and thrust ideas.",
                problems: [
                    mcq("Tess has 3 packs of patches with 7 patches in each pack. How many patches in all?", ["14", "21", "28"], "21", "3 × 7 = 21.", subject: .math),
                    mcq("Tess shares 27 mission patches among 3 flyers equally. How many does each flyer get?", ["8", "9", "12"], "9", "27 ÷ 3 = 9.", subject: .math),
                    mcq("A guide rail is 21 centimeters long. Another is 13. How much longer is the first?", ["7", "8", "9"], "8", "21 − 13 = 8.", subject: .math)
                ],
                vocabularyWords: [VocabularyWord(word: "share", definition: "To split into equal parts.", exampleSentence: "Share the patches equally.")],
                knowledgeFacts: [KnowledgeFact(fact: "A countdown helps a launch team get ready before a rocket lifts off.")],
                creativePrompt: "Draw the patch packs.",
                storyEnding: "The rocket club kits are ready for launch practice!",
                mathSkill: LevelSkillProgressions.mathFocus(for: level),
                reflectionPrompt: "Tess has 3 packs of patches with 7 patches in each pack. How many patches in all?",
                hints: mathHints(level),
                activityFingerprint: "rockets.math.advancing.packs"
            )
        }
    }

    // MARK: - Helpers

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
