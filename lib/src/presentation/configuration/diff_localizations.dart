/// An immutable set of user-visible strings for the diff viewer.
///
/// Enables full localization / i18n of all labels, buttons, and status
/// messages rendered by the diff viewer.
///
/// Use [DiffLocalizations.defaults] for English strings and override
/// individual labels with [copyWith].
///
/// ## Formatted helpers
///
/// Several labels contain runtime values (counts, indices). Use the
/// corresponding helper methods instead of composing strings manually:
///
/// ```dart
/// final loc = DiffLocalizations.defaults();
/// print(loc.formattedAdditions(42)); // '+42 additions'
/// print(loc.formattedChangeOf(0, 5)); // 'Change 1 of 5'
/// ```
class DiffLocalizations {
  /// Label for the left/old panel in side-by-side or stacked layouts.
  ///
  /// Defaults to `'Current'`.
  final String oldVersionLabel;

  /// Label for the right/new panel in side-by-side or stacked layouts.
  ///
  /// Defaults to `'Modified'`.
  final String newVersionLabel;

  /// Badge label for added lines. Defaults to `'Added'`.
  final String addedLabel;

  /// Badge label for removed lines. Defaults to `'Removed'`.
  final String removedLabel;

  /// Badge label for modified lines. Defaults to `'Modified'`.
  final String modifiedLabel;

  /// Badge label for unchanged lines. Defaults to `'Unchanged'`.
  final String unchangedLabel;

  /// Message shown when the diff contains zero changes.
  ///
  /// Defaults to `'No changes'`.
  final String noChangesLabel;

  /// Tooltip / accessible label for the "next change" navigation button.
  final String nextChangeLabel;

  /// Tooltip / accessible label for the "previous change" navigation button.
  final String previousChangeLabel;

  /// Base text for the "expand collapsed section" action.
  ///
  /// The actual rendered string is produced by [formattedShowMore].
  final String showMoreLabel;

  /// Label for the "collapse unchanged lines" action.
  final String collapseLabel;

  /// Message shown while the diff computation is in progress.
  final String loadingLabel;

  /// Message shown when diff computation fails.
  final String errorLabel;

  /// Singular/plural noun appended to the additions count in the summary bar.
  ///
  /// Example: `'additions'` → `'+3 additions'` via [formattedAdditions].
  final String additionsCountLabel;

  /// Singular/plural noun appended to the deletions count in the summary bar.
  ///
  /// Example: `'deletions'` → `'-2 deletions'` via [formattedDeletions].
  final String deletionsCountLabel;

  /// Conjunction used between current and total in change navigation.
  ///
  /// Example: `'of'` → `'Change 2 of 5'` via [formattedChangeOf].
  final String changeOfLabel;

  /// Creates an immutable [DiffLocalizations].
  ///
  /// All fields are required. Prefer [DiffLocalizations.defaults] as a
  /// starting point and use [copyWith] to substitute translated strings.
  const DiffLocalizations({
    required this.oldVersionLabel,
    required this.newVersionLabel,
    required this.addedLabel,
    required this.removedLabel,
    required this.modifiedLabel,
    required this.unchangedLabel,
    required this.noChangesLabel,
    required this.nextChangeLabel,
    required this.previousChangeLabel,
    required this.showMoreLabel,
    required this.collapseLabel,
    required this.loadingLabel,
    required this.errorLabel,
    required this.additionsCountLabel,
    required this.deletionsCountLabel,
    required this.changeOfLabel,
  });

  // ---------------------------------------------------------------------------
  // Factory constructor
  // ---------------------------------------------------------------------------

  /// Returns the default English localizations.
  const factory DiffLocalizations.defaults() = _DefaultDiffLocalizations;

  // ---------------------------------------------------------------------------
  // Formatted string helpers
  // ---------------------------------------------------------------------------

  /// Returns a formatted additions string, e.g. `'+42 additions'`.
  ///
  /// [count] should be the [DiffResult.additions] value.
  String formattedAdditions(int count) => '+$count $additionsCountLabel';

  /// Returns a formatted deletions string, e.g. `'-7 deletions'`.
  ///
  /// [count] should be the [DiffResult.deletions] value.
  String formattedDeletions(int count) => '-$count $deletionsCountLabel';

  /// Returns a human-readable change position string, e.g. `'Change 3 of 10'`.
  ///
  /// [current] is 0-based; it is displayed as `current + 1`.
  /// [total] is the total number of navigable changes.
  String formattedChangeOf(int current, int total) =>
      'Change ${current + 1} $changeOfLabel $total';

