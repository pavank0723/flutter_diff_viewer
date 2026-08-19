import 'package:flutter/material.dart';

import '../../domain/entities/diff_change.dart';
import '../../domain/entities/diff_line.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/entities/diff_segment.dart';
import '../configuration/diff_viewer_configuration.dart';

/// Builder for the header bar of the diff viewer.
///
/// Receives the configured [oldLabel] and [newLabel] strings (may be `null`
/// when the header is intentionally unlabelled) and the active
/// [FlutterDiffViewerConfiguration].
///
/// Return a [Widget] that occupies the full width of the viewer header.
///
/// ```dart
/// FlutterDiffViewer(
///   headerBuilder: (context, oldLabel, newLabel, config) {
///     return MyCustomHeader(old: oldLabel, new: newLabel);
///   },
/// )
/// ```
typedef DiffHeaderBuilder = Widget Function(
  BuildContext context,
  String? oldLabel,
  String? newLabel,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for an individual diff line row.
///
/// Called once per [DiffLine] in the visible portion of the diff.  The builder
/// is responsible for rendering the entire row, including the line-number
/// gutter, indicator column, and code content.
///
/// Use this for complete row customization; for partial overrides prefer the
/// more focused builders such as [DiffLineNumberBuilder] or
/// [DiffIndicatorBuilder].
typedef DiffLineBuilder = Widget Function(
  BuildContext context,
  DiffLine line,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for the line-number gutter cell within a diff row.
///
/// [lineNumber] is `null` when the corresponding side has no line
/// (e.g., an added line has no old-side line number).
///
/// The returned widget should fit within
/// [DiffSpacing.lineNumberWidth] pixels.
typedef DiffLineNumberBuilder = Widget Function(
  BuildContext context,
  int? lineNumber,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for the change-indicator column cell within a diff row.
///
/// The indicator character is conventionally `'+'` for added,
/// `'-'` for removed, and a space for unchanged lines.
/// The returned widget should fit within
/// [DiffSpacing.indicatorWidth] pixels.
typedef DiffIndicatorBuilder = Widget Function(
  BuildContext context,
  DiffLine line,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for a single intra-line diff [DiffSegment].
///
/// Segments are the finest unit of change information — individual words or
/// characters within a modified line.  Use this builder to apply custom
/// highlight styles or interactive behaviour to each segment.
typedef DiffSegmentBuilder = Widget Function(
  BuildContext context,
  DiffSegment segment,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for the summary statistics bar.
///
/// Receives the complete [DiffResult] (including [DiffResult.additions] and
/// [DiffResult.deletions]) so the widget can render any subset of statistics.
typedef DiffSummaryBuilder = Widget Function(
  BuildContext context,
  DiffResult result,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for the empty state shown when no changes are detected.
///
/// Rendered instead of the diff view when [DiffResult.hasNoChanges] is `true`.
typedef DiffEmptyStateBuilder = Widget Function(
  BuildContext context,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for the error state shown when diff computation fails.
///
/// [error] is the exception or error object thrown during computation.
/// The widget should present a user-friendly message and optionally a retry
/// action.
typedef DiffErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for the loading state while the diff is being computed.
///
/// Rendered in place of the diff view while an async diff computation is
/// in progress (e.g., when running in an isolate).
typedef DiffLoadingBuilder = Widget Function(
  BuildContext context,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for collapsed-section placeholder rows.
///
/// When [FlutterDiffViewerConfiguration.collapseUnchangedLines] is `true`,
/// runs of unchanged lines beyond the context window are replaced by a single
/// placeholder row.
///
/// [collapsedLineCount] is the number of hidden lines.
/// [onExpand] must be called when the user taps "expand" to reveal the lines.
typedef DiffCollapsedSectionBuilder = Widget Function(
  BuildContext context,
  int collapsedLineCount,
  VoidCallback onExpand,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for the footer section rendered below the diff content.
///
/// Receives the complete [DiffResult] so footer widgets can show aggregate
/// statistics or actions relevant to the entire diff.
typedef DiffFooterBuilder = Widget Function(
  BuildContext context,
  DiffResult result,
  FlutterDiffViewerConfiguration configuration,
);

/// Builder for the change-navigation bar (previous / next buttons).
///
/// [currentChange] is the **0-based** index of the currently focused change.
/// [totalChanges] is the total count of navigable changes in the diff.
/// [onPrevious] navigates to the preceding change (disabled at index 0).
/// [onNext] navigates to the following change (disabled at the last change).
typedef DiffChangeNavigationBuilder = Widget Function(
  BuildContext context,
  int currentChange,
  int totalChanges,
  VoidCallback onPrevious,
  VoidCallback onNext,
  FlutterDiffViewerConfiguration configuration,
);

// Explicit reference to suppress "unused import" warnings if this file is
// imported only for the typedef declarations.
// ignore: unused_element
DiffChange? _diffChangeRef;
