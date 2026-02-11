import SwiftUI
import TailwindSwiftUI

@main
struct TailwindShowcaseApp: App {
    var body: some Scene {
        WindowGroup {
            ShowcaseApp()
        }
    }
}

struct ShowcaseApp: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ColorPaletteExample()
                .tabItem {
                    Label("Colors", systemImage: "paintpalette")
                }
                .tag(0)
            
            ButtonsExample()
                .tabItem {
                    Label("Buttons", systemImage: "button.programmable")
                }
                .tag(1)
            
            CardsExample()
                .tabItem {
                    Label("Cards", systemImage: "rectangle.stack")
                }
                .tag(2)
            
            LayoutExample()
                .tabItem {
                    Label("Layout", systemImage: "square.grid.2x2")
                }
                .tag(3)
            
            TransformsExample()
                .tabItem {
                    Label("Effects", systemImage: "wand.and.stars")
                }
                .tag(4)

            OverflowExample()
                .tabItem {
                    Label("Overflow", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
                }
                .tag(5)

            TWViewExample()
                .tabItem {
                    Label("TWView", systemImage: "rectangle.3.group")
                }
                .tag(6)

            VariantsExample()
                .tabItem {
                    Label("Variants", systemImage: "circle.lefthalf.filled")
                }
                .tag(7)

            RuntimeVariablesExample()
                .tabItem {
                    Label("Runtime", systemImage: "slider.horizontal.3")
                }
                .tag(8)

            ShapeExample()
                .tabItem {
                    Label("Shape", systemImage: "square.on.circle")
                }
                .tag(9)
        }
    }
}

#Preview {
    ShowcaseApp()
}
