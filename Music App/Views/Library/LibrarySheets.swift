import SwiftUI

struct HistorySheet: View {
    @ObservedObject var historyStore: HistoryStore
    @ObservedObject var player: PlayerStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            HomeBackground().ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Listening history")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.secondary)
                }

                if historyStore.entries.isEmpty {
                    Text("Nothing yet.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 12) {
                            ForEach(historyStore.entries) { entry in
                                Button {
                                    player.play(entry.track)
                                } label: {
                                    HStack(spacing: 12) {
                                        AlbumArt(seed: entry.track.artSeed, size: 52)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(entry.track.title)
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundStyle(.primary)
                                                .lineLimit(1)
                                            Text(entry.track.subtitle)
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundStyle(.secondary)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                        Text(entry.playedAt.relativeTimeShort)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.vertical, 6)
                                }
                                .buttonStyle(.plain)
                            }

                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                    historyStore.clear()
                                }
                            } label: {
                                Text("Clear history")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Capsule().fill(.ultraThinMaterial))
                                    .overlay(Capsule().stroke(.white.opacity(0.12), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 18)
            .padding(.bottom, 18)
        }
    }
}

struct CreatePlaylistSheet: View {
    @ObservedObject var libraryStore: LibraryStore
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""

    var body: some View {
        ZStack {
            HomeBackground().ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Create playlist")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Button("Cancel") { dismiss() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.secondary)
                }

                SearchBarPlain(text: $name, placeholder: "Playlist name")

                Button {
                    libraryStore.createPlaylist(name: name)
                    dismiss()
                } label: {
                    Text("Create")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.thinMaterial))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(.white.opacity(0.12), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .disabled(name.trimmed.isEmpty)
                .opacity(name.trimmed.isEmpty ? 0.5 : 1)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 18)
            .padding(.bottom, 18)
        }
    }
}

struct RenamePlaylistSheet: View {
    @Binding var titleText: String
    let onCancel: () -> Void
    let onSave: () -> Void
    let onDelete: () -> Void

    var body: some View {
        ZStack {
            HomeBackground().ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Playlist options")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Button("Done") { onCancel() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.secondary)
                }

                Text("Rename")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.secondary)

                SearchBarPlain(text: $titleText, placeholder: "Playlist name")

                Button(action: onSave) {
                    Text("Save name")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.thinMaterial))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(.white.opacity(0.12), lineWidth: 1))
                }
                .buttonStyle(.plain)

                Button(role: .destructive, action: onDelete) {
                    Text("Delete playlist")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.red.opacity(0.30)))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.red.opacity(0.35), lineWidth: 1))
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 18)
            .padding(.bottom, 18)
        }
    }
}

struct AddFromHistorySheet: View {
    @ObservedObject var historyStore: HistoryStore
    let onPick: (Track) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            HomeBackground().ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Add from History")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.secondary)
                }

                if historyStore.entries.isEmpty {
                    Text("Play something first and it’ll show up here.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 12) {
                            ForEach(historyStore.entries) { entry in
                                Button {
                                    onPick(entry.track)
                                    dismiss()
                                } label: {
                                    HStack(spacing: 12) {
                                        AlbumArt(seed: entry.track.artSeed, size: 52)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(entry.track.title)
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundStyle(.primary)
                                                .lineLimit(1)
                                            Text(entry.track.subtitle)
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundStyle(.secondary)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.vertical, 6)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 18)
            .padding(.bottom, 18)
        }
    }
}
