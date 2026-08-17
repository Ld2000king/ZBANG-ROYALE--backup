import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_shadows.dart';
import '../theme/app_text_styles.dart';

/// One board tile: a chunky raised key that lights up lime while it's part
/// of the current drag. Both states carry dark text - the selected fill is
/// a bright pastel, not a saturated accent, so white would be unreadable.
class LetterTile extends StatelessWidget {
  const LetterTile({super.key, required this.letter, required this.selected});

  final String letter;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.06 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.limeFill : AppColors.panelLight,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? AppColors.limeFill : AppColors.hairline,
            width: 1,
          ),
          boxShadow: selected ? AppShadows.md : AppShadows.sm,
        ),
        alignment: Alignment.center,
        child: Text(letter, style: AppTextStyles.boardLetter),
      ),
    );
  }
}
