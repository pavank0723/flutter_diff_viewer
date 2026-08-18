import 'package:flutter/material.dart';

enum PropertyCategory {
  general('General & Labels', Icons.info_outline),
  layout('Layout & Breakpoints', Icons.view_quilt),
  lineDisplay('Line Display & Gutter', Icons.format_list_numbered),
  diffBehavior('Diff & Granularity', Icons.difference),
  colors('Theme & Colors', Icons.palette),
  typography('Typography & Font', Icons.text_fields),
  spacing('Spacing & Sizes', Icons.aspect_ratio),
  interaction('Interaction & Scroll', Icons.touch_app),
  performance('Performance & Isolation', Icons.speed);

  final String label;
  final IconData icon;
  const PropertyCategory(this.label, this.icon);
}

enum EditorType {
  boolean,
  dropdown,
  color,
  number,
  text,
}

class PlaygroundPropertyDefinition {
  final String key;
  final String apiPath;
  final String label;
  final String description;
  final PropertyCategory category;
  final EditorType editorType;
  final Object defaultValue;
  final List<Object>? options; // For dropdown/enum editors
  final double? min;
  final double? max;
  final int? divisions;

  const PlaygroundPropertyDefinition({
    required this.key,
    required this.apiPath,
    required this.label,
    required this.description,
    required this.category,
    required this.editorType,
    required this.defaultValue,
    this.options,
    this.min,
    this.max,
    this.divisions,
  });
}
