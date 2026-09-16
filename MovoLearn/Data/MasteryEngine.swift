import Foundation

/// Deterministic mastery updates from learning evidence.
/// One correct multiple-choice answer is never enough for mastery.
enum MasteryEngine {
    struct AttemptInput {
        let wasCorrect: Bool
        let usedHint: Bool
        let wasIndependent: Bool
        let responseTimeMs: Int?
        let activityType: String
        let questionFormat: String?
        let lessonId: UUID?
        let evidenceCriteriaCount: Int
    }

    static func apply(attempt: AttemptInput, to progress: inout ChildSkillProgress, now: Date = Date()) {
        progress.attemptCount += 1
        progress.lastAttemptedAt = now
        if let ms = attempt.responseTimeMs {
            progress.recentResponseTimeMs = ms
        }
        if let lessonId = attempt.lessonId, !progress.sourceLessonIds.contains(lessonId) {
            progress.sourceLessonIds.append(lessonId)
        }

        if attempt.usedHint {
            progress.hintCount += 1
        }

        if attempt.wasCorrect {
            progress.correctAttempts += 1
            if attempt.wasIndependent && !attempt.usedHint {
                progress.independentCorrectAttempts += 1
            }
        } else {
            progress.incorrectAttempts += 1
        }

        let evidence = SkillEvidenceRecord(
            timestamp: now,
            activityType: attempt.activityType,
            wasCorrect: attempt.wasCorrect,
            usedHint: attempt.usedHint,
            wasIndependent: attempt.wasIndependent && !attempt.usedHint,
            responseTimeMs: attempt.responseTimeMs,
            lessonId: attempt.lessonId,
            questionFormat: attempt.questionFormat
        )
        progress.evidenceRecords.append(evidence)
        if progress.evidenceRecords.count > 40 {
            progress.evidenceRecords = Array(progress.evidenceRecords.suffix(40))
        }

        recomputeScores(for: &progress, evidenceCriteriaCount: max(1, attempt.evidenceCriteriaCount), now: now)
    }

    static func recomputeScores(
        for progress: inout ChildSkillProgress,
        evidenceCriteriaCount: Int,
        now: Date = Date()
    ) {
        let attempts = max(1, progress.attemptCount)
        let accuracy = Double(progress.correctAttempts) / Double(attempts)
        let independentRatio = Double(progress.independentCorrectAttempts) / Double(attempts)
        let hintPenalty = min(0.35, Double(progress.hintCount) / Double(attempts) * 0.5)
        let formatVariety = Set(progress.evidenceRecords.compactMap(\.questionFormat)).count
        let varietyBonus = min(0.15, Double(formatVariety) * 0.05)
        let evidenceCoverage = min(1.0, Double(progress.independentCorrectAttempts) / Double(evidenceCriteriaCount))

        // Weighted, deterministic formula (0...1).
        var mastery = (accuracy * 0.40)
            + (independentRatio * 0.30)
            + (evidenceCoverage * 0.20)
            + varietyBonus
            - hintPenalty

        // Require enough independent successes before high mastery.
        if progress.independentCorrectAttempts < 3 {
            mastery = min(mastery, 0.55)
        }
        if progress.attemptCount < 4 {
            mastery = min(mastery, 0.45)
        }

        // Recent regressions pull mastery down.
        let recent = progress.evidenceRecords.suffix(5)
        let recentMisses = recent.filter { !$0.wasCorrect }.count
        if recentMisses >= 3 {
            mastery = min(mastery, 0.50)
        }

        progress.masteryScore = max(0, min(1, mastery))
        progress.confidenceScore = max(
            0,
            min(1, (independentRatio * 0.6) + (accuracy * 0.4) - hintPenalty)
        )

        let previous = progress.status
        progress.status = status(
            for: progress,
            recentMisses: recentMisses,
            now: now
        )

        if progress.status == .mastered && previous != .mastered {
            progress.lastMasteredAt = now
            progress.nextReviewAt = Calendar.current.date(byAdding: .day, value: 7, to: now)
        } else if progress.status == .needsReview {
            progress.nextReviewAt = now
        } else if progress.status == .practicing || progress.status == .developing {
            progress.nextReviewAt = Calendar.current.date(byAdding: .day, value: 3, to: now)
        }
    }

    private static func status(
        for progress: ChildSkillProgress,
        recentMisses: Int,
        now: Date
    ) -> SkillStatus {
        if progress.attemptCount == 0 {
            return .notStarted
        }

        if let nextReview = progress.nextReviewAt,
           nextReview <= now,
           progress.masteryScore >= 0.75,
           recentMisses >= 2 {
            return .needsReview
        }

        if progress.masteryScore >= 0.80,
           progress.independentCorrectAttempts >= 3,
           progress.attemptCount >= 4,
           recentMisses <= 1 {
            return .mastered
        }

        if recentMisses >= 3, progress.masteryScore < 0.70, progress.status == .mastered || progress.masteryScore < 0.55 {
            return .needsReview
        }

        if progress.masteryScore >= 0.55 {
            return .developing
        }

        if progress.correctAttempts >= 1 {
            return .practicing
        }

        return .introduced
    }

    /// True when hard prerequisites should be considered ready.
    static func isPrerequisiteReady(_ progress: ChildSkillProgress?) -> Bool {
        guard let progress else { return false }
        switch progress.status {
        case .developing, .mastered:
            return progress.masteryScore >= 0.55
        case .needsReview:
            return progress.masteryScore >= 0.70
        default:
            return false
        }
    }
}
