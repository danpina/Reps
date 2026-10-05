import Foundation

/// The app's own words, in the reader's language.
///
/// The language is the account's `profiles.locale`, not the phone's, so a person who chose
/// Spanish on the website reads Spanish here whatever their handset is set to. Curriculum
/// text is not in this file — it comes from the database, already translated. The Spanish
/// below is the website's own wording (`src/messages/es.json`), so the two read as one product.
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

    // Lessons
    func lessonOf(_ n: Int, _ total: Int) -> String { pick("Lesson \(n) of \(total)", "Lección \(n) de \(total)") }
    var inPractice: String { pick("In practice", "En la práctica") }
    func checkOf(_ n: Int, _ total: Int) -> String { pick("Check \(n) of \(total)", "Pregunta \(n) de \(total)") }
    var oneCheck: String { pick("One check", "Una pregunta") }
    var todaysMission: String { pick("Today’s field mission", "La misión de hoy") }
    var goAndDoIt: String { pick("Go and do it, then log what happened. It counts either way.", "Ve y hazlo, y luego registra qué pasó. Cuenta de cualquier forma.") }
    var previous: String { pick("Previous", "Anterior") }
    var nextLesson: String { pick("Next lesson", "Siguiente lección") }
    var backToTrack: String { pick("Back to the track", "Volver al recorrido") }
    var thereIsOneBefore: String { pick("There is one before this", "Hay una antes que esta") }
    func trackBuilds(_ n: Int, upTo next: Int) -> String {
        pick("This track builds, and lesson \(n) assumes the ones under it. You are up to lesson \(next).",
             "Este recorrido se construye, y la lección \(n) da por hecho las de debajo. Vas por la lección \(next).")
    }
    func goToLesson(_ n: Int, _ title: String) -> String { pick("Lesson \(n) · \(title)", "Lección \(n) · \(title)") }
    var partOfSubscription: String { pick("This one is part of the subscription", "Esta es parte de la suscripción") }
    func freePreview(count: Int, topic: String) -> String {
        pick("The first \(count) lessons of every topic are open, so you can read enough of \(topic) to judge whether the writing is worth paying for. This is not one of them.",
             "Las primeras \(count) lecciones de cada tema están abiertas, para que puedas leer suficiente de \(topic) y juzgar si merece la pena pagar por la escritura. Esta no es una de ellas.")
    }
    var correctYourAnswer: String { pick("Correct, and this was your answer.", "Correcto, y esta fue tu respuesta.") }
    var correctAnswer: String { pick("This was the correct answer.", "Esta era la respuesta correcta.") }
    var yourAnswerWrong: String { pick("Your answer, which was not correct.", "Tu respuesta, que no era correcta.") }
    var lessonUnavailable: String { pick("This lesson could not be opened.", "No se ha podido abrir esta lección.") }

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
