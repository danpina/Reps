import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: SessionStore

    var body: some View {
        Group {
            if !store.isSignedIn {
                LoginView()
            } else if store.needsOnboarding == true {
                WelcomeView()
            } else if store.needsOnboarding == nil {
                // The profile is on its way; it says whether onboarding is still to do.
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                MainTabView()
            }
        }
        // The appearance is stored on the account, so it follows the reader to any device.
        .preferredColorScheme(store.colorScheme)
    }
}
