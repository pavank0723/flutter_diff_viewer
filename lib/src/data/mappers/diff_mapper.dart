import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/entities/diff_segment.dart';
import '../models/diff_line_model.dart';
import '../models/diff_result_model.dart';
import '../models/diff_segment_model.dart';

/// Stateless mapper that converts between domain entities and data models.
///
/// All conversion methods are pure functions with no side effects. An instance
/// can be safely shared and reused across the entire application.
///
/// ### Usage
/// ```dart
/// const mapper = DiffMapper();
///
/// // Entity → Model (for persistence)
/// final model = mapper.resultToModel(diffResult);
/// final json  = jsonEncode(model.toMap());
///
/// // Model → Entity (after deserialisation)
/// final map     = jsonDecode(json) as Map<String, dynamic>;
/// final model2  = DiffResultModel.fromMap(map);
/// final entity  = mapper.resultToEntity(model2);
/// ```
class DiffMapper {
  /// Creates a stateless [DiffMapper].
  const DiffMapper();

  // ---------------------------------------------------------------------------
  // DiffResult ↔ DiffResultModel
  // ---------------------------------------------------------------------------

  /// Converts a domain [DiffResult] entity to a [DiffResultModel].
  ///
  /// If [entity] is already a [DiffResultModel], no allocation occurs.
  DiffResultModel resultToModel(DiffResult entity) =>
      DiffResultModel.fromEntity(entity);

  /// Converts a [DiffResultModel] to a plain domain [DiffResult] entity.
  ///
  /// The returned [DiffResult] carries [DiffLine] (not [DiffLineModel])
  /// children, stripping the serialisation layer from the domain view.
  DiffResult resultToEntity(DiffResultModel model) {
    // DiffResultModel IS-A DiffResult, so we can return it directly.
    // The caller should depend on the domain type, not the model type.
    return DiffResult(
      lines: model.lines
          .map((l) => lineToEntity(DiffLineModel.fromEntity(l)))
          .toList(growable: false),
      additions: model.additions,
      deletions: model.deletions,
      modifications: model.modifications,
      unchanged: model.unchanged,
      oldLineCount: model.oldLineCount,
      newLineCount: model.newLineCount,
    );
  }

  // ---------------------------------------------------------------------------
  // DiffLine ↔ DiffLineModel
  // ---------------------------------------------------------------------------

  /// Converts a domain [DiffLine] entity to a [DiffLineModel].
  DiffLineModel lineToModel(DiffLine entity) =>
      DiffLineModel.fromEntity(entity);

  /// Converts a [DiffLineModel] to a plain domain [DiffLine] entity.
  DiffLine lineToEntity(DiffLineModel model) => DiffLine(
        oldLineNumber: model.oldLineNumber,
        newLineNumber: model.newLineNumber,
        oldText: model.oldText,
        newText: model.newText,
        type: model.type,
        oldSegments: model.oldSegments
            .map((s) => segmentToEntity(DiffSegmentModel.fromEntity(s)))
            .toList(growable: false),
        newSegments: model.newSegments
            .map((s) => segmentToEntity(DiffSegmentModel.fromEntity(s)))
            .toList(growable: false),
        isCollapsed: model.isCollapsed,
      );

  // ---------------------------------------------------------------------------
  // DiffSegment ↔ DiffSegmentModel
  // ---------------------------------------------------------------------------

  /// Converts a domain [DiffSegment] entity to a [DiffSegmentModel].
  DiffSegmentModel segmentToModel(DiffSegment entity) =>
      DiffSegmentModel.fromEntity(entity);

  /// Converts a [DiffSegmentModel] to a plain domain [DiffSegment] entity.
  DiffSegment segmentToEntity(DiffSegmentModel model) =>
      DiffSegment(text: model.text, type: model.type);

  // ---------------------------------------------------------------------------
  // Batch helpers
  // ---------------------------------------------------------------------------

  /// Converts a list of domain [DiffLine]s to a list of [DiffLineModel]s.
  List<DiffLineModel> linesToModels(List<DiffLine> entities) =>
      entities.map(lineToModel).toList(growable: false);

  /// Converts a list of [DiffLineModel]s to a list of domain [DiffLine]s.
  List<DiffLine> modelsToLines(List<DiffLineModel> models) =>
      models.map(lineToEntity).toList(growable: false);

  /// Converts a list of domain [DiffSegment]s to a list of [DiffSegmentModel]s.
  List<DiffSegmentModel> segmentsToModels(List<DiffSegment> entities) =>
      entities.map(segmentToModel).toList(growable: false);

  /// Converts a list of [DiffSegmentModel]s to a list of domain [DiffSegment]s.
  List<DiffSegment> modelsToSegments(List<DiffSegmentModel> models) =>
      models.map(segmentToEntity).toList(growable: false);
}
