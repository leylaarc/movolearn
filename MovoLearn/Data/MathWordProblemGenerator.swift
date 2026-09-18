import Foundation

/// Math skills covered by approved word-problem patterns.
enum MathWordProblemSkill: String, CaseIterable {
    case addition
    case subtraction
    case multiplication
    case division
    case comparing
    case counting
    case missingNumber
    case fractions
    case measurement
    case time
    case money
    case shapes
    case multiStep

    var displayName: String {
        switch self {
        case .addition: return "Addition"
        case .subtraction: return "Subtraction"
        case .multiplication: return "Equal groups"
        case .division: return "Sharing equally"
        case .comparing: return "Comparing numbers"
        case .counting: return "Counting"
        case .missingNumber: return "Missing numbers"
        case .fractions: return "Simple fractions"
        case .measurement: return "Measurement"
        case .time: return "Time"
        case .money: return "Money"
        case .shapes: return "Shapes and geometry"
        case .multiStep: return "Word problems"
        }
    }
}

/// Builds natural, theme-coherent math word problems from approved sentence patterns.
/// Numbers vary by topic seed and math level so lessons do not reuse one arithmetic skeleton.
enum MathWordProblemGenerator {

    // MARK: - Public API

    /// Stable seed so the same topic×levels stay consistent, but different topics diverge.
    static func varietySeed(topic: Topic, mathLevel: MathLevel, readingLevel: ReadingLevel) -> Int {
        var hasher = Hasher()
        hasher.combine("math-variety-v2")
        hasher.combine(topic.rawValue)
        hasher.combine(mathLevel.rawValue)
        hasher.combine(readingLevel.rawValue)
        return abs(hasher.finalize())
    }

    /// Generate validated math challenges for a topic, reading level, and math ability.
    static func generateQuestions(
        topic: Topic,
        seed: Int,
        level: ReadingLevel,
        mathLevel: MathLevel = .developing,
        count: Int,
        preferredSkills: [MathWordProblemSkill]? = nil,
        passage: String? = nil,
        age: Int? = nil
    ) -> [LessonQuestion] {
        let effectiveLevel = effectiveReadingLevel(reading: level, math: mathLevel)
        let rules = LessonDifficultyRules.profile(for: effectiveLevel)
        var skillPool = preferredSkills?.isEmpty == false
            ? preferredSkills!
            : skills(for: effectiveLevel, mathLevel: mathLevel, seed: seed, age: age)
        skillPool = curriculumSkills(skillPool, age: age)
        if skillPool.isEmpty {
            skillPool = [.addition, .subtraction, .counting, .comparing]
        }
        let scenes = rankedScenes(for: topic, passage: passage)
        var questions: [LessonQuestion] = []
        var usedEquations = Set<String>()
        var attempt = 0
        let target = max(count, 3)

        while questions.count < target && attempt < target * 20 {
            let skill = skillPool[(seed &+ attempt) % skillPool.count]
            let scene = scenes[(seed &+ attempt &* 5) % scenes.count]
            let patternIndex = seed &+ attempt &* 17 &+ skill.rawValue.hashValue
            if let draft = build(
                skill: skill,
                scene: scene,
                topic: topic,
                seed: patternIndex,
                level: effectiveLevel,
                mathLevel: mathLevel,
                age: age
            ) {
                let equationKey = normalizeEquation(draft.explanation)
                let wordingIssues = QuestionQualityValidator.validateMathWordProblemPrompt(
                    draft.prompt,
                    expectedAnswer: draft.answer,
                    operation: draft.operation
                )
                let question = LessonQuestion(
                    subject: .math,
                    type: .multipleChoice,
                    responseType: .multipleChoice,
                    prompt: draft.prompt,
                    choices: draft.choices,
                    correctAnswer: "\(draft.answer)",
                    explanation: draft.explanation,
                    difficultyLevel: effectiveLevel
                )
                let choiceIssues = QuestionQualityValidator.validate(question, topic: topic).issues
                let mathIssues = MathProblemValidator.validate(
                    question,
                    mathLevel: mathLevel,
                    recentPrompts: questions.map(\.prompt)
                ).issues
                let proseOK = ChildFacingProseQualityValidator.passes(draft.prompt, allowShortImperative: true)
                    && ChildFacingProseQualityValidator.passes(draft.explanation, allowShortImperative: true)
                if wordingIssues.isEmpty && choiceIssues.isEmpty && mathIssues.isEmpty && proseOK {
                    let duplicatePrompt = questions.contains {
                        $0.prompt.localizedCaseInsensitiveCompare(question.prompt) == .orderedSame
                    }
                    if !duplicatePrompt && !usedEquations.contains(equationKey) {
                        usedEquations.insert(equationKey)
                        questions.append(question)
                    }
                }
            }
            attempt += 1
        }

        while questions.count < target {
            let scene = scenes[questions.count % scenes.count]
            let fallback = safeAdditionFallback(
                scene: scene,
                seed: seed &+ questions.count &* 31,
                level: effectiveLevel,
                mathLevel: mathLevel,
                age: age
            )
            let equationKey = normalizeEquation(fallback.explanation ?? "")
            if !usedEquations.contains(equationKey) {
                usedEquations.insert(equationKey)
                questions.append(fallback)
            } else {
                // Last-resort unique addends when collisions persist.
                let a = 1 + ((seed &+ questions.count) % 4)
                let b = 1 + ((seed &+ questions.count &* 3) % 4)
                let sum = min(a + b, LevelSkillProgressions.mathNumberRange(for: mathLevel, age: age).upperBound)
                questions.append(
                    LessonQuestion(
                        subject: .math,
                        type: .multipleChoice,
                        responseType: .multipleChoice,
                        prompt: "\(capWord(a)) \(noun(a, scene)) \(scene.groupStateVerb) \(scene.location). \(capWord(sum - a)) more \(noun(sum - a, scene)) arrived. How many \(scene.objectPlural) are there now?",
                        choices: choices(for: sum, seed: seed &+ questions.count),
                        correctAnswer: "\(sum)",
                        explanation: "\(a) + \(sum - a) = \(sum).",
                        difficultyLevel: effectiveLevel
                    )
                )
            }
        }

        return Array(questions.prefix(max(rules.mathQuestionRange.upperBound, count)))
    }

