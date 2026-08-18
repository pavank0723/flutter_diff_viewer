import 'package:flutter/material.dart';

import '../../domain/entities/diff_result.dart';
import '../configuration/diff_viewer_configuration.dart';

/// Displays a summary bar showing the number of additions and deletions.
///
/// Styled like GitHub's diff summary: green for additions, red for deletions.
/// All colors come from [DiffViewerTheme] — never hardcoded.
class DiffSummaryWidget extends StatelessWidget {
  /// The diff result to display summary statistics for.
  final DiffResult result;

  /// The configuration providing theme, typography, and localizations.
  final DiffViewerConfiguration configuration;

  /// Creates a [DiffSummaryWidget].
  const DiffSummaryWidget({
    required this.result,
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
      height: spacing.summaryHeight,
      decoration: BoxDecoration(
        color: theme.summaryBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.borderColor,
            width: spacing.borderWidth,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: spacing.horizontalPadding * 2),
      child: Row(
        children: [
          // Additions badge
          _SummaryBadge(
            label: localizations.formattedAdditions(result.additions),
            color: theme.addedTextColor,
            style: typography.summaryStyle,
          ),
          const SizedBox(width: 12),
          // Deletions badge
          _SummaryBadge(
            label: localizations.formattedDeletions(result.deletions),
            color: theme.removedTextColor,
            style: typography.summaryStyle,
          ),
          if (result.modifications > 0) ...[
            const SizedBox(width: 12),
            _SummaryBadge(
              label:
                  '~${result.modifications} ${localizations.modifiedLabel.toLowerCase()}',
              color: theme.modifiedTextColor,
              style: typography.summaryStyle,
            ),
          ],
          const Spacer(),
          // Change count
          Text(
            '${result.totalChanges} change${result.totalChanges == 1 ? '' : 's'}',
            style: typography.summaryStyle.copyWith(
              color: theme.unchangedTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBadge extends StatelessWidget {
  final String label;
  final Color color;
  final TextStyle style;

  const _SummaryBadge({
    required this.label,
    required this.color,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: style.copyWith(color: color, fontWeight: FontWeight.w600),
    );
  }
}
