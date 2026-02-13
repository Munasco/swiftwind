import Foundation

public enum TailwindVariantValidation {
    public static let supportedVariants: Set<String> = [
        "dark", "light", "focus", "hover", "active", "disabled",
        "group-dark", "group-focus", "group-hover", "group-active",
        "sm", "md", "lg", "xl", "2xl",
        "ios", "macos", "tvos", "watchos", "visionos",
    ]

    public static func isSupportedPeerVariant(_ variant: String) -> Bool {
        guard variant.hasPrefix("peer-") else { return false }
        let body = String(variant.dropFirst("peer-".count))
        let parts = body.split(separator: "/", maxSplits: 1).map(String.init)
        guard let state = parts.first, !state.isEmpty else { return false }
        let supportedStates: Set<String> = ["dark", "focus", "hover", "active", "disabled"]
        if !supportedStates.contains(state) { return false }
        if parts.count == 1 { return true }
        return !parts[1].isEmpty
    }

    public static func unsupportedVariants(in className: String) -> [String] {
        let parsed = TailwindClassParsing.parseVariantClass(className)
        return parsed.variants.filter { variant in
            if supportedVariants.contains(variant) { return false }
            if variant.hasPrefix("peer-") { return !isSupportedPeerVariant(variant) }
            return true
        }
    }
}
