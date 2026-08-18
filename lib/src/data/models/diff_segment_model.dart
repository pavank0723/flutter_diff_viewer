import '../../domain/entities/diff_segment.dart';
import '../../domain/enums/diff_type.dart';

/// Data-layer model that extends [DiffSegment] with serialisation support.
///
/// [DiffSegmentModel] is a superset of [DiffSegment]: it carries all the
/// same data plus [toMap] / [fromMap] for JSON-style persistence.
///
/// ```dart
/// final model = DiffSegmentModel.fromEntity(segment);
/// final map   = model.toMap();
/// final back  = DiffSegmentModel.fromMap(map);
/// ```
class DiffSegmentModel extends DiffSegment {
  /// Creates an immutable [DiffSegmentModel].
  const DiffSegmentModel({required super.text, required super.type});

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// Creates a [DiffSegmentModel] from a domain [DiffSegment] entity.
  factory DiffSegmentModel.fromEntity(DiffSegment entity) {
    // If it's already a model, avoid wrapping unnecessarily.
    if (entity is DiffSegmentModel) return entity;
    return DiffSegmentModel(text: entity.text, type: entity.type);
  }

  /// Deserialises a [DiffSegmentModel] from a plain [Map].
  ///
  /// Expected keys: `'text'` (String) and `'type'` (String matching a
  /// [DiffType] name).
  ///
  /// Throws [ArgumentError] if required keys are missing or `type` is invalid.
  factory DiffSegmentModel.fromMap(Map<String, dynamic> map) {
    final text = map['text'];
    final typeName = map['type'];
    if (text is! String) {
      throw ArgumentError.value(map, 'map', '"text" must be a String');
    }
    if (typeName is! String) {
      throw ArgumentError.value(map, 'map', '"type" must be a String');
    }
    return DiffSegmentModel(text: text, type: DiffType.values.byName(typeName));
  }

  // ---------------------------------------------------------------------------
  // Serialisation
  // ---------------------------------------------------------------------------

  /// Serialises this model to a plain [Map] suitable for JSON encoding.
  ///
  /// The [DiffType] is stored as its enum name string.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'text': text,
        'type': type.name,
      };

  // ---------------------------------------------------------------------------
  // Overrides
  // ---------------------------------------------------------------------------

  @override
  String toString() =>
      'DiffSegmentModel(type: $type, text: ${text.length > 20 ? '${text.substring(0, 20)}…' : text})';
}
