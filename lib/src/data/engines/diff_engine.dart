import '../../domain/entities/diff_result.dart';
import '../../domain/value_objects/diff_comparison_options.dart';

/// Abstract interface for diff engine implementations.
///
/// Implement this to provide a custom diff algorithm.
///
/// The engine is responsible for the pure computation of diffing two strings.
/// It operates synchronously and is called by [DiffRepositoryImpl], which
/// optionally offloads the work to an isolate via Flutter's `compute()`.
///
/// ```dart
/// class MyCustomEngine implements DiffEngine {
///   @override
///   DiffResult compare(String oldContent, String newContent,
///       DiffComparisonOptions options) {
///     // custom algorithm...
///   }
/// }
/// ```
abstract interface class DiffEngine {
  /// Synchronously compares two strings and returns a [DiffResult].
  ///
  /// [oldContent] is the original text.
  /// [newContent] is the modified text.
  /// [options] controls granularity, whitespace handling, and case sensitivity.
  ///
  /// Returns a fully populated [DiffResult] with statistics and line data.
  DiffResult compare(
    String oldContent,
    String newContent,
    DiffComparisonOptions options,
  );
}
