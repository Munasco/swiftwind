import Testing
import SwiftUI
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
@testable import TailwindSwiftUI

// MARK: - Parser Helpers
@MainActor
@Suite("Parser Helpers")
struct ParserHelperTests {
    // Create a dummy modifier to access helpers
    private var modifier: TailwindModifier<EmptyView> {
        TailwindModifier(classes: "", content: EmptyView())
    }

    @Test func extractNumber() {
        #expect(modifier.extractNumber(from: "p-4", prefix: "p-") == 4)
        #expect(modifier.extractNumber(from: "p-0.5", prefix: "p-") == 0.5)
        #expect(modifier.extractNumber(from: "p-16", prefix: "p-") == 16)
        #expect(modifier.extractNumber(from: "p-abc", prefix: "p-") == nil)
    }

    @Test func spacingScale() {
        #expect(modifier.spacingValue(1) == 4)
        #expect(modifier.spacingValue(4) == 16)
        #expect(modifier.spacingValue(0) == 0)
        #expect(modifier.spacingValue(0.5) == 2)
    }

    @Test func extractBracketValue() {
        #expect(modifier.extractBracketValue(from: "p-[20]", prefix: "p-") == 20)
        #expect(modifier.extractBracketValue(from: "w-[300px]", prefix: "w-") == 300)
        #expect(modifier.extractBracketValue(from: "text-[1.5rem]", prefix: "text-") == 24)
        #expect(modifier.extractBracketValue(from: "p-bad", prefix: "p-") == nil)
    }

    @Test func extractBracketValueFromRuntimeVariable() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeVariables([
            "--sidebar-width": .spacing(light: "20rem"),
        ])
        defer { TailwindSwiftUI.reset() }

