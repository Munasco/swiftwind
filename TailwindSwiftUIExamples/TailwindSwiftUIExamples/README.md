# TailwindSwiftUI Examples

Visual examples showing all features of TailwindSwiftUI.

## How to Use

### Option 1: Copy Individual Examples
Copy any example file into your Xcode project and use the `#Preview` macro to view it instantly.

### Option 2: Run Showcase App
Use `ShowcaseApp.swift` as your main view to browse all examples in tabs.

### Option 3: Swift Package Target (Recommended)
Add these examples to your Package.swift:

```swift
.executableTarget(
    name: "TailwindShowcase",
    dependencies: ["TailwindSwiftUI"],
    path: "Examples"
)
```

Then run: `swift run TailwindShowcase`

## Available Examples

### 🎨 ColorPaletteExample.swift
View all 22 color palettes with all shades (50-950).

**Features shown:**
- All Tailwind color palettes
- Color naming convention
- Shade variations

**Key utilities:**
- `bg-{color}-{shade}`
- Color extensions (`.slate500`, `.blue600`, etc.)

---

### 🔘 ButtonsExample.swift
Comprehensive button styles and variants.

**Features shown:**
- Primary, secondary, outline buttons
- Size variants (small, medium, large)
- Color variants (success, warning, danger, info)
- Rounded variants (square, rounded, pill)
- Shadow variants
- Icon buttons
- States (normal, disabled, loading)

**Key utilities:**
- `px-{n} py-{n}` - Padding
- `bg-{color}` - Background
- `text-{color}` - Text color
- `rounded-{size}` - Border radius
- `shadow-{size}` - Box shadow
- `font-{weight}` - Font weight
- `opacity-{percent}` - Opacity

---

### 🃏 CardsExample.swift
Different card layouts and styles.

**Features shown:**
- Simple cards
- Cards with headers
- Profile cards
- Stats cards
- Notification cards
- Pricing cards

**Key utilities:**
- `p-{n}` - Padding
- `rounded-{size}` - Border radius
- `shadow-{size}` - Shadows
- `border` - Borders
- `bg-{color}` - Backgrounds
- Layout composition

---

### 📐 LayoutExample.swift
Spacing, flexbox, and grid layouts.

**Features shown:**
- Padding variations (`p-2`, `p-4`, `p-8`, `px-6`, `py-6`)
- Width & height (`w-16`, `h-16`, `w-full`)
- Flexbox justify (`justify-start`, `justify-center`, `justify-end`)
- Flexbox align (`items-start`, `items-center`, `items-end`)
- Gap spacing
- Grid layouts

**Key utilities:**
- `p-{n}`, `px-{n}`, `py-{n}` - Padding
- `w-{n}`, `h-{n}` - Sizing
- `w-full`, `h-full` - Full width/height
- `gap-{n}` - Gap spacing
- `.justifyStart/Center/End()` - Flexbox justify
- `.itemsStart/Center/End()` - Flexbox align
- `.gridCols({n})` - Grid columns

---

### ✨ TransformsExample.swift
Transforms, effects, and filters.

**Features shown:**
- Scale transforms (75%, 100%, 125%)
- Rotate transforms (0°, 45°, 90°, 180°)
- Blur effects (small, medium, large)
- Opacity variations (25%, 50%, 75%, 100%)
- Shadows (none, small, medium, large)
- Animated effects
- Gradients
- Filter effects (grayscale, invert, sepia)

**Key utilities:**
- `.scale({percent})` - Scale transform
- `.rotate({degrees})` - Rotation
- `.blur(.sm/.md/.lg)` - Blur
- `opacity-{percent}` - Opacity
- `shadow-{size}` - Shadows
- `.gradientToR/L/T/B([colors])` - Gradients
- `.grayscaleFull()` - Grayscale filter
- `.invertFull()` - Invert colors
- `.sepia()` - Sepia tone

---

### 📱 ShowcaseApp.swift
Master app with all examples in tabs.

Run this to browse all examples interactively.

---

### 🧪 VariantsExample.swift
State and selector variants (`dark:`, `hover:`, `active:`, `group-*`, `peer-*`).

### 🧪 RuntimeVariablesExample.swift
Runtime token/css-variable registration and utility aliases via `initialize(entries:)`.

### 🧪 ShapeExample.swift
Shape paint examples for `fill-*`, `stroke-*`, and `stroke-{n}`.

## Quick Start

1. **In Xcode:**
   - Copy any example file to your project
   - The `#Preview` will appear instantly
   - Interact with the preview

2. **From Command Line:**
   ```bash
   # View specific example
   open Examples/ColorPaletteExample.swift
   
   # Or run showcase app
   swift run TailwindShowcase
   ```

3. **In Swift Playgrounds (iPad):**
   - Copy example content
   - Add `import TailwindSwiftUI`
   - View live preview

## Learning Path

**Beginners:**
1. Start with `ColorPaletteExample` to see all colors
2. Check `ButtonsExample` for basic styling
3. Try `LayoutExample` for spacing

**Intermediate:**
4. Explore `CardsExample` for composition
5. Study `TransformsExample` for effects

**Advanced:**
6. Mix utilities from different examples
7. Create your own combinations
8. Build production UIs

## Pro Tips

### Copy & Paste from Web
```swift
// Tailwind CSS class from web
<div class="px-6 py-3 bg-blue-600 text-white rounded-lg shadow-md font-semibold">

// Becomes this in SwiftUI
Text("Button")
    .tw("px-6 py-3 bg-blue-600 text-white rounded-lg shadow-md font-semibold")
```

### Combine String & Builder Syntax
```swift
Text("Hello")
    .tw("text-xl font-bold text-slate-900")  // String syntax
    .padding(16)                              // Standard SwiftUI
    .bg(.blue500)                             // Builder syntax
```

### Build Reusable Components
```swift
struct PrimaryButton: View {
    let text: String
    
    var body: some View {
        Text(text)
            .tw("px-6 py-3 bg-blue-600 text-white rounded-lg shadow-md font-semibold")
    }
}
```

## Screenshots

Each example includes visual demonstrations of:
- ✅ Exact Tailwind class names
- ✅ Visual output
- ✅ Property values (pt, percentages, etc.)
- ✅ Before/after comparisons

## Common Patterns

### Card with Button
```swift
VStack(alignment: .leading, spacing: 12) {
    Text("Card Title")
        .tw("text-lg font-bold text-slate-900")
    
    Text("Description text here")
        .tw("text-sm text-slate-600")
    
    Text("Action")
        .tw("px-4 py-2 bg-blue-600 text-white rounded-md font-semibold")
}
.tw("p-6 bg-white rounded-xl shadow-lg")
```

### Responsive Layout
```swift
LazyVGrid(columns: [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
], spacing: 12) {
    ForEach(items) { item in
        ItemCard(item: item)
            .tw("p-4 bg-white rounded-lg shadow-md")
    }
}
```

### Gradient Background
```swift
VStack {
    // Content
}
.gradientToR([.blue500, .purple600])
.tw("p-8 rounded-2xl shadow-xl")
```

## Need More Examples?

Check out:
- **README.md** - Full documentation
- **UTILITIES.md** - Complete utilities reference
- **ComprehensiveExample.swift** - Kitchen sink demo

## Contributing

Found a great pattern? Add it to Examples/ with:
- Descriptive filename
- `#Preview` macro
- Comments explaining utilities used
- Visual variety
