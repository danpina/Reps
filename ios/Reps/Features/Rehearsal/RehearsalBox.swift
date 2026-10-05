import SwiftUI

/// The rehearsal box at the foot of a lesson — "the test part". What kind of exercise this lesson
/// has, whether it is open yet, and the way in. The server decides everything that is a rule (the
/// level a scene needs, the free allowance); this only says it.
struct RehearsalBoxView: View {
    let lessonID: String

    @EnvironmentObject private var store: SessionStore

    @State private var box: RehearsalBox?
    @State private var busy = false
    @State private var errorText: String?
    @State private var openedID: String?
    @State private var showScreen = false

    private var strings: Strings { store.strings }

    var body: some View {
        Group {
            if let box { content(box) } else if errorText != nil { EmptyView() } else { ProgressView().frame(maxWidth: .infinity) }
        }
        .task { await load() }
        // Back from a rehearsal, the box may have a new past entry, or one fewer free rehearsal.
        .onChange(of: showScreen) { if !$0 { Task { await load() } } }
        .navigationDestination(isPresented: $showScreen) {
            if let openedID { RehearsalScreen(id: openedID) }
        }
    }

    private func load() async {
        do {
            box = try await store.withToken { try await RepsAPI().get("api/lessons/\(lessonID)/rehearsal", token: $0) }
        } catch is CancellationError {
        } catch let error as URLError where error.code == .cancelled {
        } catch {
            if box == nil { errorText = error.localizedDescription }
        }
    }

    // MARK: The box

    @ViewBuilder private func content(_ box: RehearsalBox) -> some View {
        Card {
            SectionLabel(text: heading(box.mode))

            if box.spent {
                Text(strings.t("rehearsalBox.usedFreeRehearsal", ["partnerName": box.partnerName]))
                    .font(.subheadline).foregroundColor(.secondary)
            } else if box.unlocked {
                Text(intro(box)).font(.subheadline)

                if let left = box.freeLeft {
                    Text(strings.t("rehearsalBox.freeRehearsalsLeft", ["count": left]))
                        .font(.caption.monospacedDigit()).foregroundColor(.secondary)
                }

                if let errorText { ErrorBanner(text: errorText) }

                HStack(spacing: 12) {
                    SecondaryButton(title: startTitle(box), busy: busy) { Task { await start(box) } }
                    // A drill pays once, the first time it is landed. Repetition is the point of it, and
                    // paying per repetition would turn that into a way of farming the number.
                    Text(box.paid ? strings.t("rehearsalBox.xpAward", ["xp": box.xp])
                                  : strings.t("rehearsalBox.xpAwardFirstTime", ["xp": box.xp]))
                        .font(.caption.monospacedDigit())
                        .foregroundColor(.secondary)
                        .fixedSize()
                }
            } else {
                Text(strings.t("rehearsalBox.lockedUntilLevel", ["required": box.requiredLevel, "level": box.level]))
                    .font(.subheadline).foregroundColor(.secondary)
                Text(strings.t("rehearsalBox.levelsComeFromReps")).font(.footnote).foregroundColor(.secondary)
            }

            // Outside the branches above, because what you already rehearsed here stays worth reading
            // whether or not you may start another: a lapsed subscription should not take your own
            // transcripts away.
            if !box.past.isEmpty {
                Divider()
                DisclosureGroup {
                    VStack(spacing: 0) {
                        ForEach(box.past) { rehearsal in
                            NavigationLink { RehearsalScreen(id: rehearsal.id) } label: {
                                RehearsalRowView(rehearsal: rehearsal, strings: strings, locale: store.locale)
                            }
                            .buttonStyle(.plain)
                            Divider()
                        }
                    }
                } label: {
                    Text(strings.t("rehearsalBox.countOnThisLesson",
                                   ["count": strings.t("rehearsalList.rehearsalsCount", ["count": box.past.count])]))
                        .font(.caption).foregroundColor(.secondary)
                }
            }
        }
    }

    private func heading(_ mode: String) -> String {
        switch mode {
        case "line": return strings.t("rehearsalBox.headings.line")
        case "beat": return strings.t("rehearsalBox.headings.beat")
        case "choice": return strings.t("rehearsalBox.headings.choice")
        default: return strings.t("rehearsalBox.headings.scene")
        }
    }

