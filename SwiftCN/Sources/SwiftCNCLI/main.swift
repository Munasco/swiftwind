import Foundation

enum SwiftCNError: Error, CustomStringConvertible {
    case usage(String)
    case unknownComponent(String)
    case existingFile(String)
    case writeFailed(String)

    var description: String {
        switch self {
        case let .usage(msg): return msg
        case let .unknownComponent(name): return "Unknown component: \(name)"
        case let .existingFile(path): return "File already exists: \(path). Use --force to overwrite."
        case let .writeFailed(path): return "Failed to write file: \(path)"
        }
    }
}

struct Template {
    let filename: String
    let contents: String
}

struct CLI {
    private static let available: [String: Template] = [
        "button": Template(filename: "Button.swift", contents: buttonTemplate),
        "badge": Template(filename: "Badge.swift", contents: badgeTemplate),
        "card": Template(filename: "Card.swift", contents: cardTemplate),
        "input": Template(filename: "Input.swift", contents: inputTemplate),
    ]

    static func run(args: [String]) throws {
        guard let command = args.first else {
            throw SwiftCNError.usage(usage)
        }

        switch command {
        case "list":
            list()
        case "add":
            try add(args: Array(args.dropFirst()))
        default:
            throw SwiftCNError.usage("Unknown command: \(command)\n\n\(usage)")
        }
    }

    private static func list() {
        print("Available components:")
        for name in available.keys.sorted() {
            print("- \(name)")
        }
    }

    private static func add(args: [String]) throws {
        guard !args.isEmpty else {
            throw SwiftCNError.usage("Missing component name(s).\n\n\(usage)")
        }

        var outDir = "./Components/SwiftCN"
        var force = false
        var names: [String] = []

        var i = 0
        while i < args.count {
            let arg = args[i]
            if arg == "--out" {
                let next = i + 1
                guard next < args.count else {
                    throw SwiftCNError.usage("--out requires a directory path")
                }
                outDir = args[next]
                i += 2
                continue
            }
            if arg == "--force" {
                force = true
                i += 1
                continue
            }
            names.append(arg)
            i += 1
        }

        if names.contains("all") {
            names = Array(available.keys).sorted()
        }

        let fm = FileManager.default
        try fm.createDirectory(atPath: outDir, withIntermediateDirectories: true)

        for name in names {
            guard let template = available[name] else {
                throw SwiftCNError.unknownComponent(name)
            }
            let path = (outDir as NSString).appendingPathComponent(template.filename)
            if fm.fileExists(atPath: path), !force {
                throw SwiftCNError.existingFile(path)
            }
            guard let data = template.contents.data(using: .utf8) else {
                throw SwiftCNError.writeFailed(path)
            }
            fm.createFile(atPath: path, contents: data)
            print("Created: \(path)")
        }
    }

    private static let usage = """
    swiftcn - shadcn-inspired SwiftUI scaffolder

    Usage:
      swiftcn list
      swiftcn add <component...|all> [--out <dir>] [--force]

    Examples:
      swiftcn list
      swiftcn add button badge --out ./Features/UI
      swiftcn add all --out ./Components/SwiftCN
    """

    private static let buttonTemplate = """
    import SwiftUI
    import TailwindSwiftUI

    public struct Button: View {
        public enum Variant { case `default`, destructive, outline, secondary, ghost, link }
        public enum Size { case `default`, sm, lg, icon }

        private let title: String
        private let variant: Variant
        private let size: Size
        private let action: () -> Void

        public init(_ title: String, variant: Variant = .default, size: Size = .default, action: @escaping () -> Void = {}) {
            self.title = title
            self.variant = variant
            self.size = size
            self.action = action
        }

        public var body: some View {
            SwiftUI.Button(action: action) {
                Text(title)
            }
            .tw("\\(base) \\(variantClass) \\(sizeClass)")
        }

        private var base: String { "rounded-md text-sm font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500" }

        private var variantClass: String {
            switch variant {
            case .default: return "bg-blue-600 text-white"
            case .destructive: return "bg-red-600 text-white"
            case .outline: return "border border-slate-600 bg-transparent text-slate-100"
            case .secondary: return "bg-slate-200 text-slate-900 dark:bg-slate-700 dark:text-white"
            case .ghost: return "bg-transparent text-slate-100"
            case .link: return "bg-transparent text-blue-500 underline"
            }
        }

        private var sizeClass: String {
            switch size {
            case .default: return "px-4 py-2"
            case .sm: return "px-3 py-1 text-sm"
            case .lg: return "px-6 py-3 text-base"
            case .icon: return "w-10 h-10 p-0"
            }
        }
    }
    """

    private static let badgeTemplate = """
    import SwiftUI
    import TailwindSwiftUI

    public struct Badge: View {
        public enum Variant { case `default`, secondary, destructive, outline }

        private let text: String
        private let variant: Variant

        public init(_ text: String, variant: Variant = .default) {
            self.text = text
            self.variant = variant
        }

        public var body: some View {
            Text(text)
                .tw("rounded-full px-2.5 py-0.5 text-xs font-semibold \\(variantClass)")
        }

        private var variantClass: String {
            switch variant {
            case .default: return "bg-blue-600 text-white"
            case .secondary: return "bg-slate-200 text-slate-900 dark:bg-slate-700 dark:text-white"
            case .destructive: return "bg-red-600 text-white"
            case .outline: return "border border-slate-600 text-slate-100 bg-transparent"
            }
        }
    }
    """

    private static let cardTemplate = """
    import SwiftUI
    import TailwindSwiftUI

    public struct Card<Content: View>: View {
        private let content: Content

        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .tw("rounded-xl border border-slate-700 bg-slate-900 text-slate-100 shadow-sm")
        }
    }
    """

    private static let inputTemplate = """
    import SwiftUI
    import TailwindSwiftUI

    public struct Input: View {
        private let title: String
        @Binding private var text: String

        public init(_ title: String = "", text: Binding<String>) {
            self.title = title
            self._text = text
        }

        public var body: some View {
            TextField(title, text: $text)
                .tw("h-10 w-full rounded-md border border-slate-600 bg-transparent px-3 py-2 text-sm text-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-500")
        }
    }
    """
}

@main
struct SwiftCNMain {
    static func main() {
        do {
            try CLI.run(args: Array(CommandLine.arguments.dropFirst()))
        } catch {
            fputs("swiftcn error: \(error)\n", stderr)
            exit(1)
        }
    }
}
