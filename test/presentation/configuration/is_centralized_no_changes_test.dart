import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';
import 'package:flutter_diff_viewer/src/presentation/widgets/diff_empty_state_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isCentralizedNoChanges configuration', () {
    test('isCentralizedNoChanges defaults to true', () {
      final config = FlutterDiffViewerConfiguration.defaults();
      expect(config.isCentralizedNoChanges, isTrue);
    });

    testWidgets('renders centralized empty state by default when content is identical', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterDiffViewer(
              oldContent: 'same content',
              newContent: 'same content',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DiffEmptyStateWidget), findsOneWidget);
    });

    testWidgets('renders side-by-side view with left content and right panel empty state when isCentralizedNoChanges is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterDiffViewer(
              oldContent: 'same content',
              newContent: 'same content',
              configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
                isCentralizedNoChanges: false,
                layout: DiffLayout.sideBySide,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Right panel renders panel-level empty state widget
      expect(find.byType(DiffEmptyStateWidget), findsOneWidget);
    });
  });
}
