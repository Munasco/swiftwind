import Testing
import SwiftUI
@testable import TailwindSwiftUI

@Suite("Overflow Behavior")
@MainActor
struct OverflowBehaviorTests {
    @Test func overflowHiddenCompilesOnContainer() {
        _ = VStack {
            Text("Row 1")
            Text("Row 2")
        }
        .tw("overflow-hidden")
    }

    @Test func overflowScrollVariantsCompileOnContainer() {
        for cls in [
            "overflow-scroll",
            "overflow-auto",
            "overflow-y-scroll",
            "overflow-y-auto",
            "overflow-x-scroll",
            "overflow-x-auto",
        ] {
            _ = VStack {
                Text("A")
                Text("B")
            }
            .tw(cls)
        }
    }

    @Test func overflowAxisVisibilityAndClipVariantsCompile() {
        for cls in [
            "overflow-visible",
            "overflow-clip",
            "overflow-x-visible",
            "overflow-x-hidden",
            "overflow-x-clip",
            "overflow-y-visible",
            "overflow-y-hidden",
            "overflow-y-clip",
        ] {
            _ = Text("Tailwind")
                .tw(cls)
        }
    }
}
