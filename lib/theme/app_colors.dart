import 'package:flutter/widgets.dart';

/// The brand colors - the half of the palette that does NOT change with
/// brightness. Surfaces, text tones, hairlines and shadows all live in
/// [AppPalette] instead, because those are what a dark theme actually flips.
///
/// Two families, used for two different jobs:
///  * the saturated accents (green/blue/gold/...) are button and badge
///    fills and always carry WHITE text ([textLight]).
///  * the *Fill pastels are large card and tile backgrounds and always
///    carry DARK text ([onBrightFill]) - in either theme. Using the
///    palette's textPrimary on them would go invisible in dark mode.
class AppColors {
  AppColors._();

  // ---- Saturated accents (white text) -------------------------------------
  /// Play / success / score.
  static const Color green = Color(0xFF17A34A);
  /// Primary neutral actions, links.
  static const Color blue = Color(0xFF2563EB);
  /// Battle royale.
  static const Color orange = Color(0xFFEA580C);
  /// Shop, coins, rewards.
  static const Color gold = Color(0xFFF59E0B);
  /// Random matchmaking, admin.
  static const Color purple = Color(0xFF7C3AED);
  static const Color pink = Color(0xFFDB2777);
  /// Close / back / destructive.
  static const Color red = Color(0xFFDC2626);

  /// For text sitting on a saturated accent fill.
  static const Color textLight = Color(0xFFFFFFFF);

  // ---- Bright pastel fills (always dark text) -----------------------------
  static const Color limeFill = Color(0xFFCBF25E);
  static const Color violetFill = Color(0xFFCDBFFA);
  static const Color amberFill = Color(0xFFFBD24E);
  static const Color skyFill = Color(0xFFA8D6FF);

  /// Text and icons on any of the *Fill pastels. Fixed dark in both themes,
  /// because the fills themselves are fixed bright in both themes.
  static const Color onBrightFill = Color(0xFF141720);
}
