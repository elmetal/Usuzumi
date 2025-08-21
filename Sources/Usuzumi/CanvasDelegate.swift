import Foundation
import PencilKit

public protocol CanvasDelegate: AnyObject {
    func canvasDidBeginDrawing(_ canvas: CanvasBoard)
    func canvasDidEndDrawing(_ canvas: CanvasBoard)
    func canvasDrawingDidChange(_ canvas: CanvasBoard)
    func canvasBoard(_ canvas: CanvasBoard, didZoomTo scale: CGFloat)
    func canvasBoard(_ canvas: CanvasBoard, didScrollTo offset: CGPoint)
}

public extension CanvasDelegate {
    func canvasDidBeginDrawing(_ canvas: CanvasBoard) {}
    func canvasDidEndDrawing(_ canvas: CanvasBoard) {}
    func canvasDrawingDidChange(_ canvas: CanvasBoard) {}
    func canvasBoard(_ canvas: CanvasBoard, didZoomTo scale: CGFloat) {}
    func canvasBoard(_ canvas: CanvasBoard, didScrollTo offset: CGPoint) {}
}