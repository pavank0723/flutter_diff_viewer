import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/code_generator.dart';

class IntegrationGuideDialog extends StatelessWidget {
  final String currentCode;

  const IntegrationGuideDialog({
    required this.currentCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final guideText = CodeGenerator.generateIntegrationSnippet('1.0.0');

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.integration_instructions, color: Color(0xFF0969DA)),
          SizedBox(width: 8),
          Text('Use in Your Flutter Project',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Follow these simple steps to integrate this customized DiffViewer into your existing codebase:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  guideText,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Color(0xFFD4D4D4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final fullSnippet = '''
import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

// Copy-pasted from Flutter Diff Viewer Customization Studio
Widget buildMyDiffViewer(String oldText, String newText) {
  return $currentCode;
}
''';
            Clipboard.setData(ClipboardData(text: fullSnippet));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Full integration code copied to clipboard!'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.copy, size: 16),
          label: const Text('Copy Integration Code'),
        ),
      ],
    );
  }
}
