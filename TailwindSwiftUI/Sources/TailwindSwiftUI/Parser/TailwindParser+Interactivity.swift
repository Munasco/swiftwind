import SwiftUI

// MARK: - Interactivity: cursor, select, pointer, resize, scroll, touch, appearance
extension TailwindModifier {

    func applyInteractivityClass(_ className: String, to view: AnyView) -> AnyView? {
        if isLayoutScopedInteractivityClass(className), TWViewType(from: Content.self) != .twView {
            return nil
        }

        // Cursor (macOS only for most)
        switch className {
        case "cursor-auto", "cursor-default", "cursor-pointer", "cursor-wait",
             "cursor-text", "cursor-move", "cursor-help", "cursor-not-allowed",
             "cursor-none", "cursor-context-menu", "cursor-progress", "cursor-cell",
             "cursor-crosshair", "cursor-vertical-text", "cursor-alias", "cursor-copy",
             "cursor-no-drop", "cursor-grab", "cursor-grabbing", "cursor-all-scroll",
             "cursor-col-resize", "cursor-row-resize", "cursor-n-resize",
             "cursor-e-resize", "cursor-s-resize", "cursor-w-resize",
             "cursor-ne-resize", "cursor-nw-resize", "cursor-se-resize",
             "cursor-sw-resize", "cursor-ew-resize", "cursor-ns-resize",
             "cursor-nesw-resize", "cursor-nwse-resize", "cursor-zoom-in",
             "cursor-zoom-out":
            return AnyView(view)
        default: break
        }

        // User select
        switch className {
        case "select-none": return AnyView(view)
        case "select-text": return AnyView(view)
        case "select-all": return AnyView(view)
        case "select-auto": return AnyView(view)
        default: break
        }

        // Pointer events
        switch className {
        case "pointer-events-none": return AnyView(view.allowsHitTesting(false))
        case "pointer-events-auto": return AnyView(view.allowsHitTesting(true))
        default: break
        }

        // Resize
        switch className {
        case "resize-none", "resize-y", "resize-x", "resize": return AnyView(view)
        default: break
        }

        // Scroll behavior
        switch className {
        case "scroll-auto", "scroll-smooth": return AnyView(view)
        default: break
        }

        // Scroll margin/padding
        if className.hasPrefix("scroll-m-") || className.hasPrefix("scroll-mx-") ||
           className.hasPrefix("scroll-my-") || className.hasPrefix("scroll-mt-") ||
           className.hasPrefix("scroll-mr-") || className.hasPrefix("scroll-mb-") ||
           className.hasPrefix("scroll-ml-") {
            return AnyView(view)
        }
        if className.hasPrefix("scroll-p-") || className.hasPrefix("scroll-px-") ||
           className.hasPrefix("scroll-py-") || className.hasPrefix("scroll-pt-") ||
           className.hasPrefix("scroll-pr-") || className.hasPrefix("scroll-pb-") ||
           className.hasPrefix("scroll-pl-") {
            return AnyView(view)
        }

        // Scroll snap
        switch className {
        case "snap-start", "snap-end", "snap-center", "snap-align-none",
             "snap-normal", "snap-always":
            return AnyView(view)
        case "snap-none", "snap-x", "snap-y", "snap-both",
             "snap-mandatory", "snap-proximity":
            return AnyView(view)
        default: break
        }

        // Touch action
        switch className {
        case "touch-auto", "touch-none", "touch-pan-x", "touch-pan-left",
             "touch-pan-right", "touch-pan-y", "touch-pan-up", "touch-pan-down",
             "touch-pinch-zoom", "touch-manipulation":
            return AnyView(view)
        default: break
        }

        // Appearance
        switch className {
        case "appearance-none", "appearance-auto": return AnyView(view)
        default: break
        }

        // Overscroll behavior
        switch className {
        case "overscroll-auto", "overscroll-contain", "overscroll-none",
             "overscroll-x-auto", "overscroll-x-contain", "overscroll-x-none",
             "overscroll-y-auto", "overscroll-y-contain", "overscroll-y-none":
            return AnyView(view)
        default: break
        }

        // Caret color (handled in ParserColors)
        // Accent color (handled in ParserColors)

        return nil
    }

    private func isLayoutScopedInteractivityClass(_ className: String) -> Bool {
        if className == "scroll-auto" || className == "scroll-smooth" { return true }
        if className.hasPrefix("scroll-m-") || className.hasPrefix("scroll-mx-") ||
           className.hasPrefix("scroll-my-") || className.hasPrefix("scroll-mt-") ||
           className.hasPrefix("scroll-mr-") || className.hasPrefix("scroll-mb-") ||
           className.hasPrefix("scroll-ml-") { return true }
        if className.hasPrefix("scroll-p-") || className.hasPrefix("scroll-px-") ||
           className.hasPrefix("scroll-py-") || className.hasPrefix("scroll-pt-") ||
           className.hasPrefix("scroll-pr-") || className.hasPrefix("scroll-pb-") ||
           className.hasPrefix("scroll-pl-") { return true }
        if className.hasPrefix("snap-") { return true }
        if className.hasPrefix("overscroll-") { return true }
        return false
    }
}
