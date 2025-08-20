import SwiftUI
import PencilKit

public struct CanvasView: UIViewRepresentable {
    @ObservedObject public var canvas: Canvas
    public var configuration: CanvasConfiguration
    public weak var delegate: CanvasDelegate?
    
    private var isToolPickerVisible: Bool = false
    
    public init(
        canvas: Canvas,
        configuration: CanvasConfiguration = .default
    ) {
        self.canvas = canvas
        self.configuration = configuration
    }
    
    public func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        
        canvasView.delegate = context.coordinator
        canvasView.backgroundColor = configuration.backgroundColor
        canvasView.isRulerActive = configuration.isRulerActive
        canvasView.drawingPolicy = configuration.drawingPolicy
        canvasView.minimumZoomScale = configuration.minimumZoomScale
        canvasView.maximumZoomScale = configuration.maximumZoomScale
        canvasView.isScrollEnabled = configuration.isScrollEnabled
        canvasView.isOpaque = configuration.isOpaque
        canvasView.tool = configuration.defaultTool
        
        canvas.setupCanvasView(canvasView)
        context.coordinator.canvas = canvas
        
        if isToolPickerVisible {
            context.coordinator.showToolPicker(for: canvasView)
        }
        
        return canvasView
    }
    
    public func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        canvasView.backgroundColor = configuration.backgroundColor
        canvasView.isRulerActive = configuration.isRulerActive
        canvasView.drawingPolicy = configuration.drawingPolicy
        canvasView.minimumZoomScale = configuration.minimumZoomScale
        canvasView.maximumZoomScale = configuration.maximumZoomScale
        canvasView.isScrollEnabled = configuration.isScrollEnabled
        canvasView.isOpaque = configuration.isOpaque
        canvasView.tool = canvas.currentTool
        
        context.coordinator.delegate = delegate
        
        if isToolPickerVisible && canvas.toolPicker == nil {
            context.coordinator.showToolPicker(for: canvasView)
        } else if !isToolPickerVisible && canvas.toolPicker != nil {
            context.coordinator.hideToolPicker()
        }
    }
    
    public func makeCoordinator() -> CanvasCoordinator {
        CanvasCoordinator(delegate: delegate)
    }
}

public extension CanvasView {
    func canvasDelegate(_ delegate: CanvasDelegate?) -> CanvasView {
        var view = self
        view.delegate = delegate
        return view
    }
    
    func toolPickerVisible(_ visible: Bool) -> CanvasView {
        var view = self
        view.isToolPickerVisible = visible
        return view
    }
    
    func rulerActive(_ active: Bool) -> CanvasView {
        var view = self
        view.configuration.isRulerActive = active
        return view
    }
    
    func allowsFingerDrawing(_ allows: Bool) -> CanvasView {
        var view = self
        view.configuration.allowsFingerDrawing = allows
        view.configuration.drawingPolicy = allows ? .anyInput : .pencilOnly
        return view
    }
    
    func backgroundColor(_ color: UIColor) -> CanvasView {
        var view = self
        view.configuration.backgroundColor = color
        return view
    }
    
    func scrollEnabled(_ enabled: Bool) -> CanvasView {
        var view = self
        view.configuration.isScrollEnabled = enabled
        return view
    }
    
    func zoomScale(min: CGFloat, max: CGFloat) -> CanvasView {
        var view = self
        view.configuration.minimumZoomScale = min
        view.configuration.maximumZoomScale = max
        return view
    }
}