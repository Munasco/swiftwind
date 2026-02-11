import SwiftUI

/// NativeWind compatibility no-op layer.
/// These utilities are recognized as supported semantics on native platforms,
/// even when SwiftUI has no direct visual equivalent for the exact CSS behavior.
extension TailwindModifier {

    func applyNativeWindCompatNoOpClass(_ className: String, to view: AnyView) -> AnyView? {
        // Layout
        switch className {
        case "box-border", "box-content",
             "box-decoration-clone", "box-decoration-slice",
             "break-after-auto", "break-after-avoid", "break-after-all", "break-after-avoid-page",
             "break-before-auto", "break-before-avoid", "break-before-all", "break-before-avoid-page",
             "break-inside-auto", "break-inside-avoid", "break-inside-avoid-page",
             "float-right", "float-left", "float-none", "float-start", "float-end",
             "clear-left", "clear-right", "clear-both", "clear-none", "clear-start", "clear-end",
             "isolate", "isolation-auto":
            return AnyView(view)
        default:
            break
        }

        // Layout prefixes
        if className.hasPrefix("columns-") { return AnyView(view) }
        if className.hasPrefix("break-after-") { return AnyView(view) }
        if className.hasPrefix("break-before-") { return AnyView(view) }
        if className.hasPrefix("break-inside-") { return AnyView(view) }
        if className.hasPrefix("container-") { return AnyView(view) }
        if className.hasPrefix("justify-items-") { return AnyView(view) }
        if className.hasPrefix("justify-self-") { return AnyView(view) }
        if className.hasPrefix("place-self-") { return AnyView(view) }
        if className.hasPrefix("place-content-") { return AnyView(view) }
        if className.hasPrefix("place-items-") { return AnyView(view) }
        if className.hasPrefix("flex-basis-") { return AnyView(view) }

        // Backgrounds and gradients (non-arbitrary families)
        if className.hasPrefix("bg-attachment-") { return AnyView(view) }
        if className.hasPrefix("bg-clip-") { return AnyView(view) }
        if className.hasPrefix("bg-origin-") { return AnyView(view) }
        if className.hasPrefix("bg-repeat-") || className == "bg-repeat" || className == "bg-no-repeat" {
            return AnyView(view)
        }
        if className.hasPrefix("bg-position-") { return AnyView(view) }
        if className.hasPrefix("bg-size-") { return AnyView(view) }
        if className == "bg-cover" || className == "bg-contain" || className == "bg-auto" { return AnyView(view) }
        switch className {
        case "bg-none", "bg-fixed", "bg-local", "bg-scroll",
             "bg-center", "bg-top", "bg-right", "bg-bottom", "bg-left",
             "bg-left-top", "bg-left-bottom", "bg-right-top", "bg-right-bottom":
            return AnyView(view)
        default:
            break
        }

        // Typography families where SwiftUI mapping is partial/no-op.
        if className.hasPrefix("list-image-") { return AnyView(view) }
        if className == "list-inside" || className == "list-outside" { return AnyView(view) }
        if className.hasPrefix("list-") { return AnyView(view) }
        if className.hasPrefix("decoration-") { return AnyView(view) }
        if className.hasPrefix("underline-offset-") { return AnyView(view) }
        if className.hasPrefix("font-variant-") { return AnyView(view) }
        if className.hasPrefix("text-decoration-") { return AnyView(view) }
        if className.hasPrefix("text-shadow-") { return AnyView(view) }

        // Borders / effects families
        if className.hasPrefix("divide-") { return AnyView(view) }
        if className.hasPrefix("ring-offset-") { return AnyView(view) }
        if className.hasPrefix("outline-offset-") { return AnyView(view) }
        if className.hasPrefix("bg-blend-") { return AnyView(view) }
        if className.hasPrefix("shadow-color-") { return AnyView(view) }
        if className.hasPrefix("text-shadow-color-") { return AnyView(view) }
        if className.hasPrefix("mix-blend-") { return AnyView(view) }

        return nil
    }
}
