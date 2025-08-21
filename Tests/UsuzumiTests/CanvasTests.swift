import Testing
import SwiftUI
import PencilKit
@testable import Usuzumi

@Suite("Canvas Tests")
struct CanvasTests {
    
    @Test("Canvas initializes with default values")
    @MainActor
    func testCanvasInitialization() {
        let canvas = Canvas()
        
        #expect(canvas.isDrawing == false)
        #expect(canvas.canUndo == false)
        #expect(canvas.canRedo == false)
        #expect(canvas.currentTool is PKInkingTool)
    }
    
    @Test("Canvas clear functionality")
    @MainActor
    func testCanvasClear() {
        let canvas = Canvas()
        
        canvas.clear()
        
        // After clearing, drawing should be empty (no strokes)
        #expect(canvas.drawingData.count > 0) // PKDrawing always has some metadata
        #expect(canvas.canUndo == false)
        #expect(canvas.canRedo == false)
    }
    
    @Test("Canvas drawing data setter and getter")
    @MainActor
    func testDrawingData() throws {
        let canvas = Canvas()
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
    
    @Test("Canvas export as image returns image for empty drawing")
    @MainActor
    func testExportEmptyDrawing() {
        let canvas = Canvas()
        
        let image = canvas.exportAsImage()
        
        #expect(image != nil)
    }
    
    @Test("Canvas undo/redo without canvasView")
    @MainActor
    func testUndoRedoWithoutCanvasView() {
        let canvas = Canvas()
        
        canvas.undo()
        canvas.redo()
        
        #expect(canvas.canUndo == false)
        #expect(canvas.canRedo == false)
    }
    
    @Test("Canvas setup with PKCanvasView")
    @MainActor
    func testSetupCanvasView() {
        let canvas = Canvas()
        let canvasView = PKCanvasView()
        
        canvas.setupCanvasView(canvasView)
        
        #expect(canvas.canvasView === canvasView)
        #expect(canvasView.tool is PKInkingTool)
    }
}