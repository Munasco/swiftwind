import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
@testable import TailwindMacros

@MainActor let testMacros: [String: Macro.Type] = [
    "tw": TailwindClassesMacro.self,
    "styles": TailwindClassesMacro.self,
]

// MARK: - Valid Classes
@MainActor @Suite("Macro: Valid Classes")
struct MacroValidTests {
    @Test func stylesStringMacro() {
        assertMacroExpansion(
            #"#styles("p-4 bg-blue-500 text-white")"#,
            expandedSource: #""p-4 bg-blue-500 text-white""#,
            macros: testMacros
        )
    }

    @Test func stylesBuilderMacro() {
        assertMacroExpansion(
            #"""
            #styles {
                "p-4"
                "bg-blue-500 text-white"
                "rounded-lg"
            }
            """#,
            expandedSource: #""p-4 bg-blue-500 text-white rounded-lg""#,
            macros: testMacros
        )
    }

    @Test func stylesBuilderMacroWithoutSpaceAfterName() {
        assertMacroExpansion(
            #"""
            #styles{
                "text-lg font-semibold text-white/90"
            }
            """#,
            expandedSource: #""text-lg font-semibold text-white/90""#,
            macros: testMacros
        )
    }

    @Test func stylesInlineNoSpaceSingleLine() {
        assertMacroExpansion(
            #"#styles{"text-lg font-semibold text-white/90"}"#,
            expandedSource: #""text-lg font-semibold text-white/90""#,
            macros: testMacros
        )
    }

     @Test func spacingClasses() {
        assertMacroExpansion(
            #"#tw("p-4 px-2 py-3 pt-1 pr-2 pb-3 pl-4 m-2 mx-auto")"#,
            expandedSource: #""p-4 px-2 py-3 pt-1 pr-2 pb-3 pl-4 m-2 mx-auto""#,
            macros: testMacros
        )
    }

     @Test func typographyClasses() {
        assertMacroExpansion(
            #"#tw("text-xl font-bold italic uppercase tracking-wide leading-relaxed")"#,
            expandedSource: #""text-xl font-bold italic uppercase tracking-wide leading-relaxed""#,
            macros: testMacros
        )
    }

    @Test func colorClasses() {
        assertMacroExpansion(
            #"#tw("bg-blue-500 text-white border-red-300 shadow-lg")"#,
            expandedSource: #""bg-blue-500 text-white border-red-300 shadow-lg""#,
            macros: testMacros
        )
    }

    @MainActor @Test func layoutClasses() {
        assertMacroExpansion(
            #"#tw("flex flex-row justify-center items-start gap-4 hidden visible")"#,
            expandedSource: #""flex flex-row justify-center items-start gap-4 hidden visible""#,
            macros: testMacros
        )
    }

    @Test func sizingClasses() {
        assertMacroExpansion(
            #"#tw("w-full h-16 min-w-0 max-w-lg size-8 aspect-square")"#,
            expandedSource: #""w-full h-16 min-w-0 max-w-lg size-8 aspect-square""#,
            macros: testMacros
        )
    }

    @Test func borderClasses() {
        assertMacroExpansion(
            #"#tw("rounded-lg border border-2 ring-2 ring-inset outline-none shadow-md")"#,
            expandedSource: #""rounded-lg border border-2 ring-2 ring-inset outline-none shadow-md""#,
            macros: testMacros
        )
    }

    @Test func effectClasses() {
        assertMacroExpansion(
            #"#tw("opacity-75 blur-sm grayscale invert brightness-110 contrast-125 sepia")"#,
            expandedSource: #""opacity-75 blur-sm grayscale invert brightness-110 contrast-125 sepia""#,
            macros: testMacros
        )
    }

    @Test func transformClasses() {
        assertMacroExpansion(
            #"#tw("scale-95 rotate-45 translate-x-4 -translate-y-2 origin-center")"#,
            expandedSource: #""scale-95 rotate-45 translate-x-4 -translate-y-2 origin-center""#,
            macros: testMacros
        )
    }

    @Test func transitionClasses() {
        assertMacroExpansion(
            #"#tw("transition-all duration-300 ease-in-out delay-150 animate-pulse")"#,
            expandedSource: #""transition-all duration-300 ease-in-out delay-150 animate-pulse""#,
            macros: testMacros
        )
    }

    @Test func interactivityClasses() {
        assertMacroExpansion(
            #"#tw("cursor-pointer select-none pointer-events-none scroll-smooth")"#,
            expandedSource: #""cursor-pointer select-none pointer-events-none scroll-smooth""#,
            macros: testMacros
        )
    }

    @Test func accessibilityClasses() {
        assertMacroExpansion(
            #"#tw("sr-only not-sr-only")"#,
            expandedSource: #""sr-only not-sr-only""#,
            macros: testMacros
        )
    }

    @Test func bracketArbitraryValues() {
        assertMacroExpansion(
            #"#tw("p-[20px] w-[300] bg-[#1da1f2] text-[22px] rounded-[12]")"#,
            expandedSource: #""p-[20px] w-[300] bg-[#1da1f2] text-[22px] rounded-[12]""#,
            macros: testMacros
        )
    }

    @Test func singleValidClass() {
        assertMacroExpansion(
            #"#tw("flex")"#,
            expandedSource: #""flex""#,
            macros: testMacros
        )
    }

    @Test func emptyString() {
        assertMacroExpansion(
            #"#tw("")"#,
            expandedSource: #""""#,
            macros: testMacros
        )
    }
}

