import Testing
import UIKit
import PencilKit
@testable import Eginu

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

    @Test("Tool picker selected item change invokes callback")
    func testToolPickerSelectedItemChangeCallback() {
        let coordinator = CanvasView.Coordinator()
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()

        coordinator.canvas = canvas
        canvas.bind(to: canvasView)

        var callbackFired = false
        coordinator.onToolPickerSelectedItemChange = { _ in callbackFired = true }

        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(coordinator)

        coordinator.toolPickerSelectedToolItemDidChange(toolPicker)

        #expect(callbackFired)
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
