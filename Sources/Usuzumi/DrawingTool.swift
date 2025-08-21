import SwiftUI
import PencilKit

public enum DrawingTool: Hashable, CaseIterable {
    case pen(color: Color, width: CGFloat)
    case pencil(color: Color, width: CGFloat)
    case marker(color: Color, width: CGFloat)
    case crayon(color: Color, width: CGFloat)
    case watercolor(color: Color, width: CGFloat)
    case monoline(color: Color, width: CGFloat)
    case fountainPen(color: Color, width: CGFloat)
    case eraser(type: EraserType)
    case lasso
    case ruler
    
    public enum EraserType: String, CaseIterable {
        case vector
        case bitmap
        case fixedWidthBitmap
    }
    
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
            // Ruler is not a tool, but a canvas state
            return PKInkingTool(.pen, color: .black, width: 5)
        }
    }
    
    public static var allCases: [DrawingTool] {
        // Return common default configurations
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

// MARK: - Convenience Initializers
public extension DrawingTool {
    static func pen(_ color: Color = .black, width: CGFloat = 5) -> DrawingTool {
        .pen(color: color, width: width)
    }
    
    static func pencil(_ color: Color = .gray, width: CGFloat = 3) -> DrawingTool {
        .pencil(color: color, width: width)
    }
    
    static func marker(_ color: Color = .yellow, width: CGFloat = 20) -> DrawingTool {
        .marker(color: color, width: width)
    }
    
    static var eraser: DrawingTool {
        .eraser(type: .vector)
    }
}