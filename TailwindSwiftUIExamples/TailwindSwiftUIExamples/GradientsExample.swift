import SwiftUI
import TailwindSwiftUI

struct GradientsExample: View {
    @State private var interpolationSelection: Int = 1 // 0: sRGB, 1: OKLCH
    @State private var animateTextGradient = false

    private var interpolation: GradientInterpolationMode {
        interpolationSelection == 0 ? .srgb : .oklch
    }

    private let demoStops: [Color] = [.pink500, .violet500, .cyan400]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("Gradients")
                    .tw("text-3xl font-bold text-slate-100 tracking-tight")

                Text("Linear, radial, angular, interpolation modes, and text gradients.")
                    .tw("text-sm text-slate-300")

                Picker("Interpolation", selection: $interpolationSelection) {
                    Text("sRGB").tag(0)
                    Text("OKLCH").tag(1)
                }
                .pickerStyle(.segmented)

                gradientPanel(title: "Linear Gradient", subtitle: "Selected interpolation mode") {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: demoStops,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing,
                                interpolation: interpolation
                            )
                        )
                        .frame(height: 132)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.16), lineWidth: 1)
                        )
                }

                HStack(spacing: 14) {
                    gradientPanel(title: "Radial", subtitle: "Center bloom") {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [.pink400, .violet700, .slate950]),
                                    center: .center,
                                    startRadius: 2,
                                    endRadius: 120
                                )
                            )
                            .frame(height: 110)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
                            )
                    }

                    gradientPanel(title: "Angular", subtitle: "Color wheel") {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                AngularGradient(
                                    gradient: Gradient(colors: [.pink500, .amber500, .emerald500, .blue500, .pink500]),
                                    center: .center
                                )
                            )
                            .frame(height: 110)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
                            )
                    }
                }

                gradientPanel(title: "Text Gradient", subtitle: "Yes, SwiftUI supports it.") {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Chromatic Headline")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.pink400, .violet400, .cyan300],
                                    startPoint: animateTextGradient ? .leading : .trailing,
                                    endPoint: animateTextGradient ? .trailing : .leading,
                                    interpolation: interpolation
                                )
                            )

                        Text("Mask fallback")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.clear)
                            .overlay(
                                LinearGradient(
                                    colors: [.amber300, .pink500, .violet500],
                                    startPoint: .leading,
                                    endPoint: .trailing,
                                    interpolation: interpolation
                                )
                                .mask(
                                    Text("Mask fallback")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                )
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.1).repeatForever(autoreverses: true)) {
                            animateTextGradient = true
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(
            LinearGradient(
                colors: [Color(hex: 0x0A1020), Color(hex: 0x131B35), Color(hex: 0x1C1030)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    @ViewBuilder
    private func gradientPanel<Content: View>(
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .tw("text-base font-semibold text-slate-100")
            Text(subtitle)
                .tw("text-xs text-slate-300")
            content()
        }
        .padding(14)
        .tw("rounded-2xl border border-white/15 bg-slate-950/45")
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    GradientsExample()
}

