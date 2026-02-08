import SwiftUI

// MARK: - Accessibility: sr-only, forced colors, color scheme, print
extension TailwindModifier {

    func applyAccessibilityClass(_ className: String, to view: AnyView) -> AnyView? {
        // Screen reader only
        switch className {
        case "sr-only":
            return AnyView(view.frame(width: 1, height: 1).clipped().opacity(0).accessibilityHidden(false))
        case "not-sr-only":
            return AnyView(view.frame(maxWidth: .infinity, maxHeight: .infinity).opacity(1))
        default: break
        }

        // Forced color adjust
        switch className {
        case "forced-color-adjust-auto", "forced-color-adjust-none":
            return AnyView(view)
        default: break
        }

        // Color scheme
        switch className {
        case "scheme-normal": return AnyView(view)
        case "scheme-dark": return AnyView(view.preferredColorScheme(.dark))
        case "scheme-light": return AnyView(view.preferredColorScheme(.light))
        default: break
        }

        // Print (no SwiftUI equivalent)
        if className.hasPrefix("print:") { return AnyView(view) }

        // Disabled state
        if className == "disabled" {
            return AnyView(view.disabled(true).opacity(0.5))
        }

        return nil
    }
}