    /// Equal-group lessons: pack the story's objects into the group size the passage names,
    /// then solve related multiply/divide problems with those same objects.
    static func generateGroupingQuestions(
        topic: Topic,
        seed: Int,
        level: ReadingLevel,
        mathLevel: MathLevel,
        count: Int,
        passage: String? = nil,
        age: Int? = nil
    ) -> [LessonQuestion] {
        if let age, !AgeGradeLearningStandards.allowsMultiplicativeMath(forAge: age) {
            return generateQuestions(
                topic: topic,
                seed: seed,
                level: level,
                mathLevel: mathLevel,
                count: count,
                preferredSkills: [.addition, .subtraction, .counting],
                passage: passage,
                age: age
            )
        }
        let effectiveLevel = effectiveReadingLevel(reading: level, math: mathLevel)
        let scenes = rankedScenes(for: topic, passage: passage)
        guard !scenes.isEmpty else { return [] }

        let spec = groupingSpec(from: passage)
        let packScene: MathCountableScene
        if let spec {
            packScene = scenes[0].applyingStory(
                character: spec.character,
                pronoun: spec.pronoun,
                objectSingular: spec.singular,
                objectPlural: spec.plural
            )
        } else {
            packScene = scenes[abs(seed) % scenes.count]
        }
        let groupSize = spec?.groupSize ?? [5, 10, 4][abs(seed) % 3]
        let relatedScene = spec == nil
            ? scenes[abs(seed &+ 3) % scenes.count]
            : packScene

        var drafts: [Draft] = []
        if let groups = groupsOf(
            size: groupSize,
            scene: packScene,
            seed: seed,
            mathLevel: mathLevel,
            preferredTotal: spec?.count,
            age: age
        ) {
            drafts.append(groups)
        }
        drafts.append(
            multiplication(
                scene: relatedScene,
                seed: seed &+ 19,
                mathLevel: mathLevel
            )
        )
        drafts.append(
            division(
                scene: relatedScene,
                seed: seed &+ 41,
                mathLevel: mathLevel
            )
        )

        var questions: [LessonQuestion] = []
        var usedEquations = Set<String>()
        for (index, draft) in drafts.enumerated() {
            if questions.count >= count { break }
            let question = LessonQuestion(
                subject: .math,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: draft.prompt,
                choices: draft.choices,
                correctAnswer: "\(draft.answer)",
                explanation: draft.explanation,
                difficultyLevel: effectiveLevel
            )
            let wordingIssues = QuestionQualityValidator.validateMathWordProblemPrompt(
                draft.prompt,
                expectedAnswer: draft.answer,
                operation: draft.operation
            )
            let choiceIssues = QuestionQualityValidator.validate(question, topic: topic).issues
            let mathIssues = MathProblemValidator.validate(
                question,
                mathLevel: mathLevel,
                recentPrompts: questions.map(\.prompt)
            ).issues
            let proseOK = ChildFacingProseQualityValidator.passes(draft.prompt, allowShortImperative: true)
                && ChildFacingProseQualityValidator.passes(draft.explanation, allowShortImperative: true)
            let equationKey = normalizeEquation(draft.explanation)
            if wordingIssues.isEmpty && choiceIssues.isEmpty && mathIssues.isEmpty && proseOK
                && !usedEquations.contains(equationKey) {
                usedEquations.insert(equationKey)
                questions.append(question)
            } else if index == 0, mathIssues.isEmpty, proseOK {
                usedEquations.insert(equationKey)
                questions.append(question)
            }
        }

        if questions.isEmpty {
            return generateQuestions(
                topic: topic,
                seed: seed,
                level: level,
                mathLevel: mathLevel,
                count: count,
                preferredSkills: [.multiplication, .division],
                passage: passage,
                age: age
            )
        }
        if questions.count < count {
            let extra = generateQuestions(
                topic: topic,
                seed: seed &+ 91,
                level: level,
                mathLevel: mathLevel,
                count: count - questions.count,
                preferredSkills: [.multiplication, .division],
                passage: passage,
                age: age
            )
            for question in extra where questions.count < count {
                let key = normalizeEquation(question.explanation ?? "")
                if usedEquations.insert(key).inserted {
                    questions.append(question)
                }
            }
        }
        return Array(questions.prefix(count))
    }

