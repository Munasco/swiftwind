import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
@testable import TailwindMacros

let testMacros: [String: Macro.Type] = [
    "tw": TailwindClassesMacro.self,
]

// MARK: - Valid Classes
@Suite("Macro: Valid Classes")
struct MacroValidTests {
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

    @Test func layoutClasses() {
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

// MARK: - Invalid Classes
@Suite("Macro: Invalid Classes")
struct MacroInvalidTests {
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
}
