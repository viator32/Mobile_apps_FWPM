import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFFFFA000);

  /// Light theme seeded on yellow-orange.
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  /// Dark theme seeded on yellow-orange.
  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
