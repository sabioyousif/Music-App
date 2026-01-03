import SwiftUI

struct LiquidGlassSurface: View {
    let cornerRadius: CGFloat
    let tintOpacity: Double

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            if reduceTransparency {
                shape
                    .fill(Color.black.opacity(0.75))
            } else {
                shape
                    .fill(.ultraThinMaterial)
            }

            shape
                .fill(Color.black.opacity(tintOpacity))
                .blendMode(.overlay)

            GlassShine()
                .clipShape(shape)
                .opacity(reduceTransparency ? 0.35 : 0.8)

            GlassNoise()
                .clipShape(shape)
                .opacity(reduceTransparency ? 0.06 : 0.14)

            shape
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.38), Color.white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )

            shape
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
        }
        .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 10)
    }
}

private struct GlassShine: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.26),
                Color.white.opacity(0.06),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blendMode(.screen)
    }
}

private struct GlassNoise: View {
    var body: some View {
        Canvas { context, size in
            let dotCount = Int(size.width * size.height / 320)
            var rng = SeededRandomNumberGenerator(seed: UInt64(size.width * 17 + size.height * 19))

            for _ in 0..<dotCount {
                let x = Double.random(in: 0...size.width, using: &rng)
                let y = Double.random(in: 0...size.height, using: &rng)
                let rect = CGRect(x: x, y: y, width: 1, height: 1)
                context.fill(Path(rect), with: .color(.white.opacity(0.12)))
            }
        }
        .blendMode(.softLight)
    }
}

private struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed == 0 ? 0x4d595df4d0f33173 : seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}
