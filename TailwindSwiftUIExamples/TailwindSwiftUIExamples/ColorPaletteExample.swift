import SwiftUI
import TailwindSwiftUI

struct ColorPaletteExample: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("TailwindSwiftUI Color Palette")
                    .tw("text-3xl font-bold text-slate-900")
                    .padding(.top, 20)
                
                // Slate
                ColorRow(name: "Slate", colors: [
                    ("50", Color.slate50),
                    ("100", Color.slate100),
                    ("200", Color.slate200),
                    ("300", Color.slate300),
                    ("400", Color.slate400),
                    ("500", Color.slate500),
                    ("600", Color.slate600),
                    ("700", Color.slate700),
                    ("800", Color.slate800),
                    ("900", Color.slate900),
                    ("950", Color.slate950)
                ])
                
                // Red
                ColorRow(name: "Red", colors: [
                    ("50", Color.red50),
                    ("100", Color.red100),
                    ("200", Color.red200),
                    ("300", Color.red300),
                    ("400", Color.red400),
                    ("500", Color.red500),
                    ("600", Color.red600),
                    ("700", Color.red700),
                    ("800", Color.red800),
                    ("900", Color.red900),
                    ("950", Color.red950)
                ])
                
                // Blue
                ColorRow(name: "Blue", colors: [
                    ("50", Color.blue50),
                    ("100", Color.blue100),
                    ("200", Color.blue200),
                    ("300", Color.blue300),
                    ("400", Color.blue400),
                    ("500", Color.blue500),
                    ("600", Color.blue600),
                    ("700", Color.blue700),
                    ("800", Color.blue800),
                    ("900", Color.blue900),
                    ("950", Color.blue950)
                ])
                
                // Green
                ColorRow(name: "Green", colors: [
                    ("50", Color.green50),
                    ("100", Color.green100),
                    ("200", Color.green200),
                    ("300", Color.green300),
                    ("400", Color.green400),
                    ("500", Color.green500),
                    ("600", Color.green600),
                    ("700", Color.green700),
                    ("800", Color.green800),
                    ("900", Color.green900),
                    ("950", Color.green950)
                ])
                
                // Purple
                ColorRow(name: "Purple", colors: [
                    ("50", Color.purple50),
                    ("100", Color.purple100),
                    ("200", Color.purple200),
                    ("300", Color.purple300),
                    ("400", Color.purple400),
                    ("500", Color.purple500),
                    ("600", Color.purple600),
                    ("700", Color.purple700),
                    ("800", Color.purple800),
                    ("900", Color.purple900),
                    ("950", Color.purple950)
                ])
            }
            .padding()
        }
    }
}

struct ColorRow: View {
    let name: String
    let colors: [(String, Color)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .tw("text-lg font-semibold text-slate-700")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(colors, id: \.0) { shade, color in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.slate200, lineWidth: 1)
                                )
                            
                            Text(shade)
                                .tw("text-xs text-slate-600")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ColorPaletteExample()
}
