import Foundation

final class HistoryStore: ObservableObject {
    private static let storageKey = "history.entries"

    @Published private(set) var entries: [HistoryEntry] = [] {
        didSet { persist() }
    }

    init() {
        if let stored: [HistoryEntry] = PersistenceStore.load([HistoryEntry].self, key: Self.storageKey) {
            entries = stored
        }
    }

    func recordPlay(_ track: Track) {
        entries.removeAll { $0.track.id == track.id }
        entries.insert(HistoryEntry(track: track, playedAt: Date()), at: 0)
        if entries.count > 200 { entries = Array(entries.prefix(200)) }
    }

    func clear() {
        entries.removeAll()
    }

    private func persist() {
        PersistenceStore.save(entries, key: Self.storageKey)
    }
}
