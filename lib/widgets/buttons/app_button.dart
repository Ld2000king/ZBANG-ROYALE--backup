import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_text_styles.dart';
import '../pressable_scale.dart';

enum AppButtonColor { green, gold, blue, orange, purple, red }

const Map<AppButtonColor, Color> _colorMap = {
  AppButtonColor.green: AppColors.green,
  AppButtonColor.gold: AppColors.gold,
  AppButtonColor.blue: AppColors.blue,
  AppButtonColor.orange: AppColors.orange,
  AppButtonColor.purple: AppColors.purple,
  AppButtonColor.red: AppColors.red,
};

/// Mirrors the .btn-large color-class variants (green/gold/blue/orange/
/// purple/red), each owning one action across the app. Presses bounce on
/// the app's one spring curve (PressableScale), not just a flat state
/// change.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppButtonColor.green,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonColor color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final base = _colorMap[color]!;
    final active = enabled ? onPressed : null;

    return PressableScale(
      onTap: active,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: active,
          style: ElevatedButton.styleFrom(
            backgroundColor: base,
            disabledBackgroundColor: base.withValues(alpha: 0.35),
            foregroundColor: AppColors.textLight,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.btn),
            ),
            elevation: 0,
          ),
          child: Text(label, style: AppTextStyles.button),
        ),
      ),
    );
  }
}
