import SwiftUI
import PencilKit

extension CanvasBoard {
    /// A configuration object that defines the structural behavior of a canvas view.
    ///
    /// Use ``Configuration`` to set properties that are determined at creation time
    /// and do not change during the canvas lifetime. For dynamic properties like
    /// ruler visibility or background color, use the corresponding view modifiers.
    ///
    /// ## Overview
    ///
    /// ```swift
    /// let canvas = CanvasBoard(
    ///     configuration: .init(
    ///         drawingPolicy: .pencilOnly,
    ///         minimumZoomScale: 1.0,
    ///         maximumZoomScale: 3.0
    ///     )
    /// )
    /// ```
    public struct Configuration {
        /// The default drawing tool to use when the canvas is created.
        public let defaultTool: PKTool

        /// The minimum zoom scale for the canvas.
        public let minimumZoomScale: CGFloat

        /// The maximum zoom scale for the canvas.
        public let maximumZoomScale: CGFloat

        /// A Boolean value that determines whether scrolling is enabled.
        public let isScrollEnabled: Bool

        /// A Boolean value that determines whether the canvas is opaque.
        public let isOpaque: Bool

        /// The drawing policy that determines which input methods are allowed.
        public let drawingPolicy: PKCanvasViewDrawingPolicy

        /// Creates a canvas configuration with the specified settings.
        public init(
            defaultTool: PKTool = PKInkingTool(.pen, color: .black, width: 5),
            minimumZoomScale: CGFloat = 0.5,
            maximumZoomScale: CGFloat = 5.0,
            isScrollEnabled: Bool = true,
            isOpaque: Bool = true,
            drawingPolicy: PKCanvasViewDrawingPolicy = .anyInput
        ) {
            self.defaultTool = defaultTool
            self.minimumZoomScale = minimumZoomScale
            self.maximumZoomScale = maximumZoomScale
            self.isScrollEnabled = isScrollEnabled
            self.isOpaque = isOpaque
            self.drawingPolicy = drawingPolicy
        }

        /// The default canvas configuration.
        public static var `default`: Configuration {
            Configuration()
        }
    }
}
