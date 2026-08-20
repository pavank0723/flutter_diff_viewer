import 'package:flutter/material.dart';

import '../../data/engines/default_diff_engine.dart';
import '../../data/repositories/diff_repository_impl.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_layout.dart';
import '../../domain/usecases/calculate_diff.dart';
import '../builders/diff_builders.dart';
import '../configuration/diff_viewer_configuration.dart';
import '../configuration/diff_viewer_theme.dart';
import '../controllers/diff_viewer_controller.dart';
import 'change_navigation_widget.dart';
import 'diff_empty_state_widget.dart';
import 'diff_header.dart';
import 'diff_summary_widget.dart';
import 'side_by_side_diff_view.dart';
import 'stacked_diff_view.dart';
import 'unified_diff_view.dart';

/// The primary widget for displaying content comparison diffs.
///
/// Accepts [oldContent] and [newContent] strings, calculates the diff
/// asynchronously (using background isolates for large documents), and renders
/// a responsive, accessible diff view.
///
/// Features:
/// - Side-by-side dual-panel view with synchronized scrolling
/// - Unified single-column view
/// - Stacked mobile-optimized view
/// - Split dual-card panel mode with customizable gap ([DiffSpacing.panelSpacing])
/// - Line, word, and character-level granularity
/// - Unchanged section collapsing with expand controls
/// - Change navigation bar (keyboard and touch accessible)
/// - Theme customization (light, dark, custom)
///
/// ## Basic Usage
///
/// ```dart
/// FlutterDiffViewer(
///   oldContent: 'Hello World',
///   newContent: 'Hello Flutter',
/// );
/// ```
///
/// ## Custom Configuration
///
/// ```dart
/// FlutterDiffViewer(
///   oldContent: oldText,
///   newContent: newText,
///   oldLabel: 'v1.0',
///   newLabel: 'v2.0',
///   configuration: FlutterDiffViewerConfiguration.defaults().copyWith(
///     layout: DiffLayout.sideBySide,
///     splitPanels: true,
///     spacing: DiffSpacing.defaults().copyWith(
///       panelSpacing: 16.0,
///       panelBorderRadius: 8.0,
///     ),
///     theme: FlutterDiffViewerTheme.dark(),
///   ),
/// );
/// ```
class FlutterDiffViewer extends StatefulWidget {
  /// The original (old) text content to compare.
  final String oldContent;

  /// The modified (new) text content to compare.
  final String newContent;

  /// Optional label for the old content version (e.g. "v1.0", "Current").
  final String? oldLabel;

  /// Optional label for the new content version (e.g. "v2.0", "Modified").
  final String? newLabel;

  /// Configuration object controlling layout, features, theme, and typography.
  ///
  /// Defaults to [FlutterDiffViewerConfiguration.defaults()].
  final FlutterDiffViewerConfiguration configuration;

  /// Optional explicit color theme. Overrides `configuration.theme` when provided.
  final FlutterDiffViewerTheme? theme;

  /// Optional external controller for programmatic scrolling and change navigation.
  ///
  /// If omitted, an internal controller is managed automatically.
  final FlutterDiffViewerController? controller;

  /// Optional custom builder for the header section.
  final DiffHeaderBuilder? headerBuilder;

  /// Optional custom builder for diff lines.
  final DiffLineBuilder? lineBuilder;

  /// Optional custom builder for line numbers.
  final DiffLineNumberBuilder? lineNumberBuilder;

  /// Optional custom builder for change indicators (+/-).
  final DiffIndicatorBuilder? indicatorBuilder;

  /// Optional custom builder for intra-line diff segments.
  final DiffSegmentBuilder? segmentBuilder;

  /// Optional custom builder for the summary bar.
  final DiffSummaryBuilder? summaryBuilder;

  /// Optional custom builder for the empty state (no changes).
  final DiffEmptyStateBuilder? emptyStateBuilder;

  /// Optional custom builder for the error state.
  final DiffErrorBuilder? errorBuilder;

