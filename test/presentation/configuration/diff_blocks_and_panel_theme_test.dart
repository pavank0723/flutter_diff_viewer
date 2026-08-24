import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiffSpacing block parameters', () {
    test('default DiffSpacing has blockSpacing = 0.0', () {
      const spacing = DiffSpacing.defaults();
      expect(spacing.blockSpacing, equals(0.0));
      expect(spacing.blockBorderRadius, equals(4.0));
      expect(spacing.blockBorderWidth, equals(1.0));
      expect(spacing.blockPadding, equals(EdgeInsets.zero));
    });

    test('copyWith updates blockSpacing and block metrics', () {
      const spacing = DiffSpacing.defaults();
      final updated = spacing.copyWith(
        blockSpacing: 12.0,
        blockBorderRadius: 8.0,
        blockBorderWidth: 2.0,
        blockPadding: const EdgeInsets.all(8.0),
      );

      expect(updated.blockSpacing, equals(12.0));
      expect(updated.blockBorderRadius, equals(8.0));
      expect(updated.blockBorderWidth, equals(2.0));
      expect(updated.blockPadding, equals(const EdgeInsets.all(8.0)));
    });
  });

  group('FlutterDiffViewerTheme per-container and side-aware highlights', () {
    test('resolves default panel background when side overrides are null', () {
      final theme = FlutterDiffViewerTheme.light();
      expect(
        theme.resolvePanelBackgroundColor(isOldSide: true),
        equals(theme.panelBackgroundColor),
      );
      expect(
        theme.resolvePanelBackgroundColor(isOldSide: false),
        equals(theme.panelBackgroundColor),
      );
    });

    test('resolves distinct left and right container background colors when provided', () {
      const leftBg = Color(0xFFFAFAFA);
      const rightBg = Color(0xFFF0FDF4);
      final theme = FlutterDiffViewerTheme.light().copyWith(
        leftPanelBackgroundColor: leftBg,
        rightPanelBackgroundColor: rightBg,
      );

      expect(theme.resolvePanelBackgroundColor(isOldSide: true), equals(leftBg));
      expect(theme.resolvePanelBackgroundColor(isOldSide: false), equals(rightBg));
    });

    test('resolves distinct left and right diff highlight background colors', () {
      const leftAdded = Color(0xFFE0F2FE);
      const rightAdded = Color(0xFFDCFCE7);
      final theme = FlutterDiffViewerTheme.light().copyWith(
        leftAddedBackgroundColor: leftAdded,
        rightAddedBackgroundColor: rightAdded,
      );

      expect(theme.resolveAddedBackgroundColor(isOldSide: true), equals(leftAdded));
      expect(theme.resolveAddedBackgroundColor(isOldSide: false), equals(rightAdded));
    });
  });

  group('FlutterDiffViewer Widget with block gap and distinct container colors', () {
    testWidgets('renders side-by-side view with panel gaps and block gaps', (tester) async {
      const oldText = 'Line 1\nLine 2\nLine 3';
      const newText = 'Line 1\nLine 2 modified\nLine 3 added';

      const leftContainerBg = Color(0xFFF1F5F9);
      const rightContainerBg = Color(0xFFEFF6FF);

      final config = FlutterDiffViewerConfiguration.defaults().copyWith(
        layout: DiffLayout.sideBySide,
        splitPanels: true,
        splitBlocks: true,
        spacing: const DiffSpacing.defaults().copyWith(
          panelSpacing: 16.0,
          blockSpacing: 12.0,
        ),
        theme: FlutterDiffViewerTheme.light().copyWith(
          leftPanelBackgroundColor: leftContainerBg,
          rightPanelBackgroundColor: rightContainerBg,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterDiffViewer(
              oldContent: oldText,
              newContent: newText,
              configuration: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FlutterDiffViewer), findsOneWidget);
      expect(find.textContaining('Line 1'), findsWidgets);
    });
  });
}
