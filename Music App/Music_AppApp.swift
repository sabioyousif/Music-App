import SwiftUI

@main
struct Music_AppApp: App {
    @StateObject private var historyStore = HistoryStore()
    @StateObject private var playerStore = PlayerStore()
    @StateObject private var searchStore = SearchStore(seedDemoData: true)
    @StateObject private var libraryStore = LibraryStore(seedDemoData: true)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(historyStore)
                .environmentObject(playerStore)
                .environmentObject(searchStore)
                .environmentObject(libraryStore)
        }
    }
}
