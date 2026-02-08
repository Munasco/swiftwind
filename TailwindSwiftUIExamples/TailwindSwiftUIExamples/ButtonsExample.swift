import SwiftUI
import TailwindSwiftUI

struct ButtonsExample: View {
    @State private var isPressed = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("Button Examples")
                    .tw("text-3xl font-bold text-slate-900")
                    .padding(.top, 20)
                
                // Primary Buttons
                VStack(alignment: .leading, spacing: 16) {
                    Text("Primary Buttons")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 12) {
                        Text("Small")
                            .tw("px-3 py-1 bg-blue-600 text-white rounded text-sm font-medium shadow-sm")
                        
                        Text("Medium")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold shadow-md")
                        
                        Text("Large")
                            .tw("px-6 py-3 bg-blue-600 text-white rounded-lg text-lg font-semibold shadow-lg")
                    }
                }
                
                // Secondary Buttons
                VStack(alignment: .leading, spacing: 16) {
                    Text("Secondary Buttons")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 12) {
                        Text("Cancel")
                            .tw("px-4 py-2 bg-slate-200 text-slate-800 rounded-md font-semibold")
                        
                        Text("Save Draft")
                            .tw("px-4 py-2 bg-slate-100 text-slate-700 rounded-md font-medium border border-slate-300")
                    }
                }
                
                // Outline Buttons
                VStack(alignment: .leading, spacing: 16) {
                    Text("Outline Buttons")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 12) {
                        Text("Edit")
                            .tw("px-4 py-2 bg-white text-blue-600 rounded-md font-semibold border-2 border-blue-600")
                        
                        Text("Delete")
                            .tw("px-4 py-2 bg-white text-red-600 rounded-md font-semibold border-2 border-red-600")
                        
                        Text("Info")
                            .tw("px-4 py-2 bg-white text-slate-600 rounded-md font-semibold border border-slate-300")
                    }
                }
                
                // Color Variants
                VStack(alignment: .leading, spacing: 16) {
                    Text("Color Variants")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Text("Success")
                                .tw("px-4 py-2 bg-green-600 text-white rounded-md font-semibold shadow-md")
                            
                            Text("Warning")
                                .tw("px-4 py-2 bg-yellow-500 text-white rounded-md font-semibold shadow-md")
                            
                            Text("Danger")
                                .tw("px-4 py-2 bg-red-600 text-white rounded-md font-semibold shadow-md")
                        }
                        
                        HStack(spacing: 12) {
                            Text("Info")
                                .tw("px-4 py-2 bg-cyan-600 text-white rounded-md font-semibold shadow-md")
                            
                            Text("Purple")
                                .tw("px-4 py-2 bg-purple-600 text-white rounded-md font-semibold shadow-md")
                            
                            Text("Pink")
                                .tw("px-4 py-2 bg-pink-600 text-white rounded-md font-semibold shadow-md")
                        }
                    }
                }
                
                // Rounded Variants
                VStack(alignment: .leading, spacing: 16) {
                    Text("Rounded Variants")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 12) {
                        Text("Square")
                            .tw("px-4 py-2 bg-blue-600 text-white font-semibold")
                        
                        Text("Rounded")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold")
                        
                        Text("Pill")
                            .tw("px-6 py-2 bg-blue-600 text-white rounded-full font-semibold")
                    }
                }
                
                // Shadow Variants
                VStack(alignment: .leading, spacing: 16) {
                    Text("Shadow Variants")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 12) {
                        Text("No Shadow")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold")
                        
                        Text("Small")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold shadow-sm")
                        
                        Text("Medium")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold shadow-md")
                        
                        Text("Large")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold shadow-lg")
                    }
                }
                
                // Icon Buttons (using emoji)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Icon Buttons")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 12) {
                        Text("❤️")
                            .tw("px-3 py-2 bg-red-100 text-red-600 rounded-md text-xl")
                        
                        Text("⭐️")
                            .tw("px-3 py-2 bg-yellow-100 text-yellow-600 rounded-md text-xl")
                        
                        Text("🔔")
                            .tw("px-3 py-2 bg-blue-100 text-blue-600 rounded-md text-xl")
                        
                        Text("⚙️")
                            .tw("px-3 py-2 bg-slate-100 text-slate-600 rounded-md text-xl")
                    }
                }
                
                // Disabled State
                VStack(alignment: .leading, spacing: 16) {
                    Text("States")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 12) {
                        Text("Normal")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold")
                        
                        Text("Disabled")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold opacity-50")
                        
                        Text("Loading...")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold opacity-75")
                    }
                }
            }
            .padding(24)
        }
        .tw("bg-slate-50")
    }
}

#Preview {
    ButtonsExample()
}
