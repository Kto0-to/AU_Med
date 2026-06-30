import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  static const instant = Duration(milliseconds: 100);
  static const fast = Duration(milliseconds: 200);
  static const standard = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);

  static const easeOut = Curves.easeOut;
  static const easeInOut = Curves.easeInOut;
}
