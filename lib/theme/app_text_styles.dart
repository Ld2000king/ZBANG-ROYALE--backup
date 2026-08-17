import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Rubik for display/headings/board letters/score/timer, Poppins for body -
/// ported from --font-display / --font-body in style.css.
///
/// Poppins has no Hebrew glyphs at all. On the web the original CSS gets
/// away with `font-family: 'Poppins', sans-serif` because browsers fall
/// back per-character to the system font automatically; Flutter's
/// CanvasKit renderer doesn't do that - it only falls back to Noto glyphs
/// it fetches from Google's CDN on demand, which isn't guaranteed to be
/// reachable. Since this app's body text is overwhelmingly Hebrew, every
/// Poppins style explicitly falls back to Rubik (already bundled locally,
/// and Hebrew-capable) instead of depending on that network fetch.
class AppTextStyles {
  AppTextStyles._();

  static const String _display = 'Rubik';
  static const String _body = 'Poppins';
  static const List<String> _bodyFallback = [_display];

  static const TextStyle title = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w800,
    fontSize: 34,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: AppColors.textPrimary,
  );

  static const TextStyle boardLetter = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w800,
    fontSize: 22,
    color: AppColors.textPrimary,
  );

  static const TextStyle score = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.textPrimary,
  );

  static const TextStyle timer = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 17,
    color: AppColors.textLight,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _body,
    fontFamilyFallback: _bodyFallback,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontFamily: _body,
    fontFamilyFallback: _bodyFallback,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyEmphasis = TextStyle(
    fontFamily: _body,
    fontFamilyFallback: _bodyFallback,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: AppColors.textPrimary,
  );
}
