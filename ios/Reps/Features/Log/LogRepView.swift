import SwiftUI

/// What a rep logged from a lesson already knows: which skill, which lesson, and the mission it was for.
struct LogPreset {
    var skillID: String?
    var lessonID: String?
    var missionText: String?
}

/// Log a rep. Thirty seconds is plenty, and a bad rep counts the same as a good one.
struct LogRepView: View {
    let preset: LogPreset
    let onLogged: () -> Void

    @EnvironmentObject private var store: SessionStore
    @EnvironmentObject private var library: LibraryStore
    @Environment(\.dismiss) private var dismiss

    @State private var skillID: String?
    @State private var went: Int?
    @State private var contextNote = ""
    @State private var reflection = ""
    @State private var otherSex: String?
    @State private var otherAgeGroup: String?

    @State private var busy = false
    @State private var errorText: String?
    @State private var logged: LoggedRep?

    private var strings: Strings { store.strings }

    var body: some View {
        NavigationStack {
            Group {
                if let logged {
                    confirmation(logged)
                } else {
                    form
                }
            }
            .navigationTitle(strings.t("logPage.heading"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(strings.close) { finish() }
                }
            }
        }
        .onAppear { if skillID == nil { skillID = preset.skillID } }
    }

    private var form: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                Text(strings.t("logPage.subheading")).font(.subheadline).foregroundColor(.secondary)

                if let mission = preset.missionText, !mission.isEmpty {
                    Card(tint: .accentColor) {
                        SectionLabel(text: strings.t("logPage.theMission"), color: .accentColor)
                        Text(mission).font(.subheadline)
                    }
                }

                RepFormFields(skillID: $skillID, went: $went, contextNote: $contextNote, reflection: $reflection,
                              otherSex: $otherSex, otherAgeGroup: $otherAgeGroup, locksSkill: preset.skillID != nil)

                if let errorText { ErrorBanner(text: errorText) }

                VStack(alignment: .leading, spacing: 8) {
                    PrimaryButton(title: busy ? strings.t("logPage.loggingPending") : strings.t("logPage.logThisRep"), busy: busy) {
                        Task { await submit() }
                    }
                    // Stated before the action, not just after it, so the ratio between a real
                    // conversation and everything else is visible where it matters.
                    Text(strings.t("logPage.xpMostAnythingIsWorth", ["xp": 50]))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func confirmation(_ result: LoggedRep) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Card(tint: .accentColor) {
                    Text(strings.t("fieldLog.loggedNotice", ["xp": result.xp])).font(.headline)
                }
                if !result.badges.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionLabel(text: strings.t("fieldLog.badgesEarned", ["count": result.badges.count]))
                        ForEach(result.badges) { badge in
                            Card {
                                Text(badge.name).font(.subheadline.weight(.medium))
                                Text(badge.description).font(.footnote).foregroundColor(.secondary)
                            }
                        }
                    }
                }
                PrimaryButton(title: strings.done) { finish() }
            }
            .padding(20)
        }
    }

    private func finish() {
        if logged != nil { onLogged() }
        dismiss()
    }

    private func submit() async {
        errorText = nil
        guard let skillID else { errorText = strings.t("logPage.errors.pickWhichSkill"); return }
        guard let went else { errorText = strings.t("logPage.errors.sayHowItWent"); return }

        var body: [String: Any] = [
            "skillId": skillID,
            "went": went,
            // The reader's own calendar day, so a rep logged late at night counts for the day they had it.
            "localDate": DateFormatter.isoDay.string(from: Date()),
            "timezone": TimeZone.current.identifier,
        ]
        if let lesson = preset.lessonID { body["lessonId"] = lesson }
        if let mission = preset.missionText, !mission.isEmpty { body["missionText"] = mission }
        if !contextNote.trimmingCharacters(in: .whitespaces).isEmpty { body["contextNote"] = contextNote }
        if !reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { body["reflection"] = reflection }
        if let otherSex { body["otherSex"] = otherSex }
        if let otherAgeGroup { body["otherAgeGroup"] = otherAgeGroup }

        busy = true
        defer { busy = false }
        do {
            logged = try await store.withToken { try await RepsAPI().post("api/log", body: body, token: $0) }
        } catch {
            errorText = error.localizedDescription
        }
    }
}
