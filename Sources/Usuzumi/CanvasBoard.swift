import SwiftUI
import PencilKit
import Combine

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
/// - ``init()``
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
/// - ``exportAsImage()``
/// - ``exportAsPDF()``
@MainActor
public class CanvasBoard: ObservableObject {
    /// A Boolean value indicating whether the user is currently drawing.
    ///
    /// This property is automatically updated when the user begins or ends drawing on the canvas.
    @Published public private(set) var isDrawing: Bool = false
    /// A Boolean value indicating whether an undo operation is available.
    ///
    /// Use this property to enable or disable undo buttons in your UI.
    @Published public private(set) var canUndo: Bool = false
    /// A Boolean value indicating whether a redo operation is available.
    ///
    /// Use this property to enable or disable redo buttons in your UI.
    @Published public private(set) var canRedo: Bool = false
    /// The current PencilKit tool being used for drawing.
    ///
    /// This property provides direct access to the underlying `PKTool` instance.
    @Published public var currentTool: PKTool = PKInkingTool(.pen, color: .black, width: 5)
    /// The current drawing tool represented as a `DrawingTool` enum.
    ///
    /// This property provides a higher-level abstraction over `PKTool` for easier tool management.
    @Published public var currentDrawingTool: DrawingTool = .pen(color: .black, width: 5)
    
    internal var canvasView: PKCanvasView?
    internal var toolPicker: PKToolPicker?
    
    private var drawing: PKDrawing = PKDrawing()
    private var cancellables = Set<AnyCancellable>()
    
    /// Creates a new canvas board instance.
    ///
    /// The canvas board is initialized with default settings and a pen tool.
    public init() {}
    
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
    
    /// Exports the current drawing as a UIImage.
    ///
    /// The exported image maintains the device's screen scale for optimal quality.
    ///
    /// - Returns: A `UIImage` representation of the drawing, or `nil` if the drawing is empty.
    public func exportAsImage() -> UIImage? {
        let bounds = drawing.bounds
        return drawing.image(from: bounds, scale: UIScreen.main.scale)
    }
    
    /// Exports the current drawing as PDF data.
    ///
    /// The PDF is generated with metadata including the creator and title information.
    ///
    /// - Returns: PDF data representation of the drawing, or `nil` if the export fails.
    public func exportAsPDF() -> Data? {
        let bounds = drawing.bounds
        let pdfMetaData = [
            kCGPDFContextCreator: "Usuzumi",
            kCGPDFContextTitle: "Drawing"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let renderer = UIGraphicsPDFRenderer(bounds: bounds, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            drawing.image(from: bounds, scale: 1.0).draw(in: bounds)
        }
        
        return data
    }
    
    internal func updateUndoRedoState() {
        canUndo = canvasView?.undoManager?.canUndo ?? false
        canRedo = canvasView?.undoManager?.canRedo ?? false
    }
    
    /// Sets the active drawing tool.
    ///
    /// This method updates both the high-level `DrawingTool` and the underlying `PKTool`.
    /// For the ruler tool, it also activates the ruler mode on the canvas.
    ///
    /// - Parameter tool: The drawing tool to activate.
    public func setTool(_ tool: DrawingTool) {
        currentDrawingTool = tool
        currentTool = tool.pkTool
        canvasView?.tool = currentTool
        
        // Handle ruler state separately
        if case .ruler = tool {
            canvasView?.isRulerActive = true
        } else {
            canvasView?.isRulerActive = false
        }
    }
    
    internal func setDrawingState(_ isDrawing: Bool) {
        self.isDrawing = isDrawing
    }
    
    internal func setupCanvasView(_ canvasView: PKCanvasView) {
        self.canvasView = canvasView
        canvasView.drawing = drawing
        canvasView.tool = currentTool
        updateUndoRedoState()
    }
}