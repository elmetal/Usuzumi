import Testing
import SwiftUI
import PencilKit
@testable import Eginu

@Suite("CanvasBoard.Configuration Tests")
struct CanvasConfigurationTests {

    @Test("Configuration initializes with default values")
    func testDefaultInitialization() {
        let config = CanvasBoard.Configuration()

        #expect(config.defaultTool is PKInkingTool)
        #expect(config.minimumZoomScale == 0.5)
        #expect(config.maximumZoomScale == 5.0)
        #expect(config.isScrollEnabled == true)
        #expect(config.isOpaque == true)
        #expect(config.drawingPolicy == .anyInput)
    }

    @Test("Configuration custom initialization")
    func testCustomInitialization() {
        let customTool = PKInkingTool(.pencil, color: .blue, width: 10)
        let config = CanvasBoard.Configuration(
            defaultTool: customTool,
            minimumZoomScale: 0.2,
            maximumZoomScale: 10.0,
            isScrollEnabled: false,
            isOpaque: false,
            drawingPolicy: .pencilOnly
        )

        #expect(type(of: config.defaultTool) == type(of: customTool))
        #expect(config.minimumZoomScale == 0.2)
        #expect(config.maximumZoomScale == 10.0)
        #expect(config.isScrollEnabled == false)
        #expect(config.isOpaque == false)
        #expect(config.drawingPolicy == .pencilOnly)
    }

    @Test("Configuration static default property")
    func testStaticDefault() {
        let config = CanvasBoard.Configuration.default

        #expect(config.isScrollEnabled == true)
    }
}
