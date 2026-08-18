import 'package:flutter/material.dart';

import '../../domain/enums/diff_granularity.dart';
import '../../domain/enums/diff_layout.dart';
import '../../domain/value_objects/diff_comparison_options.dart';
import 'diff_localizations.dart';
import 'diff_spacing.dart';
import 'diff_typography.dart';
import 'diff_viewer_theme.dart';

/// The top-level configuration object for the diff viewer widget.
///
/// [DiffViewerConfiguration] is the single source of truth for every
/// behavioural, visual, and localisation setting.  Pass it to `DiffViewer`
/// or `DiffViewerController`; all child widgets receive it through the
/// widget tree.
///
/// ## Quick start
///
/// ```dart
/// DiffViewer(
///   configuration: DiffViewerConfiguration.defaults(),
///   oldContent: oldText,
///   newContent: newText,
/// )
/// ```
///
/// ## Custom configuration
///
/// ```dart
/// DiffViewer(
///   configuration: DiffViewerConfiguration.defaults().copyWith(
///     layout: DiffLayout.sideBySide,
///     collapseUnchangedLines: false,
///     theme: DiffViewerTheme.dark(),
///   ),
/// )
/// ```
class DiffViewerConfiguration {
  // ---------------------------------------------------------------------------
  // Layout
  // ---------------------------------------------------------------------------

  /// The visual layout used to display the diff.
  ///
  /// Defaults to [DiffLayout.auto], which selects [DiffLayout.sideBySide]
  /// above [sideBySideBreakpoint] and [DiffLayout.unified] below it.
  final DiffLayout layout;

  /// The minimum screen width (in logical pixels) at which the
  /// [DiffLayout.auto] mode chooses [DiffLayout.sideBySide].
  ///
  /// Screens narrower than this value fall back to [DiffLayout.unified].
  /// Defaults to `768.0`.
  final double sideBySideBreakpoint;

  // ---------------------------------------------------------------------------
  // Feature flags
  // ---------------------------------------------------------------------------

  /// Whether to render the header bar with old/new version labels.
  ///
  /// Defaults to `true`.
  final bool showHeader;

  /// Whether to show line numbers in the gutter column.
  ///
  /// Defaults to `true`.
  final bool showLineNumbers;

  /// Whether to show the `+`/`-`/space change indicator column.
  ///
  /// Defaults to `true`.
  final bool showIndicators;

  /// Whether to show the summary bar (additions/deletions count).
  ///
  /// Defaults to `true`.
  final bool showSummary;

  /// Whether to show the change navigation bar (previous/next buttons).
  ///
  /// Defaults to `true`.
  final bool showChangeNavigation;

  /// Whether users can select and copy text from the diff view.
  ///
  /// Defaults to `true`.
  final bool enableTextSelection;

  /// Whether the old and new panes scroll in sync in side-by-side mode.
  ///
  /// Defaults to `true`.
  final bool synchronizedScrolling;

  /// Whether unchanged lines beyond [contextLines] are collapsed into a
  /// placeholder row.
  ///
  /// Defaults to `true`.
  final bool collapseUnchangedLines;

  // ---------------------------------------------------------------------------
  // Comparison options
  // ---------------------------------------------------------------------------

  /// The granularity level for intra-line diff highlighting.
  ///
  /// Forwarded to [DiffComparisonOptions.granularity].
  /// Defaults to [DiffGranularity.word].
  final DiffGranularity granularity;

  /// Whether to ignore leading and trailing whitespace when comparing lines.
  ///
  /// Forwarded to [DiffComparisonOptions.ignoreWhitespace].
  /// Defaults to `false`.
  final bool ignoreWhitespace;

  /// Whether the comparison is case-sensitive.
  ///
  /// Forwarded to [DiffComparisonOptions.caseSensitive].
  /// Defaults to `true`.
  final bool caseSensitive;

  /// The number of unchanged context lines shown around each change block
  /// when [collapseUnchangedLines] is `true`.
  ///
  /// Forwarded to [DiffComparisonOptions.contextLines].
  /// Must be >= 0. Defaults to `3`.
  final int contextLines;

  /// Whether to offload large diff computations to a Dart isolate.
  ///
  /// Forwarded to [DiffComparisonOptions.useIsolate].
  /// Defaults to `true`.
  final bool useIsolateForLargeDocuments;

  // ---------------------------------------------------------------------------
  // Styling
  // ---------------------------------------------------------------------------

  /// The color theme for all diff viewer widgets.
  final DiffViewerTheme theme;

  /// The typography (text styles) for all diff viewer widgets.
  final DiffTypography typography;

  /// The spacing and sizing constants for all diff viewer widgets.
  final DiffSpacing spacing;

  /// The localizations (user-visible strings) for the diff viewer.
  final DiffLocalizations localizations;

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  /// Creates an immutable [DiffViewerConfiguration].
  ///
  /// The [theme], [typography], [spacing], and [localizations] fields are
  /// **required** to allow `const` construction.  For a zero-configuration
  /// setup, use the [DiffViewerConfiguration.defaults] factory instead.
  ///
  /// [contextLines] must be >= 0.
  const DiffViewerConfiguration({
    required this.theme,
    required this.typography,
    required this.spacing,
    required this.localizations,
    this.layout = DiffLayout.auto,
    this.sideBySideBreakpoint = 768.0,
    this.showHeader = true,
    this.showLineNumbers = true,
    this.showIndicators = true,
    this.showSummary = true,
    this.showChangeNavigation = true,
    this.enableTextSelection = true,
    this.synchronizedScrolling = true,
    this.collapseUnchangedLines = true,
    this.granularity = DiffGranularity.word,
    this.ignoreWhitespace = false,
    this.caseSensitive = true,
    this.contextLines = 3,
    this.useIsolateForLargeDocuments = true,
  }) : assert(contextLines >= 0, 'contextLines must be >= 0');

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// Creates a [DiffViewerConfiguration] with all default values.
  ///
  /// Uses [DiffViewerTheme.light], [DiffTypography.defaults],
  /// [DiffSpacing.defaults], and [DiffLocalizations.defaults].
  ///
  /// ```dart
  /// final config = DiffViewerConfiguration.defaults();
  /// ```
  factory DiffViewerConfiguration.defaults() => DiffViewerConfiguration(
        theme: DiffViewerTheme.light(),
        typography: DiffTypography.defaults(),
        spacing: const DiffSpacing.defaults(),
        localizations: const DiffLocalizations.defaults(),
      );

