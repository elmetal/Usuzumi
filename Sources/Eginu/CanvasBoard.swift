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
/// ### Drawing Operations
/// - ``strokes``
/// - ``drawingBounds``
/// - ``transformDrawing(using:)``
/// - ``appendDrawing(_:)``
/// - ``appendStrokes(_:)``
///
/// ### Tool Management
/// - ``currentTool``
/// - ``setTool(_:)``
///
/// ### Undo and Redo
/// - ``canUndo``
/// - ``canRedo``
/// - ``undo()``
/// - ``redo()``
///
/// ### Exporting Content
/// - ``exportImage(scale:)``
/// - ``exportPDF()``
@Observable
@MainActor
public final class CanvasBoard {
    /// A Boolean value indicating whether the user is currently drawing.
    public private(set) var isDrawing: Bool = false
    /// A Boolean value indicating whether an undo operation is available.
    public private(set) var canUndo: Bool = false
    /// A Boolean value indicating whether a redo operation is available.
    public private(set) var canRedo: Bool = false
    /// The current drawing tool.
    public private(set) var currentTool: Tool = .pen(color: .black, width: 5)

    /// The configuration used to create this canvas board.
    public let configuration: Configuration

    @ObservationIgnored private weak var canvasView: PKCanvasView?
    @ObservationIgnored private var drawing: PKDrawing = PKDrawing()

    /// Creates a new canvas board instance with the specified configuration.
    ///
    /// - Parameter configuration: The configuration settings for the canvas. Defaults to `.default`.
    public init(configuration: Configuration = .default) {
        self.configuration = configuration
    }

    /// The drawing data that can be saved and restored.
    ///
    /// - Note: Setting this property will replace the current drawing with the new data.
    public var drawingData: Data {
        get {
            syncDrawingFromCanvas()
            do {
                return try drawing.dataRepresentation()
            } catch {
                return Data()
            }
        }
        set {
            do {
                let newDrawing = try PKDrawing(data: newValue)
                applyDrawing { $0 = newDrawing }
            } catch {
                // Invalid drawing data is silently ignored
            }
        }
    }

    /// Clears all content from the canvas.
    public func clear() {
        applyDrawing { $0 = PKDrawing() }
    }

    /// Performs an undo operation on the canvas.
    public func undo() {
        canvasView?.undoManager?.undo()
        syncDrawingFromCanvas()
        updateUndoRedoState()
    }

    /// Performs a redo operation on the canvas.
    public func redo() {
        canvasView?.undoManager?.redo()
        syncDrawingFromCanvas()
        updateUndoRedoState()
    }

    /// Exports the current drawing as a `UIImage`.
    ///
    /// - Parameter scale: The scale factor. Defaults to the display scale of the bound canvas view.
    /// - Returns: A `UIImage` representation of the drawing.
    public func exportImage(scale: CGFloat? = nil) -> UIImage {
        syncDrawingFromCanvas()
        let bounds = drawing.bounds
        let displayScale = scale ?? (canvasView?.traitCollection.displayScale ?? 2.0)
        return drawing.image(from: bounds, scale: displayScale)
    }

    /// Exports the current drawing as PDF data.
    ///
    /// - Returns: PDF data representation of the drawing.
    public func exportPDF() -> Data {
        syncDrawingFromCanvas()
        let bounds = drawing.bounds
        let pdfMetaData = [
            kCGPDFContextCreator: "Eginu",
            kCGPDFContextTitle: "Drawing"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        let renderer = UIGraphicsPDFRenderer(bounds: bounds, format: format)
        return renderer.pdfData { context in
            context.beginPage()
            drawing.image(from: bounds, scale: 1.0).draw(in: bounds)
        }
    }

    /// The strokes that make up the current drawing.
    public var strokes: [PKStroke] {
        syncDrawingFromCanvas()
        return drawing.strokes
    }

    /// The bounds of the current drawing.
    public var drawingBounds: CGRect {
        syncDrawingFromCanvas()
        return drawing.bounds
    }

    /// Applies an affine transform to the current drawing.
    ///
    /// - Parameter transform: The affine transform to apply.
    public func transformDrawing(using transform: CGAffineTransform) {
        applyDrawing { $0 = $0.transformed(using: transform) }
    }

    /// Appends another drawing to the current drawing.
    ///
    /// - Parameter other: The drawing to append.
    public func appendDrawing(_ other: PKDrawing) {
        applyDrawing { $0.append(other) }
    }

    /// Appends another drawing from its data representation.
    ///
    /// - Parameter data: The drawing data to append.
    public func appendDrawing(_ data: Data) throws {
        let otherDrawing = try PKDrawing(data: data)
        appendDrawing(otherDrawing)
    }

    /// Appends strokes to the current drawing.
    ///
    /// - Parameter strokes: The strokes to append.
    public func appendStrokes(_ strokes: [PKStroke]) {
        applyDrawing { $0 = $0.appending(PKDrawing(strokes: strokes)) }
    }

    /// Sets the active drawing tool.
    ///
    /// - Parameter tool: The drawing tool to activate.
    public func setTool(_ tool: Tool) {
        currentTool = tool
        canvasView?.tool = tool.pkTool

        if case .ruler = tool {
            canvasView?.isRulerActive = true
        } else {
            canvasView?.isRulerActive = false
        }
    }

    // MARK: - Internal (Coordinator access)

    private func syncDrawingFromCanvas() {
        if let canvasView {
            drawing = canvasView.drawing
        }
    }

    private func applyDrawing(_ mutate: (inout PKDrawing) -> Void) {
        syncDrawingFromCanvas()
        mutate(&drawing)
        canvasView?.drawing = drawing
        updateUndoRedoState()
    }

    func bind(to canvasView: PKCanvasView) {
        // Allow rebinding when the previous view was deallocated (weak ref became nil)
        if self.canvasView != nil {
            preconditionFailure("CanvasBoard is already bound to a CanvasView. A CanvasBoard can only be used with one CanvasView at a time.")
        }
        self.canvasView = canvasView
        canvasView.drawing = drawing
        canvasView.tool = currentTool.pkTool
        updateUndoRedoState()
    }

    func updateUndoRedoState() {
        canUndo = canvasView?.undoManager?.canUndo ?? false
        canRedo = canvasView?.undoManager?.canRedo ?? false
    }

    func setDrawingState(_ isDrawing: Bool) {
        self.isDrawing = isDrawing
    }

    func setToolFromPicker(_ tool: PKTool) {
        canvasView?.tool = tool
    }

    func setRulerFromPicker(_ active: Bool) {
        canvasView?.isRulerActive = active
    }

    var boundCanvasView: PKCanvasView? {
        canvasView
    }
}
