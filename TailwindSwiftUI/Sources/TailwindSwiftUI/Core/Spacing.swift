import SwiftUI

/// Tailwind-style spacing scale
/// Based on 4pt grid system: spacing value × 4 = points
public enum TSpacing {
    /// 0pt
    case _0
    /// 1pt (0.25 × 4)
    case px
    /// 2pt (0.5 × 4)
    case _0_5
    /// 4pt (1 × 4)
    case _1
    /// 6pt (1.5 × 4)
    case _1_5
    /// 8pt (2 × 4)
    case _2
    /// 10pt (2.5 × 4)
    case _2_5
    /// 12pt (3 × 4)
    case _3
    /// 14pt (3.5 × 4)
    case _3_5
    /// 16pt (4 × 4)
    case _4
    /// 20pt (5 × 4)
    case _5
    /// 24pt (6 × 4)
    case _6
    /// 28pt (7 × 4)
    case _7
    /// 32pt (8 × 4)
    case _8
    /// 36pt (9 × 4)
    case _9
    /// 40pt (10 × 4)
    case _10
    /// 44pt (11 × 4)
    case _11
    /// 48pt (12 × 4)
    case _12
    /// 56pt (14 × 4)
    case _14
    /// 64pt (16 × 4)
    case _16
    /// 80pt (20 × 4)
    case _20
    /// 96pt (24 × 4)
    case _24
    /// 112pt (28 × 4)
    case _28
    /// 128pt (32 × 4)
    case _32
    /// 144pt (36 × 4)
    case _36
    /// 160pt (40 × 4)
    case _40
    /// 176pt (44 × 4)
    case _44
    /// 192pt (48 × 4)
    case _48
    /// 208pt (52 × 4)
    case _52
    /// 224pt (56 × 4)
    case _56
    /// 240pt (60 × 4)
    case _60
    /// 256pt (64 × 4)
    case _64
    /// 288pt (72 × 4)
    case _72
    /// 320pt (80 × 4)
    case _80
    /// 384pt (96 × 4)
    case _96
    /// Custom value in points
    case custom(CGFloat)

    public var value: CGFloat {
        switch self {
        case ._0: return 0
        case .px: return 1
        case ._0_5: return 2
        case ._1: return 4
        case ._1_5: return 6
        case ._2: return 8
        case ._2_5: return 10
        case ._3: return 12
        case ._3_5: return 14
        case ._4: return 16
        case ._5: return 20
        case ._6: return 24
        case ._7: return 28
        case ._8: return 32
        case ._9: return 36
        case ._10: return 40
        case ._11: return 44
        case ._12: return 48
        case ._14: return 56
        case ._16: return 64
        case ._20: return 80
        case ._24: return 96
        case ._28: return 112
        case ._32: return 128
        case ._36: return 144
        case ._40: return 160
        case ._44: return 176
        case ._48: return 192
        case ._52: return 208
        case ._56: return 224
        case ._60: return 240
        case ._64: return 256
        case ._72: return 288
        case ._80: return 320
        case ._96: return 384
        case .custom(let value): return value
        }
    }
}

// MARK: - Convenience Integer Initializer
extension TSpacing: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        switch value {
        case 0: self = ._0
        case 1: self = ._1
        case 2: self = ._2
        case 3: self = ._3
        case 4: self = ._4
        case 5: self = ._5
        case 6: self = ._6
        case 7: self = ._7
        case 8: self = ._8
        case 9: self = ._9
        case 10: self = ._10
        case 11: self = ._11
        case 12: self = ._12
        case 14: self = ._14
        case 16: self = ._16
        case 20: self = ._20
        case 24: self = ._24
        case 28: self = ._28
        case 32: self = ._32
        case 36: self = ._36
        case 40: self = ._40
        case 44: self = ._44
        case 48: self = ._48
        case 52: self = ._52
        case 56: self = ._56
        case 60: self = ._60
        case 64: self = ._64
        case 72: self = ._72
        case 80: self = ._80
        case 96: self = ._96
        default: self = .custom(CGFloat(value * 4))
        }
    }
}
