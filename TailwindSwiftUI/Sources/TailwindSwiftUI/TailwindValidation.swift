import SwiftUI

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
    case container
    case other

    init<V: View>(from viewType: V.Type) {
        let name = String(describing: viewType)
        if name.hasPrefix("Text") || name == "Label" {
            self = .text
        } else if name.hasPrefix("Image") || name.hasPrefix("AsyncImage") {
            self = .image
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
        if className.hasPrefix("flex-") || className == "flex" ||
           className.hasPrefix("justify-") || className.hasPrefix("items-") ||
           className.hasPrefix("content-") || className.hasPrefix("place-") ||
           className.hasPrefix("grid-") || className.hasPrefix("auto-cols-") ||
           className.hasPrefix("auto-rows-") || className.hasPrefix("col-span-") ||
           className.hasPrefix("col-start-") || className.hasPrefix("col-end-") ||
           className.hasPrefix("row-span-") || className.hasPrefix("row-start-") ||
           className.hasPrefix("row-end-") || className.hasPrefix("gap-") ||
           className.hasPrefix("columns-") || className.hasPrefix("grid-flow-") ||
           className.hasPrefix("space-x-") || className.hasPrefix("space-y-") ||
           className.hasPrefix("divide-") || className.hasPrefix("self-") ||
           className == "grow" || className == "grow-0" ||
           className == "shrink" || className == "shrink-0" ||
           className.hasPrefix("order-") || className.hasPrefix("float-") ||
           className.hasPrefix("clear-") {
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
           className.hasPrefix("hyphens-") || className.hasPrefix("decoration-") {
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
        // ERROR: Layout classes on Text
        case (.layoutContainer, .text):
            return (.error, "'\(className)' is a layout/container class and has no effect on Text. Use it on VStack, HStack, or other containers.")

        // ERROR: Layout classes on Image
        case (.layoutContainer, .image):
            return (.error, "'\(className)' is a layout/container class and has no effect on Image.")

        // WARN: Text-only classes on Image
        case (.textOnly, .image):
            return (.warning, "'\(className)' is a text class and has no effect on Image.")

        // WARN: Text-only classes on containers (actually propagates via environment, so just warn)
        case (.textOnly, .container):
            // font-* and foregroundColor propagate, so don't warn for those
            if className.hasPrefix("font-") { return nil }
            return (.warning, "'\(className)' is a text class. On containers it only works if child views inherit it.")

        // WARN: Image-only on Text
        case (.imageOnly, .text):
            return (.warning, "'\(className)' is an image class and may not behave as expected on Text.")

        default:
            return nil
        }
    }

    enum TWLevel {
        case error
        case warning
    }
}
