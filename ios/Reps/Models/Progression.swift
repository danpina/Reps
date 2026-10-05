import Foundation

/// Working through in order. A port of `src/lib/curriculum/progression.ts` — read its header for
/// why a track unlocks forwards: lesson two assumes lesson one. Nothing here is earned by paying or
/// waiting, only by reading the thing before it.
///
/// Two rules keep it from ever taking something away: a lesson already read stays open whatever is
/// behind it, and "done" means read, not practised.
enum Progression {
    /// Whether the lesson at this position may be opened.
    /// - Parameters:
    ///   - lessons: In track order.
    ///   - index: Position in that order, zero-based.
    ///   - readIDs: Lessons the reader has read.
    static func isUnlocked(_ lessons: [LessonItem], index: Int, readIDs: Set<String>) -> Bool {
        if index <= 0 { return true }
        guard lessons.indices.contains(index) else { return true }
        if readIDs.contains(lessons[index].id) { return true }
        return readIDs.contains(lessons[index - 1].id)
    }

    /// The position of the first lesson that is open but not yet read, or the first lesson if every
    /// one is read. Where someone should go instead when they land somewhere locked.
    static func nextOpenIndex(_ lessons: [LessonItem], readIDs: Set<String>) -> Int {
        for (i, lesson) in lessons.enumerated()
        where !readIDs.contains(lesson.id) && isUnlocked(lessons, index: i, readIDs: readIDs) {
            return i
        }
        return 0
    }
}
