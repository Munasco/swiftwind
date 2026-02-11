import SwiftUI

// MARK: - Background Modifier
public extension View {
    func bg(_ color: Color) -> some View {
        self.background(color)
    }
}

// MARK: - Text Color
public extension View {
    func textColor(_ color: Color) -> some View {
        self.foregroundColor(color)
    }
}

// MARK: - Padding (p, px, py, pt, pr, pb, pl)
public extension View {
    /// All sides padding
    func p(_ value: CGFloat) -> some View {
        self.padding(value)
    }

    /// Horizontal padding
    func px(_ value: CGFloat) -> some View {
        self.padding(.horizontal, value)
    }

    /// Vertical padding
    func py(_ value: CGFloat) -> some View {
        self.padding(.vertical, value)
    }

    /// Top padding
    func pt(_ value: CGFloat) -> some View {
        self.padding(.top, value)
    }

    /// Right/Trailing padding
    func pr(_ value: CGFloat) -> some View {
        self.padding(.trailing, value)
    }

    /// Bottom padding
    func pb(_ value: CGFloat) -> some View {
        self.padding(.bottom, value)
    }

    /// Left/Leading padding
    func pl(_ value: CGFloat) -> some View {
        self.padding(.leading, value)
    }
}

// MARK: - Border Radius
public enum TRadius {
    case none, sm, base, md, lg, xl, xl2, xl3, full
    case custom(CGFloat)

    public var value: CGFloat {
        switch self {
        case .none: return 0
        case .sm: return 2
        case .base: return 4
        case .md: return 6
        case .lg: return 8
        case .xl: return 12
        case .xl2: return 16
        case .xl3: return 24
        case .full: return 9999
        case .custom(let v): return v
        }
    }
}

public extension View {
    func rounded(_ radius: TRadius = .base) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius.value))
    }

    func roundedTop(_ radius: TRadius) -> some View {
        self.clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: radius.value,
                topTrailingRadius: radius.value
            )
        )
    }

    func roundedBottom(_ radius: TRadius) -> some View {
        self.clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: radius.value,
                bottomTrailingRadius: radius.value
            )
        )
    }
}

// MARK: - Shadow
public enum TShadow {
    case sm, base, md, lg, xl, xl2, none

    public var radius: CGFloat {
        switch self {
        case .none: return 0
        case .sm: return 1
        case .base: return 2
        case .md: return 4
        case .lg: return 8
        case .xl: return 12
        case .xl2: return 24
        }
    }

    public var y: CGFloat {
        switch self {
        case .none: return 0
        case .sm: return 1
        case .base: return 1
        case .md: return 2
        case .lg: return 4
        case .xl: return 8
        case .xl2: return 12
        }
    }
}

public extension View {
    func shadow(_ size: TShadow) -> some View {
        self.shadow(color: .black.opacity(0.1), radius: size.radius, y: size.y)
    }

    func shadow(_ size: TShadow, color: Color) -> some View {
        self.shadow(color: color, radius: size.radius, y: size.y)
    }
}

// MARK: - Opacity
public extension View {
    func opacity(_ percent: Int) -> some View {
        self.opacity(Double(percent) / 100.0)
    }
}

// MARK: - Size (w, h, size)
public extension View {
    func w(_ value: CGFloat) -> some View {
        self.frame(width: value)
    }

    func h(_ value: CGFloat) -> some View {
        self.frame(height: value)
    }

    func size(_ value: CGFloat) -> some View {
        self.frame(width: value, height: value)
    }

    func wFull() -> some View {
        self.frame(maxWidth: .infinity)
    }

    func hFull() -> some View {
        self.frame(maxHeight: .infinity)
    }

    func minW(_ value: CGFloat) -> some View {
        self.frame(minWidth: value)
    }

    func maxW(_ value: CGFloat) -> some View {
        self.frame(maxWidth: value)
    }

    func minH(_ value: CGFloat) -> some View {
        self.frame(minHeight: value)
    }

    func maxH(_ value: CGFloat) -> some View {
        self.frame(maxHeight: value)
    }
}

// MARK: - Font Size
public enum TFontSize {
    case xs, sm, base, lg, xl, xl2, xl3, xl4, xl5, xl6, xl7, xl8, xl9

    public var size: CGFloat {
        switch self {
        case .xs: return 12
        case .sm: return 14
        case .base: return 16
        case .lg: return 18
        case .xl: return 20
        case .xl2: return 24
        case .xl3: return 30
        case .xl4: return 36
        case .xl5: return 48
        case .xl6: return 60
        case .xl7: return 72
        case .xl8: return 96
        case .xl9: return 128
        }
    }
}

public extension View {
    func text(_ size: TFontSize) -> some View {
        self.font(.system(size: size.size))
    }

    func fontBold() -> some View {
        self.fontWeight(.bold)
    }

    func fontSemibold() -> some View {
        self.fontWeight(.semibold)
    }

