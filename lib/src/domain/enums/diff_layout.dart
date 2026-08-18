/// Controls the visual layout of the diff viewer.
///
/// Different layouts are suited for different screen sizes and use cases.
enum DiffLayout {
  /// Side-by-side layout showing old content on the left and new content
  /// on the right. Best suited for wide screens (desktop, large tablets).
  ///
  /// ```
  /// ┌──────────────┬──────────────┐
  /// │ Old Content  │ New Content  │
  /// └──────────────┴──────────────┘
  /// ```
  sideBySide,

  /// Unified layout showing all changes in a single column with +/- indicators.
  /// Similar to `git diff` output. Works on any screen width.
  ///
  /// ```
  /// - Removed line
  /// + Added line
  ///   Unchanged line
  /// ```
  unified,

  /// Stacked layout showing old content above new content. Useful for mobile
  /// or narrow screens where side-by-side is not practical.
  ///
  /// ```
  /// ┌──────────────────────────┐
  /// │ Old Content              │
  /// ├──────────────────────────┤
  /// │ New Content              │
  /// └──────────────────────────┘
  /// ```
  stacked,

  /// Automatically selects the most appropriate layout based on available
  /// screen width. Uses [DiffLayout.sideBySide] on wide screens and
  /// [DiffLayout.unified] on narrow screens.
  auto,
}
