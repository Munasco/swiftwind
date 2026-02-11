import Testing
import SwiftUI
@testable import TailwindSwiftUI

@MainActor
@Suite("NativeWind Parity")
struct NativeWindParityTests {

    @Test func webOnlyMatcherFlagsExpectedUtilities() {
        let webOnly = [
            "overflow-y-scroll",
            "overflow-x-auto",
            "overscroll-none",
            "scroll-smooth",
            "scroll-m-4",
            "scroll-px-2",
            "snap-x",
            "cursor-pointer",
            "resize",
            "select-none",
        ]
        for cls in webOnly {
            #expect(TailwindNativeWindParity.isWebOnlyClassOnNative(cls), "'\(cls)' should be flagged as web-only")
        }

        let native = [
            "overflow-hidden",
            "overflow-clip",
            "overflow-visible",
            "bg-blue-500",
            "p-4",
            "aspect-video",
            "container",
        ]
        for cls in native {
            #expect(!TailwindNativeWindParity.isWebOnlyClassOnNative(cls), "'\(cls)' should stay native-supported")
        }
    }
}
