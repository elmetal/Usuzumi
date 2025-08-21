import SwiftUI
import PencilKit

struct ContentView: View {
    @StateObject private var canvas = CanvasBoard()
    
    var body: some View {
        NavigationView {
            CanvasView(canvas: canvas)
                .toolPickerVisible(true)
                .rulerActive(false)
                .allowsFingerDrawing(true)
                .backgroundColor(.systemBackground)
                .navigationTitle("Sketch")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Clear") {
                            canvas.clear()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button(action: { canvas.undo() }) {
                                Image(systemName: "arrow.uturn.backward")
                            }
                            .disabled(!canvas.canUndo)
                            
                            Button(action: { canvas.redo() }) {
                                Image(systemName: "arrow.uturn.forward")
                            }
                            .disabled(!canvas.canRedo)
                            
                            Button(action: { 
                                if let image = canvas.exportAsImage() {
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                }
                            }) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.colorScheme, .light)
}