  /// Creates a [DiffViewerConfiguration] that automatically adapts its
  /// [theme] to the ambient [BuildContext] brightness.
  ///
  /// All other settings use their default values unless overridden via
  /// [copyWith] after construction.
  factory DiffViewerConfiguration.adaptive(BuildContext context) =>
      DiffViewerConfiguration(
        theme: DiffViewerTheme.resolveFromContext(context),
        typography: DiffTypography.defaults(),
        spacing: const DiffSpacing.defaults(),
        localizations: const DiffLocalizations.defaults(),
      );

  // ---------------------------------------------------------------------------
  // Domain bridge
  // ---------------------------------------------------------------------------

  /// Converts the comparison-related settings of this configuration into a
  /// [DiffComparisonOptions] value object suitable for passing to the domain
  /// layer.
  ///
  /// ```dart
  /// final options = configuration.toComparisonOptions();
  /// await diffRepository.compare(oldText, newText, options: options);
  /// ```
  DiffComparisonOptions toComparisonOptions() => DiffComparisonOptions(
        granularity: granularity,
        ignoreWhitespace: ignoreWhitespace,
        caseSensitive: caseSensitive,
        contextLines: contextLines,
        useIsolate: useIsolateForLargeDocuments,
      );

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  /// Returns a copy of this configuration with the given fields replaced.
  DiffViewerConfiguration copyWith({
    DiffLayout? layout,
    double? sideBySideBreakpoint,
    bool? showHeader,
    bool? showLineNumbers,
    bool? showIndicators,
    bool? showSummary,
    bool? showChangeNavigation,
    bool? enableTextSelection,
    bool? synchronizedScrolling,
    bool? collapseUnchangedLines,
    DiffGranularity? granularity,
    bool? ignoreWhitespace,
    bool? caseSensitive,
    int? contextLines,
    bool? useIsolateForLargeDocuments,
    DiffViewerTheme? theme,
    DiffTypography? typography,
    DiffSpacing? spacing,
    DiffLocalizations? localizations,
  }) {
    return DiffViewerConfiguration(
      layout: layout ?? this.layout,
      sideBySideBreakpoint: sideBySideBreakpoint ?? this.sideBySideBreakpoint,
      showHeader: showHeader ?? this.showHeader,
      showLineNumbers: showLineNumbers ?? this.showLineNumbers,
      showIndicators: showIndicators ?? this.showIndicators,
      showSummary: showSummary ?? this.showSummary,
      showChangeNavigation: showChangeNavigation ?? this.showChangeNavigation,
      enableTextSelection: enableTextSelection ?? this.enableTextSelection,
      synchronizedScrolling:
          synchronizedScrolling ?? this.synchronizedScrolling,
      collapseUnchangedLines:
          collapseUnchangedLines ?? this.collapseUnchangedLines,
      granularity: granularity ?? this.granularity,
      ignoreWhitespace: ignoreWhitespace ?? this.ignoreWhitespace,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      contextLines: contextLines ?? this.contextLines,
      useIsolateForLargeDocuments:
          useIsolateForLargeDocuments ?? this.useIsolateForLargeDocuments,
      theme: theme ?? this.theme,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      localizations: localizations ?? this.localizations,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality & hashing
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffViewerConfiguration &&
          runtimeType == other.runtimeType &&
          layout == other.layout &&
          sideBySideBreakpoint == other.sideBySideBreakpoint &&
          showHeader == other.showHeader &&
          showLineNumbers == other.showLineNumbers &&
          showIndicators == other.showIndicators &&
          showSummary == other.showSummary &&
          showChangeNavigation == other.showChangeNavigation &&
          enableTextSelection == other.enableTextSelection &&
          synchronizedScrolling == other.synchronizedScrolling &&
          collapseUnchangedLines == other.collapseUnchangedLines &&
          granularity == other.granularity &&
          ignoreWhitespace == other.ignoreWhitespace &&
          caseSensitive == other.caseSensitive &&
          contextLines == other.contextLines &&
          useIsolateForLargeDocuments == other.useIsolateForLargeDocuments &&
          theme == other.theme &&
          typography == other.typography &&
          spacing == other.spacing &&
          localizations == other.localizations;

  @override
  int get hashCode => Object.hashAll([
        layout,
        sideBySideBreakpoint,
        showHeader,
        showLineNumbers,
        showIndicators,
        showSummary,
        showChangeNavigation,
        enableTextSelection,
        synchronizedScrolling,
        collapseUnchangedLines,
        granularity,
        ignoreWhitespace,
        caseSensitive,
        contextLines,
        useIsolateForLargeDocuments,
        theme,
        typography,
        spacing,
        localizations,
      ]);

  @override
  String toString() => 'DiffViewerConfiguration('
      'layout: $layout, '
      'showHeader: $showHeader, '
      'showLineNumbers: $showLineNumbers, '
      'showSummary: $showSummary, '
      'granularity: $granularity, '
      'contextLines: $contextLines, '
      'collapseUnchangedLines: $collapseUnchangedLines)';
}
