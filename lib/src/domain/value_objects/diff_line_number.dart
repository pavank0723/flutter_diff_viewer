/// Immutable value object representing a 1-based line number in a diff view.
///
/// Wraps an integer to provide semantic clarity and type safety when
/// passing line numbers through the domain layer.
///
/// ```dart
/// const lineNumber = DiffLineNumber(42);
/// print(lineNumber.value); // 42
/// print(lineNumber.display); // "42"
/// ```
class DiffLineNumber {
  /// The 1-based line number value.
  final int value;

  /// Creates an immutable line number value object.
  ///
  /// [value] must be >= 1.
  const DiffLineNumber(this.value)
      : assert(value >= 1, 'Line numbers are 1-based; value must be >= 1');

  /// Returns the line number formatted as a display string.
  String get display => value.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffLineNumber &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'DiffLineNumber($value)';
}
