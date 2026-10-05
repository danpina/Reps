import Foundation

/// Who is signed in, and in which language. The single source of truth the views read.
@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var session: AuthSession?
    @Published private(set) var locale: AppLocale = .deviceDefault
    /// What the reader has told the app about themselves, which tailors a few lessons.
    @Published private(set) var audience = Audience()

    private let client = SupabaseClient.shared

    var isSignedIn: Bool { session != nil }
    var strings: Strings { Strings(locale: locale) }

    init() {
        if let data = Keychain.load(), let saved = try? JSONDecoder().decode(AuthSession.self, from: data) {
            session = saved
        }
        Task { await loadProfile() }
    }

    func signIn(email: String, password: String) async throws {
        let fresh = try await client.signIn(email: email.trimmingCharacters(in: .whitespaces), password: password)
        store(fresh)
        await loadProfile()
    }

    func signOut() {
        session = nil
        Keychain.delete()
        locale = .deviceDefault
        audience = Audience()
        Strings.current = Strings(locale: locale)
    }

    /// A token that is good for at least the next minute, refreshed if it is not.
    /// A refresh that fails means the session is gone, so the person is sent back to sign in.
    func validAccessToken() async throws -> String {
        guard var current = session else { throw BackendError.notSignedIn }
        if current.needsRefresh {
            do {
                current = try await client.refresh(current)
                store(current)
            } catch {
                signOut()
                throw BackendError.notSignedIn
            }
        }
        return current.accessToken
    }

    private func store(_ newSession: AuthSession) {
        session = newSession
        if let data = try? JSONEncoder().encode(newSession) {
            Keychain.save(data)
        }
    }

    /// The account's language and demographics live on `profiles`, the same row the website reads.
    private func loadProfile() async {
        guard let userID = session?.userID else { return }
        struct Profile: Decodable {
            let locale: String?
            let sex: String?
            let ageGroup: String?
            let datingInterest: String?
        }
        do {
            let token = try await validAccessToken()
            let rows: [Profile] = try await client.rows(
                "profiles", query: "select=locale,sex,age_group,dating_interest&id=eq.\(userID)", accessToken: token)
            if let profile = rows.first {
                locale = AppLocale(stored: profile.locale)
                audience = Audience(sex: profile.sex, ageGroup: profile.ageGroup, datingInterest: profile.datingInterest)
            }
        } catch {
            // Staying on the phone's language is a fine fallback; it is not worth an error screen.
        }
        Strings.current = Strings(locale: locale)
    }
}
