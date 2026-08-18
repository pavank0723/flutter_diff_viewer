import 'package:flutter/material.dart';

import '../../domain/playground_property_definition.dart';

class DropdownEditor<T extends Object> extends StatelessWidget {
  final PlaygroundPropertyDefinition definition;
  final T value;
  final ValueChanged<T> onChanged;

  const DropdownEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final options = definition.options as List<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  definition.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'API: ${definition.apiPath}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: Colors.blueGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            initialValue: value,
            isDense: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            items: options.map((opt) {
              final name = opt.toString().split('.').last;
              return DropdownMenuItem<T>(
                value: opt,
                child: Text(name,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
          ),
        ],
      ),
    );
  }
}
