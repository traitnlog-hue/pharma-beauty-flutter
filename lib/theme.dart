import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Pink Glam Editorial × Clinical Trust
  static const ink = Color(0xFF3A1425);
  static const deep = Color(0xFF2B0B1B);
  static const paper = Color(0xFFFFF7FA);
  static const paper2 = Color(0xFFF6E8EE);
  static const surface = Color(0xFFFFFCFD);
  static const pearl = Color(0xFFFFFBF8);
  static const blush = Color(0xFFF6D5E1);
  static const ballerina = Color(0xFFF2C3D3);
  static const rose = Color(0xFFD7799B);

  /// PHARMA BEAUTY signature — Rose Dragée.
  static const fuchsia = Color(0xFFDF0AA4);
  static const champagne = Color(0xFFD5AE68);
  static const roseGold = Color(0xFFC98B84);
  static const berry = Color(0xFF741F42);
  static const muted = Color(0xFF806773);
  static const line = Color(0x243A1425);

  // Semantic compatibility aliases used by feature screens.
  static const mint = Color(0xFFF7DEE8);
  static const sage = Color(0xFFB88A9D);
  static const oatmeal = Color(0xFFF3E4DF);
  static const lime = Color(0xFFF3C65C);
  static const violet = fuchsia;
  static const cyan = Color(0xFFF0A7C0);
  static const coral = Color(0xFFE98285);
  static const butter = Color(0xFFF6DBA3);
}

ThemeData buildAppTheme() {
  const textTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 68,
        height: .96,
        fontWeight: FontWeight.w800,
        letterSpacing: -4.6),
    displayMedium: TextStyle(
        fontSize: 48,
        height: 1,
        fontWeight: FontWeight.w800,
        letterSpacing: -3.1),
    headlineLarge: TextStyle(
        fontSize: 36,
        height: 1.06,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.2),
    headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.08,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5),
    titleLarge: TextStyle(
        fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -.7),
    bodyLarge: TextStyle(fontSize: 15, height: 1.68),
    bodyMedium: TextStyle(fontSize: 13, height: 1.62),
    labelLarge:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .1),
  );

  return ThemeData(
    useMaterial3: true,
    splashFactory: InkRipple.splashFactory,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.fuchsia,
      primary: AppColors.berry,
      secondary: AppColors.fuchsia,
      tertiary: AppColors.champagne,
      surface: AppColors.paper,
    ),
    fontFamily: 'NotoSansKR',
    textTheme:
        textTheme.apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
    dividerColor: AppColors.line,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.paper.withValues(alpha: .96),
      foregroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.berry,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        foregroundColor: AppColors.berry,
        side: const BorderSide(color: AppColors.roseGold),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
      side: BorderSide(color: AppColors.line),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.berry,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      labelStyle: TextStyle(
          color: AppColors.ink, fontSize: 11, fontWeight: FontWeight.w700),
      secondaryLabelStyle: TextStyle(
          color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppColors.line)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppColors.fuchsia, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
    }),
  );
}
