import 'package:flutter/widgets.dart';

/// The app's palette: a light, high-contrast "premium mobile game" scheme -
/// near-white surfaces, one saturated accent per action, and bright pastel
/// fills for the big tappable mode cards.
///
/// Two families, used for two different jobs:
///  * the saturated accents (green/blue/gold/...) are button and badge
///    fills and always carry WHITE text ([textLight]).
///  * the *Fill pastels are large card backgrounds and always carry DARK
///    text ([textPrimary]) - putting white on them is unreadable.
///
/// The token *names* are unchanged from the earlier dark palette so every
/// existing widget keeps compiling; only the values moved to light.
class AppColors {
  AppColors._();

  // ---- Surfaces: a light neutral ladder -----------------------------------
  /// Page background.
  static const Color bgDeep = Color(0xFFF2F4F8);
  /// The area behind the app frame on wide screens.
  static const Color bgDeep2 = Color(0xFFE8ECF3);
  /// Cards and sheets.
  static const Color panelLight = Color(0xFFFFFFFF);
  /// Inset controls and list rows.
  static const Color surface2 = Color(0xFFF0F3F8);
  /// Nested rows, dividers, disabled fills.
  static const Color surface3 = Color(0xFFE1E6EF);

  // ---- Text ---------------------------------------------------------------
  static const Color textPrimary = Color(0xFF141720);
  static const Color textSecondary = Color(0xFF737A8B);
  /// For text sitting on a saturated accent fill.
  static const Color textLight = Color(0xFFFFFFFF);

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

  // ---- Bright pastel card fills (dark text) -------------------------------
  static const Color limeFill = Color(0xFFCBF25E);
  static const Color violetFill = Color(0xFFCDBFFA);
  static const Color amberFill = Color(0xFFFBD24E);
  static const Color skyFill = Color(0xFFA8D6FF);
  /// "Coming soon" / disabled card.
  static const Color mutedFill = Color(0xFFE6EAF1);

  /// Hairline border for cards and chips - keeps white-on-white readable
  /// without needing a heavy shadow.
  static const Color hairline = Color(0xFFE4E8F0);
}
