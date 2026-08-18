import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class UnifiedScreen extends StatefulWidget {
  const UnifiedScreen({super.key});

  @override
  State<UnifiedScreen> createState() => _UnifiedScreenState();
}

class _UnifiedScreenState extends State<UnifiedScreen> {
  bool _showLineNumbers = true;
  bool _showIndicators = true;
  bool _collapseUnchanged = true;
  int _contextLines = 3;

  void _showCode() {
    final code = '''
DiffViewer(
  oldContent: oldContent,
  newContent: newContent,
  oldLabel: 'Current',
  newLabel: 'Modified',
  configuration: DiffViewerConfiguration.defaults().copyWith(
    layout: DiffLayout.unified,
    showLineNumbers: $_showLineNumbers,
    showIndicators: $_showIndicators,
    collapseUnchangedLines: $_collapseUnchanged,
    contextLines: $_contextLines,
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Unified Git Diff View',
      description:
          'Renders changes in a single unified linear list with + and - line indicators.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = DiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.unified,
      showLineNumbers: _showLineNumbers,
      showIndicators: _showIndicators,
      collapseUnchangedLines: _collapseUnchanged,
      contextLines: _contextLines,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unified Diff View'),
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
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label:
                      Text('Line Numbers: ${_showLineNumbers ? "ON" : "OFF"}'),
                  selected: _showLineNumbers,
                  onSelected: (val) => setState(() => _showLineNumbers = val),
                ),
                FilterChip(
                  label: Text(
                      'Indicators (+/-): ${_showIndicators ? "ON" : "OFF"}'),
                  selected: _showIndicators,
                  onSelected: (val) => setState(() => _showIndicators = val),
                ),
                FilterChip(
                  label: Text(
                      'Collapse Unchanged: ${_collapseUnchanged ? "ON" : "OFF"}'),
                  selected: _collapseUnchanged,
                  onSelected: (val) => setState(() => _collapseUnchanged = val),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Context Lines: ',
                        style: TextStyle(fontSize: 12)),
                    DropdownButton<int>(
                      value: _contextLines,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1 line')),
                        DropdownMenuItem(
                            value: 3, child: Text('3 lines (Default)')),
                        DropdownMenuItem(value: 5, child: Text('5 lines')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _contextLines = val);
                      },
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
              child: DiffViewer(
                key: ValueKey(
                    'unified_${_showLineNumbers}_${_showIndicators}_${_collapseUnchanged}_$_contextLines'),
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
