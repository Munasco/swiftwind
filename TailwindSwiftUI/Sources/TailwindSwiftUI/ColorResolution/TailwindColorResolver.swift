import SwiftUI

// MARK: - Shared color parsing used by both View and Shape modifiers
enum TailwindColorResolver {

    static func parseColor(
        _ className: String,
        prefix: String,
        variables: [String: Color] = [:],
        colorScheme: ColorScheme = .light
    ) -> Color? {
        let colorStr = className.replacingOccurrences(of: prefix, with: "")
        let (rawBaseToken, alpha) = splitAlphaSuffix(from: colorStr)

        let baseColor: Color?
        if let token = extractVariableToken(rawBaseToken) {
            baseColor = variables[token] ?? TailwindRuntime.colorVariable(token, colorScheme: colorScheme)
        } else if rawBaseToken.hasPrefix("[") {
            // Rebuild the class name with stripped alpha suffix so the existing
            // bracket parser can handle it.
            baseColor = parseBracketColor(
                prefix + rawBaseToken,
                prefix: prefix,
                variables: variables,
                colorScheme: colorScheme
            )
        } else {
            switch rawBaseToken {
            case "white":
                baseColor = .white
            case "black":
                baseColor = .black
            case "transparent":
                baseColor = .clear
            case "current", "inherit":
                baseColor = nil
            default:
                // Tailwind theme token form, e.g. bg-muted -> var(--color-muted)
                if let themed = TailwindRuntime.colorVariable("--color-\(rawBaseToken)", colorScheme: colorScheme) {
                    baseColor = themed
                } else {
                    let parts = rawBaseToken.split(separator: "-")
                    if parts.count == 2, let palette = colorByName(String(parts[0]), shade: String(parts[1])) {
                        baseColor = palette
                    } else {
                        // Also support multi-segment semantic tokens, e.g. text-muted-foreground.
                        baseColor = TailwindRuntime.colorVariable("--color-\(rawBaseToken)", colorScheme: colorScheme)
                    }
                }
            }
        }

        guard let resolved = baseColor else { return nil }
        guard let alpha else { return resolved }
        return resolved.opacity(alpha)
    }

    private static func splitAlphaSuffix(from raw: String) -> (base: String, alpha: Double?) {
        var bracketDepth = 0
        var parenDepth = 0
        var slashIndex: String.Index?

        for idx in raw.indices {
            let char = raw[idx]
            if char == "[" { bracketDepth += 1 }
            if char == "]" { bracketDepth = max(0, bracketDepth - 1) }
            if char == "(" { parenDepth += 1 }
            if char == ")" { parenDepth = max(0, parenDepth - 1) }

            if char == "/", bracketDepth == 0, parenDepth == 0 {
                slashIndex = idx
            }
        }

        guard let slashIndex else { return (raw, nil) }
        let base = String(raw[..<slashIndex])
        let alphaToken = String(raw[raw.index(after: slashIndex)...])
        return (base, parseOpacity(alphaToken))
    }

    private static func parseOpacity(_ raw: String) -> Double? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return nil }

        var token = trimmed
        if token.hasPrefix("[") && token.hasSuffix("]") {
            token = String(token.dropFirst().dropLast())
        }

        token = token.trimmingCharacters(in: .whitespacesAndNewlines)
        if token.hasSuffix("%") {
            token = String(token.dropLast())
        }

        guard let numeric = Double(token) else { return nil }
        let normalized = numeric > 1 ? numeric / 100.0 : numeric
        return min(max(normalized, 0), 1)
    }

    static func parseBracketColor(
        _ className: String,
        prefix: String,
        variables: [String: Color] = [:],
        colorScheme: ColorScheme = .light
    ) -> Color? {
        let valueStr = className.replacingOccurrences(of: prefix, with: "")
        guard valueStr.hasPrefix("[") && valueStr.hasSuffix("]") else { return nil }
        let inner = String(valueStr.dropFirst().dropLast())
        if let token = extractVariableToken(inner) {
            return variables[token] ?? TailwindRuntime.colorVariable(token, colorScheme: colorScheme)
        }
        if let oklch = Color.oklch(string: inner) {
            return oklch
        }
        guard inner.hasPrefix("#") else { return nil }
        let hex = String(inner.dropFirst())
        guard let hexInt = UInt(hex, radix: 16) else { return nil }
        return Color(hex: hexInt)
    }

    static func parseRuntimeColorValue(_ value: String) -> Color? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if let oklch = Color.oklch(string: trimmed) {
            return oklch
        }
        if trimmed.hasPrefix("#") {
            let hex = String(trimmed.dropFirst())
            guard let hexInt = UInt(hex, radix: 16) else { return nil }
            return Color(hex: hexInt)
        }
        if trimmed.contains("-") {
            let parts = trimmed.split(separator: "-")
            if parts.count == 2 {
                return colorByName(String(parts[0]), shade: String(parts[1]))
            }
        }
        // If only palette name is provided, default to shade 500.
        return colorByName(trimmed, shade: "500")
    }

    private static func extractVariableToken(_ raw: String) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        // Standard CSS function form: var(--brand-bg)
        if trimmed.hasPrefix("var("), trimmed.hasSuffix(")") {
            let token = String(trimmed.dropFirst(4).dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
            guard token.hasPrefix("--") else {
                TailwindLogger.warn("Tailwind var '\(token)' must start with '--'. Example: var(--brand-bg)")
                return nil
            }
            guard isColorTokenName(token) else {
                TailwindLogger.warn("Color variables must use '--color-*' (or '--tw-color-*'). Got '\(token)'.")
                return nil
            }
            return token
        }

        // Tailwind shorthand for CSS variables, e.g. fill-(--brand-bg)
        // (the `fill-` prefix is removed before this helper is called).
        if trimmed.hasPrefix("("), trimmed.hasSuffix(")") {
            let token = String(trimmed.dropFirst().dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
            guard token.hasPrefix("--") else {
                TailwindLogger.warn("Tailwind var '\(token)' must start with '--'. Example: bg-(--brand-bg)")
                return nil
            }
            guard isColorTokenName(token) else {
                TailwindLogger.warn("Color variables must use '--color-*' (or '--tw-color-*'). Got '\(token)'.")
                return nil
            }
            return token
        }

        // Direct custom property token inside bracket forms, e.g. [--brand-bg]
        if trimmed.hasPrefix("--") {
            guard isColorTokenName(trimmed) else {
                TailwindLogger.warn("Color variables must use '--color-*' (or '--tw-color-*'). Got '\(trimmed)'.")
                return nil
            }
            return trimmed
        }

        return nil
    }

    private static func isColorTokenName(_ token: String) -> Bool {
        token.hasPrefix("--color-") || token.hasPrefix("--tw-color-")
    }

    static func colorByName(_ name: String, shade: String) -> Color? {
        ColorPalette.colorByName(name, shade: shade)
    }
}
