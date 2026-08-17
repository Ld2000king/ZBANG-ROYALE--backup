import 'package:flutter/widgets.dart';


/// Rubik for display/headings/board letters/score/timer, Poppins for body -
/// ported from --font-display / --font-body in style.css.
///
/// None of these carry a color. Color comes from the active [AppPalette]
/// (via the theme's TextTheme for plain text, or `context.palette` where a
/// widget needs the muted tone), which is what lets one const style serve
/// both the light and dark themes.
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
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 1.2,
    letterSpacing: -0.2,
  );

  /// Card titles in the mode grid - heavier than [heading] at a smaller size,
  /// so a two-line card still reads as a headline.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w800,
    fontSize: 17,
    height: 1.15,
  );

  /// Small all-caps-feeling label for badges and chips.
  static const TextStyle badge = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    height: 1.2,
  );

  static const TextStyle boardLetter = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w800,
    fontSize: 22,
  );

  static const TextStyle score = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );

  static const TextStyle timer = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 17,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _body,
    fontFamilyFallback: _bodyFallback,
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontFamily: _body,
    fontFamilyFallback: _bodyFallback,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const TextStyle bodyEmphasis = TextStyle(
    fontFamily: _body,
    fontFamilyFallback: _bodyFallback,
    fontWeight: FontWeight.w600,
    fontSize: 15,
  );
}
