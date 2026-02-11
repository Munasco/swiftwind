import Testing
@testable import TailwindSwiftUI

/// Explicit backlog tracker for remaining NativeWind parity work.
/// Keep this list in tests so gaps are visible in CI/review.
@Suite("NativeWind Parity Gaps")
struct NativeWindParityGapTrackerTests {

    @Test func parityGapBacklogIsEmpty() {
        let missingOrPartial = gapBacklog()
        #expect(missingOrPartial.isEmpty, "Parity backlog should be empty.")
    }

    @Test func noGapIsMarkedWebOnly() {
        let missingOrPartial = gapBacklog()
        for cls in missingOrPartial {
            #expect(!TailwindNativeWindParity.isWebOnlyClassOnNative(cls), "'\(cls)' is in native parity backlog and should not be categorized as web-only.")
        }
    }

    private func gapBacklog() -> [String] {
        NativeWindParityContractData.parityGaps
    }
}
