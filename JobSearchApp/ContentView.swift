import SwiftUI

struct ContentView: View {
    @StateObject private var favorites = FavoritesStore()
    @StateObject private var applications = ApplicationsStore()

    var body: some View {
        TabView {
            JobsListView()
                .tabItem {
                    Label("Jobs", systemImage: "briefcase.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }

            ApplicationsView()
                .tabItem {
                    Label("Tracker", systemImage: "checklist")
                }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.white, for: .tabBar)

        .environmentObject(favorites)
        .environmentObject(applications)
    }
}
