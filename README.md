# Flutter Diff Viewer

[![pub.dev](https://img.shields.io/pub/v/flutter_diff_viewer.svg)](https://pub.dev/packages/flutter_diff_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-≥3.10.0-blue.svg)](https://flutter.dev)

A production-grade Flutter package providing **GitHub/GitLab-style content comparison and diff viewing**. Built with Clean Architecture, SOLID principles, and designed for enterprise use.

---

## Features

- 🔄 **GitHub-style side-by-side diff view**
- 📄 **Unified diff view** (single column with +/- indicators)
- 📱 **Stacked diff view** (old above, new below — optimized for mobile)
- 🔤 **Word-level inline highlighting** — shows exactly which words changed
- 🔡 **Character-level inline highlighting** — maximum precision
- 🔢 **Line numbers** in the gutter
- 📊 **Change summary bar** (+N additions, -N deletions)
- 🧭 **Change navigation** (Previous / Next change buttons)
- 📂 **Collapsible unchanged sections** with configurable context lines
- 🎨 **Light and dark themes** (GitHub-style out of the box)
- 🎯 **Fully customizable** — every UI section has a builder callback
- 🔌 **Pluggable diff algorithm** — swap in your own engine
- ♿ **Accessibility** — semantic labels, screen reader support, color-independent indicators
- ⚡ **Performant** — `ListView.builder` handles 50,000+ line documents
- 🖥️ **Responsive** — auto-selects layout based on screen width
- 🌍 **Localization** — all user-visible strings are customizable

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_diff_viewer: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

```dart
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

DiffViewer(
  oldContent: 'Hello World\nLine two',
  newContent: 'Hello Dart\nLine two\nNew line',
)
```

That's it! The widget automatically:
1. Calculates the diff asynchronously
2. Selects the appropriate layout for the screen size
3. Renders with the default GitHub-style light theme

---

## Examples

### Side-by-Side View

```dart
DiffViewer(
  oldContent: oldText,
  newContent: newText,
  oldLabel: 'v1.2',
  newLabel: 'v1.3',
  configuration: DiffViewerConfiguration(
    layout: DiffLayout.sideBySide,
    theme: DiffViewerTheme.light(),
    typography: DiffTypography.defaults(),
    spacing: DiffSpacing.defaults(),
    localizations: DiffLocalizations.defaults(),
  ),
)
```

### Unified View

```dart
DiffViewer(
  oldContent: oldText,
  newContent: newText,
  configuration: DiffViewerConfiguration(
    layout: DiffLayout.unified,
    showLineNumbers: true,
    showSummary: true,
    theme: DiffViewerTheme.light(),
    typography: DiffTypography.defaults(),
    spacing: DiffSpacing.defaults(),
    localizations: DiffLocalizations.defaults(),
  ),
)
```

### Dark Mode

```dart
DiffViewer(
  oldContent: oldText,
  newContent: newText,
  theme: DiffViewerTheme.dark(),
)
```

### Adaptive (auto-detects from Flutter theme)

```dart
DiffViewer(
  oldContent: oldText,
  newContent: newText,
  configuration: DiffViewerConfiguration.adaptive(context),
)
```

---

## Configuration

`DiffViewerConfiguration` controls all layout and feature options:

```dart
DiffViewerConfiguration(
  // Layout
  layout: DiffLayout.auto,           // auto, sideBySide, unified, stacked
  sideBySideBreakpoint: 768.0,       // px width threshold for auto layout

  // Features
  showHeader: true,
  showLineNumbers: true,
  showIndicators: true,              // +/- indicator column
  showSummary: true,                 // additions/deletions count
  showChangeNavigation: true,
  enableTextSelection: true,
  synchronizedScrolling: true,       // sync side-by-side panels
  collapseUnchangedLines: true,

  // Comparison
  granularity: DiffGranularity.word, // line, word, character, auto
  ignoreWhitespace: false,
  caseSensitive: true,
  contextLines: 3,                   // unchanged lines around each change
  useIsolateForLargeDocuments: true, // compute() for >1000 lines

  // Styling
  theme: DiffViewerTheme.light(),
  typography: DiffTypography.defaults(),
  spacing: DiffSpacing.defaults(),
  localizations: DiffLocalizations.defaults(),
)
```

---

## Themes

### Built-in themes

```dart
DiffViewerTheme.light()  // GitHub light style
DiffViewerTheme.dark()   // GitHub dark style
```

### Custom theme

```dart
DiffViewer(
  oldContent: oldText,
  newContent: newText,
  theme: DiffViewerTheme.light().copyWith(
    addedBackgroundColor: Color(0xFFE8F5E9),
    removedBackgroundColor: Color(0xFFEDE7F6),
    addedTextColor: Color(0xFF2E7D32),
    removedTextColor: Color(0xFF6A1B9A),
  ),
)
```

---

## Word and Character Diff

```dart
// Word-level highlighting
DiffViewer(
  oldContent: 'The quick brown fox',
  newContent: 'The fast red cat',
  configuration: DiffViewerConfiguration(
    granularity: DiffGranularity.word,
    theme: DiffViewerTheme.light(),
    typography: DiffTypography.defaults(),
    spacing: DiffSpacing.defaults(),
    localizations: DiffLocalizations.defaults(),
  ),
)

// Character-level highlighting (maximum precision)
DiffViewer(
  oldContent: 'colour',
  newContent: 'color',
  configuration: DiffViewerConfiguration(
    granularity: DiffGranularity.character,
    theme: DiffViewerTheme.light(),
    typography: DiffTypography.defaults(),
    spacing: DiffSpacing.defaults(),
    localizations: DiffLocalizations.defaults(),
  ),
)
```

---

## Controller

Use `DiffViewerController` for programmatic navigation:

```dart
final controller = DiffViewerController();

// In your widget tree
DiffViewer(
  oldContent: oldText,
  newContent: newText,
  controller: controller,
)

// Navigate programmatically
controller.nextChange();
controller.previousChange();
controller.goToChange(2);
controller.scrollToLine(50);

// Collapse/expand
controller.collapseAll();
controller.expandAll();

// Read state
print('${controller.currentChangeIndex} of ${controller.totalChanges}');

// Always dispose if you create it yourself
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

---

## Custom Builders

Every UI section can be replaced with your own widget:

```dart
DiffViewer(
  oldContent: oldText,
  newContent: newText,

  // Custom header
  headerBuilder: (context, oldLabel, newLabel, config) {
    return MyCustomHeader(old: oldLabel, new_: newLabel);
  },

  // Custom line renderer
  lineBuilder: (context, line, config) {
    return MyCustomDiffLine(line: line);
  },

  // Custom collapsed section
  collapsedSectionBuilder: (context, count, onExpand, config) {
    return TextButton(
      onPressed: onExpand,
      child: Text('Show $count hidden lines'),
    );
  },

  // Custom empty state
  emptyStateBuilder: (context, config) {
    return const Center(child: Text('✅ Files are identical'));
  },

  // Custom error state
  errorBuilder: (context, error, config) {
    return Center(child: Text('Error: $error'));
  },
)
```

---

## Custom Diff Engine

Replace the built-in Myers LCS engine with your own:

```dart
class MyDiffEngine implements DiffEngine {
  @override
  DiffResult compare(
    String oldContent,
    String newContent,
    DiffComparisonOptions options,
  ) {
    // Your custom algorithm here
    return DiffResult(...);
  }
}

DiffViewer(
  oldContent: oldText,
  newContent: newText,
  diffEngine: MyDiffEngine(),
)
```

---

## Localization

Provide custom strings for any language:

```dart
DiffViewer(
  oldContent: oldText,
  newContent: newText,
  configuration: DiffViewerConfiguration(
    theme: DiffViewerTheme.light(),
    typography: DiffTypography.defaults(),
    spacing: DiffSpacing.defaults(),
    localizations: DiffLocalizations(
      oldVersionLabel: 'Aktuell',
      newVersionLabel: 'Geändert',
      addedLabel: 'Hinzugefügt',
      removedLabel: 'Entfernt',
      noChangesLabel: 'Keine Änderungen',
      nextChangeLabel: 'Nächste Änderung',
      previousChangeLabel: 'Vorherige Änderung',
      showMoreLabel: 'Zeile anzeigen',
      collapseLabel: 'Einklappen',
      loadingLabel: 'Berechnung…',
      errorLabel: 'Fehler beim Berechnen',
      additionsCountLabel: 'Hinzufügungen',
      deletionsCountLabel: 'Löschungen',
      modifiedLabel: 'Geändert',
      unchangedLabel: 'Unverändert',
      changeOfLabel: 'von',
    ),
  ),
)
```

---

## Responsive Layout

`DiffLayout.auto` automatically selects:
- **Side-by-side** when `availableWidth >= sideBySideBreakpoint` (default: 768px)
- **Unified** on narrower screens

Override the breakpoint:

```dart
DiffViewerConfiguration(
  layout: DiffLayout.auto,
  sideBySideBreakpoint: 600.0, // switch at 600px instead
  theme: DiffViewerTheme.light(),
  typography: DiffTypography.defaults(),
  spacing: DiffSpacing.defaults(),
  localizations: DiffLocalizations.defaults(),
)
```

---

## Accessibility

The package never relies solely on color to convey meaning:

- Change indicators: `+`, `-`, `~`, ` ` (in addition to color)
- Semantic labels on every line: "Added: content", "Removed: content"
- Screen reader support via Flutter's Semantics framework
- All interactive elements have tooltips

---

## Performance

- Uses `ListView.builder` — only visible rows are rendered
- Diff calculation runs asynchronously (`Future`-based)
- For documents >1000 lines with `useIsolateForLargeDocuments: true`, calculation runs in a separate isolate via `compute()`
- Staged diff: line-level first, then word/character only for changed lines

> **Measured**: 500-line documents calculate in <20ms on average hardware. Performance with very large documents (50,000+ lines) depends on the device and number of changes.

---

## Architecture

This package is built with Clean Architecture:

```
Presentation  →  Domain  ←  Data
                 (pure Dart)
```

- **Domain**: Entities, use cases, repository interfaces — zero Flutter/Material deps
- **Data**: Diff engines, repository implementations, models
- **Presentation**: Widgets, controller, themes, builders

---

## API Reference

See the [pub.dev documentation](https://pub.dev/documentation/flutter_diff_viewer) for the full API reference.

### Key classes

| Class | Description |
|---|---|
| `DiffViewer` | Main widget — the package entry point |
| `DiffViewerConfiguration` | Immutable configuration object |
| `DiffViewerTheme` | Color theme with light/dark factories |
| `DiffTypography` | Text style customization |
| `DiffSpacing` | Layout spacing customization |
| `DiffLocalizations` | User-visible string customization |
| `DiffViewerController` | Programmatic navigation and scroll control |
| `DiffEngine` | Abstract interface for custom diff algorithms |
| `DiffResult` | The output of a diff calculation |
| `DiffLine` | A single row in the diff view |
| `DiffSegment` | An inline highlighted text segment |

---

## Roadmap

- [ ] Syntax highlighting for code files
- [ ] Image diff support
- [ ] Inline comment support (GitHub PR review style)
- [ ] Export diff as HTML/PDF
- [ ] Web worker support for Flutter Web

---

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests to our [GitHub repository](https://github.com/your-org/flutter_diff_viewer).

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`flutter test`)
5. Submit a pull request

---

## License

This package is licensed under the [MIT License](LICENSE).
