import SwiftUI
import TailwindSwiftUI

struct BentoGradientExample: View {
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Pink Bento Gradient Lab")
                    .tw("text-3xl font-bold text-pink-100 tracking-tight")

                Text("Compare gradient interpolation using a warm pink-to-amber palette.")
                    .tw("text-sm text-pink-200/80")

                LazyVGrid(columns: columns, spacing: 16) {
                    gradientCard(
                        title: "sRGB Interpolation",
                        subtitle: "LinearGradient default blend",
                        interpolation: GradientInterpolationMode.srgb
                    )

                    gradientCard(
                        title: "OKLCH Interpolation",
                        subtitle: "Perceptual blend in OKLCH",
                        interpolation: GradientInterpolationMode.oklch
                    )

                    statCard(title: "Palette", value: "Pink/Rose/Amber", accent: "bg-pink-500/30 border-pink-400/60")
                    statCard(title: "Mode", value: "Bento Layout", accent: "bg-orange-500/30 border-orange-400/60")
                    statCard(title: "Stops", value: "3", accent: "bg-rose-500/30 border-rose-400/60")
                    statCard(title: "Theme", value: "Warm Neon", accent: "bg-amber-400/30 border-amber-300/60")
                }
            }
            .padding(24)
        }
        .background(
            LinearGradient(
                colors: [Color(hex: 0x200a1f), Color(hex: 0x130814), Color(hex: 0x09050c)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    @ViewBuilder
    private func gradientCard(title: String, subtitle: String, interpolation: GradientInterpolationMode) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .tw("text-base font-semibold text-pink-50")

            Text(subtitle)
                .tw("text-xs text-pink-100/70")

            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [.pink500, .rose500, .amber500],
                        startPoint: .leading,
                        endPoint: .trailing,
                        interpolation: interpolation
                    )
                )
                .frame(height: 92)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
        .padding(14)
        .tw("bg-pink-950/35 border border-pink-400/40 rounded-2xl")
    }

    @ViewBuilder
    private func statCard(title: String, value: String, accent: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .tw("text-xs uppercase tracking-wide text-pink-100/70")

            Text(value)
                .tw("text-sm font-semibold text-pink-50")
        }
        .padding(12)
        .tw("\(accent) rounded-xl")
    }
}

#Preview {
    BentoGradientExample()
}
