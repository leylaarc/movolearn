import Foundation

protocol FamilyAPIClientProtocol: AnyObject {
    func register(email: String, password: String, parentalConsent: Bool) async throws -> FamilyAuthResponse
    func login(email: String, password: String) async throws -> FamilyAuthResponse
    func refresh(refreshToken: String) async throws -> FamilyAuthResponse
    func logout(refreshToken: String) async
    func fetchFamily(accessToken: String) async throws -> FamilySnapshot
    func upsertChild(accessToken: String, payload: FamilySyncPayload) async throws -> FamilyChildSnapshot
    func deleteChild(accessToken: String, childId: UUID) async throws
    func deleteAccount(accessToken: String) async throws
}

final class FamilyAPIClient: FamilyAPIClientProtocol {
    static let shared = FamilyAPIClient()

    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = .shared, baseURL: URL = FamilyAPIConfiguration.baseURL) {
        self.session = session
        self.baseURL = baseURL
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
    }

    func register(email: String, password: String, parentalConsent: Bool) async throws -> FamilyAuthResponse {
        try ensureCloudAllowed()
        return try await post(
            path: "/v1/auth/register",
            body: [
                "email": email,
                "password": password,
                "parental_consent": parentalConsent
            ]
        )
    }

    func login(email: String, password: String) async throws -> FamilyAuthResponse {
        try ensureCloudAllowed()
        return try await post(
            path: "/v1/auth/login",
            body: ["email": email, "password": password]
        )
    }

    func refresh(refreshToken: String) async throws -> FamilyAuthResponse {
        try ensureCloudAllowed()
        return try await post(path: "/v1/auth/refresh", body: ["refresh_token": refreshToken])
    }

    func logout(refreshToken: String) async {
        guard FamilyCloudSync.isEnabled else { return }
        var request = URLRequest(url: endpoint("/v1/auth/logout"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["refresh_token": refreshToken])
        _ = try? await session.data(for: request)
    }

    func fetchFamily(accessToken: String) async throws -> FamilySnapshot {
        try ensureCloudAllowed()
        return try await send(path: "/v1/me", method: "GET", accessToken: accessToken)
    }

    func upsertChild(accessToken: String, payload: FamilySyncPayload) async throws -> FamilyChildSnapshot {
        try ensureCloudAllowed()
        var request = makeRequest(
            path: "/v1/children/\(payload.childId.uuidString)",
            method: "PUT",
            accessToken: accessToken
        )
        request.httpBody = try encoder.encode(payload)
        return try await decode(FamilyChildSnapshot.self, from: request)
    }

    func deleteChild(accessToken: String, childId: UUID) async throws {
        try ensureCloudAllowed()
        let request = makeRequest(
            path: "/v1/children/\(childId.uuidString)",
            method: "DELETE",
            accessToken: accessToken
        )
        try await sendEmpty(request)
    }

    func deleteAccount(accessToken: String) async throws {
        try ensureCloudAllowed()
        let request = makeRequest(path: "/v1/account", method: "DELETE", accessToken: accessToken)
        try await sendEmpty(request)
    }

    private func ensureCloudAllowed() throws {
        guard FamilyCloudSync.isEnabled else { throw FamilyAPIError.notConfigured }
    }

    private func post<Response: Decodable>(path: String, body: [String: Any]) async throws -> Response {
        var request = makeRequest(path: path, method: "POST", accessToken: nil)
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return try await decode(Response.self, from: request)
    }

    private func send<Response: Decodable>(path: String, method: String, accessToken: String?) async throws -> Response {
        let request = makeRequest(path: path, method: method, accessToken: accessToken)
        return try await decode(Response.self, from: request)
    }

    private func makeRequest(path: String, method: String, accessToken: String?) -> URLRequest {
        var request = URLRequest(url: endpoint(path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 20
        return request
    }

    private func endpoint(_ path: String) -> URL {
        path.split(separator: "/").reduce(baseURL) { $0.appending(path: String($1)) }
    }

    private func decode<Response: Decodable>(_ type: Response.Type, from request: URLRequest) async throws -> Response {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw FamilyAPIError.network
        }
        guard let http = response as? HTTPURLResponse else { throw FamilyAPIError.network }
        guard (200..<300).contains(http.statusCode) else {
            throw Self.mappedError(status: http.statusCode, data: data)
        }
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw FamilyAPIError.decoding
        }
    }

    private func sendEmpty(_ request: URLRequest) async throws {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw FamilyAPIError.network
        }
        guard let http = response as? HTTPURLResponse else { throw FamilyAPIError.network }
        guard (200..<300).contains(http.statusCode) else {
            throw Self.mappedError(status: http.statusCode, data: data)
        }
    }

    private static func mappedError(status: Int, data: Data) -> FamilyAPIError {
        if let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let detail = object["detail"] as? String, !detail.isEmpty {
                return .serverMessage(detail)
            }
        }
        return .httpStatus(status)
    }
}

