# Complete Utilities Reference

## All Tailwind Utilities Supported

### Layout
- `p-{size}` - Padding (all sides)
- `px-{size}` - Padding horizontal
- `py-{size}` - Padding vertical
- `pt/pr/pb/pl-{size}` - Padding individual sides
- `m-{size}` - Margin
- `mx-{size}`, `my-{size}` - Margin horizontal/vertical
- `mt/mr/mb/ml-{size}` - Margin individual sides
- `-m-{size}` - Negative margin
- `w-{size}`, `h-{size}` - Width/height
- `w-full`, `h-full` - 100% width/height
- `min-w-{size}`, `max-w-{size}` - Min/max width
- `min-h-{size}`, `max-h-{size}` - Min/max height

### Display
- `block`, `flex`, `hidden`
- `overflow-hidden`, `overflow-visible`, `overflow-scroll`

### Flexbox
- `justify-start/center/end/between/around/evenly`
- `items-start/center/end/baseline/stretch`
- `self-auto/start/end/center/stretch`
- `flex-1`, `flex-auto`, `flex-initial`, `flex-none`
- `flex-grow-{n}`, `flex-shrink-{n}`
- `order-{n}`, `order-first`, `order-last`

### Grid
- `grid-cols-{n}` - Grid columns
- `grid-rows-{n}` - Grid rows
- `gap-{size}` - Gap between items

### Position
- `.position(.relative)` - Relative positioning
- `.position(.absolute)` - Absolute positioning
- `.position(.fixed)` - Fixed positioning
- `.position(.sticky)` - Sticky positioning

### Z-Index
- `z-{n}` - Z-index value

### Colors (All with 50-950 shades)
- `bg-{color}-{shade}` - Background color
- `text-{color}-{shade}` - Text color
- `border-{color}-{shade}` - Border color

**Color Names:**
slate, gray, zinc, neutral, stone, red, orange, amber, yellow, lime, green, emerald, teal, cyan, sky, blue, indigo, violet, purple, fuchsia, pink, rose

### Typography
- `text-xs/sm/base/lg/xl/2xl/3xl/4xl/5xl/6xl/7xl/8xl/9xl` - Font sizes
- `font-thin/light/normal/medium/semibold/bold` - Font weights
- `text-left/center/right/justify` - Text alignment
- `line-clamp-{n}` - Line clamping

### Borders
- `border` - 1px border
- `border-{width}` - Border width
- `border-{color}-{shade}` - Border color
- `rounded` - Border radius 4pt
- `rounded-sm/md/lg/xl/2xl/3xl` - Border radius variants
- `rounded-full` - Fully rounded (pill)

### Shadows
- `shadow-sm/md/lg/xl/2xl` - Box shadows
- `shadow` - Default shadow

### Effects
- `opacity-{0-100}` - Opacity percentage
- `blur/blur-sm/blur-md/blur-lg/blur-xl` - Blur effects

### Transforms
- `scale-{percent}` - Scale transform
- `rotate-{degrees}` - Rotation
- `translate-x-{size}`, `translate-y-{size}` - Translation

### Filters
- `brightness-{percent}` - Brightness
- `contrast-{percent}` - Contrast
- `grayscale` - Grayscale filter
- `saturate-{percent}` - Saturation
- `hue-rotate-{degrees}` - Hue rotation
- `invert` - Color inversion
- `sepia` - Sepia tone

### Backgrounds
- `bg-{color}` - Background color
- `gradient-to-r/l/t/b/tr/br/bl/tl` - Gradients

### Interactivity
- `cursor-pointer/default/not-allowed` - Cursor styles (macOS)
- `select-none/text/all` - Text selection
- `pointer-events-none/auto` - Hit testing

### Aspect Ratio
- `aspect-square` - 1:1 ratio
- `aspect-video` - 16:9 ratio

### Accessibility
- `.srOnly()` - Screen reader only

### Blend Modes
- `mix-blend-normal/multiply/screen/overlay/darken/lighten`
- And 11 more blend modes

## Builder Pattern Equivalents

Instead of strings, use typed modifiers:

```swift
// String syntax
.tw("p-4 bg-red-500 rounded-lg shadow-md")

// Builder syntax
.p(16)
.bg(.red500)
.rounded(.lg)
.shadow(.md)
```

## Spacing Scale

Tailwind uses a 4pt grid system:

| Value | Points | Rem |
|-------|--------|-----|
| 0 | 0pt | 0rem |
| px | 1pt | 0.0625rem |
| 0.5 | 2pt | 0.125rem |
| 1 | 4pt | 0.25rem |
| 2 | 8pt | 0.5rem |
| 3 | 12pt | 0.75rem |
| 4 | 16pt | 1rem |
| 5 | 20pt | 1.25rem |
| 6 | 24pt | 1.5rem |
| 8 | 32pt | 2rem |
| 10 | 40pt | 2.5rem |
| 12 | 48pt | 3rem |
| 16 | 64pt | 4rem |
| 20 | 80pt | 5rem |
| 24 | 96pt | 6rem |
| 32 | 128pt | 8rem |
| 40 | 160pt | 10rem |
| 48 | 192pt | 12rem |
| 56 | 224pt | 14rem |
| 64 | 256pt | 16rem |
| 72 | 288pt | 18rem |
| 80 | 320pt | 20rem |
| 96 | 384pt | 24rem |

## Font Sizes

| Class | Size | Line Height |
|-------|------|-------------|
| text-xs | 12pt | - |
| text-sm | 14pt | - |
| text-base | 16pt | - |
| text-lg | 18pt | - |
| text-xl | 20pt | - |
| text-2xl | 24pt | - |
| text-3xl | 30pt | - |
| text-4xl | 36pt | - |
| text-5xl | 48pt | - |
| text-6xl | 60pt | - |
| text-7xl | 72pt | - |
| text-8xl | 96pt | - |
| text-9xl | 128pt | - |
