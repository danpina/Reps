import SwiftUI

/// Situations to read, and a decision on each. A free text box cannot tell good judgement from having
/// ignored the question, so the options are fixed — and the reason the right one is right is the lesson.
struct ChoiceDrillView: View {
    let choice: RehearsalState.Choice
    let strings: Strings
    /// Answers the current situation with the option's authored index; returns the sentence to show if refused.
    let answer: (Int) async -> String?
    let finish: () async -> String?

    @State private var busy = false
    @State private var finishing = false
    @State private var errorText: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            ForEach(Array(choice.answered.enumerated()), id: \.offset) { index, item in
                answered(index, item)
            }

            if let current = choice.current {
                currentBeat(current)
            } else {
                Card {
                    Text(choice.answered.allSatisfy(\.correct)
                         ? strings.t("choiceDrill.bothReadCorrectly")
                         : strings.t("choiceDrill.readTheNotesAbove"))
                        .font(.subheadline)
                }
            }

            if !choice.answered.isEmpty {
                Divider()
                PrimaryButton(title: finishing ? strings.t("lineDrill.finishingPending") : strings.t("lineDrill.finishThisDrill"),
                              busy: finishing) {
                    Task {
                        finishing = true
                        errorText = await finish()
                        finishing = false
                    }
                }
            }
        }
    }

    // MARK: An answered situation

    private func answered(_ index: Int, _ item: RehearsalState.Choice.Answered) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(text: strings.t("choiceDrill.situationOfTotal", ["n": index + 1, "total": choice.total]))
            Text(item.situation).font(.footnote).foregroundColor(.secondary)

            ForEach(Array(item.options.enumerated()), id: \.offset) { _, option in
                let picked = option.text == item.chosen
                let worth = picked || option.correct

                VStack(alignment: .leading, spacing: 6) {
                    (Text(option.text)
                        + Text(picked ? " — \(strings.t("choiceDrill.whatYouChose"))" : "").foregroundColor(.secondary))
                        .font(.subheadline)
                    if worth { Text(option.note).font(.footnote).foregroundColor(.secondary) }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(background(correct: option.correct, picked: picked))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(border(correct: option.correct, picked: picked), lineWidth: 1))
                .cornerRadius(8)
                .opacity(option.correct || picked ? 1 : 0.6)
            }
        }
    }

    private func background(correct: Bool, picked: Bool) -> Color {
        if correct { return Color.accentColor.opacity(0.14) }
        if picked { return Color.orange.opacity(0.14) }
        return .clear
    }

    private func border(correct: Bool, picked: Bool) -> Color {
        if correct { return .accentColor }
        if picked { return .orange }
        return Color(.separator)
    }

    // MARK: The situation in front of you

    private func currentBeat(_ current: RehearsalState.Choice.Current) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(text: strings.t("choiceDrill.situationOfTotal", ["n": choice.answered.count + 1, "total": choice.total]))
            Text(current.situation).font(.body).fixedSize(horizontal: false, vertical: true)
            Text(current.prompt).font(.subheadline.weight(.medium))

            VStack(spacing: 10) {
                ForEach(current.options, id: \.index) { option in
                    Button {
                        Task {
                            busy = true
                            errorText = await answer(option.index)
                            busy = false
                        }
                    } label: {
                        Text(option.text)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.separator), lineWidth: 1))
                    }
                    .disabled(busy)
                    .opacity(busy ? 0.6 : 1)
                }
            }

            if let errorText { ErrorBanner(text: errorText) }
        }
    }
}
