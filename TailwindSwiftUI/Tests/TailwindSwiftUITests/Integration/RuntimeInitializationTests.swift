import Testing
import SwiftUI
@testable import TailwindSwiftUI

@Suite("Integration: Runtime Initialization")
struct RuntimeInitializationTests {
    @Test func initializesThemeAndCssVariables() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(
            themeVariables: [
                TailwindThemeTokenVar("--color-brand", kind: .color, light: "blue-500", dark: "red-500"),
            ],
            cssVariables: [
                TailwindRawCssVar("--sidebar-width", property: "width", light: "320px"),
            ],
            utilities: [
                "btn-primary": "px-4 py-2 bg-brand text-white",
            ]
        )
    }

    @Test func acceptsNonNamespacedThemeTokenAsPlainCssVariable() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(
            themeVariables: [
                TailwindThemeTokenVar("--brand", kind: .color, light: "blue-500"),
            ]
        )

        #expect(TailwindRuntime.rawVariable("--brand") == "blue-500")
        #expect(TailwindRuntime.colorVariable("--brand") != nil)
    }
}
