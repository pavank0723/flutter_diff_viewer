import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/diff_segment.dart';
import '../../domain/enums/diff_type.dart';

/// LCS-based word-level intra-line diff engine.
///
/// Given the old and new text of a single **modified** line, this engine:
/// 1. Tokenises each string into word + whitespace tokens via [toWords].
/// 2. Runs an LCS (Longest Common Subsequence) algorithm to find matching
///    tokens.
/// 3. Builds two parallel [DiffSegment] lists — one for the old side and one
///    for the new side — suitable for inline highlighting.
///
/// Only [DiffType.unchanged], [DiffType.removed], and [DiffType.added] are
/// used at the segment level (never [DiffType.modified]).
///
/// Pure Dart — no Flutter or Material imports.
class WordDiffEngine {
  /// Creates a [WordDiffEngine].
  const WordDiffEngine();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Computes word-level segment lists for an old/new line pair.
  ///
  /// Returns a record with two lists:
  /// - [oldSegments]: segments describing the old side.
  /// - [newSegments]: segments describing the new side.
  ///
  /// Unchanged tokens appear on both sides; removed tokens only on the old
  /// side; added tokens only on the new side.
  ({List<DiffSegment> oldSegments, List<DiffSegment> newSegments})
      computeSegments({
    required String oldText,
    required String newText,
    bool caseSensitive = true,
  }) {
    final oldTokens = oldText.toWords();
    final newTokens = newText.toWords();

    return _buildSegments(oldTokens, newTokens, caseSensitive: caseSensitive);
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
        newSegments: b
            .map((t) => DiffSegment(text: t, type: DiffType.added))
            .toList(growable: false),
      );
    }
    if (b.isEmpty) {
      return (
        oldSegments: a
            .map((t) => DiffSegment(text: t, type: DiffType.removed))
            .toList(growable: false),
        newSegments: const [],
      );
    }

    final lcs = _computeLcs(a, b, caseSensitive: caseSensitive);
    return _segmentsFromLcs(a, b, lcs, caseSensitive: caseSensitive);
  }

  /// Computes the LCS length table using standard DP.
  ///
  /// Returns a 2D grid `dp[i][j]` = LCS length of `a[0..i-1]` and
  /// `b[0..j-1]`.
  List<List<int>> _computeLcs(
    List<String> a,
    List<String> b, {
    required bool caseSensitive,
  }) {
    final n = a.length;
    final m = b.length;

    // Allocate (n+1) x (m+1) matrix
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

  /// Backtracks through the LCS DP table to build segment lists.
  ({List<DiffSegment> oldSegments, List<DiffSegment> newSegments})
      _segmentsFromLcs(
    List<String> a,
    List<String> b,
    List<List<int>> dp, {
    required bool caseSensitive,
  }) {
    final oldSegs = <DiffSegment>[];
    final newSegs = <DiffSegment>[];

    var i = a.length;
    var j = b.length;

    // Collect operations in reverse order, then flip.
    final ops = <({String text, _SegOp op})>[];

    while (i > 0 || j > 0) {
      final match = i > 0 &&
          j > 0 &&
          (caseSensitive
              ? a[i - 1] == b[j - 1]
              : a[i - 1].toLowerCase() == b[j - 1].toLowerCase());
      if (match) {
        ops.add((text: a[i - 1], op: _SegOp.equal));
        i--;
        j--;
      } else if (i > 0 && (j == 0 || dp[i - 1][j] >= dp[i][j - 1])) {
        ops.add((text: a[i - 1], op: _SegOp.delete));
        i--;
      } else {
        ops.add((text: b[j - 1], op: _SegOp.insert));
        j--;
      }
    }

    for (final op in ops.reversed) {
      switch (op.op) {
        case _SegOp.equal:
          oldSegs.add(DiffSegment(text: op.text, type: DiffType.unchanged));
          newSegs.add(DiffSegment(text: op.text, type: DiffType.unchanged));
        case _SegOp.delete:
          oldSegs.add(DiffSegment(text: op.text, type: DiffType.removed));
        case _SegOp.insert:
          newSegs.add(DiffSegment(text: op.text, type: DiffType.added));
      }
    }

    return (oldSegments: oldSegs, newSegments: newSegs);
  }
}

/// Internal operation type used during LCS backtracking.
enum _SegOp { equal, insert, delete }
