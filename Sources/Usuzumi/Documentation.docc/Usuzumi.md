# ``Usuzumi``

A modern SwiftUI wrapper for PencilKit that simplifies drawing and sketching in iOS applications.

## Overview

Usuzumi provides a clean, SwiftUI-native interface to Apple's PencilKit framework, making it easy to add drawing capabilities to your iOS apps. Whether you're building a note-taking app, a digital whiteboard, or a creative drawing application, Usuzumi offers the tools you need.

### Key Features

- **SwiftUI Integration**: Seamlessly integrate drawing capabilities into your SwiftUI views
- **Tool Management**: Easy-to-use drawing tools including pens, pencils, markers, and erasers
- **State Management**: Observable canvas state with undo/redo support
- **Export Options**: Export drawings as images or PDF documents
- **Gesture Support**: Built-in support for zoom, pan, and other gestures
- **Customizable**: Configure appearance and behavior to match your app's needs

## Getting Started

To use Usuzumi in your project, first import the framework:

```swift
import Usuzumi
```

Then create a canvas view with a canvas board:

```swift
struct DrawingView: View {
    @StateObject private var canvas = CanvasBoard()
    
    var body: some View {
        CanvasView(canvas: canvas)
            .toolPickerVisible(true)
            .allowsFingerDrawing(true)
    }
}
```

## Topics

### Essentials

- ``CanvasView``
- ``CanvasBoard``
- ``CanvasConfiguration``

### Drawing Tools

- ``DrawingTool``

### Customization

- ``CanvasDelegate``
- ``CanvasGestureModifier``

### Advanced

- ``CanvasCoordinator``