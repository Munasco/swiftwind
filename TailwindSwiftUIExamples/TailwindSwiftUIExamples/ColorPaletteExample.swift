import SwiftUI
import TailwindSwiftUI

struct ColorPaletteExample: View {
    @State private var emphasize = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("TailwindSwiftUI Color Palette")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 16) {
                    Toggle("Emphasize sample chip", isOn: $emphasize)
                        .font(.headline)
                        .foregroundStyle(Color.white.opacity(0.9))
                        .tint(.pink500)

                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            emphasize.toggle()
                        }
                    } label: {
                        Text(emphasize ? "Emphasized Chip" : "Builder Pattern + State")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(emphasize ? Color.white : Color.slate100)
                            .padding(.horizontal, emphasize ? 24 : 18)
                            .padding(.vertical, emphasize ? 14 : 10)
                            .background(
                                LinearGradient(
                                    colors: emphasize ? [.amber600, .amber800] : [.slate700, .slate800],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: emphasize ? 18 : 14)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                            .cornerRadius(emphasize ? 18 : 14)
                            .shadow(color: Color.black.opacity(emphasize ? 0.35 : 0.2),
                                    radius: emphasize ? 12 : 6,
                                    y: emphasize ? 8 : 4)
                    }
                }
                .padding(16)
                .background(.ultraThinMaterial.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .cornerRadius(18)
                
                // Slate
                ColorRow(name: "Slate", colors: [
                    ("50", .slate50),
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
        .background(
            LinearGradient(
                colors: [.slate950, .slate900, .slate800],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

struct ColorRow: View {
    let name: String
    let colors: [(String, Color)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.headline)
                .foregroundStyle(Color.slate800)
            
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
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.slate600)
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
// MARK: - Tailwind-powered variant

struct ColorPaletteExampleTW: View {
    @State private var emphasize = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("TailwindSwiftUI Color Palette")
                    .tw("text-3xl font-bold text-white")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 16) {
                    Toggle("Emphasize sample chip", isOn: $emphasize)
                        .tw( .text(.slate700))
                        .tint(.pink500)

                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            emphasize.toggle()
                        }
                    } label: {
                        Text(emphasize ? "Emphasized Chip" : "Builder Pattern + State")
                            .tw {
                                #styles {
                                    "px-8"
                                    "bg-blue-500"
                                }
                            }
                            
                   
                    }
                    
                }
                .tw("p-4 rounded-2xl bg-white/5 border border-white/10 backdrop-blur")

                ColorRowTW(name: "Slate", colors: palette(.slate))
                ColorRowTW(name: "Red", colors: palette(.red))
                ColorRowTW(name: "Blue", colors: palette(.blue))
                ColorRowTW(name: "Green", colors: palette(.green))
                ColorRowTW(name: "Purple", colors: palette(.purple))
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [.slate950, .slate900, .slate800],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .ignoresSafeArea(edges: .bottom)
    }

    private enum PaletteKind { case slate, red, blue, green, purple }

    private func palette(_ kind: PaletteKind) -> [(String, Color)] {
        switch kind {
        case .slate:
            return [("50", .slate50), ("100", .slate100), ("200", .slate200), ("300", .slate300), ("400", .slate400),
                    ("500", .slate500), ("600", .slate600), ("700", .slate700), ("800", .slate800), ("900", .slate900), ("950", .slate950)]
        case .red:
            return [("50", .red50), ("100", .red100), ("200", .red200), ("300", .red300), ("400", .red400),
                    ("500", .red500), ("600", .red600), ("700", .red700), ("800", .red800), ("900", .red900), ("950", .red950)]
        case .blue:
            return [("50", .blue50), ("100", .blue100), ("200", .blue200), ("300", .blue300), ("400", .blue400),
                    ("500", .blue500), ("600", .blue600), ("700", .blue700), ("800", .blue800), ("900", .blue900), ("950", .blue950)]
        case .green:
            return [("50", .green50), ("100", .green100), ("200", .green200), ("300", .green300), ("400", .green400),
                    ("500", .green500), ("600", .green600), ("700", .green700), ("800", .green800), ("900", .green900), ("950", .green950)]
        case .purple:
            return [("50", .purple50), ("100", .purple100), ("200", .purple200), ("300", .purple300), ("400", .purple400),
                    ("500", .purple500), ("600", .purple600), ("700", .purple700), ("800", .purple800), ("900", .purple900), ("950", .purple950)]
        }
    }
}

struct ColorRowTW: View {
    let name: String
    let colors: [(String, Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .tw("text-lg font-semibold text-slate-100")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(colors, id: \.0, content: swatch)
                }
            }
        }
        .tw("p-1")
    }

    @ViewBuilder
    private func swatch(shade: String, color: Color) -> some View {
        VStack(spacing: 4) {
            let shape = RoundedRectangle(cornerRadius: 10)
            
            shape
                .tw("fill-[\(String(describing: color.hex))] size-16 stroke-white/20 stroke-1")

            Text(shade)
                .tw("text-[11px] font-semibold text-slate-200")
        }
    }
}
#Preview {
    ColorPaletteExampleTW()
}

