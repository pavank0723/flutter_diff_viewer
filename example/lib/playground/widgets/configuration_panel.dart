import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../domain/playground_property_definition.dart';
import '../domain/property_registry.dart';
import '../state/playground_controller.dart';
import '../state/playground_state.dart';
import 'property_editors/boolean_editor.dart';
import 'property_editors/color_editor.dart';
import 'property_editors/dropdown_editor.dart';
import 'property_editors/number_editor.dart';
import 'property_editors/text_editor.dart';

class ConfigurationPanel extends StatelessWidget {
  final PlaygroundController controller;

  const ConfigurationPanel({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final state = controller.state;
        final query = state.searchQuery.toLowerCase().trim();

        final filtered = PropertyRegistry.definitions.where((def) {
          if (query.isEmpty) return true;
          return def.label.toLowerCase().contains(query) ||
              def.key.toLowerCase().contains(query) ||
              def.apiPath.toLowerCase().contains(query) ||
              def.description.toLowerCase().contains(query);
        }).toList();

        // Group by category
        final Map<PropertyCategory, List<PlaygroundPropertyDefinition>>
            categoriesMap = {};
        for (final def in filtered) {
          categoriesMap.putIfAbsent(def.category, () => []).add(def);
        }

        return Column(
          children: [
            // Search & Quick Action Toolbar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: '🔍 Search property (e.g. color, lines...)',
                      isDense: true,
                      prefixIcon: const Icon(Icons.search, size: 18),
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () => controller.setSearchQuery(''),
                            )
                          : null,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: controller.setSearchQuery,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.undo, size: 18),
                        tooltip: 'Undo change',
                        onPressed: state.canUndo ? controller.undo : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.redo, size: 18),
                        tooltip: 'Redo change',
                        onPressed: state.canRedo ? controller.redo : null,
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.restart_alt, size: 16),
                        label: const Text('Reset All',
                            style: TextStyle(fontSize: 12)),
                        onPressed: controller.resetAll,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Accordion List of Property Editors
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: categoriesMap.entries.map((entry) {
                  final category = entry.key;
                  final defs = entry.value;

                  return ExpansionTile(
                    initiallyExpanded: true,
                    leading: Icon(category.icon,
                        size: 18, color: Theme.of(context).colorScheme.primary),
                    title: Text(category.label,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    childrenPadding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    children: defs.map((def) {
                      return MouseRegion(
                        onEnter: (_) => controller.selectProperty(def.key),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: state.selectedPropertyKey == def.key
                                ? Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withValues(alpha: 0.3)
                                : null,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _buildEditor(def, state, controller),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditor(
    PlaygroundPropertyDefinition def,
    PlaygroundState state,
    PlaygroundController ctrl,
  ) {
    final config = state.configuration;

    switch (def.key) {
      case 'layout':
        return DropdownEditor<DiffLayout>(
          definition: def,
          value: config.layout,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(layout: val), 'Changed Layout to ${val.name}'),
        );
      case 'sideBySideBreakpoint':
        return NumberEditor(
          definition: def,
          value: config.sideBySideBreakpoint,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(sideBySideBreakpoint: val.toDouble()),
              'Changed Breakpoint'),
        );
      case 'oldVersionLabel':
        return TextEditor(
          definition: def,
          value: state.oldLabel,
          onChanged: (val) => ctrl.updateContents(oldLabel: val),
        );
      case 'newVersionLabel':
        return TextEditor(
          definition: def,
          value: state.newLabel,
          onChanged: (val) => ctrl.updateContents(newLabel: val),
        );
      case 'showLineNumbers':
        return BooleanEditor(
          definition: def,
          value: config.showLineNumbers,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(showLineNumbers: val),
              'Toggled Line Numbers (${val ? "ON" : "OFF"})'),
        );
      case 'showIndicators':
        return BooleanEditor(
          definition: def,
          value: config.showIndicators,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(showIndicators: val),
              'Toggled Indicators (${val ? "ON" : "OFF"})'),
        );
      case 'showHeader':
        return BooleanEditor(
          definition: def,
          value: config.showHeader,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(showHeader: val),
              'Toggled Header (${val ? "ON" : "OFF"})'),
        );
      case 'showSummary':
        return BooleanEditor(
          definition: def,
          value: config.showSummary,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(showSummary: val), 'Toggled Summary Bar'),
        );
      case 'showChangeNavigation':
        return BooleanEditor(
          definition: def,
          value: config.showChangeNavigation,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(showChangeNavigation: val),
              'Toggled Change Navigation'),
        );
      case 'collapseUnchangedLines':
        return BooleanEditor(
          definition: def,
          value: config.collapseUnchangedLines,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(collapseUnchangedLines: val),
              'Toggled Collapse Unchanged'),
        );
      case 'contextLines':
        return NumberEditor(
          definition: def,
          value: config.contextLines,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(contextLines: val.toInt()),
              'Changed Context Lines to ${val.toInt()}'),
        );
      case 'granularity':
        return DropdownEditor<DiffGranularity>(
          definition: def,
          value: config.granularity,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(granularity: val),
              'Changed Granularity to ${val.name}'),
        );
      case 'ignoreWhitespace':
        return BooleanEditor(
          definition: def,
          value: config.ignoreWhitespace,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(ignoreWhitespace: val),
              'Toggled Ignore Whitespace'),
        );
      case 'caseSensitive':
        return BooleanEditor(
          definition: def,
          value: config.caseSensitive,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(caseSensitive: val), 'Toggled Case Sensitivity'),
        );
      case 'addedBackgroundColor':
        return ColorEditor(
          definition: def,
          value: config.theme.addedBackgroundColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  theme: config.theme.copyWith(addedBackgroundColor: val)),
              'Changed Added Background Color'),
        );
      case 'addedTextColor':
        return ColorEditor(
          definition: def,
          value: config.theme.addedTextColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  theme: config.theme.copyWith(addedTextColor: val)),
              'Changed Added Text Color'),
        );
      case 'addedHighlightColor':
        return ColorEditor(
          definition: def,
          value: config.theme.addedHighlightColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  theme: config.theme.copyWith(addedHighlightColor: val)),
              'Changed Added Highlight Color'),
        );
      case 'removedBackgroundColor':
        return ColorEditor(
          definition: def,
          value: config.theme.removedBackgroundColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  theme: config.theme.copyWith(removedBackgroundColor: val)),
              'Changed Removed Background Color'),
        );
      case 'removedTextColor':
        return ColorEditor(
          definition: def,
          value: config.theme.removedTextColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  theme: config.theme.copyWith(removedTextColor: val)),
              'Changed Removed Text Color'),
        );
      case 'removedHighlightColor':
        return ColorEditor(
          definition: def,
          value: config.theme.removedHighlightColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  theme: config.theme.copyWith(removedHighlightColor: val)),
              'Changed Removed Highlight Color'),
        );
      case 'unchangedBackgroundColor':
        return ColorEditor(
          definition: def,
          value: config.theme.unchangedBackgroundColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  theme: config.theme.copyWith(unchangedBackgroundColor: val)),
              'Changed Unchanged Background Color'),
        );
      case 'lineNumberBackgroundColor':
        return ColorEditor(
          definition: def,
          value: config.theme.lineNumberBackgroundColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  theme: config.theme.copyWith(lineNumberBackgroundColor: val)),
              'Changed Line Number Background Color'),
        );
      case 'borderColor':
        return ColorEditor(
          definition: def,
          value: config.theme.borderColor,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(theme: config.theme.copyWith(borderColor: val)),
              'Changed Border Color'),
        );
      case 'lineHeight':
        return NumberEditor(
          definition: def,
          value: config.spacing.lineHeight,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  spacing: config.spacing.copyWith(lineHeight: val.toDouble())),
              'Changed Line Height'),
        );
      case 'lineNumberWidth':
        return NumberEditor(
          definition: def,
          value: config.spacing.lineNumberWidth,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  spacing:
                      config.spacing.copyWith(lineNumberWidth: val.toDouble())),
              'Changed Line Number Width'),
        );
      case 'borderRadius':
        return NumberEditor(
          definition: def,
          value: config.spacing.borderRadius,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(
                  spacing:
                      config.spacing.copyWith(borderRadius: val.toDouble())),
              'Changed Border Radius'),
        );
      case 'enableTextSelection':
        return BooleanEditor(
          definition: def,
          value: config.enableTextSelection,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(enableTextSelection: val),
              'Toggled Text Selection'),
        );
      case 'synchronizedScrolling':
        return BooleanEditor(
          definition: def,
          value: config.synchronizedScrolling,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(synchronizedScrolling: val),
              'Toggled Synchronized Scrolling'),
        );
      case 'useIsolateForLargeDocuments':
        return BooleanEditor(
          definition: def,
          value: config.useIsolateForLargeDocuments,
          onChanged: (val) => ctrl.updateConfiguration(
              config.copyWith(useIsolateForLargeDocuments: val),
              'Toggled Isolate Computation'),
        );
      default:
        return Text('Unsupported editor for ${def.key}');
    }
  }
}
