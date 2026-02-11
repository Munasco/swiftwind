import SwiftUI

struct TWPeerState: Equatable {
    var isDark: Bool
    var isFocused: Bool
    var isHovered: Bool
    var isActive: Bool
}

private struct TWGroupDarkKey: EnvironmentKey {
    static let defaultValue = false
}

private struct TWGroupFocusedKey: EnvironmentKey {
    static let defaultValue = false
}

private struct TWGroupHoveredKey: EnvironmentKey {
    static let defaultValue = false
}

private struct TWGroupActiveKey: EnvironmentKey {
    static let defaultValue = false
}

private struct TWPeerStatesKey: EnvironmentKey {
    static let defaultValue: [String: TWPeerState] = [:]
}

extension EnvironmentValues {
    var twGroupDark: Bool {
        get { self[TWGroupDarkKey.self] }
        set { self[TWGroupDarkKey.self] = newValue }
    }

    var twGroupFocused: Bool {
        get { self[TWGroupFocusedKey.self] }
        set { self[TWGroupFocusedKey.self] = newValue }
    }

    var twGroupHovered: Bool {
        get { self[TWGroupHoveredKey.self] }
        set { self[TWGroupHoveredKey.self] = newValue }
    }

    var twGroupActive: Bool {
        get { self[TWGroupActiveKey.self] }
        set { self[TWGroupActiveKey.self] = newValue }
    }

    var twPeerStates: [String: TWPeerState] {
        get { self[TWPeerStatesKey.self] }
        set { self[TWPeerStatesKey.self] = newValue }
    }
}

struct TWPeerStatesPreferenceKey: PreferenceKey {
    static let defaultValue: [String: TWPeerState] = [:]

    static func reduce(value: inout [String: TWPeerState], nextValue: () -> [String: TWPeerState]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

private struct TWPeerScopeModifier: ViewModifier {
    @State private var peerStates: [String: TWPeerState] = [:]

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(TWPeerStatesPreferenceKey.self) { peerStates = $0 }
            .environment(\.twPeerStates, peerStates)
    }
}

public extension View {
    /// Enables `peer-*` variants within this subtree.
    func twPeerScope() -> some View {
        modifier(TWPeerScopeModifier())
    }
}
