import SwiftUI

struct ExplicitBadge: View {
    var body: some View {
        Text("E")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(.black.opacity(0.85))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color.white.opacity(0.75)))
    }
}

struct AlbumArt: View {
    let seed: Int
    let size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: palette(for: seed),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        }
        .frame(width: size, height: size)
    }

    private func palette(for seed: Int) -> [Color] {
        let palettes: [[Color]] = [
            [Color.purple.opacity(0.9), Color.blue.opacity(0.7)],
            [Color.green.opacity(0.8), Color.teal.opacity(0.7)],
            [Color.orange.opacity(0.85), Color.red.opacity(0.7)],
            [Color.indigo.opacity(0.85), Color.pink.opacity(0.6)],
            [Color.gray.opacity(0.8), Color.black.opacity(0.7)],
            [Color.cyan.opacity(0.75), Color.blue.opacity(0.75)],
            [Color.yellow.opacity(0.75), Color.orange.opacity(0.75)],
            [Color.mint.opacity(0.75), Color.green.opacity(0.75)],
            [Color.white.opacity(0.20), Color.white.opacity(0.06)],
            [Color.blue.opacity(0.40), Color.black.opacity(0.60)],
            [Color.pink.opacity(0.35), Color.purple.opacity(0.45)]
        ]
        return palettes[abs(seed) % palettes.count]
    }
}

struct ArtistAvatar: View {
    let seed: Int
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.20), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Image(systemName: "person.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(width: size, height: size)
        .overlay(Circle().stroke(Color.white.opacity(0.10), lineWidth: 1))
    }
}
