import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class StackedScreen extends StatefulWidget {
  const StackedScreen({super.key});

  @override
  State<StackedScreen> createState() => _StackedScreenState();
}

class _StackedScreenState extends State<StackedScreen> {
  bool _showLineNumbers = true;
  bool _showSummary = true;
  bool _collapseUnchanged = true;

  void _showCode() {
    final code = '''
FlutterDiffViewer(
  oldContent: oldContent,
  newContent: newContent,
  oldLabel: 'Original Text',
  newLabel: 'Updated Text',
  configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
    layout: DiffLayout.stacked,
    showLineNumbers: $_showLineNumbers,
    showSummary: $_showSummary,
    collapseUnchangedLines: $_collapseUnchanged,
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Stacked Mobile Diff View',
      description:
          'Renders original content on top and modified content below, optimized for mobile screens.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = FlutterDiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.stacked,
      showLineNumbers: _showLineNumbers,
      showSummary: _showSummary,
      collapseUnchangedLines: _collapseUnchanged,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stacked / Mobile Diff View'),
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
              children: [
                FilterChip(
                  label:
                      Text('Line Numbers: ${_showLineNumbers ? "ON" : "OFF"}'),
                  selected: _showLineNumbers,
                  onSelected: (val) => setState(() => _showLineNumbers = val),
                ),
                FilterChip(
                  label: Text('Summary Bar: ${_showSummary ? "ON" : "OFF"}'),
                  selected: _showSummary,
                  onSelected: (val) => setState(() => _showSummary = val),
                ),
                FilterChip(
                  label: Text(
                      'Collapse Unchanged: ${_collapseUnchanged ? "ON" : "OFF"}'),
                  selected: _collapseUnchanged,
                  onSelected: (val) => setState(() => _collapseUnchanged = val),
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
                key: ValueKey(
                    'stacked_${_showLineNumbers}_${_showSummary}_$_collapseUnchanged'),
                oldContent: SampleData.shortOld,
                newContent: SampleData.shortNew,
                oldLabel: 'Original Text',
                newLabel: 'Updated Text',
                configuration: config,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
