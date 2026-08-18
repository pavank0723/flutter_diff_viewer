import '../enums/diff_type.dart';

/// An immutable entity representing a navigable change within a diff result.
///
/// A [DiffChange] groups related [DiffLine] entries that form a single
/// logical change block. Used by [DiffViewerController] for change navigation
/// (next/previous change).
///
/// ```dart
/// // Navigate to a specific change
/// controller.goToChange(change.index);
/// ```
class DiffChange {
  /// The 0-based index of this change among all changes in the diff.
  final int index;

  /// The index of the first [DiffLine] in this change block.
  final int startLineIndex;

  /// The index of the last [DiffLine] in this change block.
  final int endLineIndex;

  /// The primary type of change in this block.
  ///
  /// If a block contains mixed types (e.g., removed + added lines forming
  /// a modification), this will be [DiffType.modified].
  final DiffType type;

  /// The number of lines in this change block.
  int get lineCount => endLineIndex - startLineIndex + 1;

  /// Creates an immutable diff change.
  const DiffChange({
    required this.index,
    required this.startLineIndex,
    required this.endLineIndex,
    required this.type,
  }) : assert(
          startLineIndex <= endLineIndex,
          'startLineIndex must be <= endLineIndex',
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffChange &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          startLineIndex == other.startLineIndex &&
          endLineIndex == other.endLineIndex &&
          type == other.type;

  @override
  int get hashCode => Object.hash(index, startLineIndex, endLineIndex, type);

  @override
  String toString() =>
      'DiffChange(index: $index, lines: $startLineIndex–$endLineIndex, type: $type)';
}
