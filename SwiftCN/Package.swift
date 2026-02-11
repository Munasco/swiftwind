// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftCN",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(
            name: "swiftcn",
            targets: ["SwiftCNCLI"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "SwiftCNCLI",
            path: "Sources/SwiftCNCLI"
        ),
    ]
)
