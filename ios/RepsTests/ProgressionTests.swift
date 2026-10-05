import XCTest
@testable import Reps

/// Mirrors `tests/progression.test.ts`. The rule that matters most is the one that never takes
/// anything away: anybody who read out of order keeps everything they had.
final class ProgressionTests: XCTestCase {
    private let lessons = (1...5).map { LessonItem(id: "l\($0)", order: $0, title: "Lesson \($0)", isPreview: true) }

    func testTheFirstIsAlwaysOpen() {
        XCTAssertTrue(Progression.isUnlocked(lessons, index: 0, readIDs: []))
    }

    func testTheSecondIsNotUntilTheFirstIsRead() {
        XCTAssertFalse(Progression.isUnlocked(lessons, index: 1, readIDs: []))
        XCTAssertTrue(Progression.isUnlocked(lessons, index: 1, readIDs: ["l1"]))
    }

    func testReadingOneOpensExactlyOneMore() {
        let read: Set<String> = ["l1", "l2"]
        XCTAssertTrue(Progression.isUnlocked(lessons, index: 2, readIDs: read))
        XCTAssertFalse(Progression.isUnlocked(lessons, index: 3, readIDs: read))
    }

    func testALessonAlreadyReadStaysOpenEvenWithAGapBehindIt() {
        // l4 was read out of order, before the gate existed.
        XCTAssertTrue(Progression.isUnlocked(lessons, index: 3, readIDs: ["l4"]))
    }

    func testNextOpenIndexIsTheFirstUnreadOpenLesson() {
        XCTAssertEqual(Progression.nextOpenIndex(lessons, readIDs: []), 0)
        XCTAssertEqual(Progression.nextOpenIndex(lessons, readIDs: ["l1", "l2"]), 2)
    }

    func testNextOpenIndexFallsBackToTheFirstWhenEverythingIsRead() {
        XCTAssertEqual(Progression.nextOpenIndex(lessons, readIDs: Set(lessons.map(\.id))), 0)
    }
}
