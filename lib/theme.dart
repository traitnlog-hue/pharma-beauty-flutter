import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF10201D);
  static const deep = Color(0xFF071A17);
  static const paper = Color(0xFFF7F4EE);
  static const paper2 = Color(0xFFECE7DE);
  static const surface = Color(0xFFFFFCF7);
  static const mint = Color(0xFFDCEFE8);
  static const sage = Color(0xFF79998D);
  static const oatmeal = Color(0xFFE8DFD0);
  static const lime = Color(0xFFC7FF54);
  static const violet = Color(0xFF7657FF);
  static const cyan = Color(0xFF5FE2DB);
  static const coral = Color(0xFFFF7D68);
  static const butter = Color(0xFFFFE88F);
  static const muted = Color(0xFF64736F);
  static const line = Color(0x1F10201D);
}

ThemeData buildAppTheme() {
  const textTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 72,
        height: .94,
        fontWeight: FontWeight.w800,
        letterSpacing: -5.2),
    displayMedium: TextStyle(
        fontSize: 52,
        height: .98,
        fontWeight: FontWeight.w800,
        letterSpacing: -3.8),
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
    bodyLarge: TextStyle(fontSize: 15, height: 1.65),
    bodyMedium: TextStyle(fontSize: 13, height: 1.6),
    labelLarge:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .1),
  );

  return ThemeData(
    useMaterial3: true,
    splashFactory: InkRipple.splashFactory,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      primary: AppColors.ink,
      secondary: AppColors.violet,
      tertiary: AppColors.cyan,
      surface: AppColors.paper,
    ),
    fontFamily: 'NotoSansKR',
    textTheme:
        textTheme.apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
    dividerColor: AppColors.line,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.paper,
      foregroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
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
        side: const BorderSide(color: AppColors.line),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
      side: BorderSide(color: AppColors.line),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.ink,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
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
          borderSide: const BorderSide(color: AppColors.violet, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
    }),
  );
}
