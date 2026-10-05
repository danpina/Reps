import SwiftUI

/// An open conversation with the rehearsal partner (a scene), or a short fixed sequence (a beat drill
/// — the same screen, but each turn says what it is for). Ending it scores it.
struct SceneChatView: View {
    let state: RehearsalState
    let chat: RehearsalState.Chat
    let strings: Strings
    let say: (String) async -> String?
    let end: () async -> String?

    @State private var draft = ""
    @State private var sending = false
    @State private var ending = false
    @State private var errorText: String?

    private var full: Bool { chat.turnsLeft == 0 }
    private var hasSpoken: Bool { state.transcript.contains { $0.role == "user" } }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            transcript

            if let instruction = chat.instruction, !full {
                Card(tint: .accentColor) { Text(instruction).font(.subheadline) }
            }

            input

            Divider()
            endSection
        }
    }

    // MARK: The conversation so far

    private var transcript: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(state.transcript.enumerated()), id: \.offset) { _, turn in
                let mine = turn.role == "user"
                HStack {
                    if mine { Spacer(minLength: 40) }
                    VStack(alignment: .leading, spacing: 4) {
                        Text((mine ? strings.t("chat.you") : state.partner.name).uppercased())
                            .font(.caption2.weight(.semibold))
                            .tracking(1.2)
                            .foregroundColor(.secondary)
                        Text(turn.content).font(.body).fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(mine ? Color.accentColor.opacity(0.14) : Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    if !mine { Spacer(minLength: 40) }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(strings.t("chat.conversationSoFar"))
    }

    // MARK: Saying the next thing

    private var input: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $draft)
                    .frame(minHeight: 70)
                    .padding(6)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .disabled(full)
                    .opacity(full ? 0.6 : 1)
                    .onChange(of: draft) { if $0.count > chat.maxChars { draft = String($0.prefix(chat.maxChars)) } }
                if draft.isEmpty {
                    Text(full ? strings.t("chat.sceneIsDone") : strings.t("chat.whatDoYouSay"))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.horizontal, 12).padding(.vertical, 14)
                        .allowsHitTesting(false)
                }
            }

            // Both counters appear only once they are close. Showing either from the first keystroke
            // would make this feel like a test with a word limit, which is the opposite of the thing
            // being practised.
            if full {
                Text(strings.t("chat.thatIsAsFarAsThisSceneGoes")).font(.footnote).foregroundColor(.secondary)
            } else {
                HStack {
                    Text(chat.turnsLeft <= 4 ? strings.t("chat.linesLeft", ["count": chat.turnsLeft]) : "")
                    Spacer()
                    if chat.maxChars - draft.count <= 40 {
                        Text(strings.t("chat.charactersLeft", ["count": chat.maxChars - draft.count]))
                    }
                }
                .font(.caption.monospacedDigit())
                .foregroundColor(.secondary)
            }

            if let errorText { ErrorBanner(text: errorText) }

            if !full {
                PrimaryButton(title: sending ? strings.t("chat.sayingItPending") : strings.t("chat.sayIt"), busy: sending,
                              disabled: draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || ending) {
                    Task {
                        sending = true
                        errorText = await say(draft)
                        // A line that landed leaves the box; a refused one stays, so what they wrote survives.
                        if errorText == nil { draft = "" }
                        sending = false
                    }
                }
            }
        }
    }

    // MARK: Ending it

    private var endSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(strings.t("endScene.endWhenNaturalClose")).font(.footnote).foregroundColor(.secondary)
            SecondaryButton(title: ending ? strings.t("endScene.reviewingPending") : strings.t("endScene.endTheSceneAndReviewIt"),
                            busy: ending, disabled: !hasSpoken || sending) {
                Task {
                    ending = true
                    errorText = await end()
                    ending = false
                }
            }
        }
    }
}
