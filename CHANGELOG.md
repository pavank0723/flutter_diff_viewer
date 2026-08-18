# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-08-17

### Added
- Initial release of `flutter_diff_viewer`
- GitHub/GitLab-style side-by-side diff view
- Unified diff view (single-column with +/- indicators)
- Stacked diff view (optimized for narrow/mobile screens)
- Line-level diff calculation using Myers LCS algorithm
- Word-level inline diff highlighting
- Character-level inline diff highlighting
- Staged diff processing (line → word → character, changed lines only)
- `DiffViewer` main widget with simple and advanced API
- `DiffViewerController` for programmatic navigation
- `DiffViewerConfiguration` — fully immutable configuration object
- `DiffViewerTheme` with `light()` and `dark()` factory constructors
- `DiffTypography` — full text style customization
- `DiffSpacing` — layout spacing customization
- `DiffLocalizations` — localization/i18n support
- Custom builder callbacks: `headerBuilder`, `lineBuilder`, `lineNumberBuilder`,
  `indicatorBuilder`, `segmentBuilder`, `summaryBuilder`, `emptyStateBuilder`,
  `errorBuilder`, `loadingBuilder`, `collapsedSectionBuilder`, `footerBuilder`
- `DiffEngine` abstract interface for pluggable diff algorithms
- Replaceable diff engine via `DiffViewer(diffEngine: myEngine)`
- Synchronized scrolling for side-by-side view
- Collapsible unchanged sections with configurable `contextLines`
- Change navigation: next/previous/go-to change
- Line numbers, indicators (+/-/space), headers, summary widget
- Responsive layout via `LayoutBuilder`
- Accessibility: semantic labels, screen reader support, color-independent indicators
- Async diff processing with `compute()` for large documents (>1000 lines)
- `ListView.builder` rendering — handles 50,000+ line documents efficiently
- Proper lifecycle management — no controller or scroll leaks
- Full null safety (Dart 3.x)
- Comprehensive unit, widget, and integration tests
- Full API documentation
- Professional example application with 10+ screens
