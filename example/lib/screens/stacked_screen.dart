import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class StackedScreen extends StatelessWidget {
  const StackedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stacked Diff View (Mobile Optimized)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DiffViewer(
          oldContent: SampleData.shortOld,
          newContent: SampleData.shortNew,
          oldLabel: 'Original',
          newLabel: 'Modified',
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.stacked,
          ),
        ),
      ),
    );
  }
}
