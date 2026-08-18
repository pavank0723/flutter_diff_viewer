import 'package:flutter/material.dart';

import '../../domain/playground_property_definition.dart';

class NumberEditor extends StatelessWidget {
  final PlaygroundPropertyDefinition definition;
  final num value;
  final ValueChanged<num> onChanged;

  const NumberEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final min = definition.min ?? 0.0;
    final max = definition.max ?? 100.0;
    final divisions = definition.divisions;

    final isInt = value is int || definition.defaultValue is int;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(definition.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              Text('${isInt ? value.toInt() : value}',
                  style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
            ],
          ),
          Text('API: ${definition.apiPath}',
              style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: Colors.blueGrey)),
          Slider(
            value: value.toDouble().clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            label: '${isInt ? value.toInt() : value}',
            onChanged: (val) {
              onChanged(isInt ? val.toInt() : val);
            },
          ),
        ],
      ),
    );
  }
}
