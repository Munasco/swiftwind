import SwiftUI
import TailwindSwiftUI

struct ShapeExample: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Shape Styling")
                    .tw("text-3xl font-bold text-slate-100")

                VStack(alignment: .leading, spacing: 12) {
                    Text("fill-* / stroke-* / stroke-{width}")
                        .tw("text-lg font-semibold text-slate-100")

                    HStack(spacing: 16) {
                        Circle()
                            .tw("fill-red-500 stroke-blue-500 stroke-2 w-20 h-20")

                        RoundedRectangle(cornerRadius: 12)
                            .tw("fill-emerald-500 stroke-white stroke-2 w-24 h-20")

                        Capsule()
                            .tw("fill-[#1d4ed8] stroke-yellow-300 stroke-3 w-28 h-16")
                    }

                    Text("Shape paint follows SVG intent: fill and stroke are separate channels.")
                        .tw("text-xs text-slate-400")
                }
                .tw("bg-slate-900/60 border border-slate-700 rounded-xl p-4")
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
    }
}

#Preview {
    ShapeExample()
}
