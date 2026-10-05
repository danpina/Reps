import SwiftUI

/// The reader's own page: who they are, the language, the appearance, the password, and the account.
/// The same sections, in the same order and the same words, as the website's settings.
struct SettingsView: View {
    @EnvironmentObject private var store: SessionStore

    private var strings: Strings { store.strings }

    var body: some View {
        NavigationStack {
            List {
                AboutYouSection()
                LanguageSection()
                AppearanceSection()
                PasswordSection()
                AccountSection()
            }
            .navigationTitle(strings.t("settings.heading"))
        }
    }
}

// MARK: - Shared bits

/// A one-line outcome under a section's button: what happened, in the website's words.
private struct Outcome: View {
    let message: Message?

    enum Message: Equatable {
        case done(String)
        case failed(String)
    }

    var body: some View {
        switch message {
        case .done(let text): Text(text).font(.footnote).foregroundColor(.accentColor)
        case .failed(let text): Text(text).font(.footnote).foregroundColor(.red)
        case .none: EmptyView()
        }
    }
}

private func sectionHeader(_ title: String, _ description: String?) -> some View {
    VStack(alignment: .leading, spacing: 4) {
        Text(title).font(.headline).textCase(nil).foregroundColor(.primary)
        if let description {
            Text(description).font(.footnote).textCase(nil).foregroundColor(.secondary)
        }
    }
    .padding(.bottom, 4)
}

// MARK: - About you

/// Three optional answers. They decide which version of a lesson is shown, how a rehearsal is reviewed,
/// and what a read of the log can notice. Clearing one is a legitimate edit, so a blank answer writes null.
private struct AboutYouSection: View {
    @EnvironmentObject private var store: SessionStore

    @State private var sex = ""
    @State private var age = ""
    @State private var interest = ""
    @State private var seeded = false
    @State private var busy = false
    @State private var outcome: Outcome.Message?

    private var strings: Strings { store.strings }

    var body: some View {
        Section {
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
            Button(busy ? strings.t("common.saving") : strings.t("settings.aboutYou.save")) { Task { await save() } }
                .disabled(busy)
            Outcome(message: outcome)
        } header: {
            sectionHeader(strings.t("settings.aboutYou.title"), strings.t("settings.aboutYou.description"))
        }
        .onAppear { seed() }
        .onChange(of: store.profile) { _ in seeded = false; seed() }
    }

    private func seed() {
        guard !seeded else { return }
        seeded = true
        sex = store.profile.sex ?? ""
        age = store.profile.ageGroup ?? ""
        interest = store.profile.datingInterest ?? ""
    }

    private func save() async {
        outcome = nil
        busy = true
        defer { busy = false }
        do {
            try await store.updateProfile([
                "sex": sex.isEmpty ? nil : sex,
                "age_group": age.isEmpty ? nil : age,
                "dating_interest": interest.isEmpty ? nil : interest,
            ])
            outcome = .done(strings.t("settings.messages.saved"))
        } catch {
            outcome = .failed(strings.t("settings.messages.didNotSave"))
        }
    }
}

// MARK: - Language

private struct LanguageSection: View {
    @EnvironmentObject private var store: SessionStore

    @State private var choice: AppLocale = .default
    @State private var seeded = false
    @State private var busy = false
    @State private var outcome: Outcome.Message?

    private var strings: Strings { store.strings }

    var body: some View {
        Section {
            Picker(strings.t("settings.language.legend"), selection: $choice) {
                ForEach(AppLocale.allCases, id: \.self) { locale in
                    Text(locale.nativeName).tag(locale)
                }
            }
            .pickerStyle(.segmented)

            Button(busy ? strings.t("common.saving") : strings.t("settings.language.save")) { Task { await save() } }
                .disabled(busy || choice == store.locale)
            Outcome(message: outcome)
        } header: {
            sectionHeader(strings.t("settings.language.title"), strings.t("settings.language.description"))
        }
        .onAppear { if !seeded { seeded = true; choice = store.locale } }
    }

    private func save() async {
        outcome = nil
        busy = true
        defer { busy = false }
        do {
            try await store.updateProfile(["locale": choice.rawValue])
            // The strings are read afresh now, so the confirmation comes back in the new language.
            outcome = .done(store.strings.t("settings.messages.languageSaved"))
        } catch {
            outcome = .failed(strings.t("settings.messages.didNotSave"))
        }
    }
}

// MARK: - Appearance

private struct AppearanceSection: View {
    @EnvironmentObject private var store: SessionStore

    @State private var choice = "system"
    @State private var seeded = false
    @State private var busy = false
    @State private var outcome: Outcome.Message?

    private var strings: Strings { store.strings }

    var body: some View {
        Section {
            option("system", label: strings.t("settings.appearance.system.label"), hint: strings.t("settings.appearance.system.hint"))
            option("light", label: strings.t("settings.appearance.light.label"), hint: strings.t("settings.appearance.light.hint"))
            option("dark", label: strings.t("settings.appearance.dark.label"), hint: strings.t("settings.appearance.dark.hint"))

            Button(busy ? strings.t("common.saving") : strings.t("settings.appearance.save")) { Task { await save() } }
                .disabled(busy || choice == (store.profile.theme ?? "system"))
            Outcome(message: outcome)
        } header: {
            sectionHeader(strings.t("settings.appearance.title"), strings.t("settings.appearance.description"))
        }
        .onAppear { if !seeded { seeded = true; choice = store.profile.theme ?? "system" } }
    }

