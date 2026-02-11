import Testing
import SwiftUI
#if canImport(AppKit)
import AppKit
#endif
@testable import TailwindSwiftUI

@MainActor
@Suite("NativeWind Parity Pixel Proof")
struct NativeWindParityPixelProofTests {

    @Test func solidBackgroundColorRendersExpectedPixel() {
        let view = Color.clear
            .tw("bg-blue-500")
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for solid background color pixel proof")
            return
        }

        #expect(isClose(center, to: (43, 127, 255), tolerance: 28))
    }

    @Test func slashOpacityBackgroundRendersSemiTransparentPixel() {
        let view = ZStack {
            Color.white
            Color.clear.tw("bg-blue-500/50")
        }
        .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for slash-opacity pixel proof")
            return
        }

        // Blue over white @50% should be lighter than full blue and not white.
        #expect(center.b > center.r)
        #expect(center.r > 120)
        #expect(center.g > 150)
    }

    @Test func v4LinearGradientPipelineRendersDirectionEndpoints() {
        let view = Color.clear
            .tw("bg-linear-to-r from-red-500 to-blue-500")
            .frame(width: 64, height: 32)

        guard let image = renderImage(view, width: 64, height: 32),
              let left = pixel(image, x: 2, y: 16),
              let right = pixel(image, x: 61, y: 16) else {
            #expect(Bool(false), "Failed to render image for v4 linear gradient pixel proof")
            return
        }

        #expect(!isClose(left, to: (255, 255, 255), tolerance: 8))
        #expect(!isClose(right, to: (255, 255, 255), tolerance: 8))
        let dr = abs(Int(left.r) - Int(right.r))
        let dg = abs(Int(left.g) - Int(right.g))
        let db = abs(Int(left.b) - Int(right.b))
        #expect((dr + dg + db) > 30)
    }

    @Test func ringOffsetIncreasesRingPixelCoverage() {
        let withoutOffset = Color.clear
            .tw("ring-2 ring-blue-500")
            .frame(width: 48, height: 48)
        let withOffset = Color.clear
            .tw("ring-2 ring-offset-4 ring-blue-500")
            .frame(width: 48, height: 48)

        guard let a = renderImage(withoutOffset, width: 48, height: 48),
              let b = renderImage(withOffset, width: 48, height: 48) else {
            #expect(Bool(false), "Failed to render images for ring-offset pixel proof")
            return
        }

        let baseBlue = countPixelsNear(a, target: (43, 127, 255), tolerance: 30)
        let offsetBlue = countPixelsNear(b, target: (43, 127, 255), tolerance: 30)
        #expect(offsetBlue > baseBlue, "Expected ring-offset to increase blue ring pixel coverage")
    }

    private typealias RGBA = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)

    private func renderImage<V: View>(_ view: V, width: CGFloat, height: CGFloat) -> CGImage? {
        #if canImport(AppKit)
        let renderer = ImageRenderer(content: view.frame(width: width, height: height))
        renderer.scale = 1
        guard let nsImage = renderer.nsImage else { return nil }
        guard let tiff = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff) else { return nil }
        return bitmap.cgImage
        #else
        return nil
        #endif
    }

    private func pixel(_ image: CGImage, x: Int, y: Int) -> RGBA? {
        guard x >= 0, y >= 0, x < image.width, y < image.height else { return nil }
        guard let provider = image.dataProvider, let data = provider.data else { return nil }
        let bytes = CFDataGetBytePtr(data)
        let bytesPerPixel = image.bitsPerPixel / 8
        let bytesPerRow = image.bytesPerRow
        let offset = y * bytesPerRow + x * bytesPerPixel
        guard let ptr = bytes else { return nil }
        return (ptr[offset], ptr[offset + 1], ptr[offset + 2], ptr[offset + 3])
    }

    private func isClose(_ actual: RGBA, to expected: (UInt8, UInt8, UInt8), tolerance: Int) -> Bool {
        abs(Int(actual.r) - Int(expected.0)) <= tolerance &&
        abs(Int(actual.g) - Int(expected.1)) <= tolerance &&
        abs(Int(actual.b) - Int(expected.2)) <= tolerance
    }

    private func countPixelsNear(_ image: CGImage, target: (UInt8, UInt8, UInt8), tolerance: Int) -> Int {
        var count = 0
        for y in 0..<image.height {
            for x in 0..<image.width {
                guard let px = pixel(image, x: x, y: y) else { continue }
                if isClose(px, to: target, tolerance: tolerance) {
                    count += 1
                }
            }
        }
        return count
    }
}
