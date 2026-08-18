import 'package:flutter_diff_viewer/src/data/engines/diff_engine.dart';
import 'package:flutter_diff_viewer/src/data/repositories/diff_repository_impl.dart';
import 'package:flutter_diff_viewer/src/domain/entities/diff_result.dart';
import 'package:flutter_diff_viewer/src/domain/value_objects/diff_comparison_options.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDiffEngine implements DiffEngine {
  DiffResult? returnValue;

  @override
  DiffResult compare(
      String oldContent, String newContent, DiffComparisonOptions options) {
    return returnValue ?? const DiffResult.empty();
  }
}

void main() {
  group('DiffRepositoryImpl', () {
    test('compares using provided engine', () async {
      final engine = MockDiffEngine();
      final repository = DiffRepositoryImpl(engine: engine);

      final result = await repository.compare(
        oldContent: 'old',
        newContent: 'new',
        options: const DiffComparisonOptions(),
      );

      expect(result, equals(const DiffResult.empty()));
    });
  });
}
