# TailwindSwiftUI

Complete Tailwind CSS utility system for SwiftUI. Write beautiful interfaces with utility-first modifiers.

## Features

✅ **Full Tailwind Parity** - 2,441 lines covering all major Tailwind utilities  
✅ **String Syntax** - Compact Tailwind-style: `.tw("p-4 bg-red-500 rounded-lg")`  
✅ **Builder Pattern** - Type-safe Swift: `.p(16).bg(.red500).rounded(.lg)`  
✅ **22 Color Palettes** - All Tailwind colors with 50-950 shades  
✅ **Comprehensive Utilities** - Layout, typography, spacing, effects, transforms  
✅ **Multi-Platform** - iOS 16+, macOS 13+, watchOS 9+, tvOS 16+  

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/tailwind-swiftui.git", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftUI
import TailwindSwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome")
                .tw("text-3xl font-bold text-slate-900")
            
            Text("Get Started")
                .tw("px-6 py-3 bg-blue-600 text-white rounded-lg shadow-md")
        }
        .tw("p-8 bg-white rounded-2xl shadow-xl")
    }
}
```

## SwiftUI Layout Model (Important)

Tailwind classes generally work as expected, but SwiftUI layout is not CSS layout.

- In SwiftUI, parent and child sizing/alignment are negotiated together.
- On built-in containers (`VStack`, `HStack`, `ZStack`, grids), layout changes can influence the container and surrounding layout, not just a single leaf.
- This differs from the common "plain div" mental model on the web.

If you want a more neutral wrapper surface for layout-heavy composition, prefer `TWViewLayout` and wrapper components like `TWButton`.

```swift
TWViewLayout {
    Text("Primary")
        .tw("px-4 py-2 rounded-md")
}
.tw("flex-row items-center justify-between gap-4 p-4")

TWButton("Continue", classes: "px-4 py-2 bg-blue-600 text-white rounded-md") {
    // action
}
```

## Complete Utility Reference

### Layout & Sizing

**Spacing (Padding & Margin)**
```swift
.tw("p-4")          // padding all sides (16pt)
.tw("px-4 py-2")    // horizontal & vertical
.tw("pt-2 pr-4 pb-2 pl-4")  // individual sides
```

> Margin utilities are intentionally unsupported in SwiftUI.
> SwiftUI layout is proposal-based, and CSS-style outer margin semantics do not map cleanly or predictably to native container layout.
> Prefer container spacing/alignment (`spacing`, `frame`, `alignment`, `TWViewLayout`) instead.

**Width & Height**
```swift
.tw("w-full h-64")     // width 100%, height 256pt
.tw("w-32 h-32")       // 128pt × 128pt
.tw("min-w-0 max-w-full")
.tw("min-h-screen max-h-full")
```

**Display & Position**
```swift
.tw("block flex hidden")
.position(.relative)   // position types
.position(.absolute)
.position(.fixed)
```

**Z-Index**
```swift
.tw("z-10")           // zIndex(10)
.tw("z-50")           // zIndex(50)
```

### Colors

All 22 Tailwind color palettes with shades 50-950:
- `slate`, `gray`, `zinc`, `neutral`, `stone`
- `red`, `orange`, `amber`, `yellow`, `lime`
- `green`, `emerald`, `teal`, `cyan`, `sky`
- `blue`, `indigo`, `violet`, `purple`, `fuchsia`, `pink`, `rose`

```swift
.tw("bg-red-500 text-white")
.tw("bg-gradient-to-r from-blue-500 to-purple-600")
.tw("border-slate-300")
```

### Typography

**Font Size**
```swift
.tw("text-xs")     // 12pt
.tw("text-sm")     // 14pt
.tw("text-base")   // 16pt
.tw("text-lg")     // 18pt
.tw("text-xl")     // 20pt
.tw("text-2xl")    // 24pt
...up to text-9xl  // 128pt
```

**Font Weight**
```swift
.tw("font-thin font-light font-normal")
.tw("font-medium font-semibold font-bold")
```

**Text Alignment**
```swift
.tw("text-left text-center text-right")
.tw("text-justify")
```

**Line Clamping**
```swift
.tw("line-clamp-2")   // Limit to 2 lines
.tw("line-clamp-3")
```

### Flexbox & Grid

**Flex Container**
```swift
FlexContainer(.row) {
    // Row layout
}

