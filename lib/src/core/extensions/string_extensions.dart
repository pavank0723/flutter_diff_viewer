/// Extension methods on [String] used internally by the diff package.
extension DiffStringExtensions on String {
  /// Splits this string into individual lines, preserving empty lines.
  ///
  /// Normalizes line endings (CRLF, CR, LF) to a consistent format before
  /// splitting.
  List<String> toLines() {
    if (isEmpty) return const [];
    // Normalize CRLF → LF, then CR → LF
    final normalized = replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    return normalized.split('\n');
  }

  /// Splits this string into words, including surrounding whitespace as
  /// separate tokens to allow faithful reconstruction.
  ///
  /// Whitespace tokens are kept so that diffs show spaces correctly.
  List<String> toWords() {
    if (isEmpty) return const [];
    final result = <String>[];
    final buffer = StringBuffer();
    bool? currentIsSpace;

    for (final char in runes) {
      final c = String.fromCharCode(char);
      final isSpace = c == ' ' || c == '\t';

      if (currentIsSpace != null && isSpace != currentIsSpace) {
        result.add(buffer.toString());
        buffer.clear();
      }
      currentIsSpace = isSpace;
      buffer.write(c);
    }
    if (buffer.isNotEmpty) result.add(buffer.toString());
    return result;
  }

  /// Splits this string into individual characters (Unicode-safe).
  List<String> toCharacters() {
    if (isEmpty) return const [];
    return runes.map(String.fromCharCode).toList(growable: false);
  }

  /// Trims this string if [trim] is true; returns the original otherwise.
  String trimIf(bool trim) => trim ? this.trim() : this;

  /// Converts to lowercase if [lower] is true; returns the original otherwise.
  String toLowerIf(bool lower) => lower ? toLowerCase() : this;

  /// Returns a preview of the string truncated to [maxLength] characters.
  String preview([int maxLength = 40]) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}…';
  }
}
