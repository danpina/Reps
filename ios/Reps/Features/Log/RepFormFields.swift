import SwiftUI

/// The fields shared by logging a rep and editing one: which skill, how it went, who or where, a
/// note, and — folded away — a guess about the other person. The same fields, in the same order, as
/// the website's `RepFields`.
struct RepFormFields: View {
    @Binding var skillID: String?
    @Binding var went: Int?
    @Binding var contextNote: String
    @Binding var reflection: String
    @Binding var otherSex: String?
    @Binding var otherAgeGroup: String?
    /// When the skill is already known (a rep logged from a lesson), it is shown rather than asked,
    /// with a way to change it.
    var locksSkill = false

    @EnvironmentObject private var store: SessionStore
    @EnvironmentObject private var library: LibraryStore
    @State private var picking = false

    private var strings: Strings { store.strings }

    private static let ages = ["18-24", "25-34", "35-44", "45-54", "55-64", "65+"]

    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            skillField
            wentField
            noteField
            otherField
            reflectionField
        }
    }

    // MARK: Skill

    private var selectedSkillLabel: String? {
        guard let skillID else { return nil }
        for topic in library.topics {
            if let skill = topic.skills.first(where: { $0.id == skillID }) {
                return "\(topic.name) · \(skill.name)"
            }
        }
        return nil
    }

    private var skillField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(strings.t("log.whichSkill")).font(.subheadline.weight(.medium))

            if locksSkill && !picking, let label = selectedSkillLabel {
                HStack {
                    Text(label).font(.subheadline)
                    Spacer()
                    Button(strings.t("log.change")) { picking = true }
                        .font(.footnote)
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            } else {
                Menu {
                    ForEach(library.topics) { topic in
                        Section(topic.name) {
                            ForEach(topic.skills) { skill in
                                Button(skill.name) { skillID = skill.id }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedSkillLabel ?? strings.t("log.pickOne"))
                            .foregroundColor(selectedSkillLabel == nil ? .secondary : .primary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down").font(.caption).foregroundColor(.secondary)
                    }
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
            }
        }
    }

    // MARK: How it went

    private var wentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(strings.t("log.howDidItGo")).font(.subheadline.weight(.medium))
            Text(strings.t("log.wentCreditHint")).font(.footnote).foregroundColor(.secondary)

            HStack(spacing: 8) {
                wentChoice(1, title: strings.t("went.1"), hint: strings.t("log.wentHint.1"))
                wentChoice(2, title: strings.t("went.2"), hint: strings.t("log.wentHint.2"))
                wentChoice(3, title: strings.t("went.3"), hint: strings.t("log.wentHint.3"))
            }
        }
    }

    private func wentChoice(_ value: Int, title: String, hint: String) -> some View {
        let selected = went == value
        return Button { went = value } label: {
            VStack(spacing: 4) {
                Text(title).font(.subheadline.weight(.medium))
                Text(hint).font(.caption2).foregroundColor(.secondary).multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 78)
            .padding(.horizontal, 6)
            .background(selected ? Color.accentColor.opacity(0.14) : Color(.secondarySystemBackground))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(selected ? Color.accentColor : Color.clear, lineWidth: 1.5))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    // MARK: Who or where, and the note

    private var noteField: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(strings.t("log.whoOrWhere")).font(.subheadline.weight(.medium))
                + Text("  — \(strings.t("log.optional"))").font(.footnote).foregroundColor(.secondary))
            TextField(strings.t("log.whoOrWherePlaceholder"), text: $contextNote)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .onChange(of: contextNote) { if $0.count > 140 { contextNote = String($0.prefix(140)) } }
            Text(strings.t("log.noNamesNeeded")).font(.caption).foregroundColor(.secondary)
        }
    }

    private var reflectionField: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(strings.t("log.oneNote")).font(.subheadline.weight(.medium))
                + Text("  — \(strings.t("log.optional"))").font(.footnote).foregroundColor(.secondary))
            ZStack(alignment: .topLeading) {
                TextEditor(text: $reflection)
                    .frame(minHeight: 110)
                    .padding(6)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                if reflection.isEmpty {
                    Text(strings.t("log.reflectionPlaceholder"))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    /// Folded away, because it is a guess about a stranger and must never feel like paperwork owed
    /// before a rep can be recorded.
    private var otherField: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 12) {
                Text(strings.t("log.patternsOnlyHint")).font(.caption).foregroundColor(.secondary)

                Picker(strings.t("demographics.theyWere"), selection: Binding(
                    get: { otherSex ?? "" }, set: { otherSex = $0.isEmpty ? nil : $0 })) {
                    Text(strings.t("demographics.notSaying")).tag("")
                    Text(strings.t("demographics.aMan")).tag("male")
                    Text(strings.t("demographics.aWoman")).tag("female")
                }

                Picker(strings.t("demographics.roughly"), selection: Binding(
                    get: { otherAgeGroup ?? "" }, set: { otherAgeGroup = $0.isEmpty ? nil : $0 })) {
                    Text(strings.t("demographics.notSaying")).tag("")
                    Text(strings.t("demographics.age.18-24")).tag("18-24")
                    Text(strings.t("demographics.age.25-34")).tag("25-34")
                    Text(strings.t("demographics.age.35-44")).tag("35-44")
                    Text(strings.t("demographics.age.45-54")).tag("45-54")
                    Text(strings.t("demographics.age.55-64")).tag("55-64")
                    Text(strings.t("demographics.age.65+")).tag("65+")
                }
            }
            .padding(.top, 8)
        } label: {
            (Text(strings.t("log.whoYouSpokeTo")).font(.subheadline.weight(.medium))
                + Text("  — \(strings.t("log.whoYouSpokeToHint"))").font(.footnote).foregroundColor(.secondary))
        }
    }
}
