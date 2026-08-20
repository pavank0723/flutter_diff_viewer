import 'package:flutter/material.dart';
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

class CodeGenerator {
  /// Generates clean, ready-to-paste Dart code for the current configuration.
  static String generateCode({
    required FlutterDiffViewerConfiguration config,
    required String oldContentVarName,
    required String newContentVarName,
    required String oldLabel,
    required String newLabel,
    bool minimalMode = true,
    bool includeImports = true,
  }) {
    final buffer = StringBuffer();

    if (includeImports) {
      buffer.writeln("import 'package:flutter/material.dart';");
      buffer.writeln(
          "import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';");
      buffer.writeln();
    }

    final defaults = FlutterDiffViewerConfiguration.defaults();

    final isLayoutChanged = config.layout != defaults.layout;
    final isSideBySideBpChanged =
        config.sideBySideBreakpoint != defaults.sideBySideBreakpoint;
    final isShowHeaderChanged = config.showHeader != defaults.showHeader;
    final isShowLineNumbersChanged =
        config.showLineNumbers != defaults.showLineNumbers;
    final isShowIndicatorsChanged =
        config.showIndicators != defaults.showIndicators;
    final isShowSummaryChanged = config.showSummary != defaults.showSummary;
    final isShowChangeNavChanged =
        config.showChangeNavigation != defaults.showChangeNavigation;
    final isCollapseChanged =
        config.collapseUnchangedLines != defaults.collapseUnchangedLines;
    final isContextLinesChanged = config.contextLines != defaults.contextLines;
    final isGranularityChanged = config.granularity != defaults.granularity;
    final isIgnoreWhitespaceChanged =
        config.ignoreWhitespace != defaults.ignoreWhitespace;
    final isCaseSensitiveChanged =
        config.caseSensitive != defaults.caseSensitive;
    final isEnableSelectionChanged =
        config.enableTextSelection != defaults.enableTextSelection;
    final isSyncScrollChanged =
        config.synchronizedScrolling != defaults.synchronizedScrolling;
    final isIsolateChanged = config.useIsolateForLargeDocuments !=
        defaults.useIsolateForLargeDocuments;

    final isThemeChanged = _isThemeCustomized(config.theme, defaults.theme);
    final isSpacingChanged =
        _isSpacingCustomized(config.spacing, defaults.spacing);
    final isLocalizationsChanged = _isLocalizationsCustomized(
        config.localizations, defaults.localizations, oldLabel, newLabel);

    buffer.writeln('FlutterDiffViewer(');
    buffer.writeln('  oldContent: $oldContentVarName,');
    buffer.writeln('  newContent: $newContentVarName,');
    if (oldLabel.isNotEmpty && oldLabel != 'Current') {
      buffer.writeln("  oldLabel: '$oldLabel',");
    }
    if (newLabel.isNotEmpty && newLabel != 'Modified') {
      buffer.writeln("  newLabel: '$newLabel',");
    }

    // Check if configuration parameters are present
    final hasConfigParams = !minimalMode ||
        isLayoutChanged ||
        isSideBySideBpChanged ||
        isShowHeaderChanged ||
        isShowLineNumbersChanged ||
        isShowIndicatorsChanged ||
        isShowSummaryChanged ||
        isShowChangeNavChanged ||
        isCollapseChanged ||
        isContextLinesChanged ||
        isGranularityChanged ||
        isIgnoreWhitespaceChanged ||
        isCaseSensitiveChanged ||
        isEnableSelectionChanged ||
        isSyncScrollChanged ||
        isIsolateChanged ||
        isThemeChanged ||
        isSpacingChanged ||
        isLocalizationsChanged;

    if (hasConfigParams) {
      buffer.writeln('  configuration: FlutterDiffViewerConfiguration(');

      if (!minimalMode || isLayoutChanged) {
        buffer.writeln('    layout: DiffLayout.${config.layout.name},');
      }
      if (!minimalMode || isSideBySideBpChanged) {
        buffer.writeln(
            '    sideBySideBreakpoint: ${config.sideBySideBreakpoint},');
      }
      if (!minimalMode || isShowHeaderChanged) {
        buffer.writeln('    showHeader: ${config.showHeader},');
      }
      if (!minimalMode || isShowLineNumbersChanged) {
        buffer.writeln('    showLineNumbers: ${config.showLineNumbers},');
      }
      if (!minimalMode || isShowIndicatorsChanged) {
        buffer.writeln('    showIndicators: ${config.showIndicators},');
      }
      if (!minimalMode || isShowSummaryChanged) {
        buffer.writeln('    showSummary: ${config.showSummary},');
      }
      if (!minimalMode || isShowChangeNavChanged) {
        buffer.writeln(
            '    showChangeNavigation: ${config.showChangeNavigation},');
      }
      if (!minimalMode || isCollapseChanged) {
        buffer.writeln(
            '    collapseUnchangedLines: ${config.collapseUnchangedLines},');
      }
      if (!minimalMode || isContextLinesChanged) {
        buffer.writeln('    contextLines: ${config.contextLines},');
      }
      if (!minimalMode || isGranularityChanged) {
        buffer.writeln(
            '    granularity: DiffGranularity.${config.granularity.name},');
      }
      if (!minimalMode || isIgnoreWhitespaceChanged) {
        buffer.writeln('    ignoreWhitespace: ${config.ignoreWhitespace},');
      }
      if (!minimalMode || isCaseSensitiveChanged) {
        buffer.writeln('    caseSensitive: ${config.caseSensitive},');
      }
      if (!minimalMode || isEnableSelectionChanged) {
        buffer
            .writeln('    enableTextSelection: ${config.enableTextSelection},');
      }
      if (!minimalMode || isSyncScrollChanged) {
        buffer.writeln(
            '    synchronizedScrolling: ${config.synchronizedScrolling},');
      }
      if (!minimalMode || isIsolateChanged) {
        buffer.writeln(
            '    useIsolateForLargeDocuments: ${config.useIsolateForLargeDocuments},');
      }

      // Theme
      if (!minimalMode || isThemeChanged) {
        buffer.write(
            _generateThemeCode(config.theme, defaults.theme, minimalMode));
      }

      // Spacing
      if (!minimalMode || isSpacingChanged) {
        buffer.write(_generateSpacingCode(
            config.spacing, defaults.spacing, minimalMode));
      }

      // Localizations
      if (!minimalMode || isLocalizationsChanged) {
        buffer.write(_generateLocalizationsCode(config.localizations,
            defaults.localizations, oldLabel, newLabel, minimalMode));
      }

      buffer.writeln('  ),');
    }

    buffer.write(')');
    return buffer.toString();
  }

