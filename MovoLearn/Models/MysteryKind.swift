import Foundation

/// Kinds of evidence-based mysteries (not just “guess the animal”).
enum MysteryKind: String, Codable, CaseIterable, Identifiable {
    case identity
    case cause
    case sequence
    case missingObject
    case habitat
    case science
    case number
    case pattern
    case character
    case location

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .identity: return "Identity"
        case .cause: return "Cause"
        case .sequence: return "Sequence"
        case .missingObject: return "Missing Object"
        case .habitat: return "Habitat"
        case .science: return "Science"
        case .number: return "Number"
        case .pattern: return "Pattern"
        case .character: return "Character"
        case .location: return "Location"
        }
    }
}
