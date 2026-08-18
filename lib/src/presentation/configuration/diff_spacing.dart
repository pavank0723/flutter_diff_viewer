/// An immutable set of spacing and sizing constants for the diff viewer.
///
/// Controls dimensions of gutter columns, row heights, paddings, border
/// metrics, and fixed-height sections.
///
/// Use [DiffSpacing.defaults] as a starting point and override with
/// [copyWith] for custom layouts.
///
/// ```dart
/// final spacing = DiffSpacing.defaults().copyWith(
///   lineNumberWidth: 64.0,
///   horizontalPadding: 12.0,
///   dividerWidth: 2.0,
/// );
/// ```
class DiffSpacing {
  /// The visual height of a single diff row in logical pixels.
  final double lineHeight;

  /// The width of the line-number gutter column in logical pixels.
  final double lineNumberWidth;

  /// The width of the change-indicator (`+`/`-`/space) column in logical pixels.
  final double indicatorWidth;

  /// Horizontal padding applied inside each diff cell.
  final double horizontalPadding;

  /// Vertical padding applied inside each diff row.
  final double verticalPadding;

  /// Width of borders drawn around or within the diff viewer.
  final double borderWidth;

  /// Width of central vertical divider separating original and modified content panels.
  final double dividerWidth;

  /// Corner radius of the diff viewer's outer container.
  final double borderRadius;

  /// Fixed height of the header bar (old/new label row).
  final double headerHeight;

  /// Fixed height of the summary statistics bar.
  final double summaryHeight;

  /// Creates an immutable [DiffSpacing].
  ///
  /// All values must be non-negative. Prefer [DiffSpacing.defaults] and
  /// use [copyWith] to adjust individual values.
  const DiffSpacing({
    required this.lineHeight,
    required this.lineNumberWidth,
    required this.indicatorWidth,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderWidth,
    required this.borderRadius,
    required this.headerHeight,
    required this.summaryHeight,
    this.dividerWidth = 1.0,
  })  : assert(lineHeight > 0, 'lineHeight must be > 0'),
        assert(lineNumberWidth >= 0, 'lineNumberWidth must be >= 0'),
        assert(indicatorWidth >= 0, 'indicatorWidth must be >= 0'),
        assert(horizontalPadding >= 0, 'horizontalPadding must be >= 0'),
        assert(verticalPadding >= 0, 'verticalPadding must be >= 0'),
        assert(borderWidth >= 0, 'borderWidth must be >= 0'),
        assert(dividerWidth >= 0, 'dividerWidth must be >= 0'),
        assert(borderRadius >= 0, 'borderRadius must be >= 0'),
        assert(headerHeight >= 0, 'headerHeight must be >= 0'),
        assert(summaryHeight >= 0, 'summaryHeight must be >= 0');

  // ---------------------------------------------------------------------------
  // Named constants (avoid magic numbers at call sites)
  // ---------------------------------------------------------------------------

  /// Default height for a single diff row (22 dp).
  static const double defaultLineHeight = 22.0;

  /// Default width of the line-number gutter (52 dp).
  static const double defaultLineNumberWidth = 52.0;

  /// Default width of the indicator column (20 dp).
  static const double defaultIndicatorWidth = 20.0;

  /// Default horizontal padding inside a diff cell (8 dp).
  static const double defaultHorizontalPadding = 8.0;

  /// Default vertical padding inside a diff row (2 dp).
  static const double defaultVerticalPadding = 2.0;

  /// Default border width (1 dp).
  static const double defaultBorderWidth = 1.0;

  /// Default divider width (1 dp).
  static const double defaultDividerWidth = 1.0;

  /// Default corner radius for the outer container (6 dp).
  static const double defaultBorderRadius = 6.0;

  /// Default height of the header bar (40 dp).
  static const double defaultHeaderHeight = 40.0;

  /// Default height of the summary bar (32 dp).
  static const double defaultSummaryHeight = 32.0;

  // ---------------------------------------------------------------------------
  // Factory constructor
  // ---------------------------------------------------------------------------

  /// Returns the default spacing configuration.
  const factory DiffSpacing.defaults() = _DefaultDiffSpacing;

  // ---------------------------------------------------------------------------
  // Derived helpers
  // ---------------------------------------------------------------------------

  /// The combined width of the line-number gutter and indicator column.
  ///
  /// Useful when calculating the available width for code content.
  double get gutterWidth => lineNumberWidth + indicatorWidth;

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  /// Returns a copy of this spacing with the given values replaced.
  DiffSpacing copyWith({
    double? lineHeight,
    double? lineNumberWidth,
    double? indicatorWidth,
    double? horizontalPadding,
    double? verticalPadding,
    double? borderWidth,
    double? dividerWidth,
    double? borderRadius,
    double? headerHeight,
    double? summaryHeight,
  }) {
    return DiffSpacing(
      lineHeight: lineHeight ?? this.lineHeight,
      lineNumberWidth: lineNumberWidth ?? this.lineNumberWidth,
      indicatorWidth: indicatorWidth ?? this.indicatorWidth,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      borderWidth: borderWidth ?? this.borderWidth,
      dividerWidth: dividerWidth ?? this.dividerWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      headerHeight: headerHeight ?? this.headerHeight,
      summaryHeight: summaryHeight ?? this.summaryHeight,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality & hashing
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffSpacing &&
          runtimeType == other.runtimeType &&
          lineHeight == other.lineHeight &&
          lineNumberWidth == other.lineNumberWidth &&
          indicatorWidth == other.indicatorWidth &&
          horizontalPadding == other.horizontalPadding &&
          verticalPadding == other.verticalPadding &&
          borderWidth == other.borderWidth &&
          dividerWidth == other.dividerWidth &&
          borderRadius == other.borderRadius &&
          headerHeight == other.headerHeight &&
          summaryHeight == other.summaryHeight;

  @override
  int get hashCode => Object.hash(
        lineHeight,
        lineNumberWidth,
        indicatorWidth,
        horizontalPadding,
        verticalPadding,
        borderWidth,
        dividerWidth,
        borderRadius,
        headerHeight,
        summaryHeight,
      );

  @override
  String toString() => 'DiffSpacing('
      'lineHeight: $lineHeight, '
      'lineNumberWidth: $lineNumberWidth, '
      'indicatorWidth: $indicatorWidth, '
      'dividerWidth: $dividerWidth, '
      'horizontalPadding: $horizontalPadding, '
      'borderRadius: $borderRadius)';
}

/// Private const implementation used by [DiffSpacing.defaults].
class _DefaultDiffSpacing extends DiffSpacing {
  const _DefaultDiffSpacing()
      : super(
          lineHeight: DiffSpacing.defaultLineHeight,
          lineNumberWidth: DiffSpacing.defaultLineNumberWidth,
          indicatorWidth: DiffSpacing.defaultIndicatorWidth,
          horizontalPadding: DiffSpacing.defaultHorizontalPadding,
          verticalPadding: DiffSpacing.defaultVerticalPadding,
          borderWidth: DiffSpacing.defaultBorderWidth,
          dividerWidth: DiffSpacing.defaultDividerWidth,
          borderRadius: DiffSpacing.defaultBorderRadius,
          headerHeight: DiffSpacing.defaultHeaderHeight,
          summaryHeight: DiffSpacing.defaultSummaryHeight,
        );
}
