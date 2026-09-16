import Foundation

/// Temporary local CASE-aligned standards until 1EdTech CASE Network credentials are available.
/// This is NOT a live CASE API client — do not treat identifiers as production CASE URIs.
final class MockCASEStandardsProvider: EducationalStandardsProvider {
    static let shared = MockCASEStandardsProvider()

    let providerName = "MockCASEStandardsProvider"
    let isLiveCASEIntegration = false

    private var skillsById: [String: EducationalSkill] = [:]
    private var ordered: [EducationalSkill] = []
    private var didLoad = false

    @discardableResult
    func loadIfNeeded() -> Bool {
        if didLoad { return !ordered.isEmpty }
        didLoad = true
        ordered = Self.loadBundleSkills()
        skillsById = Dictionary(uniqueKeysWithValues: ordered.map { ($0.id, $0) })
        return !ordered.isEmpty
    }

    func skills(subject: String?, grade: String?) -> [EducationalSkill] {
        _ = loadIfNeeded()
        return ordered.filter { skill in
            let subjectOK = subject.map { skill.subject.localizedCaseInsensitiveContains($0) } ?? true
            let gradeOK = grade.map { g in
                skill.educationLevels.contains { level in
                    level.localizedCaseInsensitiveContains(g)
                        || Self.gradeCompatible(level, g)
                }
            } ?? true
            return subjectOK && gradeOK
        }
    }

    func skill(id: String) -> EducationalSkill? {
        _ = loadIfNeeded()
        return skillsById[id]
    }

    func prerequisites(for skillId: String) -> [EducationalSkill] {
        guard let skill = skill(id: skillId) else { return [] }
        return skill.prerequisiteIds.compactMap { skillsById[$0] }
    }

    func relatedSkills(for skillId: String) -> [EducationalSkill] {
        guard let skill = skill(id: skillId) else { return [] }
        return skill.relatedIds.compactMap { skillsById[$0] }
    }

    func recommendSkill(
        subject: String,
        grade: String,
        readingLevel: ReadingLevel?,
        mathLevel: MathLevel?,
        masteredIds: [String],
        practiceIds: [String]
    ) -> EducationalSkill? {
        _ = loadIfNeeded()
        let mastered = Set(masteredIds)
        let candidates = skills(subject: subject, grade: grade).filter { skill in
            !mastered.contains(skill.id)
                && skill.prerequisiteIds.allSatisfy { mastered.contains($0) || $0.isEmpty }
        }

        if let practice = candidates.first(where: { practiceIds.contains($0.id) }) {
            return practice
        }

        if subject.localizedCaseInsensitiveContains("read"), let readingLevel {
            let focus = LevelSkillProgressions.readingFocus(for: readingLevel)
            if let match = candidates.first(where: {
                $0.fullStatement.localizedCaseInsensitiveContains(focus)
                    || focus.localizedCaseInsensitiveContains($0.humanCodingScheme)
            }) {
                return match
            }
            let bandIndex = readingLevel.sortOrder
            return candidates.filter { $0.subject.localizedCaseInsensitiveContains("read") }
                .sorted { $0.id < $1.id }
                .dropFirst(min(bandIndex, max(0, candidates.count - 1)))
                .first ?? candidates.first
        }

        if subject.localizedCaseInsensitiveContains("math"), let mathLevel {
            let focus = LevelSkillProgressions.mathFocus(for: mathLevel)
            if let match = candidates.first(where: {
                $0.fullStatement.localizedCaseInsensitiveContains(focus)
            }) {
                return match
            }
            let bandIndex = mathLevel.sortOrder
            return candidates.filter { $0.subject.localizedCaseInsensitiveContains("math") }
                .sorted { $0.id < $1.id }
                .dropFirst(min(bandIndex, max(0, candidates.count - 1)))
                .first ?? candidates.first
        }

        return candidates.first
    }

    private static func gradeCompatible(_ level: String, _ grade: String) -> Bool {
        let l = level.lowercased()
        let g = grade.lowercased()
        if g.contains("kind") || g == "k" { return l.contains("k") || l.contains("0") || l.contains("pre") }
        if g.contains("1") { return l.contains("1") || l.contains("k") }
        if g.contains("2") { return l.contains("2") || l.contains("1") }
        if g.contains("3") { return l.contains("3") || l.contains("2") }
        return true
    }

    private static func loadBundleSkills() -> [EducationalSkill] {
        let urls = [
            Bundle.main.url(forResource: "case-mock-skills", withExtension: "json"),
            Bundle.main.url(forResource: "case-mock-skills", withExtension: "json", subdirectory: "Standards")
        ].compactMap { $0 }
        guard let url = urls.first,
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(CaseMockSkillsFile.self, from: data) else {
            return Self.embeddedFallbackSkills()
        }
        return decoded.skills.map { $0.asEducationalSkill() }
    }

    private static func embeddedFallbackSkills() -> [EducationalSkill] {
        LevelSkillProgressions.fallbackCASESkills()
    }
}

private struct CaseMockSkillsFile: Codable {
    let providerNote: String?
    let skills: [CaseMockSkillDTO]
}

private struct CaseMockSkillDTO: Codable {
    let identifier: String
    let fullStatement: String
    let humanCodingScheme: String
    let subject: String
    let educationLevel: [String]
    let CFItemType: String?
    let prerequisiteIds: [String]?
    let relatedIds: [String]?

    func asEducationalSkill() -> EducationalSkill {
        EducationalSkill(
            id: identifier,
            fullStatement: fullStatement,
            humanCodingScheme: humanCodingScheme,
            subject: subject,
            educationLevels: educationLevel,
            skillType: CFItemType ?? "Learning Objective",
            prerequisiteIds: prerequisiteIds ?? [],
            relatedIds: relatedIds ?? []
        )
    }
}

/// Stub for a future live CASE Network client. Does not invent endpoints.
final class LicensedCASEStandardsProvider: EducationalStandardsProvider {
    let providerName = "LicensedCASEStandardsProvider"
    let isLiveCASEIntegration = false

    func loadIfNeeded() -> Bool { false }
    func skills(subject: String?, grade: String?) -> [EducationalSkill] { [] }
    func skill(id: String) -> EducationalSkill? { nil }
    func prerequisites(for skillId: String) -> [EducationalSkill] { [] }
    func relatedSkills(for skillId: String) -> [EducationalSkill] { [] }
    func recommendSkill(
        subject: String,
        grade: String,
        readingLevel: ReadingLevel?,
        mathLevel: MathLevel?,
        masteredIds: [String],
        practiceIds: [String]
    ) -> EducationalSkill? { nil }
}