    func fontMedium() -> some View {
        self.fontWeight(.medium)
    }

    func fontLight() -> some View {
        self.fontWeight(.light)
    }

    func fontThin() -> some View {
        self.fontWeight(.thin)
    }

    func textItalic() -> some View {
        self.font(.body.italic())
    }

    func uppercase() -> some View {
        self.textCase(.uppercase)
    }

    func lowercase() -> some View {
        self.textCase(.lowercase)
    }

    func capitalize() -> some View {
        self.textCase(nil)
    }

    func truncate() -> some View {
        self.lineLimit(1).truncationMode(.tail)
    }

    func lineClamp(_ lines: Int) -> some View {
        self.lineLimit(lines)
    }
}

// MARK: - Border
public extension View {
    func border(_ color: Color, width: CGFloat = 1) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(color, lineWidth: width)
        )
    }

    func borderRounded(_ color: Color, width: CGFloat = 1, radius: TRadius = .base) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius.value)
                .stroke(color, lineWidth: width)
        )
    }
}

// MARK: - Spacing (gap for stacks)
public extension HStack {
    init(gap: CGFloat, @ViewBuilder content: () -> Content) {
        self.init(spacing: gap, content: content)
    }
}

public extension VStack {
    init(gap: CGFloat, @ViewBuilder content: () -> Content) {
        self.init(spacing: gap, content: content)
    }
}

// MARK: - Z-Index
public extension View {
    func z(_ index: Double) -> some View {
        self.zIndex(index)
    }
}

// MARK: - Aspect Ratio
public extension View {
    func aspectSquare() -> some View {
        self.aspectRatio(1, contentMode: .fit)
    }

    func aspectVideo() -> some View {
        self.aspectRatio(16/9, contentMode: .fit)
    }

    func aspect(_ ratio: CGFloat) -> some View {
        self.aspectRatio(ratio, contentMode: .fit)
    }
}

// MARK: - Transitions & Animation
public enum TDuration {
    case _75, _100, _150, _200, _300, _500, _700, _1000

    public var value: Double {
        switch self {
        case ._75: return 0.075
        case ._100: return 0.1
        case ._150: return 0.15
        case ._200: return 0.2
        case ._300: return 0.3
        case ._500: return 0.5
        case ._700: return 0.7
        case ._1000: return 1.0
        }
    }
}

public extension View {
    func duration(_ d: TDuration) -> some View {
        self.animation(.easeInOut(duration: d.value), value: UUID())
    }

    func easeIn(_ d: TDuration = ._200) -> some View {
        self.animation(.easeIn(duration: d.value), value: UUID())
    }

    func easeOut(_ d: TDuration = ._200) -> some View {
        self.animation(.easeOut(duration: d.value), value: UUID())
    }

    func easeInOut(_ d: TDuration = ._200) -> some View {
        self.animation(.easeInOut(duration: d.value), value: UUID())
    }
}

// MARK: - Hidden / Visible
public extension View {
    func hidden(_ condition: Bool) -> some View {
        self.opacity(condition ? 0 : 1)
    }

    func invisible() -> some View {
        self.opacity(0)
    }
}

// MARK: - Blur
public enum TBlur {
    case none, sm, base, md, lg, xl, xl2, xl3

    public var value: CGFloat {
        switch self {
        case .none: return 0
        case .sm: return 4
        case .base: return 8
        case .md: return 12
        case .lg: return 16
        case .xl: return 24
        case .xl2: return 40
        case .xl3: return 64
        }
    }
}

public extension View {
    func blur(_ amount: TBlur) -> some View {
        self.blur(radius: amount.value)
    }
}

// MARK: - Invert
public extension View {
    func invert() -> some View {
        self.colorInvert()
    }
}

// MARK: - Object Fit (for images)
public extension Image {
    func objectCover() -> some View {
        self.resizable().scaledToFill()
    }

    func objectContain() -> some View {
        self.resizable().scaledToFit()
    }

    func objectFill() -> some View {
        self.resizable()
    }
}

// MARK: - Flex Alignment Helpers
public struct FlexRow<Content: View>: View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: Content

    public init(
        _ alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: alignment, spacing: spacing) { content }
    }
}

public struct FlexCol<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let content: Content

    public init(
        _ alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) { content }
    }
}

// MARK: - Screen Reader Only
public extension View {
    func srOnly() -> some View {
        self.accessibilityHidden(false)
            .frame(width: 1, height: 1)
            .clipped()
            .opacity(0)
    }
}

// MARK: - Disabled State
public extension View {
    func disabledStyle(_ isDisabled: Bool = true) -> some View {
        self.disabled(isDisabled).opacity(isDisabled ? 0.5 : 1)
    }
}

// MARK: - Divide (spacing between children)
public extension View {
    func divideY(_ color: Color, width: CGFloat = 1) -> some View {
        self.overlay(
            VStack(spacing: 0) {
                Divider().background(color).frame(height: width)
                Spacer()
            }
        )
    }
}
