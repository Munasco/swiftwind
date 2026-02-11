import Foundation
import os

/// Diagnostics for Tailwind class validation.
/// Uses os.Logger so errors/warnings show up properly in Xcode console
/// with correct log levels (fault for errors, default for warnings).
public enum TailwindLogger {
    /// Set to false to silence all diagnostics
    #if DEBUG
    nonisolated(unsafe) public static var enabled: Bool = true
    #else
    nonisolated(unsafe) public static var enabled: Bool = false
    #endif

    private static let logger = Logger(subsystem: "com.tailwindswiftui", category: "validation")

    private actor DiagnosticCache {
        private var seen: Set<String> = []

        func isNew(_ key: String) -> Bool {
            seen.insert(key).inserted
        }

        func reset() {
            seen.removeAll()
        }
    }

    private static let cache = DiagnosticCache()

    /// Log an error - class is incompatible with the view and will be skipped.
    /// Shows as a fault-level log in Xcode (red highlight in console).
    public static func error(_ message: String) {
        guard enabled else { return }
        Task {
            guard await cache.isNew("e:\(message)") else { return }
            logger.fault("[TailwindSwiftUI] error: \(message)")
        }
    }

    /// Log a warning - class may not behave as expected but will still be applied.
    /// Shows as a warning-level log in Xcode.
    public static func warn(_ message: String) {
        guard enabled else { return }
        Task {
            guard await cache.isNew("w:\(message)") else { return }
            logger.warning("[TailwindSwiftUI] warn: \(message)")
        }
    }

    /// Reset seen diagnostics (useful in tests)
    public static func reset() {
        Task { await cache.reset() }
    }
}
