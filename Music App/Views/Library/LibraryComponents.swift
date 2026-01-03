import SwiftUI

struct LibraryTopPill: View {
    let onSearch: () -> Void
    @Binding var sort: PlaylistSort
    let onMore: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.92))
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(.plain)

            Menu {
                Picker("Sort", selection: $sort) {
                    ForEach(PlaylistSort.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.92))
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(.plain)

            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.92))
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(LiquidGlassSurface(cornerRadius: 22, tintOpacity: 0.30))
    }
}

struct PlaylistRow: View {
    let playlist: Playlist
    let onMore: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            PlaylistMosaicCover(tracks: playlist.tracks, size: 70)

            VStack(alignment: .leading, spacing: 6) {
                Text(playlist.name)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text("by \(playlist.owner)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.65))
                    .lineLimit(1)

                Text(playlist.trackCountText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.55))
            }

            Spacer()

            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.70))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 6)
    }
}

struct PlaylistMosaicCover: View {
    let tracks: [Track]
    let size: CGFloat

    var body: some View {
        let tiles = Array(tracks.prefix(4))
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 1))

            if tiles.isEmpty {
                Image(systemName: "music.note")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white.opacity(0.70))
            } else if tiles.count == 1 {
                AlbumArt(seed: tiles[0].artSeed, size: size)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        mosaicCell(seed: tiles[safe: 0]?.artSeed, cellSize: size / 2)
                        mosaicCell(seed: tiles[safe: 1]?.artSeed, cellSize: size / 2)
                    }
                    HStack(spacing: 0) {
                        mosaicCell(seed: tiles[safe: 2]?.artSeed, cellSize: size / 2)
                        mosaicCell(seed: tiles[safe: 3]?.artSeed, cellSize: size / 2)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .frame(width: size, height: size)
    }

    private func mosaicCell(seed: Int?, cellSize: CGFloat) -> some View {
        Group {
            if let seed {
                AlbumArt(seed: seed, size: cellSize)
            } else {
                Rectangle().fill(Color.white.opacity(0.05))
            }
        }
        .frame(width: cellSize, height: cellSize)
    }
}
