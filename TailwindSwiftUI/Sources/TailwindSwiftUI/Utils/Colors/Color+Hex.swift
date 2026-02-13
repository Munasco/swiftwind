import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

public extension Color {
    /// Hex color string in `#RRGGBB` format when the color can be resolved.
    var hex: String? {
        guard let rgba = resolvedRGBA else { return nil }
        return String(
            format: "#%02X%02X%02X",
            Int((rgba.r * 255.0).rounded()),
            Int((rgba.g * 255.0).rounded()),
            Int((rgba.b * 255.0).rounded())
        )
    }

    /// Hex color string in `#RRGGBBAA` format when the color can be resolved.
    var hexStringWithAlpha: String? {
        guard let rgba = resolvedRGBA else { return nil }
        return String(
            format: "#%02X%02X%02X%02X",
            Int((rgba.r * 255.0).rounded()),
            Int((rgba.g * 255.0).rounded()),
            Int((rgba.b * 255.0).rounded()),
            Int((rgba.a * 255.0).rounded())
        )
    }

    private var resolvedRGBA: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (r, g, b, a)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let sRGB = nsColor.usingColorSpace(.sRGB) else { return nil }
        return (sRGB.redComponent, sRGB.greenComponent, sRGB.blueComponent, sRGB.alphaComponent)
        #else
        return nil
        #endif
    }
}
