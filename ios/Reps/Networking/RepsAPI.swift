import Foundation

/// The website's JSON API (`/api/…`), for the things that need a server-side rule or a secret.
///
/// Reading goes straight to Supabase under row level security. Anything that must apply the app's
/// own rules — XP, and later the AI rehearsal partner — goes through here instead, so the rule lives
/// in one place and the website and the app cannot drift apart. Authenticated with the same Supabase
/// access token, sent as a bearer token.
struct RepsAPI {
    private let session = URLSession(configuration: {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return config
    }())

    /// Records a lesson as read, and awards its XP the first time. Idempotent on the server.
    func markLessonRead(_ lessonID: String, accessToken: String) async throws {
        let url = BackendConfig.siteURL.appendingPathComponent("api/lessons/\(lessonID)/read")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw BackendError.badResponse
        }
    }
}
