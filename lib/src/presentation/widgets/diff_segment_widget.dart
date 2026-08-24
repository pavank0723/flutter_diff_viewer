import 'package:flutter/material.dart';

import '../../domain/entities/diff_segment.dart';
import '../../domain/enums/diff_type.dart';
import '../configuration/diff_viewer_configuration.dart';

/// Renders a single intra-line diff segment with appropriate highlighting.
///
/// A segment is a run of text with a single [DiffType] classification.
/// Added segments are highlighted with added highlight colors,
/// removed segments with removed highlight colors, and
/// unchanged segments have no background highlight.
///
/// Used within [DiffLineWidget] when word or character granularity is enabled.
class DiffSegmentWidget extends StatelessWidget {
  /// The segment to render.
  final DiffSegment segment;

  /// The configuration providing theme and typography.
  final FlutterDiffViewerConfiguration configuration;

  /// Whether this segment is rendered on the old (left) side.
  final bool isOldSide;

  /// Creates a [DiffSegmentWidget].
  const DiffSegmentWidget({
    required this.segment,
    required this.configuration,
    super.key,
    this.isOldSide = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;

    Color? backgroundColor;
    TextStyle textStyle;

    switch (segment.type) {
      case DiffType.added:
        backgroundColor = theme.resolveAddedHighlightColor(isOldSide: isOldSide);
        textStyle = typography.addedStyle.copyWith(
          color: theme.resolveAddedTextColor(isOldSide: isOldSide),
        );
      case DiffType.removed:
        backgroundColor = theme.resolveRemovedHighlightColor(isOldSide: isOldSide);
        textStyle = typography.removedStyle.copyWith(
          color: theme.resolveRemovedTextColor(isOldSide: isOldSide),
        );
      case DiffType.modified:
        backgroundColor = theme.resolveModifiedBackgroundColor(isOldSide: isOldSide);
        textStyle = typography.modifiedStyle.copyWith(
          color: theme.resolveModifiedTextColor(isOldSide: isOldSide),
        );
      case DiffType.unchanged:
        backgroundColor = null;
        textStyle = typography.unchangedStyle.copyWith(
          color: theme.resolveUnchangedTextColor(isOldSide: isOldSide),
        );
    }

    final textWidget = Text(segment.text, style: textStyle, softWrap: false);

    if (backgroundColor == null) return textWidget;

    return Container(color: backgroundColor, child: textWidget);
  }
}
