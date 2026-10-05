import XCTest
@testable import Reps

/// Mirrors `tests/variants.test.ts`. The failure here is silent and expensive: a matcher that is
/// slightly too eager shows a man a passage written for women, and nobody reports that — they
/// conclude the app does not know what it is talking about.
final class VariantsTests: XCTestCase {
    private let nobody = Audience()
    private let manIntoWomen = Audience(sex: "male", ageGroup: "25-34", datingInterest: "women")
    private let womanIntoMen = Audience(sex: "female", ageGroup: "35-44", datingInterest: "men")

    private func variant(_ when: VariantConditions, note: String = "…") -> LessonVariant {
        LessonVariant(when: when, noteMd: note, examplesJson: nil)
    }

    private var forMen: LessonVariant { variant(VariantConditions(sex: "male", datingInterest: "women"), note: "men") }
    private var forWomen: LessonVariant { variant(VariantConditions(sex: "female", datingInterest: "men"), note: "women") }

    // A condition the reader has not answered is a miss, never a guess.
    func testAReaderWhoAnsweredNothingMatchesNothing() {
        XCTAssertNil(Variants.pick([forMen, forWomen], for: nobody))
    }

    func testEachReaderGetsTheirOwnVariant() {
        XCTAssertEqual(Variants.pick([forMen, forWomen], for: manIntoWomen)?.noteMd, "men")
        XCTAssertEqual(Variants.pick([forMen, forWomen], for: womanIntoMen)?.noteMd, "women")
    }

    func testAnUnansweredSexIsAMissEvenWhenTheInterestMatches() {
        let onlyInterest = Audience(sex: nil, ageGroup: nil, datingInterest: "women")
        XCTAssertNil(Variants.pick([forMen], for: onlyInterest))
    }

    // "Both" is genuinely part of the audience for either, more weakly than someone who named one.
    func testBothMatchesEitherInterestButScoresLower() {
        let both = Audience(sex: nil, ageGroup: nil, datingInterest: "both")
        let datesWomen = VariantConditions(datingInterest: "women")
        XCTAssertEqual(Variants.score(datesWomen, for: both), 1)
        XCTAssertEqual(Variants.score(datesWomen, for: Audience(datingInterest: "women")), 2)
        XCTAssertNil(Variants.score(datesWomen, for: Audience(datingInterest: "men")))
    }

    func testAnAgeRangeNeedsAnAnsweredBand() {
        let range = VariantConditions(ageGroups: ["18-24", "25-34"])
        XCTAssertNil(Variants.score(range, for: nobody))
        XCTAssertEqual(Variants.score(range, for: Audience(ageGroup: "25-34")), 1)
        XCTAssertNil(Variants.score(range, for: Audience(ageGroup: "55-64")))
    }

    // A variant written for one exact band outscores a range that happens to contain it.
    func testAnExactBandBeatsARangeThatContainsIt() {
        let exact = variant(VariantConditions(ageGroup: "25-34"), note: "exact")
        let range = variant(VariantConditions(ageGroups: ["18-24", "25-34"]), note: "range")
        XCTAssertEqual(Variants.pick([range, exact], for: Audience(ageGroup: "25-34"))?.noteMd, "exact")
    }

    func testTheFirstOfTwoEquallySpecificVariantsWins() {
        let first = variant(VariantConditions(sex: "male"), note: "first")
        let second = variant(VariantConditions(sex: "male"), note: "second")
        XCTAssertEqual(Variants.pick([first, second], for: Audience(sex: "male"))?.noteMd, "first")
    }

    // A variant with no conditions scores zero and so is never chosen.
    func testAVariantWithNoConditionsIsNeverShown() {
        XCTAssertNil(Variants.pick([variant(VariantConditions())], for: manIntoWomen))
    }

    // The database keys are snake_case; if the decoder did not map them, `dating_interest` would
    // silently become "no condition" and the variant would be shown to everyone.
    func testVariantsDecodeFromTheDatabaseShape() throws {
        let json = """
        [{"when": {"sex": "male", "dating_interest": "women", "age_groups": ["25-34"]},
          "label": "If you are a man", "note_md": "A passage.",
          "examples_json": [{"situation": "s", "line": "l", "why": "w"}]}]
        """
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode([LessonVariant].self, from: Data(json.utf8))

        XCTAssertEqual(decoded.first?.when?.sex, "male")
        XCTAssertEqual(decoded.first?.when?.datingInterest, "women")
        XCTAssertEqual(decoded.first?.when?.ageGroups, ["25-34"])
        XCTAssertEqual(decoded.first?.noteMd, "A passage.")
        XCTAssertEqual(decoded.first?.examplesJson?.count, 1)
    }
}
