import SwiftUI

/// A view modifier that adds gesture recognition capabilities to a canvas view.
///
/// ``CanvasGestureModifier`` provides support for common gestures like pinch-to-zoom,
/// pan, double-tap, and long press on the canvas.
///
/// ## Overview
///
/// Apply this modifier to your canvas view to enable gesture interactions:
///
/// ```swift
/// CanvasView(canvas: canvas)
///     .canvasGestures(
///         canvas: canvas,
///         onDoubleTap: {
///             // Reset zoom on double tap
///         },
///         onLongPress: { location in
///             // Show context menu at location
///         }
///     )
/// ```
///
/// ## Topics
///
/// ### Gesture Callbacks
/// - ``onDoubleTap``
/// - ``onLongPress``
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
    /// Adds canvas gesture recognition to the view.
    ///
    /// This modifier enables pinch-to-zoom, pan, double-tap, and long press gestures
    /// on the canvas view.
    ///
    /// - Parameters:
    ///   - canvas: The canvas board to apply gestures to.
    ///   - onDoubleTap: An optional closure called when the user double-taps the canvas.
    ///   - onLongPress: An optional closure called when the user long-presses the canvas,
    ///                  providing the press location.
    /// - Returns: A view with canvas gesture recognition enabled.
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