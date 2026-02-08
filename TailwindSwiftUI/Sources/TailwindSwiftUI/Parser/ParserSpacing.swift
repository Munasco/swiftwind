import SwiftUI

// MARK: - Spacing: Padding & Margin
extension TailwindModifier {

    func applySpacingClass(_ className: String, to view: AnyView) -> AnyView? {
        // Padding
        if className.hasPrefix("p-") && !className.hasPrefix("pl-") && !className.hasPrefix("pr-") && !className.hasPrefix("pt-") && !className.hasPrefix("pb-") && !className.hasPrefix("px-") && !className.hasPrefix("py-") {
            if let v = extractNumber(from: className, prefix: "p-") {
                return AnyView(view.padding(spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("px-") {
            if let v = extractNumber(from: className, prefix: "px-") {
                return AnyView(view.padding(.horizontal, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("py-") {
            if let v = extractNumber(from: className, prefix: "py-") {
                return AnyView(view.padding(.vertical, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("pt-") {
            if let v = extractNumber(from: className, prefix: "pt-") {
                return AnyView(view.padding(.top, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("pr-") {
            if let v = extractNumber(from: className, prefix: "pr-") {
                return AnyView(view.padding(.trailing, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("pb-") {
            if let v = extractNumber(from: className, prefix: "pb-") {
                return AnyView(view.padding(.bottom, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("pl-") {
            if let v = extractNumber(from: className, prefix: "pl-") {
                return AnyView(view.padding(.leading, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("pe-") {
            if let v = extractNumber(from: className, prefix: "pe-") {
                return AnyView(view.padding(.trailing, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("ps-") {
            if let v = extractNumber(from: className, prefix: "ps-") {
                return AnyView(view.padding(.leading, spacingValue(v)))
            }
            return nil
        }

        // Margin auto
        if className == "m-auto" { return AnyView(view.frame(maxWidth: .infinity, maxHeight: .infinity)) }
        if className == "mx-auto" { return AnyView(view.frame(maxWidth: .infinity)) }
        if className == "my-auto" { return AnyView(view.frame(maxHeight: .infinity)) }
        if className == "ml-auto" { return AnyView(view.frame(maxWidth: .infinity, alignment: .trailing)) }
        if className == "mr-auto" { return AnyView(view.frame(maxWidth: .infinity, alignment: .leading)) }
        if className == "mt-auto" { return AnyView(view.frame(maxHeight: .infinity, alignment: .bottom)) }
        if className == "mb-auto" { return AnyView(view.frame(maxHeight: .infinity, alignment: .top)) }

        // Negative margins
        if className.hasPrefix("-m-") {
            if let v = extractNumber(from: className, prefix: "-m-") {
                return AnyView(view.offset(x: -spacingValue(v), y: -spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("-mx-") {
            if let v = extractNumber(from: className, prefix: "-mx-") {
                return AnyView(view.offset(x: -spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("-my-") {
            if let v = extractNumber(from: className, prefix: "-my-") {
                return AnyView(view.offset(y: -spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("-mt-") {
            if let v = extractNumber(from: className, prefix: "-mt-") {
                return AnyView(view.offset(y: -spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("-mb-") {
            if let v = extractNumber(from: className, prefix: "-mb-") {
                return AnyView(view.offset(y: spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("-ml-") {
            if let v = extractNumber(from: className, prefix: "-ml-") {
                return AnyView(view.offset(x: -spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("-mr-") {
            if let v = extractNumber(from: className, prefix: "-mr-") {
                return AnyView(view.offset(x: spacingValue(v)))
            }
            return nil
        }

        // Positive margins (offset approximation)
        if className.hasPrefix("m-") && !className.hasPrefix("mx-") && !className.hasPrefix("my-") && !className.hasPrefix("mt-") && !className.hasPrefix("mr-") && !className.hasPrefix("mb-") && !className.hasPrefix("ml-") && !className.hasPrefix("ms-") && !className.hasPrefix("me-") && !className.hasPrefix("max-") && !className.hasPrefix("min-") {
            if let v = extractNumber(from: className, prefix: "m-") {
                return AnyView(view.padding(spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("mx-") {
            if let v = extractNumber(from: className, prefix: "mx-") {
                return AnyView(view.padding(.horizontal, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("my-") {
            if let v = extractNumber(from: className, prefix: "my-") {
                return AnyView(view.padding(.vertical, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("mt-") {
            if let v = extractNumber(from: className, prefix: "mt-") {
                return AnyView(view.padding(.top, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("mr-") {
            if let v = extractNumber(from: className, prefix: "mr-") {
                return AnyView(view.padding(.trailing, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("mb-") {
            if let v = extractNumber(from: className, prefix: "mb-") {
                return AnyView(view.padding(.bottom, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("ml-") {
            if let v = extractNumber(from: className, prefix: "ml-") {
                return AnyView(view.padding(.leading, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("ms-") {
            if let v = extractNumber(from: className, prefix: "ms-") {
                return AnyView(view.padding(.leading, spacingValue(v)))
            }
            return nil
        }
        if className.hasPrefix("me-") {
            if let v = extractNumber(from: className, prefix: "me-") {
                return AnyView(view.padding(.trailing, spacingValue(v)))
            }
            return nil
        }

        // Space between (container level)
        if className.hasPrefix("space-x-") || className.hasPrefix("space-y-") {
            return AnyView(view)
        }

        return nil
    }
}
