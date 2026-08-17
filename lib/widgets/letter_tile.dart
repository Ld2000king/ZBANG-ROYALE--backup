import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_palette.dart';

/// One board tile: a chunky raised key that lights up in the play accent
/// while it's part of the current drag.
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
          color: selected ? AppColors.green : context.palette.panelLight,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? AppColors.green : context.palette.hairline,
            width: 1,
          ),
          boxShadow: selected ? context.palette.shadowMd : context.palette.shadowSm,
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: AppTextStyles.boardLetter.copyWith(
            // A selected tile is filled with the play accent in both
            // themes, so its letter is white - the same rule every accent
            // fill follows - rather than following the palette.
            color: selected ? AppColors.textLight : context.palette.textPrimary,
          ),
        ),
      ),
    );
  }
}
