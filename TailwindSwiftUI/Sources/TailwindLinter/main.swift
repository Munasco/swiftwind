import Foundation

// All known valid Tailwind class prefixes/exact matches
let validPrefixes: [String] = [
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

let validExact: Set<String> = [
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

// Layout-only classes that shouldn't be on Text/Image
let layoutClasses: Set<String> = [
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

let layoutPrefixes: [String] = [
    "gap-", "grid-cols-", "grid-rows-", "col-span-", "row-span-",
    "grid-flow-", "auto-cols-", "auto-rows-", "space-x-", "space-y-",
    "divide-", "columns-", "order-",
    "justify-items-", "justify-self-", "place-content-", "place-items-", "place-self-",
]

func isValidClass(_ name: String) -> Bool {
    if name.contains("[") && name.contains("]") { return true } // bracket = arbitrary
    if validExact.contains(name) { return true }
    for prefix in validPrefixes {
        if name.hasPrefix(prefix) { return true }
    }
    return false
}

func isLayoutClass(_ name: String) -> Bool {
    if layoutClasses.contains(name) { return true }
    for prefix in layoutPrefixes {
        if name.hasPrefix(prefix) { return true }
    }
    return false
}

func detectViewType(_ lineContent: String, _ prevLines: [String]) -> String? {
    let context = (prevLines.suffix(3).joined(separator: "\n") + "\n" + lineContent)
    if context.contains("Text(") || context.contains("Label(") { return "Text" }
    if context.contains("Image(") || context.contains("AsyncImage(") { return "Image" }
    return nil
}

// MARK: - Main
let args = CommandLine.arguments.dropFirst()

for filePath in args {
    guard let data = FileManager.default.contents(atPath: filePath),
          let content = String(data: data, encoding: .utf8) else { continue }

    let lines = content.components(separatedBy: "\n")

    for (index, line) in lines.enumerated() {
        let lineNum = index + 1

        // Find .tw("...") calls
        var searchRange = line.startIndex..<line.endIndex
        while let twRange = line.range(of: #".tw\(""#, options: .regularExpression, range: searchRange) {
            // Find the closing quote+paren
            let afterQuote = twRange.upperBound
            guard let closeQuote = line.range(of: "\")", range: afterQuote..<line.endIndex) else {
                searchRange = twRange.upperBound..<line.endIndex
                continue
            }

            let classString = String(line[afterQuote..<closeQuote.lowerBound])
            let classes = classString.split(separator: " ").map(String.init)
            let col = line.distance(from: line.startIndex, to: twRange.lowerBound) + 1

            let viewType = detectViewType(line, Array(lines.prefix(index)))

            for className in classes {
                // Check if valid
                if !isValidClass(className) {
                    print("\(filePath):\(lineNum):\(col): warning: Unknown Tailwind class '\(className)'")
                }

                // Check layout on Text/Image
                if let vt = viewType, (vt == "Text" || vt == "Image"), isLayoutClass(className) {
                    print("\(filePath):\(lineNum):\(col): error: '\(className)' is a layout class and has no effect on \(vt)")
                }
            }

            searchRange = closeQuote.upperBound..<line.endIndex
        }
    }
}
