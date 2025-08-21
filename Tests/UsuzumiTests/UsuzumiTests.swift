import Testing
import SwiftUI
@testable import Usuzumi

@Suite("Usuzumi Package Tests")
struct UsuzumiTests {
    
    @Test("All public types are accessible")
    @MainActor
    func testPublicAPIs() {
        // Test that types exist and can be instantiated or used
        let _: Usuzumi.Canvas.Type = Usuzumi.Canvas.self
        let _: Usuzumi.CanvasView.Type = Usuzumi.CanvasView.self
        let _: Usuzumi.CanvasConfiguration.Type = Usuzumi.CanvasConfiguration.self
        
        // Test that we can create instances
        let canvas = Usuzumi.Canvas()
        let config = Usuzumi.CanvasConfiguration.default
        let coordinator = Usuzumi.CanvasCoordinator(delegate: nil)
        
        #expect(canvas is Usuzumi.Canvas)
        #expect(config is Usuzumi.CanvasConfiguration)
        #expect(coordinator is Usuzumi.CanvasCoordinator)
    }
}
