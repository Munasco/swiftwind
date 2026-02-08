import SwiftUI
import TailwindSwiftUI

struct LayoutExample: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Layout & Spacing Examples")
                    .tw("text-3xl font-bold text-slate-900")
                    .padding(.top, 20)
                
                // Padding Examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("Padding")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(spacing: 12) {
                        Text("p-2 (8pt)")
                            .tw("p-2 bg-blue-100 text-blue-900 rounded border border-blue-300")
                        
                        Text("p-4 (16pt)")
                            .tw("p-4 bg-blue-100 text-blue-900 rounded border border-blue-300")
                        
                        Text("p-8 (32pt)")
                            .tw("p-8 bg-blue-100 text-blue-900 rounded border border-blue-300")
                        
                        HStack(spacing: 12) {
                            Text("px-6")
                                .tw("px-6 py-2 bg-green-100 text-green-900 rounded border border-green-300")
                            
                            Text("py-6")
                                .tw("px-2 py-6 bg-green-100 text-green-900 rounded border border-green-300")
                        }
                    }
                }
                
                // Width & Height
                VStack(alignment: .leading, spacing: 16) {
                    Text("Width & Height")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(spacing: 12) {
                        Rectangle()
                            .tw("w-16 h-16 bg-purple-500 rounded")
                            .overlay(
                                Text("64pt")
                                    .tw("text-xs text-white font-semibold")
                            )
                        
                        Rectangle()
                            .tw("w-32 h-24 bg-purple-500 rounded")
                            .overlay(
                                Text("128×96pt")
                                    .tw("text-sm text-white font-semibold")
                            )
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .tw("h-20 bg-purple-500 rounded")
                            .overlay(
                                Text("w-full × 80pt")
                                    .tw("text-sm text-white font-semibold")
                            )
                    }
                }
                
                // Flexbox - Justify
                VStack(alignment: .leading, spacing: 16) {
                    Text("Flexbox - Justify Content")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(spacing: 12) {
                        HStack {
                            Box(label: "1")
                            Box(label: "2")
                            Box(label: "3")
                        }
                        .frame(maxWidth: .infinity)
                        .tw("p-3 bg-slate-100 rounded")
                        .overlay(
                            Text("justify-start")
                                .tw("text-xs text-slate-500")
                                .position(x: 60, y: -10)
                        )
                        
                        HStack {
                            Spacer()
                            Box(label: "1")
                            Box(label: "2")
                            Box(label: "3")
                        }
                        .frame(maxWidth: .infinity)
                        .tw("p-3 bg-slate-100 rounded")
                        .overlay(
                            Text("justify-end")
                                .tw("text-xs text-slate-500")
                                .position(x: 55, y: -10)
                        )
                        
                        HStack {
                            Spacer()
                            Box(label: "1")
                            Box(label: "2")
                            Box(label: "3")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .tw("p-3 bg-slate-100 rounded")
                        .overlay(
                            Text("justify-center")
                                .tw("text-xs text-slate-500")
                                .position(x: 60, y: -10)
                        )
                    }
                }
                
                // Flexbox - Align
                VStack(alignment: .leading, spacing: 16) {
                    Text("Flexbox - Align Items")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 12) {
                        VStack {
                            Box(label: "1", size: 40)
                            Box(label: "2", size: 60)
                            Box(label: "3", size: 40)
                        }
                        .frame(maxHeight: .infinity)
                        .tw("p-3 bg-slate-100 rounded w-24")
                        
                        VStack {
                            Spacer()
                            Box(label: "1", size: 40)
                            Box(label: "2", size: 60)
                            Box(label: "3", size: 40)
                        }
                        .frame(maxHeight: .infinity)
                        .tw("p-3 bg-slate-100 rounded w-24")
                        
                        VStack {
                            Spacer()
                            Box(label: "1", size: 40)
                            Box(label: "2", size: 60)
                            Box(label: "3", size: 40)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                        .tw("p-3 bg-slate-100 rounded w-24")
                    }
                    .frame(height: 200)
                }
                
                // Gap Spacing
                VStack(alignment: .leading, spacing: 16) {
                    Text("Gap Spacing")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Box(label: "1")
                            Box(label: "2")
                            Box(label: "3")
                            Box(label: "4")
                        }
                        .tw("p-3 bg-slate-100 rounded")
                        .overlay(
                            Text("gap-2 (8pt)")
                                .tw("text-xs text-slate-500")
                                .position(x: 50, y: -10)
                        )
                        
                        HStack(spacing: 16) {
                            Box(label: "1")
                            Box(label: "2")
                            Box(label: "3")
                            Box(label: "4")
                        }
                        .tw("p-3 bg-slate-100 rounded")
                        .overlay(
                            Text("gap-4 (16pt)")
                                .tw("text-xs text-slate-500")
                                .position(x: 55, y: -10)
                        )
                        
                        HStack(spacing: 32) {
                            Box(label: "1")
                            Box(label: "2")
                            Box(label: "3")
                            Box(label: "4")
                        }
                        .tw("p-3 bg-slate-100 rounded")
                        .overlay(
                            Text("gap-8 (32pt)")
                                .tw("text-xs text-slate-500")
                                .position(x: 55, y: -10)
                        )
                    }
                }
                
                // Grid Layout
                VStack(alignment: .leading, spacing: 16) {
                    Text("Grid Layout")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(1...9, id: \.self) { num in
                            Box(label: "\(num)", size: 60)
                        }
                    }
                    .tw("p-4 bg-slate-100 rounded")
                }
            }
            .padding(24)
        }
        .tw("bg-slate-50")
    }
}

struct Box: View {
    let label: String
    var size: CGFloat = 50
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.blue500)
            .frame(width: size, height: size)
            .overlay(
                Text(label)
                    .tw("text-lg font-bold text-white")
            )
    }
}

#Preview {
    LayoutExample()
}
