import 'package:flutter/widgets.dart';

/// Ported from --shadow-depth-sm/md/lg in style.css: soft, neutral black
/// diffusion for real physical elevation - never a colored glow. Material's
/// single-number `elevation` can't express this diffuse a shadow, so cards
/// that need real "lift" use these directly instead.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x2E000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x38000000), blurRadius: 26, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x47000000), blurRadius: 36, offset: Offset(0, 16)),
  ];
}
