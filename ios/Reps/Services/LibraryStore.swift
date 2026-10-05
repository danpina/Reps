import Foundation

/// The curriculum as this reader sees it, plus the two facts that decide what they may open:
/// whether they have a subscription, and which lessons they have already read.
///
/// Loaded once when the topics screen appears and shared with every screen below it. When a lesson
/// is read the set is updated here at once, so the next lesson unlocks without another round trip.
@MainActor
final class LibraryStore: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var topics: [TopicItem] = []
    @Published private(set) var isPro = false
    @Published private(set) var readIDs: Set<String> = []

    func load(session: SessionStore) async {
        if state != .loaded { state = .loading }
        do {
            let token = try await session.validAccessToken()
            let api = CurriculumAPI()
            async let loadedTopics = api.topics(locale: session.locale, accessToken: token)
            async let loadedPro = api.isPro(accessToken: token)
            async let loadedRead = api.readLessonIDs(accessToken: token)
            (topics, isPro, readIDs) = try await (loadedTopics, loadedPro, loadedRead)
            state = .loaded
        } catch is CancellationError {
            // The view went away mid-request; nothing to show.
        } catch let error as URLError where error.code == .cancelled {
            // `.task(id:)` cancels the request in flight when the language changes, and URLSession
            // reports that as a URLError rather than a CancellationError. The next load replaces it.
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func markRead(_ lessonID: String) {
        readIDs.insert(lessonID)
    }

    /// Whether this reader may open the lesson at `index` of `skill`, and if not, why.
    func access(to skill: SkillItem, at index: Int) -> LessonAccess {
        guard skill.lessons.indices.contains(index) else { return .open }
        if !Progression.isUnlocked(skill.lessons, index: index, readIDs: readIDs) { return .outOfOrder }
        if !isPro && !skill.lessons[index].isPreview { return .subscription }
        return .open
    }
}

enum LessonAccess: Equatable {
    case open
    /// An earlier lesson in the track has not been read yet.
    case outOfOrder
    /// Past the free sample, and the account has no subscription.
    case subscription
}
