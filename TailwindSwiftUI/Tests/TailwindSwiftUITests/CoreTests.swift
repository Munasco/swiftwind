import Testing
import SwiftUI
#if canImport(AppKit)
import AppKit
#endif
@testable import TailwindSwiftUI


// MARK: - Colors
@Suite("Colors")
struct ColorTests {
    @Test func allPalettesExist() {
        // Verify all 22 palettes have the 500 shade
        let colors: [Color] = [
            .slate500, .gray500, .zinc500, .neutral500, .stone500,
            .red500, .orange500, .amber500, .yellow500, .lime500,
            .green500, .emerald500, .teal500, .cyan500, .sky500,
            .blue500, .indigo500, .violet500, .purple500, .fuchsia500,
            .pink500, .rose500,
        ]
        #expect(colors.count == 22)
    }

    @Test func shadeBoundsExist() {
        // Each palette should have 50 and 950
        #expect(Color.red50 != Color.red950)
        #expect(Color.blue50 != Color.blue950)
        #expect(Color.slate50 != Color.slate950)
    }

    @Test func hexInitializer() {
        let white = Color(hex: 0xFFFFFF)
        let black = Color(hex: 0x000000)
        #expect(white != black)
    }
}

// MARK: - Spacing
@Suite("Spacing")
struct SpacingTests {
    @Test func scaleValues() {
        #expect(TSpacing._0.value == 0)
        #expect(TSpacing._0_5.value == 2)
        #expect(TSpacing._1.value == 4)
        #expect(TSpacing._2.value == 8)
        #expect(TSpacing._4.value == 16)
        #expect(TSpacing._8.value == 32)
        #expect(TSpacing._16.value == 64)
        #expect(TSpacing._64.value == 256)
        #expect(TSpacing._96.value == 384)
    }

    @Test func integerLiteral() {
        let spacing: TSpacing = 4
        #expect(spacing.value == 16)
    }
}

// MARK: - Radius
@Suite("Radius")
struct RadiusTests {
    @Test func allSizes() {
        #expect(TRadius.none.value == 0)
        #expect(TRadius.sm.value == 2)
        #expect(TRadius.base.value == 4)
        #expect(TRadius.md.value == 6)
        #expect(TRadius.lg.value == 8)
        #expect(TRadius.xl.value == 12)
        #expect(TRadius.xl2.value == 16)
        #expect(TRadius.xl3.value == 24)
        #expect(TRadius.full.value == 9999)
    }
}

// MARK: - Shadow
@Suite("Shadow")
struct ShadowTests {
    @Test func allSizes() {
        #expect(TShadow.sm.radius == 1)
        #expect(TShadow.base.radius == 2)
        #expect(TShadow.md.radius == 4)
        #expect(TShadow.lg.radius == 8)
        #expect(TShadow.xl.radius == 12)
        #expect(TShadow.xl2.radius == 24)
    }
}

// MARK: - Validation
@Suite("Validation")
struct ValidationTests {
    @Test func layoutOnTextIsError() {
        let result = TailwindValidation.validate("flex-row", viewType: .text)
        #expect(result != nil)
        #expect(result?.level == .error)
    }

    @Test func layoutOnImageIsError() {
        let result = TailwindValidation.validate("justify-center", viewType: .image)
        #expect(result != nil)
        #expect(result?.level == .error)
    }

    @Test func textClassOnImageIsError() {
        let result = TailwindValidation.validate("tracking-wide", viewType: .image)
        #expect(result != nil)
        #expect(result?.level == .error)
    }

    @Test func fontOnContainerIsAllowed() {
        // font-* propagates via environment, so no error
        let result = TailwindValidation.validate("font-bold", viewType: .container)
        #expect(result == nil)
    }

    @Test func textClassOnContainerIsError() {
        let result = TailwindValidation.validate("tracking-wide", viewType: .container)
        #expect(result != nil)
        #expect(result?.level == .error)
    }

    @Test func universalClassOnTextIsNil() {
        let result = TailwindValidation.validate("p-4", viewType: .text)
        #expect(result == nil)
    }

    @Test func universalClassOnContainerIsNil() {
        let result = TailwindValidation.validate("bg-red-500", viewType: .container)
        #expect(result == nil)
    }

    @Test func imageClassOnTextIsError() {
        let result = TailwindValidation.validate("object-cover", viewType: .text)
        #expect(result != nil)
        #expect(result?.level == .error)
    }

    @Test func imageClassOnContainerIsError() {
        let result = TailwindValidation.validate("object-cover", viewType: .container)
        #expect(result != nil)
        #expect(result?.level == .error)
    }

    @Test func layoutClassesListCoverage() {
        let layoutClasses = ["flex-row", "flex-col", "gap-4", "justify-between",
                             "items-center", "grid-cols-3", "space-x-4", "divide-y",
                             "columns-2", "order-1", "grow", "shrink-0"]
        for cls in layoutClasses {
            let result = TailwindValidation.validate(cls, viewType: .text)
            #expect(result?.level == .error, "Expected error for '\(cls)' on Text")
        }
    }
}

// MARK: - View Type Detection
@Suite("View Type Detection")
struct ViewTypeDetectionTests {
    @Test func detectsText() {
        let type = TWViewType(from: Text.self)
        #expect(type == .text)
    }

    @Test func detectsImage() {
        let type = TWViewType(from: Image.self)
        #expect(type == .image)
    }

    @Test func detectsVStack() {
        let type = TWViewType(from: VStack<EmptyView>.self)
        #expect(type == .container)
    }

    @Test func detectsHStack() {
        let type = TWViewType(from: HStack<EmptyView>.self)
        #expect(type == .container)
    }

    @Test func detectsTWView() {
        let type = TWViewType(from: TWView<EmptyView>.self)
        #expect(type == .twView)
    }
}
