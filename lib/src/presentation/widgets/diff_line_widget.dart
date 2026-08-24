import 'package:flutter/material.dart';

import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_segment.dart';
import '../../domain/enums/diff_type.dart';
import '../builders/diff_builders.dart';
import '../configuration/diff_viewer_configuration.dart';
import '../configuration/diff_viewer_theme.dart';
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
class DiffLineWidget extends StatelessWidget {
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

  /// Creates a [DiffLineWidget].
  const DiffLineWidget({
    required this.line,
    required this.configuration,
    super.key,
    this.isOldSide = false,
    this.lineNumberBuilder,
    this.indicatorBuilder,
    this.segmentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final spacing = configuration.spacing;
    final typography = configuration.typography;

    final Color rowBackground = _resolveBackground(theme);
    final int? lineNum = isOldSide ? line.oldLineNumber : line.newLineNumber;
    final String? text = isOldSide ? line.oldText : line.newText;
    final List<DiffSegment> segments =
        isOldSide ? line.oldSegments : line.newSegments;
    final DiffType displayType = isOldSide && line.type == DiffType.modified
        ? DiffType.removed
        : line.type;

    return Semantics(
      label: _semanticLabel(displayType, text),
      child: Container(
        color: rowBackground,
        height: spacing.lineHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Line number
            if (configuration.showLineNumbers)
              lineNumberBuilder != null
                  ? lineNumberBuilder!(context, lineNum, configuration)
                  : DiffLineNumberWidget(
                      lineNumber: lineNum,
                      configuration: configuration,
                    ),

            // Change indicator
            if (configuration.showIndicators)
              indicatorBuilder != null
                  ? indicatorBuilder!(context, line, configuration)
                  : DiffIndicatorWidget(
                      diffType: displayType,
                      configuration: configuration,
                    ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.horizontalPadding,
                  vertical: spacing.verticalPadding,
                ),
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
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: segments.map((segment) {
            if (segmentBuilder != null) {
              return segmentBuilder!(context, segment, configuration);
            }
            return DiffSegmentWidget(
              segment: segment,
              configuration: configuration,
              isOldSide: isOldSide,
            );
          }).toList(growable: false),
        ),
      );
    }

    // Plain text rendering
    final textStyle = _resolveTextStyle(displayType, typography, theme);
    if (configuration.enableTextSelection) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(text, style: textStyle, maxLines: 1),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(text, style: textStyle, maxLines: 1, softWrap: false),
    );
  }

  Color _resolveBackground(FlutterDiffViewerTheme theme) {
    switch (line.type) {
      case DiffType.added:
        return theme.resolveAddedBackgroundColor(isOldSide: isOldSide);
      case DiffType.removed:
        return theme.resolveRemovedBackgroundColor(isOldSide: isOldSide);
      case DiffType.modified:
        return isOldSide
            ? theme.resolveRemovedBackgroundColor(isOldSide: true)
            : theme.resolveAddedBackgroundColor(isOldSide: false);
      case DiffType.unchanged:
        return theme.resolveUnchangedBackgroundColor(isOldSide: isOldSide);
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
          color: theme.resolveAddedTextColor(isOldSide: isOldSide),
        );
      case DiffType.removed:
        return (typography.removedStyle as TextStyle).copyWith(
          color: theme.resolveRemovedTextColor(isOldSide: isOldSide),
        );
      case DiffType.modified:
        return (typography.modifiedStyle as TextStyle).copyWith(
          color: theme.resolveModifiedTextColor(isOldSide: isOldSide),
        );
      case DiffType.unchanged:
        return (typography.unchangedStyle as TextStyle).copyWith(
          color: theme.resolveUnchangedTextColor(isOldSide: isOldSide),
        );
    }
  }

  String _semanticLabel(DiffType type, String? text) {
    final typeLabel = switch (type) {
      DiffType.added => configuration.localizations.addedLabel,
      DiffType.removed => configuration.localizations.removedLabel,
      DiffType.modified => configuration.localizations.modifiedLabel,
      DiffType.unchanged => configuration.localizations.unchangedLabel,
    };
    return '$typeLabel: ${text ?? ''}';
  }
}
