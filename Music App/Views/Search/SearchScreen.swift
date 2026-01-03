import SwiftUI

struct SearchScreen: View {
    @ObservedObject var player: PlayerStore
    @ObservedObject var searchStore: SearchStore
    let focusNonce: Int

    @State private var query: String = ""
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: true) {

                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .center, spacing: 10) {
                        SearchBar(
                            text: $query,
                            isFocused: $isSearchFocused,
                            placeholder: "What do you want to listen to?"
                        )

                        if isSearchFocused {
                            Button {
                                withAnimation(.easeOut(duration: 0.12)) { isSearchFocused = false }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white.opacity(0.85))
                                    .frame(width: 44, height: 44)
                                    .background(LiquidGlassSurface(cornerRadius: 14, tintOpacity: 0.28))
                            }
                            .buttonStyle(.plain)
                            .transition(.opacity.combined(with: .scale(scale: 0.96)))
                        }
                    }
                    .padding(.top, 8)

                    if query.trimmed.isEmpty {
                        if searchStore.recents.isEmpty {
                            VStack(spacing: 10) {
                                Spacer(minLength: 0)

                                Text("Play what you love")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.white)

                                Text("Search for artists, songs, and more")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white.opacity(0.65))
                                    .multilineTextAlignment(.center)

                                Spacer(minLength: 0)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: max(240, proxy.size.height - 240))
                            .padding(.top, 6)
                        } else {
                            Text("Recent searches")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.top, 4)

                            VStack(spacing: 14) {
                                ForEach(searchStore.recents) { item in
                                    RecentSearchRow(
                                        item: item,
                                        onToggleAdd: { id in
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                                searchStore.toggleAdd(id: id)
                                            }
                                        },
                                        onRemove: { id in
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                                searchStore.removeRecent(id: id)
                                            }
                                        },
                                        onTap: { tapped in
                                            if tapped.kind == .song {
                                                player.play(
                                                    Track(
                                                        title: tapped.title,
                                                        subtitle: tapped.secondary.isEmpty ? "Unknown Artist" : tapped.secondary,
                                                        isExplicit: tapped.isExplicit,
                                                        artSeed: tapped.artSeed
                                                    )
                                                )
                                            }
                                        }
                                    )
                                }

                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                        searchStore.clearRecents()
                                    }
                                } label: {
                                    Text("Clear recent searches")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(.white.opacity(0.78))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            Capsule()
                                                .fill(Color.white.opacity(0.06))
                                                .overlay(Capsule().stroke(Color.white.opacity(0.10), lineWidth: 1))
                                        )
                                }
                                .buttonStyle(.plain)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 8)
                            }
                        }
                    } else {
                        let results = buildResults(for: query)

                        Text("Top result")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.top, 6)

                        if let top = results.top {
                            TopResultCard(top: top) { tapped in
                                switch tapped {
                                case .song(let track):
                                    player.play(track)
                                case .artist(let artist):
                                    player.play(Track(title: artist.name, subtitle: "Artist", isExplicit: false, artSeed: artist.artSeed))
                                }
                            }
                        } else {
                            Text("No results")
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.vertical, 12)
                        }

                        if !results.songs.isEmpty {
                            ResultsHeader(title: "Songs")
                            VStack(spacing: 12) {
                                ForEach(results.songs) { track in
                                    SongResultRow(track: track) { player.play(track) }
                                }
                            }
                        }

                        if !results.artists.isEmpty {
                            ResultsHeader(title: "Artists")
                            VStack(spacing: 12) {
                                ForEach(results.artists) { artist in
                                    ArtistResultRow(artist: artist) { }
                                }
                            }
                        }
                    }

                    Spacer(minLength: 260)
                }
                .padding(.horizontal, 16)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .onAppear { requestSearchFocus() }
        .onChange(of: focusNonce) { _ in requestSearchFocus() }
    }

    private func requestSearchFocus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isSearchFocused = true
        }
    }

    private func buildResults(for rawQuery: String) -> SearchResults {
        let q = rawQuery.trimmed.lowercased()

        let songMatches = DemoData.catalogSongs
            .filter { $0.title.lowercased().contains(q) || $0.subtitle.lowercased().contains(q) }
            .prefix(6)

        let artistMatches = DemoData.catalogArtists
            .filter { $0.name.lowercased().contains(q) }
            .prefix(6)

        var out = SearchResults()
        out.songs = Array(songMatches)
        out.artists = Array(artistMatches)

        if let bestSong = out.songs.first {
            out.top = .song(bestSong)
        } else if let bestArtist = out.artists.first {
            out.top = .artist(bestArtist)
        }

        return out
    }
}
