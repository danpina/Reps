import XCTest
@testable import Reps

/// The formatter, and — because the tests run hosted in the app — that the website's catalogs
/// really were bundled and read. A missing resource shows up here as the key itself.
final class MessagesTests: XCTestCase {
    func testAPlaceholderIsSubstituted() {
        XCTAssertEqual(ICU.format("Good to see you, {name}", args: ["name": "Dani"]), "Good to see you, Dani")
    }

    func testPluralChoosesOneOrOther() {
        let pattern = "{count, plural, one {# day} other {# days}}"
        XCTAssertEqual(ICU.format(pattern, args: ["count": 1]), "1 day")
        XCTAssertEqual(ICU.format(pattern, args: ["count": 0]), "0 days")
        XCTAssertEqual(ICU.format(pattern, args: ["count": 12]), "12 days")
    }

    // Two plurals in one sentence, each with its own number — the shape of "5 reps across 2 skills".
    func testTwoPluralsInOneSentence() {
        let pattern = "{reps, plural, one {# rep} other {# reps}} across {skills, plural, one {# skill} other {# skills}}."
        XCTAssertEqual(ICU.format(pattern, args: ["reps": 1, "skills": 3]), "1 rep across 3 skills.")
        XCTAssertEqual(ICU.format(pattern, args: ["reps": 4, "skills": 1]), "4 reps across 1 skill.")
    }

    func testTextAroundAPluralSurvives() {
        let pattern = "{count, plural, one {# línea} other {# líneas}} dichas"
        XCTAssertEqual(ICU.format(pattern, args: ["count": 2]), "2 líneas dichas")
    }

    func testAHashOutsideAPluralIsLiteral() {
        XCTAssertEqual(ICU.format("Level #1", args: [:]), "Level #1")
    }

    func testAnApostropheIsLiteral() {
        XCTAssertEqual(ICU.format("Today's mission", args: [:]), "Today's mission")
    }

    func testAMissingArgumentIsEmptyNotACrash() {
        XCTAssertEqual(ICU.format("Hello {name}!", args: [:]), "Hello !")
    }

    // MARK: the bundled catalogs

    func testTheEnglishCatalogIsBundled() {
        XCTAssertEqual(Messages.text("lineDrill.sayIt", locale: .en), "Say it")
    }

    func testTheSpanishCatalogIsBundled() {
        XCTAssertEqual(Messages.text("lessonPage.checkOfTotal", locale: .es, ["n": 1, "total": 2]), "Pregunta 1 de 2")
    }

    func testSpanishPluralsUseTheCatalogsOwnWording() {
        XCTAssertEqual(Messages.text("heatmap.daysCount", locale: .es, ["count": 1]), "1 día")
        XCTAssertEqual(Messages.text("heatmap.daysCount", locale: .es, ["count": 3]), "3 días")
    }

    func testAKeyMissingEverywhereShowsTheKey() {
        XCTAssertEqual(Messages.text("nope.nothing", locale: .es), "nope.nothing")
    }

    func testRichTextBoldsTheStrongTag() {
        let text = Messages.rich("rehearseScreen.talkingTo", locale: .en, ["name": "Talise", "role": "a barista"])
        XCTAssertEqual(String(text.characters), "You are talking to Talise, a barista.")
        XCTAssertTrue(text.runs.contains { $0.inlinePresentationIntent == .stronglyEmphasized })
    }
}
