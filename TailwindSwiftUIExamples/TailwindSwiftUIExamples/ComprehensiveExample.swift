import SwiftUI
import TailwindSwiftUI

struct ComprehensiveExample: View {
    @State private var isHovered = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Section
                VStack(spacing: 16) {
                    Text("TailwindSwiftUI")
                        .tw("text-4xl font-bold text-slate-900")
                    
                    Text("Build beautiful SwiftUI interfaces with utility-first modifiers")
                        .tw("text-lg text-slate-600 text-center max-w-xl")
                    
                    HStack(gap: 3) {
                        Text("Get Started")
                            .tw("px-6 py-3 bg-blue-600 text-white rounded-lg shadow-lg font-semibold")
                            .scale(isHovered ? 105 : 100)
                        
                        Text("Documentation")
                            .tw("px-6 py-3 bg-slate-200 text-slate-800 rounded-lg font-semibold")
                    }
                }
                .tw("p-8 bg-gradient-to-br from-blue-50 to-purple-50 rounded-2xl")
                
                // Feature Cards
                VStack(gap: 4) {
                    FeatureCard(
                        icon: "✨",
                        title: "Utility-First",
                        description: "Use .tw() for compact Tailwind-style classes or builder modifiers for type safety"
                    )
                    
                    FeatureCard(
                        icon: "🎨",
                        title: "22 Color Palettes",
                        description: "All Tailwind colors from slate to rose, 50-950 shades each"
                    )
                    
                    FeatureCard(
                        icon: "⚡️",
                        title: "Full Parity",
                        description: "2,441 lines covering layout, typography, transforms, filters, and more"
                    )
                }
                
                // Gradient Demo
                VStack(spacing: 12) {
                    Text("Gradient Examples")
                        .tw("text-2xl font-bold text-slate-900")
                    
                    HStack(gap: 3) {
                        Rectangle()
                            .gradientToR([.blue500, .purple600])
                            .tw("w-24 h-24 rounded-lg shadow-md")
                        
                        Rectangle()
                            .gradientToB([.red500, .orange500])
                            .tw("w-24 h-24 rounded-lg shadow-md")
                        
                        Rectangle()
                            .gradientToTR([.cyan500, .blue500])
                            .tw("w-24 h-24 rounded-lg shadow-md")
                    }
                }
                .tw("p-6 bg-white rounded-xl shadow-lg")
                
                // Transform Demo
                VStack(spacing: 12) {
                    Text("Transforms & Effects")
                        .tw("text-2xl font-bold text-slate-900")
                    
                    HStack(gap: 3) {
                        Text("Scale")
                            .tw("w-20 h-20 bg-blue-500 text-white font-semibold rounded-lg flex items-center justify-center shadow-md")
                            .scale(125)
                        
                        Text("Rotate")
                            .tw("w-20 h-20 bg-green-500 text-white font-semibold rounded-lg flex items-center justify-center shadow-md")
                            .rotate(45)
                        
                        Text("Blur")
                            .tw("w-20 h-20 bg-purple-500 text-white font-semibold rounded-lg shadow-md blur-md")
                    }
                }
                .tw("p-6 bg-white rounded-xl shadow-lg")
                
                // Grid Demo
                VStack(alignment: .leading, spacing: 12) {
                    Text("Grid Layout")
                        .tw("text-2xl font-bold text-slate-900")
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(0..<6) { index in
                            VStack(spacing: 8) {
                                Circle()
                                    .fill(Color.blue500)
                                    .tw("w-12 h-12")
                                
                                Text("Item \(index + 1)")
                                    .tw("text-sm font-medium text-slate-700")
                            }
                            .tw("p-4 bg-slate-50 rounded-lg")
                        }
                    }
                }
                .tw("p-6 bg-white rounded-xl shadow-lg")
                
                // Border & Ring Demo
                VStack(spacing: 12) {
                    Text("Borders & Rings")
                        .tw("text-2xl font-bold text-slate-900")
                    
                    HStack(gap: 3) {
                        Text("Border")
                            .tw("px-4 py-2 border-2 border-slate-300 rounded-lg")
                        
                        Text("Ring")
                            .tw("px-4 py-2 bg-white rounded-lg")
                            .ring(2, color: .blue500)
                        
                        Text("Shadow")
                            .tw("px-4 py-2 bg-white rounded-lg shadow-xl")
                    }
                }
                .tw("p-6 bg-white rounded-xl shadow-lg")
            }
            .tw("p-6 bg-slate-100")
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(icon)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .tw("text-lg font-semibold text-slate-900")
                
                Text(description)
                    .tw("text-sm text-slate-600 line-clamp-3")
            }
        }
        .tw("p-4 bg-white border border-slate-200 rounded-lg shadow-sm")
    }
}

#Preview {
    ComprehensiveExample()
}
