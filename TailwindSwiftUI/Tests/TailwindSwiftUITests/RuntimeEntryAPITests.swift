import Testing
import SwiftUI
@testable import TailwindSwiftUI

@Suite("Runtime Entry API")
@MainActor
struct RuntimeEntryAPITests {
    @Test func defaultColorEntryUsesLightDarkWithoutPlatformBuckets() {
        TailwindSwiftUI.reset()
        defer { TailwindSwiftUI.reset() }

        TailwindSwiftUI.initialize(entries: [
            .color("--color-brand", light: "blue-500", dark: "yellow-500"),
        ])

        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .light) == .blue500)
        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .dark) == .yellow500)
    }

    @Test func platformAwareColorEntryAcceptsTypedDefaultAndOverrides() {
        TailwindSwiftUI.reset()
        defer { TailwindSwiftUI.reset() }

        TailwindSwiftUI.initialize(entries: [
            .color(
                "--color-brand",
                default: .color(light: "blue-500", dark: "yellow-500"),
                iOS: .color(light: "emerald-500", dark: "pink-500"),
                macOS: .color(light: "red-500", dark: "purple-500")
            )
        ])

        #if os(iOS)
        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .light) == .emerald500)
        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .dark) == .pink500)
        #elseif os(macOS)
        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .light) == .red500)
        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .dark) == .purple500)
        #else
        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .light) == .blue500)
        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .dark) == .yellow500)
        #endif
    }

    @Test func platformAwareNonColorThemeTokenEntryWorks() {
        TailwindSwiftUI.reset()
        defer { TailwindSwiftUI.reset() }

        TailwindSwiftUI.initialize(entries: [
            .spacing(
                "--spacing-card",
                default: .token(light: "1rem", dark: "2rem"),
                iOS: .token(light: "2rem", dark: "3rem"),
                macOS: .token(light: "3rem", dark: "4rem")
            ),
        ])

        #if os(iOS)
        #expect(TailwindRuntime.rawVariable("--spacing-card", colorScheme: .light) == "2rem")
        #expect(TailwindRuntime.rawVariable("--spacing-card", colorScheme: .dark) == "3rem")
        #elseif os(macOS)
        #expect(TailwindRuntime.rawVariable("--spacing-card", colorScheme: .light) == "3rem")
        #expect(TailwindRuntime.rawVariable("--spacing-card", colorScheme: .dark) == "4rem")
        #else
        #expect(TailwindRuntime.rawVariable("--spacing-card", colorScheme: .light) == "1rem")
        #expect(TailwindRuntime.rawVariable("--spacing-card", colorScheme: .dark) == "2rem")
        #endif
    }

    @Test func platformAwareCssPropertyEntryWorks() {
        TailwindSwiftUI.reset()
        defer { TailwindSwiftUI.reset() }

        TailwindSwiftUI.initialize(entries: [
            .css(
                "--card-backdrop",
                property: "backdrop-filter",
                default: .css(light: "blur(8px)", dark: "blur(12px)"),
                iOS: .css(light: "blur(10px)", dark: "blur(16px)"),
                macOS: .css(light: "blur(6px)", dark: "blur(10px)")
            ),
        ])

        #if os(iOS)
        #expect(TailwindRuntime.rawVariable("--card-backdrop", colorScheme: .light) == "blur(10px)")
        #expect(TailwindRuntime.rawVariable("--card-backdrop", colorScheme: .dark) == "blur(16px)")
        #elseif os(macOS)
        #expect(TailwindRuntime.rawVariable("--card-backdrop", colorScheme: .light) == "blur(6px)")
        #expect(TailwindRuntime.rawVariable("--card-backdrop", colorScheme: .dark) == "blur(10px)")
        #else
        #expect(TailwindRuntime.rawVariable("--card-backdrop", colorScheme: .light) == "blur(8px)")
        #expect(TailwindRuntime.rawVariable("--card-backdrop", colorScheme: .dark) == "blur(12px)")
        #endif
    }

    @Test func entriesMixThemeCssAndUtilities() {
        TailwindSwiftUI.reset()
        defer { TailwindSwiftUI.reset() }

        TailwindSwiftUI.initialize(entries: [
            .color("--color-brand", default: .color(light: "blue-500", dark: "yellow-500")),
            .css("--card-blur", property: "backdrop-filter", light: "blur(8px)"),
            .utilities(["btn-primary": "px-4 py-2 bg-[--color-brand] text-white rounded-md"]),
        ])

        #expect(TailwindRuntime.colorVariable("--color-brand", colorScheme: .light) != nil)
        #expect(TailwindRuntime.rawVariable("--card-blur", colorScheme: .light) == "blur(8px)")

        let expanded = TailwindRuntime.expandUtilityAliases(["btn-primary"])
        #expect(expanded.contains("bg-[--color-brand]"))
        #expect(expanded.contains("rounded-md"))
    }
}
