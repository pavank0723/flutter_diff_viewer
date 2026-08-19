import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../playground/screens/playground_screen.dart';
import '../sample_data.dart';
import '../widgets/feature_code_dialog.dart';

class ChangeNavigationScreen extends StatefulWidget {
  const ChangeNavigationScreen({super.key});

  @override
  State<ChangeNavigationScreen> createState() => _ChangeNavigationScreenState();
}

class _ChangeNavigationScreenState extends State<ChangeNavigationScreen> {
  late final FlutterDiffViewerController _diffController;

  @override
  void initState() {
    super.initState();
    _diffController = FlutterDiffViewerController();
  }

  @override
  void dispose() {
    _diffController.dispose();
    super.dispose();
  }

  void _showCode() {
    const code = '''
final controller = FlutterDiffViewerController();

// Programmatic navigation:
controller.nextChange();
controller.previousChange();
controller.jumpToChange(2);

FlutterDiffViewer(
  oldContent: oldText,
  newContent: newText,
  controller: controller,
  configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
    showChangeNavigation: true,
  ),
)''';

    FeatureCodeDialog.show(
      context,
      title: 'Programmatic Change Navigation',
      description:
          'Control diff line jumping programmatically using FlutterDiffViewerController.nextChange() and previousChange().',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = FlutterDiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.sideBySide,
      showChangeNavigation: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Navigation Controller'),
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
          // External Programmatic Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: ListenableBuilder(
              listenable: _diffController,
              builder: (context, _) {
                final current = _diffController.currentChangeIndex;
                final total = _diffController.totalChanges;

                return Row(
                  children: [
                    Text(
                      'Programmatic Controls (${total > 0 ? "Change ${current + 1} of $total" : "Calculating..."})',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_upward, size: 14),
                      label: const Text('Prev Change'),
                      onPressed:
                          total > 0 ? _diffController.previousChange : null,
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_downward, size: 14),
                      label: const Text('Next Change'),
                      onPressed: total > 0 ? _diffController.nextChange : null,
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Main View
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlutterDiffViewer(
                oldContent: SampleData.privacyOld,
                newContent: SampleData.privacyNew,
                controller: _diffController,
                configuration: config,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
