import SwiftUI
import Foundation
#if canImport(Synchronization)
import Synchronization
#endif

struct TWPeerState: Equatable {
    var isDark: Bool
    var isFocused: Bool
    var isHovered: Bool
    var isActive: Bool
    var isEnabled: Bool
}

enum TWGlobalPeerRegistry {
    private protocol StorageProtocol: Sendable {
        func set(_ state: TWPeerState, for id: String)
        func get(_ id: String) -> TWPeerState?
        func reset()
    }

    private final class LegacyStorage: StorageProtocol, @unchecked Sendable {
        private let lock = NSLock()
        private var states: [String: TWPeerState] = [:]

        func set(_ state: TWPeerState, for id: String) {
            lock.lock()
            states[id] = state
            lock.unlock()
        }

        func get(_ id: String) -> TWPeerState? {
            lock.lock()
            defer { lock.unlock() }
            return states[id]
        }

        func reset() {
            lock.lock()
            states.removeAll()
            lock.unlock()
        }
    }

    #if canImport(Synchronization)
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    private final class ModernStorage: StorageProtocol {
        private let mutex = Mutex([String: TWPeerState]())

        func set(_ state: TWPeerState, for id: String) {
            mutex.withLock { locked in
                locked[id] = state
            }
        }

        func get(_ id: String) -> TWPeerState? {
            mutex.withLock { locked in
                locked[id]
            }
        }

        func reset() {
            mutex.withLock { locked in
                locked.removeAll()
            }
        }
    }
    #endif

    private static let storage: any StorageProtocol = {
        #if canImport(Synchronization)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            return ModernStorage()
        }
        #endif
        return LegacyStorage()
    }()

    static func set(_ state: TWPeerState, for id: String) {
        storage.set(state, for: id)
    }

    static func get(_ id: String) -> TWPeerState? {
        storage.get(id)
    }

    static func reset() {
        storage.reset()
    }
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
