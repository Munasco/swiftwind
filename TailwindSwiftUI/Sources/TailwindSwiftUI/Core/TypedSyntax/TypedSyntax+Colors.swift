import Foundation

public struct TailwindColorToken: RawRepresentable, Hashable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }

    public static func custom(_ value: String) -> TailwindColorToken {
        TailwindColorToken(value)
    }

    /// Produces arbitrary color syntax: `[#RRGGBB]` or `[#RRGGBBAA]`.
    public static func hex(_ value: String) -> TailwindColorToken {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalized = trimmed.hasPrefix("#") ? trimmed : "#\(trimmed)"
        return TailwindColorToken("[\(normalized)]")
    }

    /// Produces arbitrary color syntax: `[var(--token-name)]`.
    public static func cssVar(_ value: String) -> TailwindColorToken {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("var(") {
            return TailwindColorToken("[\(trimmed)]")
        }
        if trimmed.hasPrefix("--") {
            return TailwindColorToken("[var(\(trimmed))]")
        }
        return TailwindColorToken("[var(--\(trimmed))]")
    }

    /// Produces arbitrary color syntax: `[oklch(...)]`.
    public static func oklch(_ value: String) -> TailwindColorToken {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalized = trimmed.replacingOccurrences(of: " ", with: "_")
        return TailwindColorToken("[\(normalized)]")
    }

    /// Produces arbitrary color syntax from numeric OKLCH components.
    /// Example: `.oklch(0.16, 0.23, 23)` -> `[oklch(0.16_0.23_23)]`
    public static func oklch(
        _ lightness: Double,
        _ chroma: Double,
        _ hue: Double,
        opacity: Double? = nil
    ) -> TailwindColorToken {
        let l = numberToken(lightness)
        let c = numberToken(chroma)
        let h = numberToken(hue)
        if let opacity {
            let a = numberToken(opacity)
            return oklch("oklch(\(l) \(c) \(h) / \(a))")
        }
        return oklch("oklch(\(l) \(c) \(h))")
    }

    private static func numberToken(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }
        return String(value)
    }
}

public extension TailwindTypedClass {
    static func bg(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("bg-\(color.rawValue)")
    }

    static func text(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("text-\(color.rawValue)")
    }

    static func border(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("border-\(color.rawValue)")
    }

    static func ring(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("ring-\(color.rawValue)")
    }

    static func fill(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("fill-\(color.rawValue)")
    }

    static func stroke(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("stroke-\(color.rawValue)")
    }

    static func accent(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("accent-\(color.rawValue)")
    }

    static func caret(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("caret-\(color.rawValue)")
    }

    static func decoration(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("decoration-\(color.rawValue)")
    }

    static func placeholder(_ color: TailwindColorToken) -> TailwindTypedClass {
        TailwindTypedClass("placeholder-\(color.rawValue)")
    }
}

public extension TailwindColorToken {
    static let black = TailwindColorToken("black")
    static let white = TailwindColorToken("white")
    static let transparent = TailwindColorToken("transparent")
    static let current = TailwindColorToken("current")
    static let inherit = TailwindColorToken("inherit")
}

