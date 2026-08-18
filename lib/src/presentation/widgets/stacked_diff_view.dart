import 'package:flutter/material.dart';

import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_type.dart';
import '../builders/diff_builders.dart';
import '../configuration/diff_viewer_configuration.dart';
import '../controllers/diff_viewer_controller.dart';
import 'collapsed_section_widget.dart';
import 'diff_line_widget.dart';

/// Renders a stacked diff view (old content above, new content below).
///
/// Optimized for narrow screens and mobile devices where side-by-side is not
/// practical. Each panel has its own scrollable list.
///
/// Unlike [SideBySideDiffView], the two panels are NOT synchronized —
/// they scroll independently for better mobile UX.
class StackedDiffView extends StatelessWidget {
  /// The diff result to render.
  final DiffResult result;

  /// The configuration controlling layout and appearance.
  final DiffViewerConfiguration configuration;

  /// The controller managing state.
  final DiffViewerController controller;

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

  /// Creates a [StackedDiffView].
  const StackedDiffView({
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
    final theme = configuration.theme;
    final spacing = configuration.spacing;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final items = _buildItems();

        return Column(
          children: [
            // Old content panel
            Expanded(
              child: _StackedPanel(
                items: items,
                isOldSide: true,
                configuration: configuration,
                controller: controller,
                lineBuilder: lineBuilder,
                lineNumberBuilder: lineNumberBuilder,
                indicatorBuilder: indicatorBuilder,
                segmentBuilder: segmentBuilder,
                collapsedSectionBuilder: collapsedSectionBuilder,
              ),
            ),
            // Horizontal divider
            Container(height: spacing.borderWidth, color: theme.dividerColor),
            // New content panel
            Expanded(
              child: _StackedPanel(
                items: items,
                isOldSide: false,
                configuration: configuration,
                controller: controller,
                lineBuilder: lineBuilder,
                lineNumberBuilder: lineNumberBuilder,
                indicatorBuilder: indicatorBuilder,
                segmentBuilder: segmentBuilder,
                collapsedSectionBuilder: collapsedSectionBuilder,
              ),
            ),
          ],
        );
      },
    );
  }

  List<_StackedItem> _buildItems() {
    final items = <_StackedItem>[];
    final contextLines = configuration.contextLines;

    final visibleUnchangedIndices = <int>{};
    if (configuration.collapseUnchangedLines) {
      for (var i = 0; i < result.lines.length; i++) {
        if (result.lines[i].type != DiffType.unchanged) {
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
        final blockStart = i;
        while (i < result.lines.length &&
            result.lines[i].type == DiffType.unchanged &&
            !visibleUnchangedIndices.contains(i)) {
          i++;
        }
        items.add(_CollapsedStackedItem(blockStart, i - blockStart));
      } else {
        items.add(_LineStackedItem(i, line));
        i++;
      }
    }
    return items;
  }
}

class _StackedPanel extends StatelessWidget {
  final List<_StackedItem> items;
  final bool isOldSide;
  final DiffViewerConfiguration configuration;
  final DiffViewerController controller;
  final DiffLineBuilder? lineBuilder;
  final DiffLineNumberBuilder? lineNumberBuilder;
  final DiffIndicatorBuilder? indicatorBuilder;
  final DiffSegmentBuilder? segmentBuilder;
  final DiffCollapsedSectionBuilder? collapsedSectionBuilder;

  const _StackedPanel({
    required this.items,
    required this.isOldSide,
    required this.configuration,
    required this.controller,
    this.lineBuilder,
    this.lineNumberBuilder,
    this.indicatorBuilder,
    this.segmentBuilder,
    this.collapsedSectionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: isOldSide
          ? controller.leftScrollController
          : controller.rightScrollController,
      itemCount: items.length,
      itemExtent: configuration.spacing.lineHeight,
      itemBuilder: (context, index) {
        final item = items[index];

        if (item is _CollapsedStackedItem) {
          if (collapsedSectionBuilder != null) {
            return collapsedSectionBuilder!(
              context,
              item.lineCount,
              () => controller.expandSection(item.lineIndex),
              configuration,
            );
          }
          return CollapsedSectionWidget(
            collapsedLineCount: item.lineCount,
            onExpand: () => controller.expandSection(item.lineIndex),
            configuration: configuration,
          );
        }

        final lineItem = item as _LineStackedItem;
        if (lineBuilder != null) {
          return lineBuilder!(context, lineItem.line, configuration);
        }
        return DiffLineWidget(
          key: ValueKey('${isOldSide ? 'old' : 'new'}_${lineItem.lineIndex}'),
          line: lineItem.line,
          isOldSide: isOldSide,
          configuration: configuration,
          lineNumberBuilder: lineNumberBuilder,
          indicatorBuilder: indicatorBuilder,
          segmentBuilder: segmentBuilder,
        );
      },
    );
  }
}

sealed class _StackedItem {}

final class _LineStackedItem extends _StackedItem {
  final int lineIndex;
  final DiffLine line;
  _LineStackedItem(this.lineIndex, this.line);
}

final class _CollapsedStackedItem extends _StackedItem {
  final int lineIndex;
  final int lineCount;
  _CollapsedStackedItem(this.lineIndex, this.lineCount);
}
