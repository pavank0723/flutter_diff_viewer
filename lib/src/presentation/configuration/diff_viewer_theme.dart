import 'package:flutter/material.dart';

/// An immutable theme that controls every color used by the diff viewer.
///
/// Use the pre-built factories for common themes:
/// - [FlutterDiffViewerTheme.light] — GitHub-style light theme (green/red)
/// - [FlutterDiffViewerTheme.dark]  — GitHub Dark-style theme
///
/// Or call [FlutterDiffViewerTheme.resolveFromContext] to automatically select
/// between light and dark based on the ambient [ThemeData.brightness].
///
/// Distinct container background colors and diff highlight colors can be
/// configured separately for the left ("Current") and right ("Modified") panels
/// using fields like [leftPanelBackgroundColor], [rightPanelBackgroundColor],
/// [leftAddedBackgroundColor], [rightAddedBackgroundColor], etc.
class FlutterDiffViewerTheme {
  // ---------------------------------------------------------------------------
  // Row background colors
  // ---------------------------------------------------------------------------

  /// Background color for rows that contain added content.
  final Color addedBackgroundColor;

  /// Background color for rows that contain removed content.
  final Color removedBackgroundColor;

  /// Background color for rows that contain modified content (old or new side).
  final Color modifiedBackgroundColor;

  /// Background color for rows that contain unchanged content.
  final Color unchangedBackgroundColor;

  // ---------------------------------------------------------------------------
  // Intra-line highlight colors
  // ---------------------------------------------------------------------------

  /// Highlight color for individual added words or characters within a line.
  final Color addedHighlightColor;

  /// Highlight color for individual removed words or characters within a line.
  final Color removedHighlightColor;

  // ---------------------------------------------------------------------------
  // Text colors
  // ---------------------------------------------------------------------------

  /// Text color used on added lines.
  final Color addedTextColor;

  /// Text color used on removed lines.
  final Color removedTextColor;

  /// Text color used on modified lines.
  final Color modifiedTextColor;

  /// Text color used on unchanged lines.
  final Color unchangedTextColor;

  // ---------------------------------------------------------------------------
  // UI chrome colors
  // ---------------------------------------------------------------------------

  /// Background color of the line-number gutter column.
  final Color lineNumberBackgroundColor;

  /// Text color of the line-number gutter.
  final Color lineNumberTextColor;

  /// Color of the vertical divider between old and new panes in side-by-side mode.
  final Color dividerColor;

  /// Color of the outer border surrounding the diff viewer widget.
  final Color borderColor;

  /// Background color of the header bar (showing old/new labels).
  final Color headerBackgroundColor;

  /// Text color of the header bar labels.
  final Color headerTextColor;

  /// Color of the `+` badge or gutter indicator for added lines.
  final Color indicatorAddedColor;

  /// Color of the `-` badge or gutter indicator for removed lines.
  final Color indicatorRemovedColor;

  /// Color of the space/dot gutter indicator for unchanged lines.
  final Color indicatorUnchangedColor;

  /// Background color of the summary bar (additions/deletions count).
  final Color summaryBackgroundColor;

  /// Background color of collapsed-section placeholder rows.
  final Color collapsedSectionColor;

  /// Text color within collapsed-section placeholder rows.
  final Color collapsedSectionTextColor;

  /// Background/fill color for change-navigation buttons.
  final Color navigationButtonColor;

  /// Text/icon color for change-navigation buttons.
  final Color navigationButtonTextColor;

  /// The overall background color of the diff viewer widget.
  final Color backgroundColor;

  /// Background color of individual left and right panel cards when split.
  final Color panelBackgroundColor;

  /// Border color of individual left and right panel cards when split.
  final Color panelBorderColor;

  // ---------------------------------------------------------------------------
  // Per-side container and diff highlight overrides
  // ---------------------------------------------------------------------------

  /// Background color override for the left (old/current) panel container card.
  final Color? leftPanelBackgroundColor;

  /// Background color override for the right (new/modified) panel container card.
  final Color? rightPanelBackgroundColor;

  /// Border color override for the left (old/current) panel container card.
  final Color? leftPanelBorderColor;

  /// Border color override for the right (new/modified) panel container card.
  final Color? rightPanelBorderColor;

  /// Diff added background color override for left panel.
  final Color? leftAddedBackgroundColor;

