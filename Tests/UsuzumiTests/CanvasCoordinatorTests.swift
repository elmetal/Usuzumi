import Testing
import UIKit
import PencilKit
@testable import Usuzumi

@Suite("CanvasCoordinator Tests")
@MainActor
struct CanvasCoordinatorTests {

    @Test("CanvasCoordinator initialization")
    func testInitialization() {
        let coordinator = CanvasCoordinator()

        #expect(coordinator.canvas == nil)
    }

    @Test("Show tool picker creates tool picker")
    func testShowToolPicker() {
        let coordinator = CanvasCoordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.setupCanvasView(canvasView)

        coordinator.showToolPicker(for: canvasView)

        #expect(canvas.toolPicker != nil)
    }

    @Test("Hide tool picker removes tool picker")
    func testHideToolPicker() {
        let coordinator = CanvasCoordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.setupCanvasView(canvasView)

        coordinator.showToolPicker(for: canvasView)
        #expect(canvas.toolPicker != nil)

        coordinator.hideToolPicker()
        #expect(canvas.toolPicker == nil)
    }

    @Test("Tool picker selected tool change updates canvas")
    func testToolPickerSelectedToolChange() {
        let coordinator = CanvasCoordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        let toolPicker = PKToolPicker()

        coordinator.canvas = canvas
        canvas.setupCanvasView(canvasView)

        let newTool = PKInkingTool(.pencil, color: .red, width: 10)
        toolPicker.selectedTool = newTool

        coordinator.toolPickerSelectedToolDidChange(toolPicker)

        #expect(canvas.currentTool is PKInkingTool)
        if let currentTool = canvas.currentTool as? PKInkingTool {
            #expect(currentTool.inkType == PKInkingTool.InkType.pencil)
        }
    }

    @Test("Drawing change callback is invoked")
    func testDrawingChangeCallback() {
        let coordinator = CanvasCoordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.setupCanvasView(canvasView)

        var callCount = 0
        coordinator.onDrawingChange = { _ in callCount += 1 }

        coordinator.canvasViewDrawingDidChange(canvasView)

        #expect(callCount == 1)
    }
}
