import SwiftUI
import TailwindSwiftUI

struct MacroExamples: View {
    @State private var isPrimary = true
    @State private var isCompact = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x09090b), Color(hex: 0x0f172a)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Macro Examples")
                        .tw("text-3xl font-black text-white")

                    Text("String macro")
                        .tw("text-base font-semibold text-slate-300")

                    Text("Compile-time validated with #styles(\"...\")")
                        .tw(#styles("px-4 py-3 rounded-xl bg-blue-600 text-white shadow-lg"))

                    Text("Builder macro")
                        .tw("text-base font-semibold text-slate-300")

                    VStack(alignment: .leading, spacing: 12) {
                        Toggle("Primary style", isOn: $isPrimary)
                            .tint(.pink500)
                            .tw("text-slate-100")
                        Toggle("Compact", isOn: $isCompact)
                            .tint(.pink500)
                            .tw("text-slate-100")
                    }
                    .tw("p-4 rounded-xl bg-white/5 border border-white/10")

                    Text("Builder result")
                        .tw {
                            "font-semibold text-white shadow-md transition-all duration-300"
                            isPrimary ? "bg-pink-500" : "bg-indigo-500"
                            isCompact ? "px-3 py-2 text-sm rounded-lg" : "px-6 py-3 text-lg rounded-2xl"
                        }

                    Text("Mixed usage")
                        .tw("text-base font-semibold text-slate-300")

                    Text("You can keep `.tw(...)` and pass #styles to it directly.")
                        .tw(#styles("text-slate-100 p-4 rounded-xl bg-slate-950 bg-slate-500"))
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    MacroExamples()
}