  /// Diff added background color override for right panel.
  final Color? rightAddedBackgroundColor;

  /// Diff removed background color override for left panel.
  final Color? leftRemovedBackgroundColor;

  /// Diff removed background color override for right panel.
  final Color? rightRemovedBackgroundColor;

  /// Diff modified background color override for left panel.
  final Color? leftModifiedBackgroundColor;

  /// Diff modified background color override for right panel.
  final Color? rightModifiedBackgroundColor;

  /// Diff unchanged background color override for left panel.
  final Color? leftUnchangedBackgroundColor;

  /// Diff unchanged background color override for right panel.
  final Color? rightUnchangedBackgroundColor;

  /// Added intra-line highlight color override for left panel.
  final Color? leftAddedHighlightColor;

  /// Added intra-line highlight color override for right panel.
  final Color? rightAddedHighlightColor;

  /// Removed intra-line highlight color override for left panel.
  final Color? leftRemovedHighlightColor;

  /// Removed intra-line highlight color override for right panel.
  final Color? rightRemovedHighlightColor;

  /// Text color for added lines on left panel.
  final Color? leftAddedTextColor;

  /// Text color for added lines on right panel.
  final Color? rightAddedTextColor;

  /// Text color for removed lines on left panel.
  final Color? leftRemovedTextColor;

  /// Text color for removed lines on right panel.
  final Color? rightRemovedTextColor;

  /// Text color for modified lines on left panel.
  final Color? leftModifiedTextColor;

  /// Text color for modified lines on right panel.
  final Color? rightModifiedTextColor;

  /// Text color for unchanged lines on left panel.
  final Color? leftUnchangedTextColor;

  /// Text color for unchanged lines on right panel.
  final Color? rightUnchangedTextColor;

  /// Diff block card background color override for left panel.
  final Color? leftBlockBackgroundColor;

  /// Diff block card background color override for right panel.
  final Color? rightBlockBackgroundColor;

  /// Diff block card border color override for left panel.
  final Color? leftBlockBorderColor;

  /// Diff block card border color override for right panel.
  final Color? rightBlockBorderColor;

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  /// Creates an immutable [FlutterDiffViewerTheme].
  const FlutterDiffViewerTheme({
    required this.addedBackgroundColor,
    required this.removedBackgroundColor,
    required this.modifiedBackgroundColor,
    required this.unchangedBackgroundColor,
    required this.addedHighlightColor,
    required this.removedHighlightColor,
    required this.addedTextColor,
    required this.removedTextColor,
    required this.modifiedTextColor,
    required this.unchangedTextColor,
    required this.lineNumberBackgroundColor,
    required this.lineNumberTextColor,
    required this.dividerColor,
    required this.borderColor,
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.indicatorAddedColor,
    required this.indicatorRemovedColor,
    required this.indicatorUnchangedColor,
    required this.summaryBackgroundColor,
    required this.collapsedSectionColor,
    required this.collapsedSectionTextColor,
    required this.navigationButtonColor,
    required this.navigationButtonTextColor,
    required this.backgroundColor,
    required this.panelBackgroundColor,
    required this.panelBorderColor,
    this.leftPanelBackgroundColor,
    this.rightPanelBackgroundColor,
    this.leftPanelBorderColor,
    this.rightPanelBorderColor,
    this.leftAddedBackgroundColor,
    this.rightAddedBackgroundColor,
    this.leftRemovedBackgroundColor,
    this.rightRemovedBackgroundColor,
    this.leftModifiedBackgroundColor,
    this.rightModifiedBackgroundColor,
    this.leftUnchangedBackgroundColor,
    this.rightUnchangedBackgroundColor,
    this.leftAddedHighlightColor,
    this.rightAddedHighlightColor,
    this.leftRemovedHighlightColor,
    this.rightRemovedHighlightColor,
    this.leftAddedTextColor,
    this.rightAddedTextColor,
    this.leftRemovedTextColor,
    this.rightRemovedTextColor,
    this.leftModifiedTextColor,
    this.rightModifiedTextColor,
    this.leftUnchangedTextColor,
    this.rightUnchangedTextColor,
    this.leftBlockBackgroundColor,
    this.rightBlockBackgroundColor,
    this.leftBlockBorderColor,
    this.rightBlockBorderColor,
  });

