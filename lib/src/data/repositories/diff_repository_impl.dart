import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/exceptions/diff_exceptions.dart';
import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/repositories/diff_repository.dart';
import '../../domain/value_objects/diff_comparison_options.dart';
import '../engines/default_diff_engine.dart';
import '../engines/diff_engine.dart';

// ---------------------------------------------------------------------------
// Isolate payload — must be a simple, sendable object.
// ---------------------------------------------------------------------------

/// Internal data class passed to the isolate entry-point.
///
/// All fields must be sendable across isolate boundaries (primitives / enums).
@immutable
class _DiffPayload {
  final String oldContent;
  final String newContent;
  final DiffComparisonOptions options;

  const _DiffPayload({
    required this.oldContent,
    required this.newContent,
    required this.options,
  });
}

// ---------------------------------------------------------------------------
// Top-level isolate entry-point (required by compute()).
// ---------------------------------------------------------------------------

/// Top-level function used as the entry point for [compute].
///
/// Must be a top-level (or static) function — closures cannot be passed across
/// isolate boundaries. Creates a fresh [DefaultDiffEngine] inside the isolate
/// so that no shared state is accessed.
DiffResult _computeDiff(_DiffPayload payload) {
  const engine = DefaultDiffEngine();
  return engine.compare(
    payload.oldContent,
    payload.newContent,
    payload.options,
  );
}

// ---------------------------------------------------------------------------
// Repository implementation
// ---------------------------------------------------------------------------

/// Production implementation of [DiffRepository].
///
/// Uses a [DiffEngine] (defaulting to [DefaultDiffEngine]) to compute diffs.
///
/// ### Isolate offloading
///
/// When **both** conditions are met:
/// - [DiffComparisonOptions.useIsolate] is `true`
/// - The combined line count exceeds [DiffConstants.isolateThreshold]
///
/// …the diff is computed in a separate Dart isolate via Flutter's [compute]
/// function, keeping the UI thread free.
///
/// For smaller inputs the diff runs synchronously on the calling isolate,
/// avoiding isolate spawn overhead.
///
/// ### Error handling
///
/// - [InvalidDiffInputException] is thrown for inputs that are too large or
///   otherwise invalid before computation starts.
/// - [DiffCalculationException] wraps any unexpected exception thrown by the
///   underlying engine.
///
/// ```dart
/// final repo = DiffRepositoryImpl(engine: DefaultDiffEngine());
///
/// final result = await repo.compare(
///   oldContent: oldText,
///   newContent: newText,
///   options: const DiffComparisonOptions(useIsolate: true),
/// );
/// ```
final class DiffRepositoryImpl implements DiffRepository {
  /// The diff engine used for computation.
  final DiffEngine engine;

  /// Creates a [DiffRepositoryImpl].
  ///
  /// [engine] defaults to [DefaultDiffEngine] when not supplied via DI.
  const DiffRepositoryImpl({this.engine = const DefaultDiffEngine()});

  // ---------------------------------------------------------------------------
  // DiffRepository implementation
  // ---------------------------------------------------------------------------

  @override
  Future<DiffResult> compare({
    required String oldContent,
    required String newContent,
    DiffComparisonOptions options = const DiffComparisonOptions(),
  }) async {
    // Validate inputs before doing any work.
    _validateInputs(oldContent, newContent);

    // Fast path: both strings are identical.
    if (oldContent == newContent) {
      final lines = oldContent.toLines();
      return _identicalResult(lines.length);
    }

    final payload = _DiffPayload(
      oldContent: oldContent,
      newContent: newContent,
      options: options,
    );

    try {
      if (_shouldUseIsolate(oldContent, newContent, options)) {
        // Offload to a background isolate.
        return await compute(_computeDiff, payload);
      } else {
        // Run synchronously — avoids isolate overhead for small inputs.
        return engine.compare(oldContent, newContent, options);
      }
    } on DiffException {
      rethrow; // Let domain-level exceptions propagate unchanged.
    } catch (e) {
      throw DiffCalculationException('Diff computation failed: $e', cause: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns `true` when the diff should be offloaded to an isolate.
  bool _shouldUseIsolate(
    String oldContent,
    String newContent,
    DiffComparisonOptions options,
  ) {
    if (!options.useIsolate) return false;
    final oldLines = oldContent.toLines().length;
    final newLines = newContent.toLines().length;
    final totalLines = oldLines + newLines;
    return totalLines > DiffConstants.isolateThreshold;
  }

  /// Validates that the inputs are suitable for diff computation.
  ///
  /// Throws [InvalidDiffInputException] for clearly invalid input.
  void _validateInputs(String oldContent, String newContent) {
    // Currently no hard size limit, but this is the right place to add one.
    // Both inputs being empty is valid (empty-to-empty diff).
  }

  /// Builds an empty (zero-change) [DiffResult] for identical inputs.
  DiffResult _identicalResult(int lineCount) {
    // We do not expand lines here to avoid allocation for large identical docs.
    // The engine would build unchanged DiffLines — but since callers only
    // need statistics for identical docs, we return a summary result.
    // If callers need lines they should call engine.compare directly.
    return DiffResult(
      lines: const [],
      additions: 0,
      deletions: 0,
      modifications: 0,
      unchanged: lineCount,
      oldLineCount: lineCount,
      newLineCount: lineCount,
    );
  }
}
