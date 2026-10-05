import XCTest
@testable import Reps

/// Decodes responses captured from the real API (`Fixtures/*.json`, taken from the website's own
/// routes running against the real curriculum) with the app's own decoder. A field the server renames
/// or a shape the app got wrong shows up here as a failing decode, not as a blank screen on a phone.
final class APIModelsTests: XCTestCase {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private func fixture<T: Decodable>(_ name: String, as type: T.Type = T.self) throws -> T {
        let url = try XCTUnwrap(Bundle(for: APIModelsTests.self).url(forResource: name, withExtension: "json"),
                                "missing fixture \(name).json")
        return try decoder.decode(T.self, from: Data(contentsOf: url))
    }

    // MARK: Today

    func testTodayDecodes() throws {
        let today: TodayData = try fixture("today")
        XCTAssertEqual(today.name, "Dani")
        XCTAssertFalse(today.fact.isEmpty)
        XCTAssertEqual(today.totals.repsLogged, 1)
        XCTAssertEqual(today.totals.currentStreak, 1)
        XCTAssertFalse(today.rank.name.isEmpty)
        XCTAssertEqual(today.rank.total, 10)
        XCTAssertNotNil(today.rank.next)
        XCTAssertFalse(today.heatmap.isEmpty)
        XCTAssertTrue(today.heatmap.allSatisfy { DateFormatter.isoDay.date(from: $0.date) != nil }, "days are yyyy-MM-dd")
        XCTAssertFalse(today.xpTable.isEmpty)
        XCTAssertFalse(today.badges.earned.isEmpty, "the first rep earns a badge")
        XCTAssertGreaterThan(today.rehearsals, 0)
    }

    // MARK: Rehearsal box and list

    func testTheLineBoxDecodes() throws {
        let box: RehearsalBox = try fixture("box_line")
        XCTAssertEqual(box.mode, "line")
        XCTAssertFalse(box.paid)
        XCTAssertTrue(box.unlocked)
        XCTAssertNil(box.freeLeft, "a drill has no allowance to report")
        XCTAssertNil(box.openId)
    }

    func testTheSceneBoxDecodes() throws {
        let box: RehearsalBox = try fixture("box_scene")
        XCTAssertEqual(box.mode, "scene")
        XCTAssertTrue(box.paid)
        XCTAssertFalse(box.partnerName.isEmpty)
        XCTAssertNil(box.openId, "captured before the scene was started")
        XCTAssertTrue(box.unlocked, "the first scenes of a track are open from the start")
    }

    func testTheRehearsalsTreeDecodes() throws {
        let tree: RehearsalTree = try fixture("rehearsals")
        XCTAssertFalse(tree.topics.isEmpty)
        let rehearsals = tree.topics.flatMap(\.skills).flatMap(\.lessons).flatMap(\.rehearsals)
        XCTAssertGreaterThanOrEqual(rehearsals.count, 3)
        XCTAssertTrue(rehearsals.contains { $0.mode == "line" && $0.landed != nil })
    }

    // MARK: A rehearsal in each state

    func testAFreshLineDrill() throws {
        let state: RehearsalState = try fixture("rehearsal_line_fresh")
        XCTAssertEqual(state.mode, "line")
        XCTAssertFalse(state.isComplete)
        let line = try XCTUnwrap(state.line)
        XCTAssertFalse(line.requirements.isEmpty)
        XCTAssertTrue(line.attempts.isEmpty)
        XCTAssertNil(state.choice)
        XCTAssertNil(state.chat)
        XCTAssertNil(state.result)
    }

    func testALineDrillAfterAnAttemptCarriesItsVerdicts() throws {
        let state: RehearsalState = try fixture("rehearsal_line_open")
        let attempt = try XCTUnwrap(state.line?.attempts.first)
        XCTAssertEqual(attempt.line, "Hola, ¿qué tal?")
        XCTAssertFalse(attempt.results.isEmpty)
        XCTAssertEqual(attempt.landed, attempt.results.allSatisfy(\.ok))
    }

