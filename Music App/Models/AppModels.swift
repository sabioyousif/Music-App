import Foundation

struct Track: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let subtitle: String
    let isExplicit: Bool
    let artSeed: Int

    init(id: UUID = UUID(), title: String, subtitle: String, isExplicit: Bool, artSeed: Int) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isExplicit = isExplicit
        self.artSeed = artSeed
    }
}

struct Artist: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let artSeed: Int

    init(id: UUID = UUID(), name: String, artSeed: Int) {
        self.id = id
        self.name = name
        self.artSeed = artSeed
    }
}

enum AppTab: String, CaseIterable, Identifiable, Codable {
    case home = "Home"
    case search = "Search"
    case library = "Library"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .library: return "books.vertical.fill"
        }
    }
}

struct HistoryEntry: Identifiable, Hashable, Codable {
    let id: UUID
    let track: Track
    let playedAt: Date

    init(id: UUID = UUID(), track: Track, playedAt: Date) {
        self.id = id
        self.track = track
        self.playedAt = playedAt
    }
}

enum SearchItemKind: String, Codable {
    case song = "Song"
    case artist = "Artist"

    var icon: String {
        switch self {
        case .song: return "play.square"
        case .artist: return "person.crop.circle"
        }
    }
}

struct RecentSearchItem: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var kind: SearchItemKind
    var secondary: String
    var isExplicit: Bool
    var artSeed: Int
    var supportsAdd: Bool
    var isAdded: Bool

    init(
        id: UUID = UUID(),
        title: String,
        kind: SearchItemKind,
        secondary: String,
        isExplicit: Bool,
        artSeed: Int,
        supportsAdd: Bool,
        isAdded: Bool
    ) {
        self.id = id
        self.title = title
        self.kind = kind
        self.secondary = secondary
        self.isExplicit = isExplicit
        self.artSeed = artSeed
        self.supportsAdd = supportsAdd
        self.isAdded = isAdded
    }
}

enum TopResult: Hashable {
    case song(Track)
    case artist(Artist)
}

struct SearchResults {
    var top: TopResult?
    var songs: [Track] = []
    var artists: [Artist] = []
}

struct Playlist: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var owner: String
    var tracks: [Track]

    init(id: UUID = UUID(), name: String, owner: String, tracks: [Track]) {
        self.id = id
        self.name = name
        self.owner = owner
        self.tracks = tracks
    }

    var trackCountText: String {
        "\(tracks.count) TRACK" + (tracks.count == 1 ? "" : "S")
    }
}

enum PlaylistSort: String, CaseIterable, Identifiable, Codable {
    case recentlyAdded = "Recently added"
    case nameAZ = "Name (A–Z)"
    case mostTracks = "Most tracks"

    var id: String { rawValue }
}
