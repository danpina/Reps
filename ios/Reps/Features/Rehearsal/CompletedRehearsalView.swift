import SwiftUI

/// A finished rehearsal: how it went, then the real thing it was practice for.
struct CompletedRehearsalView: View {
    let state: RehearsalState
    let strings: Strings
    let locale: AppLocale

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            switch state.result {
            case .drill(let landed, let attempts, let missed):
                drillOutcome(landed: landed, attempts: attempts, missed: missed)
            case .scene(let scale, let scores, let worked, let fix, let rewrite):
                sceneReview(scale: scale, scores: scores, worked: worked, fix: fix, rewrite: rewrite)
            case .ended, .none:
                Card {
                    Text(strings.t("rehearseScreen.sceneEnded")).font(.headline)
                    Text(strings.t("rehearseScreen.sceneEndedBody")).font(.subheadline).foregroundColor(.secondary)
                }
            }

            // Rehearsal is worth less than the real thing, and the app should keep saying so at the
            // moment it would be easiest to forget.
            Card(tint: .accentColor) {
                SectionLabel(text: strings.t("rehearseScreen.nowTheRealOne"), color: .accentColor)
                Text(state.mission).font(.body)
                LogRealRepButton(state: state, strings: strings).padding(.top, 4)
            }

            transcript
        }
    }

    // MARK: A drill

    private func drillOutcome(landed: Bool, attempts: Int, missed: [String]) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Card(tint: landed ? .accentColor : nil) {
                SectionLabel(text: landed ? strings.t("rehearseScreen.landedIt") : strings.t("rehearseScreen.notQuite"),
                             color: landed ? .accentColor : .secondary)
                Text(landed
                     ? strings.t("rehearseScreen.everyRequirementMet", ["attemptClause": attempts > 1
                                    ? strings.t("rehearseScreen.onAttempt", ["n": attempts])
                                    : strings.t("rehearseScreen.firstTime")])
                     : strings.t("rehearseScreen.settledOnOneThatMissed"))
                    .font(.body)
                if !missed.isEmpty {
                    Divider()
                    ForEach(Array(missed.enumerated()), id: \.offset) { _, requirement in
                        Text(requirement).font(.footnote).foregroundColor(.secondary)
                    }
                }
            }

            if !state.examples.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    SectionLabel(text: strings.t("rehearseScreen.threeThatWork"))
                    ForEach(Array(state.examples.enumerated()), id: \.offset) { _, example in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(example.situation).font(.caption).foregroundColor(.secondary)
                            QuoteBlock(text: example.line, emphasised: true)
                            Text(example.why).font(.footnote).foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }

    // MARK: A scored scene

    private func sceneReview(scale: RehearsalResult.Scale, scores: [RehearsalResult.Score], worked: [String],
                             fix: String, rewrite: RehearsalResult.Rewrite?) -> some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 14) {
                SectionLabel(text: strings.t("rehearseScreen.howItWent"))
                ForEach(scores, id: \.key) { score in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(score.label).font(.subheadline)
                            Spacer()
                            Text("\(score.score) / \(scale.max)").font(.caption.monospacedDigit()).foregroundColor(.secondary)
                        }
                        ProgressBar(fraction: Double(score.score) / Double(max(scale.max, 1)), height: 4)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                SectionLabel(text: strings.t("rehearseScreen.whatWorked"))
                ForEach(Array(worked.enumerated()), id: \.offset) { _, item in
                    QuoteBlock(text: item, emphasised: true)
                }
            }

            // One fix, never a list. People can only act on one thing.
            Card(tint: .orange) {
                SectionLabel(text: strings.t("rehearseScreen.theOneThingToChange"), color: .orange)
                Text(fix).font(.body)
            }

            if let rewrite {
                VStack(alignment: .leading, spacing: 10) {
                    SectionLabel(text: strings.t("rehearseScreen.oneLineRewritten"))
                    Text(strings.t("rehearseScreen.youSaid")).font(.caption).foregroundColor(.secondary)
                    Text("“\(rewrite.original)”").font(.body)
                    Text(strings.t("rehearseScreen.try")).font(.caption).foregroundColor(.secondary).padding(.top, 4)
                    Text("“\(rewrite.better)”").font(.body)
                    if !rewrite.why.isEmpty { Text(rewrite.why).font(.footnote).foregroundColor(.secondary) }
                }
            } else {
                Text(strings.t("rehearseScreen.noLineLevelRewrite")).font(.footnote).foregroundColor(.secondary)
            }
        }
    }

    // MARK: What was said

    private var transcript: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(state.transcript.enumerated()), id: \.offset) { _, turn in
                    VStack(alignment: .leading, spacing: 2) {
                        Text((turn.role == "user" ? strings.t("rehearseScreen.you") : strings.t("rehearseScreen.them")).uppercased())
                            .font(.caption2.weight(.semibold))
                            .tracking(1.2)
                            .foregroundColor(.secondary)
                        Text(turn.content).font(.subheadline)
                    }
                }
            }
            .padding(.top, 10)
        } label: {
            Text(state.mode == "choice" ? strings.t("rehearseScreen.whatYouChose") : strings.t("rehearseScreen.readTheTranscript"))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
