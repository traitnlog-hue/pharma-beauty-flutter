import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  // LEXEM 2026 · Clinical editorial neutrals with a precise violet signal.
  static const ink = Color(0xFF17171B);
  static const deep = Color(0xFF111115);
  static const paper = Color(0xFFF6F6F8);
  static const paper2 = Color(0xFFEDEDF1);
  static const surface = Color(0xFFFFFFFF);
  static const pearl = Color(0xFFFBFBFC);
  static const blush = Color(0xFFEFEDFF);
  static const ballerina = Color(0xFFD8D2FF);
  static const rose = Color(0xFF958BE0);

  /// LEXEM signature violet.
  static const fuchsia = Color(0xFF6656D9);
  static const champagne = Color(0xFFC9C9D1);
  static const roseGold = Color(0xFFB8B2DA);
  static const berry = Color(0xFF493A9A);
  static const muted = Color(0xFF686873);
  static const line = Color(0x1A17171B);

  // Semantic compatibility aliases used by feature screens.
  static const mint = Color(0xFFF0F1F4);
  static const sage = Color(0xFF9C9DA8);
  static const oatmeal = Color(0xFFE8E8EC);
  static const lime = Color(0xFFCFC8FF);
  static const violet = fuchsia;
  static const cyan = Color(0xFFE4E6F0);
  static const coral = Color(0xFFD9D4FF);
  static const butter = Color(0xFFF0F0F3);
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
        letterSpacing: -2.2),
    displayMedium: TextStyle(
        fontSize: 40,
        height: 1.04,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.6),
    headlineLarge: TextStyle(
        fontSize: 30,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -1),
    headlineMedium: TextStyle(
        fontSize: 24,
        height: 1.16,
        fontWeight: FontWeight.w700,
        letterSpacing: -.7),
    titleLarge: TextStyle(
        fontSize: 21, fontWeight: FontWeight.w700, letterSpacing: -.35),
    titleMedium: TextStyle(
        fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -.2),
    bodyLarge: TextStyle(fontSize: 17, height: 1.58),
    bodyMedium: TextStyle(fontSize: 15, height: 1.55),
    labelLarge:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0),
    labelMedium:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: .1),
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
    textTheme:
        textTheme.apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
    dividerColor: AppColors.line,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.paper.withValues(alpha: .96),
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
          color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600),
      secondaryLabelStyle: TextStyle(
          color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: const BorderSide(color: AppColors.line)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
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
