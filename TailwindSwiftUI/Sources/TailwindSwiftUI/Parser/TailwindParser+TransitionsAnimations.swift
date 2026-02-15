import SwiftUI

// MARK: - Transitions & Animations: transition, duration, timing, delay, animate, will-change
extension TailwindModifier {

    func applyTransitionsAnimationsClass(_ className: String, to view: AnyView) -> AnyView? {
        // Transition
        switch className {
        case "transition-none": return AnyView(view.animation(nil, value: false))
        case "transition-all": return AnyView(view.animation(.default, value: false))
        case "transition", "transition-colors", "transition-opacity",
             "transition-shadow", "transition-transform", "transition-behavior":
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

        // Will-change (optimization hint only)
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