FlexContainer(.col) {
    // Column layout
}
```

**Justify & Align**
```swift
.justifyStart()
.justifyCenter()
.justifyEnd()
.justifyBetween()

.itemsStart()
.itemsCenter()
.itemsEnd()
.itemsStretch()
```

**Flex Properties**
```swift
.flex1()          // Grow to fill
.flexGrow(1)
.flexShrink(1)
.flexNone()
```

**Grid**
```swift
.gridCols(3)      // 3-column grid
.gridRows(2)      // 2-row grid
```

**Gap (Spacing)**
```swift
HStack(gap: 4) { /* 16pt spacing */ }
VStack(gap: 2) { /* 8pt spacing */ }
```

### Borders & Radius

**Border Radius**
```swift
.tw("rounded")        // 4pt
.tw("rounded-sm")     // 2pt
.tw("rounded-md")     // 6pt
.tw("rounded-lg")     // 8pt
.tw("rounded-xl")     // 12pt
.tw("rounded-2xl")    // 16pt
.tw("rounded-3xl")    // 24pt
.tw("rounded-full")   // 9999pt (pill)
```

**Borders**
```swift
.tw("border")              // 1pt gray border
.tw("border-2 border-red-500")
.borderTop(1, color: .gray)
.borderX(2, color: .blue)
```

**Ring (Focus Ring)**
```swift
.ring(2, color: .blue)
.ringInset(2, color: .red)
.ringOffset(2)
```

### Shadows & Effects

**Box Shadow**
```swift
.tw("shadow-sm")     // Subtle
.tw("shadow")        // Default
.tw("shadow-md")     // Medium
.tw("shadow-lg")     // Large
.tw("shadow-xl")     // Extra large
.tw("shadow-2xl")    // Huge
```

**Opacity**
```swift
.tw("opacity-0")      // 0%
.tw("opacity-50")     // 50%
.tw("opacity-100")    // 100%
```

**Blur**
```swift
.tw("blur-sm blur blur-md blur-lg blur-xl")
.blur(.md)            // Builder syntax
```

### Transforms

**Scale**
```swift
.tw("scale-50")      // 50%
.tw("scale-100")     // 100%
.tw("scale-150")     // 150%
.scale(75)           // Builder syntax
```

**Rotate**
```swift
.tw("rotate-45")     // 45 degrees
.tw("rotate-90")     // 90 degrees
.rotate(180)         // Builder syntax
```

**Translate**
```swift
.translateX(10)
.translateY(-10)
.translate(x: 5, y: 5)
```

**Skew**
```swift
.skewX(6)
.skewY(3)
```

### Filters

**Brightness & Contrast**
```swift
.brightness(110)     // 110%
.contrast(125)       // 125%
```

**Grayscale & Saturate**
```swift
.grayscaleFull()
.grayscale(50)       // 50% desaturated
.saturate(150)       // 150% saturation
```

**Hue Rotate & Invert**
```swift
.hueRotate(90)       // Rotate hue by 90°
.invertFull()        // Color inversion
```

**Sepia**
```swift
.sepia()             // Apply sepia tone
```

### Backgrounds

**Gradients**
```swift
.gradientToR([.blue500, .purple600])     // Right
.gradientToB([.red500, .orange500])      // Bottom
.gradientToTR([.cyan500, .blue500])      // Top-right diagonal
```

**Background Utilities**
```swift
.bgCover()
.bgContain()
.bgCenter()
```

### Interactivity

**Cursor (macOS)**
```swift
.cursorPointer()
.cursorDefault()
.cursorNotAllowed()
```

**User Select**
```swift
.selectNone()        // Disable text selection
.selectText()        // Enable text selection
.selectAll()
```

**Pointer Events**
```swift
.pointerEventsNone()   // Disable hit testing
.pointerEventsAuto()   // Enable hit testing
```

### Transitions & Animations

**Duration**
```swift
.duration(._200)     // 200ms
.easeIn(._300)       // Ease in 300ms
.easeOut(._200)
.easeInOut(._500)
```

**Blend Modes**
```swift
.mixBlendNormal()
.mixBlendMultiply()
.mixBlendScreen()
.mixBlendOverlay()
...and 13 more blend modes
```

### Visibility & Display

**Visibility**
```swift
.tw("hidden")          // Hide element
.hidden(true)          // Conditional hide
.invisible()           // Invisible but takes space
```

**Overflow**
```swift
.overflowHidden()      // Clip content
.overflowVisible()     // Show overflow
.overflowScroll()      // Scrollable
```

**Scroll**
```swift
.scrollX()             // Horizontal scroll
.scrollY()             // Vertical scroll
```

### Accessibility

**Screen Reader**
```swift
.srOnly()              // Visible only to screen readers
```

**Disabled State**
```swift
.disabledStyle(true)   // Disabled appearance
```

## Builder Pattern Reference

For type-safe Swift-style modifiers:

```swift
Text("Hello")
    .p(16)                    // Padding
    .bg(.blue500)             // Background
    .textColor(.white)        // Text color
    .rounded(.lg)             // Border radius
    .shadow(.md)              // Shadow
    .text(.xl)                // Font size
    .fontBold()               // Font weight
    .w(200)                   // Width
    .h(100)                   // Height
