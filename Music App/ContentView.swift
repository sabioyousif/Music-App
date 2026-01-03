import SwiftUI

struct ContentView: View {
    var body: some View {
        AppRootView()
    }
}

#Preview {
    ContentView()
        .environmentObject(HistoryStore())
        .environmentObject(PlayerStore())
        .environmentObject(SearchStore())
        .environmentObject(LibraryStore(seedDemoData: true))
}
