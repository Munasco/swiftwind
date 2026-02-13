import Testing
@testable import TailwindLinter

@Suite("Linter: ClassParsing")
struct TailwindClassParsingTests {
    @Test func splitOnTopLevelColonsIgnoresBracketAndParenColons() {
        let parts = TailwindClassParsing.splitOnTopLevelColons("dark:bg-[url(data:image/svg+xml;foo)]")
        #expect(parts.count == 2)
        #expect(parts[0] == "dark")
        #expect(parts[1] == "bg-[url(data:image/svg+xml;foo)]")
    }

    @Test func parseVariantClass() {
        let parsed = TailwindClassParsing.parseVariantClass("dark:hover:bg-red-500")
        #expect(parsed.variants == ["dark", "hover"])
        #expect(parsed.baseClass == "bg-red-500")
    }
}
