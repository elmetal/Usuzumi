import Testing
import SwiftUI
import PencilKit
@testable import Usuzumi

@Suite("Integration Tests")
@MainActor
struct IntegrationTests {

    @Test("Full canvas setup with view and coordinator")
    func testFullSetup() {
        let config = CanvasBoard.Configuration(
            drawingPolicy: .pencilOnly
        )
        let canvas = CanvasBoard(configuration: config)
        let canvasView = CanvasView(canvas)

        let coordinator = canvasView.makeCoordinator()
        let pkCanvasView = PKCanvasView()

        canvas.bind(to: pkCanvasView)
        coordinator.canvas = canvas

        #expect(canvas.boundCanvasView === pkCanvasView)
        #expect(coordinator.canvas === canvas)
    }

    @Test("Drawing change callback through coordinator")
    func testDrawingChangeCallback() {
        let coordinator = CanvasView.Coordinator()
        let canvas = CanvasBoard()
        let pkCanvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.bind(to: pkCanvasView)

        var changedCanvas: CanvasBoard?
        coordinator.onDrawingChange = { canvas in
            changedCanvas = canvas
        }

        coordinator.canvasViewDrawingDidChange(pkCanvasView)

        #expect(changedCanvas === canvas)
    }

    @Test("CanvasBoard state updates through coordinator")
    func testCanvasStateUpdates() {
        let canvas = CanvasBoard()
        let coordinator = CanvasView.Coordinator()
        let pkCanvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.bind(to: pkCanvasView)

        #expect(canvas.isDrawing == false)

        coordinator.canvasViewDidBeginUsingTool(pkCanvasView)
        #expect(canvas.isDrawing == true)

        coordinator.canvasViewDidEndUsingTool(pkCanvasView)
        #expect(canvas.isDrawing == false)
    }

    @Test("Drawing data persistence")
    func testDrawingDataPersistence() throws {
        let canvas1 = CanvasBoard()
        let canvas2 = CanvasBoard()

        let drawing = PKDrawing()
        let data = try drawing.dataRepresentation()

        canvas1.drawingData = data
        let savedData = canvas1.drawingData

        canvas2.drawingData = savedData

        #expect(canvas1.drawingData == canvas2.drawingData)
    }
}
