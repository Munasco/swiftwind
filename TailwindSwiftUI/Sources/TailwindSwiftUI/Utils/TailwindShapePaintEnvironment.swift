import SwiftUI

private struct TWInheritedFillColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

private struct TWInheritedStrokeColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

private struct TWInheritedStrokeWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

extension EnvironmentValues {
    var twInheritedFillColor: Color? {
        get { self[TWInheritedFillColorKey.self] }
        set { self[TWInheritedFillColorKey.self] = newValue }
    }

    var twInheritedStrokeColor: Color? {
        get { self[TWInheritedStrokeColorKey.self] }
        set { self[TWInheritedStrokeColorKey.self] = newValue }
    }

    var twInheritedStrokeWidth: CGFloat? {
        get { self[TWInheritedStrokeWidthKey.self] }
        set { self[TWInheritedStrokeWidthKey.self] = newValue }
    }
}
