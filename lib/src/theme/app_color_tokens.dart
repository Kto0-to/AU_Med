import 'package:flutter/material.dart';

@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  // Backgrounds
  final Color screenBg;
  final Color cardBg;
  final Color sectionBg;
  final Color? elevatedBg;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  // Inputs
  final Color inputBg;
  final Color inputBgFocus;

  // Borders
  final Color border;
  final Color borderHover;

  // Overlay
  final Color overlay;

  // Accent
  final Color accent;
  final Color accentStrong;
  final Color accentSoft;

  // Status
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Status backgrounds (transparent)
  final Color successBg;
  final Color errorBg;
  final Color warningBg;

  const AppColorTokens({
    required this.screenBg,
    required this.cardBg,
    required this.sectionBg,
    this.elevatedBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.inputBg,
    required this.inputBgFocus,
    required this.border,
    required this.borderHover,
    required this.overlay,
    required this.accent,
    required this.accentStrong,
    required this.accentSoft,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.successBg,
    required this.errorBg,
    required this.warningBg,
  });

  static const light = AppColorTokens(
    screenBg: Color(0xFFFFF5F0),
    cardBg: Color(0xFFFFFFFF),
    sectionBg: Color(0xFFFFF0E8),
    textPrimary: Color(0xFF2D2D2D),
    textSecondary: Color(0xFF8B8B8B),
    textTertiary: Color(0xFFB8B8B8),
    inputBg: Color(0xFFFFE5DC),
    inputBgFocus: Color(0xFFFFFFFF),
    border: Color(0x26FF8C69),
    borderHover: Color(0x4DFF8C69),
    overlay: Color(0x66000000),
    accent: Color(0xFFFF8C69),
    accentStrong: Color(0xFFFF6B5B),
    accentSoft: Color(0xFFFFD4C4),
    success: Color(0xFF6BBF7A),
    warning: Color(0xFFFFB08F),
    error: Color(0xFFFF5252),
    info: Color(0xFF5B9DFF),
    successBg: Color(0x266BBF7A),
    errorBg: Color(0x26FF5252),
    warningBg: Color(0x26FFB08F),
  );

  static const dark = AppColorTokens(
    screenBg: Color(0xFF0A0908),
    cardBg: Color(0xFF161312),
    sectionBg: Color(0xFF1F1A18),
    elevatedBg: Color(0xFF242020),
    textPrimary: Color(0xFFF5EDE5),
    textSecondary: Color(0xFF7A6A5A),
    textTertiary: Color(0xFF4A4038),
    inputBg: Color(0xFF1F1A18),
    inputBgFocus: Color(0xFF2A2520),
    border: Color(0x0FFF9F7A),
    borderHover: Color(0x26FF9F7A),
    overlay: Color(0xB3000000),
    accent: Color(0xFFFF9F7A),
    accentStrong: Color(0xFFFF7B6B),
    accentSoft: Color(0xFFE8967D),
    success: Color(0xFF7ACF8A),
    warning: Color(0xFFFFB08F),
    error: Color(0xFFFF6B6B),
    info: Color(0xFF6BA8FF),
    successBg: Color(0x267ACF8A),
    errorBg: Color(0x26FF6B6B),
    warningBg: Color(0x26FFB08F),
  );

  @override
  AppColorTokens copyWith({
    Color? screenBg,
    Color? cardBg,
    Color? sectionBg,
    Color? elevatedBg,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? inputBg,
    Color? inputBgFocus,
    Color? border,
    Color? borderHover,
    Color? overlay,
    Color? accent,
    Color? accentStrong,
    Color? accentSoft,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? successBg,
    Color? errorBg,
    Color? warningBg,
  }) {
    return AppColorTokens(
      screenBg: screenBg ?? this.screenBg,
      cardBg: cardBg ?? this.cardBg,
      sectionBg: sectionBg ?? this.sectionBg,
      elevatedBg: elevatedBg ?? this.elevatedBg,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      inputBg: inputBg ?? this.inputBg,
      inputBgFocus: inputBgFocus ?? this.inputBgFocus,
      border: border ?? this.border,
      borderHover: borderHover ?? this.borderHover,
      overlay: overlay ?? this.overlay,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      successBg: successBg ?? this.successBg,
      errorBg: errorBg ?? this.errorBg,
      warningBg: warningBg ?? this.warningBg,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    return AppColorTokens(
      screenBg: Color.lerp(screenBg, other.screenBg, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      sectionBg: Color.lerp(sectionBg, other.sectionBg, t)!,
      elevatedBg: Color.lerp(elevatedBg, other.elevatedBg, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      inputBg: Color.lerp(inputBg, other.inputBg, t)!,
      inputBgFocus: Color.lerp(inputBgFocus, other.inputBgFocus, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderHover: Color.lerp(borderHover, other.borderHover, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
    );
  }
}

extension BuildContextAppColors on BuildContext {
  AppColorTokens get appColors => Theme.of(this).extension<AppColorTokens>()!;
}
