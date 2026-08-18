import 'package:flutter/widgets.dart';

import '../../core/exceptions/diff_exceptions.dart';
import '../../domain/entities/diff_change.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_type.dart';
import '../utils/scroll_synchronizer.dart';

/// State of the diff viewer.
enum DiffViewerState {
  /// Initial state before any diff has been calculated.
  idle,

  /// Diff calculation is in progress.
  loading,

  /// Diff calculation completed successfully.
  loaded,

  /// Diff calculation failed with an error.
  error,
}

/// Controls a [DiffViewer] widget's navigation, scrolling, and collapse state.
///
/// Provides programmatic access to change navigation, scrolling to specific
/// lines, and expanding/collapsing unchanged sections.
///
/// ```dart
/// final controller = DiffViewerController();
///
/// // Navigate changes
/// controller.nextChange();
/// controller.previousChange();
/// controller.goToChange(2);
///
/// // Collapse all unchanged sections
/// controller.collapseAll();
///
/// // Remember to dispose
/// controller.dispose();
/// ```
///
/// **Lifecycle note**: If you create a [DiffViewerController] yourself, you
/// are responsible for calling [dispose]. The [DiffViewer] widget will NOT
/// dispose externally provided controllers.
class DiffViewerController extends ChangeNotifier {
  DiffResult? _result;
  List<DiffChange> _changes = const [];
  int _currentChangeIndex = -1;
  DiffViewerState _state = DiffViewerState.idle;
  Object? _error;
  final Set<int> _collapsedLineIndices = {};

  /// The most recently calculated diff result.
  ///
  /// Returns `null` if no diff has been calculated yet or if calculation failed.
  DiffResult? get result => _result;

  /// The ordered list of navigable change blocks in the current diff.
  List<DiffChange> get changes => List.unmodifiable(_changes);

  /// The 0-based index of the currently highlighted change.
  ///
  /// Returns `-1` if no change is currently selected.
  int get currentChangeIndex => _currentChangeIndex;

  /// The total number of navigable changes in the current diff.
  int get totalChanges => _changes.length;

  /// The current state of the diff viewer.
  DiffViewerState get state => _state;

  /// The error from the last failed diff calculation, or `null`.
  Object? get error => _error;

  /// Whether there is a next change to navigate to.
  bool get hasNextChange =>
      _changes.isNotEmpty && _currentChangeIndex < _changes.length - 1;

  /// Whether there is a previous change to navigate to.
  bool get hasPreviousChange => _currentChangeIndex > 0;

  /// The currently selected [DiffChange], or `null`.
  DiffChange? get currentChange =>
      _currentChangeIndex >= 0 && _currentChangeIndex < _changes.length
          ? _changes[_currentChangeIndex]
          : null;

  /// Set of line indices that are currently in a collapsed state.
  Set<int> get collapsedLineIndices => Set.unmodifiable(_collapsedLineIndices);

  // ── Scroll controllers (internal) ──────────────────────────────────────────

  final ScrollController _primaryScrollController = ScrollController();
  final DiffScrollSynchronizer _scrollSynchronizer;

  /// The primary vertical scroll controller (unified/stacked view).
  ScrollController get primaryScrollController => _primaryScrollController;

  /// The left panel scroll controller (side-by-side view).
  ScrollController get leftScrollController =>
      _scrollSynchronizer.leftController;

  /// The right panel scroll controller (side-by-side view).
  ScrollController get rightScrollController =>
      _scrollSynchronizer.rightController;

  /// Creates a [DiffViewerController].
  DiffViewerController() : _scrollSynchronizer = DiffScrollSynchronizer();

  // ── Internal update methods (called by DiffViewer) ─────────────────────────

  /// Updates the controller with a new diff result.
  ///
  /// Called internally by [DiffViewer] after successful diff calculation.
  void setResult(DiffResult result) {
    _result = result;
    _changes = _extractChanges(result);
    _currentChangeIndex = _changes.isEmpty ? -1 : 0;
    _state = DiffViewerState.loaded;
    _error = null;
    notifyListeners();
  }

