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
        if let animationKind = resolveAnimationKind(className) {
            return AnyView(view.modifier(TWAnimatedEffect(kind: animationKind)))
        }

        // Will change (no SwiftUI equivalent, optimization hint)
        if className.hasPrefix("will-change-") { return AnyView(view) }

        return nil
    }

    private func resolveAnimationKind(_ className: String) -> TWAnimationKind? {
        switch className {
        case "animate-none":
            return TWAnimationKind.none
        case "animate-spin":
            return .spin(duration: 1, curve: .linear)
        case "animate-ping":
            return .ping(duration: 1, curve: .easeInOut)
        case "animate-pulse":
            return .pulse(duration: 2, curve: .easeInOut)
        case "animate-bounce":
            return .bounce(duration: 1, curve: .easeInOut)
        default:
            break
        }

        // Tailwind v4 style: animate-[spin_1s_linear_infinite]
        if className.hasPrefix("animate-["),
           let definition = extractAnimationBracketDefinition(className) {
            return parseAnimationDefinition(definition)
        }

        // Tailwind shorthand var syntax: animate-(--animate-wiggle)
        if className.hasPrefix("animate-("), className.hasSuffix(")") {
            let token = String(className.dropFirst("animate-(".count).dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
            guard token.hasPrefix("--"),
                  let raw = TailwindRuntime.rawVariable(token, colorScheme: currentColorScheme()) else { return nil }
            return parseAnimationDefinition(raw)
        }

        // Utility form maps to --animate-* theme vars in Tailwind v4.
        if className.hasPrefix("animate-") {
            let name = String(className.dropFirst("animate-".count))
            guard !name.isEmpty else { return nil }
            let token = "--animate-\(name)"
            if let raw = TailwindRuntime.rawVariable(token, colorScheme: currentColorScheme()) {
                return parseAnimationDefinition(raw)
            }
        }

        return nil
    }

    private func extractAnimationBracketDefinition(_ className: String) -> String? {
        guard className.hasPrefix("animate-["),
              className.hasSuffix("]") else { return nil }
        return String(className.dropFirst("animate-[".count).dropLast())
            .replacingOccurrences(of: "_", with: " ")
    }

    private func parseAnimationDefinition(_ raw: String) -> TWAnimationKind? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let keyframe = trimmed.split(whereSeparator: \.isWhitespace).first.map(String.init)?.lowercased() ?? ""
        let duration = parseDurationSeconds(from: trimmed) ?? 1.0
        let curve = parseAnimationCurve(from: trimmed)

        switch keyframe {
        case "none":
            return TWAnimationKind.none
        case "spin":
            return .spin(duration: duration, curve: curve)
        case "ping":
            return .ping(duration: duration, curve: curve)
        case "pulse":
            return .pulse(duration: duration, curve: curve)
        case "bounce":
            return .bounce(duration: duration, curve: curve)
        default:
            // Unknown keyframes are currently unsupported in SwiftUI runtime mapping.
            return nil
        }
    }

    private func parseDurationSeconds(from raw: String) -> Double? {
        let lowered = raw.lowercased()

        if let msRange = lowered.range(of: #"(\d+(\.\d+)?)ms"#, options: .regularExpression) {
            let token = String(lowered[msRange]).replacingOccurrences(of: "ms", with: "")
            if let value = Double(token) { return value / 1000 }
        }

        if let sRange = lowered.range(of: #"(\d+(\.\d+)?)s"#, options: .regularExpression) {
            let token = String(lowered[sRange]).replacingOccurrences(of: "s", with: "")
            return Double(token)
        }

        return nil
    }

    private func parseAnimationCurve(from raw: String) -> TWAnimationCurve {
        let lowered = raw.lowercased()
        if lowered.contains("linear") { return .linear }
        if lowered.contains("ease-in-out") || lowered.contains("cubic-bezier") { return .easeInOut }
        if lowered.contains("ease-in") { return .easeIn }
        if lowered.contains("ease-out") { return .easeOut }
        return .easeInOut
    }
}

private enum TWAnimationCurve {
    case linear
    case easeIn
    case easeOut
    case easeInOut

    func animation(duration: Double) -> Animation {
        switch self {
        case .linear: return .linear(duration: duration)
        case .easeIn: return .easeIn(duration: duration)
        case .easeOut: return .easeOut(duration: duration)
        case .easeInOut: return .easeInOut(duration: duration)
        }
    }
}

private enum TWAnimationKind {
    case none
    case spin(duration: Double, curve: TWAnimationCurve)
    case ping(duration: Double, curve: TWAnimationCurve)
    case pulse(duration: Double, curve: TWAnimationCurve)
    case bounce(duration: Double, curve: TWAnimationCurve)
}

private struct TWAnimatedEffect: ViewModifier {
    let kind: TWAnimationKind
    @State private var active = false

    func body(content: Content) -> some View {
        baseView(content)
            .onAppear {
                active = true
            }
    }

    @ViewBuilder
    private func baseView(_ content: Content) -> some View {
        switch kind {
        case .none:
            content
        case let .spin(duration, curve):
            content
                .rotationEffect(.degrees(active ? 360 : 0))
                .animation(curve.animation(duration: duration).repeatForever(autoreverses: false), value: active)
        case let .ping(duration, curve):
            content
                .scaleEffect(active ? 2 : 1)
                .opacity(active ? 0 : 1)
                .animation(curve.animation(duration: duration).repeatForever(autoreverses: false), value: active)
        case let .pulse(duration, curve):
            content
                .opacity(active ? 0.5 : 1)
                .animation(curve.animation(duration: duration).repeatForever(autoreverses: true), value: active)
        case let .bounce(duration, curve):
            content
                .offset(y: active ? -10 : 0)
                .animation(curve.animation(duration: duration).repeatForever(autoreverses: true), value: active)
        }
    }
}
