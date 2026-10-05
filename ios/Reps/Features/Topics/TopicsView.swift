import SwiftUI

@MainActor
final class TopicsViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded([TopicItem])
        case failed(String)
    }

    @Published private(set) var state: State = .loading

    func load(store: SessionStore) async {
        if case .loaded = state {} else { state = .loading }
        do {
            let token = try await store.validAccessToken()
            let topics = try await CurriculumAPI().topics(locale: store.locale, accessToken: token)
            state = .loaded(topics)
        } catch is CancellationError {
            // The view went away mid-request; nothing to show.
        } catch let error as URLError where error.code == .cancelled {
            // `.task(id:)` cancels the request in flight when the language changes, and URLSession
            // reports that as a URLError rather than a CancellationError. The next load replaces it.
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

struct TopicsView: View {
    @EnvironmentObject private var store: SessionStore
    @StateObject private var model = TopicsViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(store.strings.topics)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(store.strings.signOut) { store.signOut() }
                    }
                }
        }
        // Re-runs when the account's language arrives after sign-in, so the list never stays in
        // English for a Spanish reader.
        .task(id: store.locale) { await model.load(store: store) }
    }

    @ViewBuilder private var content: some View {
        switch model.state {
        case .loading:
            ProgressView(store.strings.loading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            VStack(spacing: 14) {
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                Button(store.strings.retry) { Task { await model.load(store: store) } }
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let topics):
            List(Array(topics.enumerated()), id: \.element.id) { index, topic in
                NavigationLink {
                    TopicDetailView(topic: topic)
                } label: {
                    TopicRow(number: index + 1, topic: topic, strings: store.strings)
                }
            }
            .listStyle(.plain)
            .refreshable { await model.load(store: store) }
        }
    }
}

private struct TopicRow: View {
    let number: Int
    let topic: TopicItem
    let strings: Strings

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(String(format: "%02d", number))
                .font(.system(.footnote, design: .monospaced))
                .foregroundColor(.secondary)
                .padding(.top, 3)
            VStack(alignment: .leading, spacing: 5) {
                Text(topic.name).font(.headline)
                if !topic.description.isEmpty {
                    Text(topic.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                Text(strings.counts(skills: topic.skills.count, lessons: topic.lessonCount))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

struct TopicDetailView: View {
    let topic: TopicItem

    var body: some View {
        List {
            if !topic.description.isEmpty {
                Text(topic.description).foregroundColor(.secondary)
            }
            ForEach(topic.skills) { skill in
                Section {
                    ForEach(skill.lessons) { lesson in
                        HStack(spacing: 12) {
                            Text(String(format: "%02d", lesson.order))
                                .font(.system(.footnote, design: .monospaced))
                                .foregroundColor(.secondary)
                            Text(lesson.title)
                            Spacer()
                            if !lesson.isPreview {
                                Image(systemName: "lock.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(skill.name).font(.headline).textCase(nil)
                        if !skill.description.isEmpty {
                            Text(skill.description).font(.footnote).textCase(nil)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(topic.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
