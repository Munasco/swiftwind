import SwiftUI
import TailwindSwiftUI

struct RuntimeVariablesExample: View {
    @State private var configured = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Runtime Variables")
                    .tw("text-3xl font-bold text-slate-100")

                VStack(alignment: .leading, spacing: 12) {
                    Text("Theme tokens + CSS variables + utility aliases")
                        .tw("text-lg font-semibold text-slate-100")

                    HStack(spacing: 10) {
                        Text("Brand")
                            .tw("btn-primary")
                        Text("Platform")
                            .tw("px-4 py-2 rounded-md bg-[--color-platform] text-white shadow-md font-semibold")
                        Text("Chip")
                            .tw("chip")
                    }

                    Text("Uses --spacing-card via arbitrary syntax")
                        .tw("text-slate-300")
                    Text("Card")
                        .tw("bg-slate-800 text-slate-100 rounded-lg p-[--spacing-card]")
                }
                .tw("panel p-4")
            }
            .padding(24)
            .frame(maxWidth: 900, alignment: .leading)
        }
        .background(
            LinearGradient(
                colors: [.black, Color(hex: 0x0b1220)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .task {
            guard !configured else { return }
            configured = true
            TailwindSwiftUI.reset()
            TailwindSwiftUI.initialize(entries: [
                .color("--color-brand", light: "blue-500", dark: "cyan-400"),
                .color(
                    "--color-platform",
                    default: .color(light: "violet-500", dark: "purple-400"),
                    iOS: .color(light: "emerald-500", dark: "green-400"),
                    macOS: .color(light: "orange-500", dark: "amber-400")
                ),
                .spacing("--spacing-card", light: "1.5rem", dark: "2rem"),
                .css("--glass-alpha", property: "opacity", light: "0.8", dark: "0.65"),
                .utilities([
                    "btn-primary": "px-4 py-2 rounded-md bg-[--color-brand] text-white shadow-md font-semibold",
                    "chip": "px-3 py-1 rounded-full text-xs font-semibold bg-slate-700 text-slate-100",
                    "panel": "bg-slate-900/60 border border-slate-700 rounded-xl",
                ]),
            ])
        }
    }
}

#Preview {
    RuntimeVariablesExample()
}
