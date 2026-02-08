import SwiftUI

// MARK: - String-based Tailwind Modifier
public extension View {
    /// Tailwind-style className string
    /// Usage: Text("Hello").tw("p-4 bg-red-500 rounded-lg shadow-md")
    /// Works on ALL SwiftUI views: Text, VStack, HStack, Image, Button, etc.
    func tw(_ classes: String) -> some View {
        TailwindModifier(classes: classes, content: self)
    }
}

struct TailwindModifier<Content: View>: View {
    let classes: [String]
    let content: Content

    init(classes: String, content: Content) {
        self.classes = classes.split(separator: " ").map(String.init)
        self.content = content
    }

    private var viewType: TWViewType {
        TWViewType(from: Content.self)
    }

    var body: some View {
        var view = AnyView(content)
        for className in classes {
            view = applyClass(className, to: view)
        }
        return view
    }

    // MARK: - Main Dispatch
    private func applyClass(_ className: String, to view: AnyView) -> AnyView {
        // Validate class against view type
        #if DEBUG
        if let result = TailwindValidation.validate(className, viewType: viewType) {
            switch result.level {
            case .error:
                TailwindLogger.error(result.message)
                return view // Skip applying the incompatible class
            case .warning:
                TailwindLogger.warn(result.message)
                // Continue applying - it might still partially work
            }
        }
        #endif

        // Try each category in order. First match wins.
        if let r = applySpacingClass(className, to: view) { return r }
        if let r = applyColorClass(className, to: view) { return r }
        if let r = applyTypographyClass(className, to: view) { return r }
        if let r = applySizingClass(className, to: view) { return r }
        if let r = applyLayoutClass(className, to: view) { return r }
        if let r = applyBorderClass(className, to: view) { return r }
        if let r = applyEffectsClass(className, to: view) { return r }
        if let r = applyTransformClass(className, to: view) { return r }
        if let r = applyInteractivityClass(className, to: view) { return r }
        if let r = applyAccessibilityClass(className, to: view) { return r }
        if let r = applyBracketClass(className, to: view) { return r }

        #if DEBUG
        TailwindLogger.warn("Unknown Tailwind class: '\(className)'")
        #endif
        return view
    }
}

// MARK: - Shared Helpers
extension TailwindModifier {

    func extractNumber(from className: String, prefix: String) -> CGFloat? {
        let valueStr = className.replacingOccurrences(of: prefix, with: "")
        if valueStr.hasPrefix("[") {
            return extractBracketValue(from: className, prefix: prefix)
        }
        if let doubleVal = Double(valueStr) {
            return CGFloat(doubleVal)
        }
        return nil
    }

    func spacingValue(_ n: CGFloat) -> CGFloat {
        return n * 4
    }

    func extractBracketValue(from className: String, prefix: String) -> CGFloat? {
        let valueStr = className.replacingOccurrences(of: prefix, with: "")
        guard valueStr.hasPrefix("[") && valueStr.hasSuffix("]") else { return nil }
        let inner = String(valueStr.dropFirst().dropLast())
        let numeric = inner
            .replacingOccurrences(of: "px", with: "")
            .replacingOccurrences(of: "pt", with: "")
            .replacingOccurrences(of: "rem", with: "")
            .replacingOccurrences(of: "%", with: "")
        if let val = Double(numeric) {
            if inner.hasSuffix("rem") { return CGFloat(val * 16) }
            return CGFloat(val)
        }
        return nil
    }

    func parseBracketColor(from className: String, prefix: String) -> Color? {
        let valueStr = className.replacingOccurrences(of: prefix, with: "")
        guard valueStr.hasPrefix("[") && valueStr.hasSuffix("]") else { return nil }
        let inner = String(valueStr.dropFirst().dropLast())
        guard inner.hasPrefix("#") else { return nil }
        let hex = String(inner.dropFirst())
        guard let hexInt = UInt(hex, radix: 16) else { return nil }
        return Color(hex: hexInt)
    }

    func parseColor(from className: String, prefix: String) -> Color? {
        let colorStr = className.replacingOccurrences(of: prefix, with: "")
        if colorStr.hasPrefix("[") {
            return parseBracketColor(from: className, prefix: prefix)
        }
        switch colorStr {
        case "white": return .white
        case "black": return .black
        case "transparent": return .clear
        case "current", "inherit": return nil
        default: break
        }
        let parts = colorStr.split(separator: "-")
        guard parts.count == 2 else { return nil }
        return getColorByName(String(parts[0]), shade: String(parts[1]))
    }

    func parseRadius(from className: String) -> CGFloat? {
        switch className {
        case "rounded-none": return 0
        case "rounded-sm": return 2
        case "rounded": return 4
        case "rounded-md": return 6
        case "rounded-lg": return 8
        case "rounded-xl": return 12
        case "rounded-2xl": return 16
        case "rounded-3xl": return 24
        case "rounded-full": return 9999
        default: return nil
        }
    }

    func parseTextSize(from className: String) -> CGFloat? {
        switch className {
        case "text-xs": return 12
        case "text-sm": return 14
        case "text-base": return 16
        case "text-lg": return 18
        case "text-xl": return 20
        case "text-2xl": return 24
        case "text-3xl": return 30
        case "text-4xl": return 36
        case "text-5xl": return 48
        case "text-6xl": return 60
        case "text-7xl": return 72
        case "text-8xl": return 96
        case "text-9xl": return 128
        default: return nil
        }
    }

    func parseShadow(from className: String) -> (radius: CGFloat, y: CGFloat)? {
        switch className {
        case "shadow-sm": return (1, 1)
        case "shadow": return (2, 1)
        case "shadow-md": return (4, 2)
        case "shadow-lg": return (8, 4)
        case "shadow-xl": return (12, 8)
        case "shadow-2xl": return (24, 12)
        case "shadow-none": return (0, 0)
        case "shadow-inner": return (2, -1)
        default: return nil
        }
    }

    func parseBlur(from className: String) -> CGFloat? {
        switch className {
        case "blur-none": return 0
        case "blur-sm": return 4
        case "blur": return 8
        case "blur-md": return 12
        case "blur-lg": return 16
        case "blur-xl": return 24
        case "blur-2xl": return 40
        case "blur-3xl": return 64
        default: return nil
        }
    }
}
