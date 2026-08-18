import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class UnifiedScreen extends StatelessWidget {
  const UnifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unified Diff View')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DiffViewer(
          oldContent: SampleData.shortOld,
          newContent: SampleData.shortNew,
          oldLabel: 'Original Document',
          newLabel: 'Updated Document',
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.unified,
          ),
        ),
      ),
    );
  }
}
