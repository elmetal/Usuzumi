import Testing
import SwiftUI
@testable import Usuzumi

@Suite("Usuzumi Package Tests")
struct UsuzumiTests {
    
    @Test("All public types are accessible")
    @MainActor
    func testPublicAPIs() {
        // Test that types exist and can be instantiated or used
        let _: Usuzumi.CanvasBoard.Type = Usuzumi.CanvasBoard.self
        let _: Usuzumi.CanvasView.Type = Usuzumi.CanvasView.self
        let _: Usuzumi.CanvasConfiguration.Type = Usuzumi.CanvasConfiguration.self
        
        // Test that we can create instances
        let canvas = Usuzumi.CanvasBoard()
        let config = Usuzumi.CanvasConfiguration.default
        let coordinator = Usuzumi.CanvasCoordinator(delegate: nil)
        
        #expect(canvas is Usuzumi.CanvasBoard)
        #expect(config is Usuzumi.CanvasConfiguration)
        #expect(coordinator is Usuzumi.CanvasCoordinator)
    }
}
