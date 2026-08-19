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

  group('FlutterDiffViewer Integration Test', () {
    testWidgets('renders diff viewer widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildApp(
          oldContent: 'Hello World',
          newContent: 'Hello Flutter',
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(FlutterDiffViewer), findsOneWidget);
    });

    testWidgets('renders empty state when content is identical',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildApp(
          oldContent: 'Same',
          newContent: 'Same',
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No changes'), findsOneWidget);
    });
  });
}
