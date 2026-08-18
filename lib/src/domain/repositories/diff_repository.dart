import '../entities/diff_result.dart';
import '../value_objects/diff_comparison_options.dart';

/// Abstract interface for the diff comparison repository.
///
/// The domain layer depends only on this interface, keeping it decoupled
/// from specific diff algorithm implementations.
///
/// Implementations are provided by the data layer (e.g., [DiffRepositoryImpl])
/// and can be swapped without modifying domain or presentation code.
///
/// ```dart
/// // In the data layer:
/// class DiffRepositoryImpl implements DiffRepository {
///   @override
///   Future<DiffResult> compare({...}) async { ... }
/// }
/// ```
abstract interface class DiffRepository {
  /// Compares [oldContent] and [newContent] and returns a [DiffResult].
  ///
  /// The [options] parameter controls comparison behavior such as
  /// granularity, whitespace handling, and case sensitivity.
  ///
  /// Throws [DiffCalculationException] if the comparison fails.
  /// Throws [InvalidDiffInputException] if inputs are invalid.
  Future<DiffResult> compare({
    required String oldContent,
    required String newContent,
    DiffComparisonOptions options = const DiffComparisonOptions(),
  });
}
