import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_segment.dart';
import '../../domain/enums/diff_type.dart';
import 'diff_segment_model.dart';

/// Data-layer model that extends [DiffLine] with serialisation support.
///
/// Provides [fromEntity] for upcasting, [toMap] for persistence, and
/// [fromMap] for deserialisation. The nested [oldSegments] and [newSegments]
/// lists are serialised as lists of [DiffSegmentModel] maps.
///
/// ```dart
/// final model = DiffLineModel.fromEntity(line);
/// final json  = jsonEncode(model.toMap());
/// final back  = DiffLineModel.fromMap(jsonDecode(json) as Map<String, dynamic>);
/// ```
class DiffLineModel extends DiffLine {
  /// Creates an immutable [DiffLineModel].
  const DiffLineModel({
    required super.type,
    super.oldLineNumber,
    super.newLineNumber,
    super.oldText,
    super.newText,
    super.oldSegments = const [],
    super.newSegments = const [],
    super.isCollapsed = false,
  });

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// Upcasts a domain [DiffLine] entity to [DiffLineModel].
  ///
  /// If [entity] is already a [DiffLineModel] it is returned as-is.
  factory DiffLineModel.fromEntity(DiffLine entity) {
    if (entity is DiffLineModel) return entity;
    return DiffLineModel(
      oldLineNumber: entity.oldLineNumber,
      newLineNumber: entity.newLineNumber,
      oldText: entity.oldText,
      newText: entity.newText,
      type: entity.type,
      oldSegments: entity.oldSegments
          .map(DiffSegmentModel.fromEntity)
          .toList(growable: false),
      newSegments: entity.newSegments
          .map(DiffSegmentModel.fromEntity)
          .toList(growable: false),
      isCollapsed: entity.isCollapsed,
    );
  }

  /// Deserialises a [DiffLineModel] from a plain [Map].
  ///
  /// Expected keys (all optional except `'type'`):
  /// - `'oldLineNumber'`: int?
  /// - `'newLineNumber'`: int?
  /// - `'oldText'`: String?
  /// - `'newText'`: String?
  /// - `'type'`: String (required, must match a [DiffType] name)
  /// - `'oldSegments'`: List of segment maps
  /// - `'newSegments'`: List of segment maps
  /// - `'isCollapsed'`: bool
  ///
  /// Throws [ArgumentError] if `'type'` is missing or invalid.
  factory DiffLineModel.fromMap(Map<String, dynamic> map) {
    final typeName = map['type'];
    if (typeName is! String) {
      throw ArgumentError.value(map, 'map', '"type" must be a String');
    }

    List<DiffSegment> parseSegments(dynamic raw) {
      if (raw is! List) return const [];
      return raw
          .cast<Map<String, dynamic>>()
          .map(DiffSegmentModel.fromMap)
          .toList(growable: false);
    }

    return DiffLineModel(
      type: DiffType.values.byName(typeName),
      oldLineNumber: map['oldLineNumber'] as int?,
      newLineNumber: map['newLineNumber'] as int?,
      oldText: map['oldText'] as String?,
      newText: map['newText'] as String?,
      oldSegments: parseSegments(map['oldSegments']),
      newSegments: parseSegments(map['newSegments']),
      isCollapsed: map['isCollapsed'] as bool? ?? false,
    );
  }

  // ---------------------------------------------------------------------------
  // Serialisation
  // ---------------------------------------------------------------------------

  /// Serialises this model to a plain [Map] suitable for JSON encoding.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'type': type.name,
      'isCollapsed': isCollapsed,
    };

    if (oldLineNumber != null) map['oldLineNumber'] = oldLineNumber;
    if (newLineNumber != null) map['newLineNumber'] = newLineNumber;
    if (oldText != null) map['oldText'] = oldText;
    if (newText != null) map['newText'] = newText;

    if (oldSegments.isNotEmpty) {
      map['oldSegments'] = oldSegments
          .map((s) => DiffSegmentModel.fromEntity(s).toMap())
          .toList(growable: false);
    }
    if (newSegments.isNotEmpty) {
      map['newSegments'] = newSegments
          .map((s) => DiffSegmentModel.fromEntity(s).toMap())
          .toList(growable: false);
    }

    return map;
  }

  // ---------------------------------------------------------------------------
  // Overrides
  // ---------------------------------------------------------------------------

  @override
  String toString() =>
      'DiffLineModel(type: $type, old: $oldLineNumber, new: $newLineNumber)';
}
