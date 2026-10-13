import 'package:flutter/material.dart';

// ── App Color Tokens ──────────────────────────────────────────────────────────
// Single source of truth — import this file anywhere to stay consistent.
class AppTheme {
  AppTheme._();

  // Brand colors
  static const Color primary       = Color(0xFF3B82F6); // Blue-500
  static const Color primaryDark   = Color(0xFF1D4ED8); // Blue-700
  static const Color primaryLight  = Color(0xFFEFF6FF); // Blue-50

  // Neutrals
  static const Color textPrimary   = Color(0xFF1E293B); // Slate-800
  static const Color textSecondary = Color(0xFF64748B); // Slate-500
  static const Color textHint      = Color(0xFFCBD5E1); // Slate-300
  static const Color border        = Color(0xFFE2E8F0); // Slate-200
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color background    = Color(0xFFF8FAFC); // Slate-50

  // Global MaterialApp ThemeData — call AppTheme.themeData() in main.dart
  static ThemeData get themeData => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: background,
    fontFamily: 'SF Pro Display',
    useMaterial3: true,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.8),
      ),
      hintStyle: const TextStyle(color: textHint, fontSize: 14),
      labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimary),
    ),
  );
}

