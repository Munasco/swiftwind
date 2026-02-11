import SwiftUI

/// A neutral Tailwind container host, intended as the SwiftUI equivalent
/// of a simple web div for layout-affecting Tailwind utilities.
public struct TWView<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
    }
}

