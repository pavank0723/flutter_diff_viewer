/// Controls the granularity of diff comparison within lines.
///
/// Determines how finely the package compares content when a line is
/// identified as [DiffType.modified].
enum DiffGranularity {
  /// Compares content at the line level only.
  ///
  /// Each line is marked as added, removed, modified, or unchanged.
  /// No intra-line highlighting is applied.
  line,

  /// Compares modified lines at the word level.
  ///
  /// Individual words within modified lines are highlighted as added
  /// or removed, providing more precise change information.
  word,

  /// Compares modified lines at the character level.
  ///
  /// Individual characters within modified lines are highlighted,
  /// providing maximum precision. Recommended for short text or code.
  character,

  /// Automatically selects the appropriate granularity based on content.
  ///
  /// Uses [DiffGranularity.word] for normal text and falls back to
  /// [DiffGranularity.line] for very long lines to maintain performance.
  auto,
}
