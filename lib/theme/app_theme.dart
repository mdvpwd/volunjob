import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale lifted 1:1 from the Stitch "Purpose & Pathway" design
/// system (Plus Jakarta Sans, with the exact size / weight / line-height /
/// tracking pairs the design file specifies).
class AppTypography {
  AppTypography._();

  static TextStyle _style({
    required double size,
    required double height,
    required FontWeight weight,
    double letterSpacingEm = 0,
    Color? color,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      height: height / size,
      fontWeight: weight,
      letterSpacing: letterSpacingEm * size,
      color: color,
    );
  }

  static TextStyle headlineXl({Color? color}) => _style(
      size: 36, height: 44, weight: FontWeight.w800, letterSpacingEm: -0.03, color: color);
  static TextStyle headlineXlMobile({Color? color}) => _style(
      size: 28, height: 36, weight: FontWeight.w800, letterSpacingEm: -0.02, color: color);
  static TextStyle headlineLg({Color? color}) => _style(
      size: 30, height: 38, weight: FontWeight.w700, letterSpacingEm: -0.02, color: color);
  static TextStyle headlineLgMobile({Color? color}) => _style(
      size: 24, height: 32, weight: FontWeight.w700, letterSpacingEm: -0.02, color: color);
  static TextStyle headlineMd({Color? color}) => _style(
      size: 20, height: 28, weight: FontWeight.w700, letterSpacingEm: -0.01, color: color);
  static TextStyle headlineSm({Color? color}) =>
      _style(size: 18, height: 24, weight: FontWeight.w600, color: color);
  static TextStyle bodyLg({Color? color}) =>
      _style(size: 16, height: 24, weight: FontWeight.w400, color: color);
  static TextStyle bodyMd({Color? color}) =>
      _style(size: 14, height: 20, weight: FontWeight.w400, color: color);
  static TextStyle bodySm({Color? color}) =>
      _style(size: 12, height: 16, weight: FontWeight.w400, color: color);
  static TextStyle labelLg({Color? color}) => _style(
      size: 14, height: 20, weight: FontWeight.w600, letterSpacingEm: 0.01, color: color);
  static TextStyle labelMd({Color? color}) => _style(
      size: 12, height: 16, weight: FontWeight.w600, letterSpacingEm: 0.01, color: color);
  static TextStyle labelSm({Color? color}) => _style(
      size: 10, height: 12, weight: FontWeight.w700, letterSpacingEm: 0.04, color: color);
}

/// Semantic colors that every screen/widget pulls from `Theme.of(context)`
/// instead of hard-coding hex values, so the whole app can flip between
/// light and dark mode cleanly (see [AppState.themeMode]).
class VolunJobColors extends ThemeExtension<VolunJobColors> {
  final Color pageBackground;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color onPrimary;

  final Color success;
  final Color onSuccess;
  final Color successBg;
  final Color warning;
  final Color onWarning;
  final Color warningBg;
  final Color danger;
  final Color dangerBg;

  const VolunJobColors({
    required this.pageBackground,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.onPrimary,
    required this.success,
    required this.onSuccess,
    required this.successBg,
    required this.warning,
    required this.onWarning,
    required this.warningBg,
    required this.danger,
    required this.dangerBg,
  });

  static const light = VolunJobColors(
    pageBackground: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF1F5F9),
    border: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textMuted: Color(0xFF94A3B8),
    primary: Color(0xFF2563EB),
    primaryDark: Color(0xFF1D4ED8),
    primaryLight: Color(0xFF3B82F6),
    onPrimary: Color(0xFFFFFFFF),
    success: Color(0xFF10B981),
    onSuccess: Color(0xFF047857),
    successBg: Color(0xFFECFDF5),
    warning: Color(0xFFF59E0B),
    onWarning: Color(0xFFB45309),
    warningBg: Color(0xFFFFFBEB),
    danger: Color(0xFFE11D48),
    dangerBg: Color(0xFFFFF1F2),
  );

  static const dark = VolunJobColors(
    pageBackground: Color(0xFF0B1120),
    surface: Color(0xFF141C2E),
    surfaceAlt: Color(0xFF1E293B),
    border: Color(0xFF263248),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    primary: Color(0xFF3B82F6),
    primaryDark: Color(0xFF60A5FA),
    primaryLight: Color(0xFF60A5FA),
    onPrimary: Color(0xFFFFFFFF),
    success: Color(0xFF34D399),
    onSuccess: Color(0xFF6EE7B7),
    successBg: Color(0xFF0F2A22),
    warning: Color(0xFFFBBF24),
    onWarning: Color(0xFFFCD34D),
    warningBg: Color(0xFF2C2209),
    danger: Color(0xFFFB7185),
    dangerBg: Color(0xFF2C121A),
  );

  @override
  VolunJobColors copyWith({
    Color? pageBackground,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? onPrimary,
    Color? success,
    Color? onSuccess,
    Color? successBg,
    Color? warning,
    Color? onWarning,
    Color? warningBg,
    Color? danger,
    Color? dangerBg,
  }) {
    return VolunJobColors(
      pageBackground: pageBackground ?? this.pageBackground,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      onPrimary: onPrimary ?? this.onPrimary,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successBg: successBg ?? this.successBg,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningBg: warningBg ?? this.warningBg,
      danger: danger ?? this.danger,
      dangerBg: dangerBg ?? this.dangerBg,
    );
  }

  @override
  VolunJobColors lerp(ThemeExtension<VolunJobColors>? other, double t) {
    if (other is! VolunJobColors) return this;
    return VolunJobColors(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerBg: Color.lerp(dangerBg, other.dangerBg, t)!,
    );
  }
}

/// Convenience accessor so widgets can write `context.colors.primary`.
extension VolunJobColorsX on BuildContext {
  VolunJobColors get colors => Theme.of(this).extension<VolunJobColors>()!;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(VolunJobColors.light, Brightness.light);
  static ThemeData dark() => _build(VolunJobColors.dark, Brightness.dark);

  static ThemeData _build(VolunJobColors c, Brightness brightness) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.pageBackground,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.primary,
        brightness: brightness,
        primary: c.primary,
        surface: c.surface,
        error: c.danger,
      ),
      extensions: [c],
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: AppTypography.headlineXl(color: c.textPrimary),
        headlineMedium: AppTypography.headlineLg(color: c.textPrimary),
        headlineSmall: AppTypography.headlineMd(color: c.textPrimary),
        titleLarge: AppTypography.headlineSm(color: c.textPrimary),
        bodyLarge: AppTypography.bodyLg(color: c.textPrimary),
        bodyMedium: AppTypography.bodyMd(color: c.textSecondary),
        bodySmall: AppTypography.bodySm(color: c.textMuted),
        labelLarge: AppTypography.labelLg(color: c.textPrimary),
        labelMedium: AppTypography.labelMd(color: c.textSecondary),
        labelSmall: AppTypography.labelSm(color: c.textMuted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.pageBackground,
        foregroundColor: c.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      iconTheme: IconThemeData(color: c.textSecondary),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      splashFactory: InkRipple.splashFactory,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          disabledBackgroundColor: c.primary.withOpacity(0.4),
          textStyle: AppTypography.labelLg(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.textPrimary,
          side: BorderSide(color: c.border),
          textStyle: AppTypography.labelLg(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          textStyle: AppTypography.labelLg(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: AppTypography.bodyLg(color: c.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.primary, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: c.border),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? c.onPrimary : c.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? c.primary : c.border,
        ),
      ),
    );
  }
}