    private func intro(_ box: RehearsalBox) -> String {
        switch box.mode {
        case "line": return strings.t("rehearsalBox.modeIntro.line")
        // Deliberately says nothing about which way the answers go.
        case "choice": return strings.t("rehearsalBox.modeIntro.choice")
        case "beat": return strings.t("rehearsalBox.modeIntro.beat", ["partnerName": box.partnerName])
        default:
            return strings.t("rehearsalBox.modeIntro.scene", [
                "partnerName": box.partnerName,
                "hardWork": box.openness <= 2 ? strings.t("rehearsalBox.modeIntro.hardWork") : "",
            ])
        }
    }

    private func startTitle(_ box: RehearsalBox) -> String {
        let carrying = box.openId != nil
        switch box.mode {
        case "line": return carrying ? strings.t("rehearsalBox.carryOn.line") : strings.t("rehearsalBox.start.line")
        case "beat": return carrying ? strings.t("rehearsalBox.carryOn.beat") : strings.t("rehearsalBox.start.beat")
        case "choice": return carrying ? strings.t("rehearsalBox.carryOn.choice") : strings.t("rehearsalBox.start.choice")
        default: return carrying ? strings.t("rehearsalBox.carryOn.scene") : strings.t("rehearsalBox.start.scene")
        }
    }

    // MARK: Starting

    private func start(_ box: RehearsalBox) async {
        errorText = nil
        busy = true
        defer { busy = false }
        do {
            let started: StartedRehearsal = try await store.withToken {
                try await RepsAPI().post("api/rehearse/start", body: ["lessonId": lessonID], token: $0)
            }
            openedID = started.id
            showScreen = true
        } catch let failure as APIFailure {
            errorText = explain(failure, box)
        } catch {
            errorText = error.localizedDescription
        }
    }

    /// The server refuses for three reasons that are rules rather than faults. Each has a sentence on
    /// the website, and the app says that sentence.
    private func explain(_ failure: APIFailure, _ box: RehearsalBox) -> String {
        switch failure.code {
        case "subscription_required":
            return strings.t("rehearsalBox.usedFreeRehearsal", ["partnerName": box.partnerName])
        case "scene_limit":
            return strings.t("rehearse.dailyCapReached", ["max": 5])
        case "locked_until_level":
            return strings.t("rehearsalBox.lockedUntilLevel", ["required": box.requiredLevel, "level": box.level])
        default:
            return failure.localizedDescription
        }
    }
}

/// One past rehearsal: how it ended, how much of it there was, and when.
struct RehearsalRowView: View {
    let rehearsal: PastRehearsal
    let strings: Strings
    let locale: AppLocale

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                verdict
                Text(count).font(.caption.monospacedDigit()).foregroundColor(.secondary)
                Spacer()
                Text(dateText).font(.caption.monospacedDigit()).foregroundColor(.secondary)
            }
            if let fix = rehearsal.fix, !fix.isEmpty {
                Text(fix).font(.footnote).foregroundColor(.secondary).lineLimit(3)
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    @ViewBuilder private var verdict: some View {
        if rehearsal.status == "open" {
            badge(strings.t("rehearsalList.unfinished"), color: .orange)
        } else if let landed = rehearsal.landed {
            landed ? badge(strings.t("rehearsalList.landed"), color: .accentColor)
                   : badge(strings.t("rehearsalList.notQuite"), color: .secondary)
        } else if let average = rehearsal.average {
            badge(strings.t("rehearsalList.avg", ["score": String(format: "%.1f", average)]), color: .accentColor)
        } else {
            badge(strings.t("rehearsalList.unscored"), color: .secondary)
        }
    }

    private func badge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(color, lineWidth: 1))
    }

    private var count: String {
        switch rehearsal.mode {
        case "line": return strings.t("rehearsalList.attempts", ["count": rehearsal.lines])
        case "choice": return strings.t("rehearsalList.read", ["count": rehearsal.lines])
        default: return strings.t("rehearsalList.linesSaid", ["count": rehearsal.lines])
        }
    }

    private var dateText: String {
        guard let date = ISO8601DateFormatter.parse(rehearsal.startedAt) else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: locale.rawValue)
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
