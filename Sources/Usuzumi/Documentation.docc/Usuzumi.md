# ``Usuzumi``

A modern SwiftUI wrapper for PencilKit that simplifies drawing and sketching in iOS applications.

## Overview

Usuzumi provides a clean, SwiftUI-native interface to Apple's PencilKit framework, making it easy to add drawing capabilities to your iOS apps. The API follows the same pattern as WebKit for SwiftUI: a `CanvasView` (View) paired with a `CanvasBoard` (State) and `CanvasBoard.Configuration`.

## Getting Started

To use Usuzumi in your project, first import the framework:

```swift
import Usuzumi
```

### Simple Usage

```swift
var body: some View {
    CanvasView()
        .toolPickerVisible(true)
}
```

### Full Control

```swift
struct DrawingView: View {
    @State private var canvas = CanvasBoard(
        configuration: .init(drawingPolicy: .pencilOnly)
    )

    var body: some View {
        CanvasView(canvas)
            .toolPickerVisible(true)
            .rulerActive(false)
            .onDrawingChange { canvas in
                // Auto-save
            }
    }
}
```

## Topics

### Core Types
- ``CanvasView``
- ``CanvasBoard``
- ``CanvasBoard/Configuration``
- ``CanvasBoard/Tool``
