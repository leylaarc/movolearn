import Foundation

extension CuratedTopicLessonBank {

    // MARK: - Creative lookup (Wave C core themes)

    static func creativePack(topic: Topic, level: ReadingLevel) -> CreativePack? {
        switch topic {
        case .horses: return horsesCreative(level)
        case .jungleAnimals: return jungleCreative(level)
        case .sharks: return sharksCreative(level)
        case .dinosaurs: return dinosaursCreative(level)
        case .space: return spaceCreative(level)
        case .dogs: return dogsCreative(level)
        case .robots: return robotsCreative(level)
        case .volcanoes: return volcanoesCreative(level)
        default: return waveECreativePack(topic: topic, level: level)
        }
    }

    // MARK: - Horses

    private static func horsesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Kind Barn Drawing",
                scene: "A brown pony stands in a quiet barn. A friend fills a blue water bucket. The pony is gentle. Gold hay sits in a pile. Sunlight comes through the door.",
                vocab: "gentle",
                vocabDef: "Soft and careful.",
                fact: "Soft voices help ponies stay calm.",
                goals: ["Brown pony", "Blue bucket", "Gold hay"],
                fingerprint: "horses.creative.beginner.barn-kindness"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Pony Welcome Drawing",
                scene: "A yellow welcome sign hangs by the barn yard. A brown pony waits where it can see people. Green grass grows by the fence. A friend speaks softly.",
                vocab: "welcome",
                vocabDef: "A friendly hello.",
                fact: "Horses feel safer when people stand where they can be seen.",
                goals: ["Welcome sign", "Brown pony", "Green grass"],
                fingerprint: "horses.creative.early.welcome-sign"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Barn Helper Drawing",
                scene: "A helper brushes a pony's coat. The brush is red. Fresh water sits in a bucket. The barn is quiet. The pony looks calm and safe.",
                vocab: "helper",
                vocabDef: "A person who does a useful job.",
                fact: "Daily care jobs keep horses healthy and calm.",
                goals: ["Helper", "Red brush", "Water bucket"],
                fingerprint: "horses.creative.growing.helper-job"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Calm Pony Path",
                scene: "A wide walking path goes through a sunny yard. The pony can see people coming. A water stop sits by a tree. There are no surprise corners. The sky is bright blue.",
                vocab: "path",
                vocabDef: "A place made for walking.",
                fact: "Clear space and soft movement help horses stay relaxed.",
                goals: ["Wide path", "Pony", "Water stop"],
                fingerprint: "horses.creative.confident.calm-path"
            )
        }
    }

    // MARK: - Jungle Animals

    private static func jungleCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Canopy Friend Drawing",
                scene: "A toucan sits high in the leafy canopy. Its beak is orange and yellow. Green leaves surround it. One red fruit hangs nearby.",
                vocab: "canopy",
                vocabDef: "The high leafy tops of trees.",
                fact: "Many jungle birds live high where fruit grows.",
                goals: ["Toucan", "Orange beak", "Red fruit"],
                fingerprint: "jungle.creative.beginner.toucan"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Rainy Leaf Drawing",
                scene: "Broad jungle leaves catch the rain. Pointed tips drip water. Raindrops are silver. The forest floor is brown and wet.",
                vocab: "drip",
                vocabDef: "To fall in drops.",
                fact: "Pointed leaf tips help rain slide away.",
                goals: ["Broad leaves", "Drip tips", "Raindrops"],
                fingerprint: "jungle.creative.early.drip-leaves"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Camouflage Creature Drawing",
                scene: "A green animal hides in leafy shade. It blends into twigs and leaves. Only one eye shows. Sunlight is a thin gold stripe.",
                vocab: "blend",
                vocabDef: "To mix in so something is hard to see.",
                fact: "Camouflage helps animals stay safe in the rainforest.",
                goals: ["Hidden animal", "Green leaves", "Gold sunlight"],
                fingerprint: "jungle.creative.growing.camouflage-creature"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Four-Layer Jungle Drawing",
                scene: "Sunny tree tops catch the wind. The canopy holds a fruit-seeking bird. The understory is dim and green. A frog sits on the shady floor among fallen leaves.",
                vocab: "layer",
                vocabDef: "One level stacked above or below another.",
                fact: "Different rainforest layers offer different light, food, and cover.",
                goals: ["Sunny tops", "Canopy bird", "Floor frog"],
                fingerprint: "jungle.creative.confident.layer-map"
            )
        }
    }

    // MARK: - Sharks

    private static func sharksCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Shark Friends Adventure",
                scene: "A shark swims with his fish friends. He has gills to help him breathe. He is dark blue. His fish friends are red, pink, and green. There is green seaweed and yellow starfish on the ocean floor. They are on an adventure.",
                vocab: "gills",
                vocabDef: "Body parts that help a shark breathe underwater.",
                fact: "Sharks use gills to breathe underwater.",
                goals: ["Dark blue shark", "Gills", "Fish friends", "Starfish"],
                fingerprint: "sharks.creative.beginner.reef-shark"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Gill-Slot Shark Drawing",
                scene: "A gray shark swims sideways in blue water. Gill slits show on its side. Water moves over the gills so the shark can breathe. A yellow fish watches nearby.",
                vocab: "gills",
                vocabDef: "Body parts that help a shark breathe underwater.",
                fact: "Sharks need water over their gills to breathe.",
                goals: ["Gray shark", "Gill slits", "Yellow fish"],
                fingerprint: "sharks.creative.early.gills-portrait"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Smooth Shark Skin Drawing",
                scene: "A shark glides past pink coral. Tiny denticles cover its skin. The shark is gray-blue. Water slides along its body. A small fish swims beside it.",
                vocab: "denticle",
                vocabDef: "A tiny tooth-like scale on shark skin.",
                fact: "Denticles help sharks swim smoothly.",
                goals: ["Gray-blue shark", "Pink coral", "Small fish"],
                fingerprint: "sharks.creative.growing.field-badge"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Reef Balance Drawing",
                scene: "A shark swims above a busy reef. Plant-eating fish graze algae off orange coral. Green seaweed waves below. The reef stays in balance.",
                vocab: "balance",
                vocabDef: "A steady mix where parts work well together.",
                fact: "Healthy reefs often need balanced food webs that include sharks.",
                goals: ["Shark", "Grazing fish", "Orange coral"],
                fingerprint: "sharks.creative.confident.reef-poster"
            )
        }
    }

    // MARK: - Dinosaurs

    private static func dinosaursCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Fossil Find Drawing",
                scene: "A fossil bone sits inside a tan rock. A scientist brushes sand away. The sky is pale blue. Green ferns grow nearby.",
                vocab: "fossil",
                vocabDef: "An old clue from long ago kept in rock.",
                fact: "Fossils help scientists learn about dinosaurs.",
                goals: ["Fossil bone", "Tan rock", "Green ferns"],
                fingerprint: "dinos.creative.beginner.fossil"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Plant-Eater Lunch Drawing",
                scene: "A plant-eating dinosaur smiles with flat teeth. A plate holds green ferns and leaves. The dinosaur is olive green. A brown log sits beside the plate.",
                vocab: "fern",
                vocabDef: "A green plant with feathery leaves.",
                fact: "Tooth shape gives clues about dinosaur diets.",
                goals: ["Plant eater", "Ferns", "Flat teeth"],
                fingerprint: "dinos.creative.early.plant-plate"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Fossil Story Drawing",
                scene: "Mud buries a dinosaur bone. Minerals harden the bone. Rock layers cover it. A paleontologist finds the fossil much later under a sunny cliff.",
                vocab: "bury",
                vocabDef: "To cover under earth or sand.",
                fact: "Fossils form slowly. They do not form in one quick minute.",
                goals: ["Buried bone", "Rock layers", "Fossil find"],
                fingerprint: "dinos.creative.growing.fossil-comic"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Fossil Clue Drawing",
                scene: "A bone, a tooth, and a trackway sit on a field table. The tooth is curved. The trackway shows three-toed prints. A notebook is open beside them.",
                vocab: "evidence",
                vocabDef: "Clues that help prove an idea.",
                fact: "Paleontologists compare multiple fossil clues before deciding.",
                goals: ["Bone", "Tooth", "Trackway"],
                fingerprint: "dinos.creative.confident.evidence-board"
            )
        }
    }

    // MARK: - Space

    private static func spaceCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Day and Night Drawing",
                scene: "Earth spins beside the bright yellow Sun. One side of Earth is in daylight. The other side is dark night. Stars shine on the night side.",
                vocab: "spin",
                vocabDef: "To turn around and around.",
                fact: "Earth's spin makes day and night.",
                goals: ["Earth", "Yellow Sun", "Night side"],
                fingerprint: "space.creative.beginner.day-night"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Moonlight Bounce Drawing",
                scene: "The yellow Sun shines on the gray Moon. Light bounces toward blue Earth. The Moon does not make its own light. Space around them is black.",
                vocab: "bounce",
                vocabDef: "To hit and spring back.",
                fact: "Moonlight is reflected sunlight.",
                goals: ["Sun", "Moon", "Earth"],
                fingerprint: "space.creative.early.moonlight"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Distant Star Drawing",
                scene: "A giant glowing star shines far away. From Earth it looks like a tiny pinprick. Our yellow Sun is the closest star. Earth is a small blue dot.",
                vocab: "distant",
                vocabDef: "Very far away.",
                fact: "Distance makes giant stars look tiny in our sky.",
                goals: ["Giant star", "Tiny pinprick", "Blue Earth"],
                fingerprint: "space.creative.growing.star-postcard"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Moon Orbit Drawing",
                scene: "Earth sits in the middle of black space. The gray Moon travels on a curved path around Earth. One arrow shows the orbit. Stars sparkle far away.",
                vocab: "orbit",
                vocabDef: "A curved path around another object.",
                fact: "Gravity and motion together make orbits.",
                goals: ["Earth", "Moon", "Curved path"],
                fingerprint: "space.creative.confident.orbit-kit"
            )
        }
    }

    // MARK: - Dogs

    private static func dogsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Sniffing Trail Drawing",
                scene: "A brown dog sniffs a winding trail. Purple scent swirls float in the air. Green grass covers the yard. A red ball waits at the end.",
                vocab: "scent",
                vocabDef: "A smell left behind.",
                fact: "Dogs use smell to learn about the world.",
                goals: ["Brown dog", "Scent swirls", "Red ball"],
                fingerprint: "dogs.creative.beginner.scent-trail"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Listening Ears Drawing",
                scene: "A golden dog turns its ears toward a quiet sound. The ears point to a rustling bush. The sky is pale blue. A leaf is falling.",
                vocab: "listen",
                vocabDef: "To pay attention to sounds.",
                fact: "Dogs may notice a quiet footstep before a person does.",
                goals: ["Dog", "Turned ears", "Bush"],
                fingerprint: "dogs.creative.early.listening-ears"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Cool-Down Station Drawing",
                scene: "A panting dog rests in cool shade. A bowl of fresh water is blue. A tree makes a dark shadow on the path. The sun is hot and yellow.",
                vocab: "shade",
                vocabDef: "A cool place out of strong sun.",
                fact: "Panting helps dogs cool their bodies.",
                goals: ["Panting dog", "Water bowl", "Shade tree"],
                fingerprint: "dogs.creative.growing.cool-station"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Smell-First Park Drawing",
                scene: "A dog leads with its nose on a park path. Three scent stops sit by a bench, a tree, and a gate. People see an empty patch of grass. The dog finds a trail there.",
                vocab: "trail",
                vocabDef: "A path of scent left behind.",
                fact: "A dog's nose has many more scent detectors than a human nose.",
                goals: ["Dog nose", "Park path", "Scent stops"],
                fingerprint: "dogs.creative.confident.scent-map"
            )
        }
    }

    // MARK: - Robots

    private static func robotsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Three-Step Robot Drawing",
                scene: "A friendly silver robot follows three numbered steps. Step one is roll. Step two is stop. Step three is wave. The robot has a blue light.",
                vocab: "program",
                vocabDef: "A list of steps for a machine.",
                fact: "Robots do program steps one after another.",
                goals: ["Silver robot", "Three steps", "Blue light"],
                fingerprint: "robots.creative.beginner.three-steps"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Robot Sensor Drawing",
                scene: "A yellow robot stands in a hallway. A touch sensor is on its hand. A light sensor is on its head. The hallway has a dark corner and a bright window.",
                vocab: "sensor",
                vocabDef: "A part that collects information from the world.",
                fact: "Touch and light sensors help robots notice bumps and brightness.",
                goals: ["Yellow robot", "Touch sensor", "Light sensor"],
                fingerprint: "robots.creative.early.sensors"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Sense Decide Act Drawing",
                scene: "An orange robot uses a sensor in a hallway. It sees a brown box. It decides to turn. Then it rolls around the box.",
                vocab: "decide",
                vocabDef: "To choose what to do next.",
                fact: "Clear sensing and clear rules make safer robot behavior.",
                goals: ["Orange robot", "Brown box", "Turn path"],
                fingerprint: "robots.creative.growing.loop-comic"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Robot Safety Drawing",
                scene: "A silver robot works while a person watches nearby. A red stop button is easy to reach. Safety lines are yellow on the floor. The robot lifts a small crate.",
                vocab: "supervision",
                vocabDef: "Careful watching and guidance by a person.",
                fact: "Understanding robot limits helps people use them wisely.",
                goals: ["Robot", "Watcher", "Stop button"],
                fingerprint: "robots.creative.confident.safety-charter"
            )
        }
    }

    // MARK: - Volcanoes

    private static func volcanoesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return sceneDrawing(
                title: "Quiet Volcano Drawing",
                scene: "A tall volcano mountain stands under a blue sky. Hot rock is labeled deep inside. Green trees grow far from the opening. People watch from a safe hill.",
                vocab: "volcano",
                vocabDef: "A mountain that can open and let hot rock out.",
                fact: "People stay far away when a volcano is unsafe.",
                goals: ["Mountain", "Hot rock", "Safe hill"],
                fingerprint: "volcanoes.creative.beginner.mountain"
            )
        case .earlyReader:
            return sceneDrawing(
                title: "Magma and Lava Drawing",
                scene: "Orange magma sits under the ground. Red lava flows on the surface. The volcano is gray. A color key shows magma and lava. Cooled rock is dark brown.",
                vocab: "lava",
                vocabDef: "Hot melted rock on Earth's surface.",
                fact: "Lava can cool and harden into new rock.",
                goals: ["Magma", "Lava", "Color key"],
                fingerprint: "volcanoes.creative.early.magma-lava-key"
            )
        case .growingReader:
            return sceneDrawing(
                title: "Pressure Warning Drawing",
                scene: "Gas bubbles rise through orange magma. Pressure pushes toward the volcano opening. A warning sign is red and yellow. Scientists stand far back on a ridge.",
                vocab: "pressure",
                vocabDef: "A strong push from inside.",
                fact: "Gas bubbles help drive magma toward surface openings.",
                goals: ["Gas bubbles", "Warning sign", "Ridge"],
                fingerprint: "volcanoes.creative.growing.pressure-icon"
            )
        case .confidentReader:
            return sceneDrawing(
                title: "Volcano Monitor Drawing",
                scene: "A monitor table shows three gauges. One gauge watches tiny earthquakes. One watches ground swelling. One watches gas. A scientist in a yellow vest writes notes.",
                vocab: "monitor",
                vocabDef: "To watch carefully for changes over time.",
                fact: "Clear warnings help communities prepare and stay safer.",
                goals: ["Three gauges", "Scientist", "Yellow vest"],
                fingerprint: "volcanoes.creative.confident.monitor-dashboard"
            )
        }
    }

    // MARK: - Creative helper

    /// Shared builder for Wave C + Wave E. Derives unique vocab examples, fact explanations,
    /// hints, and mission phrasing from each pack's vocab / fact / fingerprint / response type
    /// so Creative lessons do not share one Mad-Lib stamp.
    static func creative(
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
        fingerprint: String,
        drawingGoals: [String] = []
    ) -> CreativePack {
        let topicToken = fingerprint.split(separator: ".").first.map(String.init) ?? "topic"
        let seed = creativeSeed(fingerprint)
        let art = QuestionResponseTypeResolver.preferDrawingForCreativeSession(
            title: title,
            mission: polishCreativeMission(mission),
            prompt: prompt,
            responseType: response,
            category: .creative
        )
        return CreativePack(
            title: title,
            storyOpening: opening,
            missionPrompt: art.mission,
            inspiration: polishCreativeInspiration(inspiration),
            vocabularyWords: [
                VocabularyWord(
                    word: vocab,
                    definition: vocabDef,
                    exampleSentence: creativeVocabExample(word: vocab, fingerprint: fingerprint, seed: seed)
                )
            ],
            knowledgeFacts: [
                KnowledgeFact(
                    fact: fact,
                    explanation: creativeFactExplanation(fact: fact, inspiration: inspiration)
                )
            ],
            creativePrompt: art.prompt,
            creativeResponseType: art.responseType,
            storyEnding: ending,
            reflectionPrompt: reflection,
            hints: creativeHints(vocab: vocab, response: art.responseType, seed: seed),
            successCriteria: creativeSuccessCriteria(response: art.responseType, vocab: vocab),
            learningObjectives: [
                "Create a response connected to \(topicToken)",
                "fp:creative.\(fingerprint)"
            ],
            activityFingerprint: fingerprint,
            drawingGoals: drawingGoals
        )
    }

    /// Fun drawing-board Art Quest: a scene to draw, no quiz.
    static func sceneDrawing(
        title: String,
        scene: String,
        vocab: String,
        vocabDef: String,
        fact: String,
        goals: [String],
        fingerprint: String,
        ending: String? = nil,
        reflection: String? = nil
    ) -> CreativePack {
        let trimmedScene = scene.trimmingCharacters(in: .whitespacesAndNewlines)
        let prompt: String = {
            if trimmedScene.lowercased().hasPrefix("draw this scene") {
                return trimmedScene
            }
            return "Draw this scene: \(trimmedScene)"
        }()
        let opening: String = {
            let body: String
            if let range = trimmedScene.range(of: "Draw this scene:", options: .caseInsensitive) {
                body = String(trimmedScene[range.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                body = trimmedScene
            }
            if let end = body.firstIndex(where: { ".!?".contains($0) }) {
                return String(body[...end]).trimmingCharacters(in: .whitespaces)
            }
            return body
        }()
        return creative(
            title: title,
            opening: opening,
            mission: "Draw this scene. Show the \(vocab) clearly.",
            inspiration: "Science note: \(fact)",
            vocab: vocab,
            vocabDef: vocabDef,
            fact: fact,
            prompt: prompt,
            response: .drawing,
            ending: ending ?? "Your picture is full of life. Beautiful work!",
            reflection: reflection ?? "Which detail was the most fun to draw?",
            fingerprint: fingerprint,
            drawingGoals: goals
        )
    }

    private static func creativeSeed(_ fingerprint: String) -> Int {
        abs(fingerprint.utf8.reduce(0) { ($0 &* 31) &+ Int($1) })
    }

    /// Strips adult “use the inspiration” glue and keeps the kid-facing action.
    /// Do not prepend Mad-Lib openers like “true detail” — they make missions nonsense.
    static func polishCreativeMission(_ mission: String) -> String {
        let trimmed = mission.trimmingCharacters(in: .whitespacesAndNewlines)
        let prefixes = [
            "Use the inspiration. ",
            "Use the inspiration note. ",
            "Use the inspiration note, then ",
            "Read the inspiration. ",
            "Look at the science note and then ",
            "Borrow one detail from the inspiration and then ",
            "Start from the inspiration and then ",
            "Keep the real science in mind and then ",
            "Use one true detail from the note and then ",
            "Use one detail from the note and then "
        ]
        var action = trimmed
        for prefix in prefixes {
            if let range = action.range(of: prefix, options: [.caseInsensitive, .anchored]) {
                action = String(action[range.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
                break
            }
        }
        if action.lowercased().hasPrefix("use the inspiration") {
            if let dot = action.firstIndex(of: ".") {
                action = String(action[action.index(after: dot)...]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        guard !action.isEmpty else { return trimmed }
        let cleaned = action.prefix(1).uppercased() + action.dropFirst()
        return ChildFacingProseQualityValidator.polish(cleaned)
    }

    private static func polishCreativeInspiration(_ inspiration: String) -> String {
        let trimmed = inspiration.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("inspiration:") {
            let rest = trimmed.drop(while: { $0 != ":" }).dropFirst().trimmingCharacters(in: .whitespaces)
            return "Science note: \(rest)"
        }
        return trimmed
    }

    private static func creativeVocabExample(word: String, fingerprint _: String, seed: Int) -> String {
        let templates = [
            "Your picture can make the word \"\(word)\" easy to notice.",
            "A friend can find the word \"\(word)\" in your drawing.",
            "The word \"\(word)\" belongs in a clear place in your picture.",
            "Your drawing can show what \"\(word)\" looks like.",
            "One label in your picture can use the word \"\(word)\"."
        ]
        return templates[seed % templates.count]
    }

    private static func creativeFactExplanation(fact: String, inspiration: String) -> String {
        var note = inspiration.trimmingCharacters(in: .whitespacesAndNewlines)
        for prefix in ["Inspiration:", "Science note:"] {
            if note.lowercased().hasPrefix(prefix.lowercased()) {
                note = String(note.drop(while: { $0 != ":" }).dropFirst()).trimmingCharacters(in: .whitespaces)
                break
            }
        }
        let sentence: String = {
            if let end = note.firstIndex(where: { ".!?".contains($0) }) {
                return String(note[...end]).trimmingCharacters(in: .whitespaces)
            }
            return note
        }()
        return KnowledgeFact.childFacingExplanation(fact: fact, explanation: sentence)
    }

    private static func creativeHints(vocab: String, response: QuestionResponseType, seed: Int) -> [String] {
        let drawLike = response == .drawing
        let firstOptions = drawLike
            ? [
                "Sketch the main idea first, then add one \"\(vocab)\" detail.",
                "Find one \"\(vocab)\" clue in the science note before you draw.",
                "Keep shapes simple, and make \"\(vocab)\" easy to see."
            ]
            : [
                "Reread the science note and borrow one \"\(vocab)\" detail for your writing.",
                "Name \"\(vocab)\" clearly in your plan so a friend could understand it.",
                "Write the big idea first, then add one \"\(vocab)\" detail."
            ]
        let secondOptions = [
            "Add one idea that is yours alone.",
            "Check that your work matches the create prompt.",
            "Share one choice you made on purpose."
        ]
        return [
            firstOptions[seed % firstOptions.count],
            secondOptions[(seed / 3) % secondOptions.count]
        ]
    }

    private static func creativeSuccessCriteria(response: QuestionResponseType, vocab: String) -> [String] {
        let make = response == .drawing
            ? "Shows a clear picture with a \"\(vocab)\" detail"
            : "Writes a clear plan that uses \"\(vocab)\" thoughtfully"
        return [
            "Uses at least one detail from the science note",
            make
        ]
    }
}
