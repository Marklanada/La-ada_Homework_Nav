import 'package:flutter/material.dart';

// ── Core Palette ─────────────────────────────────────────────────────────────
const kInk         = Color(0xFF0D0D14);   // deep ink — AppBar, FAB, header card
const kGold        = Color(0xFFC8A96E);   // warm gold — accents, icons, amounts
const kGoldLight   = Color(0xFFF0E3C6);   // pale gold — icon bg, chip bg
const kSurface     = Color(0xFFF3F1EC);   // warm off-white — scaffold bg
const kCard        = Color(0xFFFAFAF7);   // card / field fill
const kMist        = Color(0xFFE8E5DC);   // subtle borders / dividers
const kLabel       = Color(0xFF7A7870);   // secondary text, hints
const kGreen       = Color(0xFF2EBD8C);   // success / positive amounts
const kRed         = Color(0xFFE84F60);   // destructive / errors

// ── Aliases (keep old names working if you prefer) ───────────────────────────
const kPrimary     = kInk;
const kPrimaryDark = kInk;
const kAccent      = kGold;
const kBg          = kSurface;
const kDivider     = kMist;
const kHint        = kLabel;

// ── Gradient (ink → slightly lighter ink for depth) ─────────────────────────
const kGradient = LinearGradient(
  colors: [Color(0xFF0D0D14), Color(0xFF1A1A2E)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ── Gold gradient (used on header banner in Add screen) ─────────────────────
const kGoldGradient = LinearGradient(
  colors: [Color(0xFFC8A96E), Color(0xFFDFBD82)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ── Theme ────────────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kGold,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: kSurface,
    fontFamily: 'DMSans',   // add DM Sans to pubspec if desired, else remove
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: kInk,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kInk,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kLabel,
        side: const BorderSide(color: kMist),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kMist, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kMist, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kGold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kRed, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kRed, width: 2),
      ),
      hintStyle: const TextStyle(color: kLabel),
      labelStyle: const TextStyle(color: kLabel),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: kCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}