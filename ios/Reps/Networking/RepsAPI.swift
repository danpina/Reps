import Foundation

/// A refusal from the website's API. The server words its own failures in the reader's language
/// where the website's code already did (`message`); otherwise there is a stable `code` the app
/// words itself.
struct APIFailure: LocalizedError {
    let status: Int
    let code: String
    let message: String?

    var errorDescription: String? {
        if let message, !message.isEmpty { return message }
        return Strings.current.genericError
    }
}

/// The website's JSON API (`/api/…`), for everything that needs a server-side rule or a secret.
///
/// Reading the curriculum goes straight to Supabase under row level security. Anything that must
/// apply the app's own rules — XP, the rehearsal partner, the free allowance, the streak — goes
/// through here instead, and runs the very same code the website does, so the rule lives in one
/// place and the app and the website cannot drift apart. Authenticated with the Supabase access
/// token, sent as a bearer token.
struct RepsAPI {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        // The AI partner can take a while to answer, and a scene review longer still.
        config.timeoutIntervalForRequest = 90
        return URLSession(configuration: config)
    }()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func get<T: Decodable>(_ path: String, token: String) async throws -> T {
        try await send("GET", path, body: nil, token: token)
    }

    func post<T: Decodable>(_ path: String, body: [String: Any]? = nil, token: String) async throws -> T {
        try await send("POST", path, body: body, token: token)
    }

    func patch<T: Decodable>(_ path: String, body: [String: Any], token: String) async throws -> T {
        try await send("PATCH", path, body: body, token: token)
    }

    func delete<T: Decodable>(_ path: String, body: [String: Any]? = nil, token: String) async throws -> T {
        try await send("DELETE", path, body: body, token: token)
    }

    /// Records a lesson as read, and awards its XP the first time. Idempotent on the server.
    func markLessonRead(_ lessonID: String, accessToken: String) async throws {
        let _: Acknowledged = try await post("api/lessons/\(lessonID)/read", token: accessToken)
    }

    private func send<T: Decodable>(_ method: String, _ path: String, body: [String: Any]?, token: String) async throws -> T {
        var request = URLRequest(url: BackendConfig.siteURL.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw BackendError.badResponse }

        guard (200..<300).contains(http.statusCode) else {
            if http.statusCode == 401 { throw BackendError.notSignedIn }
            let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            throw APIFailure(status: http.statusCode,
                             code: object?["error"] as? String ?? "error",
                             message: object?["message"] as? String)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            // A body the app cannot read is a bug worth seeing, not a blank screen.
            throw BackendError.message("\(Strings.current.genericError) (\(path))")
        }
    }
}
