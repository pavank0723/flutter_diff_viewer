import 'package:flutter/material.dart';

import '../../domain/playground_property_definition.dart';
import '../color_picker_dialog.dart';

class ColorEditor extends StatelessWidget {
  final PlaygroundPropertyDefinition definition;
  final Color value;
  final ValueChanged<Color> onChanged;

  const ColorEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
    super.key,
  });

  String _toHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  definition.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  'API: ${definition.apiPath}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () async {
              final selected = await showDialog<Color>(
                context: context,
                builder: (_) => ColorPickerDialog(
                  initialColor: value,
                  title: definition.label,
                ),
              );
              if (selected != null) {
                onChanged(selected);
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: value,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(_toHex(value),
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 11)),
                  const SizedBox(width: 4),
                  const Icon(Icons.palette_outlined, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
