import Testing
@testable import TailwindSwiftUI

@Suite("Presets: Spacing")
struct SpacingPresetTests {
    @Test func spacingScaleMatchesTailwindPoints() {
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

    @Test func spacingIntegerLiteralMapsToScale() {
        let spacing: TSpacing = 4
        #expect(spacing.value == 16)
    }
}
