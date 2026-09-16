import Foundation

/// Launch ships as an on-device learning game. No child profile is sent to Movo Learn servers
/// until this is turned on after privacy review.
///
/// Do not set `true` until `docs/legal/PRIVACY_POLICY.md`, the hosted privacy URL,
/// and `PrivacyPolicyCopy` all describe cloud collection and parental consent.
enum FamilyCloudSync {
    static let isEnabled = false
}

struct FamilyAPIConfiguration {
    static var baseURL: URL {
        if let raw = Bundle.main.object(forInfoDictionaryKey: "FamilyAPIBaseURL") as? String,
           !raw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let url = URL(string: raw) {
            return url
        }
        #if DEBUG
        return URL(string: "http://127.0.0.1:8088")!
        #else
        return URL(string: "https://api.movolearn.app")!
        #endif
    }
}

struct FamilyAuthResponse: Decodable, Equatable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let parent: ParentAccount

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case parent
    }
}

struct FamilySyncPayload: Codable {
    var childId: UUID
    var profile: ChildProfile
    var completions: [LessonCompletionRecord]
    var learningState: ChildLearningState?
    var gameProgress: GameProgressSnapshot?
    var homeActivity: HomeActivityState?

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
        case profile
        case completions
        case learningState = "learning_state"
        case gameProgress = "game_progress"
        case homeActivity = "home_activity"
    }
}

struct FamilyChildSnapshot: Decodable {
    var childId: String
    var profile: ChildProfile
    var completions: [LessonCompletionRecord]
    var learningState: ChildLearningState?
    var gameProgress: GameProgressSnapshot?
    var homeActivity: HomeActivityState?
    var updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
        case profile
        case completions
        case learningState = "learning_state"
        case gameProgress = "game_progress"
        case homeActivity = "home_activity"
        case updatedAt = "updated_at"
    }
}

struct FamilySnapshot: Decodable {
    var parent: ParentAccount
    var children: [FamilyChildSnapshot]
}

enum FamilyAPIError: LocalizedError, Equatable {
    case notConfigured
    case notSignedIn
    case serverMessage(String)
    case httpStatus(Int)
    case decoding
    case network

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Cloud save is not configured yet."
        case .notSignedIn:
            return "Sign in with a parent account to save across devices."
        case .serverMessage(let message):
            return message
        case .httpStatus(let code) where code == 401:
            return "Please sign in again."
        case .httpStatus:
            return "Couldn't reach your family account. Try again in a moment."
        case .decoding:
            return "Couldn't read the saved profile."
        case .network:
            return "Check your internet connection and try again."
        }
    }
}