    private func option(_ value: String, label: String, hint: String) -> some View {
        Button { choice = value } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label).foregroundColor(.primary)
                    Text(hint).font(.footnote).foregroundColor(.secondary)
                }
                Spacer()
                if choice == value { Image(systemName: "checkmark").foregroundColor(.accentColor) }
            }
        }
    }

    private func save() async {
        outcome = nil
        busy = true
        defer { busy = false }
        do {
            try await store.updateProfile(["theme": choice])
            outcome = .done(strings.t("settings.messages.themeSaved"))
        } catch {
            outcome = .failed(strings.t("settings.messages.didNotSave"))
        }
    }
}

// MARK: - Password

private struct PasswordSection: View {
    @EnvironmentObject private var store: SessionStore

    @State private var current = ""
    @State private var new = ""
    @State private var again = ""
    @State private var busy = false
    @State private var outcome: Outcome.Message?

    private var strings: Strings { store.strings }

    var body: some View {
        Section {
            SecureField(strings.t("settings.password.currentPassword"), text: $current)
                .textContentType(.password)
            VStack(alignment: .leading, spacing: 4) {
                SecureField(strings.t("settings.password.newPassword"), text: $new)
                    .textContentType(.newPassword)
                Text(strings.t("settings.password.newPasswordHint")).font(.caption).foregroundColor(.secondary)
            }
            SecureField(strings.t("settings.password.newPasswordAgain"), text: $again)
                .textContentType(.newPassword)

            Button(busy ? strings.t("settings.password.changing") : strings.t("settings.password.changePassword")) {
                Task { await change() }
            }
            .disabled(busy)
            Outcome(message: outcome)

            Link(strings.forgotPassword, destination: BackendConfig.siteURL.appendingPathComponent("forgot-password"))
                .font(.footnote)
        } header: {
            sectionHeader(strings.t("settings.password.title"), strings.t("settings.password.description"))
        }
    }

    /// The same checks, in the same order, as the website's `changePassword`.
    private func change() async {
        outcome = nil
        if current.isEmpty { outcome = .failed(strings.t("settings.messages.enterCurrentPassword")); return }
        if new.count < 8 { outcome = .failed(strings.t("settings.messages.newPasswordTooShort")); return }
        if new != again { outcome = .failed(strings.t("settings.messages.passwordsDoNotMatch")); return }
        if new == current { outcome = .failed(strings.t("settings.messages.samePassword")); return }

        busy = true
        defer { busy = false }
        do {
            try await store.changePassword(current: current, new: new)
            current = ""; new = ""; again = ""
            outcome = .done(strings.t("settings.messages.passwordChanged"))
        } catch PasswordChangeError.wrongCurrent {
            outcome = .failed(strings.t("settings.messages.wrongCurrentPassword"))
        } catch {
            outcome = .failed(strings.t("settings.messages.passwordChangeFailed"))
        }
    }
}

// MARK: - Account

private struct AccountSection: View {
    @EnvironmentObject private var store: SessionStore
    @State private var deleting = false

    private var strings: Strings { store.strings }

    private var version: String {
        let info = Bundle.main.infoDictionary
        let short = info?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = info?["CFBundleVersion"] as? String ?? "1"
        return "\(short) (\(build))"
    }

    var body: some View {
        Section {
            if let email = store.session?.email, !email.isEmpty {
                Text(strings.t("today.signedInAs", ["email": email])).font(.footnote).foregroundColor(.secondary)
            }
            Button(strings.t("settings.account.signOut")) { store.signOut() }

            HStack {
                Text(strings.appVersion)
                Spacer()
                Text(version).foregroundColor(.secondary)
            }
            .font(.footnote)

            Button(role: .destructive) { deleting = true } label: { Text(strings.deleteAccount) }
                .sheet(isPresented: $deleting) {
                    DeleteAccountSheet().environmentObject(store)
                }
        } header: {
            sectionHeader(strings.t("settings.account.title"), nil)
        } footer: {
            Text(strings.dangerZoneHint).font(.caption)
        }
    }
}

/// Deleting an account is a one-way door, so it asks for the password — the same proof changing one does —
/// and says plainly what goes. The server is what actually checks it.
private struct DeleteAccountSheet: View {
    @EnvironmentObject private var store: SessionStore
    @Environment(\.dismiss) private var dismiss

    @State private var password = ""
    @State private var busy = false
    @State private var errorText: String?

    private var strings: Strings { store.strings }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(strings.deleteAccountBody).font(.subheadline)
                }
                Section {
                    SecureField(strings.t("settings.password.currentPassword"), text: $password)
                        .textContentType(.password)
                    if let errorText { Text(errorText).font(.footnote).foregroundColor(.red) }
                }
                Section {
                    Button(role: .destructive) { Task { await delete() } } label: {
                        HStack {
                            if busy { ProgressView() }
                            Text(strings.deleteAccountConfirm)
                        }
                    }
                    .disabled(busy || password.isEmpty)
                }
            }
            .navigationTitle(strings.deleteAccountTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(strings.cancel) { dismiss() }.disabled(busy)
                }
            }
        }
    }

    private func delete() async {
        errorText = nil
        busy = true
        defer { busy = false }
        do {
            let _: Acknowledged = try await store.withToken {
                try await RepsAPI().delete("api/account", body: ["password": password], token: $0)
            }
            dismiss()
            store.signOut()
        } catch let failure as APIFailure {
            switch failure.code {
            case "wrong_password": errorText = strings.deleteAccountWrongPassword
            case "unavailable": errorText = strings.deleteAccountUnavailable
            default: errorText = failure.localizedDescription
            }
        } catch {
            errorText = error.localizedDescription
        }
    }
}