public extension TailwindColorToken {
    static let red50 = TailwindColorToken("red-50")
    static let red100 = TailwindColorToken("red-100")
    static let red200 = TailwindColorToken("red-200")
    static let red300 = TailwindColorToken("red-300")
    static let red400 = TailwindColorToken("red-400")
    static let red500 = TailwindColorToken("red-500")
    static let red600 = TailwindColorToken("red-600")
    static let red700 = TailwindColorToken("red-700")
    static let red800 = TailwindColorToken("red-800")
    static let red900 = TailwindColorToken("red-900")
    static let red950 = TailwindColorToken("red-950")
    static let blue50 = TailwindColorToken("blue-50")
    static let blue100 = TailwindColorToken("blue-100")
    static let blue200 = TailwindColorToken("blue-200")
    static let blue300 = TailwindColorToken("blue-300")
    static let blue400 = TailwindColorToken("blue-400")
    static let blue500 = TailwindColorToken("blue-500")
    static let blue600 = TailwindColorToken("blue-600")
    static let blue700 = TailwindColorToken("blue-700")
    static let blue800 = TailwindColorToken("blue-800")
    static let blue900 = TailwindColorToken("blue-900")
    static let blue950 = TailwindColorToken("blue-950")
    static let green50 = TailwindColorToken("green-50")
    static let green100 = TailwindColorToken("green-100")
    static let green200 = TailwindColorToken("green-200")
    static let green300 = TailwindColorToken("green-300")
    static let green400 = TailwindColorToken("green-400")
    static let green500 = TailwindColorToken("green-500")
    static let green600 = TailwindColorToken("green-600")
    static let green700 = TailwindColorToken("green-700")
    static let green800 = TailwindColorToken("green-800")
    static let green900 = TailwindColorToken("green-900")
    static let green950 = TailwindColorToken("green-950")
    static let slate50 = TailwindColorToken("slate-50")
    static let slate100 = TailwindColorToken("slate-100")
    static let slate200 = TailwindColorToken("slate-200")
    static let slate300 = TailwindColorToken("slate-300")
    static let slate400 = TailwindColorToken("slate-400")
    static let slate500 = TailwindColorToken("slate-500")
    static let slate600 = TailwindColorToken("slate-600")
    static let slate700 = TailwindColorToken("slate-700")
    static let slate800 = TailwindColorToken("slate-800")
    static let slate900 = TailwindColorToken("slate-900")
    static let slate950 = TailwindColorToken("slate-950")
    static let gray50 = TailwindColorToken("gray-50")
    static let gray100 = TailwindColorToken("gray-100")
    static let gray200 = TailwindColorToken("gray-200")
    static let gray300 = TailwindColorToken("gray-300")
    static let gray400 = TailwindColorToken("gray-400")
    static let gray500 = TailwindColorToken("gray-500")
    static let gray600 = TailwindColorToken("gray-600")
    static let gray700 = TailwindColorToken("gray-700")
    static let gray800 = TailwindColorToken("gray-800")
    static let gray900 = TailwindColorToken("gray-900")
    static let gray950 = TailwindColorToken("gray-950")
    static let zinc50 = TailwindColorToken("zinc-50")
    static let zinc100 = TailwindColorToken("zinc-100")
    static let zinc200 = TailwindColorToken("zinc-200")
    static let zinc300 = TailwindColorToken("zinc-300")
    static let zinc400 = TailwindColorToken("zinc-400")
    static let zinc500 = TailwindColorToken("zinc-500")
    static let zinc600 = TailwindColorToken("zinc-600")
    static let zinc700 = TailwindColorToken("zinc-700")
    static let zinc800 = TailwindColorToken("zinc-800")
    static let zinc900 = TailwindColorToken("zinc-900")
    static let zinc950 = TailwindColorToken("zinc-950")
    static let neutral50 = TailwindColorToken("neutral-50")
    static let neutral100 = TailwindColorToken("neutral-100")
    static let neutral200 = TailwindColorToken("neutral-200")
    static let neutral300 = TailwindColorToken("neutral-300")
    static let neutral400 = TailwindColorToken("neutral-400")
    static let neutral500 = TailwindColorToken("neutral-500")
    static let neutral600 = TailwindColorToken("neutral-600")
    static let neutral700 = TailwindColorToken("neutral-700")
    static let neutral800 = TailwindColorToken("neutral-800")
    static let neutral900 = TailwindColorToken("neutral-900")
    static let neutral950 = TailwindColorToken("neutral-950")
    static let stone50 = TailwindColorToken("stone-50")
    static let stone100 = TailwindColorToken("stone-100")
    static let stone200 = TailwindColorToken("stone-200")
    static let stone300 = TailwindColorToken("stone-300")
    static let stone400 = TailwindColorToken("stone-400")
    static let stone500 = TailwindColorToken("stone-500")
    static let stone600 = TailwindColorToken("stone-600")
    static let stone700 = TailwindColorToken("stone-700")
    static let stone800 = TailwindColorToken("stone-800")
    static let stone900 = TailwindColorToken("stone-900")
    static let stone950 = TailwindColorToken("stone-950")
    static let orange50 = TailwindColorToken("orange-50")
    static let orange100 = TailwindColorToken("orange-100")
    static let orange200 = TailwindColorToken("orange-200")
    static let orange300 = TailwindColorToken("orange-300")
    static let orange400 = TailwindColorToken("orange-400")
    static let orange500 = TailwindColorToken("orange-500")
    static let orange600 = TailwindColorToken("orange-600")
    static let orange700 = TailwindColorToken("orange-700")
    static let orange800 = TailwindColorToken("orange-800")
    static let orange900 = TailwindColorToken("orange-900")
    static let orange950 = TailwindColorToken("orange-950")
    static let amber50 = TailwindColorToken("amber-50")
    static let amber100 = TailwindColorToken("amber-100")
    static let amber200 = TailwindColorToken("amber-200")
    static let amber300 = TailwindColorToken("amber-300")
    static let amber400 = TailwindColorToken("amber-400")
    static let amber500 = TailwindColorToken("amber-500")
    static let amber600 = TailwindColorToken("amber-600")
    static let amber700 = TailwindColorToken("amber-700")
    static let amber800 = TailwindColorToken("amber-800")
    static let amber900 = TailwindColorToken("amber-900")
    static let amber950 = TailwindColorToken("amber-950")
    static let yellow50 = TailwindColorToken("yellow-50")
    static let yellow100 = TailwindColorToken("yellow-100")
    static let yellow200 = TailwindColorToken("yellow-200")
    static let yellow300 = TailwindColorToken("yellow-300")
    static let yellow400 = TailwindColorToken("yellow-400")
    static let yellow500 = TailwindColorToken("yellow-500")
    static let yellow600 = TailwindColorToken("yellow-600")
    static let yellow700 = TailwindColorToken("yellow-700")
    static let yellow800 = TailwindColorToken("yellow-800")
    static let yellow900 = TailwindColorToken("yellow-900")
    static let yellow950 = TailwindColorToken("yellow-950")
    static let lime50 = TailwindColorToken("lime-50")
    static let lime100 = TailwindColorToken("lime-100")
    static let lime200 = TailwindColorToken("lime-200")
    static let lime300 = TailwindColorToken("lime-300")
    static let lime400 = TailwindColorToken("lime-400")
    static let lime500 = TailwindColorToken("lime-500")
    static let lime600 = TailwindColorToken("lime-600")
    static let lime700 = TailwindColorToken("lime-700")
    static let lime800 = TailwindColorToken("lime-800")
    static let lime900 = TailwindColorToken("lime-900")
    static let lime950 = TailwindColorToken("lime-950")
    static let emerald50 = TailwindColorToken("emerald-50")
    static let emerald100 = TailwindColorToken("emerald-100")
    static let emerald200 = TailwindColorToken("emerald-200")
    static let emerald300 = TailwindColorToken("emerald-300")
    static let emerald400 = TailwindColorToken("emerald-400")
    static let emerald500 = TailwindColorToken("emerald-500")
    static let emerald600 = TailwindColorToken("emerald-600")
    static let emerald700 = TailwindColorToken("emerald-700")
    static let emerald800 = TailwindColorToken("emerald-800")
    static let emerald900 = TailwindColorToken("emerald-900")
    static let emerald950 = TailwindColorToken("emerald-950")
    static let teal50 = TailwindColorToken("teal-50")
    static let teal100 = TailwindColorToken("teal-100")
    static let teal200 = TailwindColorToken("teal-200")
    static let teal300 = TailwindColorToken("teal-300")
    static let teal400 = TailwindColorToken("teal-400")
    static let teal500 = TailwindColorToken("teal-500")
    static let teal600 = TailwindColorToken("teal-600")
    static let teal700 = TailwindColorToken("teal-700")
    static let teal800 = TailwindColorToken("teal-800")
    static let teal900 = TailwindColorToken("teal-900")
    static let teal950 = TailwindColorToken("teal-950")
    static let cyan50 = TailwindColorToken("cyan-50")
    static let cyan100 = TailwindColorToken("cyan-100")
    static let cyan200 = TailwindColorToken("cyan-200")
    static let cyan300 = TailwindColorToken("cyan-300")
    static let cyan400 = TailwindColorToken("cyan-400")
    static let cyan500 = TailwindColorToken("cyan-500")
    static let cyan600 = TailwindColorToken("cyan-600")
    static let cyan700 = TailwindColorToken("cyan-700")
    static let cyan800 = TailwindColorToken("cyan-800")
    static let cyan900 = TailwindColorToken("cyan-900")
    static let cyan950 = TailwindColorToken("cyan-950")
    static let sky50 = TailwindColorToken("sky-50")
    static let sky100 = TailwindColorToken("sky-100")
    static let sky200 = TailwindColorToken("sky-200")
    static let sky300 = TailwindColorToken("sky-300")
    static let sky400 = TailwindColorToken("sky-400")
    static let sky500 = TailwindColorToken("sky-500")
    static let sky600 = TailwindColorToken("sky-600")
    static let sky700 = TailwindColorToken("sky-700")
    static let sky800 = TailwindColorToken("sky-800")
    static let sky900 = TailwindColorToken("sky-900")
    static let sky950 = TailwindColorToken("sky-950")
    static let indigo50 = TailwindColorToken("indigo-50")
    static let indigo100 = TailwindColorToken("indigo-100")
    static let indigo200 = TailwindColorToken("indigo-200")
    static let indigo300 = TailwindColorToken("indigo-300")
    static let indigo400 = TailwindColorToken("indigo-400")
    static let indigo500 = TailwindColorToken("indigo-500")
    static let indigo600 = TailwindColorToken("indigo-600")
    static let indigo700 = TailwindColorToken("indigo-700")
    static let indigo800 = TailwindColorToken("indigo-800")
    static let indigo900 = TailwindColorToken("indigo-900")
    static let indigo950 = TailwindColorToken("indigo-950")
    static let violet50 = TailwindColorToken("violet-50")
    static let violet100 = TailwindColorToken("violet-100")
    static let violet200 = TailwindColorToken("violet-200")
    static let violet300 = TailwindColorToken("violet-300")
    static let violet400 = TailwindColorToken("violet-400")
    static let violet500 = TailwindColorToken("violet-500")
    static let violet600 = TailwindColorToken("violet-600")
    static let violet700 = TailwindColorToken("violet-700")
    static let violet800 = TailwindColorToken("violet-800")
    static let violet900 = TailwindColorToken("violet-900")
    static let violet950 = TailwindColorToken("violet-950")
    static let purple50 = TailwindColorToken("purple-50")
    static let purple100 = TailwindColorToken("purple-100")
    static let purple200 = TailwindColorToken("purple-200")
    static let purple300 = TailwindColorToken("purple-300")
    static let purple400 = TailwindColorToken("purple-400")
    static let purple500 = TailwindColorToken("purple-500")
    static let purple600 = TailwindColorToken("purple-600")
    static let purple700 = TailwindColorToken("purple-700")
    static let purple800 = TailwindColorToken("purple-800")
    static let purple900 = TailwindColorToken("purple-900")
    static let purple950 = TailwindColorToken("purple-950")
    static let fuchsia50 = TailwindColorToken("fuchsia-50")
    static let fuchsia100 = TailwindColorToken("fuchsia-100")
    static let fuchsia200 = TailwindColorToken("fuchsia-200")
    static let fuchsia300 = TailwindColorToken("fuchsia-300")
    static let fuchsia400 = TailwindColorToken("fuchsia-400")
    static let fuchsia500 = TailwindColorToken("fuchsia-500")
    static let fuchsia600 = TailwindColorToken("fuchsia-600")
    static let fuchsia700 = TailwindColorToken("fuchsia-700")
    static let fuchsia800 = TailwindColorToken("fuchsia-800")
    static let fuchsia900 = TailwindColorToken("fuchsia-900")
    static let fuchsia950 = TailwindColorToken("fuchsia-950")
    static let pink50 = TailwindColorToken("pink-50")
    static let pink100 = TailwindColorToken("pink-100")
    static let pink200 = TailwindColorToken("pink-200")
    static let pink300 = TailwindColorToken("pink-300")
    static let pink400 = TailwindColorToken("pink-400")
    static let pink500 = TailwindColorToken("pink-500")
    static let pink600 = TailwindColorToken("pink-600")
    static let pink700 = TailwindColorToken("pink-700")
    static let pink800 = TailwindColorToken("pink-800")
    static let pink900 = TailwindColorToken("pink-900")
    static let pink950 = TailwindColorToken("pink-950")
    static let rose50 = TailwindColorToken("rose-50")
    static let rose100 = TailwindColorToken("rose-100")
    static let rose200 = TailwindColorToken("rose-200")
    static let rose300 = TailwindColorToken("rose-300")
    static let rose400 = TailwindColorToken("rose-400")
    static let rose500 = TailwindColorToken("rose-500")
    static let rose600 = TailwindColorToken("rose-600")
    static let rose700 = TailwindColorToken("rose-700")
    static let rose800 = TailwindColorToken("rose-800")
    static let rose900 = TailwindColorToken("rose-900")
    static let rose950 = TailwindColorToken("rose-950")
}
