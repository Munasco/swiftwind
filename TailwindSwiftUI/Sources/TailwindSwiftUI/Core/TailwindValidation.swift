import SwiftUI
import TailwindLinter

// MARK: - Class categories for validation
enum TWClassIntent {
    case layoutContainer  // flex-row, justify-*, items-*, grid-*, gap-*, columns-*
    case textOnly         // tracking-*, leading-*, line-clamp-*, underline, line-through
    case imageOnly        // object-contain, object-cover, object-fill
    case universal        // padding, margin, bg, border, rounded, shadow, opacity, size
}

// MARK: - View type detection
enum TWViewType {
    case text
    case image
    case twView
    case container
    case other

    init<V: View>(from viewType: V.Type) {
        let name = String(describing: viewType)
        if name.hasPrefix("Text") || name == "Label" {
            self = .text
        } else if name.hasPrefix("Image") || name.hasPrefix("AsyncImage") {
            self = .image
        } else if name.hasPrefix("TWView") {
            self = .twView
        } else if name.hasPrefix("VStack") || name.hasPrefix("HStack") ||
                  name.hasPrefix("ZStack") || name.hasPrefix("LazyVStack") ||
                  name.hasPrefix("LazyHStack") || name.hasPrefix("LazyVGrid") ||
                  name.hasPrefix("LazyHGrid") || name.hasPrefix("ScrollView") ||
                  name.hasPrefix("List") || name.hasPrefix("Group") ||
                  name.hasPrefix("ForEach") || name.hasPrefix("Form") ||
                  name.hasPrefix("NavigationStack") || name.hasPrefix("NavigationView") ||
                  name.hasPrefix("TabView") {
            self = .container
        } else {
            self = .other
        }
    }
}

// MARK: - Validation
enum TailwindValidation {

    /// Returns the intent of a Tailwind class
    static func classIntent(_ className: String) -> TWClassIntent {
        // Layout container classes - make no sense on Text/Image
        if TailwindClassCatalog.isLayoutClass(className) {
            return .layoutContainer
        }

        // Text-only classes
        if className.hasPrefix("tracking-") || className.hasPrefix("leading-") ||
           className.hasPrefix("line-clamp-") || className == "truncate" ||
           className == "underline" || className == "line-through" ||
           className == "no-underline" || className == "overline" ||
           className == "italic" || className == "not-italic" ||
           className == "uppercase" || className == "lowercase" ||
           className == "capitalize" || className == "normal-case" ||
           className.hasPrefix("font-") || className.hasPrefix("text-wrap") ||
           className == "text-nowrap" || className == "text-ellipsis" ||
           className.hasPrefix("whitespace-") || className.hasPrefix("break-") ||
           className.hasPrefix("hyphens-") || className.hasPrefix("decoration-") ||
           className == "antialiased" || className == "subpixel-antialiased" ||
           className.hasPrefix("indent-") || className.hasPrefix("-indent-") ||
           className.hasPrefix("align-") || className.hasPrefix("underline-offset-") ||
           className == "normal-nums" || className == "ordinal" || className == "slashed-zero" ||
           className == "lining-nums" || className == "oldstyle-nums" ||
           className == "proportional-nums" || className == "tabular-nums" ||
           className == "diagonal-fractions" || className == "stacked-fractions" {
            return .textOnly
        }

        // Image-only classes
        if className.hasPrefix("object-") {
            return .imageOnly
        }

        return .universal
    }

    /// Validate a class against a view type. Returns error/warning message or nil.
    static func validate(_ className: String, viewType: TWViewType) -> (level: TWLevel, message: String)? {
        let intent = classIntent(className)

        switch (intent, viewType) {
        // Layout classes on Text/Image — no effect
        case (.layoutContainer, .text):
            return (.error, "'\(className)' is a layout/container class and has no effect on Text. Use it on VStack, HStack, or other containers.")
        case (.layoutContainer, .image):
            return (.error, "'\(className)' is a layout/container class and has no effect on Image.")
        case (.layoutContainer, .container):
            return (.warning, "'\(className)' is scoped to TWView and is ignored on SwiftUI container types like VStack/HStack/ZStack.")
        case (.layoutContainer, .other):
            return (.warning, "'\(className)' is scoped to TWView and may be ignored on this view type.")

        // Text classes on Image — no effect
        case (.textOnly, .image):
            return (.error, "'\(className)' is a text class and has no effect on Image.")

        // Text classes on containers — font-* propagates via environment, rest doesn't
        case (.textOnly, .container):
            if className.hasPrefix("font-") { return nil }
            return (.error, "'\(className)' is a text class and has no effect on containers. Use it on Text directly.")

        // Image classes on Text — no effect
        case (.imageOnly, .text):
            return (.error, "'\(className)' is an image class and has no effect on Text.")

        // Image classes on containers — no effect
        case (.imageOnly, .container):
            return (.error, "'\(className)' is an image class and has no effect on containers. Use it on Image directly.")

        default:
            return nil
        }
    }

    enum TWLevel {
        case error
        case warning
    }
}
