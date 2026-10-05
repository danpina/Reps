import SwiftUI

/// One line, as many times as you like. The requirements are on screen before anything is typed,
/// which is the whole point of the mode: somebody who does not know how to begin is not helped by a
/// blank box, but by being told the shape and then left to find the words.
struct LineDrillView: View {
    let line: RehearsalState.Line
    let examples: [WorkedExample]
    let strings: Strings
    /// Sends one attempt; returns the sentence to show if it was refused.
    let attempt: (String) async -> String?
    let finish: () async -> String?

    @State private var draft = ""
    @State private var busy = false
    @State private var finishing = false
    @State private var errorText: String?
    @State private var modelOpen = false
    @State private var examplesOpen = false

    private var last: RehearsalState.Line.Attempt? { line.attempts.last }
    private var landed: Bool { last?.landed ?? false }
    private var spent: Bool { line.attempts.count >= line.maxAttempts }
    private var long: Bool { line.maxChars > 160 }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let says = line.says, !says.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    SectionLabel(text: strings.t("lineDrill.theySay"))
                    QuoteBlock(text: says).font(.title3)
                }
            }

            requirements
            attempts
            if !(landed || spent) { input }

            if landed {
                Card(tint: .accentColor) { Text(strings.t("lineDrill.thatIsTheShape")).font(.subheadline) }
            }
            if spent && !landed {
                Card { Text(strings.t("lineDrill.enoughGoesForNow")).font(.subheadline).foregroundColor(.secondary) }
            }

            // Available from the first moment rather than as a reward. Somebody genuinely stuck is not
            // learning anything from a fourth failed attempt.
            if let model = line.model {
                Card {
                    DisclosureGroup(isExpanded: $modelOpen) {
                        VStack(alignment: .leading, spacing: 8) {
                            QuoteBlock(text: model.line, emphasised: true).font(.title3)
                            Text(model.why).font(.footnote).foregroundColor(.secondary)
                        }
                        .padding(.top, 8)
                    } label: {
                        Text(strings.t("lineDrill.oneThatWorksHere")).font(.subheadline).foregroundColor(.secondary)
                    }
                }
            }

            if !examples.isEmpty { examplesCard }

            if !line.attempts.isEmpty {
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
        .onChange(of: landed || spent) { if $0 { modelOpen = true; examplesOpen = true } }
    }

    // MARK: Pieces

    @ViewBuilder private var requirements: some View {
        if line.requirements.isEmpty {
            Text(strings.t("lineDrill.nothingToTickOff")).font(.footnote).foregroundColor(.secondary)
        } else {
            Card {
                SectionLabel(text: strings.t("lineDrill.thisOneMust"))
                ForEach(Array(line.requirements.enumerated()), id: \.offset) { _, requirement in
                    Text(requirement).font(.footnote)
                }
            }
        }
    }

    @ViewBuilder private var attempts: some View {
        if !line.attempts.isEmpty {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(Array(line.attempts.enumerated()), id: \.offset) { index, attempt in
                    let isLast = index == line.attempts.count - 1
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            SectionLabel(text: isLast ? strings.t("lineDrill.youSaid") : strings.t("lineDrill.tryN", ["n": index + 1]))
                            if attempt.landed {
                                Text(strings.t("lineDrill.landed"))
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 1))
                            }
                        }
                        Text(attempt.line).font(.title3)

                        // Only the latest attempt is marked up. Keeping every past verdict on screen turns
                        // a drill into a report card.
                        if isLast && !attempt.results.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(Array(attempt.results.enumerated()), id: \.offset) { _, result in
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text(result.ok ? "✓" : "✗").foregroundColor(result.ok ? .accentColor : .orange)
                                        verdictText(result)
                                    }
                                    .font(.footnote)
                                    .accessibilityElement(children: .combine)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func verdictText(_ result: RehearsalState.Line.Attempt.Verdict) -> some View {
        var text = result.requirement
        if let why = result.why, !why.isEmpty { text += " — \(why)" }
        return Text(text).foregroundColor(result.ok ? .secondary : .primary)
    }

    private var input: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $draft)
                    .frame(minHeight: long ? 170 : 70)
                    .padding(6)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .onChange(of: draft) { if $0.count > line.maxChars { draft = String($0.prefix(line.maxChars)) } }
                if draft.isEmpty {
                    Text(long ? strings.t("lineDrill.whatDoYouSayLong") : strings.t("lineDrill.whatDoYouSay"))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.horizontal, 12).padding(.vertical, 14)
                        .allowsHitTesting(false)
                }
            }
            CharacterCounter(used: draft.count, max: line.maxChars, strings: strings,
                             threshold: max(40, Int((Double(line.maxChars) * 0.1).rounded())))

            if let errorText { ErrorBanner(text: errorText) }

            PrimaryButton(title: busy ? strings.t("lineDrill.checkingPending")
                                  : (line.attempts.isEmpty ? strings.t("lineDrill.sayIt") : strings.t("lineDrill.tryThatAgain")),
                          busy: busy, disabled: draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                Task {
                    busy = true
                    errorText = await attempt(draft)
                    // A line that was accepted is now an attempt on the list; one that was refused stays in the
                    // box so what they wrote survives for another go.
                    if errorText == nil { draft = "" }
                    busy = false
                }
            }
        }
    }

    private var examplesCard: some View {
        Card {
            DisclosureGroup(isExpanded: $examplesOpen) {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(Array(examples.enumerated()), id: \.offset) { _, example in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(example.situation).font(.caption).foregroundColor(.secondary)
                            QuoteBlock(text: example.line, emphasised: true)
                            Text(example.why).font(.footnote).foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 8)
            } label: {
                Text(strings.t("lineDrill.threeThatWorkAndWhy")).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}
