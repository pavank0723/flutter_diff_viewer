import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class DarkModeScreen extends StatefulWidget {
  const DarkModeScreen({super.key});

  @override
  State<DarkModeScreen> createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  bool _showLineNumbers = true;
  DiffLayout _layout = DiffLayout.sideBySide;

  void _showCode() {
    final code = '''
Theme(
  data: ThemeData.dark(),
  child: FlutterDiffViewer(
    oldContent: oldText,
    newContent: newText,
    configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.${_layout.name},
      showLineNumbers: $_showLineNumbers,
      theme: FlutterDiffViewerTheme.dark(),
    ),
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Dark Mode Diff Theme',
      description:
          'GitHub-style dark mode preset with optimized dark background rows and high-visibility highlights.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = FlutterDiffViewerConfiguration.defaults().copyWith(
      layout: _layout,
      showLineNumbers: _showLineNumbers,
      theme: FlutterDiffViewerTheme.dark(),
    );

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        appBar: AppBar(
          title: const Text('Dark Mode Theme'),
          backgroundColor: const Color(0xFF161B22),
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
              color: const Color(0xFF161B22),
              child: Row(
                children: [
                  const Text('Layout: ', style: TextStyle(fontSize: 12)),
                  DropdownButton<DiffLayout>(
                    value: _layout,
                    isDense: true,
                    dropdownColor: const Color(0xFF161B22),
                    items: const [
                      DropdownMenuItem(
                          value: DiffLayout.sideBySide,
                          child: Text('Side-by-Side')),
                      DropdownMenuItem(
                          value: DiffLayout.unified, child: Text('Unified')),
                      DropdownMenuItem(
                          value: DiffLayout.stacked, child: Text('Stacked')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _layout = val);
                    },
                  ),
                  const SizedBox(width: 16),
                  FilterChip(
                    label: Text(
                        'Line Numbers: ${_showLineNumbers ? "ON" : "OFF"}'),
                    selected: _showLineNumbers,
                    onSelected: (val) => setState(() => _showLineNumbers = val),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF30363D)),

            // Main View
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FlutterDiffViewer(
                  key: ValueKey('dark_${_layout.name}_$_showLineNumbers'),
                  oldContent: SampleData.codeOld,
                  newContent: SampleData.codeNew,
                  configuration: config,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
