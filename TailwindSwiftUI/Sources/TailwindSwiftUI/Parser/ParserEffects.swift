import SwiftUI

// MARK: - Effects: opacity, shadow, blur, filters, backdrop, blend, transitions, animations
extension TailwindModifier {

    func applyEffectsClass(_ className: String, to view: AnyView) -> AnyView? {
        // Opacity
        if className.hasPrefix("opacity-") {
            if let v = extractNumber(from: className, prefix: "opacity-") {
                return AnyView(view.opacity(Double(v) / 100))
            }
            return nil
        }

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

        // Backdrop blur
        if className.hasPrefix("backdrop-blur") {
            return AnyView(view) // Limited SwiftUI support
        }
        if className.hasPrefix("backdrop-brightness-") || className.hasPrefix("backdrop-contrast-") ||
           className.hasPrefix("backdrop-grayscale") || className.hasPrefix("backdrop-hue-rotate-") ||
           className.hasPrefix("backdrop-invert") || className.hasPrefix("backdrop-opacity-") ||
           className.hasPrefix("backdrop-saturate-") || className.hasPrefix("backdrop-sepia") {
            return AnyView(view)
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

        // Background blend mode
        if className.hasPrefix("bg-blend-") { return AnyView(view) }

        // Transition
        switch className {
        case "transition-none": return AnyView(view.animation(nil, value: false))
        case "transition-all": return AnyView(view.animation(.default, value: false))
        case "transition", "transition-colors", "transition-opacity",
             "transition-shadow", "transition-transform":
            return AnyView(view.animation(.default, value: false))
        default: break
        }

        // Duration
        if className.hasPrefix("duration-") {
            if let v = extractNumber(from: className, prefix: "duration-") {
                return AnyView(view.animation(.easeInOut(duration: Double(v) / 1000), value: false))
            }
            return nil
        }

        // Ease
        switch className {
        case "ease-linear": return AnyView(view.animation(.linear, value: false))
        case "ease-in": return AnyView(view.animation(.easeIn, value: false))
        case "ease-out": return AnyView(view.animation(.easeOut, value: false))
        case "ease-in-out": return AnyView(view.animation(.easeInOut, value: false))
        default: break
        }

        // Delay
        if className.hasPrefix("delay-") {
            if let v = extractNumber(from: className, prefix: "delay-") {
                return AnyView(view.animation(.easeInOut.delay(Double(v) / 1000), value: false))
            }
            return nil
        }

        // Animate
        switch className {
        case "animate-none": return AnyView(view.animation(nil, value: false))
        case "animate-spin": return AnyView(view.rotationEffect(.degrees(360))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: false))
        case "animate-ping": return AnyView(view.scaleEffect(1.5).opacity(0)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: false))
        case "animate-pulse": return AnyView(view.opacity(0.5)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: false))
        case "animate-bounce": return AnyView(view.offset(y: -10)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: false))
        default: break
        }

        // Will change (no SwiftUI equivalent, optimization hint)
        if className.hasPrefix("will-change-") { return AnyView(view) }

        return nil
    }
}
