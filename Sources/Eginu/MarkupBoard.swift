import SwiftUI
import PencilKit
import PaperKit

/// A view model that manages the state and behavior of a PaperKit markup canvas.
///
/// ``MarkupBoard`` serves as the state manager for PaperKit-based markup operations,
/// providing a SwiftUI-compatible interface for rich markup interactions including
/// drawing, shapes, text, and images.
///
/// ## Overview
///
/// Use `MarkupBoard` to manage markup operations for your canvas-based applications.
/// It works with ``MarkupView`` to provide a complete PaperKit experience in SwiftUI.
///
/// ```swift
/// @State private var markup = MarkupBoard()
///
/// var body: some View {
///     MarkupView(markup)
///         .toolPickerVisible(true)
///         .editable(true)
/// }
/// ```
///
/// ## Topics
///
/// ### Creating a Markup Board
/// - ``init(supportedFeatureSet:)``
/// - ``init(markup:supportedFeatureSet:)``
///
/// ### Managing Markup State
/// - ``markup``
/// - ``isDrawing``
/// - ``selectedMarkup``
///
/// ### Data Persistence
/// - ``dataRepresentation()``
/// - ``load(from:)``
///
/// ### Drawing Tools
/// - ``drawingTool``
/// - ``setDrawingTool(_:)-1xzq``
/// - ``setDrawingTool(_:)-7pnr``
///
/// ### Content
/// - ``appendDrawing(_:)``
@available(iOS 26, *)
@Observable
@MainActor
public final class MarkupBoard {
    /// A Boolean value indicating whether the user is currently drawing.
    public private(set) var isDrawing: Bool = false

    /// The currently selected markup content.
    public private(set) var selectedMarkup: PaperMarkup?

    /// The supported feature set for this markup board.
    public let supportedFeatureSet: FeatureSet

    @ObservationIgnored weak var viewController: PaperMarkupViewController?
    @ObservationIgnored private var storedMarkup: PaperMarkup?

    /// Creates a new markup board with the specified feature set.
    ///
    /// - Parameter supportedFeatureSet: The feature set to support. Defaults to `.latest`.
    public init(supportedFeatureSet: FeatureSet = .latest) {
        self.supportedFeatureSet = supportedFeatureSet
    }

    /// Creates a new markup board with existing markup data.
    ///
    /// - Parameters:
    ///   - markup: The initial markup data.
    ///   - supportedFeatureSet: The feature set to support. Defaults to `.latest`.
    public init(markup: PaperMarkup, supportedFeatureSet: FeatureSet = .latest) {
        self.supportedFeatureSet = supportedFeatureSet
        self.storedMarkup = markup
    }

    /// The current markup data.
    ///
    /// Setting this property replaces the current markup content.
    public var markup: PaperMarkup? {
        get {
            viewController?.markup ?? storedMarkup
        }
        set {
            storedMarkup = newValue
            viewController?.markup = newValue
        }
    }

    /// Returns the data representation of the current markup for persistence.
    public func dataRepresentation() async throws -> Data {
        guard let markup else {
            throw MarkupError.incorrectFormat
        }
        return try await markup.dataRepresentation()
    }

    /// Loads markup from a data representation.
    ///
    /// - Parameter data: The data to load.
    public func load(from data: Data) throws {
        let loaded = try PaperMarkup(dataRepresentation: data)
        markup = loaded
    }

    /// The current drawing tool, or `nil` if no view controller is bound.
    public var drawingTool: (any PKTool)? {
        viewController?.drawingTool
    }

    /// Sets the drawing tool using a PencilKit tool.
    ///
    /// - Parameter tool: The PencilKit tool to use.
    public func setDrawingTool(_ tool: any PKTool) {
        viewController?.drawingTool = tool
    }

    /// Sets the drawing tool using an Eginu tool.
    ///
    /// - Parameter tool: The Eginu tool to use.
    public func setDrawingTool(_ tool: CanvasBoard.Tool) {
        viewController?.drawingTool = tool.pkTool
    }

    /// Appends a PencilKit drawing to the current markup.
    ///
    /// - Parameter drawing: The PencilKit drawing to append.
    public func appendDrawing(_ drawing: PKDrawing) {
        if viewController != nil {
            viewController?.markup?.append(contentsOf: drawing)
        } else {
            storedMarkup?.append(contentsOf: drawing)
        }
    }

    /// The visible frame of the markup content.
    public var contentVisibleFrame: CGRect {
        viewController?.contentVisibleFrame ?? .zero
    }

    /// Sets the visible frame of the markup content.
    ///
    /// - Parameters:
    ///   - frame: The frame to make visible.
    ///   - animated: Whether to animate the transition.
    public func setContentVisibleFrame(_ frame: CGRect, animated: Bool = false) {
        viewController?.setContentVisibleFrame(frame, animated: animated)
    }

    // MARK: - Internal (Coordinator access)

    func bind(to viewController: PaperMarkupViewController) {
        self.viewController = viewController
        if let storedMarkup {
            viewController.markup = storedMarkup
        }
    }

    func setDrawingState(_ isDrawing: Bool) {
        self.isDrawing = isDrawing
    }

    func setSelectedMarkup(_ markup: PaperMarkup?) {
        self.selectedMarkup = markup
    }

    func syncMarkupFromViewController() {
        storedMarkup = viewController?.markup
    }
}
