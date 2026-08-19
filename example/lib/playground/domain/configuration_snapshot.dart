import 'package:flutter_diff_viewer/flutter_diff_viewer.dart';

class ConfigurationSnapshot {
  final String description;
  final FlutterDiffViewerConfiguration configuration;
  final DateTime timestamp;

  ConfigurationSnapshot({
    required this.description,
    required this.configuration,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
