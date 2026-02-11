# NativeWind Parity Report

Last updated: 2026-02-09

This repository tracks NativeWind parity with three sources of truth:

- Full-support inventory tracker:
  - `TailwindSwiftUI/Tests/TailwindSwiftUITests/NativeWindInventoryTrackerTests.swift`
- Full-support matrix tracker:
  - `TailwindSwiftUI/Tests/TailwindSwiftUITests/NativeWindFullSupportTrackerTests.swift`
- Gap tracker:
  - `TailwindSwiftUI/Tests/TailwindSwiftUITests/NativeWindParityGapTrackerTests.swift`

## Status

- Native parity backlog tracked in tests: **empty**
- Web-only NativeWind classes are explicitly gated by:
  - `TailwindSwiftUI/Sources/TailwindSwiftUI/TailwindNativeWindParity.swift`
- Compatibility no-op support for non-visual/native-semantic classes is handled by:
  - `TailwindSwiftUI/Sources/TailwindSwiftUI/TailwindNativeWindCompatNoOp.swift`

## Implemented in this pass

- `basis-*` handling
- Tailwind v4 linear gradient pipeline:
  - `bg-linear-to-*`
  - `bg-linear-<angle>`
  - `from-*`, `via-*`, `to-*`
- Safe-area utilities:
  - `p-safe`, `px-safe`, `py-safe`, `pt-safe`, `pr-safe`, `pb-safe`, `pl-safe`
- `border-spacing-*` recognition
- `ring-offset-*` width contribution in ring rendering

## Inventory Buckets

### Native-supported inventory examples

- Layout/container: `container`, `flex`, `grid`, `justify-*`, `items-*`, `content-*`, `place-*`, `gap-*`, `grid-cols-*`, `col-span-*`, `row-span-*`, `z-*`
- Spacing/sizing: `p-*`, `m-*`, `w-*`, `h-*`, `min-*`, `max-*`, `size-*`, `basis-*`, `aspect-*`
- Typography: `text-*`, `font-*`, `leading-*`, `tracking-*`, `line-clamp-*`, `truncate`, transforms/case/decorations
- Colors/backgrounds: `bg-*`, `text-*`, slash-opacity forms, gradient stop utilities
- Borders/effects: `border-*`, `rounded-*`, `ring-*`, `outline-*`, `shadow-*`, `opacity-*`, `transition-*`, `animate-*`
- Interactivity: `pointer-events-*`, `touch-*`, `appearance-*`
- SVG utilities: `fill-*`, `stroke-*`
- Variants: `dark:`, `ios:`, `macos:`, responsive (`sm:`, `md:`, etc.)

### Web-only inventory examples (gated on native)

- Overflow scroll families: `overflow-auto`, `overflow-scroll`, `overflow-x-auto`, `overflow-y-scroll`
- Overscroll families: `overscroll-*`
- Scroll behavior/margin/padding/snap: `scroll-*`, `snap-*`
- Pointer/selection/resize web families: `cursor-*`, `select-*`, `resize*`

## CI Validation

Run:

```bash
cd TailwindSwiftUI
swift test -q
```

Passing tests validate:

- full-support inventory is not marked web-only
- web-only inventory is marked web-only
- full-support inventory compiles through `.tw(...)`
- parity gap backlog remains empty
