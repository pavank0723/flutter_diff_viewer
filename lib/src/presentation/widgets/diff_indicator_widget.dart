import 'package:flutter/material.dart';

import '../../domain/enums/diff_type.dart';
import '../configuration/diff_viewer_configuration.dart';

/// Displays the change indicator character (+, -, ~, space) for a diff line.
///
/// Provides both visual and semantic (accessibility) information about the
/// type of change. Never relies solely on color to convey meaning.
///
/// The indicator column is always a fixed width defined by
/// [DiffSpacing.indicatorWidth].
class DiffIndicatorWidget extends StatelessWidget {
  /// The type of change this indicator represents.
  final DiffType diffType;

  /// The configuration providing theme and spacing.
  final FlutterDiffViewerConfiguration configuration;

  /// Creates a [DiffIndicatorWidget].
  const DiffIndicatorWidget({
    required this.diffType,
    required this.configuration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = configuration.theme;
    final typography = configuration.typography;
    final spacing = configuration.spacing;

    final String indicator;
    final Color color;
    final String semanticLabel;

    switch (diffType) {
      case DiffType.added:
        indicator = '+';
        color = theme.indicatorAddedColor;
        semanticLabel = configuration.localizations.addedLabel;
      case DiffType.removed:
        indicator = '-';
        color = theme.indicatorRemovedColor;
        semanticLabel = configuration.localizations.removedLabel;
      case DiffType.modified:
        indicator = '~';
        color = theme.indicatorRemovedColor;
        semanticLabel = configuration.localizations.modifiedLabel;
      case DiffType.unchanged:
        indicator = ' ';
        color = theme.indicatorUnchangedColor;
        semanticLabel = configuration.localizations.unchangedLabel;
    }

    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: SizedBox(
        width: spacing.indicatorWidth,
        child: Center(
          child: Text(
            indicator,
            style: typography.indicatorStyle.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
