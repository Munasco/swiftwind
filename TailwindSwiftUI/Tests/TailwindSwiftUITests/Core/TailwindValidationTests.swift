import Testing
import SwiftUI
@testable import TailwindSwiftUI

@Suite("Core: TailwindValidation")
struct TailwindValidationTests {
    @Test func layoutClassesOnTextAreErrors() {
        let classes = ["flex-row", "justify-center", "items-center", "gap-4", "grow", "shrink-0"]
        for cls in classes {
            let result = TailwindValidation.validate(cls, viewType: .text)
            #expect(result?.level == .error, "Expected error for '\(cls)' on Text")
        }
    }

    @Test func layoutClassesOnContainerAreWarnings() {
        let classes = ["flex-row", "justify-center", "items-center", "gap-4"]
        for cls in classes {
            let result = TailwindValidation.validate(cls, viewType: .container)
            #expect(result?.level == .warning, "Expected warning for '\(cls)' on container")
        }
    }

    @Test func textClassesOnContainerOnlyAllowFontFamily() {
        #expect(TailwindValidation.validate("font-bold", viewType: .container) == nil)
        #expect(TailwindValidation.validate("tracking-wide", viewType: .container)?.level == .error)
    }

    @Test func universalClassesPass() {
        #expect(TailwindValidation.validate("p-4", viewType: .text) == nil)
        #expect(TailwindValidation.validate("bg-red-500", viewType: .container) == nil)
    }
}

@Suite("Core: ViewType")
struct ViewTypeDetectionTests {
    @Test func detectsCoreViewKinds() {
        #expect(TWViewType(from: Text.self) == .text)
        #expect(TWViewType(from: Image.self) == .image)
        #expect(TWViewType(from: VStack<EmptyView>.self) == .container)
        #expect(TWViewType(from: HStack<EmptyView>.self) == .container)
        #expect(TWViewType(from: TWView<EmptyView>.self) == .twView)
    }
}
