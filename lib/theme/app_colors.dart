import 'package:flutter/widgets.dart';

/// The brand colors - the half of the palette that does NOT change with
/// brightness. Surfaces, text tones, hairlines and shadows all live in
/// [AppPalette] instead, because those are what a dark theme actually flips.
///
/// These are the game's original accents, ported 1:1 from the --neon-*
/// custom properties in style.css: deep, matte, slightly desaturated tones
/// where each hue owns one action. (The variable names in the CSS still say
/// "neon" for historical reasons - the values are flat.)
///
/// Every accent here is dark enough to carry WHITE text ([textLight]) on
/// both the light and the dark surfaces, which is why fills can stay
/// identical across themes.
class AppColors {
  AppColors._();

  // ---- Accents: one hue per action ---------------------------------------
  /// Play / success / score. (--neon-lime)
  static const Color green = Color(0xFF147A4A);
  /// Primary neutral actions, links, single player. (--neon-cyan-deep)
  static const Color blue = Color(0xFF3A65B8);
  /// A lighter companion to [blue], for accents on dark fills. (--neon-cyan)
  static const Color blueLight = Color(0xFF4E7FD6);
  /// Battle royale. (--neon-orange)
  static const Color orange = Color(0xFFA85A1E);
  /// Shop, coins, rewards. (--neon-gold)
  static const Color gold = Color(0xFFC99A2E);
  /// Random matchmaking, admin. (--neon-purple)
  static const Color purple = Color(0xFF5B4FCF);
  /// Accent in the title sweep and the ambient glow. (--neon-pink)
  static const Color pink = Color(0xFFC24E7A);
  /// Close / back / destructive, and the timer. (--neon-red)
  static const Color red = Color(0xFFB3372E);

  /// Text and icons on any accent fill.
  static const Color textLight = Color(0xFFFFFFFF);

  // ---- Mode-card fills ----------------------------------------------------
  // The home grid reuses the accents directly rather than a separate pastel
  // family, so a card and its matching button read as the same action.
  static const Color singlePlayerFill = green;
  static const Color battleFill = orange;
  static const Color multiplayerFill = purple;
  static const Color randomFill = blue;
}
