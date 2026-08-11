import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // ─── Display (Outfit) ────────────────────────────────────────────────────
  static TextStyle displayLarge([Color? color]) => GoogleFonts.outfit(
    fontSize: 40, fontWeight: FontWeight.w700, height: 1.1, color: color,
  );
  static TextStyle displayMedium([Color? color]) => GoogleFonts.outfit(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.15, color: color,
  );
  static TextStyle displaySmall([Color? color]) => GoogleFonts.outfit(
    fontSize: 28, fontWeight: FontWeight.w600, height: 1.2, color: color,
  );

  // ─── Headline (Inter) ────────────────────────────────────────────────────
  static TextStyle headlineLarge([Color? color]) => GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.w700, height: 1.25, color: color,
  );
  static TextStyle headlineMedium([Color? color]) => GoogleFonts.inter(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.3, color: color,
  );
  static TextStyle headlineSmall([Color? color]) => GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w600, height: 1.35, color: color,
  );

  // ─── Title ───────────────────────────────────────────────────────────────
  static TextStyle titleLarge([Color? color]) => GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w600, height: 1.4, color: color,
  );
  static TextStyle titleMedium([Color? color]) => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600, height: 1.4, color: color,
  );
  static TextStyle titleSmall([Color? color]) => GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w600, height: 1.4, color: color,
  );

  // ─── Body ────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge([Color? color]) => GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: color,
  );
  static TextStyle bodyMedium([Color? color]) => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: color,
  );
  static TextStyle bodySmall([Color? color]) => GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: color,
  );

  // ─── Label ───────────────────────────────────────────────────────────────
  static TextStyle labelLarge([Color? color]) => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w500, height: 1.4,
    letterSpacing: 0.3, color: color,
  );
  static TextStyle labelMedium([Color? color]) => GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w500, height: 1.4,
    letterSpacing: 0.3, color: color,
  );
  static TextStyle labelSmall([Color? color]) => GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w500, height: 1.4,
    letterSpacing: 0.5, color: color,
  );

  // ─── Wordmark ────────────────────────────────────────────────────────────
  static TextStyle wordmark([Color? color]) => GoogleFonts.outfit(
    fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 2.0, color: color,
  );

  // ─── Caption / Mono ──────────────────────────────────────────────────────
  static TextStyle mono([Color? color]) => GoogleFonts.jetBrainsMono(
    fontSize: 13, fontWeight: FontWeight.w500, height: 1.4, color: color,
  );
  static TextStyle monoSmall([Color? color]) => GoogleFonts.jetBrainsMono(
    fontSize: 11, fontWeight: FontWeight.w400, height: 1.4, color: color,
  );
}

// ─── Spacing ─────────────────────────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();
  static const double xxs  = 2;
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double xxl  = 32;
  static const double xxxl = 48;
}

// ─── Radius ───────────────────────────────────────────────────────────────────
class AppRadius {
  AppRadius._();
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double full = 999;
}
