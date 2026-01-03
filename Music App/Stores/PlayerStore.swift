import Foundation

final class PlayerStore: ObservableObject {
    @Published var nowPlaying: Track
    @Published var isPlaying: Bool = true

    var onPlay: ((Track) -> Void)?

    init(nowPlaying: Track = DemoData.initialNowPlaying) {
        self.nowPlaying = nowPlaying
    }

    func play(_ track: Track) {
        nowPlaying = track
        isPlaying = true
        onPlay?(track)
    }

    func togglePlayPause() {
        isPlaying.toggle()
    }
}
