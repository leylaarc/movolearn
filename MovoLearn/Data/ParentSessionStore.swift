import Foundation
import Combine

struct ParentAccount: Codable, Equatable {
    let id: String
    let email: String
}

struct ParentSession: Codable, Equatable {
    var parent: ParentAccount
    var accessToken: String
    var refreshToken: String
    var accessTokenExpiresAt: Date
}

protocol ParentSessionStoreProtocol: AnyObject {
    var session: ParentSession? { get }
    var isSignedIn: Bool { get }
    func save(_ session: ParentSession)
    func updateTokens(accessToken: String, refreshToken: String, expiresIn: Int)
    func clear()
}

/// Parent session lives in the Keychain, not UserDefaults.
@MainActor
final class ParentSessionStore: ObservableObject, ParentSessionStoreProtocol {
    static let shared = ParentSessionStore()

    private static let account = "parentSession"

    @Published private(set) var session: ParentSession?

    var isSignedIn: Bool { session != nil }

    init() {
        session = Self.loadFromKeychain()
    }

    func save(_ session: ParentSession) {
        self.session = session
        if let data = try? JSONEncoder().encode(session) {
            _ = KeychainStore.set(data, account: Self.account)
        }
    }

    func updateTokens(accessToken: String, refreshToken: String, expiresIn: Int) {
        guard var session else { return }
        session.accessToken = accessToken
        session.refreshToken = refreshToken
        session.accessTokenExpiresAt = Date().addingTimeInterval(TimeInterval(max(60, expiresIn - 30)))
        save(session)
    }

    func clear() {
        session = nil
        KeychainStore.delete(account: Self.account)
    }

    private static func loadFromKeychain() -> ParentSession? {
        guard let data = KeychainStore.data(account: account) else { return nil }
        return try? JSONDecoder().decode(ParentSession.self, from: data)
    }
}
