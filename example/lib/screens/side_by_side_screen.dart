import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class SideBySideScreen extends StatefulWidget {
  const SideBySideScreen({super.key});

  @override
  State<SideBySideScreen> createState() => _SideBySideScreenState();
}

class _SideBySideScreenState extends State<SideBySideScreen> {
  bool _showLineNumbers = true;
  bool _synchronizedScrolling = true;
  bool _splitPanels = false;
  bool _splitBlocks = false;
  bool _customContainerColors = false;
  double _panelSpacing = 0.0;
  double _blockSpacing = 0.0;
  double _dividerWidth = 1.0;

  void _showCode() {
    final code = '''
FlutterDiffViewer(
  oldContent: oldContent,
  newContent: newContent,
  oldLabel: 'Current V1.1',
  newLabel: 'Modified V1.2',
  configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
    layout: DiffLayout.sideBySide,
    showLineNumbers: $_showLineNumbers,
    synchronizedScrolling: $_synchronizedScrolling,
    splitPanels: $_splitPanels,
    splitBlocks: $_splitBlocks,
    spacing: DiffSpacing.defaults().copyWith(
      panelSpacing: $_panelSpacing,
      blockSpacing: $_blockSpacing,
      dividerWidth: $_dividerWidth,
    ),
    theme: ${_customContainerColors ? "FlutterDiffViewerTheme.light().copyWith(\n      leftPanelBackgroundColor: const Color(0xFFF8FAFC),\n      rightPanelBackgroundColor: const Color(0xFFF0FDF4),\n    )" : "FlutterDiffViewerTheme.light()"},
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Side-by-Side Diff View',
      description:
          'Displays original and modified content in parallel columns with configurable container background colors, panel gaps, and diff block gaps.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = FlutterDiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.sideBySide,
      showLineNumbers: _showLineNumbers,
      synchronizedScrolling: _synchronizedScrolling,
      splitPanels: _splitPanels,
      splitBlocks: _splitBlocks,
      spacing: DiffSpacing.defaults().copyWith(
        panelSpacing: _panelSpacing,
        blockSpacing: _blockSpacing,
        dividerWidth: _dividerWidth,
      ),
      theme: _customContainerColors
          ? FlutterDiffViewerTheme.light().copyWith(
              leftPanelBackgroundColor: const Color(0xFFF8FAFC),
              rightPanelBackgroundColor: const Color(0xFFF0FDF4),
              leftPanelBorderColor: const Color(0xFFCBD5E1),
              rightPanelBorderColor: const Color(0xFF86EFAC),
              rightAddedBackgroundColor: const Color(0xFFDCFCE7),
              rightAddedHighlightColor: const Color(0xFF86EFAC),
            )
          : FlutterDiffViewerTheme.light(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Side-by-Side Diff View'),
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
          // Interactive Control Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: Text('Line Numbers: ${_showLineNumbers ? "ON" : "OFF"}'),
                  selected: _showLineNumbers,
                  onSelected: (val) => setState(() => _showLineNumbers = val),
                ),
                FilterChip(
                  label: Text('Sync Scroll: ${_synchronizedScrolling ? "ON" : "OFF"}'),
                  selected: _synchronizedScrolling,
                  onSelected: (val) =>
                      setState(() => _synchronizedScrolling = val),
                ),
                FilterChip(
                  label: Text('Container Colors: ${_customContainerColors ? "Custom" : "Default"}'),
                  selected: _customContainerColors,
                  onSelected: (val) =>
                      setState(() => _customContainerColors = val),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Panel Gap: ', style: TextStyle(fontSize: 12)),
                    DropdownButton<double>(
                      value: _panelSpacing,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 0.0, child: Text('0 px (None)')),
                        DropdownMenuItem(value: 12.0, child: Text('12 px')),
                        DropdownMenuItem(value: 16.0, child: Text('16 px')),
                        DropdownMenuItem(value: 24.0, child: Text('24 px')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _panelSpacing = val;
                            if (val > 0) _splitPanels = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Block Gap: ', style: TextStyle(fontSize: 12)),
                    DropdownButton<double>(
                      value: _blockSpacing,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 0.0, child: Text('0 px (None)')),
                        DropdownMenuItem(value: 8.0, child: Text('8 px')),
                        DropdownMenuItem(value: 12.0, child: Text('12 px')),
                        DropdownMenuItem(value: 16.0, child: Text('16 px')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _blockSpacing = val;
                            if (val > 0) _splitBlocks = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Diff Viewer Engine
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlutterDiffViewer(
                key: ValueKey(
                  'side_by_side_${_showLineNumbers}_${_synchronizedScrolling}_${_panelSpacing}_${_blockSpacing}_$_customContainerColors',
                ),
                oldContent: SampleData.codeOld,
                newContent: SampleData.codeNew,
                oldLabel: 'Current V1.1',
                newLabel: 'Modified V1.2',
                configuration: config,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
