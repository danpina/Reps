import SwiftUI

/// One comprehension question. Pick an answer and it reveals which was right, with a note on each
/// option you picked or that was correct, and then the explanation. Answering is final, as it is on
/// the website: the point is to find out whether you read it, not to retry until the right one sticks.
struct CheckView: View {
    let check: ComprehensionCheck
    let label: String
    let strings: Strings

    @State private var picked: Int?

    private var answered: Bool { picked != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(label.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(1.5)
                .foregroundColor(.secondary)

            Text(check.prompt)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 8) {
                ForEach(Array(check.options.enumerated()), id: \.offset) { i, option in
                    optionButton(i, option)
                }
            }

            if answered {
                Divider()
                Text(check.explain)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func optionButton(_ i: Int, _ option: CheckOption) -> some View {
        let isPicked = picked == i
        let reveal = answered && (isPicked || option.correct)

        return Button {
            if picked == nil { picked = i }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    if answered {
                        Text(option.correct ? "✓" : (isPicked ? "×" : " "))
                            .font(.footnote.monospaced())
                            .foregroundColor(.secondary)
                            .frame(width: 12)
                    }
                    Text(option.text)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)
                    Spacer(minLength: 0)
                }
                if reveal {
                    Text(option.note)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, answered ? 22 : 0)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background(reveal: reveal, correct: option.correct))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(border(reveal: reveal, correct: option.correct), lineWidth: 1))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
        .disabled(answered)
        // The tick and cross are the only visual signal, so the same information is spoken.
        .accessibilityLabel(accessibilityLabel(option, isPicked: isPicked))
    }

    private func background(reveal: Bool, correct: Bool) -> Color {
        guard reveal else { return Color(.systemBackground) }
        return correct ? Color.accentColor.opacity(0.14) : Color.red.opacity(0.12)
    }

    private func border(reveal: Bool, correct: Bool) -> Color {
        guard reveal else { return Color(.separator) }
        return correct ? Color.accentColor : Color.red.opacity(0.7)
    }

    private func accessibilityLabel(_ option: CheckOption, isPicked: Bool) -> String {
        guard answered else { return option.text }
        let verdict = option.correct
            ? (isPicked ? strings.correctYourAnswer : strings.correctAnswer)
            : (isPicked ? strings.yourAnswerWrong : "")
        return [option.text, verdict, option.note].filter { !$0.isEmpty }.joined(separator: ". ")
    }
}
