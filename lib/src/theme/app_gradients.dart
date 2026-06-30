import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  static const primaryLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB89D), Color(0xFFFF6B5B)],
  );

  static const primaryDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F7A), Color(0xFFFF7B6B)],
  );

  static const error = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFFB08F), Color(0xFFFF5252)],
  );

  static const success = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF6BBF7A), Color(0xFF4CAF50)],
  );

  static const accentSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD4C4), Color(0xFFFF8C69)],
  );
}
