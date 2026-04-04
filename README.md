# Eginu

Eginu (絵絹) — A SwiftUI wrapper for PencilKit

## Usage

```swift
import Eginu

struct DrawingView: View {
    @State private var canvas = CanvasBoard()

    var body: some View {
        CanvasView(canvas)
            .toolPickerVisible(true)
            .onDrawingChange { canvas in
                let data = canvas.drawingData // save
            }
    }
}
```

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/elmetal/SwiftEginu.git", from: "0.1.0")
]
```

Requires iOS / macCatalyst 18+, Swift 6.1+.

## Documentation

[DocC](https://elmetal.github.io/SwiftEginu/documentation/eginu/)

## License

[MIT](LICENSE)
