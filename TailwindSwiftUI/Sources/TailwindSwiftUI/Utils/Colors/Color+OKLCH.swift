import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

extension Color {
    private struct OKLCHParsedColor {
        let l: Double
        let c: Double
        let h: Double
        let opacity: Double
    }

    static func oklch(string rawValue: String) -> Color? {
        guard let parsed = parseOKLCHCSS(rawValue) else { return nil }
        return Color.oklch(parsed.l, parsed.c, parsed.h, parsed.opacity)
    }

    @inlinable
    static func oklch(l: Double, c: Double, h: Double, opacity: Double = 1.0) -> Color {
        Color.oklch(l, c, h, opacity)
    }

    @inlinable
    static func hsl(h: Double, s: Double, l: Double, opacity: Double = 1.0) -> Color {
        let hue = ((h.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)) / 360.0
        let saturation = min(max(s, 0), 1)
        let lightness = min(max(l, 0), 1)
        let alpha = min(max(opacity, 0), 1)

        if saturation == 0 {
            return Color(.sRGB, red: lightness, green: lightness, blue: lightness, opacity: alpha)
        }

        let q = lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation
        let p = 2 * lightness - q

        func hueToRGB(_ t: Double) -> Double {
            var t = t
            if t < 0 { t += 1 }
            if t > 1 { t -= 1 }
            if t < 1.0 / 6.0 { return p + (q - p) * 6 * t }
            if t < 1.0 / 2.0 { return q }
            if t < 2.0 / 3.0 { return p + (q - p) * (2.0 / 3.0 - t) * 6 }
            return p
        }

        let r = hueToRGB(hue + 1.0 / 3.0)
        let g = hueToRGB(hue)
        let b = hueToRGB(hue - 1.0 / 3.0)
        return Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }

    private static func parseOKLCHCSS(_ raw: String) -> OKLCHParsedColor? {
        let value = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard value.lowercased().hasPrefix("oklch("), value.hasSuffix(")") else { return nil }

        let inner = String(value.dropFirst(6).dropLast())
            .replacingOccurrences(of: "_", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !inner.isEmpty else { return nil }

        let pieces = inner
            .split(separator: "/", maxSplits: 1)
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        guard let colorPart = pieces.first else { return nil }

        let colorComponents = colorPart.split(whereSeparator: \.isWhitespace).map(String.init)
        guard colorComponents.count >= 3 else { return nil }
        guard let l = parseTailwindOKLCHLightness(colorComponents[0]),
              let c = parseTailwindOKLCHNumber(colorComponents[1]),
              let h = parseTailwindOKLCHHue(colorComponents[2]) else { return nil }

        let opacity: Double
        if pieces.count == 2 {
            guard let resolved = parseTailwindOKLCHOpacity(pieces[1]) else { return nil }
            opacity = resolved
        } else {
            opacity = 1.0
        }

        return .init(
            l: min(max(l, 0), 1),
            c: max(c, 0),
            h: normalizeTailwindOKLCHHue(h),
            opacity: min(max(opacity, 0), 1)
        )
    }

    private static func parseTailwindOKLCHLightness(_ token: String) -> Double? {
        let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasSuffix("%") {
            guard let value = Double(trimmed.dropLast()) else { return nil }
            return value / 100
        }
        return Double(trimmed)
    }

    private static func parseTailwindOKLCHHue(_ token: String) -> Double? {
        let cleaned = token.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasSuffix("deg") {
            return Double(cleaned.dropLast(3))
        }
        return Double(cleaned)
    }

    private static func parseTailwindOKLCHOpacity(_ token: String) -> Double? {
        let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasSuffix("%") {
            guard let value = Double(trimmed.dropLast()) else { return nil }
            return value / 100
        }
        return Double(trimmed)
    }

    private static func parseTailwindOKLCHNumber(_ token: String) -> Double? {
        let cleaned = token
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "deg", with: "")
        return Double(cleaned)
    }

    static func normalizeTailwindOKLCHHue(_ hue: Double) -> Double {
        let wrapped = hue.truncatingRemainder(dividingBy: 360)
        return wrapped < 0 ? wrapped + 360 : wrapped
    }
}
