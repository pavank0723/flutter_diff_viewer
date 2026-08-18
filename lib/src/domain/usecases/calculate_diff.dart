import '../entities/diff_result.dart';
import '../repositories/diff_repository.dart';
import '../value_objects/diff_comparison_options.dart';

/// Use case for calculating the diff between two text contents.
///
/// This is the primary entry point for the domain's diff business logic.
/// The presentation layer calls this use case instead of interacting
/// directly with repositories or engines.
///
/// Follows the Command pattern — callable via `call()` for idiomatic Dart.
///
/// ```dart
/// final calculateDiff = CalculateDiff(repository);
///
/// final result = await calculateDiff(
///   oldContent: 'Hello World',
///   newContent: 'Hello Dart',
///   options: const DiffComparisonOptions(
///     granularity: DiffGranularity.word,
///   ),
/// );
/// ```
class CalculateDiff {
  final DiffRepository _repository;

  /// Creates a [CalculateDiff] use case with the given [repository].
  const CalculateDiff(this._repository);

  /// Executes the diff calculation.
  ///
  /// Returns a [DiffResult] containing all line, word, and character-level
  /// diff information.
  ///
  /// Throws [InvalidDiffInputException] for empty or null content.
  /// Throws [DiffCalculationException] if the diff engine fails.
  Future<DiffResult> call({
    required String oldContent,
    required String newContent,
    DiffComparisonOptions options = const DiffComparisonOptions(),
  }) {
    return _repository.compare(
      oldContent: oldContent,
      newContent: newContent,
      options: options,
    );
  }
}
