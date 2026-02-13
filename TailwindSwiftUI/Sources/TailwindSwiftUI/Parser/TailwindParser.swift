import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif
import TailwindLinter

@resultBuilder
public enum TailwindClassBuilder {
    public static func buildBlock(_ components: [String]...) -> [String] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: String) -> [String] {
        [expression]
    }

    public static func buildExpression(_ expression: String?) -> [String] {
        guard let expression else { return [] }
        return [expression]
    }

    public static func buildExpression(_ expression: [String]) -> [String] {
        expression
    }

    public static func buildOptional(_ component: [String]?) -> [String] {
        component ?? []
    }

    public static func buildEither(first component: [String]) -> [String] {
        component
    }

    public static func buildEither(second component: [String]) -> [String] {
        component
    }

    public static func buildArray(_ components: [[String]]) -> [String] {
        components.flatMap { $0 }
    }

    public static func buildLimitedAvailability(_ component: [String]) -> [String] {
        component
    }
}

// MARK: - String-based Tailwind Modifier
public extension View {
    /// Tailwind-style className string
    /// Usage: Text("Hello").tw("p-4 bg-red-500 rounded-lg shadow-md")
    /// Works on ALL SwiftUI views: Text, VStack, HStack, Image, Button, etc.
    func tw(_ classes: String) -> TailwindModifier<Self> {
        return TailwindModifier(classes: classes, content: self)
    }

    /// Tailwind-style multiline class builder.
    /// Usage:
    ///   Text("Hello").tw {
    ///     "p-4"
    ///     if isPrimary { "bg-blue-500 text-white" }
    ///   }
    func tw(@TailwindClassBuilder _ classes: () -> [String]) -> TailwindModifier<Self> {
        let merged = classes()
            .flatMap { $0.split(separator: " ").map(String.init) }
            .joined(separator: " ")
        return TailwindModifier(classes: merged, content: self)
    }
}

