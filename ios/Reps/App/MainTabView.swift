import SwiftUI

/// The signed-in app: the five places the website's navigation offers.
struct MainTabView: View {
    enum Tab: Hashable {
        case today, learn, log, rehearsals, settings
    }

    @EnvironmentObject private var store: SessionStore
    @StateObject private var library = LibraryStore()
    @State private var tab: Tab = .today

    private var strings: Strings { store.strings }

    var body: some View {
        TabView(selection: $tab) {
            TodayView(goTo: { tab = $0 })
                .tabItem { Label(strings.t("nav.today"), systemImage: "sun.max") }
                .tag(Tab.today)

            TopicsView()
                .tabItem { Label(strings.t("nav.learn"), systemImage: "book") }
                .tag(Tab.learn)

            FieldLogView()
                .tabItem { Label(strings.t("nav.fieldLog"), systemImage: "list.bullet.rectangle") }
                .tag(Tab.log)

            RehearsalsListView(goTo: { tab = $0 })
                .tabItem { Label(strings.t("nav.rehearsals"), systemImage: "bubble.left.and.bubble.right") }
                .tag(Tab.rehearsals)

            SettingsView()
                .tabItem { Label(strings.t("nav.settings"), systemImage: "gearshape") }
                .tag(Tab.settings)
        }
        // One copy of the curriculum and of what the reader has read, shared by every tab, so a
        // lesson read in Learn unlocks the next one everywhere and Today never disagrees with it.
        .environmentObject(library)
        // Re-runs when the account's language arrives after sign-in, so nothing stays in English
        // for a Spanish reader.
        .task(id: store.locale) { await library.load(session: store) }
    }
}
