import SwiftUI

public struct CanvasGestureModifier: ViewModifier {
    @ObservedObject var canvas: CanvasBoard
    
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero
    
    var onDoubleTap: (() -> Void)?
    var onLongPress: ((CGPoint) -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .onTapGesture(count: 2) {
                handleDoubleTap()
            }
            .onLongPressGesture(minimumDuration: 0.5) {
                // Long press without location
                onLongPress?(.zero)
            }
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        handlePinch(scale: value)
                    }
                    .onEnded { _ in
                        lastScaleValue = 1.0
                    }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        handlePan(translation: value.translation)
                    }
                    .onEnded { _ in
                        lastOffset = .zero
                    }
            )
    }
    
    private func handleDoubleTap() {
        if let canvasView = canvas.canvasView {
            // Reset zoom to 1.0
            canvasView.setZoomScale(1.0, animated: true)
        }
        onDoubleTap?()
    }
    
    private func handlePinch(scale: CGFloat) {
        guard let canvasView = canvas.canvasView else { return }
        
        let delta = scale / lastScaleValue
        let newScale = canvasView.zoomScale * delta
        
        // Clamp to min/max zoom scale
        let clampedScale = min(max(newScale, canvasView.minimumZoomScale), canvasView.maximumZoomScale)
        canvasView.zoomScale = clampedScale
        
        lastScaleValue = scale
    }
    
    private func handlePan(translation: CGSize) {
        guard let canvasView = canvas.canvasView else { return }
        
        let delta = CGSize(
            width: translation.width - lastOffset.width,
            height: translation.height - lastOffset.height
        )
        
        canvasView.contentOffset = CGPoint(
            x: canvasView.contentOffset.x - delta.width,
            y: canvasView.contentOffset.y - delta.height
        )
        
        lastOffset = translation
    }
}

// MARK: - View Extension
public extension View {
    func canvasGestures(
        canvas: CanvasBoard,
        onDoubleTap: (() -> Void)? = nil,
        onLongPress: ((CGPoint) -> Void)? = nil
    ) -> some View {
        self.modifier(
            CanvasGestureModifier(
                canvas: canvas,
                onDoubleTap: onDoubleTap,
                onLongPress: onLongPress
            )
        )
    }
}