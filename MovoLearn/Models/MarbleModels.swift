import Foundation

// MARK: - Marble Codable models (match withmarbleapp/os-taxonomy schemas)

enum MarbleTopicType: String, Codable {
    case conceptual = "CONCEPTUAL"
    case procedural = "PROCEDURAL"
    case representational = "REPRESENTATIONAL"
    case language = "LANGUAGE"
    case meta = "META"
}

struct MarbleTopic: Codable, Identifiable, Hashable {
    let id: String
    let type: MarbleTopicType
    let subject: String
    let domain: String?
    let name: String?
    let description: String
    let ageRangeStart: Int?
    let ageRangeEnd: Int?
    let centrality: Double?
    let evidence: [String]
    let assessmentPrompt: String?
    let standards: [String]

    var displayName: String {
        let trimmed = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? id : trimmed
    }

    func includesAge(_ age: Int) -> Bool {
        let start = ageRangeStart ?? 0
        let end = ageRangeEnd ?? 18
        return age >= start && age <= end
    }
}

struct MarbleTopicsFile: Codable {
    let version: String
    let topicCount: Int
    let topics: [MarbleTopic]
}

enum MarbleDependencyStrength: String, Codable {
    case hard
    case soft
}

struct MarbleDependency: Codable, Hashable {
    /// The topic that depends on the prerequisite.
    let topicId: String
    /// Must be ready before `topicId` (hard) or preferred (soft).
    let prerequisiteId: String
    let strength: MarbleDependencyStrength
    let reason: String?
}

struct MarbleDependenciesFile: Codable {
    let version: String
    let note: String?
    let edgeCount: Int
    let dependencies: [MarbleDependency]
}

struct MarbleCluster: Codable, Hashable {
    let subject: String
    let domain: String
    let ageRangeStart: Int?
    let summary: String?
}

struct MarbleClustersFile: Codable {
    let version: String
    let clusterCount: Int
    let clusters: [MarbleCluster]
}

struct MarbleManifestFileInfo: Codable {
    let bytes: Int?
    let sha256: String?
}

struct MarbleManifest: Codable {
    let dataset: String?
    let taxonomyVersion: String?
    let generatedAt: String?
    let codesOnlySources: [String]?
    let counts: [String: MarbleJSONValue]?
    let files: [String: MarbleManifestFileInfo]?
    let excluded: [String]?
}

/// Lightweight JSON value for manifest counts that mix ints and nested objects.
enum MarbleJSONValue: Codable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case object([String: MarbleJSONValue])
    case array([MarbleJSONValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([String: MarbleJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([MarbleJSONValue].self) {
            self = .array(value)
        } else {
            self = .null
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value): try container.encode(value)
        case .int(let value): try container.encode(value)
        case .double(let value): try container.encode(value)
        case .bool(let value): try container.encode(value)
        case .object(let value): try container.encode(value)
        case .array(let value): try container.encode(value)
        case .null: try container.encodeNil()
        }
    }
}

struct MarbleStandardTopic: Codable {
    let key: String?
    let code: String?
    let data: MarbleStandardTopicData?
}

struct MarbleStandardTopicData: Codable {
    let title: String?
    let domain: String?
    let text: String?
}

struct MarbleCurriculum: Codable, Identifiable {
    var id: String { slug }
    let slug: String
    let country: String?
    let name: String?
    let version: String?
    let sourceUrl: String?
    let textIncluded: Bool?
    let license: String?
    let topicCount: Int?
    let topics: [MarbleStandardTopic]?
}

struct MarbleStandardsFile: Codable {
    let note: String?
    let codesOnlySources: [String]?
    let curriculumCount: Int?
    let curricula: [MarbleCurriculum]
}

/// Convenience alias used in product docs.
typealias MarbleStandard = MarbleStandardTopic