public struct TailwindModifier<Content: View>: View {
    let classes: [String]
    let rawClasses: [String]
    let content: Content
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isFocused) private var isFocused
    @Environment(\.twGroupDark) private var twGroupDark
    @Environment(\.twGroupFocused) private var twGroupFocused
    @Environment(\.twGroupHovered) private var twGroupHovered
    @Environment(\.twGroupActive) private var twGroupActive
    @Environment(\.twPeerStates) private var twPeerStates
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.twPositionMode) var twPositionMode
    @State private var isHovered = false
    @State private var isPressed = false
    @State private var isInsideNativeScrollView = false
    @State private var didWarnNestedOverflowY = false

    init(classes: String, content: Content) {
        let rawInput = classes.split(separator: " ").map(String.init)
        let raw = TailwindRuntime.expandUtilityAliases(rawInput)
        self.rawClasses = raw
        Self.warnConflictingClasses(raw)
        // Sort to match CSS-like behavior independent of class string ordering:
        // 1) box-model priority (text/font → sizing → padding → background → clip → border/ring → shadow → blur)
        // 2) unvarianted utilities first, variant utilities second (so dark:/hover:/etc. override base when active)
        // 3) reverse original order as final tiebreaker so later classes in
        //    the same scope win (Tailwind-like cascade behavior).
        self.classes = raw.enumerated()
            .sorted { lhs, rhs in
                let left = Self.classSortKey(lhs.element, originalIndex: lhs.offset)
                let right = Self.classSortKey(rhs.element, originalIndex: rhs.offset)
                return left < right
            }
            .map(\.element)
        self.content = content
    }

    fileprivate static func warnConflictingClasses(_ classes: [String]) {
        for conflict in TailwindConflictValidation.detectConflicts(in: classes) {
            TailwindLogger.warn(
                TailwindValidationMessages.conflictingStyles(
                    previous: conflict.previous,
                    current: conflict.current,
                    scope: conflict.scope
                )
            )
        }
    }

    fileprivate static func hasCrossScopeConflicts(previous: [String], incoming: [String]) -> Bool {
        TailwindConflictValidation.hasCrossScopeConflicts(previous: previous, incoming: incoming)
    }

    static func conflictGroup(for baseClass: String) -> String? {
        TailwindConflictValidation.conflictGroup(for: baseClass)
    }

    /// Lower number = applied first (innermost modifier).
    private static func classPriority(_ cls: String) -> Int {
        // Typography & font — innermost, affects text rendering
        if cls.hasPrefix("text-") || cls.hasPrefix("font-") ||
           cls.hasPrefix("tracking-") || cls.hasPrefix("leading-") ||
           cls.hasPrefix("line-clamp-") || cls == "italic" || cls == "not-italic" ||
           cls == "uppercase" || cls == "lowercase" || cls == "capitalize" ||
           cls == "normal-case" || cls == "truncate" || cls == "underline" ||
           cls == "line-through" || cls == "no-underline" || cls == "overline" ||
           cls == "antialiased" || cls == "subpixel-antialiased" { return 0 }
        // Sizing — w, h, frame
        if cls.hasPrefix("w-") || cls.hasPrefix("h-") || cls.hasPrefix("size-") ||
           cls.hasPrefix("min-w-") || cls.hasPrefix("max-w-") ||
           cls.hasPrefix("min-h-") || cls.hasPrefix("max-h-") ||
           cls.hasPrefix("aspect-") { return 1 }
        // Position mode should be established before inset/top/left offsets
        if cls == "static" || cls == "relative" || cls == "absolute" || cls == "fixed" || cls == "sticky" { return 1 }
        if cls.hasPrefix("inset-") || cls.hasPrefix("top-") || cls.hasPrefix("right-") ||
           cls.hasPrefix("bottom-") || cls.hasPrefix("left-") || cls.hasPrefix("start-") || cls.hasPrefix("end-") {
            return 2
        }
        // Padding — must come before background so bg covers padding area
        if cls.hasPrefix("p-") || cls.hasPrefix("px-") || cls.hasPrefix("py-") ||
           cls.hasPrefix("pt-") || cls.hasPrefix("pr-") || cls.hasPrefix("pb-") ||
           cls.hasPrefix("pl-") || cls.hasPrefix("pe-") || cls.hasPrefix("ps-") { return 2 }
        // Background — after padding, before clipShape
        if cls.hasPrefix("bg-") { return 3 }
        // Clip shape (rounded) — clips the background
        if cls.hasPrefix("rounded") { return 4 }
        // Border & ring overlays — on top of clipped shape
        if cls.hasPrefix("border") || cls.hasPrefix("ring") { return 5 }
        // Shadow — renders outside the clipped shape
        if cls.hasPrefix("shadow") || cls.hasPrefix("drop-shadow") { return 6 }
        // Blur & effects — outermost
        if cls.hasPrefix("blur") { return 7 }
        // Everything else (margin, layout, transforms, etc.) — normal
        return 3
    }

    private static func classSortKey(_ cls: String, originalIndex: Int) -> (Int, Int, Int) {
        let parsed = parseVariantMetadata(cls)
        let priority = classPriority(parsed.baseClass)
        let variantPhase = parsed.variantCount > 0 ? 1 : 0
        return (priority, variantPhase, -originalIndex)
    }

    private static func parseVariantMetadata(_ className: String) -> (baseClass: String, variantCount: Int) {
        let parsed = TailwindClassParsing.parseVariantClass(className)
        return (parsed.baseClass, parsed.variants.count)
    }

    private var viewType: TWViewType {
        TWViewType(from: Content.self)
    }

    public var body: some View {
        var view = AnyView(content)
        let gradient = resolveV4LinearGradient(from: rawClasses)
        let isGroupContainer = rawClasses.contains("group")
        let peerMarker = peerMarkerId(from: rawClasses)
        let wantsHoverTracking = needsHoverTracking(rawClasses)
        let wantsPressTracking = needsPressTracking(rawClasses)
        let wantsOverflowYTracking = rawClasses.contains { $0 == "overflow-y-scroll" || $0 == "overflow-y-auto" }

        #if DEBUG
        warnIfOverflowAxisLikelyUnbounded()
        warnIfNestedOverflowY()
        #endif

        if let gradient {
            view = AnyView(view.background(gradient))
        }

        // Pre-compute padding: resolve all padding classes to final per-side values
        // so they don't stack. In CSS, last declaration wins — we match that.
        let resolvedPadding = resolvePadding()
        if resolvedPadding.top != 0 || resolvedPadding.bottom != 0 ||
           resolvedPadding.leading != 0 || resolvedPadding.trailing != 0 {
            view = AnyView(view.padding(resolvedPadding))
        }

        // Resolve a single background color class so bg-* utilities override
        // each other like CSS instead of stacking SwiftUI background layers.
        if let bgClass = resolveFinalBackgroundColorClass() {
            view = applyClass(bgClass, to: view)
        }

        // Resolve a single rounded class so conflicting rounded-* utilities
        // don't stack multiple clip layers.
        if let roundedClass = resolveFinalRoundedClass() {
            view = applyClass(roundedClass, to: view)
        }

        for className in classes {
            if isMarkerClass(className) { continue }
            // Skip padding classes — already applied above
            if isPaddingClass(className) { continue }
            // Skip gradient classes handled in the prepass.
            if isV4GradientClass(className) { continue }

            let parsed = parseVariants(from: className)
            if isBackgroundColorClass(parsed.baseClass) { continue }
            if isRoundedClass(parsed.baseClass) { continue }
            if parsed.variants.isEmpty {
                view = applyClass(parsed.baseClass, to: view)
                continue
            }

            if shouldApply(variants: parsed.variants) {
                view = applyClass(parsed.baseClass, to: view)
            }
        }

        if isGroupContainer {
            view = AnyView(
                view
                    .environment(\.twGroupDark, colorScheme == .dark)
                    .environment(\.twGroupFocused, isFocused)
                    .environment(\.twGroupHovered, isHovered)
                    .environment(\.twGroupActive, isPressed)
            )
        }

        if let peerId = peerMarker {
            let state = TWPeerState(
                isDark: colorScheme == .dark,
                isFocused: isFocused,
                isHovered: isHovered,
                isActive: isPressed,
                isEnabled: isEnabled
            )
            // Fallback registry so peer-* can still work without explicit
            // twPeerScope() on a shared ancestor.
            TWGlobalPeerRegistry.set(state, for: peerId)
            view = AnyView(
                view.background(
                    Color.clear.preference(
                        key: TWPeerStatesPreferenceKey.self,
                        value: [peerId: state]
                    )
                )
            )
        }

        return view
            .twTrackHover(if: wantsHoverTracking) { hovered in
            isHovered = hovered
            }
            .twTrackPress(if: wantsPressTracking) { pressed in
                isPressed = pressed
            }
            .twDetectAncestorScrollView(if: wantsOverflowYTracking) { inside in
                isInsideNativeScrollView = inside
            }
    }

    private func resolveFinalBackgroundColorClass() -> String? {
        var resolved: (className: String, score: Int, index: Int)?
        for (index, token) in rawClasses.enumerated() {
            let parsed = parseVariants(from: token)
            guard isBackgroundColorClass(parsed.baseClass) else { continue }
            if parsed.variants.isEmpty || shouldApply(variants: parsed.variants) {
                let score = variantSpecificityScore(for: parsed.variants)
                if let current = resolved {
                    if score > current.score || (score == current.score && index > current.index) {
                        resolved = (parsed.baseClass, score, index)
                    }
                } else {
                    resolved = (parsed.baseClass, score, index)
                }
            }
        }
        return resolved?.className
    }

    private func variantSpecificityScore(for variants: [String]) -> Int {
        guard !variants.isEmpty else { return 0 } // base utility

        var score = variants.count * 10
        for variant in variants {
            switch variant {
            case "dark":
                // Tailwind dark variant should outrank base utility in dark mode.
                score += 10_000
            case "light":
                score += 9_000
            case "hover", "focus", "active":
                score += 2_000
            case "group-dark", "group-hover", "group-focus", "group-active":
                score += 3_000
            case "ios", "macos", "tvos", "watchos", "visionos":
                score += 500
            case "sm", "md", "lg", "xl", "2xl":
                score += 400
            default:
                if variant.hasPrefix("peer-") {
                    score += 3_000
                } else {
                    score += 100
                }
            }
        }
        return score
    }

    private func isRoundedClass(_ className: String) -> Bool {
        className.hasPrefix("rounded")
    }

    private func resolveFinalRoundedClass() -> String? {
        var resolved: (className: String, score: Int, index: Int)?
        for (index, token) in rawClasses.enumerated() {
            let parsed = parseVariants(from: token)
            guard isRoundedClass(parsed.baseClass) else { continue }
            if parsed.variants.isEmpty || shouldApply(variants: parsed.variants) {
                let score = variantSpecificityScore(for: parsed.variants)
                if let current = resolved {
                    if score > current.score || (score == current.score && index > current.index) {
                        resolved = (parsed.baseClass, score, index)
                    }
                } else {
                    resolved = (parsed.baseClass, score, index)
                }
            }
        }
        return resolved?.className
    }

    func resolvedOverlayCornerRadius() -> CGFloat {
        guard let roundedClass = resolveFinalRoundedClass(),
              let radius = parseRadius(from: roundedClass) else { return 0 }
        return radius
    }

    private func isBackgroundColorClass(_ className: String) -> Bool {
        guard className.hasPrefix("bg-"),
              !className.hasPrefix("bg-opacity-"),
              !className.hasPrefix("bg-gradient-"),
              !className.hasPrefix("bg-clip-"),
              !className.hasPrefix("bg-origin-"),
              !className.hasPrefix("bg-no-repeat"),
              !className.hasPrefix("bg-repeat"),
              !className.hasPrefix("bg-cover"),
              !className.hasPrefix("bg-contain"),
              !className.hasPrefix("bg-center"),
              !className.hasPrefix("bg-fixed"),
              !className.hasPrefix("bg-local"),
              !className.hasPrefix("bg-scroll"),
              !className.hasPrefix("bg-none")
        else { return false }
        return parseColor(from: className, prefix: "bg-") != nil
    }

    /// Returns true for any class that sets padding (handled by resolvePadding).
    private func isPaddingClass(_ cls: String) -> Bool {
        if cls.hasPrefix("p-") && !cls.hasPrefix("pl-") && !cls.hasPrefix("pr-") &&
           !cls.hasPrefix("pt-") && !cls.hasPrefix("pb-") && !cls.hasPrefix("px-") &&
           !cls.hasPrefix("py-") && !cls.hasPrefix("pe-") && !cls.hasPrefix("ps-") { return true }
        if cls.hasPrefix("px-") || cls.hasPrefix("py-") { return true }
        if cls.hasPrefix("pt-") || cls.hasPrefix("pr-") || cls.hasPrefix("pb-") || cls.hasPrefix("pl-") { return true }
        if cls.hasPrefix("pe-") || cls.hasPrefix("ps-") { return true }
        return false
    }

    private func isMarkerClass(_ cls: String) -> Bool {
        if cls == "group" || cls == "peer" { return true }
        if cls.hasPrefix("peer/") {
            let id = String(cls.dropFirst("peer/".count))
            return !id.isEmpty
        }
        return false
    }

    private func peerMarkerId(from classes: [String]) -> String? {
        for cls in classes {
            if cls == "peer" { return "default" }
            if cls.hasPrefix("peer/") {
                let id = String(cls.dropFirst("peer/".count))
                if !id.isEmpty { return id }
            }
        }
        return nil
    }

    private func needsHoverTracking(_ classes: [String]) -> Bool {
        if classes.contains("group") || classes.contains("peer") || classes.contains(where: { $0.hasPrefix("peer/") }) {
            return true
        }
        for cls in classes {
            let parsed = parseVariants(from: cls)
            for variant in parsed.variants {
                if variant == "hover" || variant == "group-hover" { return true }
                if variant.hasPrefix("peer-hover") { return true }
            }
        }
        return false
    }

    private func needsPressTracking(_ classes: [String]) -> Bool {
        if classes.contains("group") || classes.contains("peer") || classes.contains(where: { $0.hasPrefix("peer/") }) {
            return true
        }
        for cls in classes {
            let parsed = parseVariants(from: cls)
            for variant in parsed.variants {
                if variant == "active" || variant == "group-active" { return true }
                if variant.hasPrefix("peer-active") { return true }
            }
        }
        return false
    }

    #if DEBUG
    private func warnIfOverflowAxisLikelyUnbounded() {
        let hasOverflowY = rawClasses.contains {
            ($0 == "overflow-y-scroll" || $0 == "overflow-y-auto") &&
            !TailwindNativeWindParity.isWebOnlyClassOnNative($0)
        }
        let hasOverflowX = rawClasses.contains {
            ($0 == "overflow-x-scroll" || $0 == "overflow-x-auto") &&
            !TailwindNativeWindParity.isWebOnlyClassOnNative($0)
        }

        if hasOverflowY && !hasHeightConstraintClass(rawClasses) {
            TailwindLogger.warn("'\(hasOverflowY ? "overflow-y-scroll/auto" : "overflow-y")' may not scroll without a bounded height. Add h-*, max-h-*, min-h-* or frame(height:).")
        }
        if hasOverflowX && !hasWidthConstraintClass(rawClasses) {
            TailwindLogger.warn("'\(hasOverflowX ? "overflow-x-scroll/auto" : "overflow-x")' may not scroll without wide content or bounded width.")
        }
    }

    private func warnIfNestedOverflowY() {
        guard isInsideNativeScrollView else { return }
        guard !didWarnNestedOverflowY else { return }
        guard rawClasses.contains(where: {
            ($0 == "overflow-y-scroll" || $0 == "overflow-y-auto") &&
            !TailwindNativeWindParity.isWebOnlyClassOnNative($0)
        }) else { return }

        TailwindLogger.warn("'overflow-y-scroll/auto' is inside a parent ScrollView. Same-axis nested scrolling may conflict. Prefer one vertical scroller, or keep the inner view fixed-height and non-page-critical.")
        didWarnNestedOverflowY = true
    }

    private func hasHeightConstraintClass(_ classes: [String]) -> Bool {
        classes.contains {
            $0.hasPrefix("h-") || $0.hasPrefix("max-h-") || $0.hasPrefix("min-h-") || $0.hasPrefix("size-")
        }
    }

    private func hasWidthConstraintClass(_ classes: [String]) -> Bool {
        classes.contains {
            $0.hasPrefix("w-") || $0.hasPrefix("max-w-") || $0.hasPrefix("min-w-") || $0.hasPrefix("size-")
        }
    }
    #endif

    private func parseVariants(from className: String) -> TailwindParsedClass {
        TailwindClassParsing.parseVariantClass(className)
    }

    private func shouldApply(variants: [String]) -> Bool {
        for variant in variants {
            switch variant {
            case "dark":
                if colorScheme != .dark { return false }
            case "light":
                if colorScheme != .light { return false }
            case "focus":
                if !isFocused { return false }
            case "hover":
                if !isHovered { return false }
            case "active":
                if !isPressed { return false }
            case "disabled":
                if isEnabled { return false }
            case "group-dark":
                if !twGroupDark { return false }
            case "group-focus":
                if !twGroupFocused { return false }
            case "group-hover":
                if !twGroupHovered { return false }
            case "group-active":
                if !twGroupActive { return false }
            case "sm", "md", "lg", "xl", "2xl":
                if !matchesResponsiveBreakpoint(variant) { return false }
            case "ios":
                #if os(iOS)
                break
                #else
                return false
                #endif
            case "macos":
                #if os(macOS)
                break
                #else
                return false
                #endif
            case "tvos":
                #if os(tvOS)
                break
                #else
                return false
                #endif
            case "watchos":
                #if os(watchOS)
                break
                #else
                return false
                #endif
            case "visionos":
                #if os(visionOS)
                break
                #else
                return false
                #endif
            default:
                if variant.hasPrefix("peer-") {
                    if !TailwindVariantValidation.isSupportedPeerVariant(variant) {
                        #if DEBUG
                        TailwindLogger.warn(TailwindValidationMessages.unsupportedVariant(variant))
                        #endif
                        return false
                    }
                    if !applyPeerVariant(variant) { return false }
                    continue
                }
                #if DEBUG
                TailwindLogger.warn(TailwindValidationMessages.unsupportedVariant(variant))
                #endif
                return false
            }
        }
        return true
    }

    private func applyPeerVariant(_ variant: String) -> Bool {
        // Supports:
        // - peer-dark
        // - peer-focus
        // - peer-hover
        // - peer-active
        // - peer-disabled
        // - peer-dark/id
        // - peer-focus/id
        // - peer-hover/id
        // - peer-active/id
        // - peer-disabled/id
        let body = String(variant.dropFirst("peer-".count))
        let parts = body.split(separator: "/", maxSplits: 1).map(String.init)
        guard let stateToken = parts.first else { return false }
        let peerId = parts.count > 1 ? parts[1] : "default"
        guard let peer = twPeerStates[peerId] ?? TWGlobalPeerRegistry.get(peerId) else { return false }

        switch stateToken {
        case "dark": return peer.isDark
        case "focus": return peer.isFocused
        case "hover": return peer.isHovered
        case "active": return peer.isActive
        case "disabled": return !peer.isEnabled
        default: return false
        }
    }

    private func matchesResponsiveBreakpoint(_ variant: String) -> Bool {
        let width = activeViewportWidth()
        return Self.matchesResponsiveBreakpoint(variant, width: width)
    }

    static func matchesResponsiveBreakpoint(_ variant: String, width: CGFloat) -> Bool {
        switch variant {
        case "sm": return width >= 640
        case "md": return width >= 768
        case "lg": return width >= 1024
        case "xl": return width >= 1280
        case "2xl": return width >= 1536
        default: return false
        }
    }

    private func activeViewportWidth() -> CGFloat {
        #if canImport(UIKit)
        // Use active window-scene window size so responsive breakpoints
        // track real app viewport (rotation, split view, stage manager).
        if let keyWindowWidth = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .filter({ $0.activationState == .foregroundActive })
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .bounds.width {
            return keyWindowWidth
        }

        // Fallback: first foreground scene window width.
        if let sceneWindowWidth = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .filter({ $0.activationState == .foregroundActive })
            .flatMap(\.windows)
            .first?
            .bounds.width {
            return sceneWindowWidth
        }

        return 0
        #elseif canImport(AppKit)
        if let keyWindowWidth = NSApplication.shared.windows
            .first(where: \.isKeyWindow)?
            .contentView?
            .bounds.width {
            return keyWindowWidth
        }

        if let firstWindowWidth = NSApplication.shared.windows
            .first?
            .contentView?
            .bounds.width {
            return firstWindowWidth
        }

        return 0
        #else
        return 0
        #endif
    }

    /// Resolve all padding classes into a single EdgeInsets. Last class wins per-side, matching CSS.
    private func resolvePadding() -> EdgeInsets {
        var top: CGFloat?
        var bottom: CGFloat?
        var leading: CGFloat?
        var trailing: CGFloat?

        // Process in original (pre-sort) order so "last wins" is correct
        for cls in classes {
            if cls.hasPrefix("p-") && !cls.hasPrefix("pl-") && !cls.hasPrefix("pr-") &&
               !cls.hasPrefix("pt-") && !cls.hasPrefix("pb-") && !cls.hasPrefix("px-") &&
               !cls.hasPrefix("py-") && !cls.hasPrefix("pe-") && !cls.hasPrefix("ps-") {
                if let v = extractNumber(from: cls, prefix: "p-") {
                    let pts = spacingValue(v)
                    top = pts; bottom = pts; leading = pts; trailing = pts
                }
            } else if cls.hasPrefix("px-") {
                if let v = extractNumber(from: cls, prefix: "px-") {
                    let pts = spacingValue(v)
                    leading = pts; trailing = pts
                }
            } else if cls.hasPrefix("py-") {
                if let v = extractNumber(from: cls, prefix: "py-") {
                    let pts = spacingValue(v)
                    top = pts; bottom = pts
                }
            } else if cls.hasPrefix("pt-") {
                if let v = extractNumber(from: cls, prefix: "pt-") { top = spacingValue(v) }
            } else if cls.hasPrefix("pb-") {
                if let v = extractNumber(from: cls, prefix: "pb-") { bottom = spacingValue(v) }
            } else if cls.hasPrefix("pl-") || cls.hasPrefix("ps-") {
                let prefix = cls.hasPrefix("pl-") ? "pl-" : "ps-"
                if let v = extractNumber(from: cls, prefix: prefix) { leading = spacingValue(v) }
            } else if cls.hasPrefix("pr-") || cls.hasPrefix("pe-") {
                let prefix = cls.hasPrefix("pr-") ? "pr-" : "pe-"
                if let v = extractNumber(from: cls, prefix: prefix) { trailing = spacingValue(v) }
            }
        }

        return EdgeInsets(
            top: top ?? 0,
            leading: leading ?? 0,
            bottom: bottom ?? 0,
            trailing: trailing ?? 0
        )
    }


    // MARK: - Main Dispatch
    private func applyClass(_ className: String, to view: AnyView) -> AnyView {
        if TailwindNativeWindParity.isWebOnlyClassOnNative(className) {
            #if DEBUG
            TailwindLogger.warn("'\(className)' is web-only in NativeWind and is ignored on native platforms.")
            #endif
            return view
        }

        // Validate class against view type
        #if DEBUG
        if let result = TailwindValidation.validate(className, viewType: viewType) {
            switch result.level {
            case .error:
                TailwindLogger.error(result.message)
                return view // Skip applying the incompatible class
            case .warning:
                TailwindLogger.warn(result.message)
                // Continue applying - it might still partially work
            }
        }
        #endif

        // Try each category in order. First match wins.
        if let r = applySpacingClass(className, to: view) { return r }
        if let r = applyColorClass(className, to: view) { return r }
        if let r = applyTypographyClass(className, to: view) { return r }
        if let r = applySizingClass(className, to: view) { return r }
        if let r = applyLayoutClass(className, to: view) { return r }
        if let r = applyBorderClass(className, to: view) { return r }
        if let r = applyEffectsClass(className, to: view) { return r }
        if let r = applyTransformClass(className, to: view) { return r }
        if let r = applyInteractivityClass(className, to: view) { return r }
        if let r = applyAccessibilityClass(className, to: view) { return r }
        if let r = applyBracketClass(className, to: view) { return r }
        if let r = applyNativeWindCompatNoOpClass(className, to: view) { return r }

        // Avoid duplicate logs for classes that are known but intentionally scoped
        // away from this host view type (for example layout classes on VStack/HStack).
        #if DEBUG
        if TailwindClassCatalog.isLayoutClass(className), viewType != .twView {
            return view
        }
        #endif

        #if DEBUG
        TailwindLogger.warn(TailwindValidationMessages.unknownClass(className))
        #endif
        return view
    }
}

