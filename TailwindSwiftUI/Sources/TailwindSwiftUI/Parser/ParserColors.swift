import SwiftUI

// MARK: - Colors: bg-*, text-* colors, shadow colors
extension TailwindModifier {

    func applyColorClass(_ className: String, to view: AnyView) -> AnyView? {
        // Background colors: bg-{color}-{shade}
        if className.hasPrefix("bg-") && !className.hasPrefix("bg-opacity-") && !className.hasPrefix("bg-gradient-") && !className.hasPrefix("bg-clip-") && !className.hasPrefix("bg-origin-") && !className.hasPrefix("bg-no-repeat") && !className.hasPrefix("bg-repeat") && !className.hasPrefix("bg-cover") && !className.hasPrefix("bg-contain") && !className.hasPrefix("bg-center") && !className.hasPrefix("bg-fixed") && !className.hasPrefix("bg-local") && !className.hasPrefix("bg-scroll") && !className.hasPrefix("bg-none") {
            if let color = parseColor(from: className, prefix: "bg-") {
                return AnyView(view.background(color))
            }
            return nil
        }

        // Background opacity
        if className.hasPrefix("bg-opacity-") {
            // Handled via color alpha - pass through
            return AnyView(view)
        }

        // Text colors: text-{color}-{shade} (must not match text sizes or alignment)
        if className.hasPrefix("text-") {
            // Check if it's a text size first
            if parseTextSize(from: className) != nil { return nil }
            // Check if it's text alignment
            if className == "text-left" || className == "text-center" || className == "text-right" || className == "text-justify" { return nil }
            // Check if it's text decoration/transform
            if className == "text-wrap" || className == "text-nowrap" || className == "text-balance" || className == "text-pretty" || className == "text-clip" || className == "text-ellipsis" { return nil }

            if let color = parseColor(from: className, prefix: "text-") {
                return AnyView(view.foregroundColor(color))
            }
            return nil
        }

        // Shadow with color: shadow-{color}-{shade}
        if className.hasPrefix("shadow-") {
            // Check named shadows first
            if parseShadow(from: className) != nil { return nil }
            // Try color shadow
            if let color = parseColor(from: className, prefix: "shadow-") {
                return AnyView(view.shadow(color: color, radius: 4, y: 2))
            }
            return nil
        }

        // Placeholder color (text fields)
        if className.hasPrefix("placeholder-") {
            return AnyView(view)
        }

        // Decoration color
        if className.hasPrefix("decoration-") {
            return AnyView(view)
        }

        // Accent color
        if className.hasPrefix("accent-") {
            if let color = parseColor(from: className, prefix: "accent-") {
                return AnyView(view.tint(color))
            }
            return nil
        }

        // Caret color
        if className.hasPrefix("caret-") {
            if let color = parseColor(from: className, prefix: "caret-") {
                return AnyView(view.tint(color))
            }
            return nil
        }

        return nil
    }

