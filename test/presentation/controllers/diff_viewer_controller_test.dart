import 'package:flutter_diff_viewer/src/core/exceptions/diff_exceptions.dart';
import 'package:flutter_diff_viewer/src/domain/entities/diff_line.dart';
import 'package:flutter_diff_viewer/src/domain/entities/diff_result.dart';
import 'package:flutter_diff_viewer/src/domain/enums/diff_type.dart';
import 'package:flutter_diff_viewer/src/presentation/controllers/diff_viewer_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterDiffViewerController', () {
    late FlutterDiffViewerController controller;

    setUp(() {
      controller = FlutterDiffViewerController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state is idle', () {
      expect(controller.state, equals(FlutterDiffViewerState.idle));
      expect(controller.totalChanges, equals(0));
    });

    test('setLoading sets loading state', () {
      controller.setLoading();
      expect(controller.state, equals(FlutterDiffViewerState.loading));
    });

    test('setError sets error state', () {
      const exception = DiffCalculationException('Error');
      controller.setError(exception);
      expect(controller.state, equals(FlutterDiffViewerState.error));
      expect(controller.error, equals(exception));
    });

    test('setResult extracts changes and updates state', () {
      const result = DiffResult(
        lines: [
          DiffLine(
              oldLineNumber: 1,
              newLineNumber: 1,
              oldText: 'a',
              newText: 'a',
              type: DiffType.unchanged),
          DiffLine(oldLineNumber: 2, oldText: 'b', type: DiffType.removed),
          DiffLine(newLineNumber: 2, newText: 'c', type: DiffType.added),
          DiffLine(
              oldLineNumber: 3,
              newLineNumber: 3,
              oldText: 'd',
              newText: 'd',
              type: DiffType.unchanged),
        ],
        additions: 1,
        deletions: 1,
        modifications: 0,
        unchanged: 2,
        oldLineCount: 3,
        newLineCount: 3,
      );

      controller.setResult(result);
      expect(controller.state, equals(FlutterDiffViewerState.loaded));
      expect(controller.totalChanges, equals(1));
      expect(controller.currentChangeIndex, equals(0));
    });

    test('goToChange throws out of bounds exception for invalid index', () {
      const result = DiffResult.empty();
      controller.setResult(result);

      expect(() => controller.goToChange(0),
          throwsA(isA<DiffIndexOutOfBoundsException>()));
    });
  });
}
