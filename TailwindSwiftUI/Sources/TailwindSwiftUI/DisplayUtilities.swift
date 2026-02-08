import SwiftUI

// MARK: - Display & Visibility
public extension View {
    func block() -> some View { self }
    func inlineBlock() -> some View { self }
    func tw_hidden() -> some View { self.hidden() }
}

// MARK: - Overflow
public extension View {
    func overflowHidden() -> some View {
        self.clipped()
    }
    
    func overflowVisible() -> some View { self }
    func overflowScroll() -> some View {
        ScrollView { self }
    }
}

// MARK: - Object Fit/Position
public extension View {
    func objectFit(_ fit: ContentMode) -> some View {
        self.scaledToFit()
    }
    
    func objectCover() -> some View {
        self.scaledToFill()
    }
    
    func objectContain() -> some View {
        self.scaledToFit()
    }
}

// MARK: - Cursor (macOS)
#if os(macOS)
public extension View {
    func cursorPointer() -> some View {
        self.onHover { inside in
            if inside {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
    
    func cursorDefault() -> some View {
        self.onHover { _ in NSCursor.arrow.set() }
    }
    
    func cursorNotAllowed() -> some View {
        self.onHover { inside in
            if inside {
                NSCursor.operationNotAllowed.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}
#endif

// MARK: - User Select
public extension View {
    func selectNone() -> some View {
        #if os(macOS)
        return self.textSelection(.disabled)
        #else
        return self
        #endif
    }
    
    func selectText() -> some View {
        #if os(macOS)
        return self.textSelection(.enabled)
        #else
        return self
        #endif
    }
    
    func selectAll() -> some View {
        self.selectText()
    }
}

// MARK: - Pointer Events
public extension View {
    func pointerEventsNone() -> some View {
        self.allowsHitTesting(false)
    }
    
    func pointerEventsAuto() -> some View {
        self.allowsHitTesting(true)
    }
}

// MARK: - Resize
public extension View {
    func resizeNone() -> some View { self }
    func resizeVertical() -> some View { self }
    func resizeHorizontal() -> some View { self }
    func resizeBoth() -> some View { self }
}

// MARK: - Scroll Behavior
public extension View {
    func scrollSmooth() -> some View { self }
    func scrollAuto() -> some View { self }
}

// MARK: - Snap
public extension View {
    func snapStart() -> some View { self }
    func snapEnd() -> some View { self }
    func snapCenter() -> some View { self }
}

// MARK: - Touch Action
public extension View {
    func touchAuto() -> some View { self }
    func touchNone() -> some View { self.allowsHitTesting(false) }
    func touchManipulation() -> some View { self }
}

// MARK: - Will Change (performance hints)
public extension View {
    func willChangeAuto() -> some View { self }
    func willChangeScroll() -> some View { self }
    func willChangeContents() -> some View { self }
    func willChangeTransform() -> some View { self }
}

// MARK: - Appearance
public extension View {
    func appearanceNone() -> some View { self }
    func appearanceAuto() -> some View { self }
}
