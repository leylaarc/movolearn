import Foundation

enum CurriculumDiagnostics {
    static func logCurriculumHealth(using curriculum: MarbleCurriculumService) {
        #if DEBUG
        let duplicates = curriculum.duplicateTopicIDs()
        if !duplicates.isEmpty {
            print("[MovoLearn][Curriculum] Duplicate topic IDs: \(duplicates.prefix(10))")
        }

        let missing = curriculum.invalidDependencyReferences()
        if !missing.isEmpty {
            print("[MovoLearn][Curriculum] Missing dependency refs: \(missing.prefix(5).map(\.1))")
        }

        let cycles = curriculum.findPrerequisiteCycles(limit: 5)
        if !cycles.isEmpty {
            print("[MovoLearn][Curriculum] Prerequisite cycles detected: \(cycles.count) (showing up to 5)")
        }

        let invalidAges = curriculum.topics.filter { topic in
            if let start = topic.ageRangeStart, let end = topic.ageRangeEnd {
                return start > end
            }
            return false
        }
        if !invalidAges.isEmpty {
            print("[MovoLearn][Curriculum] Invalid age ranges: \(invalidAges.prefix(5).map(\.id))")
        }

        let emptyEvidence = curriculum.topics.filter(\.evidence.isEmpty)
        if !emptyEvidence.isEmpty {
            print("[MovoLearn][Curriculum] Empty evidence arrays: \(emptyEvidence.count) topics")
        }

        print("[MovoLearn][Curriculum] Loaded taxonomy \(curriculum.taxonomyVersion()) with \(curriculum.topics.count) topics")
        #endif
    }

    static func validateProgressRecords(
        _ state: ChildLearningState,
        curriculum: MarbleCurriculumService
    ) {
        #if DEBUG
        for progress in state.skillProgress where curriculum.topic(id: progress.marbleTopicId) == nil {
            print("[MovoLearn][Curriculum] Progress points to missing topic: \(progress.marbleTopicId)")
        }
        #endif
    }

    static func validateLessonResponseTypes(_ lessons: [Lesson]) {
        #if DEBUG
        let supported = Set(QuestionResponseType.allCases.map(\.rawValue))
        for lesson in lessons {
            for question in lesson.questions + lesson.mathChallenges {
                if !supported.contains(question.responseType.rawValue) {
                    print("[MovoLearn][Curriculum] Unsupported response type in \(lesson.title)")
                }
            }
        }
        #endif
    }
}