public extension TailwindModifier {
    /// Prevents nested Tailwind modifier stacks for direct `.tw(...).tw(...)` chains
    /// by merging classes into a single TailwindModifier instance.
    /// Warns only when there are actual cross-scope conflicts.
    func tw(_ classes: String) -> TailwindModifier<Content> {
        let additional = TailwindRuntime.expandUtilityAliases(
            classes.split(separator: " ").map(String.init)
        )
        if TailwindModifier<Content>.hasCrossScopeConflicts(previous: rawClasses, incoming: additional) {
            TailwindLogger.warn(TailwindValidationMessages.conflictingStylesAcrossChainedScopes)
        }
        let merged = (rawClasses + additional).joined(separator: " ")
        return TailwindModifier(classes: merged, content: content)
    }

    /// Multiline builder variant for chained .tw().
    func tw(@TailwindClassBuilder _ classes: () -> [String]) -> TailwindModifier<Content> {
        let merged = classes()
            .flatMap { $0.split(separator: " ").map(String.init) }
            .joined(separator: " ")
        return tw(merged)
    }
}

private extension View {
    @ViewBuilder
    func twTrackHover(if enabled: Bool, onChange: @escaping (Bool) -> Void) -> some View {
        #if os(macOS) || targetEnvironment(macCatalyst) || os(iOS)
        if enabled {
            self.onHover(perform: onChange)
        } else {
            self
        }
        #else
        self
        #endif
    }

