/// Represents the type of a diff change between two content versions.
///
/// Used throughout the package to categorize individual lines, words,
/// and characters in a diff comparison.
enum DiffType {
  /// Content that exists in both old and new versions without modification.
  unchanged,

  /// Content that was added in the new version (does not exist in old).
  added,

  /// Content that was removed from the old version (does not exist in new).
  removed,

  /// Content that exists in both versions but with modifications.
  ///
  /// A modified line typically contains both [removed] and [added] segments
  /// at the word or character level.
  modified,
}
