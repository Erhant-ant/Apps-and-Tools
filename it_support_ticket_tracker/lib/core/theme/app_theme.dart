import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    const primary = Color(0xFFEA580C);
    const secondary = Color(0xFFF59E0B);

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          secondary: secondary,
          surface: Colors.white,
          error: const Color(0xFFB42318),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF172B4D),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFFCBD5E1)),
        ),
      ),
    );
  }
}
