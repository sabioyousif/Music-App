import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var historyStore: HistoryStore
    @EnvironmentObject private var player: PlayerStore
    @EnvironmentObject private var searchStore: SearchStore
    @EnvironmentObject private var libraryStore: LibraryStore

    @State private var tab: AppTab = .home
    @State private var selectedChip: String = DemoData.homeChips.first ?? "Podcasts"
    @State private var searchFocusNonce: Int = 0
    @State private var didSetup = false

    var body: some View {
        ZStack {
            HomeBackground().ignoresSafeArea()

            Group {
                switch tab {
                case .home:
                    HomeScreen(
                        chips: DemoData.homeChips,
                        selectedChip: $selectedChip,
                        quickPicks: DemoData.quickPicks,
                        trending: DemoData.trending,
                        player: player
                    )
                case .search:
                    SearchScreen(
                        player: player,
                        searchStore: searchStore,
                        focusNonce: searchFocusNonce
                    )
                case .library:
                    LibraryRoot(
                        player: player,
                        historyStore: historyStore,
                        libraryStore: libraryStore
                    )
                }
            }
        }
        .onAppear {
            guard !didSetup else { return }
            didSetup = true
            player.onPlay = { track in
                historyStore.recordPlay(track)
            }
        }
        .onChange(of: tab) { newValue in
            if newValue == .search { searchFocusNonce += 1 }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 10) {
                MiniPlayer(player: player)
                GlassBottomBar(
                    selection: $tab,
                    onRetap: { tapped in
                        if tapped == .search { searchFocusNonce += 1 }
                    }
                )
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 8)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
