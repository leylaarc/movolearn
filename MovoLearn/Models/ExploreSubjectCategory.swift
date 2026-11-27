import Foundation
import SwiftUI

/// Broad subject areas shown in “Explore All Subjects” — not the same as child interest topics.
enum ExploreSubjectCategory: String, CaseIterable, Identifiable, Hashable {
    case science = "Science"
    case history = "History"
    case nature = "Nature"
    case technology = "Technology"
    case artsAndCulture = "Arts and Culture"
    case language = "Language"
    case math = "Math"
    case lifeSkills = "Life Skills"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .science: return "atom"
        case .history: return "building.columns.fill"
        case .nature: return "leaf.fill"
        case .technology: return "cpu.fill"
        case .artsAndCulture: return "paintpalette.fill"
        case .language: return "text.book.closed.fill"
        case .math: return "function"
        case .lifeSkills: return "heart.text.square.fill"
        }
    }

    var accent: Color {
        switch self {
        case .science: return DesignSystem.Colors.skyBlue
        case .history: return DesignSystem.Colors.warmOrange
        case .nature: return DesignSystem.Colors.freshGreen
        case .technology: return DesignSystem.Colors.lavenderPurple
        case .artsAndCulture: return DesignSystem.Colors.coralPink
        case .language: return DesignSystem.Colors.oceanTurquoise
        case .math: return DesignSystem.Colors.warmOrange
        case .lifeSkills: return DesignSystem.Colors.freshGreen
        }
    }

    var subtitle: String {
        switch self {
        case .science: return "Space, ocean, dinosaurs, weather, and discovery"
        case .history: return "Castles, pirates, and stories from the past"
        case .nature: return "Forests, trails, bugs, and outdoor life"
        case .technology: return "Robots, vehicles, and how things work"
        case .artsAndCulture: return "Art, music, and creative play"
        case .language: return "Stories, reading clues, and words"
        case .math: return "Numbers, puzzles, and problem solving"
        case .lifeSkills: return "Dogs, cats, horses, farms, and cooking"
        }
    }

    /// Child-facing world name for adventure home.
    var worldTitle: String {
        switch self {
        case .science: return "Science Galaxy"
        case .history: return "Time Traveler Lands"
        case .nature: return "Wild Nature Trails"
        case .technology: return "Invention Island"
        case .artsAndCulture: return "Art Studio"
        case .language: return "Story Kingdom"
        case .math: return "Number Quest"
        case .lifeSkills: return "Pets and Farms"
        }
    }

    /// Default illustration when no sample lesson is available — must match the world name.
    var representativeTopic: Topic {
        switch self {
        case .science: return .space
        case .history: return .castles
        case .nature: return .nature
        case .technology: return .robots
        case .artsAndCulture: return .art
        case .language: return .fairies
        case .math: return .soccer
        case .lifeSkills: return .dogs
        }
    }

    /// Preferred topics when picking a sample adventure for this world (order matters).
    var preferredSampleTopics: [Topic] {
        switch self {
        case .science:
            return [.space, .planets, .rockets, .dinosaurs, .volcanoes, .weather, .sharks, .oceanAnimals]
        case .history:
            return [.castles, .pirates, .princesses, .fairies]
        case .nature:
            // Forest/trail only — never horses, pets, or ocean under Wild Nature Trails.
            return [.nature, .bugs, .jungleAnimals, .farmAnimals, .zooAnimals]
        case .technology:
            return [.robots, .trains, .airplanes, .cars]
        case .artsAndCulture:
            return [.art, .music, .superheroes]
        case .language:
            return [.fairies, .princesses, .castles, .pirates]
        case .math:
            return [.soccer, .basketball, .robots, .trains, .horses, .space]
        case .lifeSkills:
            return [.dogs, .cats, .horses, .farmAnimals, .cooking]
        }
    }

    /// Topics that belong in this broad category for browse/search.
    /// Keep worlds distinct — Nature must not list horses/pets/ocean (those belong elsewhere).
    var topics: [Topic] {
        switch self {
        case .science:
            return [.space, .planets, .rockets, .dinosaurs, .volcanoes, .weather, .sharks, .oceanAnimals]
        case .history:
            return [.castles, .pirates, .princesses, .fairies]
        case .nature:
            return [.nature, .bugs, .jungleAnimals, .farmAnimals, .zooAnimals]
        case .technology:
            return [.robots, .airplanes, .trains, .cars]
        case .artsAndCulture:
            return [.art, .music, .superheroes]
        case .language:
            return [.princesses, .castles, .fairies, .pirates]
        case .math:
            return [.soccer, .basketball, .robots, .trains, .horses, .space]
        case .lifeSkills:
            return [.dogs, .cats, .cooking, .horses, .farmAnimals]
        }
    }

    static func categories(containing topic: Topic) -> [ExploreSubjectCategory] {
        allCases.filter { $0.topics.contains(topic) }
    }
}
