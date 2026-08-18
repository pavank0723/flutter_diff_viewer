import 'package:flutter/material.dart';

import '../../domain/entities/diff_segment.dart';
import '../../domain/enums/diff_type.dart';
import '../configuration/diff_viewer_configuration.dart';

/// Renders a single intra-line diff segment with appropriate highlighting.
///
/// A segment is a run of text with a single [DiffType] classification.
/// Added segments are highlighted with [DiffViewerTheme.addedHighlightColor],
/// removed segments with [DiffViewerTheme.removedHighlightColor], and
/// unchanged segments have no background highlight.
///
/// Used within [DiffLineWidget] when word or character granularity is enabled.
class DiffSegmentWidget extends StatelessWidget {
  /// The segment to render.
  final DiffSegment segment;

  /// The configuration providing theme and typography.
  final DiffViewerConfiguration configuration;

  /// Creates a [DiffSegmentWidget].
  const DiffSegmentWidget({
    required this.segment,
    required this.configuration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;

    Color? backgroundColor;
    TextStyle textStyle;

    switch (segment.type) {
      case DiffType.added:
        backgroundColor = theme.addedHighlightColor;
        textStyle = typography.addedStyle.copyWith(color: theme.addedTextColor);
      case DiffType.removed:
        backgroundColor = theme.removedHighlightColor;
        textStyle = typography.removedStyle.copyWith(
          color: theme.removedTextColor,
        );
      case DiffType.modified:
        backgroundColor = theme.modifiedBackgroundColor;
        textStyle = typography.modifiedStyle.copyWith(
          color: theme.modifiedTextColor,
        );
      case DiffType.unchanged:
        backgroundColor = null;
        textStyle = typography.unchangedStyle;
    }

    final textWidget = Text(segment.text, style: textStyle, softWrap: false);

    if (backgroundColor == null) return textWidget;

    return Container(color: backgroundColor, child: textWidget);
  }
}
