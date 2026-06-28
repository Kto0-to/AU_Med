import 'package:flutter/material.dart';
import 'package:au_med/src/theme/app_theme.dart';

class ColorPickerDialog extends StatefulWidget {
  final int initialColor;

  const ColorPickerDialog({super.key, this.initialColor = 0xFF4CAF50});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late int _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Выберите цвет'),
      content: SizedBox(
        width: 280,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: AppColors.medicationColors.map((colorInt) {
            final c = Color(colorInt);
            final isSelected = _selectedColor == colorInt;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedColor = colorInt);
                Navigator.pop(context, colorInt);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: theme.colorScheme.onSurface, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: c.withAlpha(80), blurRadius: 8)]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
