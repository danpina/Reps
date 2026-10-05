import SwiftUI

/// One rehearsal, in whatever state it is in: a line drill, a read-and-decide, a short sequence or
/// an open scene — or, once it is over, how it went.
///
/// Every verdict, every cap and every score comes from the server, which runs the website's own
/// code; this only draws the state it is given and sends the reader's next move back.
struct RehearsalScreen: View {
    let id: String

    @EnvironmentObject private var store: SessionStore
    @EnvironmentObject private var library: LibraryStore

    @State private var state: RehearsalState?
    @State private var errorText: String?

    private var strings: Strings { store.strings }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let state {
                    header(state)
                    stateContent(for: state)
                } else if let errorText {
                    VStack(spacing: 14) {
                        Text(errorText).multilineTextAlignment(.center).foregroundColor(.secondary)
                        Button(strings.retry) { Task { await load() } }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    ProgressView(strings.loading).frame(maxWidth: .infinity).padding(.top, 80)
                }
            }
            .padding(20)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .task { await load() }
    }

    private var title: String {
        switch state?.mode {
        case "line": return strings.t("rehearseScreen.titles.line")
        case "beat": return strings.t("rehearseScreen.titles.beat")
        case "choice": return strings.t("rehearseScreen.titles.choice")
        default: return strings.t("rehearseScreen.titles.scene")
        }
    }

    func load() async {
        do {
            state = try await store.withToken { try await RepsAPI().get("api/rehearse/\(id)", token: $0) }
            errorText = nil
        } catch is CancellationError {
        } catch let error as URLError where error.code == .cancelled {
        } catch {
            if state == nil { errorText = error.localizedDescription }
        }
    }

    /// Sends the reader's move, then reads the rehearsal again — whether or not it was accepted, since
    /// even a refusal can change things (a scene whose review failed still ends). Returns the
    /// sentence to show if it was refused, in the website's own words.
    private func perform(_ path: String, body: [String: Any]? = nil) async -> String? {
        var failure: String?
        do {
            let _: Acknowledged = try await store.withToken { try await RepsAPI().post(path, body: body, token: $0) }
        } catch {
            failure = error.localizedDescription
        }
        await load()
        return failure
    }

    // MARK: Header

    @ViewBuilder private func header(_ state: RehearsalState) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // A drill is not a conversation, so it does not get a partner card describing how open
            // somebody is going to be. The read-and-decide one is not even a scene.
            if state.showPartner {
                Card {
                    Text(state.setting).font(.footnote).foregroundColor(.secondary)
                    Text(strings.rich("rehearseScreen.talkingTo", ["name": state.partner.name, "role": state.partner.role]))
                        .font(.subheadline)
                    if state.paid {
                        Text(strings.t("rehearseScreen.opennessOfFive", ["openness": state.partner.openness])
                             + (state.partner.openness <= 2 ? strings.t("rehearseScreen.opennessHardWork") : ""))
                            .font(.caption.monospacedDigit())
                            .foregroundColor(.secondary)
                    }
                }
            }

            Card(tint: .accentColor) {
                SectionLabel(text: strings.t("rehearseScreen.whatYouArePractising"), color: .accentColor)
                Text(state.theMove).font(.subheadline)
                if let note = state.rehearsalNote, !note.isEmpty {
                    Divider()
                    Text(note).font(.footnote).foregroundColor(.secondary)
                }
                // The rubric is what the AI review marks against, so it belongs on the scenes it marks.
                // A drill states its own requirements next to the box.
                if state.paid && !state.criteria.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(state.criteria, id: \.key) { criterion in
                            (Text(criterion.label).foregroundColor(.primary) + Text(" — \(criterion.description)"))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            if state.paid && !state.usingRealModel {
                Text(strings.t("rehearseScreen.scriptedPartnerNote")).font(.caption).foregroundColor(.secondary)
            }
        }
    }

    // MARK: Body by state

    @ViewBuilder private func stateContent(for state: RehearsalState) -> some View {
        if state.isComplete {
            CompletedRehearsalView(state: state, strings: strings, locale: store.locale)
        } else if state.unavailable {
            unavailable(state)
        } else if state.mode == "line", let line = state.line {
            LineDrillView(line: line, examples: state.examples, strings: strings,
                          attempt: { text in await perform("api/rehearse/\(id)/attempt", body: ["line": text]) },
                          finish: { await perform("api/rehearse/\(id)/finish") })
        } else if state.mode == "choice", let choice = state.choice {
            ChoiceDrillView(choice: choice, strings: strings,
                            answer: { index in await perform("api/rehearse/\(id)/choice", body: ["option": index]) },
                            finish: { await perform("api/rehearse/\(id)/finish") })
        } else if let chat = state.chat {
            SceneChatView(state: state, chat: chat, strings: strings,
                          say: { text in await perform("api/rehearse/\(id)/say", body: ["message": text]) },
                          end: { await perform("api/rehearse/\(id)/end") })
        }
    }

    private func unavailable(_ state: RehearsalState) -> some View {
        Card {
            Text(strings.t("rehearseScreen.drillNotReady")).font(.headline)
            Text(strings.t("rehearseScreen.drillNotReadyBody")).font(.subheadline).foregroundColor(.secondary)
            LogRealRepButton(state: state, strings: strings)
        }
    }
}

/// "Log a real rep" — the reason rehearsal exists. Opens the log with the skill, lesson and mission
/// filled in, as the website's link does.
struct LogRealRepButton: View {
    let state: RehearsalState
    let strings: Strings

    @EnvironmentObject private var store: SessionStore
    @EnvironmentObject private var library: LibraryStore
    @State private var showLog = false

    var body: some View {
        PrimaryButton(title: strings.t("rehearseScreen.logARealRep")) { showLog = true }
            .sheet(isPresented: $showLog) {
                LogRepView(preset: LogPreset(skillID: skillID, lessonID: state.lessonId, missionText: state.mission)) {}
                    .environmentObject(store)
                    .environmentObject(library)
            }
    }

    private var skillID: String? {
        library.topics.flatMap(\.skills).first { $0.slug == state.skillSlug }?.id
    }
}
