import SwiftUI

struct MiniPlayer: View {
    @ObservedObject var player: PlayerStore

    var body: some View {
        HStack(spacing: 12) {
            AlbumArt(seed: player.nowPlaying.artSeed, size: 44)

            VStack(alignment: .leading, spacing: 3) {
                Text(player.nowPlaying.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(player.nowPlaying.subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.65))
                    .lineLimit(1)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "airplayaudio")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)

            Button(action: { player.togglePlayPause() }) {
                Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(LiquidGlassSurface(cornerRadius: 18, tintOpacity: 0.30))
    }
}