  /// Optional custom builder for the loading state.
  final DiffLoadingBuilder? loadingBuilder;

  /// Optional custom builder for collapsed section placeholders.
  final DiffCollapsedSectionBuilder? collapsedSectionBuilder;

  /// Optional custom builder for the footer section below the diff.
  final DiffFooterBuilder? footerBuilder;

  /// Creates a [FlutterDiffViewer].
  FlutterDiffViewer({
    required this.oldContent,
    required this.newContent,
    super.key,
    this.oldLabel,
    this.newLabel,
    FlutterDiffViewerConfiguration? configuration,
    this.theme,
    this.controller,
    this.headerBuilder,
    this.lineBuilder,
    this.lineNumberBuilder,
    this.indicatorBuilder,
    this.segmentBuilder,
    this.summaryBuilder,
    this.emptyStateBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.collapsedSectionBuilder,
    this.footerBuilder,
  }) : configuration =
            configuration ?? FlutterDiffViewerConfiguration.defaults();

  @override
  State<FlutterDiffViewer> createState() => _FlutterDiffViewerState();
}

class _FlutterDiffViewerState extends State<FlutterDiffViewer> {
  late FlutterDiffViewerController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
    _computeDiff();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = FlutterDiffViewerController();
      _ownsController = true;
    }
  }

  FlutterDiffViewerConfiguration get _effectiveConfig {
    if (widget.theme != null) {
      return widget.configuration.copyWith(theme: widget.theme);
    }
    return widget.configuration;
  }

  void _computeDiff() {
    final config = _effectiveConfig;
    final options = config.toComparisonOptions();

    const engine = DefaultDiffEngine();
    const repository = DiffRepositoryImpl(engine: engine);
    const calculateDiff = CalculateDiff(repository);

    _controller.setLoading();

    calculateDiff(
      oldContent: widget.oldContent,
      newContent: widget.newContent,
      options: options,
    ).then((result) {
      if (mounted) {
        _controller.setResult(result);
      }
    }).catchError((dynamic error) {
      if (mounted) {
        _controller.setError(error as Object);
      }
    });
  }

  @override
  void didUpdateWidget(FlutterDiffViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.oldContent != widget.oldContent ||
        oldWidget.newContent != widget.newContent ||
        oldWidget.configuration != widget.configuration ||
        oldWidget.theme != widget.theme) {
      _computeDiff();
    }

    if (oldWidget.controller != widget.controller) {
      if (_ownsController) _controller.dispose();
      _initController();
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final config = _effectiveConfig;
        final state = _controller.state;
        final isSplit = config.splitPanels || config.spacing.panelSpacing > 0;

        return Container(
          decoration: isSplit
              ? null
              : BoxDecoration(
                  color: config.theme.backgroundColor,
                  border: Border.all(
                    color: config.theme.borderColor,
                    width: config.spacing.borderWidth,
                  ),
                  borderRadius:
                      BorderRadius.circular(config.spacing.borderRadius),
                ),
          clipBehavior: isSplit ? Clip.none : Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header (only rendered globally when NOT split into separate cards)
              if (config.showHeader && !isSplit) _buildHeader(config),

              // Summary bar (shown only when loaded)
              if (config.showSummary && state == FlutterDiffViewerState.loaded)
                _buildSummary(config),

              // Main diff content
              Expanded(child: _buildBody(context, config, state)),

              // Change navigation
              if (config.showChangeNavigation &&
                  state == FlutterDiffViewerState.loaded)
                ChangeNavigationWidget(
                  controller: _controller,
                  configuration: config,
                ),

              // Footer
              if (widget.footerBuilder != null &&
                  state == FlutterDiffViewerState.loaded)
                widget.footerBuilder!(context, _controller.result!, config),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(FlutterDiffViewerConfiguration config) {
    if (widget.headerBuilder != null) {
      return LayoutBuilder(
        builder: (context, constraints) => widget.headerBuilder!(
          context,
          widget.oldLabel,
          widget.newLabel,
          config,
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) => DiffHeader(
        oldLabel: widget.oldLabel,
        newLabel: widget.newLabel,
        isSideBySide: _resolveLayout(config, constraints.maxWidth) ==
            DiffLayout.sideBySide,
        configuration: config,
      ),
    );
  }

  Widget _buildSummary(FlutterDiffViewerConfiguration config) {
    final result = _controller.result;
    if (result == null) return const SizedBox.shrink();

    if (widget.summaryBuilder != null) {
      return widget.summaryBuilder!(context, result, config);
    }
    return DiffSummaryWidget(result: result, configuration: config);
  }

  Widget _buildBody(
    BuildContext context,
    FlutterDiffViewerConfiguration config,
    FlutterDiffViewerState state,
  ) {
    switch (state) {
      case FlutterDiffViewerState.idle:
      case FlutterDiffViewerState.loading:
        if (widget.loadingBuilder != null) {
          return widget.loadingBuilder!(context, config);
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(
                config.localizations.loadingLabel,
                style: config.typography.summaryStyle.copyWith(
                  color: config.theme.unchangedTextColor,
                ),
              ),
            ],
          ),
        );

      case FlutterDiffViewerState.error:
        if (widget.errorBuilder != null) {
          return widget.errorBuilder!(context, _controller.error!, config);
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Text(
                config.localizations.errorLabel,
                style: config.typography.summaryStyle.copyWith(
                  color: config.theme.removedTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _controller.error.toString(),
                style: config.typography.lineNumberStyle,
              ),
            ],
          ),
        );

      case FlutterDiffViewerState.loaded:
        final result = _controller.result!;
        if (result.hasNoChanges) {
          if (widget.emptyStateBuilder != null) {
            return widget.emptyStateBuilder!(context, config);
          }
          return DiffEmptyStateWidget(configuration: config);
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final layout = _resolveLayout(config, constraints.maxWidth);
            return _buildLayoutView(layout, result, config);
          },
        );
    }
  }

  DiffLayout _resolveLayout(
    FlutterDiffViewerConfiguration config,
    double availableWidth,
  ) {
    if (config.layout == DiffLayout.auto) {
      return availableWidth >= config.sideBySideBreakpoint
          ? DiffLayout.sideBySide
          : DiffLayout.unified;
    }
    return config.layout;
  }

  Widget _buildLayoutView(
    DiffLayout layout,
    DiffResult result,
    FlutterDiffViewerConfiguration config,
  ) {
    switch (layout) {
      case DiffLayout.sideBySide:
        return SideBySideDiffView(
          result: result,
          configuration: config,
          controller: _controller,
          oldLabel: widget.oldLabel,
          newLabel: widget.newLabel,
          lineBuilder: widget.lineBuilder,
          lineNumberBuilder: widget.lineNumberBuilder,
          indicatorBuilder: widget.indicatorBuilder,
          segmentBuilder: widget.segmentBuilder,
          collapsedSectionBuilder: widget.collapsedSectionBuilder,
        );
      case DiffLayout.unified:
        return UnifiedDiffView(
          result: result,
          configuration: config,
          controller: _controller,
          lineBuilder: widget.lineBuilder,
          lineNumberBuilder: widget.lineNumberBuilder,
          indicatorBuilder: widget.indicatorBuilder,
          segmentBuilder: widget.segmentBuilder,
          collapsedSectionBuilder: widget.collapsedSectionBuilder,
        );
      case DiffLayout.stacked:
        return StackedDiffView(
          result: result,
          configuration: config,
          controller: _controller,
          lineBuilder: widget.lineBuilder,
          lineNumberBuilder: widget.lineNumberBuilder,
          indicatorBuilder: widget.indicatorBuilder,
          segmentBuilder: widget.segmentBuilder,
          collapsedSectionBuilder: widget.collapsedSectionBuilder,
        );
      case DiffLayout.auto:
        // Should never reach here — resolved above
        return UnifiedDiffView(
          result: result,
          configuration: config,
          controller: _controller,
        );
    }
  }
}
