import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

public enum GradientInterpolationMode {
    case srgb
    case oklch
}

public extension LinearGradient {
    init(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint,
        interpolation: GradientInterpolationMode
    ) {
        switch interpolation {
        case .srgb:
            self = LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
        case .oklch:
            self = OKLCHGradientInterpolator.linearGradient(
                colors: colors,
                start: startPoint,
                end: endPoint
            )
        }
    }
}

private enum OKLCHGradientInterpolator {
    struct OKLCHComponents {
        let l: Double
        let c: Double
        let h: Double
        let opacity: Double
    }

    static func linearGradient(
        colors: [Color],
        start: UnitPoint,
        end: UnitPoint,
        samplesPerSegment: Int = 16
    ) -> LinearGradient {
        guard colors.count >= 2 else {
            return LinearGradient(colors: colors, startPoint: start, endPoint: end)
        }

        let converted = colors.compactMap(oklchComponents(from:))
        guard converted.count == colors.count else {
            return LinearGradient(colors: colors, startPoint: start, endPoint: end)
        }

        let segments = converted.count - 1
        let clampedSamples = max(2, samplesPerSegment)
        var stops: [Gradient.Stop] = []
        stops.reserveCapacity(segments * clampedSamples + 1)

        for i in 0..<segments {
            let startColor = converted[i]
            let endColor = converted[i + 1]

            for step in 0..<clampedSamples {
                let t = Double(step) / Double(clampedSamples)
                let local = interpolate(start: startColor, end: endColor, t: t)
                let location = (Double(i) + t) / Double(segments)
                stops.append(
                    .init(
                        color: Color.oklch(local.l, local.c, local.h, local.opacity),
                        location: location
                    )
                )
            }
        }

        if let last = converted.last {
            stops.append(.init(color: Color.oklch(last.l, last.c, last.h, last.opacity), location: 1.0))
        }

        return LinearGradient(gradient: Gradient(stops: stops), startPoint: start, endPoint: end)
    }

    private static func oklchComponents(from color: Color) -> OKLCHComponents? {
        guard let rgba = rgba(from: color) else { return nil }

        let red = srgbToLinear(rgba.r)
        let green = srgbToLinear(rgba.g)
        let blue = srgbToLinear(rgba.b)

        let l = 0.4122214708 * red + 0.5363325363 * green + 0.0514459929 * blue
        let m = 0.2119034982 * red + 0.6806995451 * green + 0.1073969566 * blue
        let s = 0.0883024619 * red + 0.2817188376 * green + 0.6299787005 * blue

        let lCube = cbrt(l)
        let mCube = cbrt(m)
        let sCube = cbrt(s)

        let lightness = 0.2104542553 * lCube + 0.7936177850 * mCube - 0.0040720468 * sCube
        let aLab = 1.9779984951 * lCube - 2.4285922050 * mCube + 0.4505937099 * sCube
        let bLab = 0.0259040371 * lCube + 0.7827717662 * mCube - 0.8086757660 * sCube

        return .init(
            l: lightness,
            c: hypot(aLab, bLab),
            h: normalizeHue(atan2(bLab, aLab) * 180 / .pi),
            opacity: rgba.a
        )
    }

    private static func interpolate(
        start: OKLCHComponents,
        end: OKLCHComponents,
        t: Double
    ) -> OKLCHComponents {
        let lightness = start.l + (end.l - start.l) * t
        let chroma = start.c + (end.c - start.c) * t
        let deltaHue = shortestHueDelta(from: start.h, to: end.h)
        let hue = normalizeHue(start.h + deltaHue * t)
        let opacity = start.opacity + (end.opacity - start.opacity) * t
        return .init(l: lightness, c: chroma, h: hue, opacity: opacity)
    }

    private static func shortestHueDelta(from a: Double, to b: Double) -> Double {
        let delta = (b - a).truncatingRemainder(dividingBy: 360)
        if delta > 180 { return delta - 360 }
        if delta < -180 { return delta + 360 }
        return delta
    }

    private static func rgba(from color: Color) -> (r: Double, g: Double, b: Double, a: Double)? {
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (Double(r), Double(g), Double(b), Double(a))
        #elseif canImport(AppKit)
        let nsColor = NSColor(color)
        guard let sRGB = nsColor.usingColorSpace(.sRGB) else { return nil }
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        sRGB.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
        #else
        return nil
        #endif
    }

    private static func srgbToLinear(_ value: Double) -> Double {
        if value <= 0.04045 { return value / 12.92 }
        return pow((value + 0.055) / 1.055, 2.4)
    }

    private static func normalizeHue(_ hue: Double) -> Double {
        let wrapped = hue.truncatingRemainder(dividingBy: 360)
        return wrapped < 0 ? wrapped + 360 : wrapped
    }
}
