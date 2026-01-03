import Foundation

enum DemoData {
    static let homeChips: [String] = [
        "Podcasts", "Relax", "Sleep", "Energize", "Sad", "Romance", "Focus", "Workout"
    ]

    static let quickPicks: [Track] = [
        Track(title: "Feel It", subtitle: "d4vd • 179M plays", isExplicit: false, artSeed: 1),
        Track(title: "7AM", subtitle: "Lil Uzi Vert • 83M plays", isExplicit: true, artSeed: 2),
        Track(title: "We R Who We R", subtitle: "Kesha • 305M plays", isExplicit: false, artSeed: 3),
        Track(title: "FUK SUMN", subtitle: "¥$, Kanye West & Ty Dolla $ign • 4…", isExplicit: true, artSeed: 4),
        Track(title: "What You Saying", subtitle: "Lil Uzi Vert • 4.7M plays", isExplicit: false, artSeed: 5),
        Track(title: "Sugar On My Tongue", subtitle: "Tyler, The Creator • 87M plays", isExplicit: true, artSeed: 6),
        Track(title: "DJ Got Us Fallin' in Love", subtitle: "Usher • 639K views", isExplicit: false, artSeed: 8),
        Track(title: "Another Track", subtitle: "Random Artist • 12M plays", isExplicit: false, artSeed: 9)
    ]

    static let trending: [Track] = [
        Track(title: "What You Saying", subtitle: "Lil Uzi Vert • 4.7M plays", isExplicit: false, artSeed: 5),
        Track(title: "Sugar On My Tongue", subtitle: "Tyler, The Creator • 87M plays", isExplicit: true, artSeed: 6),
        Track(title: "DJ Got Us Fallin' in Love (Almighty ra…)", subtitle: "Usher • 639K views", isExplicit: false, artSeed: 8),
        Track(title: "One More Hit", subtitle: "Artist Name • 22M plays", isExplicit: false, artSeed: 10)
    ]

    static let catalogSongs: [Track] = [
        Track(title: "What You Saying", subtitle: "Lil Uzi Vert", isExplicit: false, artSeed: 5),
        Track(title: "Dernière danse", subtitle: "Indila", isExplicit: false, artSeed: 11),
        Track(title: "All I Want for Christmas Is You", subtitle: "Mariah Carey", isExplicit: false, artSeed: 12),
        Track(title: "White Girl", subtitle: "Shy Glizzy", isExplicit: true, artSeed: 14),
        Track(title: "679 (feat. Remy Boyz)", subtitle: "Fetty Wap, Remy Boyz", isExplicit: true, artSeed: 15),
        Track(title: "California Gurls", subtitle: "Katy Perry, Snoop Dogg", isExplicit: false, artSeed: 16),
        Track(title: "Dreams, Fairytales, Fantasies", subtitle: "A$AP Ferg, Brent Faiyaz", isExplicit: true, artSeed: 17),
        Track(title: "House Of Balloons / Glass Table Girls", subtitle: "The Weeknd", isExplicit: true, artSeed: 19)
    ]

    static let catalogArtists: [Artist] = [
        Artist(name: "Stromae", artSeed: 13),
        Artist(name: "Lil Uzi Vert", artSeed: 22),
        Artist(name: "Indila", artSeed: 23),
        Artist(name: "The Weeknd", artSeed: 24),
        Artist(name: "Mariah Carey", artSeed: 25)
    ]

    static let recentSearches: [RecentSearchItem] = [
        RecentSearchItem(title: "What You Saying", kind: .song, secondary: "Lil Uzi Vert", isExplicit: false, artSeed: 5, supportsAdd: true, isAdded: false),
        RecentSearchItem(title: "Dernière danse", kind: .song, secondary: "Indila", isExplicit: false, artSeed: 11, supportsAdd: true, isAdded: false),
        RecentSearchItem(title: "All I Want for Christmas Is You", kind: .song, secondary: "Mariah Carey", isExplicit: false, artSeed: 12, supportsAdd: true, isAdded: false),
        RecentSearchItem(title: "Stromae", kind: .artist, secondary: "", isExplicit: false, artSeed: 13, supportsAdd: false, isAdded: false),
        RecentSearchItem(title: "White Girl", kind: .song, secondary: "Shy Glizzy", isExplicit: true, artSeed: 14, supportsAdd: true, isAdded: true),
        RecentSearchItem(title: "679 (feat. Remy Boyz)", kind: .song, secondary: "Fetty Wap, Remy Boyz", isExplicit: true, artSeed: 15, supportsAdd: true, isAdded: true),
        RecentSearchItem(title: "California Gurls", kind: .song, secondary: "Katy Perry, Snoop Dogg", isExplicit: false, artSeed: 16, supportsAdd: true, isAdded: false),
        RecentSearchItem(title: "Dreams, Fairytales, Fantasies (feat. Bre…", kind: .song, secondary: "A$AP Ferg, Brent Faiyaz, Salaam Remi", isExplicit: true, artSeed: 17, supportsAdd: true, isAdded: true),
        RecentSearchItem(title: "Dreamin", kind: .song, secondary: "PARTYNEXTDOOR", isExplicit: true, artSeed: 18, supportsAdd: true, isAdded: true),
        RecentSearchItem(title: "House Of Balloons / Glass Table Girls", kind: .song, secondary: "The Weeknd", isExplicit: true, artSeed: 19, supportsAdd: true, isAdded: false)
    ]

    static let demoPlaylists: [Playlist] = {
        let demoTracksA: [Track] = [
            Track(title: "What You Saying", subtitle: "Lil Uzi Vert", isExplicit: false, artSeed: 5),
            Track(title: "Dernière danse", subtitle: "Indila", isExplicit: false, artSeed: 11),
            Track(title: "White Girl", subtitle: "Shy Glizzy", isExplicit: true, artSeed: 14),
            Track(title: "California Gurls", subtitle: "Katy Perry, Snoop Dogg", isExplicit: false, artSeed: 16)
        ]
        let demoTracksB: [Track] = [
            Track(title: "Dreamin", subtitle: "PARTYNEXTDOOR", isExplicit: true, artSeed: 18),
            Track(title: "679 (feat. Remy Boyz)", subtitle: "Fetty Wap, Remy Boyz", isExplicit: true, artSeed: 15)
        ]
        return [
            Playlist(name: "Bop", owner: "User", tracks: demoTracksA + demoTracksB + demoTracksA + demoTracksB),
            Playlist(name: "mfwp", owner: "you", tracks: demoTracksB),
            Playlist(name: "forbidden workout playlist", owner: "User", tracks: demoTracksA + demoTracksB + demoTracksB),
            Playlist(name: "jizz", owner: "you", tracks: demoTracksA + demoTracksA),
            Playlist(name: "wo", owner: "you", tracks: demoTracksA + demoTracksB),
            Playlist(name: "11", owner: "you", tracks: demoTracksB + demoTracksB + demoTracksA)
        ]
    }()

    static let initialNowPlaying = Track(title: "What You Saying", subtitle: "Lil Uzi Vert", isExplicit: false, artSeed: 7)
}
