import Foundation

/// Builds matching questions strictly from passage evidence — never from loose word associations.
enum PassageMatchingQuestionGenerator {

    static let minimumPairCount = 3

    enum RelationshipType: String, CaseIterable, Equatable {
        case termToDefinition
        case itemToDescription
        case animalToBehavior
        case objectToLocation
        case eventToResult

        var prompt: String {
            switch self {
            case .termToDefinition:
                return "Match each word to what the passage says it means."
            case .itemToDescription:
                return "Match each item with what the passage says about it."
            case .animalToBehavior:
                return "Match each animal to what the passage says it does."
            case .objectToLocation:
                return "Match each thing to the place the passage names."
            case .eventToResult:
                return "Match each event to what the passage says happens next."
            }
        }

        var explanation: String {
            "Each match comes from a sentence in the reading passage."
        }
    }

    struct RejectedPair: Equatable {
        let left: String
        let right: String
        let reason: String
    }

    struct Candidate: Equatable {
        let left: String
        let right: String
        let supportingEvidence: String
        let relationshipType: RelationshipType
    }

    struct GenerationResult: Equatable {
        let question: LessonQuestion
        let acceptedPairs: [MatchingPair]
        let rejectedPairs: [RejectedPair]
        let relationshipType: RelationshipType?
        var usedMatching: Bool { relationshipType != nil && acceptedPairs.count >= minimumPairCount }
    }

    /// Generates a matching question when the passage supports ≥3 unambiguous pairs of one relationship type.
    /// Otherwise returns a passage-based multiple-choice comprehension question.
    static func generate(
        passage: String,
        topic: Topic,
        vocabulary: [VocabularyWord] = [],
        knowledgeFacts: [KnowledgeFact] = []
    ) -> GenerationResult {
        let sentences = splitSentences(passage)
        var rejected: [RejectedPair] = []

        let rawCandidates = extractCandidates(
            sentences: sentences,
            passage: passage,
            vocabulary: vocabulary,
            knowledgeFacts: knowledgeFacts
        )

        var validatedByType: [RelationshipType: [MatchingPair]] = [:]

        for candidate in rawCandidates {
            if let reason = rejectionReason(for: candidate, passage: passage, sentences: sentences) {
                rejected.append(RejectedPair(left: candidate.left, right: candidate.right, reason: reason))
                continue
            }
            let pair = MatchingPair(
                left: candidate.left,
                right: candidate.right,
                supportingEvidence: candidate.supportingEvidence
            )
            validatedByType[candidate.relationshipType, default: []].append(pair)
        }

        // Prefer the relationship type with the most unique, non-ambiguous pairs.
        var bestType: RelationshipType?
        var bestPairs: [MatchingPair] = []

        for type in RelationshipType.allCases {
            let pairs = uniquedPairs(validatedByType[type] ?? [], rejected: &rejected)
            let unambiguous = removeAmbiguousPairs(pairs, rejected: &rejected)
            if unambiguous.count > bestPairs.count {
                bestType = type
                bestPairs = unambiguous
            }
        }

        if let bestType, bestPairs.count >= minimumPairCount {
            let selected = Array(bestPairs.prefix(4))
            let question = LessonQuestion.matching(
                prompt: bestType.prompt,
                pairs: selected,
                explanation: bestType.explanation
            )
            return GenerationResult(
                question: question,
                acceptedPairs: selected,
                rejectedPairs: rejected,
                relationshipType: bestType
            )
        }

        for pair in bestPairs {
            rejected.append(
                RejectedPair(
                    left: pair.left,
                    right: pair.right,
                    reason: "Fewer than \(minimumPairCount) strong passage-grounded pairs of one relationship type."
                )
            )
        }

        let fallback = fallbackComprehensionQuestion(
            passage: passage,
            sentences: sentences,
            topic: topic,
            vocabulary: vocabulary,
            knowledgeFacts: knowledgeFacts
        )
        return GenerationResult(
            question: fallback,
            acceptedPairs: [],
            rejectedPairs: rejected,
            relationshipType: nil
        )
    }

