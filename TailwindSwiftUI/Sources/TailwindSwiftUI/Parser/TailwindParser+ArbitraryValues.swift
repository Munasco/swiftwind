import SwiftUI

// MARK: - Bracket/Arbitrary Values: p-[20px], w-[300], bg-[#1da1f2], etc.
extension TailwindModifier {

    func applyBracketClass(_ className: String, to view: AnyView) -> AnyView? {
        guard className.contains("[") else { return nil }

        // Padding brackets
        if className.hasPrefix("p-[") { if let v = extractBracketValue(from: className, prefix: "p-") { return AnyView(view.padding(v)) } }
        if className.hasPrefix("px-[") { if let v = extractBracketValue(from: className, prefix: "px-") { return AnyView(view.padding(.horizontal, v)) } }
        if className.hasPrefix("py-[") { if let v = extractBracketValue(from: className, prefix: "py-") { return AnyView(view.padding(.vertical, v)) } }
        if className.hasPrefix("pt-[") { if let v = extractBracketValue(from: className, prefix: "pt-") { return AnyView(view.padding(.top, v)) } }
        if className.hasPrefix("pr-[") { if let v = extractBracketValue(from: className, prefix: "pr-") { return AnyView(view.padding(.trailing, v)) } }
        if className.hasPrefix("pb-[") { if let v = extractBracketValue(from: className, prefix: "pb-") { return AnyView(view.padding(.bottom, v)) } }
        if className.hasPrefix("pl-[") { if let v = extractBracketValue(from: className, prefix: "pl-") { return AnyView(view.padding(.leading, v)) } }

        // Margin brackets
        if className.hasPrefix("m-[") { if let v = extractBracketValue(from: className, prefix: "m-") { return AnyView(view.padding(v)) } }

        // Sizing brackets
        if className.hasPrefix("w-[") { if let v = extractBracketValue(from: className, prefix: "w-") { return AnyView(view.frame(width: v)) } }
        if className.hasPrefix("h-[") { if let v = extractBracketValue(from: className, prefix: "h-") { return AnyView(view.frame(height: v)) } }
        if className.hasPrefix("size-[") { if let v = extractBracketValue(from: className, prefix: "size-") { return AnyView(view.frame(width: v, height: v)) } }
        if className.hasPrefix("min-w-[") { if let v = extractBracketValue(from: className, prefix: "min-w-") { return AnyView(view.frame(minWidth: v)) } }
        if className.hasPrefix("max-w-[") { if let v = extractBracketValue(from: className, prefix: "max-w-") { return AnyView(view.frame(maxWidth: v)) } }
        if className.hasPrefix("min-h-[") { if let v = extractBracketValue(from: className, prefix: "min-h-") { return AnyView(view.frame(minHeight: v)) } }
        if className.hasPrefix("max-h-[") { if let v = extractBracketValue(from: className, prefix: "max-h-") { return AnyView(view.frame(maxHeight: v)) } }
        if className.hasPrefix("aspect-[") {
            if let raw = extractBracketInner(from: className, prefix: "aspect-"),
               let ratio = resolveAspectRatio(raw) {
                return AnyView(view.aspectRatio(ratio, contentMode: .fit))
            }
            return AnyView(view)
        }

        // Gap brackets
        if className.hasPrefix("gap-[") { return AnyView(view) }

        // Text/font size brackets
        if className.hasPrefix("text-[") {
            if let color = parseBracketColor(from: className, prefix: "text-") { return AnyView(view.foregroundColor(color)) }
            if let v = extractBracketValue(from: className, prefix: "text-") { return AnyView(view.font(.system(size: v))) }
        }

        // Color brackets
        if className.hasPrefix("bg-[") {
            if let color = parseBracketColor(from: className, prefix: "bg-") { return AnyView(view.background(color)) }
            if let gradient = parseBracketBackgroundImage(from: className, prefix: "bg-") {
                return AnyView(view.background(gradient))
            }
            // Deliberately no-op for unsupported arbitrary background image/value forms,
            // e.g. bg-[url(...)] or bg-[var(--token)].
            return AnyView(view)
        }
        if className.hasPrefix("border-[") {
            if let color = parseBracketColor(from: className, prefix: "border-") {
                return AnyView(view.overlay(RoundedRectangle(cornerRadius: 0).stroke(color, lineWidth: 1)))
            }
            if let v = extractBracketValue(from: className, prefix: "border-") {
                return AnyView(view.overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray.opacity(0.3), lineWidth: v)))
            }
        }

        // Rounded brackets
        if className.hasPrefix("rounded-[") {
            if let v = extractBracketValue(from: className, prefix: "rounded-") {
                return AnyView(view.clipShape(RoundedRectangle(cornerRadius: v)))
            }
        }

        // Effect brackets
        if className.hasPrefix("opacity-[") { if let v = extractBracketValue(from: className, prefix: "opacity-") { return AnyView(view.opacity(Double(v) / 100)) } }
        if className.hasPrefix("z-[") { if let v = extractBracketValue(from: className, prefix: "z-") { return AnyView(view.zIndex(Double(v))) } }
        if className.hasPrefix("blur-[") { if let v = extractBracketValue(from: className, prefix: "blur-") { return AnyView(view.blur(radius: v)) } }

        // Transform brackets
        if className.hasPrefix("scale-[") { if let v = extractBracketValue(from: className, prefix: "scale-") { return AnyView(view.scaleEffect(Double(v) / 100)) } }
        if className.hasPrefix("rotate-[") { if let v = extractBracketValue(from: className, prefix: "rotate-") { return AnyView(view.rotationEffect(.degrees(Double(v)))) } }
        if className.hasPrefix("translate-x-[") { if let v = extractBracketValue(from: className, prefix: "translate-x-") { return AnyView(view.offset(x: v)) } }
        if className.hasPrefix("translate-y-[") { if let v = extractBracketValue(from: className, prefix: "translate-y-") { return AnyView(view.offset(y: v)) } }

        // Inset brackets
        if className.hasPrefix("top-[") { if let v = extractBracketValue(from: className, prefix: "top-") { return AnyView(view.offset(y: v)) } }
        if className.hasPrefix("bottom-[") { if let v = extractBracketValue(from: className, prefix: "bottom-") { return AnyView(view.offset(y: -v)) } }
        if className.hasPrefix("left-[") { if let v = extractBracketValue(from: className, prefix: "left-") { return AnyView(view.offset(x: v)) } }
        if className.hasPrefix("right-[") { if let v = extractBracketValue(from: className, prefix: "right-") { return AnyView(view.offset(x: -v)) } }
        if className.hasPrefix("inset-x-[") { if let v = extractBracketValue(from: className, prefix: "inset-x-") { return AnyView(view.offset(x: v)) } }
        if className.hasPrefix("inset-y-[") { if let v = extractBracketValue(from: className, prefix: "inset-y-") { return AnyView(view.offset(y: v)) } }
        if className.hasPrefix("inset-[") { if let v = extractBracketValue(from: className, prefix: "inset-") { return AnyView(view.offset(x: v, y: v)) } }

        // Duration/delay brackets
        if className.hasPrefix("duration-[") { if let v = extractBracketValue(from: className, prefix: "duration-") { return AnyView(view.animation(.easeInOut(duration: Double(v) / 1000), value: false)) } }
        if className.hasPrefix("delay-[") { if let v = extractBracketValue(from: className, prefix: "delay-") { return AnyView(view.animation(.easeInOut.delay(Double(v) / 1000), value: false)) } }

        // Line height bracket
        if className.hasPrefix("leading-[") { if let v = extractBracketValue(from: className, prefix: "leading-") { return AnyView(view.lineSpacing(v)) } }

        // Tracking bracket
        if className.hasPrefix("tracking-[") { if let v = extractBracketValue(from: className, prefix: "tracking-") { return AnyView(view.tracking(v)) } }

        // Ring bracket color
        if className.hasPrefix("ring-[") {
            if let color = parseBracketColor(from: className, prefix: "ring-") {
                return AnyView(view.overlay(RoundedRectangle(cornerRadius: resolvedOverlayCornerRadius()).stroke(color, lineWidth: 3)))
            }
        }

        return AnyView(view) // Unrecognized bracket, pass through
    }

    private func parseBracketBackgroundImage(from className: String, prefix: String) -> LinearGradient? {
        guard let inner = extractBracketInner(from: className, prefix: prefix) else { return nil }
        // Tailwind arbitrary background image supports values like:
        // bg-[linear-gradient(...)]
        // bg-[image:linear-gradient(...)]
        let value: String = {
            if inner.hasPrefix("image:") {
                return String(inner.dropFirst("image:".count))
            }
            return inner
        }()
        return parseLinearGradient(value)
    }

    private func parseLinearGradient(_ rawValue: String) -> LinearGradient? {
        guard rawValue.hasPrefix("linear-gradient("), rawValue.hasSuffix(")") else { return nil }

        let payload = String(rawValue.dropFirst("linear-gradient(".count).dropLast())
            .replacingOccurrences(of: "_", with: " ")
        let parts = payload.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard parts.count >= 2 else { return nil }

        var direction = "to bottom"
        var colorTokens = parts
        if isDirectionOrAngle(parts[0]) {
            direction = parts[0].lowercased()
            colorTokens = Array(parts.dropFirst())
        }

        let colors = colorTokens.compactMap(parseGradientColorToken)
        guard colors.count >= 2 else { return nil }

        let (start, end) = gradientPoints(for: direction)
        return LinearGradient(
            colors: colors,
            startPoint: start,
            endPoint: end,
            interpolation: .oklch
        )
    }

    private func extractBracketInner(from className: String, prefix: String) -> String? {
        let valueStr = className.replacingOccurrences(of: prefix, with: "")
        guard valueStr.hasPrefix("["), valueStr.hasSuffix("]") else { return nil }
        return String(valueStr.dropFirst().dropLast())
    }

    private func resolveAspectRatio(_ raw: String) -> CGFloat? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("var("), trimmed.hasSuffix(")") {
            let name = trimmed
                .dropFirst("var(".count)
                .dropLast()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if let resolved = TailwindRuntime.rawVariable(name, colorScheme: currentColorScheme()) {
                return resolveAspectRatio(resolved)
            }
        }
        if trimmed.hasPrefix("--"),
           let resolved = TailwindRuntime.rawVariable(trimmed, colorScheme: currentColorScheme()) {
            return resolveAspectRatio(resolved)
        }
        let slash = trimmed.split(separator: "/", maxSplits: 1).map(String.init)
        if slash.count == 2,
           let lhs = Double(slash[0].trimmingCharacters(in: .whitespaces)),
           let rhs = Double(slash[1].trimmingCharacters(in: .whitespaces)),
           rhs != 0 {
            return CGFloat(lhs / rhs)
        }
        if let v = Double(trimmed), v > 0 {
            return CGFloat(v)
        }
        return nil
    }

    private func parseGradientColorToken(_ token: String) -> Color? {
        let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
        return TailwindColorResolver.parseRuntimeColorValue(trimmed)
    }

    private func gradientPoints(for direction: String) -> (UnitPoint, UnitPoint) {
        switch direction {
        case "to right": return (.leading, .trailing)
        case "to left": return (.trailing, .leading)
        case "to top": return (.bottom, .top)
        case "to bottom": return (.top, .bottom)
        case "to top right": return (.bottomLeading, .topTrailing)
        case "to top left": return (.bottomTrailing, .topLeading)
        case "to bottom right": return (.topLeading, .bottomTrailing)
        case "to bottom left": return (.topTrailing, .bottomLeading)
        case "90deg": return (.leading, .trailing)
        case "180deg": return (.top, .bottom)
        case "270deg": return (.trailing, .leading)
        case "360deg", "0deg": return (.bottom, .top)
        default: return (.leading, .trailing)
        }
    }

    private func isDirectionOrAngle(_ token: String) -> Bool {
        let t = token.lowercased()
        if t.hasPrefix("to ") { return true }
        if t.hasSuffix("deg"), Double(t.replacingOccurrences(of: "deg", with: "")) != nil { return true }
        return false
    }
}
