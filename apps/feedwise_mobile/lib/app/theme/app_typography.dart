import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // === DISPLAY — Hero headings ===
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.1,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
      );

  static TextStyle get displaySmall => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  // === HEADLINE — Section headers ===
  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  // === TITLE — Card subtitles ===
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // === BODY — Main content ===
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // === LABEL — Buttons, chips, badges ===
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // === MONO — Evidence data, codes ===
  static TextStyle get monoMedium => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // === BRAND ===
  static TextStyle get brandWordmark => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        height: 1,
      );

  static TextStyle get brandTagline => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        height: 1.4,
      );
}
