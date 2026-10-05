import SwiftUI

/// Every rehearsal the reader has done, in the order the curriculum runs. Practice scenes and what they
/// were scored on: useful, and worth less than one real conversation.
struct RehearsalsListView: View {
    let goTo: (MainTabView.Tab) -> Void

    @EnvironmentObject private var store: SessionStore

    @State private var tree: RehearsalTree?
    @State private var errorText: String?

    private var strings: Strings { store.strings }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(strings.t("rehearse.subheading")).font(.subheadline).foregroundColor(.secondary)

                    if let tree {
                        if tree.topics.isEmpty { empty } else { list(tree) }
                    } else if let errorText {
                        VStack(spacing: 14) {
                            Text(errorText).foregroundColor(.secondary).multilineTextAlignment(.center)
                            Button(strings.retry) { Task { await load() } }
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ProgressView(strings.loading).frame(maxWidth: .infinity).padding(.top, 40)
                    }
                }
                .padding(20)
            }
            .navigationTitle(strings.t("rehearse.heading"))
            .refreshable { await load() }
        }
        .onAppear { Task { await load() } }
    }

    private func load() async {
        do {
            tree = try await store.withToken { try await RepsAPI().get("api/rehearsals", token: $0) }
            errorText = nil
        } catch is CancellationError {
        } catch let error as URLError where error.code == .cancelled {
        } catch {
            if tree == nil { errorText = error.localizedDescription }
        }
    }

    private var empty: some View {
        Card {
            Text(strings.t("rehearse.nothingRehearsedYet")).font(.headline)
            Text(strings.t("rehearse.nothingRehearsedYetBody")).font(.subheadline).foregroundColor(.secondary)
            PrimaryButton(title: strings.t("rehearse.browseSkills")) { goTo(.learn) }.padding(.top, 4)
        }
    }

    private func list(_ tree: RehearsalTree) -> some View {
        let total = tree.topics.reduce(0) { $0 + $1.total }
        return VStack(alignment: .leading, spacing: 32) {
            Text(strings.t("rehearse.countInOrder", ["count": strings.t("rehearsalList.rehearsalsCount", ["count": total])]))
                .font(.caption.monospacedDigit())
                .foregroundColor(.secondary)

            ForEach(tree.topics) { topic in
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .firstTextBaseline) {
                        SectionLabel(text: topic.name)
                        Spacer()
                        Text("\(topic.total)").font(.caption.monospacedDigit()).foregroundColor(.secondary)
                    }
                    Divider()

                    ForEach(topic.skills) { skill in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(skill.name).font(.subheadline.weight(.medium))
                                Spacer()
                                Text(strings.t("rehearsalList.rehearsalsCount", ["count": skill.total]))
                                    .font(.caption.monospacedDigit()).foregroundColor(.secondary)
                            }
                            ForEach(skill.lessons) { lesson in
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("\(String(format: "%02d", lesson.sortOrder))  \(lesson.title)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .padding(.bottom, 4)
                                    ForEach(lesson.rehearsals) { rehearsal in
                                        NavigationLink {
                                            RehearsalScreen(id: rehearsal.id)
                                        } label: {
                                            RehearsalRowView(rehearsal: rehearsal, strings: strings, locale: store.locale)
                                        }
                                        .buttonStyle(.plain)
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
