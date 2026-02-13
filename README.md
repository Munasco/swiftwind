# TailwindSwiftUI

Tailwind-style utility classes for SwiftUI, with macro validation, typed syntax, and runtime theme variables.

## Documentation

- Main docs: `https://swiftwind.vercel.app/docs/`
- Introduction: `https://swiftwind.vercel.app/docs/getting-started/introduction/`
- Installation: `https://swiftwind.vercel.app/docs/getting-started/installation/`
- Quick start: `https://swiftwind.vercel.app/docs/getting-started/quick-start/`
- NativeWind parity: `https://swiftwind.vercel.app/docs/reference/nativewind-parity/`

## Requirements

- Swift 6.2+
- iOS 16+
- macOS 13+
- tvOS 16+
- watchOS 9+

## Installation (Swift Package Manager)

In `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/thea11ylabs/tailwind-for-swiftui.git", from: "0.0.1")
]
```

Then add the product to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "TailwindSwiftUI", package: "tailwind-for-swiftui")
    ]
)
```

## Quick Start

```swift
import SwiftUI
import TailwindSwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Welcome")
                .tw("text-2xl font-bold text-zinc-900")

            Text("Build UI faster")
                .tw("text-sm text-zinc-600")

            Button("Continue") {}
                .tw("px-4 py-2 rounded-full bg-zinc-100 text-zinc-900 shadow")
        }
        .tw("items-start gap-3 p-5 bg-zinc-800 rounded-xl")
    }
}
```

## Usage Modes

### 1) String utilities

```swift
Text("Hello")
    .tw("text-xl font-semibold text-white bg-zinc-900 px-4 py-2 rounded-lg")
```

### 2) Builder block utilities

```swift
Text("Status")
    .tw {
        "text-sm"
        "font-medium"
        if isActive {
            "text-emerald-400"
        } else {
            "text-zinc-400"
        }
    }
```

### 3) Macro-validated classes (`#styles`)

```swift
Text("Validated")
    .tw(#styles("text-red-500 font-semibold"))

Text("Validated block")
    .tw(#styles {
        "text-lg"
        "font-bold"
        if emphasize { "underline" }
    })
```

### 4) Typed syntax (`TypedSyntax`)

```swift
Text("Typed")
    .tw(.text_2xl, .font_bold, .text_white)

Text("Token colors")
    .tw(
        .bg(.zinc800),
        .text(.white),
        .border(.zinc300),
        .fill(.hex("#1da1f2")),
        .stroke(.cssVar("--color-brand")),
        .bg(.oklch(0.16, 23, 23))
    )
```

Variant composition with typed syntax:

```swift
Text("Responsive")
    .tw(.w_1_2.md, .text_white.dark, .bg_zinc_800.hover)
```

### 5) Swift-style helper modifiers

```swift
Text("Helpers")
    .p(16)
    .bg(.blue)
    .textColor(.white)
    .rounded(.lg)
    .shadow(.md)
```

### 6) Shape styling

```swift
Circle()
    .tw("fill-emerald-500 stroke-white stroke-2 size-16")
```

## Runtime Theme / CSS Variables

Use `TailwindSwiftUI.initialize(entries:)` for one unified setup path.

```swift
TailwindSwiftUI.initialize(entries: [
    .color("--color-brand", light: "blue-500", dark: "yellow-500"),
    .css("--brand-radius", property: .radius, light: "0.75rem"),
    .utilities([
        "btn-primary": "px-4 py-2 rounded-md bg-(--color-brand) text-white"
    ])
])
```

You can also use dedicated initializers:

- `TailwindSwiftUI.initialize(themeVariables:cssVariables:utilities:)`
- `TailwindSwiftUI.initializeThemeVariables(_:)`
- `TailwindSwiftUI.initializeCSSVariables(_:)`

## Layout Model Notes

Tailwind classes are mapped into SwiftUI behavior, not browser layout internals.

- SwiftUI layout is proposal/measurement-based.
- Parent/child sizing and alignment interact more directly than CSS flow layout.
- Margin utilities are intentionally unsupported.

For details and constraints, see:

- `docs/gotchas-constraints-interesting.md`

## Validation / CI

Run package tests:

```bash
cd TailwindSwiftUI
swift test -q
```

Build docs site:

```bash
cd website
bun run build
```

## Project Structure

- Core runtime/parser: `TailwindSwiftUI/Sources/TailwindSwiftUI/`
- Typed syntax: `TailwindSwiftUI/Sources/TailwindSwiftUI/Core/TypedSyntax/`
- Macros: `TailwindSwiftUI/Sources/TailwindMacros/`
- Linter rules: `TailwindSwiftUI/Sources/TailwindLinter/Validation/`
- Docs app: `website/`

## License

MIT
