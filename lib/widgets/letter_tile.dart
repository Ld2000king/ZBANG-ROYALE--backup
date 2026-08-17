import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';

class LetterTile extends StatelessWidget {
  const LetterTile({super.key, required this.letter, required this.selected});

  final String letter;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? AppColors.green : AppColors.surface2,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(
          color: selected ? AppColors.green : AppColors.surface3,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(letter, style: AppTextStyles.boardLetter),
    );
  }
}
