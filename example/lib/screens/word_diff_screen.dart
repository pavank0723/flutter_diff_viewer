import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class WordDiffScreen extends StatefulWidget {
  const WordDiffScreen({super.key});

  @override
  State<WordDiffScreen> createState() => _WordDiffScreenState();
}

class _WordDiffScreenState extends State<WordDiffScreen> {
  DiffGranularity _granularity = DiffGranularity.word;
  bool _caseSensitive = true;
  bool _ignoreWhitespace = false;

  void _showCode() {
    final code = '''
FlutterDiffViewer(
  oldContent: oldText,
  newContent: newText,
  configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
    granularity: DiffGranularity.${_granularity.name},
    caseSensitive: $_caseSensitive,
    ignoreWhitespace: $_ignoreWhitespace,
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Word-Level Diff Highlighting',
      description:
          'Highlights only the changed words within modified lines rather than marking the whole line.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = FlutterDiffViewerConfiguration.defaults().copyWith(
      granularity: _granularity,
      caseSensitive: _caseSensitive,
      ignoreWhitespace: _ignoreWhitespace,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word-Level Granularity'),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Granularity: ', style: TextStyle(fontSize: 12)),
                    DropdownButton<DiffGranularity>(
                      value: _granularity,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(
                            value: DiffGranularity.word,
                            child: Text('Word Level')),
                        DropdownMenuItem(
                            value: DiffGranularity.character,
                            child: Text('Character Level')),
                        DropdownMenuItem(
                            value: DiffGranularity.line,
                            child: Text('Line Only')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _granularity = val);
                      },
                    ),
                  ],
                ),
                FilterChip(
                  label:
                      Text('Case Sensitive: ${_caseSensitive ? "ON" : "OFF"}'),
                  selected: _caseSensitive,
                  onSelected: (val) => setState(() => _caseSensitive = val),
                ),
                FilterChip(
                  label: Text(
                      'Ignore Whitespace: ${_ignoreWhitespace ? "ON" : "OFF"}'),
                  selected: _ignoreWhitespace,
                  onSelected: (val) => setState(() => _ignoreWhitespace = val),
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
                    'word_${_granularity.name}_${_caseSensitive}_$_ignoreWhitespace'),
                oldContent: SampleData.wordOld,
                newContent: SampleData.wordNew,
                configuration: config,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
