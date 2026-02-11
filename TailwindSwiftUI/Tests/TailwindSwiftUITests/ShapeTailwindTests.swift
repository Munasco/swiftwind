import Testing
import SwiftUI
#if canImport(AppKit)
import AppKit
#endif
@testable import TailwindSwiftUI

// MARK: - Shape Tailwind
@Suite("Shape Tailwind")
@MainActor
struct ShapeTailwindTests {
    private struct WaveShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control1: CGPoint(x: rect.width * 0.25, y: rect.minY),
                control2: CGPoint(x: rect.width * 0.75, y: rect.maxY)
            )
            return path
        }
    }

    @Test func parseShapeClassesExtractsFillStrokeAndRemainder() {
        let parsed = TailwindShapeModifier<Circle>.parseShapeClasses(
            "fill-red-500 stroke-blue-500 stroke-2 w-24 h-24 shadow-lg"
        )

        #expect(parsed.fillColor != nil)
        #expect(parsed.strokeColor != nil)
        #expect(parsed.strokeWidth == 2)
        #expect(parsed.remainingClasses == ["w-24", "h-24", "shadow-lg"])
    }

    @Test func parseShapeClassesSupportsNoneAndArbitraryStrokeWidth() {
        let parsed = TailwindShapeModifier<Circle>.parseShapeClasses(
            "fill-none stroke-none stroke-[3px]"
        )

        #expect(parsed.fillNone)
        #expect(parsed.fillColor != nil)
        #expect(parsed.strokeNone)
        #expect(parsed.strokeWidth == 3)
    }

    @Test func shapeTwDoesNotCrash() {
        _ = Circle().tw("fill-emerald-400 stroke-white stroke-2 size-16")
        _ = RoundedRectangle(cornerRadius: 8).tw("fill-[#1da1f2] stroke-none w-24 h-12")
    }

    @Test func customPathShapeTwDoesNotCrash() {
        _ = WaveShape().tw("fill-blue-500 stroke-white stroke-2 w-24 h-12 shadow-md")
    }

    @Test func shapeTwThenPaddingDoesNotCrash() {
        _ = WaveShape()
            .tw("fill-red-500 stroke-blue-500 stroke-2")
            .padding()
    }

    @Test func paddingThenShapeTwCompilesAndDoesNotCrash() {
        _ = WaveShape()
            .padding()
            .tw("fill-red-500 stroke-blue-500 stroke-2")
    }

    @Test func parseShapeClassesLeavesNonShapeUtilitiesForViewPipeline() {
        let parsed = TailwindShapeModifier<WaveShape>.parseShapeClasses(
            "fill-red-500 stroke-blue-500 stroke-2 p-4 bg-black rounded-lg"
        )

        #expect(parsed.fillColor != nil)
        #expect(parsed.strokeColor != nil)
        #expect(parsed.strokeWidth == 2)
        #expect(parsed.remainingClasses == ["p-4", "bg-black", "rounded-lg"])
    }

    @Test func renderedShapeContainsExpectedFillColor() {
        let view = Rectangle()
            .tw("fill-red-500")
            .frame(width: 48, height: 48)

        guard let cgImage = renderImage(view, width: 48, height: 48),
              let center = pixel(cgImage, x: 24, y: 24) else {
            #expect(Bool(false), "Failed to render shape image for color assertion")
            return
        }

        #expect(isClose(center, to: (251, 44, 54), tolerance: 18))
    }

    @Test func renderedShapeContainsExpectedStrokeColor() {
        let view = Rectangle()
            .tw("fill-red-500 stroke-blue-500 stroke-4")
            .frame(width: 64, height: 64)

        guard let cgImage = renderImage(view, width: 64, height: 64),
              let center = pixel(cgImage, x: 32, y: 32) else {
            #expect(Bool(false), "Failed to render shape image for stroke assertion")
            return
        }

        // center should remain fill red; image should contain some blue stroke pixels.
        #expect(isClose(center, to: (251, 44, 54), tolerance: 20))
        #expect(countPixelsNear(cgImage, target: (43, 127, 255), tolerance: 28) > 0)
    }

    @Test func roundedBorderOverlayUsesRoundedCorners() {
        let view = Text("Edit")
            .tw("px-4 py-2 bg-transparent text-blue-400 rounded-md font-semibold border-2 border-blue-500")
            .frame(width: 120, height: 48)

        guard let image = renderImage(view, width: 120, height: 48),
              let nearCorner = pixel(image, x: 2, y: 2) else {
            #expect(Bool(false), "Failed to render image for rounded border overlay assertion")
            return
        }

        // With rounded-md, border should not paint hard square corner pixels.
        #expect(!isClose(nearCorner, to: (43, 127, 255), tolerance: 40))
    }

    @Test func directTwChainingMergesIntoSingleEffectivePadding() {
        let chained = Text("X")
            .tw("p-4 bg-red-500")
            .tw("p-2")
            .frame(width: 120, height: 48)

        let merged = Text("X")
            .tw("p-4 bg-red-500 p-2")
            .frame(width: 120, height: 48)

        guard let chainedImage = renderImage(chained, width: 120, height: 48),
              let mergedImage = renderImage(merged, width: 120, height: 48) else {
            #expect(Bool(false), "Failed to render images for direct .tw chaining merge assertion")
            return
        }

        let chainedRedCount = countPixelsNear(chainedImage, target: (251, 44, 54), tolerance: 26)
        let mergedRedCount = countPixelsNear(mergedImage, target: (251, 44, 54), tolerance: 26)

        #expect(abs(chainedRedCount - mergedRedCount) < 25)
    }

    @Test func directTwChainingUsesFinalRoundedClass() {
        let chained = Color.clear
            .tw("w-80 h-32 bg-red-500 rounded-3xl")
            .tw("rounded-xl")
            .frame(width: 320, height: 128)

        let merged = Color.clear
            .tw("w-80 h-32 bg-red-500 rounded-xl")
            .frame(width: 320, height: 128)

        guard let chainedImage = renderImage(chained, width: 320, height: 128),
              let mergedImage = renderImage(merged, width: 320, height: 128) else {
            #expect(Bool(false), "Failed to render images for rounded conflict assertion")
            return
        }

        let chainedRedCount = countPixelsNear(chainedImage, target: (251, 44, 54), tolerance: 20)
        let mergedRedCount = countPixelsNear(mergedImage, target: (251, 44, 54), tolerance: 20)
        #expect(abs(chainedRedCount - mergedRedCount) < 60)
    }

    @Test func multilineTwBuilderSupportsConditionals() {
        let isPrimary = true
        let view = Color.clear
            .tw {
                "bg-blue-500"
                if isPrimary {
                    "bg-red-500"
                } else {
                    "bg-emerald-500"
                }
            }
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for multiline conditional builder assertion")
            return
        }

        #expect(isClose(center, to: (251, 44, 54), tolerance: 24))
    }

    @Test func multilineTwBuilderMatchesSingleStringCascade() {
        let built = Color.clear
            .tw {
                "bg-blue-500"
                "dark:bg-red-500"
            }
            .environment(\.colorScheme, .dark)
            .frame(width: 40, height: 40)

        let single = Color.clear
            .tw("bg-blue-500 dark:bg-red-500")
            .environment(\.colorScheme, .dark)
            .frame(width: 40, height: 40)

        guard let builtImage = renderImage(built, width: 40, height: 40),
              let builtCenter = pixel(builtImage, x: 20, y: 20),
              let singleImage = renderImage(single, width: 40, height: 40),
              let singleCenter = pixel(singleImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render images for multiline/single cascade equivalence assertion")
            return
        }

        #expect(isClose(builtCenter, to: (251, 44, 54), tolerance: 24))
        #expect(isClose(singleCenter, to: (251, 44, 54), tolerance: 24))
    }

    @Test func parentAndChildTwRemainIndependentAcrossHierarchy() {
        let view = VStack(spacing: 0) {
            Color.clear
                .tw("bg-red-500")
                .frame(width: 40, height: 20)
        }
        .frame(width: 40, height: 40)
        .tw("bg-blue-500")

        guard let image = renderImage(view, width: 40, height: 40),
              let top = pixel(image, x: 20, y: 10),
              let bottom = pixel(image, x: 20, y: 30) else {
            #expect(Bool(false), "Failed to render image for parent/child tw hierarchy assertion")
            return
        }

        // Child tw should still apply at top, parent tw should still apply for remaining area.
        #expect(isClose(top, to: (251, 44, 54), tolerance: 24))
        #expect(isClose(bottom, to: (43, 127, 255), tolerance: 24))
    }

    @Test func twAppliedAfterPaddingDoesNotApplyShapePaint() {
        let view = Rectangle()
            .foregroundStyle(.green)
            .padding()
            .tw("fill-red-500 stroke-blue-500 stroke-2")
            .frame(width: 80, height: 80)

        guard let cgImage = renderImage(view, width: 80, height: 80),
              let center = pixel(cgImage, x: 40, y: 40) else {
            #expect(Bool(false), "Failed to render shape image for ordering assertion")
            return
        }

        // Since .tw is called after the shape became a generic View, shape paint classes are not applied.
        // The center should stay close to the original green, not Tailwind red.
        #expect(isClose(center, to: (52, 199, 89), tolerance: 28))
        #expect(!isClose(center, to: (251, 44, 54), tolerance: 24))
    }

    @Test func foregroundStyleAfterTwDoesNotOverrideExplicitShapePaint() {
        let view = Rectangle()
            .tw("fill-red-500 stroke-blue-500 stroke-4")
            .foregroundStyle(.green)
            .frame(width: 64, height: 64)

        guard let cgImage = renderImage(view, width: 64, height: 64),
              let center = pixel(cgImage, x: 32, y: 32) else {
            #expect(Bool(false), "Failed to render shape image for foregroundStyle ordering assertion")
            return
        }

        // tw applies explicit fill/stroke colors, which should remain even if foregroundStyle comes after.
        #expect(isClose(center, to: (251, 44, 54), tolerance: 20))
        #expect(!isClose(center, to: (52, 199, 89), tolerance: 24))
    }

    @Test func containerFillInheritanceAppliesToMultipleChildShapes() {
        let view = VStack(spacing: 0) {
            Rectangle()
            Rectangle()
        }
        .tw("fill-red-500")
        .frame(width: 60, height: 60)

        guard let cgImage = renderImage(view, width: 60, height: 60),
              let topCenter = pixel(cgImage, x: 30, y: 15),
              let bottomCenter = pixel(cgImage, x: 30, y: 45) else {
            #expect(Bool(false), "Failed to render image for container fill inheritance")
            return
        }

        #expect(isClose(topCenter, to: (251, 44, 54), tolerance: 20))
        #expect(isClose(bottomCenter, to: (251, 44, 54), tolerance: 20))
    }

    @Test func arbitraryLinearGradientBackgroundRendersPaintedDistinctEndpoints() {
        let view = Color.clear
            .tw("bg-[linear-gradient(to_right,#fb2c36,#2b7fff)]")
            .frame(width: 64, height: 32)

        guard let cgImage = renderImage(view, width: 64, height: 32),
              let left = pixel(cgImage, x: 2, y: 16),
              let right = pixel(cgImage, x: 61, y: 16) else {
            #expect(Bool(false), "Failed to render image for arbitrary linear-gradient assertion")
            return
        }

        #expect(!isClose(left, to: (255, 255, 255), tolerance: 8))
        #expect(!isClose(right, to: (255, 255, 255), tolerance: 8))
        let dr = abs(Int(left.r) - Int(right.r))
        let dg = abs(Int(left.g) - Int(right.g))
        let db = abs(Int(left.b) - Int(right.b))
        #expect((dr + dg + db) > 30)
    }

    @Test func arbitraryImageLinearGradientBackgroundRendersPaintedDistinctEndpoints() {
        let view = Color.clear
            .tw("bg-[image:linear-gradient(to_right,#fb2c36,#2b7fff)]")
            .frame(width: 64, height: 32)

        guard let cgImage = renderImage(view, width: 64, height: 32),
              let left = pixel(cgImage, x: 2, y: 16),
              let right = pixel(cgImage, x: 61, y: 16) else {
            #expect(Bool(false), "Failed to render image for arbitrary image linear-gradient assertion")
            return
        }

        #expect(!isClose(left, to: (255, 255, 255), tolerance: 8))
        #expect(!isClose(right, to: (255, 255, 255), tolerance: 8))
        let dr = abs(Int(left.r) - Int(right.r))
        let dg = abs(Int(left.g) - Int(right.g))
        let db = abs(Int(left.b) - Int(right.b))
        #expect((dr + dg + db) > 30)
    }

    @Test func arbitraryOKLCHLinearGradientBackgroundRendersDistinctEndpoints() {
        let view = Color.clear
            .tw("bg-[linear-gradient(to_right,oklch(62.3%_0.214_259.815),oklch(72.3%_0.18_160))]")
            .frame(width: 64, height: 32)

        guard let cgImage = renderImage(view, width: 64, height: 32),
              let left = pixel(cgImage, x: 2, y: 16),
              let right = pixel(cgImage, x: 61, y: 16) else {
            #expect(Bool(false), "Failed to render image for arbitrary OKLCH linear-gradient assertion")
            return
        }

        // Ensure both sides are painted and gradient endpoints are meaningfully different.
        #expect(!isClose(left, to: (255, 255, 255), tolerance: 8))
        #expect(!isClose(right, to: (255, 255, 255), tolerance: 8))
        let dr = abs(Int(left.r) - Int(right.r))
        let dg = abs(Int(left.g) - Int(right.g))
        let db = abs(Int(left.b) - Int(right.b))
        let channelDelta = dr + dg + db
        #expect(channelDelta > 30)
    }

    @Test func linearGradientInitializerSupportsOKLCHInterpolationMode() {
        let view = Rectangle()
            .fill(
                LinearGradient(
                    colors: [.red500, .blue500],
                    startPoint: .leading,
                    endPoint: .trailing,
                    interpolation: .oklch
                )
            )
            .frame(width: 64, height: 32)

        guard let cgImage = renderImage(view, width: 64, height: 32),
              let left = pixel(cgImage, x: 2, y: 16),
              let right = pixel(cgImage, x: 61, y: 16) else {
            #expect(Bool(false), "Failed to render image for OKLCH initializer gradient assertion")
            return
        }

        #expect(!isClose(left, to: (255, 255, 255), tolerance: 8))
        #expect(!isClose(right, to: (255, 255, 255), tolerance: 8))
        let dr = abs(Int(left.r) - Int(right.r))
        let dg = abs(Int(left.g) - Int(right.g))
        let db = abs(Int(left.b) - Int(right.b))
        #expect((dr + dg + db) > 30)
    }

    @Test func childShapeTwCanInheritContainerStroke() {
        let view = VStack(spacing: 0) {
            Rectangle().tw("")
        }
        .tw("fill-red-500 stroke-blue-500 stroke-4")
        .frame(width: 64, height: 64)

        guard let cgImage = renderImage(view, width: 64, height: 64),
              let center = pixel(cgImage, x: 32, y: 32) else {
            #expect(Bool(false), "Failed to render image for inherited stroke assertion")
            return
        }

        #expect(isClose(center, to: (251, 44, 54), tolerance: 20))
        #expect(countPixelsNear(cgImage, target: (43, 127, 255), tolerance: 28) > 0)
    }

    @Test func childShapeFillOverridesContainerFillInheritance() {
        let view = VStack(spacing: 0) {
            Rectangle().tw("fill-green-500")
        }
        .tw("fill-red-500")
        .frame(width: 60, height: 60)

        guard let cgImage = renderImage(view, width: 60, height: 60),
              let center = pixel(cgImage, x: 30, y: 30) else {
            #expect(Bool(false), "Failed to render image for override assertion")
            return
        }

        #expect(isClose(center, to: (0, 201, 80), tolerance: 26))
        #expect(!isClose(center, to: (251, 44, 54), tolerance: 24))
    }

    @Test func arbitraryBackgroundImageUrlDoesNotCrash() {
        _ = Text("A")
            .tw("bg-[url(https://example.com/bg.png)] p-2")
    }

    @Test func arbitraryBackgroundVarDoesNotCrash() {
        _ = Text("A")
            .tw("bg-[var(--color-brand-bg)] p-2")
    }

    @Test func arbitraryImageVarSyntaxDoesNotCrash() {
        _ = Text("A")
            .tw("bg-[image:var(--hero-image)] p-2")
    }

    @Test func animateBuiltinsDoNotCrash() {
        _ = Text("A")
            .tw("animate-spin")
        _ = Text("B")
            .tw("animate-ping")
        _ = Text("C")
            .tw("animate-pulse")
        _ = Text("D")
            .tw("animate-bounce")
    }

    @Test func animateArbitraryDefinitionDoesNotCrash() {
        _ = Text("A")
            .tw("animate-[spin_750ms_linear_infinite]")
        _ = Text("B")
            .tw("animate-[pulse_2s_ease-in-out_infinite]")
    }

    @Test func animateVariableDefinitionResolvesFromRuntimeVar() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeVariables([
            "--animate-wiggle": .animate(light: "bounce 0.5s ease-in-out infinite"),
        ])
        defer { TailwindSwiftUI.reset() }

        _ = Text("A")
            .tw("animate-(--animate-wiggle)")
    }

    @Test func initializeVarsResolvesBackgroundVarClass() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: ["--color-brand-bg": "blue"])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-var(--color-brand-bg)")
            .frame(width: 40, height: 40)

        guard let cgImage = renderImage(view, width: 40, height: 40),
              let center = pixel(cgImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for background var initializer assertion")
            return
        }

        #expect(isClose(center, to: (43, 127, 255), tolerance: 24))
    }

    @Test func initializeVarsResolvesTailwindBracketVarSyntax() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: ["--color-brand-bg": "blue-500"])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-[var(--color-brand-bg)]")
            .frame(width: 40, height: 40)

        guard let cgImage = renderImage(view, width: 40, height: 40),
              let center = pixel(cgImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for Tailwind bracket var syntax assertion")
            return
        }

        #expect(isClose(center, to: (43, 127, 255), tolerance: 24))
    }

    @Test func initializeVarsResolvesTailwindShorthandVarSyntax() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: ["--color-brand-bg": "rose-500", "--color-shape-fill": "emerald-500"])
        defer { TailwindSwiftUI.reset() }

        let backgroundView = Color.clear
            .tw("bg-(--color-brand-bg)")
            .frame(width: 40, height: 40)

        let shapeView = Rectangle()
            .tw("fill-(--color-shape-fill)")
            .frame(width: 40, height: 40)

        guard let bgImage = renderImage(backgroundView, width: 40, height: 40),
              let bgCenter = pixel(bgImage, x: 20, y: 20),
              let shapeImage = renderImage(shapeView, width: 40, height: 40),
              let shapeCenter = pixel(shapeImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for Tailwind shorthand var syntax assertion")
            return
        }

        #expect(isClose(bgCenter, to: (255, 32, 86), tolerance: 28))
        #expect(isClose(shapeCenter, to: (0, 188, 125), tolerance: 28))
    }

    @Test func initializeVarsResolvesShapeFillVarClass() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: ["--color-shape-fill": "emerald-500"])
        defer { TailwindSwiftUI.reset() }

        let view = Rectangle()
            .tw("fill-var(--color-shape-fill)")
            .frame(width: 40, height: 40)

        guard let cgImage = renderImage(view, width: 40, height: 40),
              let center = pixel(cgImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for shape fill var initializer assertion")
            return
        }

        #expect(isClose(center, to: (0, 188, 125), tolerance: 28))
    }

    @Test func initializeUtilitiesAliasExpandsWithVars() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(
            vars: ["--color-brand-bg": "rose-500"],
            utilities: ["card-bg": "bg-var(--color-brand-bg) p-2"]
        )
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("card-bg")
            .frame(width: 40, height: 40)

        guard let cgImage = renderImage(view, width: 40, height: 40),
              let center = pixel(cgImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for utility alias + vars assertion")
            return
        }

        #expect(isClose(center, to: (255, 32, 86), tolerance: 28))
    }

    @Test func initializeDarkVarsOverrideLightVarsInDarkMode() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(
            vars: ["--color-brand-bg": "blue-500"],
            darkVars: ["--color-brand-bg": "red-500"]
        )
        defer { TailwindSwiftUI.reset() }

        let base = Color.clear
            .tw("bg-var(--color-brand-bg)")
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(base.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(base.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render light/dark images for var override assertion")
            return
        }

        #expect(isClose(lightCenter, to: (43, 127, 255), tolerance: 24))
        #expect(isClose(darkCenter, to: (251, 44, 54), tolerance: 24))
    }

    @Test func initializeDarkVarsApplyToShapeFillVarInDarkMode() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(
            vars: ["--color-shape-fill": "emerald-500"],
            darkVars: ["--color-shape-fill": "amber-500"]
        )
        defer { TailwindSwiftUI.reset() }

        let base = Rectangle()
            .tw("fill-var(--color-shape-fill)")
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(base.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(base.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render light/dark shape images for var override assertion")
            return
        }

        #expect(isClose(lightCenter, to: (0, 188, 125), tolerance: 28))
        #expect(isClose(darkCenter, to: (255, 176, 0), tolerance: 30))
    }

    @Test func initializeUtilitiesAliasRecursivelyExpands() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(
            vars: ["--color-brand-bg": "rose-500"],
            utilities: [
                "card-bg": "bg-var(--color-brand-bg) p-2",
                "card-shell": "card-bg rounded-lg"
            ]
        )
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("card-shell")
            .frame(width: 40, height: 40)

        guard let cgImage = renderImage(view, width: 40, height: 40),
              let center = pixel(cgImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for recursive utility alias assertion")
            return
        }

        #expect(isClose(center, to: (255, 32, 86), tolerance: 28))
    }

    @Test func initializeDslColorSupportsLightDark() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: [
            "--color-brand-bg": .color(light: .blue500, dark: .red500),
        ])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-(--color-brand-bg)")
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(view.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(view.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for DSL light/dark var assertion")
            return
        }

        #expect(isClose(lightCenter, to: (43, 127, 255), tolerance: 24))
        #expect(isClose(darkCenter, to: (251, 44, 54), tolerance: 24))
    }

    @Test func initializeDslReferenceCanPointToEarlierVar() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: [
            "--color-brand-bg": .color(light: .blue500, dark: .red500),
            "--color-card-bg": .reference(light: "--color-brand-bg"),
        ])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-(--color-card-bg)")
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(view.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(view.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for DSL reference var assertion")
            return
        }

        #expect(isClose(lightCenter, to: (43, 127, 255), tolerance: 24))
        #expect(isClose(darkCenter, to: (251, 44, 54), tolerance: 24))
    }

    @Test func initializeDslReferenceCanUseTailwindColorVariable() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: [
            "--color-accent": .reference(light: "--color-emerald-500"),
            "--color-accent-dark": .reference(light: "--color-red-500"),
        ])
        defer { TailwindSwiftUI.reset() }

        let lightView = Color.clear
            .tw("bg-(--color-accent)")
            .frame(width: 40, height: 40)
        let darkView = Color.clear
            .tw("bg-(--color-accent-dark)")
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(lightView, width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(darkView, width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for Tailwind color variable reference assertion")
            return
        }

        #expect(isClose(lightCenter, to: (0, 188, 125), tolerance: 28))
        #expect(isClose(darkCenter, to: (251, 44, 54), tolerance: 24))
    }

    @Test func initializeDslThemeColorTypeResolves() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: [
            "--color-brand-bg": .color(light: "blue-500", dark: "yellow-500"),
        ])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-(--color-brand-bg)")
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(view.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(view.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for theme(.color) assertion")
            return
        }

        #expect(isClose(lightCenter, to: (43, 127, 255), tolerance: 24))
        #expect(isClose(darkCenter, to: (255, 176, 0), tolerance: 30))
    }

    @Test func initializeDslRawCssColorResolves() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: [
            "--color-brand-bg": .rawCss(light: "var(--color-rose-500)", cssProperty: .backgroundColor),
        ])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-(--color-brand-bg)")
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for rawCss background-color assertion")
            return
        }

        #expect(isClose(center, to: (255, 32, 86), tolerance: 28))
    }

    @Test func initializeDslRawCssNonColorDoesNotResolveIntoColorContext() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initialize(vars: [
            "--color-brand-bg": .rawCss(light: "20rem", cssProperty: "width"),
        ])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-(--color-brand-bg)")
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for rawCss non-color assertion")
            return
        }

        // No resolvable bg color should be applied; keep white canvas.
        #expect(isClose(center, to: (255, 255, 255), tolerance: 8))
    }

    @Test func darkVariantAppliesOnlyInDarkMode() {
        let view = Color.clear
            .tw("dark:bg-red-500")
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(view.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(view.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for dark variant assertion")
            return
        }

        // Light mode keeps white test canvas, dark mode applies red background.
        #expect(isClose(lightCenter, to: (255, 255, 255), tolerance: 8))
        #expect(isClose(darkCenter, to: (251, 44, 54), tolerance: 24))
    }

    @Test func darkVariantOverridesBaseColorRegardlessOfInputOrder() {
        let first = Color.clear
            .tw("bg-blue-500 dark:bg-red-500")
            .environment(\.colorScheme, .dark)
            .frame(width: 40, height: 40)

        let second = Color.clear
            .tw("dark:bg-red-500 bg-blue-500")
            .environment(\.colorScheme, .dark)
            .frame(width: 40, height: 40)

        guard let firstImage = renderImage(first, width: 40, height: 40),
              let firstCenter = pixel(firstImage, x: 20, y: 20),
              let secondImage = renderImage(second, width: 40, height: 40),
              let secondCenter = pixel(secondImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for dark precedence assertion")
            return
        }

        #expect(isClose(firstCenter, to: (251, 44, 54), tolerance: 24))
        #expect(isClose(secondCenter, to: (251, 44, 54), tolerance: 24))
    }

    @Test func darkVariantBeatsLaterBaseBackgroundDueToSpecificity() {
        let view = Color.clear
            .tw("dark:bg-red-500 bg-blue-500")
            .environment(\.colorScheme, .dark)
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for dark specificity precedence assertion")
            return
        }

        #expect(isClose(center, to: (251, 44, 54), tolerance: 24))
    }

    @Test func focusVariantDoesNotApplyWhenNotFocused() {
        let view = Color.clear
            .tw("focus:bg-red-500")
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for focus variant assertion")
            return
        }

        #expect(isClose(center, to: (255, 255, 255), tolerance: 8))
    }

    @Test func activeVariantCompilesAndDoesNotCrash() {
        _ = Color.clear
            .tw("active:bg-red-500")
            .frame(width: 40, height: 40)
    }

    @Test func groupActiveAndPeerActiveVariantsCompileAndDoNotCrash() {
        _ = VStack(spacing: 0) {
            Color.clear
                .tw("group-active:bg-red-500")
                .frame(width: 40, height: 20)
            Color.clear
                .tw("peer/default")
                .frame(width: 40, height: 10)
            Color.clear
                .tw("peer-active/default:bg-blue-500")
                .frame(width: 40, height: 10)
        }
        .tw("group")
        .twPeerScope()
        .frame(width: 40, height: 40)
    }

    @Test func groupDarkVariantAppliesToDescendantInDarkMode() {
        let view = VStack(spacing: 0) {
            Color.clear
                .tw("group-dark:bg-red-500")
                .frame(width: 40, height: 40)
        }
        .tw("group")
        .frame(width: 40, height: 40)

        guard let lightImage = renderImage(view.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(view.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for group-dark assertion")
            return
        }

        #expect(isClose(lightCenter, to: (255, 255, 255), tolerance: 8))
        #expect(isClose(darkCenter, to: (251, 44, 54), tolerance: 24))
    }

    @Test func peerDarkVariantAppliesWithPeerScope() {
        let view = VStack(spacing: 0) {
            Color.clear
                .tw("peer/email")
                .frame(width: 40, height: 20)
            Color.clear
                .tw("peer-dark/email:bg-red-500")
                .frame(width: 40, height: 20)
        }
        .twPeerScope()
        .frame(width: 40, height: 40)

        guard let lightImage = renderImage(view.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightBottom = pixel(lightImage, x: 20, y: 30),
              let darkImage = renderImage(view.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkBottom = pixel(darkImage, x: 20, y: 30) else {
            #expect(Bool(false), "Failed to render image for peer-dark assertion")
            return
        }

        #expect(isClose(lightBottom, to: (255, 255, 255), tolerance: 8))
        #expect(isClose(darkBottom, to: (251, 44, 54), tolerance: 24))
    }

    @Test func responsiveMdBreakpointComparatorWorks() {
        #expect(TailwindModifier<Color>.matchesResponsiveBreakpoint("md", width: 700) == false)
        #expect(TailwindModifier<Color>.matchesResponsiveBreakpoint("md", width: 900) == true)
    }

    @Test func platformVariantAppliesOnlyOnMatchingPlatform() {
        let iosView = Color.clear
            .tw("ios:bg-red-500")
            .frame(width: 40, height: 40)
        let macView = Color.clear
            .tw("macos:bg-red-500")
            .frame(width: 40, height: 40)

        guard let iosImage = renderImage(iosView, width: 40, height: 40),
              let iosCenter = pixel(iosImage, x: 20, y: 20),
              let macImage = renderImage(macView, width: 40, height: 40),
              let macCenter = pixel(macImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for platform variant assertion")
            return
        }

        #if os(macOS)
        #expect(isClose(iosCenter, to: (255, 255, 255), tolerance: 8))
        #expect(isClose(macCenter, to: (251, 44, 54), tolerance: 24))
        #elseif os(iOS)
        #expect(isClose(iosCenter, to: (251, 44, 54), tolerance: 24))
        #expect(isClose(macCenter, to: (255, 255, 255), tolerance: 8))
        #else
        #expect(isClose(iosCenter, to: (255, 255, 255), tolerance: 8))
        #expect(isClose(macCenter, to: (255, 255, 255), tolerance: 8))
        #endif
    }

    @Test func platformVariantCanChainWithDarkVariant() {
        let view = Color.clear
            .tw("dark:macos:bg-red-500")
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(view.environment(\.colorScheme, .light), width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(view.environment(\.colorScheme, .dark), width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for chained platform variant assertion")
            return
        }

        #if os(macOS)
        #expect(isClose(lightCenter, to: (255, 255, 255), tolerance: 8))
        #expect(isClose(darkCenter, to: (251, 44, 54), tolerance: 24))
        #else
        #expect(isClose(lightCenter, to: (255, 255, 255), tolerance: 8))
        #expect(isClose(darkCenter, to: (255, 255, 255), tolerance: 8))
        #endif
    }

    @Test func initializeVariablesAndUtilitiesCanBeCalledSeparately() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeVariables([
            "--color-brand-bg": .color(light: .rose500),
        ])
        TailwindSwiftUI.initializeUtilities([
            "card": "bg-(--color-brand-bg) p-2",
        ])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("card")
            .frame(width: 40, height: 40)

        guard let cgImage = renderImage(view, width: 40, height: 40),
              let center = pixel(cgImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for split initialize vars/utilities assertion")
            return
        }

        #expect(isClose(center, to: (255, 32, 86), tolerance: 28))
    }

    @Test func initializeDefaultThemeVariablesSeedsPaletteTokens() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeDefaultThemeVariables()
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-[var(--color-blue-500)]")
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for default theme variables assertion")
            return
        }

        #expect(isClose(center, to: (43, 127, 255), tolerance: 24))
    }

    @Test func initializeDefaultThemeVariablesSeedsMutedSemanticToken() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeDefaultThemeVariables()
        defer { TailwindSwiftUI.reset() }

        let lightView = Color.clear
            .tw("bg-muted")
            .frame(width: 40, height: 40)
        let darkView = Color.clear
            .tw("bg-muted")
            .environment(\.colorScheme, .dark)
            .frame(width: 40, height: 40)

        guard let lightImage = renderImage(lightView, width: 40, height: 40),
              let lightCenter = pixel(lightImage, x: 20, y: 20),
              let darkImage = renderImage(darkView, width: 40, height: 40),
              let darkCenter = pixel(darkImage, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for muted semantic token assertion")
            return
        }

        // slate-100 (light) and slate-800 (dark)
        #expect(isClose(lightCenter, to: (241, 245, 249), tolerance: 18))
        #expect(isClose(darkCenter, to: (29, 41, 61), tolerance: 18))
    }

    @Test func initializeVariablesLabeledPlatformsPrefersCurrentPlatform() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeVariables(
            default: [
                "--color-brand": .color(light: .yellow500),
            ],
            iOS: [
                "--color-brand": .color(light: .emerald500),
            ],
            macOS: [
                "--color-brand": .color(light: .red500),
            ]
        )
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-(--color-brand)")
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for platform var merge assertion")
            return
        }

        #if os(macOS)
        #expect(isClose(center, to: (251, 44, 54), tolerance: 24))
        #elseif os(iOS)
        #expect(isClose(center, to: (0, 188, 125), tolerance: 28))
        #else
        #expect(isClose(center, to: (43, 127, 255), tolerance: 24))
        #endif
    }

    @Test func initializeVariablesForPlatformSpecificHelperOnlyAppliesOnMatch() {
        TailwindSwiftUI.reset()
        TailwindSwiftUI.initializeVariablesForiOS([
            "--color-brand": .color(light: .emerald500),
        ])
        TailwindSwiftUI.initializeVariablesFormacOS([
            "--color-brand": .color(light: .red500),
        ])
        defer { TailwindSwiftUI.reset() }

        let view = Color.clear
            .tw("bg-(--color-brand)")
            .frame(width: 40, height: 40)

        guard let image = renderImage(view, width: 40, height: 40),
              let center = pixel(image, x: 20, y: 20) else {
            #expect(Bool(false), "Failed to render image for platform-specific helper assertion")
            return
        }

        #if os(macOS)
        #expect(isClose(center, to: (251, 44, 54), tolerance: 24))
        #elseif os(iOS)
        #expect(isClose(center, to: (0, 188, 125), tolerance: 28))
        #else
        #expect(isClose(center, to: (255, 255, 255), tolerance: 8))
        #endif
    }

    // MARK: - Image Sampling Helpers
    private typealias RGBA = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)

    @MainActor
    private func renderImage<V: View>(_ view: V, width: CGFloat, height: CGFloat) -> CGImage? {
        #if canImport(AppKit)
        let renderer = ImageRenderer(
            content: view
                .frame(width: width, height: height)
                .background(Color.white)
        )
        renderer.scale = 1
        guard let nsImage = renderer.nsImage else { return nil }
        var rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        return nsImage.cgImage(forProposedRect: &rect, context: nil, hints: nil)
        #else
        return nil
        #endif
    }

    private func pixel(_ image: CGImage, x: Int, y: Int) -> RGBA? {
        guard x >= 0, y >= 0, x < image.width, y < image.height,
              let providerData = image.dataProvider?.data,
              let data = CFDataGetBytePtr(providerData) else { return nil }

        let bytesPerPixel = image.bitsPerPixel / 8
        let bytesPerRow = image.bytesPerRow
        let offset = y * bytesPerRow + x * bytesPerPixel
        guard bytesPerPixel >= 4 else { return nil }
        return (data[offset], data[offset + 1], data[offset + 2], data[offset + 3])
    }

    private func isClose(_ actual: RGBA, to expected: (UInt8, UInt8, UInt8), tolerance: Int) -> Bool {
        let dr = abs(Int(actual.r) - Int(expected.0))
        let dg = abs(Int(actual.g) - Int(expected.1))
        let db = abs(Int(actual.b) - Int(expected.2))
        return dr <= tolerance && dg <= tolerance && db <= tolerance
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
