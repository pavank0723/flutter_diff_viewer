import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class SideBySideScreen extends StatelessWidget {
  const SideBySideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Side-by-Side Diff View')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DiffViewer(
          oldContent: SampleData.codeOld,
          newContent: SampleData.codeNew,
          oldLabel: 'main.dart (v1.0)',
          newLabel: 'main.dart (v2.0)',
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.sideBySide,
          ),
        ),
      ),
    );
  }
}
