import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct TailwindClassesMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        // Extract the string literal argument
        guard let argument = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
              let segment = argument.segments.first?.as(StringSegmentSyntax.self) else {
            context.diagnose(Diagnostic(
                node: Syntax(node),
                message: TailwindDiagnostic.requiresStringLiteral
            ))
            return ExprSyntax(stringLiteral: #""""#)
        }
        let stringLiteral = argument

        let classString = segment.content.text
        let classes = classString.split(separator: " ").map(String.init)
        let supportedVariants: Set<String> = [
            "dark", "light", "focus", "hover", "active",
            "group-dark", "group-focus", "group-hover", "group-active",
            "sm", "md", "lg", "xl", "2xl",
            "ios", "macos", "tvos", "watchos", "visionos"
        ]

        for className in classes {
            let parsed = parseVariantClass(className)
            let unsupportedVariants = parsed.variants.filter { !supportedVariants.contains($0) }
                .filter { !$0.hasPrefix("peer-") }
            if !unsupportedVariants.isEmpty {
                context.diagnose(Diagnostic(
                    node: Syntax(segment),
                    message: TailwindDiagnostic.unknownClass(className)
                ))
                continue
            }

            if isMarkerClass(parsed.baseClass) {
                continue
            }

            if let invalidColorVar = invalidColorVariableName(in: parsed.baseClass) {
                context.diagnose(Diagnostic(
                    node: Syntax(segment),
                    message: TailwindDiagnostic.invalidColorVariable(className: className, variable: invalidColorVar)
                ))
            }

            if !isValidClass(parsed.baseClass) {
                context.diagnose(Diagnostic(
                    node: Syntax(segment),
                    message: TailwindDiagnostic.unknownClass(className)
                ))
            }
        }

        // Return the string as-is — runtime handles applying it
        return ExprSyntax(stringLiteral)
    }
}

private struct ParsedVariantClass {
    let variants: [String]
    let baseClass: String
}

private func parseVariantClass(_ className: String) -> ParsedVariantClass {
    let parts = splitOnTopLevelColons(className)
    guard parts.count > 1, let base = parts.last else {
        return ParsedVariantClass(variants: [], baseClass: className)
    }
    return ParsedVariantClass(variants: Array(parts.dropLast()), baseClass: base)
}