    /// True for known outside-knowledge pairings that must never appear as matches.
    static func isLooseAssociation(left: String, right: String) -> Bool {
        looksLikeLooseAssociation(left: left, right: right)
    }

    /// True when every pair has supporting text that appears in the passage and proves the match.
    static func pairsArePassageGrounded(_ pairs: [MatchingPair], passage: String) -> Bool {
        guard pairs.count >= minimumPairCount else { return false }
        let sentences = splitSentences(passage)
        var seenLeft = Set<String>()
        var seenRight = Set<String>()

        for pair in pairs {
            let leftKey = normalizeKey(pair.left)
            let rightKey = normalizeKey(pair.right)
            if leftKey.isEmpty || rightKey.isEmpty { return false }
            if seenLeft.contains(leftKey) || seenRight.contains(rightKey) { return false }
            seenLeft.insert(leftKey)
            seenRight.insert(rightKey)

            guard let evidence = resolvedEvidence(for: pair, passage: passage, sentences: sentences) else {
                return false
            }
            if !evidenceSupports(left: pair.left, right: pair.right, evidence: evidence) {
                return false
            }
            if looksLikeLooseAssociation(left: pair.left, right: pair.right) {
                return false
            }
        }
        return true
    }

    /// Validates matching pairs against a passage; returns human-readable issue strings.
    static func validationIssues(for pairs: [MatchingPair], passage: String) -> [String] {
        guard !passage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return ["Matching question has no passage to verify against."]
        }
        if pairs.count < minimumPairCount {
            return ["Matching needs at least \(minimumPairCount) passage-grounded pairs (found \(pairs.count))."]
        }

        var issues: [String] = []
        let sentences = splitSentences(passage)
        var seenLeft = Set<String>()
        var seenRight = Set<String>()

        for pair in pairs {
            let leftKey = normalizeKey(pair.left)
            let rightKey = normalizeKey(pair.right)
            if seenLeft.contains(leftKey) {
                issues.append("Repeated left item \"\(pair.left)\".")
            }
            if seenRight.contains(rightKey) {
                issues.append("Repeated right item \"\(pair.right)\".")
            }
            seenLeft.insert(leftKey)
            seenRight.insert(rightKey)

            if looksLikeLooseAssociation(left: pair.left, right: pair.right) {
                issues.append("Loose association rejected: \"\(pair.left)\" → \"\(pair.right)\".")
                continue
            }

            guard let evidence = resolvedEvidence(for: pair, passage: passage, sentences: sentences) else {
                issues.append("No supporting sentence in the passage for \"\(pair.left)\" → \"\(pair.right)\".")
                continue
            }
            if !evidenceSupports(left: pair.left, right: pair.right, evidence: evidence) {
                issues.append("Supporting text does not prove \"\(pair.left)\" → \"\(pair.right)\": \"\(evidence)\"")
            }
        }

        // Ambiguity: a right answer should not also fit another left equally well.
        for (index, pair) in pairs.enumerated() {
            guard let evidence = resolvedEvidence(for: pair, passage: passage, sentences: sentences) else { continue }
            for (otherIndex, other) in pairs.enumerated() where otherIndex != index {
                if evidenceSupports(left: other.left, right: pair.right, evidence: evidence)
                    && evidenceSupports(left: pair.left, right: pair.right, evidence: evidence)
                    && normalizeKey(other.left) != normalizeKey(pair.left) {
                    // Only flag if the same evidence sentence also clearly links the other left to this right.
                    if evidence.localizedCaseInsensitiveContains(other.left) {
                        issues.append("Ambiguous right \"\(pair.right)\" could also fit \"\(other.left)\".")
                    }
                }
            }
        }

