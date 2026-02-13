import Testing
@testable import TailwindLinter

@Suite("Linter: ConflictValidation")
struct TailwindConflictValidationTests {
    @Test func conflictGroupDistinguishesBorderKinds() {
        #expect(TailwindConflictValidation.conflictGroup(for: "border-2") == "border-width-all")
        #expect(TailwindConflictValidation.conflictGroup(for: "border-blue-500") == "border-color-all")
    }

    @Test func detectConflictsInSingleScope() {
        let conflicts = TailwindConflictValidation.detectConflicts(in: ["p-4", "p-2", "bg-red-500", "bg-blue-500"])
        #expect(conflicts.count == 2)
    }

    @Test func crossScopeConflicts() {
        let has = TailwindConflictValidation.hasCrossScopeConflicts(
            previous: ["dark:bg-red-500", "p-4"],
            incoming: ["dark:bg-blue-500", "p-2"]
        )
        #expect(has)
    }
}
