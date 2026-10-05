import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var store: SessionStore

    @State private var email = ""
    @State private var password = ""
    @State private var busy = false
    @State private var errorText: String?

    private var strings: Strings { store.strings }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("REPS")
                    .font(.caption.weight(.semibold))
                    .tracking(3)
                    .foregroundColor(.secondary)
                    .padding(.top, 56)

                Text(strings.tagline)
                    .font(.system(.title, design: .serif).weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 14) {
                    field(strings.email) {
                        TextField(strings.email, text: $email)
                            .keyboardType(.emailAddress)
                            .textContentType(.username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    field(strings.password) {
                        SecureField(strings.password, text: $password)
                            .textContentType(.password)
                    }

                    if let errorText {
                        Text(errorText)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }

                    Button(action: submit) {
                        HStack {
                            if busy { ProgressView().tint(.white) }
                            Text(strings.signIn).fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(busy || email.isEmpty || password.isEmpty)
                    .opacity(busy || email.isEmpty || password.isEmpty ? 0.6 : 1)
                }
                .padding(.top, 8)

                Link(strings.t("auth.signIn.forgotPassword"),
                     destination: BackendConfig.siteURL.appendingPathComponent("forgot-password"))
                    .font(.footnote)

                Divider().padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text(strings.t("auth.signIn.newHereHeading")).font(.subheadline.weight(.semibold))
                    Text(strings.t("auth.signIn.newHereBody")).font(.footnote).foregroundColor(.secondary)
                    // Accounts are made on the website, which also sends the confirmation email and
                    // handles the link in it. Signing in with one made there works here the same.
                    Link(strings.t("auth.signIn.createAccount"),
                         destination: BackendConfig.siteURL.appendingPathComponent("sign-up"))
                        .font(.footnote.weight(.semibold))
                }
            }
            .padding(.horizontal, 24)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func field<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.footnote.weight(.medium)).foregroundColor(.secondary)
            content()
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }

    private func submit() {
        errorText = nil
        busy = true
        Task {
            do {
                try await store.signIn(email: email, password: password)
            } catch {
                errorText = error.localizedDescription
            }
            busy = false
        }
    }
}