// MARK: - New Valid Classes
@MainActor @Suite("Macro: New Valid Classes")
struct MacroNewValidTests {
    @Test func fontVariantNumeric() {
        assertMacroExpansion(
            #"#tw("normal-nums tabular-nums ordinal slashed-zero lining-nums")"#,
            expandedSource: #""normal-nums tabular-nums ordinal slashed-zero lining-nums""#,
            macros: testMacros
        )
    }

    @Test func dropShadowClasses() {
        assertMacroExpansion(
            #"#tw("drop-shadow drop-shadow-sm drop-shadow-md drop-shadow-lg drop-shadow-xl drop-shadow-2xl drop-shadow-none")"#,
            expandedSource: #""drop-shadow drop-shadow-sm drop-shadow-md drop-shadow-lg drop-shadow-xl drop-shadow-2xl drop-shadow-none""#,
            macros: testMacros
        )
    }

    @Test func indentAndAlign() {
        assertMacroExpansion(
            #"#tw("indent-4 -indent-2 align-middle align-top")"#,
            expandedSource: #""indent-4 -indent-2 align-middle align-top""#,
            macros: testMacros
        )
    }

    @Test func snapAndTouchClasses() {
        assertMacroExpansion(
            #"#tw("snap-start snap-end snap-center snap-x snap-y touch-auto touch-none touch-pinch-zoom touch-manipulation")"#,
            expandedSource: #""snap-start snap-end snap-center snap-x snap-y touch-auto touch-none touch-pinch-zoom touch-manipulation""#,
            macros: testMacros
        )
    }

    @Test func borderSideClasses() {
        assertMacroExpansion(
            #"#tw("border-t border-b border-l border-r border-x border-y border-s border-e")"#,
            expandedSource: #""border-t border-b border-l border-r border-x border-y border-s border-e""#,
            macros: testMacros
        )
    }

    @Test func shapePaintClasses() {
        assertMacroExpansion(
            #"#tw("fill-red-500 fill-none stroke-blue-500 stroke-2 stroke-none stroke-[3px]")"#,
            expandedSource: #""fill-red-500 fill-none stroke-blue-500 stroke-2 stroke-none stroke-[3px]""#,
            macros: testMacros
        )
    }

    @Test func tableDisplayClasses() {
        assertMacroExpansion(
            #"#tw("table table-caption table-cell table-column table-row")"#,
            expandedSource: #""table table-caption table-cell table-column table-row""#,
            macros: testMacros
        )
    }

    @Test func negativeMarginClasses() {
        assertMacroExpansion(
            #"#tw("-m-4 -mx-8 -my-2 -mt-1 -mr-2 -mb-3 -ml-4")"#,
            expandedSource: #""-m-4 -mx-8 -my-2 -mt-1 -mr-2 -mb-3 -ml-4""#,
            macros: testMacros
        )
    }

    @Test func skewTransforms() {
        assertMacroExpansion(
            #"#tw("skew-x-3 skew-y-6 -skew-x-12 -skew-y-3")"#,
            expandedSource: #""skew-x-3 skew-y-6 -skew-x-12 -skew-y-3""#,
            macros: testMacros
        )
    }

    @Test func platformVariantsAreAccepted() {
        assertMacroExpansion(
            #"#tw("ios:bg-red-500 macos:p-8 dark:macos:text-white")"#,
            expandedSource: #""ios:bg-red-500 macos:p-8 dark:macos:text-white""#,
            macros: testMacros
        )
    }

