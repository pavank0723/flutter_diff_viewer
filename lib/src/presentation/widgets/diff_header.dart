import 'package:flutter/material.dart';

import '../configuration/diff_viewer_configuration.dart';

/// Renders the header bar of the diff viewer showing old and new version labels.
///
/// In side-by-side mode, two labels are shown side by side. In unified/stacked
/// mode, a single unified header is shown.
///
/// Fully theme-driven — no hardcoded colors or typography.
class DiffHeader extends StatelessWidget {
  /// Label for the old (left/top) content panel. Defaults to "Current".
  final String? oldLabel;

  /// Label for the new (right/bottom) content panel. Defaults to "Modified".
  final String? newLabel;

  /// Whether this is a side-by-side header (two columns) or a unified header.
  final bool isSideBySide;

  /// The configuration providing theme, typography, and spacing.
  final DiffViewerConfiguration configuration;

  /// Creates a [DiffHeader].
  const DiffHeader({
    required this.isSideBySide,
    required this.configuration,
    super.key,
    this.oldLabel,
    this.newLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;
    final spacing = configuration.spacing;
    final localizations = configuration.localizations;

    final effectiveOldLabel = oldLabel ?? localizations.oldVersionLabel;
    final effectiveNewLabel = newLabel ?? localizations.newVersionLabel;

    final headerDecoration = BoxDecoration(
      color: theme.headerBackgroundColor,
      border: Border(
        bottom: BorderSide(
          color: theme.borderColor,
          width: spacing.borderWidth,
        ),
      ),
    );

    final labelStyle = typography.headerStyle.copyWith(
      color: theme.headerTextColor,
    );

    if (isSideBySide) {
      return SizedBox(
        height: spacing.headerHeight,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: headerDecoration,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.horizontalPadding * 2,
                ),
                child: Text(effectiveOldLabel, style: labelStyle),
              ),
            ),
            Container(width: spacing.borderWidth, color: theme.dividerColor),
            Expanded(
              child: Container(
                decoration: headerDecoration,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.horizontalPadding * 2,
                ),
                child: Text(effectiveNewLabel, style: labelStyle),
              ),
            ),
          ],
        ),
      );
    }

    // Unified / stacked header
    return Container(
      height: spacing.headerHeight,
      decoration: headerDecoration,
      padding: EdgeInsets.symmetric(horizontal: spacing.horizontalPadding * 2),
      child: Row(
        children: [
          Text(effectiveOldLabel, style: labelStyle),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 14, color: theme.headerTextColor),
          const SizedBox(width: 8),
          Text(effectiveNewLabel, style: labelStyle),
        ],
      ),
    );
  }
}
