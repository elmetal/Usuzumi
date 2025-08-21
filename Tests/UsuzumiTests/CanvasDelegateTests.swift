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
        
        func canvasDidBeginDrawing(_ canvas: Canvas) {
            didBeginDrawingCalled = true
        }
        
        func canvasDidEndDrawing(_ canvas: Canvas) {
            didEndDrawingCalled = true
        }
        
        func canvasDrawingDidChange(_ canvas: Canvas) {
            drawingDidChangeCalled = true
        }
        
        func canvas(_ canvas: Canvas, didZoomTo scale: CGFloat) {
            didZoomCalled = true
            lastZoomScale = scale
        }
        
        func canvas(_ canvas: Canvas, didScrollTo offset: CGPoint) {
            didScrollCalled = true
            lastScrollOffset = offset
        }
    }
    
    @Test("CanvasDelegate default implementations")
    @MainActor
    func testDefaultImplementations() {
        class MinimalDelegate: CanvasDelegate {}
        
        let delegate = MinimalDelegate()
        let canvas = Canvas()
        
        delegate.canvasDidBeginDrawing(canvas)
        delegate.canvasDidEndDrawing(canvas)
        delegate.canvasDrawingDidChange(canvas)
        delegate.canvas(canvas, didZoomTo: 1.0)
        delegate.canvas(canvas, didScrollTo: .zero)
        
        #expect(true)
    }
    
    @Test("MockCanvasDelegate tracks method calls")
    @MainActor
    func testMockDelegateTracking() {
        let delegate = MockCanvasDelegate()
        let canvas = Canvas()
        
        delegate.canvasDidBeginDrawing(canvas)
        #expect(delegate.didBeginDrawingCalled == true)
        
        delegate.canvasDidEndDrawing(canvas)
        #expect(delegate.didEndDrawingCalled == true)
        
        delegate.canvasDrawingDidChange(canvas)
        #expect(delegate.drawingDidChangeCalled == true)
        
        delegate.canvas(canvas, didZoomTo: 2.5)
        #expect(delegate.didZoomCalled == true)
        #expect(delegate.lastZoomScale == 2.5)
        
        let offset = CGPoint(x: 100, y: 200)
        delegate.canvas(canvas, didScrollTo: offset)
        #expect(delegate.didScrollCalled == true)
        #expect(delegate.lastScrollOffset == offset)
    }
}