import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final String title;

  const ColorPickerDialog({
    required this.initialColor,
    required this.title,
    super.key,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _currentColor;
  late TextEditingController _hexController;

  static const List<Color> _swatches = [
    Color(0xFFE6FFEC), // GitHub Light Added
    Color(0xFFFFEBE9), // GitHub Light Removed
    Color(0xFFFFF8C5), // GitHub Light Modified
    Color(0xFFFFFFFF), // White
    Color(0xFF0D4429), // GitHub Dark Added
    Color(0xFF4A1010), // GitHub Dark Removed
    Color(0xFF3D3000), // GitHub Dark Modified
    Color(0xFF0D1117), // GitHub Dark Bg
    Color(0xFF1A7F37), // GitHub Added Text
    Color(0xFFCF222E), // GitHub Removed Text
    Color(0xFF0969DA), // GitHub Blue
    Color(0xFF9A6700), // GitHub Orange
    Color(0xFFF6F8FA), // Light Gray
    Color(0xFF161B22), // Dark Gray
    Color(0xFFE8F5E9), // Light Green
    Color(0xFFEDE7F6), // Light Purple
    Color(0xFFE3F2FD), // Light Blue
    Color(0xFFFFF3E0), // Light Orange
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    _hexController = TextEditingController(text: _colorToHex(_currentColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  void _onHexSubmitted(String val) {
    final clean = val.replaceAll('#', '').trim();
    if (clean.length == 6 || clean.length == 8) {
      try {
        final parsed =
            int.parse(clean.length == 6 ? 'FF$clean' : clean, radix: 16);
        setState(() {
          _currentColor = Color(parsed);
        });
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current color preview card
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Center(
                child: Text(
                  _colorToHex(_currentColor),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        ThemeData.estimateBrightnessForColor(_currentColor) ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hex input field
            TextField(
              controller: _hexController,
              decoration: const InputDecoration(
                labelText: 'Hex Code (AARRGGBB or RRGGBB)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: _onHexSubmitted,
            ),
            const SizedBox(height: 16),

            const Text('Preset Swatches:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            // Swatch Grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _swatches.map((color) {
                final isSelected = color.toARGB32() == _currentColor.toARGB32();
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentColor = color;
                      _hexController.text = _colorToHex(color);
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade400,
                        width: isSelected ? 3.0 : 1.0,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.blue)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_currentColor),
          child: const Text('Apply Color'),
        ),
      ],
    );
  }
}
