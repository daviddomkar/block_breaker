import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme() {
  final baseTheme = ThemeData.dark();

  return baseTheme.copyWith(
    textTheme: GoogleFonts.silkscreenTextTheme(
      baseTheme.textTheme.copyWith(
        displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        displayMedium: baseTheme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        displaySmall: baseTheme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
