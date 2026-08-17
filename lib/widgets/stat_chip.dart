import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';
import 'pressable_scale.dart';

/// A currency pill - icon plus value on a white stadium - used for the
/// coin and diamond balances above the player card.
class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.iconName,
    required this.value,
    this.onTap,
  });

  final String iconName;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsetsDirectional.only(start: 14, end: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.panelLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.hairline),
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppTextStyles.bodyEmphasis),
          const SizedBox(width: 8),
          AppIcon(iconName, size: 22),
        ],
      ),
    );

    return onTap == null ? chip : PressableScale(onTap: onTap, child: chip);
  }
}
