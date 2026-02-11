import SwiftUI
import TailwindSwiftUI

struct OverflowExample: View {
    private let cardStyle = "bg-slate-900/60 rounded-xl p-4"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Overflow Examples")
                    .tw("text-3xl font-bold text-slate-100")
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("overflow-hidden")
                        .tw("text-lg font-semibold text-slate-100")
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: 0x1f2937))
                            .frame(height: 120)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<8, id: \.self) { idx in
                                Text("Chip \(idx + 1)")
                                    .tw("px-3 py-1 bg-cyan-500 text-white rounded-full text-sm")
                            }
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 12)
                    }
                    .tw("overflow-hidden")
                }
                .tw(cardStyle)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("overflow-y-scroll")
                        .tw("text-lg font-semibold text-slate-100")
                    
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(1...20, id: \.self) { row in
                        Text("Scrollable row \(row)")
                            .tw("px-3 py-2 bg-slate-700 text-slate-100 rounded-md")
                    }
                }
                .tw("h-48 overflow-y-scroll rounded-lg")
            }
            .tw(cardStyle)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("overflow-x-scroll")
                        .tw("text-lg font-semibold text-slate-100")
                    
                    HStack(spacing: 10) {
                        ForEach(1...20, id: \.self) { item in
                            Text("Item \(item)")
                                .tw("px-4 py-2 bg-violet-600 text-white rounded-md font-medium")
                        }
                    }
                    .tw("overflow-x-scroll rounded-lg")
                }
                .tw(cardStyle)
                
                Spacer(minLength: 0)
            }
            .padding(24)
            .frame(maxWidth: 900, maxHeight: .infinity, alignment: .topLeading)
            .background(
                LinearGradient(
                    colors: [.black, Color(hex: 0x0b1220)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
}

#Preview {
    OverflowExample()
}
struct EffectView : View {
    var body: some View {
        GeometryReader { geometry in
            Color.blue
                // Show a 100x100 block on the dominant axis to visualize overflow direction
                .frame(
                    width: geometry.size.width >= geometry.size.height ? 100 : 0,
                    height: geometry.size.height >= geometry.size.width ? 100 : 0
                )
                .task(id: geometry.size) {
                    print("GeometryReader size: \(geometry.size)")
                }
        }
        .background(Color.red)
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
 
    EffectView()
    
}
