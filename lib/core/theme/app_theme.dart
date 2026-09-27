import 'package:flutter/material.dart';

class AppTheme {
  static const _seedColor = Colors.teal;

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
  );
}
