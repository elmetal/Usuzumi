import SwiftUI
import PencilKit

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
/// ### Basic Usage
///
/// ```swift
/// struct ContentView: View {
///     @State private var canvas = CanvasBoard()
///
///     var body: some View {
///         CanvasView(canvas)
///             .toolPickerVisible(true)
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Creating a Canvas View
/// - ``init(_:)``
///
/// ### Configuring the Canvas
/// - ``canvasDelegate(_:)``
/// - ``toolPickerVisible(_:)``
public struct CanvasView: UIViewRepresentable {
    /// The canvas board that manages the drawing state.
    public var canvas: CanvasBoard

    /// The delegate that receives canvas events.
    public weak var delegate: CanvasDelegate?

    private var isToolPickerVisible: Bool = false

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
        canvasView.backgroundColor = configuration.backgroundColor
        canvasView.isRulerActive = configuration.isRulerActive
        canvasView.drawingPolicy = configuration.drawingPolicy
        canvasView.minimumZoomScale = configuration.minimumZoomScale
        canvasView.maximumZoomScale = configuration.maximumZoomScale
        canvasView.isScrollEnabled = configuration.isScrollEnabled
        canvasView.isOpaque = configuration.isOpaque
        canvasView.tool = configuration.defaultTool

        canvas.setupCanvasView(canvasView)
        context.coordinator.canvas = canvas

        if isToolPickerVisible {
            context.coordinator.showToolPicker(for: canvasView)
        }

        return canvasView
    }

    public func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        let configuration = canvas.configuration

        canvasView.backgroundColor = configuration.backgroundColor
        canvasView.isRulerActive = configuration.isRulerActive
        canvasView.drawingPolicy = configuration.drawingPolicy
        canvasView.minimumZoomScale = configuration.minimumZoomScale
        canvasView.maximumZoomScale = configuration.maximumZoomScale
        canvasView.isScrollEnabled = configuration.isScrollEnabled
        canvasView.isOpaque = configuration.isOpaque
        canvasView.tool = canvas.currentTool

        context.coordinator.delegate = delegate

        if isToolPickerVisible && canvas.toolPicker == nil {
            context.coordinator.showToolPicker(for: canvasView)
        } else if !isToolPickerVisible && canvas.toolPicker != nil {
            context.coordinator.hideToolPicker()
        }
    }

    public func makeCoordinator() -> CanvasCoordinator {
        CanvasCoordinator(delegate: delegate)
    }
}

public extension CanvasView {
    /// Sets the delegate that receives canvas events.
    ///
    /// - Parameter delegate: The delegate to receive canvas events.
    /// - Returns: A canvas view with the specified delegate.
    func canvasDelegate(_ delegate: CanvasDelegate?) -> CanvasView {
        var view = self
        view.delegate = delegate
        return view
    }

    /// Controls the visibility of the PencilKit tool picker.
    ///
    /// When visible, the tool picker allows users to select drawing tools,
    /// colors, and other drawing options.
    ///
    /// - Parameter visible: A Boolean value that determines whether the tool picker is visible.
    /// - Returns: A canvas view with the updated tool picker visibility.
    func toolPickerVisible(_ visible: Bool) -> CanvasView {
        var view = self
        view.isToolPickerVisible = visible
        return view
    }
}
