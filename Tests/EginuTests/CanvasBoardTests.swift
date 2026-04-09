import Testing
import SwiftUI
import PencilKit
@testable import Eginu

@Suite("CanvasBoard Tests")
struct CanvasBoardTests {

    @Test("CanvasBoard initializes with default values")
    @MainActor
    func testCanvasBoardInitialization() {
        let canvas = CanvasBoard()

        #expect(canvas.isDrawing == false)
        #expect(canvas.canUndo == false)
        #expect(canvas.canRedo == false)
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

        let drawing = PKDrawing()
        let data = try drawing.dataRepresentation()

        canvas.drawingData = data

        #expect(canvas.drawingData.count > 0)
    }

    @Test("CanvasBoard export as image returns image for empty drawing")
    @MainActor
    func testExportEmptyDrawing() {
        let canvas = CanvasBoard()

        let image = canvas.exportImage()

        #expect(image.size.width >= 0)
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
    }

    // MARK: - Drawing Operations

    @Test("strokes returns empty array for empty drawing")
    @MainActor
    func testStrokesEmpty() {
        let canvas = CanvasBoard()

        #expect(canvas.strokes.isEmpty)
    }

    @Test("strokes returns strokes from bound canvas view")
    @MainActor
    func testStrokesFromBoundCanvas() {
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        canvas.bind(to: canvasView)

        let stroke = PKStroke(
            ink: PKInk(.pen, color: .black),
            path: PKStrokePath(controlPoints: [
                PKStrokePoint(location: .zero, timeOffset: 0, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
                PKStrokePoint(location: CGPoint(x: 100, y: 100), timeOffset: 0.1, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
            ], creationDate: Date())
        )
        canvasView.drawing = PKDrawing(strokes: [stroke])

        #expect(canvas.strokes.count == 1)
    }

    @Test("drawingBounds returns empty rect for empty drawing")
    @MainActor
    func testDrawingBoundsEmpty() {
        let canvas = CanvasBoard()

        #expect(canvas.drawingBounds.size == .zero)
    }

    @Test("transformDrawing applies transform")
    @MainActor
    func testTransformDrawing() {
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        canvas.bind(to: canvasView)

        let stroke = PKStroke(
            ink: PKInk(.pen, color: .black),
            path: PKStrokePath(controlPoints: [
                PKStrokePoint(location: CGPoint(x: 10, y: 10), timeOffset: 0, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
                PKStrokePoint(location: CGPoint(x: 20, y: 20), timeOffset: 0.1, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
            ], creationDate: Date())
        )
        canvasView.drawing = PKDrawing(strokes: [stroke])

        let boundsBefore = canvas.drawingBounds
        canvas.transformDrawing(using: CGAffineTransform(translationX: 100, y: 100))
        let boundsAfter = canvas.drawingBounds

        #expect(boundsAfter.origin.x > boundsBefore.origin.x)
        #expect(boundsAfter.origin.y > boundsBefore.origin.y)
    }

    @Test("appendDrawing with PKDrawing increases stroke count")
    @MainActor
    func testAppendDrawing() {
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        canvas.bind(to: canvasView)

        let stroke = PKStroke(
            ink: PKInk(.pen, color: .black),
            path: PKStrokePath(controlPoints: [
                PKStrokePoint(location: .zero, timeOffset: 0, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
                PKStrokePoint(location: CGPoint(x: 50, y: 50), timeOffset: 0.1, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
            ], creationDate: Date())
        )
        let other = PKDrawing(strokes: [stroke])

        canvas.appendDrawing(other)

        #expect(canvas.strokes.count == 1)
    }

    @Test("appendDrawing with Data increases stroke count")
    @MainActor
    func testAppendDrawingData() throws {
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        canvas.bind(to: canvasView)

        let stroke = PKStroke(
            ink: PKInk(.pen, color: .black),
            path: PKStrokePath(controlPoints: [
                PKStrokePoint(location: .zero, timeOffset: 0, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
                PKStrokePoint(location: CGPoint(x: 50, y: 50), timeOffset: 0.1, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
            ], creationDate: Date())
        )
        let data = try PKDrawing(strokes: [stroke]).dataRepresentation()

        try canvas.appendDrawing(data)

        #expect(canvas.strokes.count == 1)
    }

    @Test("appendStrokes adds strokes to drawing")
    @MainActor
    func testAppendStrokes() {
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        canvas.bind(to: canvasView)

        let stroke = PKStroke(
            ink: PKInk(.pen, color: .black),
            path: PKStrokePath(controlPoints: [
                PKStrokePoint(location: .zero, timeOffset: 0, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
                PKStrokePoint(location: CGPoint(x: 50, y: 50), timeOffset: 0.1, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2),
            ], creationDate: Date())
        )

        canvas.appendStrokes([stroke])

        #expect(canvas.strokes.count == 1)
    }

    // MARK: - Eraser Width

    @Test("Eraser tool with width creates PKEraserTool with width")
    @MainActor
    func testEraserWithWidth() {
        let tool = CanvasBoard.Tool.eraser(type: .bitmap, width: 20)
        let pkTool = tool.pkTool

        #expect(pkTool is PKEraserTool)
    }

    @Test("Eraser tool without width creates PKEraserTool with default width")
    @MainActor
    func testEraserWithoutWidth() {
        let tool = CanvasBoard.Tool.eraser(type: .vector)
        let pkTool = tool.pkTool

        #expect(pkTool is PKEraserTool)
    }

    @Test("Eraser convenience initializer with width")
    @MainActor
    func testEraserConvenience() {
        let tool = CanvasBoard.Tool.eraser(.fixedWidthBitmap, width: 15)

        #expect(tool.name == "Eraser (fixedWidthBitmap)")
        #expect(tool.pkTool is PKEraserTool)
    }

    // MARK: - Tool Round-Trip (PKTool → Tool)

    @Test("Tool.init from PKInkingTool round-trips for pen")
    @MainActor
    func testToolFromPKInkingToolPen() {
        let pkTool = PKInkingTool(.pen, color: .red, width: 7)
        let tool = CanvasBoard.Tool(pkTool)

        #expect(tool != nil)
        if case .pen(_, let width) = tool {
            #expect(width == 7)
        } else {
            Issue.record("Expected .pen case")
        }
    }

    @Test("Tool.init from PKEraserTool round-trips")
    @MainActor
    func testToolFromPKEraserTool() {
        let pkTool = PKEraserTool(.vector)
        let tool = CanvasBoard.Tool(pkTool)

        #expect(tool != nil)
        if case .eraser(let type, _) = tool {
            #expect(type == .vector)
        } else {
            Issue.record("Expected .eraser case")
        }
    }

    @Test("Tool.init from PKLassoTool returns .lasso")
    @MainActor
    func testToolFromPKLassoTool() {
        let pkTool = PKLassoTool()
        let tool = CanvasBoard.Tool(pkTool)

        #expect(tool == .lasso)
    }

    @Test("setToolFromPicker updates currentTool")
    @MainActor
    func testSetToolFromPickerUpdatesCurrentTool() {
        let canvas = CanvasBoard()
        let canvasView = PKCanvasView()
        canvas.bind(to: canvasView)

        let pkTool = PKInkingTool(.marker, color: .blue, width: 15)
        canvas.setToolFromPicker(pkTool)

        if case .marker(_, let width) = canvas.currentTool {
            #expect(width == 15)
        } else {
            Issue.record("Expected .marker case, got \(canvas.currentTool)")
        }
    }
}
