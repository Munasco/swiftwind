import SwiftUI

// MARK: - Layout: flex, grid, position, overflow, display, visibility, z-index, gap, object-fit
extension TailwindModifier {
    private var isPositionedForInset: Bool {
        switch twPositionMode {
        case .static:
            return false
        case .relative, .absolute, .fixed, .sticky:
            return true
        }
    }

    private func applyInset(_ view: AnyView, className: String, x: CGFloat = 0, y: CGFloat = 0) -> AnyView {
        guard isPositionedForInset else {
            #if DEBUG
            TailwindLogger.warn("'\(className)' requires a positioned element ('relative', 'absolute', 'fixed', or 'sticky').")
            #endif
            return view
        }
        return AnyView(view.offset(x: x, y: y))
    }

    func applyLayoutClass(_ className: String, to view: AnyView) -> AnyView? {
        // Most layout-affecting utilities are intentionally scoped to TWView only.
        // Overflow is useful on regular SwiftUI containers too, so allow it globally.
        if TWViewType(from: Content.self) != .twView, !className.hasPrefix("overflow-") {
            return nil
        }

        // Container
        if className == "container" {
            return AnyView(view.frame(maxWidth: .infinity, alignment: .center))
        }

        // Display
        switch className {
        case "block", "inline-block", "inline", "flex", "inline-flex",
             "grid", "inline-grid", "contents", "flow-root":
            return AnyView(view)
        case "hidden": return AnyView(view.hidden())
        default: break
        }

        // Visibility
        switch className {
        case "visible": return AnyView(view.opacity(1))
        case "invisible": return AnyView(view.opacity(0))
        case "collapse": return AnyView(view.hidden())
        default: break
        }

        // Position
        switch className {
        case "static":
            return AnyView(view.environment(\.twPositionMode, .static))
        case "relative":
            return AnyView(view.environment(\.twPositionMode, .relative))
        case "absolute":
            return AnyView(
                view
                    .environment(\.twPositionMode, .absolute)
                    .zIndex(1)
            )
        case "fixed":
            return AnyView(
                view
                    .environment(\.twPositionMode, .fixed)
                    .zIndex(2)
            )
        case "sticky":
            return AnyView(
                view
                    .environment(\.twPositionMode, .sticky)
                    .zIndex(1)
            )
        default: break
        }

        // Inset (top/right/bottom/left)
        if className.hasPrefix("inset-x-") {
            let val = className.replacingOccurrences(of: "inset-x-", with: "")
            if val == "0" || val == "auto" || val == "full" { return AnyView(view) }
            if let v = extractNumber(from: className, prefix: "inset-x-") {
                return applyInset(view, className: className, x: spacingValue(v))
            }
            return AnyView(view)
        }
        if className.hasPrefix("inset-y-") {
            let val = className.replacingOccurrences(of: "inset-y-", with: "")
            if val == "0" || val == "auto" || val == "full" { return AnyView(view) }
            if let v = extractNumber(from: className, prefix: "inset-y-") {
                return applyInset(view, className: className, y: spacingValue(v))
            }
            return AnyView(view)
        }
        if className.hasPrefix("inset-") {
            let val = className.replacingOccurrences(of: "inset-", with: "")
            if val == "0" { return AnyView(view) }
            if val == "auto" { return AnyView(view) }
            if val == "full" { return AnyView(view) }
            if val == "x-0" || val == "y-0" || val == "x-auto" || val == "y-auto" { return AnyView(view) }
            if let v = extractNumber(from: className, prefix: "inset-") {
                return applyInset(view, className: className, x: spacingValue(v), y: spacingValue(v))
            }
            return AnyView(view)
        }
        if className.hasPrefix("top-") {
            if let v = extractNumber(from: className, prefix: "top-") {
                return applyInset(view, className: className, y: spacingValue(v))
            }
            return AnyView(view)
        }
        if className.hasPrefix("bottom-") {
            if let v = extractNumber(from: className, prefix: "bottom-") {
                return applyInset(view, className: className, y: -spacingValue(v))
            }
            return AnyView(view)
        }
        if className.hasPrefix("left-") {
            if let v = extractNumber(from: className, prefix: "left-") {
                return applyInset(view, className: className, x: spacingValue(v))
            }
            return AnyView(view)
        }
        if className.hasPrefix("right-") && !className.hasPrefix("right-[") {
            if let v = extractNumber(from: className, prefix: "right-") {
                return applyInset(view, className: className, x: -spacingValue(v))
            }
            return AnyView(view)
        }
        if className.hasPrefix("start-") {
            if let v = extractNumber(from: className, prefix: "start-") {
                return applyInset(view, className: className, x: spacingValue(v))
            }
            return AnyView(view)
        }
        if className.hasPrefix("end-") {
            if let v = extractNumber(from: className, prefix: "end-") {
                return applyInset(view, className: className, x: -spacingValue(v))
            }
            return AnyView(view)
        }

        // Flex direction & wrap
        switch className {
        case "flex-row": return AnyView(view)
        case "flex-row-reverse": return AnyView(view)
        case "flex-col": return AnyView(view)
        case "flex-col-reverse": return AnyView(view)
        case "flex-wrap": return AnyView(view)
        case "flex-wrap-reverse": return AnyView(view)
        case "flex-nowrap": return AnyView(view)
        case "flex-1": return AnyView(view.frame(maxWidth: .infinity, maxHeight: .infinity))
        case "flex-auto": return AnyView(view.frame(maxWidth: .infinity))
        case "flex-initial": return AnyView(view)
        case "flex-none": return AnyView(view.fixedSize())
        default: break
        }

        // Flex grow/shrink
        switch className {
        case "grow", "grow-1": return AnyView(view.frame(maxWidth: .infinity))
        case "grow-0": return AnyView(view)
        case "shrink", "shrink-1": return AnyView(view)
        case "shrink-0": return AnyView(view.fixedSize())
        default: break
        }

        // Flex basis
        if className.hasPrefix("basis-") {
            let val = className.replacingOccurrences(of: "basis-", with: "")
            switch val {
            case "auto":
                return AnyView(view)
            case "full":
                return AnyView(view.frame(maxWidth: .infinity))
            case "1/2":
                return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.5, y: 1))
            case "1/3":
                return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.333, y: 1))
            case "2/3":
                return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.667, y: 1))
            case "1/4":
                return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.25, y: 1))
            case "3/4":
                return AnyView(view.frame(maxWidth: .infinity).scaleEffect(x: 0.75, y: 1))
            default:
                if let v = extractNumber(from: className, prefix: "basis-") {
                    return AnyView(view.frame(width: spacingValue(v)))
                }
            }
            return AnyView(view)
        }

        // Order
        if className.hasPrefix("order-") {
            return AnyView(view) // No direct SwiftUI equivalent
        }

        // Justify content
        switch className {
        case "justify-normal", "justify-start": return AnyView(view.frame(maxWidth: .infinity, alignment: .leading))
        case "justify-end": return AnyView(view.frame(maxWidth: .infinity, alignment: .trailing))
        case "justify-center": return AnyView(view.frame(maxWidth: .infinity, alignment: .center))
        case "justify-between": return AnyView(view.frame(maxWidth: .infinity))
        case "justify-around": return AnyView(view.frame(maxWidth: .infinity))
        case "justify-evenly": return AnyView(view.frame(maxWidth: .infinity))
        case "justify-stretch": return AnyView(view.frame(maxWidth: .infinity))
        default: break
        }

        // Justify items/self
        switch className {
        case "justify-items-start": return AnyView(view.frame(maxWidth: .infinity, alignment: .leading))
        case "justify-items-end": return AnyView(view.frame(maxWidth: .infinity, alignment: .trailing))
        case "justify-items-center": return AnyView(view.frame(maxWidth: .infinity, alignment: .center))
        case "justify-items-stretch": return AnyView(view.frame(maxWidth: .infinity))
        case "justify-self-auto": return AnyView(view)
        case "justify-self-start": return AnyView(view.frame(maxWidth: .infinity, alignment: .leading))
        case "justify-self-end": return AnyView(view.frame(maxWidth: .infinity, alignment: .trailing))
        case "justify-self-center": return AnyView(view.frame(maxWidth: .infinity, alignment: .center))
        case "justify-self-stretch": return AnyView(view.frame(maxWidth: .infinity))
        default: break
        }

        // Align items
        switch className {
        case "items-start": return AnyView(view.frame(maxHeight: .infinity, alignment: .top))
        case "items-end": return AnyView(view.frame(maxHeight: .infinity, alignment: .bottom))
        case "items-center": return AnyView(view.frame(maxHeight: .infinity, alignment: .center))
        case "items-baseline": return AnyView(view.frame(maxHeight: .infinity, alignment: .center))
        case "items-stretch": return AnyView(view.frame(maxHeight: .infinity))
        default: break
        }

        // Align self
        switch className {
        case "self-auto": return AnyView(view)
        case "self-start": return AnyView(view.frame(maxHeight: .infinity, alignment: .top))
        case "self-end": return AnyView(view.frame(maxHeight: .infinity, alignment: .bottom))
        case "self-center": return AnyView(view.frame(maxHeight: .infinity, alignment: .center))
        case "self-stretch": return AnyView(view.frame(maxHeight: .infinity))
        case "self-baseline": return AnyView(view)
        default: break
        }

        // Align content
        switch className {
        case "content-normal", "content-start", "content-end",
             "content-center", "content-between", "content-around",
             "content-evenly", "content-baseline", "content-stretch":
            return AnyView(view)
        default: break
        }

        // Place content/items/self
        if className.hasPrefix("place-content-") || className.hasPrefix("place-items-") || className.hasPrefix("place-self-") {
            return AnyView(view)
        }

        // Gap
        if className.hasPrefix("gap-") && !className.hasPrefix("gap-x-") && !className.hasPrefix("gap-y-") {
            return AnyView(view) // Gap handled at container level
        }
        if className.hasPrefix("gap-x-") || className.hasPrefix("gap-y-") {
            return AnyView(view)
        }

        // Grid
        if className.hasPrefix("grid-cols-") || className.hasPrefix("grid-rows-") {
            return AnyView(view)
        }
        if className.hasPrefix("col-span-") || className.hasPrefix("col-start-") || className.hasPrefix("col-end-") {
            return AnyView(view)
        }
        if className.hasPrefix("row-span-") || className.hasPrefix("row-start-") || className.hasPrefix("row-end-") {
            return AnyView(view)
        }
        if className.hasPrefix("auto-cols-") || className.hasPrefix("auto-rows-") {
            return AnyView(view)
        }
        if className.hasPrefix("grid-flow-") {
            return AnyView(view)
        }
        // Overflow
        switch className {
        case "overflow-auto":
            return AnyView(
                TWOverflowScrollContainer(
                    axis: .both,
                    content: AnyView(view.fixedSize(horizontal: true, vertical: true))
                )
            )
        case "overflow-hidden": return AnyView(view.clipped())
        case "overflow-clip": return AnyView(view.clipped())
        case "overflow-visible": return AnyView(view)
        case "overflow-scroll":
            return AnyView(
                TWOverflowScrollContainer(
                    axis: .both,
                    content: AnyView(view.fixedSize(horizontal: true, vertical: true))
                )
            )
        case "overflow-x-auto", "overflow-x-hidden", "overflow-x-clip",
             "overflow-x-visible":
            if className == "overflow-x-auto" {
                return AnyView(
                    TWOverflowScrollContainer(
                        axis: .horizontal,
                        content: AnyView(view.fixedSize(horizontal: true, vertical: false))
                    )
                )
            }
            if className == "overflow-x-hidden" || className == "overflow-x-clip" {
                return AnyView(view.clipped())
            }
            return AnyView(view)
        case "overflow-x-scroll":
            return AnyView(
                TWOverflowScrollContainer(
                    axis: .horizontal,
                    content: AnyView(view.fixedSize(horizontal: true, vertical: false))
                )
            )
        case "overflow-y-auto", "overflow-y-hidden", "overflow-y-clip",
             "overflow-y-visible":
            if className == "overflow-y-auto" {
                return AnyView(
                    TWOverflowScrollContainer(
                        axis: .vertical,
                        content: AnyView(view.fixedSize(horizontal: false, vertical: true))
                    )
                )
            }
            if className == "overflow-y-hidden" || className == "overflow-y-clip" {
                return AnyView(view.clipped())
            }
            return AnyView(view)
        case "overflow-y-scroll":
            return AnyView(
                TWOverflowScrollContainer(
                    axis: .vertical,
                    content: AnyView(view.fixedSize(horizontal: false, vertical: true))
                )
            )
        default: break
        }

        // Z-index
        if className.hasPrefix("z-") {
            let val = className.replacingOccurrences(of: "z-", with: "")
            if val == "auto" { return AnyView(view) }
            if let v = extractNumber(from: className, prefix: "z-") {
                return AnyView(view.zIndex(Double(v)))
            }
            return nil
        }

        // Object fit
        switch className {
        case "object-contain": return AnyView(view.aspectRatio(contentMode: .fit))
        case "object-cover": return AnyView(view.aspectRatio(contentMode: .fill))
        case "object-fill": return AnyView(view.scaledToFill())
        case "object-none": return AnyView(view)
        case "object-scale-down": return AnyView(view.aspectRatio(contentMode: .fit))
        default: break
        }

        // Object position
        if className.hasPrefix("object-") {
            return AnyView(view) // object-center, object-top, etc.
        }

        // Float / clear (no direct SwiftUI equivalent)
        if className.hasPrefix("float-") || className.hasPrefix("clear-") {
            return AnyView(view)
        }

        // Isolation
        switch className {
        case "isolate", "isolation-auto": return AnyView(view)
        default: break
        }

        // Box sizing
        switch className {
        case "box-border", "box-content": return AnyView(view)
        default: break
        }

        // Columns
        if className.hasPrefix("columns-") {
            return AnyView(view)
        }

        // Break before/after/inside
        if className.hasPrefix("break-before-") || className.hasPrefix("break-after-") || className.hasPrefix("break-inside-") {
            return AnyView(view)
        }

        return nil
    }
}
