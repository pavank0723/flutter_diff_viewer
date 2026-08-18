import 'package:flutter_diff_viewer/src/data/engines/default_diff_engine.dart';
import 'package:flutter_diff_viewer/src/domain/value_objects/diff_comparison_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DefaultDiffEngine', () {
    const engine = DefaultDiffEngine();

    test('identical text produces no changes', () {
      final result = engine.compare(
        'Hello World\nLine 2',
        'Hello World\nLine 2',
        const DiffComparisonOptions(),
      );

      expect(result.hasNoChanges, isTrue);
      expect(result.unchanged, equals(2));
    });

    test('detects addition and deletion', () {
      final result = engine.compare(
        'Line A\nLine B',
        'Line A\nLine C',
        const DiffComparisonOptions(),
      );

      expect(result.hasChanges, isTrue);
      expect(result.lines, isNotEmpty);
    });

    test('handles empty strings gracefully', () {
      final result = engine.compare('', '', const DiffComparisonOptions());
      expect(result.hasNoChanges, isTrue);

      final resultAdded =
          engine.compare('', 'Added', const DiffComparisonOptions());
      expect(resultAdded.additions, equals(1));
    });

    test('handles Unicode and emojis without error', () {
      final result = engine.compare(
        'नमस्ते 😀🎉',
        'नमस्ते 😀🚀',
        const DiffComparisonOptions(),
      );

      expect(result.lines, isNotEmpty);
    });
  });
}
