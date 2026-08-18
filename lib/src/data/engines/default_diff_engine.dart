import '../../core/constants/app_constants.dart';
import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_granularity.dart';
import '../../domain/enums/diff_type.dart';
import '../../domain/value_objects/diff_comparison_options.dart';
import 'character_diff_engine.dart';
import 'diff_engine.dart';
import 'line_diff_engine.dart';
import 'word_diff_engine.dart';

/// The default [DiffEngine] implementation.
///
/// Orchestrates three sub-engines to produce a fully annotated [DiffResult]:
///
/// 1. **[LineDiffEngine]** — computes line-level edits using Myers' O(ND)
///    algorithm.
/// 2. **[WordDiffEngine]** — enriches modified lines with word-level segments.
/// 3. **[CharacterDiffEngine]** — enriches modified lines with character-level
///    segments.
///
/// ### Granularity selection
///
/// | [DiffGranularity] | Intra-line engine used |
/// |---|---|
/// | `line` | none — raw text only |
/// | `word` | [WordDiffEngine] for every modified line |
/// | `character` | [CharacterDiffEngine] for every modified line |
/// | `auto` | [WordDiffEngine] if line ≤ [DiffConstants.longLineThreshold] chars, else none |
///
/// Pure Dart — no Flutter or Material imports.
final class DefaultDiffEngine implements DiffEngine {
  /// The sub-engine for line-level diffing.
  final LineDiffEngine _lineEngine;

  /// The sub-engine for word-level intra-line diffing.
  final WordDiffEngine _wordEngine;

  /// The sub-engine for character-level intra-line diffing.
  final CharacterDiffEngine _charEngine;

  /// Creates a [DefaultDiffEngine] with optional custom sub-engines.
  ///
  /// Sub-engines are stateless and can be shared across instances.
  const DefaultDiffEngine({
    LineDiffEngine lineEngine = const LineDiffEngine(),
    WordDiffEngine wordEngine = const WordDiffEngine(),
    CharacterDiffEngine charEngine = const CharacterDiffEngine(),
  })  : _lineEngine = lineEngine,
        _wordEngine = wordEngine,
        _charEngine = charEngine;

  // ---------------------------------------------------------------------------
  // DiffEngine implementation
  // ---------------------------------------------------------------------------

  @override
  DiffResult compare(
    String oldContent,
    String newContent,
    DiffComparisonOptions options,
  ) {
    // Fast path: identical content.
    if (oldContent == newContent) {
      final lines = oldContent.toLines();
      final count = lines.length;
      final diffLines = <DiffLine>[];
      for (var i = 0; i < count; i++) {
        diffLines.add(
          DiffLine(
            oldLineNumber: i + 1,
            newLineNumber: i + 1,
            oldText: lines[i],
            newText: lines[i],
            type: DiffType.unchanged,
          ),
        );
      }
      return DiffResult(
        lines: diffLines,
        additions: 0,
        deletions: 0,
        modifications: 0,
        unchanged: count,
        oldLineCount: count,
        newLineCount: count,
      );
    }

    // Step 1: Line-level diff.
    final rawLines = _lineEngine.computeLines(
      oldContent: oldContent,
      newContent: newContent,
      ignoreWhitespace: options.ignoreWhitespace,
      caseSensitive: options.caseSensitive,
    );

    // Step 2: Enrich modified lines with intra-line segments.
    final enriched = _enrichLines(rawLines, options);

    // Step 3: Compute statistics.
    int additions = 0;
    int deletions = 0;
    int modifications = 0;
    int unchanged = 0;

    for (final line in enriched) {
      switch (line.type) {
        case DiffType.added:
          additions++;
        case DiffType.removed:
          deletions++;
        case DiffType.modified:
          modifications++;
        case DiffType.unchanged:
          unchanged++;
      }
    }

    return DiffResult(
      lines: enriched,
      additions: additions,
      deletions: deletions,
      modifications: modifications,
      unchanged: unchanged,
      oldLineCount: oldContent.toLines().length,
      newLineCount: newContent.toLines().length,
    );
  }

  // ---------------------------------------------------------------------------
  // Intra-line enrichment
  // ---------------------------------------------------------------------------

  /// Iterates over [rawLines] and enriches [DiffType.modified] lines with
  /// segment data based on the chosen [DiffComparisonOptions.granularity].
  List<DiffLine> _enrichLines(
    List<DiffLine> rawLines,
    DiffComparisonOptions options,
  ) {
    if (options.granularity == DiffGranularity.line) {
      // No intra-line diff requested.
      return rawLines;
    }

    return rawLines.map((line) {
      if (line.type != DiffType.modified) return line;
      return _enrichModifiedLine(line, options);
    }).toList(growable: false);
  }

  /// Enriches a single [DiffType.modified] line with segment data.
  DiffLine _enrichModifiedLine(DiffLine line, DiffComparisonOptions options) {
    final oldText = line.oldText ?? '';
    final newText = line.newText ?? '';

    final useWord = _shouldUseWordDiff(oldText, newText, options.granularity);
    if (!useWord && options.granularity == DiffGranularity.auto) {
      // Auto decided to skip intra-line for this long line.
      return line;
    }

    if (options.granularity == DiffGranularity.character) {
      final r = _charEngine.computeSegments(
        oldText: oldText,
        newText: newText,
        caseSensitive: options.caseSensitive,
      );
      return line.copyWith(
        oldSegments: r.oldSegments,
        newSegments: r.newSegments,
      );
    } else {
      // word or auto (where useWord == true)
      final r = _wordEngine.computeSegments(
        oldText: oldText,
        newText: newText,
        caseSensitive: options.caseSensitive,
      );
      return line.copyWith(
        oldSegments: r.oldSegments,
        newSegments: r.newSegments,
      );
    }
  }

  /// Returns `true` when intra-line word diff should be applied for this line.
  ///
  /// For [DiffGranularity.auto]: skips word diff on lines longer than
  /// [DiffConstants.longLineThreshold] characters.
  bool _shouldUseWordDiff(
    String oldText,
    String newText,
    DiffGranularity granularity,
  ) {
    if (granularity == DiffGranularity.auto) {
      final maxLen =
          oldText.length > newText.length ? oldText.length : newText.length;
      return maxLen <= DiffConstants.longLineThreshold;
    }
    // For explicit word or character, always apply.
    return granularity == DiffGranularity.word ||
        granularity == DiffGranularity.character;
  }
}
