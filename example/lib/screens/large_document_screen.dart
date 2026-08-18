import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class LargeDocumentScreen extends StatelessWidget {
  const LargeDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final oldText = SampleData.generateLargeOld(500);
    final newText = SampleData.generateLargeNew(500);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Large Document Performance (500 Lines)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Uses virtualized ListView rendering and async diff calculation.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: DiffViewer(
                oldContent: oldText,
                newContent: newText,
                oldLabel: '500 Lines Old',
                newLabel: '500 Lines New',
                configuration: DiffViewerConfiguration.defaults().copyWith(
                  useIsolateForLargeDocuments: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
