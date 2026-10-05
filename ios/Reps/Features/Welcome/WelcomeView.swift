import SwiftUI

/// The first thing a new account sees: a name, where to start, and three optional answers about the
/// reader. Shown until the profile says onboarding is done, exactly as the website does.
struct WelcomeView: View {
    @EnvironmentObject private var store: SessionStore

    @State private var topics: [TopicItem] = []
    @State private var loadFailed = false

    @State private var name = ""
    @State private var topicID: String?
    @State private var sex = ""
    @State private var age = ""
    @State private var interest = ""

    @State private var busy = false
    @State private var errorText: String?

    private var strings: Strings { store.strings }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("REPS").font(.caption.weight(.semibold)).tracking(3).foregroundColor(.secondary)
                    Text(strings.t("welcome.headline"))
                        .font(.system(.title, design: .serif).weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                    Text(strings.t("welcome.body1")).font(.subheadline).foregroundColor(.secondary)
                    Text(strings.t("welcome.body2")).font(.subheadline).foregroundColor(.secondary)
                }

                nameField
                aboutYou
                topicPicker

                if let errorText { ErrorBanner(text: errorText) }

                PrimaryButton(title: busy ? strings.t("welcome.settingUpPending") : strings.t("welcome.start"), busy: busy) {
                    Task { await start() }
                }
            }
            .padding(24)
        }
        .scrollDismissesKeyboard(.interactively)
        .task { await loadTopics() }
    }

    // MARK: Fields

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(strings.t("welcome.whatShouldWeCallYou")).font(.subheadline.weight(.medium))
            TextField(strings.t("welcome.firstNamePlenty"), text: $name)
                .textContentType(.givenName)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .onChange(of: name) { if $0.count > 60 { name = String($0.prefix(60)) } }
        }
    }

    private var aboutYou: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(strings.t("welcome.aboutYouHint")).font(.footnote).foregroundColor(.secondary)

            Picker(strings.t("demographics.youAre"), selection: $sex) {
                Text(strings.t("demographics.ratherNotSay")).tag("")
                Text(strings.t("demographics.sex.male")).tag("male")
                Text(strings.t("demographics.sex.female")).tag("female")
            }
            Picker(strings.t("demographics.yourAge"), selection: $age) {
                Text(strings.t("demographics.ratherNotSay")).tag("")
                Text(strings.t("demographics.age.18-24")).tag("18-24")
                Text(strings.t("demographics.age.25-34")).tag("25-34")
                Text(strings.t("demographics.age.35-44")).tag("35-44")
                Text(strings.t("demographics.age.45-54")).tag("45-54")
                Text(strings.t("demographics.age.55-64")).tag("55-64")
                Text(strings.t("demographics.age.65+")).tag("65+")
            }
            Picker(strings.t("demographics.datingPracticeWith"), selection: $interest) {
                Text(strings.t("demographics.ratherNotSay")).tag("")
                Text(strings.t("demographics.datingInterest.men")).tag("men")
                Text(strings.t("demographics.datingInterest.women")).tag("women")
                Text(strings.t("demographics.datingInterest.both")).tag("both")
            }
        }
    }

    private var topicPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(strings.t("welcome.whereDoYouWantToImprove")).font(.subheadline.weight(.medium))
            Text(strings.t("welcome.thisOnlyPicksWhereYouStart")).font(.footnote).foregroundColor(.secondary)

            if topics.isEmpty && !loadFailed {
                ProgressView().frame(maxWidth: .infinity)
            }
            ForEach(topics) { topic in
                let selected = topicID == topic.id
                Button { topicID = topic.id } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selected ? .accentColor : .secondary)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(topic.name).font(.subheadline.weight(.medium)).foregroundColor(.primary)
                            if !topic.description.isEmpty {
                                Text(topic.description).font(.footnote).foregroundColor(.secondary).lineLimit(3)
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(selected ? Color.accentColor : Color(.separator), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selected ? .isSelected : [])
            }
        }
    }

    // MARK: Actions

    private func loadTopics() async {
        do {
            let items = try await store.withToken { token in
                try await CurriculumAPI().topics(locale: store.locale, accessToken: token)
            }
            topics = items
        } catch {
            loadFailed = true
        }
    }

    private func start() async {
        errorText = nil
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { errorText = strings.t("welcome.errors.whatShouldWeCallYou"); return }
        guard let topicID else { errorText = strings.t("welcome.errors.pickWhereToStart"); return }

        busy = true
        defer { busy = false }
        do {
            try await store.updateProfile([
                "display_name": trimmed,
                "starting_topic_id": topicID,
                "onboarded_at": ISO8601DateFormatter().string(from: Date()),
                "sex": sex.isEmpty ? nil : sex,
                "age_group": age.isEmpty ? nil : age,
                "dating_interest": interest.isEmpty ? nil : interest,
                "timezone": TimeZone.current.identifier,
            ])
        } catch {
            errorText = strings.t("welcome.errors.didNotSave")
        }
    }
}
