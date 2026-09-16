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
            return creative(
                title: "Draw a Kind Barn Moment",
                opening: "Imagine a quiet barn and one gentle pony.",
                mission: "Use the inspiration note. Draw one kind barn moment.",
                inspiration: "Inspiration: A pony waits while a friend fills a water bucket and speaks softly.",
                vocab: "gentle", vocabDef: "Soft and careful.",
                fact: "Soft voices help ponies stay calm.",
                prompt: "Draw a pony beside a water bucket. Add one person speaking softly.",
                response: .drawing,
                ending: "Your barn picture shows care. Beautiful work!",
                reflection: "What kind detail did you put next to the pony?",
                fingerprint: "horses.creative.beginner.barn-kindness"
            )
        case .earlyReader:
            return creative(
                title: "Design a Pony Welcome Sign",
                opening: "Visitors are coming to meet a calm pony.",
                mission: "Use the inspiration. Draw a welcome sign for the barn yard.",
                inspiration: "Inspiration: Good barn manners include soft voices and standing where a pony can see you.",
                vocab: "welcome", vocabDef: "A friendly hello.",
                fact: "Horses feel safer when people stand where they can be seen.",
                prompt: "Draw a colorful welcome sign with one barn-safety tip in big letters.",
                response: .drawing,
                ending: "Your sign helps visitors be kind. Great design!",
                reflection: "Which safety tip did you put on your sign?",
                fingerprint: "horses.creative.early.welcome-sign"
            )
        case .growingReader:
            return creative(
                title: "Invent a Barn Helper Job",
                opening: "The barn needs a new helper job that keeps ponies calm.",
                mission: "Read the inspiration. Write and design your helper job.",
                inspiration: "Inspiration: Barn helpers brush coats, check water, and teach soft manners. Your job should help a pony feel safe.",
                vocab: "helper", vocabDef: "A person who does a useful job.",
                fact: "Daily care jobs keep horses healthy and calm.",
                prompt: "Write four sentences naming your barn helper job, two tasks you do, and one way you keep ponies calm. Add a small sketch idea in words.",
                response: .longText,
                ending: "Your helper job idea is ready for the barn board!",
                reflection: "Which task in your job would a pony notice first?",
                fingerprint: "horses.creative.growing.helper-job"
            )
        case .confidentReader:
            return creative(
                title: "Plan a Calm Pony Path",
                opening: "Design a walking path that keeps ponies and people comfortable.",
                mission: "Use the inspiration. Write a short plan for your calm path.",
                inspiration: "Inspiration: A good path gives ponies space, clear sight lines, and quiet stops for water. Avoid surprise corners where a pony cannot see people.",
                vocab: "path", vocabDef: "A place made for walking.",
                fact: "Clear space and soft movement help horses stay relaxed.",
                prompt: "Write a short plan with a path name, three design choices, and one sentence explaining how your path keeps ponies calm.",
                response: .longText,
                ending: "Your calm-path plan could guide a real barn yard!",
                reflection: "Which design choice best protects a pony from surprises?",
                fingerprint: "horses.creative.confident.calm-path"
            )
        }
    }

    // MARK: - Jungle Animals

    private static func jungleCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return creative(
                title: "Draw a Canopy Friend",
                opening: "Look up into the leafy jungle tops.",
                mission: "Use the inspiration. Draw one animal high in the trees.",
                inspiration: "Inspiration: A bright toucan sits high in the leafy canopy with fruit nearby.",
                vocab: "canopy", vocabDef: "The high leafy tops of trees.",
                fact: "Many jungle birds live high where fruit grows.",
                prompt: "Draw a toucan in the canopy. Add one piece of fruit.",
                response: .drawing,
                ending: "Your canopy friend looks right at home!",
                reflection: "What color did you choose for the toucan's beak?",
                fingerprint: "jungle.creative.beginner.toucan"
            )
        case .earlyReader:
            return creative(
                title: "Rainy Leaf Umbrella Art",
                opening: "Rain taps the jungle path.",
                mission: "Use the inspiration. Draw leaves that shed rain.",
                inspiration: "Inspiration: Broad jungle leaves can catch rain and drip water off pointed tips.",
                vocab: "drip", vocabDef: "To fall in drops.",
                fact: "Pointed leaf tips help rain slide away.",
                prompt: "Draw three broad leaves with pointed tips and falling raindrops.",
                response: .drawing,
                ending: "Your rainy leaf art shows a real jungle idea!",
                reflection: "Where did you put the drip tips on your leaves?",
                fingerprint: "jungle.creative.early.drip-leaves"
            )
        case .growingReader:
            return creative(
                title: "Invent a Camouflage Creature",
                opening: "Design an animal that can hide in green shade.",
                mission: "Use the inspiration. Draw your camouflage creature.",
                inspiration: "Inspiration: Some jungle animals blend into twigs and leaves. Others use bright colors as a warning. You choose one strategy for your invention.",
                vocab: "blend", vocabDef: "To mix in so something is hard to see.",
                fact: "Camouflage helps animals stay safe in the rainforest.",
                prompt: "Draw your camouflage creature in the green shade. Show where it lives and how it hides or warns.",
                response: .drawing,
                ending: "Your camouflage creature is ready for the rainforest notebook!",
                reflection: "Did you choose blending in or warning colors, and why?",
                fingerprint: "jungle.creative.growing.camouflage-creature"
            )
        case .confidentReader:
            return creative(
                title: "Design a Four-Layer Jungle Map",
                opening: "Map a rainforest from sunny tops to shady floor.",
                mission: "Use the inspiration. Write a labeled map plan.",
                inspiration: "Inspiration: Emergent tops catch sun and wind. The canopy holds fruit seekers. The understory is dim. The floor recycles fallen leaves.",
                vocab: "layer", vocabDef: "One level stacked above or below another.",
                fact: "Different rainforest layers offer different light, food, and cover.",
                prompt: "Write a map plan that names all four layers and places one animal or plant in each layer with a reason.",
                response: .longText,
                ending: "Your four-layer map could guide a jungle field trip!",
                reflection: "Which layer was hardest to stock, and why?",
                fingerprint: "jungle.creative.confident.layer-map"
            )
        }
    }

    // MARK: - Sharks

    private static func sharksCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return creative(
                title: "Draw a Gentle Reef Shark",
                opening: "Picture a sunny reef and calm blue water.",
                mission: "Use the inspiration. Draw one calm reef shark.",
                inspiration: "Inspiration: A reef shark swims slowly past coral and does not chase every little fish.",
                vocab: "reef", vocabDef: "A rocky ocean place where coral and fish live.",
                fact: "Many reef sharks swim calmly while exploring.",
                prompt: "Draw a reef shark near coral. Add two small fish swimming nearby.",
                response: .drawing,
                ending: "Your calm reef scene is wonderful!",
                reflection: "What coral color did you choose beside the shark?",
                fingerprint: "sharks.creative.beginner.reef-shark"
            )
        case .earlyReader:
            return creative(
                title: "Gill-Slot Shark Portrait",
                opening: "Scientists notice the slits on a shark's side.",
                mission: "Use the inspiration. Draw a shark portrait that shows gills.",
                inspiration: "Inspiration: Sharks breathe with gills. Water must move over the gills so the shark can breathe.",
                vocab: "gills", vocabDef: "Body parts that help a shark breathe underwater.",
                fact: "Sharks need water over their gills to breathe.",
                prompt: "Draw a side view of a shark and clearly mark the gill slits.",
                response: .drawing,
                ending: "Your portrait teaches a real shark science idea!",
                reflection: "Where did you place the gill slits on your shark?",
                fingerprint: "sharks.creative.early.gills-portrait"
            )
        case .growingReader:
            return creative(
                title: "Invent a Shark Field Badge",
                opening: "Design a badge for young ocean investigators.",
                mission: "Use the inspiration. Write your badge design and motto.",
                inspiration: "Inspiration: Shark skin has tiny tooth-like denticles that help water slide past. A good badge teaches one true shark body fact.",
                vocab: "denticle", vocabDef: "A tiny tooth-like scale on shark skin.",
                fact: "Denticles help sharks swim smoothly.",
                prompt: "Write four sentences describing your badge shape, one shark fact it shows, a short motto, and who can earn it.",
                response: .longText,
                ending: "Your shark field badge is ready to print!",
                reflection: "Which true shark fact did your motto highlight?",
                fingerprint: "sharks.creative.growing.field-badge"
            )
        case .confidentReader:
            return creative(
                title: "Design a Reef Balance Poster",
                opening: "Make a poster that shows why sharks matter on a reef.",
                mission: "Use the inspiration. Write a poster plan with a clear message.",
                inspiration: "Inspiration: Sharks near the top of a food web can help keep mid-level hunters in balance so plant-eating fish still graze algae off coral.",
                vocab: "balance", vocabDef: "A steady mix where parts work well together.",
                fact: "Healthy reefs often need balanced food webs that include sharks.",
                prompt: "Write a poster plan with a headline, three labeled picture ideas, and one sentence that explains reef balance.",
                response: .longText,
                ending: "Your reef-balance poster could hang in a science hall!",
                reflection: "Which labeled picture best shows your main message?",
                fingerprint: "sharks.creative.confident.reef-poster"
            )
        }
    }

    // MARK: - Dinosaurs

    private static func dinosaursCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return creative(
                title: "Draw a Fossil Find",
                opening: "Imagine digging carefully in soft stone.",
                mission: "Use the inspiration. Draw one fossil clue.",
                inspiration: "Inspiration: A fossil can be an old bone or a print kept in rock.",
                vocab: "fossil", vocabDef: "An old clue from long ago kept in rock.",
                fact: "Fossils help scientists learn about dinosaurs.",
                prompt: "Draw a fossil bone or footprint inside a rock. Label it fossil.",
                response: .drawing,
                ending: "Your fossil find looks ready for a museum shelf!",
                reflection: "Did you draw a bone or a print?",
                fingerprint: "dinos.creative.beginner.fossil"
            )
        case .earlyReader:
            return creative(
                title: "Plant-Eater Lunch Plate",
                opening: "Design lunch for a plant-eating dinosaur.",
                mission: "Use the inspiration. Draw a dino lunch plate.",
                inspiration: "Inspiration: Plant-eating dinosaurs chewed leaves and ferns with flatter teeth.",
                vocab: "fern", vocabDef: "A green plant with feathery leaves.",
                fact: "Tooth shape gives clues about dinosaur diets.",
                prompt: "Draw a plate with ferns and leaves for a plant eater. Add a flat-tooth smile.",
                response: .drawing,
                ending: "Your plant-eater plate is a tasty science idea!",
                reflection: "How many fern leaves did you put on the plate?",
                fingerprint: "dinos.creative.early.plant-plate"
            )
        case .growingReader:
            return creative(
                title: "Write a Fossil Formation Comic",
                opening: "Tell how a fossil forms, one panel at a time.",
                mission: "Use the inspiration. Write a four-panel comic script.",
                inspiration: "Inspiration: Remains can be buried by mud, hardened by minerals, covered by rock layers, then found much later.",
                vocab: "bury", vocabDef: "To cover under earth or sand.",
                fact: "Fossils form slowly. They do not form in one quick minute.",
                prompt: "Write four short panel descriptions in order: bury, harden, cover, discover. Give your comic a title.",
                response: .longText,
                ending: "Your fossil comic teaches a real earth process!",
                reflection: "Which panel shows the longest wait?",
                fingerprint: "dinos.creative.growing.fossil-comic"
            )
        case .confidentReader:
            return creative(
                title: "Build a Paleontologist Evidence Board",
                opening: "Design a board that uses more than one fossil clue.",
                mission: "Use the inspiration. Write your evidence-board plan.",
                inspiration: "Inspiration: Strong dinosaur ideas use bones, teeth, and trackways together instead of one broken bone alone.",
                vocab: "evidence", vocabDef: "Clues that help prove an idea.",
                fact: "Paleontologists compare multiple fossil clues before deciding.",
                prompt: "Write a board plan with three clue cards (bone, tooth, trackway) and one conclusion sentence that needs all three.",
                response: .longText,
                ending: "Your evidence board is investigator-ready!",
                reflection: "Why would one clue alone be too weak for your conclusion?",
                fingerprint: "dinos.creative.confident.evidence-board"
            )
        }
    }

    // MARK: - Space

    private static func spaceCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return creative(
                title: "Draw Day and Night Earth",
                opening: "Earth spins beside the bright Sun.",
                mission: "Use the inspiration. Draw day and night on Earth.",
                inspiration: "Inspiration: One side of Earth faces the Sun for day. The other side faces away for night.",
                vocab: "spin", vocabDef: "To turn around and around.",
                fact: "Earth's spin makes day and night.",
                prompt: "Draw Earth beside the Sun. Shade the night side and label day and night.",
                response: .drawing,
                ending: "Your Earth picture teaches a real space idea!",
                reflection: "Which side of Earth did you shade for night?",
                fingerprint: "space.creative.beginner.day-night"
            )
        case .earlyReader:
            return creative(
                title: "Moonlight Bounce Diagram",
                opening: "Explain moonlight with a simple picture.",
                mission: "Use the inspiration. Draw sunlight bouncing to Earth.",
                inspiration: "Inspiration: The Moon does not make its own light. Sunlight hits the Moon and bounces toward Earth as moonlight.",
                vocab: "bounce", vocabDef: "To hit and spring back.",
                fact: "Moonlight is reflected sunlight.",
                prompt: "Draw the Sun, Moon, and Earth with arrows showing light bouncing to Earth.",
                response: .drawing,
                ending: "Your bounce diagram shines with real science!",
                reflection: "Where did you draw the bounce arrow?",
                fingerprint: "space.creative.early.moonlight"
            )
        case .growingReader:
            return creative(
                title: "Invent a Distant Star Postcard",
                opening: "Write from a star that only looks tiny from Earth.",
                mission: "Use the inspiration. Write a postcard from a distant star.",
                inspiration: "Inspiration: Stars are giant glowing suns. They look like pinpoints because they are extremely far away. Our Sun is the closest star.",
                vocab: "distant", vocabDef: "Very far away.",
                fact: "Distance makes giant stars look tiny in our sky.",
                prompt: "Write a postcard of four sentences from a distant star explaining why Earth people see you as a tiny light.",
                response: .longText,
                ending: "Your star postcard travels across huge distance!",
                reflection: "Which sentence best explains distance?",
                fingerprint: "space.creative.growing.star-postcard"
            )
        case .confidentReader:
            return creative(
                title: "Draw the Moon Going Around Earth",
                opening: "The Moon moves around Earth in a curved path.",
                mission: "Draw the Moon going around Earth.",
                inspiration: "Inspiration: An orbit is a curved path. Earth's pull keeps the Moon nearby while the Moon keeps moving.",
                vocab: "orbit", vocabDef: "A curved path around another object.",
                fact: "Gravity and motion together make orbits.",
                prompt: "Draw Earth in the middle. Draw the Moon on a curved path around it. Add one arrow for the path.",
                response: .drawing,
                ending: "You drew the Moon's path around Earth!",
                reflection: "Where did you draw the Moon's path?",
                fingerprint: "space.creative.confident.orbit-kit"
            )
        }
    }

    // MARK: - Dogs

    private static func dogsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return creative(
                title: "Draw a Sniffing Trail",
                opening: "A dog explores with its nose first.",
                mission: "Use the inspiration. Draw a dog following a scent.",
                inspiration: "Inspiration: Dogs have strong noses and can smell things people miss.",
                vocab: "scent", vocabDef: "A smell left behind.",
                fact: "Dogs use smell to learn about the world.",
                prompt: "Draw a dog sniffing a trail. Add swirls for scent.",
                response: .drawing,
                ending: "Your sniffing trail picture is nose-smart!",
                reflection: "What was at the end of your scent trail?",
                fingerprint: "dogs.creative.beginner.scent-trail"
            )
        case .earlyReader:
            return creative(
                title: "Listening Ears Poster",
                opening: "Dog ears turn to catch soft sounds.",
                mission: "Use the inspiration. Draw a listening-ears poster.",
                inspiration: "Inspiration: Dogs can hear soft or high sounds. Moving ears help find where a noise comes from.",
                vocab: "listen", vocabDef: "To pay attention to sounds.",
                fact: "Dogs may notice a quiet footstep before a person does.",
                prompt: "Draw a dog with ears turned toward a quiet sound. Label listening.",
                response: .drawing,
                ending: "Your listening poster celebrates dog hearing!",
                reflection: "Which way did the ears point in your drawing?",
                fingerprint: "dogs.creative.early.listening-ears"
            )
        case .growingReader:
            return creative(
                title: "Invent a Cool-Down Station",
                opening: "Design a kind station for hot-day dog walks.",
                mission: "Use the inspiration. Write your cool-down station plan.",
                inspiration: "Inspiration: Dogs cool mainly by panting. Fresh water and shade help that cooling system work safely.",
                vocab: "shade", vocabDef: "A cool place out of strong sun.",
                fact: "Panting helps dogs cool their bodies.",
                prompt: "Write four sentences naming your station, two items you provide, and one rule that keeps dogs safer in heat.",
                response: .longText,
                ending: "Your cool-down station is ready for the park path!",
                reflection: "Which item in your station helps panting dogs most?",
                fingerprint: "dogs.creative.growing.cool-station"
            )
        case .confidentReader:
            return creative(
                title: "Create a Smell-First Adventure Map",
                opening: "Map a park the way a dog's nose might read it.",
                mission: "Use the inspiration. Write an adventure map with scent stops.",
                inspiration: "Inspiration: Dogs often lead with smell while people lead with eyes. Faint trails can still be useful clues for a powerful nose.",
                vocab: "trail", vocabDef: "A path of scent left behind.",
                fact: "A dog's nose has many more scent detectors than a human nose.",
                prompt: "Write a map plan with a title, three scent stops, and one sentence explaining why a stop looks empty to people but interesting to dogs.",
                response: .longText,
                ending: "Your smell-first map opens a new way to see the park!",
                reflection: "Which scent stop would a detection dog love most?",
                fingerprint: "dogs.creative.confident.scent-map"
            )
        }
    }

    // MARK: - Robots

    private static func robotsCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return creative(
                title: "Draw a Three-Step Robot",
                opening: "Robots follow steps in order.",
                mission: "Use the inspiration. Draw a robot and its steps.",
                inspiration: "Inspiration: A program is a list of steps a robot follows in order.",
                vocab: "program", vocabDef: "A list of steps for a machine.",
                fact: "Robots do program steps one after another.",
                prompt: "Draw a friendly robot and three numbered steps it follows.",
                response: .drawing,
                ending: "Your step-by-step robot is ready to run!",
                reflection: "What is step number one on your robot?",
                fingerprint: "robots.creative.beginner.three-steps"
            )
        case .earlyReader:
            return creative(
                title: "Sensor Sticker Sheet",
                opening: "Give your robot ways to notice the world.",
                mission: "Use the inspiration. Draw sensors on a robot.",
                inspiration: "Inspiration: Sensors collect light, sound, or touch information so a robot can choose safer next steps.",
                vocab: "sensor", vocabDef: "A part that collects information from the world.",
                fact: "Touch and light sensors help robots notice bumps and brightness.",
                prompt: "Draw a robot with a touch sensor and a light sensor clearly labeled.",
                response: .drawing,
                ending: "Your sensor sheet is engineer-approved!",
                reflection: "Which sensor would help most in a dark hallway?",
                fingerprint: "robots.creative.early.sensors"
            )
        case .growingReader:
            return creative(
                title: "Write a Sense-Decide-Act Comic",
                opening: "Show how a robot chooses a move.",
                mission: "Use the inspiration. Write a three-panel comic script.",
                inspiration: "Inspiration: Many robots work in a loop: sense, decide, then act. Then they can sense again.",
                vocab: "decide", vocabDef: "To choose what to do next.",
                fact: "Clear sensing and clear rules make safer robot behavior.",
                prompt: "Write three panel scripts labeled Sense, Decide, and Act for a robot avoiding a box in a hallway.",
                response: .longText,
                ending: "Your control-loop comic teaches real robotics!",
                reflection: "What input did your robot sense in panel one?",
                fingerprint: "robots.creative.growing.loop-comic"
            )
        case .confidentReader:
            return creative(
                title: "Design a Robot Safety Charter",
                opening: "Write rules that respect what machines can and cannot do.",
                mission: "Use the inspiration. Write a short safety charter.",
                inspiration: "Inspiration: Robots are machines built by people. They follow given rules and need safety checks and human supervision for important jobs.",
                vocab: "supervision", vocabDef: "Careful watching and guidance by a person.",
                fact: "Understanding robot limits helps people use them wisely.",
                prompt: "Write a charter with a title, three safety rules, and one sentence about when a human must take over.",
                response: .longText,
                ending: "Your safety charter belongs beside the robot lab door!",
                reflection: "Which rule best protects people when sensors fail?",
                fingerprint: "robots.creative.confident.safety-charter"
            )
        }
    }

    // MARK: - Volcanoes

    private static func volcanoesCreative(_ level: ReadingLevel) -> CreativePack {
        switch level {
        case .beginner:
            return creative(
                title: "Draw a Quiet Volcano Mountain",
                opening: "A volcano is a mountain that can open.",
                mission: "Use the inspiration. Draw a volcano mountain.",
                inspiration: "Inspiration: Hot rock can rise from deep inside Earth toward a volcano opening.",
                vocab: "volcano", vocabDef: "A mountain that can open and let hot rock out.",
                fact: "People stay far away when a volcano is unsafe.",
                prompt: "Draw a volcano mountain and label hot rock deep inside.",
                response: .drawing,
                ending: "Your volcano picture shows deep Earth heat!",
                reflection: "Where did you label the hot rock?",
                fingerprint: "volcanoes.creative.beginner.mountain"
            )
        case .earlyReader:
            return creative(
                title: "Magma and Lava Color Key",
                opening: "Teach the two names for melted rock.",
                mission: "Use the inspiration. Draw a color-key diagram.",
                inspiration: "Inspiration: Magma is melted rock under the ground. Lava is melted rock at the surface.",
                vocab: "lava", vocabDef: "Hot melted rock on Earth's surface.",
                fact: "Lava can cool and harden into new rock.",
                prompt: "Draw underground magma and surface lava in different colors. Add a color key.",
                response: .drawing,
                ending: "Your color key makes magma and lava clear!",
                reflection: "Which color did you choose for lava at the surface?",
                fingerprint: "volcanoes.creative.early.magma-lava-key"
            )
        case .growingReader:
            return creative(
                title: "Invent a Pressure Warning Icon",
                opening: "Design an icon that warns when pressure rises.",
                mission: "Use the inspiration. Write your icon and caption.",
                inspiration: "Inspiration: Magma and gas can raise pressure until rock above cannot hold. Rising pressure is a key eruption clue.",
                vocab: "pressure", vocabDef: "A strong push from inside.",
                fact: "Gas bubbles help drive magma toward surface openings.",
                prompt: "Write four sentences describing your warning icon shape, colors, one symbol for pressure, and a short public caption.",
                response: .longText,
                ending: "Your pressure icon could appear on a science alert board!",
                reflection: "What symbol did you choose for rising pressure?",
                fingerprint: "volcanoes.creative.growing.pressure-icon"
            )
        case .confidentReader:
            return creative(
                title: "Build a Volcano Monitor Dashboard",
                opening: "Plan a dashboard that watches more than one clue.",
                mission: "Use the inspiration. Write a monitor dashboard plan.",
                inspiration: "Inspiration: Scientists watch tiny earthquakes, ground swelling, and gas changes together. Several rising signs matter more than one rumble alone.",
                vocab: "monitor", vocabDef: "To watch carefully for changes over time.",
                fact: "Clear warnings help communities prepare and stay safer.",
                prompt: "Write a dashboard plan with three gauges, what each measures, and one sentence for when to share a public warning.",
                response: .longText,
                ending: "Your monitor dashboard is volcanologist-approved!",
                reflection: "Which two gauges rising together would worry you most?",
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
        fingerprint: String
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
            activityFingerprint: fingerprint
        )
    }

    private static func creativeSeed(_ fingerprint: String) -> Int {
        abs(fingerprint.utf8.reduce(0) { ($0 &* 31) &+ Int($1) })
    }

    /// Strips adult “use the inspiration” glue and keeps the kid-facing action.
    /// Do not prepend Mad-Lib openers like “true detail” — they make missions nonsense.
    private static func polishCreativeMission(_ mission: String) -> String {
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

    private static func creativeVocabExample(word: String, fingerprint: String, seed: Int) -> String {
        let topic = fingerprint.split(separator: ".").first.map(String.init)?.replacingOccurrences(of: "-", with: " ") ?? "this topic"
        let templates = [
            "In your \(topic) creation, show what \"\(word)\" looks like.",
            "Label one part of your work with the word \"\(word)\".",
            "Your picture or plan can make \"\(word)\" easy to notice.",
            "Add a small caption that uses the word \"\(word)\".",
            "When you finish, point to where \"\(word)\" appears in your idea."
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
