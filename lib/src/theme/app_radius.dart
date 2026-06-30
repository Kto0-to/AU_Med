import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double card = 18;
  static const double button = 12;
  static const double input = 12;
  static const double chip = 50;
  static const double modal = 24;
  static const double avatar = 50;
  static const double iconButton = 8;

  static BorderRadius get cardBorder => BorderRadius.circular(card);
  static BorderRadius get buttonBorder => BorderRadius.circular(button);
  static BorderRadius get inputBorder => BorderRadius.circular(input);
  static BorderRadius get chipBorder => BorderRadius.circular(chip);
  static BorderRadius get modalBorder => BorderRadius.circular(modal);
}
