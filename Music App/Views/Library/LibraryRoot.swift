import SwiftUI

struct LibraryRoot: View {
    @ObservedObject var player: PlayerStore
    @ObservedObject var historyStore: HistoryStore
    @ObservedObject var libraryStore: LibraryStore

    @State private var librarySearchQuery: String = ""
    @State private var isSearching: Bool = false

    @State private var showCreateSheet: Bool = false
    @State private var showRenameSheet: Bool = false
    @State private var renameTarget: Playlist?
    @State private var renameText: String = ""

    @State private var showMoreMenu: Bool = false
    @State private var showHistorySheet: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center) {
                        Text("Playlists")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.white)

                        Spacer()

                        LibraryTopPill(
                            onSearch: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                    isSearching.toggle()
                                }
                                if !isSearching { librarySearchQuery = "" }
                            },
                            sort: $libraryStore.sort,
                            onMore: { showMoreMenu = true }
                        )
                    }
                    .padding(.top, 8)

                    if isSearching {
                        SearchBarPlain(
                            text: $librarySearchQuery,
                            placeholder: "Search playlists"
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    Button {
                        showCreateSheet = true
                    } label: {
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white.opacity(0.10))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundStyle(.white.opacity(0.9))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )

                            Text("Create…")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.92))

                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.plain)

                    VStack(spacing: 18) {
                        ForEach(libraryStore.sortedPlaylists(searchQuery: librarySearchQuery)) { playlist in
                            NavigationLink(value: playlist) {
                                PlaylistRow(
                                    playlist: playlist,
                                    onMore: {
                                        renameTarget = playlist
                                        renameText = playlist.name
                                        showRenameSheet = true
                                    }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer(minLength: 260)
                }
                .padding(.horizontal, 16)
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationBarHidden(true)
            .navigationDestination(for: Playlist.self) { playlist in
                PlaylistDetail(
                    playlist: playlist,
                    player: player,
                    historyStore: historyStore,
                    libraryStore: libraryStore
                )
            }
            .confirmationDialog("Library", isPresented: $showMoreMenu, titleVisibility: .visible) {
                Button("View listening history") { showHistorySheet = true }
                Button("Clear listening history", role: .destructive) { historyStore.clear() }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $showHistorySheet) {
                HistorySheet(historyStore: historyStore, player: player)
            }
            .sheet(isPresented: $showCreateSheet) {
                CreatePlaylistSheet(libraryStore: libraryStore)
            }
            .sheet(isPresented: $showRenameSheet) {
                RenamePlaylistSheet(
                    titleText: $renameText,
                    onCancel: { showRenameSheet = false },
                    onSave: {
                        if let target = renameTarget {
                            libraryStore.renamePlaylist(target, newName: renameText)
                        }
                        showRenameSheet = false
                    },
                    onDelete: {
                        if let target = renameTarget {
                            libraryStore.deletePlaylist(target)
                        }
                        showRenameSheet = false
                    }
                )
            }
        }
    }
}
