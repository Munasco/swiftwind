public enum TailwindValidationMessages {
    public static func unknownClass(_ className: String) -> String {
        "Unknown Tailwind class '\(className)'"
    }

    public static func conflictingStyles(previous: String, current: String, scope: String) -> String {
        "Conflicting styles '\(previous)' and '\(current)' in the same \(scope)."
    }

    public static func duplicateStyle(_ className: String, scope: String) -> String {
        "Duplicate style '\(className)' in the same \(scope)."
    }

    public static var conflictingStylesAcrossChainedScopes: String {
        "Conflicting styles detected across chained .tw() scopes. Merge into one .tw { ... } block or remove conflicting classes."
    }

    public static func unsupportedVariant(_ variant: String) -> String {
        "Unsupported Tailwind variant '\(variant):'"
    }

    public static func invalidColorVariableUsage(className: String, variable: String) -> String {
        "Class '\(className)' uses '\(variable)'. Color vars must be named '--color-*' (or '--tw-color-*')."
    }

    public static func varMustStartWithDoubleDash(_ variable: String, example: String) -> String {
        "Tailwind var '\(variable)' must start with '--'. Example: \(example)"
    }

    public static func nonNamespacedColorVariable(_ variable: String) -> String {
        "Color var '\(variable)' is not namespaced as '--color-*' (or '--tw-color-*'). It will be treated as a plain CSS variable (use var()/()/[] forms), not a theme color token."
    }

    public static func invalidThemeTokenVariableName(
        variable: String,
        kind: String,
        expectedPrefixes: [String]
    ) -> String {
        let expected = expectedPrefixes.joined(separator: ", ")
        return "Theme token '\(variable)' for kind '\(kind)' should use \(expected). It will be treated as a plain CSS variable."
    }

    public static func invalidCSSPropertyName(variable: String, property: String) -> String {
        "CSS variable '\(variable)' has invalid cssProperty '\(property)'. Use a valid CSS property name like 'width', 'background-color', or '--custom-prop'."
    }

    public static var swiftLintSetupHint: String {
        "SwiftLint detected. Run \"swift package plugin tailwind-swiftui-setup-lint --allow-writing-to-package-directory\" in the same folder as your .swiftlint.yml file to add Tailwind style validations."
    }
}