    @Test func activeVariantsAreAccepted() {
        assertMacroExpansion(
            #"#tw("active:bg-red-500 group-active:text-white peer-active:bg-blue-500")"#,
            expandedSource: #""active:bg-red-500 group-active:text-white peer-active:bg-blue-500""#,
            macros: testMacros
        )
    }
}

// MARK: - Invalid Classes
@MainActor @Suite("Macro: Invalid Classes")
struct MacroInvalidTests {
    @Test func duplicateClassWarns() {
        assertMacroExpansion(
            #"#styles("bg-slate-500 bg-slate-500 text-white")"#,
            expandedSource: #""bg-slate-500 bg-slate-500 text-white""#,
            diagnostics: [
                DiagnosticSpec(message: "Duplicate style 'bg-slate-500' in the same base scope.", line: 1, column: 9, severity: .warning),
            ],
            macros: testMacros
        )
    }

    @Test func conflictingClassWarns() {
        assertMacroExpansion(
            #"#styles("text-red-500 text-red-600")"#,
            expandedSource: #""text-red-500 text-red-600""#,
            diagnostics: [
                DiagnosticSpec(
                    message: "Conflicting styles 'text-red-500' and 'text-red-600' in the same base scope.",
                    line: 1,
                    column: 9,
                    severity: .warning
                ),
            ],
            macros: testMacros
        )
    }

    @Test func singleUnknownClass() {
        assertMacroExpansion(
            #"#tw("asdf-123")"#,
            expandedSource: #""asdf-123""#,
            diagnostics: [
                DiagnosticSpec(message: "Unknown Tailwind class 'asdf-123'", line: 1, column: 5, severity: .warning),
            ],
            macros: testMacros
        )
    }

    @Test func multipleUnknownClasses() {
        assertMacroExpansion(
            #"#tw("fake-class also-fake")"#,
            expandedSource: #""fake-class also-fake""#,
            diagnostics: [
                DiagnosticSpec(message: "Unknown Tailwind class 'fake-class'", line: 1, column: 5, severity: .warning),
                DiagnosticSpec(message: "Unknown Tailwind class 'also-fake'", line: 1, column: 5, severity: .warning),
            ],
            macros: testMacros
        )
    }

    @Test func mixedValidAndInvalid() {
        assertMacroExpansion(
            #"#tw("p-4 nope bg-blue-500 wat")"#,
            expandedSource: #""p-4 nope bg-blue-500 wat""#,
            diagnostics: [
                DiagnosticSpec(message: "Unknown Tailwind class 'nope'", line: 1, column: 5, severity: .warning),
                DiagnosticSpec(message: "Unknown Tailwind class 'wat'", line: 1, column: 5, severity: .warning),
            ],
            macros: testMacros
        )
    }

    @Test func typoInClassName() {
        assertMacroExpansion(
            #"#tw("fontt-bold tex-xl")"#,
            expandedSource: #""fontt-bold tex-xl""#,
            diagnostics: [
                DiagnosticSpec(message: "Unknown Tailwind class 'fontt-bold'", line: 1, column: 5, severity: .warning),
                DiagnosticSpec(message: "Unknown Tailwind class 'tex-xl'", line: 1, column: 5, severity: .warning),
            ],
            macros: testMacros
        )
    }

    @Test func cssNotTailwind() {
        assertMacroExpansion(
            #"#tw("display:flex color:red")"#,
            expandedSource: #""display:flex color:red""#,
            diagnostics: [
                DiagnosticSpec(message: "Unknown Tailwind class 'display:flex'", line: 1, column: 5, severity: .warning),
                DiagnosticSpec(message: "Unknown Tailwind class 'color:red'", line: 1, column: 5, severity: .warning),
            ],
            macros: testMacros
        )
    }

    @Test func colorVariableMustUseColorPrefix() {
        assertMacroExpansion(
            #"#tw("bg-(--brand-bg) fill-var(--shape-fill)")"#,
            expandedSource: #""bg-(--brand-bg) fill-var(--shape-fill)""#,
            diagnostics: [
                DiagnosticSpec(
                    message: "Class 'bg-(--brand-bg)' uses '--brand-bg'. Color vars must be named '--color-*' (or '--tw-color-*').",
                    line: 1,
                    column: 5,
                    severity: .warning
                ),
                DiagnosticSpec(
                    message: "Class 'fill-var(--shape-fill)' uses '--shape-fill'. Color vars must be named '--color-*' (or '--tw-color-*').",
                    line: 1,
                    column: 5,
                    severity: .warning
                ),
            ],
            macros: testMacros
        )
    }
}
