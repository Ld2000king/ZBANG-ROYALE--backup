import 'package:flutter/widgets.dart';

/// Ported 1:1 from the :root custom properties in style.css - a flat, matte
/// dark palette (no gradients), each accent owning one action across the app.
class AppColors {
  AppColors._();

  static const Color bgDeep = Color(0xFF121317);
  static const Color bgDeep2 = Color(0xFF0C0D10);
  static const Color panelLight = Color(0xFF1C1E24);
  static const Color surface2 = Color(0xFF262933);
  static const Color surface3 = Color(0xFF2E313D);

  static const Color textPrimary = Color(0xFFF1F2F5);
  static const Color textSecondary = Color(0xFFA6ABB8);
  static const Color textLight = Color(0xFFFFFFFF);

  /// Play
  static const Color green = Color(0xFF147A4A);
  /// Links / secondary actions
  static const Color blue = Color(0xFF3A65B8);
  static const Color orange = Color(0xFFA85A1E);
  /// Shop
  static const Color gold = Color(0xFFC99A2E);
  static const Color purple = Color(0xFF5B4FCF);
  static const Color pink = Color(0xFFC24E7A);
  /// Close / back / destructive
  static const Color red = Color(0xFFB3372E);
}
