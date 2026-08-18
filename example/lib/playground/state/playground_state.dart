import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../domain/configuration_snapshot.dart';

enum PlaygroundTab {
  controls('Controls', 0),
  preview('Preview', 1),
  code('Code', 2);

  final String label;
  final int tabIndex;
  const PlaygroundTab(this.label, this.tabIndex);
}

class PlaygroundState {
  final DiffViewerConfiguration configuration;
  final String oldContent;
  final String newContent;
  final String oldLabel;
  final String newLabel;
  final String activePresetId;
  final String searchQuery;
  final bool minimalCodeMode;
  final bool includeImports;
  final bool inspectMode;
  final String? selectedPropertyKey;
  final PlaygroundTab activeTab;
  final List<ConfigurationSnapshot> history;
  final int historyIndex;

  const PlaygroundState({
    required this.configuration,
    required this.oldContent,
    required this.newContent,
    required this.oldLabel,
    required this.newLabel,
    required this.activePresetId,
    required this.searchQuery,
    required this.minimalCodeMode,
    required this.includeImports,
    required this.inspectMode,
    required this.activeTab,
    required this.history,
    required this.historyIndex,
    this.selectedPropertyKey,
  });

  bool get canUndo => historyIndex > 0;
  bool get canRedo => historyIndex < history.length - 1;

  PlaygroundState copyWith({
    DiffViewerConfiguration? configuration,
    String? oldContent,
    String? newContent,
    String? oldLabel,
    String? newLabel,
    String? activePresetId,
    String? searchQuery,
    bool? minimalCodeMode,
    bool? includeImports,
    bool? inspectMode,
    String? selectedPropertyKey,
    PlaygroundTab? activeTab,
    List<ConfigurationSnapshot>? history,
    int? historyIndex,
  }) {
    return PlaygroundState(
      configuration: configuration ?? this.configuration,
      oldContent: oldContent ?? this.oldContent,
      newContent: newContent ?? this.newContent,
      oldLabel: oldLabel ?? this.oldLabel,
      newLabel: newLabel ?? this.newLabel,
      activePresetId: activePresetId ?? this.activePresetId,
      searchQuery: searchQuery ?? this.searchQuery,
      minimalCodeMode: minimalCodeMode ?? this.minimalCodeMode,
      includeImports: includeImports ?? this.includeImports,
      inspectMode: inspectMode ?? this.inspectMode,
      selectedPropertyKey: selectedPropertyKey ?? this.selectedPropertyKey,
      activeTab: activeTab ?? this.activeTab,
      history: history ?? this.history,
      historyIndex: historyIndex ?? this.historyIndex,
    );
  }
}
