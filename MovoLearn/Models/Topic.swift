import Foundation
import SwiftUI

// MARK: - Topic Identifier

enum Topic: String, Codable, CaseIterable, Identifiable {
    case sharks = "Sharks"
    case oceanAnimals = "Ocean Animals"
    case horses = "Horses"
    case dinosaurs = "Dinosaurs"
    case space = "Space"
    case planets = "Planets"
    case rockets = "Rockets"
    case soccer = "Soccer"
    case basketball = "Basketball"
    case dogs = "Dogs"
    case cats = "Cats"
    case jungleAnimals = "Jungle Animals"
    case princesses = "Princesses"
    case castles = "Castles"
    case fairies = "Fairies"
    case airplanes = "Airplanes"
    case trains = "Trains"
    case cars = "Cars"
    case robots = "Robots"
    case superheroes = "Superheroes"
    case art = "Art"
    case music = "Music"
    case cooking = "Cooking"
    case nature = "Nature"
    case bugs = "Bugs"
    case volcanoes = "Volcanoes"
    case weather = "Weather"
    case farmAnimals = "Farm Animals"
    case zooAnimals = "Zoo Animals"
    case pirates = "Pirates"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .sharks: return "🦈"
        case .oceanAnimals: return "🐠"
        case .horses: return "🐴"
        case .dinosaurs: return "🦕"
        case .space, .planets, .rockets: return "🚀"
        case .soccer: return "⚽️"
        case .basketball: return "🏀"
        case .dogs: return "🐶"
        case .cats: return "🐱"
        case .jungleAnimals: return "🦜"
        case .princesses, .castles, .fairies: return "👑"
        case .airplanes: return "✈️"
        case .trains: return "🚂"
        case .cars: return "🚗"
        case .robots: return "🤖"
        case .superheroes: return "🦸"
        case .art: return "🎨"
        case .music: return "🎵"
        case .cooking: return "👩‍🍳"
        case .nature: return "🌿"
        case .bugs: return "🐛"
        case .volcanoes: return "🌋"
        case .weather: return "⛅️"
        case .farmAnimals: return "🐄"
        case .zooAnimals: return "🦁"
        case .pirates: return "🏴‍☠️"
        }
    }
}

// MARK: - Topic Category

enum TopicCategory: String, Codable, CaseIterable {
    case animals = "Animals"
    case science = "Science & Space"
    case sports = "Sports"
    case fantasy = "Fantasy & Adventure"
    case vehicles = "Vehicles & Machines"
    case arts = "Arts & Creativity"
    case nature = "Nature & Outdoors"
}

// MARK: - Topic Definition (rich metadata for lessons & UI)

struct TopicDefinition: Identifiable {
    let id: Topic
    let name: String
    let category: TopicCategory
    let description: String
    let primaryColorName: String
    let secondaryColorName: String
    let vocabularyWords: [String]
    let scienceFacts: [String]
    let storySettings: [String]
    let mathContexts: [String]
    let creativePrompts: [String]

    var primaryColor: Color { TopicColorResolver.color(named: primaryColorName) }
    var secondaryColor: Color { TopicColorResolver.color(named: secondaryColorName) }

    var gradientColors: [Color] { [primaryColor, secondaryColor] }

    /// Returns a creative prompt with an explicit response type (never inferred at display time).
    func creativePrompt(at index: Int) -> (text: String, responseType: QuestionResponseType) {
        let text = creativePrompts[index % creativePrompts.count]
        return (text, TopicCreativePromptClassifier.responseType(for: text))
    }
}

/// Classifies topic-library creative strings into explicit response types at lesson-build time.
enum TopicCreativePromptClassifier {
    static func responseType(for text: String) -> QuestionResponseType {
        let lower = text.lowercased()
        if QuestionResponseTypeResolver.looksLikeDrawingPrompt(lower) {
            return .drawing
        }
        if lower.hasPrefix("write ") || lower.hasPrefix("what ") || lower.hasPrefix("why ") || lower.hasPrefix("how ") {
            return .shortText
        }
        return .longText
    }
}

enum TopicColorResolver {
    static func color(named name: String) -> Color {
        switch name {
        case "oceanTurquoise": return DesignSystem.Colors.oceanTurquoise
        case "skyBlue": return DesignSystem.Colors.skyBlue
        case "warmOrange": return DesignSystem.Colors.warmOrange
        case "freshGreen": return DesignSystem.Colors.freshGreen
        case "brightLavender": return DesignSystem.Colors.brightLavender
        case "coralPink": return DesignSystem.Colors.coralPink
        case "sunshineYellow": return DesignSystem.Colors.sunshineYellow
        case "deepNavy": return DesignSystem.Colors.deepNavy
        default: return DesignSystem.Colors.skyBlue
        }
    }
}
