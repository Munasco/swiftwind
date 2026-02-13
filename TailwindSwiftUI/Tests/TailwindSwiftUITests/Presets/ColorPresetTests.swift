import Testing
import SwiftUI
@testable import TailwindSwiftUI

@Suite("Presets: Colors")
struct ColorPresetTests {
    @Test func allPrimaryPalettesExpose500() {
        let colors: [Color] = [
            .slate500, .gray500, .zinc500, .neutral500, .stone500,
            .red500, .orange500, .amber500, .yellow500, .lime500,
            .green500, .emerald500, .teal500, .cyan500, .sky500,
            .blue500, .indigo500, .violet500, .purple500, .fuchsia500,
            .pink500, .rose500,
        ]
        #expect(colors.count == 22)
    }

    @Test func shadeRangeHasDistinctValues() {
        #expect(Color.red50 != Color.red950)
        #expect(Color.blue50 != Color.blue950)
        #expect(Color.slate50 != Color.slate950)
    }

    @Test func hexAccessorsRoundTrip() {
        let blue = Color(hex: 0x2B7FFF)
        #expect(blue.hex == "#2B7FFF")
        #expect(blue.hexStringWithAlpha == "#2B7FFFFF")
    }
}
