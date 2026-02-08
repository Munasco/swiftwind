import SwiftUI

// MARK: - Grid Utilities
public extension View {
    /// Grid with specified columns
    func gridCols(_ count: Int) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: count)) {
            self
        }
    }
    
    /// Grid with specified rows
    func gridRows(_ count: Int) -> some View {
        LazyHGrid(rows: Array(repeating: GridItem(.flexible()), count: count)) {
            self
        }
    }
}

// MARK: - Flex Direction (for containers)
public struct FlexContainer<Content: View>: View {
    public enum Direction { case row, col, rowReverse, colReverse }
    
    let direction: Direction
    let content: Content
    
    public init(_ direction: Direction, @ViewBuilder content: () -> Content) {
        self.direction = direction
        self.content = content()
    }
    
    public var body: some View {
        switch direction {
        case .row:
            HStack { content }
        case .col:
            VStack { content }
        case .rowReverse:
            HStack { content }.environment(\.layoutDirection, .rightToLeft)
        case .colReverse:
            VStack { Spacer(); content }
        }
    }
}

// MARK: - Flex Wrap
public extension View {
    func flexWrap() -> some View { self }
    func flexWrapReverse() -> some View { self }
    func flexNowrap() -> some View { self }
}

// MARK: - Flex Grow/Shrink
public extension View {
    func flexGrow(_ value: Int = 1) -> some View {
        self.frame(maxWidth: value > 0 ? .infinity : nil, maxHeight: value > 0 ? .infinity : nil)
    }
    
    func flexShrink(_ value: Int = 1) -> some View {
        self.fixedSize()
    }
    
    func flex1() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func flexAuto() -> some View { self }
    func flexInitial() -> some View { self }
    func flexNone() -> some View { self.fixedSize() }
}

// MARK: - Justify Content
public extension View {
    func justifyStart() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func justifyEnd() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func justifyCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    func justifyBetween() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    func justifyAround() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    func justifyEvenly() -> some View {
        self.frame(maxWidth: .infinity)
    }
}

// MARK: - Align Items
public extension View {
    func itemsStart() -> some View {
        self.frame(maxHeight: .infinity, alignment: .top)
    }
    
    func itemsEnd() -> some View {
        self.frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    func itemsCenter() -> some View {
        self.frame(maxHeight: .infinity, alignment: .center)
    }
    
    func itemsBaseline() -> some View {
        self.alignmentGuide(.firstTextBaseline) { _ in 0 }
    }
    
    func itemsStretch() -> some View {
        self.frame(maxHeight: .infinity)
    }
}

// MARK: - Align Self
public extension View {
    func selfAuto() -> some View { self }
    func selfStart() -> some View { self.frame(maxHeight: .infinity, alignment: .top) }
    func selfEnd() -> some View { self.frame(maxHeight: .infinity, alignment: .bottom) }
    func selfCenter() -> some View { self.frame(maxHeight: .infinity, alignment: .center) }
    func selfStretch() -> some View { self.frame(maxHeight: .infinity) }
}

// MARK: - Place Content
public extension View {
    func placeContentCenter() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    func placeContentStart() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func placeContentEnd() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
    
    func placeContentBetween() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Place Items
public extension View {
    func placeItemsStart() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func placeItemsEnd() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
    
    func placeItemsCenter() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Order
public extension View {
    func order(_ value: Int) -> some View {
        self.zIndex(Double(value))
    }
    
    func orderFirst() -> some View { self.zIndex(999) }
    func orderLast() -> some View { self.zIndex(-999) }
    func orderNone() -> some View { self }
}

// MARK: - Gap (for containers)
public extension HStack {
    init(gap: Int, alignment: VerticalAlignment = .center, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: CGFloat(gap * 4), content: content)
    }
}

public extension VStack {
    init(gap: Int, alignment: HorizontalAlignment = .center, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: CGFloat(gap * 4), content: content)
    }
}