private func splitOnTopLevelColons(_ value: String) -> [String] {
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

private func isMarkerClass(_ value: String) -> Bool {
    if value == "group" || value == "peer" { return true }
    if value.hasPrefix("peer/") {
        let id = String(value.dropFirst("peer/".count))
        return !id.isEmpty
    }
    return false
}

// MARK: - Diagnostics
enum TailwindDiagnostic: DiagnosticMessage {
    case requiresStringLiteral
    case unknownClass(String)
    case layoutOnText(String)
    case invalidColorVariable(className: String, variable: String)

    var message: String {
        switch self {
        case .requiresStringLiteral:
            return "#tw requires a string literal"
        case .unknownClass(let name):
            return "Unknown Tailwind class '\(name)'"
        case .layoutOnText(let name):
            return "'\(name)' is a layout class and has no effect on Text"
        case let .invalidColorVariable(className, variable):
            return "Class '\(className)' uses '\(variable)'. Color vars must be named '--color-*' (or '--tw-color-*')."
        }
    }

    var diagnosticID: MessageID {
        switch self {
        case .requiresStringLiteral:
            return MessageID(domain: "TailwindSwiftUI", id: "requiresStringLiteral")
        case .unknownClass:
            return MessageID(domain: "TailwindSwiftUI", id: "unknownClass")
        case .layoutOnText:
            return MessageID(domain: "TailwindSwiftUI", id: "layoutOnText")
        case .invalidColorVariable:
            return MessageID(domain: "TailwindSwiftUI", id: "invalidColorVariable")
        }
    }

    var severity: DiagnosticSeverity {
        switch self {
        case .requiresStringLiteral: return .error
        case .unknownClass: return .warning
        case .layoutOnText: return .error
        case .invalidColorVariable: return .warning
        }
    }
}

private func invalidColorVariableName(in baseClass: String) -> String? {
    guard isColorUtility(baseClass) else { return nil }

    if let token = extractToken(from: baseClass, marker: "var(") {
        return isValidColorToken(token) ? nil : token
    }

    if let token = extractToken(from: baseClass, marker: "("), baseClass.contains(")") {
        return isValidColorToken(token) ? nil : token
    }

    if let bracket = extractBracketInner(from: baseClass),
       bracket.hasPrefix("--") || bracket.hasPrefix("var(") {
        if bracket.hasPrefix("image:") || bracket.hasPrefix("url(") {
            return nil
        }
        if let token = extractToken(from: bracket, marker: "var(") {
            return isValidColorToken(token) ? nil : token
        }
        return isValidColorToken(bracket) ? nil : bracket
    }

    return nil
}

private func isColorUtility(_ className: String) -> Bool {
    let prefixes = [
        "bg-", "text-", "border-", "ring-", "ring-offset-", "outline-",
        "fill-", "stroke-", "accent-", "caret-", "placeholder-", "decoration-"
    ]
    return prefixes.contains { className.hasPrefix($0) }
}

private func isValidColorToken(_ token: String) -> Bool {
    token.hasPrefix("--color-") || token.hasPrefix("--tw-color-")
}

private func extractToken(from value: String, marker: String) -> String? {
    guard let range = value.range(of: marker) else { return nil }
    let start = range.upperBound
    guard let end = value[start...].firstIndex(of: marker == "var(" ? ")" : ")") else { return nil }
    let token = String(value[start..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
    return token.hasPrefix("--") ? token : nil
}

private func extractBracketInner(from value: String) -> String? {
    guard let open = value.firstIndex(of: "["),
          let close = value.lastIndex(of: "]"),
          open < close else { return nil }
    return String(value[value.index(after: open)..<close]).trimmingCharacters(in: .whitespacesAndNewlines)
}

// MARK: - Validation
private func isValidClass(_ name: String) -> Bool {
    if name.contains("[") && name.contains("]") { return true }
    if validExact.contains(name) { return true }
    for prefix in validPrefixes {
        if name.hasPrefix(prefix) { return true }
    }
    return false
}

private let validPrefixes: [String] = [
    // Spacing
    "p-", "px-", "py-", "pt-", "pr-", "pb-", "pl-", "pe-", "ps-",
    "m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "me-", "ms-",
    "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-",
    // Sizing
    "w-", "h-", "size-", "min-w-", "max-w-", "min-h-", "max-h-",
    // Colors & backgrounds
    "bg-", "text-", "border-", "ring-", "shadow-", "outline-",
    "accent-", "caret-", "decoration-", "placeholder-",
    // SVG / shape paint
    "fill-", "stroke-",
    // Border & radius
    "rounded-", "divide-",
    // Layout
    "opacity-", "z-", "gap-", "gap-x-", "gap-y-",
    "top-", "bottom-", "left-", "right-", "inset-", "start-", "end-",
    "grid-cols-", "grid-rows-", "col-span-", "col-start-", "col-end-",
    "row-span-", "row-start-", "row-end-", "auto-cols-", "auto-rows-",
    "grid-flow-", "space-x-", "space-y-", "columns-",
    "object-", "place-content-", "place-items-", "place-self-",
    "justify-items-", "justify-self-", "origin-",
    "overflow-", "overscroll-", "order-", "basis-",
    "float-", "clear-",
    // Typography
    "font-", "tracking-", "leading-", "line-clamp-",
    "indent-", "-indent-", "align-", "underline-offset-",
    "whitespace-", "hyphens-",
    // Transforms
    "scale-", "scale-x-", "scale-y-", "rotate-", "-rotate-",
    "translate-x-", "translate-y-", "-translate-x-", "-translate-y-",
    "skew-x-", "skew-y-", "-skew-x-", "-skew-y-",
    "perspective-",
    // Effects & filters
    "blur-", "brightness-", "contrast-", "saturate-", "hue-rotate-", "-hue-rotate-",
    "drop-shadow-", "backdrop-", "mix-blend-", "bg-blend-",
    // Transitions & animation
    "duration-", "delay-", "ease-", "animate-", "transition-",
    // Interactivity
    "cursor-", "snap-", "touch-", "will-change-",
    "scroll-m-", "scroll-mx-", "scroll-my-", "scroll-mt-", "scroll-mr-", "scroll-mb-", "scroll-ml-",
    "scroll-p-", "scroll-px-", "scroll-py-", "scroll-pt-", "scroll-pr-", "scroll-pb-", "scroll-pl-",
    // Misc
    "break-before-", "break-after-", "break-inside-",
    "content-", "outline-offset-", "ring-offset-",
    "forced-color-adjust-",
]

private let validExact: Set<String> = [
    // Display
    "hidden", "block", "inline", "inline-block", "flex", "inline-flex",
    "grid", "inline-grid", "contents", "flow-root",
    "table", "table-caption", "table-cell", "table-column", "table-column-group",
    "table-footer-group", "table-header-group", "table-row-group", "table-row",
    // Visibility & position
    "visible", "invisible", "collapse",
    "static", "relative", "absolute", "fixed", "sticky",
    // Typography
    "italic", "not-italic", "underline", "overline", "line-through", "no-underline",
    "uppercase", "lowercase", "capitalize", "normal-case",
    "truncate", "antialiased", "subpixel-antialiased",
    // Font variant numeric
    "normal-nums", "ordinal", "slashed-zero", "lining-nums", "oldstyle-nums",
    "proportional-nums", "tabular-nums", "diagonal-fractions", "stacked-fractions",
    // Border
    "border", "border-0", "border-2", "border-4", "border-8",
    "border-t", "border-b", "border-l", "border-r", "border-x", "border-y", "border-s", "border-e",
    "border-solid", "border-dashed", "border-dotted", "border-double", "border-hidden", "border-none",
    // Ring
    "ring", "ring-0", "ring-1", "ring-2", "ring-4", "ring-8", "ring-inset",
    // Shadow
    "shadow", "shadow-sm", "shadow-md", "shadow-lg", "shadow-xl", "shadow-2xl", "shadow-none", "shadow-inner",
    // Drop shadow
    "drop-shadow", "drop-shadow-sm", "drop-shadow-md", "drop-shadow-lg",
    "drop-shadow-xl", "drop-shadow-2xl", "drop-shadow-none",
    // Rounded
    "rounded", "rounded-none", "rounded-sm", "rounded-md", "rounded-lg",
    "rounded-xl", "rounded-2xl", "rounded-3xl", "rounded-full",
    "rounded-t", "rounded-b", "rounded-l", "rounded-r",
    // Blur & filters
    "blur", "blur-none", "blur-sm", "blur-md", "blur-lg", "blur-xl", "blur-2xl", "blur-3xl",
    "grayscale", "grayscale-0", "invert", "invert-0", "sepia", "sepia-0",
    // Flex
    "flex-row", "flex-col", "flex-row-reverse", "flex-col-reverse",
    "flex-wrap", "flex-wrap-reverse", "flex-nowrap",
    "flex-1", "flex-auto", "flex-initial", "flex-none",
    "grow", "grow-0", "shrink", "shrink-0",
    // Justify & align
    "justify-normal", "justify-start", "justify-end", "justify-center",
    "justify-between", "justify-around", "justify-evenly", "justify-stretch",
    "items-start", "items-end", "items-center", "items-baseline", "items-stretch",
    "self-auto", "self-start", "self-end", "self-center", "self-stretch", "self-baseline",
    "content-normal", "content-start", "content-end", "content-center",
    "content-between", "content-around", "content-evenly", "content-baseline", "content-stretch",
    // Text alignment & wrapping
    "text-left", "text-center", "text-right", "text-justify", "text-start", "text-end",
    "text-wrap", "text-nowrap", "text-balance", "text-pretty", "text-ellipsis", "text-clip",
    "break-normal", "break-words", "break-all", "break-keep",
    // Sizing
    "aspect-auto", "aspect-square", "aspect-video",
    // Accessibility
    "sr-only", "not-sr-only",
    // Interactivity
    "pointer-events-none", "pointer-events-auto",
    "select-none", "select-text", "select-all", "select-auto",
    "resize-none", "resize-y", "resize-x", "resize",
    "scroll-auto", "scroll-smooth",
    "appearance-none", "appearance-auto",
    // Snap
    "snap-start", "snap-end", "snap-center", "snap-align-none",
    "snap-normal", "snap-always",
    "snap-none", "snap-x", "snap-y", "snap-both", "snap-mandatory", "snap-proximity",
    // Touch
    "touch-auto", "touch-none", "touch-pan-x", "touch-pan-left", "touch-pan-right",
    "touch-pan-y", "touch-pan-up", "touch-pan-down", "touch-pinch-zoom", "touch-manipulation",
    // Transforms
    "transform-none", "transform-gpu", "transform-cpu",
    "backface-visible", "backface-hidden",
    // Box model
    "isolate", "isolation-auto",
    "box-border", "box-content",
    // Transitions
    "transition", "transition-none", "transition-all",
    "transition-colors", "transition-opacity", "transition-shadow", "transition-transform",
    "ease-linear", "ease-in", "ease-out", "ease-in-out",
    // Animations
    "animate-none", "animate-spin", "animate-ping", "animate-pulse", "animate-bounce",
    // State & theme
    "disabled",
    "scheme-normal", "scheme-dark", "scheme-light",
    // Font family
    "font-sans", "font-serif", "font-mono",
    // Auto margins
    "m-auto", "mx-auto", "my-auto", "ml-auto", "mr-auto", "mt-auto", "mb-auto",
]
