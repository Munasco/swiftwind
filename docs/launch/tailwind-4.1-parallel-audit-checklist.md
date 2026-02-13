# Tailwind 4.1 Parallel Audit Checklist

Last updated: 2026-02-13

Purpose: verify every requested feature area with evidence before broad launch claims.

How to use:

1. Assign each lane to a reviewer (or sub-agent).
2. For each item, record status: `✅ implemented`, `⚠️ partial/scoped`, `❌ missing`, `🌐 intentionally web-only`.
3. Add evidence references: parser file, catalog entry, tests, example, issue.

Evidence format:

- `Parser:` `TailwindSwiftUI/Sources/...`
- `Tests:` `TailwindSwiftUI/Tests/...`
- `Example:` `TailwindSwiftUIExamples/...`
- `Issue:` link/id

## Lane A: Core & Configuration

- [ ] Core concepts
- [ ] Styling with utility classes
- [ ] Hover, focus, and other states
- [ ] Responsive design
- [ ] Dark mode
- [ ] Theme variables
- [ ] Colors
- [ ] Adding custom styles
- [ ] Detecting classes in source files
- [ ] Functions and directives
- [ ] Base styles
- [ ] Preflight

## Lane B: Layout

- [ ] aspect-ratio
- [ ] columns
- [ ] break-after
- [ ] break-before
- [ ] break-inside
- [ ] box-decoration-break
- [ ] box-sizing
- [ ] display
- [ ] float
- [ ] clear
- [ ] isolation
- [ ] object-fit
- [ ] object-position
- [ ] overflow
- [ ] overscroll-behavior
- [ ] position
- [ ] top / right / bottom / left
- [ ] visibility
- [ ] z-index

## Lane C: Flexbox & Grid

- [ ] flex-basis
- [ ] flex-direction
- [ ] flex-wrap
- [ ] flex
- [ ] flex-grow
- [ ] flex-shrink
- [ ] order
- [ ] grid-template-columns
- [ ] grid-column
- [ ] grid-template-rows
- [ ] grid-row
- [ ] grid-auto-flow
- [ ] grid-auto-columns
- [ ] grid-auto-rows
- [ ] gap
- [ ] justify-content
- [ ] justify-items
- [ ] justify-self
- [ ] align-content
- [ ] align-items
- [ ] align-self
- [ ] place-content
- [ ] place-items
- [ ] place-self

## Lane D: Spacing & Sizing

- [ ] padding
- [ ] margin
- [ ] width
- [ ] min-width
- [ ] max-width
- [ ] height
- [ ] min-height
- [ ] max-height

## Lane E: Typography

- [ ] font-family
- [ ] font-size
- [ ] font-smoothing
- [ ] font-style
- [ ] font-weight
- [ ] font-stretch
- [ ] font-variant-numeric
- [ ] letter-spacing
- [ ] line-clamp
- [ ] line-height
- [ ] list-style-image
- [ ] list-style-position
- [ ] list-style-type
- [ ] text-align
- [ ] color
- [ ] text-decoration-line
- [ ] text-decoration-color
- [ ] text-decoration-style
- [ ] text-decoration-thickness
- [ ] text-underline-offset
- [ ] text-transform
- [ ] text-overflow
- [ ] text-wrap
- [ ] text-indent
- [ ] vertical-align
- [ ] white-space
- [ ] word-break
- [ ] overflow-wrap
- [ ] hyphens
- [ ] content

## Lane F: Backgrounds & Borders

- [ ] background-attachment
- [ ] background-clip
- [ ] background-color
- [ ] background-image
- [ ] background-origin
- [ ] background-position
- [ ] background-repeat
- [ ] background-size
- [ ] border-radius
- [ ] border-width
- [ ] border-color
- [ ] border-style
- [ ] outline-width
- [ ] outline-color
- [ ] outline-style
- [ ] outline-offset

## Lane G: Effects & Filters

- [ ] box-shadow
- [ ] text-shadow
- [ ] opacity
- [ ] mix-blend-mode
- [ ] background-blend-mode
- [ ] mask-clip
- [ ] mask-composite
- [ ] mask-image
- [ ] mask-mode
- [ ] mask-origin
- [ ] mask-position
- [ ] mask-repeat
- [ ] mask-size
- [ ] mask-type
- [ ] filter
- [ ] blur
- [ ] brightness
- [ ] contrast
- [ ] drop-shadow
- [ ] grayscale
- [ ] hue-rotate
- [ ] invert
- [ ] saturate
- [ ] sepia
- [ ] backdrop-filter
- [ ] backdrop-blur
- [ ] backdrop-brightness
- [ ] backdrop-contrast
- [ ] backdrop-grayscale
- [ ] backdrop-hue-rotate
- [ ] backdrop-invert
- [ ] backdrop-opacity
- [ ] backdrop-saturate
- [ ] backdrop-sepia

## Lane H: Tables

- [ ] border-collapse
- [ ] border-spacing
- [ ] table-layout
- [ ] caption-side

## Lane I: Transitions, Animation, Transforms

- [ ] transition-property
- [ ] transition-behavior
- [ ] transition-duration
- [ ] transition-timing-function
- [ ] transition-delay
- [ ] animation
- [ ] backface-visibility
- [ ] perspective
- [ ] perspective-origin
- [ ] rotate
- [ ] scale
- [ ] skew
- [ ] transform
- [ ] transform-origin
- [ ] transform-style
- [ ] translate

## Lane J: Interactivity, SVG, Accessibility

- [ ] accent-color
- [ ] appearance
- [ ] caret-color
- [ ] color-scheme
- [ ] cursor
- [ ] field-sizing
- [ ] pointer-events
- [ ] resize
- [ ] scroll-behavior
- [ ] scroll-margin
- [ ] scroll-padding
- [ ] scroll-snap-align
- [ ] scroll-snap-stop
- [ ] scroll-snap-type
- [ ] touch-action
- [ ] user-select
- [ ] will-change
- [ ] fill
- [ ] stroke
- [ ] stroke-width
- [ ] forced-color-adjust

## Launch Gate

Do not claim broad parity in public launch copy until:

- [ ] All checklist lines are tagged with status + evidence
- [ ] All `❌` and risky `⚠️` items are documented in public docs
- [ ] HN post language reflects actual status (no overclaim)
