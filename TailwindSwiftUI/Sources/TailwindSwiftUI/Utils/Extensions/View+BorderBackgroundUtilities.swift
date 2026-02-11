import SwiftUI

// MARK: - Border Width
public extension View {
    func border(_ width: CGFloat = 1) -> some View {
        self.overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: width))
    }
    
    func borderColor(_ color: Color, width: CGFloat = 1) -> some View {
        self.overlay(RoundedRectangle(cornerRadius: 0).stroke(color, lineWidth: width))
    }
    
    func borderX(_ width: CGFloat, color: Color = .gray) -> some View {
        self.overlay(
            HStack {
                Rectangle().fill(color).frame(width: width)
                Spacer()
                Rectangle().fill(color).frame(width: width)
            }
        )
    }
    
    func borderY(_ width: CGFloat, color: Color = .gray) -> some View {
        self.overlay(
            VStack {
                Rectangle().fill(color).frame(height: width)
                Spacer()
                Rectangle().fill(color).frame(height: width)
            }
        )
    }
    
    func borderTop(_ width: CGFloat, color: Color = .gray) -> some View {
        self.overlay(
            VStack {
                Rectangle().fill(color).frame(height: width)
                Spacer()
            }
        )
    }
    
    func borderBottom(_ width: CGFloat, color: Color = .gray) -> some View {
        self.overlay(
            VStack {
                Spacer()
                Rectangle().fill(color).frame(height: width)
            }
        )
    }
    
    func borderLeft(_ width: CGFloat, color: Color = .gray) -> some View {
        self.overlay(
            HStack {
                Rectangle().fill(color).frame(width: width)
                Spacer()
            }
        )
    }
    
    func borderRight(_ width: CGFloat, color: Color = .gray) -> some View {
        self.overlay(
            HStack {
                Spacer()
                Rectangle().fill(color).frame(width: width)
            }
        )
    }
}

// MARK: - Border Style
public extension View {
    func borderSolid() -> some View { self }
    func borderDashed() -> some View { self }
    func borderDotted() -> some View { self }
    func borderDouble() -> some View { self }
    func borderNone() -> some View { self }
}

// MARK: - Divide (borders between children)
public extension View {
    func divideX(_ width: CGFloat = 1, color: Color = .gray) -> some View {
        self
    }
    
    func divideY(_ width: CGFloat = 1, color: Color = .gray) -> some View {
        self
    }
}

// MARK: - Outline
public extension View {
    func outline(_ width: CGFloat = 1, color: Color = .blue) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(color, lineWidth: width)
                .offset(x: width, y: width)
        )
    }
    
    func outlineOffset(_ offset: CGFloat) -> some View {
        self.padding(offset)
    }
}

// MARK: - Ring (focus ring)
public extension View {
    func ring(_ width: CGFloat = 2, color: Color = .blue) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(color, lineWidth: width)
        )
    }
    
    func ringInset(_ width: CGFloat = 2, color: Color = .blue) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(color, lineWidth: width)
        )
    }
    
    func ringOffset(_ offset: CGFloat) -> some View {
        self.padding(offset)
    }
    
    func ringOffsetColor(_ color: Color) -> some View {
        self
    }
}

// MARK: - Background Size
public extension View {
    func bgAuto() -> some View { self }
    func bgCover() -> some View { self }
    func bgContain() -> some View { self }
}

// MARK: - Background Position
public extension View {
    func bgCenter() -> some View { self }
    func bgTop() -> some View { self }
    func bgBottom() -> some View { self }
    func bgLeft() -> some View { self }
    func bgRight() -> some View { self }
}

// MARK: - Background Repeat
public extension View {
    func bgRepeat() -> some View { self }
    func bgNoRepeat() -> some View { self }
    func bgRepeatX() -> some View { self }
    func bgRepeatY() -> some View { self }
    func bgRepeatRound() -> some View { self }
    func bgRepeatSpace() -> some View { self }
}

// MARK: - Background Origin
public extension View {
    func bgOriginBorder() -> some View { self }
    func bgOriginPadding() -> some View { self }
    func bgOriginContent() -> some View { self }
}

// MARK: - Background Clip
public extension View {
    func bgClipBorder() -> some View { self.clipped() }
    func bgClipPadding() -> some View { self.clipped() }
    func bgClipContent() -> some View { self.clipped() }
    func bgClipText() -> some View { self }
}

// MARK: - Gradient (Linear, Radial, Conic)
public extension View {
    func gradientToR(_ colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
        )
    }
    
    func gradientToL(_ colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .trailing, endPoint: .leading)
        )
    }
    
    func gradientToT(_ colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
        )
    }
    
    func gradientToB(_ colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
        )
    }
    
    func gradientToTR(_ colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .bottomLeading, endPoint: .topTrailing)
        )
    }
    
    func gradientToBR(_ colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
    
    func gradientToBL(_ colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .topTrailing, endPoint: .bottomLeading)
        )
    }
    
    func gradientToTL(_ colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .bottomTrailing, endPoint: .topLeading)
        )
    }
}
