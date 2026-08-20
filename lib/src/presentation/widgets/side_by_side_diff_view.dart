import 'package:flutter/material.dart';

import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_type.dart';
import '../builders/diff_builders.dart';
import '../configuration/diff_viewer_configuration.dart';
import '../controllers/diff_viewer_controller.dart';
import 'collapsed_section_widget.dart';
import 'diff_header.dart';
import 'diff_line_widget.dart';

/// Renders a side-by-side diff view with synchronized scrolling.
///
/// Displays old content on the left panel and new content on the right panel,
/// with corresponding lines aligned. Both panels scroll in sync.
///
/// Supports classic unified frame mode and split dual-card panel mode with
/// customizable in-between gap ([DiffSpacing.panelSpacing]).
class SideBySideDiffView extends StatelessWidget {
  /// The diff result to render.
  final DiffResult result;

  /// The configuration controlling layout and appearance.
  final FlutterDiffViewerConfiguration configuration;

  /// The controller providing synchronized scroll controllers.
  final FlutterDiffViewerController controller;

  /// Optional label for the old (left) content panel.
  final String? oldLabel;

  /// Optional label for the new (right) content panel.
  final String? newLabel;

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
    this.oldLabel,
    this.newLabel,
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
    final isSplit = configuration.splitPanels || spacing.panelSpacing > 0;

    Widget wrapPanelCard({required bool isOldSide, required Widget child}) {
      if (!isSplit) return child;

      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.panelBackgroundColor,
          border: Border.all(
            color: theme.panelBorderColor,
            width: spacing.panelBorderWidth,
          ),
          borderRadius: BorderRadius.circular(spacing.panelBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (configuration.showHeader)
              DiffHeader(
                isSideBySide: true,
                configuration: configuration,
                oldLabel: oldLabel,
                newLabel: newLabel,
                isPanelCardHeader: true,
                isOldPanelHeader: isOldSide,
              ),
            Expanded(child: child),
          ],
        ),
      );
    }

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final items = _buildSideBySideItems(result, configuration, controller);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left panel (old content)
            Expanded(
              child: wrapPanelCard(
                isOldSide: true,
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
            ),
            // Divider line or Panel Gap
            if (isSplit)
              SizedBox(width: spacing.panelSpacing)
            else
              Container(width: spacing.dividerWidth, color: theme.dividerColor),
            // Right panel (new content)
            Expanded(
              child: wrapPanelCard(
                isOldSide: false,
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
  final FlutterDiffViewerConfiguration configuration;
  final DiffLineBuilder? lineBuilder;
  final DiffLineNumberBuilder? lineNumberBuilder;
  final DiffIndicatorBuilder? indicatorBuilder;
  final DiffSegmentBuilder? segmentBuilder;
  final DiffCollapsedSectionBuilder? collapsedSectionBuilder;
  final FlutterDiffViewerController controller;

  const _DiffPanel({
    required this.items,
    required this.isOldSide,
    required this.scrollController,
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
    return Container(
      color: configuration.theme.backgroundColor,
      child: Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            if (item.isCollapsedPlaceholder) {
              if (collapsedSectionBuilder != null) {
                return collapsedSectionBuilder!(
                  context,
                  item.collapsedCount,
                  () => controller.expandSection(item.collapsedStartIndex),
                  configuration,
                );
              }
              return CollapsedSectionWidget(
                collapsedLineCount: item.collapsedCount,
                configuration: configuration,
                onExpand: () {
                  controller.expandSection(item.collapsedStartIndex);
                },
              );
            }

            final line = isOldSide ? item.oldLine : item.newLine;

            if (line == null) {
              // Empty filler row (for line alignment when change exists only on opposite side)
              return SizedBox(
                height: configuration.spacing.lineHeight,
                child: Container(
                  color: configuration.theme.unchangedBackgroundColor,
                ),
              );
            }

            if (lineBuilder != null) {
              return lineBuilder!(context, line, configuration);
            }

            return DiffLineWidget(
              line: line,
              configuration: configuration,
              isOldSide: isOldSide,
              lineNumberBuilder: lineNumberBuilder,
              indicatorBuilder: indicatorBuilder,
              segmentBuilder: segmentBuilder,
            );
          },
        ),
      ),
    );
  }
}

/// Helper data class representing a single row item in side-by-side view.
class _SideBySideItem {
  final DiffLine? oldLine;
  final DiffLine? newLine;
  final bool isCollapsedPlaceholder;
  final int collapsedCount;
  final int collapsedStartIndex;

  const _SideBySideItem.line(this.oldLine, this.newLine)
      : isCollapsedPlaceholder = false,
        collapsedCount = 0,
        collapsedStartIndex = -1;

  const _SideBySideItem.collapsed(this.collapsedCount, this.collapsedStartIndex)
      : oldLine = null,
        newLine = null,
        isCollapsedPlaceholder = true;
}

/// Computes the aligned list of side-by-side row items from a [DiffResult].
List<_SideBySideItem> _buildSideBySideItems(
  DiffResult result,
  FlutterDiffViewerConfiguration configuration,
  FlutterDiffViewerController controller,
) {
  final items = <_SideBySideItem>[];
  final lines = result.lines;

  if (lines.isEmpty) return items;

  int i = 0;
  while (i < lines.length) {
    // Check for collapsed section
    if (configuration.collapseUnchangedLines && controller.isLineCollapsed(i)) {
      int count = 0;
      final startIdx = i;
      while (i < lines.length && controller.isLineCollapsed(i)) {
        count++;
        i++;
      }
      items.add(_SideBySideItem.collapsed(count, startIdx));
      continue;
    }

    final line = lines[i];

    if (line.type == DiffType.unchanged) {
      items.add(_SideBySideItem.line(line, line));
      i++;
    } else if (line.type == DiffType.modified) {
      items.add(_SideBySideItem.line(line, line));
      i++;
    } else if (line.type == DiffType.removed) {
      // Check if followed by added line (modified pair)
      if (i + 1 < lines.length && lines[i + 1].type == DiffType.added) {
        items.add(_SideBySideItem.line(line, lines[i + 1]));
        i += 2;
      } else {
        items.add(_SideBySideItem.line(line, null));
        i++;
      }
    } else if (line.type == DiffType.added) {
      items.add(_SideBySideItem.line(null, line));
      i++;
    }
  }

  return items;
}
