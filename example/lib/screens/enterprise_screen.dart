import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class EnterpriseScreen extends StatelessWidget {
  const EnterpriseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enterprise Privacy Notice Comparison')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DiffViewer(
          oldContent: SampleData.privacyOld,
          newContent: SampleData.privacyNew,
          oldLabel: 'PN00736 v1.2',
          newLabel: 'PN00736 v1.3',
          configuration: DiffViewerConfiguration.defaults().copyWith(
            layout: DiffLayout.sideBySide,
            showSummary: true,
            showChangeNavigation: true,
            collapseUnchangedLines: true,
            contextLines: 2,
          ),
        ),
      ),
    );
  }
}
