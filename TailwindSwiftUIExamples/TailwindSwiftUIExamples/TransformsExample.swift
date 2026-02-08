import SwiftUI
import TailwindSwiftUI

struct TransformsExample: View {
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("Transforms & Effects")
                    .tw("text-3xl font-bold text-slate-900")
                    .padding(.top, 20)
                
                // Scale
                VStack(alignment: .leading, spacing: 16) {
                    Text("Scale")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-blue-500")
                                .scale(75)
                            Text("75%")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-blue-500")
                            Text("100%")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-blue-500")
                                .scale(125)
                            Text("125%")
                                .tw("text-xs text-slate-600")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Rotate
                VStack(alignment: .leading, spacing: 16) {
                    Text("Rotate")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-green-500")
                                .rotate(0)
                            Text("0°")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-green-500")
                                .rotate(45)
                            Text("45°")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-green-500")
                                .rotate(90)
                            Text("90°")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-green-500")
                                .rotate(180)
                            Text("180°")
                                .tw("text-xs text-slate-600")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Blur
                VStack(alignment: .leading, spacing: 16) {
                    Text("Blur")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-purple-500")
                            Text("None")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-purple-500 blur-sm")
                            Text("Small")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-purple-500 blur-md")
                            Text("Medium")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-purple-500 blur-lg")
                            Text("Large")
                                .tw("text-xs text-slate-600")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Opacity
                VStack(alignment: .leading, spacing: 16) {
                    Text("Opacity")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-red-500 opacity-25")
                            Text("25%")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-red-500 opacity-50")
                            Text("50%")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-red-500 opacity-75")
                            Text("75%")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-red-500 opacity-100")
                            Text("100%")
                                .tw("text-xs text-slate-600")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Shadows
                VStack(alignment: .leading, spacing: 16) {
                    Text("Shadows")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-white")
                            Text("None")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-white shadow-sm")
                            Text("Small")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-white shadow-md")
                            Text("Medium")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .tw("w-20 h-20 bg-white shadow-lg")
                            Text("Large")
                                .tw("text-xs text-slate-600")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Combined Effects
                VStack(alignment: .leading, spacing: 16) {
                    Text("Combined Effects")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 12)
                            .tw("w-24 h-24 bg-blue-500 shadow-lg")
                            .scale(isAnimating ? 110 : 100)
                            .rotate(isAnimating ? 180 : 0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                            .overlay(
                                Text("Animated")
                                    .tw("text-xs font-semibold text-white")
                            )
                            .onAppear {
                                isAnimating = true
                            }
                        
                        RoundedRectangle(cornerRadius: 12)
                            .gradientToR([.purple500, .pink500])
                            .frame(width: 96, height: 96)
                            .tw("shadow-xl")
                            .overlay(
                                Text("Gradient")
                                    .tw("text-xs font-semibold text-white")
                            )
                        
                        RoundedRectangle(cornerRadius: 12)
                            .tw("w-24 h-24 bg-cyan-500 shadow-lg")
                            .overlay(
                                Text("Glowing")
                                    .tw("text-xs font-semibold text-white")
                            )
                            .ring(4, color: .cyan300)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Filter Effects
                VStack(alignment: .leading, spacing: 16) {
                    Text("Filter Effects")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Circle()
                                .tw("w-16 h-16 bg-orange-500")
                                .grayscaleFull()
                            Text("Grayscale")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            Circle()
                                .tw("w-16 h-16 bg-blue-500")
                                .invertFull()
                            Text("Invert")
                                .tw("text-xs text-slate-600")
                        }
                        
                        VStack(spacing: 8) {
                            Circle()
                                .tw("w-16 h-16 bg-green-500")
                                .sepia()
                            Text("Sepia")
                                .tw("text-xs text-slate-600")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(24)
        }
        .tw("bg-slate-50")
    }
}

#Preview {
    TransformsExample()
}
