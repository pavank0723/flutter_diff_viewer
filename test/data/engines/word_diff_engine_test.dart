import 'package:flutter_diff_viewer/src/data/engines/word_diff_engine.dart';
import 'package:flutter_diff_viewer/src/domain/entities/diff_segment.dart';
import 'package:flutter_diff_viewer/src/domain/enums/diff_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WordDiffEngine', () {
    const engine = WordDiffEngine();

    test('splits and identifies word-level additions and removals', () {
      final segments = engine.computeSegments(
        oldText: 'Hello World',
        newText: 'Hello Dart',
      );

      expect(segments.oldSegments, isNotEmpty);
      expect(segments.newSegments, isNotEmpty);

      final removed = segments.oldSegments
          .where((DiffSegment s) => s.type == DiffType.removed);
      final added = segments.newSegments
          .where((DiffSegment s) => s.type == DiffType.added);

      expect(removed.any((DiffSegment s) => s.text.contains('World')), isTrue);
      expect(added.any((DiffSegment s) => s.text.contains('Dart')), isTrue);
    });
  });
}
