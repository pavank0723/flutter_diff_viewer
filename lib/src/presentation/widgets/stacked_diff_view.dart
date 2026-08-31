import 'package:flutter/material.dart';

import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_type.dart';
import '../builders/diff_builders.dart';
import '../configuration/diff_viewer_configuration.dart';
import '../controllers/diff_viewer_controller.dart';
import '../utils/horizontal_scroll_sync.dart';
import 'collapsed_section_widget.dart';
import 'diff_line_widget.dart';

/// Renders a stacked diff view (old content above, new content below).
class StackedDiffView extends StatelessWidget {
  /// The diff result to render.
  final DiffResult result;

  /// The configuration controlling layout and appearance.
  final FlutterDiffViewerConfiguration configuration;

  /// The controller managing state.
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

class _StackedPanel extends StatefulWidget {
  final List<_StackedItem> items;
  final bool isOldSide;
  final FlutterDiffViewerConfiguration configuration;
  final FlutterDiffViewerController controller;
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
  State<_StackedPanel> createState() => _StackedPanelState();
}

class _StackedPanelState extends State<_StackedPanel> {
  late final DiffHorizontalScrollSync _horizontalScrollSync;

  @override
  void initState() {
    super.initState();
    _horizontalScrollSync = DiffHorizontalScrollSync();
  }

  @override
  void dispose() {
    _horizontalScrollSync.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.configuration.theme;
    final spacing = widget.configuration.spacing;
    final panelBg = theme.resolvePanelBackgroundColor(isOldSide: widget.isOldSide);
    final isBlockMode = widget.configuration.splitBlocks || spacing.blockSpacing > 0;
    final blocks = isBlockMode ? _groupStackedBlocks(widget.items) : const <_StackedBlock>[];

    final listWidget = isBlockMode
        ? ListView.builder(
            controller: widget.isOldSide
                ? widget.controller.leftScrollController
                : widget.controller.rightScrollController,
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              final block = blocks[index];

              if (block.isCollapsed) {
                final collapsedItem =
                    block.items.first as _CollapsedStackedItem;
                if (widget.collapsedSectionBuilder != null) {
                  return widget.collapsedSectionBuilder!(
                    context,
                    collapsedItem.lineCount,
                    () => widget.controller.expandSection(collapsedItem.lineIndex),
                    widget.configuration,
                  );
                }
                return CollapsedSectionWidget(
                  collapsedLineCount: collapsedItem.lineCount,
                  onExpand: () =>
                      widget.controller.expandSection(collapsedItem.lineIndex),
                  configuration: widget.configuration,
                );
              }

              final blockBg =
                  theme.resolveBlockBackgroundColor(isOldSide: widget.isOldSide);
              final blockBorder =
                  theme.resolveBlockBorderColor(isOldSide: widget.isOldSide);

              return Container(
                margin: EdgeInsets.only(
                  bottom: index == blocks.length - 1 ? 0 : spacing.blockSpacing,
                ),
                padding: spacing.blockPadding,
                decoration: BoxDecoration(
                  color: blockBg,
                  border: Border.all(
                    color: blockBorder,
                    width: spacing.blockBorderWidth,
                  ),
                  borderRadius:
                      BorderRadius.circular(spacing.blockBorderRadius),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: block.items.map((item) {
                    final lineItem = item as _LineStackedItem;
                    if (widget.lineBuilder != null) {
                      return widget.lineBuilder!(
                          context, lineItem.line, widget.configuration);
                    }
                    return DiffLineWidget(
                      key: ValueKey(
                          '${widget.isOldSide ? 'old' : 'new'}_${lineItem.lineIndex}'),
                      line: lineItem.line,
                      isOldSide: widget.isOldSide,
                      configuration: widget.configuration,
                      lineNumberBuilder: widget.lineNumberBuilder,
                      indicatorBuilder: widget.indicatorBuilder,
                      segmentBuilder: widget.segmentBuilder,
                      horizontalScrollSync: _horizontalScrollSync,
                    );
                  }).toList(growable: false),
                ),
              );
            },
          )
        : ListView.builder(
            controller: widget.isOldSide
                ? widget.controller.leftScrollController
                : widget.controller.rightScrollController,
            itemCount: widget.items.length,
            itemExtent: widget.configuration.spacing.lineHeight,
            itemBuilder: (context, index) {
              final item = widget.items[index];

              if (item is _CollapsedStackedItem) {
                if (widget.collapsedSectionBuilder != null) {
                  return widget.collapsedSectionBuilder!(
                    context,
                    item.lineCount,
                    () => widget.controller.expandSection(item.lineIndex),
                    widget.configuration,
                  );
                }
                return CollapsedSectionWidget(
                  collapsedLineCount: item.lineCount,
                  onExpand: () => widget.controller.expandSection(item.lineIndex),
                  configuration: widget.configuration,
                );
              }

              final lineItem = item as _LineStackedItem;
              if (widget.lineBuilder != null) {
                return widget.lineBuilder!(context, lineItem.line, widget.configuration);
              }
              return DiffLineWidget(
                key: ValueKey(
                    '${widget.isOldSide ? 'old' : 'new'}_${lineItem.lineIndex}'),
                line: lineItem.line,
                isOldSide: widget.isOldSide,
                configuration: widget.configuration,
                lineNumberBuilder: widget.lineNumberBuilder,
                indicatorBuilder: widget.indicatorBuilder,
                segmentBuilder: widget.segmentBuilder,
                horizontalScrollSync: _horizontalScrollSync,
              );
            },
          );

    return Container(
      color: panelBg,
      child: listWidget,
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

class _StackedBlock {
  final List<_StackedItem> items;
  final bool isCollapsed;

  const _StackedBlock.lines(this.items) : isCollapsed = false;
  const _StackedBlock.collapsed(this.items) : isCollapsed = true;
}

List<_StackedBlock> _groupStackedBlocks(List<_StackedItem> items) {
  final blocks = <_StackedBlock>[];
  if (items.isEmpty) return blocks;

  List<_StackedItem> currentGroup = [];
  bool? inChangeGroup;

  for (final item in items) {
    if (item is _CollapsedStackedItem) {
      if (currentGroup.isNotEmpty) {
        blocks.add(_StackedBlock.lines(currentGroup));
        currentGroup = [];
        inChangeGroup = null;
      }
      blocks.add(_StackedBlock.collapsed([item]));
      continue;
    }

    final lineItem = item as _LineStackedItem;
    final isChange = lineItem.line.type != DiffType.unchanged;

    if (inChangeGroup == null || inChangeGroup != isChange) {
      if (currentGroup.isNotEmpty) {
        blocks.add(_StackedBlock.lines(currentGroup));
        currentGroup = [];
      }
      inChangeGroup = isChange;
    }
    currentGroup.add(item);
  }

  if (currentGroup.isNotEmpty) {
    blocks.add(_StackedBlock.lines(currentGroup));
  }

  return blocks;
}