```

## Complete Example

```swift
import SwiftUI
import TailwindSwiftUI

struct Dashboard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Dashboard")
                    .tw("text-2xl font-bold text-slate-900")
                Spacer()
                Text("Profile")
                    .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold cursor-pointer")
                    .cursorPointer()
            }
            .tw("p-6 border-b border-slate-200")
            
            // Cards Grid
            VStack(gap: 4) {
                ForEach(0..<3) { _ in
                    VStack(alignment: .leading, gap: 2) {
                        Text("Card Title")
                            .tw("text-lg font-semibold text-slate-900")
                        
                        Text("Card description with some details")
                            .tw("text-sm text-slate-600 line-clamp-2")
                        
                        HStack(gap: 2) {
                            Text("Action")
                                .tw("px-3 py-1 bg-blue-100 text-blue-700 rounded text-sm font-medium")
                            Text("Delete")
                                .tw("px-3 py-1 bg-red-100 text-red-700 rounded text-sm font-medium")
                        }
                    }
                    .tw("p-4 bg-white border border-slate-200 rounded-lg shadow-sm")
                }
            }
            .tw("p-6")
        }
        .tw("bg-slate-50")
    }
}
```

## File Structure

```
Sources/TailwindSwiftUI/
├── Colors.swift                      (344 lines - 22 color palettes)
├── Modifiers.swift                   (471 lines - core view modifiers)
├── TailwindParser.swift              (614 lines - string syntax parser)
├── TextModifiers.swift               (51 lines - Text-specific utils)
├── BorderBackgroundUtilities.swift   (220 lines - borders & gradients)
├── DisplayUtilities.swift            (140 lines - display & visibility)
├── GridFlexUtilities.swift           (187 lines - flex & grid)
├── LayoutHelpers.swift               (66 lines - positioning)
├── TransformEffects.swift            (190 lines - transforms & filters)
└── Core/
    └── Spacing.swift                 (158 lines - spacing scale)

Total: 2,441 lines
```

## Contributing

Contributions welcome! This project aims for full Tailwind CSS parity in SwiftUI.

## License

MIT
