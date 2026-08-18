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
  double _dividerWidth = 1.0;

  void _showCode() {
    final code = '''
DiffViewer(
  oldContent: oldContent,
  newContent: newContent,
  oldLabel: 'main.dart (v1.0)',
  newLabel: 'main.dart (v2.0)',
  configuration: DiffViewerConfiguration.defaults().copyWith(
    layout: DiffLayout.sideBySide,
    showLineNumbers: $_showLineNumbers,
    synchronizedScrolling: $_synchronizedScrolling,
    spacing: DiffSpacing.defaults().copyWith(
      dividerWidth: $_dividerWidth,
    ),
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Side-by-Side Diff View',
      description:
          'Displays original and modified content in two parallel synchronized scrolling columns.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = DiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.sideBySide,
      showLineNumbers: _showLineNumbers,
      synchronizedScrolling: _synchronizedScrolling,
      spacing: DiffSpacing(
        lineHeight: 22.0,
        lineNumberWidth: 52.0,
        indicatorWidth: 20.0,
        horizontalPadding: 8.0,
        verticalPadding: 2.0,
        borderWidth: 1.0,
        borderRadius: 6.0,
        headerHeight: 40.0,
        summaryHeight: 32.0,
        dividerWidth: _dividerWidth,
      ),
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
              spacing: 16,
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
                      'Sync Scroll: ${_synchronizedScrolling ? "ON" : "OFF"}'),
                  selected: _synchronizedScrolling,
                  onSelected: (val) =>
                      setState(() => _synchronizedScrolling = val),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Divider Width: ',
                        style: TextStyle(fontSize: 12)),
                    DropdownButton<double>(
                      value: _dividerWidth,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(
                            value: 1.0, child: Text('1 px (Default)')),
                        DropdownMenuItem(value: 3.0, child: Text('3 px')),
                        DropdownMenuItem(value: 6.0, child: Text('6 px')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _dividerWidth = val);
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
              child: DiffViewer(
                key: ValueKey(
                    'side_by_side_${_showLineNumbers}_${_synchronizedScrolling}_$_dividerWidth'),
                oldContent: SampleData.codeOld,
                newContent: SampleData.codeNew,
                oldLabel: 'main.dart (v1.0)',
                newLabel: 'main.dart (v2.0)',
                configuration: config,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
