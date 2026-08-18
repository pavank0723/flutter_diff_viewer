import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class ChangeNavigationScreen extends StatefulWidget {
  const ChangeNavigationScreen({super.key});

  @override
  State<ChangeNavigationScreen> createState() => _ChangeNavigationScreenState();
}

class _ChangeNavigationScreenState extends State<ChangeNavigationScreen> {
  late final DiffViewerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DiffViewerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programmatic Change Navigation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total changes: ${_controller.totalChanges}'),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _controller.hasPreviousChange
                              ? _controller.previousChange
                              : null,
                          icon: const Icon(Icons.arrow_upward),
                          label: const Text('Prev'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _controller.hasNextChange
                              ? _controller.nextChange
                              : null,
                          icon: const Icon(Icons.arrow_downward),
                          label: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: DiffViewer(
                oldContent: SampleData.privacyOld,
                newContent: SampleData.privacyNew,
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
