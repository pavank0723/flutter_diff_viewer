import '../enums/diff_type.dart';

/// An immutable entity representing a contiguous run of text with a single
/// [DiffType] classification.
///
/// Segments are the finest unit of diff information, used to highlight
/// specific words or characters within a line.
///
/// Example: In the line `"Hello World"` → `"Hello Dart"`:
/// - `DiffSegment(text: 'Hello ', type: DiffType.unchanged)`
/// - `DiffSegment(text: 'World', type: DiffType.removed)` (old side)
/// - `DiffSegment(text: 'Dart', type: DiffType.added)` (new side)
///
/// Segments are always non-empty strings.
class DiffSegment {
  /// The text content of this segment.
  final String text;

  /// The classification of this segment indicating how it changed.
  final DiffType type;

  /// Creates an immutable diff segment.
  ///
  /// [text] must not be empty.
  const DiffSegment({required this.text, required this.type});

  /// Returns `true` if this segment represents unchanged content.
  bool get isUnchanged => type == DiffType.unchanged;

  /// Returns `true` if this segment represents added content.
  bool get isAdded => type == DiffType.added;

  /// Returns `true` if this segment represents removed content.
  bool get isRemoved => type == DiffType.removed;

  /// Creates a copy of this segment with the specified fields replaced.
  DiffSegment copyWith({String? text, DiffType? type}) {
    return DiffSegment(text: text ?? this.text, type: type ?? this.type);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffSegment &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          type == other.type;

  @override
  int get hashCode => Object.hash(text, type);

  @override
  String toString() =>
      'DiffSegment(type: $type, text: ${text.length > 20 ? '${text.substring(0, 20)}…' : text})';
}
