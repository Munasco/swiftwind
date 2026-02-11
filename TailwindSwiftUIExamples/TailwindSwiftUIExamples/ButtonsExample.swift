import SwiftUI
import TailwindSwiftUI

struct ButtonsExample: View {
    @State private var isPressed = false
    private let sectionStyle = "w-full bg-neutral-900/60 rounded-xl p-4"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Text("Button Examples")
                    .tw("text-3xl font-bold text-slate-100")

                // Primary Buttons
                VStack(alignment: .leading, spacing: 16) {
                    Text("Primary Buttons")
                        .tw("text-lg font-semibold text-slate-100 tracking-tight")
                    
                    HStack() {
                        Text("Small")
                            .tw("px-3 py-2 text-slate-950 rounded-3xl text-sm font-semibold shadow-sm dark:bg-red-500 bg-yellow-500")
                            .foregroundStyle(.white)
                            .padding(.horizontal,  70)
                        Text("Medium")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold shadow-md")
                        
                        Text("Large")
                            .tw("px-6 py-3 bg-blue-600 text-white rounded-lg text-lg font-semibold shadow-lg")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tw(sectionStyle)
                
                // Secondary Buttons
                VStack(alignment: .leading, spacing: 16) {
                    Text("Secondary Buttons")
                        .tw("text-lg font-semibold text-slate-100 tracking-tight")
                    
                    HStack(spacing: 12) {
                        Text("Cancel")
                            .tw("px-4 py-2 bg-slate-200 text-slate-900 rounded-md font-semibold")
                        
                        Text("Save Draft")
                            .tw("px-4 py-2 bg-white/5 text-slate-100 rounded-md font-medium border border-slate-700")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tw(sectionStyle)
                
                // Outline Buttons
                VStack(alignment: .leading, spacing: 16) {
                    Text("Outline Buttons")
                        .tw("text-lg font-semibold text-slate-100 tracking-tight")
                    
                    HStack(spacing: 12) {
                        Text("Edit")
                            .tw("px-4 py-2 bg-transparent text-blue-400 rounded-md font-semibold border-2 border-blue-500")
                        
                        Text("Delete")
                            .tw("px-4 py-2 bg-transparent text-red-400 rounded-md font-semibold border-2 border-red-500")
                        
                        Text("Info")
                            .tw("px-4 py-2 bg-transparent text-slate-100 rounded-md font-semibold border border-slate-700")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tw(sectionStyle)
                
                // Color Variants
                VStack(alignment: .leading, spacing: 16) {
                    Text("Color Variants")
                        .tw("text-lg font-semibold text-slate-100 tracking-tight")
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Text("Success")
                                .tw("px-4 py-2 bg-green-600 text-white rounded-md font-semibold shadow-md")
                            
                            Text("Warning")
                                .tw("px-4 py-2 bg-amber-500 text-slate-950 rounded-md font-semibold shadow-md")
                            
                            Text("Danger")
                                .tw("px-4 py-2 bg-red-600 text-white rounded-md font-semibold shadow-md")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 12) {
                            Text("Info")
                                .tw("px-4 py-2 bg-cyan-600 text-white rounded-md font-semibold shadow-md")
                            
                            Text("Purple")
                                .tw("px-4 py-2 bg-purple-600 text-white rounded-md font-semibold shadow-md")
                            
                            Text("Pink")
                                .tw("px-4 py-2 bg-pink-600 text-white rounded-md font-semibold shadow-md")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .tw(sectionStyle)
                
                // Rounded Variants
                VStack(alignment: .leading, spacing: 16) {
                    Text("Rounded Variants")
                        .tw("text-lg font-semibold text-slate-100 tracking-tight")
                    
                    HStack(spacing: 12) {
                        Text("Square")
                            .tw("px-4 py-2 bg-blue-600 text-white font-semibold")
                        
                        Text("Rounded")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold")
                        
                        Text("Pill")
                            .tw("px-6 py-2 bg-blue-600 text-white rounded-full font-semibold")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tw(sectionStyle)
                
                // Shadow Variants
                VStack(alignment: .leading, spacing: 16) {
                    Text("Shadow Variants")
                        .tw("text-lg font-semibold text-slate-100 tracking-tight")
                    
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tw(sectionStyle)
                
                // Icon Buttons (using emoji)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Icon Buttons")
                        .tw("text-lg font-semibold text-slate-100 tracking-tight")
                    
                    HStack(spacing: 12) {
                        Text("❤️")
                            .tw("px-3 py-2 bg-red-500/20 text-red-200 rounded-md text-xl border border-red-500/40")
                        
                        Text("⭐️")
                            .tw("px-3 py-2 bg-amber-500/20 text-amber-100 rounded-md text-xl border border-amber-500/40")
                        
                        Text("🔔")
                            .tw("px-3 py-2 bg-cyan-500/20 text-cyan-100 rounded-md text-xl border border-cyan-500/40")
                        
                        Text("⚙️")
                            .tw("px-3 py-2 bg-slate-500/20 text-slate-100 rounded-md text-xl border border-slate-500/40")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tw(sectionStyle)
                
                // Disabled State
                VStack(alignment: .leading, spacing: 16) {
                    Text("States")
                        .tw("text-lg font-semibold text-slate-100 tracking-tight")
                    
                    HStack(spacing: 12) {
                        Text("Normal")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold")
                        
                        Text("Disabled")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold opacity-50")
                        
                        Text("Loading...")
                            .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold opacity-75")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tw(sectionStyle)
            }
            .frame(maxWidth: 720, alignment: .leading)
            .padding(24)
        }
        .background(
            LinearGradient(colors: [.black, Color(hex: 0x0b1220)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
}

#Preview {
    ButtonsExample()
}
