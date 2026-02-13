import Testing
@testable import TailwindLinter

@Suite("Linter: ClassCatalog")
struct TailwindClassCatalogTests {
    @Test func validClassChecks() {
        #expect(TailwindClassCatalog.isValidClass("flex"))
        #expect(TailwindClassCatalog.isValidClass("p-4"))
        #expect(TailwindClassCatalog.isValidClass("bg-red-500"))
        #expect(!TailwindClassCatalog.isValidClass("not-a-class"))
    }

    @Test func layoutClassChecks() {
        #expect(TailwindClassCatalog.isLayoutClass("flex"))
        #expect(TailwindClassCatalog.isLayoutClass("gap-4"))
        #expect(TailwindClassCatalog.isLayoutClass("justify-center"))
        #expect(!TailwindClassCatalog.isLayoutClass("bg-red-500"))
    }

    @Test func markerClassChecks() {
        #expect(TailwindClassCatalog.isMarkerClass("group"))
        #expect(TailwindClassCatalog.isMarkerClass("peer"))
        #expect(TailwindClassCatalog.isMarkerClass("peer/input"))
        #expect(!TailwindClassCatalog.isMarkerClass("peer/"))
    }
}
