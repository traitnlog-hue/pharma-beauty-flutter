import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Dusty Surreal × Soft Futurism × Clinical Trust
  static const ink = Color(0xFF252123);
  static const deep = Color(0xFF1C1B1C);
  static const paper = Color(0xFFF8F2F1);
  static const paper2 = Color(0xFFEEE6E4);
  static const surface = Color(0xFFFFFCFB);
  static const pearl = Color(0xFFFFFAF7);
  static const blush = Color(0xFFF0D6DE);
  static const ballerina = Color(0xFFE8BDC9);
  static const rose = Color(0xFFC78696);

  /// PHARMA BEAUTY signature — Rose Dragée.
  static const fuchsia = Color(0xFFDF0AA4);
  static const champagne = Color(0xFFC9A98F);
  static const roseGold = Color(0xFFC79B94);
  static const berry = Color(0xFF5C2941);
  static const muted = Color(0xFF756B6E);
  static const line = Color(0x24252123);

  // Semantic compatibility aliases used by feature screens.
  static const mint = Color(0xFFEDE4E2);
  static const sage = Color(0xFFA99691);
  static const oatmeal = Color(0xFFE9D8D1);
  static const lime = Color(0xFFDFB8C4);
  static const violet = fuchsia;
  static const cyan = Color(0xFFD4C9D0);
  static const coral = Color(0xFFD49A93);
  static const butter = Color(0xFFE8D1B9);
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
      primary: AppColors.ink,
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
