import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp({
    required String oldContent,
    required String newContent,
    FlutterDiffViewerConfiguration? configuration,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: FlutterDiffViewer(
          oldContent: oldContent,
          newContent: newContent,
          configuration: configuration,
        ),
      ),
    );
  }

  group('Highlight Whitespace and Unified Horizontal Scrolling', () {
    testWidgets('highlights added whitespace with middle dots when enabled',
        (WidgetTester tester) async {
      final config = FlutterDiffViewerConfiguration.defaults().copyWith(
        highlightWhitespace: true,
        layout: DiffLayout.unified,
      );

      await tester.pumpWidget(
        buildApp(
          oldContent: 'hello world',
          newContent: 'hello   world',
          configuration: config,
        ),
      );

      await tester.pumpAndSettle();

      // Expect to find middle dots for added spaces in segment
      expect(find.textContaining('·'), findsWidgets);
    });

    testWidgets('does not replace added whitespace with middle dots when disabled',
        (WidgetTester tester) async {
      final config = FlutterDiffViewerConfiguration.defaults().copyWith(
        highlightWhitespace: false,
        layout: DiffLayout.unified,
      );

      await tester.pumpWidget(
        buildApp(
          oldContent: 'hello world',
          newContent: 'hello   world',
          configuration: config,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('·'), findsNothing);
    });

    testWidgets('renders diff viewer with horizontal scroll container across all lines',
        (WidgetTester tester) async {
      final config = FlutterDiffViewerConfiguration.defaults().copyWith(
        layout: DiffLayout.sideBySide,
      );

      await tester.pumpWidget(
        buildApp(
          oldContent: 'short line',
          newContent: 'a very long line that requires horizontal scrolling across the entire panel view',
          configuration: config,
        ),
      );

      await tester.pumpAndSettle();

      final horizontalScrolls = find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal,
      );

      expect(horizontalScrolls, findsWidgets);
    });
  });
}
