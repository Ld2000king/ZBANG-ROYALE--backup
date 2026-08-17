import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_shadows.dart';
import 'app_text_styles.dart';

/// The app's full Material theme, built entirely from the design tokens in
/// this folder (AppColors/AppRadii/AppTextStyles/AppShadows). Material 3
/// supplies the mechanics - ColorScheme, component theme slots - while every
/// value inside is the app's own light, high-contrast game identity rather
/// than a Material default.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      surface: AppColors.panelLight,
      surfaceContainerHighest: AppColors.surface2,
      primary: AppColors.green,
      secondary: AppColors.blue,
      tertiary: AppColors.gold,
      error: AppColors.red,
      onSurface: AppColors.textPrimary,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onError: AppColors.textLight,
      outline: AppColors.hairline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgDeep,
      canvasColor: AppColors.bgDeep,
      colorScheme: colorScheme,
      fontFamily: 'Poppins',
      splashFactory: InkRipple.splashFactory,

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.title,
        headlineMedium: AppTextStyles.heading,
        titleLarge: AppTextStyles.cardTitle,
        titleMedium: AppTextStyles.bodyEmphasis,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySecondary,
        labelLarge: AppTextStyles.button,
        labelSmall: AppTextStyles.badge,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDeep,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),

      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),

      cardTheme: CardThemeData(
        color: AppColors.panelLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: const BorderSide(color: AppColors.hairline),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.textLight,
          disabledBackgroundColor: AppColors.surface3,
          disabledForegroundColor: AppColors.textSecondary,
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
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.hairline),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surface2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface2,
        hintStyle: AppTextStyles.bodySecondary,
        labelStyle: AppTextStyles.bodySecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.hairline),
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
        backgroundColor: AppColors.panelLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading,
        contentTextStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.panelLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.card)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyEmphasis.copyWith(color: AppColors.textLight),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface2,
        labelStyle: AppTextStyles.bodyEmphasis,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: const StadiumBorder(side: BorderSide(color: AppColors.hairline)),
        side: BorderSide.none,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.panelLight,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.limeFill,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(AppTextStyles.bodySecondary),
        iconTheme: const WidgetStatePropertyAll(IconThemeData(color: AppColors.textPrimary)),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.green,
        linearTrackColor: AppColors.surface3,
      ),
    );
  }
}

/// Shared decoration for the app's white card surface, which needs both a
/// hairline (to separate white-on-near-white) and a soft lift - more than a
/// plain CardTheme can express.
BoxDecoration appCardDecoration({
  Color color = AppColors.panelLight,
  double radius = AppRadii.card,
  List<BoxShadow>? shadow,
  bool border = true,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: border ? Border.all(color: AppColors.hairline) : null,
    boxShadow: shadow ?? AppShadows.sm,
  );
}
