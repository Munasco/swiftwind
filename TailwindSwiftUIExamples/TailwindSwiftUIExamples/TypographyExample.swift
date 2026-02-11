import SwiftUI
import TailwindSwiftUI

struct TypographyExample: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("Typography Examples")
                    .tw("text-3xl font-bold text-slate-900")
                    .padding(.top, 20)
                
                // Font Sizes
                VStack(alignment: .leading, spacing: 16) {
                    Text("Font Sizes")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("text-xs: Extra Small (12pt)")
                            .tw("text-xs text-slate-600")
                        
                        Text("text-sm: Small (14pt)")
                            .tw("text-sm text-slate-600")
                        
                        Text("text-base: Base (16pt)")
                            .tw("text-base text-slate-600")
                        
                        Text("text-lg: Large (18pt)")
                            .tw("text-lg text-slate-600")
                        
                        Text("text-xl: Extra Large (20pt)")
                            .tw("text-xl text-slate-600")
                        
                        Text("text-2xl: 2X Large (24pt)")
                            .tw("text-2xl text-slate-600")
                        
                        Text("text-3xl: 3X Large (30pt)")
                            .tw("text-3xl text-slate-600")
                        
                        Text("text-4xl: 4X Large (36pt)")
                            .tw("text-4xl text-slate-600")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tw("p-6 bg-white rounded-xl shadow-md")
                }
                
                // Font Weights
                VStack(alignment: .leading, spacing: 16) {
                    Text("Font Weights")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("font-thin: Thin Weight")
                            .tw("text-lg font-thin text-slate-900")
                        
                        Text("font-light: Light Weight")
                            .tw("text-lg font-light text-slate-900")
                        
                        Text("font-normal: Normal Weight")
                            .tw("text-lg text-slate-900")
                        
                        Text("font-medium: Medium Weight")
                            .tw("text-lg font-medium text-slate-900")
                        
                        Text("font-semibold: Semibold Weight")
                            .tw("text-lg font-semibold text-slate-900")
                        
                        Text("font-bold: Bold Weight")
                            .tw("text-lg font-bold text-slate-900")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tw("p-6 bg-white rounded-xl shadow-md")
                }
                
                // Text Alignment
                VStack(alignment: .leading, spacing: 16) {
                    Text("Text Alignment")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(spacing: 12) {
                        Text("text-left: Left aligned text goes here and wraps to multiple lines to show alignment")
                            .tw("text-base text-slate-600 text-left")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("text-center: Center aligned text goes here and wraps to multiple lines to show alignment")
                            .tw("text-base text-slate-600 text-center")
                            .multilineTextAlignment(.center)
                        
                        Text("text-right: Right aligned text goes here and wraps to multiple lines to show alignment")
                            .tw("text-base text-slate-600 text-right")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                    }
                    .tw("p-6 bg-white rounded-xl shadow-md")
                }
                
                // Color Variations
                VStack(alignment: .leading, spacing: 16) {
                    Text("Text Colors")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("text-slate-900: Primary Text")
                            .tw("text-base font-semibold text-slate-900")
                        
                        Text("text-slate-600: Secondary Text")
                            .tw("text-base text-slate-600")
                        
                        Text("text-slate-400: Tertiary Text")
                            .tw("text-base text-slate-400")
                        
                        Divider().padding(.vertical, 4)
                        
                        Text("text-blue-600: Blue Accent")
                            .tw("text-base font-semibold text-blue-600")
                        
                        Text("text-green-600: Success Text")
                            .tw("text-base font-semibold text-green-600")
                        
                        Text("text-red-600: Error Text")
                            .tw("text-base font-semibold text-red-600")
                        
                        Text("text-yellow-600: Warning Text")
                            .tw("text-base font-semibold text-yellow-600")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tw("p-6 bg-white rounded-xl shadow-md")
                }
                
                // Line Clamping
                VStack(alignment: .leading, spacing: 16) {
                    Text("Line Clamping")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("line-clamp-1")
                                .tw("text-xs font-semibold text-slate-500 uppercase")
                            
                            Text("This is a very long text that should be clamped to one line and show an ellipsis at the end because it's too long to fit")
                                .tw("text-sm text-slate-600 line-clamp-1")
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("line-clamp-2")
                                .tw("text-xs font-semibold text-slate-500 uppercase")
                            
                            Text("This is a very long text that should be clamped to two lines and show an ellipsis at the end because it's too long to fit. It keeps going and going. nd because it's too long to fit. It keeps going and going ")
                                .tw("text-sm text-slate-600 line-clamp-2")
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("line-clamp-3")
                                .tw("text-xs font-semibold text-slate-500 uppercase")
                            
                            Text("This is a very long text that should be clamped to three lines and show an ellipsis at the end because it's too long to fit. It keeps going and going. More text here.")
                                .tw("text-sm text-slate-600 line-clamp-3")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tw("p-6 bg-white rounded-xl shadow-md")
                }
                
                // Combinations
                VStack(alignment: .leading, spacing: 16) {
                    Text("Combined Styles")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Article Heading")
                                .tw("text-2xl font-bold text-slate-900")
                            
                            Text("By John Doe • 5 min read")
                                .tw("text-sm text-slate-500")
                            
                            Text("This is a sample article excerpt that demonstrates multiple typography utilities working together. The text is styled with different sizes, weights, and colors to create a clear visual hierarchy.")
                                .tw("text-base text-slate-600")
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("💡 Pro Tip")
                                .tw("text-base font-bold text-blue-900")
                            
                            Text("Combine multiple utilities for rich text formatting")
                                .tw("text-sm text-blue-700")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tw("p-4 bg-blue-50 rounded-lg border border-blue-200")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tw("p-6 bg-white rounded-xl shadow-md")
                }
            }
            .padding(24)
        }
        .tw("bg-slate-50")
    }
}

#Preview {
    TypographyExample()
}
