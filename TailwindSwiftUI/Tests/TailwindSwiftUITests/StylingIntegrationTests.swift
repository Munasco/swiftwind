import Testing
import SwiftUI
#if canImport(AppKit)
import AppKit
#endif
@testable import TailwindSwiftUI

// MARK: - Blend Modes & Filters
@Suite("Blend Modes & Filters")
@MainActor
struct BlendModeFilterTests {
    @Test func allBlendModes() {
        let modes = ["mix-blend-normal", "mix-blend-multiply", "mix-blend-screen", "mix-blend-overlay",
                     "mix-blend-darken", "mix-blend-lighten", "mix-blend-color-dodge", "mix-blend-color-burn",
                     "mix-blend-hard-light", "mix-blend-soft-light", "mix-blend-difference", "mix-blend-exclusion",
                     "mix-blend-hue", "mix-blend-saturation", "mix-blend-color", "mix-blend-luminosity",
                     "mix-blend-plus-lighter"]
        for mode in modes {
            _ = Text("").tw(mode)
        }
    }

    @Test func allBlurSizes() {
        for cls in ["blur-none", "blur-sm", "blur", "blur-md", "blur-lg", "blur-xl", "blur-2xl", "blur-3xl"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func allShadowSizes() {
        for cls in ["shadow-sm", "shadow", "shadow-md", "shadow-lg", "shadow-xl", "shadow-2xl", "shadow-none", "shadow-inner"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func dropShadows() {
        for cls in ["drop-shadow-none", "drop-shadow-sm", "drop-shadow", "drop-shadow-md",
                     "drop-shadow-lg", "drop-shadow-xl", "drop-shadow-2xl"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func brightnessContrast() {
        for cls in ["brightness-75", "brightness-90", "brightness-110", "brightness-125",
                     "contrast-75", "contrast-90", "contrast-110", "contrast-125"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func hueRotation() {
        for cls in ["hue-rotate-15", "hue-rotate-30", "hue-rotate-60", "hue-rotate-90",
                     "-hue-rotate-15", "-hue-rotate-30", "-hue-rotate-60"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func saturationValues() {
        for cls in ["saturate-0", "saturate-50", "saturate-100", "saturate-150", "saturate-200"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func grayscaleInvertSepia() {
        for cls in ["grayscale", "grayscale-0", "invert", "invert-0", "sepia", "sepia-0"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func opacityLevels() {
        for cls in ["opacity-0", "opacity-5", "opacity-10", "opacity-25", "opacity-50",
                     "opacity-75", "opacity-90", "opacity-95", "opacity-100"] {
            _ = Text("").tw(cls)
        }
    }
}

// MARK: - Typography Extended
@Suite("Typography Extended")
@MainActor
struct TypographyExtendedTests {
    @Test func allFontWeights() {
        for cls in ["font-thin", "font-extralight", "font-light", "font-normal",
                     "font-medium", "font-semibold", "font-bold", "font-extrabold", "font-black"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func allTextSizes() {
        for cls in ["text-xs", "text-sm", "text-base", "text-lg", "text-xl",
                     "text-2xl", "text-3xl", "text-4xl", "text-5xl", "text-6xl",
                     "text-7xl", "text-8xl", "text-9xl"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func allTrackingValues() {
        for cls in ["tracking-tighter", "tracking-tight", "tracking-normal",
                     "tracking-wide", "tracking-wider", "tracking-widest"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func allLeadingValues() {
        for cls in ["leading-none", "leading-tight", "leading-snug",
                     "leading-normal", "leading-relaxed", "leading-loose"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func allTextTransforms() {
        for cls in ["uppercase", "lowercase", "capitalize", "normal-case"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func fontVariantNumeric() {
        for cls in ["normal-nums", "ordinal", "slashed-zero", "lining-nums", "oldstyle-nums",
                     "proportional-nums", "tabular-nums", "diagonal-fractions", "stacked-fractions"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func antialiasing() {
        _ = Text("").tw("antialiased")
        _ = Text("").tw("subpixel-antialiased")
    }

    @Test func lineClampValues() {
        for cls in ["line-clamp-1", "line-clamp-2", "line-clamp-3", "line-clamp-4", "line-clamp-6", "line-clamp-none"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func textIndent() {
        _ = Text("").tw("indent-4")
        _ = Text("").tw("indent-8")
        _ = Text("").tw("-indent-4")
    }

    @Test func verticalAlign() {
        for cls in ["align-baseline", "align-top", "align-middle", "align-bottom",
                     "align-text-top", "align-text-bottom", "align-sub", "align-super"] {
            _ = Text("").tw(cls)
        }
    }
}

// MARK: - Transforms Extended
@Suite("Transforms Extended")
@MainActor
struct TransformExtendedTests {
    @Test func skewTransforms() {
        for cls in ["skew-x-3", "skew-x-6", "skew-x-12", "skew-y-3", "skew-y-6", "skew-y-12",
                     "-skew-x-3", "-skew-x-6", "-skew-y-3", "-skew-y-6"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func transformOrigin() {
        for cls in ["origin-center", "origin-top", "origin-top-right", "origin-right",
                     "origin-bottom-right", "origin-bottom", "origin-bottom-left", "origin-left", "origin-top-left"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func negativeTransforms() {
        _ = Text("").tw("-rotate-45 -translate-x-4 -translate-y-8")
    }

    @Test func scaleVariants() {
        for cls in ["scale-50", "scale-75", "scale-90", "scale-95", "scale-100", "scale-105", "scale-110", "scale-125", "scale-150"] {
            _ = Text("").tw(cls)
        }
    }
}

// MARK: - Integration: .tw() on Views
@Suite("Integration")
@MainActor
struct IntegrationTests {
    @Test func twOnTextDoesNotCrash() {
        let view = Text("Hello").tw("text-xl font-bold text-blue-600 p-4 bg-white rounded-lg shadow-md")
        _ = view
    }

    @Test func twOnVStackDoesNotCrash() {
        let view = VStack {}.tw("p-8 bg-slate-100 rounded-2xl shadow-xl border border-gray-200")
        _ = view
    }

    @Test func twWithEmptyStringDoesNotCrash() {
        let view = Text("Hello").tw("")
        _ = view
    }

    @Test func twWithUnknownClassDoesNotCrash() {
        let view = Text("Hello").tw("not-a-real-class another-fake")
        _ = view
    }

    @Test func twWithBracketValuesDoesNotCrash() {
        let view = Text("Hello").tw("p-[20px] w-[300] bg-[#1da1f2] text-[22px] rounded-[12]")
        _ = view
    }

    @Test func twWithManyClassesDoesNotCrash() {
        let view = Text("Test").tw("text-sm font-semibold text-white bg-blue-600 px-4 py-2 rounded-md shadow-md opacity-90 border border-blue-700")
        _ = view
    }

    @Test func twWithSlashOpacityColorsDoesNotCrash() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeVariables([
            "--color-brand": .color(light: .blue500, dark: .red500),
        ])
        defer { TailwindSwiftUI.reset() }

        _ = Text("Badge").tw("bg-neutral-900/60 text-white border border-cyan-500/40 px-3 py-1 rounded-md")
        _ = Text("Icon").tw("bg-red-500/20 border-red-500/40 px-2 py-2 rounded-full")
        _ = Text("Subtle").tw("bg-white/5 border border-amber-500/40")
        _ = Text("Hex").tw("bg-[#1d4ed8]/30 border-[#ef4444]/40 text-[#22c55e]/70")
        _ = Text("Var").tw("bg-[--color-brand]/25 border-[var(--color-brand)]/55")
    }

    @Test func stylesMethodWorks() {
        let view = Text("Hello").styles("text-xl font-bold bg-red-500")
        _ = view
    }

    @Test func twWithAllCategories() {
        _ = Text("").tw("p-4 px-2 py-3 pt-1 pr-2 pb-3 pl-4 m-2 mx-auto")
        _ = Text("").tw("text-xl font-bold italic uppercase tracking-wide leading-relaxed truncate line-clamp-2")
        _ = Text("").tw("w-full h-16 min-w-0 max-w-lg aspect-square")
        _ = VStack {}.tw("hidden visible overflow-hidden z-10")
        _ = Text("").tw("rounded-lg border border-red-500 shadow-md ring-2")
        _ = Text("").tw("opacity-75 blur-sm grayscale invert brightness-110 contrast-125")
        _ = Text("").tw("scale-95 rotate-45 translate-x-4 -translate-y-2")
        _ = Text("").tw("pointer-events-none select-none")
        _ = Text("").tw("sr-only")
    }
}
