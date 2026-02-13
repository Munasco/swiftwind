import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import TailwindLinter

public struct TailwindClassesMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let classString = extractClassString(from: node, in: context) else {
            return makeStringLiteralExpr("")
        }

        let classes = classString.split(separator: " ").map(String.init)
        var seenClasses = Set<String>()

        for className in classes {
            if seenClasses.contains(className) {
                context.diagnose(Diagnostic(
                    node: Syntax(node),
                    message: TailwindDiagnostic.duplicateClass(className)
                ))
            } else {
                seenClasses.insert(className)
            }

            let parsed = TailwindClassParsing.parseVariantClass(className)
            let unsupportedVariants = TailwindVariantValidation.unsupportedVariants(in: className)

            if !unsupportedVariants.isEmpty {
                for unsupported in unsupportedVariants {
                    context.diagnose(Diagnostic(
                        node: Syntax(node),
                        message: TailwindDiagnostic.unsupportedVariant(unsupported)
                    ))
                }
                continue
            }

            if TailwindClassCatalog.isMarkerClass(parsed.baseClass) {
                continue
            }

            if let invalidColorVar = TailwindVariableValidation.invalidColorVariableName(in: parsed.baseClass) {
                context.diagnose(Diagnostic(
                    node: Syntax(node),
                    message: TailwindDiagnostic.invalidColorVariable(className: className, variable: invalidColorVar)
                ))
            }

            if !TailwindClassCatalog.isValidClass(parsed.baseClass) {
                context.diagnose(Diagnostic(
                    node: Syntax(node),
                    message: TailwindDiagnostic.unknownClass(className)
                ))
                continue
            }
        }

        for conflict in TailwindConflictValidation.detectConflicts(in: classes) {
            context.diagnose(Diagnostic(
                node: Syntax(node),
                message: TailwindDiagnostic.conflictingClasses(
                    previous: conflict.previous,
                    current: conflict.current,
                    scope: conflict.scope
                )
            ))
        }

        return makeStringLiteralExpr(classString)
    }
}

private func makeStringLiteralExpr(_ raw: String) -> ExprSyntax {
    let escaped = raw
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "\"", with: "\\\"")
    return ExprSyntax("\"\(raw: escaped)\"")
}

private func extractClassString(
    from node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
) -> String? {
    if let argument = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
       let literal = stringLiteralValue(argument, in: context, fallbackNode: Syntax(node)) {
        return literal
    }

    if let trailing = node.trailingClosure {
        var tokens: [String] = []
        for item in trailing.statements {
            guard let exprStmt = item.item.as(ExpressionStmtSyntax.self) else { continue }
            if let stringExpr = exprStmt.expression.as(StringLiteralExprSyntax.self),
               let literal = stringLiteralValue(stringExpr, in: context, fallbackNode: Syntax(trailing)) {
                tokens.append(literal)
                continue
            }
            context.diagnose(Diagnostic(
                node: Syntax(exprStmt),
                message: TailwindDiagnostic.requiresStringLiteralInBuilder
            ))
            return nil
        }
        return tokens.joined(separator: " ")
    }

    context.diagnose(Diagnostic(
        node: Syntax(node),
        message: TailwindDiagnostic.requiresStringLiteral
    ))
    return nil
}

private func stringLiteralValue(
    _ literal: StringLiteralExprSyntax,
    in context: some MacroExpansionContext,
    fallbackNode: Syntax
) -> String? {
    guard literal.segments.count == 1,
          let segment = literal.segments.first?.as(StringSegmentSyntax.self) else {
        context.diagnose(Diagnostic(
            node: fallbackNode,
            message: TailwindDiagnostic.requiresStringLiteral
        ))
        return nil
    }
    return segment.content.text
}

enum TailwindDiagnostic: DiagnosticMessage {
    case requiresStringLiteral
    case requiresStringLiteralInBuilder
    case unknownClass(String)
    case duplicateClass(String)
    case conflictingClasses(previous: String, current: String, scope: String)
    case unsupportedVariant(String)
    case layoutOnText(String)
    case invalidColorVariable(className: String, variable: String)

    var message: String {
        switch self {
        case .requiresStringLiteral:
            return "#tw requires a string literal"
        case .requiresStringLiteralInBuilder:
            return "#styles builder accepts only string literal lines"
        case .unknownClass(let name):
            return TailwindValidationMessages.unknownClass(name)
        case .duplicateClass(let name):
            return "Duplicate Tailwind class '\(name)' in the same macro input"
        case let .conflictingClasses(previous, current, scope):
            return TailwindValidationMessages.conflictingStyles(previous: previous, current: current, scope: scope)
        case .unsupportedVariant(let name):
            return TailwindValidationMessages.unsupportedVariant(name)
        case .layoutOnText(let name):
            return "'\(name)' is a layout class and has no effect on Text"
        case let .invalidColorVariable(className, variable):
            return TailwindValidationMessages.invalidColorVariableUsage(className: className, variable: variable)
        }
    }

    var diagnosticID: MessageID {
        switch self {
        case .requiresStringLiteral:
            return MessageID(domain: "TailwindSwiftUI", id: "requiresStringLiteral")
        case .requiresStringLiteralInBuilder:
            return MessageID(domain: "TailwindSwiftUI", id: "requiresStringLiteralInBuilder")
        case .unknownClass:
            return MessageID(domain: "TailwindSwiftUI", id: "unknownClass")
        case .duplicateClass:
            return MessageID(domain: "TailwindSwiftUI", id: "duplicateClass")
        case .conflictingClasses:
            return MessageID(domain: "TailwindSwiftUI", id: "conflictingClasses")
        case .unsupportedVariant:
            return MessageID(domain: "TailwindSwiftUI", id: "unsupportedVariant")
        case .layoutOnText:
            return MessageID(domain: "TailwindSwiftUI", id: "layoutOnText")
        case .invalidColorVariable:
            return MessageID(domain: "TailwindSwiftUI", id: "invalidColorVariable")
        }
    }

    var severity: DiagnosticSeverity {
        switch self {
        case .requiresStringLiteral: return .error
        case .requiresStringLiteralInBuilder: return .error
        case .unknownClass: return .warning
        case .duplicateClass: return .warning
        case .conflictingClasses: return .warning
        case .unsupportedVariant: return .warning
        case .layoutOnText: return .error
        case .invalidColorVariable: return .warning
        }
    }
}
