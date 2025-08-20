import SwiftUI
import PencilKit
import Combine

@MainActor
public class Canvas: ObservableObject {
    @Published public private(set) var isDrawing: Bool = false
    @Published public private(set) var canUndo: Bool = false
    @Published public private(set) var canRedo: Bool = false
    @Published public var currentTool: PKTool = PKInkingTool(.pen, color: .black, width: 5)
    
    internal var canvasView: PKCanvasView?
    internal var toolPicker: PKToolPicker?
    
    private var drawing: PKDrawing = PKDrawing()
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
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
    
    public func clear() {
        drawing = PKDrawing()
        canvasView?.drawing = drawing
        updateUndoRedoState()
    }
    
    public func undo() {
        canvasView?.undoManager?.undo()
        updateUndoRedoState()
    }
    
    public func redo() {
        canvasView?.undoManager?.redo()
        updateUndoRedoState()
    }
    
    public func exportAsImage() -> UIImage? {
        let bounds = drawing.bounds
        return drawing.image(from: bounds, scale: UIScreen.main.scale)
    }
    
    internal func updateUndoRedoState() {
        canUndo = canvasView?.undoManager?.canUndo ?? false
        canRedo = canvasView?.undoManager?.canRedo ?? false
    }
    
    internal func setupCanvasView(_ canvasView: PKCanvasView) {
        self.canvasView = canvasView
        canvasView.drawing = drawing
        canvasView.tool = currentTool
        updateUndoRedoState()
    }
}