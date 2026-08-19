/// Base class for all exceptions thrown by the flutter_diff_viewer package.
///
/// Catch this base class to handle any package-specific error:
///
/// ```dart
/// try {
///   final result = await calculateDiff(...);
/// } on DiffException catch (e) {
///   print('Diff error: ${e.message}');
/// }
/// ```
sealed class DiffException implements Exception {
  /// A human-readable description of the error.
  final String message;

  /// Optional original error that caused this exception.
  final Object? cause;

  const DiffException(this.message, {this.cause});

  @override
  String toString() =>
      '$runtimeType: $message${cause != null ? ' (caused by: $cause)' : ''}';
}

/// Thrown when the inputs provided for diff calculation are invalid.
///
/// Examples:
/// - Both [oldContent] and [newContent] are identical empty strings (not an
///   error by itself, but very large inputs exceeding limits).
/// - Configuration values are out of acceptable bounds.
final class InvalidDiffInputException extends DiffException {
  const InvalidDiffInputException(super.message, {super.cause});
}

/// Thrown when the diff engine encounters an internal failure during
/// calculation.
///
/// This typically wraps exceptions from the underlying diff algorithm.
final class DiffCalculationException extends DiffException {
  const DiffCalculationException(super.message, {super.cause});
}

/// Thrown when the diff viewer is configured with invalid or incompatible
/// settings.
///
/// Examples:
/// - Negative [contextLines] value.
/// - Unsupported layout/granularity combination.
final class DiffConfigurationException extends DiffException {
  const DiffConfigurationException(super.message, {super.cause});
}

/// Thrown when a requested change index is out of bounds.
///
/// This typically occurs when [FlutterDiffViewerController.goToChange] is called
/// with an index that does not exist in the current diff result.
final class DiffIndexOutOfBoundsException extends DiffException {
  /// The index that was requested.
  final int requestedIndex;

  /// The total number of changes available.
  final int totalChanges;

  const DiffIndexOutOfBoundsException({
    required this.requestedIndex,
    required this.totalChanges,
  }) : super(
          'Change index $requestedIndex is out of bounds. '
          'Total changes: $totalChanges.',
        );
}
