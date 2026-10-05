import Foundation

/// The website's own translations, bundled into the app.
///
/// `src/messages/en.json` and `es.json` are copied into the app at build time (see
/// `ios/scripts/sync-messages.sh`), so every sentence the website says, the app says in
/// exactly the same words — including all the Spanish that was reviewed line by line. There is
/// no second copy to keep in step: change the wording once, in the catalog, and both change.
///
/// A key missing from the reader's language falls back to English, and one missing from both
/// shows the key itself, which is ugly on purpose — a gap in the catalog should be noticed.
enum Messages {
    private static var cache: [AppLocale: [String: String]] = [:]
    private static let lock = NSLock()

    static func text(_ key: String, locale: AppLocale, _ args: [String: Any] = [:]) -> String {
        let pattern = catalog(locale)[key] ?? catalog(.default)[key] ?? key
        return ICU.format(pattern, args: args)
    }

    /// For the few sentences that carry emphasis: `<strong>x</strong>` becomes bold and any other
    /// tag is dropped.
    static func rich(_ key: String, locale: AppLocale, _ args: [String: Any] = [:]) -> AttributedString {
        let formatted = text(key, locale: locale, args)
            .replacingOccurrences(of: "<strong>", with: "**")
            .replacingOccurrences(of: "</strong>", with: "**")
        let stripped = formatted.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        return Markdown.attributed(stripped)
    }

    private static func catalog(_ locale: AppLocale) -> [String: String] {
        lock.lock()
        defer { lock.unlock() }
        if let cached = cache[locale] { return cached }
        let loaded = load(locale)
        cache[locale] = loaded
        return loaded
    }

    private static func load(_ locale: AppLocale) -> [String: String] {
        guard
            let url = Bundle.main.url(forResource: "messages-\(locale.rawValue)", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return [:] }

        var flat: [String: String] = [:]
        flatten(object, prefix: "", into: &flat)
        return flat
    }

    /// `{"lineDrill": {"sayIt": "Say it"}}` becomes `"lineDrill.sayIt": "Say it"`.
    private static func flatten(_ object: [String: Any], prefix: String, into flat: inout [String: String]) {
        for (key, value) in object {
            let path = prefix.isEmpty ? key : "\(prefix).\(key)"
            if let text = value as? String {
                flat[path] = text
            } else if let nested = value as? [String: Any] {
                flatten(nested, prefix: path, into: &flat)
            }
        }
    }
}

/// The small part of ICU MessageFormat the catalog actually uses: `{name}` placeholders and
/// `{count, plural, one {…} other {…}}` with `#` for the number. The catalog has no `select`,
/// ordinal or number formats, and English and Spanish both only distinguish "one" from "other".
enum ICU {
    static func format(_ pattern: String, args: [String: Any], pluralNumber: Int? = nil) -> String {
        let chars = Array(pattern)
        var out = ""
        var i = 0

        while i < chars.count {
            let c = chars[i]
            if c == "{", let close = matchingBrace(chars, from: i) {
                out += expand(String(chars[(i + 1)..<close]), args: args)
                i = close + 1
            } else if c == "#", let n = pluralNumber {
                out += String(n)
                i += 1
            } else {
                out.append(c)
                i += 1
            }
        }
        return out
    }

    /// The index of the `}` that closes the `{` at `start`, allowing for nesting.
    private static func matchingBrace(_ chars: [Character], from start: Int) -> Int? {
        var depth = 0
        var i = start
        while i < chars.count {
            if chars[i] == "{" { depth += 1 }
            if chars[i] == "}" {
                depth -= 1
                if depth == 0 { return i }
            }
            i += 1
        }
        return nil
    }

    private static func expand(_ inner: String, args: [String: Any]) -> String {
        let parts = splitTopLevel(inner, limit: 3)
        let name = parts[0].trimmingCharacters(in: .whitespaces)

        guard parts.count == 3, parts[1].trimmingCharacters(in: .whitespaces) == "plural" else {
            return stringValue(args[name])
        }

        let n = intValue(args[name])
        let branches = parseBranches(parts[2])
        let category = n == 1 ? "one" : "other"
        let body = branches["=\(n)"] ?? branches[category] ?? branches["other"] ?? ""
        return format(body, args: args, pluralNumber: n)
    }

    /// Splits on commas that are not inside braces, into at most `limit` parts (the last one
    /// takes the remainder, commas and all).
    private static func splitTopLevel(_ text: String, limit: Int) -> [String] {
        var parts: [String] = []
        var current = ""
        var depth = 0
        for c in text {
            if c == "{" { depth += 1 }
            if c == "}" { depth -= 1 }
            if c == ",", depth == 0, parts.count < limit - 1 {
                parts.append(current)
                current = ""
            } else {
                current.append(c)
            }
        }
        parts.append(current)
        return parts
    }

    /// `one {# day} other {# days}` → `["one": "# day", "other": "# days"]`.
    private static func parseBranches(_ text: String) -> [String: String] {
        let chars = Array(text)
        var branches: [String: String] = [:]
        var i = 0

        while i < chars.count {
            while i < chars.count, chars[i].isWhitespace { i += 1 }
            var selector = ""
            while i < chars.count, !chars[i].isWhitespace, chars[i] != "{" {
                selector.append(chars[i])
                i += 1
            }
            while i < chars.count, chars[i].isWhitespace { i += 1 }
            guard i < chars.count, chars[i] == "{", let close = matchingBrace(chars, from: i) else { break }
            branches[selector] = String(chars[(i + 1)..<close])
            i = close + 1
        }
        return branches
    }

    private static func stringValue(_ value: Any?) -> String {
        switch value {
        case let s as String: return s
        case let n as Int: return String(n)
        case let d as Double: return d.rounded() == d ? String(Int(d)) : String(d)
        case nil: return ""
        default: return "\(value!)"
        }
    }

    private static func intValue(_ value: Any?) -> Int {
        switch value {
        case let n as Int: return n
        case let d as Double: return Int(d)
        case let s as String: return Int(s) ?? 0
        default: return 0
        }
    }
}
