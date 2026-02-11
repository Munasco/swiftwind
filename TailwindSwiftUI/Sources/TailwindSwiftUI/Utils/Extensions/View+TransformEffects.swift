import SwiftUI

// MARK: - Transform Scale
public extension View {
    func scale(_ value: Int) -> some View {
        self.scaleEffect(Double(value) / 100)
    }
    
    func scaleX(_ value: Int) -> some View {
        self.scaleEffect(x: Double(value) / 100, y: 1)
    }
    
    func scaleY(_ value: Int) -> some View {
        self.scaleEffect(x: 1, y: Double(value) / 100)
    }
}

// MARK: - Transform Rotate
public  extension View {
    func rotate(_ degrees: Int) -> some View {
        self.rotationEffect(.degrees(Double(degrees)))
    }
}

// MARK: - Transform Translate
public extension View {
    func translateX(_ value: CGFloat) -> some View {
        self.offset(x: value)
    }
    
    func translateY(_ value: CGFloat) -> some View {
        self.offset(y: value)
    }
    
    func translate(x: CGFloat, y: CGFloat) -> some View {
        self.offset(x: x, y: y)
    }
}

// MARK: - Transform Skew
public extension View {
    func skewX(_ degrees: Double) -> some View {
        self.transformEffect(CGAffineTransform(a: 1, b: 0, c: tan(degrees * .pi / 180), d: 1, tx: 0, ty: 0))
    }
    
    func skewY(_ degrees: Double) -> some View {
        self.transformEffect(CGAffineTransform(a: 1, b: tan(degrees * .pi / 180), c: 0, d: 1, tx: 0, ty: 0))
    }
}

// MARK: - Transform Origin
public extension View {
    func transformOriginCenter() -> some View { self }
    func transformOriginTop() -> some View { self }
    func transformOriginTopRight() -> some View { self }
    func transformOriginRight() -> some View { self }
    func transformOriginBottomRight() -> some View { self }
    func transformOriginBottom() -> some View { self }
    func transformOriginBottomLeft() -> some View { self }
    func transformOriginLeft() -> some View { self }
    func transformOriginTopLeft() -> some View { self }
}

// MARK: - Filters - Blur
public enum TWBlur {
    case none, sm, base, md, lg, xl, xl2, xl3
    
    var value: CGFloat {
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
    func blur(_ amount: TWBlur) -> some View {
        self.blur(radius: amount.value)
    }
}

// MARK: - Filters - Brightness
public extension View {
    func brightness(_ percent: Int) -> some View {
        self.brightness(Double(percent - 100) / 100)
    }
}

// MARK: - Filters - Contrast
public extension View {
    func contrast(_ percent: Int) -> some View {
        self.contrast(Double(percent) / 100)
    }
}

// MARK: - Filters - Grayscale
public extension View {
    func grayscaleFull() -> some View {
        self.grayscale(1.0)
    }
    
    func grayscale(_ percent: Int) -> some View {
        self.saturation(1.0 - Double(percent) / 100)
    }
}

// MARK: - Filters - Hue Rotate
public extension View {
    func hueRotate(_ degrees: Int) -> some View {
        self.hueRotation(.degrees(Double(degrees)))
    }
}

// MARK: - Filters - Invert
public extension View {
    func invertFull() -> some View {
        self.colorInvert()
    }
}

// MARK: - Filters - Saturate
public extension View {
    func saturate(_ percent: Int) -> some View {
        self.saturation(Double(percent) / 100)
    }
}

// MARK: - Filters - Sepia
public extension View {
    func sepia() -> some View {
        self.colorMultiply(Color(red: 0.9, green: 0.8, blue: 0.6))
    }
}

// MARK: - Backdrop Filters
public extension View {
    func backdropBlur(_ amount: TWBlur) -> some View {
        self.background(.ultraThinMaterial)
    }
    
    func backdropBrightness(_ percent: Int) -> some View {
        self
    }
    
    func backdropContrast(_ percent: Int) -> some View {
        self
    }
    
    func backdropGrayscale() -> some View {
        self
    }
    
    func backdropHueRotate(_ degrees: Int) -> some View {
        self
    }
    
    func backdropInvert() -> some View {
        self
    }
    
    func backdropSaturate(_ percent: Int) -> some View {
        self
    }
}

// MARK: - Mix Blend Mode
public extension View {
    func mixBlendNormal() -> some View { self.blendMode(.normal) }
    func mixBlendMultiply() -> some View { self.blendMode(.multiply) }
    func mixBlendScreen() -> some View { self.blendMode(.screen) }
    func mixBlendOverlay() -> some View { self.blendMode(.overlay) }
    func mixBlendDarken() -> some View { self.blendMode(.darken) }
    func mixBlendLighten() -> some View { self.blendMode(.lighten) }
    func mixBlendColorDodge() -> some View { self.blendMode(.colorDodge) }
    func mixBlendColorBurn() -> some View { self.blendMode(.colorBurn) }
    func mixBlendHardLight() -> some View { self.blendMode(.hardLight) }
    func mixBlendSoftLight() -> some View { self.blendMode(.softLight) }
    func mixBlendDifference() -> some View { self.blendMode(.difference) }
    func mixBlendExclusion() -> some View { self.blendMode(.exclusion) }
    func mixBlendHue() -> some View { self.blendMode(.hue) }
    func mixBlendSaturation() -> some View { self.blendMode(.saturation) }
    func mixBlendColor() -> some View { self.blendMode(.color) }
    func mixBlendLuminosity() -> some View { self.blendMode(.luminosity) }
}
