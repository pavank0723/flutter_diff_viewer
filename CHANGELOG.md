# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.3] - 2026-08-24

### Fixed
- **Identical Content Line Population**: Fixed `DiffRepositoryImpl` to populate unchanged text lines for identical inputs, enabling the left panel ("Current") to display current version text when `isCentralizedNoChanges: false`.
- **Studio Switch Editors**: Added boolean switch editors for `isCentralizedNoChanges`, `showContentWhenIdentical`, and `showHeaderDivider` in the interactive Customization Studio.

## [1.3.2] - 2026-08-24

### Added
- **Redesigned Header Bar (Title + Version Badge)**: Headers now render a clean `"Title"` + `"Version Badge"` layout (e.g., `"Current V1.1"`). Added `oldVersionCode` and `newVersionCode` parameters.
- **Custom Version Widget Overrides**: Added `oldVersionWidget` and `newVersionWidget` to replace default version badges with custom widgets.
- **Optional Header Bottom Divider (`showHeaderDivider`)**: Header bottom divider is now off by default (`false`) for a clean borderless look, and fully configurable in `FlutterDiffViewerTheme`.
- **Configurable Version Badge Styling**: Customizable badge colors (`versionBadgeBackgroundColor`, `versionBadgeTextColor`, `versionBadgeBorderRadius`), typography (`versionBadgeStyle`), and padding (`versionBadgeHorizontalPadding`, `versionBadgeVerticalPadding`).
- **Configurable Centralized Empty State (`isCentralizedNoChanges`)**: Added `isCentralizedNoChanges` flag in `FlutterDiffViewerConfiguration` (default: `true`). When set to `false`, displays current content on the left panel and a panel-level empty state on the right panel.
- **Configurable Empty State (`showContentWhenIdentical`)**: Added `showContentWhenIdentical` flag in `FlutterDiffViewerConfiguration`. When set to `true`, renders identical content as unchanged lines instead of hiding content behind the empty state.
- **Interactive Studio Updates**: Added interactive controls and code generator support for `isCentralizedNoChanges`, `showContentWhenIdentical`, and `showHeaderDivider` in the demo studio.

## [1.1.0] - 2026-08-20

### Added
- **Split Dual-Card Panel Mode (`splitPanels`)**: Render original and modified diff views as two distinct separate card containers.
- **Customizable In-Between Box Gap (`panelSpacing`)**: Responsive spacing gap in pixels between the left/original and right/modified panel cards.
- **Customizable Card Box Borders & Radius**: Added `panelBorderRadius` and `panelBorderWidth` in `DiffSpacing`, plus `panelBackgroundColor` and `panelBorderColor` in `FlutterDiffViewerTheme`.
- **Card-Embedded Version Headers**: In split panel mode, version titles ("Current V1.1", "Modified V1.2") render cleanly inside each card header bar.

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
- `FlutterDiffViewer` main widget with simple and advanced API
- `FlutterDiffViewerController` for programmatic navigation
- `FlutterDiffViewerConfiguration` — fully immutable configuration object
- `FlutterDiffViewerTheme` with `light()` and `dark()` factory constructors
- `DiffTypography` — full text style customization
- `DiffSpacing` — layout spacing customization
- `DiffLocalizations` — localization/i18n support
- Custom builder callbacks: `headerBuilder`, `lineBuilder`, `lineNumberBuilder`,
  `indicatorBuilder`, `segmentBuilder`, `summaryBuilder`, `emptyStateBuilder`,
  `errorBuilder`, `loadingBuilder`, `collapsedSectionBuilder`, `footerBuilder`
- `DiffEngine` abstract interface for pluggable diff algorithms
- Replaceable diff engine via `FlutterDiffViewer(diffEngine: myEngine)`
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
