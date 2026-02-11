import SwiftUI

// MARK: - Transforms: scale, rotate, translate, skew, origin
extension TailwindModifier {

    func applyTransformClass(_ className: String, to view: AnyView) -> AnyView? {
        // Scale
        if className.hasPrefix("scale-x-") {
            if let v = extractNumber(from: className, prefix: "scale-x-") {
                return AnyView(view.scaleEffect(x: Double(v) / 100, y: 1))
            }
            return nil
        }
        if className.hasPrefix("scale-y-") {
            if let v = extractNumber(from: className, prefix: "scale-y-") {
                return AnyView(view.scaleEffect(x: 1, y: Double(v) / 100))
            }
            return nil
        }
        if className.hasPrefix("scale-") {
            if let v = extractNumber(from: className, prefix: "scale-") {
                return AnyView(view.scaleEffect(Double(v) / 100))
            }
            return nil
        }

        // Rotate (positive)
        if className.hasPrefix("rotate-") && !className.hasPrefix("-rotate-") {
            if let v = extractNumber(from: className, prefix: "rotate-") {
                return AnyView(view.rotationEffect(.degrees(Double(v))))
            }
            return nil
        }
        // Rotate (negative)
        if className.hasPrefix("-rotate-") {
            if let v = extractNumber(from: className, prefix: "-rotate-") {
                return AnyView(view.rotationEffect(.degrees(-Double(v))))
            }
            return nil
        }

        // Translate X
        if className.hasPrefix("translate-x-") {
            if let v = extractNumber(from: className, prefix: "translate-x-") {
                return AnyView(view.offset(x: spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("-translate-x-") {
            if let v = extractNumber(from: className, prefix: "-translate-x-") {
                return AnyView(view.offset(x: -spacingValue(v)))
            }
            return nil
        }

        // Translate Y
        if className.hasPrefix("translate-y-") {
            if let v = extractNumber(from: className, prefix: "translate-y-") {
                return AnyView(view.offset(y: spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("-translate-y-") {
            if let v = extractNumber(from: className, prefix: "-translate-y-") {
                return AnyView(view.offset(y: -spacingValue(v)))
            }
            return nil
        }

        // Skew (approximate with rotation)
        if className.hasPrefix("skew-x-") {
            if let v = extractNumber(from: className, prefix: "skew-x-") {
                return AnyView(view.rotationEffect(.degrees(Double(v) * 0.5)))
            }
            return nil
        }
        if className.hasPrefix("skew-y-") {
            if let v = extractNumber(from: className, prefix: "skew-y-") {
                return AnyView(view.rotationEffect(.degrees(Double(v) * 0.5)))
            }
            return nil
        }
        if className.hasPrefix("-skew-x-") || className.hasPrefix("-skew-y-") {
            return AnyView(view)
        }

        // Transform origin
        switch className {
        case "origin-center", "origin-top", "origin-top-right",
             "origin-right", "origin-bottom-right", "origin-bottom",
             "origin-bottom-left", "origin-left", "origin-top-left":
            return AnyView(view)
        default: break
        }

        // Transform GPU/CPU hints
        switch className {
        case "transform-none": return AnyView(view)
        case "transform-gpu", "transform-cpu": return AnyView(view)
        default: break
        }

        // Backface visibility
        switch className {
        case "backface-visible", "backface-hidden": return AnyView(view)
        default: break
        }

        // Perspective
        if className.hasPrefix("perspective-") { return AnyView(view) }

        return nil
    }
}
