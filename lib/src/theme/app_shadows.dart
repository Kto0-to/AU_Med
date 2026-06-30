import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  // Light theme card shadows
  static final cardLightSmall = BoxShadow(
    offset: const Offset(0, 2),
    blurRadius: 8,
    color: const Color(0x0FFF6B5B),
  );
  static final cardLightMedium = BoxShadow(
    offset: const Offset(0, 4),
    blurRadius: 20,
    color: const Color(0x14FF6B5B),
  );
  static final cardLightLarge = BoxShadow(
    offset: const Offset(0, 8),
    blurRadius: 30,
    color: const Color(0x26FF6B5B),
  );

  // Dark theme card shadows
  static final cardDarkSmall = BoxShadow(
    offset: const Offset(0, 2),
    blurRadius: 8,
    color: const Color(0x4D000000),
  );
  static final cardDarkMedium = BoxShadow(
    offset: const Offset(0, 4),
    blurRadius: 20,
    color: const Color(0x66000000),
  );
  static final cardDarkLarge = BoxShadow(
    offset: const Offset(0, 8),
    blurRadius: 30,
    color: const Color(0x80000000),
  );

  // Button shadows
  static final buttonPrimary = BoxShadow(
    offset: const Offset(0, 4),
    blurRadius: 14,
    color: const Color(0x4DFF6B5B),
  );
  static final buttonPrimaryHover = BoxShadow(
    offset: const Offset(0, 6),
    blurRadius: 20,
    color: const Color(0x66FF6B5B),
  );
  static final buttonPrimaryPressed = BoxShadow(
    offset: const Offset(0, 2),
    blurRadius: 8,
    color: const Color(0x33FF6B5B),
  );
}
