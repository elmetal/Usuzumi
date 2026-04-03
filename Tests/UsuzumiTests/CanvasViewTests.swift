import Testing
import SwiftUI
import PencilKit
@testable import Usuzumi

@Suite("CanvasView Tests")
@MainActor
struct CanvasViewTests {

    @Test("CanvasView initialization with default configuration")
    func testDefaultInitialization() {
        let canvas = CanvasBoard()
        let canvasView = CanvasView(canvas)

        #expect(canvasView.canvas === canvas)
        #expect(canvas.configuration.backgroundColor == .systemBackground)
    }

    @Test("CanvasView simple initialization without canvas board")
    func testSimpleInitialization() {
        let canvasView = CanvasView()

        #expect(canvasView.canvas.configuration.backgroundColor == .systemBackground)
    }

    @Test("CanvasView initialization with custom configuration")
    func testCustomConfiguration() {
        let config = CanvasBoard.Configuration(
            backgroundColor: .systemGray,
            isRulerActive: true,
            allowsFingerDrawing: false
        )
        let canvas = CanvasBoard(configuration: config)
        let canvasView = CanvasView(canvas)

        #expect(canvas.configuration.backgroundColor == .systemGray)
        #expect(canvas.configuration.isRulerActive == true)
        #expect(canvas.configuration.allowsFingerDrawing == false)
    }

    @Test("CanvasView makeCoordinator creates coordinator")
    func testMakeCoordinator() {
        let canvas = CanvasBoard()
        let canvasView = CanvasView(canvas)

        let coordinator = canvasView.makeCoordinator()

        #expect(coordinator is CanvasCoordinator)
    }
}
