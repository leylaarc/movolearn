import Foundation

/// Local math skill progression aligned with early-elementary sequences.
/// Does NOT invent Quantile measures from age/grade/AI. Licensed Quantile requires MetaMetrics credentials.
struct MockQuantileAlignedProgression: MathProgressionProvider {
    let providerName = "MockQuantileAlignedProgression (temporary)"
    let isLicensedQuantile = false

    private let standards: EducationalStandardsProvider

    init(standards: EducationalStandardsProvider = MockCASEStandardsProvider.shared) {
        self.standards = standards
    }

    func orderedSkills(for mathLevel: MathLevel, grade: String) -> [EducationalSkill] {
        let all = standards.skills(subject: "Math", grade: grade)
        let focus = LevelSkillProgressions.mathSkills(for: mathLevel)
        let matched = all.filter { skill in
            focus.contains { skill.fullStatement.localizedCaseInsensitiveContains($0) }
        }
        return matched.isEmpty ? Array(all.prefix(6)) : matched
    }

    func nextSkill(
        after skillId: String?,
        mathLevel: MathLevel,
        grade: String,
        masteredIds: [String]
    ) -> EducationalSkill? {
        let ordered = orderedSkills(for: mathLevel, grade: grade)
        let mastered = Set(masteredIds)
        if let skillId,
           let idx = ordered.firstIndex(where: { $0.id == skillId }),
           idx + 1 < ordered.count {
            let next = ordered[idx + 1]
            if prerequisitesReady(skillId: next.id, masteredIds: masteredIds) {
                return next
            }
        }
        return ordered.first { !mastered.contains($0.id) && prerequisitesReady(skillId: $0.id, masteredIds: masteredIds) }
    }

    func prerequisitesReady(skillId: String, masteredIds: [String]) -> Bool {
        let mastered = Set(masteredIds)
        let prereqs = standards.prerequisites(for: skillId)
        return prereqs.allSatisfy { mastered.contains($0.id) }
    }
}

/// Placeholder for licensed Quantile services. Does not invent scores or endpoints.
struct LicensedQuantileProvider: MathProgressionProvider {
    let providerName = "LicensedQuantileProvider (not configured)"
    let isLicensedQuantile = false

    func orderedSkills(for mathLevel: MathLevel, grade: String) -> [EducationalSkill] {
        MockQuantileAlignedProgression().orderedSkills(for: mathLevel, grade: grade)
    }

    func nextSkill(
        after skillId: String?,
        mathLevel: MathLevel,
        grade: String,
        masteredIds: [String]
    ) -> EducationalSkill? {
        nil
    }

    func prerequisitesReady(skillId: String, masteredIds: [String]) -> Bool {
        false
    }
}