    /// Prefer countable objects that actually appear in the lesson passage.
    private static func rankedScenes(for topic: Topic, passage: String?) -> [MathCountableScene] {
        let scenes = MathWordProblemScenes.scenes(for: topic)
        guard let passage, !passage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return scenes
        }
        let haystack = passage.lowercased()
        func hitScore(_ scene: MathCountableScene) -> Int {
            var score = 0
            if haystack.contains(scene.objectPlural.lowercased()) { score += 2 }
            if haystack.contains(scene.objectSingular.lowercased()) { score += 1 }
            return score
        }
        return scenes.sorted { hitScore($0) > hitScore($1) }
    }

    static func primarySkillName(seed: Int, level: ReadingLevel, mathLevel: MathLevel = .developing) -> String {
        skills(
            for: effectiveReadingLevel(reading: level, math: mathLevel),
            mathLevel: mathLevel,
            seed: seed
        ).first?.displayName ?? "Word problems"
    }

    // MARK: - Skill selection

    private static func effectiveReadingLevel(reading: ReadingLevel, math: MathLevel) -> ReadingLevel {
        _ = math
        return reading
    }

    private static func skills(for level: ReadingLevel, mathLevel: MathLevel, seed: Int, age: Int? = nil) -> [MathWordProblemSkill] {
        let pool: [MathWordProblemSkill]
        switch mathLevel {
        case .emerging:
            pool = [.counting, .comparing, .addition]
        case .developing:
            pool = [.addition, .subtraction, .counting, .comparing, .missingNumber]
        case .secure:
            pool = [.addition, .subtraction, .missingNumber, .multiplication, .division, .measurement, .shapes]
        case .advancing:
            pool = [
                .multiStep, .multiplication, .division, .fractions, .measurement,
                .missingNumber, .addition, .subtraction, .shapes
            ]
        }
        _ = level
        let usable = {
            let filtered = curriculumSkills(pool, age: age)
            return filtered.isEmpty ? [.addition, .counting, .comparing] : filtered
        }()
        let start = abs(seed) % max(1, usable.count)
        return Array(usable[start...]) + Array(usable[..<start])
    }

    private static func curriculumSkills(_ pool: [MathWordProblemSkill], age: Int?) -> [MathWordProblemSkill] {
        guard let age else { return pool }
        var allowed = pool
        if !AgeGradeLearningStandards.allowsMultiplicativeMath(forAge: age) {
            allowed.removeAll { [.multiplication, .division, .fractions].contains($0) }
        }
        switch AgeGradeLearningStandards.band(age: age) {
        case .preK, .kindergarten, .grade1:
            allowed.removeAll { $0 == .multiStep }
        case .grade2, .grade3:
            break
        }
        return allowed
    }

    // MARK: - Draft model

    private struct Draft {
        let prompt: String
        let answer: Int
        let choices: [String]
        let explanation: String
        let operation: QuestionQualityValidator.MathOperationHint
    }

    private static func build(
        skill: MathWordProblemSkill,
        scene: MathCountableScene,
        topic: Topic,
        seed: Int,
        level: ReadingLevel,
        mathLevel: MathLevel,
        age: Int? = nil
    ) -> Draft? {
        _ = level
        switch skill {
        case .addition:
            return addition(scene: scene, seed: seed, mathLevel: mathLevel, age: age)
        case .subtraction:
            return subtraction(scene: scene, seed: seed, mathLevel: mathLevel, age: age)
        case .multiplication:
            return multiplication(scene: scene, seed: seed, mathLevel: mathLevel, age: age)
        case .division:
            return division(scene: scene, seed: seed, mathLevel: mathLevel, age: age)
        case .comparing:
            return comparing(scene: scene, seed: seed, mathLevel: mathLevel, age: age)
        case .counting:
            return counting(scene: scene, seed: seed, mathLevel: mathLevel, age: age)
        case .missingNumber:
            return missingNumber(scene: scene, seed: seed, mathLevel: mathLevel, age: age)
        case .fractions:
            return fractions(scene: scene, seed: seed, mathLevel: mathLevel)
        case .measurement:
            return measurement(scene: scene, topic: topic, seed: seed, mathLevel: mathLevel)
        case .time:
            return time(scene: scene, seed: seed, mathLevel: mathLevel)
        case .money:
            return money(scene: scene, seed: seed, mathLevel: mathLevel)
        case .shapes:
            return shapes(topic: topic, seed: seed)
        case .multiStep:
            return multiStep(scene: scene, seed: seed, mathLevel: mathLevel)
        }
    }

    // MARK: - Number ranges by math level

    private static func addends(seed: Int, mathLevel: MathLevel, age: Int? = nil) -> (Int, Int) {
        let maxSum = LevelSkillProgressions.mathNumberRange(for: mathLevel, age: age).upperBound
        let aMax: Int
        let bMax: Int
        switch mathLevel {
        case .emerging:
            aMax = 5; bMax = 5
        case .developing:
            aMax = 12; bMax = 9
        case .secure:
            aMax = 45; bMax = 35
        case .advancing:
            aMax = 80; bMax = 50
        }
        var a = (abs(seed) % aMax) + 1
        var b = (abs(seed / 7) % bMax) + 1
        if a + b > maxSum {
            b = max(1, maxSum - a)
        }
        if a + b > maxSum {
            a = max(1, maxSum / 2)
            b = max(1, maxSum - a)
        }
        return (a, b)
    }

    private static func subtractionPair(seed: Int, mathLevel: MathLevel, age: Int? = nil) -> (start: Int, leave: Int) {
        let maxN = LevelSkillProgressions.mathNumberRange(for: mathLevel, age: age).upperBound
        let start: Int
        let leave: Int
        switch mathLevel {
        case .emerging:
            start = (abs(seed) % 6) + 4          // 4...9
            leave = (abs(seed / 5) % (start - 1)) + 1
        case .developing:
            start = (abs(seed) % 12) + 8         // 8...19
            leave = (abs(seed / 5) % min(9, start - 1)) + 1
        case .secure:
            start = (abs(seed) % 60) + 20        // 20...79
            leave = (abs(seed / 5) % min(35, start - 1)) + 1
        case .advancing:
            start = (abs(seed) % 120) + 30       // 30...149
            leave = (abs(seed / 5) % min(60, start - 1)) + 1
        }
        let cappedStart = min(start, maxN)
        let cappedLeave = min(leave, max(1, cappedStart - 1))
        return (cappedStart, cappedLeave)
    }

    private static func equalGroups(seed: Int, mathLevel: MathLevel, age: Int? = nil) -> (groups: Int, perGroup: Int) {
        let maxProduct = LevelSkillProgressions.mathNumberRange(for: mathLevel, age: age).upperBound
        let groups: Int
        let perGroup: Int
        switch mathLevel {
        case .emerging:
            groups = (abs(seed) % 2) + 2         // 2...3
            perGroup = (abs(seed / 2) % 2) + 2   // 2...3
        case .developing:
            groups = (abs(seed) % 3) + 2         // 2...4
            perGroup = (abs(seed / 2) % 4) + 2   // 2...5
        case .secure:
            groups = (abs(seed) % 5) + 2         // 2...6
            perGroup = (abs(seed / 2) % 8) + 2   // 2...9
        case .advancing:
            groups = (abs(seed) % 6) + 2         // 2...7
            perGroup = (abs(seed / 2) % 9) + 2   // 2...10
        }
        if groups * perGroup > maxProduct {
            let g = min(groups, max(2, maxProduct / 4))
            let p = max(2, min(perGroup, maxProduct / g))
            return (g, p)
        }
        return (groups, perGroup)
    }

    // MARK: - Addition patterns

    private static func addition(scene: MathCountableScene, seed: Int, mathLevel: MathLevel, age: Int? = nil) -> Draft {
        let (a, b) = addends(seed: seed, mathLevel: mathLevel, age: age)
        let sum = a + b
        let objects = noun(a, scene)
        let moreObjects = noun(b, scene)
        let pattern = abs(seed) % 4

        let prompt: String
        switch pattern {
        case 0:
            prompt = "\(capWord(a)) \(objects) \(scene.groupStateVerb) \(scene.location). \(capWord(b)) more \(moreObjects) arrived. How many \(scene.objectPlural) are there now?"
        case 1:
            if let character = scene.character {
                prompt = "\(cap(character)) \(scene.collectVerb) \(a) \(objects) \(scene.location). Then \(scene.pronoun) found \(quantityPhrase(b)) more. How many \(scene.objectPlural) does \(character) have now?"
            } else {
                prompt = "There were \(a) \(objects) \(scene.location). Then \(quantityPhrase(b)) more \(moreObjects) joined them. How many \(scene.objectPlural) are there altogether?"
            }
        case 2:
            prompt = "You see \(a) \(objects) \(scene.location) and \(b) more \(moreObjects) nearby. How many \(scene.objectPlural) do you see in all?"
        default:
            prompt = "\(capWord(a)) \(objects) \(scene.groupStateVerb) \(scene.location). \(capWord(b)) \(moreObjects) joined them. How many \(scene.objectPlural) are there altogether?"
        }

        return draft(prompt: prompt, answer: sum, explanation: "\(a) + \(b) = \(sum).", operation: .addition(a, b))
    }

    // MARK: - Subtraction patterns

    private static func subtraction(scene: MathCountableScene, seed: Int, mathLevel: MathLevel, age: Int? = nil) -> Draft {
        let pair = subtractionPair(seed: seed, mathLevel: mathLevel, age: age)
        let start = pair.start
        let leave = pair.leave
        let left = start - leave
        let objects = noun(start, scene)
        let leaving = noun(leave, scene)
        let leaveVerb = leave == 1 ? scene.leaveVerbSingular : scene.leaveVerbPlural
        let pattern = abs(seed) % 4

        let prompt: String
        switch pattern {
        case 0:
            prompt = "\(capWord(start)) \(objects) \(scene.groupStateVerb) \(scene.location). \(capWord(leave)) \(leaving) \(leaveVerb). How many \(scene.objectPlural) are left?"
        case 1:
            if let character = scene.character, canShare(scene) {
                prompt = "\(cap(character)) had \(start) \(objects). \(cap(scene.pronoun)) \(scene.giveVerb) \(leave) \(leaving). How many \(scene.objectPlural) does \(character) still have?"
            } else {
                prompt = "There were \(start) \(objects) \(scene.location). \(capWord(leave)) \(leaving) \(leaveVerb). How many \(scene.objectPlural) remain?"
            }
        case 2:
            prompt = "\(capWord(start)) \(objects) \(scene.groupStateVerb) \(scene.location). Then \(leave) \(leaving) \(leaveVerb). How many \(scene.objectPlural) are still there?"
        default:
            if let character = scene.character, canShare(scene) {
                prompt = "\(cap(character)) \(scene.collectVerb) \(start) \(objects). \(cap(scene.pronoun)) \(scene.giveVerb) \(leave) \(leaving) with a friend. How many \(scene.objectPlural) are left?"
            } else {
                prompt = "A group of \(start) \(objects) \(scene.groupStateVerb) \(scene.location). \(capWord(leave)) \(leaving) \(leaveVerb). How many \(scene.objectPlural) are left?"
            }
        }

        return draft(prompt: prompt, answer: left, explanation: "\(start) − \(leave) = \(left).", operation: .subtraction(start, leave))
    }

    // MARK: - Equal groups (story-sized)

    private struct GroupingSpec {
        let character: String?
        let pronoun: String
        let count: Int
        let groupSize: Int
        let singular: String
        let plural: String
    }

    private static func groupingSpec(from passage: String?) -> GroupingSpec? {
        guard let passage, !passage.isEmpty else { return nil }
        guard let regex = try? NSRegularExpression(
            pattern: #"(?i)(?:packs?\s+(\d+)\s+(.+?)\s+into groups of (\d+)|has\s+(\d+)\s+(.+?)\.\s+.+?\s+groups of (\d+))"#,
            options: []
        ) else { return nil }
        let ns = passage as NSString
        guard let match = regex.firstMatch(in: passage, range: NSRange(location: 0, length: ns.length)),
              match.numberOfRanges >= 4 else {
            return nil
        }
        func g(_ i: Int) -> String {
            guard i < match.numberOfRanges else { return "" }
            let range = match.range(at: i)
            guard range.location != NSNotFound else { return "" }
            return ns.substring(with: range).trimmingCharacters(in: .whitespaces)
        }
        let packed = Int(g(1)) ?? 0
        let hasCount = Int(g(4)) ?? 0
        let count = packed > 0 ? packed : hasCount
        let plural = packed > 0 ? g(2) : g(5)
        let size = packed > 0 ? (Int(g(3)) ?? 0) : (Int(g(6)) ?? 0)
        guard count > 0, size > 0, !plural.isEmpty else { return nil }
        let character = firstNamedCharacter(in: passage)
        let pronoun = pronounForName(character ?? "", passage: passage)
        return GroupingSpec(
            character: character,
            pronoun: pronoun,
            count: count,
            groupSize: size,
            singular: singularize(plural),
            plural: plural
        )
    }

    private static func firstNamedCharacter(in passage: String) -> String? {
        guard let regex = try? NSRegularExpression(
            pattern: #"^((?:(?:Mr|Mrs|Ms|Dr|Chef|Ranger|Farmer|Keeper|Captain)\.?\s+)?[A-Z][A-Za-z]+(?:\s+[A-Z][A-Za-z]+)?) "#,
            options: []
        ) else { return nil }
        let ns = passage as NSString
        guard let match = regex.firstMatch(in: passage, range: NSRange(location: 0, length: min(ns.length, 80))) else {
            return nil
        }
        let name = ns.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? nil : name
    }

    private static func pronounForName(_ name: String, passage: String) -> String {
        let lower = passage.lowercased()
        if lower.contains(" she ") || lower.contains(" she.") { return "she" }
        if lower.contains(" he ") || lower.contains(" he.") { return "he" }
        if name.lowercased() == "they" { return "they" }
        return "they"
    }

    private static func singularize(_ plural: String) -> String {
        let lower = plural.lowercased()
        if lower.hasSuffix("ies"), plural.count > 3 {
            return String(plural.dropLast(3)) + "y"
        }
        if lower.hasSuffix("ses") || lower.hasSuffix("ches") || lower.hasSuffix("shes") {
            return String(plural.dropLast(2))
        }
        if lower.hasSuffix("s"), !lower.hasSuffix("ss") {
            return String(plural.dropLast())
        }
        return plural
    }

    private static func groupsOf(
        size: Int,
        scene: MathCountableScene,
        seed: Int,
        mathLevel: MathLevel,
        preferredTotal: Int? = nil,
        age: Int? = nil
    ) -> Draft? {
        guard size > 0 else { return nil }
        let maxN = LevelSkillProgressions.mathNumberRange(for: mathLevel, age: age).upperBound
        let total: Int
        let groups: Int
        if let preferredTotal, preferredTotal > 0, preferredTotal % size == 0, preferredTotal <= maxN {
            total = preferredTotal
            groups = preferredTotal / size
        } else {
            let maxGroups = max(1, maxN / size)
            let span = max(1, min(5, maxGroups))
            groups = min(maxGroups, 2 + (abs(seed) % span))
            total = groups * size
            guard total <= maxN else { return nil }
        }
        guard groups >= 1 else { return nil }

        let objects = noun(total, scene)
        let prompt: String
        if let character = scene.character {
            let actor = scene.pronoun == "they" ? cap(character) : cap(scene.pronoun)
            let put = scene.pronoun == "they" ? "put" : "puts"
            prompt = "\(cap(character)) has \(total) \(objects). \(actor) \(put) them in groups of \(size). How many groups is that?"
        } else {
            prompt = "You have \(total) \(objects). You put them in groups of \(size). How many groups is that?"
        }
        return draft(
            prompt: prompt,
            answer: groups,
            explanation: "\(total) ÷ \(size) = \(groups).",
            operation: .division(total, size)
        )
    }

    // MARK: - Multiplication (equal groups)

    private static func multiplication(scene: MathCountableScene, seed: Int, mathLevel: MathLevel, age: Int? = nil) -> Draft {
        let pair = equalGroups(seed: seed, mathLevel: mathLevel, age: age)
        let groups = pair.groups
        let perGroup = pair.perGroup
        let product = groups * perGroup
        let pattern = abs(seed) % 3

        let prompt: String
        switch pattern {
        case 0:
            prompt = "There are \(groups) groups of \(scene.objectPlural) \(scene.location). Each group has \(perGroup) \(scene.objectPlural). How many \(scene.objectPlural) are there in all?"
        case 1:
            if let character = scene.character {
                prompt = "\(cap(character)) packs \(groups) bags. Each bag holds \(perGroup) \(scene.objectPlural). How many \(scene.objectPlural) did \(scene.pronoun) pack?"
            } else {
                prompt = "\(capWord(groups)) baskets each hold \(perGroup) \(scene.objectPlural). How many \(scene.objectPlural) are there altogether?"
            }
        default:
            prompt = "There are \(groups) rows of \(scene.objectPlural). Each row has \(perGroup) \(scene.objectPlural). How many \(scene.objectPlural) are there in all?"
        }

        return draft(
            prompt: prompt,
            answer: product,
            explanation: "\(groups) × \(perGroup) = \(product).",
            operation: .multiplication(groups, perGroup)
        )
    }

    // MARK: - Division (fair sharing)

    private static func division(scene: MathCountableScene, seed: Int, mathLevel: MathLevel, age: Int? = nil) -> Draft {
        let pair = equalGroups(seed: seed &+ 11, mathLevel: mathLevel, age: age)
        let groups = pair.groups
        let perGroup = pair.perGroup
        let total = groups * perGroup
        let pattern = abs(seed) % 3

        let prompt: String
        switch pattern {
        case 0:
            prompt = "\(capWord(total)) \(noun(total, scene)) are shared equally among \(groups) friends. How many \(scene.objectPlural) does each friend get?"
        case 1:
            if let character = scene.character {
                prompt = "\(cap(character)) has \(total) \(noun(total, scene)) and puts them into \(groups) equal piles. How many \(scene.objectPlural) are in each pile?"
            } else {
                prompt = "You sort \(total) \(noun(total, scene)) into \(groups) equal groups. How many \(scene.objectPlural) are in each group?"
            }
        default:
            prompt = "\(capWord(total)) \(noun(total, scene)) \(scene.groupStateVerb) \(scene.location). They are shared equally by \(groups) friends. How many \(scene.objectPlural) does each friend get?"
        }

        return draft(
            prompt: prompt,
            answer: perGroup,
            explanation: "\(total) ÷ \(groups) = \(perGroup).",
            operation: .division(total, groups)
        )
    }

    // MARK: - Multi-step (advancing)

    private static func multiStep(scene: MathCountableScene, seed: Int, mathLevel: MathLevel) -> Draft {
        let pair = equalGroups(seed: seed, mathLevel: mathLevel == .emerging ? .developing : mathLevel)
        let groups = pair.groups
        let perGroup = pair.perGroup
        let product = groups * perGroup
        let prompt: String
        if let character = scene.character {
            prompt = "\(cap(character)) fills \(groups) boxes with \(perGroup) \(scene.objectPlural) in each box. How many \(scene.objectPlural) is that?"
        } else {
            prompt = "There are \(groups) baskets with \(perGroup) \(scene.objectPlural) in each basket. How many \(scene.objectPlural) altogether?"
        }
        return draft(
            prompt: prompt,
            answer: product,
            explanation: "\(groups) × \(perGroup) = \(product).",
            operation: .multiplication(groups, perGroup)
        )
    }

    // MARK: - Comparing

    private static func comparing(scene: MathCountableScene, seed: Int, mathLevel: MathLevel, age: Int? = nil) -> Draft {
        let maxN = min(LevelSkillProgressions.mathNumberRange(for: mathLevel, age: age).upperBound, mathLevel == .emerging ? 10 : 20)
        var a = (abs(seed) % max(3, maxN - 2)) + 2
        var b = (abs(seed / 4) % max(2, maxN - 3)) + 1
        if b == a { b = a == maxN ? a - 1 : a + 1 }
        a = min(a, maxN)
        b = min(b, maxN)
        let more = abs(a - b)
        let largerIsA = a > b
        let pattern = abs(seed) % 3

        let prompt: String
        switch pattern {
        case 0:
            prompt = "There are \(a) \(noun(a, scene)) \(scene.location) and \(b) \(noun(b, scene)) nearby. How many more \(scene.objectPlural) are in the larger group?"
        case 1:
            if largerIsA {
                prompt = "One group has \(a) \(noun(a, scene)). Another group has \(b) \(noun(b, scene)). How many more \(scene.objectPlural) does the first group have?"
            } else {
                prompt = "One group has \(a) \(noun(a, scene)). Another group has \(b) \(noun(b, scene)). How many more \(scene.objectPlural) does the second group have?"
            }
        default:
            prompt = "You count \(a) \(noun(a, scene)) and then \(b) \(noun(b, scene)). What is the difference between the two groups?"
        }

        return draft(
            prompt: prompt,
            answer: more,
            explanation: "\(max(a, b)) − \(min(a, b)) = \(more).",
            operation: .subtraction(max(a, b), min(a, b))
        )
    }

    // MARK: - Counting

    private static func counting(scene: MathCountableScene, seed: Int, mathLevel: MathLevel, age: Int? = nil) -> Draft {
        let maxN = min(LevelSkillProgressions.mathNumberRange(for: mathLevel, age: age).upperBound, mathLevel == .emerging ? 10 : 20)
        let n = (abs(seed) % max(4, maxN - 2)) + 2
        let pattern = abs(seed) % 3
        let prompt: String
        switch pattern {
        case 0:
            prompt = "Count the \(scene.objectPlural): there are \(numberWord(n)) \(noun(n, scene)) \(scene.location). How many \(scene.objectPlural) are there?"
        case 1:
            prompt = "\(capWord(n)) \(noun(n, scene)) \(scene.groupStateVerb) \(scene.location). How many \(scene.objectPlural) can you count?"
        default:
            if let character = scene.character {
                prompt = "\(cap(character)) points to \(numberWord(n)) \(noun(n, scene)) \(scene.location). How many \(scene.objectPlural) did \(scene.pronoun) point to?"
            } else {
                prompt = "You carefully count \(numberWord(n)) \(noun(n, scene)) \(scene.location). How many did you count?"
            }
        }
        return draft(prompt: prompt, answer: n, explanation: "The total is \(n).", operation: .identity(n))
    }

    // MARK: - Missing number

    private static func missingNumber(scene: MathCountableScene, seed: Int, mathLevel: MathLevel, age: Int? = nil) -> Draft {
        let (a, b) = addends(seed: seed, mathLevel: mathLevel, age: age)
        let sum = a + b
        let hideFirst = abs(seed) % 2 == 0
        let answer = hideFirst ? a : b
        let prompt: String
        if hideFirst {
            prompt = "Some \(scene.objectPlural) \(scene.groupStateVerb) \(scene.location). \(capWord(b)) more \(noun(b, scene)) arrived, and now there are \(sum). How many \(scene.objectPlural) were there at the start?"
        } else {
            prompt = "\(capWord(a)) \(noun(a, scene)) \(scene.groupStateVerb) \(scene.location). Some more arrived, and now there are \(sum). How many \(scene.objectPlural) joined?"
        }
        return draft(
            prompt: prompt,
            answer: answer,
            explanation: hideFirst ? "\(sum) − \(b) = \(a)." : "\(sum) − \(a) = \(b).",
            operation: .subtraction(sum, hideFirst ? b : a)
        )
    }

    // MARK: - Fractions (half / simple parts)

    private static func fractions(scene: MathCountableScene, seed: Int, mathLevel: MathLevel) -> Draft {
        let pool: [Int]
        switch mathLevel {
        case .emerging, .developing:
            pool = [4, 6, 8, 10]
        case .secure:
            pool = [8, 10, 12, 16, 20]
        case .advancing:
            pool = [12, 16, 20, 24, 30]
        }
        let wholes = pool[abs(seed) % pool.count]
        let answer = wholes / 2
        let pattern = abs(seed) % 2
        let prompt: String
        if pattern == 0 {
            prompt = "There are \(wholes) \(noun(wholes, scene)) \(scene.location). Half of them are moved. How many \(scene.objectPlural) were moved?"
        } else if let character = scene.character, canShare(scene) {
            prompt = "\(cap(character)) has \(wholes) \(noun(wholes, scene)) and gives half of them away. How many \(scene.objectPlural) does \(scene.pronoun) give away?"
        } else {
            prompt = "You split \(wholes) \(noun(wholes, scene)) into two equal groups. How many \(scene.objectPlural) are in each group?"
        }
        return draft(
            prompt: prompt,
            answer: answer,
            explanation: "Half of \(wholes) is \(answer).",
            operation: .division(wholes, 2)
        )
    }

    // MARK: - Measurement

    private static func measurement(scene: MathCountableScene, topic: Topic, seed: Int, mathLevel: MathLevel) -> Draft {
        let (a, b) = addends(seed: seed, mathLevel: mathLevel)
        let unit: String
        switch topic {
        case .space, .planets, .rockets: unit = "meters"
        case .dinosaurs, .nature, .volcanoes: unit = "steps"
        case .soccer, .basketball: unit = "feet"
        default: unit = "inches"
        }
        let sum = a + b
        let prompt = "A path \(scene.location) is \(a) \(unit) long. You measure \(b) more \(unit). How many \(unit) long is the path now?"
        return draft(prompt: prompt, answer: sum, explanation: "\(a) + \(b) = \(sum) \(unit).", operation: .addition(a, b))
    }

    // MARK: - Time

    private static func time(scene: MathCountableScene, seed: Int, mathLevel: MathLevel) -> Draft {
        _ = mathLevel
        let start = (abs(seed) % 5) + 1
        let hours = (abs(seed / 2) % 3) + 1
        let end = start + hours
        let prompt: String
        if let character = scene.character {
            prompt = "\(cap(character)) starts counting \(scene.objectPlural) at \(start) o'clock and finishes \(hours) hour\(hours == 1 ? "" : "s") later. What time is it then?"
        } else {
            prompt = "You begin an activity \(scene.location) at \(start) o'clock. It lasts \(hours) hour\(hours == 1 ? "" : "s"). What time do you finish?"
        }
        return draft(
            prompt: prompt,
            answer: end,
            explanation: "\(start) + \(hours) = \(end).",
            operation: .addition(start, hours)
        )
    }

    // MARK: - Money

    private static func money(scene: MathCountableScene, seed: Int, mathLevel: MathLevel) -> Draft {
        let (a, b) = addends(seed: seed, mathLevel: mathLevel)
        let sum = a + b
        let pattern = abs(seed) % 2
        let prompt: String
        if pattern == 0, let character = scene.character {
            prompt = "\(cap(character)) has \(a) cents and finds \(b) more cents near the \(scene.objectPlural). How many cents does \(scene.pronoun) have now?"
        } else {
            prompt = "You save \(a) cents, then earn \(b) more cents after counting \(scene.objectPlural). How many cents do you have in all?"
        }
        return draft(prompt: prompt, answer: sum, explanation: "\(a) + \(b) = \(sum) cents.", operation: .addition(a, b))
    }

    // MARK: - Shapes

    private static func shapes(topic: Topic, seed: Int) -> Draft {
        let shapes: [(String, Int)] = [
            ("triangle", 3),
            ("square", 4),
            ("rectangle", 4),
            ("pentagon", 5),
            ("hexagon", 6)
        ]
        let pick = shapes[abs(seed) % shapes.count]
        let themeHint: String
        switch topic {
        case .space, .planets, .rockets: themeHint = "on a mission badge"
        case .princesses, .castles, .fairies: themeHint = "on a castle banner"
        case .oceanAnimals, .sharks, .pirates: themeHint = "on a ship flag"
        case .dinosaurs: themeHint = "on a dig-site sign"
        default: themeHint = "on a colorful poster"
        }
        let prompt = "A \(pick.0) \(themeHint) has how many sides?"
        return draft(
            prompt: prompt,
            answer: pick.1,
            explanation: "A \(pick.0) has \(pick.1) sides.",
            operation: .identity(pick.1)
        )
    }

    // MARK: - Fallback

    private static func safeAdditionFallback(
        scene: MathCountableScene,
        seed: Int,
        level: ReadingLevel,
        mathLevel: MathLevel,
        age: Int? = nil
    ) -> LessonQuestion {
        let (a, b) = addends(seed: seed, mathLevel: mathLevel, age: age)
        let sum = a + b
        let prompt = "\(capWord(a)) \(noun(a, scene)) \(scene.groupStateVerb) \(scene.location). \(capWord(b)) more \(noun(b, scene)) arrived. How many \(scene.objectPlural) are there now?"
        return LessonQuestion(
            subject: .math,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: prompt,
            choices: choices(for: sum, seed: seed),
            correctAnswer: "\(sum)",
            explanation: "\(a) + \(b) = \(sum).",
            difficultyLevel: level
        )
    }

    // MARK: - Formatting helpers

    private static func draft(
        prompt: String,
        answer: Int,
        explanation: String,
        operation: QuestionQualityValidator.MathOperationHint
    ) -> Draft {
        Draft(
            prompt: prompt,
            answer: answer,
            choices: choices(for: answer, seed: answer &* 17 &+ prompt.count),
            explanation: explanation,
            operation: operation
        )
    }

    private static func choices(for answer: Int, seed: Int) -> [String] {
        var options = Set<Int>([answer])
        let deltas = [-1, 1, -2, 2, answer == 0 ? 1 : -answer]
        var i = 0
        while options.count < 3 && i < deltas.count {
            let value = answer + deltas[(abs(seed) + i) % deltas.count]
            if value > 0 || answer == 0 { options.insert(value) }
            i += 1
        }
        while options.count < 3 {
            options.insert(answer + options.count)
        }
        return options.sorted().prefix(3).map(String.init)
    }

    private static func normalizeEquation(_ explanation: String) -> String {
        explanation
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "×", with: "x")
            .replacingOccurrences(of: "÷", with: "/")
            .filter { $0.isNumber || "+-x/=,".contains($0) }
    }

    private static func noun(_ count: Int, _ scene: MathCountableScene) -> String {
        count == 1 ? scene.objectSingular : scene.objectPlural
    }

    /// Prefer number words for small counts so mid-sentence wording stays natural.
    private static func quantityPhrase(_ n: Int) -> String {
        n <= 12 ? numberWord(n) : "\(n)"
    }

    /// Only use character "share/give" templates when the verb truly means giving objects away.
    private static func canShare(_ scene: MathCountableScene) -> Bool {
        let sharing = ["shared", "gave", "gave away", "handed out", "handed", "sent"]
        return sharing.contains(scene.giveVerb)
    }

    private static func numberWord(_ n: Int) -> String {
        let words = [
            0: "zero", 1: "one", 2: "two", 3: "three", 4: "four",
            5: "five", 6: "six", 7: "seven", 8: "eight", 9: "nine", 10: "ten",
            11: "eleven", 12: "twelve"
        ]
        return words[n] ?? "\(n)"
    }

    private static func capWord(_ n: Int) -> String {
        let word = numberWord(n)
        return word.prefix(1).uppercased() + word.dropFirst()
    }

    private static func cap(_ text: String) -> String {
        guard let first = text.first else { return text }
        return String(first).uppercased() + text.dropFirst()
    }
}
