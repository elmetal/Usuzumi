import UIKit
import PencilKit

/// A coordinator that bridges PencilKit's UIKit components with SwiftUI.
///
/// ``CanvasCoordinator`` handles the communication between the canvas view,
/// tool picker, and delegate callbacks. It manages tool selection, drawing
/// state changes, and view updates.
///
/// ## Overview
///
/// This class is automatically created and managed by ``CanvasView``. It serves
/// as the delegate for both `PKCanvasView` and `PKToolPicker`, forwarding
/// relevant events to the ``CanvasDelegate``.
///
/// ## Topics
///
/// ### Tool Picker Management
/// - ``showToolPicker(for:)``
/// - ``hideToolPicker()``
@MainActor
public class CanvasCoordinator: NSObject {
    weak var canvas: CanvasBoard?
    weak var delegate: CanvasDelegate?
    private var lastContentOffset: CGPoint = .zero
    private var lastZoomScale: CGFloat = 1.0
    
    init(delegate: CanvasDelegate?) {
        self.delegate = delegate
        super.init()
    }
    
    func showToolPicker(for canvasView: PKCanvasView) {
        guard canvas?.toolPicker == nil else { return }
        
        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)
        canvasView.becomeFirstResponder()
        
        canvas?.toolPicker = toolPicker
    }
    
    func hideToolPicker() {
        guard let toolPicker = canvas?.toolPicker,
              let canvasView = canvas?.canvasView else { return }
        
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        toolPicker.removeObserver(canvasView)
        toolPicker.removeObserver(self)
        
        canvas?.toolPicker = nil
    }
}

extension CanvasCoordinator: PKCanvasViewDelegate {
    public func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        canvas?.updateUndoRedoState()
        delegate?.canvasDrawingDidChange(canvas!)
    }
    
    public func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        canvas?.setDrawingState(true)
        delegate?.canvasDidBeginDrawing(canvas!)
    }
    
    public func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        canvas?.setDrawingState(false)
        delegate?.canvasDidEndDrawing(canvas!)
    }
    
    public func canvasViewDidZoom(_ canvasView: PKCanvasView) {
        let newZoomScale = canvasView.zoomScale
        if abs(newZoomScale - lastZoomScale) > 0.01 {
            lastZoomScale = newZoomScale
            delegate?.canvasBoard(canvas!, didZoomTo: newZoomScale)
        }
    }
    
    public func canvasViewDidScroll(_ canvasView: PKCanvasView) {
        let newOffset = canvasView.contentOffset
        if !newOffset.equalTo(lastContentOffset) {
            lastContentOffset = newOffset
            delegate?.canvasBoard(canvas!, didScrollTo: newOffset)
        }
    }
}

extension CanvasCoordinator: PKToolPickerObserver {
    public func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {
        canvas?.currentTool = toolPicker.selectedTool
        canvas?.canvasView?.tool = toolPicker.selectedTool
    }
    
    public func toolPickerIsRulerActiveDidChange(_ toolPicker: PKToolPicker) {
        canvas?.canvasView?.isRulerActive = toolPicker.isRulerActive
    }
    
    public func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
    }
    
    public func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
    }
}
