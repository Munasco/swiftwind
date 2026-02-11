import SwiftUI

// MARK: - Inset (top/right/bottom/left positioning)
public extension View {
    func insetAuto() -> some View {
        self
    }
    
    func insetFull() -> some View {
        self.offset(x: 0, y: 0)
    }
    
    func inset(top: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil) -> some View {
        let xOffset = (left ?? 0) - (right ?? 0)
        let yOffset = (top ?? 0) - (bottom ?? 0)
        return self.offset(x: xOffset, y: yOffset)
    }
}

// MARK: - Flex Basis
public extension View {
    func basisAuto() -> some View {
        self
    }
    
    func basisFull() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    func basis(_ value: CGFloat) -> some View {
        self.frame(width: value)
    }
}

// MARK: - Grid Auto Flow
public extension View {
    func gridFlowRow() -> some View { self }
    func gridFlowCol() -> some View { self }
    func gridFlowDense() -> some View { self }
    func gridFlowRowDense() -> some View { self }
    func gridFlowColDense() -> some View { self }
}

// MARK: - Grid Column/Row Span
// Note: SwiftUI doesn't support col/row span directly in LazyVGrid/LazyHGrid
// These are placeholders for compatibility
public extension View {
    func colSpan(_ n: Int) -> some View {
        self
    }

    func colSpanFull() -> some View {
        self
    }

    func rowSpan(_ n: Int) -> some View {
        self
    }

    func rowSpanFull() -> some View {
        self
    }
}

// MARK: - Grid Column/Row Start/End
public extension View {
    func colStart(_ n: Int) -> some View {
        self
    }
    
    func colEnd(_ n: Int) -> some View {
        self
    }
    
    func rowStart(_ n: Int) -> some View {
        self
    }
    
    func rowEnd(_ n: Int) -> some View {
        self
    }
}

// MARK: - Place Self
public extension View {
    func placeSelfAuto() -> some View { self }
    func placeSelfStart() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    func placeSelfEnd() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
    func placeSelfCenter() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    func placeSelfStretch() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Space Between (for containers)
public extension View {
    func spaceX(_ value: CGFloat) -> some View {
        self
    }
    
    func spaceY(_ value: CGFloat) -> some View {
        self
    }
}

// MARK: - Transition Property
public enum TTransitionProperty {
    case none, all, colors, opacity, shadow, transform
    
    var animation: Animation? {
        switch self {
        case .none: return nil
        case .all: return .default
        case .colors: return .default
        case .opacity: return .default
        case .shadow: return .default
        case .transform: return .default
        }
    }
}

public extension View {
    func transition(_ property: TTransitionProperty) -> some View {
        if let anim = property.animation {
            return AnyView(self.animation(anim, value: UUID()))
        }
        return AnyView(self)
    }
    
    func transitionNone() -> some View {
        self.animation(nil, value: UUID())
    }
    
    func transitionAll() -> some View {
        self.animation(.default, value: UUID())
    }
}

// MARK: - Transition Duration
public extension View {
    func duration75() -> some View {
        self.animation(.easeInOut(duration: 0.075), value: UUID())
    }
    
    func duration100() -> some View {
        self.animation(.easeInOut(duration: 0.1), value: UUID())
    }
    
    func duration150() -> some View {
        self.animation(.easeInOut(duration: 0.15), value: UUID())
    }
    
    func duration200() -> some View {
        self.animation(.easeInOut(duration: 0.2), value: UUID())
    }
    
    func duration300() -> some View {
        self.animation(.easeInOut(duration: 0.3), value: UUID())
    }
    
    func duration500() -> some View {
        self.animation(.easeInOut(duration: 0.5), value: UUID())
    }
    
    func duration700() -> some View {
        self.animation(.easeInOut(duration: 0.7), value: UUID())
    }
    
    func duration1000() -> some View {
        self.animation(.easeInOut(duration: 1.0), value: UUID())
    }
}

// MARK: - Transition Delay
public extension View {
    func delay75() -> some View {
        self.animation(.easeInOut.delay(0.075), value: UUID())
    }
    
    func delay100() -> some View {
        self.animation(.easeInOut.delay(0.1), value: UUID())
    }
    
    func delay150() -> some View {
        self.animation(.easeInOut.delay(0.15), value: UUID())
    }
    
    func delay200() -> some View {
        self.animation(.easeInOut.delay(0.2), value: UUID())
    }
    
    func delay300() -> some View {
        self.animation(.easeInOut.delay(0.3), value: UUID())
    }
    
    func delay500() -> some View {
        self.animation(.easeInOut.delay(0.5), value: UUID())
    }
    
    func delay700() -> some View {
        self.animation(.easeInOut.delay(0.7), value: UUID())
    }
    
    func delay1000() -> some View {
        self.animation(.easeInOut.delay(1.0), value: UUID())
    }
}

// MARK: - Ease Timing
public extension View {
    func easeLinear() -> some View {
        self.animation(.linear, value: UUID())
    }
    
    func easeIn() -> some View {
        self.animation(.easeIn, value: UUID())
    }
    
    func easeOut() -> some View {
        self.animation(.easeOut, value: UUID())
    }
    
    func easeInOut() -> some View {
        self.animation(.easeInOut, value: UUID())
    }
}

// MARK: - Animation
public extension View {
    func animateNone() -> some View {
        self.animation(nil, value: UUID())
    }
    
    func animateSpin() -> some View {
        self.rotationEffect(.degrees(360))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: UUID())
    }
    
    func animatePing() -> some View {
        self.scaleEffect(1.5)
            .opacity(0)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: UUID())
    }
    
    func animatePulse() -> some View {
        self.opacity(0.5)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
    }
    
    func animateBounce() -> some View {
        self.offset(y: -10)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: UUID())
    }
}

// MARK: - Content Visibility
public extension View {
    func contentAuto() -> some View { self }
    func contentHidden() -> some View { self.opacity(0) }
    func contentVisible() -> some View { self.opacity(1) }
}

// MARK: - Forced Colors
public extension View {
    func forcedColorsAuto() -> some View { self }
    func forcedColorsNone() -> some View { self }
}

// MARK: - Contain
public extension View {
    func containNone() -> some View { self }
    func containContent() -> some View { self }
    func containSize() -> some View { self }
    func containLayout() -> some View { self }
    func containPaint() -> some View { self }
    func containStyle() -> some View { self }
    func containStrict() -> some View { self }
}
