import Testing
import SwiftUI
import PencilKit
@testable import Usuzumi

@Suite("CanvasView Tests")
@MainActor
struct CanvasViewTests {
    
    @Test("CanvasView initialization with default configuration")
    func testDefaultInitialization() {
        let canvas = Canvas()
        let canvasView = CanvasView(canvas: canvas)
        
        #expect(canvasView.canvas === canvas)
        #expect(canvasView.configuration.backgroundColor == .systemBackground)
    }
    
    @Test("CanvasView initialization with custom configuration")
    func testCustomConfiguration() {
        let canvas = Canvas()
        let config = CanvasConfiguration(
            backgroundColor: .systemGray,
            isRulerActive: true,
            allowsFingerDrawing: false
        )
        let canvasView = CanvasView(canvas: canvas, configuration: config)
        
        #expect(canvasView.configuration.backgroundColor == .systemGray)
        #expect(canvasView.configuration.isRulerActive == true)
        #expect(canvasView.configuration.allowsFingerDrawing == false)
    }
    
    @Test("CanvasView modifiers")
    func testViewModifiers() {
        let canvas = Canvas()
        let baseView = CanvasView(canvas: canvas)
        
        let modifiedView = baseView
            .toolPickerVisible(true)
            .rulerActive(true)
            .allowsFingerDrawing(false)
            .backgroundColor(.systemGray2)
            .scrollEnabled(false)
            .zoomScale(min: 0.1, max: 20.0)
        
        #expect(modifiedView.configuration.isRulerActive == true)
        #expect(modifiedView.configuration.drawingPolicy == .pencilOnly)
        #expect(modifiedView.configuration.backgroundColor == .systemGray2)
        #expect(modifiedView.configuration.isScrollEnabled == false)
        #expect(modifiedView.configuration.minimumZoomScale == 0.1)
        #expect(modifiedView.configuration.maximumZoomScale == 20.0)
    }
    
    @Test("CanvasView delegate modifier")
    func testDelegateModifier() {
        class TestDelegate: CanvasDelegate {}
        let delegate = TestDelegate()
        let canvas = Canvas()
        let baseView = CanvasView(canvas: canvas)
        
        let viewWithDelegate = baseView.canvasDelegate(delegate)
        
        #expect(viewWithDelegate.delegate === delegate)
    }
    
    @Test("CanvasView makeCoordinator creates coordinator")
    func testMakeCoordinator() {
        let canvas = Canvas()
        let canvasView = CanvasView(canvas: canvas)
        
        let coordinator = canvasView.makeCoordinator()
        
        #expect(coordinator is CanvasCoordinator)
    }
}