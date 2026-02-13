import SwiftUI

/// Convenience button wrapper for utility-first styling with `.tw(...)`.
public struct TWButton<Label: View>: View {
    private let classes: String
    private let action: () -> Void
    private let label: Label

    public init(
        _ classes: String = "",
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.classes = classes
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(action: action) { label }
            .tw(classes)
    }
}

public extension TWButton where Label == Text {
    init(
        _ title: String,
        classes: String = "",
        action: @escaping () -> Void
    ) {
        self.init(classes, action: action) {
            Text(title)
        }
    }
}

