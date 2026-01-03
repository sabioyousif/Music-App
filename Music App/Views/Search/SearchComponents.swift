import SwiftUI

struct ResultsHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(.primary)
            .padding(.top, 10)
    }
}

struct TopResultCard: View {
    let top: TopResult
    let onTap: (TopResult) -> Void

    var body: some View {
        Button {
            onTap(top)
        } label: {
            HStack(spacing: 12) {
                switch top {
                case .song(let track):
                    AlbumArt(seed: track.artSeed, size: 64)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(track.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        HStack(spacing: 8) {
                            if track.isExplicit { ExplicitBadge() }
                            Text("Song • \(track.subtitle)")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }

                case .artist(let artist):
                    ArtistAvatar(seed: artist.artSeed, size: 64)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(artist.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Text("Artist")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(.thinMaterial)
                        .frame(width: 34, height: 34)

                    Image(systemName: "play.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.primary)
                        .offset(x: 1)
                }
            }
            .padding(12)
            .background(LiquidGlassSurface(cornerRadius: 16, tintOpacity: 0.30))
        }
        .buttonStyle(.plain)
    }
}

struct SongResultRow: View {
    let track: Track
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AlbumArt(seed: track.artSeed, size: 52)

                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    HStack(spacing: 7) {
                        if track.isExplicit { ExplicitBadge() }
                        Image(systemName: "play.square")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.secondary)

                        Text("Song • \(track.subtitle)")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
            }
            .padding(.vertical, 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct ArtistResultRow: View {
    let artist: Artist
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ArtistAvatar(seed: artist.artSeed, size: 52)

                VStack(alignment: .leading, spacing: 4) {
                    Text(artist.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    HStack(spacing: 7) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.secondary)

                        Text("Artist")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 28, height: 28)
            }
            .padding(.vertical, 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct RecentSearchRow: View {
    let item: RecentSearchItem
    let onToggleAdd: (UUID) -> Void
    let onRemove: (UUID) -> Void
    let onTap: (RecentSearchItem) -> Void

    var body: some View {
        Button { onTap(item) } label: {
            HStack(spacing: 12) {
                if item.kind == .artist {
                    ArtistAvatar(seed: item.artSeed, size: 52)
                } else {
                    AlbumArt(seed: item.artSeed, size: 52)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    HStack(spacing: 7) {
                        if item.isExplicit && item.kind == .song { ExplicitBadge() }

                        Image(systemName: item.kind.icon)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.secondary)

                        Text(subtitleLine(for: item))
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 8)

                HStack(spacing: 14) {
                    if item.supportsAdd {
                        Button { onToggleAdd(item.id) } label: {
                            if item.isAdded {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(Color.green.opacity(0.95))
                            } else {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    Button { onRemove(item.id) } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 28, height: 28)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func subtitleLine(for item: RecentSearchItem) -> String {
        switch item.kind {
        case .song: return item.secondary.isEmpty ? "Song" : "Song • \(item.secondary)"
        case .artist: return "Artist"
        }
    }
}
