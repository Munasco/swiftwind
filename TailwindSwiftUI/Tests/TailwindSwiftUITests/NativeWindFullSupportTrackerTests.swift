import Testing
import SwiftUI
@testable import TailwindSwiftUI

/// Lightweight tracker for NativeWind "full support" parity in this package.
/// Keep this list intentionally explicit so parity drift is visible in review.
@MainActor
@Suite("NativeWind Full Support Tracker")
struct NativeWindFullSupportTrackerTests {

    @Test func fullSupportMatrixOnStandardViews() {
        let classes = standardViewMatrix()
        for cls in classes {
            assertNativeSupported(cls)
            _ = Text("Tracker").tw(cls)
        }
    }

    @Test func fullSupportMatrixOnTWViewContainers() {
        let classes = twViewContainerMatrix()
        for cls in classes {
            assertNativeSupported(cls)
            _ = TWView {
                Text("A")
                Text("B")
            }.tw(cls)
        }
    }

    @Test func fullSupportThemeTokenBackedAspectStillWorks() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeVariables([
            "--aspect-poster": .aspect(light: "3 / 4"),
        ])
        defer { TailwindSwiftUI.reset() }

        _ = Rectangle().tw("aspect-poster")
        _ = Rectangle().tw("aspect-[var(--aspect-poster)]")
    }

    private func assertNativeSupported(_ cls: String) {
        #expect(!TailwindNativeWindParity.isWebOnlyClassOnNative(cls), "'\(cls)' should not be flagged as web-only")
    }

    private func standardViewMatrix() -> [String] {
        NativeWindParityContractData.fullSupportInventoryStandard
    }

    private func twViewContainerMatrix() -> [String] {
        NativeWindParityContractData.fullSupportInventoryContainer
    }
}
