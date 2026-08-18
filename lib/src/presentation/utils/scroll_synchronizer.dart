import 'package:flutter/widgets.dart';

/// Manages synchronized vertical scrolling between two [ScrollController]s.
///
/// Used by [SideBySideDiffView] to keep the old and new panels in sync.
/// Prevents recursive scroll events that would cause infinite update loops.
///
/// Ownership semantics:
/// - If [DiffScrollSynchronizer] creates the controllers internally, it
///   disposes them in [dispose].
/// - If controllers are provided externally, they are NOT disposed.
///
/// ```dart
/// final synchronizer = DiffScrollSynchronizer();
///
/// // Use controllers in your widgets
/// final leftController = synchronizer.leftController;
/// final rightController = synchronizer.rightController;
///
/// // Dispose when done
/// synchronizer.dispose();
/// ```
class DiffScrollSynchronizer {
  /// The scroll controller for the left (old content) panel.
  final ScrollController leftController;

  /// The scroll controller for the right (new content) panel.
  final ScrollController rightController;

  final bool _ownsLeft;
  final bool _ownsRight;

  /// Prevents recursive scroll events.
  bool _isSyncing = false;

  /// Creates a [DiffScrollSynchronizer] with the provided or newly created
  /// scroll controllers.
  ///
  /// If [leftController] is not provided, a new one is created and owned
  /// by this synchronizer (disposed in [dispose]).
  ///
  /// If [rightController] is not provided, a new one is created and owned
  /// by this synchronizer.
  DiffScrollSynchronizer({
    ScrollController? leftController,
    ScrollController? rightController,
  })  : leftController = leftController ?? ScrollController(),
        rightController = rightController ?? ScrollController(),
        _ownsLeft = leftController == null,
        _ownsRight = rightController == null {
    _attachListeners();
  }

  void _attachListeners() {
    leftController.addListener(_onLeftScroll);
    rightController.addListener(_onRightScroll);
  }

  void _onLeftScroll() {
    if (_isSyncing) return;
    if (!rightController.hasClients) return;
    if (!leftController.hasClients) return;

    final leftOffset = leftController.offset;
    final rightMax = rightController.position.maxScrollExtent;

    _isSyncing = true;
    try {
      rightController.jumpTo(leftOffset.clamp(0.0, rightMax));
    } finally {
      _isSyncing = false;
    }
  }

  void _onRightScroll() {
    if (_isSyncing) return;
    if (!leftController.hasClients) return;
    if (!rightController.hasClients) return;

    final rightOffset = rightController.offset;
    final leftMax = leftController.position.maxScrollExtent;

    _isSyncing = true;
    try {
      leftController.jumpTo(rightOffset.clamp(0.0, leftMax));
    } finally {
      _isSyncing = false;
    }
  }

  /// Scrolls both panels to the given [offset] simultaneously.
  void scrollTo(double offset) {
    _isSyncing = true;
    try {
      if (leftController.hasClients) {
        final leftMax = leftController.position.maxScrollExtent;
        leftController.jumpTo(offset.clamp(0.0, leftMax));
      }
      if (rightController.hasClients) {
        final rightMax = rightController.position.maxScrollExtent;
        rightController.jumpTo(offset.clamp(0.0, rightMax));
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Animates both panels to the given [offset].
  Future<void> animateTo(
    double offset, {
    required Duration duration,
    required Curve curve,
  }) async {
    _isSyncing = true;
    try {
      final futures = <Future<void>>[];
      if (leftController.hasClients) {
        final leftMax = leftController.position.maxScrollExtent;
        futures.add(
          leftController.animateTo(
            offset.clamp(0.0, leftMax),
            duration: duration,
            curve: curve,
          ),
        );
      }
      if (rightController.hasClients) {
        final rightMax = rightController.position.maxScrollExtent;
        futures.add(
          rightController.animateTo(
            offset.clamp(0.0, rightMax),
            duration: duration,
            curve: curve,
          ),
        );
      }
      await Future.wait(futures);
    } finally {
      _isSyncing = false;
    }
  }

  /// Releases listeners and optionally disposes owned controllers.
  void dispose() {
    leftController.removeListener(_onLeftScroll);
    rightController.removeListener(_onRightScroll);

    if (_ownsLeft) leftController.dispose();
    if (_ownsRight) rightController.dispose();
  }
}
