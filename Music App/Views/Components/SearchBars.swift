import SwiftUI

struct SearchBarPlain: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
                .submitLabel(.search)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button {
                    withAnimation(.easeOut(duration: 0.12)) { text = "" }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(LiquidGlassSurface(cornerRadius: 14, tintOpacity: 0.25))
    }
}

struct SearchBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let placeholder: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
                .focused(isFocused)
                .submitLabel(.search)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button {
                    withAnimation(.easeOut(duration: 0.12)) { text = "" }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(LiquidGlassSurface(cornerRadius: 14, tintOpacity: 0.25))
    }
}
