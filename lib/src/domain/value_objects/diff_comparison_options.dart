import '../enums/diff_granularity.dart';

/// Immutable value object encapsulating all options that control how
/// a diff comparison is performed.
///
/// Pass this to [DiffRepository.compare] or via [FlutterDiffViewerConfiguration].
///
/// ```dart
/// const options = DiffComparisonOptions(
///   granularity: DiffGranularity.word,
///   ignoreWhitespace: true,
///   contextLines: 3,
/// );
/// ```
class DiffComparisonOptions {
  /// The granularity level for intra-line diff highlighting.
  ///
  /// Defaults to [DiffGranularity.word].
  final DiffGranularity granularity;

  /// Whether to ignore leading and trailing whitespace when comparing lines.
  ///
  /// Defaults to `false`.
  final bool ignoreWhitespace;

  /// Whether the comparison is case-sensitive.
  ///
  /// Defaults to `true` (case-sensitive).
  final bool caseSensitive;

  /// The number of unchanged context lines to include around each change block.
  ///
  /// Used when [FlutterDiffViewerConfiguration.collapseUnchangedLines] is `true`.
  /// Must be >= 0. Defaults to `3`.
  final int contextLines;

  /// Whether to process the diff asynchronously using an isolate.
  ///
  /// Set to `true` for large documents (typically >1000 lines).
  /// Defaults to `false`.
  final bool useIsolate;

  /// Creates an immutable set of diff comparison options.
  ///
  /// All parameters have sensible defaults; only override what you need.
  const DiffComparisonOptions({
    this.granularity = DiffGranularity.word,
    this.ignoreWhitespace = false,
    this.caseSensitive = true,
    this.contextLines = 3,
    this.useIsolate = false,
  }) : assert(contextLines >= 0, 'contextLines must be >= 0');

  /// Creates a copy of this options object with the specified fields replaced.
  DiffComparisonOptions copyWith({
    DiffGranularity? granularity,
    bool? ignoreWhitespace,
    bool? caseSensitive,
    int? contextLines,
    bool? useIsolate,
  }) {
    return DiffComparisonOptions(
      granularity: granularity ?? this.granularity,
      ignoreWhitespace: ignoreWhitespace ?? this.ignoreWhitespace,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      contextLines: contextLines ?? this.contextLines,
      useIsolate: useIsolate ?? this.useIsolate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffComparisonOptions &&
          runtimeType == other.runtimeType &&
          granularity == other.granularity &&
          ignoreWhitespace == other.ignoreWhitespace &&
          caseSensitive == other.caseSensitive &&
          contextLines == other.contextLines &&
          useIsolate == other.useIsolate;

  @override
  int get hashCode => Object.hash(
        granularity,
        ignoreWhitespace,
        caseSensitive,
        contextLines,
        useIsolate,
      );

  @override
  String toString() => 'DiffComparisonOptions('
      'granularity: $granularity, '
      'ignoreWhitespace: $ignoreWhitespace, '
      'caseSensitive: $caseSensitive, '
      'contextLines: $contextLines, '
      'useIsolate: $useIsolate)';
}
