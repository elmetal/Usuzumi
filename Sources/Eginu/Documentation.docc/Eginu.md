# ``Eginu``

A modern SwiftUI wrapper for PencilKit and PaperKit that simplifies drawing and markup in iOS applications.

## Overview

Eginu provides a clean, SwiftUI-native interface to Apple's PencilKit and PaperKit frameworks, making it easy to add drawing and markup capabilities to your iOS apps. The API follows the same pattern as WebKit for SwiftUI: a View paired with a State object.

## Getting Started

To use Eginu in your project, first import the framework:

```swift
import Eginu
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

### PaperKit (iOS 26+)
- ``MarkupView``
- ``MarkupBoard``

### PencilKit Compatibility
- <doc:PencilKitCoverage>