  static String generateIntegrationSnippet(String packageVersion) {
    return '''
# 1. Add dependency to pubspec.yaml:
dependencies:
  flutter_diff_viewer: ^$packageVersion

# 2. Run in terminal:
flutter pub get

# 3. Import in your Dart file:
import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

# 4. Add widget to UI:
FlutterDiffViewer(
  oldContent: myOriginalText,
  newContent: myUpdatedText,
);
''';
  }

  static bool _isThemeCustomized(
      FlutterDiffViewerTheme current, FlutterDiffViewerTheme defaults) {
    return current.addedBackgroundColor != defaults.addedBackgroundColor ||
        current.addedTextColor != defaults.addedTextColor ||
        current.addedHighlightColor != defaults.addedHighlightColor ||
        current.removedBackgroundColor != defaults.removedBackgroundColor ||
        current.removedTextColor != defaults.removedTextColor ||
        current.removedHighlightColor != defaults.removedHighlightColor ||
        current.unchangedBackgroundColor != defaults.unchangedBackgroundColor ||
        current.panelBackgroundColor != defaults.panelBackgroundColor ||
        current.panelBorderColor != defaults.panelBorderColor ||
        current.lineNumberBackgroundColor !=
            defaults.lineNumberBackgroundColor ||
        current.borderColor != defaults.borderColor ||
        current.dividerColor != defaults.dividerColor;
  }

