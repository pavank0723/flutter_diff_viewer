import 'package:flutter_diff_viewer/src/domain/entities/diff_line.dart';
import 'package:flutter_diff_viewer/src/domain/entities/diff_segment.dart';
import 'package:flutter_diff_viewer/src/domain/enums/diff_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiffLine', () {
    test('creates with required type field', () {
      const line = DiffLine(type: DiffType.unchanged);
      expect(line.type, DiffType.unchanged);
      expect(line.oldLineNumber, isNull);
      expect(line.newLineNumber, isNull);
      expect(line.oldText, isNull);
      expect(line.newText, isNull);
      expect(line.oldSegments, isEmpty);
      expect(line.newSegments, isEmpty);
      expect(line.isCollapsed, isFalse);
    });

    test('creates added line correctly', () {
      const line = DiffLine(
        newLineNumber: 5,
        newText: 'new content',
        type: DiffType.added,
      );
      expect(line.isAdded, isTrue);
      expect(line.isRemoved, isFalse);
      expect(line.isModified, isFalse);
      expect(line.isUnchanged, isFalse);
      expect(line.oldLineNumber, isNull);
    });

    test('creates removed line correctly', () {
      const line = DiffLine(
        oldLineNumber: 3,
        oldText: 'old content',
        type: DiffType.removed,
      );
      expect(line.isRemoved, isTrue);
      expect(line.newLineNumber, isNull);
    });

    test('creates modified line with segments', () {
      const segments = [
        DiffSegment(text: 'Hello ', type: DiffType.unchanged),
        DiffSegment(text: 'World', type: DiffType.removed),
      ];
      const line = DiffLine(
        oldLineNumber: 1,
        newLineNumber: 1,
        oldText: 'Hello World',
        newText: 'Hello Dart',
        type: DiffType.modified,
        oldSegments: segments,
      );
      expect(line.isModified, isTrue);
      expect(line.hasSegments, isTrue);
      expect(line.oldSegments, hasLength(2));
    });

    test('hasSegments is false when no segments', () {
      const line = DiffLine(type: DiffType.modified);
      expect(line.hasSegments, isFalse);
    });

    test('copyWith replaces specified fields', () {
      const original = DiffLine(
        oldLineNumber: 1,
        type: DiffType.unchanged,
        isCollapsed: false,
      );
      final copy = original.copyWith(isCollapsed: true, type: DiffType.removed);
      expect(copy.oldLineNumber, 1);
      expect(copy.type, DiffType.removed);
      expect(copy.isCollapsed, isTrue);
    });

    test('equality is value-based', () {
      const a = DiffLine(oldLineNumber: 1, type: DiffType.unchanged);
      const b = DiffLine(oldLineNumber: 1, type: DiffType.unchanged);
      const c = DiffLine(oldLineNumber: 2, type: DiffType.unchanged);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('toString is human-readable', () {
      const line = DiffLine(
          oldLineNumber: 5, newLineNumber: 5, type: DiffType.unchanged);
      expect(line.toString(), contains('unchanged'));
      expect(line.toString(), contains('5'));
    });
  });
}
