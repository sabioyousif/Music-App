import Foundation
import Combine
import SwiftUI

final class LibraryStore: ObservableObject {
    private static let playlistsKey = "library.playlists"
    private static let sortKey = "library.sort"

    @Published var playlists: [Playlist] = [] {
        didSet { persistPlaylists() }
    }

    @Published var sort: PlaylistSort = .recentlyAdded {
        didSet { persistSort() }
    }

    init(seedDemoData: Bool = true) {
        if let stored: [Playlist] = PersistenceStore.load([Playlist].self, key: Self.playlistsKey) {
            playlists = stored
        } else if seedDemoData {
            playlists = DemoData.demoPlaylists
            persistPlaylists()
        }

        if let storedSort: PlaylistSort = PersistenceStore.load(PlaylistSort.self, key: Self.sortKey) {
            sort = storedSort
        }
    }

    func createPlaylist(name: String, owner: String = "you") {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        playlists.insert(Playlist(name: trimmed, owner: owner, tracks: []), at: 0)
    }

    func deletePlaylist(_ playlist: Playlist) {
        playlists.removeAll { $0.id == playlist.id }
    }

    func renamePlaylist(_ playlist: Playlist, newName: String) {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard let idx = playlists.firstIndex(where: { $0.id == playlist.id }) else { return }
        playlists[idx].name = trimmed
    }

    func addTrack(_ track: Track, to playlist: Playlist) {
        guard let idx = playlists.firstIndex(where: { $0.id == playlist.id }) else { return }
        playlists[idx].tracks.append(track)
    }

    func removeTrack(at offsets: IndexSet, from playlist: Playlist) {
        guard let idx = playlists.firstIndex(where: { $0.id == playlist.id }) else { return }
        playlists[idx].tracks.remove(atOffsets: offsets)
    }

    func sortedPlaylists(searchQuery: String) -> [Playlist] {
        let q = searchQuery.trimmed.lowercased()

        var filtered = playlists
        if !q.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(q) }
        }

        switch sort {
        case .recentlyAdded:
            return filtered
        case .nameAZ:
            return filtered.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .mostTracks:
            return filtered.sorted { $0.tracks.count > $1.tracks.count }
        }
    }

    private func persistPlaylists() {
        PersistenceStore.save(playlists, key: Self.playlistsKey)
    }

    private func persistSort() {
        PersistenceStore.save(sort, key: Self.sortKey)
    }
}
