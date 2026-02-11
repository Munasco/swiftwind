import SwiftUI
import TailwindSwiftUI

struct VariantsExample: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Variants")
                    .tw("text-3xl font-bold text-slate-100")

                VStack(alignment: .leading, spacing: 12) {
                    Text("dark:, hover:, active:")
                        .tw("text-lg font-semibold text-slate-100")

                    Text("Dark-aware pill")
                        .tw("px-3 py-2 bg-yellow-500 text-slate-900 dark:bg-red-500 dark:text-white rounded-full font-semibold")

                    Text("Hover / active demo (pointer platforms)")
                        .tw("px-4 py-2 rounded-md bg-blue-600 text-white hover:bg-blue-500 active:bg-blue-700")
                }
                .tw("bg-slate-900/60 border border-slate-700 rounded-xl p-4")

                VStack(alignment: .leading, spacing: 12) {
                    Text("group-* variants")
                        .tw("text-lg font-semibold text-slate-100")

                    VStack(alignment: .leading, spacing: 8) {
                        Text("group container")
                            .tw("text-xs uppercase tracking-wide text-slate-400")
                        Text("Child responds to group state")
                            .tw("px-3 py-2 rounded-md bg-slate-700 text-slate-100 group-hover:bg-cyan-600 group-active:bg-cyan-700")
                    }
                    .tw("group p-3 bg-slate-800 rounded-lg")
                }
                .tw("bg-slate-900/60 border border-slate-700 rounded-xl p-4")

                VStack(alignment: .leading, spacing: 12) {
                    Text("peer-* variants")
                        .tw("text-lg font-semibold text-slate-100")

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Peer Source")
                            .tw("peer px-3 py-2 rounded bg-violet-600 text-white")
                        Text("Peer reacts to source")
                            .tw("px-3 py-2 rounded bg-slate-700 text-slate-100 peer-hover:bg-violet-500 peer-active:bg-violet-700")
                    }
                    .tw("p-3 bg-slate-800 rounded-lg")
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
    VariantsExample()
}