  // ---------------------------------------------------------------------------
  // Resolver Helpers
  // ---------------------------------------------------------------------------

  /// Resolves the panel container background color based on panel side.
  Color resolvePanelBackgroundColor({required bool isOldSide}) => isOldSide
      ? (leftPanelBackgroundColor ?? panelBackgroundColor)
      : (rightPanelBackgroundColor ?? panelBackgroundColor);

  /// Resolves the panel container border color based on panel side.
  Color resolvePanelBorderColor({required bool isOldSide}) => isOldSide
      ? (leftPanelBorderColor ?? panelBorderColor)
      : (rightPanelBorderColor ?? panelBorderColor);

  /// Resolves added background color based on panel side.
  Color resolveAddedBackgroundColor({bool isOldSide = false}) => isOldSide
      ? (leftAddedBackgroundColor ?? addedBackgroundColor)
      : (rightAddedBackgroundColor ?? addedBackgroundColor);

  /// Resolves removed background color based on panel side.
  Color resolveRemovedBackgroundColor({bool isOldSide = false}) => isOldSide
      ? (leftRemovedBackgroundColor ?? removedBackgroundColor)
      : (rightRemovedBackgroundColor ?? removedBackgroundColor);

  /// Resolves modified background color based on panel side.
  Color resolveModifiedBackgroundColor({bool isOldSide = false}) => isOldSide
      ? (leftModifiedBackgroundColor ?? modifiedBackgroundColor)
      : (rightModifiedBackgroundColor ?? modifiedBackgroundColor);

  /// Resolves unchanged background color based on panel side.
  Color resolveUnchangedBackgroundColor({bool isOldSide = false}) => isOldSide
      ? (leftUnchangedBackgroundColor ?? unchangedBackgroundColor)
      : (rightUnchangedBackgroundColor ?? unchangedBackgroundColor);

  /// Resolves added highlight color based on panel side.
  Color resolveAddedHighlightColor({bool isOldSide = false}) => isOldSide
      ? (leftAddedHighlightColor ?? addedHighlightColor)
      : (rightAddedHighlightColor ?? addedHighlightColor);

  /// Resolves removed highlight color based on panel side.
  Color resolveRemovedHighlightColor({bool isOldSide = false}) => isOldSide
      ? (leftRemovedHighlightColor ?? removedHighlightColor)
      : (rightRemovedHighlightColor ?? removedHighlightColor);

  /// Resolves added text color based on panel side.
  Color resolveAddedTextColor({bool isOldSide = false}) => isOldSide
      ? (leftAddedTextColor ?? addedTextColor)
      : (rightAddedTextColor ?? addedTextColor);

  /// Resolves removed text color based on panel side.
  Color resolveRemovedTextColor({bool isOldSide = false}) => isOldSide
      ? (leftRemovedTextColor ?? removedTextColor)
      : (rightRemovedTextColor ?? removedTextColor);

  /// Resolves modified text color based on panel side.
  Color resolveModifiedTextColor({bool isOldSide = false}) => isOldSide
      ? (leftModifiedTextColor ?? modifiedTextColor)
      : (rightModifiedTextColor ?? modifiedTextColor);

  /// Resolves unchanged text color based on panel side.
  Color resolveUnchangedTextColor({bool isOldSide = false}) => isOldSide
      ? (leftUnchangedTextColor ?? unchangedTextColor)
      : (rightUnchangedTextColor ?? unchangedTextColor);

  /// Resolves block card background color based on panel side.
  Color resolveBlockBackgroundColor({required bool isOldSide}) => isOldSide
      ? (leftBlockBackgroundColor ?? resolvePanelBackgroundColor(isOldSide: true))
      : (rightBlockBackgroundColor ?? resolvePanelBackgroundColor(isOldSide: false));

