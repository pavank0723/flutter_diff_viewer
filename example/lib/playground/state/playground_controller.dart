import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

import '../../sample_data.dart';
import '../domain/configuration_snapshot.dart';
import '../domain/playground_preset.dart';
import 'playground_state.dart';

class PlaygroundController extends ChangeNotifier {
  late PlaygroundState _state;

  PlaygroundState get state => _state;

  PlaygroundController() {
    final defaultConfig = FlutterDiffViewerConfiguration.defaults().copyWith(
      layout: DiffLayout.sideBySide,
      granularity: DiffGranularity.word,
      showSummary: true,
      showLineNumbers: true,
      showIndicators: true,
      collapseUnchangedLines: true,
    );

    final initialSnapshot = ConfigurationSnapshot(
      description: 'Initial Default Configuration',
      configuration: defaultConfig,
    );

    _state = PlaygroundState(
      configuration: defaultConfig,
      oldContent: SampleData.privacyOld,
      newContent: SampleData.privacyNew,
      oldLabel: 'PN00736 v1.2',
      newLabel: 'PN00736 v1.3',
      activePresetId: 'github_light',
      searchQuery: '',
      minimalCodeMode: true,
      includeImports: true,
      inspectMode: false,
      selectedPropertyKey: 'layout',
      activeTab: PlaygroundTab.controls,
      history: [initialSnapshot],
      historyIndex: 0,
    );
  }

  void updateConfiguration(
      FlutterDiffViewerConfiguration newConfig, String actionDescription) {
    // Truncate future history if after an undo
    final newHistory = _state.history.sublist(0, _state.historyIndex + 1);
    final snapshot = ConfigurationSnapshot(
      description: actionDescription,
      configuration: newConfig,
    );
    newHistory.add(snapshot);

    _state = _state.copyWith(
      configuration: newConfig,
      activePresetId: 'custom',
      history: newHistory,
      historyIndex: newHistory.length - 1,
    );
    notifyListeners();
  }

  void applyPreset(PlaygroundPreset preset) {
    final newHistory = _state.history.sublist(0, _state.historyIndex + 1);
    final snapshot = ConfigurationSnapshot(
      description: 'Applied Preset: ${preset.name}',
      configuration: preset.configuration,
    );
    newHistory.add(snapshot);

    _state = _state.copyWith(
      configuration: preset.configuration,
      activePresetId: preset.id,
      history: newHistory,
      historyIndex: newHistory.length - 1,
    );
    notifyListeners();
  }

  void undo() {
    if (!_state.canUndo) return;
    final newIndex = _state.historyIndex - 1;
    final snapshot = _state.history[newIndex];

    _state = _state.copyWith(
      configuration: snapshot.configuration,
      historyIndex: newIndex,
    );
    notifyListeners();
  }

  void redo() {
    if (!_state.canRedo) return;
    final newIndex = _state.historyIndex + 1;
    final snapshot = _state.history[newIndex];

    _state = _state.copyWith(
      configuration: snapshot.configuration,
      historyIndex: newIndex,
    );
    notifyListeners();
  }

  void resetAll() {
    final defaultConfig = FlutterDiffViewerConfiguration.defaults();
    updateConfiguration(defaultConfig, 'Reset All Properties');
  }

  void setSearchQuery(String query) {
    _state = _state.copyWith(searchQuery: query);
    notifyListeners();
  }

  void selectProperty(String? key) {
    _state = _state.copyWith(selectedPropertyKey: key);
    notifyListeners();
  }

  void toggleMinimalCodeMode(bool minimal) {
    _state = _state.copyWith(minimalCodeMode: minimal);
    notifyListeners();
  }

  void toggleIncludeImports(bool imports) {
    _state = _state.copyWith(includeImports: imports);
    notifyListeners();
  }

  void toggleInspectMode(bool inspect) {
    _state = _state.copyWith(inspectMode: inspect);
    notifyListeners();
  }

  void setActiveTab(PlaygroundTab tab) {
    _state = _state.copyWith(activeTab: tab);
    notifyListeners();
  }

  void updateContents({
    String? oldContent,
    String? newContent,
    String? oldLabel,
    String? newLabel,
  }) {
    _state = _state.copyWith(
      oldContent: oldContent ?? _state.oldContent,
      newContent: newContent ?? _state.newContent,
      oldLabel: oldLabel ?? _state.oldLabel,
      newLabel: newLabel ?? _state.newLabel,
    );
    notifyListeners();
  }
}
