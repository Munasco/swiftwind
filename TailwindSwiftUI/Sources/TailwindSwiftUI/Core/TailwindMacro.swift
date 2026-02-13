import SwiftUI

/// Compile-time validated Tailwind classes.
/// Usage:
///   Text("Hello").tw(#styles("text-xl font-bold bg-blue-500"))
///   Text("Hello").tw(#styles {
///     "text-xl"
///     "font-bold bg-blue-500"
///   })
/// Emits real compiler errors/warnings for invalid or misapplied classes.
@freestanding(expression)
public macro tw(_ classes: String) -> String = #externalMacro(module: "TailwindMacros", type: "TailwindClassesMacro")
@freestanding(expression)
public macro styles(_ classes: String) -> String = #externalMacro(module: "TailwindMacros", type: "TailwindClassesMacro")
@freestanding(expression)
public macro styles(@TailwindClassBuilder _ classes: () -> [String]) -> String = #externalMacro(module: "TailwindMacros", type: "TailwindClassesMacro")

// MARK: - .styles() method (pairs with #tw macro)
public extension View {
    /// Apply compile-time validated Tailwind classes.
    /// Usage: Text("Hello").styles(#tw("text-xl font-bold text-blue-600"))
    func styles(_ classes: String) -> some View {
        TailwindModifier(classes: classes, content: self)
    }
}
