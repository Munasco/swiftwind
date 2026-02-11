import Foundation

/// NativeWind parity helpers for utilities that are web-only in NativeWind v5 docs.
/// These classes are intentionally treated as no-ops on native platforms.
enum TailwindNativeWindParity {

    static func isWebOnlyClassOnNative(_ className: String) -> Bool {
        // Overflow axis/scroll variants are web-only in NativeWind.
        switch className {
        case "overflow-auto", "overflow-scroll",
             "overflow-x-auto", "overflow-x-scroll",
             "overflow-y-auto", "overflow-y-scroll":
            return true
        default:
            break
        }

        // Web-only sizing tokens in NativeWind docs (auto/min/max/fit buckets).
        switch className {
        case "h-auto", "h-min", "h-max", "h-fit",
             "w-auto", "w-min", "w-max", "w-fit",
             "min-h-min", "min-h-max", "min-h-fit",
             "max-h-min", "max-h-max", "max-h-fit",
             "min-w-min", "min-w-max", "min-w-fit",
             "max-w-min", "max-w-max", "max-w-fit":
            return true
        default:
            break
        }

        // Table display family is web-only.
        switch className {
        case "table", "table-caption", "table-cell", "table-column",
             "table-column-group", "table-footer-group", "table-header-group",
             "table-row-group", "table-row":
            return true
        default:
            break
        }

        // Overscroll behavior is web-only.
        if className.hasPrefix("overscroll-") {
            return true
        }

        // Scroll behavior/margin/padding/snap are web-only.
        if className == "scroll-auto" || className == "scroll-smooth" {
            return true
        }
        if className.hasPrefix("scroll-m-") || className.hasPrefix("scroll-mx-") ||
            className.hasPrefix("scroll-my-") || className.hasPrefix("scroll-mt-") ||
            className.hasPrefix("scroll-mr-") || className.hasPrefix("scroll-mb-") ||
            className.hasPrefix("scroll-ml-") {
            return true
        }
        if className.hasPrefix("scroll-p-") || className.hasPrefix("scroll-px-") ||
            className.hasPrefix("scroll-py-") || className.hasPrefix("scroll-pt-") ||
            className.hasPrefix("scroll-pr-") || className.hasPrefix("scroll-pb-") ||
            className.hasPrefix("scroll-pl-") {
            return true
        }
        if className.hasPrefix("snap-") {
            return true
        }

        // Interactivity classes with no RN-native equivalent in NativeWind.
        if className.hasPrefix("cursor-") {
            return true
        }
        switch className {
        case "resize", "resize-x", "resize-y", "resize-none",
             "select-none", "select-text", "select-all", "select-auto":
            return true
        default:
            break
        }

        return false
    }
}
