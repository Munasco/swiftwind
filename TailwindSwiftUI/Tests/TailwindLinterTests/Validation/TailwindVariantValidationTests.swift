import Testing
@testable import TailwindLinter

@Suite("Linter: VariantValidation")
struct TailwindVariantValidationTests {
    @Test func unsupportedVariantDetection() {
        let unsupported = TailwindVariantValidation.unsupportedVariants(in: "foo:bg-red-500")
        #expect(unsupported == ["foo"])
    }

    @Test func supportedVariantDetection() {
        let unsupported = TailwindVariantValidation.unsupportedVariants(in: "dark:hover:bg-red-500")
        #expect(unsupported.isEmpty)
    }

    @Test func peerVariantValidation() {
        #expect(TailwindVariantValidation.isSupportedPeerVariant("peer-hover"))
        #expect(TailwindVariantValidation.isSupportedPeerVariant("peer-active/input"))
        #expect(!TailwindVariantValidation.isSupportedPeerVariant("peer-weird"))
        // Current parser behavior treats trailing slash as equivalent to default peer id.
        #expect(TailwindVariantValidation.isSupportedPeerVariant("peer-active/"))
    }
}
