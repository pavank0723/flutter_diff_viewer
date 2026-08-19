import 'package:flutter/material.dart';

import '../configuration/diff_viewer_configuration.dart';

/// Displays a friendly empty state when no differences are detected.
///
/// Shown when both [oldContent] and [newContent] are identical.
class DiffEmptyStateWidget extends StatelessWidget {
  /// The configuration providing theme and localizations.
  final FlutterDiffViewerConfiguration configuration;

  /// Creates a [DiffEmptyStateWidget].
  const DiffEmptyStateWidget({required this.configuration, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;
    final localizations = configuration.localizations;

    return Container(
      color: theme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 48,
              color: theme.indicatorAddedColor,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noChangesLabel,
              style: typography.headerStyle.copyWith(
                color: theme.unchangedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays an error state when diff calculation fails.
class DiffErrorWidget extends StatelessWidget {
  /// The error that occurred.
  final Object error;

  /// The configuration providing theme and localizations.
  final FlutterDiffViewerConfiguration configuration;

  /// Creates a [DiffErrorWidget].
  const DiffErrorWidget({
    required this.error,
    required this.configuration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;
    final localizations = configuration.localizations;

    return Container(
      color: theme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.indicatorRemovedColor,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.errorLabel,
              style: typography.headerStyle.copyWith(
                color: theme.removedTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error.toString(),
                style: typography.collapsedStyle.copyWith(
                  color: theme.lineNumberTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a loading state while diff calculation is in progress.
class DiffLoadingWidget extends StatelessWidget {
  /// The configuration providing theme and localizations.
  final FlutterDiffViewerConfiguration configuration;

  /// Creates a [DiffLoadingWidget].
  const DiffLoadingWidget({required this.configuration, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;
    final localizations = configuration.localizations;

    return Container(
      color: theme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: theme.navigationButtonColor,
              strokeWidth: 2,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.loadingLabel,
              style: typography.summaryStyle.copyWith(
                color: theme.unchangedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
