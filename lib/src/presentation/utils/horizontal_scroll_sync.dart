import 'package:flutter/widgets.dart';

/// Manages synchronized horizontal scrolling across all line rows in a diff view.
///
/// Ensures that when any line row is scrolled horizontally, all other lines
/// in the same panel/view scroll to the identical horizontal offset in real-time.
class DiffHorizontalScrollSync extends ChangeNotifier {
  double _offset = 0.0;

  /// The current shared horizontal scroll offset.
  double get offset => _offset;

  /// Updates the horizontal scroll offset and notifies listeners if changed.
  void updateOffset(double newOffset) {
    if ((_offset - newOffset).abs() > 0.5) {
      _offset = newOffset;
      notifyListeners();
    }
  }
}
