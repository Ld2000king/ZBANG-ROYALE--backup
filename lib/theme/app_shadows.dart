import 'package:flutter/widgets.dart';

/// Elevation for a light UI: a tight contact shadow plus a wider, very soft
/// ambient one. On light surfaces a single heavy blur reads as grey mud, so
/// each tier stacks two low-alpha layers instead.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0F141720), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A141720), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x14141720), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x0F141720), blurRadius: 20, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x1A141720), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x14141720), blurRadius: 32, offset: Offset(0, 14)),
  ];

  /// A colored lift under a saturated button, tinted by its own accent -
  /// the "chunky game button" look, still soft rather than a neon halo.
  static List<BoxShadow> accent(Color color) => [
        BoxShadow(color: color.withValues(alpha: 0.32), blurRadius: 16, offset: const Offset(0, 6)),
      ];
}
