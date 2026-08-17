import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../app_icon.dart';
import '../pressable_scale.dart';

/// A round icon + label button for the Home screen's menu row (shop,
/// profile, ...) - the compact companion to AppButton's full-width CTA.
/// Same spring press as everything else.
class MenuIconButton extends StatelessWidget {
  const MenuIconButton({
    super.key,
    required this.iconName,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String iconName;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(child: AppIcon(iconName, size: 24, color: AppColors.textLight)),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}
