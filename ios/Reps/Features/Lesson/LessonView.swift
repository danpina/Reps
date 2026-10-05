import SwiftUI

/// A lesson: the theory, worked examples, comprehension questions and today's mission.
///
/// Mirrors the website's lesson page. The rehearsal drills and logging a rep are not here yet; they
/// come next, and nothing is shown for them until they work.
struct LessonView: View {
    let skill: SkillItem
    let topicName: String
    /// Zero-based position within the skill's lessons.
    let index: Int

    @EnvironmentObject private var store: SessionStore
    @EnvironmentObject private var library: LibraryStore

    private enum Phase {
        case loading
        case ready(LessonDetail)
        case blocked(LessonAccess)
        case failed(String)
    }

    @State private var phase: Phase = .loading

    private var strings: Strings { store.strings }
    private var entry: LessonItem { skill.lessons[index] }

    var body: some View {
        Group {
            switch phase {
            case .loading:
                ProgressView(strings.loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .ready(let lesson):
                LessonContent(skill: skill, index: index, lesson: lesson, strings: strings, topicName: topicName)
            case .blocked(let access):
                BlockedLessonView(skill: skill, topicName: topicName, index: index, access: access, strings: strings)
            case .failed(let message):
                VStack(spacing: 14) {
                    Text(message).multilineTextAlignment(.center).foregroundColor(.secondary)
                    Button(strings.retry) { Task { await load(force: true) } }
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(skill.name)
        .navigationBarTitleDisplayMode(.inline)
        .task { await load(force: false) }
    }

    /// `.task` runs again when the reader comes back from a lesson pushed on top of this one, and a
    /// reload there would re-shuffle the answers under them. Hence the guard.
    @MainActor private func load(force: Bool) async {
        if !force, case .ready = phase { return }

        // Checked here as well as in the list, because a link is not a permission and the lesson can
        // be reached by other routes. The database is what actually refuses; this explains it.
        let access = library.access(to: skill, at: index)
        guard access == .open else {
            phase = .blocked(access)
            return
        }

        phase = .loading
        do {
            let token = try await store.validAccessToken()
            let lesson = try await LessonAPI().lesson(
                skillID: skill.id, order: entry.order, locale: store.locale,
                audience: store.audience, accessToken: token)
            phase = .ready(lesson)
            recordRead(lesson.id, token: token)
        } catch is CancellationError {
            // The reader left before it loaded.
        } catch let error as URLError where error.code == .cancelled {
            // Same, as URLSession reports it.
        } catch LessonError.unavailable {
            phase = .failed(strings.lessonUnavailable)
        } catch {
            phase = .failed(error.localizedDescription)
        }
    }

    /// Opening a lesson is what counts as reading it. Done after the content is on screen, and
    /// without blocking it: the XP rules run on the server, and a slow or failed call must never get
    /// between someone and the page. The next lesson unlocks locally only once the server agrees.
    @MainActor private func recordRead(_ lessonID: String, token: String) {
        let library = self.library
        Task {
            do {
                try await RepsAPI().markLessonRead(lessonID, accessToken: token)
                await MainActor.run { library.markRead(lessonID) }
            } catch {
                // Nothing to show: it is recorded the next time the lesson is opened.
            }
        }
    }
}

// MARK: - The lesson itself

private struct LessonContent: View {
    let skill: SkillItem
    let index: Int
    let lesson: LessonDetail
    let strings: Strings
    let topicName: String

    @Environment(\.dismiss) private var dismiss
    @State private var showLog = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                header
                theory
                if !lesson.examples.isEmpty { examples }
                ForEach(Array(lesson.checks.enumerated()), id: \.offset) { i, check in
                    CheckView(
                        check: check,
                        label: lesson.checks.count > 1 ? strings.checkOf(i + 1, lesson.checks.count) : strings.oneCheck,
                        strings: strings)
                }
                // The test: a drill or a scene, whichever the lesson was written for.
                RehearsalBoxView(lessonID: lesson.id)
                if !lesson.mission.isEmpty { mission }
                navigation
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .sheet(isPresented: $showLog) {
            LogRepView(preset: LogPreset(skillID: skill.id, lessonID: lesson.id, missionText: lesson.mission)) {}
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(strings.lessonOf(lesson.order, skill.lessons.count))
                .font(.caption)
                .foregroundColor(.secondary)
            Text(lesson.title)
                .font(.system(.title2, design: .serif).weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var theory: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(Markdown.paragraphs(lesson.theory).enumerated()), id: \.offset) { _, paragraph in
                Text(Markdown.attributed(paragraph))
                    .font(.body)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var examples: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(strings.inPractice.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(1.5)
                .foregroundColor(.secondary)

            ForEach(Array(lesson.examples.enumerated()), id: \.offset) { _, example in
                HStack(alignment: .top, spacing: 12) {
                    Rectangle().fill(Color(.separator)).frame(width: 2)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(example.situation).font(.footnote).foregroundColor(.secondary)
                        Text("“\(example.line)”").font(.body)
                        Text(example.why).font(.footnote).foregroundColor(.secondary)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var mission: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(strings.todaysMission.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(1.5)
                .foregroundColor(.accentColor)
            Text(lesson.mission).font(.body).fixedSize(horizontal: false, vertical: true)
            Text(strings.goAndDoIt).font(.footnote).foregroundColor(.secondary)
            HStack(spacing: 12) {
                PrimaryButton(title: strings.t("lessonPage.logThisRep")) { showLog = true }
                Text("+50 XP").font(.caption.monospacedDigit()).foregroundColor(.secondary).fixedSize()
            }
            .padding(.top, 4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.accentColor.opacity(0.10))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.accentColor, lineWidth: 1))
        .cornerRadius(12)
    }

    private var navigation: some View {
        HStack {
            if index > 0 {
                NavigationLink {
                    LessonView(skill: skill, topicName: topicName, index: index - 1)
                } label: {
                    Text("← \(strings.previous)")
                }
                .foregroundColor(.secondary)
            }
            Spacer()
            if index + 1 < skill.lessons.count {
                NavigationLink {
                    LessonView(skill: skill, topicName: topicName, index: index + 1)
                } label: {
                    Text("\(strings.nextLesson) →").fontWeight(.semibold)
                }
            } else {
                Button { dismiss() } label: {
                    Text(strings.backToTrack).fontWeight(.semibold)
                }
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - When a lesson cannot be opened

/// What a lesson looks like when the reader may not open it yet. It says where they are and what to
/// do, and then it stops. No blurred paragraph and no teaser of the theory: a paywall that shows the
/// goods through frosted glass costs more goodwill than the pressure buys.
private struct BlockedLessonView: View {
    let skill: SkillItem
    let topicName: String
    let index: Int
    let access: LessonAccess
    let strings: Strings

    @EnvironmentObject private var library: LibraryStore

    /// The first lesson of every topic's first skill is open, two in all. Stated on the website in
    /// `FREE_PREVIEW_LESSONS`, and enforced by the database either way.
    private let freePreviewLessons = 2

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(strings.lessonOf(skill.lessons[index].order, skill.lessons.count))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(skill.lessons[index].title)
                        .font(.system(.title2, design: .serif).weight(.semibold))
                }

                VStack(alignment: .leading, spacing: 10) {
                    switch access {
                    case .outOfOrder:
                        outOfOrder
                    case .subscription, .open:
                        subscription
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding(20)
        }
    }

    @ViewBuilder private var outOfOrder: some View {
        let nextIndex = Progression.nextOpenIndex(skill.lessons, readIDs: library.readIDs)
        let next = skill.lessons[nextIndex]

        Text(strings.thereIsOneBefore).font(.headline)
        Text(strings.trackBuilds(skill.lessons[index].order, upTo: next.order))
            .font(.subheadline)
            .foregroundColor(.secondary)
        NavigationLink {
            LessonView(skill: skill, topicName: topicName, index: nextIndex)
        } label: {
            Text(strings.goToLesson(next.order, next.title)).fontWeight(.semibold)
        }
        .padding(.top, 4)
    }

    @ViewBuilder private var subscription: some View {
        Text(strings.partOfSubscription).font(.headline)
        Text(strings.freePreview(count: freePreviewLessons, topic: topicName))
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}
