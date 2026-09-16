import Foundation

/// Temporary readability checker used until MetaMetrics Lexile credentials and docs are available.
/// Results are heuristic estimates — NOT licensed Lexile measures.
struct MockReadabilityProvider: ReadingLevelMeasurementProvider {
    let providerName = "MockReadabilityProvider (temporary)"
    let isLicensedLexile = false

    func measure(passage: String, intendedReadingLevel: ReadingLevel) -> ReadingLevelMeasurement {
        let trimmed = passage.trimmingCharacters(in: .whitespacesAndNewlines)
        let sentences = trimmed
            .components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let words = trimmed.split(whereSeparator: { $0.isWhitespace || $0.isNewline })
        let wordCount = max(1, words.count)
        let sentenceCount = max(1, sentences.count)
        let avgSentenceLen = Double(wordCount) / Double(sentenceCount)
        let avgWordLen = words.reduce(0.0) { $0 + Double($1.count) } / Double(wordCount)

        // Rough mapping onto early-elementary bands (mock only).
        let estimate = Int(avgSentenceLen * 12 + avgWordLen * 18 + Double(wordCount) * 0.4)
        let measuredBand = band(forEstimate: estimate)
        let intended = Self.intendedBand(for: intendedReadingLevel)
        let passes = Self.bandsCompatible(measured: measuredBand, intended: intendedReadingLevel)

        return ReadingLevelMeasurement(
            providerName: providerName,
            isLicensedLexile: false,
            intendedBand: intended,
            measuredEstimate: estimate,
            measuredBand: measuredBand,
            passesIntendedRange: passes,
            notes: [
                "MOCK readability — not a MetaMetrics Lexile measure",
                String(format: "avgSentenceLen=%.1f avgWordLen=%.1f words=%d", avgSentenceLen, avgWordLen, wordCount)
            ]
        )
    }

    private func band(forEstimate estimate: Int) -> String {
        switch estimate {
        case ...120: return "Beginner"
        case 121...220: return "Early Reader"
        case 221...340: return "Growing Reader"
        default: return "Confident Reader"
        }
    }

    static func intendedBand(for level: ReadingLevel) -> String {
        switch level {
        case .beginner: return "BR–200L (mock band)"
        case .earlyReader: return "200L–400L (mock band)"
        case .growingReader: return "400L–600L (mock band)"
        case .confidentReader: return "600L–800L (mock band)"
        }
    }

    private static func bandsCompatible(measured: String, intended: ReadingLevel) -> Bool {
        let measuredLevel: ReadingLevel
        switch measured {
        case "Beginner": measuredLevel = .beginner
        case "Early Reader": measuredLevel = .earlyReader
        case "Growing Reader": measuredLevel = .growingReader
        default: measuredLevel = .confidentReader
        }
        return abs(measuredLevel.sortOrder - intended.sortOrder) <= 1
    }
}

/// Placeholder for licensed Lexile integration. Does not invent API endpoints.
struct LicensedLexileProvider: ReadingLevelMeasurementProvider {
    let providerName = "LicensedLexileProvider (not configured)"
    let isLicensedLexile = false

    func measure(passage: String, intendedReadingLevel: ReadingLevel) -> ReadingLevelMeasurement {
        ReadingLevelMeasurement(
            providerName: providerName,
            isLicensedLexile: false,
            intendedBand: MockReadabilityProvider.intendedBand(for: intendedReadingLevel),
            measuredEstimate: nil,
            measuredBand: "unavailable",
            passesIntendedRange: false,
            notes: [
                "Licensed Lexile credentials are not configured.",
                "Configure backend MetaMetrics credentials; do not call Lexile from the iOS app."
            ]
        )
    }
}
