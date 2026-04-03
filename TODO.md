# TODO

## WebKit for SwiftUI パターンへの整合

`WebView` + `WebPage` + `WebPage.Configuration` の設計パターンを
PencilKit の UIViewRepresentable 実装で再現するための改善項目。

---

### 1. `@Observable` への移行

- [x] `CanvasBoard` を `ObservableObject` (`@Published`) から `@Observable` マクロに移行
- [x] 利用側の `@StateObject` / `@ObservedObject` を `@State` / `@Bindable` に置き換え
  - `WebPage` は `@Observable` な `final class`

### 2. Configuration をネスト型にし、State 側に所有させる

- [x] `CanvasConfiguration` → `CanvasBoard.Configuration` に移動
- [x] `CanvasBoard(configuration:)` で受け取り、init 時に確定させる
  - 現状: `CanvasView` の引数として渡しており、State 側が Configuration を所有していない
  - 目標: `CanvasBoard(configuration:)` → `CanvasView(canvas)` の流れ
- [x] Configuration のプロパティを `let`（イミュータブル）にする
  - `WebPage.Configuration` は値型で、init 後は変更しない設計

### 3. CanvasView のイニシャライザ整理

- [ ] 簡易イニシャライザ `CanvasView()` を追加（内部で CanvasBoard を自動生成）
  - `WebView(url:)` 相当の、State オブジェクト不要な簡易 API
- [ ] フルコントロール用 `CanvasView(_ canvas: CanvasBoard)` を用意
  - `WebView(_ page: WebPage)` と同じパターン
  - `configuration` 引数は削除（CanvasBoard が所有するため）

### 4. View Modifier の再設計

- [ ] struct コピーではなく SwiftUI `Environment` / `Preference` 経由の伝搬に変更
  - 現状: `var view = self; view.configuration.xxx = yyy` で struct を書き換えている
  - 目標: `.webViewBackForwardNavigationGestures(_:)` 等と同様の仕組み
- [ ] modifier 名に `canvas` プレフィックスを付ける（名前空間の衝突回避）
  - 例: `.canvasToolPickerVisible(_:)`, `.canvasRulerActive(_:)`, `.canvasScrollEnabled(_:)`
- [ ] Configuration で確定すべき設定（init 時）と動的に変更可能な設定を分離
  - Configuration: `drawingPolicy`, `isOpaque`, `defaultTool`, zoom range
  - 動的設定（Environment）: `toolPickerVisible`, `rulerActive`, `backgroundColor`

### 5. Delegate パターンの刷新

- [ ] `CanvasDelegate` プロトコルを廃止し、クロージャ / AsyncSequence ベースに移行
  - `WebPage` は delegate を使わず、AsyncSequence でイベントを返す
- [ ] 描画イベントを `AsyncSequence` で提供
  - 例: `for await event in canvas.drawingEvents { ... }`
- [ ] または SwiftUI 的なコールバック modifier にする
  - 例: `.onCanvasDrawingChange { ... }`, `.onCanvasZoom { ... }`

### 6. CanvasBoard 内部実装の隠蔽

- [ ] `canvasView: PKCanvasView?` / `toolPicker: PKToolPicker?` を `private` にする
  - `WebPage` は内部の `WKWebView` を公開していない
- [ ] `updateUndoRedoState()`, `setDrawingState(_:)`, `setupCanvasView(_:)` を隠蔽

### 7. 1:1 バインディングの保証

- [ ] `CanvasBoard` が複数の `CanvasView` に同時バインドされないよう制約する
  - `WebPage` は同時に1つの `WebView` のみバインド可能

### 8. Combine 依存の除去

- [ ] `import Combine` / `cancellables` を削除（`@Observable` 移行で不要に）

### 9. エクスポート API の改善

- [ ] `exportAsImage()` / `exportAsPDF()` を統一的な `export(.image)` / `export(.pdf)` API に
  - `WebPage.exported(as:)` パターンに準拠
- [ ] `UIScreen.main.scale` の直接参照を除去（deprecated）

### 10. 型の整理・ネスト化

- [ ] `DrawingTool` → `CanvasBoard.Tool` にネスト
- [ ] `CanvasCoordinator` → `CanvasView.Coordinator` にネスト（UIViewRepresentable 慣習）
- [ ] `CanvasGestureModifier` を `internal` にし、public API から隠す

---

## 目標とする API の姿

```swift
// 簡易利用
struct SimpleView: View {
    var body: some View {
        CanvasView()
            .canvasToolPickerVisible(true)
    }
}

// フルコントロール
struct AdvancedView: View {
    @State private var canvas = CanvasBoard(
        configuration: .init(
            drawingPolicy: .pencilOnly,
            defaultTool: .pen(color: .blue, width: 3)
        )
    )

    var body: some View {
        CanvasView(canvas)
            .canvasToolPickerVisible(true)
            .canvasRulerActive(false)
            .onCanvasDrawingChange { canvas in
                autosave(canvas.drawingData)
            }

        if canvas.isDrawing {
            Text("Drawing...")
        }

        Button("Undo") { canvas.undo() }
            .disabled(!canvas.canUndo)
    }
}
```

---

## Advanced Features
- [ ] Implement annotation features
- [ ] Add shape recognition

## Documentation
- [x] Write API documentation (DocC-style documentation added)
- [ ] Create README with quick start guide
