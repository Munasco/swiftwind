import Testing
import SwiftUI
#if canImport(AppKit)
import AppKit
#endif
@testable import TailwindSwiftUI

// MARK: - Sizing Extended
@Suite("Sizing Extended")
@MainActor
struct SizingExtendedTests {
    @Test func fractionalWidths() {
        for cls in ["w-1/2", "w-1/3", "w-2/3", "w-1/4", "w-3/4", "w-1/5", "w-2/5", "w-3/5", "w-4/5", "w-1/6", "w-5/6"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func namedMaxWidths() {
        for cls in ["max-w-xs", "max-w-sm", "max-w-md", "max-w-lg", "max-w-xl", "max-w-2xl",
                     "max-w-3xl", "max-w-4xl", "max-w-5xl", "max-w-6xl", "max-w-7xl", "max-w-prose"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func aspectRatios() {
        for cls in ["aspect-auto", "aspect-square", "aspect-video"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func zIndexValues() {
        for cls in ["z-0", "z-10", "z-20", "z-30", "z-40", "z-50", "z-auto"] {
            _ = Text("").tw(cls)
        }
    }
}

// MARK: - Border Extended
@Suite("Border Extended")
@MainActor
struct BorderExtendedTests {
    @Test func allBorderWidths() {
        for cls in ["border-0", "border", "border-2", "border-4", "border-8"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func borderSides() {
        for cls in ["border-t", "border-b", "border-l", "border-r", "border-x", "border-y"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func allRingWidths() {
        for cls in ["ring-0", "ring-1", "ring-2", "ring-4", "ring-8"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func perCornerRadius() {
        for cls in ["rounded-t-sm", "rounded-b-lg", "rounded-l-md", "rounded-r-xl"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func outlineStyles() {
        for cls in ["outline-none", "outline", "outline-1", "outline-2", "outline-4",
                     "outline-dashed", "outline-dotted", "outline-double"] {
            _ = Text("").tw(cls)
        }
    }
}

// MARK: - Spacing Extended
@Suite("Spacing Extended")
@MainActor
struct SpacingExtendedTests {
    @Test func negativeMargins() {
        _ = Text("").tw("-m-4 -mx-8 -my-16")
        _ = Text("").tw("-mt-32 -mr-2 -mb-2 -ml-4")
    }

    @Test func logicalSpacing() {
        _ = Text("").tw("ps-4 pe-4 ms-2 me-2")
    }
}

// MARK: - Interactivity Extended
@Suite("Interactivity Extended")
@MainActor
struct InteractivityExtendedTests {
    @Test func cursorStyles() {
        for cls in ["cursor-auto", "cursor-default", "cursor-pointer", "cursor-wait", "cursor-text",
                     "cursor-move", "cursor-help", "cursor-not-allowed", "cursor-grab", "cursor-grabbing"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func scrollSnap() {
        for cls in ["snap-start", "snap-end", "snap-center", "snap-none", "snap-x", "snap-y", "snap-both"] {
            _ = VStack {}.tw(cls)
        }
    }

    @Test func touchActions() {
        for cls in ["touch-auto", "touch-none", "touch-pan-x", "touch-pan-y", "touch-pinch-zoom"] {
            _ = VStack {}.tw(cls)
        }
    }
}

// MARK: - Animations & Transitions
@Suite("Animations & Transitions")
@MainActor
struct AnimationTransitionTests {
    @Test func allAnimationTypes() {
        for cls in ["animate-none", "animate-spin", "animate-ping", "animate-pulse", "animate-bounce"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func transitionTypes() {
        for cls in ["transition-none", "transition-all", "transition", "transition-colors",
                     "transition-opacity", "transition-shadow", "transition-transform"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func easingFunctions() {
        for cls in ["ease-linear", "ease-in", "ease-out", "ease-in-out"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func durationAndDelay() {
        for cls in ["duration-75", "duration-100", "duration-150", "duration-200", "duration-300", "duration-500", "duration-700", "duration-1000"] {
            _ = Text("").tw(cls)
        }
        for cls in ["delay-75", "delay-100", "delay-150", "delay-200", "delay-300", "delay-500"] {
            _ = Text("").tw(cls)
        }
    }
}

// MARK: - Grid Layout
@Suite("Grid Layout")
@MainActor
struct GridLayoutTests {
    @Test func gridColumns() {
        for cls in ["grid-cols-1", "grid-cols-2", "grid-cols-3", "grid-cols-4", "grid-cols-6", "grid-cols-12"] {
            _ = VStack {}.tw(cls)
        }
    }

    @Test func gridCellPlacement() {
        for cls in ["col-span-1", "col-span-2", "col-span-3", "col-start-1", "col-start-2",
                     "col-end-3", "row-span-1", "row-span-2", "row-start-1", "row-end-2"] {
            _ = Text("").tw(cls)
        }
    }

    @Test func placeUtilities() {
        for cls in ["place-content-start", "place-content-end", "place-content-center",
                     "place-items-start", "place-items-center",
                     "place-self-auto", "place-self-start", "place-self-center"] {
            _ = VStack {}.tw(cls)
        }
    }
}

// MARK: - Validation Extended
@Suite("Validation Extended")
@MainActor
struct ValidationExtendedTests {
    @Test func layoutOnContainerWarns() {
        for cls in ["flex", "flex-row", "flex-col", "gap-4", "justify-center", "items-center"] {
            let result = TailwindValidation.validate(cls, viewType: .container)
            #expect(result?.level == .warning, "Layout class '\(cls)' should warn on containers")
        }
    }

    @Test func layoutOnTWViewNoError() {
        for cls in ["flex", "flex-row", "flex-col", "gap-4", "justify-center", "items-center"] {
            let result = TailwindValidation.validate(cls, viewType: .twView)
            #expect(result == nil, "Layout class '\(cls)' should be allowed on TWView")
        }
    }

    @Test func allFontWeightsOnContainerAllowed() {
        for cls in ["font-thin", "font-extralight", "font-light", "font-normal",
                     "font-medium", "font-semibold", "font-bold", "font-extrabold", "font-black"] {
            let result = TailwindValidation.validate(cls, viewType: .container)
            #expect(result == nil, "Font weight '\(cls)' should propagate on containers")
        }
    }

    @Test func textOnlyClassesErrorOnContainer() {
        for cls in ["tracking-wide", "leading-loose", "line-clamp-2", "uppercase", "italic"] {
            let result = TailwindValidation.validate(cls, viewType: .container)
            #expect(result != nil && result?.level == .error, "'\(cls)' should error on containers")
        }
    }

    @Test func fontVariantNumericOnImageErrors() {
        for cls in ["tabular-nums", "ordinal", "slashed-zero"] {
            let result = TailwindValidation.validate(cls, viewType: .image)
            #expect(result != nil && result?.level == .error, "'\(cls)' should error on Image")
        }
    }
}
