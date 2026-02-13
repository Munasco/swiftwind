import SwiftUI

enum TWPositionMode {
    case `static`
    case relative
    case absolute
    case fixed
    case sticky
}

private struct TWPositionModeKey: EnvironmentKey {
    static let defaultValue: TWPositionMode = .static
}

extension EnvironmentValues {
    var twPositionMode: TWPositionMode {
        get { self[TWPositionModeKey.self] }
        set { self[TWPositionModeKey.self] = newValue }
    }
}
