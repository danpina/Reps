import XCTest
@testable import Reps

/// Mirrors `tests/markdown.test.ts`. The failures this guards against are silent: nothing throws, and
/// a lesson that lost its paragraph breaks or prints its own asterisks just reads as bad writing.
final class MarkdownTests: XCTestCase {
    func testBlankLinesSeparateParagraphs() {
        XCTAssertEqual(Markdown.paragraphs("one\n\ntwo"), ["one", "two"])
    }

    // Content pasted with Windows line endings arrives as "\r\n\r\n". A split on "\n\n" alone never
    // matches it, and every lesson silently becomes one block.
    func testWindowsLineEndingsStillSplit() {
        XCTAssertEqual(Markdown.paragraphs("one\r\n\r\ntwo"), ["one", "two"])
    }

    func testASingleNewlineIsAWrapNotABreak() {
        XCTAssertEqual(Markdown.paragraphs("one\ntwo\n\nthree"), ["one two", "three"])
    }

    func testExtraBlankLinesDoNotMakeEmptyParagraphs() {
        XCTAssertEqual(Markdown.paragraphs("\n\none\n\n\n\ntwo\n\n"), ["one", "two"])
    }

    func testBoldAndItalicBecomeStyledRunsWithoutTheirAsterisks() {
        let text = Markdown.attributed("plain **bold** and *quiet* end")
        XCTAssertEqual(String(text.characters), "plain bold and quiet end")

        var bold = [String](), italic = [String]()
        for run in text.runs {
            let piece = String(text[run.range].characters)
            if run.inlinePresentationIntent == .stronglyEmphasized { bold.append(piece) }
            if run.inlinePresentationIntent == .emphasized { italic.append(piece) }
        }
        XCTAssertEqual(bold, ["bold"])
        XCTAssertEqual(italic, ["quiet"])
    }

    // Bold is tried first, so the two stars of **x** are never read as an italic run.
    func testBoldIsNotMistakenForItalic() {
        let text = Markdown.attributed("**The move:** say it")
        XCTAssertEqual(String(text.characters), "The move: say it")
        XCTAssertTrue(text.runs.contains { $0.inlinePresentationIntent == .stronglyEmphasized })
        XCTAssertFalse(text.runs.contains { $0.inlinePresentationIntent == .emphasized })
    }

    // An unmatched star is plain text, not something to swallow.
    func testAStrayAsteriskIsLeftAlone() {
        let text = Markdown.attributed("5 * 3 is fifteen")
        XCTAssertEqual(String(text.characters), "5 * 3 is fifteen")
        XCTAssertFalse(text.runs.contains { $0.inlinePresentationIntent != nil })
    }
}
