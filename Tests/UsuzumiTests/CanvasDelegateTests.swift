import Testing
import Foundation
import CoreGraphics
@testable import Usuzumi

@Suite("CanvasDelegate Tests")
struct CanvasDelegateTests {
    
    class MockCanvasDelegate: CanvasDelegate {
        var didBeginDrawingCalled = false
        var didEndDrawingCalled = false
        var drawingDidChangeCalled = false
        var didZoomCalled = false
        var didScrollCalled = false
        var lastZoomScale: CGFloat?
        var lastScrollOffset: CGPoint?
        
        func canvasDidBeginDrawing(_ canvas: CanvasBoard) {
            didBeginDrawingCalled = true
        }
        
        func canvasDidEndDrawing(_ canvas: CanvasBoard) {
            didEndDrawingCalled = true
        }
        
        func canvasDrawingDidChange(_ canvas: CanvasBoard) {
            drawingDidChangeCalled = true
        }
        
        func canvasBoard(_ canvas: CanvasBoard, didZoomTo scale: CGFloat) {
            didZoomCalled = true
            lastZoomScale = scale
        }
        
        func canvasBoard(_ canvas: CanvasBoard, didScrollTo offset: CGPoint) {
            didScrollCalled = true
            lastScrollOffset = offset
        }
    }
    
    @Test("CanvasDelegate default implementations")
    @MainActor
    func testDefaultImplementations() {
        class MinimalDelegate: CanvasDelegate {}
        
        let delegate = MinimalDelegate()
        let canvas = CanvasBoard()
        
        delegate.canvasDidBeginDrawing(canvas)
        delegate.canvasDidEndDrawing(canvas)
        delegate.canvasDrawingDidChange(canvas)
        delegate.canvasBoard(canvas, didZoomTo: 1.0)
        delegate.canvasBoard(canvas, didScrollTo: .zero)
        
        #expect(true)
    }
    
    @Test("MockCanvasDelegate tracks method calls")
    @MainActor
    func testMockDelegateTracking() {
        let delegate = MockCanvasDelegate()
        let canvas = CanvasBoard()
        
        delegate.canvasDidBeginDrawing(canvas)
        #expect(delegate.didBeginDrawingCalled == true)
        
        delegate.canvasDidEndDrawing(canvas)
        #expect(delegate.didEndDrawingCalled == true)
        
        delegate.canvasDrawingDidChange(canvas)
        #expect(delegate.drawingDidChangeCalled == true)
        
        delegate.canvasBoard(canvas, didZoomTo: 2.5)
        #expect(delegate.didZoomCalled == true)
        #expect(delegate.lastZoomScale == 2.5)
        
        let offset = CGPoint(x: 100, y: 200)
        delegate.canvasBoard(canvas, didScrollTo: offset)
        #expect(delegate.didScrollCalled == true)
        #expect(delegate.lastScrollOffset == offset)
    }
}