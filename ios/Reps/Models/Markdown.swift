import Foundation

/// The small subset of markdown the curriculum uses: blank lines separate paragraphs, and
/// `**bold**` and `*italic*` mark emphasis. A port of `src/lib/markdown.ts`, with the same two
/// silent-failure guards: line endings are normalised before splitting (Windows endings arrive as
/// "\r\n\r\n" and would otherwise leave every lesson as one block), and a stray asterisk that is
/// not part of a matched pair is left as plain text rather than swallowed.
enum Markdown {
    static func paragraphs(_ markdown: String) -> [String] {
        let normalised = markdown
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return normalised
            .components(separatedBy: "\n\n")
            .map { $0.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    /// Bold is tried first at each position, so the two stars of `**x**` are never read as an
    /// italic run containing a star.
    private static let emphasis = try! NSRegularExpression(pattern: #"\*\*[^*]+\*\*|\*[^*\n]+\*"#)

    /// One paragraph as styled text. Built by hand rather than by `AttributedString(markdown:)`, so
    /// that it breaks in exactly the same places the website's renderer does.
    static func attributed(_ paragraph: String) -> AttributedString {
        var result = AttributedString()
        let text = paragraph as NSString
        var cursor = 0

        func appendPlain(_ range: NSRange) {
            guard range.length > 0 else { return }
            result.append(AttributedString(text.substring(with: range)))
        }

        for match in emphasis.matches(in: paragraph, range: NSRange(location: 0, length: text.length)) {
            appendPlain(NSRange(location: cursor, length: match.range.location - cursor))

            let raw = text.substring(with: match.range)
            let isBold = raw.hasPrefix("**")
            let inner = String(raw.dropFirst(isBold ? 2 : 1).dropLast(isBold ? 2 : 1))

            var run = AttributedString(inner)
            run.inlinePresentationIntent = isBold ? .stronglyEmphasized : .emphasized
            result.append(run)

            cursor = match.range.location + match.range.length
        }
        appendPlain(NSRange(location: cursor, length: text.length - cursor))
        return result
    }
}
