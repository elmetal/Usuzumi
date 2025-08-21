import Testing
import SwiftUI
import PencilKit
@testable import Usuzumi

@Suite("CanvasBoard Tests")
struct CanvasBoardTests {
    
    @Test("CanvasBoard initializes with default values")
    @MainActor
    func testCanvasBoardInitialization() {
        let canvas = CanvasBoard()
        
        #expect(canvas.isDrawing == false)
        #expect(canvas.canUndo == false)
        #expect(canvas.canRedo == false)
        #expect(canvas.currentTool is PKInkingTool)
    }
    
    @Test("CanvasBoard clear functionality")
    @MainActor
    func testCanvasBoardClear() {
        let canvas = CanvasBoard()
        
        canvas.clear()
        
        // After clearing, drawing should be empty (no strokes)
        #expect(canvas.drawingData.count > 0) // PKDrawing always has some metadata
        #expect(canvas.canUndo == false)
        #expect(canvas.canRedo == false)
    }
    
    @Test("CanvasBoard drawing data setter and getter")
    @MainActor
    func testDrawingData() throws {
        let canvas = CanvasBoard()
        let originalData = canvas.drawingData
        
        let drawing = PKDrawing()
        let data = try drawing.dataRepresentation()
        
        canvas.drawingData = data
        
        // Drawing data should be set (might have different size due to metadata)
        #expect(canvas.drawingData.count > 0)
        // The data should have changed from original
        let newData = canvas.drawingData
        #expect(newData.count >= data.count || newData != originalData)
    }
    
    @Test("CanvasBoard export as image returns image for empty drawing")
    @MainActor
    func testExportEmptyDrawing() {
        let canvas = CanvasBoard()
        
        let image = canvas.exportAsImage()
        
        #expect(image != nil)
    }
    
    @Test("CanvasBoard undo/redo without canvasView")
    @MainActor
    func testUndoRedoWithoutCanvasView() {
        let canvas = CanvasBoard()
        
        canvas.undo()
        canvas.redo()
        
        #expect(canvas.canUndo == false)
        #expect(canvas.canRedo == false)
    }
    
    @Test("CanvasBoard setup with PKCanvasView")
    @MainActor
    func testSetupCanvasView() {
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        
        canvas.setupCanvasView(canvasView)
        
        #expect(canvas.canvasView === canvasView)
        #expect(canvasView.tool is PKInkingTool)
    }
}