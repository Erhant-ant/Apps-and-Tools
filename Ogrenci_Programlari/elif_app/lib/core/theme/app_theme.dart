import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Elif'in Sınav Koçu — Tema Sistemi
/// Göz yormayan, modern ve premium renk paleti
class AppTheme {
  AppTheme._();

  // ─── Ana Renkler ───────────────────────────────────────────
  static const Color primary = Color(0xFF4A6CF7);       // Yumuşak mavi
  static const Color primaryLight = Color(0xFF818CF8);   // Açık mavi
  static const Color primaryDark = Color(0xFF3451B2);    // Koyu mavi
  static const Color secondary = Color(0xFF7C3AED);      // Soft mor
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color accent = Color(0xFF10B981);         // Sakin yeşil — başarı
  static const Color accentLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);        // Sıcak turuncu
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);          // Yumuşak kırmızı
  static const Color errorLight = Color(0xFFFCA5A5);

  // ─── Arka Plan & Yüzey ─────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);     // Çok açık gri
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ─── Metin Renkleri ────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1E293B);    // Koyu lacivert
  static const Color textSecondary = Color(0xFF64748B);  // Orta gri
  static const Color textTertiary = Color(0xFF94A3B8);   // Açık gri
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Sınav Kartı Gradyanları ───────────────────────────────
  static const List<Color> kpssGradient = [
    Color(0xFF7C3AED),
    Color(0xFFA78BFA),
  ];
  static const List<Color> yksGradient = [
    Color(0xFF4A6CF7),
    Color(0xFF818CF8),
  ];
  static const List<Color> tytGradient = [
    Color(0xFF0EA5E9),
    Color(0xFF38BDF8),
  ];
  static const List<Color> aytGradient = [
    Color(0xFF8B5CF6),
    Color(0xFFC084FC),
  ];

  // ─── Ders Renkleri ─────────────────────────────────────────
  static const Color turkceColor = Color(0xFF3B82F6);
  static const Color matematikColor = Color(0xFFEF4444);
  static const Color tarihColor = Color(0xFFF59E0B);
  static const Color cografyaColor = Color(0xFF10B981);
  static const Color vatandaslikColor = Color(0xFF8B5CF6);
  static const Color guncelColor = Color(0xFF06B6D4);
  static const Color edebiyatColor = Color(0xFFEC4899);
  static const Color fenColor = Color(0xFF14B8A6);
  static const Color sosyalColor = Color(0xFFF97316);

  // ─── Gölge ─────────────────────────────────────────────────
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // ─── Kenar Yarıçapları ─────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;

  // ─── Boşluklar ─────────────────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ─── Tema ──────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: textOnPrimary,
        secondary: secondary,
        onSecondary: textOnPrimary,
        surface: surface,
        onSurface: textPrimary,
        error: error,
        onError: textOnPrimary,
      ),
      scaffoldBackgroundColor: background,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingMd,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: textOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineLarge: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textTertiary,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textTertiary,
      ),
    );
  }
}
