import Foundation

/// Loads Marble taxonomy JSON once and exposes efficient lookups.
final class MarbleCurriculumService {
    static let shared = MarbleCurriculumService()

    private(set) var isLoaded = false
    private(set) var loadError: String?
    private(set) var manifest: MarbleManifest?
    private(set) var topics: [MarbleTopic] = []
    private(set) var dependencies: [MarbleDependency] = []
    private(set) var clusters: [MarbleCluster] = []
    private(set) var curricula: [MarbleCurriculum] = []

    private var topicByID: [String: MarbleTopic] = [:]
    private var prerequisitesByTopic: [String: [MarbleDependency]] = [:]
    private var unlocksByPrerequisite: [String: [MarbleDependency]] = [:]
    private var topicsBySubject: [String: [MarbleTopic]] = [:]
    private var topicsByDomain: [String: [MarbleTopic]] = [:]

    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    @discardableResult
    func loadIfNeeded() -> Bool {
        if isLoaded { return loadError == nil }
        return reload()
    }

    @discardableResult
    func reload() -> Bool {
        isLoaded = false
        loadError = nil
        topicByID = [:]
        prerequisitesByTopic = [:]
        unlocksByPrerequisite = [:]
        topicsBySubject = [:]
        topicsByDomain = [:]

        do {
            manifest = try decodeFile("manifest", as: MarbleManifest.self)
            let topicsFile = try decodeFile("topics", as: MarbleTopicsFile.self)
            let depsFile = try decodeFile("dependencies", as: MarbleDependenciesFile.self)
            let clustersFile = try decodeFile("clusters", as: MarbleClustersFile.self)
            let standardsFile = try? decodeFile("curriculum-standards", as: MarbleStandardsFile.self)

            topics = topicsFile.topics
            dependencies = depsFile.dependencies
            clusters = clustersFile.clusters
            curricula = standardsFile?.curricula ?? []

            for topic in topics {
                topicByID[topic.id] = topic
                topicsBySubject[topic.subject, default: []].append(topic)
                if let domain = topic.domain {
                    topicsByDomain[domain, default: []].append(topic)
                }
            }

            for edge in dependencies {
                prerequisitesByTopic[edge.topicId, default: []].append(edge)
                unlocksByPrerequisite[edge.prerequisiteId, default: []].append(edge)
            }

            isLoaded = true
            #if DEBUG
            CurriculumDiagnostics.logCurriculumHealth(using: self)
            #endif
            return true
        } catch {
            loadError = error.localizedDescription
            isLoaded = true
            topics = []
            dependencies = []
            #if DEBUG
            print("[MovoLearn] Marble curriculum load failed: \(error)")
            #endif
            return false
        }
    }

    func topic(id: String) -> MarbleTopic? {
        _ = loadIfNeeded()
        return topicByID[id]
    }

    func prerequisites(for topicId: String, strength: MarbleDependencyStrength? = nil) -> [MarbleDependency] {
        _ = loadIfNeeded()
        let edges = prerequisitesByTopic[topicId] ?? []
        guard let strength else { return edges }
        return edges.filter { $0.strength == strength }
    }

    func hardPrerequisites(for topicId: String) -> [MarbleDependency] {
        prerequisites(for: topicId, strength: .hard)
    }

    func softPrerequisites(for topicId: String) -> [MarbleDependency] {
        prerequisites(for: topicId, strength: .soft)
    }

    /// Topics unlocked after mastering `topicId` (reverse lookup).
    func unlocks(from prerequisiteId: String) -> [MarbleDependency] {
        _ = loadIfNeeded()
        return unlocksByPrerequisite[prerequisiteId] ?? []
    }

    func topics(subject: String) -> [MarbleTopic] {
        _ = loadIfNeeded()
        return topicsBySubject[subject] ?? []
    }

    func topics(domain: String) -> [MarbleTopic] {
        _ = loadIfNeeded()
        return topicsByDomain[domain] ?? []
    }

    func topics(forAge age: Int) -> [MarbleTopic] {
        _ = loadIfNeeded()
        return topics.filter { $0.includesAge(age) }
    }

    func evidence(for topicId: String) -> [String] {
        topic(id: topicId)?.evidence ?? []
    }

    func assessmentPrompt(for topicId: String) -> String? {
        topic(id: topicId)?.assessmentPrompt
    }

    func standards(for topicId: String) -> [String] {
        topic(id: topicId)?.standards ?? []
    }

    func taxonomyVersion() -> String {
        _ = loadIfNeeded()
        return manifest?.taxonomyVersion ?? "unknown"
    }

    /// Detects missing topic references in dependency edges.
    func invalidDependencyReferences() -> [(MarbleDependency, String)] {
        _ = loadIfNeeded()
        var issues: [(MarbleDependency, String)] = []
        for edge in dependencies {
            if topicByID[edge.topicId] == nil {
                issues.append((edge, "missing topicId \(edge.topicId)"))
            }
            if topicByID[edge.prerequisiteId] == nil {
                issues.append((edge, "missing prerequisiteId \(edge.prerequisiteId)"))
            }
        }
        return issues
    }

    func duplicateTopicIDs() -> [String] {
        _ = loadIfNeeded()
        var seen = Set<String>()
        var duplicates = Set<String>()
        for topic in topics {
            if !seen.insert(topic.id).inserted {
                duplicates.insert(topic.id)
            }
        }
        return Array(duplicates).sorted()
    }

    /// DFS cycle detection on hard prerequisites.
    func findPrerequisiteCycles(limit: Int = 20) -> [[String]] {
        _ = loadIfNeeded()
        var cycles: [[String]] = []
        var visiting = Set<String>()
        var visited = Set<String>()
        var stack: [String] = []

        func dfs(_ node: String) {
            if cycles.count >= limit { return }
            if visiting.contains(node) {
                if let start = stack.firstIndex(of: node) {
                    cycles.append(Array(stack[start...]) + [node])
                }
                return
            }
            if visited.contains(node) { return }
            visiting.insert(node)
            stack.append(node)
            for edge in hardPrerequisites(for: node) {
                dfs(edge.prerequisiteId)
            }
            stack.removeLast()
            visiting.remove(node)
            visited.insert(node)
        }

        for topic in topics {
            dfs(topic.id)
            if cycles.count >= limit { break }
        }
        return cycles
    }

    private func decodeFile<T: Decodable>(_ name: String, as type: T.Type) throws -> T {
        guard let url = bundle.url(forResource: name, withExtension: "json", subdirectory: "Marble")
            ?? bundle.url(forResource: name, withExtension: "json") else {
            throw CurriculumLoadError.missingResource(name)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum CurriculumLoadError: LocalizedError {
    case missingResource(String)

    var errorDescription: String? {
        switch self {
        case .missingResource(let name):
            return "Missing Marble resource: \(name).json"
        }
    }
}

/// Backward-compatible alias from the product brief.
typealias CurriculumRepository = MarbleCurriculumService
