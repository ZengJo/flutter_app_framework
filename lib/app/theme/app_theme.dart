import 'package:flutter/material.dart';

import 'app_theme_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,

      extensions: const [
        AppThemeColors(
          primaryButton: Color(0xFFFF6B00),
          secondaryButton: Color(0xFFFFA726),
          titleText: Color(0xFF222222),
          bodyText: Color(0xFF666666),
        ),
      ],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      extensions: const [
        AppThemeColors(
          primaryButton: Color(0xFF2196F3),
          secondaryButton: Color(0xFF64B5F6),
          titleText: Colors.white,
          bodyText: Color(0xFFCCCCCC),
        ),
      ],
    );
  }
}
