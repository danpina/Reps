import Foundation

/// The languages the app is offered in. Mirrors `LOCALES` in the website's
/// `src/lib/curriculum/locale.ts` — German is not offered yet, and a stored value the app
/// does not know reads as English, the same rule the website uses.
enum AppLocale: String, CaseIterable {
    case en
    case es

    static let `default` = AppLocale.en

    init(stored value: String?) {
        self = value.flatMap(AppLocale.init(rawValue:)) ?? .default
    }

    /// The name of a language in that language, which is how a picker should read.
    var nativeName: String {
        switch self {
        case .en: return "English"
        case .es: return "Español"
        }
    }
}
