import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var historyStore: HistoryStore
    @EnvironmentObject private var playerStore: PlayerStore
    @EnvironmentObject private var searchStore: SearchStore
    @EnvironmentObject private var libraryStore: LibraryStore

    var body: some View {
        UIKitTabBarControllerRepresentable(
            historyStore: historyStore,
            playerStore: playerStore,
            searchStore: searchStore,
            libraryStore: libraryStore
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
        .environmentObject(HistoryStore())
        .environmentObject(PlayerStore())
        .environmentObject(SearchStore())
        .environmentObject(LibraryStore(seedDemoData: true))
}
