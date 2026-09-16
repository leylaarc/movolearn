import Foundation

/// Abstraction over child-profile persistence so storage can later move to CloudKit/DB.
protocol ProfileRepositoryProtocol: AnyObject {
    func load() -> ChildProfile?
    @discardableResult
    func save(_ profile: ChildProfile) -> Bool
    func delete()
    var hasPersistedProfile: Bool { get }
}

/// Local-first profile store using UserDefaults (same persistence style as `ProgressStore`).
final class ProfileRepository: ProfileRepositoryProtocol {
    static let shared = ProfileRepository()

    static let storageKey = "com.movolearn.childProfile"
    static let schemaKey = "com.movolearn.childProfile.schemaVersion"

    private let defaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    var hasPersistedProfile: Bool {
        defaults.data(forKey: Self.storageKey) != nil
    }

    func load() -> ChildProfile? {
        guard let data = defaults.data(forKey: Self.storageKey) else { return nil }
        do {
            var profile = try decoder.decode(ChildProfile.self, from: data)
            if profile.birthday != nil {
                profile.storedAge = profile.currentAge
            }
            let stripped = Self.stripSensitiveFields(profile)
            if stripped != profile {
                _ = save(stripped)
                return stripped
            }
            return stripped
        } catch {
            #if DEBUG
            print("[MovoLearn] Profile persistence failure: could not decode child profile — \(error)")
            #endif
            return nil
        }
    }

    @discardableResult
    func save(_ profile: ChildProfile) -> Bool {
        var toSave = Self.stripSensitiveFields(profile)
        toSave.schemaVersion = ChildProfile.currentSchemaVersion
        if toSave.birthday != nil {
            toSave.storedAge = toSave.currentAge
        }
        toSave.touch(updated: true, active: true)
        do {
            let data = try encoder.encode(toSave)
            defaults.set(data, forKey: Self.storageKey)
            defaults.set(ChildProfile.currentSchemaVersion, forKey: Self.schemaKey)
            return true
        } catch {
            #if DEBUG
            print("[MovoLearn] Profile persistence failure: could not encode child profile — \(error)")
            #endif
            return false
        }
    }

    func delete() {
        defaults.removeObject(forKey: Self.storageKey)
        defaults.removeObject(forKey: Self.schemaKey)
    }

    /// On-device launch does not keep a full birthday — age is enough for lesson difficulty.
    static func stripSensitiveFields(_ profile: ChildProfile) -> ChildProfile {
        guard !FamilyCloudSync.isEnabled else { return profile }
        var copy = profile
        if let birthday = copy.birthday {
            copy.storedAge = ChildProfile.age(from: birthday)
            copy.birthday = nil
        }
        return copy
    }
}