    // MARK: - Color Lookup Table
    func getColorByName(_ name: String, shade: String) -> Color? {
        switch "\(name)\(shade)" {
        case "red50": return .red50
        case "red100": return .red100
        case "red200": return .red200
        case "red300": return .red300
        case "red400": return .red400
        case "red500": return .red500
        case "red600": return .red600
        case "red700": return .red700
        case "red800": return .red800
        case "red900": return .red900
        case "red950": return .red950
        case "blue50": return .blue50
        case "blue100": return .blue100
        case "blue200": return .blue200
        case "blue300": return .blue300
        case "blue400": return .blue400
        case "blue500": return .blue500
        case "blue600": return .blue600
        case "blue700": return .blue700
        case "blue800": return .blue800
        case "blue900": return .blue900
        case "blue950": return .blue950
        case "green50": return .green50
        case "green100": return .green100
        case "green200": return .green200
        case "green300": return .green300
        case "green400": return .green400
        case "green500": return .green500
        case "green600": return .green600
        case "green700": return .green700
        case "green800": return .green800
        case "green900": return .green900
        case "green950": return .green950
        case "slate50": return .slate50
        case "slate100": return .slate100
        case "slate200": return .slate200
        case "slate300": return .slate300
        case "slate400": return .slate400
        case "slate500": return .slate500
        case "slate600": return .slate600
        case "slate700": return .slate700
        case "slate800": return .slate800
        case "slate900": return .slate900
        case "slate950": return .slate950
        case "gray50": return .gray50
        case "gray100": return .gray100
        case "gray200": return .gray200
        case "gray300": return .gray300
        case "gray400": return .gray400
        case "gray500": return .gray500
        case "gray600": return .gray600
        case "gray700": return .gray700
        case "gray800": return .gray800
        case "gray900": return .gray900
        case "gray950": return .gray950
        case "zinc50": return .zinc50
        case "zinc100": return .zinc100
        case "zinc200": return .zinc200
        case "zinc300": return .zinc300
        case "zinc400": return .zinc400
        case "zinc500": return .zinc500
        case "zinc600": return .zinc600
        case "zinc700": return .zinc700
        case "zinc800": return .zinc800
        case "zinc900": return .zinc900
        case "zinc950": return .zinc950
        case "neutral50": return .neutral50
        case "neutral100": return .neutral100
        case "neutral200": return .neutral200
        case "neutral300": return .neutral300
        case "neutral400": return .neutral400
        case "neutral500": return .neutral500
        case "neutral600": return .neutral600
        case "neutral700": return .neutral700
        case "neutral800": return .neutral800
        case "neutral900": return .neutral900
        case "neutral950": return .neutral950
        case "stone50": return .stone50
        case "stone100": return .stone100
        case "stone200": return .stone200
        case "stone300": return .stone300
        case "stone400": return .stone400
        case "stone500": return .stone500
        case "stone600": return .stone600
        case "stone700": return .stone700
        case "stone800": return .stone800
        case "stone900": return .stone900
        case "stone950": return .stone950
        case "orange50": return .orange50
        case "orange100": return .orange100
        case "orange200": return .orange200
        case "orange300": return .orange300
        case "orange400": return .orange400
        case "orange500": return .orange500
        case "orange600": return .orange600
        case "orange700": return .orange700
        case "orange800": return .orange800
        case "orange900": return .orange900
        case "orange950": return .orange950
        case "amber50": return .amber50
        case "amber100": return .amber100
        case "amber200": return .amber200
        case "amber300": return .amber300
        case "amber400": return .amber400
        case "amber500": return .amber500
        case "amber600": return .amber600
        case "amber700": return .amber700
        case "amber800": return .amber800
        case "amber900": return .amber900
        case "amber950": return .amber950
        case "yellow50": return .yellow50
        case "yellow100": return .yellow100
        case "yellow200": return .yellow200
        case "yellow300": return .yellow300
        case "yellow400": return .yellow400
        case "yellow500": return .yellow500
        case "yellow600": return .yellow600
        case "yellow700": return .yellow700
        case "yellow800": return .yellow800
        case "yellow900": return .yellow900
        case "yellow950": return .yellow950
        case "lime50": return .lime50
        case "lime100": return .lime100
        case "lime200": return .lime200
        case "lime300": return .lime300
        case "lime400": return .lime400
        case "lime500": return .lime500
        case "lime600": return .lime600
        case "lime700": return .lime700
        case "lime800": return .lime800
        case "lime900": return .lime900
        case "lime950": return .lime950
        case "emerald50": return .emerald50
        case "emerald100": return .emerald100
        case "emerald200": return .emerald200
        case "emerald300": return .emerald300
        case "emerald400": return .emerald400
        case "emerald500": return .emerald500
        case "emerald600": return .emerald600
        case "emerald700": return .emerald700
        case "emerald800": return .emerald800
        case "emerald900": return .emerald900
        case "emerald950": return .emerald950
        case "teal50": return .teal50
        case "teal100": return .teal100
        case "teal200": return .teal200
        case "teal300": return .teal300
        case "teal400": return .teal400
        case "teal500": return .teal500
        case "teal600": return .teal600
        case "teal700": return .teal700
        case "teal800": return .teal800
        case "teal900": return .teal900
        case "teal950": return .teal950
        case "cyan50": return .cyan50
        case "cyan100": return .cyan100
        case "cyan200": return .cyan200
        case "cyan300": return .cyan300
        case "cyan400": return .cyan400
        case "cyan500": return .cyan500
        case "cyan600": return .cyan600
        case "cyan700": return .cyan700
        case "cyan800": return .cyan800
        case "cyan900": return .cyan900
        case "cyan950": return .cyan950
        case "sky50": return .sky50
        case "sky100": return .sky100
        case "sky200": return .sky200
        case "sky300": return .sky300
        case "sky400": return .sky400
        case "sky500": return .sky500
        case "sky600": return .sky600
        case "sky700": return .sky700
        case "sky800": return .sky800
        case "sky900": return .sky900
        case "sky950": return .sky950
        case "indigo50": return .indigo50
        case "indigo100": return .indigo100
        case "indigo200": return .indigo200
        case "indigo300": return .indigo300
        case "indigo400": return .indigo400
        case "indigo500": return .indigo500
        case "indigo600": return .indigo600
        case "indigo700": return .indigo700
        case "indigo800": return .indigo800
        case "indigo900": return .indigo900
        case "indigo950": return .indigo950
        case "violet50": return .violet50
        case "violet100": return .violet100
        case "violet200": return .violet200
        case "violet300": return .violet300
        case "violet400": return .violet400
        case "violet500": return .violet500
        case "violet600": return .violet600
        case "violet700": return .violet700
        case "violet800": return .violet800
        case "violet900": return .violet900
        case "violet950": return .violet950
        case "purple50": return .purple50
        case "purple100": return .purple100
        case "purple200": return .purple200
        case "purple300": return .purple300
        case "purple400": return .purple400
        case "purple500": return .purple500
        case "purple600": return .purple600
        case "purple700": return .purple700
        case "purple800": return .purple800
        case "purple900": return .purple900
        case "purple950": return .purple950
        case "fuchsia50": return .fuchsia50
        case "fuchsia100": return .fuchsia100
        case "fuchsia200": return .fuchsia200
        case "fuchsia300": return .fuchsia300
        case "fuchsia400": return .fuchsia400
        case "fuchsia500": return .fuchsia500
        case "fuchsia600": return .fuchsia600
        case "fuchsia700": return .fuchsia700
        case "fuchsia800": return .fuchsia800
        case "fuchsia900": return .fuchsia900
        case "fuchsia950": return .fuchsia950
        case "pink50": return .pink50
        case "pink100": return .pink100
        case "pink200": return .pink200
        case "pink300": return .pink300
        case "pink400": return .pink400
        case "pink500": return .pink500
        case "pink600": return .pink600
        case "pink700": return .pink700
        case "pink800": return .pink800
        case "pink900": return .pink900
        case "pink950": return .pink950
        case "rose50": return .rose50
        case "rose100": return .rose100
        case "rose200": return .rose200
        case "rose300": return .rose300
        case "rose400": return .rose400
        case "rose500": return .rose500
        case "rose600": return .rose600
        case "rose700": return .rose700
        case "rose800": return .rose800
        case "rose900": return .rose900
        case "rose950": return .rose950
        default: return nil
        }
    }
}
