import Foundation
import SwiftUI
import TailwindLinter

public enum TailwindThemeTokenKind: String, CaseIterable, Sendable {
    case animate
    case aspect
    case borderWidth
    case blur
    case breakpoint
    case columns
    case color
    case container
    case cursor
    case delay
    case duration
    case dropShadow
    case ease
    case font
    case fontWeight
    case insetShadow
    case leading
    case opacity
    case outline
    case perspective
    case radius
    case ring
    case ringOffset
    case rotate
    case scale
    case shadow
    case skew
    case spacing
    case text
    case textShadow
    case tracking
    case transition
    case zIndex
}
public enum TailwindRawCssProperty: Equatable, Sendable {
    case color
    case backgroundColor
    case borderColor
    case ringColor
    case ringOffsetColor
    case outlineColor
    case fill
    case stroke
    case shadowColor
    case textShadowColor
    case caretColor
    case accentColor
    case placeholderColor
    /// Custom CSS property name, e.g. `"background-image"`, `"line-height"`, `"--my-prop"`.
    case custom(String)

    public var cssName: String {
        switch self {
        case .color: return "color"
        case .backgroundColor: return "background-color"
        case .borderColor: return "border-color"
        case .ringColor: return "ring-color"
        case .ringOffsetColor: return "ring-offset-color"
        case .outlineColor: return "outline-color"
        case .fill: return "fill"
        case .stroke: return "stroke"
        case .shadowColor: return "shadow-color"
        case .textShadowColor: return "text-shadow-color"
        case .caretColor: return "caret-color"
        case .accentColor: return "accent-color"
        case .placeholderColor: return "placeholder-color"
        case let .custom(name): return name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    fileprivate var supportsColorResolution: Bool {
        switch self {
        case .color, .backgroundColor, .borderColor, .ringColor, .ringOffsetColor, .outlineColor,
                .fill, .stroke, .shadowColor, .textShadowColor, .caretColor, .accentColor, .placeholderColor:
            return true
        case let .custom(name):
            return Self.isColorLikePropertyName(name)
        }
    }

    private static func isColorLikePropertyName(_ raw: String) -> Bool {
        let name = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if name.isEmpty { return false }
        if name == "color" || name == "fill" || name == "stroke" { return true }
        return name.hasSuffix("-color")
    }
}

public struct TailwindVar {
    fileprivate let light: TailwindVarExpression
    fileprivate let dark: TailwindVarExpression?

    fileprivate init(light: TailwindVarExpression, dark: TailwindVarExpression? = nil) {
        self.light = light
        self.dark = dark
    }

    /// Color-based variable, with optional dark override.
    /// Usage: `.color(light: .blue500, dark: .yellow500)`
    public static func color(light: Color, dark: Color? = nil) -> TailwindVar {
        TailwindVar(light: .color(light), dark: dark.map(TailwindVarExpression.color))
    }

    /// Token-based variable, where token is a tailwind color token or hex string.
    /// Examples: `"blue-500"`, `"#2b7fff"`, `"var(--color-brand-bg)"`.
    public static func token(light: String, dark: String? = nil) -> TailwindVar {
        TailwindVar(light: .token(light), dark: dark.map(TailwindVarExpression.token))
    }

    /// String-based color value helper.
    /// Examples: `.color(light: "blue-500", dark: "yellow-500")`, `.color(light: "#2b7fff")`
    public static func color(light: String, dark: String? = nil) -> TailwindVar {
        TailwindVar(light: .typedToken(type: .color, value: light), dark: dark.map { .typedToken(type: .color, value: $0) })
    }

    public static func animate(light: String, dark: String? = nil) -> TailwindVar {
        typed(.animate, light: light, dark: dark)
    }

    public static func aspect(light: String, dark: String? = nil) -> TailwindVar {
        typed(.aspect, light: light, dark: dark)
    }

    public static func blur(light: String, dark: String? = nil) -> TailwindVar {
        typed(.blur, light: light, dark: dark)
    }

    public static func breakpoint(light: String, dark: String? = nil) -> TailwindVar {
        typed(.breakpoint, light: light, dark: dark)
    }

    public static func container(light: String, dark: String? = nil) -> TailwindVar {
        typed(.container, light: light, dark: dark)
    }

    public static func borderWidth(light: String, dark: String? = nil) -> TailwindVar {
        typed(.borderWidth, light: light, dark: dark)
    }

    public static func columns(light: String, dark: String? = nil) -> TailwindVar {
        typed(.columns, light: light, dark: dark)
    }

    public static func cursor(light: String, dark: String? = nil) -> TailwindVar {
        typed(.cursor, light: light, dark: dark)
    }

    public static func delay(light: String, dark: String? = nil) -> TailwindVar {
        typed(.delay, light: light, dark: dark)
    }

    public static func duration(light: String, dark: String? = nil) -> TailwindVar {
        typed(.duration, light: light, dark: dark)
    }

    public static func dropShadow(light: String, dark: String? = nil) -> TailwindVar {
        typed(.dropShadow, light: light, dark: dark)
    }

    public static func ease(light: String, dark: String? = nil) -> TailwindVar {
        typed(.ease, light: light, dark: dark)
    }

    public static func font(light: String, dark: String? = nil) -> TailwindVar {
        typed(.font, light: light, dark: dark)
    }

    public static func fontWeight(light: String, dark: String? = nil) -> TailwindVar {
        typed(.fontWeight, light: light, dark: dark)
    }

    public static func insetShadow(light: String, dark: String? = nil) -> TailwindVar {
        typed(.insetShadow, light: light, dark: dark)
    }

    public static func leading(light: String, dark: String? = nil) -> TailwindVar {
        typed(.leading, light: light, dark: dark)
    }

    public static func opacity(light: String, dark: String? = nil) -> TailwindVar {
        typed(.opacity, light: light, dark: dark)
    }

    public static func outline(light: String, dark: String? = nil) -> TailwindVar {
        typed(.outline, light: light, dark: dark)
    }

    public static func perspective(light: String, dark: String? = nil) -> TailwindVar {
        typed(.perspective, light: light, dark: dark)
    }

    public static func radius(light: String, dark: String? = nil) -> TailwindVar {
        typed(.radius, light: light, dark: dark)
    }

    public static func ring(light: String, dark: String? = nil) -> TailwindVar {
        typed(.ring, light: light, dark: dark)
    }

    public static func ringOffset(light: String, dark: String? = nil) -> TailwindVar {
        typed(.ringOffset, light: light, dark: dark)
    }

    public static func rotate(light: String, dark: String? = nil) -> TailwindVar {
        typed(.rotate, light: light, dark: dark)
    }

    public static func scale(light: String, dark: String? = nil) -> TailwindVar {
        typed(.scale, light: light, dark: dark)
    }

    public static func shadow(light: String, dark: String? = nil) -> TailwindVar {
        typed(.shadow, light: light, dark: dark)
    }

    public static func skew(light: String, dark: String? = nil) -> TailwindVar {
        typed(.skew, light: light, dark: dark)
    }

    public static func spacing(light: String, dark: String? = nil) -> TailwindVar {
        typed(.spacing, light: light, dark: dark)
    }

    public static func text(light: String, dark: String? = nil) -> TailwindVar {
        typed(.text, light: light, dark: dark)
    }

    public static func textShadow(light: String, dark: String? = nil) -> TailwindVar {
        typed(.textShadow, light: light, dark: dark)
    }

    public static func tracking(light: String, dark: String? = nil) -> TailwindVar {
        typed(.tracking, light: light, dark: dark)
    }

    public static func transition(light: String, dark: String? = nil) -> TailwindVar {
        typed(.transition, light: light, dark: dark)
    }

    public static func zIndex(light: String, dark: String? = nil) -> TailwindVar {
        typed(.zIndex, light: light, dark: dark)
    }

    fileprivate static func typed(_ type: TailwindThemeTokenKind, light: String, dark: String? = nil) -> TailwindVar {
        TailwindVar(
            light: .typedToken(type: type, value: light),
            dark: dark.map { .typedToken(type: type, value: $0) }
        )
    }

    /// Alias for `token(light:dark:)`.
    public static func value(light: String, dark: String? = nil) -> TailwindVar {
        token(light: light, dark: dark)
    }

    /// Reference another variable, by name.
    /// Examples: `"brandBg"`, `"--brand-bg"`, `"var(--brand-bg)"`.
    public static func reference(light: String, dark: String? = nil) -> TailwindVar {
        TailwindVar(light: .reference(light), dark: dark.map(TailwindVarExpression.reference))
    }

    /// Escape hatch for raw CSS-like values keyed by a property name.
    public static func rawCss(
        light: String,
        dark: String? = nil,
        cssProperty: TailwindRawCssProperty
    ) -> TailwindVar {
        TailwindVar(
            light: .rawCss(value: light, property: cssProperty),
            dark: dark.map { .rawCss(value: $0, property: cssProperty) }
        )
    }

    /// Convenience overload for raw CSS-like values using a custom property name.
    /// Example: `.rawCss(light: "linear-gradient(...)", cssProperty: "background-image")`
    public static func rawCss(
        light: String,
        dark: String? = nil,
        cssProperty: String
    ) -> TailwindVar {
        rawCss(light: light, dark: dark, cssProperty: .custom(cssProperty))
    }

}

public struct TailwindThemeTokenVar: Sendable {
    public let name: String
    public let kind: TailwindThemeTokenKind
    public let light: String
    public let dark: String?

    public init(_ name: String, kind: TailwindThemeTokenKind, light: String, dark: String? = nil) {
        self.name = name
        self.kind = kind
        self.light = light
        self.dark = dark
    }
}

public struct TailwindColorValue: Sendable {
    public let light: String
    public let dark: String?

    public init(light: String, dark: String? = nil) {
        self.light = light
        self.dark = dark
    }

    public static func color(light: String, dark: String? = nil) -> TailwindColorValue {
        TailwindColorValue(light: light, dark: dark)
    }

    /// Single-value convenience. Applies to both light and dark.
    public static func color(_ value: String) -> TailwindColorValue {
        TailwindColorValue(light: value, dark: nil)
    }
}

public struct TailwindThemeTokenValue: Sendable {
    public let light: String
    public let dark: String?

    public init(light: String, dark: String? = nil) {
        self.light = light
        self.dark = dark
    }

    public static func token(light: String, dark: String? = nil) -> TailwindThemeTokenValue {
        TailwindThemeTokenValue(light: light, dark: dark)
    }

    public static func color(light: String, dark: String? = nil) -> TailwindThemeTokenValue {
        TailwindThemeTokenValue(light: light, dark: dark)
    }

    /// Single-value convenience. Applies to both light and dark.
    public static func token(_ value: String) -> TailwindThemeTokenValue {
        TailwindThemeTokenValue(light: value, dark: nil)
    }

    /// Single-value convenience. Applies to both light and dark.
    public static func color(_ value: String) -> TailwindThemeTokenValue {
        TailwindThemeTokenValue(light: value, dark: nil)
    }
}

public struct TailwindCSSPropertyValue: Sendable {
    public let light: String
    public let dark: String?

    public init(light: String, dark: String? = nil) {
        self.light = light
        self.dark = dark
    }

    public static func css(light: String, dark: String? = nil) -> TailwindCSSPropertyValue {
        TailwindCSSPropertyValue(light: light, dark: dark)
    }

    /// Single-value convenience. Applies to both light and dark.
    public static func css(_ value: String) -> TailwindCSSPropertyValue {
        TailwindCSSPropertyValue(light: value, dark: nil)
    }
}

public struct TailwindRawCssVar: Sendable {
    public let name: String
    public let property: String
    public let light: String
    public let dark: String?

    public init(_ name: String, property: String, light: String, dark: String? = nil) {
        self.name = name
        self.property = property
        self.light = light
        self.dark = dark
    }

    public init(_ name: String, property: TailwindRawCssProperty, light: String, dark: String? = nil) {
        self.init(name, property: property.cssName, light: light, dark: dark)
    }
}

public enum TailwindVariableEntry: Sendable {
    case themeToken(TailwindThemeTokenVar)
    case rawCss(TailwindRawCssVar)
    case utilities([String: String])
}

public extension TailwindVariableEntry {
    static func themeToken(
        _ name: String,
        kind: TailwindThemeTokenKind,
        light: String,
        dark: String? = nil
    ) -> TailwindVariableEntry {
        .themeToken(TailwindThemeTokenVar(name, kind: kind, light: light, dark: dark))
    }

    /// Default color entry (no platform override).
    /// Use this when you do not need iOS/macOS/tvOS/watchOS/visionOS-specific values.
    /// Example: `.color("--color-brand", light: "blue-500", dark: "yellow-500")`
    static func color(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry {
        .themeToken(TailwindThemeTokenVar(name, kind: .color, light: light, dark: dark))
    }

    /// Single-value color entry. Applies to both light and dark.
    static func color(_ name: String, _ value: String) -> TailwindVariableEntry {
        .themeToken(TailwindThemeTokenVar(name, kind: .color, light: value, dark: nil))
    }

    /// Single-value theme token entry. Applies to both light and dark.
    static func themeToken(
        _ name: String,
        kind: TailwindThemeTokenKind,
        _ value: String
    ) -> TailwindVariableEntry {
        .themeToken(TailwindThemeTokenVar(name, kind: kind, light: value, dark: nil))
    }

    /// Platform-aware theme token entry.
    /// `default` is required, platform buckets are optional and override `default` when present.
    static func themeToken(
        _ name: String,
        kind: TailwindThemeTokenKind,
        `default` defaultValue: TailwindThemeTokenValue,
        iOS: TailwindThemeTokenValue? = nil,
        macOS: TailwindThemeTokenValue? = nil,
        tvOS: TailwindThemeTokenValue? = nil,
        watchOS: TailwindThemeTokenValue? = nil,
        visionOS: TailwindThemeTokenValue? = nil
    ) -> TailwindVariableEntry {
        let selected = currentPlatformThemeTokenValue(
            default: defaultValue,
            iOS: iOS,
            macOS: macOS,
            tvOS: tvOS,
            watchOS: watchOS,
            visionOS: visionOS
        )
        return .themeToken(
            TailwindThemeTokenVar(
                name,
                kind: kind,
                light: selected.light,
                dark: selected.dark
            )
        )
    }

    /// Platform-aware color entry (string values).
    /// `default` is required, platform buckets are optional and override `default` when present.
    static func color(
        _ name: String,
        `default` defaultLight: String,
        iOS: String? = nil,
        macOS: String? = nil,
        tvOS: String? = nil,
        watchOS: String? = nil,
        visionOS: String? = nil,
        dark: String? = nil
    ) -> TailwindVariableEntry {
        .themeToken(
            TailwindThemeTokenVar(
                name,
                kind: .color,
                light: currentPlatformValue(
                    default: defaultLight,
                    iOS: iOS,
                    macOS: macOS,
                    tvOS: tvOS,
                    watchOS: watchOS,
                    visionOS: visionOS
                ),
                dark: dark
            )
        )
    }

    /// Platform-aware color entry (typed light/dark values).
    /// `default` is required, platform buckets are optional and override `default` when present.
    static func spacing(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry {
        .themeToken(TailwindThemeTokenVar(name, kind: .spacing, light: light, dark: dark))
    }

    static func animate(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .animate, light: light, dark: dark) }
    static func aspect(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .aspect, light: light, dark: dark) }
    static func borderWidth(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .borderWidth, light: light, dark: dark) }
    static func blur(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .blur, light: light, dark: dark) }
    static func breakpoint(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .breakpoint, light: light, dark: dark) }
    static func columns(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .columns, light: light, dark: dark) }
    static func container(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .container, light: light, dark: dark) }
    static func cursor(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .cursor, light: light, dark: dark) }
    static func delay(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .delay, light: light, dark: dark) }
    static func duration(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .duration, light: light, dark: dark) }
    static func dropShadow(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .dropShadow, light: light, dark: dark) }
    static func ease(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .ease, light: light, dark: dark) }
    static func font(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .font, light: light, dark: dark) }
    static func fontWeight(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .fontWeight, light: light, dark: dark) }
    static func insetShadow(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .insetShadow, light: light, dark: dark) }
    static func leading(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .leading, light: light, dark: dark) }
    static func opacity(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .opacity, light: light, dark: dark) }
    static func outline(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .outline, light: light, dark: dark) }
    static func perspective(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .perspective, light: light, dark: dark) }
    static func radius(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .radius, light: light, dark: dark) }
    static func ring(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .ring, light: light, dark: dark) }
    static func ringOffset(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .ringOffset, light: light, dark: dark) }
    static func rotate(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .rotate, light: light, dark: dark) }
    static func scale(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .scale, light: light, dark: dark) }
    static func shadow(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .shadow, light: light, dark: dark) }
    static func skew(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .skew, light: light, dark: dark) }
    static func text(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .text, light: light, dark: dark) }
    static func textShadow(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .textShadow, light: light, dark: dark) }
    static func tracking(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .tracking, light: light, dark: dark) }
    static func transition(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .transition, light: light, dark: dark) }
    static func zIndex(_ name: String, light: String, dark: String? = nil) -> TailwindVariableEntry { themeToken(name, kind: .zIndex, light: light, dark: dark) }

    static func animate(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .animate, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func aspect(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .aspect, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func borderWidth(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .borderWidth, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func blur(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .blur, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func breakpoint(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .breakpoint, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func columns(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .columns, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func color(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .color, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func container(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .container, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func cursor(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .cursor, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func delay(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .delay, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func duration(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .duration, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func dropShadow(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .dropShadow, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func ease(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .ease, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func font(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .font, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func fontWeight(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .fontWeight, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func insetShadow(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .insetShadow, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func leading(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .leading, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func opacity(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .opacity, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func outline(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .outline, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func perspective(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .perspective, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func radius(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .radius, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func ring(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .ring, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func ringOffset(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .ringOffset, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func rotate(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .rotate, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func scale(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .scale, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func shadow(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .shadow, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func skew(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .skew, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func spacing(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .spacing, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func text(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .text, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func textShadow(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .textShadow, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func tracking(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .tracking, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func transition(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .transition, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }
    static func zIndex(_ name: String, `default` defaultValue: TailwindThemeTokenValue, iOS: TailwindThemeTokenValue? = nil, macOS: TailwindThemeTokenValue? = nil, tvOS: TailwindThemeTokenValue? = nil, watchOS: TailwindThemeTokenValue? = nil, visionOS: TailwindThemeTokenValue? = nil) -> TailwindVariableEntry { themeToken(name, kind: .zIndex, default: defaultValue, iOS: iOS, macOS: macOS, tvOS: tvOS, watchOS: watchOS, visionOS: visionOS) }

    static func rawCss(
        _ name: String,
        property: String,
        light: String,
        dark: String? = nil
    ) -> TailwindVariableEntry {
        .rawCss(TailwindRawCssVar(name, property: property, light: light, dark: dark))
    }

    static func css(
        _ name: String,
        property: String,
        light: String,
        dark: String? = nil
    ) -> TailwindVariableEntry {
        .rawCss(TailwindRawCssVar(name, property: property, light: light, dark: dark))
    }

    /// Single-value CSS variable entry. Applies to both light and dark.
    static func css(
        _ name: String,
        property: String,
        _ value: String
    ) -> TailwindVariableEntry {
        .rawCss(TailwindRawCssVar(name, property: property, light: value, dark: nil))
    }

    static func css(
        _ name: String,
        property: String,
        `default` defaultValue: TailwindCSSPropertyValue,
        iOS: TailwindCSSPropertyValue? = nil,
        macOS: TailwindCSSPropertyValue? = nil,
        tvOS: TailwindCSSPropertyValue? = nil,
        watchOS: TailwindCSSPropertyValue? = nil,
        visionOS: TailwindCSSPropertyValue? = nil
    ) -> TailwindVariableEntry {
        let selected = currentPlatformCssValue(
            default: defaultValue,
            iOS: iOS,
            macOS: macOS,
            tvOS: tvOS,
            watchOS: watchOS,
            visionOS: visionOS
        )
        return .rawCss(TailwindRawCssVar(name, property: property, light: selected.light, dark: selected.dark))
    }

    static func rawCss(
        _ name: String,
        property: TailwindRawCssProperty,
        light: String,
        dark: String? = nil
    ) -> TailwindVariableEntry {
        .rawCss(TailwindRawCssVar(name, property: property, light: light, dark: dark))
    }

    static func css(
        _ name: String,
        property: TailwindRawCssProperty,
        light: String,
        dark: String? = nil
    ) -> TailwindVariableEntry {
        .rawCss(TailwindRawCssVar(name, property: property, light: light, dark: dark))
    }

    /// Single-value CSS variable entry. Applies to both light and dark.
    static func css(
        _ name: String,
        property: TailwindRawCssProperty,
        _ value: String
    ) -> TailwindVariableEntry {
        .rawCss(TailwindRawCssVar(name, property: property, light: value, dark: nil))
    }

    static func css(
        _ name: String,
        property: TailwindRawCssProperty,
        `default` defaultValue: TailwindCSSPropertyValue,
        iOS: TailwindCSSPropertyValue? = nil,
        macOS: TailwindCSSPropertyValue? = nil,
        tvOS: TailwindCSSPropertyValue? = nil,
        watchOS: TailwindCSSPropertyValue? = nil,
        visionOS: TailwindCSSPropertyValue? = nil
    ) -> TailwindVariableEntry {
        css(
            name,
            property: property.cssName,
            default: defaultValue,
            iOS: iOS,
            macOS: macOS,
            tvOS: tvOS,
            watchOS: watchOS,
            visionOS: visionOS
        )
    }

    private static func currentPlatformValue(
        `default` defaultValue: String,
        iOS: String?,
        macOS: String?,
        tvOS: String?,
        watchOS: String?,
        visionOS: String?
    ) -> String {
        #if os(iOS)
        iOS ?? defaultValue
        #elseif os(macOS)
        macOS ?? defaultValue
        #elseif os(tvOS)
        tvOS ?? defaultValue
        #elseif os(watchOS)
        watchOS ?? defaultValue
        #elseif os(visionOS)
        visionOS ?? defaultValue
        #else
        defaultValue
        #endif
    }

    private static func currentPlatformThemeTokenValue(
        `default` defaultValue: TailwindThemeTokenValue,
        iOS: TailwindThemeTokenValue?,
        macOS: TailwindThemeTokenValue?,
        tvOS: TailwindThemeTokenValue?,
        watchOS: TailwindThemeTokenValue?,
        visionOS: TailwindThemeTokenValue?
    ) -> TailwindThemeTokenValue {
        #if os(iOS)
        iOS ?? defaultValue
        #elseif os(macOS)
        macOS ?? defaultValue
        #elseif os(tvOS)
        tvOS ?? defaultValue
        #elseif os(watchOS)
        watchOS ?? defaultValue
        #elseif os(visionOS)
        visionOS ?? defaultValue
        #else
        defaultValue
        #endif
    }

    private static func currentPlatformCssValue(
        `default` defaultValue: TailwindCSSPropertyValue,
        iOS: TailwindCSSPropertyValue?,
        macOS: TailwindCSSPropertyValue?,
        tvOS: TailwindCSSPropertyValue?,
        watchOS: TailwindCSSPropertyValue?,
        visionOS: TailwindCSSPropertyValue?
    ) -> TailwindCSSPropertyValue {
        #if os(iOS)
        iOS ?? defaultValue
        #elseif os(macOS)
        macOS ?? defaultValue
        #elseif os(tvOS)
        tvOS ?? defaultValue
        #elseif os(watchOS)
        watchOS ?? defaultValue
        #elseif os(visionOS)
        visionOS ?? defaultValue
        #else
        defaultValue
        #endif
    }

}

public enum TailwindInitializationError: Error, CustomStringConvertible {
    case unresolvedReference(variable: String, reference: String)
    case circularReference(path: [String])
    case invalidColorVariableName(variable: String)

    public var description: String {
        switch self {
        case let .unresolvedReference(variable, reference):
            return "Unresolved Tailwind var reference '\(reference)' in variable '\(variable)'."
        case let .circularReference(path):
            return "Circular Tailwind var reference detected: \(path.joined(separator: " -> "))."
        case let .invalidColorVariableName(variable):
            return "Tailwind color variables must use '--color-*' (or '--tw-color-*'). Invalid variable: '\(variable)'."
        }
    }
}

public enum TailwindPlatform: String, CaseIterable, Hashable {
    case all
    case iOS
    case macOS
    case tvOS
    case watchOS
    case visionOS

    static var current: TailwindPlatform {
        #if os(iOS)
        return .iOS
        #elseif os(macOS)
        return .macOS
        #elseif os(tvOS)
        return .tvOS
        #elseif os(watchOS)
        return .watchOS
        #elseif os(visionOS)
        return .visionOS
        #else
        return .all
        #endif
    }
}

public enum TailwindSwiftUI {
    /// Unified initializer for theme-token vars + raw-css vars + utility aliases.
    /// `themeVariables` is the default path and should be preferred.
    public static func initialize(
        themeVariables: [TailwindThemeTokenVar] = [],
        cssVariables: [TailwindRawCssVar] = [],
        utilities: [String: String] = [:]
    ) {
        let vars = makeVarMap(themeVariables: themeVariables, cssVariables: cssVariables)
        initialize(vars: vars, utilities: utilities)
    }

    /// Initialize runtime variables using DSL-style values, including references.
    /// Example:
    ///   TailwindSwiftUI.initialize(vars: [
    ///     "brandBg": .color(light: .blue500, dark: .yellow500),
    ///     "cardBg": .reference(light: "brandBg"),
    ///     "accent": .reference(light: "--color-emerald-500")
    ///   ])
    public static func initialize(vars: [String: TailwindVar] = [:], utilities: [String: String] = [:]) {
        do {
            try Tailwind.shared.configure(varDefinitions: vars, utilities: utilities, strict: false)
        } catch {
            // Non-strict mode should never throw; keep this as a fallback safety net.
            TailwindLogger.warn("Unexpected Tailwind initialization error: \(error)")
        }
    }

    /// Initialize only variables in non-strict mode (warnings on bad references).
    public static func initializeVariables(_ vars: [String: TailwindVar]) {
        initialize(vars: vars, utilities: [:])
    }

    /// Initialize typed theme token variables.
    public static func initializeThemeVariables(_ vars: [TailwindThemeTokenVar]) {
        initialize(themeVariables: vars)
    }

    /// Initialize raw css variables.
    public static func initializeCSSVariables(_ vars: [TailwindRawCssVar]) {
        initialize(cssVariables: vars)
    }

    /// Initialize from mixed entries (theme tokens, css vars, utilities).
    public static func initialize(entries: [TailwindVariableEntry]) {
        let split = split(entries: entries)
        initialize(themeVariables: split.themeVariables, cssVariables: split.cssVariables, utilities: split.utilities)
    }

    /// Initialize variables from platform buckets and automatically apply the
    /// current platform overrides on top of shared defaults.
    ///
    /// Precedence: `defaultVars` < `.all` < `.currentPlatform`.
    public static func initializeVariables(
        _ varsByPlatform: [TailwindPlatform: [String: TailwindVar]],
        defaultVars: [String: TailwindVar] = [:]
    ) {
        var merged = defaultVars
        if let shared = varsByPlatform[.all] {
            merged.merge(shared) { _, new in new }
        }
        if let platformSpecific = varsByPlatform[TailwindPlatform.current] {
            merged.merge(platformSpecific) { _, new in new }
        }
        initializeVariables(merged)
    }

    /// Initialize variables from per-platform mixed variable entries.
    /// Precedence: `defaultVars` < `.all` < `.currentPlatform`.
    public static func initializeVariables(
        _ varsByPlatform: [TailwindPlatform: [TailwindVariableEntry]],
        defaultVars: [TailwindVariableEntry] = []
    ) {
        var merged = makeVarMap(from: defaultVars)
        if let shared = varsByPlatform[.all] {
            merged.merge(makeVarMap(from: shared)) { _, new in new }
        }
        if let platformSpecific = varsByPlatform[TailwindPlatform.current] {
            merged.merge(makeVarMap(from: platformSpecific)) { _, new in new }
        }
        initializeVariables(merged)
    }

    /// Convenience platform initializer with explicit labels to reduce call-site clutter.
    ///
    /// Precedence: `default` < current platform bucket.
    public static func initializeVariables(
        `default` defaultVars: [String: TailwindVar] = [:],
        iOS: [String: TailwindVar] = [:],
        macOS: [String: TailwindVar] = [:],
        tvOS: [String: TailwindVar] = [:],
        watchOS: [String: TailwindVar] = [:],
        visionOS: [String: TailwindVar] = [:]
    ) {
        var merged = defaultVars
        #if os(iOS)
        merged.merge(iOS) { _, new in new }
        #elseif os(macOS)
        merged.merge(macOS) { _, new in new }
        #elseif os(tvOS)
        merged.merge(tvOS) { _, new in new }
        #elseif os(watchOS)
        merged.merge(watchOS) { _, new in new }
        #elseif os(visionOS)
        merged.merge(visionOS) { _, new in new }
        #endif
        initializeVariables(merged)
    }

    /// Convenience platform initializer for mixed variable entries.
    /// Precedence: `default` < current platform bucket.
    public static func initializeVariables(
        `default` defaultVars: [TailwindVariableEntry] = [],
        iOS: [TailwindVariableEntry] = [],
        macOS: [TailwindVariableEntry] = [],
        tvOS: [TailwindVariableEntry] = [],
        watchOS: [TailwindVariableEntry] = [],
        visionOS: [TailwindVariableEntry] = []
    ) {
        var merged = makeVarMap(from: defaultVars)
        #if os(iOS)
        merged.merge(makeVarMap(from: iOS)) { _, new in new }
        #elseif os(macOS)
        merged.merge(makeVarMap(from: macOS)) { _, new in new }
        #elseif os(tvOS)
        merged.merge(makeVarMap(from: tvOS)) { _, new in new }
        #elseif os(watchOS)
        merged.merge(makeVarMap(from: watchOS)) { _, new in new }
        #elseif os(visionOS)
        merged.merge(makeVarMap(from: visionOS)) { _, new in new }
        #endif
        initializeVariables(merged)
    }

    public static func initializeVariablesForiOS(_ vars: [String: TailwindVar]) {
        #if os(iOS)
        initializeVariables(vars)
        #endif
    }

    public static func initializeVariablesFormacOS(_ vars: [String: TailwindVar]) {
        #if os(macOS)
        initializeVariables(vars)
        #endif
    }

    public static func initializeVariablesFortvOS(_ vars: [String: TailwindVar]) {
        #if os(tvOS)
        initializeVariables(vars)
        #endif
    }

    public static func initializeVariablesForwatchOS(_ vars: [String: TailwindVar]) {
        #if os(watchOS)
        initializeVariables(vars)
        #endif
    }

    public static func initializeVariablesForvisionOS(_ vars: [String: TailwindVar]) {
        #if os(visionOS)
        initializeVariables(vars)
        #endif
    }

    /// Initialize only utility aliases.
    public static func initializeUtilities(_ utilities: [String: String]) {
        initialize(vars: [:], utilities: utilities)
    }

    /// Seed Tailwind default theme variables (v4-aligned buckets and values).
    /// This adds standard defaults like `--color-*`, `--font-*`, `--breakpoint-*`,
    /// spacing/text/radius/shadow/ease/animate tokens, etc.
    public static func initializeDefaultThemeVariables() {
        Tailwind.shared.configureLazyDefaultVarDefinitions(TailwindDefaultTheme.makeVariables())
    }

    /// Initialize global TailwindSwiftUI runtime configuration.
    /// - Parameters:
    ///   - vars: Color variables keyed by name. Keys can be `brandBg`, `brand-bg`, or `--brand-bg`.
    ///   - darkVars: Dark mode overrides for vars. When present, these are used in dark color scheme.
    ///   - utilities: Utility aliases mapping one token to one or more class tokens.
    /// - Note: Last write wins for duplicate keys.
    public static func initialize(
        vars: [String: Color] = [:],
        darkVars: [String: Color] = [:],
        utilities: [String: String] = [:]
    ) {
        Tailwind.shared.configure(colors: vars, darkColors: darkVars, utilities: utilities)
    }

    /// Convenience overload for string color values (e.g. `blue`, `blue-500`, `#2b7fff`).
    public static func initialize(
        vars: [String: String] = [:],
        darkVars: [String: String] = [:],
        utilities: [String: String] = [:]
    ) {
        var resolved: [String: Color] = [:]
        var darkResolved: [String: Color] = [:]

        for (key, value) in vars {
            if let color = TailwindColorResolver.parseRuntimeColorValue(value) {
                resolved[key] = color
            } else {
                TailwindLogger.warn("Could not resolve TailwindSwiftUI var '\(key)' from value '\(value)'.")
            }
        }

        for (key, value) in darkVars {
            if let color = TailwindColorResolver.parseRuntimeColorValue(value) {
                darkResolved[key] = color
            } else {
                TailwindLogger.warn("Could not resolve TailwindSwiftUI dark var '\(key)' from value '\(value)'.")
            }
        }

        Tailwind.shared.configure(colors: resolved, darkColors: darkResolved, utilities: utilities)
    }

    /// Clears global runtime configuration. Useful in tests.
    public static func reset() {
        Tailwind.shared.reset()
    }

    private static func makeVarMap(from entries: [TailwindVariableEntry]) -> [String: TailwindVar] {
        var out: [String: TailwindVar] = [:]
        for entry in entries {
            switch entry {
            case let .themeToken(token):
                out[token.name] = .typed(token.kind, light: token.light, dark: token.dark)
            case let .rawCss(raw):
                out[raw.name] = .rawCss(light: raw.light, dark: raw.dark, cssProperty: raw.property)
            case .utilities:
                continue
            }
        }
        return out
    }

    private static func makeVarMap(
        themeVariables: [TailwindThemeTokenVar],
        cssVariables: [TailwindRawCssVar]
    ) -> [String: TailwindVar] {
        var out: [String: TailwindVar] = [:]
        for token in themeVariables {
            out[token.name] = .typed(token.kind, light: token.light, dark: token.dark)
        }
        for raw in cssVariables {
            out[raw.name] = .rawCss(light: raw.light, dark: raw.dark, cssProperty: raw.property)
        }
        return out
    }

    private static func split(entries: [TailwindVariableEntry]) -> (
        themeVariables: [TailwindThemeTokenVar],
        cssVariables: [TailwindRawCssVar],
        utilities: [String: String]
    ) {
        var themes: [TailwindThemeTokenVar] = []
        var css: [TailwindRawCssVar] = []
        var utils: [String: String] = [:]

        for entry in entries {
            switch entry {
            case let .themeToken(token):
                themes.append(token)
            case let .rawCss(raw):
                css.append(raw)
            case let .utilities(aliases):
                utils.merge(aliases) { _, new in new }
            }
        }
        return (themes, css, utils)
    }
}

enum TailwindRuntime {
    static func colorVariable(_ name: String, colorScheme: ColorScheme = .light) -> Color? {
        Tailwind.shared.colorVariable(name, colorScheme: colorScheme)
    }

    static func rawVariable(_ name: String, colorScheme: ColorScheme = .light) -> String? {
        Tailwind.shared.rawVariable(name, colorScheme: colorScheme)
    }

    static func expandUtilityAliases(_ tokens: [String]) -> [String] {
        Tailwind.shared.expandUtilityAliases(tokens)
    }
}

private final class Tailwind: @unchecked Sendable {
    static let shared = Tailwind()

    private let lock = NSLock()
    private var didSeedDefaultTheme = false
    private var colors: [String: Color] = [:]
    private var darkColors: [String: Color] = [:]
    private var varDefinitions: [String: TailwindVar] = [:]
    private var lazyDefaultVarDefinitions: [String: TailwindVar] = [:]
    private var utilities: [String: String] = [:]

    func configure(
        varDefinitions newVarDefinitions: [String: TailwindVar],
        utilities newUtilities: [String: String],
        strict: Bool
    ) throws {
        lock.lock()
        defer { lock.unlock() }

        for (key, definition) in newVarDefinitions {
            for normalized in normalizedNames(for: key) {
                if varDefinitions[normalized] != nil {
                    TailwindLogger.warn("Tailwind var '\(normalized)' is being redefined. Last write wins.")
                }
                varDefinitions[normalized] = definition
                lazyDefaultVarDefinitions.removeValue(forKey: normalized)
            }
        }

        for (key, utility) in newUtilities {
            utilities[key] = utility
        }

        let issues = validationIssuesLocked()
        if strict, let first = issues.first {
            switch first {
            case let .unresolvedReference(variable, reference):
                throw TailwindInitializationError.unresolvedReference(variable: variable, reference: reference)
            case let .circularReference(path):
                throw TailwindInitializationError.circularReference(path: path)
            case .invalidThemeTokenName, .invalidCssPropertyName:
                // Non-fatal by design: we keep parity with Tailwind behavior by
                // treating non-conforming names as plain CSS variables.
                break
            }
        }

        for issue in issues {
            switch issue {
            case let .unresolvedReference(variable, reference):
                TailwindLogger.warn(
                    "Tailwind var '\(variable)' references '\(reference)', but it could not be resolved."
                )
            case let .circularReference(path):
                TailwindLogger.warn(
                    "Tailwind var cycle detected: \(path.joined(separator: " -> "))."
                )
            case let .invalidThemeTokenName(variable, kind, expectedPrefixes):
                TailwindLogger.warn(
                    TailwindValidationMessages.invalidThemeTokenVariableName(
                        variable: variable,
                        kind: kind,
                        expectedPrefixes: expectedPrefixes
                    )
                )
            case let .invalidCssPropertyName(variable, property):
                TailwindLogger.warn(
                    TailwindValidationMessages.invalidCSSPropertyName(
                        variable: variable,
                        property: property
                    )
                )
            }
        }
    }

    /// Stores defaults lazily. They are materialized into active runtime vars
    /// only when actually referenced by classes at runtime.
    func configureLazyDefaultVarDefinitions(_ defaults: [String: TailwindVar]) {
        lock.lock()
        defer { lock.unlock() }
        didSeedDefaultTheme = true

        for (key, definition) in defaults {
            for normalized in normalizedNames(for: key) {
                if varDefinitions[normalized] == nil {
                    lazyDefaultVarDefinitions[normalized] = definition
                }
            }
        }
    }

    func configure(
        colors newColors: [String: Color],
        darkColors newDarkColors: [String: Color],
        utilities newUtilities: [String: String]
    ) {
        lock.lock()
        defer { lock.unlock() }

        for (key, color) in newColors {
            for name in normalizedNames(for: key) {
                colors[name] = color
            }
        }

        for (key, color) in newDarkColors {
            for name in normalizedNames(for: key) {
                darkColors[name] = color
            }
        }

        for (key, utility) in newUtilities {
            utilities[key] = utility
        }
    }

    func reset() {
        lock.lock()
        defer { lock.unlock() }
        didSeedDefaultTheme = false
        colors.removeAll()
        darkColors.removeAll()
        varDefinitions.removeAll()
        lazyDefaultVarDefinitions.removeAll()
        utilities.removeAll()
    }

    func colorVariable(_ rawName: String, colorScheme: ColorScheme) -> Color? {
        lock.lock()
        defer { lock.unlock() }
        ensureDefaultThemeSeededLocked()

        var visited = Set<String>()
        for key in normalizedNames(for: rawName) {
            if colorScheme == .dark, let darkValue = darkColors[key] {
                return darkValue
            }
            if let value = colors[key] {
                return value
            }
            if let resolved = resolveDefinedVariable(
                normalizedName: key,
                colorScheme: colorScheme,
                visited: &visited
            ) {
                return resolved
            }
        }
        return nil
    }

    func rawVariable(_ rawName: String, colorScheme: ColorScheme) -> String? {
        lock.lock()
        defer { lock.unlock() }
        ensureDefaultThemeSeededLocked()

        var visited = Set<String>()
        for key in normalizedNames(for: rawName) {
            if let resolved = resolveDefinedVariableRaw(
                normalizedName: key,
                colorScheme: colorScheme,
                visited: &visited
            ) {
                return resolved
            }
        }
        return nil
    }

    func expandUtilityAliases(_ tokens: [String]) -> [String] {
        lock.lock()
        let utilitiesSnapshot = utilities
        lock.unlock()

        var expanded: [String] = []
        for token in tokens {
            expanded.append(contentsOf: expandToken(token, utilities: utilitiesSnapshot, depth: 0))
        }
        return expanded
    }

    private func expandToken(_ token: String, utilities: [String: String], depth: Int) -> [String] {
        if depth > 8 { return [token] } // protect against alias loops
        guard let alias = utilities[token] else { return [token] }
        let aliasTokens = alias.split(separator: " ").map(String.init)
        var resolved: [String] = []
        for aliasToken in aliasTokens {
            resolved.append(contentsOf: expandToken(aliasToken, utilities: utilities, depth: depth + 1))
        }
        return resolved
    }

    private func ensureDefaultThemeSeededLocked() {
        guard !didSeedDefaultTheme else { return }
        didSeedDefaultTheme = true
        for (key, definition) in TailwindDefaultTheme.makeVariables() {
            for normalized in normalizedNames(for: key) {
                if varDefinitions[normalized] == nil {
                    lazyDefaultVarDefinitions[normalized] = definition
                }
            }
        }
    }

    private func normalizedNames(for raw: String) -> [String] {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let withoutVar = if trimmed.hasPrefix("var(") && trimmed.hasSuffix(")") {
            String(trimmed.dropFirst(4).dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            trimmed
        }

        guard withoutVar.hasPrefix("--") else {
            TailwindLogger.warn(TailwindValidationMessages.varMustStartWithDoubleDash(withoutVar, example: "--brand-bg"))
            return []
        }

        let withoutDashes = String(withoutVar.dropFirst(2))
        let canonical = camelToKebab(withoutDashes).lowercased()
        let full = "--" + canonical

        return [
            canonical,
            full
        ]
    }

    private func camelToKebab(_ value: String) -> String {
        guard !value.isEmpty else { return value }
        var out = ""
        for char in value {
            if char.isUppercase {
                out.append("-")
                out.append(char.lowercased())
            } else {
                out.append(char)
            }
        }
        return out
    }

    private func resolveDefinedVariable(
        normalizedName: String,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> Color? {
        guard !visited.contains(normalizedName) else { return nil }
        materializeLazyVarIfNeeded(normalizedName)
        guard let definition = varDefinitions[normalizedName] else { return nil }

        visited.insert(normalizedName)
        defer { visited.remove(normalizedName) }

        if colorScheme == .dark, let darkExpr = definition.dark,
           let resolvedDark = resolveExpression(darkExpr, colorScheme: colorScheme, visited: &visited) {
            return resolvedDark
        }

        return resolveExpression(definition.light, colorScheme: colorScheme, visited: &visited)
    }

    private func resolveExpression(
        _ expression: TailwindVarExpression,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> Color? {
        switch expression {
        case let .color(color):
            return color
        case let .token(token):
            return resolveToken(token, colorScheme: colorScheme, visited: &visited)
        case let .typedToken(type, value):
            return resolveTypedToken(type: type, value: value, colorScheme: colorScheme, visited: &visited)
        case let .rawCss(value, property):
            return resolveRawCss(value: value, property: property, colorScheme: colorScheme, visited: &visited)
        case let .reference(name):
            return resolveReference(name, colorScheme: colorScheme, visited: &visited)
        }
    }

    private func resolveTypedToken(
        type: TailwindThemeTokenKind,
        value: String,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> Color? {
        switch type {
        case .color:
            return resolveToken(value, colorScheme: colorScheme, visited: &visited)
        default:
            return nil
        }
    }

    private func resolveRawCss(
        value: String,
        property: TailwindRawCssProperty,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> Color? {
        guard property.supportsColorResolution else { return nil }
        return resolveToken(value, colorScheme: colorScheme, visited: &visited)
    }

    private func resolveDefinedVariableRaw(
        normalizedName: String,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> String? {
        guard !visited.contains(normalizedName) else { return nil }
        materializeLazyVarIfNeeded(normalizedName)
        guard let definition = varDefinitions[normalizedName] else { return nil }

        visited.insert(normalizedName)
        defer { visited.remove(normalizedName) }

        if colorScheme == .dark, let darkExpr = definition.dark,
           let resolvedDark = resolveExpressionRaw(darkExpr, colorScheme: colorScheme, visited: &visited) {
            return resolvedDark
        }

        return resolveExpressionRaw(definition.light, colorScheme: colorScheme, visited: &visited)
    }

    private func resolveExpressionRaw(
        _ expression: TailwindVarExpression,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> String? {
        switch expression {
        case .color:
            return nil
        case let .token(token):
            return resolveTokenRaw(token, colorScheme: colorScheme, visited: &visited)
        case let .typedToken(_, value):
            return resolveTokenRaw(value, colorScheme: colorScheme, visited: &visited)
        case let .rawCss(value, _):
            return resolveTokenRaw(value, colorScheme: colorScheme, visited: &visited) ?? value
        case let .reference(name):
            return resolveReferenceRaw(name, colorScheme: colorScheme, visited: &visited)
        }
    }

    private func resolveTokenRaw(
        _ raw: String,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if let explicitVar = parseVarFunction(trimmed) {
            return resolveReferenceRaw(explicitVar, colorScheme: colorScheme, visited: &visited)
        }
        if trimmed.hasPrefix("--"),
           let ref = resolveReferenceRaw(trimmed, colorScheme: colorScheme, visited: &visited) {
            return ref
        }
        return trimmed.isEmpty ? nil : trimmed
    }

    private func resolveReferenceRaw(
        _ rawName: String,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> String? {
        for key in normalizedNames(for: rawName) {
            if let resolved = resolveDefinedVariableRaw(normalizedName: key, colorScheme: colorScheme, visited: &visited) {
                return resolved
            }
            if colorScheme == .dark, darkColors[key] != nil {
                return nil
            }
            if colors[key] != nil {
                return nil
            }
        }
        return nil
    }

    private func resolveToken(
        _ raw: String,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> Color? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        if let explicitVar = parseVarFunction(trimmed) {
            return resolveReference(explicitVar, colorScheme: colorScheme, visited: &visited)
        }

        if trimmed.hasPrefix("--"),
           let ref = resolveReference(trimmed, colorScheme: colorScheme, visited: &visited) {
            return ref
        }

        if let builtin = parseTailwindColorVariableName(trimmed),
           let builtinColor = TailwindColorResolver.parseRuntimeColorValue(builtin) {
            return builtinColor
        }

        return TailwindColorResolver.parseRuntimeColorValue(trimmed)
    }

    private func resolveReference(
        _ rawName: String,
        colorScheme: ColorScheme,
        visited: inout Set<String>
    ) -> Color? {
        for key in normalizedNames(for: rawName) {
            if colorScheme == .dark, let darkValue = darkColors[key] {
                return darkValue
            }
            if let value = colors[key] {
                return value
            }
            if let resolved = resolveDefinedVariable(normalizedName: key, colorScheme: colorScheme, visited: &visited) {
                return resolved
            }
        }

        if let builtin = parseTailwindColorVariableName(rawName),
           let builtinColor = TailwindColorResolver.parseRuntimeColorValue(builtin) {
            return builtinColor
        }

        return nil
    }

    private func parsedReferenceCandidate(from expression: TailwindVarExpression) -> String? {
        switch expression {
        case .color:
            return nil
        case let .reference(name):
            return name
        case let .token(token):
            return referenceCandidate(fromRawValue: token)
        case let .typedToken(type, value):
            if type != .color { return nil }
            return referenceCandidate(fromRawValue: value)
        case let .rawCss(value, property):
            if !property.supportsColorResolution { return nil }
            return referenceCandidate(fromRawValue: value)
        }
    }

    private func referenceCandidate(fromRawValue raw: String) -> String? {
        if let inside = parseVarFunction(raw) {
            return inside
        }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("--"), parseTailwindColorVariableName(trimmed) == nil {
            return trimmed
        }
        return nil
    }

    private func canResolveReferenceLocked(_ rawName: String) -> Bool {
        for key in normalizedNames(for: rawName) {
            if varDefinitions[key] != nil || lazyDefaultVarDefinitions[key] != nil || colors[key] != nil || darkColors[key] != nil {
                return true
            }
        }

        if parseTailwindColorVariableName(rawName) != nil {
            return true
        }
        return false
    }

    private func firstDefinitionKey(for rawName: String) -> String? {
        for key in normalizedNames(for: rawName) {
            if varDefinitions[key] != nil || lazyDefaultVarDefinitions[key] != nil {
                return key
            }
        }
        return nil
    }

    private func materializeLazyVarIfNeeded(_ normalizedName: String) {
        guard varDefinitions[normalizedName] == nil,
              let definition = lazyDefaultVarDefinitions.removeValue(forKey: normalizedName)
        else { return }

        varDefinitions[normalizedName] = definition
    }

    private func detectCycleLocked() -> [String]? {
        var graph: [String: [String]] = [:]
        for (name, definition) in varDefinitions {
            var edges: [String] = []

            if let ref = parsedReferenceCandidate(from: definition.light),
               let target = firstDefinitionKey(for: ref) {
                edges.append(target)
            }
            if let dark = definition.dark,
               let ref = parsedReferenceCandidate(from: dark),
               let target = firstDefinitionKey(for: ref) {
                edges.append(target)
            }
            graph[name] = Array(Set(edges))
        }

        var visited = Set<String>()
        var stack = Set<String>()
        var path: [String] = []

        func dfs(_ node: String) -> [String]? {
            visited.insert(node)
            stack.insert(node)
            path.append(node)

            for next in graph[node] ?? [] {
                if !visited.contains(next) {
                    if let cycle = dfs(next) { return cycle }
                } else if stack.contains(next) {
                    if let idx = path.firstIndex(of: next) {
                        return Array(path[idx...]) + [next]
                    }
                    return [next, next]
                }
            }

            stack.remove(node)
            _ = path.popLast()
            return nil
        }

        for node in graph.keys where !visited.contains(node) {
            if let cycle = dfs(node) {
                return cycle
            }
        }
        return nil
    }

    private enum ValidationIssue {
        case unresolvedReference(variable: String, reference: String)
        case circularReference(path: [String])
        case invalidThemeTokenName(variable: String, kind: String, expectedPrefixes: [String])
        case invalidCssPropertyName(variable: String, property: String)
    }

    private func validationIssuesLocked() -> [ValidationIssue] {
        var issues: [ValidationIssue] = []
        var seenUnresolved = Set<String>()
        var seenInvalidThemeName = Set<String>()
        var seenInvalidCssProperty = Set<String>()

        for (name, definition) in varDefinitions {
            if let invalidThemeName = invalidThemeTokenNameIssue(variable: name, definition: definition) {
                let key = "\(name)|\(invalidThemeName.kind)"
                if !seenInvalidThemeName.contains(key) {
                    issues.append(.invalidThemeTokenName(
                        variable: name,
                        kind: invalidThemeName.kind,
                        expectedPrefixes: invalidThemeName.expectedPrefixes
                    ))
                    seenInvalidThemeName.insert(key)
                }
            }

            if let invalidCssProperty = invalidCssPropertyNameIssue(variable: name, definition: definition) {
                let key = "\(name)|\(invalidCssProperty)"
                if !seenInvalidCssProperty.contains(key) {
                    issues.append(.invalidCssPropertyName(variable: name, property: invalidCssProperty))
                    seenInvalidCssProperty.insert(key)
                }
            }

            if let ref = parsedReferenceCandidate(from: definition.light),
               !canResolveReferenceLocked(ref) {
                let key = "\(name)|\(ref)"
                if !seenUnresolved.contains(key) {
                    issues.append(.unresolvedReference(variable: name, reference: ref))
                    seenUnresolved.insert(key)
                }
            }

            if let dark = definition.dark,
               let ref = parsedReferenceCandidate(from: dark),
               !canResolveReferenceLocked(ref) {
                let key = "\(name)|\(ref)"
                if !seenUnresolved.contains(key) {
                    issues.append(.unresolvedReference(variable: name, reference: ref))
                    seenUnresolved.insert(key)
                }
            }
        }

        if let cycle = detectCycleLocked() {
            issues.append(.circularReference(path: cycle))
        }
        return issues
    }

    private func invalidThemeTokenNameIssue(
        variable name: String,
        definition: TailwindVar
    ) -> (kind: String, expectedPrefixes: [String])? {
        if let kind = explicitThemeTokenKind(in: definition),
           let issue = TailwindVariableValidation.invalidThemeTokenName(
               name,
               forThemeKindRawValue: kind.rawValue
           ) {
            return (kind.rawValue, issue.expectedPrefixes)
        }

        if definitionContainsColorValue(definition),
           let issue = TailwindVariableValidation.invalidThemeTokenName(
               name,
               forThemeKindRawValue: TailwindThemeTokenKind.color.rawValue
           ) {
            return (TailwindThemeTokenKind.color.rawValue, issue.expectedPrefixes)
        }

        return nil
    }

    private func explicitThemeTokenKind(in definition: TailwindVar) -> TailwindThemeTokenKind? {
        switch definition.light {
        case let .typedToken(type, _):
            return type
        default:
            break
        }

        if let dark = definition.dark {
            switch dark {
            case let .typedToken(type, _):
                return type
            default:
                break
            }
        }

        return nil
    }

    private func invalidCssPropertyNameIssue(
        variable name: String,
        definition: TailwindVar
    ) -> String? {
        guard let propertyName = rawCssPropertyName(in: definition) else { return nil }
        return TailwindVariableValidation.isValidCSSPropertyName(propertyName) ? nil : propertyName
    }

    private func rawCssPropertyName(in definition: TailwindVar) -> String? {
        switch definition.light {
        case let .rawCss(_, property):
            return property.cssName
        default:
            break
        }

        if let dark = definition.dark {
            switch dark {
            case let .rawCss(_, property):
                return property.cssName
            default:
                break
            }
        }

        return nil
    }

    private func definitionContainsColorValue(_ definition: TailwindVar) -> Bool {
        expressionCanResolveColor(definition.light) || definition.dark.map(expressionCanResolveColor) == true
    }

    private func expressionCanResolveColor(_ expression: TailwindVarExpression) -> Bool {
        switch expression {
        case .color:
            return true
        case let .typedToken(type, _):
            return type == .color
        case let .rawCss(_, property):
            return property.supportsColorResolution
        case let .token(value):
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if parseTailwindColorVariableName(trimmed) != nil { return true }
            if let token = parseVarFunction(trimmed) {
                return parseTailwindColorVariableName(token) != nil ||
                    TailwindVariableValidation.isColorThemeVariableToken(token)
            }
            return TailwindColorResolver.parseRuntimeColorValue(trimmed) != nil
        case .reference:
            return false
        }
    }

    private func parseVarFunction(_ raw: String) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("var("), trimmed.hasSuffix(")") else { return nil }
        let token = String(trimmed.dropFirst(4).dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
        guard token.hasPrefix("--") else {
            TailwindLogger.warn(TailwindValidationMessages.varMustStartWithDoubleDash(token, example: "var(--brand-bg)"))
            return nil
        }
        return token
    }

    private func parseTailwindColorVariableName(_ raw: String) -> String? {
        TailwindVariableValidation.themeColorName(from: raw)
    }
}

private enum TailwindVarExpression {
    case color(Color)
    case token(String)
    case typedToken(type: TailwindThemeTokenKind, value: String)
    case rawCss(value: String, property: TailwindRawCssProperty)
    case reference(String)
}
