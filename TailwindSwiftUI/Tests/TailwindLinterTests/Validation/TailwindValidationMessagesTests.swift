import Testing
@testable import TailwindLinter

@Suite("Linter: ValidationMessages")
struct TailwindValidationMessagesTests {
    @Test func conflictingStylesMessage() {
        let message = TailwindValidationMessages.conflictingStyles(previous: "p-4", current: "p-2", scope: "base scope")
        #expect(message.contains("Conflicting styles"))
        #expect(message.contains("p-4"))
        #expect(message.contains("p-2"))
    }

    @Test func unknownClassMessage() {
        let message = TailwindValidationMessages.unknownClass("foo-bar")
        #expect(message == "Unknown Tailwind class 'foo-bar'")
    }

    @Test func duplicateStyleMessage() {
        let message = TailwindValidationMessages.duplicateStyle("bg-red-500", scope: "base scope")
        #expect(message == "Duplicate style 'bg-red-500' in the same base scope.")
    }

    @Test func unsupportedVariantMessage() {
        let message = TailwindValidationMessages.unsupportedVariant("foo")
        #expect(message.contains("Unsupported Tailwind variant 'foo:'"))
    }

    @Test func invalidThemeTokenVariableNameMessage() {
        let message = TailwindValidationMessages.invalidThemeTokenVariableName(
            variable: "--brand",
            kind: "color",
            expectedPrefixes: ["--color-", "--tw-color-"]
        )
        #expect(message.contains("--brand"))
        #expect(message.contains("color"))
        #expect(message.contains("--color-"))
    }

    @Test func invalidCSSPropertyMessage() {
        let message = TailwindValidationMessages.invalidCSSPropertyName(
            variable: "--sidebar-width",
            property: "bad property"
        )
        #expect(message.contains("--sidebar-width"))
        #expect(message.contains("bad property"))
    }
}
