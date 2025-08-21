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
- [ ] Define DrawingTool enum
- [ ] Integrate PKToolPicker
- [ ] Implement tool selection sync

## Data Management
- [ ] Implement drawing import/export
- [ ] Add undo/redo functionality
- [ ] Support image/PDF export

## Advanced Features
- [ ] Add gesture recognition support
- [ ] Implement annotation features
- [ ] Add shape recognition

## Testing
- [ ] Write unit tests for CanvasBoard state
- [ ] Write integration tests for SwiftUI
- [ ] Add example app

## Documentation
- [ ] Write API documentation
- [ ] Add usage examples
- [ ] Create README with quick start guide