  /// Returns a formatted "show more" label, e.g. `'Show lines (14)'`.
  ///
  /// [count] is the number of collapsed lines that would be revealed.
  String formattedShowMore(int count) => '$showMoreLabel ($count)';

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  /// Returns a copy of these localizations with the given labels replaced.
  DiffLocalizations copyWith({
    String? oldVersionLabel,
    String? newVersionLabel,
    String? addedLabel,
    String? removedLabel,
    String? modifiedLabel,
    String? unchangedLabel,
    String? noChangesLabel,
    String? nextChangeLabel,
    String? previousChangeLabel,
    String? showMoreLabel,
    String? collapseLabel,
    String? loadingLabel,
    String? errorLabel,
    String? additionsCountLabel,
    String? deletionsCountLabel,
    String? changeOfLabel,
  }) {
    return DiffLocalizations(
      oldVersionLabel: oldVersionLabel ?? this.oldVersionLabel,
      newVersionLabel: newVersionLabel ?? this.newVersionLabel,
      addedLabel: addedLabel ?? this.addedLabel,
      removedLabel: removedLabel ?? this.removedLabel,
      modifiedLabel: modifiedLabel ?? this.modifiedLabel,
      unchangedLabel: unchangedLabel ?? this.unchangedLabel,
      noChangesLabel: noChangesLabel ?? this.noChangesLabel,
      nextChangeLabel: nextChangeLabel ?? this.nextChangeLabel,
      previousChangeLabel: previousChangeLabel ?? this.previousChangeLabel,
      showMoreLabel: showMoreLabel ?? this.showMoreLabel,
      collapseLabel: collapseLabel ?? this.collapseLabel,
      loadingLabel: loadingLabel ?? this.loadingLabel,
      errorLabel: errorLabel ?? this.errorLabel,
      additionsCountLabel: additionsCountLabel ?? this.additionsCountLabel,
      deletionsCountLabel: deletionsCountLabel ?? this.deletionsCountLabel,
      changeOfLabel: changeOfLabel ?? this.changeOfLabel,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality & hashing
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffLocalizations &&
          runtimeType == other.runtimeType &&
          oldVersionLabel == other.oldVersionLabel &&
          newVersionLabel == other.newVersionLabel &&
          addedLabel == other.addedLabel &&
          removedLabel == other.removedLabel &&
          modifiedLabel == other.modifiedLabel &&
          unchangedLabel == other.unchangedLabel &&
          noChangesLabel == other.noChangesLabel &&
          nextChangeLabel == other.nextChangeLabel &&
          previousChangeLabel == other.previousChangeLabel &&
          showMoreLabel == other.showMoreLabel &&
          collapseLabel == other.collapseLabel &&
          loadingLabel == other.loadingLabel &&
          errorLabel == other.errorLabel &&
          additionsCountLabel == other.additionsCountLabel &&
          deletionsCountLabel == other.deletionsCountLabel &&
          changeOfLabel == other.changeOfLabel;

  @override
  int get hashCode => Object.hashAll([
        oldVersionLabel,
        newVersionLabel,
        addedLabel,
        removedLabel,
        modifiedLabel,
        unchangedLabel,
        noChangesLabel,
        nextChangeLabel,
        previousChangeLabel,
        showMoreLabel,
        collapseLabel,
        loadingLabel,
        errorLabel,
        additionsCountLabel,
        deletionsCountLabel,
        changeOfLabel,
      ]);

  @override
  String toString() => 'DiffLocalizations('
      'oldVersionLabel: $oldVersionLabel, '
      'newVersionLabel: $newVersionLabel, '
      'addedLabel: $addedLabel, '
      'removedLabel: $removedLabel)';
}

/// Private const implementation backing [DiffLocalizations.defaults].
class _DefaultDiffLocalizations extends DiffLocalizations {
  const _DefaultDiffLocalizations()
      : super(
          oldVersionLabel: 'Current',
          newVersionLabel: 'Modified',
          addedLabel: 'Added',
          removedLabel: 'Removed',
          modifiedLabel: 'Modified',
          unchangedLabel: 'Unchanged',
          noChangesLabel: 'No changes',
          nextChangeLabel: 'Next change',
          previousChangeLabel: 'Previous change',
          showMoreLabel: 'Show lines',
          collapseLabel: 'Collapse',
          loadingLabel: 'Calculating diff\u2026',
          errorLabel: 'Failed to calculate diff',
          additionsCountLabel: 'additions',
          deletionsCountLabel: 'deletions',
          changeOfLabel: 'of',
        );
}
