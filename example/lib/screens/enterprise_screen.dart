import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class EnterpriseScreen extends StatefulWidget {
  const EnterpriseScreen({super.key});

  @override
  State<EnterpriseScreen> createState() => _EnterpriseScreenState();
}

class _EnterpriseScreenState extends State<EnterpriseScreen> {
  DiffGranularity _granularity = DiffGranularity.character;
  bool _showNavigation = true;
  bool _showSummary = true;

  void _showCode() {
    final code = '''
FlutterDiffViewer(
  oldContent: privacyNoticeV1_2,
  newContent: privacyNoticeV1_3,
  oldLabel: 'PN00736 v1.2',
  newLabel: 'PN00736 v1.3',
  configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
    layout: DiffLayout.sideBySide,
    granularity: DiffGranularity.${_granularity.name},
    showSummary: $_showSummary,
    showChangeNavigation: $_showNavigation,
    collapseUnchangedLines: true,
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Enterprise Legal Document Comparison',
      description:
          'Flagship enterprise showcase comparing Privacy Notice PN00736 v1.2 vs v1.3 with full summary bar and change navigation controls.',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = FlutterDiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.sideBySide,
      granularity: _granularity,
      showSummary: _showSummary,
      showChangeNavigation: _showNavigation,
      collapseUnchangedLines: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enterprise Legal Document Diff'),
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
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _granularity = val);
                      },
                    ),
                  ],
                ),
                FilterChip(
                  label: Text(
                      'Change Navigation: ${_showNavigation ? "ON" : "OFF"}'),
                  selected: _showNavigation,
                  onSelected: (val) => setState(() => _showNavigation = val),
                ),
                FilterChip(
                  label: Text('Summary Bar: ${_showSummary ? "ON" : "OFF"}'),
                  selected: _showSummary,
                  onSelected: (val) => setState(() => _showSummary = val),
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
                    'enterprise_${_granularity.name}_${_showNavigation}_$_showSummary'),
                oldContent: SampleData.privacyOld,
                newContent: SampleData.privacyNew,
                oldLabel: 'PN00736 v1.2',
                newLabel: 'PN00736 v1.3',
                configuration: config,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
