import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: SessionStore

    var body: some View {
        if store.isSignedIn {
            TopicsView()
        } else {
            LoginView()
        }
    }
}
