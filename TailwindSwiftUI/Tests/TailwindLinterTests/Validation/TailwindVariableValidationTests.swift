import Testing
@testable import TailwindLinter

@Suite("Linter: VariableValidation")
struct TailwindVariableValidationTests {
    @Test func themeTokenNameChecks() {
        #expect(TailwindVariableValidation.isColorThemeVariableToken("--color-brand"))
        #expect(TailwindVariableValidation.isColorThemeVariableToken("--tw-color-brand"))
        #expect(!TailwindVariableValidation.isColorThemeVariableToken("--brand"))
    }

    @Test func extractCustomPropertyToken() {
        #expect(TailwindVariableValidation.extractCustomPropertyToken(from: "var(--color-brand)") == "--color-brand")
        #expect(TailwindVariableValidation.extractCustomPropertyToken(from: "(--color-brand)") == "--color-brand")
        #expect(TailwindVariableValidation.extractCustomPropertyToken(from: "--color-brand") == "--color-brand")
    }

    @Test func invalidColorVariableNameDetection() {
        #expect(TailwindVariableValidation.invalidColorVariableName(in: "bg-[var(--brand)]") == "--brand")
        #expect(TailwindVariableValidation.invalidColorVariableName(in: "bg-[var(--color-brand)]") == nil)
    }

    @Test func themeTokenKindNamespaceValidation() {
        let valid = TailwindVariableValidation.invalidThemeTokenName("--spacing-card", forThemeKindRawValue: "spacing")
        let invalid = TailwindVariableValidation.invalidThemeTokenName("--card", forThemeKindRawValue: "spacing")
        let zValid = TailwindVariableValidation.invalidThemeTokenName("--z-modal", forThemeKindRawValue: "zIndex")
        let zInvalid = TailwindVariableValidation.invalidThemeTokenName("--index-modal", forThemeKindRawValue: "zIndex")

        #expect(valid == nil)
        #expect(invalid != nil)
        #expect(zValid == nil)
        #expect(zInvalid != nil)
    }

    @Test func cssPropertyValidation() {
        #expect(TailwindVariableValidation.isValidCSSPropertyName("width"))
        #expect(TailwindVariableValidation.isValidCSSPropertyName("background-color"))
        #expect(TailwindVariableValidation.isValidCSSPropertyName("--sidebar-width"))
        #expect(!TailwindVariableValidation.isValidCSSPropertyName(""))
        #expect(!TailwindVariableValidation.isValidCSSPropertyName(" background color "))
    }
}
