import SwiftUI

// MARK: - Position
public extension View {
    func positionStatic() -> some View { self }
    func positionRelative() -> some View { self }
    func positionAbsolute() -> some View { self.position(x: 0, y: 0) }
    func positionFixed() -> some View { self }
    func positionSticky() -> some View { self }
}

// MARK: - Visibility
public extension View {
    func visible() -> some View { self.opacity(1) }
    func tw_invisible() -> some View { self.opacity(0) }
    func collapse() -> some View { self.hidden() }
}

// MARK: - Float & Clear
public extension View {
    func floatLeft() -> some View { self }
    func floatRight() -> some View { self }
    func floatNone() -> some View { self }
    
    func clearLeft() -> some View { self }
    func clearRight() -> some View { self }
    func clearBoth() -> some View { self }
    func clearNone() -> some View { self }
}

// MARK: - Isolation
public extension View {
    func isolate() -> some View { self }
    func isolationAuto() -> some View { self }
}

// MARK: - Box Sizing
public extension View {
    func boxBorder() -> some View { self }
    func boxContent() -> some View { self }
}

// MARK: - Display
public extension View {
    func displayBlock() -> some View { self }
    func displayInlineBlock() -> some View { self }
    func displayInline() -> some View { self }
    func displayFlex() -> some View { self }
    func displayInlineFlex() -> some View { self }
    func displayGrid() -> some View { self }
    func displayInlineGrid() -> some View { self }
    func displayContents() -> some View { self }
    func displayNone() -> some View { self.hidden() }
}

// MARK: - Table Layout
public extension View {
    func tableAuto() -> some View { self }
    func tableFixed() -> some View { self }
    func borderCollapse() -> some View { self }
    func borderSeparate() -> some View { self }
}

// MARK: - List Style
public extension View {
    func listInside() -> some View { self }
    func listOutside() -> some View { self }
    func listNone() -> some View { self }
    func listDisc() -> some View { self }
    func listDecimal() -> some View { self }
}

// MARK: - Caption Side
public extension View {
    func captionTop() -> some View { self }
    func captionBottom() -> some View { self }
}

// MARK: - Scroll Snap (additional)
public extension View {
    func snapNone() -> some View { self }
    func snapX() -> some View { self }
    func snapY() -> some View { self }
    func snapBoth() -> some View { self }
    func snapMandatory() -> some View { self }
    func snapProximity() -> some View { self }
    func snapAlignNone() -> some View { self }
}


// MARK: - Break (Page Break)
public extension View {
    func breakBefore() -> some View { self }
    func breakAfter() -> some View { self }
    func breakInside() -> some View { self }
    func breakNormal() -> some View { self }
    func breakWords() -> some View { self }
    func breakAll() -> some View { self }
}

// MARK: - Whitespace
public extension View {
    func whitespaceNormal() -> some View { self }
    func whitespaceNowrap() -> some View { self }
    func whitespacePre() -> some View { self }
    func whitespacePreLine() -> some View { self }
    func whitespacePreWrap() -> some View { self }
}

// MARK: - Text Transform (additional)
public extension View {
    func normalCase() -> some View { self }
    func underline() -> some View { self }
    func lineThrough() -> some View { self }
    func noUnderline() -> some View { self }
}

// MARK: - Vertical Align
public extension View {
    func alignBaseline() -> some View { self }
    func alignTop() -> some View { self.frame(maxHeight: .infinity, alignment: .top) }
    func alignMiddle() -> some View { self.frame(maxHeight: .infinity, alignment: .center) }
    func alignBottom() -> some View { self.frame(maxHeight: .infinity, alignment: .bottom) }
    func alignTextTop() -> some View { self }
    func alignTextBottom() -> some View { self }
    func alignSub() -> some View { self }
    func alignSuper() -> some View { self }
}

// MARK: - Accent Color
public extension View {
    func accentColor(_ color: Color) -> some View {
        self.tint(color)
    }
}

// MARK: - Caret Color
public extension View {
    func caretColor(_ color: Color) -> some View {
        self.tint(color)
    }
}

// MARK: - Outline Style
public extension View {
    func outlineSolid() -> some View { self }
    func outlineDashed() -> some View { self }
    func outlineDotted() -> some View { self }
    func outlineDouble() -> some View { self }
    func outlineNone() -> some View { self }
}

// MARK: - Transform Properties
public extension View {
    func transformNone() -> some View { self }
    func transformGpu() -> some View { self }
    func transformCpu() -> some View { self }
}

// MARK: - Transform Box
public extension View {
    func transformBoxBorder() -> some View { self }
    func transformBoxFill() -> some View { self }
    func transformBoxView() -> some View { self }
}

// MARK: - Backface Visibility
public extension View {
    func backfaceVisible() -> some View { self }
    func backfaceHidden() -> some View { self }
}

// MARK: - Box Decoration Break
public extension View {
    func boxDecorationClone() -> some View { self }
    func boxDecorationSlice() -> some View { self }
}

// MARK: - Overscroll Behavior
public extension View {
    func overscrollAuto() -> some View { self }
    func overscrollContain() -> some View { self }
    func overscrollNone() -> some View { self }
}

// MARK: - Background Attachment
public extension View {
    func bgFixed() -> some View { self }
    func bgLocal() -> some View { self }
    func bgScroll() -> some View { self }
}

// MARK: - Image Rendering
public extension Image {
    func imageAuto() -> some View { self }
    func imagePixelated() -> some View {
        self.interpolation(.none)
    }
}

// MARK: - Columns
public extension View {
    func columnsAuto() -> some View { self }
    func columns1() -> some View { self }
    func columns2() -> some View { self }
    func columns3() -> some View { self }
    func columns4() -> some View { self }
}

// MARK: - Break Before/After/Inside
public extension View {
    func breakBeforeAuto() -> some View { self }
    func breakBeforeAvoid() -> some View { self }
    func breakBeforePage() -> some View { self }
    func breakAfterAuto() -> some View { self }
    func breakAfterAvoid() -> some View { self }
    func breakAfterPage() -> some View { self }
    func breakInsideAuto() -> some View { self }
    func breakInsideAvoid() -> some View { self }
    func breakInsidePage() -> some View { self }
}

// MARK: - Color Scheme
public extension View {
    func schemeNormal() -> some View { self }
    func schemeDark() -> some View { self.preferredColorScheme(.dark) }
    func schemeLight() -> some View { self.preferredColorScheme(.light) }
}

// MARK: - Forced Color Adjust
public extension View {
    func forcedColorAdjustAuto() -> some View { self }
    func forcedColorAdjustNone() -> some View { self }
}

// MARK: - Content
public extension View {
    func contentNone() -> some View { self }
}