    @ViewBuilder
    func twTrackPress(if enabled: Bool, onChange: @escaping (Bool) -> Void) -> some View {
        if enabled {
            self
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in onChange(true) }
                        .onEnded { _ in onChange(false) }
                )
        } else {
            self
        }
    }

    @ViewBuilder
    func twDetectAncestorScrollView(if enabled: Bool, onChange: @escaping (Bool) -> Void) -> some View {
        if enabled {
            self.background(TWScrollAncestorProbe(onChange: onChange))
        } else {
            self
        }
    }
}

private struct TWScrollAncestorProbe: View {
    let onChange: (Bool) -> Void

    var body: some View {
        #if canImport(UIKit)
        TWUIKitScrollAncestorProbe(onChange: onChange)
        #elseif canImport(AppKit)
        TWAppKitScrollAncestorProbe(onChange: onChange)
        #else
        Color.clear
            .frame(width: 0, height: 0)
            .onAppear { onChange(false) }
        #endif
    }
}

#if canImport(UIKit)
private struct TWUIKitScrollAncestorProbe: UIViewRepresentable {
    let onChange: (Bool) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            onChange(hasScrollAncestor(view))
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            onChange(hasScrollAncestor(uiView))
        }
    }

    private func hasScrollAncestor(_ view: UIView) -> Bool {
        var current = view.superview
        while let node = current {
            if node is UIScrollView { return true }
            current = node.superview
        }
        return false
    }
}
#endif

