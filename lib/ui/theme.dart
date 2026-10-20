import 'package:flutter/material.dart';

/// The approved "Picture Dictionary" palette.
///
/// [italianRed] is reserved: it marks Italian-language elements only — the
/// Italian headword, the speaker button, the active VERO/FALSO state and the
/// streak flame. Translations and interface chrome use the neutrals plus the
/// single ink accent. Topic accents (see Topic.accent) are used on icon
/// backgrounds and category tiles, never on body text.
class AppColors {
  const AppColors._();

  static const Color italianRed = Color(0xFFE83827);
  static const Color paper = Color(0xFFF7F5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1C1C1E);
  static const Color muted = Color(0xFF6E6E73);
  static const Color border = Color(0xFFE5E2DA);

  // Dark variants of the same roles.
  static const Color paperDark = Color(0xFF171614);
  static const Color surfaceDark = Color(0xFF232220);
  static const Color inkDark = Color(0xFFF4F2ED);
  static const Color mutedDark = Color(0xFFA6A3A0);
  static const Color borderDark = Color(0xFF343230);

  /// Answer feedback. Green is never used for Italian text.
  static const Color correct = Color(0xFF2E7D4F);
  static const Color wrong = Color(0xFFC0392B);

  /// The Italian tricolour, used as a thin strip above the bottom bar.
  static const List<Color> tricolour = <Color>[
    Color(0xFF2E7D4F),
    Color(0xFFFFFFFF),
    Color(0xFFE83827),
  ];
}

/// Four-level type scale, applied consistently on every screen.
class AppRadii {
  const AppRadii._();
  static const double card = 24;
  static const double tile = 20;
  static const double box = 18;
  static const double pill = 999;
}

class AppSpace {
  const AppSpace._();
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppTheme {
  const AppTheme._();

  /// Plus Jakarta Sans when it is bundled in assets/fonts, with a system
  /// fallback chain that covers Urdu, Gurmukhi, Bengali, Sinhala and Chinese
  /// through the fonts the phone already has.
  static const String fontFamily = 'PlusJakartaSans';

  static const List<String> fontFallback = <String>[
    'Noto Nastaliq Urdu',
    'Noto Sans Arabic',
    'Noto Sans Gurmukhi',
    'Noto Sans Bengali',
    'Noto Sans Sinhala',
    'Noto Sans Devanagari',
    'Noto Sans SC',
    'Noto Sans CJK SC',
    'Noto Color Emoji',
    'Roboto',
  ];

  static ThemeData light() => _build(
        brightness: Brightness.light,
        paper: AppColors.paper,
        surface: AppColors.surface,
        ink: AppColors.ink,
        muted: AppColors.muted,
        border: AppColors.border,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        paper: AppColors.paperDark,
        surface: AppColors.surfaceDark,
        ink: AppColors.inkDark,
        muted: AppColors.mutedDark,
        border: AppColors.borderDark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color paper,
    required Color surface,
    required Color ink,
    required Color muted,
    required Color border,
  }) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.italianRed,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.italianRed,
      onPrimary: Colors.white,
      surface: surface,
      onSurface: ink,
      outline: border,
    );

    final TextTheme text = TextTheme(
      // Level 1 — the Italian word itself.
      displaySmall: TextStyle(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: ink,
      ),
      // Level 1 (smaller variant) for screen headers.
      headlineMedium: TextStyle(
        fontSize: 26,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      // Level 2 — the translation.
      titleMedium: TextStyle(
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
      // Level 3 — explanation and example.
      bodyMedium: TextStyle(
        fontSize: 15,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      // Level 4 — metadata.
      bodySmall: TextStyle(
        fontSize: 13,
        height: 1.35,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: muted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: paper,
      canvasColor: paper,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      textTheme: text,
      dividerColor: border,
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (BuildContext context) =>
            const MirroredIcon(Icons.arrow_back_rounded),
        closeButtonIconBuilder: (BuildContext context) =>
            const Icon(Icons.close_rounded),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: paper,
        surfaceTintColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.l,
          vertical: AppSpace.l,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: const BorderSide(color: AppColors.italianRed, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: ink,
          foregroundColor: brightness == Brightness.light
              ? Colors.white
              : AppColors.paperDark,
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: ink,
          side: BorderSide(color: border),
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(48, 48),
          textStyle: text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: muted,
        textColor: ink,
        minVerticalPadding: AppSpace.m,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) =>
            states.contains(WidgetState.selected) ? Colors.white : surface),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) =>
            states.contains(WidgetState.selected)
                ? AppColors.italianRed
                : border),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: brightness == Brightness.light ? Colors.white : paper,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.box),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.card),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
    );
  }
}

/// An icon that really flips in right-to-left layouts.
///
/// Material icons do not mirror on their own, so Urdu and Shahmukhi would
/// otherwise keep a left-pointing back arrow and a right-pointing chevron.
class MirroredIcon extends StatelessWidget {
  const MirroredIcon(this.icon, {super.key, this.size, this.color});

  final IconData icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final Widget child = Icon(icon, size: size, color: color);
    if (!rtl) return child;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0),
      child: child,
    );
  }
}

/// Convenience readers so screens never hard-code a colour.
extension AppThemeX on BuildContext {
  ThemeData get t => Theme.of(this);
  TextTheme get texts => Theme.of(this).textTheme;
  Color get paper => Theme.of(this).scaffoldBackgroundColor;
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get ink => Theme.of(this).colorScheme.onSurface;
  Color get muted =>
      Theme.of(this).textTheme.bodySmall?.color ?? AppColors.muted;
  Color get border => Theme.of(this).colorScheme.outline;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
