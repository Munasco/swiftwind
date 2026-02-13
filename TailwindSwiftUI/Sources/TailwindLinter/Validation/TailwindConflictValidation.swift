import Foundation

public struct TailwindConflictDiagnostic: Sendable {
    public let previous: String
    public let current: String
    public let scope: String

    public init(previous: String, current: String, scope: String) {
        self.previous = previous
        self.current = current
        self.scope = scope
    }
}

public enum TailwindConflictValidation {
    public static func conflictKey(for className: String) -> String? {
        let parsed = TailwindClassParsing.parseVariantClass(className)
        guard let group = conflictGroup(for: parsed.baseClass) else { return nil }
        return "\(parsed.variants.joined(separator: ":"))|\(group)"
    }

    public static func detectConflicts(in classNames: [String]) -> [TailwindConflictDiagnostic] {
        var seen: [String: String] = [:]
        var diagnostics: [TailwindConflictDiagnostic] = []

        for className in classNames {
            let parsed = TailwindClassParsing.parseVariantClass(className)
            guard let group = conflictGroup(for: parsed.baseClass) else { continue }

            let variantScope = parsed.variants.joined(separator: ":")
            let key = "\(variantScope)|\(group)"
            if let previous = seen[key], previous != parsed.baseClass {
                let scopeLabel = variantScope.isEmpty ? "base scope" : "variant scope '\(variantScope)'"
                diagnostics.append(
                    TailwindConflictDiagnostic(previous: previous, current: parsed.baseClass, scope: scopeLabel)
                )
            } else if seen[key] == nil {
                seen[key] = parsed.baseClass
            }
        }

        return diagnostics
    }

    public static func hasCrossScopeConflicts(previous: [String], incoming: [String]) -> Bool {
        var previousSeen: [String: String] = [:]

        for className in previous {
            let parsed = TailwindClassParsing.parseVariantClass(className)
            guard let group = conflictGroup(for: parsed.baseClass) else { continue }
            let key = "\(parsed.variants.joined(separator: ":"))|\(group)"
            if previousSeen[key] == nil {
                previousSeen[key] = parsed.baseClass
            }
        }

        for className in incoming {
            let parsed = TailwindClassParsing.parseVariantClass(className)
            guard let group = conflictGroup(for: parsed.baseClass) else { continue }
            let key = "\(parsed.variants.joined(separator: ":"))|\(group)"
            if let previousClass = previousSeen[key], previousClass != parsed.baseClass {
                return true
            }
        }

        return false
    }

    public static func conflictGroup(for baseClass: String) -> String? {
        if baseClass.hasPrefix("bg-"),
           !baseClass.hasPrefix("bg-opacity-"),
           !baseClass.hasPrefix("bg-gradient-"),
           !baseClass.hasPrefix("bg-clip-"),
           !baseClass.hasPrefix("bg-origin-"),
           !baseClass.hasPrefix("bg-no-repeat"),
           !baseClass.hasPrefix("bg-repeat"),
           !baseClass.hasPrefix("bg-cover"),
           !baseClass.hasPrefix("bg-contain"),
           !baseClass.hasPrefix("bg-center"),
           !baseClass.hasPrefix("bg-fixed"),
           !baseClass.hasPrefix("bg-local"),
           !baseClass.hasPrefix("bg-scroll"),
           !baseClass.hasPrefix("bg-none") {
            return "background-color"
        }

        if isTextColorUtility(baseClass) { return "text-color" }
        if baseClass.hasPrefix("rounded") { return "rounded" }
        if baseClass.hasPrefix("p-") { return "padding-all" }
        if baseClass.hasPrefix("px-") { return "padding-x" }
        if baseClass.hasPrefix("py-") { return "padding-y" }
        if baseClass.hasPrefix("pt-") { return "padding-top" }
        if baseClass.hasPrefix("pr-") || baseClass.hasPrefix("pe-") { return "padding-trailing" }
        if baseClass.hasPrefix("pb-") { return "padding-bottom" }
        if baseClass.hasPrefix("pl-") || baseClass.hasPrefix("ps-") { return "padding-leading" }
        if let border = borderConflictGroup(for: baseClass) { return border }
        if let ring = ringConflictGroup(for: baseClass) { return ring }
        if let outline = outlineConflictGroup(for: baseClass) { return outline }
        if baseClass.hasPrefix("shadow") || baseClass.hasPrefix("drop-shadow") { return "shadow" }
        if baseClass.hasPrefix("opacity-") { return "opacity" }
        return nil
    }

