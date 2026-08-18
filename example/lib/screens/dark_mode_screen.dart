import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class DarkModeScreen extends StatelessWidget {
  const DarkModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(useMaterial3: true),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        appBar: AppBar(
          title: const Text('Dark Mode Theme'),
          backgroundColor: const Color(0xFF161B22),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DiffViewer(
            oldContent: SampleData.codeOld,
            newContent: SampleData.codeNew,
            oldLabel: 'v1.0',
            newLabel: 'v2.0',
            theme: DiffViewerTheme.dark(),
          ),
        ),
      ),
    );
  }
}
