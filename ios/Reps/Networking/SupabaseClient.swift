import Foundation

/// A signed-in Supabase Auth session, as the app keeps it between launches.
struct AuthSession: Codable, Equatable {
    var accessToken: String
    var refreshToken: String
    var expiresAt: Date
    var userID: String
    var email: String

    /// Treated as expired a minute early so a request never goes out with a token
    /// that dies in flight.
    var needsRefresh: Bool { expiresAt.timeIntervalSinceNow < 60 }
}

enum BackendError: LocalizedError {
    case message(String)
    case badResponse
    case notSignedIn

    var errorDescription: String? {
        switch self {
        case .message(let text): return text
        case .badResponse: return Strings.current.genericError
        case .notSignedIn: return Strings.current.sessionExpired
        }
    }
}

/// A deliberately small client for Supabase's two HTTP surfaces — Auth (GoTrue) and
/// PostgREST. The website reads through the same row level security policies, so the
/// app sees exactly what the same account sees there and nothing more.
final class SupabaseClient {
    static let shared = SupabaseClient()

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config)
    }()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // MARK: Auth

    func signIn(email: String, password: String) async throws -> AuthSession {
        let body = try JSONSerialization.data(withJSONObject: ["email": email, "password": password])
        return try await tokenRequest(grantType: "password", body: body)
    }

    func refresh(_ current: AuthSession) async throws -> AuthSession {
        let body = try JSONSerialization.data(withJSONObject: ["refresh_token": current.refreshToken])
        return try await tokenRequest(grantType: "refresh_token", body: body)
    }

    private func tokenRequest(grantType: String, body: Data) async throws -> AuthSession {
        var components = URLComponents(url: BackendConfig.supabaseURL.appendingPathComponent("auth/v1/token"),
                                       resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "grant_type", value: grantType)]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(BackendConfig.publishableKey, forHTTPHeaderField: "apikey")

        let (data, response) = try await send(request)
        guard (200..<300).contains(response.statusCode) else { throw Self.error(from: data) }

        struct TokenResponse: Decodable {
            struct User: Decodable { let id: String; let email: String? }
            let accessToken: String
            let refreshToken: String
            let expiresIn: Double
            let user: User
        }
        let token = try decoder.decode(TokenResponse.self, from: data)
        return AuthSession(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken,
            expiresAt: Date().addingTimeInterval(token.expiresIn),
            userID: token.user.id,
            email: token.user.email ?? ""
        )
    }

    // MARK: PostgREST

    /// Reads rows from a table or view. `query` is the PostgREST query string
    /// (`select=…&order=…`), passed through as-is so it reads like the website's queries.
    func rows<T: Decodable>(_ table: String, query: String, accessToken: String) async throws -> [T] {
        var components = URLComponents(url: BackendConfig.supabaseURL.appendingPathComponent("rest/v1/\(table)"),
                                       resolvingAgainstBaseURL: false)!
        components.percentEncodedQuery = query

        var request = URLRequest(url: components.url!)
        request.setValue(BackendConfig.publishableKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await send(request)
        guard (200..<300).contains(response.statusCode) else { throw Self.error(from: data) }
        return try decoder.decode([T].self, from: data)
    }

    // MARK: Plumbing

    private func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw BackendError.badResponse }
        return (data, http)
    }

    /// Supabase reports failures under different keys depending on which service said no.
    private static func error(from data: Data) -> BackendError {
        if let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            for key in ["error_description", "msg", "message", "error"] {
                if let text = object[key] as? String, !text.isEmpty {
                    return .message(friendly(text))
                }
            }
        }
        return .badResponse
    }

    /// The one failure a person will actually hit gets a sentence a person can use.
    private static func friendly(_ text: String) -> String {
        text.lowercased().contains("invalid login credentials") ? Strings.current.wrongCredentials : text
    }
}
