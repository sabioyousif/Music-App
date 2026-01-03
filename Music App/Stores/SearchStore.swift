import Foundation
import Combine

final class SearchStore: ObservableObject {
    @Published var recents: [RecentSearchItem]

    init(seedDemoData: Bool = true) {
        if seedDemoData {
            self.recents = DemoData.recentSearches
        } else {
            self.recents = []
        }
    }

    func clearRecents() {
        recents.removeAll()
    }

    func removeRecent(id: UUID) {
        recents.removeAll { $0.id == id }
    }

    func toggleAdd(id: UUID) {
        guard let idx = recents.firstIndex(where: { $0.id == id }) else { return }
        recents[idx].isAdded.toggle()
    }
}
