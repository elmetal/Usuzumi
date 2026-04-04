import Testing
import SwiftUI
@testable import Eginu

@Suite("Eginu Package Tests")
struct EginuTests {

    @Test("All public types are accessible")
    @MainActor
    func testPublicAPIs() {
        // Test that types exist and can be instantiated or used
        let _: Eginu.CanvasBoard.Type = Eginu.CanvasBoard.self
        let _: Eginu.CanvasView.Type = Eginu.CanvasView.self
        let _: Eginu.CanvasBoard.Configuration.Type = Eginu.CanvasBoard.Configuration.self

        // Test that we can create instances
        let canvas = Eginu.CanvasBoard()
        let config = Eginu.CanvasBoard.Configuration.default
        let coordinator = Eginu.CanvasView.Coordinator()

        #expect(canvas is Eginu.CanvasBoard)
        #expect(config is Eginu.CanvasBoard.Configuration)
        #expect(coordinator is Eginu.CanvasView.Coordinator)
    }
}
