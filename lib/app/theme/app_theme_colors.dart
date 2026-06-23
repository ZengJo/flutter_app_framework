import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primaryButton;
  final Color secondaryButton;

  final Color titleText;
  final Color bodyText;

  final String? loginBackground;
  final String? homeBackground;

  const AppThemeColors({
    required this.primaryButton,
    required this.secondaryButton,
    required this.titleText,
    required this.bodyText,
    this.loginBackground,
    this.homeBackground,
  });

  @override
  AppThemeColors copyWith({
    Color? primaryButton,
    Color? secondaryButton,
    Color? titleText,
    Color? bodyText,
    String? loginBackground,
    String? homeBackground,
  }) {
    return AppThemeColors(
      primaryButton: primaryButton ?? this.primaryButton,
      secondaryButton: secondaryButton ?? this.secondaryButton,
      titleText: titleText ?? this.titleText,
      bodyText: bodyText ?? this.bodyText,
      loginBackground: loginBackground ?? this.loginBackground,
      homeBackground: homeBackground ?? this.homeBackground,
    );
  }

  @override
  AppThemeColors lerp(
    covariant ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      primaryButton: Color.lerp(primaryButton, other.primaryButton, t)!,
      secondaryButton: Color.lerp(secondaryButton, other.secondaryButton, t)!,
      titleText: Color.lerp(titleText, other.titleText, t)!,
      bodyText: Color.lerp(bodyText, other.bodyText, t)!,
      loginBackground: t < 0.5 ? loginBackground : other.loginBackground,
      homeBackground: t < 0.5 ? homeBackground : other.homeBackground,
    );
  }
}
