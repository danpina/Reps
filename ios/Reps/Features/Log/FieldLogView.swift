import SwiftUI

/// Every real conversation the reader has logged. This is the part that counts.
struct FieldLogView: View {
    @EnvironmentObject private var store: SessionStore
    @EnvironmentObject private var library: LibraryStore

    @State private var response: FieldLogResponse?
    @State private var errorText: String?
    @State private var notice: String?
    @State private var showLog = false

    private var strings: Strings { store.strings }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(strings.t("fieldLog.subheading")).font(.subheadline).foregroundColor(.secondary)

                    if let notice { Card(tint: .accentColor) { Text(notice).font(.subheadline) } }

                    if let response {
                        totals(response.totals)
                        if response.entries.isEmpty { emptyState } else { days(response.entries) }
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
            .navigationTitle(strings.t("fieldLog.heading"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showLog = true } label: {
                        Label(strings.t("nav.logARep"), systemImage: "plus")
                    }
                }
            }
            .refreshable { await load() }
            .navigationDestination(for: FieldLogEntry.self) { entry in
                EditRepView(entry: entry) { outcome in
                    notice = outcome
                    Task { await load() }
                }
            }
        }
        .onAppear { Task { await load() } }
        .sheet(isPresented: $showLog) {
            LogRepView(preset: LogPreset()) { Task { await load() } }
        }
    }

    private func load() async {
        do {
            response = try await store.withToken { try await RepsAPI().get("api/field-log", token: $0) }
            errorText = nil
        } catch is CancellationError {
        } catch let error as URLError where error.code == .cancelled {
        } catch {
            if response == nil { errorText = error.localizedDescription }
        }
    }

    // MARK: Pieces

    private func totals(_ totals: TodayData.Totals) -> some View {
        HStack(alignment: .top, spacing: 12) {
            stat(strings.t("fieldLog.reps"), totals.repsLogged)
            stat(strings.t("fieldLog.streak"), totals.currentStreak)
            stat(strings.t("fieldLog.longest"), totals.longestStreak)
        }
    }

    private func stat(_ label: String, _ value: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundColor(.secondary)
            Text("\(value)").font(.system(.title2, design: .rounded).monospacedDigit())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }

    private var emptyState: some View {
        Card {
            Text(strings.t("fieldLog.firstRepHeading")).font(.headline)
            Text(strings.t("fieldLog.firstRepBody")).font(.subheadline).foregroundColor(.secondary)
            PrimaryButton(title: strings.t("fieldLog.logOneNow")) { showLog = true }
                .padding(.top, 4)
        }
    }

    private func days(_ entries: [FieldLogEntry]) -> some View {
        let grouped = Dictionary(grouping: entries, by: \.loggedDate)
        let order = grouped.keys.sorted(by: >)

        return VStack(alignment: .leading, spacing: 22) {
            ForEach(order, id: \.self) { day in
                VStack(alignment: .leading, spacing: 10) {
                    SectionLabel(text: dayLabel(day))
                    ForEach(grouped[day] ?? []) { entry in
                        NavigationLink(value: entry) {
                            RepRow(entry: entry, skillName: skillName(entry), strings: strings)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    /// The skill's name in the reader's language: the log's own rows carry the English one.
    private func skillName(_ entry: FieldLogEntry) -> String {
        for topic in library.topics {
            if let skill = topic.skills.first(where: { $0.id == entry.skillId }) { return skill.name }
        }
        return entry.skills?.name ?? strings.t("fieldLog.aRep")
    }

    private func dayLabel(_ iso: String) -> String {
        guard let date = DateFormatter.isoDay.date(from: iso) else { return iso }
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(date) { return strings.t("fieldLog.today") }
        if calendar.isDateInYesterday(date) { return strings.t("fieldLog.yesterday") }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: store.locale.rawValue)
        formatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
        return formatter.string(from: date)
    }
}

// FieldLogEntry is a navigation value.
extension FieldLogEntry: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

private struct RepRow: View {
    let entry: FieldLogEntry
    let skillName: String
    let strings: Strings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(skillName).font(.subheadline.weight(.medium))
                Spacer()
                Text(wentLabel)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(entry.went == 3 ? Color.accentColor : Color(.separator), lineWidth: 1))
                    .foregroundColor(entry.went == 3 ? .accentColor : .secondary)
            }
            if let note = entry.contextNote, !note.isEmpty {
                Text(note).font(.footnote).foregroundColor(.secondary)
            }
            if let other = describeOther(entry) {
                Text(other).font(.caption).foregroundColor(.secondary)
            }
            if let reflection = entry.reflection, !reflection.isEmpty {
                Text(reflection).font(.subheadline).lineLimit(4)
            }
            Text("+\(entry.xpAwarded) XP").font(.caption.monospacedDigit()).foregroundColor(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }

    private var wentLabel: String {
        switch entry.went {
        case 1: return strings.t("went.1")
        case 2: return strings.t("went.2")
        default: return strings.t("went.3")
        }
    }

    private func describeOther(_ entry: FieldLogEntry) -> String? {
        let who: String? = entry.otherSex == "male" ? strings.t("demographics.aMan")
            : entry.otherSex == "female" ? strings.t("demographics.aWoman") : nil
        let age = entry.otherAgeGroup.map(ageLabel)

        if let who, let age { return "\(who), \(age)" }
        if let who { return who }
        if let age { return strings.t("demographics.someoneAged", ["age": age]) }
        return nil
    }

    private func ageLabel(_ band: String) -> String {
        switch band {
        case "18-24": return strings.t("demographics.age.18-24")
        case "25-34": return strings.t("demographics.age.25-34")
        case "35-44": return strings.t("demographics.age.35-44")
        case "45-54": return strings.t("demographics.age.45-54")
        case "55-64": return strings.t("demographics.age.55-64")
        default: return strings.t("demographics.age.65+")
        }
    }
}

// MARK: - Editing

/// Edit a rep, or delete it. Moving a rep to another skill moves its XP with it, and deleting one
/// takes its XP back and works the streak out again — all on the server, as on the website.
struct EditRepView: View {
    let entry: FieldLogEntry
    /// Called with the sentence to show on the list once this has saved or deleted.
    let onDone: (String) -> Void

    @EnvironmentObject private var store: SessionStore
    @Environment(\.dismiss) private var dismiss

    @State private var skillID: String?
    @State private var went: Int?
    @State private var contextNote: String
    @State private var reflection: String
    @State private var otherSex: String?
    @State private var otherAgeGroup: String?

    @State private var busy = false
    @State private var errorText: String?
    @State private var confirmingDelete = false

    private var strings: Strings { store.strings }

    init(entry: FieldLogEntry, onDone: @escaping (String) -> Void) {
        self.entry = entry
        self.onDone = onDone
        _skillID = State(initialValue: entry.skillId)
        _went = State(initialValue: entry.went)
        _contextNote = State(initialValue: entry.contextNote ?? "")
        _reflection = State(initialValue: entry.reflection ?? "")
        _otherSex = State(initialValue: entry.otherSex)
        _otherAgeGroup = State(initialValue: entry.otherAgeGroup)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                Text(strings.t("editRepPage.loggedOn", ["date": loggedOn]))
                    .font(.footnote)
                    .foregroundColor(.secondary)

                if let mission = entry.missionText, !mission.isEmpty {
                    Card(tint: .accentColor) {
                        SectionLabel(text: strings.t("editRepPage.theMissionThisWasFor"), color: .accentColor)
                        Text(mission).font(.subheadline)
                    }
                }

                RepFormFields(skillID: $skillID, went: $went, contextNote: $contextNote, reflection: $reflection,
                              otherSex: $otherSex, otherAgeGroup: $otherAgeGroup)

                if let errorText { ErrorBanner(text: errorText) }

                PrimaryButton(title: busy ? strings.t("editRepPage.savingPending") : strings.t("editRepPage.saveChanges"), busy: busy) {
                    Task { await save() }
                }

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text(strings.t("editRepPage.deleteExplanation")).font(.footnote).foregroundColor(.secondary)
                    Button(role: .destructive) { confirmingDelete = true } label: {
                        Text(strings.t("editRepPage.deleteThisRep")).fontWeight(.medium)
                    }
                    .disabled(busy)
                }
            }
            .padding(20)
        }
        .navigationTitle(strings.t("editRepPage.heading"))
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .confirmationDialog(strings.t("editRepPage.deleteThisRep"), isPresented: $confirmingDelete, titleVisibility: .visible) {
            Button(strings.t("editRepPage.yesDeleteIt"), role: .destructive) { Task { await delete() } }
            Button(strings.t("editRepPage.keepIt"), role: .cancel) {}
        } message: {
            Text(strings.t("editRepPage.deleteExplanation"))
        }
    }

    private var loggedOn: String {
        guard let date = DateFormatter.isoDay.date(from: entry.loggedDate) else { return entry.loggedDate }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: store.locale.rawValue)
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    private func save() async {
        errorText = nil
        guard let skillID else { errorText = strings.t("editRepPage.errors.pickWhichSkill"); return }
        guard let went else { errorText = strings.t("editRepPage.errors.sayHowItWent"); return }

        var body: [String: Any] = ["skillId": skillID, "went": went, "contextNote": contextNote, "reflection": reflection]
        if let otherSex { body["otherSex"] = otherSex }
        if let otherAgeGroup { body["otherAgeGroup"] = otherAgeGroup }

        busy = true
        defer { busy = false }
        do {
            let _: Acknowledged = try await store.withToken { try await RepsAPI().patch("api/field-log/\(entry.id)", body: body, token: $0) }
            onDone(strings.t("fieldLog.repUpdated"))
            dismiss()
        } catch {
            errorText = error.localizedDescription
        }
    }

    private func delete() async {
        errorText = nil
        busy = true
        defer { busy = false }
        do {
            let _: Acknowledged = try await store.withToken { try await RepsAPI().delete("api/field-log/\(entry.id)", token: $0) }
            onDone(strings.t("fieldLog.repDeleted"))
            dismiss()
        } catch {
            errorText = strings.t("fieldLog.deleteFailed")
        }
    }
}
