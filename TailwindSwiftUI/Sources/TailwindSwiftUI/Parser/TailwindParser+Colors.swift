import SwiftUI

// MARK: - Colors: bg-*, text-* colors, shadow colors
 private let twBgNonColorPrefixes: [String] = [
    "bg-opacity-", "bg-gradient-", "bg-clip-", "bg-origin-",
    "bg-no-repeat", "bg-repeat", "bg-cover", "bg-contain",
    "bg-center", "bg-fixed", "bg-local", "bg-scroll"
]

private let twTextNonColorExact: Set<String> = [
    "text-left", "text-center", "text-right", "text-justify",
    "text-wrap", "text-nowrap", "text-balance", "text-pretty",
    "text-clip", "text-ellipsis"
]

extension TailwindModifier {
    func applyColorClass(_ className: String, to view: AnyView) -> AnyView? {
        // Fast route on first character to avoid checking every prefix branch.
        switch className.first {
        case "b":
            if className.hasPrefix("bg-opacity-") {
                // Handled via color alpha - pass through
                return AnyView(view)
            }
            if className.hasPrefix("bg-") {
                if className == "bg-none" || twBgNonColorPrefixes.contains(where: className.hasPrefix) {
                    return nil
                }
                if let color = parseColor(from: className, prefix: "bg-") {
                    return AnyView(view.background(color))
                }
                return nil
            }

        case "t":
            if className.hasPrefix("text-") {
                if parseTextSize(from: className) != nil { return nil }
                if twTextNonColorExact.contains(className) { return nil }
                if let color = parseColor(from: className, prefix: "text-") {
                    return AnyView(view.foregroundColor(color))
                }
                return nil
            }

        case "s":
            if className.hasPrefix("shadow-") {
                if parseShadow(from: className) != nil { return nil }
                if let color = parseColor(from: className, prefix: "shadow-") {
                    return AnyView(view.shadow(color: color, radius: 4, y: 2))
                }
                return nil
            }
            if className == "stroke-none" {
                return AnyView(view.environment(\.twInheritedStrokeColor, nil))
            }
            if className.hasPrefix("stroke-") {
                let suffix = String(className.dropFirst("stroke-".count))
                if let width = parseStrokeWidth(suffix) {
                    return AnyView(view.environment(\.twInheritedStrokeWidth, width))
                }
                if let color = parseColor(from: className, prefix: "stroke-") {
                    return AnyView(view.environment(\.twInheritedStrokeColor, color))
                }
                return nil
            }

        case "p":
            if className.hasPrefix("placeholder-") {
                return AnyView(view)
            }

        case "d":
            if className.hasPrefix("decoration-") {
                return AnyView(view)
            }

        case "a":
            if className.hasPrefix("accent-") {
                if let color = parseColor(from: className, prefix: "accent-") {
                    return AnyView(view.tint(color))
                }
                return nil
            }

        case "c":
            if className.hasPrefix("caret-") {
                if let color = parseColor(from: className, prefix: "caret-") {
                    return AnyView(view.tint(color))
                }
                return nil
            }

        case "f":
            if className == "fill-none" {
                return AnyView(
                    view
                        .environment(\.twInheritedFillColor, .clear)
                        .foregroundStyle(.clear)
                )
            }
            if className.hasPrefix("fill-") {
                if let color = parseColor(from: className, prefix: "fill-") {
                    return AnyView(
                        view
                            .environment(\.twInheritedFillColor, color)
                            .foregroundStyle(color)
                    )
                }
                return nil
            }

        default:
            break
        }

        return nil
    }

    private func parseStrokeWidth(_ suffix: String) -> CGFloat? {
        switch suffix {
        case "0": return 0
        case "1": return 1
        case "2": return 2
        case "3": return 3
        default: break
        }
        if suffix.hasPrefix("["), suffix.hasSuffix("]") {
            let innerRaw = String(suffix.dropFirst().dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
            if let val = parseUnitNumber(innerRaw) {
                return CGFloat(val)
            }
            if let raw = TailwindRuntime.rawVariable(innerRaw),
               let fromVar = parseUnitNumber(raw) {
                return CGFloat(fromVar)
            }
        }
        return nil
    }

    private func parseUnitNumber(_ raw: String) -> Double? {
        let token = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if token.hasSuffix("px") || token.hasSuffix("pt") {
            return Double(token.dropLast(2))
        }
        return Double(token)
    }

    // MARK: - Color Lookup Table
    func getColorByName(_ name: String, shade: String) -> Color? {
        ColorPalette.colorByName(name, shade: shade)
    }
}