#if canImport(AppKit)
private struct TWAppKitScrollAncestorProbe: NSViewRepresentable {
    let onChange: (Bool) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        DispatchQueue.main.async {
            onChange(hasScrollAncestor(view))
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            onChange(hasScrollAncestor(nsView))
        }
    }

    private func hasScrollAncestor(_ view: NSView) -> Bool {
        var current = view.superview
        while let node = current {
            if node is NSScrollView { return true }
            current = node.superview
        }
        return false
    }
}
#endif

// MARK: - Shared Helpers
extension TailwindModifier {
    func currentColorScheme() -> ColorScheme {
        colorScheme
    }

    // Placeholder hooks for upcoming Tailwind v4 non-arbitrary gradient pipeline.
    // Supports classes like:
    // - bg-linear-to-r
    // - bg-linear-to-br
    // - bg-linear-45
    // - from-red-500 via-cyan-500 to-blue-500
    func resolveV4LinearGradient(from classes: [String]) -> LinearGradient? {
        var directionClass: String?
        var angle: Double?
        var from: Color?
        var via: Color?
        var to: Color?

        for token in classes {
            if token.hasPrefix("bg-linear-to-") {
                directionClass = token
                continue
            }
            if token.hasPrefix("bg-linear-"),
               !token.hasPrefix("bg-linear-to-") {
                let suffix = token.replacingOccurrences(of: "bg-linear-", with: "")
                if let rawAngle = Double(suffix) {
                    angle = rawAngle
                }
                continue
            }
            if token.hasPrefix("from-") {
                from = parseColor(from: token, prefix: "from-")
                continue
            }
            if token.hasPrefix("via-") {
                via = parseColor(from: token, prefix: "via-")
                continue
            }
            if token.hasPrefix("to-") {
                to = parseColor(from: token, prefix: "to-")
                continue
            }
        }

        guard from != nil || via != nil || to != nil else { return nil }
        let gradientColors = [from, via, to].compactMap { $0 }
        guard gradientColors.count >= 2 else { return nil }

        let points: (UnitPoint, UnitPoint)
        if let directionClass {
            points = linearPoints(forDirectionalClass: directionClass)
        } else if let angle {
            points = linearPoints(forAngle: angle)
        } else {
            points = (.top, .bottom)
        }

        return LinearGradient(
            colors: gradientColors,
            startPoint: points.0,
            endPoint: points.1,
            interpolation: .oklch
        )
    }

