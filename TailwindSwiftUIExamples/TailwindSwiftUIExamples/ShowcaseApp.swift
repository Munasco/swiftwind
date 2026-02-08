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
        }
    }
}

#Preview {
    ShowcaseApp()
}
