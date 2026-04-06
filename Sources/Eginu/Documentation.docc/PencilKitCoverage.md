# PencilKit API Coverage

A summary of which PencilKit APIs are covered by Eginu and which are not yet supported.

## PKCanvasView

| Property / Method | Status | Eginu API |
|---|---|---|
| `drawing` | ✓ | ``CanvasBoard/drawingData`` |
| `tool` | ✓ | ``CanvasBoard/setTool(_:)``, ``CanvasBoard/currentTool`` |
| `isRulerActive` | ✓ | `CanvasView.rulerActive(_:)` |
| `backgroundColor` | ✓ | `CanvasView.backgroundColor(_:)` |
| `drawingPolicy` | ✓ | ``CanvasBoard/Configuration/drawingPolicy`` |
| `minimumZoomScale` | ✓ | ``CanvasBoard/Configuration/minimumZoomScale`` |
| `maximumZoomScale` | ✓ | ``CanvasBoard/Configuration/maximumZoomScale`` |
| `isScrollEnabled` | ✓ | ``CanvasBoard/Configuration/isScrollEnabled`` |
| `isOpaque` | ✓ | ``CanvasBoard/Configuration/isOpaque`` |
| `undoManager` | ✓ | ``CanvasBoard/undo()``, ``CanvasBoard/redo()``, ``CanvasBoard/canUndo``, ``CanvasBoard/canRedo`` |
| `isDrawingEnabled` (iOS 18) | ✓ | `CanvasView.drawingEnabled(_:)` |
| `drawingGestureRecognizer` | — | — |
| `maximumSupportedContentVersion` (iOS 17) | ✓ | ``CanvasBoard/Configuration/maximumSupportedContentVersion`` |

## PKCanvasViewDelegate

| Method | Status | Eginu API |
|---|---|---|
| `canvasViewDrawingDidChange(_:)` | ✓ | `CanvasView.onDrawingChange(_:)` |
| `canvasViewDidBeginUsingTool(_:)` | ✓ | ``CanvasBoard/isDrawing`` |
| `canvasViewDidEndUsingTool(_:)` | ✓ | ``CanvasBoard/isDrawing`` |
| `canvasViewDidZoom(_:)` | ✓ | `CanvasView.onZoom(_:)` |
| `canvasViewDidScroll(_:)` | ✓ | `CanvasView.onScroll(_:)` |
| `canvasViewDidFinishRendering(_:)` | ✓ | `CanvasView.onFinishRendering(_:)` |
| `canvasViewDidRefineStrokes(_:strokes:newStrokes:)` (iOS 18.1) | — | — |

## PKDrawing

| Property / Method | Status | Eginu API |
|---|---|---|
| `init(data:)` / `dataRepresentation()` | ✓ | ``CanvasBoard/drawingData`` |
| `image(from:scale:)` | ✓ | ``CanvasBoard/exportImage(scale:)`` |
| `strokes` (iOS 14) | ✓ | ``CanvasBoard/strokes`` |
| `init(strokes:)` (iOS 14) | ✓ | ``CanvasBoard/setDrawing(strokes:)`` |
| `transformed(using:)` | ✓ | ``CanvasBoard/transformDrawing(using:)`` |
| `appending(_:)` | ✓ | ``CanvasBoard/appendDrawing(_:)``, ``CanvasBoard/appendStrokes(_:)`` |
| `bounds` | ✓ | ``CanvasBoard/drawingBounds`` |
| `requiredContentVersion` (iOS 17) | ✓ | ``CanvasBoard/requiredContentVersion`` |

## PKToolPicker

| Property / Method | Status | Eginu API |
|---|---|---|
| `setVisible(_:forFirstResponder:)` | ✓ | `CanvasView.toolPickerVisible(_:)` |
| `selectedTool` | ✓ | ``CanvasBoard/currentTool`` (auto-sync) |
| `isRulerActive` | ✓ | Auto-sync with `CanvasView.rulerActive(_:)` |
| `showsDrawingPolicyControls` | ✓ | `CanvasView.showsDrawingPolicyControls(_:)` |
| `stateAutosaveName` | ✓ | `CanvasView.toolPickerAutosaveName(_:)` |
| `colorUserInterfaceStyle` | ✓ | `CanvasView.toolPickerColorUserInterfaceStyle(_:)` |
| `overrideUserInterfaceStyle` | ✓ | `CanvasView.toolPickerOverrideUserInterfaceStyle(_:)` |
| `init(toolItems:)` (iOS 18) | — | — |
| `selectedToolItem` (iOS 18) | — | — |
| `toolItems` (iOS 18) | — | — |
| `accessoryItem` (iOS 18) | — | — |

## PKToolPickerObserver

| Method | Status | Eginu API |
|---|---|---|
| `toolPickerSelectedToolDidChange(_:)` | ✓ | ``CanvasBoard/currentTool`` (auto-sync) |
| `toolPickerIsRulerActiveDidChange(_:)` | ✓ | Auto-sync with `CanvasView.rulerActive(_:)` |
| `toolPickerVisibilityDidChange(_:)` | ✓ | `CanvasView.onToolPickerVisibilityChange(_:)` |
| `toolPickerFramesObscuredDidChange(_:)` | ✓ | `CanvasView.onToolPickerFramesObscuredChange(_:)` |
| `toolPickerSelectedToolItemDidChange(_:)` (iOS 18) | — | — |

## Tool Types

### PKInkingTool

| Property / Method | Status | Eginu API |
|---|---|---|
| Ink types: pen, pencil, marker, crayon, watercolor, monoline, fountainPen | ✓ | ``CanvasBoard/Tool`` |
| `color` / `width` | ✓ | Associated values on each ``CanvasBoard/Tool`` case |
| `defaultWidth(for:)` / `minimumWidth(for:)` / `maximumWidth(for:)` | — | — |
| `convertColor(_:from:to:)` | — | — |

### PKEraserTool

| Property / Method | Status | Eginu API |
|---|---|---|
| `eraserType` (vector, bitmap, fixedWidthBitmap) | ✓ | ``CanvasBoard/Tool/EraserType`` |
| `width` (iOS 16.4) | ✓ | ``CanvasBoard/Tool/eraser(type:width:)`` |

### PKLassoTool

| Property / Method | Status | Eginu API |
|---|---|---|
| Lasso selection | ✓ | ``CanvasBoard/Tool/lasso`` |

## PKStroke / PKStrokePath / PKStrokePoint

| API | Status |
|---|---|
| `PKStroke` properties (`ink`, `path`, `transform`, `mask`, `renderBounds`) | — |
| `PKStrokePath` methods (`interpolatedLocation`, `interpolatedPoint`, `enumerateInterpolatedPoints`) | — |
| `PKStrokePoint` properties (`location`, `force`, `azimuth`, `altitude`, `opacity`) | — |

## Other

| API | Status |
|---|---|
| `PKToolPickerCustomItem` / `PKToolPickerCustomItemConfiguration` (iOS 18) | — |
| `UICanvasFeedbackGenerator` (iOS 18) | — |
