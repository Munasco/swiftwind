import Testing
import SwiftUI
@testable import TailwindSwiftUI

@Suite("LayoutViews: TWStack")
@MainActor
struct TWStackTests {
    @Test func horizontalStackConstructs() {
        _ = TWStack(.horizontal, gap: 12) {
            Text("A")
            Text("B")
        }
    }

    @Test func verticalStackConstructs() {
        _ = TWStack(.vertical, gap: 8) {
            Text("A")
            Text("B")
        }
    }
}
