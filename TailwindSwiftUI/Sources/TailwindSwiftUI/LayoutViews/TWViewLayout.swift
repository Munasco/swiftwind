import SwiftUI

/// A neutral layout host intended for web-style composition.
///
/// Use this when you want a "plain div" container surface where Tailwind layout
/// classes are attached to the wrapper itself instead of a built-in stack that
/// already carries its own layout semantics.
public struct TWViewLayout<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        TWView { content }
    }
}

