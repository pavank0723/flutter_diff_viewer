import 'package:flutter_diff_viewer/src/domain/entities/diff_result.dart';
import 'package:flutter_diff_viewer/src/domain/repositories/diff_repository.dart';
import 'package:flutter_diff_viewer/src/domain/usecases/calculate_diff.dart';
import 'package:flutter_diff_viewer/src/domain/value_objects/diff_comparison_options.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDiffRepository implements DiffRepository {
  DiffResult? returnValue;
  String? capturedOld;
  String? capturedNew;
  DiffComparisonOptions? capturedOptions;

  @override
  Future<DiffResult> compare({
    required String oldContent,
    required String newContent,
    DiffComparisonOptions options = const DiffComparisonOptions(),
  }) async {
    capturedOld = oldContent;
    capturedNew = newContent;
    capturedOptions = options;
    return returnValue ?? const DiffResult.empty();
  }
}

void main() {
  group('CalculateDiff', () {
    test('delegates parameters to repository', () async {
      final repository = MockDiffRepository();
      final useCase = CalculateDiff(repository);
      const options = DiffComparisonOptions(ignoreWhitespace: true);

      final result = await useCase(
        oldContent: 'old text',
        newContent: 'new text',
        options: options,
      );

      expect(repository.capturedOld, equals('old text'));
      expect(repository.capturedNew, equals('new text'));
      expect(repository.capturedOptions, equals(options));
      expect(result, equals(const DiffResult.empty()));
    });
  });
}
