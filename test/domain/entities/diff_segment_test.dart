import 'package:flutter_diff_viewer/src/domain/entities/diff_segment.dart';
import 'package:flutter_diff_viewer/src/domain/enums/diff_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiffSegment', () {
    test('creates with required fields', () {
      const segment = DiffSegment(text: 'hello', type: DiffType.unchanged);
      expect(segment.text, 'hello');
      expect(segment.type, DiffType.unchanged);
    });

    test('isUnchanged returns true for unchanged type', () {
      const segment = DiffSegment(text: 'x', type: DiffType.unchanged);
      expect(segment.isUnchanged, isTrue);
      expect(segment.isAdded, isFalse);
      expect(segment.isRemoved, isFalse);
    });

    test('isAdded returns true for added type', () {
      const segment = DiffSegment(text: 'x', type: DiffType.added);
      expect(segment.isAdded, isTrue);
      expect(segment.isUnchanged, isFalse);
    });

    test('isRemoved returns true for removed type', () {
      const segment = DiffSegment(text: 'x', type: DiffType.removed);
      expect(segment.isRemoved, isTrue);
    });

    test('equality is value-based', () {
      const a = DiffSegment(text: 'hello', type: DiffType.added);
      const b = DiffSegment(text: 'hello', type: DiffType.added);
      const c = DiffSegment(text: 'world', type: DiffType.added);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('hashCode is consistent with equality', () {
      const a = DiffSegment(text: 'hello', type: DiffType.added);
      const b = DiffSegment(text: 'hello', type: DiffType.added);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('copyWith replaces specified fields', () {
      const original = DiffSegment(text: 'hello', type: DiffType.unchanged);
      final copy = original.copyWith(type: DiffType.removed);
      expect(copy.text, 'hello');
      expect(copy.type, DiffType.removed);
    });

    test('toString is human-readable', () {
      const segment = DiffSegment(text: 'hi', type: DiffType.added);
      expect(segment.toString(), contains('added'));
      expect(segment.toString(), contains('hi'));
    });

    test('handles long text in toString without crashing', () {
      final longText = 'a' * 100;
      final segment = DiffSegment(text: longText, type: DiffType.removed);
      expect(segment.toString(), isNotEmpty);
    });
  });
}
