import 'package:flutter/material.dart';

import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_segment.dart';
import '../../domain/enums/diff_type.dart';
import '../builders/diff_builders.dart';
import '../configuration/diff_viewer_configuration.dart';
import '../configuration/diff_viewer_theme.dart';
import '../utils/horizontal_scroll_sync.dart';
import 'diff_indicator_widget.dart';
import 'diff_line_number_widget.dart';
import 'diff_segment_widget.dart';

/// Renders a single line row in the diff view.
///
/// Includes (optionally) the line number, indicator, and text content.
/// When segments are available, renders inline highlights using
/// [DiffSegmentWidget]; otherwise renders the full line text.
///
/// All rendering decisions (colors, typography) are driven by
/// [FlutterDiffViewerConfiguration] and side-aware resolvers.
class DiffLineWidget extends StatefulWidget {
  /// The diff line data to render.
  final DiffLine line;

  /// Whether this is rendering the old (left) side or new (right) side.
  ///
  /// In unified view this is always `false` (single combined column).
  /// In side-by-side view, [isOldSide] is `true` for the left panel.
  final bool isOldSide;

  /// The configuration providing theme, typography, spacing, and localizations.
  final FlutterDiffViewerConfiguration configuration;

  /// Optional custom line number builder.
  final DiffLineNumberBuilder? lineNumberBuilder;

  /// Optional custom indicator builder.
  final DiffIndicatorBuilder? indicatorBuilder;

  /// Optional custom segment builder.
  final DiffSegmentBuilder? segmentBuilder;

  /// Optional synchronizer for horizontal scrolling across all line rows.
  final DiffHorizontalScrollSync? horizontalScrollSync;

  /// Creates a [DiffLineWidget].
  const DiffLineWidget({
    required this.line,
    required this.configuration,
    super.key,
    this.isOldSide = false,
    this.lineNumberBuilder,
    this.indicatorBuilder,
    this.segmentBuilder,
    this.horizontalScrollSync,
  });

  @override
  State<DiffLineWidget> createState() => _DiffLineWidgetState();
}

