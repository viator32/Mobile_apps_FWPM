import 'package:flutter/material.dart';

class AppTheme {
  static final _seed = Colors.indigo;
  static final light = ThemeData(colorSchemeSeed: _seed, useMaterial3: true);
  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
  );
}
