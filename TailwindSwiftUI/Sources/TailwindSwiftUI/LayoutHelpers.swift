import SwiftUI

// MARK: - Container Components with Gap Support

/// Tailwind-style flex row with gap
public struct TWStack<Content: View>: View {
    let axis: Axis
    let gap: CGFloat?
    let content: Content
    
    public init(_ axis: Axis, gap: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.gap = gap
        self.content = content()
    }
    
    public var body: some View {
        if axis == .horizontal {
            HStack(spacing: gap) { content }
        } else {
            VStack(spacing: gap) { content }
        }
    }
}

// MARK: - Position Types
public enum TWPosition {
    case relative, absolute, fixed, sticky
}

// MARK: - Display Modifiers
public extension View {
    func position(_ position: TWPosition) -> some View {
        // Note: SwiftUI doesn't have exact position equivalents
        // This is a simplified version
        switch position {
        case .relative: return AnyView(self)
        case .absolute: return AnyView(self.position(x: 0, y: 0))
        case .fixed: return AnyView(self)
        case .sticky: return AnyView(self)
        }
    }
}

// MARK: - Inset/Offset (top, left, right, bottom)
public extension View {
    func inset(top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0) -> some View {
        self.offset(x: left - right, y: top - bottom)
    }
    
    func top(_ value: CGFloat) -> some View {
        self.offset(y: -value)
    }
    
    func bottom(_ value: CGFloat) -> some View {
        self.offset(y: value)
    }
    
    func left(_ value: CGFloat) -> some View {
        self.offset(x: -value)
    }
    
    func right(_ value: CGFloat) -> some View {
        self.offset(x: value)
    }
}
