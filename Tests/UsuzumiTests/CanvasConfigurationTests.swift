import Testing
import SwiftUI
import PencilKit
@testable import Usuzumi

@Suite("CanvasConfiguration Tests")
struct CanvasConfigurationTests {
    
    @Test("CanvasConfiguration initializes with default values")
    func testDefaultInitialization() {
        let config = CanvasConfiguration()
        
        #expect(config.backgroundColor == .systemBackground)
        #expect(config.isRulerActive == false)
        #expect(config.allowsFingerDrawing == true)
        #expect(config.defaultTool is PKInkingTool)
        #expect(config.minimumZoomScale == 0.5)
        #expect(config.maximumZoomScale == 5.0)
        #expect(config.isScrollEnabled == true)
        #expect(config.isOpaque == true)
        #expect(config.drawingPolicy == .anyInput)
    }
    
    @Test("CanvasConfiguration custom initialization")
    func testCustomInitialization() {
        let customTool = PKInkingTool(.pencil, color: .blue, width: 10)
        let config = CanvasConfiguration(
            backgroundColor: .systemGray,
            isRulerActive: true,
            allowsFingerDrawing: false,
            defaultTool: customTool,
            minimumZoomScale: 0.2,
            maximumZoomScale: 10.0,
            isScrollEnabled: false,
            isOpaque: false,
            drawingPolicy: .pencilOnly
        )
        
        #expect(config.backgroundColor == .systemGray)
        #expect(config.isRulerActive == true)
        #expect(config.allowsFingerDrawing == false)
        #expect(type(of: config.defaultTool) == type(of: customTool))
        #expect(config.minimumZoomScale == 0.2)
        #expect(config.maximumZoomScale == 10.0)
        #expect(config.isScrollEnabled == false)
        #expect(config.isOpaque == false)
        #expect(config.drawingPolicy == .pencilOnly)
    }
    
    @Test("CanvasConfiguration static default property")
    func testStaticDefault() {
        let config = CanvasConfiguration.default
        
        #expect(config.backgroundColor == .systemBackground)
        #expect(config.isRulerActive == false)
        #expect(config.allowsFingerDrawing == true)
    }
}