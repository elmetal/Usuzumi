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

        #expect(canvas.drawingData.count > 0)
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

        #expect(canvas.drawingData.count > 0)
        let newData = canvas.drawingData
        #expect(newData.count >= data.count || newData != originalData)
    }

    @Test("CanvasBoard export as image returns image for empty drawing")
    @MainActor
    func testExportEmptyDrawing() {
        let canvas = CanvasBoard()

        let image = canvas.export(.image()) as? UIImage

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

    @Test("CanvasBoard bind to PKCanvasView")
    @MainActor
    func testBindCanvasView() {
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()

        canvas.bind(to: canvasView)

        #expect(canvas.boundCanvasView === canvasView)
        #expect(canvasView.tool is PKInkingTool)
    }
}
