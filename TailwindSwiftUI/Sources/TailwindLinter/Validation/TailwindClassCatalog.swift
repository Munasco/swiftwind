import Foundation

public enum TailwindClassCatalog {
    public static let validPrefixes: [String] = [
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

    public static let validExact: Set<String> = [
        // Display
        "hidden", "block", "inline", "inline-block", "flex", "inline-flex",
        "grid", "inline-grid", "contents", "flow-root",
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

    public static let layoutClasses: Set<String> = [
        "flex", "inline-flex",
        "grid", "inline-grid",
        "flex-row", "flex-col", "flex-row-reverse", "flex-col-reverse",
        "flex-wrap", "flex-wrap-reverse", "flex-nowrap",
        "justify-normal", "justify-start", "justify-end", "justify-center",
        "justify-between", "justify-around", "justify-evenly", "justify-stretch",
        "items-start", "items-end", "items-center", "items-baseline", "items-stretch",
        "content-normal", "content-start", "content-end", "content-center",
        "content-between", "content-around", "content-evenly",
        "grow", "grow-0", "shrink", "shrink-0",
        "flex-1", "flex-auto", "flex-initial", "flex-none",
    ]

    public static let layoutPrefixes: [String] = [
        "flex-", "justify-", "items-", "content-", "place-", "self-",
        "gap-", "grid-cols-", "grid-rows-", "col-span-", "row-span-",
        "col-start-", "col-end-", "row-start-", "row-end-",
        "grid-flow-", "auto-cols-", "auto-rows-", "space-x-", "space-y-",
        "divide-", "columns-", "order-",
        "justify-items-", "justify-self-", "place-content-", "place-items-", "place-self-",
        "float-", "clear-",
    ]

    public static func isValidClass(_ name: String) -> Bool {
        if isUnsupportedTableUtility(name) { return false }
        if name.contains("[") && name.contains("]") { return true }
        if validExact.contains(name) { return true }
        for prefix in validPrefixes {
            if name.hasPrefix(prefix) { return true }
        }
        return false
    }

    public static func isLayoutClass(_ name: String) -> Bool {
        if layoutClasses.contains(name) { return true }
        for prefix in layoutPrefixes {
            if name.hasPrefix(prefix) { return true }
        }
        return false
    }

    public static func isMarkerClass(_ value: String) -> Bool {
        if value == "group" || value == "peer" { return true }
        if value.hasPrefix("peer/") {
            let id = String(value.dropFirst("peer/".count))
            return !id.isEmpty
        }
        return false
    }

    private static func isUnsupportedTableUtility(_ name: String) -> Bool {
        switch name {
        case "table", "table-caption", "table-cell", "table-column", "table-column-group",
             "table-footer-group", "table-header-group", "table-row-group", "table-row",
             "table-auto", "table-fixed", "border-collapse", "border-separate",
             "caption-top", "caption-bottom":
            return true
        default:
            break
        }

        if name.hasPrefix("border-spacing-") {
            return true
        }

        return false
    }
}
