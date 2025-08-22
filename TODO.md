# TODO

## Project Setup
- [x] Add iOS platform support to Package.swift (iOS 17.0+)
- [x] Import PencilKit framework

## Core Components
- [x] Create CanvasBoard class (ObservableObject for state management)
- [x] Create CanvasConfiguration class (immutable settings)
- [x] Create CanvasView (UIViewRepresentable wrapper)
- [x] Create CanvasCoordinator (UIKit-SwiftUI bridge)
- [x] Create CanvasDelegate protocol

## Drawing Tools
- [x] Define DrawingTool enum
- [x] Integrate PKToolPicker
- [x] Implement tool selection sync

## Data Management
- [x] Implement drawing import/export (via drawingData property)
- [x] Add undo/redo functionality
- [x] Support image export (via exportAsImage)
- [x] Support PDF export (via exportAsPDF)

## Advanced Features
- [x] Add gesture recognition support (via CanvasGestureModifier)
- [ ] Implement annotation features
- [ ] Add shape recognition

## Testing
- [x] Write unit tests for CanvasBoard state
- [x] Write integration tests for SwiftUI
- [x] Add example app (in Usuzumi.swift)

## Documentation
- [ ] Write API documentation
- [x] Add usage examples (in Usuzumi.swift)
- [ ] Create README with quick start guide