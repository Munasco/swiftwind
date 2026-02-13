import Foundation
import TailwindLinter

private func detectViewType(_ lineContent: String, _ prevLines: [String]) -> String? {
    let context = (prevLines.suffix(3).joined(separator: "\n") + "\n" + lineContent)
    if context.contains("Text(") || context.contains("Label(") { return "Text" }
    if context.contains("Image(") || context.contains("AsyncImage(") { return "Image" }
    return nil
}

private func containsSwiftLintConfig(near path: String) -> Bool {
    let fm = FileManager.default
    var current = URL(fileURLWithPath: path).deletingLastPathComponent()

    while true {
        let config = current.appendingPathComponent(".swiftlint.yml").path
        if fm.fileExists(atPath: config) {
            return true
        }

        let parent = current.deletingLastPathComponent()
        if parent.path == current.path { break }
        current = parent
    }

    return false
}

// MARK: - Main
let args = CommandLine.arguments.dropFirst()

if let firstFile = args.first, containsSwiftLintConfig(near: firstFile) {
    print("warning: \(TailwindValidationMessages.swiftLintSetupHint)")
}

for filePath in args {
    guard let data = FileManager.default.contents(atPath: filePath),
          let content = String(data: data, encoding: .utf8) else { continue }

    let lines = content.components(separatedBy: "\n")

    for (index, line) in lines.enumerated() {
        let lineNum = index + 1

        var searchRange = line.startIndex..<line.endIndex
        while let twRange = line.range(of: #"\.tw\(""#, options: .regularExpression, range: searchRange) {
            let afterQuote = twRange.upperBound
            guard let closeQuote = line.range(of: "\")", range: afterQuote..<line.endIndex) else {
                searchRange = twRange.upperBound..<line.endIndex
                continue
            }

            let classString = String(line[afterQuote..<closeQuote.lowerBound])
            let classes = classString.split(separator: " ").map(String.init)
            let col = line.distance(from: line.startIndex, to: twRange.lowerBound) + 1

            let viewType = detectViewType(line, Array(lines.prefix(index)))

            for className in classes {
                let parsed = TailwindClassParsing.parseVariantClass(className)

                let unsupportedVariants = TailwindVariantValidation.unsupportedVariants(in: className)
                for unsupported in unsupportedVariants {
                    print("\(filePath):\(lineNum):\(col): warning: \(TailwindValidationMessages.unsupportedVariant(unsupported))")
                }

                if !TailwindClassCatalog.isValidClass(parsed.baseClass) {
                    print("\(filePath):\(lineNum):\(col): warning: \(TailwindValidationMessages.unknownClass(className))")
                }

                if let invalidColorVar = TailwindVariableValidation.invalidColorVariableName(in: parsed.baseClass) {
                    print(
                        "\(filePath):\(lineNum):\(col): warning: " +
                        TailwindValidationMessages.invalidColorVariableUsage(className: className, variable: invalidColorVar)
                    )
                }

                if let vt = viewType,
                   (vt == "Text" || vt == "Image"),
                   TailwindClassCatalog.isLayoutClass(parsed.baseClass) {
                    print("\(filePath):\(lineNum):\(col): error: '\(className)' is a layout class and has no effect on \(vt)")
                }
            }

            for conflict in TailwindConflictValidation.detectConflicts(in: classes) {
                print("\(filePath):\(lineNum):\(col): warning: \(TailwindValidationMessages.conflictingStyles(previous: conflict.previous, current: conflict.current, scope: conflict.scope))")
            }

            searchRange = closeQuote.upperBound..<line.endIndex
        }
    }
}
