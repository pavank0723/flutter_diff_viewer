import 'package:flutter/material.dart';

import '../../domain/playground_property_definition.dart';

class BooleanEditor extends StatelessWidget {
  final PlaygroundPropertyDefinition definition;
  final bool value;
  final ValueChanged<bool> onChanged;

  const BooleanEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      dense: true,
      title: Text(
        definition.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      subtitle: Text(
        'API: ${definition.apiPath}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 11, fontFamily: 'monospace', color: Colors.blueGrey),
      ),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
