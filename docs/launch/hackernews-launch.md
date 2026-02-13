# Hacker News Launch Pack

Last updated: 2026-02-13

## Title Options

1. Show HN: TailwindSwiftUI, Tailwind-style utilities for SwiftUI
2. Show HN: TailwindSwiftUI (SwiftUI utility classes, variants, theme tokens, macros)
3. Show HN: TailwindSwiftUI, utility-first styling + compile-time class diagnostics

## Recommended HN Post Body

We just open-sourced **TailwindSwiftUI**: a utility-first styling layer for SwiftUI that supports Tailwind-style classes while keeping native SwiftUI composition.

Repo: `<REPO_URL>`
Docs: `<DOCS_URL>`
Examples: `<EXAMPLES_URL>`

What it does:

- Tailwind-style `.tw("...")` classes for SwiftUI views
- `#styles(...)` macro path for compile-time diagnostics on literal class strings
- Dark/responsive/platform variants (`dark:`, `sm:`, `ios:`, `macos:`, etc.)
- Group/peer state variants (`group-*`, `peer-*`)
- Theme token + CSS variable runtime initialization
- Color pipeline with OKLCH support and gradient interpolation options
- Build-tool lint plugin for class validation in source

What we intentionally call out:

- SwiftUI layout semantics are not CSS flow semantics
- Some web-only utility families are intentionally gated/no-op on native
- See gotchas and constraints doc before adopting widely

If you try it, I’d appreciate feedback on:

1. class conflict diagnostics quality
2. variant behavior parity expectations
3. API ergonomics for theme token / CSS variable initialization

Built by `@<your-handle>` with implementation and QA support from **OpenAI Codex**.

## First Comment (Recommended)

Known constraints and tradeoffs are documented here:

- Gotchas / constraints / interesting patterns: `docs/gotchas-constraints-interesting.md`
- Native parity notes: `docs/nativewind-parity.md`

If you hit a mismatch, please post:

- class string
- expected behavior
- platform (iOS/macOS/tvOS/watchOS/visionOS)
- minimal repro snippet

I’ll use those to prioritize fixes quickly.

## Comment Replies (Copy/Paste)

### “Why not just use pure SwiftUI modifiers?”

You should when it’s clearer. This package is for teams that want utility-class ergonomics and tokenized design consistency across larger codebases.

### “Is this 1:1 Tailwind?”

No strict claim of web 1:1. It targets pragmatic parity where native rendering/layout semantics make sense, and explicitly documents non-equivalent areas.

### “Does this hurt performance?”

There are static/macro/lint paths to catch issues early. Runtime parsing still exists, so we recommend using static class strings and macro/lint diagnostics where possible.

### “How do responsive breakpoints work?”

Breakpoints are evaluated against active window viewport width (window-scene aware), not static device constants.

## Pre-Post Checklist

- [ ] Replace placeholder URLs/handle
- [ ] Ensure README top section matches current capabilities
- [ ] Ensure docs links are valid
- [ ] Run tests one more time (`swift test -q`)
- [ ] Prepare 1-2 GIFs/screenshots for comments
- [ ] Pin gotchas/constraints link in first comment
