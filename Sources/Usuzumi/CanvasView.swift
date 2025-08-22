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
/// various configuration options through ``CanvasConfiguration``.
///
/// ### Basic Usage
///
/// ```swift
/// struct ContentView: View {
///     @StateObject private var canvas = CanvasBoard()
///
///     var body: some View {
///         CanvasView(canvas: canvas)
///             .toolPickerVisible(true)
///             .allowsFingerDrawing(true)
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Creating a Canvas View
/// - ``init(canvas:configuration:)``
///
/// ### Configuring the Canvas
/// - ``canvasDelegate(_:)``
/// - ``toolPickerVisible(_:)``
/// - ``rulerActive(_:)``
/// - ``allowsFingerDrawing(_:)``
/// - ``backgroundColor(_:)``
/// - ``scrollEnabled(_:)``
/// - ``zoomScale(min:max:)``
public struct CanvasView: UIViewRepresentable {
    /// The canvas board that manages the drawing state.
    @ObservedObject public var canvas: CanvasBoard
    
    /// The configuration settings for the canvas.
    public var configuration: CanvasConfiguration
    
    /// The delegate that receives canvas events.
    public weak var delegate: CanvasDelegate?
    
    private var isToolPickerVisible: Bool = false
    
    /// Creates a new canvas view with the specified board and configuration.
    ///
    /// - Parameters:
    ///   - canvas: The canvas board that manages the drawing state.
    ///   - configuration: The configuration settings for the canvas. Defaults to `.default`.
    public init(
        canvas: CanvasBoard,
        configuration: CanvasConfiguration = .default
    ) {
        self.canvas = canvas
        self.configuration = configuration
    }
    
    public func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        
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
    
    /// Activates or deactivates the ruler tool.
    ///
    /// When active, the ruler helps users draw straight lines and measure distances.
    ///
    /// - Parameter active: A Boolean value that determines whether the ruler is active.
    /// - Returns: A canvas view with the updated ruler state.
    func rulerActive(_ active: Bool) -> CanvasView {
        var view = self
        view.configuration.isRulerActive = active
        return view
    }
    
    /// Configures whether finger drawing is allowed on the canvas.
    ///
    /// When disabled, only Apple Pencil input will be accepted for drawing.
    ///
    /// - Parameter allows: A Boolean value that determines whether finger drawing is allowed.
    /// - Returns: A canvas view with the updated finger drawing setting.
    func allowsFingerDrawing(_ allows: Bool) -> CanvasView {
        var view = self
        view.configuration.allowsFingerDrawing = allows
        view.configuration.drawingPolicy = allows ? .anyInput : .pencilOnly
        return view
    }
    
    /// Sets the background color of the canvas.
    ///
    /// - Parameter color: The background color to apply to the canvas.
    /// - Returns: A canvas view with the specified background color.
    func backgroundColor(_ color: UIColor) -> CanvasView {
        var view = self
        view.configuration.backgroundColor = color
        return view
    }
    
    /// Enables or disables scrolling on the canvas.
    ///
    /// When enabled, users can pan around the canvas if the content extends beyond the visible area.
    ///
    /// - Parameter enabled: A Boolean value that determines whether scrolling is enabled.
    /// - Returns: A canvas view with the updated scrolling setting.
    func scrollEnabled(_ enabled: Bool) -> CanvasView {
        var view = self
        view.configuration.isScrollEnabled = enabled
        return view
    }
    
    /// Sets the minimum and maximum zoom scale for the canvas.
    ///
    /// - Parameters:
    ///   - min: The minimum zoom scale (must be greater than 0).
    ///   - max: The maximum zoom scale.
    /// - Returns: A canvas view with the specified zoom scale limits.
    func zoomScale(min: CGFloat, max: CGFloat) -> CanvasView {
        var view = self
        view.configuration.minimumZoomScale = min
        view.configuration.maximumZoomScale = max
        return view
    }
}