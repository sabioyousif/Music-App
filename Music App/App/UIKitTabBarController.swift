import SwiftUI
import UIKit

final class SearchFocusCoordinator: ObservableObject {
    @Published var nonce: Int = 0
}

final class MusicTabBarController: UITabBarController, UITabBarControllerDelegate {
    private let historyStore: HistoryStore
    private let playerStore: PlayerStore
    private let searchStore: SearchStore
    private let libraryStore: LibraryStore
    private let searchFocusCoordinator = SearchFocusCoordinator()

    init(
        historyStore: HistoryStore,
        playerStore: PlayerStore,
        searchStore: SearchStore,
        libraryStore: LibraryStore
    ) {
        self.historyStore = historyStore
        self.playerStore = playerStore
        self.searchStore = searchStore
        self.libraryStore = libraryStore
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureTabBarAppearance()
        configureTabs()
        playerStore.onPlay = { [weak historyStore] track in
            historyStore?.recordPlay(track)
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 1 {
            searchFocusCoordinator.nonce += 1
        }
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.35)

        let normal = appearance.stackedLayoutAppearance.normal
        normal.iconColor = UIColor.secondaryLabel
        normal.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]

        let selected = appearance.stackedLayoutAppearance.selected
        selected.iconColor = UIColor.label
        selected.titleTextAttributes = [.foregroundColor: UIColor.label]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.compactAppearance = appearance
        tabBar.isTranslucent = true
    }

    private func configureTabs() {
        let home = UIHostingController(
            rootView: HomeTabRoot(player: playerStore)
        )
        home.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        home.tabBarItem.tag = 0

        let search = UIHostingController(
            rootView: SearchTabRoot(
                player: playerStore,
                searchStore: searchStore,
                focusCoordinator: searchFocusCoordinator
            )
        )
        search.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        search.tabBarItem.tag = 1

        let library = UIHostingController(
            rootView: LibraryTabRoot(
                player: playerStore,
                historyStore: historyStore,
                libraryStore: libraryStore
            )
        )
        library.tabBarItem = UITabBarItem(
            title: "Library",
            image: UIImage(systemName: "rectangle.stack"),
            selectedImage: UIImage(systemName: "rectangle.stack.fill")
        )
        library.tabBarItem.tag = 2

        viewControllers = [home, search, library]
    }
}

struct UIKitTabBarControllerRepresentable: UIViewControllerRepresentable {
    let historyStore: HistoryStore
    let playerStore: PlayerStore
    let searchStore: SearchStore
    let libraryStore: LibraryStore

    func makeUIViewController(context: Context) -> MusicTabBarController {
        MusicTabBarController(
            historyStore: historyStore,
            playerStore: playerStore,
            searchStore: searchStore,
            libraryStore: libraryStore
        )
    }

    func updateUIViewController(_ uiViewController: MusicTabBarController, context: Context) {}
}

struct TabScreenContainer<Content: View>: View {
    @ObservedObject var player: PlayerStore
    let content: Content

    init(player: PlayerStore, @ViewBuilder content: () -> Content) {
        self.player = player
        self.content = content()
    }

    var body: some View {
        ZStack {
            HomeBackground().ignoresSafeArea()
            content
        }
        .safeAreaInset(edge: .bottom) {
            MiniPlayer(player: player)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct HomeTabRoot: View {
    @State private var selectedChip: String = DemoData.homeChips.first ?? "Podcasts"
    @ObservedObject var player: PlayerStore

    var body: some View {
        TabScreenContainer(player: player) {
            HomeScreen(
                chips: DemoData.homeChips,
                selectedChip: $selectedChip,
                quickPicks: DemoData.quickPicks,
                trending: DemoData.trending,
                player: player
            )
        }
    }
}

struct SearchTabRoot: View {
    @ObservedObject var player: PlayerStore
    @ObservedObject var searchStore: SearchStore
    @ObservedObject var focusCoordinator: SearchFocusCoordinator

    var body: some View {
        TabScreenContainer(player: player) {
            SearchScreen(
                player: player,
                searchStore: searchStore,
                focusNonce: focusCoordinator.nonce
            )
        }
    }
}

struct LibraryTabRoot: View {
    @ObservedObject var player: PlayerStore
    @ObservedObject var historyStore: HistoryStore
    @ObservedObject var libraryStore: LibraryStore

    var body: some View {
        TabScreenContainer(player: player) {
            LibraryRoot(
                player: player,
                historyStore: historyStore,
                libraryStore: libraryStore
            )
        }
    }
}
