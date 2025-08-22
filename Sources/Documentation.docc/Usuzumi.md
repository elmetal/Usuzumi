# ``Usuzumi``

A modern SwiftUI wrapper for PencilKit that simplifies drawing and sketching in iOS applications.

## Overview

Usuzumi provides a clean, SwiftUI-native interface to Apple's PencilKit framework, making it easy to add drawing capabilities to your iOS apps. Whether you're building a note-taking app, a digital whiteboard, or a creative drawing application, Usuzumi offers the tools you need.

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
