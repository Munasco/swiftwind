import Foundation

public struct TailwindParsedClass: Sendable {
    public let variants: [String]
    public let baseClass: String

    public init(variants: [String], baseClass: String) {
        self.variants = variants
        self.baseClass = baseClass
    }
}

public enum TailwindClassParsing {
    public static func splitOnTopLevelColons(_ value: String) -> [String] {
        var out: [String] = []
        var current = ""
        var bracketDepth = 0
        var parenDepth = 0

        for char in value {
            if char == "[" { bracketDepth += 1 }
            if char == "]" { bracketDepth = max(0, bracketDepth - 1) }
            if char == "(" { parenDepth += 1 }
            if char == ")" { parenDepth = max(0, parenDepth - 1) }

            if char == ":" && bracketDepth == 0 && parenDepth == 0 {
                out.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }

        out.append(current)
        return out
    }

    public static func parseVariantClass(_ className: String) -> TailwindParsedClass {
        let parts = splitOnTopLevelColons(className)
        guard parts.count > 1, let base = parts.last else {
            return TailwindParsedClass(variants: [], baseClass: className)
        }
        return TailwindParsedClass(variants: Array(parts.dropLast()), baseClass: base)
    }
}
