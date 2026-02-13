import Testing
import SwiftUI
@testable import TailwindSwiftUI

@Suite("Typed Syntax")
@MainActor
struct TailwindTypedSyntaxUnitTests {
    @Test func variadicTypedTwCompiles() {
        _ = Text("Welcome back")
            .tw(.text_2xl, .font_bold, .text_white)

        _ = Text("Build UI faster")
            .tw(.text_sm, .text_zinc_300)

        _ = Button("Continue") {}
            .tw(.px_4, .py_2, .rounded_full, .bg_zinc_100, .text_zinc_900, .shadow_xl)

        _ = VStack(alignment: .leading, spacing: 12) {
            Text("A")
            Text("B")
        }
        .tw(.items_start, .gap_3, .px_5, .py_5, .bg_zinc_800, .rounded_xl)
    }

    @Test func typedTwSupportsVariantCombinators() {
        _ = Text("Responsive")
            .tw(.w_1_2.md, .text_white.dark, .bg_zinc_800.hover)
    }

    @Test func typedTwArrayOverloadCompiles() {
        let typed: [TailwindTypedClass] = [.text_sm, .font_bold, .text_white]
        _ = Text("Array")
            .tw(typed)
    }

    @Test func typedColorBuildersGenerateExpectedTokens() {
        let modifier = Text("Token colors")
            .tw(
                .bg(.zinc800),
                .text(.white),
                .border(.zinc300),
                .fill(.hex("#1da1f2")),
                .stroke(.cssVar("--color-brand")),
                .bg(.oklch("oklch(0.65 0.17 26.3)")),
                .bg(.oklch(0.16, 23, 23)),
                .text(.oklch(0.72, 0.18, 253, opacity: 0.9))
            )

        #expect(modifier.rawClasses.contains("bg-zinc-800"))
        #expect(modifier.rawClasses.contains("text-white"))
        #expect(modifier.rawClasses.contains("border-zinc-300"))
        #expect(modifier.rawClasses.contains("fill-[#1da1f2]"))
        #expect(modifier.rawClasses.contains("stroke-[var(--color-brand)]"))
        #expect(modifier.rawClasses.contains("bg-[oklch(0.65_0.17_26.3)]"))
        #expect(modifier.rawClasses.contains("bg-[oklch(0.16_23_23)]"))
        #expect(modifier.rawClasses.contains("text-[oklch(0.72_0.18_253_/_0.9)]"))
    }
}
