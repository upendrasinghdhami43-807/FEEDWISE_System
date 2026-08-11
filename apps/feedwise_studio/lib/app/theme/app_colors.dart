import 'package:flutter/material.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // Primary — Deep Indigo (Trust, Authority, Intelligence)
  static const primary50  = Color(0xFFEEF0FF);
  static const primary100 = Color(0xFFDFE1FF);
  static const primary200 = Color(0xFFC6C9FF);
  static const primary300 = Color(0xFFA4A5FE);
  static const primary400 = Color(0xFF8580FB);
  static const primary500 = Color(0xFF6C5CE7); // ← Main brand color
  static const primary600 = Color(0xFF5A3FDD);
  static const primary700 = Color(0xFF4C31C2);
  static const primary800 = Color(0xFF3F299E);
  static const primary900 = Color(0xFF362582);

  // Secondary — Warm Coral (Energy, Action)
  static const secondary400 = Color(0xFFFF6B6B); // ← Accent
  static const secondary500 = Color(0xFFEE4444);
  static const secondary600 = Color(0xFFDB2C2C);

  // Tertiary — Teal (Growth, Learning, Progress)
  static const tertiary400 = Color(0xFF2DD4BF); // ← Progress
  static const tertiary500 = Color(0xFF14B8A6);
  static const tertiary600 = Color(0xFF0D9488);

  // Surfaces — Dark
  static const surfaceDark         = Color(0xFF0F1117);
  static const surfaceCardDark     = Color(0xFF1A1D27);
  static const surfaceElevatedDark = Color(0xFF242736);
  static const borderDark          = Color(0xFF2E3144);
  static const borderLightDark     = Color(0xFF3A3F56);

  // Surfaces — Light
  static const surfaceLight         = Color(0xFFF8F9FB);
  static const surfaceCardLight     = Color(0xFFFFFFFF);
  static const surfaceElevatedLight = Color(0xFFF0F2F5);
  static const borderLight          = Color(0xFFE2E8F0);

  // Text — Dark Mode
  static const textPrimaryDark    = Color(0xFFF1F5F9);
  static const textSecondaryDark  = Color(0xFF94A3B8);
  static const textTertiaryDark   = Color(0xFF64748B);

  // Text — Light Mode
  static const textPrimaryLight   = Color(0xFF0F172A);
  static const textSecondaryLight = Color(0xFF475569);
  static const textTertiaryLight  = Color(0xFF94A3B8);

  // Evidence Status
  static const evidenceSupported = Color(0xFF22C55E);
  static const evidenceUncertain = Color(0xFFF59E0B);
  static const evidenceMissing   = Color(0xFFEF4444);
  static const evidenceNeutral   = Color(0xFF94A3B8);

  // Status Colors
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error   = Color(0xFFEF4444);
  static const info    = Color(0xFF3B82F6);

  // Scenario Status
  static const statusDraft     = Color(0xFF94A3B8);
  static const statusReview    = Color(0xFFF59E0B);
  static const statusPublished = Color(0xFF22C55E);
  static const statusArchived  = Color(0xFF64748B);

  // Gradients
  static const heroGradientColors    = [Color(0xFF6C5CE7), Color(0xFF8B5CF6)];
  static const warmGradientColors    = [Color(0xFFFF6B6B), Color(0xFFFFA94D)];
  static const coolGradientColors    = [Color(0xFF2DD4BF), Color(0xFF6C5CE7)];
  static const tealGradientColors    = [Color(0xFF2DD4BF), Color(0xFF14B8A6)];
  static const successGradientColors = [Color(0xFF22C55E), Color(0xFF16A34A)];
}

// ─── Gradient Definitions ────────────────────────────────────────────────────

class AppGradients {
  AppGradients._();

  static const hero = LinearGradient(
    colors: AppColors.heroGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const warm = LinearGradient(
    colors: AppColors.warmGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cool = LinearGradient(
    colors: AppColors.coolGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const teal = LinearGradient(
    colors: AppColors.tealGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const success = LinearGradient(
    colors: AppColors.successGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glass = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
