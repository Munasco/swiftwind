import SwiftUI
import TailwindSwiftUI

struct CardsExample: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Card Examples")
                    .tw("text-3xl font-bold text-slate-900")
                    .padding(.top, 20)
                
                // Simple Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Simple Cardµ")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Card Title")
                            .tw("text-lg font-bold text-slate-900")
                        
                        Text("This is a simple card with some content. It has a white background, rounded corners, and a subtle shadow.")
                            .tw("text-sm text-slate-600")
                    }
                    .tw("p-6 bg-white rounded-lg shadow-md")
                }
                
                // Card with Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("Card with Header")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Featured Article")
                                .tw("text-xs font-semibold text-blue-600 uppercase")
                            
                            Text("Getting Started with TailwindSwiftUI")
                                .tw("text-xl font-bold text-slate-900")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tw("p-6 bg-blue-50 rounded-t-lg")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Learn how to use utility-first modifiers to build beautiful SwiftUI interfaces quickly.")
                                .tw("text-sm text-slate-600")
                            
                            Text("Read More →")
                                .tw("text-sm font-semibold text-blue-600")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tw("p-6 bg-white rounded-b-lg")
                    }
                    .tw("shadow-lg")
                }
                
                // Profile Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Profile Card")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 16) {
                        Circle()
                            .tw("w-16 h-16 bg-blue-500")
                            .overlay(
                                Text("JD")
                                    .tw("text-2xl font-bold text-white")
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("John Doe")
                                .tw("text-lg font-bold text-slate-900")
                            
                            Text("Software Developer")
                                .tw("text-sm text-slate-600")
                            
                            HStack(spacing: 8) {
                                Text("📍 San Francisco")
                                    .tw("text-xs text-slate-500")
                                
                                Text("•")
                                    .tw("text-xs text-slate-300")
                                
                                Text("🔗 @johndoe")
                                    .tw("text-xs text-blue-600")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tw("p-6 bg-white rounded-xl shadow-lg")
                }
                
                // Stats Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Stats Card")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Text("1.2K")
                                .tw("text-2xl font-bold text-slate-900")
                            Text("Followers")
                                .tw("text-xs text-slate-500")
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .tw("w-px h-12 bg-slate-200")
                        
                        VStack(spacing: 4) {
                            Text("543")
                                .tw("text-2xl font-bold text-slate-900")
                            Text("Following")
                                .tw("text-xs text-slate-500")
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .tw("w-px h-12 bg-slate-200")
                        
                        VStack(spacing: 4) {
                            Text("89")
                                .tw("text-2xl font-bold text-slate-900")
                            Text("Posts")
                                .tw("text-xs text-slate-500")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .tw("p-6 bg-white rounded-xl shadow-md")
                }
                
                // Notification Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notification Card")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .tw("w-10 h-10 bg-green-500")
                            .overlay(
                                Text("✓")
                                    .tw("text-lg font-bold text-white")
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Success!")
                                .tw("text-base font-bold text-slate-900")
                            
                            Text("Your changes have been saved successfully.")
                                .tw("text-sm text-slate-600")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .tw("p-4 bg-green-50 border border-green-200 rounded-lg")
                }
                
                // Pricing Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pricing Card")
                        .tw("text-xl font-semibold text-slate-700")
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text("Pro")
                                .tw("text-sm font-semibold text-blue-600 uppercase")
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("$")
                                    .tw("text-2xl font-bold text-slate-900")
                                Text("29")
                                    .tw("text-5xl font-bold text-slate-900")
                                Text("/month")
                                    .tw("text-base text-slate-500")
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            FeatureRow(text: "Unlimited projects")
                            FeatureRow(text: "Advanced analytics")
                            FeatureRow(text: "24/7 support")
                            FeatureRow(text: "Custom domain")
                        }
                        
                        Text("Get Started")
                            .frame(maxWidth: .infinity)
                            .tw("py-3 bg-blue-600 text-white font-semibold rounded-lg shadow-md")
                    }
                    .tw("p-6 bg-white border-2 border-blue-600 rounded-xl shadow-lg")
                }
            }
            .padding(24)
        }
        .tw("bg-slate-50")
    }
}

struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text("✓")
                .tw("text-green-600 font-bold")
            
            Text(text)
                .tw("text-sm text-slate-600")
        }
    }
}

#Preview {
    CardsExample()
}