        #expect(modifier.extractBracketValue(from: "w-[--sidebar-width]", prefix: "w-") == 320)
        #expect(modifier.extractBracketValue(from: "w-[var(--sidebar-width)]", prefix: "w-") == 320)
    }

    @MainActor @Test func parseBracketColor() {
        let color = modifier.parseBracketColor(from: "bg-[#ff0000]", prefix: "bg-")
        #expect(color != nil)

        let noHash = modifier.parseBracketColor(from: "bg-[red]", prefix: "bg-")
        #expect(noHash == nil)
    }

    @Test func parseColorByName() {
        #expect(modifier.parseColor(from: "bg-red-500", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "bg-white", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "bg-black", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "bg-transparent", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "bg-red-500/20", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "bg-white/5", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "border-cyan-500/40", prefix: "border-") != nil)
        #expect(modifier.parseColor(from: "bg-slate-900/[0.60]", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "bg-notacolor-500", prefix: "bg-") == nil)
    }

    @Test func parseBracketColorWithSlashAlpha() {
        #expect(modifier.parseColor(from: "bg-[#1d4ed8]/30", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "text-[#22c55e]/70", prefix: "text-") != nil)
        #expect(modifier.parseColor(from: "border-[#ef4444]/40", prefix: "border-") != nil)
    }

    @Test func parseOKLCHColorValues() {
        #expect(Color.oklch(string: "oklch(62.3% 0.214 259.815)") != nil)
        #expect(Color.oklch(string: "oklch(62.3% 0.214 259.815 / 0.7)") != nil)
        #expect(Color.oklch(string: "oklch(0.623 0.214 259.815 / 70%)") != nil)
        #expect(TailwindColorResolver.parseRuntimeColorValue("oklch(62.3% 0.214 259.815)") != nil)
    }

    @Test func numericColorInitializers() {
        let oklchPositional = Color.oklch(0.62, 0.21, 260, 1.0)
        let oklchLabeled = Color.oklch(l: 0.62, c: 0.21, h: 260, opacity: 1.0)
        let hsl = Color.hsl(h: 210, s: 0.8, l: 0.5, opacity: 1.0)

        #if canImport(AppKit)
        #expect(NSColor(oklchPositional).usingColorSpace(.sRGB) != nil)
        #expect(NSColor(oklchLabeled).usingColorSpace(.sRGB) != nil)
        #expect(NSColor(hsl).usingColorSpace(.sRGB) != nil)
        #elseif canImport(UIKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        #expect(UIColor(oklchPositional).getRed(&r, green: &g, blue: &b, alpha: &a))
        #expect(UIColor(oklchLabeled).getRed(&r, green: &g, blue: &b, alpha: &a))
        #expect(UIColor(hsl).getRed(&r, green: &g, blue: &b, alpha: &a))
        #else
        #expect(Bool(true))
        #endif
    }

    @Test func parseBracketOKLCHColor() {
        #expect(modifier.parseBracketColor(from: "bg-[oklch(62.3%_0.214_259.815)]", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "bg-[oklch(62.3%_0.214_259.815)]/40", prefix: "bg-") != nil)
    }

    @Test func parseVariableBracketColorWithSlashAlpha() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeVariables([
            "--color-brand": .color(light: .blue500, dark: .red500),
        ])
        defer { TailwindSwiftUI.reset() }

        #expect(modifier.parseColor(from: "bg-[var(--color-brand)]/40", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "bg-[--color-brand]/25", prefix: "bg-") != nil)
        #expect(modifier.parseColor(from: "border-[var(--color-brand)]/55", prefix: "border-") != nil)
    }

    @Test func parseTextSize() {
        #expect(modifier.parseTextSize(from: "text-xs") == 12)
        #expect(modifier.parseTextSize(from: "text-base") == 16)
        #expect(modifier.parseTextSize(from: "text-4xl") == 36)
        #expect(modifier.parseTextSize(from: "text-9xl") == 128)
        #expect(modifier.parseTextSize(from: "text-abc") == nil)
    }

    @Test func parseRadius() {
        #expect(modifier.parseRadius(from: "rounded") == 4)
        #expect(modifier.parseRadius(from: "rounded-none") == 0)
        #expect(modifier.parseRadius(from: "rounded-full") == 9999)
        #expect(modifier.parseRadius(from: "rounded-lg") == 8)
        #expect(modifier.parseRadius(from: "rounded-abc") == nil)
    }

    @Test func parseShadow() {
        let sm = modifier.parseShadow(from: "shadow-sm")
        #expect(sm?.radius == 1)
        #expect(sm?.y == 1)

        let xl = modifier.parseShadow(from: "shadow-xl")
        #expect(xl?.radius == 12)
        #expect(xl?.y == 8)

        #expect(modifier.parseShadow(from: "shadow-none")?.radius == 0)
        #expect(modifier.parseShadow(from: "shadow-abc") == nil)
    }

    @Test func parseBlur() {
        #expect(modifier.parseBlur(from: "blur") == 8)
        #expect(modifier.parseBlur(from: "blur-none") == 0)
        #expect(modifier.parseBlur(from: "blur-sm") == 4)
        #expect(modifier.parseBlur(from: "blur-3xl") == 64)
        #expect(modifier.parseBlur(from: "blur-abc") == nil)
    }

    @Test func conflictGroupsDifferentiateBorderWidthAndBorderColor() {
        let widthGroup = TailwindModifier<EmptyView>.conflictGroup(for: "border-2")
        let colorGroup = TailwindModifier<EmptyView>.conflictGroup(for: "border-blue-600")
        #expect(widthGroup != nil)
        #expect(colorGroup != nil)
        #expect(widthGroup != colorGroup)
    }

    @Test func conflictGroupsDifferentiateRingWidthAndRingColor() {
        let widthGroup = TailwindModifier<EmptyView>.conflictGroup(for: "ring-2")
        let colorGroup = TailwindModifier<EmptyView>.conflictGroup(for: "ring-blue-500")
        #expect(widthGroup != nil)
        #expect(colorGroup != nil)
        #expect(widthGroup != colorGroup)
    }

    @Test func conflictGroupsStillCollideForSameBorderDimension() {
        let first = TailwindModifier<EmptyView>.conflictGroup(for: "border-2")
        let second = TailwindModifier<EmptyView>.conflictGroup(for: "border-4")
        #expect(first != nil)
        #expect(first == second)
    }

    @MainActor @Test func allColorPalettesResolvable() {
        let palettes = ["red", "blue", "green", "slate", "gray", "zinc", "neutral",
                        "stone", "orange", "amber", "yellow", "lime", "emerald",
                        "teal", "cyan", "sky", "indigo", "violet", "purple",
                        "fuchsia", "pink", "rose"]
        let shades = ["50", "100", "200", "300", "400", "500", "600", "700", "800", "900", "950"]

        for palette in palettes {
            for shade in shades {
                let color = modifier.getColorByName(palette, shade: shade)
                #expect(color != nil, "Missing \(palette)-\(shade)")
            }
        }
    }
}
