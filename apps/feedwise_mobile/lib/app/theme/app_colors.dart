import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === PRIMARY — Deep Indigo ===
  static const primary50 = Color(0xFFEEF0FF);
  static const primary100 = Color(0xFFDFE1FF);
  static const primary200 = Color(0xFFC6C9FF);
  static const primary300 = Color(0xFFA4A5FE);
  static const primary400 = Color(0xFF8580FB);
  static const primary500 = Color(0xFF6C5CE7); // Main brand
  static const primary600 = Color(0xFF5A3FDD);
  static const primary700 = Color(0xFF4C31C2);
  static const primary800 = Color(0xFF3F299E);
  static const primary900 = Color(0xFF362582);

  // === SECONDARY — Warm Coral ===
  static const secondary50 = Color(0xFFFFF1F0);
  static const secondary100 = Color(0xFFFFE0DD);
  static const secondary200 = Color(0xFFFFC7C1);
  static const secondary300 = Color(0xFFFFA196);
  static const secondary400 = Color(0xFFFF6B6B); // Accent
  static const secondary500 = Color(0xFFEE4444);
  static const secondary600 = Color(0xFFDB2C2C);
  static const secondary700 = Color(0xFFB82121);
  static const secondary800 = Color(0xFF981F1F);
  static const secondary900 = Color(0xFF7E2020);

  // === TERTIARY — Teal ===
  static const tertiary50 = Color(0xFFF0FDFA);
  static const tertiary100 = Color(0xFFCCFBF1);
  static const tertiary200 = Color(0xFF99F6E4);
  static const tertiary300 = Color(0xFF5EEAD4);
  static const tertiary400 = Color(0xFF2DD4BF); // Progress
  static const tertiary500 = Color(0xFF14B8A6);
  static const tertiary600 = Color(0xFF0D9488);
  static const tertiary700 = Color(0xFF0F766E);

  // === EVIDENCE STATUS ===
  static const evidenceSupported = Color(0xFF22C55E);
  static const evidenceUncertain = Color(0xFFF59E0B);
  static const evidenceMissing = Color(0xFFEF4444);
  static const evidenceNeutral = Color(0xFF94A3B8);

  // === SURFACE — Light Mode ===
  static const surfaceLight = Color(0xFFFAFAFC);
  static const surfaceCardLight = Color(0xFFFFFFFF);
  static const surfaceElevatedLight = Color(0xFFF8F9FB);
  static const borderLight = Color(0xFFE2E8F0);

  // === SURFACE — Dark Mode ===
  static const surfaceDark = Color(0xFF0F1117);
  static const surfaceCardDark = Color(0xFF1A1D27);
  static const surfaceElevatedDark = Color(0xFF242736);
  static const borderDark = Color(0xFF2E3144);

  // === TEXT — Light Mode ===
  static const textPrimaryLight = Color(0xFF0F172A);
  static const textSecondaryLight = Color(0xFF475569);
  static const textTertiaryLight = Color(0xFF94A3B8);

  // === TEXT — Dark Mode ===
  static const textPrimaryDark = Color(0xFFF1F5F9);
  static const textSecondaryDark = Color(0xFF94A3B8);
  static const textTertiaryDark = Color(0xFF64748B);

  // === GRADIENTS ===
  static const heroGradientColors = [Color(0xFF6C5CE7), Color(0xFF8B5CF6)];
  static const warmGradientColors = [Color(0xFFFF6B6B), Color(0xFFFFA94D)];
  static const coolGradientColors = [Color(0xFF2DD4BF), Color(0xFF6C5CE7)];

  static const heroGradient = LinearGradient(
    colors: heroGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const warmGradient = LinearGradient(
    colors: warmGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const coolGradient = LinearGradient(
    colors: coolGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // === SKILL COLORS ===
  static const skillSource = Color(0xFF6C5CE7);
  static const skillEvidence = Color(0xFF14B8A6);
  static const skillAI = Color(0xFF8B5CF6);
  static const skillBias = Color(0xFFF59E0B);
  static const skillSafety = Color(0xFF22C55E);

  // Decision action colors
  static const decisionShare = Color(0xFF3B82F6);
  static const decisionVerify = Color(0xFFF59E0B);
  static const decisionReport = Color(0xFFEF4444);
  static const decisionIgnore = Color(0xFF94A3B8);

  // XP / Achievement colors
  static const xpColor = Color(0xFFFFD700);
  static const streakColor = Color(0xFFFF6B35);
}
