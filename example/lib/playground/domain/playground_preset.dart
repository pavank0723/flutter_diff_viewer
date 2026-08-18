import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

class PlaygroundPreset {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final DiffViewerConfiguration configuration;

  const PlaygroundPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.configuration,
  });

  static List<PlaygroundPreset> get defaultPresets => [
        PlaygroundPreset(
          id: 'github_light',
          name: 'GitHub Light',
          description: 'Standard GitHub desktop pull request diff view',
          icon: Icons.light_mode,
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.sideBySide,
            granularity: DiffGranularity.word,
            showSummary: true,
            showLineNumbers: true,
            showIndicators: true,
            collapseUnchangedLines: true,
            theme: DiffViewerTheme.light(),
          ),
        ),
        PlaygroundPreset(
          id: 'github_dark',
          name: 'GitHub Dark',
          description: 'Dark mode PR viewer with vibrant highlights',
          icon: Icons.dark_mode,
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.sideBySide,
            granularity: DiffGranularity.word,
            showSummary: true,
            showLineNumbers: true,
            showIndicators: true,
            collapseUnchangedLines: true,
            theme: DiffViewerTheme.dark(),
          ),
        ),
        PlaygroundPreset(
          id: 'minimal',
          name: 'Minimal Clean',
          description:
              'Clean borderless layout without line numbers or headers',
          icon: Icons.cleaning_services,
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.unified,
            showHeader: false,
            showLineNumbers: false,
            showIndicators: false,
            showSummary: false,
            showChangeNavigation: false,
            collapseUnchangedLines: false,
          ),
        ),
        PlaygroundPreset(
          id: 'enterprise_audit',
          name: 'Enterprise Audit',
          description: 'Full legal document review with change navigation',
          icon: Icons.gavel,
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.sideBySide,
            granularity: DiffGranularity.character,
            showHeader: true,
            showSummary: true,
            showChangeNavigation: true,
            collapseUnchangedLines: true,
            contextLines: 2,
            theme: DiffViewerTheme.light().copyWith(
              addedBackgroundColor: const Color(0xFFE8F5E9),
              addedTextColor: const Color(0xFF1B5E20),
              removedBackgroundColor: const Color(0xFFFFEBEE),
              removedTextColor: const Color(0xFFB71C1C),
              headerBackgroundColor: const Color(0xFFF5F5F5),
              borderColor: const Color(0xFFBDBDBD),
            ),
          ),
        ),
        PlaygroundPreset(
          id: 'compact_mobile',
          name: 'Mobile Stacked',
          description: 'Stacked layout optimized for small mobile screens',
          icon: Icons.phone_android,
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.stacked,
            granularity: DiffGranularity.word,
            showLineNumbers: true,
            showIndicators: true,
            collapseUnchangedLines: true,
            spacing: const DiffSpacing(
              lineHeight: 20.0,
              lineNumberWidth: 40.0,
              horizontalPadding: 4.0,
              indicatorWidth: 20.0,
              verticalPadding: 2.0,
              borderWidth: 1.0,
              borderRadius: 6.0,
              headerHeight: 40.0,
              summaryHeight: 32.0,
            ),
          ),
        ),
        PlaygroundPreset(
          id: 'high_contrast',
          name: 'High Contrast (a11y)',
          description: 'Accessibility-first palette with bold indicators',
          icon: Icons.accessibility_new,
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.unified,
            granularity: DiffGranularity.character,
            showIndicators: true,
            showLineNumbers: true,
            theme: DiffViewerTheme.light().copyWith(
              addedBackgroundColor: const Color(0xFFD4EDDA),
              addedTextColor: const Color(0xFF004085),
              addedHighlightColor: const Color(0xFFC3E6CB),
              removedBackgroundColor: const Color(0xFFF8D7DA),
              removedTextColor: const Color(0xFF721C24),
              removedHighlightColor: const Color(0xFFF5C6CB),
              indicatorAddedColor: const Color(0xFF155724),
              indicatorRemovedColor: const Color(0xFF721C24),
            ),
          ),
        ),
      ];
}
