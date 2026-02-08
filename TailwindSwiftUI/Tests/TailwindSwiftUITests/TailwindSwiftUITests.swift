import Testing
import SwiftUI
@testable import TailwindSwiftUI

// MARK: - Colors
@Suite("Colors")
struct ColorTests {
    @Test func allPalettesExist() {
        // Verify all 22 palettes have the 500 shade
        let colors: [Color] = [
            .slate500, .gray500, .zinc500, .neutral500, .stone500,
            .red500, .orange500, .amber500, .yellow500, .lime500,
            .green500, .emerald500, .teal500, .cyan500, .sky500,
            .blue500, .indigo500, .violet500, .purple500, .fuchsia500,
            .pink500, .rose500,
        ]
        #expect(colors.count == 22)
    }

    @Test func shadeBoundsExist() {
        // Each palette should have 50 and 950
        #expect(Color.red50 != Color.red950)
        #expect(Color.blue50 != Color.blue950)
        #expect(Color.slate50 != Color.slate950)
    }

    @Test func hexInitializer() {
        let white = Color(hex: 0xFFFFFF)
        let black = Color(hex: 0x000000)
        #expect(white != black)
    }
}

// MARK: - Spacing
@Suite("Spacing")
struct SpacingTests {
    @Test func scaleValues() {
        #expect(TSpacing._0.value == 0)
        #expect(TSpacing._0_5.value == 2)
        #expect(TSpacing._1.value == 4)
        #expect(TSpacing._2.value == 8)
        #expect(TSpacing._4.value == 16)
        #expect(TSpacing._8.value == 32)
        #expect(TSpacing._16.value == 64)
        #expect(TSpacing._64.value == 256)
        #expect(TSpacing._96.value == 384)
    }

    @Test func integerLiteral() {
        let spacing: TSpacing = 4
        #expect(spacing.value == 16)
    }
}

// MARK: - Radius
@Suite("Radius")
struct RadiusTests {
    @Test func allSizes() {
        #expect(TRadius.none.value == 0)
        #expect(TRadius.sm.value == 2)
        #expect(TRadius.base.value == 4)
        #expect(TRadius.md.value == 6)
        #expect(TRadius.lg.value == 8)
        #expect(TRadius.xl.value == 12)
        #expect(TRadius.xl2.value == 16)
        #expect(TRadius.xl3.value == 24)
        #expect(TRadius.full.value == 9999)
    }
}

// MARK: - Shadow
@Suite("Shadow")
struct ShadowTests {
    @Test func allSizes() {
        #expect(TShadow.sm.radius == 1)
        #expect(TShadow.base.radius == 2)
        #expect(TShadow.md.radius == 4)
        #expect(TShadow.lg.radius == 8)
        #expect(TShadow.xl.radius == 12)
        #expect(TShadow.xl2.radius == 24)
    }
}

// MARK: - Validation
@Suite("Validation")
struct ValidationTests {
    @Test func layoutOnTextIsError() {
        let result = TailwindValidation.validate("flex-row", viewType: .text)
        #expect(result != nil)
        #expect(result?.level == .error)
    }

    @Test func layoutOnImageIsError() {
        let result = TailwindValidation.validate("justify-center", viewType: .image)
        #expect(result != nil)
        #expect(result?.level == .error)
    }

    @Test func textClassOnImageIsWarning() {
        let result = TailwindValidation.validate("tracking-wide", viewType: .image)
        #expect(result != nil)
        #expect(result?.level == .warning)
    }

    @Test func fontOnContainerIsAllowed() {
        // font-* propagates via environment, so no warning
        let result = TailwindValidation.validate("font-bold", viewType: .container)
        #expect(result == nil)
    }

    @Test func textClassOnContainerWarns() {
        let result = TailwindValidation.validate("tracking-wide", viewType: .container)
        #expect(result != nil)
        #expect(result?.level == .warning)
    }

    @Test func universalClassOnTextIsNil() {
        let result = TailwindValidation.validate("p-4", viewType: .text)
        #expect(result == nil)
    }

    @Test func universalClassOnContainerIsNil() {
        let result = TailwindValidation.validate("bg-red-500", viewType: .container)
        #expect(result == nil)
    }

    @Test func imageClassOnTextWarns() {
        let result = TailwindValidation.validate("object-cover", viewType: .text)
        #expect(result != nil)
        #expect(result?.level == .warning)
    }

    @Test func layoutClassesListCoverage() {
        let layoutClasses = ["flex-row", "flex-col", "gap-4", "justify-between",
                             "items-center", "grid-cols-3", "space-x-4", "divide-y",
                             "columns-2", "order-1", "grow", "shrink-0"]
        for cls in layoutClasses {
            let result = TailwindValidation.validate(cls, viewType: .text)
            #expect(result?.level == .error, "Expected error for '\(cls)' on Text")
        }
    }
}

// MARK: - View Type Detection
@Suite("View Type Detection")
struct ViewTypeDetectionTests {
    @Test func detectsText() {
        let type = TWViewType(from: Text.self)
        #expect(type == .text)
    }

    @Test func detectsImage() {
        let type = TWViewType(from: Image.self)
        #expect(type == .image)
    }

    @Test func detectsVStack() {
        let type = TWViewType(from: VStack<EmptyView>.self)
        #expect(type == .container)
    }

    @Test func detectsHStack() {
        let type = TWViewType(from: HStack<EmptyView>.self)
        #expect(type == .container)
    }
}

// MARK: - Parser Helpers
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

    @Test func parseBracketColor() {
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
        #expect(modifier.parseColor(from: "bg-notacolor-500", prefix: "bg-") == nil)
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

    @Test func allColorPalettesResolvable() {
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

    @Test func stylesMethodWorks() {
        let view = Text("Hello").styles("text-xl font-bold bg-red-500")
        _ = view
    }

    @Test func twWithAllCategories() {
        // Spacing
        let v1 = Text("").tw("p-4 px-2 py-3 pt-1 pr-2 pb-3 pl-4 m-2 mx-auto")
        _ = v1

        // Typography
        let v2 = Text("").tw("text-xl font-bold italic uppercase tracking-wide leading-relaxed truncate line-clamp-2")
        _ = v2

        // Sizing
        let v3 = Text("").tw("w-full h-16 min-w-0 max-w-lg aspect-square")
        _ = v3

        // Layout
        let v4 = VStack {}.tw("hidden visible overflow-hidden z-10")
        _ = v4

        // Border
        let v5 = Text("").tw("rounded-lg border border-red-500 shadow-md ring-2")
        _ = v5

        // Effects
        let v6 = Text("").tw("opacity-75 blur-sm grayscale invert brightness-110 contrast-125")
        _ = v6

        // Transforms
        let v7 = Text("").tw("scale-95 rotate-45 translate-x-4 -translate-y-2")
        _ = v7

        // Interactivity
        let v8 = Text("").tw("pointer-events-none select-none")
        _ = v8

        // Accessibility
        let v9 = Text("").tw("sr-only")
        _ = v9
    }
}
