import SwiftUI
import PencilKit

/// A view model that manages the state and behavior of a drawing canvas.
///
/// ``CanvasBoard`` serves as the central state manager for PencilKit-based drawing operations,
/// providing a SwiftUI-compatible interface for canvas interactions.
///
/// ## Overview
///
/// Use `CanvasBoard` to manage drawing operations, tool selection, and export functionality
/// for your canvas-based applications. The class automatically synchronizes with the underlying
/// `PKCanvasView` and provides observable properties for UI updates.
///
/// ## Topics
///
/// ### Creating a Canvas Board
/// - ``init(configuration:)``
///
/// ### Managing Drawing State
/// - ``isDrawing``
/// - ``drawingData``
/// - ``clear()``
///
/// ### Tool Management
/// - ``currentTool``
/// - ``currentDrawingTool``
/// - ``setTool(_:)``
///
/// ### Undo and Redo
/// - ``canUndo``
/// - ``canRedo``
/// - ``undo()``
/// - ``redo()``
///
/// ### Exporting Content
/// - ``ExportFormat``
/// - ``export(_:)``
@Observable
@MainActor
public final class CanvasBoard {
    /// A Boolean value indicating whether the user is currently drawing.
    ///
    /// This property is automatically updated when the user begins or ends drawing on the canvas.
    public private(set) var isDrawing: Bool = false
    /// A Boolean value indicating whether an undo operation is available.
    ///
    /// Use this property to enable or disable undo buttons in your UI.
    public private(set) var canUndo: Bool = false
    /// A Boolean value indicating whether a redo operation is available.
    ///
    /// Use this property to enable or disable redo buttons in your UI.
    public private(set) var canRedo: Bool = false
    /// The current PencilKit tool being used for drawing.
    ///
    /// This property provides direct access to the underlying `PKTool` instance.
    public var currentTool: PKTool = PKInkingTool(.pen, color: .black, width: 5)
    /// The current drawing tool represented as a ``Tool`` enum.
    ///
    /// This property provides a higher-level abstraction over `PKTool` for easier tool management.
    public var currentDrawingTool: Tool = .pen(color: .black, width: 5)

    /// The configuration used to create this canvas board.
    public let configuration: Configuration

    @ObservationIgnored private var isBound: Bool = false
    @ObservationIgnored private var canvasView: PKCanvasView?
    @ObservationIgnored private var drawing: PKDrawing = PKDrawing()

    /// Creates a new canvas board instance with the specified configuration.
    ///
    /// - Parameter configuration: The configuration settings for the canvas. Defaults to `.default`.
    public init(configuration: Configuration = .default) {
        self.configuration = configuration
        self.currentTool = configuration.defaultTool
        self.currentDrawingTool = .pen(color: .black, width: 5)
    }

    /// The drawing data that can be saved and restored.
    ///
    /// Use this property to persist drawings or transfer them between canvas instances.
    ///
    /// - Note: Setting this property will replace the current drawing with the new data.
    public var drawingData: Data {
        get {
            do {
                return try drawing.dataRepresentation()
            } catch {
                return Data()
            }
        }
        set {
            do {
                drawing = try PKDrawing(data: newValue)
                canvasView?.drawing = drawing
                updateUndoRedoState()
            } catch {
                print("Failed to load drawing data: \(error)")
            }
        }
    }

    /// Clears all content from the canvas.
    ///
    /// This operation cannot be undone using the undo manager.
    public func clear() {
        drawing = PKDrawing()
        canvasView?.drawing = drawing
        updateUndoRedoState()
    }

    /// Performs an undo operation on the canvas.
    ///
    /// This method has no effect if ``canUndo`` is `false`.
    public func undo() {
        canvasView?.undoManager?.undo()
        updateUndoRedoState()
    }

    /// Performs a redo operation on the canvas.
    ///
    /// This method has no effect if ``canRedo`` is `false`.
    public func redo() {
        canvasView?.undoManager?.redo()
        updateUndoRedoState()
    }

    /// The format for exporting a drawing.
    public enum ExportFormat {
        /// Export as a raster image.
        case image(scale: CGFloat? = nil)
        /// Export as a PDF document.
        case pdf
    }

    /// Exports the current drawing in the specified format.
    ///
    /// - Parameter format: The export format to use.
    /// - Returns: The exported content, or `nil` if the export fails.
    ///
    /// ```swift
    /// // Export as image at screen scale
    /// let image = canvas.export(.image())
    ///
    /// // Export as image at custom scale
    /// let hiResImage = canvas.export(.image(scale: 3.0))
    ///
    /// // Export as PDF
    /// let pdfData = canvas.export(.pdf)
    /// ```
    public func export(_ format: ExportFormat) -> (any Sendable)? {
        let bounds = drawing.bounds
        switch format {
        case .image(let scale):
            let displayScale = scale ?? (canvasView?.traitCollection.displayScale ?? 2.0)
            return drawing.image(from: bounds, scale: displayScale)
        case .pdf:
            let pdfMetaData = [
                kCGPDFContextCreator: "Usuzumi",
                kCGPDFContextTitle: "Drawing"
            ]
            let rendererFormat = UIGraphicsPDFRendererFormat()
            rendererFormat.documentInfo = pdfMetaData as [String: Any]
            let renderer = UIGraphicsPDFRenderer(bounds: bounds, format: rendererFormat)
            return renderer.pdfData { context in
                context.beginPage()
                drawing.image(from: bounds, scale: 1.0).draw(in: bounds)
            }
        }
    }

    /// Sets the active drawing tool.
    ///
    /// This method updates both the high-level `Tool` and the underlying `PKTool`.
    /// For the ruler tool, it also activates the ruler mode on the canvas.
    ///
    /// - Parameter tool: The drawing tool to activate.
    public func setTool(_ tool: Tool) {
        currentDrawingTool = tool
        currentTool = tool.pkTool
        canvasView?.tool = currentTool

        if case .ruler = tool {
            canvasView?.isRulerActive = true
        } else {
            canvasView?.isRulerActive = false
        }
    }

    // MARK: - Internal (Coordinator access)

    func bind(to canvasView: PKCanvasView) {
        precondition(!isBound, "CanvasBoard is already bound to a CanvasView. A CanvasBoard can only be used with one CanvasView at a time.")
        isBound = true
        self.canvasView = canvasView
        canvasView.drawing = drawing
        canvasView.tool = currentTool
        updateUndoRedoState()
    }

    func unbind() {
        isBound = false
        canvasView = nil
    }

    func updateUndoRedoState() {
        canUndo = canvasView?.undoManager?.canUndo ?? false
        canRedo = canvasView?.undoManager?.canRedo ?? false
    }

    func setDrawingState(_ isDrawing: Bool) {
        self.isDrawing = isDrawing
    }

    func setToolFromPicker(_ tool: PKTool) {
        currentTool = tool
        canvasView?.tool = tool
    }

    func setRulerFromPicker(_ active: Bool) {
        canvasView?.isRulerActive = active
    }

    var boundCanvasView: PKCanvasView? {
        canvasView
    }
}
