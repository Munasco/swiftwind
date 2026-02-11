import Foundation

// Tailwind v4 default theme token seed used by TailwindSwiftUI.initializeDefaultThemeVariables().
enum TailwindDefaultTheme {
    static func makeVariables() -> [String: TailwindVar] {
        var out: [String: TailwindVar] = [:]

        // Font families
        out["--font-sans"] = .font(light: "ui-sans-serif, system-ui, sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\"")
        out["--font-serif"] = .font(light: "ui-serif, Georgia, Cambria, \"Times New Roman\", Times, serif")
        out["--font-mono"] = .font(light: "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, \"Liberation Mono\", \"Courier New\", monospace")

        // Color tokens mirror Tailwind palette tokens.
        let palettes = [
            "red", "orange", "amber", "yellow", "lime", "green", "emerald", "teal", "cyan", "sky", "blue", "indigo",
            "violet", "purple", "fuchsia", "pink", "rose", "slate", "gray", "zinc", "neutral", "stone"
        ]
        let shades = ["50", "100", "200", "300", "400", "500", "600", "700", "800", "900", "950"]
        for palette in palettes {
            for shade in shades {
                out["--color-\(palette)-\(shade)"] = .color(light: "\(palette)-\(shade)")
            }
        }
        out["--color-black"] = .color(light: "black")
        out["--color-white"] = .color(light: "white")
        // Common semantic tokens (non-core Tailwind defaults, useful app aliases).
        out["--color-muted"] = .color(light: "slate-100", dark: "slate-800")
        out["--color-muted-foreground"] = .color(light: "slate-600", dark: "slate-300")

        // Spacing scale base and responsive breakpoints.
        out["--spacing"] = .spacing(light: "0.25rem")
        out["--breakpoint-sm"] = .breakpoint(light: "40rem")
        out["--breakpoint-md"] = .breakpoint(light: "48rem")
        out["--breakpoint-lg"] = .breakpoint(light: "64rem")
        out["--breakpoint-xl"] = .breakpoint(light: "80rem")
        out["--breakpoint-2xl"] = .breakpoint(light: "96rem")

        let containers: [String: String] = [
            "3xs": "16rem", "2xs": "18rem", "xs": "20rem", "sm": "24rem", "md": "28rem", "lg": "32rem", "xl": "36rem",
            "2xl": "42rem", "3xl": "48rem", "4xl": "56rem", "5xl": "64rem", "6xl": "72rem", "7xl": "80rem"
        ]
        for (name, value) in containers {
            out["--container-\(name)"] = .container(light: value)
        }

        // Typography tokens
        let textSizes: [String: (String, String)] = [
            "xs": ("0.75rem", "calc(1 / 0.75)"),
            "sm": ("0.875rem", "calc(1.25 / 0.875)"),
            "base": ("1rem", "calc(1.5 / 1)"),
            "lg": ("1.125rem", "calc(1.75 / 1.125)"),
            "xl": ("1.25rem", "calc(1.75 / 1.25)"),
            "2xl": ("1.5rem", "calc(2 / 1.5)"),
            "3xl": ("1.875rem", "calc(2.25 / 1.875)"),
            "4xl": ("2.25rem", "calc(2.5 / 2.25)"),
            "5xl": ("3rem", "1"),
            "6xl": ("3.75rem", "1"),
            "7xl": ("4.5rem", "1"),
            "8xl": ("6rem", "1"),
            "9xl": ("8rem", "1")
        ]
        for (name, value) in textSizes {
            out["--text-\(name)"] = .text(light: value.0)
            out["--text-\(name)--line-height"] = .rawCss(light: value.1, cssProperty: "line-height")
        }

        let fontWeights: [String: String] = [
            "thin": "100", "extralight": "200", "light": "300", "normal": "400", "medium": "500", "semibold": "600",
            "bold": "700", "extrabold": "800", "black": "900"
        ]
        for (name, value) in fontWeights {
            out["--font-weight-\(name)"] = .fontWeight(light: value)
        }

        let tracking: [String: String] = [
            "tighter": "-0.05em", "tight": "-0.025em", "normal": "0em", "wide": "0.025em", "wider": "0.05em", "widest": "0.1em"
        ]
        for (name, value) in tracking {
            out["--tracking-\(name)"] = .tracking(light: value)
        }

        let leading: [String: String] = [
            "tight": "1.25", "snug": "1.375", "normal": "1.5", "relaxed": "1.625", "loose": "2"
        ]
        for (name, value) in leading {
            out["--leading-\(name)"] = .leading(light: value)
        }

        let radii: [String: String] = [
            "xs": "0.125rem", "sm": "0.25rem", "md": "0.375rem", "lg": "0.5rem", "xl": "0.75rem", "2xl": "1rem", "3xl": "1.5rem", "4xl": "2rem"
        ]
        for (name, value) in radii {
            out["--radius-\(name)"] = .radius(light: value)
        }

        // Shadows
        let shadows: [String: String] = [
            "2xs": "0 1px rgb(0 0 0 / 0.05)",
            "xs": "0 1px 2px 0 rgb(0 0 0 / 0.05)",
            "sm": "0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)",
            "md": "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)",
            "lg": "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)",
            "xl": "0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)",
            "2xl": "0 25px 50px -12px rgb(0 0 0 / 0.25)"
        ]
        for (name, value) in shadows {
            out["--shadow-\(name)"] = .shadow(light: value)
        }

        let insetShadows: [String: String] = [
            "2xs": "inset 0 1px rgb(0 0 0 / 0.05)",
            "xs": "inset 0 1px 1px rgb(0 0 0 / 0.05)",
            "sm": "inset 0 2px 4px rgb(0 0 0 / 0.05)"
        ]
        for (name, value) in insetShadows {
            out["--inset-shadow-\(name)"] = .insetShadow(light: value)
        }

        let dropShadows: [String: String] = [
            "xs": "0 1px 1px rgb(0 0 0 / 0.05)",
            "sm": "0 1px 2px rgb(0 0 0 / 0.15)",
            "md": "0 3px 3px rgb(0 0 0 / 0.12)",
            "lg": "0 4px 4px rgb(0 0 0 / 0.15)",
            "xl": "0 9px 7px rgb(0 0 0 / 0.1)",
            "2xl": "0 25px 25px rgb(0 0 0 / 0.15)"
        ]
        for (name, value) in dropShadows {
            out["--drop-shadow-\(name)"] = .dropShadow(light: value)
        }

        let textShadows: [String: String] = [
            "2xs": "0px 1px 0px rgb(0 0 0 / 0.15)",
            "xs": "0px 1px 1px rgb(0 0 0 / 0.2)",
            "sm": "0px 1px 0px rgb(0 0 0 / 0.075), 0px 1px 1px rgb(0 0 0 / 0.075), 0px 2px 2px rgb(0 0 0 / 0.075)",
            "md": "0px 1px 1px rgb(0 0 0 / 0.1), 0px 1px 2px rgb(0 0 0 / 0.1), 0px 2px 4px rgb(0 0 0 / 0.1)",
            "lg": "0px 1px 2px rgb(0 0 0 / 0.1), 0px 3px 2px rgb(0 0 0 / 0.1), 0px 4px 8px rgb(0 0 0 / 0.1)"
        ]
        for (name, value) in textShadows {
            out["--text-shadow-\(name)"] = .textShadow(light: value)
        }

        let blurs: [String: String] = [
            "xs": "4px", "sm": "8px", "md": "12px", "lg": "16px", "xl": "24px", "2xl": "40px", "3xl": "64px"
        ]
        for (name, value) in blurs {
            out["--blur-\(name)"] = .blur(light: value)
        }

        let perspectives: [String: String] = [
            "dramatic": "100px", "near": "300px", "normal": "500px", "midrange": "800px", "distant": "1200px"
        ]
        for (name, value) in perspectives {
            out["--perspective-\(name)"] = .perspective(light: value)
        }

        out["--aspect-video"] = .aspect(light: "16 / 9")

        let easings: [String: String] = [
            "in": "cubic-bezier(0.4, 0, 1, 1)",
            "out": "cubic-bezier(0, 0, 0.2, 1)",
            "in-out": "cubic-bezier(0.4, 0, 0.2, 1)"
        ]
        for (name, value) in easings {
            out["--ease-\(name)"] = .ease(light: value)
        }

        let animations: [String: String] = [
            "spin": "spin 1s linear infinite",
            "ping": "ping 1s cubic-bezier(0, 0, 0.2, 1) infinite",
            "pulse": "pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite",
            "bounce": "bounce 1s infinite"
        ]
        for (name, value) in animations {
            out["--animate-\(name)"] = .animate(light: value)
        }

        return out
    }
}
