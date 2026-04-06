import UIKit
import PencilKit

extension CanvasView {
    /// A coordinator that bridges PencilKit's UIKit components with SwiftUI.
    ///
    /// This class is automatically created and managed by ``CanvasView``. It serves
    /// as the delegate for both `PKCanvasView` and `PKToolPicker`, forwarding
    /// relevant events through callback closures set via view modifiers.
    @MainActor
    public class Coordinator: NSObject {
        weak var canvas: CanvasBoard?
        var onDrawingChange: (@MainActor @Sendable (CanvasBoard) -> Void)?
        var onZoom: (@MainActor @Sendable (CGFloat) -> Void)?
        var onScroll: (@MainActor @Sendable (CGPoint) -> Void)?
        var onFinishRendering: (@MainActor @Sendable () -> Void)?
        var onToolPickerVisibilityChange: (@MainActor @Sendable (Bool) -> Void)?
        var onToolPickerFramesObscuredChange: (@MainActor @Sendable (CGRect) -> Void)?
        private(set) var toolPicker: PKToolPicker?
        private var lastContentOffset: CGPoint = .zero
        private var lastZoomScale: CGFloat = 1.0

        override init() {
            super.init()
        }

        func showToolPicker(for canvasView: PKCanvasView) {
            guard toolPicker == nil else { return }

            let picker = PKToolPicker()
            picker.setVisible(true, forFirstResponder: canvasView)
            picker.addObserver(canvasView)
            picker.addObserver(self)
            canvasView.becomeFirstResponder()

            toolPicker = picker
        }

        func hideToolPicker() {
            guard let picker = toolPicker,
                  let canvasView = canvas?.boundCanvasView else { return }

            picker.setVisible(false, forFirstResponder: canvasView)
            picker.removeObserver(canvasView)
            picker.removeObserver(self)

            toolPicker = nil
        }
    }
}

extension CanvasView.Coordinator: PKCanvasViewDelegate {
    public func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guard let canvas else { return }
        canvas.updateUndoRedoState()
        onDrawingChange?(canvas)
    }

    public func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        canvas?.setDrawingState(true)
    }

    public func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        canvas?.setDrawingState(false)
    }

    public func canvasViewDidZoom(_ canvasView: PKCanvasView) {
        let newZoomScale = canvasView.zoomScale
        if abs(newZoomScale - lastZoomScale) > 0.01 {
            lastZoomScale = newZoomScale
            onZoom?(newZoomScale)
        }
    }

    public func canvasViewDidScroll(_ canvasView: PKCanvasView) {
        let newOffset = canvasView.contentOffset
        if !newOffset.equalTo(lastContentOffset) {
            lastContentOffset = newOffset
            onScroll?(newOffset)
        }
    }

    public func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        onFinishRendering?()
    }
}

extension CanvasView.Coordinator: PKToolPickerObserver {
    public func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {
        canvas?.setToolFromPicker(toolPicker.selectedTool)
    }

    public func toolPickerIsRulerActiveDidChange(_ toolPicker: PKToolPicker) {
        canvas?.setRulerFromPicker(toolPicker.isRulerActive)
    }

    public func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        onToolPickerVisibilityChange?(toolPicker.isVisible)
    }

    public func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        guard let canvasView = canvas?.boundCanvasView else { return }
        onToolPickerFramesObscuredChange?(toolPicker.frameObscured(in: canvasView))
    }
}
