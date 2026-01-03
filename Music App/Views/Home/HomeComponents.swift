import SwiftUI

struct TopHeader: View {
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    Circle().fill(Color.red.opacity(0.95)).frame(width: 28, height: 28)
                    Image(systemName: "play.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(x: 1)
                }

                Text("Music")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
            }

            Spacer()

            IconButtonWithBadge(icon: "bell", badge: "9") { }
            IconButton(icon: "magnifyingglass") { }

            ZStack {
                Circle().fill(Color.orange.opacity(0.75)).frame(width: 34, height: 34)
                Text("S")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.top, 8)
    }
}

struct IconButton: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.92))
                .frame(width: 34, height: 34)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct IconButtonWithBadge: View {
    let icon: String
    let badge: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.92))
                    .frame(width: 34, height: 34)

                Text(badge)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.red))
                    .offset(x: 6, y: -4)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct ChipRow: View {
    let chips: [String]
    @Binding var selected: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(chips, id: \.self) { chip in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) { selected = chip }
                    } label: {
                        Text(chip)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white.opacity(selected == chip ? 0.95 : 0.85))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(selected == chip ? 0.14 : 0.10))
                                    .overlay(Capsule().stroke(Color.white.opacity(0.09), lineWidth: 1))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

struct SectionHeader: View {
    let title: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Button(action: action) {
                Text(buttonTitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.06))
                            .overlay(Capsule().stroke(Color.white.opacity(0.10), lineWidth: 1))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 6)
    }
}

struct QuickPicksSnappingCarousel: View {
    let tracks: [Track]
    let onTapTrack: (Track) -> Void

    private var pages: [[Track]] {
        var result: [[Track]] = []
        var current: [Track] = []
        for track in tracks {
            current.append(track)
            if current.count == 4 {
                result.append(current)
                current = []
            }
        }
        if !current.isEmpty { result.append(current) }
        return result
    }

    var body: some View {
        GeometryReader { geo in
            let containerWidth = geo.size.width
            let pageWidth = max(280, containerWidth * 0.86)
            let trailingPeek = max(18, containerWidth - pageWidth)

            Group {
                if #available(iOS 17.0, *) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 14) {
                            ForEach(Array(pages.enumerated()), id: \.offset) { _, pageTracks in
                                VStack(spacing: 10) {
                                    ForEach(pageTracks) { track in
                                        TrackRow(track: track) { onTapTrack(track) }
                                    }
                                }
                                .frame(width: pageWidth, alignment: .leading)
                                .scrollTargetLayout()
                            }
                        }
                        .padding(.horizontal, 2)
                        .padding(.trailing, trailingPeek)
                    }
                    .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                    .scrollClipDisabled()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(Array(pages.enumerated()), id: \.offset) { _, pageTracks in
                                VStack(spacing: 10) {
                                    ForEach(pageTracks) { track in
                                        TrackRow(track: track) { onTapTrack(track) }
                                    }
                                }
                                .frame(width: pageWidth, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, 2)
                        .padding(.trailing, trailingPeek)
                    }
                }
            }
        }
        .frame(height: 4 * 64 + 3 * 10)
    }
}

struct TrackRow: View {
    let track: Track
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AlbumArt(seed: track.artSeed, size: 52)
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    HStack(spacing: 6) {
                        if track.isExplicit { ExplicitBadge() }
                        Text(track.subtitle)
                            .font(.system(size: 16))
                            .foregroundStyle(.white.opacity(0.65))
                            .lineLimit(1)
                    }
                }
                Spacer()
                Image(systemName: "ellipsis.vertical")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(width: 30, height: 30)
            }
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
