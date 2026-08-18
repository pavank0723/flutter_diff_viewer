import 'package:flutter/material.dart';

import '../configuration/diff_viewer_configuration.dart';
import '../controllers/diff_viewer_controller.dart';

/// Displays change navigation controls (Previous / Change N of M / Next).
///
/// Allows users to jump between detected changes. Buttons are disabled
/// when navigation is not possible (e.g., first/last change).
///
/// Wraps [DiffViewerController] state via [ListenableBuilder] for efficient
/// rebuilding.
class ChangeNavigationWidget extends StatelessWidget {
  /// The controller managing navigation state.
  final DiffViewerController controller;

  /// The configuration providing theme and localizations.
  final DiffViewerConfiguration configuration;

  /// Creates a [ChangeNavigationWidget].
  const ChangeNavigationWidget({
    required this.controller,
    required this.configuration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;
    final spacing = configuration.spacing;
    final localizations = configuration.localizations;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.totalChanges == 0) return const SizedBox.shrink();

        final label = localizations.formattedChangeOf(
          controller.currentChangeIndex,
          controller.totalChanges,
        );

        return Container(
          height: spacing.summaryHeight,
          decoration: BoxDecoration(
            color: theme.summaryBackgroundColor,
            border: Border(
              top: BorderSide(
                color: theme.borderColor,
                width: spacing.borderWidth,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: spacing.horizontalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Previous button
              _NavButton(
                tooltip: localizations.previousChangeLabel,
                icon: Icons.keyboard_arrow_up_rounded,
                enabled: controller.hasPreviousChange,
                onPressed: controller.previousChange,
                configuration: configuration,
              ),
              const SizedBox(width: 4),
              // Counter label
              Text(
                label,
                style: typography.summaryStyle.copyWith(
                  color: theme.unchangedTextColor,
                ),
              ),
              const SizedBox(width: 4),
              // Next button
              _NavButton(
                tooltip: localizations.nextChangeLabel,
                icon: Icons.keyboard_arrow_down_rounded,
                enabled: controller.hasNextChange,
                onPressed: controller.nextChange,
                configuration: configuration,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final DiffViewerConfiguration configuration;

  const _NavButton({
    required this.tooltip,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? theme.navigationButtonColor
                : theme.lineNumberTextColor,
          ),
        ),
      ),
    );
  }
}
