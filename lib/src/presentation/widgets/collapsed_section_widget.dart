import 'package:flutter/material.dart';

import '../configuration/diff_viewer_configuration.dart';

/// Displays a placeholder for a collapsed section of unchanged lines.
///
/// Shows the count of hidden lines and a button to expand them.
/// Styled like GitHub's collapsed section indicator with a blue expand button.
class CollapsedSectionWidget extends StatelessWidget {
  /// The number of lines that are hidden in this collapsed section.
  final int collapsedLineCount;

  /// Called when the user taps the "Show lines" button.
  final VoidCallback onExpand;

  /// The configuration providing theme and localizations.
  final DiffViewerConfiguration configuration;

  /// Creates a [CollapsedSectionWidget].
  const CollapsedSectionWidget({
    required this.collapsedLineCount,
    required this.onExpand,
    required this.configuration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;
    final spacing = configuration.spacing;
    final localizations = configuration.localizations;

    return Container(
      height: spacing.lineHeight * 1.5,
      decoration: BoxDecoration(
        color: theme.collapsedSectionColor,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: theme.borderColor,
            width: spacing.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: spacing.lineNumberWidth),
          SizedBox(width: spacing.indicatorWidth),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.horizontalPadding,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.unfold_more_rounded,
                    size: 14,
                    color: theme.collapsedSectionTextColor,
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: onExpand,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      child: Text(
                        localizations.formattedShowMore(collapsedLineCount),
                        style: typography.collapsedStyle.copyWith(
                          color: theme.collapsedSectionTextColor,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.collapsedSectionTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
