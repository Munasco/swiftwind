import SwiftUI

// MARK: - Filters: blur, brightness, contrast, grayscale, hue, invert, saturate, sepia, drop-shadow, backdrop
extension TailwindModifier {

    func applyFiltersClass(_ className: String, to view: AnyView) -> AnyView? {
        // Blur
        if className.hasPrefix("blur") && !className.hasPrefix("blur-[") {
            if let b = parseBlur(from: className) {
                return AnyView(view.blur(radius: b))
            }
            return nil
        }

        // Brightness
        if className.hasPrefix("brightness-") {
            if let v = extractNumber(from: className, prefix: "brightness-") {
                return AnyView(view.brightness(Double(v) / 100 - 1.0))
            }
            return nil
        }

        // Contrast
        if className.hasPrefix("contrast-") {
            if let v = extractNumber(from: className, prefix: "contrast-") {
                return AnyView(view.contrast(Double(v) / 100))
            }
            return nil
        }

        // Grayscale
        switch className {
        case "grayscale-0": return AnyView(view.grayscale(0))
        case "grayscale": return AnyView(view.grayscale(1))
        default: break
        }

        // Hue rotate
        if className.hasPrefix("hue-rotate-") {
            if let v = extractNumber(from: className, prefix: "hue-rotate-") {
                return AnyView(view.hueRotation(.degrees(Double(v))))
            }
            return nil
        }
        if className.hasPrefix("-hue-rotate-") {
            if let v = extractNumber(from: className, prefix: "-hue-rotate-") {
                return AnyView(view.hueRotation(.degrees(-Double(v))))
            }
            return nil
        }

        // Invert
        switch className {
        case "invert-0": return AnyView(view.colorInvert().colorInvert()) // no-op
        case "invert": return AnyView(view.colorInvert())
        default: break
        }

        // Saturate
        if className.hasPrefix("saturate-") {
            if let v = extractNumber(from: className, prefix: "saturate-") {
                return AnyView(view.saturation(Double(v) / 100))
            }
            return nil
        }

        // Sepia (no direct SwiftUI equivalent, approximate with saturation)
        switch className {
        case "sepia-0": return AnyView(view)
        case "sepia": return AnyView(view.saturation(0.3))
        default: break
        }

        // Drop shadow
        switch className {
        case "drop-shadow-none": return AnyView(view.shadow(radius: 0))
        case "drop-shadow-sm": return AnyView(view.shadow(color: .black.opacity(0.05), radius: 1, y: 1))
        case "drop-shadow": return AnyView(view.shadow(color: .black.opacity(0.1), radius: 1, y: 1))
        case "drop-shadow-md": return AnyView(view.shadow(color: .black.opacity(0.1), radius: 3, y: 2))
        case "drop-shadow-lg": return AnyView(view.shadow(color: .black.opacity(0.1), radius: 4, y: 4))
        case "drop-shadow-xl": return AnyView(view.shadow(color: .black.opacity(0.1), radius: 8, y: 8))
        case "drop-shadow-2xl": return AnyView(view.shadow(color: .black.opacity(0.25), radius: 12, y: 12))
        default: break
        }

        // Backdrop filter families (limited SwiftUI support)
        if className.hasPrefix("backdrop-blur") {
            return AnyView(view)
        }
        if className.hasPrefix("backdrop-brightness-") || className.hasPrefix("backdrop-contrast-") ||
           className.hasPrefix("backdrop-grayscale") || className.hasPrefix("backdrop-hue-rotate-") ||
           className.hasPrefix("backdrop-invert") || className.hasPrefix("backdrop-opacity-") ||
           className.hasPrefix("backdrop-saturate-") || className.hasPrefix("backdrop-sepia") {
            return AnyView(view)
        }

        // Filter utility toggles
        if className == "filter" || className == "filter-none" { return AnyView(view) }

        return nil
    }
}
