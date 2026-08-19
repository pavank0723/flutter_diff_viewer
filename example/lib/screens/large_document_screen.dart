import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class LargeDocumentScreen extends StatefulWidget {
  const LargeDocumentScreen({super.key});

  @override
  State<LargeDocumentScreen> createState() => _LargeDocumentScreenState();
}

class _LargeDocumentScreenState extends State<LargeDocumentScreen> {
  int _lineCount = 500;
  bool _useIsolate = true;
  late String _oldText;
  late String _newText;

  @override
  void initState() {
    super.initState();
    _regenerateText();
  }

  void _regenerateText() {
    _oldText = SampleData.generateLargeOld(_lineCount);
    _newText = SampleData.generateLargeNew(_lineCount);
  }

  void _showCode() {
    final code = '''
FlutterDiffViewer(
  oldContent: largeOldText, // $_lineCount lines
  newContent: largeNewText, // $_lineCount lines
  configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
    useIsolateForLargeDocuments: $_useIsolate,
    collapseUnchangedLines: true,
    contextLines: 3,
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Large Document Performance & Isolate Diffing',
      description:
          'Uses virtualized ListView rendering and Flutter background isolates (compute) for smooth 60fps diffing of 500+ line documents.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = FlutterDiffViewerConfiguration.defaults().copyWith(
      useIsolateForLargeDocuments: _useIsolate,
      collapseUnchangedLines: true,
      contextLines: 3,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Large Document Benchmark ($_lineCount Lines)'),
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
                    const Text('Line Count: ', style: TextStyle(fontSize: 12)),
                    DropdownButton<int>(
                      value: _lineCount,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 100, child: Text('100 Lines')),
                        DropdownMenuItem(value: 500, child: Text('500 Lines')),
                        DropdownMenuItem(
                            value: 1000,
                            child: Text('1000 Lines (Isolate Active)')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _lineCount = val;
                            _regenerateText();
                          });
                        }
                      },
                    ),
                  ],
                ),
                FilterChip(
                  label:
                      Text('Background Isolate: ${_useIsolate ? "ON" : "OFF"}'),
                  selected: _useIsolate,
                  onSelected: (val) => setState(() => _useIsolate = val),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        'Virtualized ListView (${_lineCount * 2} items)',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
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
                key: ValueKey('large_${_lineCount}_$_useIsolate'),
                oldContent: _oldText,
                newContent: _newText,
                configuration: config,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
