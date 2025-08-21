import Testing
import SwiftUI
import PencilKit
@testable import Usuzumi

@Suite("Integration Tests")
@MainActor
struct IntegrationTests {
    
    @Test("Full canvas setup with view and coordinator")
    func testFullSetup() {
        let canvas = CanvasBoard()
        let config = CanvasConfiguration(
            backgroundColor: .systemGray,
            isRulerActive: true
        )
        let canvasView = CanvasView(canvas: canvas, configuration: config)
        
        let coordinator = canvasView.makeCoordinator()
        let pkCanvasView = PKCanvasView()
        
        canvas.setupCanvasView(pkCanvasView)
        coordinator.canvas = canvas
        
        #expect(canvas.canvasView === pkCanvasView)
        #expect(coordinator.canvas === canvas)
    }
    
    @Test("Delegate integration with coordinator")
    func testDelegateIntegration() {
        class TestDelegate: CanvasDelegate {
            var drawingChangedCount = 0
            
            func canvasDrawingDidChange(_ canvas: Usuzumi.CanvasBoard) {
                drawingChangedCount += 1
            }
        }
        
        let delegate = TestDelegate()
        let coordinator = CanvasCoordinator(delegate: delegate)
        let canvas = CanvasBoard()
        let pkCanvasView = PKCanvasView()
        
        coordinator.canvas = canvas
        canvas.setupCanvasView(pkCanvasView)
        
        coordinator.canvasViewDrawingDidChange(pkCanvasView)
        
        #expect(delegate.drawingChangedCount == 1)
    }
    
    @Test("CanvasBoard state updates through coordinator")
    func testCanvasStateUpdates() {
        let canvas = CanvasBoard()
        let coordinator = CanvasCoordinator(delegate: nil)
        let pkCanvasView = PKCanvasView()
        
        coordinator.canvas = canvas
        canvas.setupCanvasView(pkCanvasView)
        
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