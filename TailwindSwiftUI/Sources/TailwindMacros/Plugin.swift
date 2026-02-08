import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct TailwindMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TailwindClassesMacro.self,
    ]
}
