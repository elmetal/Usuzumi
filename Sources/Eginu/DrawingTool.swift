import SwiftUI
import PencilKit

extension CanvasBoard {
    /// An enumeration that represents various drawing tools available in the canvas.
    ///
    /// ``Tool`` provides a high-level abstraction over PencilKit's tools,
    /// making it easier to work with different drawing instruments in SwiftUI.
    ///
    /// ## Overview
    ///
    /// Each tool case represents a different type of drawing instrument
    /// with customizable properties like color and width:
    ///
    /// ```swift
    /// let pen = CanvasBoard.Tool.pen(color: .blue, width: 3)
    /// let eraser = CanvasBoard.Tool.eraser(type: .vector)
    /// ```
    public enum Tool: Hashable, CaseIterable {
        /// A pen tool with customizable color and width.
        case pen(color: Color, width: CGFloat)

        /// A pencil tool with customizable color and width.
        case pencil(color: Color, width: CGFloat)

        /// A marker tool with customizable color and width.
        case marker(color: Color, width: CGFloat)

        /// A crayon tool with customizable color and width.
        case crayon(color: Color, width: CGFloat)

        /// A watercolor brush tool with customizable color and width.
        case watercolor(color: Color, width: CGFloat)

        /// A monoline pen tool with customizable color and width.
        case monoline(color: Color, width: CGFloat)

        /// A fountain pen tool with customizable color and width.
        case fountainPen(color: Color, width: CGFloat)

        /// An eraser tool with a specific eraser type.
        case eraser(type: EraserType)

        /// A lasso selection tool for selecting and moving drawings.
        case lasso

        /// A ruler tool for drawing straight lines.
        case ruler

        /// The type of eraser to use.
        public enum EraserType: String, CaseIterable {
            /// A vector eraser that removes entire strokes.
            case vector

            /// A bitmap eraser that removes pixels.
            case bitmap

            /// A fixed-width bitmap eraser.
            case fixedWidthBitmap
        }

        /// The corresponding PencilKit tool for this drawing tool.
        public var pkTool: PKTool {
            switch self {
            case .pen(let color, let width):
                return PKInkingTool(.pen, color: UIColor(color), width: width)
            case .pencil(let color, let width):
                return PKInkingTool(.pencil, color: UIColor(color), width: width)
            case .marker(let color, let width):
                return PKInkingTool(.marker, color: UIColor(color), width: width)
            case .crayon(let color, let width):
                return PKInkingTool(.crayon, color: UIColor(color), width: width)
            case .watercolor(let color, let width):
                return PKInkingTool(.watercolor, color: UIColor(color), width: width)
            case .monoline(let color, let width):
                return PKInkingTool(.monoline, color: UIColor(color), width: width)
            case .fountainPen(let color, let width):
                return PKInkingTool(.fountainPen, color: UIColor(color), width: width)
            case .eraser(let type):
                switch type {
                case .vector:
                    return PKEraserTool(.vector)
                case .bitmap:
                    return PKEraserTool(.bitmap)
                case .fixedWidthBitmap:
                    return PKEraserTool(.fixedWidthBitmap)
                }
            case .lasso:
                return PKLassoTool()
            case .ruler:
                return PKInkingTool(.pen, color: .black, width: 5)
            }
        }

        /// A collection of all drawing tools with default configurations.
        public static var allCases: [Tool] {
            [
                .pen(color: .black, width: 5),
                .pencil(color: .gray, width: 3),
                .marker(color: .yellow, width: 20),
                .crayon(color: .blue, width: 10),
                .watercolor(color: .green, width: 15),
                .monoline(color: .red, width: 5),
                .fountainPen(color: .black, width: 3),
                .eraser(type: .vector),
                .lasso,
                .ruler
            ]
        }

        /// The human-readable name of the drawing tool.
        public var name: String {
            switch self {
            case .pen: return "Pen"
            case .pencil: return "Pencil"
            case .marker: return "Marker"
            case .crayon: return "Crayon"
            case .watercolor: return "Watercolor"
            case .monoline: return "Monoline"
            case .fountainPen: return "Fountain Pen"
            case .eraser(let type): return "Eraser (\(type.rawValue))"
            case .lasso: return "Lasso"
            case .ruler: return "Ruler"
            }
        }

        /// The SF Symbol name for the drawing tool icon.
        public var icon: String {
            switch self {
            case .pen: return "pencil.tip"
            case .pencil: return "pencil"
            case .marker: return "highlighter"
            case .crayon: return "pencil.tip.crop.circle"
            case .watercolor: return "paintbrush"
            case .monoline: return "pencil.line"
            case .fountainPen: return "pencil.and.outline"
            case .eraser: return "eraser"
            case .lasso: return "lasso"
            case .ruler: return "ruler"
            }
        }
    }
}

// MARK: - Convenience Initializers
public extension CanvasBoard.Tool {
    /// Creates a pen tool with the specified color and width.
    static func pen(_ color: Color = .black, width: CGFloat = 5) -> CanvasBoard.Tool {
        .pen(color: color, width: width)
    }

    /// Creates a pencil tool with the specified color and width.
    static func pencil(_ color: Color = .gray, width: CGFloat = 3) -> CanvasBoard.Tool {
        .pencil(color: color, width: width)
    }

    /// Creates a marker tool with the specified color and width.
    static func marker(_ color: Color = .yellow, width: CGFloat = 20) -> CanvasBoard.Tool {
        .marker(color: color, width: width)
    }

    /// A default vector eraser tool.
    static var eraser: CanvasBoard.Tool {
        .eraser(type: .vector)
    }
}
