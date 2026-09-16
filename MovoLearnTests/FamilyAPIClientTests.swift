import XCTest
@testable import MovoLearn

final class FamilyAPIClientTests: XCTestCase {
    func testAuthResponseDecodesSnakeCaseKeys() throws {
        let json = """
        {
          "access_token": "aaa",
          "refresh_token": "bbb",
          "token_type": "bearer",
          "expires_in": 900,
          "parent": { "id": "parent-1", "email": "parent@example.com", "created_at": "2026-09-16T12:00:00Z" }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(FamilyAuthResponse.self, from: json)
        XCTAssertEqual(response.accessToken, "aaa")
        XCTAssertEqual(response.refreshToken, "bbb")
        XCTAssertEqual(response.expiresIn, 900)
        XCTAssertEqual(response.parent.email, "parent@example.com")
    }

    func testSyncPayloadRoundTripPreservesChildProfile() throws {
        var profile = ChildProfile(nickname: "Mia", age: 7)
        profile.favoriteTopics = [.oceanAnimals]
        profile.hasCompletedOnboarding = true
        let payload = FamilySyncPayload(
            childId: profile.id,
            profile: profile,
            completions: [],
            learningState: .empty(childId: profile.id),
            gameProgress: .empty,
            homeActivity: .empty
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let data = try encoder.encode(payload)
        let decoded = try decoder.decode(FamilySyncPayload.self, from: data)
        XCTAssertEqual(decoded.profile.nickname, "Mia")
        XCTAssertEqual(decoded.profile.favoriteTopics, [.oceanAnimals])
        XCTAssertEqual(decoded.childId, profile.id)
    }

    func testLaunchPrivacyPolicyMatchesDisabledCloudSync() {
        XCTAssertFalse(FamilyCloudSync.isEnabled)
        XCTAssertEqual(
            PrivacyPolicyCopy.cloudSyncEnabledInThisVersion,
            FamilyCloudSync.isEnabled,
            "Rewrite docs/legal and PrivacyPolicyCopy before enabling FamilyCloudSync"
        )
        XCTAssertTrue(PrivacyPolicyCopy.fullText.contains("not sent to Movo Learn"))
        XCTAssertTrue(PrivacyPolicyCopy.fullText.contains("privacy@movolearn.app"))
        XCTAssertEqual(PrivacyPolicyCopy.publicURLString, "https://movolearn.com/privacy")
        XCTAssertFalse(PrivacyPolicyCopy.fullText.contains("App Store listing"))
    }

    func testCloudSyncDisabledBlocksNetworkCalls() async {
        XCTAssertFalse(FamilyCloudSync.isEnabled)
        let client = FamilyAPIClient()
        do {
            _ = try await client.register(email: "parent@example.com", password: "long-enough-password", parentalConsent: true)
            XCTFail("Cloud calls must be blocked while FamilyCloudSync is disabled")
        } catch let error as FamilyAPIError {
            XCTAssertEqual(error, .notConfigured)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
