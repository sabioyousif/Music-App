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
                        .foregroundStyle(.white)
                    Spacer()
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.85))
                }

                if historyStore.entries.isEmpty {
                    Text("Nothing yet.")
                        .foregroundStyle(.white.opacity(0.65))
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
                                                .foregroundStyle(.white)
                                                .lineLimit(1)
                                            Text(entry.track.subtitle)
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundStyle(.white.opacity(0.65))
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                        Text(entry.playedAt.relativeTimeShort)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundStyle(.white.opacity(0.55))
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
                                    .foregroundStyle(.white.opacity(0.78))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Capsule().fill(Color.white.opacity(0.06)))
                                    .overlay(Capsule().stroke(Color.white.opacity(0.10), lineWidth: 1))
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
                        .foregroundStyle(.white)
                    Spacer()
                    Button("Cancel") { dismiss() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.75))
                }

                SearchBarPlain(text: $name, placeholder: "Playlist name")

                Button {
                    libraryStore.createPlaylist(name: name)
                    dismiss()
                } label: {
                    Text("Create")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white.opacity(0.10)))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.white.opacity(0.10), lineWidth: 1))
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
                        .foregroundStyle(.white)
                    Spacer()
                    Button("Done") { onCancel() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.75))
                }

                Text("Rename")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white.opacity(0.75))

                SearchBarPlain(text: $titleText, placeholder: "Playlist name")

                Button(action: onSave) {
                    Text("Save name")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white.opacity(0.10)))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.white.opacity(0.10), lineWidth: 1))
                }
                .buttonStyle(.plain)

                Button(role: .destructive, action: onDelete) {
                    Text("Delete playlist")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
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
                        .foregroundStyle(.white)
                    Spacer()
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.75))
                }

                if historyStore.entries.isEmpty {
                    Text("Play something first and it’ll show up here.")
                        .foregroundStyle(.white.opacity(0.65))
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
                                                .foregroundStyle(.white)
                                                .lineLimit(1)
                                            Text(entry.track.subtitle)
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundStyle(.white.opacity(0.65))
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(.white.opacity(0.75))
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
