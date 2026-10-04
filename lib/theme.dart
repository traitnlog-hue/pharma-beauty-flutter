import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  // BE:CAUSE palette: gold is the only action/selection signal.
  // Warm ivory surfaces keep a commerce-heavy screen calm and legible.
  static const gold = Color(0xFFB68A3C);
  static const goldDeep = Color(0xFF765316);
  static const champagneBase = Color(0xFFFBF9F3);
  static const sunset = Color(0xFFE3C17D);

  static const ink = Color(0xFF2B1E26);
  static const deep = Color(0xFF332511);
  static const paper = champagneBase;
  static const paper2 = Color(0xFFF3EDE2);
  static const surface = Color(0xFFFFFFFF);
  static const pearl = Color(0xFFFFFDFC);
  static const blush = Color(0xFFF4E7CB);
  static const ballerina = Color(0xFFE7D0A0);
  static const rose = Color(0xFFD2B170);

  /// BE:CAUSE decision signal.
  static const fuchsia = gold;
  static const champagne = Color(0xFFF0E5D1);
  static const roseGold = Color(0xFFD9BD86);
  static const berry = goldDeep;
  static const muted = Color(0xFF746B5E);
  static const line = Color(0x1A2B1E26);

  // Semantic compatibility aliases used by feature screens.
  static const mint = Color(0xFFF7F1E5);
  static const sage = Color(0xFF9B8561);
  static const oatmeal = Color(0xFFF1E8D8);
  static const lime = sunset;
  static const violet = fuchsia;
  static const cyan = Color(0xFFF6EEDC);
  static const coral = Color(0xFFF6E5CE);
  static const butter = Color(0xFFF5E5BD);
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class AppRadii {
  static const control = 14.0;
  static const card = 18.0;
  static const feature = 24.0;
  static const hero = 28.0;
}

ThemeData buildAppTheme() {
  const textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 52,
      height: 1.02,
      fontWeight: FontWeight.w700,
      letterSpacing: -2.2,
    ),
    displayMedium: TextStyle(
      fontSize: 40,
      height: 1.04,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.6,
    ),
    headlineLarge: TextStyle(
      fontSize: 30,
      height: 1.12,
      fontWeight: FontWeight.w700,
      letterSpacing: -1,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      height: 1.16,
      fontWeight: FontWeight.w700,
      letterSpacing: -.7,
    ),
    titleLarge: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      letterSpacing: -.35,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      letterSpacing: -.2,
    ),
    bodyLarge: TextStyle(fontSize: 17, height: 1.58),
    bodyMedium: TextStyle(fontSize: 15, height: 1.55),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: .1,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    splashFactory: InkRipple.splashFactory,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.fuchsia,
      primary: AppColors.fuchsia,
      secondary: AppColors.berry,
      tertiary: AppColors.champagne,
      surface: AppColors.paper,
    ),
    fontFamily: 'NotoSansKR',
    textTheme: textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    dividerColor: AppColors.line,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface.withValues(alpha: .96),
      foregroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 68,
      iconTheme: const IconThemeData(size: 21, color: AppColors.ink),
    ),
    iconTheme: const IconThemeData(size: 20, color: AppColors.ink),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: const BorderSide(color: AppColors.line),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        iconSize: const WidgetStatePropertyAll(20),
        foregroundColor: const WidgetStatePropertyAll(AppColors.ink),
        overlayColor: WidgetStatePropertyAll(
          AppColors.fuchsia.withValues(alpha: .08),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.fuchsia,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        foregroundColor: AppColors.fuchsia,
        side: const BorderSide(color: AppColors.roseGold),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      side: BorderSide(color: AppColors.line),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.berry,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      labelStyle: TextStyle(
        color: AppColors.ink,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      secondaryLabelStyle: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.control),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.control),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.control),
        borderSide: const BorderSide(color: AppColors.fuchsia, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
      },
    ),
  );
}
