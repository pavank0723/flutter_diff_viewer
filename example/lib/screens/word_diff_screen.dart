import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class WordDiffScreen extends StatelessWidget {
  const WordDiffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word-Level Diff')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Word granularity calculates differences word by word inside modified lines.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Expanded(
              child: DiffViewer(
                oldContent: SampleData.wordOld,
                newContent: SampleData.wordNew,
                oldLabel: 'Original sentence',
                newLabel: 'Modified sentence',
                configuration: DiffViewerConfiguration.defaults().copyWith(
                  granularity: DiffGranularity.word,
                  layout: DiffLayout.unified,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