    func isV4GradientClass(_ className: String) -> Bool {
        if className.hasPrefix("bg-linear-") { return true }
        if className.hasPrefix("from-") || className.hasPrefix("via-") || className.hasPrefix("to-") { return true }
        return false
    }

    private func linearPoints(forDirectionalClass cls: String) -> (UnitPoint, UnitPoint) {
        switch cls {
        case "bg-linear-to-r": return (.leading, .trailing)
        case "bg-linear-to-l": return (.trailing, .leading)
        case "bg-linear-to-t": return (.bottom, .top)
        case "bg-linear-to-b": return (.top, .bottom)
        case "bg-linear-to-tr": return (.bottomLeading, .topTrailing)
        case "bg-linear-to-tl": return (.bottomTrailing, .topLeading)
        case "bg-linear-to-br": return (.topLeading, .bottomTrailing)
        case "bg-linear-to-bl": return (.topTrailing, .bottomLeading)
        default: return (.top, .bottom)
        }
    }

    private func linearPoints(forAngle angle: Double) -> (UnitPoint, UnitPoint) {
        let normalized = angle.truncatingRemainder(dividingBy: 360)
        switch normalized {
        case 45: return (.bottomLeading, .topTrailing)
        case 90: return (.leading, .trailing)
        case 135: return (.topLeading, .bottomTrailing)
        case 180: return (.top, .bottom)
        case 225: return (.topTrailing, .bottomLeading)
        case 270: return (.trailing, .leading)
        case 315: return (.bottomTrailing, .topLeading)
        default: return (.top, .bottom)
        }
    }

