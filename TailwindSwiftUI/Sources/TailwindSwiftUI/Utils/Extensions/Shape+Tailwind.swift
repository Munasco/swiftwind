import SwiftUI

// MARK: - Tailwind modifier for Shape types
// Handles fill-*, stroke-* (color + width), then delegates remaining classes to View .tw()
//
// Usage:
//   MyCustomShape().tw("fill-red-500 stroke-blue-500 stroke-2 w-24 h-24 shadow-lg")
//   Circle().tw("fill-emerald-400 stroke-white stroke-2 size-16")
//   RoundedRectangle(cornerRadius: 8).tw("fill-[#1da1f2] stroke-none w-full h-12")

public extension Shape {
    /// Tailwind-style className string for Shape types.
    /// Supports fill-*, stroke-* (color and width), plus all standard View classes.
    func tw(_ classes: String) -> some View {
        let tokens = classes.split(separator: " ").map(String.init)
        let expanded = TailwindRuntime.expandUtilityAliases(tokens).joined(separator: " ")
        return TailwindShapeModifier(shape: self, classes: expanded)
    }
}

struct TailwindShapeModifier<S: Shape>: View {
    let shape: S
    let classes: String
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.twInheritedFillColor) private var inheritedFillColor
    @Environment(\.twInheritedStrokeColor) private var inheritedStrokeColor
    @Environment(\.twInheritedStrokeWidth) private var inheritedStrokeWidth

    var body: some View {
        let parsed = Self.parseShapeClasses(classes, colorScheme: colorScheme)
        let effectiveFill = parsed.fillColor ?? (parsed.fillNone ? .clear : inheritedFillColor)
        let effectiveStrokeColor = parsed.strokeNone ? nil : (parsed.strokeColor ?? inheritedStrokeColor)
        let effectiveStrokeWidth = parsed.strokeWidth ?? inheritedStrokeWidth

        // Build the shape view: fill + optional stroke overlay
        // In SwiftUI you can't call .fill() and .stroke() on the same Shape,
        // so we use ZStack or overlay composition.
        let filled: AnyView = {
            if let fillColor = effectiveFill {
                return AnyView(shape.fill(fillColor))
            } else if effectiveStrokeColor != nil || effectiveStrokeWidth != nil {
                // No fill specified but stroke is — use clear fill so shape is transparent
                return AnyView(shape.fill(.clear))
            } else {
                // No fill or stroke — default SwiftUI behavior (foregroundColor)
                return AnyView(shape)
            }
        }()

        let composed: AnyView = {
            if let strokeColor = effectiveStrokeColor {
                let width = effectiveStrokeWidth ?? 1
                return AnyView(
                    filled.overlay(shape.stroke(strokeColor, lineWidth: width))
                )
            } else if parsed.strokeNone {
                return filled
            } else {
                return filled
            }
        }()

        // Pass remaining (non-shape) classes to the View-level .tw()
        if parsed.remainingClasses.isEmpty {
            composed
        } else {
            composed.tw(parsed.remainingClasses.joined(separator: " "))
        }
    }

    // MARK: - Parsing

    struct ParsedShapeClasses {
        var fillColor: Color?
        var fillNone: Bool = false
        var strokeColor: Color?
        var strokeWidth: CGFloat?
        var strokeNone: Bool = false
        var remainingClasses: [String] = []

        var hasStroke: Bool {
            strokeColor != nil || strokeWidth != nil
        }
    }

    static func parseShapeClasses(_ classes: String, colorScheme: ColorScheme = .light) -> ParsedShapeClasses {
        let tokens = classes.split(separator: " ").map(String.init)
        var result = ParsedShapeClasses()

        for token in tokens {
            // fill-none
            if token == "fill-none" {
                result.fillNone = true
                result.fillColor = .clear
                continue
            }

            // fill-{color}
            if token.hasPrefix("fill-") {
                if let color = TailwindColorResolver.parseColor(
                    token,
                    prefix: "fill-",
                    colorScheme: colorScheme
                ) {
                    result.fillColor = color
                    continue
                }
            }

            // stroke-none
            if token == "stroke-none" {
                result.strokeNone = true
                continue
            }

            // stroke-{width} (numeric: 0, 1, 2, 3 or arbitrary [3px])
            if token.hasPrefix("stroke-") {
                let suffix = token.replacingOccurrences(of: "stroke-", with: "")

                // Check for preset widths first
                if let width = strokeWidthValue(suffix) {
                    result.strokeWidth = width
                    continue
                }

                // Check for arbitrary width: stroke-[3px]
                if suffix.hasPrefix("[") && suffix.hasSuffix("]") {
                    let inner = String(suffix.dropFirst().dropLast())
                        .replacingOccurrences(of: "px", with: "")
                        .replacingOccurrences(of: "pt", with: "")
                    if let val = Double(inner) {
                        result.strokeWidth = CGFloat(val)
                        continue
                    }

                    let token = String(suffix.dropFirst().dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
                    if let raw = TailwindRuntime.rawVariable(token, colorScheme: colorScheme) {
                        let normalized = raw
                            .replacingOccurrences(of: "px", with: "")
                            .replacingOccurrences(of: "pt", with: "")
                        if let fromVar = Double(normalized) {
                            result.strokeWidth = CGFloat(fromVar)
                            continue
                        }
                    }
                }

                // Otherwise try as color: stroke-red-500, stroke-[#hex]
                if let color = TailwindColorResolver.parseColor(
                    token,
                    prefix: "stroke-",
                    colorScheme: colorScheme
                ) {
                    result.strokeColor = color
                    continue
                }
            }

            // Everything else passes through to View .tw()
            result.remainingClasses.append(token)
        }

        return result
    }

    /// Tailwind stroke width presets (maps to CSS stroke-width values)
    private static func strokeWidthValue(_ suffix: String) -> CGFloat? {
        switch suffix {
        case "0": return 0
        case "1": return 1
        case "2": return 2
        case "3": return 3
        default: return nil
        }
    }
}
