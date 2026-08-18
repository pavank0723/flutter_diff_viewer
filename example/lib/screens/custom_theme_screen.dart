import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../sample_data.dart';

class CustomThemeScreen extends StatelessWidget {
  const CustomThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = DiffViewerTheme.light().copyWith(
      addedBackgroundColor: const Color(0xFFE8F5E9),
      removedBackgroundColor: const Color(0xFFEDE7F6),
      addedHighlightColor: const Color(0xFFC8E6C9),
      removedHighlightColor: const Color(0xFFD1C4E9),
      addedTextColor: const Color(0xFF2E7D32),
      removedTextColor: const Color(0xFF6A1B9A),
      indicatorAddedColor: const Color(0xFF388E3C),
      indicatorRemovedColor: const Color(0xFF7B1FA2),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Purple/Green Theme')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DiffViewer(
          oldContent: SampleData.shortOld,
          newContent: SampleData.shortNew,
          oldLabel: 'Original',
          newLabel: 'Custom Theme',
          theme: customTheme,
        ),
      ),
    );
  }
}
