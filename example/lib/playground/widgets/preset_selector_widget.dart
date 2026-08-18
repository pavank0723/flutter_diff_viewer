import 'package:flutter/material.dart';

import '../domain/playground_preset.dart';

class PresetSelectorWidget extends StatelessWidget {
  final String activePresetId;
  final ValueChanged<PlaygroundPreset> onSelectPreset;

  const PresetSelectorWidget({
    required this.activePresetId,
    required this.onSelectPreset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presets = PlaygroundPreset.defaultPresets;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: presets.map((preset) {
          final isSelected = preset.id == activePresetId;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              avatar: Icon(
                preset.icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
              label: Text(preset.name),
              selected: isSelected,
              onSelected: (_) => onSelectPreset(preset),
              tooltip: preset.description,
            ),
          );
        }).toList(),
      ),
    );
  }
}
