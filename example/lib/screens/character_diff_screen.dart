import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class CharacterDiffScreen extends StatefulWidget {
  const CharacterDiffScreen({super.key});

  @override
  State<CharacterDiffScreen> createState() => _CharacterDiffScreenState();
}

class _CharacterDiffScreenState extends State<CharacterDiffScreen> {
  DiffGranularity _granularity = DiffGranularity.character;
  bool _caseSensitive = true;

  void _showCode() {
    final code = '''
DiffViewer(
  oldContent: oldText,
  newContent: newText,
  configuration: DiffViewerConfiguration.defaults().copyWith(
    granularity: DiffGranularity.${_granularity.name},
    caseSensitive: $_caseSensitive,
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Character-Level Precision Diff',
      description:
          'High-precision diffing that highlights exact individual character changes within words.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = DiffViewerConfiguration.defaults().copyWith(
      granularity: _granularity,
      caseSensitive: _caseSensitive,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character-Level Granularity'),
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
                            value: DiffGranularity.character,
                            child: Text('Character Level')),
                        DropdownMenuItem(
                            value: DiffGranularity.word,
                            child: Text('Word Level')),
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
              ],
            ),
          ),
          const Divider(height: 1),

          // Main View
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DiffViewer(
                key: ValueKey('char_${_granularity.name}_$_caseSensitive'),
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
