import SwiftUI

struct TopicsView: View {
    @EnvironmentObject private var store: SessionStore
    @StateObject private var library = LibraryStore()

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
        // Shared with every screen pushed from here, so a lesson read in one place unlocks the next
        // everywhere without another round trip.
        .environmentObject(library)
        // Re-runs when the account's language arrives after sign-in, so the list never stays in
        // English for a Spanish reader.
        .task(id: store.locale) { await library.load(session: store) }
    }

    @ViewBuilder private var content: some View {
        switch library.state {
        case .loading:
            ProgressView(store.strings.loading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            VStack(spacing: 14) {
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                Button(store.strings.retry) { Task { await library.load(session: store) } }
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded:
            List(Array(library.topics.enumerated()), id: \.element.id) { index, topic in
                NavigationLink {
                    TopicDetailView(topic: topic)
                } label: {
                    TopicRow(number: index + 1, topic: topic, strings: store.strings)
                }
            }
            .listStyle(.plain)
            .refreshable { await library.load(session: store) }
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

    @EnvironmentObject private var library: LibraryStore

    var body: some View {
        List {
            if !topic.description.isEmpty {
                Text(topic.description).foregroundColor(.secondary)
            }
            ForEach(topic.skills) { skill in
                Section {
                    ForEach(Array(skill.lessons.enumerated()), id: \.element.id) { index, lesson in
                        NavigationLink {
                            LessonView(skill: skill, topicName: topic.name, index: index)
                        } label: {
                            LessonRowView(lesson: lesson, access: library.access(to: skill, at: index),
                                          isRead: library.readIDs.contains(lesson.id))
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

private struct LessonRowView: View {
    let lesson: LessonItem
    let access: LessonAccess
    let isRead: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(String(format: "%02d", lesson.order))
                .font(.system(.footnote, design: .monospaced))
                .foregroundColor(.secondary)
            Text(lesson.title)
                .foregroundColor(access == .open ? .primary : .secondary)
            Spacer()
            if isRead {
                Image(systemName: "checkmark")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.accentColor)
            } else if access == .subscription {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
