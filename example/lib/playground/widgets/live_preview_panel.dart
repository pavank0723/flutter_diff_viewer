import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../domain/playground_preset.dart';
import '../state/playground_controller.dart';
import 'preset_selector_widget.dart';

class LivePreviewPanel extends StatelessWidget {
  final PlaygroundController controller;

  const LivePreviewPanel({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final state = controller.state;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye_outlined,
                          size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Live Diff Preview',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          state.configuration.layout.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  PresetSelectorWidget(
                    activePresetId: state.activePresetId,
                    onSelectPreset: (PlaygroundPreset preset) {
                      controller.applyPreset(preset);
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Main Live FlutterDiffViewer Widget
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FlutterDiffViewer(
                  key: ValueKey(
                    'preview_${state.configuration.hashCode}_${state.oldLabel}_${state.newLabel}',
                  ),
                  oldContent: state.oldContent,
                  newContent: state.newContent,
                  oldLabel: state.oldLabel,
                  newLabel: state.newLabel,
                  configuration: state.configuration,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
