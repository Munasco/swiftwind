import SwiftUI

// MARK: - Borders: border, rounded, ring, divide, outline
extension TailwindModifier {

    func applyBorderClass(_ className: String, to view: AnyView) -> AnyView? {
        let overlayRadius = resolvedOverlayCornerRadius()
        let ringOffsetWidth = resolvedRingOffsetWidth()

        // Rounded
        if className.hasPrefix("rounded") {
            if let r = parseRadius(from: className) {
                return AnyView(view.clipShape(RoundedRectangle(cornerRadius: r)))
            }
            // Per-corner: rounded-t, rounded-b, rounded-l, rounded-r, etc.
            if className.hasPrefix("rounded-t-") || className == "rounded-t" {
                let r = parseRadiusSuffix(className.replacingOccurrences(of: "rounded-t", with: "rounded")) ?? 4
                return AnyView(view.clipShape(UnevenRoundedRectangle(topLeadingRadius: r, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: r)))
            }
            if className.hasPrefix("rounded-b-") || className == "rounded-b" {
                let r = parseRadiusSuffix(className.replacingOccurrences(of: "rounded-b", with: "rounded")) ?? 4
                return AnyView(view.clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: r, bottomTrailingRadius: r, topTrailingRadius: 0)))
            }
            if className.hasPrefix("rounded-l-") || className == "rounded-l" {
                let r = parseRadiusSuffix(className.replacingOccurrences(of: "rounded-l", with: "rounded")) ?? 4
                return AnyView(view.clipShape(UnevenRoundedRectangle(topLeadingRadius: r, bottomLeadingRadius: r, bottomTrailingRadius: 0, topTrailingRadius: 0)))
            }
            if className.hasPrefix("rounded-r-") || className == "rounded-r" {
                let r = parseRadiusSuffix(className.replacingOccurrences(of: "rounded-r", with: "rounded")) ?? 4
                return AnyView(view.clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: r, topTrailingRadius: r)))
            }
            return AnyView(view)
        }

        // Shadow
        if className.hasPrefix("shadow") && !className.hasPrefix("shadow-") {
            if let s = parseShadow(from: className) {
                return AnyView(view.shadow(color: .black.opacity(0.25), radius: s.radius, y: s.y))
            }
        }
        if className.hasPrefix("shadow-") {
            if let s = parseShadow(from: className) {
                return AnyView(view.shadow(color: .black.opacity(0.25), radius: s.radius, y: s.y))
            }
            // shadow-{color} is handled in ParserColors
            return nil
        }

        // Border width
        if className == "border" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.gray.opacity(0.3), lineWidth: 1)))
        }
        if className == "border-0" { return AnyView(view) }
        if className == "border-2" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.gray.opacity(0.3), lineWidth: 2)))
        }
        if className == "border-4" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.gray.opacity(0.3), lineWidth: 4)))
        }
        if className == "border-8" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.gray.opacity(0.3), lineWidth: 8)))
        }

        // Border sides
        switch className {
        case "border-t", "border-b", "border-l", "border-r",
             "border-x", "border-y", "border-s", "border-e":
            return AnyView(view)
        default: break
        }

        // Border style
        switch className {
        case "border-solid", "border-dashed", "border-dotted",
             "border-double", "border-hidden", "border-none":
            return AnyView(view)
        default: break
        }

        // Border color
        if className.hasPrefix("border-") {
            if let color = parseColor(from: className, prefix: "border-") {
                return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(color, lineWidth: 1)))
            }
            if let w = extractNumber(from: className, prefix: "border-") {
                return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.gray.opacity(0.3), lineWidth: w)))
            }
            return nil
        }

        // Ring
        if className == "ring" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.blue.opacity(0.5), lineWidth: 3 + ringOffsetWidth)))
        }
        if className == "ring-0" { return AnyView(view) }
        if className == "ring-1" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.blue.opacity(0.5), lineWidth: 1 + ringOffsetWidth)))
        }
        if className == "ring-2" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.blue.opacity(0.5), lineWidth: 2 + ringOffsetWidth)))
        }
        if className == "ring-4" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.blue.opacity(0.5), lineWidth: 4 + ringOffsetWidth)))
        }
        if className == "ring-8" {
            return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(Color.blue.opacity(0.5), lineWidth: 8 + ringOffsetWidth)))
        }
        if className == "ring-inset" { return AnyView(view) }
        if className.hasPrefix("ring-offset-") { return AnyView(view) }
        if className.hasPrefix("ring-") {
            if let color = parseColor(from: className, prefix: "ring-") {
                return AnyView(view.overlay(RoundedRectangle(cornerRadius: overlayRadius).stroke(color, lineWidth: 3 + ringOffsetWidth)))
            }
            return nil
        }

        // Outline
        switch className {
        case "outline-none": return AnyView(view)
        case "outline", "outline-1", "outline-2", "outline-4", "outline-8":
            return AnyView(view)
        case "outline-dashed", "outline-dotted", "outline-double":
            return AnyView(view)
        default: break
        }
        if className.hasPrefix("outline-offset-") { return AnyView(view) }
        if className.hasPrefix("outline-") {
            if parseColor(from: className, prefix: "outline-") != nil { return AnyView(view) }
        }

        // Divide
        if className.hasPrefix("divide-") {
            return AnyView(view) // Container-level
        }

        return nil
    }

    private func parseRadiusSuffix(_ name: String) -> CGFloat? {
        return parseRadius(from: name)
    }

    private func resolvedRingOffsetWidth() -> CGFloat {
        var width: CGFloat = 0
        for cls in rawClasses {
            guard cls.hasPrefix("ring-offset-") else { continue }
            let token = cls.replacingOccurrences(of: "ring-offset-", with: "")
            if token == "0" { width = 0; continue }
            if let v = Double(token) {
                width = CGFloat(v)
            } else if cls.hasPrefix("ring-offset-["),
                      let v = extractBracketValue(from: cls, prefix: "ring-offset-") {
                width = v
            }
        }
        return width
    }

}
