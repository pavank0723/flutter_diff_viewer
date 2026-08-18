import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/diff_segment.dart';
import '../../domain/enums/diff_type.dart';

/// LCS-based character-level intra-line diff engine.
///
/// Identical in structure to [WordDiffEngine] but operates on individual
/// **Unicode characters** rather than word tokens.
///
/// Character-level diff is the most granular option and is ideal for:
/// - Short lines (e.g. identifiers, single words)
/// - Detecting minimal edits within words
///
/// For long lines, prefer [WordDiffEngine] to avoid O(n²) cost.
///
/// Pure Dart — no Flutter or Material imports.
class CharacterDiffEngine {
  /// Creates a [CharacterDiffEngine].
  const CharacterDiffEngine();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Computes character-level segment lists for an old/new line pair.
  ///
  /// Returns a record with two lists:
  /// - [oldSegments]: segments describing the old side character by character.
  /// - [newSegments]: segments describing the new side character by character.
  ///
  /// Adjacent segments of the same type are **merged** to reduce the number
  /// of segments and improve rendering performance.
  ({List<DiffSegment> oldSegments, List<DiffSegment> newSegments})
      computeSegments({
    required String oldText,
    required String newText,
    bool caseSensitive = true,
  }) {
    final oldChars = oldText.toCharacters();
    final newChars = newText.toCharacters();

    return _buildSegments(oldChars, newChars, caseSensitive: caseSensitive);
  }

  // ---------------------------------------------------------------------------
  // Core LCS + segment builder
  // ---------------------------------------------------------------------------

  ({List<DiffSegment> oldSegments, List<DiffSegment> newSegments})
      _buildSegments(
    List<String> a,
    List<String> b, {
    required bool caseSensitive,
  }) {
    if (a.isEmpty && b.isEmpty) {
      return (oldSegments: const [], newSegments: const []);
    }
    if (a.isEmpty) {
      return (
        oldSegments: const [],
        newSegments: [DiffSegment(text: b.join(), type: DiffType.added)],
      );
    }
    if (b.isEmpty) {
      return (
        oldSegments: [DiffSegment(text: a.join(), type: DiffType.removed)],
        newSegments: const [],
      );
    }

    final dp = _computeLcs(a, b, caseSensitive: caseSensitive);
    final (oldRaw, newRaw) = _backtrack(a, b, dp);
    return (oldSegments: _merge(oldRaw), newSegments: _merge(newRaw));
  }

  /// Builds the LCS DP table for character sequences [a] and [b].
  List<List<int>> _computeLcs(
    List<String> a,
    List<String> b, {
    required bool caseSensitive,
  }) {
    final n = a.length;
    final m = b.length;
    final dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));

    for (var i = 1; i <= n; i++) {
      for (var j = 1; j <= m; j++) {
        final ai = caseSensitive ? a[i - 1] : a[i - 1].toLowerCase();
        final bj = caseSensitive ? b[j - 1] : b[j - 1].toLowerCase();
        if (ai == bj) {
          dp[i][j] = dp[i - 1][j - 1] + 1;
        } else {
          dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
        }
      }
    }
    return dp;
  }

  /// Backtracks the DP table to recover per-character segments (unmerged).
  (List<DiffSegment> old, List<DiffSegment> newSegs) _backtrack(
    List<String> a,
    List<String> b,
    List<List<int>> dp,
  ) {
    final oldSegs = <DiffSegment>[];
    final newSegs = <DiffSegment>[];
    final ops = <({String text, _CharOp op})>[];

    var i = a.length;
    var j = b.length;

    while (i > 0 || j > 0) {
      if (i > 0 && j > 0 && a[i - 1] == b[j - 1]) {
        ops.add((text: a[i - 1], op: _CharOp.equal));
        i--;
        j--;
      } else if (j > 0 && (i == 0 || dp[i][j - 1] >= dp[i - 1][j])) {
        ops.add((text: b[j - 1], op: _CharOp.insert));
        j--;
      } else {
        ops.add((text: a[i - 1], op: _CharOp.delete));
        i--;
      }
    }

    for (final op in ops.reversed) {
      switch (op.op) {
        case _CharOp.equal:
          oldSegs.add(DiffSegment(text: op.text, type: DiffType.unchanged));
          newSegs.add(DiffSegment(text: op.text, type: DiffType.unchanged));
        case _CharOp.delete:
          oldSegs.add(DiffSegment(text: op.text, type: DiffType.removed));
        case _CharOp.insert:
          newSegs.add(DiffSegment(text: op.text, type: DiffType.added));
      }
    }

    return (oldSegs, newSegs);
  }

  // ---------------------------------------------------------------------------
  // Merge adjacent same-type segments
  // ---------------------------------------------------------------------------

  /// Merges consecutive [DiffSegment]s with the same [DiffType] to reduce
  /// the total number of segments.
  List<DiffSegment> _merge(List<DiffSegment> raw) {
    if (raw.isEmpty) return const [];

    final merged = <DiffSegment>[];
    var buf = StringBuffer(raw.first.text);
    var currentType = raw.first.type;

    for (var k = 1; k < raw.length; k++) {
      final seg = raw[k];
      if (seg.type == currentType) {
        buf.write(seg.text);
      } else {
        merged.add(DiffSegment(text: buf.toString(), type: currentType));
        buf = StringBuffer(seg.text);
        currentType = seg.type;
      }
    }
    merged.add(DiffSegment(text: buf.toString(), type: currentType));
    return merged;
  }
}

/// Internal operation type for character-level backtracking.
enum _CharOp { equal, insert, delete }