        return issues
    }

    // MARK: - Extraction

    private static func extractCandidates(
        sentences: [String],
        passage: String,
        vocabulary: [VocabularyWord],
        knowledgeFacts: [KnowledgeFact]
    ) -> [Candidate] {
        var candidates: [Candidate] = []

        for sentence in sentences {
            candidates.append(contentsOf: extractFromSentence(sentence))
        }

        for word in vocabulary {
            candidates.append(contentsOf: candidatesFromVocabulary(word, sentences: sentences, passage: passage))
        }

        for fact in knowledgeFacts {
            candidates.append(contentsOf: candidatesFromFact(fact, sentences: sentences, passage: passage))
        }

        return candidates
    }

    private static func extractFromSentence(_ sentence: String) -> [Candidate] {
        var results: [Candidate] = []
        let trimmed = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > 12 else { return results }

        // "X looks like Y"
        if let match = firstMatch(
            in: trimmed,
            pattern: #"(?i)\b((?:a |an |the )?[A-Za-z][A-Za-z\- ]{1,40}?)\s+looks? like\s+((?:a |an |the )?[^.—,;]+)"#
        ) {
            results.append(
                Candidate(
                    left: titleCase(cleanPhrase(match.g1)),
                    right: sentenceCase(cleanPhrase(match.g2)),
                    supportingEvidence: trimmed,
                    relationshipType: .itemToDescription
                )
            )
        }

        // "X are/is/was/were Y" definitional (also usable as item→description)
        if let match = firstMatch(
            in: trimmed,
            pattern: #"(?i)\b((?:a |an |the )?[A-Za-z][A-Za-z\- ]{0,30}?)\s+(?:are|is|was|were)\s+((?:the |a |an )?(?:remains|bones|nature'?s|animals?|predators?|herbivores?|groups?|places?|parts?|friends?|cousins?|time capsules?|hard as|layered)[^.—,;]*)"#
        ) {
            let left = titleCase(cleanPhrase(match.g1))
            let right = sentenceCase(cleanPhrase(match.g2))
            if isUsefulPair(left: left, right: right) {
                for type in [RelationshipType.termToDefinition, .itemToDescription] {
                    results.append(
                        Candidate(
                            left: left,
                            right: right,
                            supportingEvidence: trimmed,
                            relationshipType: type
                        )
                    )
                }
            }
        }

        // Em-dash / hyphen definition: "Gills — ..." / "Fossils are nature's time capsules — ..."
        if let match = firstMatch(
            in: trimmed,
            pattern: #"(?i)\b([A-Za-z][A-Za-z\- ]{1,28}?)\s*(?:—|--)\s*([^.]+)"#
        ) {
            let left = titleCase(cleanPhrase(match.g1))
            let right = sentenceCase(cleanPhrase(match.g2))
            // Prefer the clause before "are/is" when present: "Fossils are nature's time capsules"
            if let areMatch = firstMatch(
                in: trimmed,
                pattern: #"(?i)\b([A-Za-z][A-Za-z\- ]{1,28}?)\s+(?:are|is)\s+([^—]+?)(?:\s*—|\s*--|$)"#
            ) {
                let defLeft = titleCase(cleanPhrase(areMatch.g1))
                let defRight = sentenceCase(cleanPhrase(areMatch.g2))
                if isUsefulPair(left: defLeft, right: defRight) {
                    results.append(
                        Candidate(
                            left: defLeft,
                            right: defRight,
                            supportingEvidence: trimmed,
                            relationshipType: .termToDefinition
                        )
                    )
                }
            } else if isUsefulPair(left: left, right: right) {
                results.append(
                    Candidate(
                        left: left,
                        right: right,
                        supportingEvidence: trimmed,
                        relationshipType: .termToDefinition
                    )
                )
            }
        }

        // "called Y" / "were called Y"
        if let match = firstMatch(
            in: trimmed,
            pattern: #"(?i)((?:some |the |a |an )?[^. ][^.]{0,40}?)\s+(?:were |was |are |is )?called\s+([A-Za-z][A-Za-z\- ]{1,30})"#
        ) {
            let subject = cleanPhrase(match.g1)
            let name = titleCase(cleanPhrase(match.g2))
            // Prefer "Herbivores → animals that ate plants" style when the sentence defines the label.
            if let ateMatch = firstMatch(
                in: trimmed,
                pattern: #"(?i)(?:some |the )?([^.]{0,60}?)\s+ate\s+([^.]+?)\s+and\s+(?:were |was )?called\s+([A-Za-z]+)"#
            ) {
                results.append(
                    Candidate(
                        left: titleCase(cleanPhrase(ateMatch.g3)),
                        right: sentenceCase("Animals that ate " + cleanPhrase(ateMatch.g2)),
                        supportingEvidence: trimmed,
                        relationshipType: .termToDefinition
                    )
                )
            } else if isUsefulPair(left: name, right: subject) {
                results.append(
                    Candidate(
                        left: name,
                        right: sentenceCase(subject),
                        supportingEvidence: trimmed,
                        relationshipType: .termToDefinition
                    )
                )
            }
        }

        // "X that Y" definitional relative clause near science nouns
        if let match = firstMatch(
            in: trimmed,
            pattern: #"(?i)\b((?:gills|fossils?|bones|herds?|footprints?|suits?|rockets?|predators?|herbivores?))\s+that\s+([^.—,;]+)"#
        ) {
            results.append(
                Candidate(
                    left: titleCase(cleanPhrase(match.g1)),
                    right: sentenceCase(cleanPhrase(match.g2)),
                    supportingEvidence: trimmed,
                    relationshipType: .termToDefinition
                )
            )
        }

        // Location: "hiding near X" / "at the X" / "from the X"
        if let match = firstMatch(
            in: trimmed,
            pattern: #"(?i)\b((?:a |an |the )?(?:baby [a-z]+|[a-z]+))\s+(?:hiding |resting |waiting |layered )??(?:near|beside|in|on|at|from)\s+((?:a |an |the )?[^.—,;]{3,40})"#
        ) {
            let left = titleCase(cleanPhrase(match.g1))
            let right = sentenceCase(cleanPhrase(match.g2))
            if isUsefulPair(left: left, right: right), left.split(separator: " ").count <= 4 {
                results.append(
                    Candidate(
                        left: left,
                        right: right,
                        supportingEvidence: trimmed,
                        relationshipType: .objectToLocation
                    )
                )
            }
        }

        // Behavior: "X uses/eats/swims/nudges/munches ..."
        if let match = firstMatch(
            in: trimmed,
            pattern: #"(?i)\b((?:[A-Z][a-z]+|[A-Za-z]+))\s+(uses|eats|swims|nudges|munches|pads|roamed|press(?:es)?|keep(?:s)?|pull(?:s)?)\s+([^.—,;]+)"#
        ) {
            let subject = titleCase(cleanPhrase(match.g1))
            let verb = cleanPhrase(match.g2).lowercased()
            let rest = cleanPhrase(match.g3)
            results.append(
                Candidate(
                    left: subject,
                    right: sentenceCase("\(verb) \(rest)"),
                    supportingEvidence: trimmed,
                    relationshipType: .animalToBehavior
                )
            )
        }

        // "Notes say the bones are hard as stone and layered in mud..."
        if let match = firstMatch(
            in: trimmed,
            pattern: #"(?i)\b(?:the )?bones\s+are\s+([^.]+)"#
        ) {
            let description = cleanPhrase(match.g1)
            results.append(
                Candidate(
                    left: "Bones",
                    right: sentenceCase(description),
                    supportingEvidence: trimmed,
                    relationshipType: .itemToDescription
                )
            )
        }

        return results
    }

    private static func candidatesFromVocabulary(
        _ word: VocabularyWord,
        sentences: [String],
        passage: String
    ) -> [Candidate] {
        guard passage.localizedCaseInsensitiveContains(word.word) else { return [] }
        guard let sentence = sentences.first(where: { $0.localizedCaseInsensitiveContains(word.word) }) else {
            return []
        }
        // Only use the vocab definition if the passage sentence itself supports that meaning.
        let definition = cleanPhrase(word.definition)
        guard !definition.isEmpty else { return [] }
        guard evidenceSupports(left: word.word, right: definition, evidence: sentence)
            || significantOverlap(definition, sentence) else {
            return []
        }
        return [
            Candidate(
                left: titleCase(word.word),
                right: sentenceCase(definition),
                supportingEvidence: sentence,
                relationshipType: .termToDefinition
            )
        ]
    }

    private static func candidatesFromFact(
        _ fact: KnowledgeFact,
        sentences: [String],
        passage: String
    ) -> [Candidate] {
        let text = cleanPhrase(fact.fact)
        guard text.count > 10 else { return [] }
        // Fact must be mirrored in the passage, not outside knowledge alone.
        guard let sentence = sentences.first(where: { significantOverlap(text, $0) })
            ?? (significantOverlap(text, passage) ? sentences.first : nil) else {
            return []
        }
        if let match = firstMatch(
            in: text,
            pattern: #"(?i)^(.+?)\s+(?:help|helps|are|is|tell|tells)\s+(.+)$"#
        ) {
            return [
                Candidate(
                    left: titleCase(cleanPhrase(match.g1)),
                    right: sentenceCase(cleanPhrase(match.g2)),
                    supportingEvidence: sentence,
                    relationshipType: .termToDefinition
                )
            ]
        }
        return []
    }

    // MARK: - Validation helpers

    private static func rejectionReason(
        for candidate: Candidate,
        passage: String,
        sentences: [String]
    ) -> String? {
        if looksLikeLooseAssociation(left: candidate.left, right: candidate.right) {
            return "Loose real-world association not proven by the passage."
        }
        if !isUsefulPair(left: candidate.left, right: candidate.right) {
            return "Pair is too vague or not age-appropriate."
        }
        let evidence = candidate.supportingEvidence.trimmingCharacters(in: .whitespacesAndNewlines)
        if evidence.isEmpty {
            return "Missing supporting evidence."
        }
        if !passage.localizedCaseInsensitiveContains(evidence)
            && !sentences.contains(where: { normalizeKey($0) == normalizeKey(evidence) }) {
            // Allow evidence that is a sentence from the passage even with light punctuation differences.
            let evidenceKey = normalizeKey(evidence)
            let found = sentences.contains { normalizeKey($0).contains(evidenceKey) || evidenceKey.contains(normalizeKey($0)) }
            if !found {
                return "Supporting excerpt is not found in the passage."
            }
        }
        if !evidenceSupports(left: candidate.left, right: candidate.right, evidence: evidence) {
            return "Could not find direct evidence for this exact match in the passage."
        }
        return nil
    }

    private static func resolvedEvidence(
        for pair: MatchingPair,
        passage: String,
        sentences: [String]
    ) -> String? {
        if let evidence = pair.supportingEvidence?.trimmingCharacters(in: .whitespacesAndNewlines),
           !evidence.isEmpty {
            if passage.localizedCaseInsensitiveContains(evidence)
                || sentences.contains(where: { normalizeKey($0) == normalizeKey(evidence) })
                || sentences.contains(where: {
                    normalizeKey($0).contains(normalizeKey(evidence))
                        || normalizeKey(evidence).contains(normalizeKey($0))
                }) {
                return evidence
            }
        }
        // Legacy pairs without stored evidence: try to recover a proving sentence.
        return sentences.first { evidenceSupports(left: pair.left, right: pair.right, evidence: $0) }
    }

    private static func evidenceSupports(left: String, right: String, evidence: String) -> Bool {
        let evidenceKey = normalizeKey(evidence)
        let leftTokens = contentTokens(left)
        let rightTokens = contentTokens(right)
        guard !leftTokens.isEmpty, !rightTokens.isEmpty else { return false }

        let leftOK = leftTokens.allSatisfy { evidenceKey.contains($0) }
            || evidence.localizedCaseInsensitiveContains(left)
        guard leftOK else { return false }

        // Right side: require most content words, or a strong contiguous phrase overlap.
        let matchedRight = rightTokens.filter { evidenceKey.contains($0) }.count
        if matchedRight >= max(1, (rightTokens.count + 1) / 2) {
            return true
        }
        return significantOverlap(right, evidence)
    }

    private static func looksLikeLooseAssociation(left: String, right: String) -> Bool {
        let pair = "\(normalizeKey(left))|\(normalizeKey(right))"
        let banned: Set<String> = [
            "fossil|museum", "fossils|museum",
            "egg|nest", "eggs|nest",
            "herd|valley", "herds|valley",
            "bird|nest", "birds|nest",
            "seed|soil", "seeds|soil",
            "book|shelf", "books|shelf",
            "dog|walk and fresh water",
            "cat|cozy napping spot",
            "puppy|gentle playtime",
            "crab|sandy shore",
            "sea star|rocky tide pool",
            "shark|ocean reef"
        ]
        if banned.contains(pair) { return true }

        // Generic "thing → typical place" without shared evidence words is handled elsewhere;
        // these extra heuristics catch common outside-knowledge pairings.
        let loosePlacePairs: [(String, String)] = [
            ("fossil", "museum"), ("egg", "nest"), ("herd", "valley"),
            ("bird", "nest"), ("fish", "ocean"), ("horse", "barn")
        ]
        let leftKey = normalizeKey(left)
        let rightKey = normalizeKey(right)
        return loosePlacePairs.contains { leftKey.contains($0.0) && rightKey.contains($0.1) }
    }

    private static func isUsefulPair(left: String, right: String) -> Bool {
        let leftTrim = left.trimmingCharacters(in: .whitespacesAndNewlines)
        let rightTrim = right.trimmingCharacters(in: .whitespacesAndNewlines)
        guard leftTrim.count >= 2, rightTrim.count >= 3 else { return false }
        guard normalizeKey(leftTrim) != normalizeKey(rightTrim) else { return false }
        let stopLeft: Set<String> = [
            "the", "a", "an", "this", "that", "some", "you", "your", "notes", "long ago",
            "and", "or", "but", "they", "them", "it", "he", "she", "we", "i"
        ]
        if stopLeft.contains(normalizeKey(leftTrim)) { return false }
        let leftWords = leftTrim.split(separator: " ")
        if leftWords.count > 4 { return false }
        let bannedLeftTokens: Set<String> = [
            "say", "says", "said", "notes", "pointed", "noticed", "whispered",
            "and", "or", "but", "they", "them", "then"
        ]
        if leftWords.map({ $0.lowercased() }).contains(where: { bannedLeftTokens.contains($0) }) {
            return false
        }
        if rightTrim.count > 80 { return false }
        return true
    }

    private static func uniquedPairs(_ pairs: [MatchingPair], rejected: inout [RejectedPair]) -> [MatchingPair] {
        var result: [MatchingPair] = []
        var seenLeft = Set<String>()
        var seenRight = Set<String>()
        for pair in pairs {
            let leftKey = normalizeKey(pair.left)
            let rightKey = normalizeKey(pair.right)
            if seenLeft.contains(leftKey) {
                rejected.append(RejectedPair(left: pair.left, right: pair.right, reason: "Duplicate left item."))
                continue
            }
            if seenRight.contains(rightKey) {
                rejected.append(RejectedPair(left: pair.left, right: pair.right, reason: "Duplicate right item."))
                continue
            }
            seenLeft.insert(leftKey)
            seenRight.insert(rightKey)
            result.append(pair)
        }
        return result
    }

    private static func removeAmbiguousPairs(_ pairs: [MatchingPair], rejected: inout [RejectedPair]) -> [MatchingPair] {
        var keep: [MatchingPair] = []
        for pair in pairs {
            let ambiguous = pairs.contains { other in
                guard other.id != pair.id else { return false }
                guard let evidence = pair.supportingEvidence else { return false }
                return evidence.localizedCaseInsensitiveContains(other.left)
                    && evidenceSupports(left: other.left, right: pair.right, evidence: evidence)
            }
            if ambiguous {
                rejected.append(
                    RejectedPair(
                        left: pair.left,
                        right: pair.right,
                        reason: "Ambiguous match — more than one answer could reasonably work."
                    )
                )
            } else {
                keep.append(pair)
            }
        }
        return keep
    }

    private static func fallbackComprehensionQuestion(
        passage: String,
        sentences: [String],
        topic: Topic,
        vocabulary: [VocabularyWord],
        knowledgeFacts: [KnowledgeFact]
    ) -> LessonQuestion {
        if let word = vocabulary.first(where: { passage.localizedCaseInsensitiveContains($0.word) }) {
            let correct = sentenceCase(word.definition)
            let distractors = vocabulary
                .filter { $0.word.caseInsensitiveCompare(word.word) != .orderedSame }
                .prefix(2)
                .map { sentenceCase($0.definition) }
            var choices = [correct] + distractors
            while choices.count < 3 {
                choices.append(contentsOf: topicFallbackDistractors(for: topic, excluding: choices))
                choices = uniquedStrings(choices)
            }
            return LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "According to the passage, what does \"\(word.word)\" mean?",
                choices: Array(choices.prefix(3)),
                correctAnswer: correct,
                explanation: "The passage supports this meaning of \"\(word.word)\"."
            )
        }

        if let sentence = sentences.first(where: { $0.count > 40 }) {
            let correct = sentenceCase(shorten(sentence, limit: 70))
            let distractors = topicFallbackDistractors(for: topic, excluding: [correct])
            return LessonQuestion(
                subject: .reading,
                type: .multipleChoice,
                responseType: .multipleChoice,
                prompt: "What happens in this part of the story?",
                choices: uniquedStrings([correct] + distractors).prefix(3).map { $0 },
                correctAnswer: correct,
                explanation: "That detail appears in the reading passage."
            )
        }

        let fact = knowledgeFacts.first?.fact ?? "A detail from today's \(topic.rawValue.lowercased()) story"
        return LessonQuestion(
            subject: .reading,
            type: .multipleChoice,
            responseType: .multipleChoice,
            prompt: "What is this story mostly about?",
            choices: uniquedStrings([
                sentenceCase(fact),
                "Something that never appears in the story",
                "A detail from a completely different topic"
            ]).prefix(3).map { $0 },
            correctAnswer: sentenceCase(fact),
            explanation: "The correct choice is grounded in the lesson story."
        )
    }

    private static func topicFallbackDistractors(for topic: Topic, excluding: [String]) -> [String] {
        let options: [String]
        switch topic {
        case .dinosaurs:
            options = [
                "Dinosaurs lived only inside museums",
                "Every fossil is a phone from long ago",
                "Eggs always mean a nest in every story"
            ]
        case .sharks, .oceanAnimals:
            options = [
                "Sharks breathe only on the beach",
                "Coral reefs are found in deserts",
                "Fish never hide near caves"
            ]
        case .horses:
            options = [
                "Horses sleep only on spaceships",
                "Hay is never used in a stall",
                "Foals never watch from a paddock"
            ]
        case .space, .planets, .rockets:
            options = [
                "Rockets launch without any checklist",
                "Space has plenty of air to breathe",
                "The Moon is made of soft cheese"
            ]
        default:
            options = [
                "A detail that is not in the story",
                "Something from a different adventure",
                "An idea the passage never mentions"
            ]
        }
        return options.filter { candidate in
            !excluding.contains(where: { $0.caseInsensitiveCompare(candidate) == .orderedSame })
        }
    }

    // MARK: - Text helpers

    static func splitSentences(_ passage: String) -> [String] {
        let normalized = passage
            .replacingOccurrences(of: "—", with: ". ")
            .replacingOccurrences(of: "–", with: ". ")
            .replacingOccurrences(of: #"\s*\.\s+"#, with: ". ", options: .regularExpression)
        var sentences: [String] = []
        normalized.enumerateSubstrings(in: normalized.startIndex..., options: [.bySentences, .localized]) { substring, _, _, _ in
            guard let substring else { return }
            let trimmed = substring.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                sentences.append(trimmed)
            }
        }
        if sentences.isEmpty {
            let trimmed = passage.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty { sentences = [trimmed] }
        }
        // Drop pronoun-only leftovers like "They keep secrets..."
        return sentences.filter { sentence in
            let first = sentence.split(separator: " ").first.map { $0.lowercased() } ?? ""
            return !["they", "it", "he", "she", "we", "and", "but", "or"].contains(first)
        }
    }

    private struct RegexGroups {
        let g1: String
        let g2: String
        let g3: String
    }

    private static func firstMatch(in text: String, pattern: String) -> RegexGroups? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range) else { return nil }
        func group(_ index: Int) -> String {
            guard match.numberOfRanges > index,
                  let r = Range(match.range(at: index), in: text) else { return "" }
            return String(text[r])
        }
        let g1 = group(1)
        if g1.isEmpty { return nil }
        return RegexGroups(g1: g1, g2: group(2), g3: group(3))
    }

    private static func cleanPhrase(_ text: String) -> String {
        var result = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimChars = CharacterSet(charactersIn: "\"'“”‘’.,;:!?()[]")
        while let first = result.unicodeScalars.first, trimChars.contains(first) {
            result.removeFirst()
        }
        while let last = result.unicodeScalars.last, trimChars.contains(last) {
            result.removeLast()
        }
        return result.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func normalizeKey(_ text: String) -> String {
        text.lowercased()
            .replacingOccurrences(of: #"^the\s+"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"^a\s+"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"^an\s+"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"[^a-z0-9\s]"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func contentTokens(_ text: String) -> [String] {
        let stop: Set<String> = [
            "a", "an", "the", "of", "to", "and", "or", "for", "in", "on", "at", "from",
            "with", "as", "that", "this", "are", "is", "was", "were", "be", "by", "it",
            "its", "their", "they", "them", "into", "about", "like"
        ]
        return normalizeKey(text)
            .split(separator: " ")
            .map(String.init)
            .filter { $0.count > 1 && !stop.contains($0) }
    }

    private static func significantOverlap(_ a: String, _ b: String) -> Bool {
        let tokensA = Set(contentTokens(a))
        let tokensB = Set(contentTokens(b))
        guard !tokensA.isEmpty, !tokensB.isEmpty else { return false }
        let overlap = tokensA.intersection(tokensB).count
        return overlap >= max(1, min(tokensA.count, tokensB.count) / 2)
    }

    private static func titleCase(_ text: String) -> String {
        let cleaned = cleanPhrase(text)
        guard let first = cleaned.first else { return cleaned }
        return String(first).uppercased() + cleaned.dropFirst()
    }

    private static func sentenceCase(_ text: String) -> String {
        titleCase(text)
    }

    private static func shorten(_ text: String, limit: Int) -> String {
        let cleaned = cleanPhrase(text)
        guard cleaned.count > limit else { return cleaned }
        let idx = cleaned.index(cleaned.startIndex, offsetBy: limit)
        if let space = cleaned[..<idx].lastIndex(of: " ") {
            return String(cleaned[..<space])
        }
        return String(cleaned.prefix(limit))
    }

    private static func uniquedStrings(_ values: [String]) -> [String] {
        var result: [String] = []
        for value in values {
            if !result.contains(where: { $0.caseInsensitiveCompare(value) == .orderedSame }) {
                result.append(value)
            }
        }
        return result
    }
}
