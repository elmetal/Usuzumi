import SwiftUI
import PencilKit
import PaperKit

// MARK: - Environment Keys

@available(iOS 26, *)
extension EnvironmentValues {
    @Entry var markupEditable: Bool = true
    @Entry var onMarkupChange: (@MainActor @Sendable (MarkupBoard) -> Void)? = nil
    @Entry var onMarkupSelectionChange: (@MainActor @Sendable (PaperMarkup?) -> Void)? = nil
    @Entry var onMarkupBeginDrawing: (@MainActor @Sendable () -> Void)? = nil
}

// MARK: - MarkupView

/// A SwiftUI view that wraps PaperKit's `PaperMarkupViewController` for rich markup editing.
///
/// ``MarkupView`` provides a SwiftUI-compatible interface to PaperKit, enabling
/// drawing, shapes, text, and image markup with Apple Pencil and finger input.
///
/// ## Overview
///
/// Use `MarkupView` to add rich markup capabilities to your SwiftUI app.
/// It supports all PaperKit features including drawing, shapes, text boxes, and images.
///
/// ### Simple Usage
///
/// ```swift
/// @State private var markup = MarkupBoard()
///
/// var body: some View {
///     MarkupView(markup)
///         .toolPickerVisible(true)
///         .editable(true)
/// }
/// ```
///
/// ## Topics
///
/// ### Creating a Markup View
/// - ``init(_:)``
@available(iOS 26, *)
public struct MarkupView: UIViewControllerRepresentable {
    /// The markup board that manages the markup state.
    public var markup: MarkupBoard

    // Shared ToolPicker environment keys
    @Environment(\.canvasToolPickerVisible) private var isToolPickerVisible
    @Environment(\.canvasRulerActive) private var isRulerActive
    @Environment(\.canvasShowsDrawingPolicyControls) private var showsDrawingPolicyControls
    @Environment(\.canvasToolPickerAutosaveName) private var toolPickerAutosaveName
    @Environment(\.canvasToolPickerColorUserInterfaceStyle) private var toolPickerColorStyle
    @Environment(\.canvasToolPickerOverrideUserInterfaceStyle) private var toolPickerOverrideStyle
    @Environment(\.canvasToolPickerItems) private var toolPickerItems
    @Environment(\.canvasToolPickerAccessoryItem) private var toolPickerAccessoryItem

    // MarkupView-specific environment keys
    @Environment(\.markupEditable) private var isEditable
    @Environment(\.onMarkupChange) private var onMarkupChange
    @Environment(\.onMarkupSelectionChange) private var onMarkupSelectionChange
    @Environment(\.onMarkupBeginDrawing) private var onMarkupBeginDrawing

    /// Creates a new markup view with the specified markup board.
    ///
    /// - Parameter markup: The markup board that manages the markup state.
    public init(_ markup: MarkupBoard) {
        self.markup = markup
    }

    public func makeUIViewController(context: Context) -> PaperMarkupViewController {
        let vc = PaperMarkupViewController(
            markup: markup.markup,
            supportedFeatureSet: markup.supportedFeatureSet
        )

        vc.delegate = context.coordinator
        vc.isEditable = isEditable
        vc.isRulerActive = isRulerActive

        markup.bind(to: vc)
        context.coordinator.markup = markup

        if isToolPickerVisible {
            context.coordinator.showToolPicker(for: vc, toolItems: toolPickerItems)
        }

        return vc
    }

