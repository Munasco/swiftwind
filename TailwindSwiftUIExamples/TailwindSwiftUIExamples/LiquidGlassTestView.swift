import SwiftUI

struct BlueBackgroundTest: View {
    var body: some View {
        ZStack {
            // The Solid System Blue Background
            Color.clear
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 1. STANDARD PRIMARY
                // This might look "okay" but lacks the Liquid Glass depth.
                Text("Standard Primary")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                // 2. VIBRANT HIERARCHY (The "Liquid Glass" feel)
                // Using .secondary or .tertiary on a color background
                // tells SwiftUI to blend the text WITH the blue.
                // Example of applying Liquid Glass to a view
                Text("Hello Liquid Glass")
                    .padding()
                    .glassEffect(
                        .regular, // Appearance: .regular or .clear [1]
                        in: .rect(cornerRadius: 20) // Custom shape
                    )
                    .tint(.blue) // Optional tint color [1]
                Button("Get") {
                    print("Button tapped!")
                }.buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)

                VStack(spacing: 8) {
                    Text("Liquid Adaptation")
                        .font(.title).bold()
                        .foregroundStyle(.white) // Forced high contrast
                    
                    Text("This uses hierarchical transparency")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        // In iOS 26, .secondary automatically behaves like this
                }
                .padding()
                .background(.ultraThinMaterial) // Creates the glass refraction
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                // 3. THE AUTO-TINT BUTTON
                // Notice how the button text color is chosen by the OS
                // to contrast against the blue.
                Button("System Adaptive Action") { }
                    .tint(.orange)
                    .backgroundStyle(.red)
            }
        }
    }
}

#Preview("Liquid Glass Demo") {
    BlueBackgroundTest()
}
