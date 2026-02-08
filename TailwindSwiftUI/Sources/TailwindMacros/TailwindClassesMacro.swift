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

        for className in classes {
            if !isValidClass(className) {
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

// MARK: - Diagnostics
enum TailwindDiagnostic: DiagnosticMessage {
    case requiresStringLiteral
    case unknownClass(String)
    case layoutOnText(String)

    var message: String {
        switch self {
        case .requiresStringLiteral:
            return "#tw requires a string literal"
        case .unknownClass(let name):
            return "Unknown Tailwind class '\(name)'"
        case .layoutOnText(let name):
            return "'\(name)' is a layout class and has no effect on Text"
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
        }
    }

    var severity: DiagnosticSeverity {
        switch self {
        case .requiresStringLiteral: return .error
        case .unknownClass: return .warning
        case .layoutOnText: return .error
        }
    }
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
    "p-", "px-", "py-", "pt-", "pr-", "pb-", "pl-", "pe-", "ps-",
    "m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "me-", "ms-",
    "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-",
    "w-", "h-", "size-", "min-w-", "max-w-", "min-h-", "max-h-",
    "bg-", "text-", "border-", "ring-", "shadow-", "outline-",
    "rounded-", "opacity-", "z-", "gap-", "gap-x-", "gap-y-",
    "font-", "tracking-", "leading-", "line-clamp-",
    "scale-", "scale-x-", "scale-y-", "rotate-", "-rotate-",
    "translate-x-", "translate-y-", "-translate-x-", "-translate-y-",
    "skew-x-", "skew-y-", "-skew-x-", "-skew-y-",
    "blur-", "brightness-", "contrast-", "saturate-", "hue-rotate-", "-hue-rotate-",
    "duration-", "delay-", "ease-",
    "top-", "bottom-", "left-", "right-", "inset-", "start-", "end-",
    "grid-cols-", "grid-rows-", "col-span-", "col-start-", "col-end-",
    "row-span-", "row-start-", "row-end-", "auto-cols-", "auto-rows-",
    "grid-flow-", "space-x-", "space-y-", "divide-",
    "accent-", "caret-", "decoration-", "columns-",
    "scroll-m-", "scroll-p-", "order-", "basis-",
    "object-", "place-content-", "place-items-", "place-self-",
    "justify-items-", "justify-self-", "origin-",
    "overflow-", "overscroll-",
    "cursor-", "snap-", "touch-", "will-change-",
    "animate-", "transition-",
    "float-", "clear-",
    "backdrop-", "mix-blend-", "bg-blend-",
    "break-before-", "break-after-", "break-inside-",
    "placeholder-", "content-",
    "outline-offset-", "ring-offset-",
    "whitespace-", "hyphens-",
    "forced-color-adjust-",
]

private let validExact: Set<String> = [
    "hidden", "block", "inline", "inline-block", "flex", "inline-flex",
    "grid", "inline-grid", "contents", "flow-root", "table",
    "visible", "invisible", "collapse",
    "static", "relative", "absolute", "fixed", "sticky",
    "italic", "not-italic", "underline", "overline", "line-through", "no-underline",
    "uppercase", "lowercase", "capitalize", "normal-case",
    "truncate", "antialiased", "subpixel-antialiased",
    "border", "border-0", "border-2", "border-4", "border-8",
    "border-solid", "border-dashed", "border-dotted", "border-double", "border-hidden", "border-none",
    "ring", "ring-0", "ring-1", "ring-2", "ring-4", "ring-8", "ring-inset",
    "shadow", "shadow-sm", "shadow-md", "shadow-lg", "shadow-xl", "shadow-2xl", "shadow-none", "shadow-inner",
    "rounded", "rounded-none", "rounded-sm", "rounded-md", "rounded-lg",
    "rounded-xl", "rounded-2xl", "rounded-3xl", "rounded-full",
    "rounded-t", "rounded-b", "rounded-l", "rounded-r",
    "blur", "blur-none", "blur-sm", "blur-md", "blur-lg", "blur-xl", "blur-2xl", "blur-3xl",
    "grayscale", "grayscale-0", "invert", "invert-0", "sepia", "sepia-0",
    "flex-row", "flex-col", "flex-row-reverse", "flex-col-reverse",
    "flex-wrap", "flex-wrap-reverse", "flex-nowrap",
    "flex-1", "flex-auto", "flex-initial", "flex-none",
    "grow", "grow-0", "shrink", "shrink-0",
    "justify-normal", "justify-start", "justify-end", "justify-center",
    "justify-between", "justify-around", "justify-evenly", "justify-stretch",
    "items-start", "items-end", "items-center", "items-baseline", "items-stretch",
    "self-auto", "self-start", "self-end", "self-center", "self-stretch", "self-baseline",
    "content-normal", "content-start", "content-end", "content-center",
    "content-between", "content-around", "content-evenly", "content-baseline", "content-stretch",
    "text-left", "text-center", "text-right", "text-justify", "text-start", "text-end",
    "text-wrap", "text-nowrap", "text-balance", "text-pretty", "text-ellipsis", "text-clip",
    "break-normal", "break-words", "break-all", "break-keep",
    "aspect-auto", "aspect-square", "aspect-video",
    "sr-only", "not-sr-only",
    "pointer-events-none", "pointer-events-auto",
    "select-none", "select-text", "select-all", "select-auto",
    "resize-none", "resize-y", "resize-x", "resize",
    "scroll-auto", "scroll-smooth",
    "appearance-none", "appearance-auto",
    "transform-none", "transform-gpu", "transform-cpu",
    "backface-visible", "backface-hidden",
    "isolate", "isolation-auto",
    "box-border", "box-content",
    "transition", "transition-none", "transition-all",
    "transition-colors", "transition-opacity", "transition-shadow", "transition-transform",
    "ease-linear", "ease-in", "ease-out", "ease-in-out",
    "animate-none", "animate-spin", "animate-ping", "animate-pulse", "animate-bounce",
    "disabled",
    "scheme-normal", "scheme-dark", "scheme-light",
    "font-sans", "font-serif", "font-mono",
    "m-auto", "mx-auto", "my-auto", "ml-auto", "mr-auto", "mt-auto", "mb-auto",
]
