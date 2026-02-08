import SwiftUI

// MARK: - Typography: font, text size/align/decoration/transform, tracking, leading, line-clamp
extension TailwindModifier {

    func applyTypographyClass(_ className: String, to view: AnyView) -> AnyView? {

        // Font weights
        switch className {
        case "font-thin": return AnyView(view.fontWeight(.thin))
        case "font-extralight": return AnyView(view.fontWeight(.ultraLight))
        case "font-light": return AnyView(view.fontWeight(.light))
        case "font-normal": return AnyView(view.fontWeight(.regular))
        case "font-medium": return AnyView(view.fontWeight(.medium))
        case "font-semibold": return AnyView(view.fontWeight(.semibold))
        case "font-bold": return AnyView(view.fontWeight(.bold))
        case "font-extrabold": return AnyView(view.fontWeight(.heavy))
        case "font-black": return AnyView(view.fontWeight(.black))
        default: break
        }

        // Font style
        switch className {
        case "italic": return AnyView(view.font(.body.italic()))
        case "not-italic": return AnyView(view.font(.body))
        default: break
        }

        // Font family
        switch className {
        case "font-sans": return AnyView(view.font(.system(.body, design: .default)))
        case "font-serif": return AnyView(view.font(.system(.body, design: .serif)))
        case "font-mono": return AnyView(view.font(.system(.body, design: .monospaced)))
        default: break
        }

        // Text size
        if className.hasPrefix("text-") {
            if let size = parseTextSize(from: className) {
                return AnyView(view.font(.system(size: size)))
            }
        }

        // Text alignment
        switch className {
        case "text-left": return AnyView(view.multilineTextAlignment(.leading))
        case "text-center": return AnyView(view.multilineTextAlignment(.center))
        case "text-right": return AnyView(view.multilineTextAlignment(.trailing))
        case "text-justify": return AnyView(view.multilineTextAlignment(.leading))
        case "text-start": return AnyView(view.multilineTextAlignment(.leading))
        case "text-end": return AnyView(view.multilineTextAlignment(.trailing))
        default: break
        }

        // Text decoration
        switch className {
        case "underline": return AnyView(view.underline())
        case "overline": return AnyView(view) // No SwiftUI equivalent
        case "line-through": return AnyView(view.strikethrough())
        case "no-underline": return AnyView(view.underline(false))
        default: break
        }

        // Text decoration style
        if className.hasPrefix("decoration-") {
            // decoration-solid, decoration-dashed, etc. - limited SwiftUI support
            return nil
        }

        // Text transform
        switch className {
        case "uppercase": return AnyView(view.textCase(.uppercase))
        case "lowercase": return AnyView(view.textCase(.lowercase))
        case "capitalize": return AnyView(view.textCase(nil)) // No direct capitalize in SwiftUI
        case "normal-case": return AnyView(view.textCase(nil))
        default: break
        }

        // Text wrap
        switch className {
        case "text-wrap": return AnyView(view.fixedSize(horizontal: false, vertical: true))
        case "text-nowrap": return AnyView(view.fixedSize(horizontal: true, vertical: false))
        case "text-balance": return AnyView(view)
        case "text-pretty": return AnyView(view)
        default: break
        }

        // Text overflow
        switch className {
        case "truncate": return AnyView(view.lineLimit(1).truncationMode(.tail))
        case "text-ellipsis": return AnyView(view.truncationMode(.tail))
        case "text-clip": return AnyView(view.clipped())
        default: break
        }

        // Line clamp
        if className.hasPrefix("line-clamp-") {
            let suffix = className.replacingOccurrences(of: "line-clamp-", with: "")
            if suffix == "none" {
                return AnyView(view.lineLimit(nil))
            }
            if let v = Int(suffix) {
                return AnyView(view.lineLimit(v))
            }
            return nil
        }

        // Tracking (letter spacing)
        switch className {
        case "tracking-tighter": return AnyView(view.tracking(-0.8))
        case "tracking-tight": return AnyView(view.tracking(-0.4))
        case "tracking-normal": return AnyView(view.tracking(0))
        case "tracking-wide": return AnyView(view.tracking(0.4))
        case "tracking-wider": return AnyView(view.tracking(0.8))
        case "tracking-widest": return AnyView(view.tracking(1.6))
        default: break
        }

        // Leading (line height) - approximated via lineSpacing
        switch className {
        case "leading-none": return AnyView(view.lineSpacing(0))
        case "leading-tight": return AnyView(view.lineSpacing(2))
        case "leading-snug": return AnyView(view.lineSpacing(4))
        case "leading-normal": return AnyView(view.lineSpacing(6))
        case "leading-relaxed": return AnyView(view.lineSpacing(8))
        case "leading-loose": return AnyView(view.lineSpacing(12))
        default: break
        }
        if className.hasPrefix("leading-") {
            if let v = extractNumber(from: className, prefix: "leading-") {
                return AnyView(view.lineSpacing(spacingValue(v)))
            }
        }

        // Whitespace
        switch className {
        case "whitespace-normal": return AnyView(view)
        case "whitespace-nowrap": return AnyView(view.fixedSize(horizontal: true, vertical: false))
        case "whitespace-pre": return AnyView(view)
        case "whitespace-pre-line": return AnyView(view)
        case "whitespace-pre-wrap": return AnyView(view)
        case "whitespace-break-spaces": return AnyView(view)
        default: break
        }

        // Word/overflow break
        switch className {
        case "break-normal": return AnyView(view)
        case "break-words": return AnyView(view)
        case "break-all": return AnyView(view)
        case "break-keep": return AnyView(view)
        default: break
        }

        // Hyphens
        switch className {
        case "hyphens-none": return AnyView(view)
        case "hyphens-manual": return AnyView(view)
        case "hyphens-auto": return AnyView(view)
        default: break
        }

        // Content (for pseudo-elements - not applicable in SwiftUI)
        if className.hasPrefix("content-") {
            return AnyView(view)
        }

        return nil
    }
}
