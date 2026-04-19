import Foundation

/// Thin wrapper around URLSession that talks to the Next.js backend.
/// Set API_BASE_URL in Info.plist (or override here) to point at your deployed Vercel URL.
final class APIClient {
    static let shared = APIClient()

    /// Reads API_BASE_URL from Info.plist if present, otherwise defaults to localhost
    /// for dev. Production should always set this via Info.plist build setting.
    let baseURL: URL

    private init() {
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
           let url = URL(string: urlString) {
            self.baseURL = url
        } else {
            // Fallback for local dev — override in Info.plist for production
            self.baseURL = URL(string: "http://localhost:3000")!
        }
    }

    enum APIError: Error, LocalizedError {
        case badResponse(Int)
        case decodingFailed
        case transport(Error)
        case unauthorized

        var errorDescription: String? {
            switch self {
            case .badResponse(let code): return "Server returned status \(code)"
            case .decodingFailed: return "Could not decode response"
            case .transport(let err): return err.localizedDescription
            case .unauthorized: return "Unauthorized"
            }
        }
    }

    // MARK: - Auth

    struct AppleSignInRequest: Encodable {
        let idToken: String
        let nonce: String
        let fullName: String?
        let email: String?
    }

    struct AppleSignInResponse: Decodable {
        let sessionToken: String
        let userId: String
    }

    func signInWithApple(_ request: AppleSignInRequest) async throws -> AppleSignInResponse {
        try await post(path: "/api/auth/apple", body: request, auth: false)
    }

    #if DEBUG
    func testSignIn() async throws -> AppleSignInResponse {
        struct Empty: Encodable {}
        return try await post(path: "/api/auth/test", body: Empty(), auth: false)
    }
    #endif

    struct MeResponse: Decodable {
        let userId: String
        let email: String?
        let name: String?
        let isPremium: Bool
    }

    func me() async throws -> MeResponse {
        try await get(path: "/api/user/me", auth: true)
    }

    // MARK: - Generic helpers

    private func get<T: Decodable>(path: String, auth: Bool) async throws -> T {
        var req = URLRequest(url: baseURL.appendingPathComponent(path))
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        attach(&req, auth: auth)
        return try await perform(req)
    }

    private func post<Body: Encodable, T: Decodable>(path: String, body: Body, auth: Bool) async throws -> T {
        var req = URLRequest(url: baseURL.appendingPathComponent(path))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.httpBody = try JSONEncoder().encode(body)
        attach(&req, auth: auth)
        return try await perform(req)
    }

    private func attach(_ req: inout URLRequest, auth: Bool) {
        guard auth, let token = KeychainHelper.read("sessionToken") else { return }
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    private func perform<T: Decodable>(_ req: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse else {
                throw APIError.badResponse(-1)
            }
            if http.statusCode == 401 { throw APIError.unauthorized }
            guard (200..<300).contains(http.statusCode) else {
                throw APIError.badResponse(http.statusCode)
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        } catch let err as APIError {
            throw err
        } catch {
            throw APIError.transport(error)
        }
    }
}
