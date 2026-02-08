import SwiftUI

// MARK: - Sizing: w, h, size, min/max, fractions, screen, named
extension TailwindModifier {

    func applySizingClass(_ className: String, to view: AnyView) -> AnyView? {

        // Size (w + h combined)
        if className.hasPrefix("size-") {
            let val = className.replacingOccurrences(of: "size-", with: "")
            switch val {
            case "full": return AnyView(view.frame(maxWidth: .infinity, maxHeight: .infinity))
            case "min": return AnyView(view.fixedSize())
            case "max": return AnyView(view.frame(maxWidth: .infinity, maxHeight: .infinity))
            case "fit": return AnyView(view.fixedSize())
            case "screen": return AnyView(view.frame(maxWidth: .infinity, maxHeight: .infinity))
            case "auto": return AnyView(view)
            default:
                if let v = extractNumber(from: className, prefix: "size-") {
                    return AnyView(view.frame(width: spacingValue(v), height: spacingValue(v)))
                }
            }
            return nil
        }

        // Width
        if className.hasPrefix("w-") && !className.hasPrefix("will-") {
            let val = className.replacingOccurrences(of: "w-", with: "")
            switch val {
            case "full": return AnyView(view.frame(maxWidth: .infinity))
            case "screen": return AnyView(view.frame(maxWidth: .infinity))
            case "svw", "lvw", "dvw": return AnyView(view.frame(maxWidth: .infinity))
            case "min": return AnyView(view.fixedSize(horizontal: true, vertical: false))
            case "max": return AnyView(view.frame(maxWidth: .infinity))
            case "fit": return AnyView(view.fixedSize(horizontal: true, vertical: false))
            case "auto": return AnyView(view)
            case "px": return AnyView(view.frame(width: 1))
            // Fractions
            case "1/2": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.5, y: 1))
            case "1/3": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.333, y: 1))
            case "2/3": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.667, y: 1))
            case "1/4": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.25, y: 1))
            case "2/4": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.5, y: 1))
            case "3/4": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.75, y: 1))
            case "1/5": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.2, y: 1))
            case "2/5": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.4, y: 1))
            case "3/5": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.6, y: 1))
            case "4/5": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.8, y: 1))
            case "1/6": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.167, y: 1))
            case "5/6": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.833, y: 1))
            case "1/12": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.083, y: 1))
            case "5/12": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.417, y: 1))
            case "7/12": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.583, y: 1))
            case "11/12": return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.917, y: 1))
            default:
                if let v = extractNumber(from: className, prefix: "w-") {
                    return AnyView(view.frame(width: spacingValue(v)))
                }
            }
            return nil
        }

        // Height
        if className.hasPrefix("h-") && !className.hasPrefix("hyphens-") {
            let val = className.replacingOccurrences(of: "h-", with: "")
            switch val {
            case "full": return AnyView(view.frame(maxHeight: .infinity))
            case "screen": return AnyView(view.frame(maxHeight: .infinity))
            case "svh", "lvh", "dvh": return AnyView(view.frame(maxHeight: .infinity))
            case "min": return AnyView(view.fixedSize(horizontal: false, vertical: true))
            case "max": return AnyView(view.frame(maxHeight: .infinity))
            case "fit": return AnyView(view.fixedSize(horizontal: false, vertical: true))
            case "auto": return AnyView(view)
            case "px": return AnyView(view.frame(height: 1))
            // Fractions
            case "1/2": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.5))
            case "1/3": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.333))
            case "2/3": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.667))
            case "1/4": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.25))
            case "3/4": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.75))
            case "1/5": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.2))
            case "2/5": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.4))
            case "3/5": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.6))
            case "4/5": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.8))
            case "1/6": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.167))
            case "5/6": return AnyView(view.frame(maxHeight: .infinity).scaleEffect(x: 1, y: 0.833))
            default:
                if let v = extractNumber(from: className, prefix: "h-") {
                    return AnyView(view.frame(height: spacingValue(v)))
                }
            }
            return nil
        }

        // Min width
        if className.hasPrefix("min-w-") {
            let val = className.replacingOccurrences(of: "min-w-", with: "")
            switch val {
            case "0": return AnyView(view.frame(minWidth: 0))
            case "full": return AnyView(view.frame(minWidth: .infinity))
            case "min": return AnyView(view)
            case "max": return AnyView(view)
            case "fit": return AnyView(view)
            default:
                if let v = extractNumber(from: className, prefix: "min-w-") {
                    return AnyView(view.frame(minWidth: spacingValue(v)))
                }
            }
            return nil
        }

        // Max width (named sizes)
        if className.hasPrefix("max-w-") {
            let val = className.replacingOccurrences(of: "max-w-", with: "")
            switch val {
            case "none": return AnyView(view)
            case "0": return AnyView(view.frame(maxWidth: 0))
            case "xs": return AnyView(view.frame(maxWidth: 320))
            case "sm": return AnyView(view.frame(maxWidth: 384))
            case "md": return AnyView(view.frame(maxWidth: 448))
            case "lg": return AnyView(view.frame(maxWidth: 512))
            case "xl": return AnyView(view.frame(maxWidth: 576))
            case "2xl": return AnyView(view.frame(maxWidth: 672))
            case "3xl": return AnyView(view.frame(maxWidth: 768))
            case "4xl": return AnyView(view.frame(maxWidth: 896))
            case "5xl": return AnyView(view.frame(maxWidth: 1024))
            case "6xl": return AnyView(view.frame(maxWidth: 1152))
            case "7xl": return AnyView(view.frame(maxWidth: 1280))
            case "full": return AnyView(view.frame(maxWidth: .infinity))
            case "min": return AnyView(view)
            case "max": return AnyView(view)
            case "fit": return AnyView(view)
            case "prose": return AnyView(view.frame(maxWidth: 640))
            case "screen-sm": return AnyView(view.frame(maxWidth: 640))
            case "screen-md": return AnyView(view.frame(maxWidth: 768))
            case "screen-lg": return AnyView(view.frame(maxWidth: 1024))
            case "screen-xl": return AnyView(view.frame(maxWidth: 1280))
            case "screen-2xl": return AnyView(view.frame(maxWidth: 1536))
            default:
                if let v = extractNumber(from: className, prefix: "max-w-") {
                    return AnyView(view.frame(maxWidth: spacingValue(v)))
                }
            }
            return nil
        }

        // Min height
        if className.hasPrefix("min-h-") {
            let val = className.replacingOccurrences(of: "min-h-", with: "")
            switch val {
            case "0": return AnyView(view.frame(minHeight: 0))
            case "full": return AnyView(view.frame(minHeight: .infinity))
            case "screen": return AnyView(view.frame(minHeight: .infinity))
            case "svh", "lvh", "dvh": return AnyView(view.frame(minHeight: .infinity))
            case "min": return AnyView(view)
            case "max": return AnyView(view)
            case "fit": return AnyView(view)
            default:
                if let v = extractNumber(from: className, prefix: "min-h-") {
                    return AnyView(view.frame(minHeight: spacingValue(v)))
                }
            }
            return nil
        }

        // Max height
        if className.hasPrefix("max-h-") {
            let val = className.replacingOccurrences(of: "max-h-", with: "")
            switch val {
            case "none": return AnyView(view)
            case "0": return AnyView(view.frame(maxHeight: 0))
            case "full": return AnyView(view.frame(maxHeight: .infinity))
            case "screen": return AnyView(view.frame(maxHeight: .infinity))
            case "svh", "lvh", "dvh": return AnyView(view.frame(maxHeight: .infinity))
            case "min": return AnyView(view)
            case "max": return AnyView(view)
            case "fit": return AnyView(view)
            default:
                if let v = extractNumber(from: className, prefix: "max-h-") {
                    return AnyView(view.frame(maxHeight: spacingValue(v)))
                }
            }
            return nil
        }

        // Aspect ratio
        switch className {
        case "aspect-auto": return AnyView(view)
        case "aspect-square": return AnyView(view.aspectRatio(1, contentMode: .fit))
        case "aspect-video": return AnyView(view.aspectRatio(16/9, contentMode: .fit))
        default: break
        }

        return nil
    }
}
