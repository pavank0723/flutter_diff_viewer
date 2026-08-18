import 'package:flutter_diff_viewer/src/domain/entities/diff_line.dart';
import 'package:flutter_diff_viewer/src/domain/entities/diff_result.dart';
import 'package:flutter_diff_viewer/src/domain/enums/diff_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiffResult', () {
    test('empty constructor creates result with zero values', () {
      const result = DiffResult.empty();

      expect(result.lines, isEmpty);
      expect(result.additions, equals(0));
      expect(result.deletions, equals(0));
      expect(result.modifications, equals(0));
      expect(result.unchanged, equals(0));
      expect(result.hasNoChanges, isTrue);
      expect(result.hasChanges, isFalse);
      expect(result.totalChanges, equals(0));
      expect(result.changedLines, isEmpty);
      expect(result.unchangedLines, isEmpty);
    });

    test('correctly evaluates hasChanges and totalChanges', () {
      const result = DiffResult(
        lines: [
          DiffLine(type: DiffType.added),
          DiffLine(type: DiffType.removed),
          DiffLine(type: DiffType.unchanged),
        ],
        additions: 1,
        deletions: 1,
        modifications: 0,
        unchanged: 1,
        oldLineCount: 2,
        newLineCount: 2,
      );

      expect(result.hasNoChanges, isFalse);
      expect(result.hasChanges, isTrue);
      expect(result.totalChanges, equals(2));
      expect(result.changedLines.length, equals(2));
      expect(result.unchangedLines.length, equals(1));
    });

    test('value equality and hashCode behave correctly', () {
      const result1 = DiffResult(
        lines: [],
        additions: 2,
        deletions: 1,
        modifications: 0,
        unchanged: 5,
        oldLineCount: 6,
        newLineCount: 7,
      );

      const result2 = DiffResult(
        lines: [],
        additions: 2,
        deletions: 1,
        modifications: 0,
        unchanged: 5,
        oldLineCount: 6,
        newLineCount: 7,
      );

      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
    });
  });
}
