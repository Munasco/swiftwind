import Testing
import SwiftUI
@testable import TailwindSwiftUI

/// Inventory tracker built from NativeWind section coverage targets.
/// Rules:
/// - Full-support inventory classes must not be tagged web-only.
/// - Web-only inventory classes must be tagged web-only.
/// - Full-support inventory classes should compile through `.tw(...)`.
@MainActor
@Suite("NativeWind Inventory Tracker")
struct NativeWindInventoryTrackerTests {

    @Test func fullSupportInventoryIsNotWebOnly() {
        for cls in fullSupportInventory() {
            #expect(!TailwindNativeWindParity.isWebOnlyClassOnNative(cls), "'\(cls)' should be native-supported, not web-only")
        }
    }

    @Test func webOnlyInventoryIsTaggedWebOnly() {
        for cls in NativeWindParityContractData.webOnlyInventory {
            #expect(TailwindNativeWindParity.isWebOnlyClassOnNative(cls), "'\(cls)' should be web-only in NativeWind parity layer")
        }
    }

    @Test func fullSupportInventoryCompilesOnViews() {
        // Standard view target
        for cls in NativeWindParityContractData.fullSupportInventoryStandard {
            _ = Text("Inventory").tw(cls)
        }
        // TWView container target for layout-centric classes
        for cls in NativeWindParityContractData.fullSupportInventoryContainer {
            _ = TWView {
                Text("A")
                Text("B")
            }.tw(cls)
        }
    }

    private func fullSupportInventory() -> [String] {
        Array(Set(
            NativeWindParityContractData.fullSupportInventoryStandard +
            NativeWindParityContractData.fullSupportInventoryContainer
        ))
    }
}
