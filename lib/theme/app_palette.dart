import 'package:flutter/material.dart';

import 'app_text_styles.dart';

/// Everything in the design system whose value depends on the active
/// brightness: the neutral surface ladder, the two text tones, the hairline,
/// and the elevation shadows.
///
/// The brand colors do NOT live here - accents and the bright pastel card
/// fills are identity and stay identical in both themes (see AppColors), so
/// a mode card is the same lime whether the app is light or dark.
///
/// Read it with `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bgDeep,
    required this.bgDeep2,
    required this.panelLight,
    required this.surface2,
    required this.surface3,
    required this.textPrimary,
    required this.textSecondary,
    required this.hairline,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
  });

  /// Page background.
  final Color bgDeep;
  /// The area behind the app frame on wide screens.
  final Color bgDeep2;
  /// Cards and sheets.
  final Color panelLight;
  /// Inset controls and list rows.
  final Color surface2;
  /// Nested rows, dividers, disabled fills.
  final Color surface3;

  final Color textPrimary;
  final Color textSecondary;

  /// Separates same-on-same surfaces (white card on near-white page, dark
  /// card on darker page) without needing a heavy shadow.
  final Color hairline;

  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;

  /// [AppTextStyles] carries no colors so it can stay `const` across both
  /// themes; these apply the right tone for the active one.
  TextStyle get secondaryText => AppTextStyles.bodySecondary.copyWith(color: textSecondary);
  TextStyle get badgeText => AppTextStyles.badge.copyWith(color: textPrimary);

  /// Light: near-white surfaces, a tight contact shadow plus a wide soft
  /// ambient one (a single heavy blur reads as grey mud on white).
  static const AppPalette lightPalette = AppPalette(
    bgDeep: Color(0xFFF2F4F8),
    bgDeep2: Color(0xFFE8ECF3),
    panelLight: Color(0xFFFFFFFF),
    surface2: Color(0xFFF0F3F8),
    surface3: Color(0xFFE1E6EF),
    textPrimary: Color(0xFF141720),
    textSecondary: Color(0xFF737A8B),
    hairline: Color(0xFFE4E8F0),
    shadowSm: [
      BoxShadow(color: Color(0x0F141720), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(color: Color(0x0A141720), blurRadius: 12, offset: Offset(0, 4)),
    ],
    shadowMd: [
      BoxShadow(color: Color(0x14141720), blurRadius: 4, offset: Offset(0, 2)),
      BoxShadow(color: Color(0x0F141720), blurRadius: 20, offset: Offset(0, 8)),
    ],
    shadowLg: [
      BoxShadow(color: Color(0x1A141720), blurRadius: 8, offset: Offset(0, 4)),
      BoxShadow(color: Color(0x14141720), blurRadius: 32, offset: Offset(0, 14)),
    ],
  );

  /// Dark: the flat matte obsidian ladder this game started from, where each
  /// surface tier is slightly lighter than the one behind it. Shadows go
  /// deeper and softer, since on a dark ground elevation reads from the
  /// surface stepping up rather than from the shadow itself.
  static const AppPalette darkPalette = AppPalette(
    bgDeep: Color(0xFF121317),
    bgDeep2: Color(0xFF0C0D10),
    panelLight: Color(0xFF1C1E24),
    surface2: Color(0xFF262933),
    surface3: Color(0xFF2E313D),
    textPrimary: Color(0xFFF1F2F5),
    textSecondary: Color(0xFFA6ABB8),
    hairline: Color(0xFF2C2F3A),
    shadowSm: [
      BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4)),
    ],
    shadowMd: [
      BoxShadow(color: Color(0x40000000), blurRadius: 22, offset: Offset(0, 8)),
    ],
    shadowLg: [
      BoxShadow(color: Color(0x4D000000), blurRadius: 34, offset: Offset(0, 14)),
    ],
  );

  @override
  AppPalette copyWith({
    Color? bgDeep,
    Color? bgDeep2,
    Color? panelLight,
    Color? surface2,
    Color? surface3,
    Color? textPrimary,
    Color? textSecondary,
    Color? hairline,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowLg,
  }) {
    return AppPalette(
      bgDeep: bgDeep ?? this.bgDeep,
      bgDeep2: bgDeep2 ?? this.bgDeep2,
      panelLight: panelLight ?? this.panelLight,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      hairline: hairline ?? this.hairline,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
    );
  }

  @override
  AppPalette lerp(covariant AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      bgDeep: Color.lerp(bgDeep, other.bgDeep, t)!,
      bgDeep2: Color.lerp(bgDeep2, other.bgDeep2, t)!,
      panelLight: Color.lerp(panelLight, other.panelLight, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      shadowSm: BoxShadow.lerpList(shadowSm, other.shadowSm, t)!,
      shadowMd: BoxShadow.lerpList(shadowMd, other.shadowMd, t)!,
      shadowLg: BoxShadow.lerpList(shadowLg, other.shadowLg, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  /// The active theme's [AppPalette]. Registered by both AppTheme.light and
  /// AppTheme.dark, so this is never null inside the app.
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}

/// The soft, accent-tinted lift under a saturated button - the "chunky game
/// button" look. Brightness-independent, since it's derived from the
/// button's own brand color rather than from the surface behind it.
List<BoxShadow> accentShadow(Color color) => [
      BoxShadow(color: color.withValues(alpha: 0.32), blurRadius: 16, offset: const Offset(0, 6)),
    ];
