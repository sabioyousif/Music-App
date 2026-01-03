import SwiftUI

struct PlaylistDetail: View {
    let playlist: Playlist
    @ObservedObject var player: PlayerStore
    @ObservedObject var historyStore: HistoryStore
    @ObservedObject var libraryStore: LibraryStore

    @State private var showAddFromHistory: Bool = false

    private var resolvedPlaylist: Playlist {
        libraryStore.playlists.first(where: { $0.id == playlist.id }) ?? playlist
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                }

                PlaylistMosaicCover(tracks: resolvedPlaylist.tracks, size: 160)
                    .padding(.top, 8)

                Text(resolvedPlaylist.name)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 4)

                Text("by \(resolvedPlaylist.owner) • \(resolvedPlaylist.trackCountText)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Button {
                        if let first = resolvedPlaylist.tracks.first {
                            player.play(first)
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("Play")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(.thinMaterial))
                        .overlay(Capsule().stroke(.white.opacity(0.12), lineWidth: 1))
                    }
                    .buttonStyle(.plain)

                    Button {
                        showAddFromHistory = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                            Text("Add from History")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(.ultraThinMaterial))
                        .overlay(Capsule().stroke(.white.opacity(0.12), lineWidth: 1))
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .padding(.top, 4)

                if resolvedPlaylist.tracks.isEmpty {
                    Text("No tracks yet")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.top, 14)
                } else {
                    VStack(spacing: 10) {
                        ForEach(resolvedPlaylist.tracks) { track in
                            TrackRow(track: track) { player.play(track) }
                        }
                    }
                    .padding(.top, 8)
                }

                Spacer(minLength: 260)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddFromHistory) {
            AddFromHistorySheet(
                historyStore: historyStore,
                onPick: { picked in
                    libraryStore.addTrack(picked, to: resolvedPlaylist)
                }
            )
        }
    }
}