  /// Resolves block card border color based on panel side.
  Color resolveBlockBorderColor({required bool isOldSide}) => isOldSide
      ? (leftBlockBorderColor ?? resolvePanelBorderColor(isOldSide: true))
      : (rightBlockBorderColor ?? resolvePanelBorderColor(isOldSide: false));

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// GitHub-style **light** theme with green additions and red removals.
  factory FlutterDiffViewerTheme.light() => const FlutterDiffViewerTheme(
        addedBackgroundColor: Color(0xFFE6FFEC),
        removedBackgroundColor: Color(0xFFFFEBE9),
        modifiedBackgroundColor: Color(0xFFFFF8C5),
        unchangedBackgroundColor: Color(0xFFFFFFFF),
        addedHighlightColor: Color(0xFFABF2BC),
        removedHighlightColor: Color(0xFFFFCDD2),
        addedTextColor: Color(0xFF1A7F37),
        removedTextColor: Color(0xFFCF222E),
        modifiedTextColor: Color(0xFF9A6700),
        unchangedTextColor: Color(0xFF24292F),
        lineNumberBackgroundColor: Color(0xFFF6F8FA),
        lineNumberTextColor: Color(0xFF8C959F),
        dividerColor: Color(0xFFD0D7DE),
        borderColor: Color(0xFFD0D7DE),
        headerBackgroundColor: Color(0xFFF6F8FA),
        headerTextColor: Color(0xFF24292F),
        indicatorAddedColor: Color(0xFF1A7F37),
        indicatorRemovedColor: Color(0xFFCF222E),
        indicatorUnchangedColor: Color(0xFF8C959F),
        summaryBackgroundColor: Color(0xFFF6F8FA),
        collapsedSectionColor: Color(0xFFDBEAFE),
        collapsedSectionTextColor: Color(0xFF0969DA),
        navigationButtonColor: Color(0xFF0969DA),
        navigationButtonTextColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFFFFFFFF),
        panelBackgroundColor: Color(0xFFFFFFFF),
        panelBorderColor: Color(0xFFD0D7DE),
      );

  /// GitHub Dark-style **dark** theme.
  factory FlutterDiffViewerTheme.dark() => const FlutterDiffViewerTheme(
        addedBackgroundColor: Color(0xFF0D4429),
        removedBackgroundColor: Color(0xFF4A1010),
        modifiedBackgroundColor: Color(0xFF3D3000),
        unchangedBackgroundColor: Color(0xFF0D1117),
        addedHighlightColor: Color(0xFF1A5C33),
        removedHighlightColor: Color(0xFF6B1F1F),
        addedTextColor: Color(0xFF3FB950),
        removedTextColor: Color(0xFFF85149),
        modifiedTextColor: Color(0xFFD29922),
        unchangedTextColor: Color(0xFFE6EDF3),
        lineNumberBackgroundColor: Color(0xFF161B22),
        lineNumberTextColor: Color(0xFF6E7681),
        dividerColor: Color(0xFF30363D),
        borderColor: Color(0xFF30363D),
        headerBackgroundColor: Color(0xFF161B22),
        headerTextColor: Color(0xFFE6EDF3),
        indicatorAddedColor: Color(0xFF3FB950),
        indicatorRemovedColor: Color(0xFFF85149),
        indicatorUnchangedColor: Color(0xFF6E7681),
        summaryBackgroundColor: Color(0xFF161B22),
        collapsedSectionColor: Color(0xFF0C2137),
        collapsedSectionTextColor: Color(0xFF58A6FF),
        navigationButtonColor: Color(0xFF388BFD),
        navigationButtonTextColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFF0D1117),
        panelBackgroundColor: Color(0xFF0D1117),
        panelBorderColor: Color(0xFF30363D),
      );

  // ---------------------------------------------------------------------------
  // Static helpers
  // ---------------------------------------------------------------------------

  /// Resolves the appropriate theme for the given [context].
  static FlutterDiffViewerTheme resolveFromContext(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? FlutterDiffViewerTheme.dark()
        : FlutterDiffViewerTheme.light();
  }

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  /// Returns a copy of this theme with the given fields replaced.
  FlutterDiffViewerTheme copyWith({
    Color? addedBackgroundColor,
    Color? removedBackgroundColor,
    Color? modifiedBackgroundColor,
    Color? unchangedBackgroundColor,
    Color? addedHighlightColor,
    Color? removedHighlightColor,
    Color? addedTextColor,
    Color? removedTextColor,
    Color? modifiedTextColor,
    Color? unchangedTextColor,
    Color? lineNumberBackgroundColor,
    Color? lineNumberTextColor,
    Color? dividerColor,
    Color? borderColor,
    Color? headerBackgroundColor,
    Color? headerTextColor,
    Color? indicatorAddedColor,
    Color? indicatorRemovedColor,
    Color? indicatorUnchangedColor,
    Color? summaryBackgroundColor,
    Color? collapsedSectionColor,
    Color? collapsedSectionTextColor,
    Color? navigationButtonColor,
    Color? navigationButtonTextColor,
    Color? backgroundColor,
    Color? panelBackgroundColor,
    Color? panelBorderColor,
    Color? leftPanelBackgroundColor,
    Color? rightPanelBackgroundColor,
    Color? leftPanelBorderColor,
    Color? rightPanelBorderColor,
    Color? leftAddedBackgroundColor,
    Color? rightAddedBackgroundColor,
    Color? leftRemovedBackgroundColor,
    Color? rightRemovedBackgroundColor,
    Color? leftModifiedBackgroundColor,
    Color? rightModifiedBackgroundColor,
    Color? leftUnchangedBackgroundColor,
    Color? rightUnchangedBackgroundColor,
    Color? leftAddedHighlightColor,
    Color? rightAddedHighlightColor,
    Color? leftRemovedHighlightColor,
    Color? rightRemovedHighlightColor,
    Color? leftAddedTextColor,
    Color? rightAddedTextColor,
    Color? leftRemovedTextColor,
    Color? rightRemovedTextColor,
    Color? leftModifiedTextColor,
    Color? rightModifiedTextColor,
    Color? leftUnchangedTextColor,
    Color? rightUnchangedTextColor,
    Color? leftBlockBackgroundColor,
    Color? rightBlockBackgroundColor,
    Color? leftBlockBorderColor,
    Color? rightBlockBorderColor,
  }) {
    return FlutterDiffViewerTheme(
      addedBackgroundColor: addedBackgroundColor ?? this.addedBackgroundColor,
      removedBackgroundColor:
          removedBackgroundColor ?? this.removedBackgroundColor,
      modifiedBackgroundColor:
          modifiedBackgroundColor ?? this.modifiedBackgroundColor,
      unchangedBackgroundColor:
          unchangedBackgroundColor ?? this.unchangedBackgroundColor,
      addedHighlightColor: addedHighlightColor ?? this.addedHighlightColor,
      removedHighlightColor:
          removedHighlightColor ?? this.removedHighlightColor,
      addedTextColor: addedTextColor ?? this.addedTextColor,
      removedTextColor: removedTextColor ?? this.removedTextColor,
      modifiedTextColor: modifiedTextColor ?? this.modifiedTextColor,
      unchangedTextColor: unchangedTextColor ?? this.unchangedTextColor,
      lineNumberBackgroundColor:
          lineNumberBackgroundColor ?? this.lineNumberBackgroundColor,
      lineNumberTextColor: lineNumberTextColor ?? this.lineNumberTextColor,
      dividerColor: dividerColor ?? this.dividerColor,
      borderColor: borderColor ?? this.borderColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      indicatorAddedColor: indicatorAddedColor ?? this.indicatorAddedColor,
      indicatorRemovedColor:
          indicatorRemovedColor ?? this.indicatorRemovedColor,
      indicatorUnchangedColor:
          indicatorUnchangedColor ?? this.indicatorUnchangedColor,
      summaryBackgroundColor:
          summaryBackgroundColor ?? this.summaryBackgroundColor,
      collapsedSectionColor:
          collapsedSectionColor ?? this.collapsedSectionColor,
      collapsedSectionTextColor:
          collapsedSectionTextColor ?? this.collapsedSectionTextColor,
      navigationButtonColor:
          navigationButtonColor ?? this.navigationButtonColor,
      navigationButtonTextColor:
          navigationButtonTextColor ?? this.navigationButtonTextColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
      panelBorderColor: panelBorderColor ?? this.panelBorderColor,
      leftPanelBackgroundColor:
          leftPanelBackgroundColor ?? this.leftPanelBackgroundColor,
      rightPanelBackgroundColor:
          rightPanelBackgroundColor ?? this.rightPanelBackgroundColor,
      leftPanelBorderColor: leftPanelBorderColor ?? this.leftPanelBorderColor,
      rightPanelBorderColor:
          rightPanelBorderColor ?? this.rightPanelBorderColor,
      leftAddedBackgroundColor:
          leftAddedBackgroundColor ?? this.leftAddedBackgroundColor,
      rightAddedBackgroundColor:
          rightAddedBackgroundColor ?? this.rightAddedBackgroundColor,
      leftRemovedBackgroundColor:
          leftRemovedBackgroundColor ?? this.leftRemovedBackgroundColor,
      rightRemovedBackgroundColor:
          rightRemovedBackgroundColor ?? this.rightRemovedBackgroundColor,
      leftModifiedBackgroundColor:
          leftModifiedBackgroundColor ?? this.leftModifiedBackgroundColor,
      rightModifiedBackgroundColor:
          rightModifiedBackgroundColor ?? this.rightModifiedBackgroundColor,
      leftUnchangedBackgroundColor:
          leftUnchangedBackgroundColor ?? this.leftUnchangedBackgroundColor,
      rightUnchangedBackgroundColor:
          rightUnchangedBackgroundColor ?? this.rightUnchangedBackgroundColor,
      leftAddedHighlightColor:
          leftAddedHighlightColor ?? this.leftAddedHighlightColor,
      rightAddedHighlightColor:
          rightAddedHighlightColor ?? this.rightAddedHighlightColor,
      leftRemovedHighlightColor:
          leftRemovedHighlightColor ?? this.leftRemovedHighlightColor,
      rightRemovedHighlightColor:
          rightRemovedHighlightColor ?? this.rightRemovedHighlightColor,
      leftAddedTextColor: leftAddedTextColor ?? this.leftAddedTextColor,
      rightAddedTextColor: rightAddedTextColor ?? this.rightAddedTextColor,
      leftRemovedTextColor: leftRemovedTextColor ?? this.leftRemovedTextColor,
      rightRemovedTextColor:
          rightRemovedTextColor ?? this.rightRemovedTextColor,
      leftModifiedTextColor:
          leftModifiedTextColor ?? this.leftModifiedTextColor,
      rightModifiedTextColor:
          rightModifiedTextColor ?? this.rightModifiedTextColor,
      leftUnchangedTextColor:
          leftUnchangedTextColor ?? this.leftUnchangedTextColor,
      rightUnchangedTextColor:
          rightUnchangedTextColor ?? this.rightUnchangedTextColor,
      leftBlockBackgroundColor:
          leftBlockBackgroundColor ?? this.leftBlockBackgroundColor,
      rightBlockBackgroundColor:
          rightBlockBackgroundColor ?? this.rightBlockBackgroundColor,
      leftBlockBorderColor: leftBlockBorderColor ?? this.leftBlockBorderColor,
      rightBlockBorderColor:
          rightBlockBorderColor ?? this.rightBlockBorderColor,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality & hashing
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlutterDiffViewerTheme &&
          runtimeType == other.runtimeType &&
          addedBackgroundColor == other.addedBackgroundColor &&
          removedBackgroundColor == other.removedBackgroundColor &&
          modifiedBackgroundColor == other.modifiedBackgroundColor &&
          unchangedBackgroundColor == other.unchangedBackgroundColor &&
          addedHighlightColor == other.addedHighlightColor &&
          removedHighlightColor == other.removedHighlightColor &&
          addedTextColor == other.addedTextColor &&
          removedTextColor == other.removedTextColor &&
          modifiedTextColor == other.modifiedTextColor &&
          unchangedTextColor == other.unchangedTextColor &&
          lineNumberBackgroundColor == other.lineNumberBackgroundColor &&
          lineNumberTextColor == other.lineNumberTextColor &&
          dividerColor == other.dividerColor &&
          borderColor == other.borderColor &&
          headerBackgroundColor == other.headerBackgroundColor &&
          headerTextColor == other.headerTextColor &&
          indicatorAddedColor == other.indicatorAddedColor &&
          indicatorRemovedColor == other.indicatorRemovedColor &&
          indicatorUnchangedColor == other.indicatorUnchangedColor &&
          summaryBackgroundColor == other.summaryBackgroundColor &&
          collapsedSectionColor == other.collapsedSectionColor &&
          collapsedSectionTextColor == other.collapsedSectionTextColor &&
          navigationButtonColor == other.navigationButtonColor &&
          navigationButtonTextColor == other.navigationButtonTextColor &&
          backgroundColor == other.backgroundColor &&
          panelBackgroundColor == other.panelBackgroundColor &&
          panelBorderColor == other.panelBorderColor &&
          leftPanelBackgroundColor == other.leftPanelBackgroundColor &&
          rightPanelBackgroundColor == other.rightPanelBackgroundColor &&
          leftPanelBorderColor == other.leftPanelBorderColor &&
          rightPanelBorderColor == other.rightPanelBorderColor &&
          leftAddedBackgroundColor == other.leftAddedBackgroundColor &&
          rightAddedBackgroundColor == other.rightAddedBackgroundColor &&
          leftRemovedBackgroundColor == other.leftRemovedBackgroundColor &&
          rightRemovedBackgroundColor == other.rightRemovedBackgroundColor &&
          leftModifiedBackgroundColor == other.leftModifiedBackgroundColor &&
          rightModifiedBackgroundColor == other.rightModifiedBackgroundColor &&
          leftUnchangedBackgroundColor == other.leftUnchangedBackgroundColor &&
          rightUnchangedBackgroundColor == other.rightUnchangedBackgroundColor &&
          leftAddedHighlightColor == other.leftAddedHighlightColor &&
          rightAddedHighlightColor == other.rightAddedHighlightColor &&
          leftRemovedHighlightColor == other.leftRemovedHighlightColor &&
          rightRemovedHighlightColor == other.rightRemovedHighlightColor &&
          leftAddedTextColor == other.leftAddedTextColor &&
          rightAddedTextColor == other.rightAddedTextColor &&
          leftRemovedTextColor == other.leftRemovedTextColor &&
          rightRemovedTextColor == other.rightRemovedTextColor &&
          leftModifiedTextColor == other.leftModifiedTextColor &&
          rightModifiedTextColor == other.rightModifiedTextColor &&
          leftUnchangedTextColor == other.leftUnchangedTextColor &&
          rightUnchangedTextColor == other.rightUnchangedTextColor &&
          leftBlockBackgroundColor == other.leftBlockBackgroundColor &&
          rightBlockBackgroundColor == other.rightBlockBackgroundColor &&
          leftBlockBorderColor == other.leftBlockBorderColor &&
          rightBlockBorderColor == other.rightBlockBorderColor;

  @override
  int get hashCode => Object.hashAll([
        addedBackgroundColor,
        removedBackgroundColor,
        modifiedBackgroundColor,
        unchangedBackgroundColor,
        addedHighlightColor,
        removedHighlightColor,
        addedTextColor,
        removedTextColor,
        modifiedTextColor,
        unchangedTextColor,
        lineNumberBackgroundColor,
        lineNumberTextColor,
        dividerColor,
        borderColor,
        headerBackgroundColor,
        headerTextColor,
        indicatorAddedColor,
        indicatorRemovedColor,
        indicatorUnchangedColor,
        summaryBackgroundColor,
        collapsedSectionColor,
        collapsedSectionTextColor,
        navigationButtonColor,
        navigationButtonTextColor,
        backgroundColor,
        panelBackgroundColor,
        panelBorderColor,
        leftPanelBackgroundColor,
        rightPanelBackgroundColor,
        leftPanelBorderColor,
        rightPanelBorderColor,
        leftAddedBackgroundColor,
        rightAddedBackgroundColor,
        leftRemovedBackgroundColor,
        rightRemovedBackgroundColor,
        leftModifiedBackgroundColor,
        rightModifiedBackgroundColor,
        leftUnchangedBackgroundColor,
        rightUnchangedBackgroundColor,
        leftAddedHighlightColor,
        rightAddedHighlightColor,
        leftRemovedHighlightColor,
        rightRemovedHighlightColor,
        leftAddedTextColor,
        rightAddedTextColor,
        leftRemovedTextColor,
        rightRemovedTextColor,
        leftModifiedTextColor,
        rightModifiedTextColor,
        leftUnchangedTextColor,
        rightUnchangedTextColor,
        leftBlockBackgroundColor,
        rightBlockBackgroundColor,
        leftBlockBorderColor,
        rightBlockBorderColor,
      ]);

  @override
  String toString() => 'FlutterDiffViewerTheme('
      'backgroundColor: $backgroundColor, '
      'panelBackgroundColor: $panelBackgroundColor, '
      'leftPanelBackgroundColor: $leftPanelBackgroundColor, '
      'rightPanelBackgroundColor: $rightPanelBackgroundColor, '
      'addedBackgroundColor: $addedBackgroundColor)';
}
