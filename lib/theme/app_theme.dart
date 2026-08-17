import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_shadows.dart';
import 'app_text_styles.dart';

/// The app's full Material theme, built from the zbang design tokens
/// (AppColors/AppRadii/AppTextStyles/AppShadows - themselves ported 1:1
/// from the web app's style.css). Material 3 provides the mechanics
/// (ColorScheme, component theme slots); every value inside is this app's
/// own flat, matte, dark identity, not Material's defaults.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final colorScheme = const ColorScheme.dark(
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
      outline: AppColors.surface3,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDeep,
      canvasColor: AppColors.bgDeep,
      colorScheme: colorScheme,
      fontFamily: 'Poppins',
      splashFactory: InkRipple.splashFactory,

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.title,
        headlineMedium: AppTextStyles.heading,
        titleMedium: AppTextStyles.bodyEmphasis,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySecondary,
        labelLarge: AppTextStyles.button,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgDeep,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),

      dividerTheme: const DividerThemeData(
        color: AppColors.surface3,
        thickness: 1,
        space: 1,
      ),

      cardTheme: CardThemeData(
        color: AppColors.panelLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.textLight,
          disabledBackgroundColor: AppColors.green.withValues(alpha: 0.35),
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
          side: const BorderSide(color: AppColors.surface3),
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
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide.none,
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
        elevation: 0,
        titleTextStyle: AppTextStyles.heading,
        contentTextStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.panelLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.card)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface2,
        contentTextStyle: AppTextStyles.bodyEmphasis,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface2,
        labelStyle: AppTextStyles.bodyEmphasis,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        side: BorderSide.none,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.panelLight,
        indicatorColor: AppColors.green.withValues(alpha: 0.24),
        labelTextStyle: WidgetStateProperty.all(AppTextStyles.bodySecondary),
        iconTheme: const WidgetStatePropertyAll(IconThemeData(color: AppColors.textPrimary)),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.green,
        linearTrackColor: AppColors.surface2,
      ),
    );
  }
}

/// Convenience helpers for the elevated "card" look used throughout the app
/// (see AppShadows) that plain CardTheme can't express on its own.
extension AppCardDecoration on BuildContext {
  BoxDecoration cardDecoration({List<BoxShadow>? shadow, double radius = AppRadii.card}) {
    return BoxDecoration(
      color: AppColors.panelLight,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: shadow ?? AppShadows.sm,
    );
  }
}