  static String _generateThemeCode(FlutterDiffViewerTheme current,
      FlutterDiffViewerTheme defaults, bool minimalMode) {
    final b = StringBuffer();
    b.writeln('    theme: FlutterDiffViewerTheme.light().copyWith(');
    if (!minimalMode ||
        current.addedBackgroundColor != defaults.addedBackgroundColor) {
      b.writeln(
          '      addedBackgroundColor: ${_colorToCode(current.addedBackgroundColor)},');
    }
    if (!minimalMode || current.addedTextColor != defaults.addedTextColor) {
      b.writeln(
          '      addedTextColor: ${_colorToCode(current.addedTextColor)},');
    }
    if (!minimalMode ||
        current.addedHighlightColor != defaults.addedHighlightColor) {
      b.writeln(
          '      addedHighlightColor: ${_colorToCode(current.addedHighlightColor)},');
    }
    if (!minimalMode ||
        current.removedBackgroundColor != defaults.removedBackgroundColor) {
      b.writeln(
          '      removedBackgroundColor: ${_colorToCode(current.removedBackgroundColor)},');
    }
    if (!minimalMode || current.removedTextColor != defaults.removedTextColor) {
      b.writeln(
          '      removedTextColor: ${_colorToCode(current.removedTextColor)},');
    }
    if (!minimalMode ||
        current.removedHighlightColor != defaults.removedHighlightColor) {
      b.writeln(
          '      removedHighlightColor: ${_colorToCode(current.removedHighlightColor)},');
    }
    if (!minimalMode ||
        current.unchangedBackgroundColor != defaults.unchangedBackgroundColor) {
      b.writeln(
          '      unchangedBackgroundColor: ${_colorToCode(current.unchangedBackgroundColor)},');
    }
    if (!minimalMode ||
        current.panelBackgroundColor != defaults.panelBackgroundColor) {
      b.writeln(
          '      panelBackgroundColor: ${_colorToCode(current.panelBackgroundColor)},');
    }
    if (!minimalMode || current.panelBorderColor != defaults.panelBorderColor) {
      b.writeln(
          '      panelBorderColor: ${_colorToCode(current.panelBorderColor)},');
    }
    if (!minimalMode ||
        current.lineNumberBackgroundColor !=
            defaults.lineNumberBackgroundColor) {
      b.writeln(
          '      lineNumberBackgroundColor: ${_colorToCode(current.lineNumberBackgroundColor)},');
    }
    if (!minimalMode || current.borderColor != defaults.borderColor) {
      b.writeln('      borderColor: ${_colorToCode(current.borderColor)},');
    }
    if (!minimalMode || current.dividerColor != defaults.dividerColor) {
      b.writeln('      dividerColor: ${_colorToCode(current.dividerColor)},');
    }
    b.writeln('    ),');
    return b.toString();
  }

  static bool _isSpacingCustomized(DiffSpacing current, DiffSpacing defaults) {
    return current.lineHeight != defaults.lineHeight ||
        current.lineNumberWidth != defaults.lineNumberWidth ||
        current.dividerWidth != defaults.dividerWidth ||
        current.borderRadius != defaults.borderRadius ||
        current.panelSpacing != defaults.panelSpacing ||
        current.panelBorderRadius != defaults.panelBorderRadius ||
        current.panelBorderWidth != defaults.panelBorderWidth;
  }

  static String _generateSpacingCode(
      DiffSpacing current, DiffSpacing defaults, bool minimalMode) {
    final b = StringBuffer();
    b.writeln('    spacing: DiffSpacing.defaults().copyWith(');
    if (!minimalMode || current.lineHeight != defaults.lineHeight) {
      b.writeln('      lineHeight: ${current.lineHeight},');
    }
    if (!minimalMode || current.lineNumberWidth != defaults.lineNumberWidth) {
      b.writeln('      lineNumberWidth: ${current.lineNumberWidth},');
    }
    if (!minimalMode || current.dividerWidth != defaults.dividerWidth) {
      b.writeln('      dividerWidth: ${current.dividerWidth},');
    }
    if (!minimalMode || current.borderRadius != defaults.borderRadius) {
      b.writeln('      borderRadius: ${current.borderRadius},');
    }
    if (!minimalMode || current.panelSpacing != defaults.panelSpacing) {
      b.writeln('      panelSpacing: ${current.panelSpacing},');
    }
    if (!minimalMode ||
        current.panelBorderRadius != defaults.panelBorderRadius) {
      b.writeln('      panelBorderRadius: ${current.panelBorderRadius},');
    }
    if (!minimalMode || current.panelBorderWidth != defaults.panelBorderWidth) {
      b.writeln('      panelBorderWidth: ${current.panelBorderWidth},');
    }
    b.writeln('    ),');
    return b.toString();
  }

  static bool _isLocalizationsCustomized(DiffLocalizations current,
      DiffLocalizations defaults, String oldLabel, String newLabel) {
    return (oldLabel.isNotEmpty && oldLabel != defaults.oldVersionLabel) ||
        (newLabel.isNotEmpty && newLabel != defaults.newVersionLabel);
  }

  static String _generateLocalizationsCode(
      DiffLocalizations current,
      DiffLocalizations defaults,
      String oldLabel,
      String newLabel,
      bool minimalMode) {
    final b = StringBuffer();
    b.writeln('    localizations: DiffLocalizations.defaults().copyWith(');
    if (oldLabel.isNotEmpty && oldLabel != defaults.oldVersionLabel) {
      b.writeln("      oldVersionLabel: '$oldLabel',");
    }
    if (newLabel.isNotEmpty && newLabel != defaults.newVersionLabel) {
      b.writeln("      newVersionLabel: '$newLabel',");
    }
    b.writeln('    ),');
    return b.toString();
  }

  static String _colorToCode(Color color) {
    final hex =
        color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
    return 'const Color(0x$hex)';
  }
}
