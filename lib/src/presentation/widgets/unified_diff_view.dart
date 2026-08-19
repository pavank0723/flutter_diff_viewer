import 'package:flutter/material.dart';

import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_type.dart';
import '../builders/diff_builders.dart';
import '../configuration/diff_viewer_configuration.dart';
import '../controllers/diff_viewer_controller.dart';
import 'collapsed_section_widget.dart';
import 'diff_line_widget.dart';

/// A helper for building the list of items in a view, handling collapsed sections.
///
/// Encapsulates the logic that groups consecutive unchanged lines into
/// collapsible blocks, inserting [CollapsedSectionWidget]s in their place.
List<_DiffViewItem> _buildViewItems({
  required DiffResult result,
  required FlutterDiffViewerConfiguration configuration,
  required Set<int> collapsedIndices,
}) {
  final items = <_DiffViewItem>[];
  final contextLines = configuration.contextLines;

  // Determine which unchanged line indices should be visible
  // (within contextLines of a change).
  final visibleUnchangedIndices = <int>{};
  if (configuration.collapseUnchangedLines) {
    for (var i = 0; i < result.lines.length; i++) {
      if (result.lines[i].type != DiffType.unchanged) {
        // Mark context lines around this change as visible
        for (var c = i - contextLines; c <= i + contextLines; c++) {
          if (c >= 0 && c < result.lines.length) {
            visibleUnchangedIndices.add(c);
          }
        }
      }
    }
  }

  var i = 0;
  while (i < result.lines.length) {
    final line = result.lines[i];

    if (configuration.collapseUnchangedLines &&
        line.type == DiffType.unchanged &&
        !visibleUnchangedIndices.contains(i)) {
      // Start of a collapsed block — find its end
      final blockStart = i;
      while (i < result.lines.length &&
          result.lines[i].type == DiffType.unchanged &&
          !visibleUnchangedIndices.contains(i)) {
        i++;
      }
      final collapsedCount = i - blockStart;
      if (collapsedCount > 0) {
        items.add(
          _CollapsedItem(lineIndex: blockStart, lineCount: collapsedCount),
        );
      }
    } else {
      items.add(_LineItem(lineIndex: i, line: line));
      i++;
    }
  }
  return items;
}

sealed class _DiffViewItem {}

final class _LineItem extends _DiffViewItem {
  final int lineIndex;
  final DiffLine line;
  _LineItem({required this.lineIndex, required this.line});
}

final class _CollapsedItem extends _DiffViewItem {
  final int lineIndex;
  final int lineCount;
  _CollapsedItem({required this.lineIndex, required this.lineCount});
}

/// Renders a unified diff view (single column, +/- indicators).
///
/// Each changed line appears once with its indicator. The unified view works
/// well on any screen width including mobile.
///
/// Uses [ListView.builder] for virtual rendering — efficient for large diffs.
class UnifiedDiffView extends StatelessWidget {
  /// The diff result to render.
  final DiffResult result;

  /// The configuration controlling layout and appearance.
  final FlutterDiffViewerConfiguration configuration;

  /// The controller for scroll state management.
  final FlutterDiffViewerController controller;

  /// Optional custom line builder.
  final DiffLineBuilder? lineBuilder;

  /// Optional custom line number builder.
  final DiffLineNumberBuilder? lineNumberBuilder;

  /// Optional custom indicator builder.
  final DiffIndicatorBuilder? indicatorBuilder;

  /// Optional custom segment builder.
  final DiffSegmentBuilder? segmentBuilder;

  /// Optional custom collapsed section builder.
  final DiffCollapsedSectionBuilder? collapsedSectionBuilder;

  /// Creates a [UnifiedDiffView].
  const UnifiedDiffView({
    required this.result,
    required this.configuration,
    required this.controller,
    super.key,
    this.lineBuilder,
    this.lineNumberBuilder,
    this.indicatorBuilder,
    this.segmentBuilder,
    this.collapsedSectionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final items = _buildViewItems(
          result: result,
          configuration: configuration,
          collapsedIndices: controller.collapsedLineIndices,
        );

        return ListView.builder(
          controller: controller.primaryScrollController,
          itemCount: items.length,
          itemExtent: configuration.spacing.lineHeight,
          itemBuilder: (context, index) {
            final item = items[index];

            switch (item) {
              case _CollapsedItem(:final lineIndex, :final lineCount):
                if (collapsedSectionBuilder != null) {
                  return collapsedSectionBuilder!(
                    context,
                    lineCount,
                    () => controller.expandSection(lineIndex),
                    configuration,
                  );
                }
                return CollapsedSectionWidget(
                  collapsedLineCount: lineCount,
                  onExpand: () => controller.expandSection(lineIndex),
                  configuration: configuration,
                );

              case _LineItem(:final line):
                if (lineBuilder != null) {
                  return lineBuilder!(context, line, configuration);
                }
                return DiffLineWidget(
                  key: ValueKey('unified_${item.lineIndex}'),
                  line: line,
                  configuration: configuration,
                  lineNumberBuilder: lineNumberBuilder,
                  indicatorBuilder: indicatorBuilder,
                  segmentBuilder: segmentBuilder,
                );
            }
          },
        );
      },
    );
  }
}
