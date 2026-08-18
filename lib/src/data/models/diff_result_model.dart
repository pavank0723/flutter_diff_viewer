import '../../domain/entities/diff_result.dart';
import 'diff_line_model.dart';

/// Data-layer model that extends [DiffResult] with serialisation support.
///
/// Serialises the complete diff result — including all [DiffLineModel] entries
/// and their nested [DiffSegmentModel]s — to/from a plain [Map] compatible
/// with `dart:convert`'s `jsonEncode` / `jsonDecode`.
///
/// ```dart
/// final model  = DiffResultModel.fromEntity(result);
/// final json   = jsonEncode(model.toMap());
/// final back   = DiffResultModel.fromMap(jsonDecode(json));
/// ```
class DiffResultModel extends DiffResult {
  /// Creates an immutable [DiffResultModel].
  const DiffResultModel({
    required super.lines,
    required super.additions,
    required super.deletions,
    required super.modifications,
    required super.unchanged,
    required super.oldLineCount,
    required super.newLineCount,
  });

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// Upcasts a domain [DiffResult] entity to [DiffResultModel].
  ///
  /// If [entity] is already a [DiffResultModel] it is returned as-is.
  factory DiffResultModel.fromEntity(DiffResult entity) {
    if (entity is DiffResultModel) return entity;
    return DiffResultModel(
      lines: entity.lines.map(DiffLineModel.fromEntity).toList(growable: false),
      additions: entity.additions,
      deletions: entity.deletions,
      modifications: entity.modifications,
      unchanged: entity.unchanged,
      oldLineCount: entity.oldLineCount,
      newLineCount: entity.newLineCount,
    );
  }

  /// Deserialises a [DiffResultModel] from a plain [Map].
  ///
  /// Expected keys:
  /// - `'lines'`: List of line maps (required)
  /// - `'additions'`: int (required)
  /// - `'deletions'`: int (required)
  /// - `'modifications'`: int (required)
  /// - `'unchanged'`: int (required)
  /// - `'oldLineCount'`: int (required)
  /// - `'newLineCount'`: int (required)
  ///
  /// Throws [ArgumentError] if required integer fields are absent or have
  /// wrong types.
  factory DiffResultModel.fromMap(Map<String, dynamic> map) {
    int requireInt(String key) {
      final v = map[key];
      if (v is! int) {
        throw ArgumentError.value(map, 'map', '"$key" must be an int');
      }
      return v;
    }

    final rawLines = map['lines'];
    final lines = (rawLines is List)
        ? rawLines
            .cast<Map<String, dynamic>>()
            .map(DiffLineModel.fromMap)
            .toList(growable: false)
        : const <DiffLineModel>[];

    return DiffResultModel(
      lines: lines,
      additions: requireInt('additions'),
      deletions: requireInt('deletions'),
      modifications: requireInt('modifications'),
      unchanged: requireInt('unchanged'),
      oldLineCount: requireInt('oldLineCount'),
      newLineCount: requireInt('newLineCount'),
    );
  }

  /// Creates an empty [DiffResultModel] (both inputs were empty / identical).
  const DiffResultModel.empty()
      : super(
          lines: const [],
          additions: 0,
          deletions: 0,
          modifications: 0,
          unchanged: 0,
          oldLineCount: 0,
          newLineCount: 0,
        );

  // ---------------------------------------------------------------------------
  // Serialisation
  // ---------------------------------------------------------------------------

  /// Serialises this model to a plain [Map] suitable for JSON encoding.
  ///
  /// All nested [DiffLineModel]s are recursively serialised.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'lines': lines
            .map((l) => DiffLineModel.fromEntity(l).toMap())
            .toList(growable: false),
        'additions': additions,
        'deletions': deletions,
        'modifications': modifications,
        'unchanged': unchanged,
        'oldLineCount': oldLineCount,
        'newLineCount': newLineCount,
      };

  // ---------------------------------------------------------------------------
  // Overrides
  // ---------------------------------------------------------------------------

  @override
  String toString() => 'DiffResultModel('
      'additions: $additions, '
      'deletions: $deletions, '
      'modifications: $modifications, '
      'unchanged: $unchanged, '
      'lines: ${lines.length})';
}
