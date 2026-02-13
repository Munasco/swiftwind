import Testing
@testable import TailwindSwiftUI

@Suite("Utils: Radius & Shadow")
struct RadiusShadowTests {
    @Test func radiusValues() {
        #expect(TRadius.none.value == 0)
        #expect(TRadius.sm.value == 2)
        #expect(TRadius.base.value == 4)
        #expect(TRadius.md.value == 6)
        #expect(TRadius.lg.value == 8)
        #expect(TRadius.xl.value == 12)
        #expect(TRadius.xl2.value == 16)
        #expect(TRadius.xl3.value == 24)
        #expect(TRadius.full.value == 9999)
    }

    @Test func shadowValues() {
        #expect(TShadow.sm.radius == 1)
        #expect(TShadow.base.radius == 2)
        #expect(TShadow.md.radius == 4)
        #expect(TShadow.lg.radius == 8)
        #expect(TShadow.xl.radius == 12)
        #expect(TShadow.xl2.radius == 24)
    }
}
