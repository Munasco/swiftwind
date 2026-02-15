import SwiftUI

// MARK: - Effects: opacity, blend modes, mask utilities
extension TailwindModifier {

    func applyEffectsClass(_ className: String, to view: AnyView) -> AnyView? {
        // Opacity
        if className.hasPrefix("opacity-") {
            if let v = extractNumber(from: className, prefix: "opacity-") {
                return AnyView(view.opacity(Double(v) / 100))
            }
            return nil
        }

        // Mix blend mode
        switch className {
        case "mix-blend-normal": return AnyView(view.blendMode(.normal))
        case "mix-blend-multiply": return AnyView(view.blendMode(.multiply))
        case "mix-blend-screen": return AnyView(view.blendMode(.screen))
        case "mix-blend-overlay": return AnyView(view.blendMode(.overlay))
        case "mix-blend-darken": return AnyView(view.blendMode(.darken))
        case "mix-blend-lighten": return AnyView(view.blendMode(.lighten))
        case "mix-blend-color-dodge": return AnyView(view.blendMode(.colorDodge))
        case "mix-blend-color-burn": return AnyView(view.blendMode(.colorBurn))
        case "mix-blend-hard-light": return AnyView(view.blendMode(.hardLight))
        case "mix-blend-soft-light": return AnyView(view.blendMode(.softLight))
        case "mix-blend-difference": return AnyView(view.blendMode(.difference))
        case "mix-blend-exclusion": return AnyView(view.blendMode(.exclusion))
        case "mix-blend-hue": return AnyView(view.blendMode(.hue))
        case "mix-blend-saturation": return AnyView(view.blendMode(.saturation))
        case "mix-blend-color": return AnyView(view.blendMode(.color))
        case "mix-blend-luminosity": return AnyView(view.blendMode(.luminosity))
        case "mix-blend-plus-lighter": return AnyView(view.blendMode(.plusLighter))
        default: break
        }

        // Background blend mode (no direct SwiftUI equivalent)
        if className.hasPrefix("bg-blend-") { return AnyView(view) }

        // Text shadow family (currently no direct SwiftUI equivalent)
        if className.hasPrefix("text-shadow") { return AnyView(view) }

        // Mask family (currently no direct SwiftUI equivalent)
        if className.hasPrefix("mask-") { return AnyView(view) }

        return nil
    }
}
