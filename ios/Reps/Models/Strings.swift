import Foundation

/// The app's own words, in the reader's language.
///
/// The language is the account's `profiles.locale`, not the phone's, so a person who chose
/// Spanish on the website reads Spanish here whatever their handset is set to. Curriculum
/// text is not in this file — it comes from the database, already translated.
struct Strings {
    let locale: AppLocale

    /// Set by `SessionStore` whenever the account's language is known. Before sign-in
    /// there is no account to ask, so the phone's language picks between the two.
    static var current = Strings(locale: .deviceDefault)

    private func pick(_ en: String, _ es: String) -> String {
        locale == .es ? es : en
    }

    // Sign in
    var tagline: String { pick("Talking to people is a skill, not a personality.", "Hablar con la gente es una habilidad, no una personalidad.") }
    var signIn: String { pick("Sign in", "Iniciar sesión") }
    var email: String { pick("Email", "Correo electrónico") }
    var password: String { pick("Password", "Contraseña") }
    var noAccountHint: String { pick("New here? Create your account on the Reps website, then sign in.", "¿Nuevo por aquí? Crea tu cuenta en la web de Reps y luego inicia sesión.") }

    // Topics
    var topics: String { pick("Topics", "Temas") }
    var signOut: String { pick("Sign out", "Cerrar sesión") }
    var retry: String { pick("Try again", "Reintentar") }
    var loading: String { pick("Loading…", "Cargando…") }
    var free: String { pick("free", "gratis") }
    func counts(skills: Int, lessons: Int) -> String {
        if locale == .es {
            return "\(skills) \(skills == 1 ? "habilidad" : "habilidades") · \(lessons) lecciones"
        }
        return "\(skills) \(skills == 1 ? "skill" : "skills") · \(lessons) lessons"
    }

    // Errors
    var genericError: String { pick("Something went wrong. Please try again.", "Algo ha salido mal. Inténtalo de nuevo.") }
    var sessionExpired: String { pick("Your session has expired. Please sign in again.", "Tu sesión ha caducado. Inicia sesión de nuevo.") }
    var wrongCredentials: String { pick("That email and password don't match.", "Ese correo y esa contraseña no coinciden.") }
}

extension AppLocale {
    /// The phone's preferred language, narrowed to the two the app offers.
    static var deviceDefault: AppLocale {
        let code = Locale.preferredLanguages.first.map { String($0.prefix(2)) }
        return AppLocale(stored: code)
    }
}
