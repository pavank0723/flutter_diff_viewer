import 'package:flutter/material.dart';

import '../../core/exceptions/diff_exceptions.dart';
import '../../data/engines/default_diff_engine.dart';
import '../../data/engines/diff_engine.dart';
import '../../data/repositories/diff_repository_impl.dart';
import '../../domain/entities/diff_result.dart';
import '../../domain/enums/diff_layout.dart';
import '../../domain/repositories/diff_repository.dart';
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

/// A Flutter widget that displays a GitHub/GitLab-style comparison between
/// two versions of text content.
///
/// ## Simple usage
///
/// ```dart
/// DiffViewer(
///   oldContent: 'Hello World',
///   newContent: 'Hello Dart',
/// )
/// ```
///
/// ## Advanced usage
///
/// ```dart
/// DiffViewer(
///   oldContent: oldText,
///   newContent: newText,
///   oldLabel: 'v1.2',
///   newLabel: 'v1.3',
///   controller: myController,
///   configuration: DiffViewerConfiguration(
///     layout: DiffLayout.sideBySide,
///     granularity: DiffGranularity.word,
///     collapseUnchangedLines: true,
///     showSummary: true,
///     showChangeNavigation: true,
///   ),
///   theme: DiffViewerTheme.dark(),
///   diffEngine: myCustomEngine,
///   headerBuilder: (ctx, old, new_, config) => MyHeader(),
///   lineBuilder: (ctx, line, config) => MyLine(line),
/// )
/// ```
///
/// ## Controller ownership
///
/// If you provide a [controller], YOU are responsible for disposing it.
/// If you do not provide one, [DiffViewer] creates and disposes its own.
///
/// ## Diff engine
///
/// By default, [DiffViewer] uses the built-in Myers LCS diff engine. To use
/// a custom algorithm, implement [DiffEngine] and pass it via [diffEngine].
class DiffViewer extends StatefulWidget {
  /// The original content to compare from.
  final String oldContent;

  /// The modified content to compare to.
  final String newContent;

  /// Optional label for the old (left/top) panel. Defaults to "Current".
  final String? oldLabel;

  /// Optional label for the new (right/bottom) panel. Defaults to "Modified".
  final String? newLabel;

  /// Configuration controlling layout, features, and appearance.
  ///
  /// Defaults to [DiffViewerConfiguration.defaults()].
  final DiffViewerConfiguration configuration;

  /// Theme overrides. If provided, overrides [configuration.theme].
  final DiffViewerTheme? theme;

  /// An optional external controller for programmatic navigation and scrolling.
  ///
  /// If not provided, [DiffViewer] creates and manages its own controller.
  /// If provided, [DiffViewer] does NOT dispose it — you are responsible.
  final DiffViewerController? controller;

  /// A custom diff engine implementation.
  ///
  /// If not provided, the built-in [DefaultDiffEngine] (Myers LCS) is used.
  ///
  /// ```dart
  /// DiffViewer(
  ///   diffEngine: MyCustomDiffEngine(),
  ///   ...
  /// )
  /// ```
  final DiffEngine? diffEngine;

  // ── Builder callbacks ───────────────────────────────────────────────────────

  /// Custom builder for the header section.
  final DiffHeaderBuilder? headerBuilder;

  /// Custom builder for individual diff line rows.
  final DiffLineBuilder? lineBuilder;

  /// Custom builder for the line number gutter.
  final DiffLineNumberBuilder? lineNumberBuilder;

  /// Custom builder for the change indicator (+, -, space).
  final DiffIndicatorBuilder? indicatorBuilder;

  /// Custom builder for inline diff segments (words/characters).
  final DiffSegmentBuilder? segmentBuilder;

  /// Custom builder for the summary bar.
  final DiffSummaryBuilder? summaryBuilder;

  /// Custom builder for the empty state (no changes detected).
  final DiffEmptyStateBuilder? emptyStateBuilder;

  /// Custom builder for the error state.
  final DiffErrorBuilder? errorBuilder;

  /// Custom builder for the loading state.
  final DiffLoadingBuilder? loadingBuilder;

  /// Custom builder for collapsed unchanged sections.
  final DiffCollapsedSectionBuilder? collapsedSectionBuilder;

  /// Custom builder for the footer section.
  final DiffFooterBuilder? footerBuilder;