class _DiffLineWidgetState extends State<DiffLineWidget> {
  late final ScrollController _scrollController;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    final initialOffset = widget.horizontalScrollSync?.offset ?? 0.0;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    widget.horizontalScrollSync?.addListener(_onSyncChanged);
  }

  @override
  void didUpdateWidget(DiffLineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.horizontalScrollSync != widget.horizontalScrollSync) {
      oldWidget.horizontalScrollSync?.removeListener(_onSyncChanged);
      widget.horizontalScrollSync?.addListener(_onSyncChanged);
      _onSyncChanged();
    }
  }

  void _onSyncChanged() {
    final targetOffset = widget.horizontalScrollSync?.offset ?? 0.0;
    if (_scrollController.hasClients &&
        !_isSyncing &&
        (_scrollController.offset - targetOffset).abs() > 0.5) {
      _isSyncing = true;
      final maxExtent = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(targetOffset.clamp(0.0, maxExtent));
      _isSyncing = false;
    }
  }

  @override
  void dispose() {
    widget.horizontalScrollSync?.removeListener(_onSyncChanged);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.configuration.theme;
    final spacing = widget.configuration.spacing;
    final typography = widget.configuration.typography;

    final Color rowBackground = _resolveBackground(theme);
    final int? lineNum = widget.isOldSide ? widget.line.oldLineNumber : widget.line.newLineNumber;
    final String? text = widget.isOldSide ? widget.line.oldText : widget.line.newText;
    final List<DiffSegment> segments =
        widget.isOldSide ? widget.line.oldSegments : widget.line.newSegments;
    final DiffType displayType = widget.isOldSide && widget.line.type == DiffType.modified
        ? DiffType.removed
        : widget.line.type;

    return Semantics(
      label: _semanticLabel(displayType, text),
      child: Container(
        color: rowBackground,
        height: spacing.lineHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Line number
            if (widget.configuration.showLineNumbers)
              widget.lineNumberBuilder != null
                  ? widget.lineNumberBuilder!(context, lineNum, widget.configuration)
                  : DiffLineNumberWidget(
                      lineNumber: lineNum,
                      configuration: widget.configuration,
                    ),

            // Change indicator
            if (widget.configuration.showIndicators)
              widget.indicatorBuilder != null
                  ? widget.indicatorBuilder!(context, widget.line, widget.configuration)
                  : DiffIndicatorWidget(
                      diffType: displayType,
                      configuration: widget.configuration,
                    ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.horizontalPadding,
                  vertical: spacing.verticalPadding,
                ),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification &&
                        !_isSyncing &&
                        widget.horizontalScrollSync != null) {
                      _isSyncing = true;
                      widget.horizontalScrollSync!
                          .updateOffset(notification.metrics.pixels);
                      _isSyncing = false;
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: _buildContent(
                      context,
                      text,
                      segments,
                      displayType,
                      typography,
                      theme,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    String? text,
    List<DiffSegment> segments,
    DiffType displayType,
    dynamic typography,
    FlutterDiffViewerTheme theme,
  ) {
    if (text == null) {
      return const SizedBox.shrink();
    }

    // If we have segments, render inline highlights
    if (segments.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: segments.map((segment) {
          if (widget.segmentBuilder != null) {
            return widget.segmentBuilder!(context, segment, widget.configuration);
          }
          return DiffSegmentWidget(
            segment: segment,
            configuration: widget.configuration,
            isOldSide: widget.isOldSide,
          );
        }).toList(growable: false),
      );
    }

    final textStyle = _resolveTextStyle(displayType, typography, theme);

    if (widget.configuration.highlightWhitespace &&
        (displayType == DiffType.added || displayType == DiffType.removed) &&
        (text.contains(' ') || text.contains('\t'))) {
      final wsBgColor = theme.resolveAddedWhitespaceBackgroundColor(isOldSide: widget.isOldSide);
      final wsTextColor = theme.resolveAddedWhitespaceTextColor(isOldSide: widget.isOldSide);
      final spans = <InlineSpan>[];
      final buffer = StringBuffer();

      void flushNormal() {
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString(), style: textStyle));
          buffer.clear();
        }
      }

      final runesList = text.runes.toList();
      final firstNonWs = runesList.indexWhere((r) => r != 32 && r != 9);
      final lastNonWs = runesList.lastIndexWhere((r) => r != 32 && r != 9);

      for (var i = 0; i < runesList.length; i++) {
        final char = String.fromCharCode(runesList[i]);
        if (char == ' ' || char == '\t') {
          final isTab = char == '\t';
          final isLeading = firstNonWs != -1 && i < firstNonWs;
          final isTrailing = lastNonWs != -1 && i > lastNonWs;
          final isMultiSpace = char == ' ' &&
              ((i > 0 && runesList[i - 1] == 32) ||
                  (i + 1 < runesList.length && runesList[i + 1] == 32));

          if (isTab || isLeading || isTrailing || isMultiSpace) {
            flushNormal();
            final symbol = isTab ? '→' : '·';
            spans.add(
              TextSpan(
                text: symbol,
                style: textStyle.copyWith(
                  color: wsTextColor,
                  backgroundColor: wsBgColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            buffer.write(' ');
          }
        } else {
          buffer.write(char);
        }
      }
      flushNormal();

      if (widget.configuration.enableTextSelection) {
        return SelectableText.rich(
          TextSpan(children: spans),
          maxLines: 1,
        );
      }
      return Text.rich(
        TextSpan(children: spans),
        softWrap: false,
        maxLines: 1,
      );
    }

    // Plain text rendering without whitespace highlights
    if (widget.configuration.enableTextSelection) {
      return SelectableText(text, style: textStyle, maxLines: 1);
    }

    return Text(text, style: textStyle, maxLines: 1, softWrap: false);
  }

  Color _resolveBackground(FlutterDiffViewerTheme theme) {
    switch (widget.line.type) {
      case DiffType.added:
        return theme.resolveAddedBackgroundColor(isOldSide: widget.isOldSide);
      case DiffType.removed:
        return theme.resolveRemovedBackgroundColor(isOldSide: widget.isOldSide);
      case DiffType.modified:
        return widget.isOldSide
            ? theme.resolveRemovedBackgroundColor(isOldSide: true)
            : theme.resolveAddedBackgroundColor(isOldSide: false);
      case DiffType.unchanged:
        return theme.resolveUnchangedBackgroundColor(isOldSide: widget.isOldSide);
    }
  }

  TextStyle _resolveTextStyle(
    DiffType displayType,
    dynamic typography,
    FlutterDiffViewerTheme theme,
  ) {
    switch (displayType) {
      case DiffType.added:
        return (typography.addedStyle as TextStyle).copyWith(
          color: theme.resolveAddedTextColor(isOldSide: widget.isOldSide),
        );
      case DiffType.removed:
        return (typography.removedStyle as TextStyle).copyWith(
          color: theme.resolveRemovedTextColor(isOldSide: widget.isOldSide),
        );
      case DiffType.modified:
        return (typography.modifiedStyle as TextStyle).copyWith(
          color: theme.resolveModifiedTextColor(isOldSide: widget.isOldSide),
        );
      case DiffType.unchanged:
        return (typography.unchangedStyle as TextStyle).copyWith(
          color: theme.resolveUnchangedTextColor(isOldSide: widget.isOldSide),
        );
    }
  }

  String _semanticLabel(DiffType type, String? text) {
    final typeLabel = switch (type) {
      DiffType.added => widget.configuration.localizations.addedLabel,
      DiffType.removed => widget.configuration.localizations.removedLabel,
      DiffType.modified => widget.configuration.localizations.modifiedLabel,
      DiffType.unchanged => widget.configuration.localizations.unchangedLabel,
    };
    return '$typeLabel: ${text ?? ''}';
  }
}
