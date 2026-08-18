import '../enums/diff_type.dart';
import 'diff_line.dart';

/// An immutable entity representing the complete result of a diff comparison.
///
/// Contains all [DiffLine] entries along with summary statistics.
///
/// ```dart
/// final result = await calculateDiff(
///   oldContent: oldText,
///   newContent: newText,
/// );
///
/// print('${result.additions} additions, ${result.deletions} deletions');
/// ```
class DiffResult {
  /// The ordered list of diff lines representing the full comparison.
  ///
  /// Each entry is a [DiffLine] that describes a row in the diff view.
  final List<DiffLine> lines;

  /// The number of lines added in the new content.
  final int additions;

  /// The number of lines removed from the old content.
  final int deletions;

  /// The number of lines that were modified (exist in both but changed).
  final int modifications;

  /// The number of lines that are identical in both versions.
  final int unchanged;

  /// The total number of lines in the old content.
  final int oldLineCount;

  /// The total number of lines in the new content.
  final int newLineCount;

  /// Creates an immutable diff result.
  const DiffResult({
    required this.lines,
    required this.additions,
    required this.deletions,
    required this.modifications,
    required this.unchanged,
    required this.oldLineCount,
    required this.newLineCount,
  });

  /// Creates an empty diff result representing two identical, empty documents.
  const DiffResult.empty()
      : lines = const [],
        additions = 0,
        deletions = 0,
        modifications = 0,
        unchanged = 0,
        oldLineCount = 0,
        newLineCount = 0;

  /// Returns `true` if the two compared contents are identical (no changes).
  bool get hasNoChanges =>
      additions == 0 && deletions == 0 && modifications == 0;

  /// Returns `true` if there are any changes between the two contents.
  bool get hasChanges => !hasNoChanges;

  /// The total number of changed lines (additions + deletions + modifications).
  int get totalChanges => additions + deletions + modifications;

  /// Returns only the lines that represent changes (added, removed, modified).
  List<DiffLine> get changedLines =>
      lines.where((l) => l.type != DiffType.unchanged).toList(growable: false);

  /// Returns only the lines that represent unchanged content.
  List<DiffLine> get unchangedLines =>
      lines.where((l) => l.type == DiffType.unchanged).toList(growable: false);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffResult &&
          runtimeType == other.runtimeType &&
          additions == other.additions &&
          deletions == other.deletions &&
          modifications == other.modifications &&
          unchanged == other.unchanged &&
          oldLineCount == other.oldLineCount &&
          newLineCount == other.newLineCount;

  @override
  int get hashCode => Object.hash(
        additions,
        deletions,
        modifications,
        unchanged,
        oldLineCount,
        newLineCount,
      );

  @override
  String toString() => 'DiffResult('
      'additions: $additions, '
      'deletions: $deletions, '
      'modifications: $modifications, '
      'unchanged: $unchanged, '
      'lines: ${lines.length})';
}