    func extractNumber(from className: String, prefix: String) -> CGFloat? {
        let valueStr = className.replacingOccurrences(of: prefix, with: "")
        if valueStr.hasPrefix("[") {
            return extractBracketValue(from: className, prefix: prefix)
        }
        if let doubleVal = Double(valueStr) {
            return CGFloat(doubleVal)
        }
        return nil
    }

    func spacingValue(_ n: CGFloat) -> CGFloat {
        return n * 4
    }

    func extractBracketValue(from className: String, prefix: String) -> CGFloat? {
        let valueStr = className.replacingOccurrences(of: prefix, with: "")
        guard valueStr.hasPrefix("[") && valueStr.hasSuffix("]") else { return nil }
        let inner = String(valueStr.dropFirst().dropLast())
        if let resolved = resolveNumericValue(inner) {
            return resolved
        }

        if let raw = TailwindRuntime.rawVariable(inner, colorScheme: colorScheme) {
            return resolveNumericValue(raw)
        }

        return nil
    }

    private func resolveNumericValue(_ raw: String) -> CGFloat? {
        let inner = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let numeric = inner
            .replacingOccurrences(of: "px", with: "")
            .replacingOccurrences(of: "pt", with: "")
            .replacingOccurrences(of: "rem", with: "")
            .replacingOccurrences(of: "%", with: "")
        if let val = Double(numeric) {
            if inner.hasSuffix("rem") { return CGFloat(val * 16) }
            return CGFloat(val)
        }
        return nil
    }

