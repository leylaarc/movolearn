import Foundation

/// Lesson-specific vocabulary and facts used to build and validate high-quality questions.
/// Generators and validators should prefer this bank over a bare theme keyword.
struct LessonContextBank: Equatable {
    let characters: [String]
    let animalsOrObjects: [String]
    let locations: [String]
    let actions: [String]
    let vocabulary: [String]
    let establishedFacts: [String]
    let commonMisconceptions: [String]
    let excludedConcepts: [String]
    let primarySubject: PrimarySubject
    let primaryTopicId: String?
    let learningObjective: String
    let intendedSkill: String
    let storySummary: String
    let ageBand: String
    let readingLevel: ReadingLevel

    /// All tokens allowed when checking whether a noun belongs in the lesson world.
    var allowedNouns: Set<String> {
        var words = Set<String>()
        for list in [characters, animalsOrObjects, locations, actions, vocabulary] {
            words.formUnion(list.flatMap(Self.tokenize))
        }
        words.formUnion(Self.tokenize(storySummary))
        words.formUnion(establishedFacts.flatMap(Self.tokenize))
        return words
    }

    /// Builds a context bank from a fully authored lesson.
    static func from(lesson: Lesson) -> LessonContextBank {
        let passage = lesson.readingPassage
        let opening = lesson.storyOpening
        let combined = [opening, passage, lesson.missionPrompt].joined(separator: " ")

        let topicDef = TopicLibrary.definition(for: lesson.theme)

        var characters = Self.extractProperNames(from: combined)
        if characters.isEmpty {
            characters = Self.defaultCharacters(for: lesson.theme)
        }

        let animalsOrObjects = Array(Set(
            topicDef.mathContexts.flatMap(Self.tokenize)
                + topicDef.vocabularyWords.map { $0.lowercased() }
                + Self.themeObjects(for: lesson.theme)
        )).sorted()

        let locations = Array(Set(
            topicDef.storySettings.flatMap(Self.tokenize)
                + Self.themeLocations(for: lesson.theme)
        )).sorted()

        let actions = Self.themeActions(for: lesson.theme)
        let vocabulary = lesson.vocabularyWords.map(\.word)
        let facts = lesson.knowledgeFacts.map(\.fact)

        return LessonContextBank(
            characters: characters,
            animalsOrObjects: animalsOrObjects,
            locations: locations,
            actions: actions,
            vocabulary: vocabulary,
            establishedFacts: facts,
            commonMisconceptions: Self.misconceptions(for: lesson.theme),
            excludedConcepts: Self.excludedConcepts(for: lesson.theme) + [
                "toaster", "sandwich", "pizza", "homework", "parking meter", "grocery"
            ],
            primarySubject: lesson.primarySubject,
            primaryTopicId: lesson.primaryTopicId,
            learningObjective: lesson.learningObjectives.first
                ?? lesson.readingSkill,
            intendedSkill: lesson.primarySubject == .math ? lesson.mathSkill : lesson.readingSkill,
            storySummary: Self.summarize(combined),
            ageBand: lesson.ageTarget,
            readingLevel: lesson.readingLevel
        )
    }

    /// Lightweight bank when only a topic is known (generators before full lesson exists).
    static func from(topic: Topic, primarySubject: PrimarySubject, readingLevel: ReadingLevel = .earlyReader) -> LessonContextBank {
        let def = TopicLibrary.definition(for: topic)
        return LessonContextBank(
            characters: defaultCharacters(for: topic),
            animalsOrObjects: themeObjects(for: topic) + def.vocabularyWords.map { $0.lowercased() },
            locations: themeLocations(for: topic) + def.storySettings.flatMap(tokenize),
            actions: themeActions(for: topic),
            vocabulary: def.vocabularyWords,
            establishedFacts: [],
            commonMisconceptions: misconceptions(for: topic),
            excludedConcepts: excludedConcepts(for: topic),
            primarySubject: primarySubject,
            primaryTopicId: nil,
            learningObjective: def.name,
            intendedSkill: primarySubject.defaultSkillLabel,
            storySummary: "A learning adventure about \(def.name.lowercased()).",
            ageBand: "5-8",
            readingLevel: readingLevel
        )
    }

