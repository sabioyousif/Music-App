import SwiftUI

struct HomeBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.07, green: 0.07, blue: 0.08), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(colors: [Color.green.opacity(0.18), Color.clear],
                           center: .topLeading, startRadius: 40, endRadius: 320)
                .blendMode(.screen)

            RadialGradient(colors: [Color.purple.opacity(0.16), Color.clear],
                           center: .center, startRadius: 30, endRadius: 360)
                .blendMode(.screen)

            RadialGradient(colors: [Color.blue.opacity(0.14), Color.clear],
                           center: .topTrailing, startRadius: 30, endRadius: 320)
                .blendMode(.screen)
        }
    }
}
