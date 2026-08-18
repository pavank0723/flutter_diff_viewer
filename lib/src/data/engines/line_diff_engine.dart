import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/diff_line.dart';
import '../../domain/enums/diff_type.dart';

/// Internal result type from the Myers diff algorithm.
///
/// Represents a single operation in the edit script.
enum _EditOp { equal, insert, delete }

/// Internal record binding an edit operation to its text.
class _Edit {
  final _EditOp op;
  final String text;
  const _Edit(this.op, this.text);
}

/// Line-level diff engine using the Myers O(ND) shortest-edit-script algorithm.
///
/// Computes the minimum-edit diff between two sequences of lines. Adjacent
/// [_EditOp.delete] + [_EditOp.insert] pairs are promoted to
/// [DiffType.modified] lines so callers can apply intra-line highlighting.
///
/// This engine performs **no** intra-line highlighting — that is delegated to
/// [WordDiffEngine] and [CharacterDiffEngine].
///
/// ### Algorithm Reference
/// E. W. Myers, "An O(ND) Difference Algorithm and Its Variations",
/// Algorithmica, 1986.
class LineDiffEngine {
  /// Creates a [LineDiffEngine].
  const LineDiffEngine();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Computes a line-level diff between [oldContent] and [newContent].
  ///
  /// [ignoreWhitespace] trims each line before comparison but keeps the
  /// original raw text in the returned [DiffLine]s.
  /// [caseSensitive] controls whether comparison is case-sensitive.
  ///
  /// Returns an ordered list of [DiffLine]s representing the full diff.
  List<DiffLine> computeLines({
    required String oldContent,
    required String newContent,
    bool ignoreWhitespace = false,
    bool caseSensitive = true,
  }) {
    final oldLines = oldContent.toLines();
    final newLines = newContent.toLines();

    if (oldLines.isEmpty && newLines.isEmpty) return const [];

    // Normalise for comparison only — raw text is preserved for display.
    final oldKeys = _normalise(oldLines, ignoreWhitespace, caseSensitive);
    final newKeys = _normalise(newLines, ignoreWhitespace, caseSensitive);

    final edits = _myersDiff(oldKeys, newKeys);
    return _buildDiffLines(oldLines, newLines, edits);
  }

  // ---------------------------------------------------------------------------
  // Normalisation helpers
  // ---------------------------------------------------------------------------

  List<String> _normalise(
    List<String> lines,
    bool ignoreWs,
    bool caseSensitive,
  ) {
    return lines.map((l) {
      var s = l;
      if (ignoreWs) s = s.trim();
      if (!caseSensitive) s = s.toLowerCase();
      return s;
    }).toList(growable: false);
  }

  // ---------------------------------------------------------------------------
  // Myers O(ND) diff algorithm
  // ---------------------------------------------------------------------------

  /// Runs LCS edit script on [a] vs [b].
  ///
  /// Returns a flat list of [_Edit]s representing the full diff in order.
  List<_Edit> _myersDiff(List<String> a, List<String> b) {
    final n = a.length;
    final m = b.length;

    if (n == 0 && m == 0) return const [];
    if (n == 0) return [for (final s in b) _Edit(_EditOp.insert, s)];
    if (m == 0) return [for (final s in a) _Edit(_EditOp.delete, s)];

    final dp = List.generate(
      n + 1,
      (_) => List<int>.filled(m + 1, 0),
      growable: false,
    );

    for (var i = 1; i <= n; i++) {
      for (var j = 1; j <= m; j++) {
        if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1] + 1;
        } else {
          dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
        }
      }
    }

    final edits = <_Edit>[];
    var i = n;
    var j = m;

    while (i > 0 || j > 0) {
      if (i > 0 && j > 0 && a[i - 1] == b[j - 1]) {
        edits.add(_Edit(_EditOp.equal, a[i - 1]));
        i--;
        j--;
      } else if (i > 0 && (j == 0 || dp[i - 1][j] >= dp[i][j - 1])) {
        edits.add(_Edit(_EditOp.delete, a[i - 1]));
        i--;
      } else {
        edits.add(_Edit(_EditOp.insert, b[j - 1]));
        j--;
      }
    }

    return edits.reversed.toList(growable: false);
  }

  // ---------------------------------------------------------------------------
  // DiffLine assembly
  // ---------------------------------------------------------------------------

  /// Converts raw edits into [DiffLine] entities, merging adjacent
  /// delete+insert pairs into [DiffType.modified] entries.
  List<DiffLine> _buildDiffLines(
    List<String> oldLines,
    List<String> newLines,
    List<_Edit> edits,
  ) {
    // Expand edits back to indexed lines using pointers into original arrays.
    // We re-derive line numbers from position pointers.
    int oldIdx = 0;
    int newIdx = 0;

    // First, build a raw list associating each edit with its source text.
    // Because _myersDiff works on normalised keys but we want raw text,
    // we use the original arrays indexed by pointers.
    final rawEdits = <({_EditOp op, String text})>[];
    for (final edit in edits) {
      switch (edit.op) {
        case _EditOp.equal:
          rawEdits.add((op: _EditOp.equal, text: oldLines[oldIdx]));
          oldIdx++;
          newIdx++;
        case _EditOp.delete:
          rawEdits.add((op: _EditOp.delete, text: oldLines[oldIdx]));
          oldIdx++;
        case _EditOp.insert:
          rawEdits.add((op: _EditOp.insert, text: newLines[newIdx]));
          newIdx++;
      }
    }

    // Second pass: merge adjacent delete+insert → modified.
    final result = <DiffLine>[];
    int i = 0;
    int oldNum = 1;
    int newNum = 1;

    while (i < rawEdits.length) {
      final current = rawEdits[i];

      // Look for a delete immediately followed by an insert → modified pair.
      if (current.op == _EditOp.delete &&
          i + 1 < rawEdits.length &&
          rawEdits[i + 1].op == _EditOp.insert) {
        final next = rawEdits[i + 1];
        result.add(
          DiffLine(
            oldLineNumber: oldNum++,
            newLineNumber: newNum++,
            oldText: current.text,
            newText: next.text,
            type: DiffType.modified,
          ),
        );
        i += 2;
        continue;
      }

      switch (current.op) {
        case _EditOp.equal:
          result.add(
            DiffLine(
              oldLineNumber: oldNum++,
              newLineNumber: newNum++,
              oldText: current.text,
              newText: current.text,
              type: DiffType.unchanged,
            ),
          );
        case _EditOp.delete:
          result.add(
            DiffLine(
              oldLineNumber: oldNum++,
              oldText: current.text,
              type: DiffType.removed,
            ),
          );
        case _EditOp.insert:
          result.add(
            DiffLine(
              newLineNumber: newNum++,
              newText: current.text,
              type: DiffType.added,
            ),
          );
      }
      i++;
    }

    return result;
  }
}
