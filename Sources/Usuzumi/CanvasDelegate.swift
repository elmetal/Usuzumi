import Foundation
import PencilKit

public protocol CanvasDelegate: AnyObject {
    func canvasDidBeginDrawing(_ canvas: Canvas)
    func canvasDidEndDrawing(_ canvas: Canvas)
    func canvasDrawingDidChange(_ canvas: Canvas)
    func canvas(_ canvas: Canvas, didZoomTo scale: CGFloat)
    func canvas(_ canvas: Canvas, didScrollTo offset: CGPoint)
}

public extension CanvasDelegate {
    func canvasDidBeginDrawing(_ canvas: Canvas) {}
    func canvasDidEndDrawing(_ canvas: Canvas) {}
    func canvasDrawingDidChange(_ canvas: Canvas) {}
    func canvas(_ canvas: Canvas, didZoomTo scale: CGFloat) {}
    func canvas(_ canvas: Canvas, didScrollTo offset: CGPoint) {}
}