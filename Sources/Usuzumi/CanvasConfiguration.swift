import SwiftUI
import PencilKit

public struct CanvasConfiguration {
    public var backgroundColor: UIColor
    public var isRulerActive: Bool
    public var allowsFingerDrawing: Bool
    public var defaultTool: PKTool
    public var minimumZoomScale: CGFloat
    public var maximumZoomScale: CGFloat
    public var isScrollEnabled: Bool
    public var isOpaque: Bool
    public var drawingPolicy: PKCanvasViewDrawingPolicy
    
    public init(
        backgroundColor: UIColor = .systemBackground,
        isRulerActive: Bool = false,
        allowsFingerDrawing: Bool = true,
        defaultTool: PKTool = PKInkingTool(.pen, color: .black, width: 5),
        minimumZoomScale: CGFloat = 0.5,
        maximumZoomScale: CGFloat = 5.0,
        isScrollEnabled: Bool = true,
        isOpaque: Bool = true,
        drawingPolicy: PKCanvasViewDrawingPolicy = .anyInput
    ) {
        self.backgroundColor = backgroundColor
        self.isRulerActive = isRulerActive
        self.allowsFingerDrawing = allowsFingerDrawing
        self.defaultTool = defaultTool
        self.minimumZoomScale = minimumZoomScale
        self.maximumZoomScale = maximumZoomScale
        self.isScrollEnabled = isScrollEnabled
        self.isOpaque = isOpaque
        self.drawingPolicy = drawingPolicy
    }
    
    public static var `default`: CanvasConfiguration {
        CanvasConfiguration()
    }
}