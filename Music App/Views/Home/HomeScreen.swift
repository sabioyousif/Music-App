import SwiftUI

struct HomeScreen: View {
    let chips: [String]
    @Binding var selectedChip: String
    let quickPicks: [Track]
    let trending: [Track]
    @ObservedObject var player: PlayerStore

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                TopHeader()

                ChipRow(chips: chips, selected: $selectedChip)

                SectionHeader(title: "Quick picks", buttonTitle: "Play all") { }

                QuickPicksSnappingCarousel(
                    tracks: quickPicks,
                    onTapTrack: { track in player.play(track) }
                )

                SectionHeader(title: "Trending songs for you", buttonTitle: "Play all") { }

                VStack(spacing: 10) {
                    ForEach(trending) { track in
                        TrackRow(track: track) { player.play(track) }
                    }
                }

                Spacer(minLength: 260)
            }
            .padding(.top, 10)
            .padding(.horizontal, 16)
        }
    }
}
