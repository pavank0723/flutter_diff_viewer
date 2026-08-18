import 'package:flutter/material.dart';

/// An immutable set of [TextStyle]s used throughout the diff viewer.
///
/// Provides distinct typographic treatments for code content, line numbers,
/// headers, diff indicators, and state labels.
///
/// Use [DiffTypography.defaults] as a starting point, then override
/// individual styles with [copyWith].
///
/// ```dart
/// final typography = DiffTypography.defaults().copyWith(
///   codeStyle: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14),
/// );
/// ```
class DiffTypography {
  /// Primary style for all monospaced diff content (line text).
  ///
  /// Should use a monospace font family to ensure code alignment.
  final TextStyle codeStyle;

  /// Style for the line-number gutter text.
  ///
  /// Typically smaller and muted relative to [codeStyle].
  final TextStyle lineNumberStyle;

  /// Style for the header bar labels (old/new version labels).
  final TextStyle headerStyle;

  /// Style for the summary statistics bar (additions/deletions count).
  final TextStyle summaryStyle;

  /// Style applied to text spans on **added** lines.
  ///
  /// Color is usually overridden at render time from [DiffViewerTheme];
  /// this controls font metrics.
  final TextStyle addedStyle;

  /// Style applied to text spans on **removed** lines.
  final TextStyle removedStyle;

  /// Style applied to text spans on **modified** lines.
  final TextStyle modifiedStyle;

  /// Style applied to text spans on **unchanged** lines.
  final TextStyle unchangedStyle;

  /// Style for the `+`, `-`, and space change-indicator characters.
  final TextStyle indicatorStyle;

  /// Style for the label inside a collapsed-section placeholder row.
  final TextStyle collapsedStyle;

  /// Creates an immutable [DiffTypography].
  ///
  /// All fields are required. Prefer [DiffTypography.defaults] and use
  /// [copyWith] to adjust individual styles.
  const DiffTypography({
    required this.codeStyle,
    required this.lineNumberStyle,
    required this.headerStyle,
    required this.summaryStyle,
    required this.addedStyle,
    required this.removedStyle,
    required this.modifiedStyle,
    required this.unchangedStyle,
    required this.indicatorStyle,
    required this.collapsedStyle,
  });

  // ---------------------------------------------------------------------------
  // Factory constructor
  // ---------------------------------------------------------------------------

  /// Returns the default typography suitable for code diffs at 13 sp.
  ///
  /// Uses the platform's default monospace font family. For a custom font,
  /// start with this factory and apply [copyWith].
  factory DiffTypography.defaults() => const DiffTypography(
        codeStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
          letterSpacing: 0,
        ),
        lineNumberStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Color(0xFF8C959F),
        ),
        headerStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        summaryStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        addedStyle:
            TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.5),
        removedStyle:
            TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.5),
        modifiedStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
        ),
        unchangedStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
        ),
        indicatorStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        collapsedStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      );

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  /// Returns a copy of this typography with the given styles replaced.
  DiffTypography copyWith({
    TextStyle? codeStyle,
    TextStyle? lineNumberStyle,
    TextStyle? headerStyle,
    TextStyle? summaryStyle,
    TextStyle? addedStyle,
    TextStyle? removedStyle,
    TextStyle? modifiedStyle,
    TextStyle? unchangedStyle,
    TextStyle? indicatorStyle,
    TextStyle? collapsedStyle,
  }) {
    return DiffTypography(
      codeStyle: codeStyle ?? this.codeStyle,
      lineNumberStyle: lineNumberStyle ?? this.lineNumberStyle,
      headerStyle: headerStyle ?? this.headerStyle,
      summaryStyle: summaryStyle ?? this.summaryStyle,
      addedStyle: addedStyle ?? this.addedStyle,
      removedStyle: removedStyle ?? this.removedStyle,
      modifiedStyle: modifiedStyle ?? this.modifiedStyle,
      unchangedStyle: unchangedStyle ?? this.unchangedStyle,
      indicatorStyle: indicatorStyle ?? this.indicatorStyle,
      collapsedStyle: collapsedStyle ?? this.collapsedStyle,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality & hashing
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffTypography &&
          runtimeType == other.runtimeType &&
          codeStyle == other.codeStyle &&
          lineNumberStyle == other.lineNumberStyle &&
          headerStyle == other.headerStyle &&
          summaryStyle == other.summaryStyle &&
          addedStyle == other.addedStyle &&
          removedStyle == other.removedStyle &&
          modifiedStyle == other.modifiedStyle &&
          unchangedStyle == other.unchangedStyle &&
          indicatorStyle == other.indicatorStyle &&
          collapsedStyle == other.collapsedStyle;

  @override
  int get hashCode => Object.hash(
        codeStyle,
        lineNumberStyle,
        headerStyle,
        summaryStyle,
        addedStyle,
        removedStyle,
        modifiedStyle,
        unchangedStyle,
        indicatorStyle,
        collapsedStyle,
      );

  @override
  String toString() => 'DiffTypography('
      'codeStyle: $codeStyle, '
      'lineNumberStyle: $lineNumberStyle, '
      'headerStyle: $headerStyle)';
}
