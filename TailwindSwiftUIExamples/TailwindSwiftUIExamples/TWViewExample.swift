import SwiftUI
import TailwindSwiftUI

struct TWViewExample: View {
    private let panel = "bg-neutral-900/60 rounded-xl p-4"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("TWView (Div-like Container)")
                    .tw("text-3xl font-bold text-slate-100")

                Text("Use TWView when you want Tailwind layout utilities to control alignment and flow.")
                    .tw("text-slate-300")

                VStack(alignment: .leading, spacing: 12) {
                    Text("Regular VStack (layout utilities are ignored)")
                        .tw("text-lg font-semibold text-slate-100")

                    VStack {
                        Text("A").tw("px-3 py-2 bg-blue-600 text-white rounded")
                        Text("B").tw("px-3 py-2 bg-blue-600 text-white rounded")
                    }
                    .tw("justify-center items-center gap-4 p-3 bg-slate-800 rounded-lg")
                }
                .tw(panel)

                VStack(alignment: .leading, spacing: 12) {
                    Text("TWView (layout utilities apply)")
                        .tw("text-lg font-semibold text-slate-100")

                    TWView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1").tw("px-3 py-2 bg-emerald-600 text-white rounded")
                            Text("2").tw("px-3 py-2 bg-emerald-600 text-white rounded")
                            Text("3").tw("px-3 py-2 bg-emerald-600 text-white rounded")
                        }
                    }
                    .tw("justify-center items-center p-3 bg-slate-800 rounded-lg")
                }
                .tw(panel)
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
    TWViewExample()
}
