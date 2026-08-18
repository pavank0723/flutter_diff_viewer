/// Internal constants used by the flutter_diff_viewer package.
///
/// These are NOT part of the public API and may change without notice.
abstract final class DiffConstants {
  DiffConstants._();

  /// The default number of unchanged context lines to show around each change.
  static const int defaultContextLines = 3;

  /// Minimum number of lines to collapse (below this, don't collapse).
  static const int minimumCollapsibleLines = 5;

  /// The threshold (in lines) above which `compute()` isolate processing
  /// is used automatically when [DiffComparisonOptions.useIsolate] is true.
  static const int isolateThreshold = 1000;

  /// The width (in characters) above which auto-granularity falls back
  /// from word-level to line-level diff to maintain performance.
  static const int longLineThreshold = 500;

  /// Label used for added lines in unified view.
  static const String addedIndicator = '+';

  /// Label used for removed lines in unified view.
  static const String removedIndicator = '-';

  /// Label used for unchanged lines in unified view.
  static const String unchangedIndicator = ' ';

  /// Label used for modified lines in unified view.
  static const String modifiedIndicator = '~';
}
