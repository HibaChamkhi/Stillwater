import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

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
