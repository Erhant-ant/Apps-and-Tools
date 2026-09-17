import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sınav Koçum Pro — Tema Sistemi
/// "BOOK + STUDY + MODERN" tasarım felsefesi
/// Kaliteli kitap kâğıdı, mürekkep mavisi, sıcak nostaljik atmosfer
class AppTheme {
  AppTheme._();

  // ─── Ana Renkler ───────────────────────────────────────────
  static const Color primary = Color(0xFF243B53);       // Koyu mürekkep mavisi
  static const Color primaryLight = Color(0xFF3B5B7D);  // Açık mürekkep
  static const Color primaryDark = Color(0xFF1A2D40);   // Koyu mürekkep
  static const Color secondary = Color(0xFF8F3D3D);     // Bordo — eski kitap kapağı
  static const Color secondaryLight = Color(0xFFB05A5A);// Açık bordo
  static const Color accent = Color(0xFF71856F);        // Adaçayı yeşili — başarı
  static const Color accentLight = Color(0xFF8FA88B);   // Açık adaçayı
  static const Color warning = Color(0xFFB08A4A);       // Mat altın — vurgu
  static const Color warningLight = Color(0xFFC9A86C);  // Açık altın
  static const Color error = Color(0xFFA94442);         // Mat kırmızı
  static const Color errorLight = Color(0xFFD4918F);    // Açık mat kırmızı

  // ─── Arka Plan & Yüzey ─────────────────────────────────────
  static const Color background = Color(0xFFF7F3EA);     // Kitap kâğıdı
  static const Color surface = Color(0xFFFFFDF7);        // Sıcak beyaz
  static const Color surfaceVariant = Color(0xFFF1EBDD); // Hafif krem
  static const Color cardBackground = Color(0xFFFCF9F1); // Kart kremi

  // ─── Kenar & Ayırıcı ───────────────────────────────────────
  static const Color border = Color(0xFFE7DFD0);         // Sıcak kenar
  static const Color divider = Color(0xFFE7DFD0);        // Ayırıcı

  // ─── Metin Renkleri ────────────────────────────────────────
  static const Color textPrimary = Color(0xFF263238);    // Koyu mürekkep
  static const Color textSecondary = Color(0xFF66706B);  // Doğal gri-yeşil
  static const Color textTertiary = Color(0xFF9CA3A0);   // Açık gri
  static const Color textOnPrimary = Color(0xFFFFFDF7);  // Sıcak beyaz

  // ─── Sınav Kartı Gradyanları ───────────────────────────────
  static const List<Color> kpssGradient = [
    Color(0xFF8F3D3D),   // Bordo
    Color(0xFFB05A5A),
  ];
  static const List<Color> yksGradient = [
    Color(0xFF243B53),   // Mürekkep mavisi
    Color(0xFF3B5B7D),
  ];
  static const List<Color> tytGradient = [
    Color(0xFF2C5F7C),   // Okyanus
    Color(0xFF4A8BAD),
  ];
  static const List<Color> aytGradient = [
    Color(0xFF6B4A7D),   // Leylak
    Color(0xFF8A6B9E),
  ];
  static const List<Color> ydsGradient = [
    Color(0xFF2B5B5A),   // Koyu Deniz/Teal
    Color(0xFF438A89),
  ];
  static const List<Color> primaryGradient = [
    Color(0xFF243B53),
    Color(0xFF3B5B7D),
  ];
  static const List<Color> secondaryGradient = [
    Color(0xFF8F3D3D),
    Color(0xFFB05A5A),
  ];

  // ─── Ders Renkleri (mat ve doğal tonlar) ────────────────────
  static const Color turkceColor = Color(0xFF2C5F7C);    // Okyanus mavisi
  static const Color matematikColor = Color(0xFF8F3D3D); // Bordo
  static const Color tarihColor = Color(0xFFB08A4A);     // Mat altın
  static const Color cografyaColor = Color(0xFF71856F);  // Adaçayı yeşili
  static const Color vatandaslikColor = Color(0xFF6B4A7D);// Leylak
  static const Color guncelColor = Color(0xFF3B7A8A);    // Çam mavisi
  static const Color edebiyatColor = Color(0xFF9E5A6B);  // Gül kurusu
  static const Color fenColor = Color(0xFF4A7A6B);       // Orman yeşili
  static const Color sosyalColor = Color(0xFFA06B3E);    // Kahve tonu

  // ─── Gölge ─────────────────────────────────────────────────
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: const Color(0xFF8A7D6B).withValues(alpha: 0.06),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF8A7D6B).withValues(alpha: 0.03),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF8A7D6B).withValues(alpha: 0.08),
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
      dividerColor: divider,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.lora(
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
          side: const BorderSide(color: border, width: 1),
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
          textStyle: GoogleFonts.nunitoSans(
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
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: border),
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
        selectedLabelStyle: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunitoSans(
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
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: GoogleFonts.nunitoSans(
          color: textOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Tipografi ─────────────────────────────────────────────
  // Başlıklar: Lora (serif — kitap/dergi hissi)
  // Gövde: Nunito Sans (modern sans-serif, okunabilir)
  static TextTheme get _textTheme {
    return TextTheme(
      // ─── Başlıklar (Lora — serif) ──────────
      displayLarge: GoogleFonts.lora(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.lora(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.lora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      // ─── Alt başlıklar (Nunito Sans — geçiş) ──
      titleLarge: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
      // ─── Gövde (Nunito Sans — okunabilir) ──────
      bodyLarge: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      bodySmall: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textTertiary,
      ),
      // ─── Etiketler (Nunito Sans) ───────────────
      labelLarge: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.nunitoSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textTertiary,
      ),
    );
  }
}