    func parseBracketColor(from className: String, prefix: String) -> Color? {
        TailwindColorResolver.parseBracketColor(className, prefix: prefix, colorScheme: colorScheme)
    }

    func parseColor(from className: String, prefix: String) -> Color? {
        TailwindColorResolver.parseColor(className, prefix: prefix, colorScheme: colorScheme)
    }

    func parseRadius(from className: String) -> CGFloat? {
        switch className {
        case "rounded-none": return 0
        case "rounded-sm": return 2
        case "rounded": return 4
        case "rounded-md": return 6
        case "rounded-lg": return 8
        case "rounded-xl": return 12
        case "rounded-2xl": return 16
        case "rounded-3xl": return 24
        case "rounded-full": return 9999
        default: return nil
        }
    }

    func parseTextSize(from className: String) -> CGFloat? {
        switch className {
        case "text-xs": return 12
        case "text-sm": return 14
        case "text-base": return 16
        case "text-lg": return 18
        case "text-xl": return 20
        case "text-2xl": return 24
        case "text-3xl": return 30
        case "text-4xl": return 36
        case "text-5xl": return 48
        case "text-6xl": return 60
        case "text-7xl": return 72
        case "text-8xl": return 96
        case "text-9xl": return 128
        default: return nil
        }
    }

    func parseShadow(from className: String) -> (radius: CGFloat, y: CGFloat)? {
        switch className {
        case "shadow-sm": return (1, 1)
        case "shadow": return (2, 1)
        case "shadow-md": return (4, 2)
        case "shadow-lg": return (8, 4)
        case "shadow-xl": return (12, 8)
        case "shadow-2xl": return (24, 12)
        case "shadow-none": return (0, 0)
        case "shadow-inner": return (2, -1)
        default: return nil
        }
    }

    func parseBlur(from className: String) -> CGFloat? {
        switch className {
        case "blur-none": return 0
        case "blur-sm": return 4
        case "blur": return 8
        case "blur-md": return 12
        case "blur-lg": return 16
        case "blur-xl": return 24
        case "blur-2xl": return 40
        case "blur-3xl": return 64
        default: return nil
        }
    }
}
