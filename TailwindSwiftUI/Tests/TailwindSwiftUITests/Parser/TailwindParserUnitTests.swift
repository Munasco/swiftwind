import Testing
import SwiftUI
@testable import TailwindSwiftUI

@Suite("Parser: Unit")
@MainActor
struct TailwindParserUnitTests {
    @Test func twAppliesWithoutCrash() {
        _ = Text("Hello").tw("p-4 bg-blue-500 text-white rounded-lg")
        _ = Rectangle().tw("fill-red-500 stroke-blue-500 stroke-2 w-16 h-16")
        _ = VStack { Text("A") }.tw("relative top-2")
    }

    @Test func chainedTwCompiles() {
        _ = Text("Hello")
            .tw("p-4 bg-red-500")
            .tw("p-2 rounded-md")
    }
}
