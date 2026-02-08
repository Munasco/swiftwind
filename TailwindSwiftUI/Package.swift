// swift-tools-version: 6.2
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "TailwindSwiftUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(
            name: "TailwindSwiftUI",
            targets: ["TailwindSwiftUI"]
        ),
        .plugin(
            name: "TailwindLintPlugin",
            targets: ["TailwindLintPlugin"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
    ],
    targets: [
        .target(
            name: "TailwindSwiftUI",
            dependencies: ["TailwindMacros"]
        ),
        .macro(
            name: "TailwindMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .executableTarget(
            name: "TailwindLinter",
            path: "Sources/TailwindLinter"
        ),
        .plugin(
            name: "TailwindLintPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "TailwindLinter"),
            ]
        ),
        .testTarget(
            name: "TailwindSwiftUITests",
            dependencies: ["TailwindSwiftUI"]
        ),
        .testTarget(
            name: "TailwindMacroTests",
            dependencies: [
                "TailwindMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