    private static func isTextColorUtility(_ value: String) -> Bool {
        guard value.hasPrefix("text-") else { return false }
        let suffix = String(value.dropFirst("text-".count))

        let nonColorExact: Set<String> = [
            "left", "center", "right", "justify", "start", "end",
            "wrap", "nowrap", "balance", "pretty",
            "ellipsis", "clip",
        ]
        if nonColorExact.contains(suffix) { return false }

        let nonColorSizeTokens: Set<String> = [
            "xs", "sm", "base", "lg", "xl", "2xl", "3xl", "4xl", "5xl", "6xl", "7xl", "8xl", "9xl",
        ]
        if nonColorSizeTokens.contains(suffix) { return false }

        if suffix.hasPrefix("[") && suffix.hasSuffix("]") { return true }
        if suffix.hasPrefix("(") && suffix.hasSuffix(")") { return true }

        if ["white", "black", "transparent", "current", "inherit"].contains(suffix) {
            return true
        }

        let parts = suffix.split(separator: "-", omittingEmptySubsequences: true)
        return parts.count >= 2
    }

    private static func borderConflictGroup(for baseClass: String) -> String? {
        guard baseClass == "border" || baseClass.hasPrefix("border-") else { return nil }
        if baseClass.hasPrefix("border-opacity-") { return "border-opacity" }

        let styles: Set<String> = ["solid", "dashed", "dotted", "double", "none"]
        let directional: Set<String> = ["x", "y", "t", "r", "b", "l", "s", "e"]

        if baseClass == "border" { return "border-width-all" }

        let suffix = String(baseClass.dropFirst("border-".count))
        let parts = suffix.split(separator: "-", omittingEmptySubsequences: true).map(String.init)
        guard !parts.isEmpty else { return "border-width-all" }

        if styles.contains(parts[0]) { return "border-style-all" }

        if directional.contains(parts[0]) {
            if parts.count == 1 { return "border-width-\(parts[0])" }
            let rest = parts.dropFirst().joined(separator: "-")
            if styles.contains(rest) { return "border-style-\(parts[0])" }
            if isWidthLikeToken(rest) { return "border-width-\(parts[0])" }
            return "border-color-\(parts[0])"
        }

        if isWidthLikeToken(suffix) { return "border-width-all" }
        return "border-color-all"
    }

    private static func ringConflictGroup(for baseClass: String) -> String? {
        if baseClass == "ring" { return "ring-width" }
        guard baseClass.hasPrefix("ring-") else { return nil }
        if baseClass.hasPrefix("ring-offset-") {
            let suffix = String(baseClass.dropFirst("ring-offset-".count))
            return isWidthLikeToken(suffix) ? "ring-offset-width" : "ring-offset-color"
        }
        if baseClass == "ring-inset" || baseClass.hasPrefix("ring-inset") { return "ring-inset" }

        let suffix = String(baseClass.dropFirst("ring-".count))
        return isWidthLikeToken(suffix) ? "ring-width" : "ring-color"
    }

    private static func outlineConflictGroup(for baseClass: String) -> String? {
        if baseClass == "outline" { return "outline-width" }
        if baseClass == "outline-none" { return "outline-style" }
        if baseClass.hasPrefix("outline-offset-") { return "outline-offset" }
        guard baseClass.hasPrefix("outline-") else { return nil }

        let suffix = String(baseClass.dropFirst("outline-".count))
        if ["solid", "dashed", "dotted", "double"].contains(suffix) {
            return "outline-style"
        }
        return isWidthLikeToken(suffix) ? "outline-width" : "outline-color"
    }

    private static func isWidthLikeToken(_ value: String) -> Bool {
        if value == "px" { return true }
        if value.hasPrefix("[") && value.hasSuffix("]") { return true }
        return Double(value) != nil
    }
}
