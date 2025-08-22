import Foundation
import PencilKit

/// A protocol that defines methods for receiving canvas-related events.
///
/// Conform to ``CanvasDelegate`` to receive notifications about drawing events,
/// zoom changes, and scroll position updates from a canvas view.
///
/// ## Overview
///
/// Implement this protocol to respond to user interactions with the canvas:
///
/// ```swift
/// class MyCanvasDelegate: CanvasDelegate {
///     func canvasDidBeginDrawing(_ canvas: CanvasBoard) {
///         print("User started drawing")
///     }
///     
///     func canvasDrawingDidChange(_ canvas: CanvasBoard) {
///         // Save drawing automatically
///         saveDrawing(canvas.drawingData)
///     }
/// }
/// ```
///
/// All delegate methods have default empty implementations, so you only need
/// to implement the methods you're interested in.
///
/// ## Topics
///
/// ### Drawing Events
/// - ``canvasDidBeginDrawing(_:)``
/// - ``canvasDidEndDrawing(_:)``
/// - ``canvasDrawingDidChange(_:)``
///
/// ### View Transform Events
/// - ``canvasBoard(_:didZoomTo:)``
/// - ``canvasBoard(_:didScrollTo:)``
public protocol CanvasDelegate: AnyObject {
    /// Tells the delegate that the user began drawing on the canvas.
    ///
    /// - Parameter canvas: The canvas board where drawing began.
    func canvasDidBeginDrawing(_ canvas: CanvasBoard)
    
    /// Tells the delegate that the user stopped drawing on the canvas.
    ///
    /// - Parameter canvas: The canvas board where drawing ended.
    func canvasDidEndDrawing(_ canvas: CanvasBoard)
    
    /// Tells the delegate that the drawing content changed.
    ///
    /// This method is called whenever the drawing is modified, including
    /// after undo and redo operations.
    ///
    /// - Parameter canvas: The canvas board whose drawing changed.
    func canvasDrawingDidChange(_ canvas: CanvasBoard)
    
    /// Tells the delegate that the canvas zoom scale changed.
    ///
    /// - Parameters:
    ///   - canvas: The canvas board that was zoomed.
    ///   - scale: The new zoom scale value.
    func canvasBoard(_ canvas: CanvasBoard, didZoomTo scale: CGFloat)
    
    /// Tells the delegate that the canvas scroll position changed.
    ///
    /// - Parameters:
    ///   - canvas: The canvas board that was scrolled.
    ///   - offset: The new scroll offset in points.
    func canvasBoard(_ canvas: CanvasBoard, didScrollTo offset: CGPoint)
}

public extension CanvasDelegate {
    func canvasDidBeginDrawing(_ canvas: CanvasBoard) {}
    func canvasDidEndDrawing(_ canvas: CanvasBoard) {}
    func canvasDrawingDidChange(_ canvas: CanvasBoard) {}
    func canvasBoard(_ canvas: CanvasBoard, didZoomTo scale: CGFloat) {}
    func canvasBoard(_ canvas: CanvasBoard, didScrollTo offset: CGPoint) {}
}