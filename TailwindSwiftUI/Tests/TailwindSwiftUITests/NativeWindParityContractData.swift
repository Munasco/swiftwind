enum NativeWindParityContractData {
    static let fullSupportInventoryStandard: [String] = [
        // Sizing
        "w-full", "w-12", "w-1/2", "w-1/6",
        "h-12", "h-1/2", "min-h-8", "max-h-64",
        "min-w-0", "max-w-lg", "max-w-screen-sm",
        "size-8",
        "aspect-auto", "aspect-square", "aspect-video", "aspect-4/3", "aspect-[4/3]",

        // Spacing
        "p-4", "px-3", "py-2", "pt-1", "pr-2", "pb-3", "pl-4",
        "m-2", "mx-2", "my-1", "mt-3", "mr-1", "mb-4", "ml-2",
        "space-x-2", "space-y-2",
        "p-safe", "px-safe", "pt-safe",

        // Typography
        "text-xs", "text-sm", "text-base", "text-lg", "text-center",
        "font-sans", "font-serif", "font-mono", "font-semibold",
        "leading-tight", "tracking-wide", "truncate", "line-clamp-2",
        "uppercase", "underline", "line-through",
        "list-disc", "list-decimal", "list-inside", "list-outside",
        "underline-offset-2", "decoration-dotted", "decoration-2",

        // Colors / backgrounds / gradient stops
        "bg-blue-500", "bg-blue-500/38", "text-white", "text-red-500/60",
        "bg-linear-to-r", "bg-linear-to-br", "bg-linear-45",
        "from-blue-500", "via-cyan-500", "to-emerald-500",
        "accent-blue-500", "caret-red-500",
        "bg-center", "bg-top", "bg-no-repeat", "bg-cover", "bg-scroll",

        // Borders / effects / transforms
        "border", "border-2", "border-red-500/40", "rounded-lg",
        "ring", "ring-2", "ring-blue-500", "ring-offset-2", "ring-offset-blue-500",
        "outline", "outline-2", "outline-offset-2", "outline-red-500",
        "divide-x", "divide-y", "divide-blue-500",
        "opacity-75", "shadow-md", "drop-shadow-sm",
        "transition-colors", "duration-200", "ease-in-out", "delay-100",
        "animate-spin", "animate-pulse",
        "scale-95", "rotate-6", "translate-x-2", "skew-y-3",

        // Interactivity
        "pointer-events-none", "pointer-events-auto",
        "touch-auto", "touch-pan-x", "touch-pan-y", "touch-manipulation",
        "appearance-none",

        // SVG
        "fill-red-500", "fill-none", "stroke-blue-500", "stroke-2", "stroke-[3px]",

        // Variants
        "dark:bg-slate-900", "ios:p-4", "macos:p-8", "sm:text-sm", "md:text-base",
    ]

    static let fullSupportInventoryContainer: [String] = [
        // Display / layout
        "container",
        "flex", "inline-flex", "grid", "hidden", "visible",
        "flex-row", "flex-col", "flex-wrap",
        "basis-1/2", "basis-64", "basis-full",
        "grow", "grow-0", "shrink", "shrink-0",
        "justify-start", "justify-center", "justify-end", "justify-between",
        "justify-items-center", "justify-self-center",
        "items-start", "items-center", "items-end",
        "content-center", "place-items-center", "place-content-center", "place-self-center",
        "grid-cols-2", "grid-rows-2", "grid-flow-row",
        "auto-cols-auto", "auto-rows-auto",
        "col-span-2", "row-span-2",
        "order-1",
        "columns-2",
        "box-border", "box-content",
        "box-decoration-clone",
        "float-left", "clear-both", "isolate",
        "break-before-auto", "break-after-auto", "break-inside-auto",
        "z-10",
        "overflow-hidden", "overflow-clip", "overflow-visible",
        "border-spacing-2",
    ]

    static let webOnlyInventory: [String] = [
        // Overflow scroll families
        "overflow-auto", "overflow-scroll", "overflow-x-auto", "overflow-y-scroll",

        // Overscroll
        "overscroll-auto", "overscroll-contain", "overscroll-none",

        // Scroll behavior/margin/padding/snap
        "scroll-smooth", "scroll-auto",
        "scroll-m-2", "scroll-p-2",
        "snap-x", "snap-center",

        // Web-specific pointer/selection/resize families
        "cursor-pointer", "resize", "resize-x", "select-none",

        // Web-only sizing tokens
        "h-auto", "h-min", "h-max", "h-fit",
        "w-auto", "w-min", "w-max", "w-fit",
        "min-h-fit", "max-h-fit", "min-w-fit", "max-w-fit",

        // Web-only table display family
        "table", "table-row", "table-cell",
    ]

    static let parityGaps: [String] = []
}
