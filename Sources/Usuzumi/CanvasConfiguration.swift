import SwiftUI
import PencilKit

extension CanvasBoard {
    /// A configuration object that defines the appearance and behavior of a canvas view.
    ///
    /// Use ``Configuration`` to customize various aspects of the drawing canvas,
    /// including background color, input policies, and zoom settings.
    ///
    /// ## Overview
    ///
    /// Create a configuration to customize how your canvas looks and behaves:
    ///
    /// ```swift
    /// let canvas = CanvasBoard(
    ///     configuration: .init(
    ///         backgroundColor: .white,
    ///         allowsFingerDrawing: false,
    ///         minimumZoomScale: 1.0,
    ///         maximumZoomScale: 3.0
    ///     )
    /// )
    /// ```
    ///
    /// ## Topics
    ///
    /// ### Creating a Configuration
    /// - ``init(backgroundColor:isRulerActive:allowsFingerDrawing:defaultTool:minimumZoomScale:maximumZoomScale:isScrollEnabled:isOpaque:drawingPolicy:)``
    /// - ``default``
    ///
    /// ### Configuration Properties
    /// - ``backgroundColor``
    /// - ``isRulerActive``
    /// - ``allowsFingerDrawing``
    /// - ``defaultTool``
    /// - ``minimumZoomScale``
    /// - ``maximumZoomScale``
    /// - ``isScrollEnabled``
    /// - ``isOpaque``
    /// - ``drawingPolicy``
    public struct Configuration {
        /// The background color of the canvas.
        public let backgroundColor: UIColor

        /// A Boolean value that determines whether the ruler is active.
        public let isRulerActive: Bool

        /// A Boolean value that determines whether finger drawing is allowed.
        public let allowsFingerDrawing: Bool

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
        ///
        /// - Parameters:
        ///   - backgroundColor: The background color of the canvas. Defaults to `.systemBackground`.
        ///   - isRulerActive: Whether the ruler is initially active. Defaults to `false`.
        ///   - allowsFingerDrawing: Whether finger drawing is allowed. Defaults to `true`.
        ///   - defaultTool: The default drawing tool. Defaults to a black pen with width 5.
        ///   - minimumZoomScale: The minimum zoom scale. Defaults to `0.5`.
        ///   - maximumZoomScale: The maximum zoom scale. Defaults to `5.0`.
        ///   - isScrollEnabled: Whether scrolling is enabled. Defaults to `true`.
        ///   - isOpaque: Whether the canvas is opaque. Defaults to `true`.
        ///   - drawingPolicy: The drawing input policy. Defaults to `.anyInput`.
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

        /// The default canvas configuration.
        ///
        /// This configuration uses system default values for all settings.
        public static var `default`: Configuration {
            Configuration()
        }
    }
}
