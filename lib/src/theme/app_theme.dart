import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class AppColors {
  static const List<int> medicationColors = [
    0xFF4CAF50,
    0xFF2196F3,
    0xFFFF9800,
    0xFFE91E63,
    0xFF9C27B0,
    0xFF00BCD4,
    0xFFFF5722,
    0xFF607D8B,
    0xFF795548,
    0xFF3F51B5,
    0xFF009688,
    0xFFFFEB3B,
  ];

  static Color getMedicationColor(int index) =>
      Color(medicationColors[index % medicationColors.length]);

  static const taken = Color(0xFF4CAF50);
  static const missed = Color(0xFFF44336);
  static const skipped = Color(0xFFFF9800);
  static const scheduled = Color(0xFF9E9E9E);
}

class MedicationIcons {
  static const icons = [
    Icons.medication,
    Icons.medication_liquid,
    Icons.vaccines,
    Icons.healing,
    Icons.spa,
    Icons.water_drop,
    Icons.science,
    Icons.medical_services,
  ];

  static const iconNames = [
    'таблетка',
    'жидкость',
    'спрей',
    'укол',
    'травы',
    'капли',
    'порошок',
    'аптечка',
  ];

  static IconData fromCodePoint(String? codePoint) {
    if (codePoint == null) return Icons.medication;
    final cp = int.parse(codePoint);
    for (final icon in icons) {
      if (icon.codePoint == cp) return icon;
    }
    return Icons.medication;
  }
}

class AppTheme {
  static shadcn.ThemeData lightTheme = shadcn.ThemeData(
    colorScheme: shadcn.ColorScheme(
      brightness: Brightness.light,
      background: const Color(0xFFF8FAFC),
      foreground: const Color(0xFF0F172A),
      primary: const Color(0xFF2563EB),
      primaryForeground: const Color(0xFFFFFFFF),
      secondary: const Color(0xFFF1F5F9),
      secondaryForeground: const Color(0xFF1E293B),
      muted: const Color(0xFFF1F5F9),
      mutedForeground: const Color(0xFF64748B),
      accent: const Color(0xFFF1F5F9),
      accentForeground: const Color(0xFF1E293B),
      destructive: const Color(0xFFEF4444),
      destructiveForeground: const Color(0xFFF8FAFC),
      border: const Color(0xFFE2E8F0),
      input: const Color(0xFFE2E8F0),
      ring: const Color(0xFF2563EB),
      card: const Color(0xFFFFFFFF),
      cardForeground: const Color(0xFF0F172A),
      popover: const Color(0xFFFFFFFF),
      popoverForeground: const Color(0xFF0F172A),
      chart1: const Color(0xFF2563EB),
      chart2: const Color(0xFF16A34A),
      chart3: const Color(0xFFF59E0B),
      chart4: const Color(0xFFEF4444),
      chart5: const Color(0xFF8B5CF6),
    ),
    radius: 12.0,
  );

  static shadcn.ThemeData darkTheme = shadcn.ThemeData.dark(
    colorScheme: shadcn.ColorScheme(
      brightness: Brightness.dark,
      background: const Color(0xFF0F172A),
      foreground: const Color(0xFFF8FAFC),
      primary: const Color(0xFF3B82F6),
      primaryForeground: const Color(0xFFFFFFFF),
      secondary: const Color(0xFF1E293B),
      secondaryForeground: const Color(0xFFF8FAFC),
      muted: const Color(0xFF1E293B),
      mutedForeground: const Color(0xFF94A3B8),
      accent: const Color(0xFF1E293B),
      accentForeground: const Color(0xFFF8FAFC),
      destructive: const Color(0xFF7F1D1D),
      destructiveForeground: const Color(0xFFF8FAFC),
      border: const Color(0xFF334155),
      input: const Color(0xFF334155),
      ring: const Color(0xFF3B82F6),
      card: const Color(0xFF1E293B),
      cardForeground: const Color(0xFFF8FAFC),
      popover: const Color(0xFF1E293B),
      popoverForeground: const Color(0xFFF8FAFC),
      chart1: const Color(0xFF3B82F6),
      chart2: const Color(0xFF22C55E),
      chart3: const Color(0xFFF59E0B),
      chart4: const Color(0xFFEF4444),
      chart5: const Color(0xFFA78BFA),
    ),
    radius: 12.0,
  );
}
