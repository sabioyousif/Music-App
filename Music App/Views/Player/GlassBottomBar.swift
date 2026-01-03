import SwiftUI

struct GlassBottomBar: View {
    @Binding var selection: AppTab
    var onRetap: (AppTab) -> Void

    var body: some View {
        HStack(spacing: 6) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    if selection == tab {
                        onRetap(tab)
                    } else {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            selection = tab
                        }
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .symbolRenderingMode(.hierarchical)

                        Text(tab.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        ZStack {
                            if selection == tab {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                            }
                        }
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .foregroundStyle(selection == tab ? Color.white : Color.white.opacity(0.70))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(LiquidGlassSurface(cornerRadius: 22, tintOpacity: 0.30))
    }
}
