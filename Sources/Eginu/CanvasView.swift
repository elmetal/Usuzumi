import SwiftUI
import PencilKit

// MARK: - Environment Keys

extension EnvironmentValues {
    @Entry var canvasToolPickerVisible: Bool = false
    @Entry var canvasRulerActive: Bool = false
    @Entry var canvasBackgroundColor: UIColor = .systemBackground
    @Entry var onCanvasDrawingChange: (@MainActor @Sendable (CanvasBoard) -> Void)? = nil
    @Entry var onCanvasZoom: (@MainActor @Sendable (CGFloat) -> Void)? = nil
    @Entry var onCanvasScroll: (@MainActor @Sendable (CGPoint) -> Void)? = nil
}

// MARK: - CanvasView

/// A SwiftUI view that wraps PencilKit's `PKCanvasView` for drawing and sketching.
///
/// ``CanvasView`` provides a SwiftUI-compatible interface to PencilKit, enabling
/// drawing capabilities with Apple Pencil and finger input support.
///
/// ## Overview
///
/// Use `CanvasView` to add drawing capabilities to your SwiftUI app. The view
/// automatically integrates with ``CanvasBoard`` for state management and supports
/// various configuration options through ``CanvasBoard/Configuration``.
///
/// ### Simple Usage
///
/// ```swift
/// var body: some View {
///     CanvasView()
///         .toolPickerVisible(true)
/// }
/// ```
///
/// ### Full Control
///
/// ```swift
/// struct ContentView: View {
///     @State private var canvas = CanvasBoard()
///
///     var body: some View {
///         CanvasView(canvas)
///             .toolPickerVisible(true)
///             .rulerActive(false)
///             .onDrawingChange { canvas in
///                 autosave(canvas.drawingData)
///             }
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Creating a Canvas View
/// - ``init()``
/// - ``init(_:)``
public struct CanvasView: UIViewRepresentable {
    /// The canvas board that manages the drawing state.
    public var canvas: CanvasBoard

    @Environment(\.canvasToolPickerVisible) private var isToolPickerVisible
    @Environment(\.canvasRulerActive) private var isRulerActive
    @Environment(\.canvasBackgroundColor) private var backgroundColor
    @Environment(\.onCanvasDrawingChange) private var onDrawingChange
    @Environment(\.onCanvasZoom) private var onZoom
    @Environment(\.onCanvasScroll) private var onScroll

    /// Creates a new canvas view with a default canvas board.
    ///
    /// Use this initializer for simple usage where you don't need
    /// to access the canvas state externally.
    public init() {
        self.canvas = CanvasBoard()
    }

    /// Creates a new canvas view with the specified board.
    ///
    /// Configuration is provided through the ``CanvasBoard/configuration`` property.
    ///
    /// - Parameter canvas: The canvas board that manages the drawing state.
    public init(_ canvas: CanvasBoard) {
        self.canvas = canvas
    }

    public func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        let configuration = canvas.configuration

        canvasView.delegate = context.coordinator

        // Static configuration — applied once, never changes
        canvasView.drawingPolicy = configuration.drawingPolicy
        canvasView.minimumZoomScale = configuration.minimumZoomScale
        canvasView.maximumZoomScale = configuration.maximumZoomScale
        canvasView.isScrollEnabled = configuration.isScrollEnabled
        canvasView.isOpaque = configuration.isOpaque
        canvasView.tool = configuration.defaultTool

        // Dynamic settings from Environment
        canvasView.backgroundColor = backgroundColor
        canvasView.isRulerActive = isRulerActive

        canvas.bind(to: canvasView)
        context.coordinator.canvas = canvas

        if isToolPickerVisible {
            context.coordinator.showToolPicker(for: canvasView)
        }

        return canvasView
    }

    public func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        // Only update dynamic (Environment-driven) properties
        canvasView.backgroundColor = backgroundColor
        canvasView.isRulerActive = isRulerActive

        context.coordinator.onDrawingChange = onDrawingChange
        context.coordinator.onZoom = onZoom
        context.coordinator.onScroll = onScroll

        if isToolPickerVisible && context.coordinator.toolPicker == nil {
            context.coordinator.showToolPicker(for: canvasView)
        } else if !isToolPickerVisible && context.coordinator.toolPicker != nil {
            context.coordinator.hideToolPicker()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

// MARK: - View Modifiers

public extension View {
    /// Controls the visibility of the PencilKit tool picker.
    ///
    /// - Parameter visible: A Boolean value that determines whether the tool picker is visible.
    func toolPickerVisible(_ visible: Bool) -> some View {
        environment(\.canvasToolPickerVisible, visible)
    }

    /// Activates or deactivates the ruler on the canvas.
    ///
    /// - Parameter active: A Boolean value that determines whether the ruler is active.
    func rulerActive(_ active: Bool) -> some View {
        environment(\.canvasRulerActive, active)
    }

    /// Sets the background color of the canvas.
    ///
    /// - Parameter color: The background color to apply.
    func backgroundColor(_ color: UIColor) -> some View {
        environment(\.canvasBackgroundColor, color)
    }

    /// Adds an action to perform when the drawing content changes.
    ///
    /// - Parameter action: A closure called with the canvas board when the drawing changes.
    func onDrawingChange(_ action: @MainActor @Sendable @escaping (CanvasBoard) -> Void) -> some View {
        environment(\.onCanvasDrawingChange, action)
    }

    /// Adds an action to perform when the canvas zoom scale changes.
    ///
    /// - Parameter action: A closure called with the new zoom scale.
    func onZoom(_ action: @MainActor @Sendable @escaping (CGFloat) -> Void) -> some View {
        environment(\.onCanvasZoom, action)
    }

    /// Adds an action to perform when the canvas scroll position changes.
    ///
    /// - Parameter action: A closure called with the new scroll offset.
    func onScroll(_ action: @MainActor @Sendable @escaping (CGPoint) -> Void) -> some View {
        environment(\.onCanvasScroll, action)
    }
}