    func testAFinishedDrillHasADrillResult() throws {
        let state: RehearsalState = try fixture("rehearsal_line_done")
        XCTAssertTrue(state.isComplete)
        guard case .drill(let landed, let attempts, _)? = state.result else {
            return XCTFail("expected a drill result, got \(String(describing: state.result))")
        }
        XCTAssertEqual(attempts, 1)
        XCTAssertTrue(landed)
        XCTAssertNil(state.line, "a finished drill has no live state")
    }

    func testAFreshChoiceDrillHidesTheVerdicts() throws {
        let state: RehearsalState = try fixture("rehearsal_choice_fresh")
        let choice = try XCTUnwrap(state.choice)
        XCTAssertGreaterThan(choice.total, 1)
        XCTAssertTrue(choice.answered.isEmpty)
        let current = try XCTUnwrap(choice.current)
        XCTAssertGreaterThan(current.options.count, 1)
        XCTAssertEqual(Set(current.options.map(\.index)).count, current.options.count, "indexes are the authored positions")
    }

    func testAnAnsweredChoiceRevealsEveryOptionsNote() throws {
        let state: RehearsalState = try fixture("rehearsal_choice_open")
        let choice = try XCTUnwrap(state.choice)
        let answered = try XCTUnwrap(choice.answered.first)
        XCTAssertFalse(answered.options.isEmpty)
        XCTAssertTrue(answered.options.contains { $0.correct })
        XCTAssertTrue(answered.options.contains { $0.text == answered.chosen })
        XCTAssertNotNil(choice.current, "there is a second situation still to read")
    }

    func testAFinishedChoiceDrill() throws {
        let state: RehearsalState = try fixture("rehearsal_choice_done")
        XCTAssertTrue(state.isComplete)
        guard case .drill? = state.result else { return XCTFail("expected a drill result") }
    }

    func testAnOpenSceneHasChatState() throws {
        let state: RehearsalState = try fixture("rehearsal_scene_open")
        XCTAssertTrue(state.paid)
        XCTAssertFalse(state.usingRealModel, "captured against the scripted partner")
        let chat = try XCTUnwrap(state.chat)
        XCTAssertLessThan(chat.turnsLeft, 14, "a line has been used")
        XCTAssertEqual(state.transcript.count, 2)
        XCTAssertEqual(state.transcript.first?.role, "user")
        XCTAssertFalse(state.criteria.isEmpty, "a scene is marked against the rubric")
    }

    func testAScoredSceneHasAReview() throws {
        let state: RehearsalState = try fixture("rehearsal_scene_done")
        guard case .scene(let scale, let scores, let worked, let fix, _)? = state.result else {
            return XCTFail("expected a scene review, got \(String(describing: state.result))")
        }
        XCTAssertEqual(scale.max, 5)
        XCTAssertFalse(scores.isEmpty)
        XCTAssertEqual(worked.count, 2, "exactly two things that worked")
        XCTAssertFalse(fix.isEmpty)
    }

    func testABeatDrillStartsWithItsFirstInstruction() throws {
        let state: RehearsalState = try fixture("rehearsal_beat_fresh")
        XCTAssertEqual(state.mode, "beat")
        XCTAssertNotNil(state.chat?.instruction)
    }

    // MARK: Logging

    func testALoggedRepReportsItsXPAndBadges() throws {
        let logged: LoggedRep = try fixture("logged")
        XCTAssertEqual(logged.xp, 50)
        XCTAssertEqual(logged.badges.count, 1)
    }

    func testTheFieldLogDecodesWithItsSnakeCaseRows() throws {
        let response: FieldLogResponse = try fixture("fieldlog")
        XCTAssertEqual(response.totals.repsLogged, 1)
        let entry = try XCTUnwrap(response.entries.first)
        XCTAssertEqual(entry.went, 3)
        XCTAssertEqual(entry.contextNote, "café")
        XCTAssertEqual(entry.otherSex, "female")
        XCTAssertEqual(entry.otherAgeGroup, "25-34")
        XCTAssertEqual(entry.loggedDate.count, 10)
        XCTAssertNotNil(DateFormatter.isoDay.date(from: entry.loggedDate))
        XCTAssertNotNil(ISO8601DateFormatter.parse(entry.loggedAt), "Supabase timestamps carry fractional seconds")
        XCTAssertNotNil(entry.skills?.topics)
    }
}
