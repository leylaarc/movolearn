import Foundation

@MainActor
enum LearningSessionRecorder {
    static func recordLessonStarted(childId: UUID, lesson: Lesson) {
        let event = LearningEvent(
            childId: childId,
            type: .lessonStarted,
            lessonId: lesson.id,
            marbleTopicId: lesson.primaryTopicId,
            activityType: lesson.category.rawValue,
            metadata: ["lessonType": lesson.lessonType.rawValue]
        )
        _ = LearningProgressStore.shared.appendEvent(event, to: childId)
    }

    static func recordQuestionAnswered(
        childId: UUID,
        lesson: Lesson,
        question: LessonQuestion,
        wasCorrect: Bool,
        usedHint: Bool
    ) {
        let store = LearningProgressStore.shared
        _ = store.appendEvent(
            LearningEvent(
                childId: childId,
                type: .questionAnswered,
                lessonId: lesson.id,
                marbleTopicId: lesson.primaryTopicId,
                activityType: lesson.category.rawValue,
                result: wasCorrect ? "correct" : "incorrect",
                metadata: [
                    "subject": question.subject.rawValue,
                    "responseType": question.responseType.rawValue,
                    "hint": usedHint ? "1" : "0"
                ]
            ),
            to: childId
        )

        guard let topicId = lesson.primaryTopicId else { return }
        var state = store.loadState(for: childId)
        let curriculum = MarbleCurriculumService.shared
        _ = curriculum.loadIfNeeded()
        var progress = state.progress(for: topicId)
            ?? ChildSkillProgress(childProfileId: childId, marbleTopicId: topicId)
        let evidenceCount = max(1, curriculum.evidence(for: topicId).count)
        MasteryEngine.apply(
            attempt: .init(
                wasCorrect: wasCorrect,
                usedHint: usedHint,
                wasIndependent: wasCorrect && !usedHint,
                responseTimeMs: nil,
                activityType: lesson.category.rawValue,
                questionFormat: question.responseType.rawValue,
                lessonId: lesson.id,
                evidenceCriteriaCount: evidenceCount
            ),
            to: &progress
        )
        if let idx = state.skillProgress.firstIndex(where: { $0.marbleTopicId == topicId }) {
            state.skillProgress[idx] = progress
        } else {
            state.skillProgress.append(progress)
        }
        store.save(state)
    }

    static func recordLessonCompleted(
        childId: UUID,
        lesson: Lesson,
        summary: ProgressSummary
    ) {
        let store = LearningProgressStore.shared
        _ = store.appendEvent(
            LearningEvent(
                childId: childId,
                type: .lessonCompleted,
                lessonId: lesson.id,
                marbleTopicId: lesson.primaryTopicId,
                activityType: lesson.category.rawValue,
                result: summary.accuracy >= 0.7 ? "success" : "needsPractice",
                metadata: [
                    "correct": String(summary.correctAnswers),
                    "total": String(summary.totalQuestions)
                ]
            ),
            to: childId
        )

        let topicIds = ([lesson.primaryTopicId].compactMap { $0 }) + lesson.supportingTopicIds
        guard !topicIds.isEmpty else { return }

        var state = store.loadState(for: childId)
        let curriculum = MarbleCurriculumService.shared
        _ = curriculum.loadIfNeeded()

        let independent = summary.accuracy >= 0.8
        for topicId in Set(topicIds) {
            var progress = state.progress(for: topicId)
                ?? ChildSkillProgress(childProfileId: childId, marbleTopicId: topicId)
            let evidenceCount = max(1, curriculum.evidence(for: topicId).count)
            // Lesson completion contributes summarized evidence; individual questions
            // can refine this further when captured per-item in the future.
            MasteryEngine.apply(
                attempt: .init(
                    wasCorrect: summary.accuracy >= 0.6,
                    usedHint: false,
                    wasIndependent: independent,
                    responseTimeMs: nil,
                    activityType: lesson.category.rawValue,
                    questionFormat: "lessonSummary",
                    lessonId: lesson.id,
                    evidenceCriteriaCount: evidenceCount
                ),
                to: &progress
            )
            if let idx = state.skillProgress.firstIndex(where: { $0.marbleTopicId == topicId }) {
                state.skillProgress[idx] = progress
            } else {
                state.skillProgress.append(progress)
            }

            if progress.status == .mastered {
                _ = store.appendEvent(
                    LearningEvent(
                        childId: childId,
                        type: .skillMastered,
                        lessonId: lesson.id,
                        marbleTopicId: topicId,
                        activityType: lesson.category.rawValue,
                        result: "mastered"
                    ),
                    to: childId
                )
                state = store.loadState(for: childId)
            } else if progress.status == .needsReview {
                _ = store.appendEvent(
                    LearningEvent(
                        childId: childId,
                        type: .skillRegressed,
                        lessonId: lesson.id,
                        marbleTopicId: topicId,
                        activityType: lesson.category.rawValue,
                        result: "needsReview"
                    ),
                    to: childId
                )
                state = store.loadState(for: childId)
            }
        }
        store.save(state)
        CurriculumDiagnostics.validateProgressRecords(state, curriculum: curriculum)
    }
}
