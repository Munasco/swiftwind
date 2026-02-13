import Foundation

public enum TailwindVariableValidation {
    public struct ThemeTokenNameIssue: Equatable, Sendable {
        public let variable: String
        public let kind: String
        public let expectedPrefixes: [String]

        public init(variable: String, kind: String, expectedPrefixes: [String]) {
            self.variable = variable
            self.kind = kind
            self.expectedPrefixes = expectedPrefixes
        }
    }

    private static let themeKindPrefixes: [String: [String]] = [
        "animate": ["--animate-"],
        "aspect": ["--aspect-"],
        "borderWidth": ["--border-width-"],
        "blur": ["--blur-"],
        "breakpoint": ["--breakpoint-"],
        "columns": ["--columns-"],
        "color": ["--color-", "--tw-color-"],
        "container": ["--container-"],
        "cursor": ["--cursor-"],
        "delay": ["--delay-"],
        "duration": ["--duration-"],
        "dropShadow": ["--drop-shadow-"],
        "ease": ["--ease-"],
        "font": ["--font-"],
        "fontWeight": ["--font-weight-"],
        "insetShadow": ["--inset-shadow-"],
        "leading": ["--leading-"],
        "opacity": ["--opacity-"],
        "outline": ["--outline-"],
        "perspective": ["--perspective-"],
        "radius": ["--radius-"],
        "ring": ["--ring-"],
        "ringOffset": ["--ring-offset-"],
        "rotate": ["--rotate-"],
        "scale": ["--scale-"],
        "shadow": ["--shadow-"],
        "skew": ["--skew-"],
        "spacing": ["--spacing-", "--spacing"],
        "text": ["--text-"],
        "textShadow": ["--text-shadow-"],
        "tracking": ["--tracking-"],
        "transition": ["--transition-"],
        "zIndex": ["--z-"],
    ]

    public static func expectedPrefixes(forThemeKindRawValue rawValue: String) -> [String]? {
        themeKindPrefixes[rawValue]
    }

    public static func invalidThemeTokenName(
        _ variableName: String,
        forThemeKindRawValue rawValue: String
    ) -> ThemeTokenNameIssue? {
        guard let expected = expectedPrefixes(forThemeKindRawValue: rawValue), !expected.isEmpty else {
            return nil
        }

        let normalized = normalizeVariableName(variableName)
        guard !normalized.isEmpty else {
            return ThemeTokenNameIssue(variable: variableName, kind: rawValue, expectedPrefixes: expected)
        }

        let normalizedWithoutDashes = stripLeadingDashes(normalized)
        for prefix in expected {
            let prefixNormalized = stripLeadingDashes(prefix.lowercased())
            if normalizedWithoutDashes.hasPrefix(prefixNormalized) {
                return nil
            }
        }

        return ThemeTokenNameIssue(variable: variableName, kind: rawValue, expectedPrefixes: expected)
    }

    public static func isThemeTokenName(
        _ token: String,
        forThemeKindRawValue rawValue: String
    ) -> Bool {
        invalidThemeTokenName(token, forThemeKindRawValue: rawValue) == nil
    }

    public static func isColorThemeVariableToken(_ token: String) -> Bool {
        isThemeTokenName(token, forThemeKindRawValue: "color")
    }

    public static func themeColorName(from token: String) -> String? {
        let trimmed = normalizeVariableName(token)
        if trimmed.hasPrefix("--color-") {
            return String(trimmed.dropFirst("--color-".count))
        }
        if trimmed.hasPrefix("--tw-color-") {
            return String(trimmed.dropFirst("--tw-color-".count))
        }
        return nil
    }

    public static func extractCustomPropertyToken(from value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("var("), trimmed.hasSuffix(")") {
            let token = String(trimmed.dropFirst(4).dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
            return token.hasPrefix("--") ? token : nil
        }
        if trimmed.hasPrefix("("), trimmed.hasSuffix(")") {
            let token = String(trimmed.dropFirst().dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
            return token.hasPrefix("--") ? token : nil
        }
        if trimmed.hasPrefix("--") {
            return trimmed
        }
        return nil
    }

    public static func invalidColorVariableName(in baseClass: String) -> String? {
        guard isColorUtility(baseClass) else { return nil }

        if let token = extractToken(from: baseClass, marker: "var(") {
            return isColorThemeVariableToken(token) ? nil : token
        }

        if let token = extractToken(from: baseClass, marker: "("), baseClass.contains(")") {
            return isColorThemeVariableToken(token) ? nil : token
        }

        if let bracket = extractBracketInner(from: baseClass),
           bracket.hasPrefix("--") || bracket.hasPrefix("var(") {
            if bracket.hasPrefix("image:") || bracket.hasPrefix("url(") {
                return nil
            }
            if let token = extractToken(from: bracket, marker: "var(") {
                return isColorThemeVariableToken(token) ? nil : token
            }
            return isColorThemeVariableToken(bracket) ? nil : bracket
        }

        return nil
    }

    public static func isValidCSSPropertyName(_ raw: String) -> Bool {
        let name = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return false }
        if name.contains(where: { $0.isWhitespace || $0.isNewline }) {
            return false
        }

        if name.hasPrefix("--") {
            return name.count > 2
        }

        let scalarPattern = "^-?[a-zA-Z][a-zA-Z0-9-]*$"
        return name.range(of: scalarPattern, options: .regularExpression) != nil
    }

    private static func normalizeVariableName(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.hasPrefix("var("), trimmed.hasSuffix(")") {
            return String(trimmed.dropFirst(4).dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return trimmed
    }

    private static func stripLeadingDashes(_ value: String) -> String {
        if value.hasPrefix("--") {
            return String(value.dropFirst(2))
        }
        return value
    }

    private static func isColorUtility(_ className: String) -> Bool {
        let prefixes = [
            "bg-", "text-", "border-", "ring-", "ring-offset-", "outline-",
            "fill-", "stroke-", "accent-", "caret-", "placeholder-", "decoration-",
        ]
        return prefixes.contains { className.hasPrefix($0) }
    }

    private static func extractToken(from value: String, marker: String) -> String? {
        guard let range = value.range(of: marker) else { return nil }
        let start = range.upperBound
        guard let end = value[start...].firstIndex(of: ")") else { return nil }
        let token = String(value[start..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
        return token.hasPrefix("--") ? token : nil
    }

    private static func extractBracketInner(from value: String) -> String? {
        guard let open = value.firstIndex(of: "["),
              let close = value.lastIndex(of: "]"),
              open < close else { return nil }
        return String(value[value.index(after: open)..<close]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
