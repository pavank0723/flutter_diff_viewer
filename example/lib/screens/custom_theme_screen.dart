import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

enum ThemePalette {
  purpleTeal('Purple & Teal'),
  emerald('Emerald Corporate'),
  solarized('Solarized Warm');

  final String label;
  const ThemePalette(this.label);
}

class CustomThemeScreen extends StatefulWidget {
  const CustomThemeScreen({super.key});

  @override
  State<CustomThemeScreen> createState() => _CustomThemeScreenState();
}

class _CustomThemeScreenState extends State<CustomThemeScreen> {
  ThemePalette _palette = ThemePalette.purpleTeal;
  double _borderRadius = 8.0;

  FlutterDiffViewerTheme _buildTheme() {
    switch (_palette) {
      case ThemePalette.purpleTeal:
        return FlutterDiffViewerTheme.light().copyWith(
          addedBackgroundColor: const Color(0xFFE8F5E9),
          removedBackgroundColor: const Color(0xFFEDE7F6),
          addedHighlightColor: const Color(0xFFC8E6C9),
          removedHighlightColor: const Color(0xFFD1C4E9),
          addedTextColor: const Color(0xFF2E7D32),
          removedTextColor: const Color(0xFF6A1B9A),
        );
      case ThemePalette.emerald:
        return FlutterDiffViewerTheme.light().copyWith(
          addedBackgroundColor: const Color(0xFFE0F2F1),
          removedBackgroundColor: const Color(0xFFFFEBEE),
          addedHighlightColor: const Color(0xFFB2DFDB),
          removedHighlightColor: const Color(0xFFFFCDD2),
          addedTextColor: const Color(0xFF00695C),
          removedTextColor: const Color(0xFFC62828),
        );
      case ThemePalette.solarized:
        return FlutterDiffViewerTheme.light().copyWith(
          addedBackgroundColor: const Color(0xFFFDF6E3),
          removedBackgroundColor: const Color(0xFFFEECEB),
          addedHighlightColor: const Color(0xFFEEE8D5),
          removedHighlightColor: const Color(0xFFFAD7D3),
          addedTextColor: const Color(0xFF859900),
          removedTextColor: const Color(0xFFCB4B16),
        );
    }
  }

  void _showCode() {
    final theme = _buildTheme();
    final code = '''
FlutterDiffViewer(
  oldContent: oldText,
  newContent: newText,
  configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
    spacing: DiffSpacing.defaults().copyWith(
      borderRadius: $_borderRadius,
    ),
    theme: FlutterDiffViewerTheme.light().copyWith(
      addedBackgroundColor: const Color(0x${theme.addedBackgroundColor.toARGB32().toRadixString(16).toUpperCase()}),
      addedTextColor: const Color(0x${theme.addedTextColor.toARGB32().toRadixString(16).toUpperCase()}),
      removedBackgroundColor: const Color(0x${theme.removedBackgroundColor.toARGB32().toRadixString(16).toUpperCase()}),
      removedTextColor: const Color(0x${theme.removedTextColor.toARGB32().toRadixString(16).toUpperCase()}),
    ),
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Custom Themed Diff Viewer',
      description:
          'Fully custom brand palette with customized background row colors, highlight colors, and border radius.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = FlutterDiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.sideBySide,
      theme: _buildTheme(),
      spacing: DiffSpacing(
        lineHeight: 22.0,
        lineNumberWidth: 52.0,
        indicatorWidth: 20.0,
        horizontalPadding: 8.0,
        verticalPadding: 2.0,
        borderWidth: 1.0,
        headerHeight: 40.0,
        summaryHeight: 32.0,
        borderRadius: _borderRadius,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Theme'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.code, size: 16),
            label: const Text('View Code'),
            onPressed: _showCode,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Customize in Studio',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PlaygroundScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Control Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Palette: ', style: TextStyle(fontSize: 12)),
                    DropdownButton<ThemePalette>(
                      value: _palette,
                      isDense: true,
                      items: ThemePalette.values.map((p) {
                        return DropdownMenuItem(value: p, child: Text(p.label));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _palette = val);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Border Radius: ${_borderRadius.toInt()}px ',
                        style: const TextStyle(fontSize: 12)),
                    Slider(
                      value: _borderRadius,
                      min: 0,
                      max: 20,
                      divisions: 20,
                      onChanged: (val) => setState(() => _borderRadius = val),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main View
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlutterDiffViewer(
                key: ValueKey('custom_${_palette.name}_$_borderRadius'),
                oldContent: SampleData.shortOld,
                newContent: SampleData.shortNew,
                configuration: config,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