    public func updateUIViewController(_ vc: PaperMarkupViewController, context: Context) {
        vc.isEditable = isEditable
        vc.isRulerActive = isRulerActive

        context.coordinator.onMarkupChange = onMarkupChange
        context.coordinator.onMarkupSelectionChange = onMarkupSelectionChange
        context.coordinator.onMarkupBeginDrawing = onMarkupBeginDrawing

        if isToolPickerVisible {
            if context.coordinator.toolPicker == nil {
                context.coordinator.showToolPicker(for: vc, toolItems: toolPickerItems)
            } else if context.coordinator.toolItemsNeedRecreation(toolPickerItems) {
                context.coordinator.hideToolPicker(from: vc)
                context.coordinator.showToolPicker(for: vc, toolItems: toolPickerItems)
            }
        } else if context.coordinator.toolPicker != nil {
            context.coordinator.hideToolPicker(from: vc)
        }

        context.coordinator.toolPicker?.showsDrawingPolicyControls = showsDrawingPolicyControls
        context.coordinator.toolPicker?.stateAutosaveName = toolPickerAutosaveName
        context.coordinator.toolPicker?.colorUserInterfaceStyle = toolPickerColorStyle
        context.coordinator.toolPicker?.overrideUserInterfaceStyle = toolPickerOverrideStyle
        context.coordinator.toolPicker?.accessoryItem = toolPickerAccessoryItem
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

// MARK: - Coordinator

@available(iOS 26, *)
extension MarkupView {
    @MainActor
    public class Coordinator: NSObject, PaperMarkupViewController.Delegate {
        weak var markup: MarkupBoard?
        var onMarkupChange: (@MainActor @Sendable (MarkupBoard) -> Void)?
        var onMarkupSelectionChange: (@MainActor @Sendable (PaperMarkup?) -> Void)?
        var onMarkupBeginDrawing: (@MainActor @Sendable () -> Void)?
        private(set) var toolPicker: PKToolPicker?
        private var configuredToolItemIdentifiers: [String]?

        override init() {
            super.init()
        }

        func showToolPicker(for vc: PaperMarkupViewController, toolItems: [PKToolPickerItem]? = nil) {
            guard toolPicker == nil else { return }

            let picker: PKToolPicker
            if let toolItems {
                picker = PKToolPicker(toolItems: toolItems)
                configuredToolItemIdentifiers = toolItems.map(\.identifier)
            } else {
                picker = PKToolPicker()
                configuredToolItemIdentifiers = nil
            }

            picker.setVisible(true, forFirstResponder: vc)
            picker.addObserver(vc)
            vc.becomeFirstResponder()

            toolPicker = picker
        }

        func hideToolPicker(from vc: PaperMarkupViewController) {
            guard let picker = toolPicker else { return }

            picker.setVisible(false, forFirstResponder: vc)
            picker.removeObserver(vc)

            toolPicker = nil
            configuredToolItemIdentifiers = nil
        }

        func toolItemsNeedRecreation(_ newItems: [PKToolPickerItem]?) -> Bool {
            let newCount = newItems?.count
            let oldCount = configuredToolItemIdentifiers?.count
            guard newCount == oldCount else { return true }
            let newIdentifiers = newItems?.map(\.identifier)
            return newIdentifiers != configuredToolItemIdentifiers
        }

        // MARK: - PaperMarkupViewController.Delegate

        public nonisolated func paperMarkupViewControllerDidChangeMarkup(
            _ controller: PaperMarkupViewController
        ) {
            MainActor.assumeIsolated {
                guard let markup else { return }
                markup.syncMarkupFromViewController()
                onMarkupChange?(markup)
            }
        }

        public nonisolated func paperMarkupViewControllerDidChangeSelection(
            _ controller: PaperMarkupViewController
        ) {
            MainActor.assumeIsolated {
                markup?.setSelectedMarkup(controller.selectedMarkup)
                onMarkupSelectionChange?(controller.selectedMarkup)
            }
        }

        public nonisolated func paperMarkupViewControllerDidBeginDrawing(
            _ controller: PaperMarkupViewController
        ) {
            MainActor.assumeIsolated {
                markup?.setDrawingState(true)
                onMarkupBeginDrawing?()
            }
        }

        public nonisolated func paperMarkupViewControllerDidChangeContentVisibleFrame(
            _ controller: PaperMarkupViewController
        ) {
            // Future: expose as callback
        }
    }
}

// MARK: - View Modifiers

@available(iOS 26, *)
public extension View {
    /// Controls whether the markup view allows editing.
    ///
    /// When set to `false`, the markup view becomes a read-only viewer.
    ///
    /// - Parameter editable: A Boolean value that determines whether editing is enabled.
    func editable(_ editable: Bool) -> some View {
        environment(\.markupEditable, editable)
    }

    /// Adds an action to perform when the markup content changes.
    ///
    /// - Parameter action: A closure called with the markup board when the content changes.
    func onMarkupChange(_ action: @MainActor @Sendable @escaping (MarkupBoard) -> Void) -> some View {
        environment(\.onMarkupChange, action)
    }

    /// Adds an action to perform when the markup selection changes.
    ///
    /// - Parameter action: A closure called with the selected markup content.
    func onMarkupSelectionChange(_ action: @MainActor @Sendable @escaping (PaperMarkup?) -> Void) -> some View {
        environment(\.onMarkupSelectionChange, action)
    }

    /// Adds an action to perform when the user begins drawing.
    ///
    /// - Parameter action: A closure called when drawing begins.
    func onMarkupBeginDrawing(_ action: @MainActor @Sendable @escaping () -> Void) -> some View {
        environment(\.onMarkupBeginDrawing, action)
    }
}
