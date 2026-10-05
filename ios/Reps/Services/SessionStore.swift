import Foundation
import SwiftUI

/// The profile row, as far as the app reads it. The same columns the website's settings page does.
struct Profile: Decodable, Equatable {
    var displayName: String?
    var locale: String?
    var theme: String?
    var sex: String?
    var ageGroup: String?
    var datingInterest: String?
    var onboardedAt: String?
}

enum PasswordChangeError: Error {
    /// The "current password" the reader typed is not the account's.
    case wrongCurrent
}

/// Who is signed in, and in which language. The single source of truth the views read.
@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var session: AuthSession?
    @Published private(set) var locale: AppLocale = .deviceDefault
    /// What the reader has told the app about themselves, which tailors a few lessons.
    @Published private(set) var audience = Audience()
    /// The rest of the profile, for the screens that show or change it.
    @Published private(set) var profile = Profile()
    /// `nil` until the profile has loaded; then whether onboarding is still to do.
    @Published private(set) var needsOnboarding: Bool?

    private let client = SupabaseClient.shared

    var isSignedIn: Bool { session != nil }
    var strings: Strings { Strings(locale: locale) }

    /// The appearance chosen in Settings, stored on the account. Nil follows the device.
    var colorScheme: ColorScheme? {
        switch profile.theme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

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
        profile = Profile()
        needsOnboarding = nil
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

    /// Runs work that needs a token, with a fresh one. A 401 from the server means the session is
    /// gone, so the reader is sent back to sign in rather than shown an error they cannot act on.
    func withToken<T>(_ work: (String) async throws -> T) async throws -> T {
        let token = try await validAccessToken()
        do {
            return try await work(token)
        } catch BackendError.notSignedIn {
            signOut()
            throw BackendError.notSignedIn
        }
    }

    /// Writes changes to the profile row under the reader's own row level security — exactly what
    /// the website's settings forms do — and refreshes what the screens read.
    func updateProfile(_ changes: [String: Any?]) async throws {
        guard let userID = session?.userID else { throw BackendError.notSignedIn }
        let token = try await validAccessToken()
        try await client.update("profiles", filter: "id=eq.\(userID)", changes: changes, accessToken: token)
        await loadProfile()
    }

    /// Changes the account's password. Supabase will change it on the strength of a session alone,
    /// which would make a borrowed phone enough to take the account — so, like the website, the
    /// current password is proved first.
    func changePassword(current: String, new: String) async throws {
        guard let email = session?.email, !email.isEmpty else { throw BackendError.notSignedIn }
        let token = try await validAccessToken()
        do {
            _ = try await client.signIn(email: email, password: current)
        } catch let error as URLError {
            throw error   // No connection is not a wrong password.
        } catch {
            throw PasswordChangeError.wrongCurrent
        }
        try await client.setPassword(new, accessToken: token)
    }

    private func store(_ newSession: AuthSession) {
        session = newSession
        if let data = try? JSONEncoder().encode(newSession) {
            Keychain.save(data)
        }
    }

    /// The account's language and demographics live on `profiles`, the same row the website reads.
    func loadProfile() async {
        guard let userID = session?.userID else { return }
        do {
            let token = try await validAccessToken()
            let rows: [Profile] = try await client.rows(
                "profiles",
                query: "select=display_name,locale,theme,sex,age_group,dating_interest,onboarded_at&id=eq.\(userID)",
                accessToken: token)
            if let loaded = rows.first {
                profile = loaded
                locale = AppLocale(stored: loaded.locale)
                audience = Audience(sex: loaded.sex, ageGroup: loaded.ageGroup, datingInterest: loaded.datingInterest)
                needsOnboarding = loaded.onboardedAt == nil
            }
        } catch {
            // Staying on the phone's language is a fine fallback; it is not worth an error screen.
            // Onboarding is assumed done: not knowing must not trap someone on a spinner.
            if needsOnboarding == nil { needsOnboarding = false }
        }
        Strings.current = Strings(locale: locale)
    }
}
