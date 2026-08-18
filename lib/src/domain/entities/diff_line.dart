import '../enums/diff_type.dart';
import 'diff_segment.dart';

/// An immutable entity representing a single line (or pair of lines) in a diff.
///
/// In side-by-side mode, a [DiffLine] holds both the old and new content for
/// a given visual row. In unified mode, each [DiffLine] represents a single
/// line from either the old or new content.
///
/// - [oldLineNumber]: The 1-based line number in the old content, or `null`
///   if this line does not exist in the old content (i.e., it was added).
/// - [newLineNumber]: The 1-based line number in the new content, or `null`
///   if this line does not exist in the new content (i.e., it was removed).
/// - [oldText]: The raw text of the old line, or `null` if not applicable.
/// - [newText]: The raw text of the new line, or `null` if not applicable.
/// - [type]: The overall change type of this line.
/// - [oldSegments]: Word/character-level segments for the old side.
/// - [newSegments]: Word/character-level segments for the new side.
/// - [isCollapsed]: Whether this line is part of a collapsed unchanged section.
class DiffLine {
  /// The 1-based line number in the old (original) content.
  ///
  /// `null` for lines that only exist in the new content ([DiffType.added]).
  final int? oldLineNumber;

  /// The 1-based line number in the new (modified) content.
  ///
  /// `null` for lines that only exist in the old content ([DiffType.removed]).
  final int? newLineNumber;

  /// The raw text content from the old version.
  ///
  /// `null` for [DiffType.added] lines.
  final String? oldText;

  /// The raw text content from the new version.
  ///
  /// `null` for [DiffType.removed] lines.
  final String? newText;

  /// The overall change classification for this line.
  final DiffType type;

  /// Word or character-level segments for the old side of this line.
  ///
  /// Empty list if granularity is [DiffGranularity.line] or if this line
  /// is [DiffType.unchanged].
  final List<DiffSegment> oldSegments;

  /// Word or character-level segments for the new side of this line.
  ///
  /// Empty list if granularity is [DiffGranularity.line] or if this line
  /// is [DiffType.unchanged].
  final List<DiffSegment> newSegments;

  /// Whether this line is currently collapsed (hidden) as part of an
  /// unchanged context section.
  final bool isCollapsed;

  /// Creates an immutable diff line.
  const DiffLine({
    required this.type,
    this.oldLineNumber,
    this.newLineNumber,
    this.oldText,
    this.newText,
    this.oldSegments = const [],
    this.newSegments = const [],
    this.isCollapsed = false,
  });

  /// Returns `true` if this line represents an unchanged line.
  bool get isUnchanged => type == DiffType.unchanged;

  /// Returns `true` if this line represents an added line.
  bool get isAdded => type == DiffType.added;

  /// Returns `true` if this line represents a removed line.
  bool get isRemoved => type == DiffType.removed;

  /// Returns `true` if this line represents a modified line.
  bool get isModified => type == DiffType.modified;

  /// Returns `true` if this line has intra-line segment information.
  bool get hasSegments => oldSegments.isNotEmpty || newSegments.isNotEmpty;

  /// Creates a copy of this line with the specified fields replaced.
  DiffLine copyWith({
    int? oldLineNumber,
    int? newLineNumber,
    String? oldText,
    String? newText,
    DiffType? type,
    List<DiffSegment>? oldSegments,
    List<DiffSegment>? newSegments,
    bool? isCollapsed,
  }) {
    return DiffLine(
      oldLineNumber: oldLineNumber ?? this.oldLineNumber,
      newLineNumber: newLineNumber ?? this.newLineNumber,
      oldText: oldText ?? this.oldText,
      newText: newText ?? this.newText,
      type: type ?? this.type,
      oldSegments: oldSegments ?? this.oldSegments,
      newSegments: newSegments ?? this.newSegments,
      isCollapsed: isCollapsed ?? this.isCollapsed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffLine &&
          runtimeType == other.runtimeType &&
          oldLineNumber == other.oldLineNumber &&
          newLineNumber == other.newLineNumber &&
          oldText == other.oldText &&
          newText == other.newText &&
          type == other.type &&
          isCollapsed == other.isCollapsed;

  @override
  int get hashCode => Object.hash(
        oldLineNumber,
        newLineNumber,
        oldText,
        newText,
        type,
        isCollapsed,
      );

  @override
  String toString() =>
      'DiffLine(type: $type, old: $oldLineNumber, new: $newLineNumber)';
}
