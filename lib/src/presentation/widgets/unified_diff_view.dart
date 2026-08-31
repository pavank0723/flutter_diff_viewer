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

/// A helper for building the list of items in a view, handling collapsed sections.
List<_DiffViewItem> _buildViewItems({
  required DiffResult result,
  required FlutterDiffViewerConfiguration configuration,
  required Set<int> collapsedIndices,
}) {
  final items = <_DiffViewItem>[];
  final contextLines = configuration.contextLines;

  // Determine which unchanged line indices should be visible
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

class _UnifiedBlock {
  final List<_DiffViewItem> items;
  final bool isCollapsed;

  const _UnifiedBlock.lines(this.items) : isCollapsed = false;
  const _UnifiedBlock.collapsed(this.items) : isCollapsed = true;
}

List<_UnifiedBlock> _groupUnifiedBlocks(List<_DiffViewItem> items) {
  final blocks = <_UnifiedBlock>[];
  if (items.isEmpty) return blocks;

  List<_DiffViewItem> currentGroup = [];
  bool? inChangeGroup;

  for (final item in items) {
    if (item is _CollapsedItem) {
      if (currentGroup.isNotEmpty) {
        blocks.add(_UnifiedBlock.lines(currentGroup));
        currentGroup = [];
        inChangeGroup = null;
      }
      blocks.add(_UnifiedBlock.collapsed([item]));
      continue;
    }

    final lineItem = item as _LineItem;
    final isChange = lineItem.line.type != DiffType.unchanged;

    if (inChangeGroup == null || inChangeGroup != isChange) {
      if (currentGroup.isNotEmpty) {
        blocks.add(_UnifiedBlock.lines(currentGroup));
        currentGroup = [];
      }
      inChangeGroup = isChange;
    }
    currentGroup.add(item);
  }

  if (currentGroup.isNotEmpty) {
    blocks.add(_UnifiedBlock.lines(currentGroup));
  }

  return blocks;
}

/// Renders a unified diff view (single column, +/- indicators).
class UnifiedDiffView extends StatefulWidget {
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
  State<UnifiedDiffView> createState() => _UnifiedDiffViewState();
}

class _UnifiedDiffViewState extends State<UnifiedDiffView> {
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
    final isBlockMode = widget.configuration.splitBlocks || spacing.blockSpacing > 0;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final items = _buildViewItems(
          result: widget.result,
          configuration: widget.configuration,
          collapsedIndices: widget.controller.collapsedLineIndices,
        );

        final blocks = isBlockMode ? _groupUnifiedBlocks(items) : const <_UnifiedBlock>[];

        if (isBlockMode) {
          return ListView.builder(
            controller: widget.controller.primaryScrollController,
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              final block = blocks[index];

              if (block.isCollapsed) {
                final collapsedItem = block.items.first as _CollapsedItem;
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
                  theme.resolveBlockBackgroundColor(isOldSide: false);
              final blockBorder =
                  theme.resolveBlockBorderColor(isOldSide: false);

              return Container(
                margin: EdgeInsets.only(
                  bottom:
                      index == blocks.length - 1 ? 0 : spacing.blockSpacing,
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
                    final lineItem = item as _LineItem;
                    if (widget.lineBuilder != null) {
                      return widget.lineBuilder!(
                          context, lineItem.line, widget.configuration);
                    }
                    return DiffLineWidget(
                      key: ValueKey('unified_${lineItem.lineIndex}'),
                      line: lineItem.line,
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
          );
        }

        return ListView.builder(
          controller: widget.controller.primaryScrollController,
          itemCount: items.length,
          itemExtent: widget.configuration.spacing.lineHeight,
          itemBuilder: (context, index) {
            final item = items[index];

            switch (item) {
              case _CollapsedItem(:final lineIndex, :final lineCount):
                if (widget.collapsedSectionBuilder != null) {
                  return widget.collapsedSectionBuilder!(
                    context,
                    lineCount,
                    () => widget.controller.expandSection(lineIndex),
                    widget.configuration,
                  );
                }
                return CollapsedSectionWidget(
                  collapsedLineCount: lineCount,
                  onExpand: () => widget.controller.expandSection(lineIndex),
                  configuration: widget.configuration,
                );

              case _LineItem(:final line):
                if (widget.lineBuilder != null) {
                  return widget.lineBuilder!(context, line, widget.configuration);
                }
                return DiffLineWidget(
                  key: ValueKey('unified_${item.lineIndex}'),
                  line: line,
                  configuration: widget.configuration,
                  lineNumberBuilder: widget.lineNumberBuilder,
                  indicatorBuilder: widget.indicatorBuilder,
                  segmentBuilder: widget.segmentBuilder,
                  horizontalScrollSync: _horizontalScrollSync,
                );
            }
          },
        );
      },
    );
  }
}
