import 'package:flutter/material.dart';

import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_type.dart';
import '../builders/diff_builders.dart';
import '../configuration/diff_viewer_configuration.dart';
import '../controllers/diff_viewer_controller.dart';
import 'collapsed_section_widget.dart';
import 'diff_line_widget.dart';

/// Renders a side-by-side diff view with synchronized scrolling.
///
/// Displays old content on the left panel and new content on the right panel,
/// with corresponding lines aligned. Both panels scroll in sync.
///
/// Uses two parallel [ListView.builder] instances for virtual rendering.
/// Scroll synchronization is managed by [DiffScrollSynchronizer] inside
/// [DiffViewerController].
class SideBySideDiffView extends StatelessWidget {
  /// The diff result to render.
  final DiffResult result;

  /// The configuration controlling layout and appearance.
  final DiffViewerConfiguration configuration;

  /// The controller providing synchronized scroll controllers.
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

  /// Creates a [SideBySideDiffView].
  const SideBySideDiffView({
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
        final items = _buildSideBySideItems(result, configuration, controller);

        return Row(
          children: [
            // Left panel (old content)
            Expanded(
              child: _DiffPanel(
                items: items,
                isOldSide: true,
                scrollController: controller.leftScrollController,
                configuration: configuration,
                lineBuilder: lineBuilder,
                lineNumberBuilder: lineNumberBuilder,
                indicatorBuilder: indicatorBuilder,
                segmentBuilder: segmentBuilder,
                collapsedSectionBuilder: collapsedSectionBuilder,
                controller: controller,
              ),
            ),
            // Vertical divider
            Container(width: spacing.dividerWidth, color: theme.dividerColor),
            // Right panel (new content)
            Expanded(
              child: _DiffPanel(
                items: items,
                isOldSide: false,
                scrollController: controller.rightScrollController,
                configuration: configuration,
                lineBuilder: lineBuilder,
                lineNumberBuilder: lineNumberBuilder,
                indicatorBuilder: indicatorBuilder,
                segmentBuilder: segmentBuilder,
                collapsedSectionBuilder: collapsedSectionBuilder,
                controller: controller,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A single panel (left or right) in the side-by-side view.
class _DiffPanel extends StatelessWidget {
  final List<_SideBySideItem> items;
  final bool isOldSide;
  final ScrollController scrollController;
  final DiffViewerConfiguration configuration;
  final DiffLineBuilder? lineBuilder;
  final DiffLineNumberBuilder? lineNumberBuilder;
  final DiffIndicatorBuilder? indicatorBuilder;
  final DiffSegmentBuilder? segmentBuilder;
  final DiffCollapsedSectionBuilder? collapsedSectionBuilder;
  final DiffViewerController controller;

  const _DiffPanel({
    required this.items,
    required this.isOldSide,
    required this.scrollController,
    required this.configuration,
    required this.lineBuilder,
    required this.lineNumberBuilder,
    required this.indicatorBuilder,
    required this.segmentBuilder,
    required this.collapsedSectionBuilder,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: items.length,
      itemExtent: configuration.spacing.lineHeight,
      itemBuilder: (context, index) {
        final item = items[index];

        if (item is _CollapsedSideBySideItem) {
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

        final lineItem = item as _LineSideBySideItem;
        if (lineBuilder != null) {
          return lineBuilder!(context, lineItem.line, configuration);
        }

        return DiffLineWidget(
          key: ValueKey(
            '${isOldSide ? 'left' : 'right'}_${lineItem.lineIndex}',
          ),
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

sealed class _SideBySideItem {}

final class _LineSideBySideItem extends _SideBySideItem {
  final int lineIndex;
  final DiffLine line;
  _LineSideBySideItem(this.lineIndex, this.line);
}

final class _CollapsedSideBySideItem extends _SideBySideItem {
  final int lineIndex;
  final int lineCount;
  _CollapsedSideBySideItem(this.lineIndex, this.lineCount);
}

List<_SideBySideItem> _buildSideBySideItems(
  DiffResult result,
  DiffViewerConfiguration configuration,
  DiffViewerController controller,
) {
  final items = <_SideBySideItem>[];
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
      final count = i - blockStart;
      if (count > 0) {
        items.add(_CollapsedSideBySideItem(blockStart, count));
      }
    } else {
      items.add(_LineSideBySideItem(i, line));
      i++;
    }
  }
  return items;
}
