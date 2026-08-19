import 'package:flutter/material.dart';

import '../configuration/diff_viewer_configuration.dart';

/// Displays a line number in the gutter of the diff view.
///
/// Shows the 1-based line number, or a blank placeholder when the line
/// does not exist on this side of the diff (e.g., an added line has no
/// old-side line number).
///
/// The column is always the fixed width defined by [DiffSpacing.lineNumberWidth].
class DiffLineNumberWidget extends StatelessWidget {
  /// The 1-based line number to display, or `null` for a blank placeholder.
  final int? lineNumber;

  /// The configuration providing theme and spacing.
  final FlutterDiffViewerConfiguration configuration;

  /// Creates a [DiffLineNumberWidget].
  const DiffLineNumberWidget({
    required this.lineNumber,
    required this.configuration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;
    final spacing = configuration.spacing;

    return Container(
      width: spacing.lineNumberWidth,
      color: theme.lineNumberBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: spacing.horizontalPadding),
      alignment: Alignment.centerRight,
      child: lineNumber != null
          ? Text(
              lineNumber.toString(),
              style: typography.lineNumberStyle.copyWith(
                color: theme.lineNumberTextColor,
              ),
              textAlign: TextAlign.right,
            )
          : const SizedBox.shrink(),
    );
  }
}
