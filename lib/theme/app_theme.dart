import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';
import 'app_radii.dart';
import 'app_text_styles.dart';

/// The app's Material themes, built entirely from the design tokens in this
/// folder. Material 3 supplies the mechanics - ColorScheme, component theme
/// slots - while every value inside is the app's own game identity rather
/// than a Material default.
///
/// [light] and [dark] are the same theme with a different [AppPalette]
/// swapped in: brand accents and pastel card fills are identical across
/// both, only surfaces, text tones, hairlines and shadows flip.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppPalette.lightPalette, Brightness.light);
  static ThemeData get dark => _build(AppPalette.darkPalette, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      surface: palette.panelLight,
      surfaceContainerHighest: palette.surface2,
      primary: AppColors.green,
      secondary: AppColors.blue,
      tertiary: AppColors.gold,
      error: AppColors.red,
      onSurface: palette.textPrimary,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onError: AppColors.textLight,
      outline: palette.hairline,
    );

    // Plain text picks its color up from here, which is why AppTextStyles
    // can stay color-free. bodyMedium in particular is what Material hands
    // to DefaultTextStyle, so it must be the PRIMARY tone - the muted tone
    // is applied deliberately via `context.palette.secondaryText`.
    final textTheme = TextTheme(
      displayLarge: AppTextStyles.title.copyWith(color: palette.textPrimary),
      headlineMedium: AppTextStyles.heading.copyWith(color: palette.textPrimary),
      titleLarge: AppTextStyles.cardTitle.copyWith(color: palette.textPrimary),
      titleMedium: AppTextStyles.bodyEmphasis.copyWith(color: palette.textPrimary),
      bodyLarge: AppTextStyles.body.copyWith(color: palette.textPrimary),
      bodyMedium: AppTextStyles.body.copyWith(color: palette.textPrimary),
      bodySmall: AppTextStyles.bodySecondary.copyWith(color: palette.textSecondary),
      labelLarge: AppTextStyles.button.copyWith(color: AppColors.textLight),
      labelSmall: AppTextStyles.badge.copyWith(color: palette.textSecondary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: palette.bgDeep,
      canvasColor: palette.bgDeep,
      colorScheme: colorScheme,
      fontFamily: 'Poppins',
      splashFactory: InkRipple.splashFactory,
      extensions: [palette],

      textTheme: textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: palette.bgDeep,
        foregroundColor: palette.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading.copyWith(color: palette.textPrimary),
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),

      iconTheme: IconThemeData(color: palette.textPrimary, size: 22),

      dividerTheme: DividerThemeData(
        color: palette.hairline,
        thickness: 1,
        space: 1,
      ),

      cardTheme: CardThemeData(
        color: palette.panelLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: palette.hairline),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.textLight,
          disabledBackgroundColor: palette.surface3,
          disabledForegroundColor: palette.textSecondary,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
          elevation: 0,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.blue,
          textStyle: AppTextStyles.bodyEmphasis,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: palette.hairline),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: palette.textPrimary,
          backgroundColor: palette.surface2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.textLight
              : palette.panelLight,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.green
              : palette.surface3,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface2,
        hintStyle: AppTextStyles.bodySecondary.copyWith(color: palette.textSecondary),
        labelStyle: AppTextStyles.bodySecondary.copyWith(color: palette.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide(color: palette.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide(color: palette.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: palette.panelLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading.copyWith(color: palette.textPrimary),
        contentTextStyle: AppTextStyles.body.copyWith(color: palette.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.panelLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.card)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.textPrimary,
        contentTextStyle: AppTextStyles.bodyEmphasis.copyWith(color: palette.bgDeep),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: palette.surface2,
        labelStyle: AppTextStyles.bodyEmphasis.copyWith(color: palette.textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: StadiumBorder(side: BorderSide(color: palette.hairline)),
        side: BorderSide.none,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.panelLight,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.green,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(
          AppTextStyles.bodySecondary.copyWith(color: palette.textSecondary),
        ),
        iconTheme: WidgetStatePropertyAll(IconThemeData(color: palette.textPrimary)),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.green,
        linearTrackColor: palette.surface3,
      ),
    );
  }
}

/// Shared decoration for the app's card surface, which needs both a hairline
/// (to separate same-on-same surfaces) and a soft lift - more than a plain
/// CardTheme can express.
BoxDecoration appCardDecoration(
  BuildContext context, {
  Color? color,
  double radius = AppRadii.card,
  List<BoxShadow>? shadow,
  bool border = true,
}) {
  final palette = context.palette;
  return BoxDecoration(
    color: color ?? palette.panelLight,
    borderRadius: BorderRadius.circular(radius),
    border: border ? Border.all(color: palette.hairline) : null,
    boxShadow: shadow ?? palette.shadowSm,
  );
}
