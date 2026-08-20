import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import 'playground_property_definition.dart';

/// Registry of all customizable properties exposed by [FlutterDiffViewerConfiguration].
class PropertyRegistry {
  PropertyRegistry._();

  static List<PlaygroundPropertyDefinition> get properties => [
        // --- Layout ---
        PlaygroundPropertyDefinition(
          key: 'layout',
          apiPath: 'configuration.layout',
          label: 'Diff Layout Mode',
          description:
              'Controls visual layout format (Side-by-Side, Unified, Stacked, Auto-responsive).',
          category: PropertyCategory.layout,
          editorType: EditorType.dropdown,
          defaultValue: DiffLayout.auto,
          options: DiffLayout.values,
        ),
        PlaygroundPropertyDefinition(
          key: 'sideBySideBreakpoint',
          apiPath: 'configuration.sideBySideBreakpoint',
          label: 'Side-by-Side Breakpoint (px)',
          description:
              'Minimum width for Auto layout to choose Side-by-Side vs Unified.',
          category: PropertyCategory.layout,
          editorType: EditorType.number,
          defaultValue: 768.0,
          min: 400.0,
          max: 1200.0,
          divisions: 16,
        ),
        PlaygroundPropertyDefinition(
          key: 'splitPanels',
          apiPath: 'configuration.splitPanels',
          label: 'Split Box / Dual Card Panels',
          description:
              'Renders original and modified content in separate box cards with customizable gap.',
          category: PropertyCategory.layout,
          editorType: EditorType.boolean,
          defaultValue: false,
        ),

        // --- General / Titles ---
        PlaygroundPropertyDefinition(
          key: 'oldVersionLabel',
          apiPath: 'configuration.localizations.oldVersionLabel',
          label: 'Old Version Label',
          description: 'Header text for original/left content panel.',
          category: PropertyCategory.general,
          editorType: EditorType.text,
          defaultValue: 'Current',
        ),
        PlaygroundPropertyDefinition(
          key: 'newVersionLabel',
          apiPath: 'configuration.localizations.newVersionLabel',
          label: 'New Version Label',
          description: 'Header text for modified/right content panel.',
          category: PropertyCategory.general,
          editorType: EditorType.text,
          defaultValue: 'Modified',
        ),

        // --- Line Display & Gutter ---
        PlaygroundPropertyDefinition(
          key: 'showLineNumbers',
          apiPath: 'configuration.showLineNumbers',
          label: 'Show Line Numbers',
          description:
              'Toggles line number gutter columns in old and new panels.',
          category: PropertyCategory.lineDisplay,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
        PlaygroundPropertyDefinition(
          key: 'showIndicators',
          apiPath: 'configuration.showIndicators',
          label: 'Show Change Indicators (+/-)',
          description:
              'Toggles the change symbol indicator column (+, -, space).',
          category: PropertyCategory.lineDisplay,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
        PlaygroundPropertyDefinition(
          key: 'showHeader',
          apiPath: 'configuration.showHeader',
          label: 'Show Header Bar',
          description: 'Toggles top version title bar.',
          category: PropertyCategory.lineDisplay,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
        PlaygroundPropertyDefinition(
          key: 'showSummary',
          apiPath: 'configuration.showSummary',
          label: 'Show Summary Bar',
          description: 'Displays +N additions and -N deletions count bar.',
          category: PropertyCategory.lineDisplay,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
        PlaygroundPropertyDefinition(
          key: 'showChangeNavigation',
          apiPath: 'configuration.showChangeNavigation',
          label: 'Show Change Navigation Bar',
          description:
              'Provides Previous/Next change jumping controls in footer.',
          category: PropertyCategory.lineDisplay,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
        PlaygroundPropertyDefinition(
          key: 'collapseUnchangedLines',
          apiPath: 'configuration.collapseUnchangedLines',
          label: 'Collapse Unchanged Lines',
          description:
              'Hides long sections of unchanged lines with an expand button.',
          category: PropertyCategory.lineDisplay,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
        PlaygroundPropertyDefinition(
          key: 'contextLines',
          apiPath: 'configuration.contextLines',
          label: 'Context Lines',
          description:
              'Number of unchanged lines to show around each change block.',
          category: PropertyCategory.lineDisplay,
          editorType: EditorType.number,
          defaultValue: 3,
          min: 0,
          max: 10,
          divisions: 10,
        ),

        // --- Diff & Granularity ---
        PlaygroundPropertyDefinition(
          key: 'granularity',
          apiPath: 'configuration.granularity',
          label: 'Diff Granularity',
          description:
              'Controls intra-line edit detection precision (word, character, line-only, auto).',
          category: PropertyCategory.diffBehavior,
          editorType: EditorType.dropdown,
          defaultValue: DiffGranularity.word,
          options: DiffGranularity.values,
        ),
        PlaygroundPropertyDefinition(
          key: 'ignoreWhitespace',
          apiPath: 'configuration.ignoreWhitespace',
          label: 'Ignore Whitespace',
          description:
              'Ignores leading/trailing space differences when matching lines.',
          category: PropertyCategory.diffBehavior,
          editorType: EditorType.boolean,
          defaultValue: false,
        ),
        PlaygroundPropertyDefinition(
          key: 'caseSensitive',
          apiPath: 'configuration.caseSensitive',
          label: 'Case Sensitive',
          description: 'Controls case sensitivity during line and word diffs.',
          category: PropertyCategory.diffBehavior,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),

        // --- Colors & Theme ---
        PlaygroundPropertyDefinition(
          key: 'addedBackgroundColor',
          apiPath: 'configuration.theme.addedBackgroundColor',
          label: 'Added Row Background Color',
          description: 'Background color for added content lines.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFE6FFEC),
        ),
        PlaygroundPropertyDefinition(
          key: 'addedTextColor',
          apiPath: 'configuration.theme.addedTextColor',
          label: 'Added Text Color',
          description: 'Text color for added lines and segments.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFF1A7F37),
        ),
        PlaygroundPropertyDefinition(
          key: 'addedHighlightColor',
          apiPath: 'configuration.theme.addedHighlightColor',
          label: 'Added Segment Highlight Color',
          description: 'Intra-line word/character highlight for additions.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFABF2BC),
        ),
        PlaygroundPropertyDefinition(
          key: 'removedBackgroundColor',
          apiPath: 'configuration.theme.removedBackgroundColor',
          label: 'Removed Row Background Color',
          description: 'Background color for deleted content lines.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFFFEBE9),
        ),
        PlaygroundPropertyDefinition(
          key: 'removedTextColor',
          apiPath: 'configuration.theme.removedTextColor',
          label: 'Removed Text Color',
          description: 'Text color for deleted lines and segments.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFCF222E),
        ),
        PlaygroundPropertyDefinition(
          key: 'removedHighlightColor',
          apiPath: 'configuration.theme.removedHighlightColor',
          label: 'Removed Segment Highlight Color',
          description: 'Intra-line word/character highlight for deletions.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFFFCDD2),
        ),
        PlaygroundPropertyDefinition(
          key: 'unchangedBackgroundColor',
          apiPath: 'configuration.theme.unchangedBackgroundColor',
          label: 'Unchanged Row Background Color',
          description: 'Background color for unmodified lines.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFFFFFFF),
        ),
        PlaygroundPropertyDefinition(
          key: 'panelBackgroundColor',
          apiPath: 'configuration.theme.panelBackgroundColor',
          label: 'Split Panel Card Background',
          description:
              'Background color of individual panel card boxes when split.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFFFFFFF),
        ),
        PlaygroundPropertyDefinition(
          key: 'panelBorderColor',
          apiPath: 'configuration.theme.panelBorderColor',
          label: 'Split Panel Card Border Color',
          description:
              'Border color of individual panel card boxes when split.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFD0D7DE),
        ),
        PlaygroundPropertyDefinition(
          key: 'lineNumberBackgroundColor',
          apiPath: 'configuration.theme.lineNumberBackgroundColor',
          label: 'Line Number Gutter Background',
          description: 'Background color of the line number column.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFF6F8FA),
        ),
        PlaygroundPropertyDefinition(
          key: 'borderColor',
          apiPath: 'configuration.theme.borderColor',
          label: 'Border Color',
          description: 'Color of outer border.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFD0D7DE),
        ),
        PlaygroundPropertyDefinition(
          key: 'dividerColor',
          apiPath: 'configuration.theme.dividerColor',
          label: 'Center Panel Divider Color',
          description:
              'Color of the central vertical divider between original and modified panels in side-by-side view.',
          category: PropertyCategory.colors,
          editorType: EditorType.color,
          defaultValue: const Color(0xFFD0D7DE),
        ),

        // --- Spacing & Sizes ---
        PlaygroundPropertyDefinition(
          key: 'panelSpacing',
          apiPath: 'configuration.spacing.panelSpacing',
          label: 'Panel Box Gap / In-Between Spacing (px)',
          description:
              'Gap distance in pixels between the left (original) and right (modified) panel card boxes.',
          category: PropertyCategory.spacing,
          editorType: EditorType.number,
          defaultValue: 0.0,
          min: 0.0,
          max: 32.0,
          divisions: 32,
        ),
        PlaygroundPropertyDefinition(
          key: 'panelBorderRadius',
          apiPath: 'configuration.spacing.panelBorderRadius',
          label: 'Panel Card Border Radius (px)',
          description:
              'Corner radius for individual left and right panel card boxes.',
          category: PropertyCategory.spacing,
          editorType: EditorType.number,
          defaultValue: 6.0,
          min: 0.0,
          max: 24.0,
          divisions: 24,
        ),
        PlaygroundPropertyDefinition(
          key: 'panelBorderWidth',
          apiPath: 'configuration.spacing.panelBorderWidth',
          label: 'Panel Card Border Width (px)',
          description:
              'Border line width for individual left and right panel card boxes.',
          category: PropertyCategory.spacing,
          editorType: EditorType.number,
          defaultValue: 1.0,
          min: 0.0,
          max: 8.0,
          divisions: 16,
        ),
        PlaygroundPropertyDefinition(
          key: 'dividerWidth',
          apiPath: 'configuration.spacing.dividerWidth',
          label: 'Center Panel Divider Width (px)',
          description:
              'Width of the central vertical divider separating old/original and new/modified panels.',
          category: PropertyCategory.spacing,
          editorType: EditorType.number,
          defaultValue: 1.0,
          min: 0.0,
          max: 12.0,
          divisions: 24,
        ),
        PlaygroundPropertyDefinition(
          key: 'lineHeight',
          apiPath: 'configuration.spacing.lineHeight',
          label: 'Line Row Height (px)',
          description: 'Fixed height of each diff row for virtual rendering.',
          category: PropertyCategory.spacing,
          editorType: EditorType.number,
          defaultValue: 22.0,
          min: 16.0,
          max: 40.0,
          divisions: 24,
        ),
        PlaygroundPropertyDefinition(
          key: 'lineNumberWidth',
          apiPath: 'configuration.spacing.lineNumberWidth',
          label: 'Line Number Column Width (px)',
          description: 'Width reserved for line number gutter.',
          category: PropertyCategory.spacing,
          editorType: EditorType.number,
          defaultValue: 52.0,
          min: 30.0,
          max: 90.0,
          divisions: 20,
        ),
        PlaygroundPropertyDefinition(
          key: 'borderRadius',
          apiPath: 'configuration.spacing.borderRadius',
          label: 'Corner Border Radius (px)',
          description: 'Rounding radius of outer viewer container.',
          category: PropertyCategory.spacing,
          editorType: EditorType.number,
          defaultValue: 6.0,
          min: 0.0,
          max: 24.0,
          divisions: 24,
        ),

        // --- Interaction & Performance ---
        PlaygroundPropertyDefinition(
          key: 'enableTextSelection',
          apiPath: 'configuration.enableTextSelection',
          label: 'Enable Text Selection',
          description: 'Allows users to highlight and copy diff text.',
          category: PropertyCategory.interaction,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
        PlaygroundPropertyDefinition(
          key: 'synchronizedScrolling',
          apiPath: 'configuration.synchronizedScrolling',
          label: 'Synchronized Scrolling',
          description:
              'Scrolls left and right panels together in side-by-side mode.',
          category: PropertyCategory.interaction,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
        PlaygroundPropertyDefinition(
          key: 'useIsolateForLargeDocuments',
          apiPath: 'configuration.useIsolateForLargeDocuments',
          label: 'Use Background Isolate (>1000 lines)',
          description:
              'Calculates large document diffs off the main UI thread.',
          category: PropertyCategory.performance,
          editorType: EditorType.boolean,
          defaultValue: true,
        ),
      ];
}
