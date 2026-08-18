import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/code_generator.dart';
import '../state/playground_controller.dart';

class GeneratedCodePanel extends StatelessWidget {
  final PlaygroundController controller;

  const GeneratedCodePanel({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final state = controller.state;

        final code = CodeGenerator.generateCode(
          config: state.configuration,
          oldContentVarName: 'oldContent',
          newContentVarName: 'newContent',
          oldLabel: state.oldLabel,
          newLabel: state.newLabel,
          minimalMode: state.minimalCodeMode,
          includeImports: state.includeImports,
        );

        return Column(
          children: [
            // Toolbar Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.code, size: 18, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text(
                        'Generated Dart Code',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy, size: 14),
                        label: const Text('Copy Code',
                            style: TextStyle(fontSize: 12)),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '✓ Generated Dart code copied to clipboard!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FilterChip(
                        label: const Text('Minimal Code'),
                        selected: state.minimalCodeMode,
                        onSelected: (val) =>
                            controller.toggleMinimalCodeMode(val),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Include Imports'),
                        selected: state.includeImports,
                        onSelected: (val) =>
                            controller.toggleIncludeImports(val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Code Display Area
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF1E1E1E),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: SelectableText(
                    code,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFFD4D4D4),
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
