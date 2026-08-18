/// A production-grade Flutter package providing GitHub/GitLab-style
/// content comparison and diff viewing.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';
///
/// DiffViewer(
///   oldContent: 'Hello World',
///   newContent: 'Hello Dart',
/// )
/// ```
///
/// ## Advanced Usage
///
/// ```dart
/// DiffViewer(
///   oldContent: oldText,
///   newContent: newText,
///   configuration: DiffViewerConfiguration(
///     layout: DiffLayout.sideBySide,
///     granularity: DiffGranularity.word,
///     collapseUnchangedLines: true,
///     theme: DiffViewerTheme.dark(),
///     typography: DiffTypography.defaults(),
///     spacing: DiffSpacing.defaults(),
///     localizations: DiffLocalizations.defaults(),
///   ),
///   controller: myController,
///   diffEngine: myCustomEngine,
/// )
/// ```
library;

// Core & Exceptions
export 'src/core/exceptions/diff_exceptions.dart';

// Data Engines
export 'src/data/engines/diff_engine.dart';

// Domain Entities
export 'src/domain/entities/diff_change.dart';
export 'src/domain/entities/diff_line.dart';
export 'src/domain/entities/diff_result.dart';
export 'src/domain/entities/diff_segment.dart';

// Domain Enums
export 'src/domain/enums/diff_granularity.dart';
export 'src/domain/enums/diff_layout.dart';
export 'src/domain/enums/diff_type.dart';

// Domain Repositories & Use Cases
export 'src/domain/repositories/diff_repository.dart';
export 'src/domain/usecases/calculate_diff.dart';

// Domain Value Objects
export 'src/domain/value_objects/diff_comparison_options.dart';
export 'src/domain/value_objects/diff_line_number.dart';

// Presentation Builders
export 'src/presentation/builders/diff_builders.dart';

// Presentation Configuration
export 'src/presentation/configuration/diff_localizations.dart';
export 'src/presentation/configuration/diff_spacing.dart';
export 'src/presentation/configuration/diff_typography.dart';
export 'src/presentation/configuration/diff_viewer_configuration.dart';
export 'src/presentation/configuration/diff_viewer_theme.dart';

// Presentation Controllers
export 'src/presentation/controllers/diff_viewer_controller.dart';

// Presentation Widgets & Layouts
export 'src/presentation/widgets/diff_viewer.dart';
export 'src/presentation/widgets/side_by_side_diff_view.dart';
export 'src/presentation/widgets/stacked_diff_view.dart';
export 'src/presentation/widgets/unified_diff_view.dart';
