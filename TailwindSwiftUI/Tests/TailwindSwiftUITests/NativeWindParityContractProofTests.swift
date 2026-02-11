import Testing
import SwiftUI
@testable import TailwindSwiftUI

@MainActor
@Suite("NativeWind Parity Contract Proof")
struct NativeWindParityContractProofTests {

    @Test func fullSupportInventoryHasNoUnknownUtilitiesForStandardViews() {
        let modifier = TailwindModifier(classes: "", content: EmptyView())
        for cls in NativeWindParityContractData.fullSupportInventoryStandard {
            let base = baseClass(from: cls)
            let recognized = isRecognizedByDispatch(modifier: modifier, className: base, view: AnyView(Text("x")))
            #expect(recognized, "Expected full-support class to be recognized on standard view: '\(cls)'")
        }
    }

    @Test func fullSupportInventoryHasNoUnknownUtilitiesForContainerViews() {
        let modifier = TailwindModifier(classes: "", content: TWView { EmptyView() })
        for cls in NativeWindParityContractData.fullSupportInventoryContainer {
            let base = baseClass(from: cls)
            let recognized = isRecognizedByDispatch(modifier: modifier, className: base, view: AnyView(TWView { EmptyView() }))
            #expect(recognized, "Expected full-support class to be recognized on container view: '\(cls)'")
        }
    }

    @Test func parityContractSetsAreConsistent() {
        let full = Set(NativeWindParityContractData.fullSupportInventoryStandard + NativeWindParityContractData.fullSupportInventoryContainer)
        let webOnly = Set(NativeWindParityContractData.webOnlyInventory)
        let overlap = full.intersection(webOnly)
        #expect(overlap.isEmpty, "A class cannot be both full-support and web-only. Overlap: \(Array(overlap).sorted())")
    }

    @Test func parityGapContractIsEmpty() {
        #expect(NativeWindParityContractData.parityGaps.isEmpty, "Parity gap contract should be empty.")
    }

    private func baseClass(from cls: String) -> String {
        // Variants like `dark:bg-*` / `ios:p-*` resolve to base utility part.
        if let last = cls.split(separator: ":").last {
            return String(last)
        }
        return cls
    }

    private func isRecognizedByDispatch<C: View>(
        modifier: TailwindModifier<C>,
        className: String,
        view: AnyView
    ) -> Bool {
        if TailwindNativeWindParity.isWebOnlyClassOnNative(className) {
            return false
        }
        if modifier.isV4GradientClass(className) {
            return true
        }
        if modifier.applySpacingClass(className, to: view) != nil { return true }
        if modifier.applyColorClass(className, to: view) != nil { return true }
        if modifier.applyTypographyClass(className, to: view) != nil { return true }
        if modifier.applySizingClass(className, to: view) != nil { return true }
        if modifier.applyLayoutClass(className, to: view) != nil { return true }
        if modifier.applyBorderClass(className, to: view) != nil { return true }
        if modifier.applyEffectsClass(className, to: view) != nil { return true }
        if modifier.applyTransformClass(className, to: view) != nil { return true }
        if modifier.applyInteractivityClass(className, to: view) != nil { return true }
        if modifier.applyAccessibilityClass(className, to: view) != nil { return true }
        if modifier.applyBracketClass(className, to: view) != nil { return true }
        if modifier.applyNativeWindCompatNoOpClass(className, to: view) != nil { return true }
        return false
    }
}
