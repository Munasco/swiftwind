import SwiftUI

enum TWOverflowScrollAxis {
    case vertical
    case horizontal
    case both
}

struct TWOverflowScrollContainer: View {
    let axis: TWOverflowScrollAxis
    let content: AnyView

    var body: some View {
#if canImport(UIKit) && !os(watchOS)
        TWUIKitOverflowScrollView(axis: axis, content: content)
#else
        switch axis {
        case .vertical:
            ScrollView(.vertical) { content }
        case .horizontal:
            ScrollView(.horizontal) { content }
        case .both:
            ScrollView([.horizontal, .vertical]) { content }
        }
#endif
    }
}

#if canImport(UIKit) && !os(watchOS)
import UIKit

private struct TWUIKitOverflowScrollView: UIViewRepresentable {
    let axis: TWOverflowScrollAxis
    let content: AnyView

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.keyboardDismissMode = .interactive

        let host = context.coordinator.hostingController
        host.rootView = configuredRootView()
#if os(iOS) || os(tvOS) || os(visionOS)
        if #available(iOS 16.0, tvOS 16.0, visionOS 1.0, *) {
            host.sizingOptions = [.intrinsicContentSize]
        }
#endif
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.setContentHuggingPriority(.required, for: .vertical)
        host.view.setContentCompressionResistancePriority(.required, for: .vertical)

        scrollView.addSubview(host.view)

        let constraints = [
            host.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)

        context.coordinator.widthConstraint = host.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        context.coordinator.heightConstraint = host.view.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        context.coordinator.widthConstraint?.priority = .required
        context.coordinator.heightConstraint?.priority = .required
        applyAxisConfiguration(scrollView, coordinator: context.coordinator)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController.rootView = configuredRootView()
        applyAxisConfiguration(uiView, coordinator: context.coordinator)
    }

    private func configuredRootView() -> AnyView {
        switch axis {
        case .vertical:
            return AnyView(content.fixedSize(horizontal: false, vertical: true))
        case .horizontal:
            return AnyView(content.fixedSize(horizontal: true, vertical: false))
        case .both:
            return AnyView(content.fixedSize(horizontal: true, vertical: true))
        }
    }

    private func applyAxisConfiguration(_ scrollView: UIScrollView, coordinator: Coordinator) {
        coordinator.widthConstraint?.isActive = false
        coordinator.heightConstraint?.isActive = false

        switch axis {
        case .vertical:
            coordinator.widthConstraint?.isActive = true
            scrollView.alwaysBounceVertical = true
            scrollView.alwaysBounceHorizontal = false
            scrollView.showsVerticalScrollIndicator = true
            scrollView.showsHorizontalScrollIndicator = false
        case .horizontal:
            coordinator.heightConstraint?.isActive = true
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = true
        case .both:
            scrollView.alwaysBounceVertical = true
            scrollView.alwaysBounceHorizontal = true
            scrollView.showsVerticalScrollIndicator = true
            scrollView.showsHorizontalScrollIndicator = true
        }
    }

    final class Coordinator {
        let hostingController = UIHostingController(rootView: AnyView(EmptyView()))
        var widthConstraint: NSLayoutConstraint?
        var heightConstraint: NSLayoutConstraint?
    }
}
#endif
