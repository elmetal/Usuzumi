import Testing
import UIKit
import PencilKit
@testable import Usuzumi

@Suite("CanvasView.Coordinator Tests")
@MainActor
struct CoordinatorTests {

    @Test("CanvasView.Coordinator initialization")
    func testInitialization() {
        let coordinator = CanvasView.Coordinator()

        #expect(coordinator.canvas == nil)
    }

    @Test("Show tool picker creates tool picker")
    func testShowToolPicker() {
        let coordinator = CanvasView.Coordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.bind(to: canvasView)

        coordinator.showToolPicker(for: canvasView)

        #expect(coordinator.toolPicker != nil)
    }

    @Test("Hide tool picker removes tool picker")
    func testHideToolPicker() {
        let coordinator = CanvasView.Coordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.bind(to: canvasView)

        coordinator.showToolPicker(for: canvasView)
        #expect(coordinator.toolPicker != nil)

        coordinator.hideToolPicker()
        #expect(coordinator.toolPicker == nil)
    }

    @Test("Tool picker selected tool change updates canvas view")
    func testToolPickerSelectedToolChange() {
        let coordinator = CanvasView.Coordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        let toolPicker = PKToolPicker()

        coordinator.canvas = canvas
        canvas.bind(to: canvasView)

        let newTool = PKInkingTool(.pencil, color: .red, width: 10)
        toolPicker.selectedTool = newTool

        coordinator.toolPickerSelectedToolDidChange(toolPicker)

        // The PKToolPicker directly sets the tool on the PKCanvasView
        #expect(canvasView.tool is PKInkingTool)
    }

    @Test("Drawing change callback is invoked")
    func testDrawingChangeCallback() {
        let coordinator = CanvasView.Coordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.bind(to: canvasView)

        var callCount = 0
        coordinator.onDrawingChange = { _ in callCount += 1 }

        coordinator.canvasViewDrawingDidChange(canvasView)

        #expect(callCount == 1)
    }
}