  /// Creates a [DiffViewer].
  ///
  /// [oldContent] and [newContent] are required. All other parameters are
  /// optional and have sensible defaults.
  DiffViewer({
    required this.oldContent,
    required this.newContent,
    super.key,
    this.oldLabel,
    this.newLabel,
    DiffViewerConfiguration? configuration,
    this.theme,
    this.controller,
    this.diffEngine,
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
  }) : configuration = configuration ?? DiffViewerConfiguration.defaults();

  @override
  State<DiffViewer> createState() => _DiffViewerState();
}

class _DiffViewerState extends State<DiffViewer> {
  late DiffViewerController _controller;
  late DiffRepository _repository;
  late CalculateDiff _calculateDiff;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
    _initRepository();
    _startDiffCalculation();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = DiffViewerController();
      _ownsController = true;
    }
  }

  void _initRepository() {
    final engine = widget.diffEngine ?? const DefaultDiffEngine();
    _repository = DiffRepositoryImpl(engine: engine);
    _calculateDiff = CalculateDiff(_repository);
  }

  DiffViewerConfiguration get _effectiveConfig {
    final config = widget.configuration;
    if (widget.theme != null) {
      return config.copyWith(theme: widget.theme);
    }
    return config;
  }

  Future<void> _startDiffCalculation() async {
    _controller.setLoading();
    try {
      final options = _effectiveConfig.toComparisonOptions();
      final result = await _calculateDiff(
        oldContent: widget.oldContent,
        newContent: widget.newContent,
        options: options,
      );
      if (mounted) {
        _controller.setResult(result);
      }
    } on DiffException catch (e) {
      if (mounted) _controller.setError(e);
    } catch (e) {
      if (mounted) {
        _controller.setError(
          DiffCalculationException(
            'Unexpected error during diff calculation',
            cause: e,
          ),
        );
      }
    }
  }

  @override
  void didUpdateWidget(DiffViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-run diff if content or engine changed
    if (oldWidget.oldContent != widget.oldContent ||
        oldWidget.newContent != widget.newContent ||
        oldWidget.diffEngine != widget.diffEngine) {
      _initRepository();
      _startDiffCalculation();
    }

    // Swap controller if externally provided controller changed
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

        return Container(
          decoration: BoxDecoration(
            color: config.theme.backgroundColor,
            border: Border.all(
              color: config.theme.borderColor,
              width: config.spacing.borderWidth,
            ),
            borderRadius: BorderRadius.circular(config.spacing.borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              if (config.showHeader) _buildHeader(config),

              // Summary bar (shown only when loaded)
              if (config.showSummary && state == DiffViewerState.loaded)
                _buildSummary(config),

              // Main diff content
              Expanded(child: _buildBody(context, config, state)),

              // Change navigation
              if (config.showChangeNavigation &&
                  state == DiffViewerState.loaded)
                ChangeNavigationWidget(
                  controller: _controller,
                  configuration: config,
                ),

              // Footer
              if (widget.footerBuilder != null &&
                  state == DiffViewerState.loaded)
                widget.footerBuilder!(context, _controller.result!, config),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(DiffViewerConfiguration config) {
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

  Widget _buildSummary(DiffViewerConfiguration config) {
    final result = _controller.result;
    if (result == null) return const SizedBox.shrink();

    if (widget.summaryBuilder != null) {
      return widget.summaryBuilder!(context, result, config);
    }
    return DiffSummaryWidget(result: result, configuration: config);
  }

  Widget _buildBody(
    BuildContext context,
    DiffViewerConfiguration config,
    DiffViewerState state,
  ) {
    switch (state) {
      case DiffViewerState.idle:
      case DiffViewerState.loading:
        if (widget.loadingBuilder != null) {
          return widget.loadingBuilder!(context, config);
        }
        return DiffLoadingWidget(configuration: config);

      case DiffViewerState.error:
        if (widget.errorBuilder != null) {
          return widget.errorBuilder!(context, _controller.error!, config);
        }
        return DiffErrorWidget(
          error: _controller.error!,
          configuration: config,
        );

      case DiffViewerState.loaded:
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
    DiffViewerConfiguration config,
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
    DiffViewerConfiguration config,
  ) {
    switch (layout) {
      case DiffLayout.sideBySide:
        return SideBySideDiffView(
          result: result,
          configuration: config,
          controller: _controller,
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
