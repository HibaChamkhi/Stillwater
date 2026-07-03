import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Soft Wellness palette — cream, sage, forest, mauve.
class AppColors {
  const AppColors._();

  static const pageBg = Color(0xFFEBE6D8); // warm cream page
  static const surface = Color(0xFFF5F1E7); // card / off-white
  static const journalBg = Color(0xFFE7E1D1); // slightly warmer beige
  static const sage = Color(0xFF93A47D); // green cards
  static const sageDark = Color(0xFF6E7E56); // begin button
  static const forest = Color(0xFF5E6B47); // deep green text
  static const breatheBg = Color(0xFF67734D); // meditation screen
  static const tan = Color(0xFFD9D1BB); // beige tiles
  static const tanDeep = Color(0xFFCBC2A8);
  static const mauve = Color(0xFFB99CA8); // accent
  static const ink = Color(0xFF474640); // primary text
  static const inkSoft = Color(0xFF8C897C); // muted labels
  static const greenText = Color(0xFF7A8C5E); // italic accent words
  static const line = Color(0xFFDAD3C2); // hairlines
}

/// Typography — Cormorant (serif, expressive) + Nunito Sans (calm body).
class AppText {
  const AppText._();

  static TextStyle serif({
    double size = 28,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.ink,
    bool italic = false,
    double height = 1.14,
    double spacing = 0,
  }) {
    return GoogleFonts.cormorant(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: spacing,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    );
  }

  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double spacing = 0,
    double height = 1.45,
  }) {
    return GoogleFonts.nunitoSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: spacing,
      height: height,
    );
  }

  /// Uppercase tracked-out label (e.g. THURSDAY · MARCH 14).
  static TextStyle label({
    Color color = AppColors.inkSoft,
    double size = 10.5,
    FontWeight weight = FontWeight.w600,
  }) {
    return GoogleFonts.nunitoSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 1.9,
      height: 1.3,
    );
  }
}