  /// Transitions to the loading state.
  ///
  /// Called internally by [DiffViewer] when diff calculation begins.
  void setLoading() {
    _state = DiffViewerState.loading;
    notifyListeners();
  }

  /// Transitions to the error state.
  ///
  /// Called internally by [DiffViewer] when diff calculation fails.
  void setError(Object error) {
    _state = DiffViewerState.error;
    _error = error;
    notifyListeners();
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  /// Navigates to the next change in the diff.
  ///
  /// Does nothing if there is no next change.
  void nextChange() {
    if (!hasNextChange) return;
    _currentChangeIndex++;
    notifyListeners();
    _scrollToCurrentChange();
  }

  /// Navigates to the previous change in the diff.
  ///
  /// Does nothing if there is no previous change.
  void previousChange() {
    if (!hasPreviousChange) return;
    _currentChangeIndex--;
    notifyListeners();
    _scrollToCurrentChange();
  }

  /// Navigates to the change at the given [index].
  ///
  /// Throws [DiffIndexOutOfBoundsException] if [index] is out of bounds.
  void goToChange(int index) {
    if (index < 0 || index >= _changes.length) {
      throw DiffIndexOutOfBoundsException(
        requestedIndex: index,
        totalChanges: _changes.length,
      );
    }
    _currentChangeIndex = index;
    notifyListeners();
    _scrollToCurrentChange();
  }

  /// Scrolls the diff view to the line at [lineIndex] (0-based).
  ///
  /// Uses an approximate item extent calculation. For precise positioning,
  /// use [goToChange] with change navigation.
  void scrollToLine(int lineIndex) {
    if (_result == null ||
        lineIndex < 0 ||
        lineIndex >= _result!.lines.length) {
      return;
    }
    // Approximate scroll offset using a standard line height of 22px
    const approximateLineHeight = 22.0;
    final offset = lineIndex * approximateLineHeight;
    _primaryScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollSynchronizer.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ── Collapse / Expand ───────────────────────────────────────────────────────

  /// Collapses all unchanged line sections.
  void collapseAll() {
    if (_result == null) return;
    for (var i = 0; i < _result!.lines.length; i++) {
      if (_result!.lines[i].isUnchanged) {
        _collapsedLineIndices.add(i);
      }
    }
    notifyListeners();
  }

  /// Expands all collapsed unchanged line sections.
  void expandAll() {
    _collapsedLineIndices.clear();
    notifyListeners();
  }

  /// Expands the collapsed section containing the line at [lineIndex].
  void expandSection(int lineIndex) {
    _collapsedLineIndices.remove(lineIndex);
    notifyListeners();
  }

  /// Returns `true` if the line at [lineIndex] is currently collapsed.
  bool isLineCollapsed(int lineIndex) =>
      _collapsedLineIndices.contains(lineIndex);

  // ── Private helpers ─────────────────────────────────────────────────────────

  List<DiffChange> _extractChanges(DiffResult result) {
    final changes = <DiffChange>[];
    int? blockStart;
    DiffType? blockType;
    var changeIndex = 0;

    for (var i = 0; i < result.lines.length; i++) {
      final line = result.lines[i];
      if (line.type != DiffType.unchanged) {
        blockStart ??= i;
        blockType ??= line.type;
      } else if (blockStart != null) {
        changes.add(
          DiffChange(
            index: changeIndex++,
            startLineIndex: blockStart,
            endLineIndex: i - 1,
            type: blockType!,
          ),
        );
        blockStart = null;
        blockType = null;
      }
    }
    if (blockStart != null) {
      changes.add(
        DiffChange(
          index: changeIndex,
          startLineIndex: blockStart,
          endLineIndex: result.lines.length - 1,
          type: blockType!,
        ),
      );
    }
    return List.unmodifiable(changes);
  }

  void _scrollToCurrentChange() {
    final change = currentChange;
    if (change == null) return;
    scrollToLine(change.startLineIndex);
  }

  @override
  void dispose() {
    _primaryScrollController.dispose();
    _scrollSynchronizer.dispose();
    super.dispose();
  }
}