    // MARK: - Theme defaults

    private static func defaultCharacters(for topic: Topic) -> [String] {
        switch topic {
        case .sharks, .oceanAnimals: return ["Finn", "Marina"]
        case .horses: return ["Sunny"]
        case .dinosaurs: return ["Dottie"]
        case .space, .planets, .rockets: return ["Nova"]
        default: return []
        }
    }

    private static func themeObjects(for topic: Topic) -> [String] {
        switch topic {
        case .sharks, .oceanAnimals:
            return ["shark", "fish", "coral", "reef", "bubble", "fin", "gill", "cave", "kelp"]
        case .horses:
            return ["horse", "foal", "hay", "stall", "saddle", "mane", "stable"]
        case .dinosaurs:
            return ["dinosaur", "fossil", "footprint", "egg", "herd", "fern", "nest"]
        case .space, .planets, .rockets:
            return ["rocket", "moon", "orbit", "crew", "suit", "supply", "star"]
        default:
            return QuestionQualityValidator.topicKeywords(for: topic)
        }
    }

    private static func themeLocations(for topic: Topic) -> [String] {
        switch topic {
        case .sharks, .oceanAnimals: return ["reef", "cave", "ocean", "lagoon", "tide pool"]
        case .horses: return ["stable", "paddock", "barn", "pasture", "trail"]
        case .dinosaurs: return ["valley", "nest", "watering hole", "museum"]
        case .space, .planets, .rockets: return ["launch pad", "moon", "orbit", "station"]
        default: return []
        }
    }

    private static func themeActions(for topic: Topic) -> [String] {
        switch topic {
        case .sharks, .oceanAnimals: return ["swim", "hide", "search", "breathe", "follow"]
        case .horses: return ["gallop", "nudge", "graze", "build", "rest"]
        case .dinosaurs: return ["walk", "search", "nest", "roam", "discover"]
        case .space, .planets, .rockets: return ["launch", "count", "check", "orbit", "land"]
        default: return ["explore", "help", "learn", "notice"]
        }
    }

    private static func misconceptions(for topic: Topic) -> [String] {
        switch topic {
        case .sharks, .oceanAnimals:
            return ["All sharks are always dangerous", "Sharks breathe with lungs like people"]
        case .horses:
            return ["Horses sleep standing only because they cannot lie down"]
        case .dinosaurs:
            return ["All dinosaurs lived at the same time"]
        case .space, .planets, .rockets:
            return ["There is air outside a rocket the same as on Earth"]
        default:
            return []
        }
    }

    private static func excludedConcepts(for topic: Topic) -> [String] {
        // Concepts that should not appear as distractors for this topic.
        let common = ["toaster", "sandwich", "pizza", "sock", "email", "homework"]
        switch topic {
        case .sharks, .oceanAnimals:
            return common + ["desert dune", "classroom desk", "mountain lake"]
        case .horses:
            return common + ["coral reef", "rocket fuel"]
        case .dinosaurs:
            return common + ["parking lot", "grocery store"]
        case .space, .planets, .rockets:
            return common + ["stable stall", "coral cave"]
        default:
            return common
        }
    }

    private static func summarize(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= 220 { return trimmed }
        return String(trimmed.prefix(217)) + "…"
    }

    private static func extractProperNames(from text: String) -> [String] {
        let known = ["Finn", "Marina", "Sunny", "Dottie", "Nova", "Maya", "Leo", "Sam"]
        return known.filter { text.contains($0) }
    }

    static func tokenize(_ text: String) -> [String] {
        text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 2 }
    }
}
