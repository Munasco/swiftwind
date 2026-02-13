import PackagePlugin
import Foundation

@main
struct TailwindLintPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let sourceTarget = target as? SourceModuleTarget else { return [] }

        let swiftFiles = sourceTarget.sourceFiles.filter { $0.type == .source && $0.url.pathExtension == "swift" }
        guard !swiftFiles.isEmpty else { return [] }

        let tool = try context.tool(named: "TailwindLinterCLI")
        let inputFiles = swiftFiles.map(\.url)

        return [
            .prebuildCommand(
                displayName: "TailwindSwiftUI Lint",
                executable: tool.url,
                arguments: inputFiles.map(\.path),
                outputFilesDirectory: context.pluginWorkDirectoryURL.appending(path: "TailwindLint")
            )
        ]
    }
}
